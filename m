Return-Path: <linux-bcachefs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06997C433EF
	for <linux-bcachefs@archiver.kernel.org>; Sat,  6 Nov 2021 19:37:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CE29B6023B
	for <linux-bcachefs@archiver.kernel.org>; Sat,  6 Nov 2021 19:37:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234275AbhKFTkb (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Sat, 6 Nov 2021 15:40:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233622AbhKFTkb (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Sat, 6 Nov 2021 15:40:31 -0400
Received: from mail-qk1-x72a.google.com (mail-qk1-x72a.google.com [IPv6:2607:f8b0:4864:20::72a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDE87C061570
        for <linux-bcachefs@vger.kernel.org>; Sat,  6 Nov 2021 12:37:49 -0700 (PDT)
Received: by mail-qk1-x72a.google.com with SMTP id bl12so11865509qkb.13
        for <linux-bcachefs@vger.kernel.org>; Sat, 06 Nov 2021 12:37:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=/vKtCqULl5h77q0C1TrtBSgOSH77Mt3SnY1GhkOaxFs=;
        b=Pq9yW+x1EncrEMWPAOPR+kfBr5T55CkTxPKnKmZo2ycXTE9bCTDKuNrI12UDrrnJug
         awpUQLoDvDKx1lDaKnnlsx3Rqx4Q2F5iIZYMoSo8eBjYJz1FSFIu+dVJnSy/gERsaDEh
         WXAHrmIcZ2oUS5nMFoTqWD0PkuxRYDsxVYyQP0bA4kSAVFRUJDQ77O1fzlUjdCeS5N2C
         N508rPawCbKd9MPyOXCebVRo2MQ6OWbRmcSS6+4etLrUatVorYkz4KPwWnNkUQdPnXN9
         63/aGHir8Y384xev+UNKQJWjA9U/bh00g6hW3+DJtzYSiolUDvZSkj6XnS6zCF27plVo
         YCYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=/vKtCqULl5h77q0C1TrtBSgOSH77Mt3SnY1GhkOaxFs=;
        b=OK9J1oh2o9bR2oxGNNYdPIg7Na1GpM89NF7G3+qQj+8IdyHUgAraix1W4kf7uKW21K
         NK6A4WCmYhjUjL019aP8PDT8ZYD5klkfZAfDKIxMjSCHvlt4eDPum+rH1byxUHH+8aLB
         tDkdfQLgy5cFHFh3vyPt8Z79/42T2hLbjaNP7fsLFsUq91nV3itwSZRilmUkKWKWFVKB
         gon4aGKVhFLMmyhrdQVByvTa/Yj10L2RgrdhW8AVRHJy2OQvRoC66nFqbldE5TMFdWbb
         VwJdv8TVhJzX9P8u2/g+LhLFXss0JdR+ZXvkZ40J2TNM98UL/WJ2UZ52dq8Rh81gn0pS
         PlwA==
X-Gm-Message-State: AOAM531JVtB1giB9y0njLgjhZsBFMPm0554eLbZR32Vw8OveNjq082ur
        WTIUesjVvgu8D11KwU3YtL2H0NT19A==
X-Google-Smtp-Source: ABdhPJzc1P/CJR2dTF+6YNkX1Narefm3aHUJ1tFWiEZbGiHz0NVeTuuMcmYht+yeP6StsW61GFX0dw==
X-Received: by 2002:a37:b385:: with SMTP id c127mr53959824qkf.206.1636227468755;
        Sat, 06 Nov 2021 12:37:48 -0700 (PDT)
Received: from moria.home.lan (c-73-219-103-14.hsd1.vt.comcast.net. [73.219.103.14])
        by smtp.gmail.com with ESMTPSA id b2sm7710661qtg.88.2021.11.06.12.37.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 06 Nov 2021 12:37:47 -0700 (PDT)
Date:   Sat, 6 Nov 2021 15:37:46 -0400
From:   Kent Overstreet <kent.overstreet@gmail.com>
To:     Chris Webb <chris@arachsys.com>
Cc:     linux-bcachefs@vger.kernel.org
Subject: Re: More eager discard behaviour
Message-ID: <YYbZii7HNJ8lb8FF@moria.home.lan>
References: <20211106171156.GM11670@arachsys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211106171156.GM11670@arachsys.com>
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Sat, Nov 06, 2021 at 05:11:56PM +0000, Chris Webb wrote:
> SSDs are happier TRIMmed, but discard is also invaluable for filesystems on
> thin provisioning systems like dm-thin. (virtio-block can pass discards up
> from guest to host, so this is a common VM configuration.)
> 
> How practical would it be either to more-greedily wake the allocator thread
> and reclaim buckets, or to detect buckets available to discard earlier in
> their lifetime?

It's on the todo list, it'll be part of the grand allocator rework I have
planned - there's a lot that needs to be done.

We've got to rework the state transitions, and differentiate between buckets
with cached data, buckets that need a journal commit before we can write to them
again, buckets that need discarding, and buckets that are ready for use - and we
need to start storing all that persistently, as well as build some new data
structures to get rid of the scanning over every bucket we currently have to do
in various places.

Step one is going to be creating a persistent LRU. It'll be another btree,
sorted by the order in which we want to reuse buckets - a combination of the
amount of live data in the bucket and the time since it was last read.

If you're interested in tackling this, I can sketch it out for you :)

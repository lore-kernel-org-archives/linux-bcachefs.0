Return-Path: <linux-bcachefs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01742C433EF
	for <linux-bcachefs@archiver.kernel.org>; Tue, 12 Oct 2021 18:20:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DAD1660C4B
	for <linux-bcachefs@archiver.kernel.org>; Tue, 12 Oct 2021 18:20:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232502AbhJLSWC (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Tue, 12 Oct 2021 14:22:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232462AbhJLSWB (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Tue, 12 Oct 2021 14:22:01 -0400
Received: from mail-qt1-x833.google.com (mail-qt1-x833.google.com [IPv6:2607:f8b0:4864:20::833])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5D35C061570
        for <linux-bcachefs@vger.kernel.org>; Tue, 12 Oct 2021 11:19:59 -0700 (PDT)
Received: by mail-qt1-x833.google.com with SMTP id b12so226215qtq.3
        for <linux-bcachefs@vger.kernel.org>; Tue, 12 Oct 2021 11:19:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=dSW/KsHKP2BnSZ/aIggYsZnkmgF2rAGCjG0GkMIUN9g=;
        b=E5SeNHVIxvtc/2WB9xj0OJZxwW6XMj4ydnQfNCok4U/RvcdHfpm7AiAQmDX4WfY8Dj
         wP6yo//1adSRo6yBjAeXtv1B3h2qTwm7s4Vgit2br/vtIEikz6O/ZNZoPzdw9b5mmQeq
         VgVwBfoyTjMEVVzPwDwEqqUXwpHmmOaFTIgbIBamYA+4ptho+UCjkJr4IgFI/v8c7als
         /UehM8/QfSQhSfTFtjjhbSpRX7DPEkM8h+gxiL6HSbjy2+Ym906JYAZCeT6uyBKe/zrY
         zzf3Uev9VvHoMs4kvwJlz4eZYClomBe1C6b4sdr8T26M7H3DmY2Wx/goI+v34+CinpfG
         SsOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=dSW/KsHKP2BnSZ/aIggYsZnkmgF2rAGCjG0GkMIUN9g=;
        b=QiVvzKk6FjudRyWD8sKGq92w+gm2/KGCypakHYZGyE6o6zUWoxHICC5exE1GCo0zAD
         aSU3cbSthP+hsNiStIiNGSsPxTKmmR2YX76QcmYG0DgGJcSJXhuOkP8w2TQrDZBiLJbj
         HfNaB/VevovAMq62mvwa0g3xPUgmaxuiG+69gjU5hN//hfpE21ktn4YxDNEAo9sA3iRV
         EOlZX4M+bTIaidtYQBpo34elHMrcvQk4cahXNDFxGqbHhUY8JwyLmkCX+i6de1yRoKyI
         00aqCAJkCMoFB40pbHDX2YazD61VHqiUkTQYcm/aLTPeYKhyfk294Y4rJUM07dHXIA9S
         Iy/Q==
X-Gm-Message-State: AOAM533n4/xLdT6ehe9IfLsvOmS+cAUoyg+sf0t72Bb/2MexktIHf69v
        gu9nt2qc68wV9+pLfPP7MQ/iE6mDqQ==
X-Google-Smtp-Source: ABdhPJxFgGZp90AGO4rLz2wOLeidIHElLrRil00C/tHGrwP8SxDtw5APMKeZd8BpDdBVB/pH4oeajQ==
X-Received: by 2002:a05:622a:448:: with SMTP id o8mr15671892qtx.63.1634062798255;
        Tue, 12 Oct 2021 11:19:58 -0700 (PDT)
Received: from moria.home.lan (c-73-219-103-14.hsd1.vt.comcast.net. [73.219.103.14])
        by smtp.gmail.com with ESMTPSA id m11sm6910373qkp.0.2021.10.12.11.19.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Oct 2021 11:19:57 -0700 (PDT)
Date:   Tue, 12 Oct 2021 14:19:55 -0400
From:   Kent Overstreet <kent.overstreet@gmail.com>
To:     Chris Webb <chris@arachsys.com>
Cc:     linux-bcachefs@vger.kernel.org
Subject: Re: Metadata rereplication not triggering
Message-ID: <YWXRy46DZY7AV+Kf@moria.home.lan>
References: <20211012090745.GA11670@arachsys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211012090745.GA11670@arachsys.com>
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Tue, Oct 12, 2021 at 10:07:46AM +0100, Chris Webb wrote:
> [Spotted while double-checking c85e27c45512 fixed the rereplicate BUG_ON at
> fs/bcachefs/btree_iter.c:2475 the other day.]
> 
> If I create a filesystem with --replicas=2, fail a component drive and
> replace with a new one, then use bcachefs data rereplicate, metadata
> doesn't seem to get copied to the new drive.

It turns out rereplicate_pred() wasn't checking the key types correctly, and it
wasn't rereplicating any of the newer key types - I just pushed a fix. Thanks
for the report and the test!

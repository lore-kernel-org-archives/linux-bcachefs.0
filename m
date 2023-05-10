Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12A55C7EE24
	for <linux-bcachefs@archiver.kernel.org>; Wed, 10 May 2023 04:48:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235608AbjEJEsv (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Wed, 10 May 2023 00:48:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235511AbjEJEs3 (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Wed, 10 May 2023 00:48:29 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D73B644AB
        for <linux-bcachefs@vger.kernel.org>; Tue,  9 May 2023 21:48:27 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id 41be03b00d2f7-52caed90d17so3824959a12.0
        for <linux-bcachefs@vger.kernel.org>; Tue, 09 May 2023 21:48:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1683694107; x=1686286107;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=WbCygp9Px15SzD0gwBSvyFIkLYldAjH2gcy9VS5qfBA=;
        b=uu6lxeulBsClafDoba1z7contnPxyTG1azE0iMo1TkJbWonAvbaTxSSqU77lmI7wWT
         Jph156IIkUs8azw/OCVukwlBzQlXLpvAMhOFSlE0ehSRebZAH/C88rZo5hXHhVYKECH5
         UyaZOxOLOs5yhly6OZuiPs/Lqf7gX9fo7bQZKcSVhz0jqpnEr0ezGjoV5irN0vAVv9j4
         I3DhZnRI9d8SgOqq9lCkraqzopceA2mTjfd6Aa5Cdi4ZPuvFXVnaGonXhZUz3jsQhPJz
         YmJW5BiFrBwNokCxWTFeoujgAj9VJP7+HQxNHENIhxHOTFXnEazYPZwkIq75367w66Hz
         pOiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683694107; x=1686286107;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WbCygp9Px15SzD0gwBSvyFIkLYldAjH2gcy9VS5qfBA=;
        b=A22KWdu9YA7SRXBDhv80Ehw+zgMmfvj+yOZ4MPxzzU1fDXKnTSYBd/HERv8qILUb1N
         iw6KNuE/JRvVcpH5xicSICbDG3e2zDK1QlUATF0ibkNSwHhHRNYDFDFCYFL0jCnyg+4r
         9ydG6haK4YdIjR41MrB6vR4Fs/TqIF/qY+Gjg43oKAngewenwf4teDbJ0dz5D+T7pKh5
         H2HzIHOw4fiwrRRIsIqkVnwRvQxXJlDM15hjIMXN09Jp89AD3Nmo/ajARRSG6capQGyt
         nglRW1zKhvTr1yefALSX3gggJh5UK7sVIoXdBBvZ67nFa6DsrSv0HyIQ6bnA7Pqy3KfK
         9iWg==
X-Gm-Message-State: AC+VfDxVAhm7DgwYcJvzPxb23DcZt0viw3EW19YPrEDGhIbe9hHzUvhn
        GsyMEsn0J/YVk1GBlA2g8YoI+Q==
X-Google-Smtp-Source: ACHHUZ5FtHw6VRGWfuSyZnM7yVwB2RqJuk4iYxi7e2TddgcXvPXkQJmL2Y02fkXItbGLSqa0mfRjRg==
X-Received: by 2002:a17:902:dac5:b0:1a5:dfd:d167 with SMTP id q5-20020a170902dac500b001a50dfdd167mr20566017plx.8.1683694107319;
        Tue, 09 May 2023 21:48:27 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-88-204.pa.nsw.optusnet.com.au. [49.181.88.204])
        by smtp.gmail.com with ESMTPSA id d1-20020a170902aa8100b001aafb802efbsm2613503plr.12.2023.05.09.21.48.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 May 2023 21:48:26 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1pwbkW-00DUIx-1t; Wed, 10 May 2023 14:48:24 +1000
Date:   Wed, 10 May 2023 14:48:24 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Kent Overstreet <kent.overstreet@linux.dev>
Cc:     linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-bcachefs@vger.kernel.org, Dave Chinner <dchinner@redhat.com>
Subject: Re: [PATCH 21/32] hlist-bl: add hlist_bl_fake()
Message-ID: <20230510044824.GG2651828@dread.disaster.area>
References: <20230509165657.1735798-1-kent.overstreet@linux.dev>
 <20230509165657.1735798-22-kent.overstreet@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230509165657.1735798-22-kent.overstreet@linux.dev>
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Tue, May 09, 2023 at 12:56:46PM -0400, Kent Overstreet wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> in preparation for switching the VFS inode cache over the hlist_bl
  In

> lists, we nee dto be able to fake a list node that looks like it is
            need to

> hased for correct operation of filesystems that don't directly use
  hashed

> the VFS indoe cache.
          inode cache hash index.

-Dave.

-- 
Dave Chinner
david@fromorbit.com

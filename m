Return-Path: <linux-bcachefs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25B98C433F5
	for <linux-bcachefs@archiver.kernel.org>; Wed, 13 Oct 2021 17:29:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F32B16101D
	for <linux-bcachefs@archiver.kernel.org>; Wed, 13 Oct 2021 17:29:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230232AbhJMRba (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Wed, 13 Oct 2021 13:31:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229681AbhJMRba (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Wed, 13 Oct 2021 13:31:30 -0400
Received: from mail-qt1-x830.google.com (mail-qt1-x830.google.com [IPv6:2607:f8b0:4864:20::830])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6535C061570
        for <linux-bcachefs@vger.kernel.org>; Wed, 13 Oct 2021 10:29:26 -0700 (PDT)
Received: by mail-qt1-x830.google.com with SMTP id b12so3299401qtq.3
        for <linux-bcachefs@vger.kernel.org>; Wed, 13 Oct 2021 10:29:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=5cAcP5SxiZ+TAiNyWmlVGbVI5SDGw5xlinY5xVxtQKg=;
        b=WCaje0HWIYtsEGQ8ZRDvbOuyRj9epqQmXgGPM7e9YwUmsbPVk6E/1/C5e0ogenkRl4
         UwpuS8fhUXIsc3XbprnenW75xATUHFEa5eh4vfc1VQzUbi9Kh8ZnFN7cPY2N+TQZeADg
         W/dm5TtyZdb8luRN/A2HCCyr9dlIVGHqP8AudxTHlA32JBr1rUHVKzfKN+VptlqyLkb5
         3aqHpJN7El/GPW1lAEGdyLptNn7GgyrIoBln2YMsaFi1gndIlLNNK/p9qv5vHYG/Rxrw
         VGTjetdp+BWrn9RaSYVs2s2PpuGULf4wRnTd+AxOSSlXjek7ogvshE0wv63eKEDE96j7
         2CYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=5cAcP5SxiZ+TAiNyWmlVGbVI5SDGw5xlinY5xVxtQKg=;
        b=PB0psYEgs5pJ3V3gyfCuHtuDtyFT9w+9KiIYWDsGJtSGWMSvkgcWnARVnKgAIimH/U
         Lt7pvIzK7mO2I9/P20Du+L+vT1LESE7SWAAD3A9mBMto32tPG0NQ5Ux+t89SABMuOJJ1
         8nbEMDe0ANFoXx0Til7UQBm91RCuXuyk0g0i3UVhxW5s3U4rWkslk8LrEZ31kGiteysc
         cdntvR5H1MtpLRqEQC75Sto8JnWIqAUjIflhc222Fdj0CFJN4p6ZnrMnPhQbkSrAxZB4
         j3NUtnVleR+uKBf/GvUu6XZyRF6YAzTtFOWY2AyH/Zq4CKyBRfd1HRMfegPUZeZptE61
         rknA==
X-Gm-Message-State: AOAM533uIgLHDX3Q4PjrVcvRw2hUf7stKtFGzFrGD7ONeJ5XqQrSDJtA
        ZlL8RDCHq2Ff+mRmuox+zxYSAPZlwQ==
X-Google-Smtp-Source: ABdhPJz/oqVOiRUhMoKLMPrbpMfYL4CCVB7cQ13jPOG4o5MffHdh9E43/Yj3wQjqTNJW2uT2o6CtHg==
X-Received: by 2002:ac8:6893:: with SMTP id m19mr759758qtq.116.1634146166119;
        Wed, 13 Oct 2021 10:29:26 -0700 (PDT)
Received: from moria.home.lan (c-73-219-103-14.hsd1.vt.comcast.net. [73.219.103.14])
        by smtp.gmail.com with ESMTPSA id k2sm143051qtg.35.2021.10.13.10.29.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Oct 2021 10:29:25 -0700 (PDT)
Date:   Wed, 13 Oct 2021 13:29:23 -0400
From:   Kent Overstreet <kent.overstreet@gmail.com>
To:     Chris Webb <chris@arachsys.com>
Cc:     linux-bcachefs@vger.kernel.org
Subject: Re: Metadata rereplication not triggering
Message-ID: <YWcXczNENXOTxBuw@moria.home.lan>
References: <20211012090745.GA11670@arachsys.com>
 <YWXRy46DZY7AV+Kf@moria.home.lan>
 <20211013165240.GC11670@arachsys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211013165240.GC11670@arachsys.com>
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Wed, Oct 13, 2021 at 05:52:40PM +0100, Chris Webb wrote:
> Kent Overstreet <kent.overstreet@gmail.com> writes:
> 
> > On Tue, Oct 12, 2021 at 10:07:46AM +0100, Chris Webb wrote:
> > > 
> > > If I create a filesystem with --replicas=2, fail a component drive and
> > > replace with a new one, then use bcachefs data rereplicate, metadata
> > > doesn't seem to get copied to the new drive.
> > 
> > It turns out rereplicate_pred() wasn't checking the key types correctly, and it
> > wasn't rereplicating any of the newer key types - I just pushed a fix. Thanks
> > for the report and the test!
> 
> Hi Kent. Ah, that makes sense, thanks!
> 
> I pulled the latest HEADs of bcachefs-tools and bcachefs, including this
> patch, but when rerunning the ktest, it still fails.
> 
>   00016 bcachefs (dev-1): btree write error: device removed
>   00016 bcachefs (f5d59006-9408-4179-859c-16e94b1d9b7a): insufficient devices
>   online (0) for replicas entry btree: 1/2 [0 1]
>   00016 bcachefs: bch2_fs_open() bch_fs_open err opening /dev/sdd:
>   insufficient devices
>   00016 mount: /mnt: wrong fs type, bad option, bad superblock on /dev/sdd,
>   missing codepage or helper program, or other error.
>   00016 
>   00016 ========= FAILED replace_replica in 2s
> 
> I added a bcachefs fs usage to the ktest just before the first umount to
> provide a bit of additional debugging info: looks like sb and journal are
> still zero on the newly added device even following the data rereplicate
> operation.

That's a separate (known) bug - adding a new device doesn't account for
sb/journal on the new device correctly. I should revisit that one...

> Is there something extra I should be adding to the test to ensure the
> superblock also gets mirrored (e.g. a pause if it's kicked off
> asynchronously), or is there still something not quite right here? (Does the
> test now pass for you? I'm guessing this should be reasonably deterministic
> and host independent?)

It looks like I must have mixed up some test run output or something - you're
right, it's still failing for me, but it does work if prior to rereplicate we
either remove /dev/sdc or set it to failed - that is, a device being (possibly
momentarily) offline isn't enough for rereplicate to consider a given extent.

I'll update the test - this is also something we should document.

Return-Path: <linux-bcachefs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5DBB4C433F5
	for <linux-bcachefs@archiver.kernel.org>; Sat,  7 May 2022 18:09:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244484AbiEGSNK (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Sat, 7 May 2022 14:13:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244202AbiEGSNJ (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Sat, 7 May 2022 14:13:09 -0400
Received: from mail-qt1-x832.google.com (mail-qt1-x832.google.com [IPv6:2607:f8b0:4864:20::832])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F87D2BC4
        for <linux-bcachefs@vger.kernel.org>; Sat,  7 May 2022 11:09:22 -0700 (PDT)
Received: by mail-qt1-x832.google.com with SMTP id o11so8250706qtp.13
        for <linux-bcachefs@vger.kernel.org>; Sat, 07 May 2022 11:09:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=z+CcEvVf0FPvq70N+cDldRom8x4fdv3E9Uj9M8Vckw0=;
        b=kWhzryAEhEkDne7fPxMkwro1KMXV//6I8W6gX87X5VGwOiUhCZIB+QHMF4KGHtW2M4
         BaOvwh/9UiNIZ9fxtp17ZOTzUvSLbfEWaeO9ePbhThD7FU5YhqPtiTkNjDrRLw4ox4vP
         L+yNeRGFBP95zCH4ll7+NPD3iyb4WIz2Nlzs1UsSy1Dp3FNTjcPtj4er0KwaFeRw51fH
         qM5EINmeLIdKQBTGuImGz0qQCxi0I5z2DQ1jdxe6evkaRcUHoXhOelO1aLnCAWZ6uqLb
         8Tc5Ex9Tu0vcWgU66QCwdsKVGE43bnyOhZJW0VMzcsJTdIw/Edh9kRJsPD/A6WwkaDXW
         bu5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=z+CcEvVf0FPvq70N+cDldRom8x4fdv3E9Uj9M8Vckw0=;
        b=PZTVR1wlVHb3KH+pzokCre6CGfbm7vxcjLsIPpYnjBW//J/ZJmQQ1Q2mkVcFAdG3bt
         pJwIUjC91vCMYTcfz9qXsMJJ2J8hB6nK43q05mD0u6jBi14Q1AC4yGgYWW3pZjGkO480
         JjTHA5FwJOMsifMqmsH3od27+XYs6SmiO2EBLLOXdWjAf1KnRnG8OjLHWfyeCffyU7lN
         VangdwpgYy1gwCYpG7YewtivnKxdxjuRK87ytYFWS9g0ZcqiGCKvWMiJrUEI3/mqgLXZ
         L1NqaBuLe42l6TClxo0lXPva8DAJWCcQvaNz2RE01FXOhb11SUZTdczS7p3GxZGFQ8pW
         EPzg==
X-Gm-Message-State: AOAM5335hPzMIpwaQGEUr3f5fvwYfg1ih4RfMB4Fx3PfPDdMIhFruF1T
        WPdk9ecQ124Gzxo4fzjum4kOGG8LDA==
X-Google-Smtp-Source: ABdhPJzvnI9l+YHnzDpFLnZ9XgQ1AwtE3NfFN9WwdHPnKGvaOcNZw4BXLvWo50e5E4p2d2UA8JkKMg==
X-Received: by 2002:ac8:59cd:0:b0:2f3:c08d:9ffa with SMTP id f13-20020ac859cd000000b002f3c08d9ffamr8358563qtf.564.1651946961022;
        Sat, 07 May 2022 11:09:21 -0700 (PDT)
Received: from moria.home.lan (c-73-219-103-14.hsd1.vt.comcast.net. [73.219.103.14])
        by smtp.gmail.com with ESMTPSA id t3-20020ac85303000000b002f39b99f6a9sm4549763qtn.67.2022.05.07.11.09.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 May 2022 11:09:19 -0700 (PDT)
Date:   Sat, 7 May 2022 14:09:18 -0400
From:   Kent Overstreet <kent.overstreet@gmail.com>
To:     Wout Mertens <wout.mertens@gmail.com>
Cc:     linux-bcachefs@vger.kernel.org
Subject: Re: content-addressed storage?
Message-ID: <20220507180918.62kiggruug4e5cs7@moria.home.lan>
References: <CAO3V83+SSfYXLj18NvkVzJ68K3LxdPQnG0U-Zhnq+ZQLp5p0wA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAO3V83+SSfYXLj18NvkVzJ68K3LxdPQnG0U-Zhnq+ZQLp5p0wA@mail.gmail.com>
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Mon, Apr 25, 2022 at 07:37:51AM +0200, Wout Mertens wrote:
> Hi,
> 
> I'm idly wondering if bcachefs could support lookups and reuse of
> variable-size chunks based on their hash checksum, thus allowing
> deduplication.
> 
> So, instead of using a user-level storage layer like
> https://github.com/systemd/casync, it would be a layer deeper, inside
> bcachefs.
> 
> Would that be more optimal in memory/cpu/disk, or would it not make
> much difference besides comfort?
> 
> As a quick overview, casync splits files into chunks. The chunks are
> variable-sized based on their content using a rolling hash, which
> makes insertions and deletions change only the affected blocks and not
> the blocks following them. Then, the chunks are compressed and hashed,
> and stored under their hash.
> So files stored this way are lists of variable-size hashed chunks. If
> two files are similar, they will be sharing a lot of the chunks
> automatically.
> 
> A straightforward implementation would result in a single directory
> with millions/billions of small files. Is that something bcachefs can
> handle?
> 
> Inside bcachefs I'd instead imagine a btree with all the chunks as
> extents, keyed by their hash, and files somehow being able to
> arbitrarily point at those extents.

We'd need to try implementing it and see how well it works, but I've been
thinking along the same lines as what you're describing - it could work.

The thing people have run into with dedup in other filesystems is that doing it
inline has really high memory overhead - because accesses to your index-by-hash
btree are in completely random order, so you need to keep the whole thing in
memory.

But doing it at extent granularity instead of block granularity will help. The
next question is, what if accesses are misaligned? I've heard of some cool
rolling window algorithms that might be worth looking into. But maybe you or the
casync people have some thoughts on this? What affects extent/chunk alignment in
their system? In bcachefs extent alignment will depend on what the allocator is
doing, it's not something upper layers can generally rely on.

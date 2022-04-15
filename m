Return-Path: <linux-bcachefs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9B99C433F5
	for <linux-bcachefs@archiver.kernel.org>; Fri, 15 Apr 2022 19:11:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238272AbiDOTON (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Fri, 15 Apr 2022 15:14:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245720AbiDOTOM (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Fri, 15 Apr 2022 15:14:12 -0400
Received: from mail-qt1-x831.google.com (mail-qt1-x831.google.com [IPv6:2607:f8b0:4864:20::831])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A09F24F1C
        for <linux-bcachefs@vger.kernel.org>; Fri, 15 Apr 2022 12:11:43 -0700 (PDT)
Received: by mail-qt1-x831.google.com with SMTP id a11so6454433qtb.12
        for <linux-bcachefs@vger.kernel.org>; Fri, 15 Apr 2022 12:11:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=rmBclZxZakI5PkFfaqNpz8DEIANDTHDFIHU5vRHT3xI=;
        b=khMKQR1byHSAgsTD4cI+hkNC5dGhZbT59iKR8b8XKqxAcks475tA6FgzAuPqtZ+x1N
         TZrYruciOiIDi/hYSqdm+h8uV3miYhqb3g6FFlePiwey1ZMdIM8v299hLqKbTyA8vkG5
         BmV86B+al8XnkWbxUOAwS3uMp8ilgHdvXY6Y+do7e0yIgYE1I6WpmCpzeih2NamJQXQK
         ShJ2I/4eUauSk3tjEKDEwICAaEu6icmly6BfphfzVZt4scXd3JIIEi9mtH7D4ru9Lodq
         omTtocqBmNiUJ0wSWlpomuCYZcCx2c40dYjm8dgyDw3tOak1TkGd+SsTms5MKXKUZaC7
         bVMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=rmBclZxZakI5PkFfaqNpz8DEIANDTHDFIHU5vRHT3xI=;
        b=xp0BnhmL7FwCzUYDZsiCdwcWyPz8QQNNMS7AA6iFlAMmwK1VacqUQzx8X4WAsrlVmE
         p75An+2E3ToBQhPFqxhmnsnZ/vnlpffQ9+HCNy2l5qbxqAZbnJVkhzeofIK/weqhAZ5q
         AWCPUFczvAqySrOqAK7qGvC3XxUsQ1hkH/o4+xJ5mI1z+5K1zfvHnI/GhlgZXzmuLtFw
         TfgPPmpd+XXnwZiKLJTy6pARIDGyrejDOAQABFUVnt0K44p1UHpXL0AJWbvJCI5GE7dm
         BPK+c5MZ4OeFoL+BEFR27BlTrMYHzIjixBXBipsQIZa13WbBTWqq/CVr6JVXsAQJAyXC
         Gauw==
X-Gm-Message-State: AOAM531jniI2PEIn/rV9JLpPFmGNgH6cGYRgRemhf9Zv2YM2gPfS1bXu
        60bT72fgbb0vOoUhx2i0RXxF4fhfpg==
X-Google-Smtp-Source: ABdhPJy/TxTjN9NVPWi9+ioqMbs0Kn+kDFLbzMlN/3rOkEGXLCpsKi49OGUTSAqX2TJ/8YOPsKe2JA==
X-Received: by 2002:a05:622a:146:b0:2e1:b8d5:e88c with SMTP id v6-20020a05622a014600b002e1b8d5e88cmr461213qtw.472.1650049902643;
        Fri, 15 Apr 2022 12:11:42 -0700 (PDT)
Received: from moria.home.lan (c-73-219-103-14.hsd1.vt.comcast.net. [73.219.103.14])
        by smtp.gmail.com with ESMTPSA id l11-20020a05620a210b00b0069c0bc64bc5sm2836778qkl.128.2022.04.15.12.11.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Apr 2022 12:11:42 -0700 (PDT)
Date:   Fri, 15 Apr 2022 15:11:40 -0400
From:   Kent Overstreet <kent.overstreet@gmail.com>
To:     Demi Marie Obenour <demi@invisiblethingslab.com>
Cc:     linux-bcachefs@vger.kernel.org
Subject: Re: Comparison to ZFS and BTRFS
Message-ID: <20220415191140.2xyni3kusht6wear@moria.home.lan>
References: <Yk05Sk4ztxLMpgrt@itl-email>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yk05Sk4ztxLMpgrt@itl-email>
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Wed, Apr 06, 2022 at 02:55:04AM -0400, Demi Marie Obenour wrote:
> How does bcachefs manage to outperform ZFS and BTRFS?  Obviously being
> licensed under GPL-compatible terms is an advantage for inclusion in
> Linux, but I am more interested in the technical aspects.
> 
> - How does bcachefs avoid the nasty performance pitfalls that plague
>   BTRFS?  Are VM disks and databases on bcachefs fast?

Clean modular design (the result of years of slow incremental work), and a
_blazingly_ fast B+ tree implementation.

We're not fast in every situation yet. We don't have a nocow (non copy-on-write)
mode, and slow random reads can be slow due to checksum granularity being at the
extent level (which is a good tradeoff in most situations, but we need an option
for smaller checksum granularity at some point).

> - How does bcachefs avoid the dreaded RAID write hole? 

We're copy on write - and this extends to our erasure coding implementation, we
don't update existing stripes in place - we create new stripes as needed,
reusing buckets from existing stripes that still have data.

> - How does an O_DIRECT loop device on bcachefs compare to a zvol on ZFS?

I'd have to benchmark/profile it. It appears there's some bugs in the way the
loop driver in O_DIRECT mode interacts with bcachefs according to xfstests, and
the loopback driver is implemented in a more heavyweight way that it needs to be
- there's room for improvement.

> - Is there a good description of the bcachefs on-disk format anywhere?

Try this: https://bcachefs.org/Architecture/

> - What are the internal abstraction layers used in bcachefs?  Is it a
>   key-value store with a filesystem on top of it, the way ZFS is?

It's just a key value store with a filesystem on top, moreso than the way ZFS
is, from what I understand of ZFS.

> - Is it possible to shrink a bcachefs filesystem?

Not yet, but it won't take much work to add

> Does bcachefs have
>   any restrictions regarding the size of disks in a pool, or can I just
>   throw a bunch of varying-size disks at bcachefs and have it spread the
>   data around automatically to provide the level of redundancy I want?

No restrictions, the allocator stripes across available devices but biases in
favor of devices with more free space.

> - Can bcachefs use faster storage as a cache for slower storage, or
>   otherwise move data around based on usage patterns?

Yes.

> - Can bcachefs saturate your typical NVMe drive on realistic workloads?
>   Can it do so with encryption enabled?

This sounds like a question for someone interested in benchmarking :)

> - Is support for swap files on bcachefs planned?  That would require
>   being able to perform O_DIRECT asynchronous writes without any memory
>   allocations.

Yes it's planned, the IO path already has the necessary support

> - Is bcachefs being used in production anywhere?

Yes

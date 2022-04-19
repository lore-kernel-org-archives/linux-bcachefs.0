Return-Path: <linux-bcachefs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83D9CC433F5
	for <linux-bcachefs@archiver.kernel.org>; Tue, 19 Apr 2022 01:35:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244142AbiDSBiT (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Mon, 18 Apr 2022 21:38:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235649AbiDSBiS (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Mon, 18 Apr 2022 21:38:18 -0400
Received: from mail-qt1-x82e.google.com (mail-qt1-x82e.google.com [IPv6:2607:f8b0:4864:20::82e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6272A201BE
        for <linux-bcachefs@vger.kernel.org>; Mon, 18 Apr 2022 18:35:37 -0700 (PDT)
Received: by mail-qt1-x82e.google.com with SMTP id o18so11270210qtk.7
        for <linux-bcachefs@vger.kernel.org>; Mon, 18 Apr 2022 18:35:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=+/pxalyrj2SDjmqMptggq3Vmgs44trE1raMfokT5J3o=;
        b=PF6pg7ymSXptJwa80PtXpGay1zeZBB1iPWpIhQ3ziv77RlXoGO9NYcB7uzwX9SaxP5
         SQTFjzBn5Rpng1P7TfCjaTFHmA0IVPrG+hBTnR2FvSpiJwBVzPDoIY1y0ONg2WKO32lp
         mgsCYJyona2QVzsBBxYLNpJmIKhTdl5bTiAjgZOtQjXYE5mtxZ7NpXNMnYYZjPHJuuAo
         ESxKDOf3H9ELp/cqa2nwMwQQZYE3s+w466epSb3teGhwnzmmGMjHJUxPWIkEAx5kfYO9
         wYb51hPScpwKPhoheZshoPgpzIll5307usNWkvn5qDpu3VtqCjnTed9lplKdftK4Jsft
         Cb0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=+/pxalyrj2SDjmqMptggq3Vmgs44trE1raMfokT5J3o=;
        b=ElmHYJ26TKGFnUHz2Yl2iRSilRIsrxa5COTyUv7qqJ2+Qx0ttiE/brly4JHhb0+kXI
         xAq4xE9UfaJ6FgJE8CMKUfWWXtA0+kxtLTxEJAxtvgrGjIhyDTdLMEvKqEnUBTDzrpaZ
         ENDXmvwNAKViGTc58AQRGMBIpj3+pxsSQk5MWAFgTwu0kibhHcF0FGEkTGylyxCZrIC0
         +3H5WyXrFDBdUjujb+ATmbBw2l3W7pdVdh6gUJHbcR2B70594sP4rmTX/4s+08gkw/6k
         0zZtE770UyQU1JNYfHKSUUIIhA68Y1avLF0RXfACYsfL7+Uq2tfWefc7099s4sEJN7tA
         6+2w==
X-Gm-Message-State: AOAM5307lfIWD1vWfEMpRQZ0Q5s7hSOb1VLNS/efRUH/XqFJ+o9Pu9sx
        3+9UXEpBB0uqO/guXl5yvk7Jm6xILQ==
X-Google-Smtp-Source: ABdhPJxRcdwwUUStSz/NEQ8en6avBjENcVN8R5giu+i7d8PjuzviVS9eQq2JgtDs8zhS/nL9l/Pd3g==
X-Received: by 2002:a05:622a:3ce:b0:2f1:fd16:751b with SMTP id k14-20020a05622a03ce00b002f1fd16751bmr5326390qtx.197.1650332136466;
        Mon, 18 Apr 2022 18:35:36 -0700 (PDT)
Received: from moria.home.lan (c-73-219-103-14.hsd1.vt.comcast.net. [73.219.103.14])
        by smtp.gmail.com with ESMTPSA id q139-20020a37a791000000b0069e88513517sm3663123qke.91.2022.04.18.18.35.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Apr 2022 18:35:35 -0700 (PDT)
Date:   Mon, 18 Apr 2022 21:35:34 -0400
From:   Kent Overstreet <kent.overstreet@gmail.com>
To:     Demi Marie Obenour <demi@invisiblethingslab.com>
Cc:     linux-bcachefs@vger.kernel.org
Subject: Re: Comparison to ZFS and BTRFS
Message-ID: <20220419013534.fb5m6kd6f6ithcig@moria.home.lan>
References: <Yk05Sk4ztxLMpgrt@itl-email>
 <20220415191140.2xyni3kusht6wear@moria.home.lan>
 <Yl1wqhHUGRnPdKjx@itl-email>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Yl1wqhHUGRnPdKjx@itl-email>
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Mon, Apr 18, 2022 at 10:07:38AM -0400, Demi Marie Obenour wrote:
> On Fri, Apr 15, 2022 at 03:11:40PM -0400, Kent Overstreet wrote:
> > On Wed, Apr 06, 2022 at 02:55:04AM -0400, Demi Marie Obenour wrote:
> > > How does bcachefs manage to outperform ZFS and BTRFS?  Obviously being
> > > licensed under GPL-compatible terms is an advantage for inclusion in
> > > Linux, but I am more interested in the technical aspects.
> > > 
> > > - How does bcachefs avoid the nasty performance pitfalls that plague
> > >   BTRFS?  Are VM disks and databases on bcachefs fast?
> > 
> > Clean modular design (the result of years of slow incremental work), and a
> > _blazingly_ fast B+ tree implementation.
> > 
> > We're not fast in every situation yet. We don't have a nocow (non copy-on-write)
> > mode, and slow random reads can be slow due to checksum granularity being at the
> > extent level (which is a good tradeoff in most situations, but we need an option
> > for smaller checksum granularity at some point).
> 
> How well does bcachefs handle writes to files that have extents shared
> (via reflinks or snapshots) with other files?  I would like to use
> bcachefs in Qubes OS once it reaches mainline, and in Qubes OS, each VM
> disk image is typically a snapshot of the previous revision.  Therefore,
> each write breaks sharing.  I am curious how well bcachefs handles this
> situation; I know that at least dm-thin is not optimized for it.  Also,
> for a file of size N, are reflinks O(N), or are they O(log N) or better?

O(N), but they're also cheap to overwrite.

> How much of a performance hit can one expect from erasure coding,
> compared to mirroring?

Should be very little, but it's not yet stable enough for real world performance
testing.

> Is there something lower-level available?  For instance, where should
> one look if they want to add (read-only) bcachefs support to GRUB?

The sanest thing to do would be to port bcachefs to grub - you can't read
anything without reading the journal and overlaying that over the btree, if
you're not doing journal replay, so that's a lot of code that you really don't
want to rewrite - and just reading from btree nodes is non trivial. Bcachefs has
been ported to userspace already, so it'd be a big undertaking but not crazy.

> Also, is it possible to mount a bcachefs filesystem off of a truly
> immutable volume?

Yes.

> > > - Can bcachefs use faster storage as a cache for slower storage, or
> > >   otherwise move data around based on usage patterns?
> > 
> > Yes.
> 
> I am not surprised, considering that bcachefs is based on bcache.  Is
> there any manual configuration required, or can bcachefs detect fast and
> slow storage automatically?  Also, does the data remain on the slow
> storage, or can bcachefs move frequently-used data entirely off of slow
> storage to make room for infrequently used data?

You should be reading the manual for these kinds of questions:
https://bcachefs.org/bcachefs-principles-of-operation.pdf

Long story short, you tell the IO path where to put things and it can be
configured filesystem wide, or per file/directory.

> 
> > > - Can bcachefs saturate your typical NVMe drive on realistic workloads?
> > >   Can it do so with encryption enabled?
> > 
> > This sounds like a question for someone interested in benchmarking :)
> 
> I would love to benchmark, but right now I don’t have any machines on
> which I am willing to install a bespoke kernel build.  I might be able
> to try bcachefs in a VM, though.  I’m also no expert in storage
> benchmarking.
> 
> > > - Is support for swap files on bcachefs planned?  That would require
> > >   being able to perform O_DIRECT asynchronous writes without any memory
> > >   allocations.
> > 
> > Yes it's planned, the IO path already has the necessary support
> 
> That is awesome!  Will it require disabling CoW or checksums, or will it
> work even with CoW and checksums enabled and without risking deadlocks?

Normal IO path, so CoW and checksums and encryption and all.

> 
> > > - Is bcachefs being used in production anywhere?
> > 
> > Yes
> 
> Are there any places that are willing to talk about their use of
> bcachefs?  Is bcachefs basically the WireGuard of filesystems?
> 
> A few other questions:
> 
> 1. What would it take for bcachefs to be buildable as a loadable kernel
>    module?  That would be much more convienient than building a kernel,
>    and might allow bcachefs to be packaged in distributions.

Not gonna happen. When I'm ready for more users I'll focus on upstreaming it,
right now I've still got bugs to fix :)

> 
> 2. Would it be possible to digitally sign releases?  The means to sign
>    them is not particularly relevant, so long as it is secure.  OpenPGP,
>    signify, minisign, and ssh-keygen -Y are all fine.
> 
> 3. Are there plans to add longer, random nonces to the encryption
>    implementation?  One long-term goal of Qubes OS is untrusted storage
>    domains, and that requires that encrypted bcachefs be safe against a
>    malicious block device.  A simple way to implement this is to use a
>    192-bit random nonce stored along each 128-bit authentication tag,
>    and use XChaCha20-Poly1305 as the cipher.  A 192-bit nonce is long
>    enough that one can safely pick a random number at each boot, and
>    then increment it for each encryption.  This also requires that any
>    data read from disk that has not been authenticated be treated as
>    untrusted.

Nonces are stored with pointers, not with the data they protect, so this isn't
necessary for what you're talking about - nonces are themselves encrypted and
authenticated, with a chain of trust up to the superblock, or journal after an
unclean shutdown.

However, the superblock isn't currently authenticated - that would be nice to
fix.

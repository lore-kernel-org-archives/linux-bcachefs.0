Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1FA63EE4993
	for <linux-bcachefs@archiver.kernel.org>; Tue, 22 Aug 2023 19:34:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229511AbjHVTeE (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Tue, 22 Aug 2023 15:34:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229672AbjHVTeE (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Tue, 22 Aug 2023 15:34:04 -0400
Received: from out-2.mta1.migadu.com (out-2.mta1.migadu.com [IPv6:2001:41d0:203:375::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39011128
        for <linux-bcachefs@vger.kernel.org>; Tue, 22 Aug 2023 12:34:01 -0700 (PDT)
Date:   Tue, 22 Aug 2023 15:33:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1692732839;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=KOqlEp3nff6ygwWeOXODjg4Fh4SpdM/55bQ2S0HTCJw=;
        b=HP3GniZ5+NjJpMWN7oNaqmh8JUNFyYjfzQQAPawvTW8bKxLNneVH30R3JDkXXPEFe8KGfl
        d0vAZy1NrLs+5xmv3A3+N2nezvuG9sakUOeh+NDcKti2uhjegFsoFh8JGAyc3jfjsl5CAO
        GIFwHnB2Cr9j4l9HkeGHC6cDPkGD/24=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Kent Overstreet <kent.overstreet@linux.dev>
To:     Linus Heckemann <linus@schreibt.jetzt>
Cc:     linux-bcachefs@vger.kernel.org, dhowells@redhat.com
Subject: Re: Mounting subvolumes or subtrees
Message-ID: <20230822193355.d73i4pd5figg6hnm@moria.home.lan>
References: <yga1qfx34xh.fsf@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <yga1qfx34xh.fsf@localhost>
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Sun, Aug 20, 2023 at 07:11:06PM +0000, Linus Heckemann wrote:
> Hi all!
> 
> I'd like to use bcachefs as my root filesystem -- but I don't want / to
> be the root of the filesystem.
> 
> This is achievable with btrfs using subvolume mounts (passing -o
> subvol=... or -o subvolid=... to the mount program), but having looked
> at the way it's handled on the kernel side (duplication of code from
> fs/super.c in fs/btrfs/super.c) I'm pretty sure that's not something
> that should be repeated in bcachefs.
> 
> It can also be done by having an initramfs that mounts the root of the
> filesystem, then bind-mounts a subpath of that and
> switch_root/pivot_root-ing into the bind mount. However, this approach isn't
> representable in a classic fstab -- the root of the filesystem needs to
> be mounted somewhere, but given that I want the subtree to be /, we have
> nowhere to mount it.
> 
> One idea I have -- and I haven't read enough code yet to tell whether
> the APIs already support this -- is that the new mount API
> (fsopen/move_mount flow) could be used as-is or extended to support
> mounting a subtree of a filesystem without needing an intermediate mount
> of its root. This would allow _all_ filesystems to benefit from this
> ability, not just bcachefs -- and to represent this as a "fake mount
> option", much like X-mount.mkdir, in util-linux, making it possible to
> put this type of mount in an fstab.
> 
> I'd appreciate any opinions on whether my thoughts make sense, and how
> else my goal might be achievable.

David Howells might have some thoughts?

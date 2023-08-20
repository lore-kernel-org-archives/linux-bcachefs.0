Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56E70EE49A4
	for <linux-bcachefs@archiver.kernel.org>; Sun, 20 Aug 2023 19:23:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231710AbjHTTX0 (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Sun, 20 Aug 2023 15:23:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231685AbjHTTXX (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Sun, 20 Aug 2023 15:23:23 -0400
X-Greylist: delayed 554 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 20 Aug 2023 12:20:26 PDT
Received: from sosiego.soundray.org (sosiego.soundray.org [IPv6:2a01:4f8:c2c:a9a0::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A68EE449E
        for <linux-bcachefs@vger.kernel.org>; Sun, 20 Aug 2023 12:20:26 -0700 (PDT)
From:   Linus Heckemann <linus@schreibt.jetzt>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=schreibt.jetzt;
        s=sosiego; t=1692558668;
        bh=34yIU1HNUx2ll0hTrcy4QYFWjATb9zvoOyGKHBTz0dM=;
        h=From:To:Subject:Date;
        b=oB7njWpt2b8B+jMXT9C2yH7zI5haSk4hL6jga6nXLYYBm6IkXD7c1d/AFQ7n6qmCn
         LhpMDk5OslU9W9qhoVMSb3tpAuit9UyLIM0Fin3Dt9GlcI39EJfcdD9tz4hpdNBmdJ
         mwEvNgznQmD5vUAfVXl0bH5OhIyMuHyuIDt43Dkc=
To:     linux-bcachefs@vger.kernel.org
Subject: Mounting subvolumes or subtrees
Date:   Sun, 20 Aug 2023 19:11:06 +0000
Message-ID: <yga1qfx34xh.fsf@localhost>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

Hi all!

I'd like to use bcachefs as my root filesystem -- but I don't want / to
be the root of the filesystem.

This is achievable with btrfs using subvolume mounts (passing -o
subvol=... or -o subvolid=... to the mount program), but having looked
at the way it's handled on the kernel side (duplication of code from
fs/super.c in fs/btrfs/super.c) I'm pretty sure that's not something
that should be repeated in bcachefs.

It can also be done by having an initramfs that mounts the root of the
filesystem, then bind-mounts a subpath of that and
switch_root/pivot_root-ing into the bind mount. However, this approach isn't
representable in a classic fstab -- the root of the filesystem needs to
be mounted somewhere, but given that I want the subtree to be /, we have
nowhere to mount it.

One idea I have -- and I haven't read enough code yet to tell whether
the APIs already support this -- is that the new mount API
(fsopen/move_mount flow) could be used as-is or extended to support
mounting a subtree of a filesystem without needing an intermediate mount
of its root. This would allow _all_ filesystems to benefit from this
ability, not just bcachefs -- and to represent this as a "fake mount
option", much like X-mount.mkdir, in util-linux, making it possible to
put this type of mount in an fstab.

I'd appreciate any opinions on whether my thoughts make sense, and how
else my goal might be achievable.

Cheers
Linus

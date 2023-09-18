Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E2EDC46CA1
	for <linux-bcachefs@archiver.kernel.org>; Mon, 18 Sep 2023 15:42:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229556AbjIRPmJ (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Mon, 18 Sep 2023 11:42:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229669AbjIRPmH (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Mon, 18 Sep 2023 11:42:07 -0400
Received: from sosiego.soundray.org (sosiego.soundray.org [IPv6:2a01:4f8:c2c:a9a0::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A763E7C
        for <linux-bcachefs@vger.kernel.org>; Mon, 18 Sep 2023 08:40:01 -0700 (PDT)
From:   Linus Heckemann <linus@schreibt.jetzt>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=schreibt.jetzt;
        s=sosiego; t=1695042517;
        bh=doeM+bbjP0rgzoPIxl/qhATB3sQlLsFsOLN7GUCw+nA=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date;
        b=dwEIKp+p/Ntgz/R8soqQKvNwFkgf/xRLvZQ4B/H0r1qPQvUS3AX67dABNlBLAHhDd
         8LRLl0lH+9VauPHTinV2YxLkE54b61Wkw4nd2oCJwdoo1yERyYXV2OQl7Gx+DAmh17
         qK04XqDmGNBn6OpS8TIPGorBrIHkjL3MUgc43I+Y=
To:     Kent Overstreet <kent.overstreet@linux.dev>
Cc:     linux-bcachefs@vger.kernel.org, dhowells@redhat.com
Subject: Re: Mounting subvolumes or subtrees
In-Reply-To: <20230822193355.d73i4pd5figg6hnm@moria.home.lan>
References: <yga1qfx34xh.fsf@localhost>
 <20230822193355.d73i4pd5figg6hnm@moria.home.lan>
Date:   Mon, 18 Sep 2023 13:08:35 +0000
Message-ID: <yga1qeviq7g.fsf@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

Kent Overstreet <kent.overstreet@linux.dev> writes:

> On Sun, Aug 20, 2023 at 07:11:06PM +0000, Linus Heckemann wrote:
>> Hi all!
>>=20
>> I'd like to use bcachefs as my root filesystem -- but I don't want / to
>> be the root of the filesystem.
>>=20
>> This is achievable with btrfs using subvolume mounts (passing -o
>> subvol=3D... or -o subvolid=3D... to the mount program), but having look=
ed
>> at the way it's handled on the kernel side (duplication of code from
>> fs/super.c in fs/btrfs/super.c) I'm pretty sure that's not something
>> that should be repeated in bcachefs.
>>=20
>> It can also be done by having an initramfs that mounts the root of the
>> filesystem, then bind-mounts a subpath of that and
>> switch_root/pivot_root-ing into the bind mount. However, this approach i=
sn't
>> representable in a classic fstab -- the root of the filesystem needs to
>> be mounted somewhere, but given that I want the subtree to be /, we have
>> nowhere to mount it.
>>=20
>> One idea I have -- and I haven't read enough code yet to tell whether
>> the APIs already support this -- is that the new mount API
>> (fsopen/move_mount flow) could be used as-is or extended to support
>> mounting a subtree of a filesystem without needing an intermediate mount
>> of its root. This would allow _all_ filesystems to benefit from this
>> ability, not just bcachefs -- and to represent this as a "fake mount
>> option", much like X-mount.mkdir, in util-linux, making it possible to
>> put this type of mount in an fstab.
>>=20
>> I'd appreciate any opinions on whether my thoughts make sense, and how
>> else my goal might be achievable.
>
> David Howells might have some thoughts?

I had a chat with Christian Brauner at All Systems Go, and he pointed me
to https://uapi-group.org/kernel-features/ -- so this is indeed not
currently possible, but there is some agreement that it would make sense.

The relevant point on that page at the time of writing:
> Ability to mount sub-directories of regular file systems instead of
> the top-level directory. i.e. for a file system /dev/sda1 which
> contains a sub-directory /foobar mount /foobar without having to mount
> its parent directory first. Consider something like this:
>
> mount -t ext4 /dev/sda1 somedir/ -o subdir=3D/foobar
>
> Use-Case: systemd-homed currently mounts a sub-directory of the
> per-user LUKS volume as the user=E2=80=99s home directory (and not the ro=
ot
> directory of the per-user LUKS volume=E2=80=99s file system!), and in ord=
er to
> implement this invisibly from the host side requires a complex mount
> namespace exercise.

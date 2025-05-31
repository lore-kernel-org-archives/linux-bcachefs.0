Received: from mail.lichtvoll.de (lichtvoll.de [37.120.160.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 039329460
	for <linux-bcachefs@vger.kernel.org>; Sat, 31 May 2025 09:07:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=37.120.160.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748682473; cv=none; b=GxDfAfnqWqK6/yA2UJVLcvtbJfLcMjDDruneeJPAlr0gAwj5r+f4Qfm8ZDMStSWnRrBb5T3qgCYqD6za9LMavMq8jXRQ4gQ41ho6jXNlksqVp2gmAd5AOgpg1zSDfDbljDu39eqZRm8XWGZiWY/zEGcYyYpbUohPcEx/qgd+RMk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748682473; c=relaxed/simple;
	bh=kG+fmcefEEwgk8bC9sJ7c8Ssaj+dE1CCDN7f8CFyoew=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Po/glL7FZMt9/tUJiHNc+QDme42mFG2EkD+hmZDkF8nM5BCGkCk/29KnnbRHkar4n39gX7Res6/VcZo+wG4CT5+NkBNUyGQdKWs82FVVYK0CS6pPsn4UXmk7TzhvlO9m+xNdNa6L+hDXqhZ+JJ3jhTBNbceYcyvCQkZ0BQTe2Is=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lichtvoll.de; spf=pass smtp.mailfrom=lichtvoll.de; arc=none smtp.client-ip=37.120.160.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lichtvoll.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lichtvoll.de
Received: from 127.0.0.1 (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (secp384r1) server-digest SHA384)
	(No client certificate requested)
	by mail.lichtvoll.de (Postfix) with ESMTPSA id DA89A103015;
	Sat, 31 May 2025 09:07:46 +0000 (UTC)
Authentication-Results: mail.lichtvoll.de;
	auth=pass smtp.auth=martin@lichtvoll.de smtp.mailfrom=martin@lichtvoll.de
From: Martin Steigerwald <martin@lichtvoll.de>
To: Hongbo Li <lihongbo22@huawei.com>,
 Kent Overstreet <kent.overstreet@linux.dev>
Cc: linux-bcachefs@vger.kernel.org
Subject: Re: Size of directory entry 16 EiB according to "ls -l"
Date: Sat, 31 May 2025 11:07:46 +0200
Message-ID: <5016808.31r3eYUQgx@lichtvoll.de>
In-Reply-To: <evvg4qltrboeynoj4j33zzrbr2atye6mywkhzy7l5i2ifehae6@ih62wyi2fsrr>
References:
 <3009813.e9J7NaK4W3@lichtvoll.de>
 <evvg4qltrboeynoj4j33zzrbr2atye6mywkhzy7l5i2ifehae6@ih62wyi2fsrr>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"

Kent Overstreet - 31.05.25, 01:16:04 CEST:
> On Fri, May 30, 2025 at 11:19:32PM +0200, Martin Steigerwald wrote:
> > Summary: I am curious why "ls -l" reports 16 EiB as the size of a
> > directory entry. As to what I can see the filesystem is perfectly
> > fine.
> >=20
> > Kernel 6.15, self compiled. 320 GiB BCacheFS on LUKS encrypted LVM.
> > Checksums are xxhash. Filesystem was created recently on self compiled
> > 6.15-rc7 with self-compiled bcachefs tools from git tag 1.25.2.
> > "bcachefs" reports 1.25.1 as version number.
> >=20
> > I have a directory entry that according to ls -l is quite big:
> >=20
> > drwxrwxr-x 5 martin martin 18446744073709551400 DATE DIRECTORY
>=20
> Yes, this is due to a leftover from the directory i_size patchset that
> had to be reverted. As long as it's not causing issues it'll be a bit
> before I get to it, I've got higher priority bugs I'm working on right
> now (as usual).

The filesystem is perfectly fine to as far as I can say.

And I have no software in use on that filesystem that relies on any=20
specific value or calculation there=C2=B9, so absolutely no hurry from my p=
oint=20
of view.

[1] I am not even sure whether it is save to assume anything for directory=
=20
size in user space apps. "du" for example does not seem to take it into=20
account =E2=80=93 at least it does not pick up the 16 EiB =E2=80=93, not ev=
en with
"--apparent-size". BTRFS shows some value there that appears to go up with=
=20
the amount of directory entries. ext4 and XFS do as well, divisible=20
through 4096.

Best,
=2D-=20
Martin



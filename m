Received: from mail.lichtvoll.de (lichtvoll.de [37.120.160.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CC04367F26
	for <linux-bcachefs@vger.kernel.org>; Fri,  7 Aug 2026 17:15:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=37.120.160.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786122930; cv=none; b=JrOYS+GoluEpGluvgDMOb3IgRq00d4fvCRKHrUTW26CA9nfO//Y6RvH0jT8COYUYKxnXEGrnMjjEY59wHwR0rPGkrXHWKJJKrpnpsQfrUVmn7RFc2MU/UjBLv5bJLpz/3qLxTrVQet4v8zjGdy4py5740OMlFJlXnoCauSuGYpA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786122930; c=relaxed/simple;
	bh=Jjjrzdgcy5v2/S5xHr1R7kQlxQ9VBy6+TS22OHUMlyc=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KNLrgqAPFzuak/IniMbN22dZ3hKnkSSfVZDVbZ8YOv2fC6lKM42drXKtN70um/rlpXT9oiUkcwNJC0IWBcMH3rBa2wXyHYlBuPDvaQTbw/PyP36RYM0d81alSjh6wIik/en9Wmuh4bZEeFwZp8DbIu2xLuOmJ/TQogViNo9lpAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lichtvoll.de; spf=pass smtp.mailfrom=lichtvoll.de; arc=none smtp.client-ip=37.120.160.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lichtvoll.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lichtvoll.de
Received: from 127.0.0.1 (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519MLKEM768 server-signature ECDSA (secp384r1) server-digest SHA384)
	(No client certificate requested)
	by mail.lichtvoll.de (Postfix) with ESMTPSA id 245F0237D12
	for <linux-bcachefs@vger.kernel.org>; Fri, 07 Aug 2026 17:15:15 +0000 (UTC)
Authentication-Results: mail.lichtvoll.de;
	auth=pass smtp.auth=martin@lichtvoll.de smtp.mailfrom=martin@lichtvoll.de
From: Martin Steigerwald <martin@lichtvoll.de>
To: linux-bcachefs@vger.kernel.org
Subject: Re: Building BCacheFS module with Rust support via DKMS package
Date: Fri, 07 Aug 2026 19:09:58 +0200
Message-ID: <qJhizNTWQIexo4YhzOoWeA@lichtvoll.de>
In-Reply-To: <6296709.lOV4Wx5bFT@laptop>
References: <6296709.lOV4Wx5bFT@laptop>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"

Greetings.

Martin Steigerwald - 06.08.26, 19:07:33 CEST:
> I am building my own kernel with:
>=20
> time eatmydata make LLVM=3D1 -j16 bindeb-pkg LOCALVERSION=3D-t14g5
>=20
> I do have rustc and rust-src as of 1.95.0+dfsg1-2, bindgen as of
> 0.72.1-1+b2 on Devuan Ceres which is based on Debian Unstable aka Sid.
>=20
> I am quite confident my kernel is build with rust support:
>=20
> % grep _RUST /boot/config-7.1.6-t14g5
> CONFIG_RUSTC_VERSION=3D109500
> CONFIG_RUST_IS_AVAILABLE=3Dy
> CONFIG_RUSTC_LLVM_VERSION=3D210108
> CONFIG_RUSTC_LLVM_MAJOR_VERSION=3D21
> CONFIG_RUSTC_CLANG_LLVM_COMPATIBLE=3Dy
> CONFIG_RUSTC_HAS_SPAN_FILE=3Dy
> CONFIG_RUSTC_HAS_UNNECESSARY_TRANSMUTES=3Dy
> CONFIG_RUSTC_HAS_FILE_WITH_NUL=3Dy
> CONFIG_RUSTC_HAS_FILE_AS_C_STR=3Dy
> CONFIG_RUST=3Dy
> CONFIG_RUSTC_VERSION_TEXT=3D
>   "rustc 1.95.0 (59807616e 2026-04-14) (built from a source tarball)"
> CONFIG_HAVE_RUST=3Dy
> CONFIG_HAVE_CFI_ICALL_NORMALIZE_INTEGERS_RUSTC=3Dy
[=E2=80=A6]
> CONFIG_RUST_OVERFLOW_CHECKS=3Dy
> # CONFIG_RUST_BUILD_ASSERT_ALLOW is not set
> CONFIG_RUST_INLINE_HELPERS=3Dy
>=20
> I install linux-image and linux-header packages.
>=20
> Yet with bcachefs-kernel-dkms up to 1:1.39.0 I see:
>=20
> built without Rust support; this will be required in the near future -
> ensure a compatible Rust toolchain (rustc + bindgen + rust-src) is
> available at module build time
>=20
> Would bcachefs-kernel-dkms use LLVM automatically? AFAIR I did not
> manage to have a kernel with Rust support using GCC which I used
> previously.

It does.

Also rust source files are being built into object files.

Also things like "rust/libcore.rmeta" are build.

Yet not included into linux-headers package.

So for some reason the Debian build does not include the necessary Rust=20
files within the linux-headers.

This is why Rust build is disabled during DKMS module build as indicated=20
by "make.log":

bcachefs: building without Rust =E2=80=94 missing the kernel's prebuilt Rus=
t=20
stdlib (/usr/src/linux-headers-7.1.7-t14g5/rust/libcore.rmeta); the kernel=
=20
was built/installed without its rust/ artifacts

I leave it at that for now.

Best,
=2D-=20
Martin



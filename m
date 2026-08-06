Received: from mail.lichtvoll.de (lichtvoll.de [37.120.160.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5A8048BD29
	for <linux-bcachefs@vger.kernel.org>; Thu,  6 Aug 2026 17:12:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=37.120.160.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786036367; cv=none; b=OrKWt596YQZvxwlG1NB1wTsetl42Sy6BCMBhWUd1ftOiI3k2z5aHMfM2MfvGPJ5MDdpjxI+aQhD2icGxh2fBkKhh1geT9FklOPANQAIAPfxZiS2fuXerE0ech2BgRAH9fqEqg25adG83IH4IgHT/cXvtSkNm62woPNwDvWPwioA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786036367; c=relaxed/simple;
	bh=elwa/QMfljcqrBYWjxFPDSxobF11cgFb4NP0jdwwRJw=;
	h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type; b=PfPteQ/fRJL1vsE31dc7Lb59FnCUHYkl8bNvCCyJqr52hg47uFFC9sEm/d0IX7K+wdhkCQVefpflpdeugCSvtXbKuICeq0phMpnMM6wafNHAL51OCMLlHtB0ux7HNwhbIwLj5gIHIZIgwS/KvIjng/MHJyctj1AP/xpFgT8xCUU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lichtvoll.de; spf=pass smtp.mailfrom=lichtvoll.de; arc=none smtp.client-ip=37.120.160.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lichtvoll.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lichtvoll.de
Received: from 127.0.0.1 (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519MLKEM768 server-signature ECDSA (secp384r1) server-digest SHA384)
	(No client certificate requested)
	by mail.lichtvoll.de (Postfix) with ESMTPSA id 6459A236F6A
	for <linux-bcachefs@vger.kernel.org>; Thu, 06 Aug 2026 17:07:34 +0000 (UTC)
Authentication-Results: mail.lichtvoll.de;
	auth=pass smtp.auth=martin@lichtvoll.de smtp.mailfrom=martin@lichtvoll.de
From: Martin Steigerwald <martin@lichtvoll.de>
To: linux-bcachefs@vger.kernel.org
Subject: Building BCacheFS module with Rust support via DKMS package
Date: Thu, 06 Aug 2026 19:07:33 +0200
Message-ID: <6296709.lOV4Wx5bFT@laptop>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"

Greetings.

I am building my own kernel with:

time eatmydata make LLVM=1 -j16 bindeb-pkg LOCALVERSION=-t14g5

I do have rustc and rust-src as of 1.95.0+dfsg1-2, bindgen as of 
0.72.1-1+b2 on Devuan Ceres which is based on Debian Unstable aka Sid.

I am quite confident my kernel is build with rust support:

% grep _RUST /boot/config-7.1.6-t14g5
CONFIG_RUSTC_VERSION=109500
CONFIG_RUST_IS_AVAILABLE=y
CONFIG_RUSTC_LLVM_VERSION=210108
CONFIG_RUSTC_LLVM_MAJOR_VERSION=21
CONFIG_RUSTC_CLANG_LLVM_COMPATIBLE=y
CONFIG_RUSTC_HAS_SPAN_FILE=y
CONFIG_RUSTC_HAS_UNNECESSARY_TRANSMUTES=y
CONFIG_RUSTC_HAS_FILE_WITH_NUL=y
CONFIG_RUSTC_HAS_FILE_AS_C_STR=y
CONFIG_RUST=y
CONFIG_RUSTC_VERSION_TEXT=
  "rustc 1.95.0 (59807616e 2026-04-14) (built from a source tarball)"
CONFIG_HAVE_RUST=y
CONFIG_HAVE_CFI_ICALL_NORMALIZE_INTEGERS_RUSTC=y
# CONFIG_RUST_FW_LOADER_ABSTRACTIONS is not set
# CONFIG_BLK_DEV_RUST_NULL is not set
# CONFIG_ANDROID_BINDER_IPC_RUST is not set
# CONFIG_RUST_BITMAP_HARDENED is not set
# CONFIG_FIND_BIT_BENCHMARK_RUST is not set
# CONFIG_RUST_DEBUG_ASSERTIONS is not set
CONFIG_RUST_OVERFLOW_CHECKS=y
# CONFIG_RUST_BUILD_ASSERT_ALLOW is not set
CONFIG_RUST_INLINE_HELPERS=y

I install linux-image and linux-header packages.

Yet with bcachefs-kernel-dkms up to 1:1.39.0 I see:

built without Rust support; this will be required in the near future - 
ensure a compatible Rust toolchain (rustc + bindgen + rust-src) is 
available at module build time

Would bcachefs-kernel-dkms use LLVM automatically? AFAIR I did not manage 
to have a kernel with Rust support using GCC which I used previously.

Best
-- 
Martin



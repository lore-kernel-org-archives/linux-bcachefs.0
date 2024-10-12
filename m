Received: from fout-a8-smtp.messagingengine.com (fout-a8-smtp.messagingengine.com [103.168.172.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C1033FE55
	for <linux-bcachefs@vger.kernel.org>; Sat, 12 Oct 2024 16:13:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.151
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728749624; cv=none; b=kP196ux+gwoh/aDNetx5nuUxUIqdgMMMfIZLJsnpw7Aie6CGkZRxRLHEAGvQJVxTPcZPM5tZ9Xr0xAmPo9nupspYK0etC69wfxtPnmfhRR+CFMPKzFNZ7sGsCmJegHZg6+VtFMaNO9bU31l1SNMIxwpR63jdrjG8QRXajs3wEng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728749624; c=relaxed/simple;
	bh=6cVM0rMLzLxKNCFo+wExFhIXhk53yI3/oN99SS1hZv4=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=JiKvFP64a3qOpzJ0a4Bwm8NkU+XaPiBpXOeSkYr1nF3OTlATjTKLe5n9Wh+TXC2fygl7RQvkCgAMe1wl0ETgKxhhzrka9ubGj5xn/mm+9Ap+Uv9SWA4haI8QckS67DwsgfZ9H51NBuidrJ0BbZ898ya4ObfanIJvxl4q+FYB7qk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=alyssa.is; spf=pass smtp.mailfrom=alyssa.is; dkim=pass (2048-bit key) header.d=alyssa.is header.i=@alyssa.is header.b=ZJz4b2xP; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=l7FjrbCO; arc=none smtp.client-ip=103.168.172.151
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=alyssa.is
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alyssa.is
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=alyssa.is header.i=@alyssa.is header.b="ZJz4b2xP";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="l7FjrbCO"
Received: from phl-compute-01.internal (phl-compute-01.phl.internal [10.202.2.41])
	by mailfout.phl.internal (Postfix) with ESMTP id 908BC13801AB
	for <linux-bcachefs@vger.kernel.org>; Sat, 12 Oct 2024 12:13:41 -0400 (EDT)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-01.internal (MEProxy); Sat, 12 Oct 2024 12:13:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alyssa.is; h=cc
	:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:message-id:mime-version:reply-to:subject:subject:to
	:to; s=fm1; t=1728749621; x=1728836021; bh=6Rr+KHJTMIK6Q8oIx18GV
	27PbOGpp3o6B9q1DtXaUYc=; b=ZJz4b2xPo0riM/5I13zAcljHV10nWQ964mhY8
	uzAtr5SOmaq4Yu/nZ0YilhrGlCyvng2z1kIEhOGyOZOO5DSaVPA/nXKBHpJmkWY5
	k5F2w7P56oavc3kIW+TXdQLJOdGSFOrK9rQH/dn3PAP9kalQ4Mh3qtRno8fUazMV
	czVFKt602q9VduJgSi+Qd7ZZtHFuMQKF1flgk/HtAFyU6EAiOK/lShi8433Qp3vV
	0vFAR8+ZeeJBQD2XChpVN3AHm9q0tdEhC7yjOum1N2XZPObilJyRWWT9A0o3sQO/
	BNxfDrhlN0T3as67LT8K/NHFDvwNigVTrd+dy9irpTYB+nj6g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:content-transfer-encoding:content-type
	:date:date:feedback-id:feedback-id:from:from:in-reply-to
	:message-id:mime-version:reply-to:subject:subject:to:to
	:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
	fm2; t=1728749621; x=1728836021; bh=6Rr+KHJTMIK6Q8oIx18GV27PbOGp
	p3o6B9q1DtXaUYc=; b=l7FjrbCOe7X+JjsQDN5+EzRGxFwD+qHBo19h/+sAhryr
	s138h5VzVTxHoEW/pwoa1Nm4Gd7flu8nEksHJyu08TAfjmUwD9xDa6LpMcL4f2rr
	ALB5K8qgHgBUauijGs+diq6IamhgWMzC1saGT2yEt3UIfcB+23QU2Dk1y/2lZAUz
	08B4vE1nVAsBKLIj9sYMaLnRuD6i/d8kWE6B3xEG852LRWG8uhgj7eSwSdW0eFIA
	FeU1hTePkt6LOJGOpabhGYd2hBz2ojVgFnKlSckEcsg8Ccs8Zf4JF9/2X8uyQtW0
	sAOEjy+DpZ+irDdmt/gnzi0b2JhRzeVSeEu1O69/7Q==
X-ME-Sender: <xms:NaAKZ_tnGNQc7mBih62_lgPQS3rwOieRMo6baWoeaRGpIjyljGCsOg>
    <xme:NaAKZwfkKQmdLlIcAb709t9NVv6IrH0D2cp2Q8ITpgQdI-jKvfsTLXC0cPCFa2sQD
    wdGQBAuP4pc5OGrjw>
X-ME-Received: <xmr:NaAKZyy5iMl05zpBCsRY_SN7OdSonkbHtOPO_0dK-PMurA1V70Jc8ziGOCvD7PeX3DKGTXheE3Ov-SDAvyh0kGpsGps>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeftddrvdeguddgleekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdggtfgfnhhsuhgsshgtrhhisggvpdfu
    rfetoffkrfgpnffqhgenuceurghilhhouhhtmecufedttdenucenucfjughrpefhvffuff
    fkofgggfestdekredtredttdenucfhrhhomheptehlhihsshgrucftohhsshcuoehhihes
    rghlhihsshgrrdhisheqnecuggftrfgrthhtvghrnhepleejtdeiffegveejuedvkeevie
    etkefgleeuleehfeduleekueejffeikeeggfeinecuffhomhgrihhnpehgihhthhhusgdr
    tghomhenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    hhihesrghlhihsshgrrdhishdpnhgspghrtghpthhtohepuddpmhhouggvpehsmhhtphho
    uhhtpdhrtghpthhtoheplhhinhhugidqsggtrggthhgvfhhssehvghgvrhdrkhgvrhhnvg
    hlrdhorhhg
X-ME-Proxy: <xmx:NaAKZ-PLB8eVWM2x19y8502QPFQOpb74-js3kRG0J1fq31YLPqcX9A>
    <xmx:NaAKZ_-FB8tEa-JdlkBV2O56cVremK4xnbHzsJPnAECIW8IHaNHozw>
    <xmx:NaAKZ-XDkV6WKpGT1cfZx2FdLoWDplcdJiFz8VROQ72XogwqnbrVTw>
    <xmx:NaAKZwe4ydleaSu32bbZJA2ZG36iVi8Bd3kr_S6R8IYe2IqdgsFf1Q>
    <xmx:NaAKZ5lQyQ_O9ODNXAoB-wL6AEv8dbnzCR2y41F2FxM5RnVQ3zIX3RBo>
Feedback-ID: i12284293:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA for
 <linux-bcachefs@vger.kernel.org>; Sat, 12 Oct 2024 12:13:40 -0400 (EDT)
Received: by sf.qyliss.net (Postfix, from userid 1000)
	id 5AB6CC3EF2B2; Sat, 12 Oct 2024 18:13:39 +0200 (CEST)
From: Alyssa Ross <hi@alyssa.is>
To: linux-bcachefs@vger.kernel.org
Subject: [PATCH bcachefs-tools] Pass -C default-linker-libraries to rustc
Date: Sat, 12 Oct 2024 18:13:19 +0200
Message-ID: <20241012161319.305837-1-hi@alyssa.is>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

By default, rustc passes -nodefaultlibs to the linker.  In some cases,
this can cause compiler builtins (e.g. __cpu_model, used by
__builtin_cpu_supports) not to be linked in:

= note: /nix/store/s2cjhni3s6shh0n35ay1hpj8d85k44qk-x86_64-unknown-linux-musl-binutils-2.43.1/bin/x86_64-unknown-linux-musl-ld: ./libbcachefs.a(tools-util.o): in function `resolve_crc32c':
        /build/source/c_src/tools-util.c:457:(.text+0x1023): undefined reference to `__cpu_model'
        collect2: error: ld returned 1 exit status

I saw this with static musl GCC builds, and others have reported it with
Clang.

Link: https://github.com/koverstreet/bcachefs-tools/issues/300
Signed-off-by: Alyssa Ross <hi@alyssa.is>
---
 Makefile | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/Makefile b/Makefile
index c0261c35..c14db58d 100644
--- a/Makefile
+++ b/Makefile
@@ -73,12 +73,13 @@ CFLAGS+=$(call cc-disable-warning, zero-length-array)
 CFLAGS+=$(call cc-disable-warning, shift-overflow)
 CFLAGS+=$(call cc-disable-warning, enum-conversion)
 CFLAGS+=$(call cc-disable-warning, gnu-variable-sized-type-not-at-end)
+export RUSTFLAGS=-C default-linker-libraries
 
 PKGCONFIG_LIBS="blkid uuid liburcu libsodium zlib liblz4 libzstd libudev libkeyutils"
 ifdef BCACHEFS_FUSE
 	PKGCONFIG_LIBS+="fuse3 >= 3.7"
 	CFLAGS+=-DBCACHEFS_FUSE
-	export RUSTFLAGS=--cfg fuse
+	RUSTFLAGS+=--cfg fuse
 endif
 
 PKGCONFIG_CFLAGS:=$(shell $(PKG_CONFIG) --cflags $(PKGCONFIG_LIBS))

base-commit: b34d1341919c4edd3251c7f69c2588acd1196d71
-- 
2.45.2


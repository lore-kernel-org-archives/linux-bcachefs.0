Received: from pfhigh4-smtp.messagingengine.com (fhigh4-smtp.messagingengine.com [103.168.172.155])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FA231917D9
	for <linux-bcachefs@vger.kernel.org>; Tue,  3 Sep 2024 17:35:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.155
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725384931; cv=none; b=SaLh7VQwuf6BqGl4/ux+0QNidN8aSCog/89xETWdzxZ+Gjg9/GbLhKvqzjRMR2yIGLbmWbSr/zPWgNJfzAGadlsaNV7igWhDRYhL3eL8NJdmef9snuUas3jyJEoVE3c93pgoi3BSPzCpuJJbSHMz5LyMrMN/6H6YDZz965MJJ7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725384931; c=relaxed/simple;
	bh=P6MZMb46rTMCS79ENaog2lshKU7f6+n8ufQvmRO//LA=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=HMUaz9h+HcGGla+6oApOok/VWh5gOscdazQx99l9raqqAfhAv69jOIz2cS00UdGgAnimVt/zhmCklW59u5uG+JomGBv3mLrxhgixuRaWmRFyRWFMOXuJhbYFnonglAIfc6sd2MJ6T1n9gaMiWR6OH8oKVeaLloCR9R5stUTp9VA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=alyssa.is; spf=pass smtp.mailfrom=alyssa.is; dkim=pass (2048-bit key) header.d=alyssa.is header.i=@alyssa.is header.b=aZ5l089w; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=hcL0r3ex; arc=none smtp.client-ip=103.168.172.155
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=alyssa.is
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alyssa.is
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=alyssa.is header.i=@alyssa.is header.b="aZ5l089w";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="hcL0r3ex"
Received: from phl-compute-04.internal (phl-compute-04.phl.internal [10.202.2.44])
	by mailfhigh.phl.internal (Postfix) with ESMTP id D15581140431
	for <linux-bcachefs@vger.kernel.org>; Tue,  3 Sep 2024 13:35:26 -0400 (EDT)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-04.internal (MEProxy); Tue, 03 Sep 2024 13:35:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alyssa.is; h=cc
	:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:message-id:mime-version:reply-to:subject:subject:to
	:to; s=fm3; t=1725384926; x=1725471326; bh=M9nl7IjApWgOdaFZFj6d+
	IlDvFB/GmcnudSJOTs1W28=; b=aZ5l089wf8YWpTlSzpsa/z/HXQUaYk1UFuWrM
	VtsNzRTXVHGjMrzAfoJF7yJ2c3WvxjqB4u5fmMN9gdm16zPzdtUMATFm6Yp0Ppvu
	bHXlxtdirq1RLSYfLlv0MuY74ANPWYpK/PxgH3BCG3hwW6AexpdUxKC6fZBqKB1Y
	Z23gUSEoZwBEpRoFnHhJV2OPYjpo8vq66fz69LQSpBl/NJRnMmSIFOVTMdszZoxE
	Enp8hIs+BTSIWAy7p7lI3/rkYB1X8HtYD4ptPAeYgWI5/t7M4JUDoncxqcu6FeIP
	tk+sWEaUzqfUgc2JDyg4gwX1TKAirWjle3QRiIRZmUb5/O/vw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:content-transfer-encoding:content-type
	:date:date:feedback-id:feedback-id:from:from:in-reply-to
	:message-id:mime-version:reply-to:subject:subject:to:to
	:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
	fm1; t=1725384926; x=1725471326; bh=M9nl7IjApWgOdaFZFj6d+IlDvFB/
	GmcnudSJOTs1W28=; b=hcL0r3exn45w9bssptswXUKbm8OKrWitOsqZ8pNEqjS1
	+WEvaEnOg+SrkThTFq5AdZ/HYJLX3epUGVtHUm0u8Qk4xwFeTTXohHm0ndF7GO78
	n23vSrfPRb3rxkl/5jH5+UNu5nMXHPsB1lkoFngjbW4cdSz659dapsY9cvzwyTYU
	XbDqAONax5O4ul4MIbGZuquDuAGItVbs981AGrfWNs8mkeyTSmoSh478j1gcdpy1
	eQLkebcbaaTt07YLZ15y4QnvmUFYDZq80D2/L/u2tvFVUh/lsuOYQrndJAtlUF0J
	neNamjguv3qM/dbceHzLCF94g4Z2ueX/AL2Z0F74YA==
X-ME-Sender: <xms:3kjXZlZGt2SUVO1IdzbsCrD4lDtHVGJDpK6R_gqnw8tFNf9ZK-sAcg>
    <xme:3kjXZsZSeD4-izYQNb4ktBraSw0zrbLrbRUTc4UVzqgUsiY_oxICTuGbCaUABBEMT
    70lTE3Lna4YGaRaCQ>
X-ME-Received: <xmr:3kjXZn96ga3dRXpLb3jLzCM9kkhMfEXHYxx8FHR6S_aFZ-0xMXzpNqfBH5Tk9C_v00F1IwnXn6EYMt46vtUuKaB3Kc8>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeftddrudehhedgudduhecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpggftfghnshhusghstghrihgsvgdp
    uffrtefokffrpgfnqfghnecuuegrihhlohhuthemuceftddtnecunecujfgurhephffvuf
    ffkffoggfgsedtkeertdertddtnecuhfhrohhmpeetlhihshhsrgcutfhoshhsuceohhhi
    segrlhihshhsrgdrihhsqeenucggtffrrghtthgvrhhnpeehvdffgffhteeijefgteeftd
    fghfdvheeuhedvjedugfeggfeljefgleefvefgfeenucevlhhushhtvghrufhiiigvpedt
    necurfgrrhgrmhepmhgrihhlfhhrohhmpehhihesrghlhihsshgrrdhishdpnhgspghrtg
    hpthhtohepuddpmhhouggvpehsmhhtphhouhhtpdhrtghpthhtoheplhhinhhugidqsggt
    rggthhgvfhhssehvghgvrhdrkhgvrhhnvghlrdhorhhg
X-ME-Proxy: <xmx:3kjXZjquJojf0NfGBAVJN1RTWaOwdykeR9561HXIRUQVFqduYcKwDA>
    <xmx:3kjXZgoPvN4k6FVGDxP84dy31Phk3Pw8wKJR162n9BBfuFwF7kihfw>
    <xmx:3kjXZpT_s9U3qfUdp8ozSYMBWZe5TmdqJgBaAOudn7W2Bc9jmP4icg>
    <xmx:3kjXZopbUByXwFSjNxUU-_hN_6zcjbwFtgOWi4Yi03OJ-f3yGir8SQ>
    <xmx:3kjXZtCG6-KFFyPV0fkOCKU-U4DD5blpAN_ZQdhKE7hbZpRxKNXgYoMM>
Feedback-ID: i12284293:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA for
 <linux-bcachefs@vger.kernel.org>; Tue, 3 Sep 2024 13:35:26 -0400 (EDT)
Received: by sf.qyliss.net (Postfix, from userid 1000)
	id 62B282C3BD5CE; Tue, 03 Sep 2024 19:35:24 +0200 (CEST)
From: Alyssa Ross <hi@alyssa.is>
To: linux-bcachefs@vger.kernel.org
Subject: [PATCH bcachefs-tools] Remove udev from PKGCONFIG_LIBS in Makefile
Date: Tue,  3 Sep 2024 19:35:22 +0200
Message-ID: <20240903173522.496756-1-hi@alyssa.is>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

libudev.pc is the pkg-config file for the udev libraries.  udev.pc is
just there to define the directory that rules etc. should be installed
into.  It therefore doesn't need to be included in the list of libraries
passed to pkg-config --cflags or pkg-config --libs.

At least one implementation of the libudev API, libudev-zero, does not
provide a udev.pc file, because it does not implement the udev rules
language, just the library API.  With this change, it's possible to
build bcachefs-tools against libudev-zero by pointing PKGCONFIG_UDEVDIR
somewhere on the make command line.

Signed-off-by: Alyssa Ross <hi@alyssa.is>
---
 Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Makefile b/Makefile
index 23122fd6..c0261c35 100644
--- a/Makefile
+++ b/Makefile
@@ -74,7 +74,7 @@ CFLAGS+=$(call cc-disable-warning, shift-overflow)
 CFLAGS+=$(call cc-disable-warning, enum-conversion)
 CFLAGS+=$(call cc-disable-warning, gnu-variable-sized-type-not-at-end)
 
-PKGCONFIG_LIBS="blkid uuid liburcu libsodium zlib liblz4 libzstd libudev libkeyutils udev"
+PKGCONFIG_LIBS="blkid uuid liburcu libsodium zlib liblz4 libzstd libudev libkeyutils"
 ifdef BCACHEFS_FUSE
 	PKGCONFIG_LIBS+="fuse3 >= 3.7"
 	CFLAGS+=-DBCACHEFS_FUSE
-- 
2.45.2


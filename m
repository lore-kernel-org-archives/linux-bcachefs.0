Received: from mout02.posteo.de (mout02.posteo.de [185.67.36.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19312146A68
	for <linux-bcachefs@vger.kernel.org>; Fri, 21 Mar 2025 16:34:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.67.36.66
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742574872; cv=none; b=byPRsIahgxKEiyAf+VzyUXY47Ji2GCYrrEPk2IhMP2D7fo+UWulKZ+me899DVayDvxMYwCxS2lYNhXcGJQTDowomeNV9yJQT9LMXqZWixWio1g3vI38hCRMCR1t5woOKAuRDMF5go42ShL6SQsJzvbKpjt/Ep15ks0PKZ+2BOsg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742574872; c=relaxed/simple;
	bh=52G8a8PyLl693DMCD/0zVGr9RwxemND2/mRfPl/VxNI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Nl2UIyCugx2RrEzJEs56+pQwPZZLzmx8m/AO95m4LoL/R8jFAH7uFq33e8SJW8oRKGN2tYMWgUIrHRUWruJkrMqPCGfkDRj5IuLhaB5yiC+TumFvqv3bNtM00ke5k55oLA1SjBUWfpGhCt35HZacPOAVcDUPBJOZ/AXkIsaYF7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=posteo.net; spf=pass smtp.mailfrom=posteo.net; dkim=pass (2048-bit key) header.d=posteo.net header.i=@posteo.net header.b=HNZqq/hD; arc=none smtp.client-ip=185.67.36.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=posteo.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=posteo.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=posteo.net header.i=@posteo.net header.b="HNZqq/hD"
Received: from submission (posteo.de [185.67.36.169]) 
	by mout02.posteo.de (Postfix) with ESMTPS id 3B8E8240105
	for <linux-bcachefs@vger.kernel.org>; Fri, 21 Mar 2025 17:34:28 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=posteo.net; s=2017;
	t=1742574868; bh=52G8a8PyLl693DMCD/0zVGr9RwxemND2/mRfPl/VxNI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:
	 Content-Transfer-Encoding:From;
	b=HNZqq/hDbmGo6X1UF+b92h63w92pXjSKDUrg/MoxVDUeLaU6R5i5U5bMYb1poUW51
	 NWwczo3pqSj8JM6HqGq1zhPzAJhsawayBHEeUEON/Hl8wiVvZYfhKVDbMd2WuNOGfB
	 UOuhD0XbApMx9Ivsoa4zC0uuMr3QGf4WP6GJK4sl1AhyUNdEyS8tAEwS/3GgawjsYb
	 qXe8zNOY/uTzklnU+VcpPkix1a9cWl+1+tDOhyJ6+zCF9yTnbdhKGANSuyTr3Fcxw6
	 k1fEwenqj2G7T3/K2vUcq4ZSGKJi4CNErUywdzeEl8xd0K/pFs7c9fW6w57OKTVlDd
	 VCJaYpTCiSk9Q==
Received: from customer (localhost [127.0.0.1])
	by submission (posteo.de) with ESMTPSA id 4ZK7M45lQvz9rxF;
	Fri, 21 Mar 2025 17:34:24 +0100 (CET)
From: =?UTF-8?q?Thomas=20M=C3=BChlbacher?= <tmuehlbacher@posteo.net>
To: kent.overstreet@linux.dev
Cc: linux-bcachefs@vger.kernel.org,
	=?UTF-8?q?Thomas=20M=C3=BChlbacher?= <tmuehlbacher@posteo.net>
Subject: [PATCH v2 06/10] fix(makefile): locate built bin with CARGO_BUILD_TARGET set
Date: Fri, 21 Mar 2025 16:34:00 +0000
Message-ID: <20250321163404.353334-7-tmuehlbacher@posteo.net>
In-Reply-To: <20250321163404.353334-1-tmuehlbacher@posteo.net>
References: <20250321163404.353334-1-tmuehlbacher@posteo.net>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When this environment variable is set, e.g. for some cross compile
setups, the target dir is nested a little further.
---
 Makefile | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/Makefile b/Makefile
index 81e3ba1e..95d8cdb5 100644
--- a/Makefile
+++ b/Makefile
@@ -22,6 +22,13 @@ else
   CARGO_CLEAN_ARGS = --quiet
 endif
 
+# when cross compiling, cargo places the built binary in a different location
+ifdef CARGO_BUILD_TARGET
+	BUILT_BIN = target/$(CARGO_BUILD_TARGET)/release/bcachefs
+else
+	BUILT_BIN = target/release/bcachefs
+endif
+
 # Prevent recursive expansions of $(CFLAGS) to avoid repeatedly performing
 # compile tests
 CFLAGS:=$(CFLAGS)
@@ -195,7 +202,7 @@ cmd_version.o : .version
 install: INITRAMFS_HOOK=$(INITRAMFS_DIR)/hooks/bcachefs
 install: INITRAMFS_SCRIPT=$(INITRAMFS_DIR)/scripts/local-premount/bcachefs
 install: bcachefs $(optional_install)
-	$(INSTALL) -m0755 -D target/release/bcachefs -t $(DESTDIR)$(ROOT_SBINDIR)
+	$(INSTALL) -m0755 -D $(BUILT_BIN)  -t $(DESTDIR)$(ROOT_SBINDIR)
 	$(INSTALL) -m0644 -D bcachefs.8    -t $(DESTDIR)$(PREFIX)/share/man/man8/
 	$(INSTALL) -m0755 -D initramfs/script $(DESTDIR)$(INITRAMFS_SCRIPT)
 	$(INSTALL) -m0755 -D initramfs/hook   $(DESTDIR)$(INITRAMFS_HOOK)
-- 
2.48.1


Received: from wiki.archlinuxcn.org (wiki.archlinuxcn.org [104.245.9.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54BB679FD
	for <linux-bcachefs@vger.kernel.org>; Sat, 26 Oct 2024 14:19:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=104.245.9.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729952364; cv=none; b=CvnlaRbgxD7UPY68J0EXJZf/PZJEb/Yg/+0CmReOdME0/BzHBk/JcSpoa/PGkbQcYfYdDWyt3NDuBQr5ZFkcHGCVbXLP5qpp2W4fEpXGJdePXkfSlPWQc5PpVuCRadY5gVTlyOavqbB/fZol8FZqVsxDVkcAqWrX0h9vdtdh3lI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729952364; c=relaxed/simple;
	bh=f9Nwq0Cbv3X7g/KA16YFAuomUda19emGQhSpneUoYnI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=PrXHfb/7bj7GTqUsLbN4G8XP//9AmQQuM6+lBU8Gcw61vnh9Y/3QffhXl/OsI09TmJrxO2cowPTtwu78BCH8XIzqPUh46hwMUsXnd1xAutSzHBGeMVx4uUpNk00SeIsUaOnubQhYcomt4VZgcwXjPs5C4FGHMtLDJ85AIy41Q8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=archlinuxcn.org; spf=pass smtp.mailfrom=archlinuxcn.org; dkim=pass (2048-bit key) header.d=archlinuxcn.org header.i=@archlinuxcn.org header.b=ssVx/LIz; arc=none smtp.client-ip=104.245.9.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=archlinuxcn.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=archlinuxcn.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=archlinuxcn.org header.i=@archlinuxcn.org header.b="ssVx/LIz"
DKIM-Signature: a=rsa-sha256; bh=MowEKMegvG4EzCT+n7tgrGYIwYlr9eNTwAWZ4Wf9kF8=;
 c=relaxed/relaxed; d=archlinuxcn.org;
 h=Subject:Subject:Sender:To:To:Cc:Cc:From:From:Date:Date:MIME-Version:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Transfer-Encoding:Reply-To:In-Reply-To:Message-Id:Message-Id:References:Autocrypt:Openpgp;
 i=@archlinuxcn.org; s=default; t=1729952344; v=1; x=1730384344;
 b=ssVx/LIzLtjgOvBcRgFXc+ShzdpcQcePlll5Dl/Z6PKUD5jUa582Faynly+5BRCBnSvaPDT9
 nw67q45lvHMIWWHSjwx9Kj/3FGVxFGYTiaFCo45dWYpEBLhTPQ3jCh7RvdHa90JNcgwHY/piVWa
 cJt5d+j2qf/CrjvNUBVEKmixq8kY2YND663iRFpN3KjP/af64XFmVHFpnaqYAkmJUnJyGfSDqH+
 dCtk32JOrYL15+UTfAsaJcCGJNEBcqLHNwEwMf4Wp0bN5+D3XSPiIRGC1kBxdwsWZmZZ7bhTh/B
 9uLEJ15Eubx094mrxxIpasrDOQEy8Jgpy57V5eYDfRYeg==
Received: by wiki.archlinuxcn.org (envelope-sender
 <integral@archlinuxcn.org>) with ESMTPS id 5e72cba0; Sat, 26 Oct 2024
 22:19:04 +0800
From: Integral <integral@archlinuxcn.org>
To: kent.overstreet@gmail.com,
	kent.overstreet@linux.dev,
	lihongbo22@huawei.com
Cc: mmpgouride@gmail.com,
	linux-bcachefs@vger.kernel.org,
	integral@archlinuxcn.org
Subject: [PATCH] bcachefs-tools: fix in fuse feature in RUSTFLAGS
Date: Sat, 26 Oct 2024 22:18:31 +0800
Message-ID: <20241026141830.65199-2-integral@archlinuxcn.org>
X-Mailer: git-send-email 2.47.0
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Currently, when "BCACHEFS_FUSE=1" is set, fusemount subcommand
still cannot be identified. Change RUSTFLAGS in Makefile to fix
this problem.

Signed-off-by: Integral <integral@archlinuxcn.org>
---
 Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Makefile b/Makefile
index c14db58d..1fae1f5b 100644
--- a/Makefile
+++ b/Makefile
@@ -79,7 +79,7 @@ PKGCONFIG_LIBS="blkid uuid liburcu libsodium zlib liblz4 libzstd libudev libkeyu
 ifdef BCACHEFS_FUSE
 	PKGCONFIG_LIBS+="fuse3 >= 3.7"
 	CFLAGS+=-DBCACHEFS_FUSE
-	RUSTFLAGS+=--cfg fuse
+	RUSTFLAGS+=--cfg feature="fuse"
 endif

 PKGCONFIG_CFLAGS:=$(shell $(PKG_CONFIG) --cflags $(PKGCONFIG_LIBS))
--
2.47.0


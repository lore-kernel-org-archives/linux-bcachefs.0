Received: from mout02.posteo.de (mout02.posteo.de [185.67.36.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0C2D21CFF7
	for <linux-bcachefs@vger.kernel.org>; Fri, 10 Jan 2025 22:49:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.67.36.66
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736549390; cv=none; b=eBqJmRSn2bk4PVz9ReJYo0a+T7y6YItEZ4mf85nTwr2BPrT0TCUZY4HaGc6T1VbZctwU3IL5lEAjD7ANjF6/Db0knwHp3VZ1pQ0lXceSIuAstOUu/H/enbb9ustSi4SZ5B+FeXaJ7yLEPpxw9HUUfkO2R+1HH9LrxXKCJmxkT3E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736549390; c=relaxed/simple;
	bh=XeLEaD/JwWfVweZ+NMXLPKgHMRArH0T7aqu5zf/T5ww=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Lo4izjLmJgGPsnMx3R9HgkGUrWdSK3FYZfeEsNqXnjYYGNWZZZZ8Vs/YB+0EVnvEHqi1+c0SXukH3M2djKGhfJRYW15ULXv3vjPfuhghLdFSvOCumkrSM+3rK4BGOhD+UwP2uKrpzOTfZSij3p8ITywkgLC01OynkJ3pHZL21K8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=posteo.net; spf=pass smtp.mailfrom=posteo.net; dkim=pass (2048-bit key) header.d=posteo.net header.i=@posteo.net header.b=PpoVNikB; arc=none smtp.client-ip=185.67.36.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=posteo.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=posteo.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=posteo.net header.i=@posteo.net header.b="PpoVNikB"
Received: from submission (posteo.de [185.67.36.169]) 
	by mout02.posteo.de (Postfix) with ESMTPS id B38D8240103
	for <linux-bcachefs@vger.kernel.org>; Fri, 10 Jan 2025 23:49:46 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=posteo.net; s=2017;
	t=1736549386; bh=XeLEaD/JwWfVweZ+NMXLPKgHMRArH0T7aqu5zf/T5ww=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:
	 Content-Transfer-Encoding:From;
	b=PpoVNikBBOa473OzmgfbBP9SMJe0VFwEUxIVxV8G12ei3auCbcIxyvh27lR9Rj6gD
	 0yYasPaZFeCkw478Q5n+MDHdCa1g9qJ453dv9jUZ4KEPDn/EW9pxqBD2tIjmSNgJ+I
	 XnknoNHOcCAB151Q7NyfCmKH4Z269WDxEWHuZA1hJYw0FKtDiG29gkTJ+tj0ykbpJH
	 PSeJQKe3CZ/k6bRWL3w5QczMCl8aRfaGyw8hvFpTVed5RcxmEdpnLYWXF1gQjNnQkm
	 Engw2H8sOuunfpuNQE7cNUzbQXQ9Hc+aHUuTva8M6gMVVkH3TO3e+1FNjU1BT69zSa
	 k1woNNpvMUo2w==
Received: from customer (localhost [127.0.0.1])
	by submission (posteo.de) with ESMTPSA id 4YVH0V23pKz6tyL;
	Fri, 10 Jan 2025 23:49:46 +0100 (CET)
From: =?UTF-8?q?Thomas=20M=C3=BChlbacher?= <tmuehlbacher@posteo.net>
To: linux-bcachefs@vger.kernel.org
Cc: kent.overstreet@gmail.com,
	=?UTF-8?q?Thomas=20M=C3=BChlbacher?= <tmuehlbacher@posteo.net>
Subject: [PATCH 6/9] fix(makefile): locate built bin with CARGO_BUILD_TARGET set
Date: Fri, 10 Jan 2025 22:49:09 +0000
Message-ID: <20250110224912.445491-7-tmuehlbacher@posteo.net>
In-Reply-To: <20250110224912.445491-1-tmuehlbacher@posteo.net>
References: <20250110224912.445491-1-tmuehlbacher@posteo.net>
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
index 68ebb2d6..71b3e48d 100644
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
2.47.0


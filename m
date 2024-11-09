Received: from wiki.archlinuxcn.org (wiki.archlinuxcn.org [104.245.9.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C86B15746F
	for <linux-bcachefs@vger.kernel.org>; Sat,  9 Nov 2024 18:57:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=104.245.9.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731178650; cv=none; b=SUX2q+NGYCyZDf05d+AbStc1G32Gw+T6bQRW0ncC7kcx0kxAInsNoJxvIk24l2fX1aiyQcrSGwo8HBbC6KHEQrq7AJ9jpUgzQsYA624qOREzRdusoHJfj5+xNJsSbbVLnHHhSmkF7xV3uOcRwKQoCyScEUA9hQtrTMNqAEwj8lM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731178650; c=relaxed/simple;
	bh=ICVKMQ9e7/L6fubJnR84/eDgRZbmuc8yND8JOL9zF1k=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=FjEOt8ETklm89DNX/S3iIZHvbWn//8CUyeSJ9MdKV/XCXo4MoDjyLo2ntbd2e2nrJTePpkWJn180KNoOQ5LwW2aBCNk/XQsIZ29WfyuQtoTWx/qQyW8xhQUq0Wkfqbw234qwAYz35wJsC9L4DU8hXN1kE1VPGFyfUhJ21Wzh7qY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=archlinuxcn.org; spf=pass smtp.mailfrom=archlinuxcn.org; dkim=pass (2048-bit key) header.d=archlinuxcn.org header.i=@archlinuxcn.org header.b=moZtyfEj; arc=none smtp.client-ip=104.245.9.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=archlinuxcn.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=archlinuxcn.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=archlinuxcn.org header.i=@archlinuxcn.org header.b="moZtyfEj"
DKIM-Signature: a=rsa-sha256; bh=nmnc8lsg7anflEvLF1bUa4+1/jfDOmGcJ6zlruq7T8k=;
 c=relaxed/relaxed; d=archlinuxcn.org;
 h=Subject:Subject:Sender:To:To:Cc:Cc:From:From:Date:Date:MIME-Version:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Transfer-Encoding:Reply-To:In-Reply-To:Message-Id:Message-Id:References:Autocrypt:Openpgp;
 i=@archlinuxcn.org; s=default; t=1731178633; v=1; x=1731610633;
 b=moZtyfEjOeeBXmD0jUj1oRvOBbeCy0glzdhxHtavgIK0G9hCMim5spZcmpsFhEu+LIJA/1lF
 aRqADOKrFMlW9Qa+XKz29ualDn0Fg2+8CfSWyPP046tjbMBrwYyg56YYmxk9mEk2x+d7AAnK5oL
 9pVuaAbwMBnvP72YeFSX8IHP2N8BVEUBe4Q5YzI7rC7oVYHr1jP2IKDlMbGFK4kvWFcDP6J2yw2
 Bwoxnw6tSzDctvzHgcB61r626uB0dXelH2e7b0zcunsT3j9DTWHP4PzUez54mMz85dDPQ2Y9/s9
 yzCSWds+uP0shq0asbBYkChedyrvQvhatBqNfKiDmim1w==
Received: by wiki.archlinuxcn.org (envelope-sender
 <integral@archlinuxcn.org>) with ESMTPS id 0ff4e0c9; Sun, 10 Nov 2024
 02:57:13 +0800
From: Integral <integral@archlinuxcn.org>
To: kent.overstreet@gmail.com,
	kent.overstreet@linux.dev,
	lihongbo22@huawei.com
Cc: mmpgouride@gmail.com,
	linux-bcachefs@vger.kernel.org,
	integral@archlinuxcn.org
Subject: [PATCH] bcachefs-tools: add usage function for fs subcommand
Date: Sun, 10 Nov 2024 02:56:49 +0800
Message-ID: <20241109185648.30536-2-integral@archlinuxcn.org>
X-Mailer: git-send-email 2.47.0
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add the missing usage function for "fs" subcommand; when no matching
subcommand exists, print the usage and return -EINVAL.

Signed-off-by: Integral <integral@archlinuxcn.org>
---
 c_src/bcachefs.c |  9 ++++-----
 c_src/cmd_fs.c   | 12 ++++++++++++
 c_src/cmds.h     |  1 +
 3 files changed, 17 insertions(+), 5 deletions(-)

diff --git a/c_src/bcachefs.c b/c_src/bcachefs.c
index 77bf6215..e9e617e1 100644
--- a/c_src/bcachefs.c
+++ b/c_src/bcachefs.c
@@ -113,14 +113,13 @@ int fs_cmds(int argc, char *argv[])
 {
 	char *cmd = pop_cmd(&argc, argv);

-	if (argc < 1) {
-		bcachefs_usage();
-		exit(EXIT_FAILURE);
-	}
+	if (argc < 1)
+		return fs_usage();
 	if (!strcmp(cmd, "usage"))
 		return cmd_fs_usage(argc, argv);

-	return 0;
+	fs_usage();
+	return -EINVAL;
 }

 int device_cmds(int argc, char *argv[])
diff --git a/c_src/cmd_fs.c b/c_src/cmd_fs.c
index 82eeceff..eb8f7d2e 100644
--- a/c_src/cmd_fs.c
+++ b/c_src/cmd_fs.c
@@ -487,6 +487,18 @@ devs:
 	bcache_fs_close(fs);
 }

+int fs_usage(void)
+{
+       puts("bcachefs fs - manage a running filesystem\n"
+            "Usage: bcachefs fs <CMD> [OPTIONS]\n"
+            "\n"
+            "Commands:\n"
+            "  usage                     Display detailed filesystem usage\n"
+            "\n"
+            "Report bugs to <linux-bcachefs@vger.kernel.org>");
+       return 0;
+}
+
 static void fs_usage_usage(void)
 {
 	puts("bcachefs fs usage - display detailed filesystem usage\n"
diff --git a/c_src/cmds.h b/c_src/cmds.h
index 64267dc4..99016d52 100644
--- a/c_src/cmds.h
+++ b/c_src/cmds.h
@@ -14,6 +14,7 @@ int cmd_show_super(int argc, char *argv[]);
 int cmd_reset_counters(int argc, char *argv[]);
 int cmd_set_option(int argc, char *argv[]);

+int fs_usage(void);
 int cmd_fs_usage(int argc, char *argv[]);

 int device_usage(void);
--
2.47.0


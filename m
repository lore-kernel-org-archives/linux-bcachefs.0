Received: from wiki.archlinuxcn.org (wiki.archlinuxcn.org [104.245.9.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 029911C5D7B
	for <linux-bcachefs@vger.kernel.org>; Mon, 31 Mar 2025 12:01:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=104.245.9.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743422495; cv=none; b=KoZnZgTTXsO/yXiDumnFDeD2Fg7wy1gw9t+yzEqKvJzhqg/Xb532XjQxUyoc1hI64ysdvIuswycZLpkFNkfxgVyIv+yT/Kd5pkKPDGfo3qhC56WDl4w+v4NZ7AiOujEhZrs/k0+FsvEvm2y08UYsvdAmuJvFRrbzeA3ArT39m/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743422495; c=relaxed/simple;
	bh=CtEeAYdYTz7xSC8ZIF2PZB5N+XLcSSw9UFTrUnlDrvo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=mxncWgPz6lYnstLIeRKKDlx4r3eXjIFgZ4Ud4wg3LhsAIF50Zh2GANCyqbxkn1tVq0KEEIWnVqlSId10TSbqf+sp2CYIMkfyMVgBBjr/ND6fqGT/e3r6wQjCSDRVvgyZrGydjZL6yvZaFcMKUNVoBNUTtF/7LUkvmY43LjVvbck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=archlinuxcn.org; spf=pass smtp.mailfrom=archlinuxcn.org; dkim=pass (2048-bit key) header.d=archlinuxcn.org header.i=@archlinuxcn.org header.b=SF9syHv4; arc=none smtp.client-ip=104.245.9.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=archlinuxcn.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=archlinuxcn.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=archlinuxcn.org header.i=@archlinuxcn.org header.b="SF9syHv4"
DKIM-Signature: a=rsa-sha256; bh=ktExUNRETTxeC7sRlXpf5sLQ0RudcdXJzTTO6jVq/RM=;
 c=relaxed/relaxed; d=archlinuxcn.org;
 h=Subject:Subject:Sender:To:To:Cc:Cc:From:From:Date:Date:MIME-Version:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Transfer-Encoding:Reply-To:In-Reply-To:Message-Id:Message-Id:References:Autocrypt:Openpgp;
 i=@archlinuxcn.org; s=default; t=1743422456; v=1; x=1743854456;
 b=SF9syHv4Km7cXQAVxxvthbOubGktd+kqsQiKrcmWRwIOZuxuHgBIdkukxMZTCfi8+EjFMBpE
 MKa8eYvdaotpFGWH7nZKuUFtEuO8Q5r10mJwFgabUuG8EWpzn401oIPtly+y9sLvLbw1+mQvilY
 YiZVSt/n1qj3dQoRjE608PthuunhaZOf2nodxHaB6xGEmZgaRLKOi9eiC0HRG8VlIGhKpa4FWRl
 Mxd2YkmPw0tfxnsxi0Ia3oSse2Ba5gaJhhKw/I5k7CGMR5B6lhw4SfEKiKFROVdIvPIvMAkSOqw
 N0IU1Hqc09D0OA6gpvOn9HVj2z96ttU9l1UDi7G3nv1bg==
Received: by wiki.archlinuxcn.org (envelope-sender
 <integral@archlinuxcn.org>) with ESMTPS id 731a9d9b; Mon, 31 Mar 2025
 20:00:56 +0800
From: Integral <integral@archlinuxcn.org>
To: kent.overstreet@gmail.com,
	kent.overstreet@linux.dev,
	lihongbo22@huawei.com
Cc: mmpgouride@gmail.com,
	linux-bcachefs@vger.kernel.org,
	integral@archlinuxcn.org
Subject: [PATCH v2 combined resend v2] bcachefs-tools: add fs_usage & return -EINVAL when no matching subcommand
Date: Mon, 31 Mar 2025 20:00:32 +0800
Message-ID: <20250331120031.79365-2-integral@archlinuxcn.org>
X-Mailer: git-send-email 2.49.0
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
 c_src/bcachefs.c | 15 ++++++++-------
 c_src/cmd_fs.c   | 13 +++++++++++++
 c_src/cmds.h     |  1 +
 3 files changed, 22 insertions(+), 7 deletions(-)

diff --git a/c_src/bcachefs.c b/c_src/bcachefs.c
index f2a1449e..2f718147 100644
--- a/c_src/bcachefs.c
+++ b/c_src/bcachefs.c
@@ -118,16 +118,15 @@ int fs_cmds(int argc, char *argv[])
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
 	if (!strcmp(cmd, "top"))
 		return cmd_fs_top(argc, argv);
 
-	return 0;
+	fs_usage();
+	return -EINVAL;
 }
 
 int device_cmds(int argc, char *argv[])
@@ -153,7 +152,8 @@ int device_cmds(int argc, char *argv[])
 	if (!strcmp(cmd, "resize-journal"))
 		return cmd_device_resize_journal(argc, argv);
 
-	return 0;
+	device_usage();
+	return -EINVAL;
 }
 
 int data_cmds(int argc, char *argv[])
@@ -169,5 +169,6 @@ int data_cmds(int argc, char *argv[])
 	if (!strcmp(cmd, "job"))
 		return cmd_data_job(argc, argv);
 
-	return 0;
+	data_usage();
+	return -EINVAL;
 }
diff --git a/c_src/cmd_fs.c b/c_src/cmd_fs.c
index 06f797b9..4ab3ec0d 100644
--- a/c_src/cmd_fs.c
+++ b/c_src/cmd_fs.c
@@ -491,6 +491,19 @@ devs:
 	bcache_fs_close(fs);
 }
 
+int fs_usage(void)
+{
+	puts("bcachefs fs - manage a running filesystem\n"
+	     "Usage: bcachefs fs <CMD> [OPTIONS]\n"
+	     "\n"
+	     "Commands:\n"
+	     "  usage                   Display detailed filesystem usage\n"
+	     "  top                     Show runtime performance information\n"
+	     "\n"
+	     "Report bugs to <linux-bcachefs@vger.kernel.org>");
+	return 0;
+}
+
 static void fs_usage_usage(void)
 {
 	puts("bcachefs fs usage - display detailed filesystem usage\n"
diff --git a/c_src/cmds.h b/c_src/cmds.h
index 9502d539..82f28af2 100644
--- a/c_src/cmds.h
+++ b/c_src/cmds.h
@@ -15,6 +15,7 @@ int cmd_recover_super(int argc, char *argv[]);
 int cmd_reset_counters(int argc, char *argv[]);
 int cmd_set_option(int argc, char *argv[]);
 
+int fs_usage(void);
 int cmd_fs_usage(int argc, char *argv[]);
 int cmd_fs_top(int argc, char *argv[]);
 
-- 
2.49.0


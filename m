Received: from wiki.archlinuxcn.org (wiki.archlinuxcn.org [104.245.9.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9905184F
	for <linux-bcachefs@vger.kernel.org>; Mon, 11 Nov 2024 03:49:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=104.245.9.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731296999; cv=none; b=qgWENMtn3cme7LoBjSFD5EN528peldKJQH28yZLWTYEODRRKc+yFt7ll454FcbsOgPe8SAEPpmKwJWXB2iiLMD40IQPcUKaHrcqACGa2/9H1ecQ4cUc4fLXnw9Ccj98sR9MX9zbhiG9Rj2DSZLgeUg1Gn1t8LEqbQLaOC76ggNs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731296999; c=relaxed/simple;
	bh=fmg4nz1lEdglbi7lTo/vPpkfi5F7BD48QJkCX1tTUgo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Nt1ROgrkmDq29y6WAXUrgSox+i30YZQ2qzlXrRjxmFXf0EMmEdtO4ll1/G+1liYcxuULaSKBk0pxye5EmTUvz9nzPN7P3TSZBnZ8M1PLLY/Qu1ycAE6ckh2gnpoI2dOwtZzn+66bw2Ts+r9C4GgvISQIbK5c+iKOoKu63sb/aGA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=archlinuxcn.org; spf=pass smtp.mailfrom=archlinuxcn.org; dkim=pass (2048-bit key) header.d=archlinuxcn.org header.i=@archlinuxcn.org header.b=mJXid80C; arc=none smtp.client-ip=104.245.9.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=archlinuxcn.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=archlinuxcn.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=archlinuxcn.org header.i=@archlinuxcn.org header.b="mJXid80C"
DKIM-Signature: a=rsa-sha256; bh=8Lz+ugmXF9zRGIVTc6Q55qwrbOmISuOLKuKSk/+trGs=;
 c=relaxed/relaxed; d=archlinuxcn.org;
 h=Subject:Subject:Sender:To:To:Cc:Cc:From:From:Date:Date:MIME-Version:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Transfer-Encoding:Reply-To:In-Reply-To:In-Reply-To:Message-Id:Message-Id:References:References:Autocrypt:Openpgp;
 i=@archlinuxcn.org; s=default; t=1731296965; v=1; x=1731728965;
 b=mJXid80CPq2G37ORppcfBwgewmJoQJgP7l/eXArVwLKwrUe9uv1SQHWAykuEm3OIEbblR/En
 roObpApTab0T87pQOMAV8SbWLXOxnv2/YpUhvF8/qE8/ReY1+uBtEa8s9OLe0soYjN76uVll/tp
 xAgDDL0Crc1oOgynyJ4DDGXQajk7DDX5f7QlmRSsXooEyRzFMNUMoNzavTUoeSxB+Hh90bNNyyE
 HfBzTksUeuZ99Aios1kuY1LklupxsZ/SQWpmsk3nUV1gSHX3ZLDJwx99m4o9z54r11n7Gm/cs5N
 8zsLFSL908IJFMkr1j6NuDm4ErBalvp8C8uH5zcr8uM9A==
Received: by wiki.archlinuxcn.org (envelope-sender
 <integral@archlinuxcn.org>) with ESMTPS id 93c8cc52; Mon, 11 Nov 2024
 11:49:25 +0800
From: Integral <integral@archlinuxcn.org>
To: lihongbo22@huawei.com
Cc: integral@archlinuxcn.org,
	kent.overstreet@gmail.com,
	kent.overstreet@linux.dev,
	linux-bcachefs@vger.kernel.org,
	mmpgouride@gmail.com
Subject: [PATCH v2 combined] bcachefs-tools: add fs_usage & return -EINVAL when no matching subcommand
Date: Mon, 11 Nov 2024 11:49:17 +0800
Message-ID: <20241111034917.41805-1-integral@archlinuxcn.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <5484f8dd-da46-4d95-8a8a-e0d51778b414@huawei.com>
References: <5484f8dd-da46-4d95-8a8a-e0d51778b414@huawei.com>
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
 c_src/cmd_fs.c   | 12 ++++++++++++
 c_src/cmds.h     |  1 +
 3 files changed, 21 insertions(+), 7 deletions(-)

diff --git a/c_src/bcachefs.c b/c_src/bcachefs.c
index 77bf6215..89e13b75 100644
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
@@ -146,7 +145,8 @@ int device_cmds(int argc, char *argv[])
 	if (!strcmp(cmd, "resize-journal"))
 		return cmd_device_resize_journal(argc, argv);

-	return 0;
+	device_usage();
+	return -EINVAL;
 }

 int data_cmds(int argc, char *argv[])
@@ -160,5 +160,6 @@ int data_cmds(int argc, char *argv[])
 	if (!strcmp(cmd, "job"))
 		return cmd_data_job(argc, argv);

-	return 0;
+	data_usage();
+	return -EINVAL;
 }
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


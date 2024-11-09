Received: from wiki.archlinuxcn.org (wiki.archlinuxcn.org [104.245.9.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AF8B13BC35
	for <linux-bcachefs@vger.kernel.org>; Sat,  9 Nov 2024 18:50:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=104.245.9.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731178220; cv=none; b=arSm69SSjqBJKudGNQ8/i6gAucCQ4SeUZE6UG5fSRcHqSbJT8a2dOso180G6KKsmzPE3qUVeiX5dAwwuLH0C/YicOoSFQ+l+PElA7K3uccbb2jxCxX5CjlEqdHbzAKnR4jNHz52SZ5WKmqFx9ThwdZPXChUZZr6H9xjsYsVeDc0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731178220; c=relaxed/simple;
	bh=cvhZCeCTuJYexJkH5VSO2XfdpDi3ZaOXODiz/F11P+M=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ArEgqxvSG8uO7ikCOS19OnNYTcT7ww/QrEWXHq3VbbIGUZY31ze3GvT5q6/T3X6jdi0NlS9RiOAIeWtzrnzOoNUfqgDq+yyFM/I5sBba8U4+a6Wm4SBvJMvsFvNzo4WcHvFpUlQ6NeawxBYesHPjTDdocJRxYSluYIsx+8dlDms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=archlinuxcn.org; spf=pass smtp.mailfrom=archlinuxcn.org; dkim=pass (2048-bit key) header.d=archlinuxcn.org header.i=@archlinuxcn.org header.b=Z33Ohong; arc=none smtp.client-ip=104.245.9.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=archlinuxcn.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=archlinuxcn.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=archlinuxcn.org header.i=@archlinuxcn.org header.b="Z33Ohong"
DKIM-Signature: a=rsa-sha256; bh=Xco5LYOL5VXXKt8oPkpGGLeCsBqmwIhvpFC+EJVsbyU=;
 c=relaxed/relaxed; d=archlinuxcn.org;
 h=Subject:Subject:Sender:To:To:Cc:Cc:From:From:Date:Date:MIME-Version:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Transfer-Encoding:Reply-To:In-Reply-To:Message-Id:Message-Id:References:Autocrypt:Openpgp;
 i=@archlinuxcn.org; s=default; t=1731178035; v=1; x=1731610035;
 b=Z33Ohong0xbSLWj6a+OJxxe29f1EFm/G0fz8H0Lntmm6/Gxnv1O9uPF7ltir4txMoNoi0Q/o
 RQ3lR/OmcJ//tAHXcatJcKCxax2wdx4Y7FNzkl+Bu/auJtmNtuec/OLUna3w6oxjt+8wNp8pPV0
 UiqEydDzt9VsPW8Vqk+OB6NJKhXhf2j1POVHlUjxWgdM/3GgCOC2i4pyjXB3soG0QJ2WkT7bTFk
 eMNZ0iFeT9O1+10eziwX2Fn/iXIiSOjI9+JGQTn4tx+WldykcvR/Cciztv44aihnQg0Gv6uku43
 9nEB1rgTQnHdXt+tKfn0kIh4Kh4YS5Mf+dXwGtt/5j71Q==
Received: by wiki.archlinuxcn.org (envelope-sender
 <integral@archlinuxcn.org>) with ESMTPS id a368c4cd; Sun, 10 Nov 2024
 02:47:15 +0800
From: Integral <integral@archlinuxcn.org>
To: kent.overstreet@gmail.com,
	kent.overstreet@linux.dev,
	lihongbo22@huawei.com
Cc: mmpgouride@gmail.com,
	linux-bcachefs@vger.kernel.org,
	integral@archlinuxcn.org
Subject: [PATCH] bcachefs-tools: print usage & return -EINVAL when no matching subcommand
Date: Sun, 10 Nov 2024 02:45:51 +0800
Message-ID: <20241109184550.27953-2-integral@archlinuxcn.org>
X-Mailer: git-send-email 2.47.0
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When matching subcommand doesn't exixt, print usage and
return -EINVAL.

Signed-off-by: Integral <integral@archlinuxcn.org>
---
 c_src/bcachefs.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/c_src/bcachefs.c b/c_src/bcachefs.c
index 77bf6215..a904235d 100644
--- a/c_src/bcachefs.c
+++ b/c_src/bcachefs.c
@@ -120,7 +120,7 @@ int fs_cmds(int argc, char *argv[])
 	if (!strcmp(cmd, "usage"))
 		return cmd_fs_usage(argc, argv);

-	return 0;
+	return -EINVAL;
 }

 int device_cmds(int argc, char *argv[])
@@ -146,7 +146,8 @@ int device_cmds(int argc, char *argv[])
 	if (!strcmp(cmd, "resize-journal"))
 		return cmd_device_resize_journal(argc, argv);

-	return 0;
+	device_usage();
+	return -EINVAL;
 }

 int data_cmds(int argc, char *argv[])
@@ -160,5 +161,6 @@ int data_cmds(int argc, char *argv[])
 	if (!strcmp(cmd, "job"))
 		return cmd_data_job(argc, argv);

-	return 0;
+	data_usage();
+	return -EINVAL;
 }
--
2.47.0


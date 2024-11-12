Received: from szxga06-in.huawei.com (szxga06-in.huawei.com [45.249.212.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 278AD20B1E1
	for <linux-bcachefs@vger.kernel.org>; Tue, 12 Nov 2024 07:48:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731397695; cv=none; b=Rd4kXoqAjc29PAGSe7bjS1IvuLgDKVIuaLiHOvSMkwtywdZapiLI8uSEkpavppiMZWO+09zgzypGICqJSqj1DRMyzQQFBd+dAG0OhiuzaRxEnN6vxdbCmmFW2IbcusKb+v88dSVpP0HPNeYMosDuQMhq4fqIspiGVrc6t8ZtmL8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731397695; c=relaxed/simple;
	bh=/DbU2Db8luGBFqWakwPvjl1Gpg84DLqWxWiPHJYT3+U=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NT2MP6wBZV2jJxAC3NDMJJfhBD1w78ihiOniPyxVkOsbFUizL2XmyB9WJa0t/MwiA99zUoZnaXsUwO0j4qJAI7HexTXgWkmfKYGmd/H/9G1ZHze3sJGiW0+sVqZF+L4k7W7YIOaKfWUJlnilOHCGcihjBHLihVzwbck2D+mKwmI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.17])
	by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4XndnY2b7Bz1ypRh;
	Tue, 12 Nov 2024 15:48:17 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (unknown [7.185.36.66])
	by mail.maildlp.com (Postfix) with ESMTPS id 138E61A0188;
	Tue, 12 Nov 2024 15:48:06 +0800 (CST)
Received: from huawei.com (10.90.53.73) by dggpeml500022.china.huawei.com
 (7.185.36.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.39; Tue, 12 Nov
 2024 15:48:05 +0800
From: Hongbo Li <lihongbo22@huawei.com>
To: <kent.overstreet@linux.dev>
CC: <linux-bcachefs@vger.kernel.org>, <lihongbo22@huawei.com>
Subject: [PATCH v2 2/3] bcachefs: avoid copy from NULL printbuf when allocation failure
Date: Tue, 12 Nov 2024 15:47:44 +0800
Message-ID: <20241112074745.407848-3-lihongbo22@huawei.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20241112074745.407848-1-lihongbo22@huawei.com>
References: <20241112074745.407848-1-lihongbo22@huawei.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggpeml500022.china.huawei.com (7.185.36.66)

printbuf.buf may be NULL if allocation_failure is true. Check
for this prior to using it as a seq_printf source.

Fixes: fa8e94faeece ("bcachefs: Heap allocate printbufs")
Signed-off-by: David Disseldorp <ddiss@suse.de>
Signed-off-by: Hongbo Li <lihongbo22@huawei.com>
---
 fs/bcachefs/fs.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/fs/bcachefs/fs.c b/fs/bcachefs/fs.c
index 91fce04272a1..4dbb46e41509 100644
--- a/fs/bcachefs/fs.c
+++ b/fs/bcachefs/fs.c
@@ -2048,13 +2048,18 @@ static int bch2_show_options(struct seq_file *seq, struct dentry *root)
 {
 	struct bch_fs *c = root->d_sb->s_fs_info;
 	struct printbuf buf = PRINTBUF;
+	int ret;
 
 	bch2_opts_to_text(&buf, c->opts, c, c->disk_sb.sb,
 			  OPT_MOUNT, OPT_HIDDEN, OPT_SHOW_MOUNT_STYLE);
 	printbuf_nul_terminate(&buf);
-	seq_printf(seq, ",%s", buf.buf);
 
-	int ret = buf.allocation_failure ? -ENOMEM : 0;
+	ret = printbuf_err(&buf);
+	if (ret)
+		goto err;
+
+	seq_printf(seq, ",%s", buf.buf);
+err:
 	printbuf_exit(&buf);
 	return ret;
 }
-- 
2.34.1


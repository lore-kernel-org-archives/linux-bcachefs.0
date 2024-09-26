Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2A69C125
	for <linux-bcachefs@vger.kernel.org>; Thu, 26 Sep 2024 01:49:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.190
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727315400; cv=none; b=D5/jsP2bD9XGgNvEihVNlSkF0wwvtxZOyIITfjftUFyDHw6MXWMUOMIvDG3H835DfU3+/7tduNogIsBMaVATkKEigE2nPZ1nIJxLE6PGASaoOiDLjNYhpUaCXX3026f/v6znxhdvWEc+5xVGBMshr39fFyIT5/vUidmXFglln5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727315400; c=relaxed/simple;
	bh=JXMb3xzjgi02/RWRA9kEBQFPXGgKpVj8ouBD8/swxvQ=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=X9h2hDRQZyB6Ij+0NUG+k+26urNFsRwJAAduvMnB502YMeABcJSKq/TbPKD5wZI2OaR4pGqaWVQd/R39ToTHaRWqTQgLoertrnvfvSgdP3brEic3PZsZ0BmAoOp+b36JD2aC9nRefB71GhBgnhbIZNdvXCzCvnxVyo0hKn8Sy70=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.190
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.17])
	by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4XDc3L4HD8z20pWC;
	Thu, 26 Sep 2024 09:49:34 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (unknown [7.185.36.66])
	by mail.maildlp.com (Postfix) with ESMTPS id 95B471A0188;
	Thu, 26 Sep 2024 09:49:56 +0800 (CST)
Received: from huawei.com (10.90.53.73) by dggpeml500022.china.huawei.com
 (7.185.36.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.39; Thu, 26 Sep
 2024 09:49:56 +0800
From: Hongbo Li <lihongbo22@huawei.com>
To: <kent.overstreet@linux.dev>
CC: <linux-bcachefs@vger.kernel.org>, <lihongbo22@huawei.com>,
	<chris.zjh@huawei.com>, <ddiss@suse.de>
Subject: [PATCH v2 1/2] bcachefs: avoid copy from NULL printbuf
Date: Thu, 26 Sep 2024 10:00:00 +0800
Message-ID: <20240926020002.1746333-2-lihongbo22@huawei.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240926020002.1746333-1-lihongbo22@huawei.com>
References: <20240926020002.1746333-1-lihongbo22@huawei.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpeml500022.china.huawei.com (7.185.36.66)

printbuf.buf may be NULL if allocation_failure is true. Check
for this prior to using it as a seq_puts() source.

Fixes: fa8e94faeece ("bcachefs: Heap allocate printbufs")
Signed-off-by: David Disseldorp <ddiss@suse.de>
Signed-off-by: Hongbo Li <lihongbo22@huawei.com>
---
 fs/bcachefs/fs.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/bcachefs/fs.c b/fs/bcachefs/fs.c
index e774cb3e6b1a..d6e26b5056f3 100644
--- a/fs/bcachefs/fs.c
+++ b/fs/bcachefs/fs.c
@@ -1923,13 +1923,16 @@ static int bch2_show_options(struct seq_file *seq, struct dentry *root)
 {
 	struct bch_fs *c = root->d_sb->s_fs_info;
 	struct printbuf buf = PRINTBUF;
+	int ret = 0;
 
 	bch2_opts_to_text(&buf, c->opts, c, c->disk_sb.sb,
 			  OPT_MOUNT, OPT_HIDDEN, OPT_SHOW_MOUNT_STYLE);
 	printbuf_nul_terminate(&buf);
-	seq_puts(seq, buf.buf);
+	if (buf.allocation_failure)
+		ret = -ENOMEM;
+	else
+		seq_puts(seq, buf.buf);
 
-	int ret = buf.allocation_failure ? -ENOMEM : 0;
 	printbuf_exit(&buf);
 	return ret;
 }
-- 
2.34.1


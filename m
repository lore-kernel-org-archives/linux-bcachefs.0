Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 662CE16D4E6
	for <linux-bcachefs@vger.kernel.org>; Fri, 13 Dec 2024 04:03:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.255
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734062611; cv=none; b=mMFtnlRWmxa84k2/Kfqqb3VJd1NmV90v9jRfVchtOq0fMJOcPST+lbBeq36QYuQF5FywQplbHvjK37FQ9HEJ3og6x6Hz1uC9IRwwcskoq/RgGHFYE59qCFBgR/EFUUpTDs/VZpoHgKVZM0qby9KIUtr5jnlBrBQFF4cpvA6WHJs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734062611; c=relaxed/simple;
	bh=wmqfUQy3DjxkCJyix6KaOovBcl/clk1AYrz0OMbbomo=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Z2D3Xx8BQN5piLk07cuLnKXG486zKFmMPc4eiJjf1cVapOFvYP+gYc96TsHShq2dkHOA/vIPadpr79xQU1dCYeF1jK46gMOMv0VfJYNjfOJrPVOlnVHEf7aN+m9UvZaDdXnX22q324tNbC650oHfdNq2TlPaA+rjtqsoBsDE+vg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.255
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.194])
	by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4Y8bG42pGKz1V643;
	Fri, 13 Dec 2024 12:00:12 +0800 (CST)
Received: from kwepemo500009.china.huawei.com (unknown [7.202.194.199])
	by mail.maildlp.com (Postfix) with ESMTPS id 405A8140154;
	Fri, 13 Dec 2024 12:03:20 +0800 (CST)
Received: from huawei.com (10.90.53.73) by kwepemo500009.china.huawei.com
 (7.202.194.199) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Fri, 13 Dec
 2024 12:03:19 +0800
From: Hongbo Li <lihongbo22@huawei.com>
To: <kent.overstreet@linux.dev>
CC: <lihongbo22@huawei.com>, <linux-bcachefs@vger.kernel.org>
Subject: [PATCH v3 2/3] bcachefs: avoid copy from NULL printbuf when allocation failure
Date: Fri, 13 Dec 2024 12:03:27 +0800
Message-ID: <20241213040328.2921159-3-lihongbo22@huawei.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20241213040328.2921159-1-lihongbo22@huawei.com>
References: <20241213040328.2921159-1-lihongbo22@huawei.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 kwepemo500009.china.huawei.com (7.202.194.199)

printbuf.buf may be NULL if allocation_failure is true. Check
for this prior to using it as a seq_printf source.

Fixes: fa8e94faeece ("bcachefs: Heap allocate printbufs")
Signed-off-by: Hongbo Li <lihongbo22@huawei.com>
---
 fs/bcachefs/fs.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/fs/bcachefs/fs.c b/fs/bcachefs/fs.c
index 3f83f131d0e8..c916a12eef15 100644
--- a/fs/bcachefs/fs.c
+++ b/fs/bcachefs/fs.c
@@ -2062,13 +2062,18 @@ static int bch2_show_options(struct seq_file *seq, struct dentry *root)
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


Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA3CCD528
	for <linux-bcachefs@vger.kernel.org>; Mon, 23 Sep 2024 09:40:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727084411; cv=none; b=Rd/uC6vN8uOGsHus4BNIQ7hSE9KRKdIrbsOIuRf5RcZM5MoKT9UfIwPeZEXCzW0lthcQFBa4GeioH90uDOmOrjSQ/v1XAkblc879m567oXuEj2E1PxWQApCjujVJ63FN7ATx576NnX1wixlehit2IH77g91Q9lOq91QZmwYToY8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727084411; c=relaxed/simple;
	bh=p/Ta7Ks0vEqc1ykflQRoiq+RQCWWA8CQ/Am3Vl5HKLk=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=ExGm+ldUPa1TzDkR3iMaajRC1YFNztd1o8x58VB7BC93JMGimhE8R2dHgXOD3ZfTvrqQigE7NMcIRseKpIuF6h1HMBW5m4bURp2zd3iTm4nEGi0Sfkcb4rNvDJt2UaFhormlnnJuIoCIdsAtUYBV/6MaojkM17hUsVCKOc2tzJo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.162.254])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4XBybG4V9mzpWFW;
	Mon, 23 Sep 2024 17:38:02 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (unknown [7.185.36.66])
	by mail.maildlp.com (Postfix) with ESMTPS id A8782180106;
	Mon, 23 Sep 2024 17:40:05 +0800 (CST)
Received: from huawei.com (10.90.53.73) by dggpeml500022.china.huawei.com
 (7.185.36.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.39; Mon, 23 Sep
 2024 17:40:05 +0800
From: Hongbo Li <lihongbo22@huawei.com>
To: <kent.overstreet@linux.dev>
CC: <linux-bcachefs@vger.kernel.org>, <lihongbo22@huawei.com>,
	<liaochang1@huawei.com>
Subject: [PATCH] bcachefs: fix incorrect show_options results
Date: Mon, 23 Sep 2024 17:50:03 +0800
Message-ID: <20240923095003.3559171-1-lihongbo22@huawei.com>
X-Mailer: git-send-email 2.34.1
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

When call show_options in bcachefs, the options buffer is appeneded
to the seq variable. In fact, it requires an additional comma to be
appended first. This will affect the remount process when reading
existing mount options.

Fixes: 9305cf91d05e ("bcachefs: bch2_opts_to_text()")
Signed-off-by: Hongbo Li <lihongbo22@huawei.com>
---
 fs/bcachefs/fs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/bcachefs/fs.c b/fs/bcachefs/fs.c
index e774cb3e6b1a..79c3a650b714 100644
--- a/fs/bcachefs/fs.c
+++ b/fs/bcachefs/fs.c
@@ -1927,7 +1927,7 @@ static int bch2_show_options(struct seq_file *seq, struct dentry *root)
 	bch2_opts_to_text(&buf, c->opts, c, c->disk_sb.sb,
 			  OPT_MOUNT, OPT_HIDDEN, OPT_SHOW_MOUNT_STYLE);
 	printbuf_nul_terminate(&buf);
-	seq_puts(seq, buf.buf);
+	seq_printf(seq, ",%s", buf.buf);
 
 	int ret = buf.allocation_failure ? -ENOMEM : 0;
 	printbuf_exit(&buf);
-- 
2.34.1


Received: from szxga07-in.huawei.com (szxga07-in.huawei.com [45.249.212.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CEFD2420B
	for <linux-bcachefs@vger.kernel.org>; Mon, 19 Feb 2024 09:55:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.35
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708336525; cv=none; b=FFV/GCgW2Rl6MD+/tJdWlW7dtcgY3jxitAiPe4Wy0sdTsEx3GC3ItvClFMtrHe1eYe1AZNIXTxPdF//BwABb1rUkwRjxTci3LNfoSEfmiSV1ifcgG5rdBuj23A+LKW2jFUBxWRkGBPUE+K8PZm6AaXTzfXRn7EyE1Mk2tLs9o+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708336525; c=relaxed/simple;
	bh=Ub3GOvSlVmTqcFpt+f5Lsqs0TVS8LvlssILEKsLmKSo=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=BNH7waOt/K/ocFKuZf1rFZLi4rzCmFSTpcRBt1+202SE0pBBmc9KL9qWWwmfeoKPtm4xDe3rcNxoqc5M1mkyse1own9i5xnM4lPmKMEHBO96b1swsfdYuOy8JhhDqxfja9ajgF/1tSwmR2ZrX/EdJyKmeZ/tViFQus+/XTxV57g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.163])
	by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4TddBw3wx4z1X2p9;
	Mon, 19 Feb 2024 17:53:12 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (unknown [7.185.36.66])
	by mail.maildlp.com (Postfix) with ESMTPS id EC74D18002D;
	Mon, 19 Feb 2024 17:55:19 +0800 (CST)
Received: from huawei.com (10.90.53.73) by dggpeml500022.china.huawei.com
 (7.185.36.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Mon, 19 Feb
 2024 17:55:19 +0800
From: Hongbo Li <lihongbo22@huawei.com>
To: <kent.overstreet@linux.dev>
CC: <bfoster@redhat.com>, <linux-bcachefs@vger.kernel.org>,
	<ruanjinjie@huawei.com>, <lihongbo22@huawei.com>
Subject: [PATCH] bcachefs: fix the error code when mounting with incorrect options.
Date: Mon, 19 Feb 2024 17:54:33 +0800
Message-ID: <20240219095433.2566106-1-lihongbo22@huawei.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpeml500022.china.huawei.com (7.185.36.66)

When mount with incorrect options such as:
"mount -t bcachefs -o errors=back /dev/loop1 /mnt/bcachefs/".
It rebacks the error "mount: /mnt/bcachefs: permission denied."
 cause bch2_parse_mount_opts returns -1 and bch2_mount throws
it up. This is unreasonable.

The real error message should be like this:
"mount: /mnt/bcachefs: wrong fs type, bad option, bad
superblock on /dev/loop1, missing codepage or helper program,
or other error."

Signed-off-by: Hongbo Li <lihongbo22@huawei.com>
---
 fs/bcachefs/opts.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/bcachefs/opts.c b/fs/bcachefs/opts.c
index b1ed0b9a20d3..a9ee9eaab670 100644
--- a/fs/bcachefs/opts.c
+++ b/fs/bcachefs/opts.c
@@ -456,7 +456,7 @@ int bch2_parse_mount_opts(struct bch_fs *c, struct bch_opts *opts,
 
 	copied_opts = kstrdup(options, GFP_KERNEL);
 	if (!copied_opts)
-		return -1;
+		return -ENOMEM;
 	copied_opts_start = copied_opts;
 
 	while ((opt = strsep(&copied_opts, ",")) != NULL) {
@@ -501,11 +501,11 @@ int bch2_parse_mount_opts(struct bch_fs *c, struct bch_opts *opts,
 
 bad_opt:
 	pr_err("Bad mount option %s", name);
-	ret = -1;
+	ret = -EINVAL;
 	goto out;
 bad_val:
 	pr_err("Invalid mount option %s", err.buf);
-	ret = -1;
+	ret = -EINVAL;
 	goto out;
 out:
 	kfree(copied_opts_start);
-- 
2.34.1


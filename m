Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CB9F2B9A8
	for <linux-bcachefs@vger.kernel.org>; Fri, 13 Dec 2024 04:03:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734062612; cv=none; b=ENu0YjmT2d8rbMOEJm0r5YRShc17jTt7iCOtZOeyQoFjgFro+TtvOXbIf5qOP4Lp0tUDOUOyitBN9spIK4XwZBKT/cW16qASqRSsxQHxumG9n4UZXZgSIqPcbpcQrQyLMX3Zh80lEd+EZ/9yXCMTq2wcqMrH5fC+iimAKUZVJNo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734062612; c=relaxed/simple;
	bh=F8uBTS78eMogKUxiFEDSItsDiMS31smrDp55IE9EaOQ=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oY4CA9DXgvDZdLlFqRun7Wybterk4lq+MuS1QmXG2c7ZaA8qpaeLOuFWeljI6Ess6N8BH1ipKk59Zq4XqWVa4AJl94F+Sgindwbshhuo9ht15vgWZ8Lq2iHJHNvbKgtxO2ieQ//S1Byq50rraca0pSoU6Y9MZtlak+y5+HB69qY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.252])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4Y8bHd4hkyzqTpN;
	Fri, 13 Dec 2024 12:01:33 +0800 (CST)
Received: from kwepemo500009.china.huawei.com (unknown [7.202.194.199])
	by mail.maildlp.com (Postfix) with ESMTPS id 936461800D9;
	Fri, 13 Dec 2024 12:03:20 +0800 (CST)
Received: from huawei.com (10.90.53.73) by kwepemo500009.china.huawei.com
 (7.202.194.199) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Fri, 13 Dec
 2024 12:03:20 +0800
From: Hongbo Li <lihongbo22@huawei.com>
To: <kent.overstreet@linux.dev>
CC: <lihongbo22@huawei.com>, <linux-bcachefs@vger.kernel.org>
Subject: [PATCH v3 3/3] bcachefs: use printbuf_err helper
Date: Fri, 13 Dec 2024 12:03:28 +0800
Message-ID: <20241213040328.2921159-4-lihongbo22@huawei.com>
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

Obtain printbuf failure status with printbuf_err helper.

Signed-off-by: Hongbo Li <lihongbo22@huawei.com>
---
 fs/bcachefs/opts.c  | 7 +------
 fs/bcachefs/sysfs.c | 4 +---
 2 files changed, 2 insertions(+), 9 deletions(-)

diff --git a/fs/bcachefs/opts.c b/fs/bcachefs/opts.c
index 6772faf385a5..f3741c41dd17 100644
--- a/fs/bcachefs/opts.c
+++ b/fs/bcachefs/opts.c
@@ -545,12 +545,7 @@ int bch2_parse_one_mount_opt(struct bch_fs *c, struct bch_opts *opts,
 	ret = bch2_opt_parse(c, &bch2_opt_table[id], val, &v, &err);
 	if (ret == -BCH_ERR_option_needs_open_fs && parse_later) {
 		prt_printf(parse_later, "%s=%s,", name, val);
-		if (parse_later->allocation_failure) {
-			ret = -ENOMEM;
-			goto out;
-		}
-
-		ret = 0;
+		ret = printbuf_err(parse_later);
 		goto out;
 	}
 
diff --git a/fs/bcachefs/sysfs.c b/fs/bcachefs/sysfs.c
index a7eb1f511484..9743e6f406bf 100644
--- a/fs/bcachefs/sysfs.c
+++ b/fs/bcachefs/sysfs.c
@@ -63,9 +63,7 @@ static ssize_t fn ## _show(struct kobject *kobj, struct attribute *attr,\
 	if (out.pos && out.buf[out.pos - 1] != '\n')			\
 		prt_newline(&out);					\
 									\
-	if (!ret && out.allocation_failure)				\
-		ret = -ENOMEM;						\
-									\
+	ret = ret ?: printbuf_err(&out);				\
 	if (!ret) {							\
 		ret = min_t(size_t, out.pos, PAGE_SIZE - 1);		\
 		memcpy(buf, out.buf, ret);				\
-- 
2.34.1


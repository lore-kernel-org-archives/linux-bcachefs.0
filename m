Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 425AC621
	for <linux-bcachefs@vger.kernel.org>; Tue, 29 Oct 2024 12:54:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.190
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730206482; cv=none; b=qMpYcyWlSOJ6img4YHcUHEUuz7yJYxnAhbcU+W4ViGgpXKShkPmmB8DcrbjLOUxIp8L7x9UfeiZemqtwNwWgcfr06ASeXbtaUDV6hghSBoGlvnEmJALMtSGgNSapZOMM81ieGYqCLYYSdqwoeaQ287COfoXcHMuiOLDd5cBv7aw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730206482; c=relaxed/simple;
	bh=BEGDaZmmTaulhFAEDHGgIaEuUYY4FylYrslzWjNT5A4=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=cyPuQbwTOLyDMSmVEcSNLifhTFtqFYMIQy4yvuM2IdO6WRhGaMEWELsKsFJAdDqSg/u6ZzuZRN+Yg0kQCyhoJ6SqSEUA7Uaqu7/EE6GaPK6MHobvsl5NWq98mAi8QkAxce8dWf6BcL70Rat1IqtDTtKszJ0PURUo/Z/IJb29pOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.190
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.162.112])
	by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4Xd9DK0n9wz20r5M;
	Tue, 29 Oct 2024 20:53:37 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (unknown [7.185.36.66])
	by mail.maildlp.com (Postfix) with ESMTPS id 7649814013B;
	Tue, 29 Oct 2024 20:54:35 +0800 (CST)
Received: from huawei.com (10.90.53.73) by dggpeml500022.china.huawei.com
 (7.185.36.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.39; Tue, 29 Oct
 2024 20:54:35 +0800
From: Hongbo Li <lihongbo22@huawei.com>
To: <kent.overstreet@linux.dev>
CC: <linux-bcachefs@vger.kernel.org>, <lihongbo22@huawei.com>
Subject: [PATCH] bcachefs: use attribute define helper for sysfs attribute
Date: Tue, 29 Oct 2024 20:54:08 +0800
Message-ID: <20241029125408.3013288-1-lihongbo22@huawei.com>
X-Mailer: git-send-email 2.34.1
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

The sysfs attribute definition has been wrapped into macro:
rw_attribute, read_attribute and write_attribute, we can
use these helpers to uniform the attribute definition.

Signed-off-by: Hongbo Li <lihongbo22@huawei.com>
---
 fs/bcachefs/sysfs.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/fs/bcachefs/sysfs.c b/fs/bcachefs/sysfs.c
index 4ab0ccba2ab5..50c9743306a2 100644
--- a/fs/bcachefs/sysfs.c
+++ b/fs/bcachefs/sysfs.c
@@ -211,6 +211,7 @@ BCH_PERSISTENT_COUNTERS()
 #undef x
 
 rw_attribute(discard);
+read_attribute(state);
 rw_attribute(label);
 
 read_attribute(copy_gc_wait);
@@ -235,11 +236,6 @@ write_attribute(perf_test);
 	BCH_TIME_STATS()
 #undef x
 
-static struct attribute sysfs_state_rw = {
-	.name = "state",
-	.mode =  0444,
-};
-
 static size_t bch2_btree_cache_size(struct bch_fs *c)
 {
 	struct btree_cache *bc = &c->btree_cache;
@@ -774,7 +770,7 @@ SHOW(bch2_dev)
 		prt_char(out, '\n');
 	}
 
-	if (attr == &sysfs_state_rw) {
+	if (attr == &sysfs_state) {
 		prt_string_option(out, bch2_member_states, ca->mi.state);
 		prt_char(out, '\n');
 	}
@@ -854,7 +850,7 @@ struct attribute *bch2_dev_files[] = {
 
 	/* settings: */
 	&sysfs_discard,
-	&sysfs_state_rw,
+	&sysfs_state,
 	&sysfs_label,
 
 	&sysfs_has_data,
-- 
2.34.1


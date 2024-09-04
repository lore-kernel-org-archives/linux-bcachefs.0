Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB2A6130ADA
	for <linux-bcachefs@vger.kernel.org>; Wed,  4 Sep 2024 07:22:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.191
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725434538; cv=none; b=Rhfrj/Kr59ohB+0TSRr6VlZUY3lsv8rXZJLD63TLXmcyX4eI0mOjSQTc52vtIrHA4qPtfzsASVcweaDIemc5FvNpG00busXDP77yPWI4u1FEvr0dvdLQjFyhEobyYfP1hYUNIuIdptHwkdkyvzvJdsC2DiCKkUD9XqX/iTSvNtw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725434538; c=relaxed/simple;
	bh=8o8NEzex7ADthEtlSDUy+3pcrZiNlmWIqT1ZP0LmHKM=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=k/H6Tt4+GGynZwivRM5ngKjftkKN+b1Imud2UD125BF5X2x2e0edLoBn4GC0RbJU0MMUChfOkg/ezeKhFROpR9kJ+nh/RbW5Ps3w/PPqSIyDv5ny4qtJYEdQqVinPx4UhdtMNiiVPZkTE0AoqLoqV6T4dr9G2aKlZtnn116DV/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.191
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.44])
	by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4WzD3m0Bw2z1HJ89;
	Wed,  4 Sep 2024 15:03:32 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (unknown [7.185.36.66])
	by mail.maildlp.com (Postfix) with ESMTPS id 578F314011D;
	Wed,  4 Sep 2024 15:06:59 +0800 (CST)
Received: from huawei.com (10.90.53.73) by dggpeml500022.china.huawei.com
 (7.185.36.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.39; Wed, 4 Sep
 2024 15:06:59 +0800
From: Hongbo Li <lihongbo22@huawei.com>
To: <kent.overstreet@linux.dev>
CC: <linux-bcachefs@vger.kernel.org>, <lihongbo22@huawei.com>
Subject: [PATCH] bcachefs: Fix compilation error for bch2_sb_member_alloc
Date: Wed, 4 Sep 2024 15:15:32 +0800
Message-ID: <20240904071532.2812271-1-lihongbo22@huawei.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpeml500022.china.huawei.com (7.185.36.66)

Fix the following compilation error:

```
fs/bcachefs/sb-members.c: In function ‘bch2_sb_member_alloc’:
fs/bcachefs/sb-members.c:508:2: error: a label can only be part of a statement and a declaration is not a statement
  508 |  unsigned nr_devices = max_t(unsigned, dev_idx + 1, c->sb.nr_devices);
```

Fixes: a7d364a133c7 ("bcachefs: bch2_sb_member_alloc()")
Signed-off-by: Hongbo Li <lihongbo22@huawei.com>
---
 fs/bcachefs/sb-members.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/fs/bcachefs/sb-members.c b/fs/bcachefs/sb-members.c
index 2aad62961938..02bcde3c1b02 100644
--- a/fs/bcachefs/sb-members.c
+++ b/fs/bcachefs/sb-members.c
@@ -478,11 +478,15 @@ unsigned bch2_sb_nr_devices(const struct bch_sb *sb)
 int bch2_sb_member_alloc(struct bch_fs *c)
 {
 	unsigned dev_idx = c->sb.nr_devices;
+	struct bch_sb_field_members_v2 *mi;
+	unsigned nr_devices;
+	unsigned u64s;
+	int best = -1;
+	u64 best_last_mount = 0;
+
 	if (dev_idx < BCH_SB_MEMBERS_MAX)
 		goto have_slot;
 
-	int best = -1;
-	u64 best_last_mount = 0;
 	for (dev_idx = 0; dev_idx < BCH_SB_MEMBERS_MAX; dev_idx++) {
 		/* eventually BCH_SB_MEMBERS_MAX will be raised */
 		if (dev_idx == BCH_SB_MEMBER_INVALID)
@@ -505,11 +509,11 @@ int bch2_sb_member_alloc(struct bch_fs *c)
 
 	return -BCH_ERR_ENOSPC_sb_members;
 have_slot:
-	unsigned nr_devices = max_t(unsigned, dev_idx + 1, c->sb.nr_devices);
+	nr_devices = max_t(unsigned, dev_idx + 1, c->sb.nr_devices);
 
-	struct bch_sb_field_members_v2 *mi = bch2_sb_field_get(c->disk_sb.sb, members_v2);
-	unsigned u64s = DIV_ROUND_UP(sizeof(struct bch_sb_field_members_v2) +
-				     le16_to_cpu(mi->member_bytes) * nr_devices, sizeof(u64));
+	mi = bch2_sb_field_get(c->disk_sb.sb, members_v2);
+	u64s = DIV_ROUND_UP(sizeof(struct bch_sb_field_members_v2) +
+			    le16_to_cpu(mi->member_bytes) * nr_devices, sizeof(u64));
 
 	mi = bch2_sb_field_resize(&c->disk_sb, members_v2, u64s);
 	if (!mi)
-- 
2.34.1


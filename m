Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7CD1946F
	for <linux-bcachefs@vger.kernel.org>; Wed, 25 Sep 2024 02:17:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.255
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727230681; cv=none; b=ER6sIktnnCc4Gv5eoEkAE73T8iP2stS/f7jKHfbi2C3tzoM/hXv1zQbuiVHyok/wt4UDZxZyskY7dWTLZ0/YR0nrttjbrSu5wCIBNRtwzUyjmM2ZkocedhyrYFHeONctdqepQiTN3xYDN6FbmDyHtCST10dRjuTcbOCqKmLBcBo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727230681; c=relaxed/simple;
	bh=1tL1zQqCSMkYofgqCYvPMdhWjbyoymaMq4H4A+xKFOM=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=NWZc8LtM/5lM6Q3Z8AmduYNj1C02OaxHDnU239qKmaPBjEqzFHsDO1EEG8rOVcbkxycIPf/AZFXKbdDNYwWSQZJJ7Ud3Zd6uyGfHU5Zh1ROHg6GtOoGZo2DE/DB2rQvUAnugo7h4WYWBT19BnX3MIiCDYzYb7ibccYexYtSXxM8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.255
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.252])
	by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4XD0hn11Zhz1T7tT;
	Wed, 25 Sep 2024 10:16:25 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (unknown [7.185.36.66])
	by mail.maildlp.com (Postfix) with ESMTPS id A60FC180AE8;
	Wed, 25 Sep 2024 10:17:49 +0800 (CST)
Received: from huawei.com (10.90.53.73) by dggpeml500022.china.huawei.com
 (7.185.36.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.39; Wed, 25 Sep
 2024 10:17:49 +0800
From: Hongbo Li <lihongbo22@huawei.com>
To: <kent.overstreet@linux.dev>
CC: <linux-bcachefs@vger.kernel.org>, <lihongbo22@huawei.com>,
	<chris.zjh@huawei.com>
Subject: [PATCH] bcachefs: check the return code when set upgrade extra
Date: Wed, 25 Sep 2024 10:27:59 +0800
Message-ID: <20240925022759.3819978-1-lihongbo22@huawei.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpeml500022.china.huawei.com (7.185.36.66)

In bch2_sb_set_upgrade_extra, it checks the metadata version for
stripes. If it needs to write super, bch2_write_super will be done.
But this pharse may be incorrect, and the original code didn't keep
the error code. We should check the return code in this case.

Fixes: 7773df19c35f ("bcachefs: metadata version bucket_stripe_sectors")
Signed-off-by: Hongbo Li <lihongbo22@huawei.com>
---
 fs/bcachefs/recovery.c     | 2 ++
 fs/bcachefs/sb-downgrade.c | 8 ++++----
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/fs/bcachefs/recovery.c b/fs/bcachefs/recovery.c
index be1e7ca4362f..31e33f93055f 100644
--- a/fs/bcachefs/recovery.c
+++ b/fs/bcachefs/recovery.c
@@ -855,6 +855,8 @@ int bch2_fs_recovery(struct bch_fs *c)
 	set_bit(BCH_FS_btree_running, &c->flags);
 
 	ret = bch2_sb_set_upgrade_extra(c);
+	if (ret)
+		goto err;
 
 	ret = bch2_run_recovery_passes(c);
 	if (ret)
diff --git a/fs/bcachefs/sb-downgrade.c b/fs/bcachefs/sb-downgrade.c
index 6f0493f79959..2acb52d107be 100644
--- a/fs/bcachefs/sb-downgrade.c
+++ b/fs/bcachefs/sb-downgrade.c
@@ -138,7 +138,7 @@ UPGRADE_TABLE()
 #undef x
 };
 
-static int have_stripes(struct bch_fs *c)
+static bool have_stripes(struct bch_fs *c)
 {
 	return !btree_node_fake(c->btree_roots_known[BTREE_ID_stripes].b);
 }
@@ -155,7 +155,7 @@ int bch2_sb_set_upgrade_extra(struct bch_fs *c)
 
 	if (old_version <  bcachefs_metadata_version_bucket_stripe_sectors &&
 	    new_version >= bcachefs_metadata_version_bucket_stripe_sectors &&
-	    (ret = have_stripes(c) > 0)) {
+	    have_stripes(c)) {
 		__set_bit_le64(BCH_RECOVERY_PASS_STABLE_check_allocations, ext->recovery_passes_required);
 		__set_bit_le64(BCH_FSCK_ERR_alloc_key_dirty_sectors_wrong, ext->errors_silent);
 		__set_bit_le64(BCH_FSCK_ERR_alloc_key_stripe_sectors_wrong, ext->errors_silent);
@@ -163,10 +163,10 @@ int bch2_sb_set_upgrade_extra(struct bch_fs *c)
 	}
 
 	if (write_sb)
-		bch2_write_super(c);
+		ret = bch2_write_super(c);
 	mutex_unlock(&c->sb_lock);
 
-	return ret < 0 ? ret : 0;
+	return ret;
 }
 
 void bch2_sb_set_upgrade(struct bch_fs *c,
-- 
2.34.1


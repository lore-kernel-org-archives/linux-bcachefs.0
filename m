Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AF7017C68
	for <linux-bcachefs@vger.kernel.org>; Wed, 11 Sep 2024 01:02:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726016565; cv=none; b=GkOwH3iGQocv/jVivhiJH3k5HED8GSK5NRJ2BA9el8dtuP7Bee+6pkPBtmQsG77hcoPwdIH5Z0fs7x3vo3L1rVUSJ0pW6f31by2e46bc2C1AFnK9I1PwjfDkNCm7JO11UCmhqSEzQYDcL1vQFqm9EhXefdLR+4ZwtaP/vxn7YAc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726016565; c=relaxed/simple;
	bh=5yts8GZ0O8lZbPzyMJu6Pcru4K+5EcCooFGyFSmlF28=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hLsVKPwLkypgYGZo8vwccE8Rz75RD6NWyBaEoicqBzE/IYA0RCqUKavPbNkXPeW+A6icd8Wz0Q0tP20elyGQn8M47y9bpLs2X0It6Jy2rA/y4ap6VxCqsWykTXPAcW0rqqHhqhQlr13aVovM5ydX6dSde29KIx/zfP9WVwA3wTU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.252])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4X3Mgp5v9ZzpVb4;
	Wed, 11 Sep 2024 09:00:38 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (unknown [7.185.36.66])
	by mail.maildlp.com (Postfix) with ESMTPS id 77D4F180AE6;
	Wed, 11 Sep 2024 09:02:41 +0800 (CST)
Received: from huawei.com (10.90.53.73) by dggpeml500022.china.huawei.com
 (7.185.36.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.39; Wed, 11 Sep
 2024 09:02:41 +0800
From: Hongbo Li <lihongbo22@huawei.com>
To: <kent.overstreet@linux.dev>
CC: <linux-bcachefs@vger.kernel.org>, <lihongbo22@huawei.com>,
	<chris.zjh@huawei.com>
Subject: [PATCH v2 2/2] bcachefs: bcachefs_metadata_version_directory_size
Date: Wed, 11 Sep 2024 09:11:42 +0800
Message-ID: <20240911011142.741429-3-lihongbo22@huawei.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240911011142.741429-1-lihongbo22@huawei.com>
References: <20240911011142.741429-1-lihongbo22@huawei.com>
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

This adds another metadata version for accounting directory size.
For the new version of the filesystem, when new subdirectory items
are created or deleted, the parent directory's size will change
accordingly. For the old version of the existed file system, running
fsck will automatically upgrade the metadata version, and it will
do the check and recalculationg of the directory size.

Signed-off-by: Hongbo Li <lihongbo22@huawei.com>
---
 fs/bcachefs/bcachefs_format.h  |  3 ++-
 fs/bcachefs/fsck.c             | 41 ++++++++++++++++++++++++++++++++++
 fs/bcachefs/sb-downgrade.c     |  5 ++++-
 fs/bcachefs/sb-errors_format.h |  1 +
 4 files changed, 48 insertions(+), 2 deletions(-)

diff --git a/fs/bcachefs/bcachefs_format.h b/fs/bcachefs/bcachefs_format.h
index 8c4addddd07e..ef838b47c53d 100644
--- a/fs/bcachefs/bcachefs_format.h
+++ b/fs/bcachefs/bcachefs_format.h
@@ -678,7 +678,8 @@ struct bch_sb_field_ext {
 	x(disk_accounting_v2,		BCH_VERSION(1,  9))		\
 	x(disk_accounting_v3,		BCH_VERSION(1, 10))		\
 	x(disk_accounting_inum,		BCH_VERSION(1, 11))		\
-	x(rebalance_work_acct_fix,	BCH_VERSION(1, 12))
+	x(rebalance_work_acct_fix,	BCH_VERSION(1, 12))		\
+	x(directory_size,		BCH_VERSION(1, 13))
 
 enum bcachefs_metadata_version {
 	bcachefs_metadata_version_min = 9,
diff --git a/fs/bcachefs/fsck.c b/fs/bcachefs/fsck.c
index 9b3470a97546..7c831495fb96 100644
--- a/fs/bcachefs/fsck.c
+++ b/fs/bcachefs/fsck.c
@@ -979,6 +979,37 @@ static bool bch2_inode_open(struct bch_fs *c, struct bpos p)
 	return __bch2_inode_hash_find(c, inum) != NULL;
 }
 
+static int check_directory_size(struct btree_trans *trans,
+				struct bch_inode_unpacked *inode_u,
+				struct bkey_s_c inode_k, bool *write_inode)
+{
+	struct btree_iter iter;
+	struct bkey_s_c k;
+	u64 new_size = 0;
+	int ret;
+
+	for_each_btree_key_upto_norestart(trans, iter, BTREE_ID_dirents,
+				SPOS(inode_k.k->p.offset, 0, inode_k.k->p.snapshot),
+				POS(inode_k.k->p.offset, U64_MAX),
+				0, k, ret) {
+		if (k.k->type != KEY_TYPE_dirent)
+			continue;
+
+		struct bkey_s_c_dirent dirent = bkey_s_c_to_dirent(k);
+		struct qstr name = bch2_dirent_get_name(dirent);
+
+		new_size += dirent_occupied_size(&name);
+	}
+	bch2_trans_iter_exit(trans, &iter);
+
+	if (!ret && inode_u->bi_size != new_size) {
+		inode_u->bi_size = new_size;
+		*write_inode = true;
+	}
+
+	return ret;
+}
+
 static int check_inode(struct btree_trans *trans,
 		       struct btree_iter *iter,
 		       struct bkey_s_c k,
@@ -1170,6 +1201,16 @@ static int check_inode(struct btree_trans *trans,
 			do_update = true;
 		}
 	}
+
+	if (S_ISDIR(u.bi_mode)) {
+		ret = check_directory_size(trans, &u, k, &do_update);
+
+		fsck_err_on(ret,
+			    trans, directory_size_mismatch,
+			    "directory inode %llu:%u with the mismatch directory size",
+			    u.bi_inum, k.k->p.snapshot);
+		ret = 0;
+	}
 do_update:
 	if (do_update) {
 		ret = __bch2_fsck_write_inode(trans, &u, iter->pos.snapshot);
diff --git a/fs/bcachefs/sb-downgrade.c b/fs/bcachefs/sb-downgrade.c
index c7e4cdd3f6a5..9d12359aecb9 100644
--- a/fs/bcachefs/sb-downgrade.c
+++ b/fs/bcachefs/sb-downgrade.c
@@ -78,7 +78,10 @@
 	  BCH_FSCK_ERR_accounting_mismatch)			\
 	x(rebalance_work_acct_fix,				\
 	  BIT_ULL(BCH_RECOVERY_PASS_check_allocations),		\
-	  BCH_FSCK_ERR_accounting_mismatch)
+	  BCH_FSCK_ERR_accounting_mismatch)			\
+	x(directory_size,					\
+	  BIT_ULL(BCH_RECOVERY_PASS_check_inodes),		\
+	  BCH_FSCK_ERR_directory_size_mismatch)
 
 #define DOWNGRADE_TABLE()					\
 	x(bucket_stripe_sectors,				\
diff --git a/fs/bcachefs/sb-errors_format.h b/fs/bcachefs/sb-errors_format.h
index f0c14702f9e6..380f5f34efc6 100644
--- a/fs/bcachefs/sb-errors_format.h
+++ b/fs/bcachefs/sb-errors_format.h
@@ -292,6 +292,7 @@ enum bch_fsck_flags {
 	x(accounting_key_replicas_nr_devs_0,			278,	FSCK_AUTOFIX)	\
 	x(accounting_key_replicas_nr_required_bad,		279,	FSCK_AUTOFIX)	\
 	x(accounting_key_replicas_devs_unsorted,		280,	FSCK_AUTOFIX)	\
+	x(directory_size_mismatch,				281,	FSCK_AUTOFIX)	\
 
 enum bch_sb_error_id {
 #define x(t, n, ...) BCH_FSCK_ERR_##t = n,
-- 
2.34.1


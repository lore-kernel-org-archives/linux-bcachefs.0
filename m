Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C6181DF749
	for <linux-bcachefs@vger.kernel.org>; Tue,  7 Jan 2025 13:27:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.191
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736256468; cv=none; b=uvM/CKxm1UxPR96+Ncv6Zx5FRXF/F1s8tvq++qZ05Hu4we859r0Xeev6qo4L2W5irvuaLHVTr97Y47R1htWLfYerRKdSigQxaCOlUKSRT7vaYbEyle/IeXXJXlet+HFGz5vcCyL5bUpn59h4TKkMSHD7sFZ7XXMngQ21tW3K46Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736256468; c=relaxed/simple;
	bh=vq97cAzOw5srpch3AaE/6oKKq3v+wf078ejSBNFl8yI=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fEwzbu7iNVNpDo4tRfXzLU9EYajFR2RvlyIcOhnJPneXlvzEXW/AAclHgtROLQLYJttWEBfIipObZv5gKiq0WrTT7JF3Yhf71hP2TG1aSPGRe3Z/gNoOU45DfMAZGXBNKr1u8KKqfbSh1hO/Z4GIfNqWJ86ROfvV/d3kFW7saoE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.191
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.214])
	by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4YSBbl1Cw5z1kxfL;
	Tue,  7 Jan 2025 21:24:35 +0800 (CST)
Received: from kwepemo500009.china.huawei.com (unknown [7.202.194.199])
	by mail.maildlp.com (Postfix) with ESMTPS id 41CE81A016C;
	Tue,  7 Jan 2025 21:27:35 +0800 (CST)
Received: from huawei.com (10.67.174.162) by kwepemo500009.china.huawei.com
 (7.202.194.199) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Tue, 7 Jan
 2025 21:27:34 +0800
From: Hongbo Li <lihongbo22@huawei.com>
To: <kent.overstreet@linux.dev>
CC: <linux-bcachefs@vger.kernel.org>, <lihongbo22@huawei.com>
Subject: [PATCH v3 2/2] bcachefs: bcachefs_metadata_version_directory_size
Date: Tue, 7 Jan 2025 13:18:41 +0000
Message-ID: <20250107131841.91603-3-lihongbo22@huawei.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250107131841.91603-1-lihongbo22@huawei.com>
References: <20250107131841.91603-1-lihongbo22@huawei.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 kwepemo500009.china.huawei.com (7.202.194.199)

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
 fs/bcachefs/sb-errors_format.h |  3 ++-
 4 files changed, 49 insertions(+), 3 deletions(-)

diff --git a/fs/bcachefs/bcachefs_format.h b/fs/bcachefs/bcachefs_format.h
index 0680930508a3..f70f0108401f 100644
--- a/fs/bcachefs/bcachefs_format.h
+++ b/fs/bcachefs/bcachefs_format.h
@@ -685,7 +685,8 @@ struct bch_sb_field_ext {
 	x(reflink_p_may_update_opts,	BCH_VERSION(1, 16))		\
 	x(inode_depth,			BCH_VERSION(1, 17))		\
 	x(persistent_inode_cursors,	BCH_VERSION(1, 18))		\
-	x(autofix_errors,		BCH_VERSION(1, 19))
+	x(autofix_errors,		BCH_VERSION(1, 19))		\
+	x(directory_size,		BCH_VERSION(1, 20))
 
 enum bcachefs_metadata_version {
 	bcachefs_metadata_version_min = 9,
diff --git a/fs/bcachefs/fsck.c b/fs/bcachefs/fsck.c
index 3917d75f3c98..8fcf7c8e5ede 100644
--- a/fs/bcachefs/fsck.c
+++ b/fs/bcachefs/fsck.c
@@ -1116,6 +1116,37 @@ static int get_snapshot_root_inode(struct btree_trans *trans,
 	return ret;
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
+	for_each_btree_key_max_norestart(trans, iter, BTREE_ID_dirents,
+			SPOS(inode_k.k->p.offset, 0, inode_k.k->p.snapshot),
+			POS(inode_k.k->p.offset, U64_MAX),
+			0, k, ret) {
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
@@ -1304,6 +1335,16 @@ static int check_inode(struct btree_trans *trans,
 		u.bi_journal_seq = journal_cur_seq(&c->journal);
 		do_update = true;
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
 		ret = __bch2_fsck_write_inode(trans, &u);
diff --git a/fs/bcachefs/sb-downgrade.c b/fs/bcachefs/sb-downgrade.c
index 051214fdc735..14f6b6a5fb38 100644
--- a/fs/bcachefs/sb-downgrade.c
+++ b/fs/bcachefs/sb-downgrade.c
@@ -90,7 +90,10 @@
 	  BIT_ULL(BCH_RECOVERY_PASS_check_allocations),		\
 	  BCH_FSCK_ERR_accounting_mismatch,			\
 	  BCH_FSCK_ERR_accounting_key_replicas_nr_devs_0,	\
-	  BCH_FSCK_ERR_accounting_key_junk_at_end)
+	  BCH_FSCK_ERR_accounting_key_junk_at_end)		\
+	x(directory_size,					\
+	  BIT_ULL(BCH_RECOVERY_PASS_check_inodes),		\
+	  BCH_FSCK_ERR_directory_size_mismatch)			\
 
 #define DOWNGRADE_TABLE()					\
 	x(bucket_stripe_sectors,				\
diff --git a/fs/bcachefs/sb-errors_format.h b/fs/bcachefs/sb-errors_format.h
index 80b6d589808b..0b4fe899209b 100644
--- a/fs/bcachefs/sb-errors_format.h
+++ b/fs/bcachefs/sb-errors_format.h
@@ -313,7 +313,8 @@ enum bch_fsck_flags {
 	x(logged_op_but_clean,					283,	FSCK_AUTOFIX)	\
 	x(compression_opt_not_marked_in_sb,			295,	FSCK_AUTOFIX)	\
 	x(compression_type_not_marked_in_sb,			296,	FSCK_AUTOFIX)	\
-	x(MAX,							303,	0)
+	x(directory_size_mismatch,				303,	FSCK_AUTOFIX)	\
+	x(MAX,							304,	0)
 
 enum bch_sb_error_id {
 #define x(t, n, ...) BCH_FSCK_ERR_##t = n,
-- 
2.34.1


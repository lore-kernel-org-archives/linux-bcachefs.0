Received: from szxga06-in.huawei.com (szxga06-in.huawei.com [45.249.212.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B79CF13A24E
	for <linux-bcachefs@vger.kernel.org>; Fri,  5 Jul 2024 07:16:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720163788; cv=none; b=AFUe36CAXJr9weBOs9Q3jNEBGF3zLUt9d8KR6XTIQ9Gopigw97xRLJ4nRLme//gAnQ4cNZGfDneBHUVJT0dhu+CssZa0/egc1D8b4Z1Yjbq3BKUYqYn6X7IAVb0HMlqQz3v6k7qgEO0V63Tb7m2iE1sf+GL58Y/oPfUOF2fzKpU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720163788; c=relaxed/simple;
	bh=iqbmlHhEx+2TqEiznREkmYfjI3O6AHEH0zFlxBX0PqE=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=d1XOJyJhI6r5Sx5IG8wm70kv3XLwbuIH0JsdS/tBQtWnr7PJF2FmuLWO7Biy17B/HkCjMTuytfKyYL1kYJFuuDNsM0ZSLyOiOz7bo+LHDY1Rd+yFpZNLb9ASqBAEMTu31QAfl4lZ28Aa5+Sn1NPzWSSM0MfHrGxYP0UncKnAtow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.234])
	by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4WFlBn5GVTz1xtKR;
	Fri,  5 Jul 2024 15:14:41 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (unknown [7.185.36.66])
	by mail.maildlp.com (Postfix) with ESMTPS id 3BBE41402C7;
	Fri,  5 Jul 2024 15:16:15 +0800 (CST)
Received: from huawei.com (10.90.53.73) by dggpeml500022.china.huawei.com
 (7.185.36.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.39; Fri, 5 Jul
 2024 15:16:15 +0800
From: Hongbo Li <lihongbo22@huawei.com>
To: <kent.overstreet@linux.dev>
CC: <linux-bcachefs@vger.kernel.org>, <lihongbo22@huawei.com>
Subject: [RFC PATCH] bcachefs: make directory i_size meaningful
Date: Fri, 5 Jul 2024 15:20:06 +0800
Message-ID: <20240705072006.2768861-1-lihongbo22@huawei.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpeml500022.china.huawei.com (7.185.36.66)

The isize of directory is 0 in bcachefs if the directory is empty.
With more child dirents created, its size ought to change. Many
other filesystems changed as that (ie. xfs and btrfs). And many of
them changed as the size of child dirent name. Although the directory
size may not seem to convey much, we can still give it some meaning.

The formula of dentry size as follow:
    occupied_size = 40 + ALIGN(9 + namelen, 8)

Signed-off-by: Hongbo Li <lihongbo22@huawei.com>
---
 fs/bcachefs/dirent.h    |  5 +++++
 fs/bcachefs/fs-common.c | 11 +++++++++++
 fs/bcachefs/fs.c        | 13 ++++++++-----
 3 files changed, 24 insertions(+), 5 deletions(-)

diff --git a/fs/bcachefs/dirent.h b/fs/bcachefs/dirent.h
index 24037e6e0a09..16b0c89970ac 100644
--- a/fs/bcachefs/dirent.h
+++ b/fs/bcachefs/dirent.h
@@ -32,6 +32,11 @@ static inline unsigned dirent_val_u64s(unsigned len)
 			    sizeof(u64));
 }
 
+static inline unsigned int dirent_occupied_size(const struct qstr *name)
+{
+	return (BKEY_U64s + dirent_val_u64s(name->len)) * sizeof(u64);
+}
+
 int bch2_dirent_read_target(struct btree_trans *, subvol_inum,
 			    struct bkey_s_c_dirent, subvol_inum *);
 
diff --git a/fs/bcachefs/fs-common.c b/fs/bcachefs/fs-common.c
index 508d029ac53d..2d5db8c530a2 100644
--- a/fs/bcachefs/fs-common.c
+++ b/fs/bcachefs/fs-common.c
@@ -153,6 +153,7 @@ int bch2_create_trans(struct btree_trans *trans,
 		if (is_subdir_for_nlink(new_inode))
 			dir_u->bi_nlink++;
 		dir_u->bi_mtime = dir_u->bi_ctime = now;
+		dir_u->bi_size += dirent_occupied_size(name);
 
 		ret = bch2_inode_write(trans, &dir_iter, dir_u);
 		if (ret)
@@ -217,6 +218,7 @@ int bch2_link_trans(struct btree_trans *trans,
 	}
 
 	dir_u->bi_mtime = dir_u->bi_ctime = now;
+	dir_u->bi_size += dirent_occupied_size(name);
 
 	dir_hash = bch2_hash_info_init(c, dir_u);
 
@@ -319,6 +321,7 @@ int bch2_unlink_trans(struct btree_trans *trans,
 
 	dir_u->bi_mtime = dir_u->bi_ctime = inode_u->bi_ctime = now;
 	dir_u->bi_nlink -= is_subdir_for_nlink(inode_u);
+	dir_u->bi_size	-= dirent_occupied_size(name);
 
 	ret =   bch2_hash_delete_at(trans, bch2_dirent_hash_desc,
 				    &dir_hash, &dirent_iter,
@@ -457,6 +460,14 @@ int bch2_rename_trans(struct btree_trans *trans,
 		goto err;
 	}
 
+	if (mode == BCH_RENAME) {
+		src_dir_u->bi_size -= dirent_occupied_size(src_name);
+		dst_dir_u->bi_size += dirent_occupied_size(dst_name);
+	}
+
+	if (mode == BCH_RENAME_OVERWRITE)
+		src_dir_u->bi_size -= dirent_occupied_size(src_name);
+
 	if (src_inode_u->bi_parent_subvol)
 		src_inode_u->bi_parent_subvol = dst_dir.subvol;
 
diff --git a/fs/bcachefs/fs.c b/fs/bcachefs/fs.c
index fd01a5402c28..6c7496d40521 100644
--- a/fs/bcachefs/fs.c
+++ b/fs/bcachefs/fs.c
@@ -65,6 +65,9 @@ void bch2_inode_update_after_write(struct btree_trans *trans,
 	i_gid_write(&inode->v, bi->bi_gid);
 	inode->v.i_mode	= bi->bi_mode;
 
+	if (fields & ATTR_SIZE)
+		i_size_write(&inode->v, bi->bi_size);
+
 	if (fields & ATTR_ATIME)
 		inode_set_atime_to_ts(&inode->v, bch2_time_to_timespec(c, bi->bi_atime));
 	if (fields & ATTR_MTIME)
@@ -369,7 +372,7 @@ __bch2_create(struct mnt_idmap *idmap,
 
 	if (!(flags & BCH_CREATE_TMPFILE)) {
 		bch2_inode_update_after_write(trans, dir, &dir_u,
-					      ATTR_MTIME|ATTR_CTIME);
+					      ATTR_MTIME|ATTR_CTIME|ATTR_SIZE);
 		mutex_unlock(&dir->ei_update_lock);
 	}
 
@@ -525,7 +528,7 @@ static int __bch2_link(struct bch_fs *c,
 
 	if (likely(!ret)) {
 		bch2_inode_update_after_write(trans, dir, &dir_u,
-					      ATTR_MTIME|ATTR_CTIME);
+					      ATTR_MTIME|ATTR_CTIME|ATTR_SIZE);
 		bch2_inode_update_after_write(trans, inode, &inode_u, ATTR_CTIME);
 	}
 
@@ -577,7 +580,7 @@ int __bch2_unlink(struct inode *vdir, struct dentry *dentry,
 		goto err;
 
 	bch2_inode_update_after_write(trans, dir, &dir_u,
-				      ATTR_MTIME|ATTR_CTIME);
+				      ATTR_MTIME|ATTR_CTIME|ATTR_SIZE);
 	bch2_inode_update_after_write(trans, inode, &inode_u,
 				      ATTR_MTIME);
 
@@ -724,11 +727,11 @@ static int bch2_rename2(struct mnt_idmap *idmap,
 	       dst_inode->v.i_ino != dst_inode_u.bi_inum);
 
 	bch2_inode_update_after_write(trans, src_dir, &src_dir_u,
-				      ATTR_MTIME|ATTR_CTIME);
+				      ATTR_MTIME|ATTR_CTIME|ATTR_SIZE);
 
 	if (src_dir != dst_dir)
 		bch2_inode_update_after_write(trans, dst_dir, &dst_dir_u,
-					      ATTR_MTIME|ATTR_CTIME);
+					      ATTR_MTIME|ATTR_CTIME|ATTR_SIZE);
 
 	bch2_inode_update_after_write(trans, src_inode, &src_inode_u,
 				      ATTR_CTIME);
-- 
2.34.1


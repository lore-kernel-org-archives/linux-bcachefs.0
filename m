Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 550AB8BF0
	for <linux-bcachefs@vger.kernel.org>; Mon, 19 Aug 2024 01:48:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.190
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724032132; cv=none; b=OPcbiQ7R50AY5zw3IXQBXhemDYzAxHESLLWEU3Aqjq/Dxahqt8UuXB0oeiQjJ8KgC7+L2P1APfJbMrkoYs7oLYHfpWGZaMUyPpQh6A3SJacOUg0DJ10ujncxHx7dFdIFeqU7tWtORsmGKVlnLrHsaF0/DKratciHstrWZ2hS7UE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724032132; c=relaxed/simple;
	bh=8oqQkwsJ0fY4XBtRxrG1T8KFgZUJQOzPVvrh4ZGlOqo=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=AShyNlUfptEDZgf4klxY0BBYc4wWY0yTgJexut/ibzDCQZ77PtfCZcsyaPAwfKUHVuLAJmRAdnMfS4Jf0OeFLC3VLZ4GvG4jRl0U6+jb6eiBwAYr+vEQWF8dzyq660UqRRDiO6qNzFuXeRLUQFs4hLgzgoa2wh2OY3caYb7J8TE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.190
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.234])
	by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4WnFkT66x7z20lyk;
	Mon, 19 Aug 2024 09:44:01 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (unknown [7.185.36.66])
	by mail.maildlp.com (Postfix) with ESMTPS id E4FA614022E;
	Mon, 19 Aug 2024 09:48:40 +0800 (CST)
Received: from huawei.com (10.90.53.73) by dggpeml500022.china.huawei.com
 (7.185.36.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.39; Mon, 19 Aug
 2024 09:48:40 +0800
From: Hongbo Li <lihongbo22@huawei.com>
To: <kent.overstreet@linux.dev>
CC: <brauner@kernel.org>, <linux-bcachefs@vger.kernel.org>,
	<lihongbo22@huawei.com>
Subject: [PATCH v2] bcachefs: support idmap mounts
Date: Mon, 19 Aug 2024 09:55:50 +0800
Message-ID: <20240819015550.2565027-1-lihongbo22@huawei.com>
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

We enable idmapped mounts for bcachefs. Here, we just pass down
the user_namespace argument from the VFS methods to the relevant
helpers.

The idmap test in bcachefs is as following:

```
1. losetup /dev/loop1 bcachefs.img
2. ./bcachefs format /dev/loop1
3. mount -t bcachefs /dev/loop1 /mnt/bcachefs/
4. ./mount-idmapped --map-mount b:0:1000:1 /mnt/bcachefs /mnt/idmapped1/

ll /mnt/bcachefs
total 2
drwx------. 2 root root    0 Jun 14 14:10 lost+found
-rw-r--r--. 1 root root 1945 Jun 14 14:12 profile

ll /mnt/idmapped1/

total 2
drwx------. 2 1000 1000    0 Jun 14 14:10 lost+found
-rw-r--r--. 1 1000 1000 1945 Jun 14 14:12 profile

Signed-off-by: Hongbo Li <lihongbo22@huawei.com>

---
v2:
  - fix the gid translation when umask S_ISGID

v1:
  - https://lore.kernel.org/all/20240615102038.3110867-1-lihongbo22@huawei.com/T/
---
 fs/bcachefs/fs.c | 50 ++++++++++++++++++++++++++++++++----------------
 1 file changed, 34 insertions(+), 16 deletions(-)

diff --git a/fs/bcachefs/fs.c b/fs/bcachefs/fs.c
index c50457ba808d..0fcab802d376 100644
--- a/fs/bcachefs/fs.c
+++ b/fs/bcachefs/fs.c
@@ -350,6 +350,8 @@ __bch2_create(struct mnt_idmap *idmap,
 	subvol_inum inum;
 	struct bch_subvolume subvol;
 	u64 journal_seq = 0;
+	kuid_t kuid;
+	kgid_t kgid;
 	int ret;
 
 	/*
@@ -376,13 +378,15 @@ __bch2_create(struct mnt_idmap *idmap,
 retry:
 	bch2_trans_begin(trans);
 
+	kuid = mapped_fsuid(idmap, i_user_ns(&dir->v));
+	kgid = mapped_fsgid(idmap, i_user_ns(&dir->v));
 	ret   = bch2_subvol_is_ro_trans(trans, dir->ei_inum.subvol) ?:
 		bch2_create_trans(trans,
 				  inode_inum(dir), &dir_u, &inode_u,
 				  !(flags & BCH_CREATE_TMPFILE)
 				  ? &dentry->d_name : NULL,
-				  from_kuid(i_user_ns(&dir->v), current_fsuid()),
-				  from_kgid(i_user_ns(&dir->v), current_fsgid()),
+				  from_kuid(i_user_ns(&dir->v), kuid),
+				  from_kgid(i_user_ns(&dir->v), kgid),
 				  mode, rdev,
 				  default_acl, acl, snapshot_src, flags) ?:
 		bch2_quota_acct(c, bch_qid(&inode_u), Q_INO, 1,
@@ -800,11 +804,17 @@ static void bch2_setattr_copy(struct mnt_idmap *idmap,
 {
 	struct bch_fs *c = inode->v.i_sb->s_fs_info;
 	unsigned int ia_valid = attr->ia_valid;
+	kuid_t kuid;
+	kgid_t kgid;
 
-	if (ia_valid & ATTR_UID)
-		bi->bi_uid = from_kuid(i_user_ns(&inode->v), attr->ia_uid);
-	if (ia_valid & ATTR_GID)
-		bi->bi_gid = from_kgid(i_user_ns(&inode->v), attr->ia_gid);
+	if (ia_valid & ATTR_UID) {
+		kuid = from_vfsuid(idmap, i_user_ns(&inode->v), attr->ia_vfsuid);
+		bi->bi_uid = from_kuid(i_user_ns(&inode->v), kuid);
+	}
+	if (ia_valid & ATTR_GID) {
+		kgid = from_vfsgid(idmap, i_user_ns(&inode->v), attr->ia_vfsgid);
+		bi->bi_gid = from_kgid(i_user_ns(&inode->v), kgid);
+	}
 
 	if (ia_valid & ATTR_SIZE)
 		bi->bi_size = attr->ia_size;
@@ -819,11 +829,11 @@ static void bch2_setattr_copy(struct mnt_idmap *idmap,
 	if (ia_valid & ATTR_MODE) {
 		umode_t mode = attr->ia_mode;
 		kgid_t gid = ia_valid & ATTR_GID
-			? attr->ia_gid
+			? kgid
 			: inode->v.i_gid;
 
-		if (!in_group_p(gid) &&
-		    !capable_wrt_inode_uidgid(idmap, &inode->v, CAP_FSETID))
+		if (!in_group_or_capable(idmap, &inode->v,
+			make_vfsgid(idmap, i_user_ns(&inode->v), gid)))
 			mode &= ~S_ISGID;
 		bi->bi_mode = mode;
 	}
@@ -839,17 +849,23 @@ int bch2_setattr_nonsize(struct mnt_idmap *idmap,
 	struct btree_iter inode_iter = { NULL };
 	struct bch_inode_unpacked inode_u;
 	struct posix_acl *acl = NULL;
+	kuid_t kuid;
+	kgid_t kgid;
 	int ret;
 
 	mutex_lock(&inode->ei_update_lock);
 
 	qid = inode->ei_qid;
 
-	if (attr->ia_valid & ATTR_UID)
-		qid.q[QTYP_USR] = from_kuid(i_user_ns(&inode->v), attr->ia_uid);
+	if (attr->ia_valid & ATTR_UID) {
+		kuid = from_vfsuid(idmap, i_user_ns(&inode->v), attr->ia_vfsuid);
+		qid.q[QTYP_USR] = from_kuid(i_user_ns(&inode->v), kuid);
+	}
 
-	if (attr->ia_valid & ATTR_GID)
-		qid.q[QTYP_GRP] = from_kgid(i_user_ns(&inode->v), attr->ia_gid);
+	if (attr->ia_valid & ATTR_GID) {
+		kgid = from_vfsgid(idmap, i_user_ns(&inode->v), attr->ia_vfsgid);
+		qid.q[QTYP_GRP] = from_kgid(i_user_ns(&inode->v), kgid);
+	}
 
 	ret = bch2_fs_quota_transfer(c, inode, qid, ~0,
 				     KEY_TYPE_QUOTA_PREALLOC);
@@ -905,13 +921,15 @@ static int bch2_getattr(struct mnt_idmap *idmap,
 {
 	struct bch_inode_info *inode = to_bch_ei(d_inode(path->dentry));
 	struct bch_fs *c = inode->v.i_sb->s_fs_info;
+	vfsuid_t vfsuid = i_uid_into_vfsuid(idmap, &inode->v);
+	vfsgid_t vfsgid = i_gid_into_vfsgid(idmap, &inode->v);
 
 	stat->dev	= inode->v.i_sb->s_dev;
 	stat->ino	= inode->v.i_ino;
 	stat->mode	= inode->v.i_mode;
 	stat->nlink	= inode->v.i_nlink;
-	stat->uid	= inode->v.i_uid;
-	stat->gid	= inode->v.i_gid;
+	stat->uid	= vfsuid_into_kuid(vfsuid);
+	stat->gid	= vfsgid_into_kgid(vfsgid);
 	stat->rdev	= inode->v.i_rdev;
 	stat->size	= i_size_read(&inode->v);
 	stat->atime	= inode_get_atime(&inode->v);
@@ -2169,7 +2187,7 @@ static struct file_system_type bcache_fs_type = {
 	.name			= "bcachefs",
 	.init_fs_context	= bch2_init_fs_context,
 	.kill_sb		= bch2_kill_sb,
-	.fs_flags		= FS_REQUIRES_DEV,
+	.fs_flags		= FS_REQUIRES_DEV | FS_ALLOW_IDMAP,
 };
 
 MODULE_ALIAS_FS("bcachefs");
-- 
2.34.1


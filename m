Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D65C31D7E41
	for <linux-bcachefs@vger.kernel.org>; Mon, 30 Jun 2025 21:36:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751319397; cv=none; b=gywF3LP/utBvVQtuSq3kIXfRV2a2iRBjE/D8kq7Ao8Gb8XqWaB6OV1rg5p8PmP3oEksvwzhKTLYFipDPtc4fQbHGl3orH9CQEVjXJG2e0qRUWOpG0xu3epdgRGGDvgFH7KHw2WOm5ZlBkV5TzR5F6ORUlYF8/hIs+pseyQqY+bM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751319397; c=relaxed/simple;
	bh=Zo3zCLXQJSD9LW8+TzpE6/OMjVBx8SwbLtn2C2Xw/3E=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=IkhOTD/Gyx416gSwgVYH8/4V9wFYy9xvyaHdg0jL7+7xRUKF45+u2x3AxX2plrzB8ARAKfnqnRxUES7Q3NndHtVc1Rsa65i43WpLTiD5hReuAUSIvtw8PK7Vg5+5ccbD+6ZI2ptElyhSUMHonXYzl6oCf/6toq1wDs/Bs20ZQPw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=psU23zmC; arc=none smtp.client-ip=91.218.175.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="psU23zmC"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1751319391;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=B3D1BVmwOMgQ1gnRZJSAc5/LwnX66cACRV2gzE0k/9c=;
	b=psU23zmCRK77K2KZsCEYcS78kk+f0bx5DA12IBPyk9czQ6PGFxhMIZbPDWQmEk3bUK2YwV
	RNwa88X3VcxwCsC1NiQ+dwdfmfjGSWJP+4vwOR2QBzBipLPxe6SdpjMQh3+ezAWWmIDhH6
	3d8rOiNT/hhcJqEURxSVGnr8J8RLhOc=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH] bcachefs: opts.casefold_disabled
Date: Mon, 30 Jun 2025 17:36:26 -0400
Message-ID: <20250630213626.2068567-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Add an option for completely disabling casefolding on a filesystem, as a
workaround for overlayfs.

This should only be needed as a temporary workaround, until the
overlayfs fix arrives.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/bcachefs.h | 11 +++++++++--
 fs/bcachefs/dirent.c   | 19 +++++++++----------
 fs/bcachefs/dirent.h   |  3 ++-
 fs/bcachefs/fs.c       |  7 ++-----
 fs/bcachefs/fsck.c     |  2 --
 fs/bcachefs/inode.c    | 13 ++++++++-----
 fs/bcachefs/opts.h     |  5 +++++
 fs/bcachefs/str_hash.c |  5 +++--
 fs/bcachefs/str_hash.h |  2 --
 fs/bcachefs/super.c    | 36 ++++++++++++++++++------------------
 10 files changed, 56 insertions(+), 47 deletions(-)

diff --git a/fs/bcachefs/bcachefs.h b/fs/bcachefs/bcachefs.h
index 8043943cdf6a..ddfacad0f70c 100644
--- a/fs/bcachefs/bcachefs.h
+++ b/fs/bcachefs/bcachefs.h
@@ -863,9 +863,7 @@ struct bch_fs {
 	DARRAY(enum bcachefs_metadata_version)
 				incompat_versions_requested;
 
-#ifdef CONFIG_UNICODE
 	struct unicode_map	*cf_encoding;
-#endif
 
 	struct bch_sb_handle	disk_sb;
 
@@ -1285,4 +1283,13 @@ static inline bool bch2_discard_opt_enabled(struct bch_fs *c, struct bch_dev *ca
 		: ca->mi.discard;
 }
 
+static inline bool bch2_fs_casefold_enabled(struct bch_fs *c)
+{
+#ifdef CONFIG_UNICODE
+	return !c->opts.casefold_disabled;
+#else
+	return false;
+#endif
+}
+
 #endif /* _BCACHEFS_H */
diff --git a/fs/bcachefs/dirent.c b/fs/bcachefs/dirent.c
index 300f7cc8abdf..a18d0f78704d 100644
--- a/fs/bcachefs/dirent.c
+++ b/fs/bcachefs/dirent.c
@@ -18,7 +18,9 @@ int bch2_casefold(struct btree_trans *trans, const struct bch_hash_info *info,
 {
 	*out_cf = (struct qstr) QSTR_INIT(NULL, 0);
 
-#ifdef CONFIG_UNICODE
+	if (!bch2_fs_casefold_enabled(trans->c))
+		return -EOPNOTSUPP;
+
 	unsigned char *buf = bch2_trans_kmalloc(trans, BCH_NAME_MAX + 1);
 	int ret = PTR_ERR_OR_ZERO(buf);
 	if (ret)
@@ -30,9 +32,6 @@ int bch2_casefold(struct btree_trans *trans, const struct bch_hash_info *info,
 
 	*out_cf = (struct qstr) QSTR_INIT(buf, ret);
 	return 0;
-#else
-	return -EOPNOTSUPP;
-#endif
 }
 
 static unsigned bch2_dirent_name_bytes(struct bkey_s_c_dirent d)
@@ -231,7 +230,8 @@ void bch2_dirent_to_text(struct printbuf *out, struct bch_fs *c, struct bkey_s_c
 	prt_printf(out, " type %s", bch2_d_type_str(d.v->d_type));
 }
 
-int bch2_dirent_init_name(struct bkey_i_dirent *dirent,
+int bch2_dirent_init_name(struct bch_fs *c,
+			  struct bkey_i_dirent *dirent,
 			  const struct bch_hash_info *hash_info,
 			  const struct qstr *name,
 			  const struct qstr *cf_name)
@@ -251,7 +251,9 @@ int bch2_dirent_init_name(struct bkey_i_dirent *dirent,
 		       offsetof(struct bch_dirent, d_name) -
 		       name->len);
 	} else {
-#ifdef CONFIG_UNICODE
+		if (!bch2_fs_casefold_enabled(c))
+			return -EOPNOTSUPP;
+
 		memcpy(&dirent->v.d_cf_name_block.d_names[0], name->name, name->len);
 
 		char *cf_out = &dirent->v.d_cf_name_block.d_names[name->len];
@@ -277,9 +279,6 @@ int bch2_dirent_init_name(struct bkey_i_dirent *dirent,
 		dirent->v.d_cf_name_block.d_cf_name_len = cpu_to_le16(cf_len);
 
 		EBUG_ON(bch2_dirent_get_casefold_name(dirent_i_to_s_c(dirent)).len != cf_len);
-#else
-	return -EOPNOTSUPP;
-#endif
 	}
 
 	unsigned u64s = dirent_val_u64s(name->len, cf_len);
@@ -313,7 +312,7 @@ struct bkey_i_dirent *bch2_dirent_create_key(struct btree_trans *trans,
 	dirent->v.d_type = type;
 	dirent->v.d_unused = 0;
 
-	int ret = bch2_dirent_init_name(dirent, hash_info, name, cf_name);
+	int ret = bch2_dirent_init_name(trans->c, dirent, hash_info, name, cf_name);
 	if (ret)
 		return ERR_PTR(ret);
 
diff --git a/fs/bcachefs/dirent.h b/fs/bcachefs/dirent.h
index 70fb0b581221..1e17199cc5c7 100644
--- a/fs/bcachefs/dirent.h
+++ b/fs/bcachefs/dirent.h
@@ -59,7 +59,8 @@ static inline void dirent_copy_target(struct bkey_i_dirent *dst,
 	dst->v.d_type = src.v->d_type;
 }
 
-int bch2_dirent_init_name(struct bkey_i_dirent *,
+int bch2_dirent_init_name(struct bch_fs *,
+			  struct bkey_i_dirent *,
 			  const struct bch_hash_info *,
 			  const struct qstr *,
 			  const struct qstr *);
diff --git a/fs/bcachefs/fs.c b/fs/bcachefs/fs.c
index db24a76563f8..b4a52e5b9b7b 100644
--- a/fs/bcachefs/fs.c
+++ b/fs/bcachefs/fs.c
@@ -722,7 +722,6 @@ static struct dentry *bch2_lookup(struct inode *vdir, struct dentry *dentry,
 	if (IS_ERR(inode))
 		inode = NULL;
 
-#ifdef CONFIG_UNICODE
 	if (!inode && IS_CASEFOLDED(vdir)) {
 		/*
 		 * Do not cache a negative dentry in casefolded directories
@@ -737,7 +736,6 @@ static struct dentry *bch2_lookup(struct inode *vdir, struct dentry *dentry,
 		 */
 		return NULL;
 	}
-#endif
 
 	return d_splice_alias(&inode->v, dentry);
 }
@@ -2565,9 +2563,8 @@ static int bch2_fs_get_tree(struct fs_context *fc)
 
 	sb->s_shrink->seeks = 0;
 
-#ifdef CONFIG_UNICODE
-	sb->s_encoding = c->cf_encoding;
-#endif
+	if (bch2_fs_casefold_enabled(c))
+		sb->s_encoding = c->cf_encoding;
 	generic_set_sb_d_ops(sb);
 
 	vinode = bch2_vfs_inode_get(c, BCACHEFS_ROOT_SUBVOL_INUM);
diff --git a/fs/bcachefs/fsck.c b/fs/bcachefs/fsck.c
index 9920f1affc5b..d56198463d26 100644
--- a/fs/bcachefs/fsck.c
+++ b/fs/bcachefs/fsck.c
@@ -2302,9 +2302,7 @@ static int check_dirent(struct btree_trans *trans, struct btree_iter *iter,
 		*hash_info = bch2_hash_info_init(c, &i->inode);
 	dir->first_this_inode = false;
 
-#ifdef CONFIG_UNICODE
 	hash_info->cf_encoding = bch2_inode_casefold(c, &i->inode) ? c->cf_encoding : NULL;
-#endif
 
 	ret = bch2_str_hash_check_key(trans, s, &bch2_dirent_hash_desc, hash_info,
 				      iter, k, need_second_pass);
diff --git a/fs/bcachefs/inode.c b/fs/bcachefs/inode.c
index 53e5dc1f6ac1..ef4cc7395b86 100644
--- a/fs/bcachefs/inode.c
+++ b/fs/bcachefs/inode.c
@@ -1265,7 +1265,14 @@ int bch2_inode_set_casefold(struct btree_trans *trans, subvol_inum inum,
 {
 	struct bch_fs *c = trans->c;
 
-#ifdef CONFIG_UNICODE
+#ifndef CONFIG_UNICODE
+	bch_err(c, "Cannot use casefolding on a kernel without CONFIG_UNICODE");
+	return -EOPNOTSUPP;
+#endif
+
+	if (c->opts.casefold_disabled)
+		return -EOPNOTSUPP;
+
 	int ret = 0;
 	/* Not supported on individual files. */
 	if (!S_ISDIR(bi->bi_mode))
@@ -1289,10 +1296,6 @@ int bch2_inode_set_casefold(struct btree_trans *trans, subvol_inum inum,
 	bi->bi_fields_set |= BIT(Inode_opt_casefold);
 
 	return bch2_maybe_propagate_has_case_insensitive(trans, inum, bi);
-#else
-	bch_err(c, "Cannot use casefolding on a kernel without CONFIG_UNICODE");
-	return -EOPNOTSUPP;
-#endif
 }
 
 static noinline int __bch2_inode_rm_snapshot(struct btree_trans *trans, u64 inum, u32 snapshot)
diff --git a/fs/bcachefs/opts.h b/fs/bcachefs/opts.h
index b0a76bd6d6f5..63f8e254495c 100644
--- a/fs/bcachefs/opts.h
+++ b/fs/bcachefs/opts.h
@@ -234,6 +234,11 @@ enum fsck_err_opts {
 	  OPT_BOOL(),							\
 	  BCH_SB_CASEFOLD,		false,				\
 	  NULL,		"Dirent lookups are casefolded")		\
+	x(casefold_disabled,			u8,			\
+	  OPT_FS|OPT_MOUNT,						\
+	  OPT_BOOL(),							\
+	  BCH2_NO_SB_OPT,		false,				\
+	  NULL,		"Disable casefolding filesystem wide")		\
 	x(inodes_32bit,			u8,				\
 	  OPT_FS|OPT_INODE|OPT_FORMAT|OPT_MOUNT|OPT_RUNTIME,		\
 	  OPT_BOOL(),							\
diff --git a/fs/bcachefs/str_hash.c b/fs/bcachefs/str_hash.c
index 71b735a85026..3e9f59226bdf 100644
--- a/fs/bcachefs/str_hash.c
+++ b/fs/bcachefs/str_hash.c
@@ -38,6 +38,7 @@ static int bch2_fsck_rename_dirent(struct btree_trans *trans,
 				   struct bkey_s_c_dirent old,
 				   bool *updated_before_k_pos)
 {
+	struct bch_fs *c = trans->c;
 	struct qstr old_name = bch2_dirent_get_name(old);
 	struct bkey_i_dirent *new = bch2_trans_kmalloc(trans, BKEY_U64s_MAX * sizeof(u64));
 	int ret = PTR_ERR_OR_ZERO(new);
@@ -60,7 +61,7 @@ static int bch2_fsck_rename_dirent(struct btree_trans *trans,
 					sprintf(renamed_buf, "%.*s.fsck_renamed-%u",
 						old_name.len, old_name.name, i));
 
-		ret = bch2_dirent_init_name(new, hash_info, &renamed_name, NULL);
+		ret = bch2_dirent_init_name(c, new, hash_info, &renamed_name, NULL);
 		if (ret)
 			return ret;
 
@@ -79,7 +80,7 @@ static int bch2_fsck_rename_dirent(struct btree_trans *trans,
 	}
 
 	ret = ret ?: bch2_fsck_update_backpointers(trans, s, desc, hash_info, &new->k_i);
-	bch_err_fn(trans->c, ret);
+	bch_err_fn(c, ret);
 	return ret;
 }
 
diff --git a/fs/bcachefs/str_hash.h b/fs/bcachefs/str_hash.h
index 79d51aef70aa..8979ac2d7a3b 100644
--- a/fs/bcachefs/str_hash.h
+++ b/fs/bcachefs/str_hash.h
@@ -48,9 +48,7 @@ bch2_hash_info_init(struct bch_fs *c, const struct bch_inode_unpacked *bi)
 	struct bch_hash_info info = {
 		.inum_snapshot	= bi->bi_snapshot,
 		.type		= INODE_STR_HASH(bi),
-#ifdef CONFIG_UNICODE
 		.cf_encoding	= bch2_inode_casefold(c, bi) ? c->cf_encoding : NULL,
-#endif
 		.siphash_key	= { .k0 = bi->bi_hash_seed }
 	};
 
diff --git a/fs/bcachefs/super.c b/fs/bcachefs/super.c
index 69c097ff54e7..54316abe09df 100644
--- a/fs/bcachefs/super.c
+++ b/fs/bcachefs/super.c
@@ -1024,24 +1024,25 @@ static struct bch_fs *bch2_fs_alloc(struct bch_sb *sb, struct bch_opts *opts,
 			goto err;
 	}
 
-#ifdef CONFIG_UNICODE
-	/* Default encoding until we can potentially have more as an option. */
-	c->cf_encoding = utf8_load(BCH_FS_DEFAULT_UTF8_ENCODING);
-	if (IS_ERR(c->cf_encoding)) {
-		printk(KERN_ERR "Cannot load UTF-8 encoding for filesystem. Version: %u.%u.%u",
-			unicode_major(BCH_FS_DEFAULT_UTF8_ENCODING),
-			unicode_minor(BCH_FS_DEFAULT_UTF8_ENCODING),
-			unicode_rev(BCH_FS_DEFAULT_UTF8_ENCODING));
-		ret = -EINVAL;
-		goto err;
-	}
-#else
+#ifndef CONFIG_UNICODE
 	if (c->sb.features & BIT_ULL(BCH_FEATURE_casefolding)) {
 		printk(KERN_ERR "Cannot mount a filesystem with casefolding on a kernel without CONFIG_UNICODE\n");
 		ret = -EINVAL;
 		goto err;
 	}
 #endif
+	if (bch2_fs_casefold_enabled(c)) {
+		/* Default encoding until we can potentially have more as an option. */
+		c->cf_encoding = utf8_load(BCH_FS_DEFAULT_UTF8_ENCODING);
+		if (IS_ERR(c->cf_encoding)) {
+			printk(KERN_ERR "Cannot load UTF-8 encoding for filesystem. Version: %u.%u.%u",
+			       unicode_major(BCH_FS_DEFAULT_UTF8_ENCODING),
+			       unicode_minor(BCH_FS_DEFAULT_UTF8_ENCODING),
+			       unicode_rev(BCH_FS_DEFAULT_UTF8_ENCODING));
+			ret = -EINVAL;
+			goto err;
+		}
+	}
 
 	for (i = 0; i < c->sb.nr_devices; i++) {
 		if (!bch2_member_exists(c->disk_sb.sb, i))
@@ -1160,12 +1161,11 @@ int bch2_fs_start(struct bch_fs *c)
 
 	print_mount_opts(c);
 
-#ifdef CONFIG_UNICODE
-	bch_info(c, "Using encoding defined by superblock: utf8-%u.%u.%u",
-		 unicode_major(BCH_FS_DEFAULT_UTF8_ENCODING),
-		 unicode_minor(BCH_FS_DEFAULT_UTF8_ENCODING),
-		 unicode_rev(BCH_FS_DEFAULT_UTF8_ENCODING));
-#endif
+	if (c->cf_encoding)
+		bch_info(c, "Using encoding defined by superblock: utf8-%u.%u.%u",
+			 unicode_major(BCH_FS_DEFAULT_UTF8_ENCODING),
+			 unicode_minor(BCH_FS_DEFAULT_UTF8_ENCODING),
+			 unicode_rev(BCH_FS_DEFAULT_UTF8_ENCODING));
 
 	if (!bch2_fs_may_start(c))
 		return bch_err_throw(c, insufficient_devices_to_start);
-- 
2.50.0


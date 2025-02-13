Received: from out-187.mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39EBA24BC06
	for <linux-bcachefs@vger.kernel.org>; Thu, 13 Feb 2025 18:46:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739472396; cv=none; b=rhp514nWu/s8g8XRbG4MZU6oyPx8alWax1HkPwvj3itUfmIBS5ec35ENrpvJpVFK5j+ossDnCudBGDbCqckEykTJhjfY+blIF+SsTaWy7BjRdkMr3uveoC2YvliDDOdTb5LrVPuuMORi+Bqha9dzS92rYKiA6Yk7gLudTZo/hNU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739472396; c=relaxed/simple;
	bh=jph/K22wyhva7hTP24BSM97hopcurTPx7/zNFT5DqD4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BSyKamTrXP/OWrU/eqsv7sYL3WDxZhJhJSD/j30P450R3txK6UEXJK9i2gxpbONgr66YtYudaFpxENc8maaPen5dhBgSSPfioqYN2tMcqXSVRSUdV12XFkPvTRYo9x8fHA7jCr1wcMhYXHddbgOF4O2e0ESF1tteEzjbik4ikfI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=PQSZEFqG; arc=none smtp.client-ip=95.215.58.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="PQSZEFqG"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1739472391;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Pe4wWjKE/ndZJOEjom0PgxTY24lwawZ84ZFqIBBjESU=;
	b=PQSZEFqGco+JX+R0FsqQqMgEhRop6FQxt2Qodn5O98qGTQew4NhlEwvPmRGQCld6NpG7AM
	te6LOe1vy9C9EJojYCygmZSAqD+nlCRMj+YAiblC6+hI4mJ70/pP5hHdDfMzetrOKXCZtA
	IQFaLGlLXhNu+acY6JnN3RWYNKt1PbM=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Joshua Ashton <joshua@froggi.es>,
	=?UTF-8?q?Andr=C3=A9=20Almeida?= <andrealmeid@igalia.com>,
	Gabriel Krisman Bertazi <krisman@suse.de>,
	Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 18/18] bcachefs: bcachefs_metadata_version_casefolding
Date: Thu, 13 Feb 2025 13:46:03 -0500
Message-ID: <20250213184607.18237-19-kent.overstreet@linux.dev>
In-Reply-To: <20250213184607.18237-1-kent.overstreet@linux.dev>
References: <20250213184607.18237-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Joshua Ashton <joshua@froggi.es>

This patch implements support for case-insensitive file name lookups
in bcachefs.

The implementation uses the same UTF-8 lowering and normalization that
ext4 and f2fs is using.

More information is provided in Documentation/bcachefs/casefolding.rst

Compatibility notes:

This uses the new versioning scheme for incompatible features where an
incompatible feature is tied to a version number: the superblock says
"we may use incompat features up to x" and "incompat features up to x
are in use", disallowing mounting by previous versions.

Additionally, and old style incompat feature bit is used, so that
kernels without utf8 casefolding support know if casefolding
specifically is in use and they're allowed to mount.

Signed-off-by: Joshua Ashton <joshua@froggi.es>
Cc: André Almeida <andrealmeid@igalia.com>
Cc: Gabriel Krisman Bertazi <krisman@suse.de>
Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 .../filesystems/bcachefs/casefolding.rst      |  87 +++++++++
 fs/bcachefs/bcachefs.h                        |   6 +
 fs/bcachefs/bcachefs_format.h                 |   6 +-
 fs/bcachefs/dirent.c                          | 170 +++++++++++++++---
 fs/bcachefs/dirent.h                          |   9 +-
 fs/bcachefs/dirent_format.h                   |  20 ++-
 fs/bcachefs/fs-ioctl.c                        |  25 +++
 fs/bcachefs/fs-ioctl.h                        |  20 ++-
 fs/bcachefs/fs.c                              |  17 ++
 fs/bcachefs/inode_format.h                    |   3 +-
 fs/bcachefs/sb-errors_format.h                |   4 +-
 fs/bcachefs/str_hash.c                        |   2 +-
 fs/bcachefs/str_hash.h                        |   4 +
 fs/bcachefs/super.c                           |  19 ++
 14 files changed, 350 insertions(+), 42 deletions(-)
 create mode 100644 Documentation/filesystems/bcachefs/casefolding.rst

diff --git a/Documentation/filesystems/bcachefs/casefolding.rst b/Documentation/filesystems/bcachefs/casefolding.rst
new file mode 100644
index 000000000000..6546aa4f7a86
--- /dev/null
+++ b/Documentation/filesystems/bcachefs/casefolding.rst
@@ -0,0 +1,87 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+Casefolding
+===========
+
+bcachefs has support for case-insensitive file and directory
+lookups using the regular `chattr +F` (`S_CASEFOLD`, `FS_CASEFOLD_FL`)
+casefolding attributes.
+
+The main usecase for casefolding is compatibility with software written
+against other filesystems that rely on casefolded lookups
+(eg. NTFS and Wine/Proton).
+Taking advantage of file-system level casefolding can lead to great
+loading time gains in many applications and games.
+
+Casefolding support requires a kernel with the `CONFIG_UNICODE` enabled.
+Once a directory has been flagged for casefolding, a feature bit
+is enabled on the superblock which marks the filesystem as using
+casefolding.
+When the feature bit for casefolding is enabled, it is no longer possible
+to mount that filesystem on kernels without `CONFIG_UNICODE` enabled.
+
+On the lookup/query side: casefolding is implemented by allocating a new
+string of `BCH_NAME_MAX` length using the `utf8_casefold` function to
+casefold the query string.
+
+On the dirent side: casefolding is implemented by ensuring the `bkey`'s
+hash is made from the casefolded string and storing the cached casefolded
+name with the regular name in the dirent.
+
+The structure looks like this:
+
+Regular:    [dirent data][regular name][nul][nul]...
+Casefolded: [dirent data][reg len][cf len][regular name][casefolded name][nul][nul]...
+
+(Do note, the number of `NUL`s here is merely for illustration, they count can vary
+ per-key, and they may not even be present if the key is aligned to `sizeof(u64)`.)
+
+This is efficient as it means that for all file lookups that require casefolding,
+it has identical performance to a regular lookup:
+a hash comparison and a `memcmp` of the name.
+
+Rationale
+---------
+
+Several designs were considered for this system:
+One was to introduce a dirent_v2, however that would be painful especially as
+the hash system only has support for a single key type. This would also need
+`BCH_NAME_MAX` to change between versions, and a new feature bit.
+
+Another option was to store without the two lengths, and just take the length of
+the regular name and casefolded name contiguously / 2 as the length. This would
+assume that the regular length == casefolded length, but that could potentially
+not be true, if the uppercase unicode glyph had a different UTF-8 encoding than
+the lowercase unicode glyph.
+It would be possible to disregard the casefold cache for those cases, but it was
+decided to simply encode the two string lengths in the key to avoid random
+performance issues if this edgecase was ever hit.
+
+The option settled on was to use a free-bit in d_type to mark a dirent as having
+a casefold cache, and then treat the first 4 bytes the name block as lengths.
+You can see this in the `d_cf_name_block` member of union in `bch_dirent`.
+
+The feature bit was used to allow casefolding support to be enabled for the majority
+of users, but some allow users who have no need for the feature to still use bcachefs as
+`CONFIG_UNICODE` can increase the kernel side a significant amount due to the tables used,
+which may be decider between using bcachefs for eg. embedded platforms.
+
+Other filesystems like ext4 and f2fs have a super-block level option for casefolding
+encoding, but bcachefs currently does not provide this. ext4 and f2fs do not expose
+any encodings than a single UTF-8 version. When future encodings are desirable,
+they will be added trivially using the opts mechanism.
+
+dentry/dcache considerations
+---------
+
+Currently, in casefolded directories, bcachefs (like other filesystems) will not cache
+negative dentry's.
+
+This is because currently doing so presents a problem in the following scenario:
+ - Lookup file "blAH" in a casefolded directory
+ - Creation of file "BLAH" in a casefolded directory
+ - Lookup file "blAH" in a casefolded directory
+This would fail if negative dentry's were cached.
+
+This is slightly suboptimal, but could be fixed in future with some vfs work.
+
diff --git a/fs/bcachefs/bcachefs.h b/fs/bcachefs/bcachefs.h
index 28216297edbb..02067366820d 100644
--- a/fs/bcachefs/bcachefs.h
+++ b/fs/bcachefs/bcachefs.h
@@ -203,6 +203,7 @@
 #include <linux/types.h>
 #include <linux/workqueue.h>
 #include <linux/zstd.h>
+#include <linux/unicode.h>
 
 #include "bcachefs_format.h"
 #include "btree_journal_iter_types.h"
@@ -699,6 +700,8 @@ enum bch_write_ref {
 	BCH_WRITE_REF_NR,
 };
 
+#define BCH_FS_DEFAULT_UTF8_ENCODING UNICODE_AGE(12, 1, 0)
+
 struct bch_fs {
 	struct closure		cl;
 
@@ -783,6 +786,9 @@ struct bch_fs {
 		u64		btrees_lost_data;
 	}			sb;
 
+#ifdef CONFIG_UNICODE
+	struct unicode_map	*cf_encoding;
+#endif
 
 	struct bch_sb_handle	disk_sb;
 
diff --git a/fs/bcachefs/bcachefs_format.h b/fs/bcachefs/bcachefs_format.h
index b4ac311f21a1..13cc0833b488 100644
--- a/fs/bcachefs/bcachefs_format.h
+++ b/fs/bcachefs/bcachefs_format.h
@@ -689,7 +689,8 @@ struct bch_sb_field_ext {
 	x(directory_size,		BCH_VERSION(1, 20))		\
 	x(cached_backpointers,		BCH_VERSION(1, 21))		\
 	x(stripe_backpointers,		BCH_VERSION(1, 22))		\
-	x(stripe_lru,			BCH_VERSION(1, 23))
+	x(stripe_lru,			BCH_VERSION(1, 23))		\
+	x(casefolding,			BCH_VERSION(1, 24))
 
 enum bcachefs_metadata_version {
 	bcachefs_metadata_version_min = 9,
@@ -911,7 +912,8 @@ static inline void SET_BCH_SB_BACKGROUND_COMPRESSION_TYPE(struct bch_sb *sb, __u
 	x(journal_no_flush,		16)	\
 	x(alloc_v2,			17)	\
 	x(extents_across_btree_nodes,	18)	\
-	x(incompat_version_field,	19)
+	x(incompat_version_field,	19)	\
+	x(casefolding,			20)
 
 #define BCH_SB_FEATURES_ALWAYS				\
 	(BIT_ULL(BCH_FEATURE_new_extent_overwrite)|	\
diff --git a/fs/bcachefs/dirent.c b/fs/bcachefs/dirent.c
index 7dcc18000726..f4c283d1e86a 100644
--- a/fs/bcachefs/dirent.c
+++ b/fs/bcachefs/dirent.c
@@ -13,6 +13,40 @@
 
 #include <linux/dcache.h>
 
+static int bch2_casefold(struct btree_trans *trans, const struct bch_hash_info *info,
+				const struct qstr *str, struct qstr *out_cf)
+{
+	*out_cf = (struct qstr) QSTR_INIT(NULL, 0);
+
+#ifdef CONFIG_UNICODE
+	unsigned char *buf = bch2_trans_kmalloc(trans, BCH_NAME_MAX + 1);
+	int ret = PTR_ERR_OR_ZERO(buf);
+	if (ret)
+		return ret;
+
+	ret = utf8_casefold(info->cf_encoding, str, buf, BCH_NAME_MAX + 1);
+	if (ret <= 0)
+		return ret;
+
+	*out_cf = (struct qstr) QSTR_INIT(buf, ret);
+	return 0;
+#else
+	return -EOPNOTSUPP;
+#endif
+}
+
+static inline int bch2_maybe_casefold(struct btree_trans *trans,
+				      const struct bch_hash_info *info,
+				      const struct qstr *str, struct qstr *out_cf)
+{
+	if (likely(!info->cf_encoding)) {
+		*out_cf = *str;
+		return 0;
+	} else {
+		return bch2_casefold(trans, info, str, out_cf);
+	}
+}
+
 static unsigned bch2_dirent_name_bytes(struct bkey_s_c_dirent d)
 {
 	if (bkey_val_bytes(d.k) < offsetof(struct bch_dirent, d_name))
@@ -28,13 +62,38 @@ static unsigned bch2_dirent_name_bytes(struct bkey_s_c_dirent d)
 #endif
 
 	return bkey_bytes -
-		offsetof(struct bch_dirent, d_name) -
+		(d.v->d_casefold
+		? offsetof(struct bch_dirent, d_cf_name_block.d_names)
+		: offsetof(struct bch_dirent, d_name)) -
 		trailing_nuls;
 }
 
 struct qstr bch2_dirent_get_name(struct bkey_s_c_dirent d)
 {
-	return (struct qstr) QSTR_INIT(d.v->d_name, bch2_dirent_name_bytes(d));
+	if (d.v->d_casefold) {
+		unsigned name_len = le16_to_cpu(d.v->d_cf_name_block.d_name_len);
+		return (struct qstr) QSTR_INIT(&d.v->d_cf_name_block.d_names[0], name_len);
+	} else {
+		return (struct qstr) QSTR_INIT(d.v->d_name, bch2_dirent_name_bytes(d));
+	}
+}
+
+static struct qstr bch2_dirent_get_casefold_name(struct bkey_s_c_dirent d)
+{
+	if (d.v->d_casefold) {
+		unsigned name_len = le16_to_cpu(d.v->d_cf_name_block.d_name_len);
+		unsigned cf_name_len = le16_to_cpu(d.v->d_cf_name_block.d_cf_name_len);
+		return (struct qstr) QSTR_INIT(&d.v->d_cf_name_block.d_names[name_len], cf_name_len);
+	} else {
+		return (struct qstr) QSTR_INIT(NULL, 0);
+	}
+}
+
+static inline struct qstr bch2_dirent_get_lookup_name(struct bkey_s_c_dirent d)
+{
+	return d.v->d_casefold
+		? bch2_dirent_get_casefold_name(d)
+		: bch2_dirent_get_name(d);
 }
 
 static u64 bch2_dirent_hash(const struct bch_hash_info *info,
@@ -57,7 +116,7 @@ static u64 dirent_hash_key(const struct bch_hash_info *info, const void *key)
 static u64 dirent_hash_bkey(const struct bch_hash_info *info, struct bkey_s_c k)
 {
 	struct bkey_s_c_dirent d = bkey_s_c_to_dirent(k);
-	struct qstr name = bch2_dirent_get_name(d);
+	struct qstr name = bch2_dirent_get_lookup_name(d);
 
 	return bch2_dirent_hash(info, &name);
 }
@@ -65,7 +124,7 @@ static u64 dirent_hash_bkey(const struct bch_hash_info *info, struct bkey_s_c k)
 static bool dirent_cmp_key(struct bkey_s_c _l, const void *_r)
 {
 	struct bkey_s_c_dirent l = bkey_s_c_to_dirent(_l);
-	const struct qstr l_name = bch2_dirent_get_name(l);
+	const struct qstr l_name = bch2_dirent_get_lookup_name(l);
 	const struct qstr *r_name = _r;
 
 	return !qstr_eq(l_name, *r_name);
@@ -75,8 +134,8 @@ static bool dirent_cmp_bkey(struct bkey_s_c _l, struct bkey_s_c _r)
 {
 	struct bkey_s_c_dirent l = bkey_s_c_to_dirent(_l);
 	struct bkey_s_c_dirent r = bkey_s_c_to_dirent(_r);
-	const struct qstr l_name = bch2_dirent_get_name(l);
-	const struct qstr r_name = bch2_dirent_get_name(r);
+	const struct qstr l_name = bch2_dirent_get_lookup_name(l);
+	const struct qstr r_name = bch2_dirent_get_lookup_name(r);
 
 	return !qstr_eq(l_name, r_name);
 }
@@ -104,17 +163,19 @@ int bch2_dirent_validate(struct bch_fs *c, struct bkey_s_c k,
 			 struct bkey_validate_context from)
 {
 	struct bkey_s_c_dirent d = bkey_s_c_to_dirent(k);
+	unsigned name_block_len = bch2_dirent_name_bytes(d);
 	struct qstr d_name = bch2_dirent_get_name(d);
+	struct qstr d_cf_name = bch2_dirent_get_casefold_name(d);
 	int ret = 0;
 
 	bkey_fsck_err_on(!d_name.len,
 			 c, dirent_empty_name,
 			 "empty name");
 
-	bkey_fsck_err_on(bkey_val_u64s(k.k) > dirent_val_u64s(d_name.len),
+	bkey_fsck_err_on(d_name.len + d_cf_name.len > name_block_len,
 			 c, dirent_val_too_big,
-			 "value too big (%zu > %u)",
-			 bkey_val_u64s(k.k), dirent_val_u64s(d_name.len));
+			 "dirent names exceed bkey size (%d + %d > %d)",
+			 d_name.len, d_cf_name.len, name_block_len);
 
 	/*
 	 * Check new keys don't exceed the max length
@@ -142,6 +203,18 @@ int bch2_dirent_validate(struct bch_fs *c, struct bkey_s_c k,
 			 le64_to_cpu(d.v->d_inum) == d.k->p.inode,
 			 c, dirent_to_itself,
 			 "dirent points to own directory");
+
+	if (d.v->d_casefold) {
+		bkey_fsck_err_on(from.from == BKEY_VALIDATE_commit &&
+				 d_cf_name.len > BCH_NAME_MAX,
+				 c, dirent_cf_name_too_big,
+				 "dirent w/ cf name too big (%u > %u)",
+				 d_cf_name.len, BCH_NAME_MAX);
+
+		bkey_fsck_err_on(d_cf_name.len != strnlen(d_cf_name.name, d_cf_name.len),
+				 c, dirent_stray_data_after_cf_name,
+				 "dirent has stray data after cf name's NUL");
+	}
 fsck_err:
 	return ret;
 }
@@ -166,10 +239,11 @@ void bch2_dirent_to_text(struct printbuf *out, struct bch_fs *c, struct bkey_s_c
 static struct bkey_i_dirent *dirent_alloc_key(struct btree_trans *trans,
 				subvol_inum dir,
 				u8 type,
-				int name_len, u64 dst)
+				int name_len, int cf_name_len,
+				u64 dst)
 {
 	struct bkey_i_dirent *dirent;
-	unsigned u64s = BKEY_U64s + dirent_val_u64s(name_len);
+	unsigned u64s = BKEY_U64s + dirent_val_u64s(name_len, cf_name_len);
 
 	BUG_ON(u64s > U8_MAX);
 
@@ -188,6 +262,8 @@ static struct bkey_i_dirent *dirent_alloc_key(struct btree_trans *trans,
 	}
 
 	dirent->v.d_type = type;
+	dirent->v.d_unused = 0;
+	dirent->v.d_casefold = cf_name_len ? 1 : 0;
 
 	return dirent;
 }
@@ -195,6 +271,8 @@ static struct bkey_i_dirent *dirent_alloc_key(struct btree_trans *trans,
 static void dirent_init_regular_name(struct bkey_i_dirent *dirent,
 				     const struct qstr *name)
 {
+	EBUG_ON(dirent->v.d_casefold);
+
 	memcpy(&dirent->v.d_name[0], name->name, name->len);
 	memset(&dirent->v.d_name[name->len], 0,
 		bkey_val_bytes(&dirent->k) -
@@ -202,10 +280,30 @@ static void dirent_init_regular_name(struct bkey_i_dirent *dirent,
 		name->len);
 }
 
+static void dirent_init_casefolded_name(struct bkey_i_dirent *dirent,
+					const struct qstr *name,
+					const struct qstr *cf_name)
+{
+	EBUG_ON(!dirent->v.d_casefold);
+	EBUG_ON(!cf_name->len);
+
+	dirent->v.d_cf_name_block.d_name_len = name->len;
+	dirent->v.d_cf_name_block.d_cf_name_len = cf_name->len;
+	memcpy(&dirent->v.d_cf_name_block.d_names[0], name->name, name->len);
+	memcpy(&dirent->v.d_cf_name_block.d_names[name->len], cf_name->name, cf_name->len);
+	memset(&dirent->v.d_cf_name_block.d_names[name->len + cf_name->len], 0,
+		bkey_val_bytes(&dirent->k) -
+		offsetof(struct bch_dirent, d_cf_name_block.d_names) -
+		name->len + cf_name->len);
+
+	EBUG_ON(bch2_dirent_get_casefold_name(dirent_i_to_s_c(dirent)).len != cf_name->len);
+}
+
 static struct bkey_i_dirent *dirent_create_key(struct btree_trans *trans,
 				subvol_inum dir,
 				u8 type,
 				const struct qstr *name,
+				const struct qstr *cf_name,
 				u64 dst)
 {
 	struct bkey_i_dirent *dirent;
@@ -213,13 +311,16 @@ static struct bkey_i_dirent *dirent_create_key(struct btree_trans *trans,
 	if (name->len > BCH_NAME_MAX)
 		return ERR_PTR(-ENAMETOOLONG);
 
-	dirent = dirent_alloc_key(trans, dir, type, name->len, dst);
+	dirent = dirent_alloc_key(trans, dir, type, name->len, cf_name ? cf_name->len : 0, dst);
 	if (IS_ERR(dirent))
 		return dirent;
 
-	dirent_init_regular_name(dirent, name);
+	if (cf_name)
+		dirent_init_casefolded_name(dirent, name, cf_name);
+	else
+		dirent_init_regular_name(dirent, name);
 
-	EBUG_ON(bch2_dirent_name_bytes(dirent_i_to_s_c(dirent)) != name->len);
+	EBUG_ON(bch2_dirent_get_name(dirent_i_to_s_c(dirent)).len != name->len);
 
 	return dirent;
 }
@@ -235,7 +336,7 @@ int bch2_dirent_create_snapshot(struct btree_trans *trans,
 	struct bkey_i_dirent *dirent;
 	int ret;
 
-	dirent = dirent_create_key(trans, dir_inum, type, name, dst_inum);
+	dirent = dirent_create_key(trans, dir_inum, type, name, NULL, dst_inum);
 	ret = PTR_ERR_OR_ZERO(dirent);
 	if (ret)
 		return ret;
@@ -261,7 +362,16 @@ int bch2_dirent_create(struct btree_trans *trans, subvol_inum dir,
 	struct bkey_i_dirent *dirent;
 	int ret;
 
-	dirent = dirent_create_key(trans, dir, type, name, dst_inum);
+	if (hash_info->cf_encoding) {
+		struct qstr cf_name;
+		ret = bch2_casefold(trans, hash_info, name, &cf_name);
+		if (ret)
+			return ret;
+		dirent = dirent_create_key(trans, dir, type, name, &cf_name, dst_inum);
+	} else {
+		dirent = dirent_create_key(trans, dir, type, name, NULL, dst_inum);
+	}
+
 	ret = PTR_ERR_OR_ZERO(dirent);
 	if (ret)
 		return ret;
@@ -306,6 +416,7 @@ int bch2_dirent_rename(struct btree_trans *trans,
 		const struct qstr *dst_name, subvol_inum *dst_inum, u64 *dst_offset,
 		enum bch_rename_mode mode)
 {
+	struct qstr src_name_lookup, dst_name_lookup;
 	struct btree_iter src_iter = { NULL };
 	struct btree_iter dst_iter = { NULL };
 	struct bkey_s_c old_src, old_dst = bkey_s_c_null;
@@ -320,8 +431,11 @@ int bch2_dirent_rename(struct btree_trans *trans,
 	memset(dst_inum, 0, sizeof(*dst_inum));
 
 	/* Lookup src: */
+	ret = bch2_maybe_casefold(trans, src_hash, src_name, &src_name_lookup);
+	if (ret)
+		goto out;
 	old_src = bch2_hash_lookup(trans, &src_iter, bch2_dirent_hash_desc,
-				   src_hash, src_dir, src_name,
+				   src_hash, src_dir, &src_name_lookup,
 				   BTREE_ITER_intent);
 	ret = bkey_err(old_src);
 	if (ret)
@@ -333,6 +447,9 @@ int bch2_dirent_rename(struct btree_trans *trans,
 		goto out;
 
 	/* Lookup dst: */
+	ret = bch2_maybe_casefold(trans, dst_hash, dst_name, &dst_name_lookup);
+	if (ret)
+		goto out;
 	if (mode == BCH_RENAME) {
 		/*
 		 * Note that we're _not_ checking if the target already exists -
@@ -340,12 +457,12 @@ int bch2_dirent_rename(struct btree_trans *trans,
 		 * correctness:
 		 */
 		ret = bch2_hash_hole(trans, &dst_iter, bch2_dirent_hash_desc,
-				     dst_hash, dst_dir, dst_name);
+				     dst_hash, dst_dir, &dst_name_lookup);
 		if (ret)
 			goto out;
 	} else {
 		old_dst = bch2_hash_lookup(trans, &dst_iter, bch2_dirent_hash_desc,
-					    dst_hash, dst_dir, dst_name,
+					    dst_hash, dst_dir, &dst_name_lookup,
 					    BTREE_ITER_intent);
 		ret = bkey_err(old_dst);
 		if (ret)
@@ -361,7 +478,8 @@ int bch2_dirent_rename(struct btree_trans *trans,
 		*src_offset = dst_iter.pos.offset;
 
 	/* Create new dst key: */
-	new_dst = dirent_create_key(trans, dst_dir, 0, dst_name, 0);
+	new_dst = dirent_create_key(trans, dst_dir, 0, dst_name,
+				    dst_hash->cf_encoding ? &dst_name_lookup : NULL, 0);
 	ret = PTR_ERR_OR_ZERO(new_dst);
 	if (ret)
 		goto out;
@@ -371,7 +489,8 @@ int bch2_dirent_rename(struct btree_trans *trans,
 
 	/* Create new src key: */
 	if (mode == BCH_RENAME_EXCHANGE) {
-		new_src = dirent_create_key(trans, src_dir, 0, src_name, 0);
+		new_src = dirent_create_key(trans, src_dir, 0, src_name,
+					    src_hash->cf_encoding ? &src_name_lookup : NULL, 0);
 		ret = PTR_ERR_OR_ZERO(new_src);
 		if (ret)
 			goto out;
@@ -498,9 +617,14 @@ int bch2_dirent_lookup_trans(struct btree_trans *trans,
 			     const struct qstr *name, subvol_inum *inum,
 			     unsigned flags)
 {
+	struct qstr lookup_name;
+	int ret = bch2_maybe_casefold(trans, hash_info, name, &lookup_name);
+	if (ret)
+		return ret;
+
 	struct bkey_s_c k = bch2_hash_lookup(trans, iter, bch2_dirent_hash_desc,
-					     hash_info, dir, name, flags);
-	int ret = bkey_err(k);
+					     hash_info, dir, &lookup_name, flags);
+	ret = bkey_err(k);
 	if (ret)
 		goto err;
 
diff --git a/fs/bcachefs/dirent.h b/fs/bcachefs/dirent.h
index 37f01c1a3f7f..a6e15a012936 100644
--- a/fs/bcachefs/dirent.h
+++ b/fs/bcachefs/dirent.h
@@ -25,10 +25,13 @@ struct bch_inode_info;
 
 struct qstr bch2_dirent_get_name(struct bkey_s_c_dirent d);
 
-static inline unsigned dirent_val_u64s(unsigned len)
+static inline unsigned dirent_val_u64s(unsigned len, unsigned cf_len)
 {
-	return DIV_ROUND_UP(offsetof(struct bch_dirent, d_name) + len,
-			    sizeof(u64));
+	unsigned bytes = cf_len
+		? offsetof(struct bch_dirent, d_cf_name_block.d_names) + len + cf_len
+		: offsetof(struct bch_dirent, d_name) + len;
+
+	return DIV_ROUND_UP(bytes, sizeof(u64));
 }
 
 int bch2_dirent_read_target(struct btree_trans *, subvol_inum,
diff --git a/fs/bcachefs/dirent_format.h b/fs/bcachefs/dirent_format.h
index 5e116b88e814..2e766032e1e9 100644
--- a/fs/bcachefs/dirent_format.h
+++ b/fs/bcachefs/dirent_format.h
@@ -29,9 +29,25 @@ struct bch_dirent {
 	 * Copy of mode bits 12-15 from the target inode - so userspace can get
 	 * the filetype without having to do a stat()
 	 */
-	__u8			d_type;
+#if defined(__LITTLE_ENDIAN_BITFIELD)
+	__u8			d_type:5,
+				d_unused:2,
+				d_casefold:1;
+#elif defined(__BIG_ENDIAN_BITFIELD)
+	__u8			d_casefold:1,
+				d_unused:2,
+				d_type:5;
+#endif
 
-	__u8			d_name[];
+	union {
+	struct {
+		__u8		d_pad;
+		__le16		d_name_len;
+		__le16		d_cf_name_len;
+		__u8		d_names[0];
+	} d_cf_name_block __packed;
+	__u8			d_name[0];
+	} __packed;
 } __packed __aligned(8);
 
 #define DT_SUBVOL	16
diff --git a/fs/bcachefs/fs-ioctl.c b/fs/bcachefs/fs-ioctl.c
index 15725b4ce393..4465a2a821e3 100644
--- a/fs/bcachefs/fs-ioctl.c
+++ b/fs/bcachefs/fs-ioctl.c
@@ -54,6 +54,31 @@ static int bch2_inode_flags_set(struct btree_trans *trans,
 	    (newflags & (BCH_INODE_nodump|BCH_INODE_noatime)) != newflags)
 		return -EINVAL;
 
+	if ((newflags ^ oldflags) & BCH_INODE_casefolded) {
+#ifdef CONFIG_UNICODE
+		int ret = 0;
+		/* Not supported on individual files. */
+		if (!S_ISDIR(bi->bi_mode))
+			return -EOPNOTSUPP;
+
+		/*
+		 * Make sure the dir is empty, as otherwise we'd need to
+		 * rehash everything and update the dirent keys.
+		 */
+		ret = bch2_empty_dir_trans(trans, inode_inum(inode));
+		if (ret < 0)
+			return ret;
+
+		if (!bch2_request_incompat_feature(c,bcachefs_metadata_version_casefolding))
+			return -EOPNOTSUPP;
+
+		bch2_check_set_feature(c, BCH_FEATURE_casefolding);
+#else
+		printk(KERN_ERR "Cannot use casefolding on a kernel without CONFIG_UNICODE\n");
+		return -EOPNOTSUPP;
+#endif
+	}
+
 	if (s->set_projinherit) {
 		bi->bi_fields_set &= ~(1 << Inode_opt_project);
 		bi->bi_fields_set |= ((int) s->projinherit << Inode_opt_project);
diff --git a/fs/bcachefs/fs-ioctl.h b/fs/bcachefs/fs-ioctl.h
index d30f9bb056fd..ecd3bfdcde21 100644
--- a/fs/bcachefs/fs-ioctl.h
+++ b/fs/bcachefs/fs-ioctl.h
@@ -6,19 +6,21 @@
 
 /* bcachefs inode flags -> vfs inode flags: */
 static const __maybe_unused unsigned bch_flags_to_vfs[] = {
-	[__BCH_INODE_sync]	= S_SYNC,
-	[__BCH_INODE_immutable]	= S_IMMUTABLE,
-	[__BCH_INODE_append]	= S_APPEND,
-	[__BCH_INODE_noatime]	= S_NOATIME,
+	[__BCH_INODE_sync]		= S_SYNC,
+	[__BCH_INODE_immutable]		= S_IMMUTABLE,
+	[__BCH_INODE_append]		= S_APPEND,
+	[__BCH_INODE_noatime]		= S_NOATIME,
+	[__BCH_INODE_casefolded]	= S_CASEFOLD,
 };
 
 /* bcachefs inode flags -> FS_IOC_GETFLAGS: */
 static const __maybe_unused unsigned bch_flags_to_uflags[] = {
-	[__BCH_INODE_sync]	= FS_SYNC_FL,
-	[__BCH_INODE_immutable]	= FS_IMMUTABLE_FL,
-	[__BCH_INODE_append]	= FS_APPEND_FL,
-	[__BCH_INODE_nodump]	= FS_NODUMP_FL,
-	[__BCH_INODE_noatime]	= FS_NOATIME_FL,
+	[__BCH_INODE_sync]		= FS_SYNC_FL,
+	[__BCH_INODE_immutable]		= FS_IMMUTABLE_FL,
+	[__BCH_INODE_append]		= FS_APPEND_FL,
+	[__BCH_INODE_nodump]		= FS_NODUMP_FL,
+	[__BCH_INODE_noatime]		= FS_NOATIME_FL,
+	[__BCH_INODE_casefolded]	= FS_CASEFOLD_FL,
 };
 
 /* bcachefs inode flags -> FS_IOC_FSGETXATTR: */
diff --git a/fs/bcachefs/fs.c b/fs/bcachefs/fs.c
index 90ade8f648d9..ad9eaad0f2fb 100644
--- a/fs/bcachefs/fs.c
+++ b/fs/bcachefs/fs.c
@@ -698,6 +698,23 @@ static struct dentry *bch2_lookup(struct inode *vdir, struct dentry *dentry,
 	if (IS_ERR(inode))
 		inode = NULL;
 
+#ifdef CONFIG_UNICODE
+	if (!inode && IS_CASEFOLDED(vdir)) {
+		/*
+		 * Do not cache a negative dentry in casefolded directories
+		 * as it would need to be invalidated in the following situation:
+		 * - Lookup file "blAH" in a casefolded directory
+		 * - Creation of file "BLAH" in a casefolded directory
+		 * - Lookup file "blAH" in a casefolded directory
+		 * which would fail if we had a negative dentry.
+		 *
+		 * We should come back to this when VFS has a method to handle
+		 * this edgecase.
+		 */
+		return NULL;
+	}
+#endif
+
 	return d_splice_alias(&inode->v, dentry);
 }
 
diff --git a/fs/bcachefs/inode_format.h b/fs/bcachefs/inode_format.h
index b99a5bf1a75e..117110af1e3f 100644
--- a/fs/bcachefs/inode_format.h
+++ b/fs/bcachefs/inode_format.h
@@ -137,7 +137,8 @@ enum inode_opt_id {
 	x(i_sectors_dirty,		6)	\
 	x(unlinked,			7)	\
 	x(backptr_untrusted,		8)	\
-	x(has_child_snapshot,		9)
+	x(has_child_snapshot,		9)	\
+	x(casefolded,			10)
 
 /* bits 20+ reserved for packed fields below: */
 
diff --git a/fs/bcachefs/sb-errors_format.h b/fs/bcachefs/sb-errors_format.h
index b86ec013d7d7..cdafd877b8a1 100644
--- a/fs/bcachefs/sb-errors_format.h
+++ b/fs/bcachefs/sb-errors_format.h
@@ -314,7 +314,9 @@ enum bch_fsck_flags {
 	x(compression_opt_not_marked_in_sb,			295,	FSCK_AUTOFIX)	\
 	x(compression_type_not_marked_in_sb,			296,	FSCK_AUTOFIX)	\
 	x(directory_size_mismatch,				303,	FSCK_AUTOFIX)	\
-	x(MAX,							304,	0)
+	x(dirent_cf_name_too_big,				304,	0)		\
+	x(dirent_stray_data_after_cf_name,			305,	0)		\
+	x(MAX,							306,	0)
 
 enum bch_sb_error_id {
 #define x(t, n, ...) BCH_FSCK_ERR_##t = n,
diff --git a/fs/bcachefs/str_hash.c b/fs/bcachefs/str_hash.c
index d78451c2a0c6..93e71119e5a4 100644
--- a/fs/bcachefs/str_hash.c
+++ b/fs/bcachefs/str_hash.c
@@ -50,7 +50,7 @@ static noinline int fsck_rename_dirent(struct btree_trans *trans,
 	for (unsigned i = 0; i < 1000; i++) {
 		unsigned len = sprintf(new->v.d_name, "%.*s.fsck_renamed-%u",
 				       old_name.len, old_name.name, i);
-		unsigned u64s = BKEY_U64s + dirent_val_u64s(len);
+		unsigned u64s = BKEY_U64s + dirent_val_u64s(len, 0);
 
 		if (u64s > U8_MAX)
 			return -EINVAL;
diff --git a/fs/bcachefs/str_hash.h b/fs/bcachefs/str_hash.h
index 55a4ac7bf220..f645a4547b04 100644
--- a/fs/bcachefs/str_hash.h
+++ b/fs/bcachefs/str_hash.h
@@ -34,6 +34,7 @@ bch2_str_hash_opt_to_type(struct bch_fs *c, enum bch_str_hash_opts opt)
 
 struct bch_hash_info {
 	u8			type;
+	struct unicode_map 	*cf_encoding;
 	/*
 	 * For crc32 or crc64 string hashes the first key value of
 	 * the siphash_key (k0) is used as the key.
@@ -47,6 +48,9 @@ bch2_hash_info_init(struct bch_fs *c, const struct bch_inode_unpacked *bi)
 	/* XXX ick */
 	struct bch_hash_info info = {
 		.type = INODE_STR_HASH(bi),
+#ifdef CONFIG_UNICODE
+		.cf_encoding = !!(bi->bi_flags & BCH_INODE_casefolded) ? c->cf_encoding : NULL,
+#endif
 		.siphash_key = { .k0 = bi->bi_hash_seed }
 	};
 
diff --git a/fs/bcachefs/super.c b/fs/bcachefs/super.c
index 6d97d412fed9..10c281ad96eb 100644
--- a/fs/bcachefs/super.c
+++ b/fs/bcachefs/super.c
@@ -837,6 +837,25 @@ static struct bch_fs *bch2_fs_alloc(struct bch_sb *sb, struct bch_opts opts)
 	if (ret)
 		goto err;
 
+#ifdef CONFIG_UNICODE
+	/* Default encoding until we can potentially have more as an option. */
+	c->cf_encoding = utf8_load(BCH_FS_DEFAULT_UTF8_ENCODING);
+	if (IS_ERR(c->cf_encoding)) {
+		printk(KERN_ERR "Cannot load UTF-8 encoding for filesystem. Version: %u.%u.%u",
+			unicode_major(BCH_FS_DEFAULT_UTF8_ENCODING),
+			unicode_minor(BCH_FS_DEFAULT_UTF8_ENCODING),
+			unicode_rev(BCH_FS_DEFAULT_UTF8_ENCODING));
+		ret = -EINVAL;
+		goto err;
+	}
+#else
+	if (c->sb.features & BIT_ULL(BCH_FEATURE_casefolding)) {
+		printk(KERN_ERR "Cannot mount a filesystem with casefolding on a kernel without CONFIG_UNICODE\n");
+		ret = -EINVAL;
+		goto err;
+	}
+#endif
+
 	pr_uuid(&name, c->sb.user_uuid.b);
 	ret = name.allocation_failure ? -BCH_ERR_ENOMEM_fs_name_alloc : 0;
 	if (ret)
-- 
2.45.2


Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40AA21367
	for <linux-bcachefs@vger.kernel.org>; Sun, 31 Dec 2023 05:16:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="mHC7vEwx"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1703999779;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=B6Z1jHzlsoNS4OhResZ7kpsNYUTVY4s86AFF/TyALzg=;
	b=mHC7vEwxKW8Rw+Kir7tI4M5pBXPQL+wB+yeLWqEpL+AmF0k/7+OKu1CLGg79a1Vbr0BDno
	N1frjgMEPCqBu7jAsJpX/464/SEZElmJ9prUaGvDX+yfq8RbAH9wk7oJmW4R+q5wrMlT4b
	sbD/PtXkjWfuuo9AYEDuoNhf5ACsQWc=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 2/3] bcachefs: bch_sb.recovery_passes_required
Date: Sun, 31 Dec 2023 00:16:07 -0500
Message-ID: <20231231051608.2558476-2-kent.overstreet@linux.dev>
In-Reply-To: <20231231051608.2558476-1-kent.overstreet@linux.dev>
References: <20231231051608.2558476-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Add two new superblock fields. Since the main section of the superblock
is now fully, we have to add a new variable length section for them -
bch_sb_field_ext.

 - recovery_passes_requried: recovery passes that must be run on the
   next mount
 - errors_silent: errors that will be silently fixed

These are to improve upgrading and dwongrading: these fields won't be
cleared until after recovery successfully completes, so there won't be
any issues with crashing partway through an upgrade or a downgrade.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/bcachefs.h        |  1 +
 fs/bcachefs/bcachefs_format.h | 33 +++++++++------
 fs/bcachefs/errcode.h         |  1 +
 fs/bcachefs/error.c           |  3 ++
 fs/bcachefs/recovery.c        | 76 ++++++++++++++++++++++++++++-------
 fs/bcachefs/sb-errors.c       |  2 +-
 fs/bcachefs/sb-errors.h       |  2 +
 fs/bcachefs/super-io.c        | 73 +++++++++++++++++++++++++++++++++
 fs/bcachefs/super-io.h        | 10 +++++
 9 files changed, 172 insertions(+), 29 deletions(-)

diff --git a/fs/bcachefs/bcachefs.h b/fs/bcachefs/bcachefs.h
index 3926e9e3ba96..840f605eff1f 100644
--- a/fs/bcachefs/bcachefs.h
+++ b/fs/bcachefs/bcachefs.h
@@ -796,6 +796,7 @@ struct bch_fs {
 		unsigned	nsec_per_time_unit;
 		u64		features;
 		u64		compat;
+		unsigned long	errors_silent[BITS_TO_LONGS(BCH_SB_ERR_MAX)];
 	}			sb;
 
 
diff --git a/fs/bcachefs/bcachefs_format.h b/fs/bcachefs/bcachefs_format.h
index 2105198daf3b..b649e0cff9ba 100644
--- a/fs/bcachefs/bcachefs_format.h
+++ b/fs/bcachefs/bcachefs_format.h
@@ -1214,19 +1214,20 @@ struct bch_sb_field {
 };
 
 #define BCH_SB_FIELDS()				\
-	x(journal,	0)			\
-	x(members_v1,	1)			\
-	x(crypt,	2)			\
-	x(replicas_v0,	3)			\
-	x(quota,	4)			\
-	x(disk_groups,	5)			\
-	x(clean,	6)			\
-	x(replicas,	7)			\
-	x(journal_seq_blacklist, 8)		\
-	x(journal_v2,	9)			\
-	x(counters,	10)			\
-	x(members_v2,	11)			\
-	x(errors,	12)
+	x(journal,			0)	\
+	x(members_v1,			1)	\
+	x(crypt,			2)	\
+	x(replicas_v0,			3)	\
+	x(quota,			4)	\
+	x(disk_groups,			5)	\
+	x(clean,			6)	\
+	x(replicas,			7)	\
+	x(journal_seq_blacklist,	8)	\
+	x(journal_v2,			9)	\
+	x(counters,			10)	\
+	x(members_v2,			11)	\
+	x(errors,			12)	\
+	x(ext,				13)
 
 enum bch_sb_field_type {
 #define x(f, nr)	BCH_SB_FIELD_##f = nr,
@@ -1641,6 +1642,12 @@ struct bch_sb_field_errors {
 LE64_BITMASK(BCH_SB_ERROR_ENTRY_ID,	struct bch_sb_field_error_entry, v,  0, 16);
 LE64_BITMASK(BCH_SB_ERROR_ENTRY_NR,	struct bch_sb_field_error_entry, v, 16, 64);
 
+struct bch_sb_field_ext {
+	struct bch_sb_field	field;
+	__le64			recovery_passes_required[2];
+	__le64			errors_silent[8];
+};
+
 /* Superblock: */
 
 /*
diff --git a/fs/bcachefs/errcode.h b/fs/bcachefs/errcode.h
index f827db54438c..ecd24c068277 100644
--- a/fs/bcachefs/errcode.h
+++ b/fs/bcachefs/errcode.h
@@ -218,6 +218,7 @@
 	x(BCH_ERR_invalid_sb,		invalid_sb_quota)			\
 	x(BCH_ERR_invalid_sb,		invalid_sb_errors)			\
 	x(BCH_ERR_invalid_sb,		invalid_sb_opt_compression)		\
+	x(BCH_ERR_invalid_sb,		invalid_sb_ext)				\
 	x(BCH_ERR_invalid,		invalid_bkey)				\
 	x(BCH_ERR_operation_blocked,    nocow_lock_blocked)			\
 	x(EIO,				btree_node_read_err)			\
diff --git a/fs/bcachefs/error.c b/fs/bcachefs/error.c
index 655e3ba9bfd2..aa4f7f4925f6 100644
--- a/fs/bcachefs/error.c
+++ b/fs/bcachefs/error.c
@@ -152,6 +152,9 @@ int bch2_fsck_err(struct bch_fs *c,
 	struct printbuf buf = PRINTBUF, *out = &buf;
 	int ret = -BCH_ERR_fsck_ignore;
 
+	if (test_bit(err, c->sb.errors_silent))
+		return -BCH_ERR_fsck_fix;
+
 	bch2_sb_error_count(c, err);
 
 	va_start(args, fmt);
diff --git a/fs/bcachefs/recovery.c b/fs/bcachefs/recovery.c
index e205e7233ef6..c7b3b3a460a5 100644
--- a/fs/bcachefs/recovery.c
+++ b/fs/bcachefs/recovery.c
@@ -574,13 +574,12 @@ u64 bch2_recovery_passes_from_stable(u64 v)
 	return ret;
 }
 
-static void check_version_upgrade(struct bch_fs *c)
+static bool check_version_upgrade(struct bch_fs *c)
 {
 	unsigned latest_compatible = bch2_latest_compatible_version(c->sb.version);
 	unsigned latest_version	= bcachefs_metadata_version_current;
 	unsigned old_version = c->sb.version_upgrade_complete ?: c->sb.version;
 	unsigned new_version = 0;
-	u64 recovery_passes;
 
 	if (old_version < bcachefs_metadata_required_upgrade_below) {
 		if (c->opts.version_upgrade == BCH_VERSION_UPGRADE_incompatible ||
@@ -624,7 +623,7 @@ static void check_version_upgrade(struct bch_fs *c)
 		bch2_version_to_text(&buf, new_version);
 		prt_newline(&buf);
 
-		recovery_passes = bch2_upgrade_recovery_passes(c, old_version, new_version);
+		u64 recovery_passes = bch2_upgrade_recovery_passes(c, old_version, new_version);
 		if (recovery_passes) {
 			if ((recovery_passes & RECOVERY_PASS_ALL_FSCK) == RECOVERY_PASS_ALL_FSCK)
 				prt_str(&buf, "fsck required");
@@ -639,12 +638,13 @@ static void check_version_upgrade(struct bch_fs *c)
 
 		bch_info(c, "%s", buf.buf);
 
-		mutex_lock(&c->sb_lock);
 		bch2_sb_upgrade(c, new_version);
-		mutex_unlock(&c->sb_lock);
 
 		printbuf_exit(&buf);
+		return true;
 	}
+
+	return false;
 }
 
 u64 bch2_fsck_recovery_passes(void)
@@ -739,7 +739,6 @@ int bch2_fs_recovery(struct bch_fs *c)
 	struct bch_sb_field_clean *clean = NULL;
 	struct jset *last_journal_entry = NULL;
 	u64 last_seq = 0, blacklist_seq, journal_seq;
-	bool write_sb = false;
 	int ret = 0;
 
 	if (c->sb.clean) {
@@ -767,15 +766,53 @@ int bch2_fs_recovery(struct bch_fs *c)
 		goto err;
 	}
 
-	if (!(c->opts.nochanges && c->opts.norecovery))
-		check_version_upgrade(c);
-
 	if (c->opts.fsck && c->opts.norecovery) {
 		bch_err(c, "cannot select both norecovery and fsck");
 		ret = -EINVAL;
 		goto err;
 	}
 
+	if (!(c->opts.nochanges && c->opts.norecovery)) {
+		mutex_lock(&c->sb_lock);
+		bool write_sb = false;
+
+		struct bch_sb_field_ext *ext =
+			bch2_sb_field_get_minsize(&c->disk_sb, ext, sizeof(*ext) / sizeof(u64));
+		if (!ext) {
+			ret = -BCH_ERR_ENOSPC_sb;
+			mutex_unlock(&c->sb_lock);
+			goto err;
+		}
+
+		if (BCH_SB_HAS_TOPOLOGY_ERRORS(c->disk_sb.sb)) {
+			ext->recovery_passes_required[0] |=
+				cpu_to_le64(bch2_recovery_passes_to_stable(BIT_ULL(BCH_RECOVERY_PASS_check_topology)));
+			write_sb = true;
+		}
+
+		u64 sb_passes = bch2_recovery_passes_from_stable(le64_to_cpu(ext->recovery_passes_required[0]));
+		if (sb_passes) {
+			struct printbuf buf = PRINTBUF;
+			prt_str(&buf, "superblock requires following recovery passes to be run:\n  ");
+			prt_bitflags(&buf, bch2_recovery_passes, sb_passes);
+			bch_info(c, "%s", buf.buf);
+			printbuf_exit(&buf);
+			c->recovery_passes_explicit |= sb_passes;
+		}
+
+		if (check_version_upgrade(c))
+			write_sb = true;
+
+		if (write_sb)
+			bch2_write_super(c);
+
+		c->recovery_passes_explicit |= bch2_recovery_passes_from_stable(le64_to_cpu(ext->recovery_passes_required[0]));
+		mutex_unlock(&c->sb_lock);
+	}
+
+	if (c->opts.fsck && IS_ENABLED(CONFIG_BCACHEFS_DEBUG))
+		c->recovery_passes_explicit |= BIT_ULL(BCH_RECOVERY_PASS_check_topology);
+
 	ret = bch2_blacklist_table_initialize(c);
 	if (ret) {
 		bch_err(c, "error initializing blacklist table");
@@ -912,11 +949,6 @@ int bch2_fs_recovery(struct bch_fs *c)
 	if (ret)
 		goto err;
 
-	if (c->opts.fsck &&
-	    (IS_ENABLED(CONFIG_BCACHEFS_DEBUG) ||
-	     BCH_SB_HAS_TOPOLOGY_ERRORS(c->disk_sb.sb)))
-		c->recovery_passes_explicit |= BIT_ULL(BCH_RECOVERY_PASS_check_topology);
-
 	ret = bch2_run_recovery_passes(c);
 	if (ret)
 		goto err;
@@ -955,16 +987,30 @@ int bch2_fs_recovery(struct bch_fs *c)
 	}
 
 	mutex_lock(&c->sb_lock);
+	bool write_sb = false;
+
 	if (BCH_SB_VERSION_UPGRADE_COMPLETE(c->disk_sb.sb) != le16_to_cpu(c->disk_sb.sb->version)) {
 		SET_BCH_SB_VERSION_UPGRADE_COMPLETE(c->disk_sb.sb, le16_to_cpu(c->disk_sb.sb->version));
 		write_sb = true;
 	}
 
-	if (!test_bit(BCH_FS_error, &c->flags)) {
+	if (!test_bit(BCH_FS_error, &c->flags) &&
+	    !(c->disk_sb.sb->compat[0] & cpu_to_le64(1ULL << BCH_COMPAT_alloc_info))) {
 		c->disk_sb.sb->compat[0] |= cpu_to_le64(1ULL << BCH_COMPAT_alloc_info);
 		write_sb = true;
 	}
 
+	if (!test_bit(BCH_FS_error, &c->flags)) {
+		struct bch_sb_field_ext *ext = bch2_sb_field_get(c->disk_sb.sb, ext);
+		if (ext &&
+		    (!bch2_is_zero(ext->recovery_passes_required, sizeof(ext->recovery_passes_required)) ||
+		     !bch2_is_zero(ext->errors_silent, sizeof(ext->errors_silent)))) {
+			memset(ext->recovery_passes_required, 0, sizeof(ext->recovery_passes_required));
+			memset(ext->errors_silent, 0, sizeof(ext->errors_silent));
+			write_sb = true;
+		}
+	}
+
 	if (c->opts.fsck &&
 	    !test_bit(BCH_FS_error, &c->flags) &&
 	    !test_bit(BCH_FS_errors_not_fixed, &c->flags)) {
diff --git a/fs/bcachefs/sb-errors.c b/fs/bcachefs/sb-errors.c
index f0930ab7f036..caf7669db6a1 100644
--- a/fs/bcachefs/sb-errors.c
+++ b/fs/bcachefs/sb-errors.c
@@ -4,7 +4,7 @@
 #include "sb-errors.h"
 #include "super-io.h"
 
-static const char * const bch2_sb_error_strs[] = {
+const char * const bch2_sb_error_strs[] = {
 #define x(t, n, ...) [n] = #t,
 	BCH_SB_ERRS()
 	NULL
diff --git a/fs/bcachefs/sb-errors.h b/fs/bcachefs/sb-errors.h
index 27e5dc7884bb..8889001e7db4 100644
--- a/fs/bcachefs/sb-errors.h
+++ b/fs/bcachefs/sb-errors.h
@@ -4,6 +4,8 @@
 
 #include "sb-errors_types.h"
 
+extern const char * const bch2_sb_error_strs[];
+
 extern const struct bch_sb_field_ops bch_sb_field_ops_errors;
 
 void bch2_sb_error_count(struct bch_fs *, enum bch_sb_error_id);
diff --git a/fs/bcachefs/super-io.c b/fs/bcachefs/super-io.c
index c80a993ec982..cccded38337f 100644
--- a/fs/bcachefs/super-io.c
+++ b/fs/bcachefs/super-io.c
@@ -260,6 +260,17 @@ struct bch_sb_field *bch2_sb_field_resize_id(struct bch_sb_handle *sb,
 	return f;
 }
 
+struct bch_sb_field *bch2_sb_field_get_minsize_id(struct bch_sb_handle *sb,
+						  enum bch_sb_field_type type,
+						  unsigned u64s)
+{
+	struct bch_sb_field *f = bch2_sb_field_get_id(sb->sb, type);
+
+	if (!f || le32_to_cpu(f->u64s) < u64s)
+		f = bch2_sb_field_resize_id(sb, type, u64s);
+	return f;
+}
+
 /* Superblock validate: */
 
 static int validate_sb_layout(struct bch_sb_layout *layout, struct printbuf *out)
@@ -479,6 +490,21 @@ static int bch2_sb_validate(struct bch_sb_handle *disk_sb, struct printbuf *out,
 
 /* device open: */
 
+static unsigned long le_ulong_to_cpu(unsigned long v)
+{
+	return sizeof(unsigned long) == 8
+		? le64_to_cpu(v)
+		: le32_to_cpu(v);
+}
+
+static void le_bitvector_to_cpu(unsigned long *dst, unsigned long *src, unsigned nr)
+{
+	BUG_ON(nr & (BITS_PER_TYPE(long) - 1));
+
+	for (unsigned i = 0; i < BITS_TO_LONGS(nr); i++)
+		dst[i] = le_ulong_to_cpu(src[i]);
+}
+
 static void bch2_sb_update(struct bch_fs *c)
 {
 	struct bch_sb *src = c->disk_sb.sb;
@@ -505,6 +531,13 @@ static void bch2_sb_update(struct bch_fs *c)
 	c->sb.features		= le64_to_cpu(src->features[0]);
 	c->sb.compat		= le64_to_cpu(src->compat[0]);
 
+	memset(c->sb.errors_silent, 0, sizeof(c->sb.errors_silent));
+
+	struct bch_sb_field_ext *ext = bch2_sb_field_get(src, ext);
+	if (ext)
+		le_bitvector_to_cpu(c->sb.errors_silent, (void *) ext->errors_silent,
+				    sizeof(c->sb.errors_silent) * 8);
+
 	for_each_member_device(c, ca) {
 		struct bch_member m = bch2_sb_member_get(src, ca->dev_idx);
 		ca->mi = bch2_mi_to_cpu(&m);
@@ -1085,6 +1118,46 @@ void bch2_sb_upgrade(struct bch_fs *c, unsigned new_version)
 	c->disk_sb.sb->features[0] |= cpu_to_le64(BCH_SB_FEATURES_ALL);
 }
 
+static int bch2_sb_ext_validate(struct bch_sb *sb, struct bch_sb_field *f,
+				struct printbuf *err)
+{
+	if (vstruct_bytes(f) < 88) {
+		prt_printf(err, "field too small (%zu < %u)", vstruct_bytes(f), 88);
+		return -BCH_ERR_invalid_sb_ext;
+	}
+
+	return 0;
+}
+
+static void bch2_sb_ext_to_text(struct printbuf *out, struct bch_sb *sb,
+				struct bch_sb_field *f)
+{
+	struct bch_sb_field_ext *e = field_to_type(f, ext);
+
+	prt_printf(out, "Recovery passes required:");
+	prt_tab(out);
+	prt_bitflags(out, bch2_recovery_passes,
+		     bch2_recovery_passes_from_stable(le64_to_cpu(e->recovery_passes_required[0])));
+	prt_newline(out);
+
+	unsigned long *errors_silent = kmalloc(sizeof(e->errors_silent), GFP_KERNEL);
+	if (errors_silent) {
+		le_bitvector_to_cpu(errors_silent, (void *) e->errors_silent, sizeof(e->errors_silent) * 8);
+
+		prt_printf(out, "Errors to silently fix:");
+		prt_tab(out);
+		prt_bitflags_vector(out, bch2_sb_error_strs, errors_silent, sizeof(e->errors_silent) * 8);
+		prt_newline(out);
+
+		kfree(errors_silent);
+	}
+}
+
+static const struct bch_sb_field_ops bch_sb_field_ops_ext = {
+	.validate	= bch2_sb_ext_validate,
+	.to_text	= bch2_sb_ext_to_text,
+};
+
 static const struct bch_sb_field_ops *bch2_sb_field_ops[] = {
 #define x(f, nr)					\
 	[BCH_SB_FIELD_##f] = &bch_sb_field_ops_##f,
diff --git a/fs/bcachefs/super-io.h b/fs/bcachefs/super-io.h
index e6f40a054319..1a8c2088c5c5 100644
--- a/fs/bcachefs/super-io.h
+++ b/fs/bcachefs/super-io.h
@@ -40,6 +40,16 @@ struct bch_sb_field *bch2_sb_field_resize_id(struct bch_sb_handle *,
 #define bch2_sb_field_resize(_sb, _name, _u64s)				\
 	field_to_type(bch2_sb_field_resize_id(_sb, BCH_SB_FIELD_##_name, _u64s), _name)
 
+struct bch_sb_field *bch2_sb_field_get_minsize_id(struct bch_sb_handle *,
+					enum bch_sb_field_type, unsigned);
+#define bch2_sb_field_get_minsize(_sb, _name, _u64s)				\
+	field_to_type(bch2_sb_field_get_minsize_id(_sb, BCH_SB_FIELD_##_name, _u64s), _name)
+
+#define bch2_sb_field_nr_entries(_f)					\
+	(_f ? ((bch2_sb_field_bytes(&_f->field) - sizeof(*_f)) /	\
+	       sizeof(_f->entries[0]))					\
+	    : 0)
+
 void bch2_sb_field_delete(struct bch_sb_handle *, enum bch_sb_field_type);
 
 extern const char * const bch2_sb_fields[];
-- 
2.43.0


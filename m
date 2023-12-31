Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF6B51371
	for <linux-bcachefs@vger.kernel.org>; Sun, 31 Dec 2023 05:16:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="OLTP1d1Q"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1703999779;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BzH54R1r6C/CjyUSdiMpDdR53Sei2GM4AzGw/9XjI2w=;
	b=OLTP1d1QOzC8xlxtSVKmgWFLj+ntljqAXlSg83bV2rZpr08of2a1s0ADE0Pq6b6klcnHFE
	VykCoX98bZYEYOF65FA+7mKoU3XdSkSo5edw45QbdmbSd1QzPmdYCCWm7LqsNmLuEu0cXo
	aResR4/XrBReAKDCoM87RGbpwX2/834=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 3/3] bcachefs: bch_sb_field_downgrade
Date: Sun, 31 Dec 2023 00:16:08 -0500
Message-ID: <20231231051608.2558476-3-kent.overstreet@linux.dev>
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

Add a new superblock section that contains a list of
  { minor version, recovery passes, errors_to_fix }

that is - a list of recovery passes that must be run when downgrading
past a given version, and a list of errors to silently fix.

The upcoming disk accounting rewrite is not going to be fully
compatible: we're going to have to regenerate accounting both when
upgrading to the new version, and also from downgrading from the new
version, since the new method of doing disk space accounting is a
completely different architecture based on deltas, and synchronizing
them for every jounal entry write to maintain compatibility is going to
be too expensive and impractical.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/Makefile          |   1 +
 fs/bcachefs/bcachefs_format.h |  20 +++-
 fs/bcachefs/errcode.h         |   2 +
 fs/bcachefs/recovery.c        |  29 ++++++
 fs/bcachefs/sb-clean.c        |   2 -
 fs/bcachefs/sb-downgrade.c    | 190 ++++++++++++++++++++++++++++++++++
 fs/bcachefs/sb-downgrade.h    |  10 ++
 fs/bcachefs/sb-errors.c       |   4 +-
 fs/bcachefs/super-io.c        |   6 ++
 9 files changed, 258 insertions(+), 6 deletions(-)
 create mode 100644 fs/bcachefs/sb-downgrade.c
 create mode 100644 fs/bcachefs/sb-downgrade.h

diff --git a/fs/bcachefs/Makefile b/fs/bcachefs/Makefile
index ed550a40463e..b81268418174 100644
--- a/fs/bcachefs/Makefile
+++ b/fs/bcachefs/Makefile
@@ -71,6 +71,7 @@ bcachefs-y		:=	\
 	reflink.o		\
 	replicas.o		\
 	sb-clean.o		\
+	sb-downgrade.o		\
 	sb-errors.o		\
 	sb-members.o		\
 	siphash.o		\
diff --git a/fs/bcachefs/bcachefs_format.h b/fs/bcachefs/bcachefs_format.h
index b649e0cff9ba..eb2df422ae5a 100644
--- a/fs/bcachefs/bcachefs_format.h
+++ b/fs/bcachefs/bcachefs_format.h
@@ -1227,7 +1227,8 @@ struct bch_sb_field {
 	x(counters,			10)	\
 	x(members_v2,			11)	\
 	x(errors,			12)	\
-	x(ext,				13)
+	x(ext,				13)	\
+	x(downgrade,			14)
 
 enum bch_sb_field_type {
 #define x(f, nr)	BCH_SB_FIELD_##f = nr,
@@ -1648,6 +1649,18 @@ struct bch_sb_field_ext {
 	__le64			errors_silent[8];
 };
 
+struct bch_sb_field_downgrade_entry {
+	__le16			version;
+	__le64			recovery_passes[2];
+	__le16			nr_errors;
+	__le16			errors[] __counted_by(nr_errors);
+} __packed __aligned(2);
+
+struct bch_sb_field_downgrade {
+	struct bch_sb_field	field;
+	struct bch_sb_field_downgrade_entry entries[];
+};
+
 /* Superblock: */
 
 /*
@@ -1661,6 +1674,11 @@ struct bch_sb_field_ext {
 
 #define RECOVERY_PASS_ALL_FSCK		(1ULL << 63)
 
+/*
+ * field 1:		version name
+ * field 2:		BCH_VERSION(major, minor)
+ * field 3:		recovery passess required on upgrade
+ */
 #define BCH_METADATA_VERSIONS()						\
 	x(bkey_renumber,		BCH_VERSION(0, 10),		\
 	  RECOVERY_PASS_ALL_FSCK)					\
diff --git a/fs/bcachefs/errcode.h b/fs/bcachefs/errcode.h
index ecd24c068277..8c40c2067a04 100644
--- a/fs/bcachefs/errcode.h
+++ b/fs/bcachefs/errcode.h
@@ -94,6 +94,7 @@
 	x(ENOSPC,			ENOSPC_sb_members)			\
 	x(ENOSPC,			ENOSPC_sb_members_v2)			\
 	x(ENOSPC,			ENOSPC_sb_crypt)			\
+	x(ENOSPC,			ENOSPC_sb_downgrade)			\
 	x(ENOSPC,			ENOSPC_btree_slot)			\
 	x(ENOSPC,			ENOSPC_snapshot_tree)			\
 	x(ENOENT,			ENOENT_bkey_type_mismatch)		\
@@ -219,6 +220,7 @@
 	x(BCH_ERR_invalid_sb,		invalid_sb_errors)			\
 	x(BCH_ERR_invalid_sb,		invalid_sb_opt_compression)		\
 	x(BCH_ERR_invalid_sb,		invalid_sb_ext)				\
+	x(BCH_ERR_invalid_sb,		invalid_sb_downgrade)			\
 	x(BCH_ERR_invalid,		invalid_bkey)				\
 	x(BCH_ERR_operation_blocked,    nocow_lock_blocked)			\
 	x(EIO,				btree_node_read_err)			\
diff --git a/fs/bcachefs/recovery.c b/fs/bcachefs/recovery.c
index c7b3b3a460a5..0f26956f6b86 100644
--- a/fs/bcachefs/recovery.c
+++ b/fs/bcachefs/recovery.c
@@ -27,6 +27,7 @@
 #include "recovery.h"
 #include "replicas.h"
 #include "sb-clean.h"
+#include "sb-downgrade.h"
 #include "snapshot.h"
 #include "subvolume.h"
 #include "super-io.h"
@@ -800,6 +801,34 @@ int bch2_fs_recovery(struct bch_fs *c)
 			c->recovery_passes_explicit |= sb_passes;
 		}
 
+		if (bcachefs_metadata_version_current < c->sb.version) {
+			struct printbuf buf = PRINTBUF;
+
+			prt_str(&buf, "Version downgrade required:\n");
+
+			u64 passes = ext->recovery_passes_required[0];
+			ret = bch2_sb_set_downgrade(c,
+					BCH_VERSION_MINOR(bcachefs_metadata_version_current),
+					BCH_VERSION_MINOR(c->sb.version));
+			if (ret) {
+				mutex_unlock(&c->sb_lock);
+				goto err;
+			}
+
+			passes = ext->recovery_passes_required[0] & ~passes;
+			if (passes) {
+				prt_str(&buf, "  running recovery passes: ");
+				prt_bitflags(&buf, bch2_recovery_passes,
+					     bch2_recovery_passes_from_stable(le64_to_cpu(passes)));
+			}
+
+			bch_info(c, "%s", buf.buf);
+			printbuf_exit(&buf);
+
+			bch2_sb_maybe_downgrade(c);
+			write_sb = true;
+		}
+
 		if (check_version_upgrade(c))
 			write_sb = true;
 
diff --git a/fs/bcachefs/sb-clean.c b/fs/bcachefs/sb-clean.c
index ca14f86fb2a9..9632f36f5f31 100644
--- a/fs/bcachefs/sb-clean.c
+++ b/fs/bcachefs/sb-clean.c
@@ -328,8 +328,6 @@ int bch2_fs_mark_dirty(struct bch_fs *c)
 
 	mutex_lock(&c->sb_lock);
 	SET_BCH_SB_CLEAN(c->disk_sb.sb, false);
-
-	bch2_sb_maybe_downgrade(c);
 	c->disk_sb.sb->features[0] |= cpu_to_le64(BCH_SB_FEATURES_ALWAYS);
 
 	ret = bch2_write_super(c);
diff --git a/fs/bcachefs/sb-downgrade.c b/fs/bcachefs/sb-downgrade.c
new file mode 100644
index 000000000000..92bac20f6b1e
--- /dev/null
+++ b/fs/bcachefs/sb-downgrade.c
@@ -0,0 +1,190 @@
+// SPDX-License-Identifier: GPL-2.0
+
+/*
+ * Superblock section that contains a list of recovery passes to run when
+ * downgrading past a given version
+ */
+
+#include "bcachefs.h"
+#include "darray.h"
+#include "recovery.h"
+#include "sb-downgrade.h"
+#include "sb-errors.h"
+#include "super-io.h"
+
+/*
+ * Downgrade table:
+ * When dowgrading past certain versions, we need to run certain recovery passes
+ * and fix certain errors:
+ *
+ * x(version, recovery_passes, errors...)
+ */
+
+#define DOWNGRADE_TABLE()
+
+struct downgrade_entry {
+	u64		recovery_passes;
+	u16		version;
+	u16		nr_errors;
+	const u16	*errors;
+};
+
+#define x(ver, passes, ...) static const u16 ver_##errors[] = { __VA_ARGS__ };
+DOWNGRADE_TABLE()
+#undef x
+
+static const struct downgrade_entry downgrade_table[] = {
+#define x(ver, passes, ...) {					\
+	.recovery_passes	= passes,			\
+	.version		= bcachefs_metadata_version_##ver,\
+	.nr_errors		= ARRAY_SIZE(ver_##errors),	\
+	.errors			= ver_##errors,			\
+},
+DOWNGRADE_TABLE()
+#undef x
+};
+
+static inline const struct bch_sb_field_downgrade_entry *
+downgrade_entry_next_c(const struct bch_sb_field_downgrade_entry *e)
+{
+	return (void *) &e->errors[le16_to_cpu(e->nr_errors)];
+}
+
+#define for_each_downgrade_entry(_d, _i)						\
+	for (const struct bch_sb_field_downgrade_entry *_i = (_d)->entries;		\
+	     (void *) _i	< vstruct_end(&(_d)->field) &&				\
+	     (void *) &_i->errors[0] < vstruct_end(&(_d)->field);			\
+	     _i = downgrade_entry_next_c(_i))
+
+static int bch2_sb_downgrade_validate(struct bch_sb *sb, struct bch_sb_field *f,
+				      struct printbuf *err)
+{
+	struct bch_sb_field_downgrade *e = field_to_type(f, downgrade);
+
+	for_each_downgrade_entry(e, i) {
+		if (BCH_VERSION_MAJOR(le16_to_cpu(i->version)) !=
+		    BCH_VERSION_MAJOR(le16_to_cpu(sb->version))) {
+			prt_printf(err, "downgrade entry with mismatched major version (%u != %u)",
+				   BCH_VERSION_MAJOR(le16_to_cpu(i->version)),
+				   BCH_VERSION_MAJOR(le16_to_cpu(sb->version)));
+			return -BCH_ERR_invalid_sb_downgrade;
+		}
+	}
+
+	return 0;
+}
+
+static void bch2_sb_downgrade_to_text(struct printbuf *out, struct bch_sb *sb,
+				      struct bch_sb_field *f)
+{
+	struct bch_sb_field_downgrade *e = field_to_type(f, downgrade);
+
+	if (out->nr_tabstops <= 1)
+		printbuf_tabstop_push(out, 16);
+
+	for_each_downgrade_entry(e, i) {
+		prt_str(out, "version:");
+		prt_tab(out);
+		bch2_version_to_text(out, le16_to_cpu(i->version));
+		prt_newline(out);
+
+		prt_str(out, "recovery passes:");
+		prt_tab(out);
+		prt_bitflags(out, bch2_recovery_passes,
+			     bch2_recovery_passes_from_stable(le64_to_cpu(i->recovery_passes[0])));
+		prt_newline(out);
+
+		prt_str(out, "errors:");
+		prt_tab(out);
+		bool first = true;
+		for (unsigned j = 0; j < le16_to_cpu(i->nr_errors); j++) {
+			if (!first)
+				prt_char(out, ',');
+			first = false;
+			unsigned e = le16_to_cpu(i->errors[j]);
+			prt_str(out, e < BCH_SB_ERR_MAX ? bch2_sb_error_strs[e] : "(unknown)");
+		}
+		prt_newline(out);
+	}
+}
+
+const struct bch_sb_field_ops bch_sb_field_ops_downgrade = {
+	.validate	= bch2_sb_downgrade_validate,
+	.to_text	= bch2_sb_downgrade_to_text,
+};
+
+int bch2_sb_downgrade_update(struct bch_fs *c)
+{
+	darray_char table = {};
+	int ret = 0;
+
+	for (const struct downgrade_entry *src = downgrade_table;
+	     src < downgrade_table + ARRAY_SIZE(downgrade_table);
+	     src++) {
+		if (BCH_VERSION_MAJOR(src->version) != BCH_VERSION_MAJOR(le16_to_cpu(c->disk_sb.sb->version)))
+			continue;
+
+		struct bch_sb_field_downgrade_entry *dst;
+		unsigned bytes = sizeof(*dst) + sizeof(dst->errors[0]) * src->nr_errors;
+
+		ret = darray_make_room(&table, bytes);
+		if (ret)
+			goto out;
+
+		dst = (void *) &darray_top(table);
+		dst->version = cpu_to_le16(src->version);
+		dst->recovery_passes[0]	= cpu_to_le64(src->recovery_passes);
+		dst->recovery_passes[1]	= 0;
+		dst->nr_errors		= cpu_to_le16(src->nr_errors);
+		for (unsigned i = 0; i < src->nr_errors; i++)
+			dst->errors[i] = cpu_to_le16(src->errors[i]);
+
+		table.nr += bytes;
+	}
+
+	struct bch_sb_field_downgrade *d = bch2_sb_field_get(c->disk_sb.sb, downgrade);
+
+	unsigned sb_u64s = DIV_ROUND_UP(sizeof(*d) + table.nr, sizeof(u64));
+
+	if (d && le32_to_cpu(d->field.u64s) > sb_u64s)
+		goto out;
+
+	d = bch2_sb_field_resize(&c->disk_sb, downgrade, sb_u64s);
+	if (!d) {
+		ret = -BCH_ERR_ENOSPC_sb_downgrade;
+		goto out;
+	}
+
+	memcpy(d->entries, table.data, table.nr);
+	memset_u64s_tail(d->entries, 0, table.nr);
+out:
+	darray_exit(&table);
+	return ret;
+}
+
+int bch2_sb_set_downgrade(struct bch_fs *c, unsigned new_minor, unsigned old_minor)
+{
+	struct bch_sb_field_downgrade *d = bch2_sb_field_get(c->disk_sb.sb, downgrade);
+	if (!d)
+		return 0;
+
+	struct bch_sb_field_ext *ext = bch2_sb_field_get(c->disk_sb.sb, ext);
+
+	for_each_downgrade_entry(d, i) {
+		unsigned minor = BCH_VERSION_MINOR(le16_to_cpu(i->version));
+		if (new_minor < minor && minor <= old_minor) {
+			ext->recovery_passes_required[0] |= i->recovery_passes[0];
+			ext->recovery_passes_required[1] |= i->recovery_passes[1];
+
+			for (unsigned j = 0; j < le16_to_cpu(i->nr_errors); j++) {
+				unsigned e = le16_to_cpu(i->errors[j]);
+				if (e < BCH_SB_ERR_MAX)
+					__set_bit(e, c->sb.errors_silent);
+				if (e < sizeof(ext->errors_silent) * 8)
+					ext->errors_silent[e / 64] |= cpu_to_le64(BIT_ULL(e % 64));
+			}
+		}
+	}
+
+	return 0;
+}
diff --git a/fs/bcachefs/sb-downgrade.h b/fs/bcachefs/sb-downgrade.h
new file mode 100644
index 000000000000..0703ad7e99e4
--- /dev/null
+++ b/fs/bcachefs/sb-downgrade.h
@@ -0,0 +1,10 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _BCACHEFS_SB_DOWNGRADE_H
+#define _BCACHEFS_SB_DOWNGRADE_H
+
+extern const struct bch_sb_field_ops bch_sb_field_ops_downgrade;
+
+int bch2_sb_downgrade_update(struct bch_fs *);
+int bch2_sb_set_downgrade(struct bch_fs *, unsigned, unsigned);
+
+#endif /* _BCACHEFS_SB_DOWNGRADE_H */
diff --git a/fs/bcachefs/sb-errors.c b/fs/bcachefs/sb-errors.c
index caf7669db6a1..5f5bcae391fb 100644
--- a/fs/bcachefs/sb-errors.c
+++ b/fs/bcachefs/sb-errors.c
@@ -20,9 +20,7 @@ static void bch2_sb_error_id_to_text(struct printbuf *out, enum bch_sb_error_id
 
 static inline unsigned bch2_sb_field_errors_nr_entries(struct bch_sb_field_errors *e)
 {
-	return e
-		? (bch2_sb_field_bytes(&e->field) - sizeof(*e)) / sizeof(e->entries[0])
-		: 0;
+	return bch2_sb_field_nr_entries(e);
 }
 
 static inline unsigned bch2_sb_field_errors_u64s(unsigned nr)
diff --git a/fs/bcachefs/super-io.c b/fs/bcachefs/super-io.c
index cccded38337f..7cbf496dcf99 100644
--- a/fs/bcachefs/super-io.c
+++ b/fs/bcachefs/super-io.c
@@ -13,6 +13,7 @@
 #include "replicas.h"
 #include "quota.h"
 #include "sb-clean.h"
+#include "sb-downgrade.h"
 #include "sb-errors.h"
 #include "sb-members.h"
 #include "super-io.h"
@@ -958,6 +959,7 @@ int bch2_write_super(struct bch_fs *c)
 	bch2_sb_members_from_cpu(c);
 	bch2_sb_members_cpy_v2_v1(&c->disk_sb);
 	bch2_sb_errors_from_cpu(c);
+	bch2_sb_downgrade_update(c);
 
 	for_each_online_member(c, ca)
 		bch2_sb_from_fs(c, ca);
@@ -1114,6 +1116,10 @@ void bch2_sb_upgrade(struct bch_fs *c, unsigned new_version)
 {
 	lockdep_assert_held(&c->sb_lock);
 
+	if (BCH_VERSION_MAJOR(new_version) >
+	    BCH_VERSION_MAJOR(le16_to_cpu(c->disk_sb.sb->version)))
+		bch2_sb_field_resize(&c->disk_sb, downgrade, 0);
+
 	c->disk_sb.sb->version = cpu_to_le16(new_version);
 	c->disk_sb.sb->features[0] |= cpu_to_le64(BCH_SB_FEATURES_ALL);
 }
-- 
2.43.0


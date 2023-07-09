Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 947A3C04A94
	for <linux-bcachefs@archiver.kernel.org>; Sun,  9 Jul 2023 17:16:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230283AbjGIRQM (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Sun, 9 Jul 2023 13:16:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229579AbjGIRQL (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Sun, 9 Jul 2023 13:16:11 -0400
Received: from out-29.mta0.migadu.com (out-29.mta0.migadu.com [91.218.175.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8A95F1
        for <linux-bcachefs@vger.kernel.org>; Sun,  9 Jul 2023 10:16:09 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1688922968;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZroeXsoLfMSBw2a7Mg4Uz7FYPl8H4X+u6ZAIVEqvX+0=;
        b=xjmBl273rrafNlZ+KtiFDKR8pru3mNVfv3fh7bm3sNNlabq+qAkJmm6nI0f+Aklco8wTfK
        M9MCvqNn7F3dnLQxBbpN6E38YEeYcPLzLsRFW263jFQWfX4cnB1uSmMofXgb4zLgAvvcdX
        1Ut7d3FYthIHZn18w5o6kGY8W/oaLdA=
From:   Kent Overstreet <kent.overstreet@linux.dev>
To:     linux-bcachefs@vger.kernel.org
Cc:     Kent Overstreet <kent.overstreet@linux.dev>, bfoster@redhat.com,
        sandeen@redhat.com
Subject: [PATCH 10/10] bcachefs: bcachefs_metadata_version_major_minor
Date:   Sun,  9 Jul 2023 13:15:51 -0400
Message-Id: <20230709171551.2349961-11-kent.overstreet@linux.dev>
In-Reply-To: <20230709171551.2349961-1-kent.overstreet@linux.dev>
References: <20230709171551.2349961-1-kent.overstreet@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

This introduces major/minor versioning to the superblock version number.
Major version number changes indicate incompatible releases; we can move
forward to a new major version number, but not backwards. Minor version
numbers indicate compatible changes - these add features, but can still
be mounted and used by old versions.

With the recent patches that make it possible to roll out new btrees and
key types without breaking compatibility, we should be able to roll out
most new features without incompatible changes.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/bcachefs.h        |  1 -
 fs/bcachefs/bcachefs_format.h | 46 +++++++++++++-----------
 fs/bcachefs/btree_io.c        |  7 ++--
 fs/bcachefs/journal_io.c      | 12 ++++---
 fs/bcachefs/recovery.c        | 66 +++++++++++++++++++++++++++--------
 fs/bcachefs/super-io.c        | 58 ++++++++++++++++++++----------
 fs/bcachefs/super-io.h        |  3 +-
 7 files changed, 132 insertions(+), 61 deletions(-)

diff --git a/fs/bcachefs/bcachefs.h b/fs/bcachefs/bcachefs.h
index cfd4a7b9e8..88a1782b2a 100644
--- a/fs/bcachefs/bcachefs.h
+++ b/fs/bcachefs/bcachefs.h
@@ -568,7 +568,6 @@ enum {
 	BCH_FS_INITIAL_GC_UNFIXED,	/* kill when we enumerate fsck errors */
 	BCH_FS_NEED_ANOTHER_GC,
 
-	BCH_FS_VERSION_UPGRADE,
 	BCH_FS_HAVE_DELETED_SNAPSHOTS,
 
 	/* errors: */
diff --git a/fs/bcachefs/bcachefs_format.h b/fs/bcachefs/bcachefs_format.h
index 8a0f90a83d..8c1955b6a4 100644
--- a/fs/bcachefs/bcachefs_format.h
+++ b/fs/bcachefs/bcachefs_format.h
@@ -1574,28 +1574,32 @@ struct bch_sb_field_journal_seq_blacklist {
  * One common version number for all on disk data structures - superblock, btree
  * nodes, journal entries
  */
+#define BCH_VERSION_MAJOR(_v)		((__u8) ((_v) >> 10))
+#define BCH_VERSION_MINOR(_v)		((__u8) ((_v) >> 0))
+#define BCH_VERSION(_major, _minor)	(((_major) << 10)|(_minor) << 0)
 
 #define BCH_METADATA_VERSIONS()				\
-	x(bkey_renumber,		10)		\
-	x(inode_btree_change,		11)		\
-	x(snapshot,			12)		\
-	x(inode_backpointers,		13)		\
-	x(btree_ptr_sectors_written,	14)		\
-	x(snapshot_2,			15)		\
-	x(reflink_p_fix,		16)		\
-	x(subvol_dirent,		17)		\
-	x(inode_v2,			18)		\
-	x(freespace,			19)		\
-	x(alloc_v4,			20)		\
-	x(new_data_types,		21)		\
-	x(backpointers,			22)		\
-	x(inode_v3,			23)		\
-	x(unwritten_extents,		24)		\
-	x(bucket_gens,			25)		\
-	x(lru_v2,			26)		\
-	x(fragmentation_lru,		27)		\
-	x(no_bps_in_alloc_keys,		28)		\
-	x(snapshot_trees,		29)
+	x(bkey_renumber,		BCH_VERSION(0, 10))		\
+	x(inode_btree_change,		BCH_VERSION(0, 11))		\
+	x(snapshot,			BCH_VERSION(0, 12))		\
+	x(inode_backpointers,		BCH_VERSION(0, 13))		\
+	x(btree_ptr_sectors_written,	BCH_VERSION(0, 14))		\
+	x(snapshot_2,			BCH_VERSION(0, 15))		\
+	x(reflink_p_fix,		BCH_VERSION(0, 16))		\
+	x(subvol_dirent,		BCH_VERSION(0, 17))		\
+	x(inode_v2,			BCH_VERSION(0, 18))		\
+	x(freespace,			BCH_VERSION(0, 19))		\
+	x(alloc_v4,			BCH_VERSION(0, 20))		\
+	x(new_data_types,		BCH_VERSION(0, 21))		\
+	x(backpointers,			BCH_VERSION(0, 22))		\
+	x(inode_v3,			BCH_VERSION(0, 23))		\
+	x(unwritten_extents,		BCH_VERSION(0, 24))		\
+	x(bucket_gens,			BCH_VERSION(0, 25))		\
+	x(lru_v2,			BCH_VERSION(0, 26))		\
+	x(fragmentation_lru,		BCH_VERSION(0, 27))		\
+	x(no_bps_in_alloc_keys,		BCH_VERSION(0, 28))		\
+	x(snapshot_trees,		BCH_VERSION(0, 29))		\
+	x(major_minor,			BCH_VERSION(1,  0))
 
 enum bcachefs_metadata_version {
 	bcachefs_metadata_version_min = 9,
@@ -1605,7 +1609,7 @@ enum bcachefs_metadata_version {
 	bcachefs_metadata_version_max
 };
 
-static const unsigned bcachefs_metadata_required_upgrade_below = bcachefs_metadata_version_snapshot_trees;
+static const unsigned bcachefs_metadata_required_upgrade_below = bcachefs_metadata_version_major_minor;
 
 #define bcachefs_metadata_version_current	(bcachefs_metadata_version_max - 1)
 
diff --git a/fs/bcachefs/btree_io.c b/fs/bcachefs/btree_io.c
index a8197c5008..a8f7b71139 100644
--- a/fs/bcachefs/btree_io.c
+++ b/fs/bcachefs/btree_io.c
@@ -701,7 +701,9 @@ static int validate_bset(struct bch_fs *c, struct bch_dev *ca,
 
 	btree_err_on(!bch2_version_compatible(version),
 		     BTREE_ERR_INCOMPATIBLE, c, ca, b, i,
-		     "unsupported bset version %u", version);
+		     "unsupported bset version %u.%u",
+		     BCH_VERSION_MAJOR(version),
+		     BCH_VERSION_MINOR(version));
 
 	if (btree_err_on(version < c->sb.version_min,
 			 BTREE_ERR_FIXABLE, c, NULL, b, i,
@@ -713,7 +715,8 @@ static int validate_bset(struct bch_fs *c, struct bch_dev *ca,
 		mutex_unlock(&c->sb_lock);
 	}
 
-	if (btree_err_on(version > c->sb.version,
+	if (btree_err_on(BCH_VERSION_MAJOR(version) >
+			 BCH_VERSION_MAJOR(c->sb.version),
 			 BTREE_ERR_FIXABLE, c, NULL, b, i,
 			 "bset version %u newer than superblock version %u",
 			 version, c->sb.version)) {
diff --git a/fs/bcachefs/journal_io.c b/fs/bcachefs/journal_io.c
index c7c2ae326f..f861ae2f17 100644
--- a/fs/bcachefs/journal_io.c
+++ b/fs/bcachefs/journal_io.c
@@ -747,9 +747,11 @@ static int jset_validate(struct bch_fs *c,
 
 	version = le32_to_cpu(jset->version);
 	if (journal_entry_err_on(!bch2_version_compatible(version), c, jset, NULL,
-			"%s sector %llu seq %llu: incompatible journal entry version %u",
+			"%s sector %llu seq %llu: incompatible journal entry version %u.%u",
 			ca ? ca->name : c->name,
-			sector, le64_to_cpu(jset->seq), version)) {
+			sector, le64_to_cpu(jset->seq),
+			BCH_VERSION_MAJOR(version),
+			BCH_VERSION_MINOR(version))) {
 		/* don't try to continue: */
 		return -EINVAL;
 	}
@@ -794,9 +796,11 @@ static int jset_validate_early(struct bch_fs *c,
 
 	version = le32_to_cpu(jset->version);
 	if (journal_entry_err_on(!bch2_version_compatible(version), c, jset, NULL,
-			"%s sector %llu seq %llu: unknown journal entry version %u",
+			"%s sector %llu seq %llu: unknown journal entry version %u.%u",
 			ca ? ca->name : c->name,
-			sector, le64_to_cpu(jset->seq), version)) {
+			sector, le64_to_cpu(jset->seq),
+			BCH_VERSION_MAJOR(version),
+			BCH_VERSION_MINOR(version))) {
 		/* don't try to continue: */
 		return -EINVAL;
 	}
diff --git a/fs/bcachefs/recovery.c b/fs/bcachefs/recovery.c
index 3b9120bd36..2339b979ec 100644
--- a/fs/bcachefs/recovery.c
+++ b/fs/bcachefs/recovery.c
@@ -1111,31 +1111,69 @@ static int bch2_fs_upgrade_for_subvolumes(struct bch_fs *c)
 
 static void check_version_upgrade(struct bch_fs *c)
 {
-	unsigned version = c->sb.version_upgrade_complete ?: c->sb.version;
+	unsigned latest_compatible = bch2_version_compatible(c->sb.version);
+	unsigned latest_version	= bcachefs_metadata_version_current;
+	unsigned old_version = c->sb.version_upgrade_complete ?: c->sb.version;
+	unsigned new_version;
+
+	if (old_version < bcachefs_metadata_required_upgrade_below) {
+		if (c->opts.version_upgrade == BCH_VERSION_UPGRADE_incompatible ||
+		    latest_compatible < bcachefs_metadata_required_upgrade_below)
+			new_version = latest_version;
+		else
+			new_version = latest_compatible;
+	} else {
+		switch (c->opts.version_upgrade) {
+		case BCH_VERSION_UPGRADE_compatible:
+			new_version = latest_compatible;
+			break;
+		case BCH_VERSION_UPGRADE_incompatible:
+			new_version = latest_version;
+			break;
+		case BCH_VERSION_UPGRADE_none:
+			new_version = old_version;
+			break;
+		}
+	}
 
-	if (version < bcachefs_metadata_required_upgrade_below ||
-	    (version < bcachefs_metadata_version_current &&
-	     c->opts.version_upgrade != BCH_VERSION_UPGRADE_none)) {
+	if (new_version > old_version) {
 		struct printbuf buf = PRINTBUF;
 
-		if (version != c->sb.version) {
-			prt_str(&buf, "version upgrade to ");
+		if (old_version < bcachefs_metadata_required_upgrade_below)
+			prt_str(&buf, "Version upgrade required:\n");
+
+		if (old_version != c->sb.version) {
+			prt_str(&buf, "Version upgrade from ");
+			bch2_version_to_text(&buf, c->sb.version_upgrade_complete);
+			prt_str(&buf, " to ");
 			bch2_version_to_text(&buf, c->sb.version);
-			prt_str(&buf, " incomplete:\n");
+			prt_str(&buf, " incomplete\n");
 		}
 
-		prt_str(&buf, "version ");
-		bch2_version_to_text(&buf, version);
-		prt_str(&buf, " prior to ");
-		bch2_version_to_text(&buf, bcachefs_metadata_required_upgrade_below);
-		prt_str(&buf, ", upgrade and fsck required");
+		prt_str(&buf, "Doing ");
+		if (BCH_VERSION_MAJOR(old_version) != BCH_VERSION_MAJOR(new_version))
+			prt_str(&buf, "incompatible");
+		else
+			prt_str(&buf, "compatible");
+		prt_str(&buf, "version upgrade from ");
+		bch2_version_to_text(&buf, old_version);
+		prt_str(&buf, " to ");
+		bch2_version_to_text(&buf, new_version);
+		prt_newline(&buf);
+
+		prt_str(&buf, "fsck required");
 
 		bch_info(c, "%s", buf.buf);
-		printbuf_exit(&buf);
 
 		c->opts.fsck		= true;
 		c->opts.fix_errors	= FSCK_OPT_YES;
-		set_bit(BCH_FS_VERSION_UPGRADE, &c->flags);
+
+		mutex_lock(&c->sb_lock);
+		c->disk_sb.sb->version = cpu_to_le16(new_version);
+		c->disk_sb.sb->features[0] |= cpu_to_le64(BCH_SB_FEATURES_ALL);
+		mutex_unlock(&c->sb_lock);
+
+		printbuf_exit(&buf);
 	}
 }
 
diff --git a/fs/bcachefs/super-io.c b/fs/bcachefs/super-io.c
index b174003b57..b4aec5b6ae 100644
--- a/fs/bcachefs/super-io.c
+++ b/fs/bcachefs/super-io.c
@@ -23,19 +23,42 @@
 #include <linux/backing-dev.h>
 #include <linux/sort.h>
 
-static const char * const bch2_metadata_versions[] = {
-#define x(t, n) [n] = #t,
+struct bch2_metadata_version_str {
+	u16		version;
+	const char	*name;
+};
+
+static const struct bch2_metadata_version_str bch2_metadata_versions[] = {
+#define x(n, v) { .version = v, .name = #n },
 	BCH_METADATA_VERSIONS()
 #undef x
 };
 
 void bch2_version_to_text(struct printbuf *out, unsigned v)
 {
-	const char *str = v < ARRAY_SIZE(bch2_metadata_versions)
-		? bch2_metadata_versions[v]
-		: "(unknown version)";
+	const char *str = "(unknown version)";
+
+	for (unsigned i = 0; i < ARRAY_SIZE(bch2_metadata_versions); i++)
+		if (bch2_metadata_versions[i].version == v) {
+			str = bch2_metadata_versions[i].name;
+			break;
+		}
+
+	prt_printf(out, "%u.%u: %s", BCH_VERSION_MAJOR(v), BCH_VERSION_MINOR(v), str);
+}
+
+unsigned bch2_latest_compatible_version(unsigned v)
+{
+	if (!BCH_VERSION_MAJOR(v))
+		return v;
+
+	for (unsigned i = 0; i < ARRAY_SIZE(bch2_metadata_versions); i++)
+		if (bch2_metadata_versions[i].version > v &&
+		    BCH_VERSION_MAJOR(bch2_metadata_versions[i].version) ==
+		    BCH_VERSION_MAJOR(v))
+			v = bch2_metadata_versions[i].version;
 
-	prt_printf(out, "%u: %s", v, str);
+	return v;
 }
 
 const char * const bch2_sb_fields[] = {
@@ -809,10 +832,9 @@ int bch2_write_super(struct bch_fs *c)
 	closure_init_stack(cl);
 	memset(&sb_written, 0, sizeof(sb_written));
 
-	if (test_bit(BCH_FS_VERSION_UPGRADE, &c->flags)) {
-		c->disk_sb.sb->magic = BCHFS_MAGIC;
-		c->disk_sb.sb->layout.magic = BCHFS_MAGIC;
-	}
+	/* Make sure we're using the new magic numbers: */
+	c->disk_sb.sb->magic = BCHFS_MAGIC;
+	c->disk_sb.sb->layout.magic = BCHFS_MAGIC;
 
 	le64_add_cpu(&c->disk_sb.sb->seq, 1);
 
@@ -1187,19 +1209,19 @@ int bch2_fs_mark_dirty(struct bch_fs *c)
 	mutex_lock(&c->sb_lock);
 	SET_BCH_SB_CLEAN(c->disk_sb.sb, false);
 
+	/*
+	 * Downgrade, if superblock is at a higher version than currently
+	 * supported:
+	 */
 	if (BCH_SB_VERSION_UPGRADE_COMPLETE(c->disk_sb.sb) > bcachefs_metadata_version_current)
 		SET_BCH_SB_VERSION_UPGRADE_COMPLETE(c->disk_sb.sb, bcachefs_metadata_version_current);
-
-	if (test_bit(BCH_FS_VERSION_UPGRADE, &c->flags) ||
-	    c->sb.version > bcachefs_metadata_version_current)
+	if (c->sb.version > bcachefs_metadata_version_current)
 		c->disk_sb.sb->version = cpu_to_le16(bcachefs_metadata_version_current);
-
-	if (test_bit(BCH_FS_VERSION_UPGRADE, &c->flags))
-		c->disk_sb.sb->features[0] |= cpu_to_le64(BCH_SB_FEATURES_ALL);
+	if (c->sb.version_min > bcachefs_metadata_version_current)
+		c->disk_sb.sb->version_min = cpu_to_le16(bcachefs_metadata_version_current);
+	c->disk_sb.sb->compat[0] &= cpu_to_le64((1ULL << BCH_COMPAT_NR) - 1);
 
 	c->disk_sb.sb->features[0] |= cpu_to_le64(BCH_SB_FEATURES_ALWAYS);
-
-	c->disk_sb.sb->compat[0] &= cpu_to_le64((1ULL << BCH_COMPAT_NR) - 1);
 	ret = bch2_write_super(c);
 	mutex_unlock(&c->sb_lock);
 
diff --git a/fs/bcachefs/super-io.h b/fs/bcachefs/super-io.h
index cda71ec845..a850cc4ae6 100644
--- a/fs/bcachefs/super-io.h
+++ b/fs/bcachefs/super-io.h
@@ -11,11 +11,12 @@
 
 static inline bool bch2_version_compatible(u16 version)
 {
-	return version <= bcachefs_metadata_version_current &&
+	return BCH_VERSION_MAJOR(version) <= BCH_VERSION_MAJOR(bcachefs_metadata_version_current) &&
 		version >= bcachefs_metadata_version_min;
 }
 
 void bch2_version_to_text(struct printbuf *, unsigned);
+unsigned bch2_latest_compatible_version(unsigned);
 
 struct bch_sb_field *bch2_sb_field_get(struct bch_sb *, enum bch_sb_field_type);
 struct bch_sb_field *bch2_sb_field_resize(struct bch_sb_handle *,
-- 
2.40.1


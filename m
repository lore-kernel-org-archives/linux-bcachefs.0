Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56BC1C001DE
	for <linux-bcachefs@archiver.kernel.org>; Sun,  9 Jul 2023 17:16:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230284AbjGIRQI (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Sun, 9 Jul 2023 13:16:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230352AbjGIRQH (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Sun, 9 Jul 2023 13:16:07 -0400
Received: from out-41.mta0.migadu.com (out-41.mta0.migadu.com [IPv6:2001:41d0:1004:224b::29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC259130
        for <linux-bcachefs@vger.kernel.org>; Sun,  9 Jul 2023 10:16:05 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1688922963;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QVRYrsvo55TJISpPbxPgtRMa8DoecH7Adj+RrA03c/M=;
        b=af8EUtKwdiDOvyCa1TayKWMr7T0K27/JRReF9n7MfzB8rcMAp3jCLhAewgsoPP/2Ou4KVU
        NpAXVuXj70dlflrvsCmbEz3h3DC/WjKLvjDcmDJBXa/+rWfvXu4WvuqrQYkSw1uWaNWjsM
        avBN+Dys125yxGbfQ+jLnWs0mJuil9Q=
From:   Kent Overstreet <kent.overstreet@linux.dev>
To:     linux-bcachefs@vger.kernel.org
Cc:     Kent Overstreet <kent.overstreet@linux.dev>, bfoster@redhat.com,
        sandeen@redhat.com
Subject: [PATCH 05/10] bcachefs: BCH_SB_VERSION_UPGRADE_COMPLETE()
Date:   Sun,  9 Jul 2023 13:15:46 -0400
Message-Id: <20230709171551.2349961-6-kent.overstreet@linux.dev>
In-Reply-To: <20230709171551.2349961-1-kent.overstreet@linux.dev>
References: <20230709171551.2349961-1-kent.overstreet@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

Version upgrades are not atomic operations: when we do a version upgrade
we need to update the superblock before we start using new features, and
then when the upgrade completes we need to update the superblock again.
This adds a new superblock field so we can detect and handle incomplete
version upgrades.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/alloc_background.c |  3 +-
 fs/bcachefs/bcachefs.h         |  7 +++++
 fs/bcachefs/bcachefs_format.h  |  5 ++++
 fs/bcachefs/recovery.c         | 54 +++++++++++++++++++---------------
 fs/bcachefs/super-io.c         | 18 ++++++++++++
 5 files changed, 62 insertions(+), 25 deletions(-)

diff --git a/fs/bcachefs/alloc_background.c b/fs/bcachefs/alloc_background.c
index c59629bbbc..b1dfe300d9 100644
--- a/fs/bcachefs/alloc_background.c
+++ b/fs/bcachefs/alloc_background.c
@@ -1232,8 +1232,7 @@ int bch2_check_alloc_hole_bucket_gens(struct btree_trans *trans,
 	unsigned i, gens_offset, gens_end_offset;
 	int ret;
 
-	if (c->sb.version < bcachefs_metadata_version_bucket_gens &&
-	    !c->opts.version_upgrade)
+	if (c->sb.version < bcachefs_metadata_version_bucket_gens)
 		return 0;
 
 	bch2_btree_iter_set_pos(bucket_gens_iter, alloc_gens_pos(start, &gens_offset));
diff --git a/fs/bcachefs/bcachefs.h b/fs/bcachefs/bcachefs.h
index a8488d4e18..d7f030aa30 100644
--- a/fs/bcachefs/bcachefs.h
+++ b/fs/bcachefs/bcachefs.h
@@ -712,6 +712,7 @@ struct bch_fs {
 
 		u16		version;
 		u16		version_min;
+		u16		version_upgrade_complete;
 
 		u8		nr_devices;
 		u8		clean;
@@ -1134,6 +1135,12 @@ static inline bool bch2_dev_exists2(const struct bch_fs *c, unsigned dev)
 	return dev < c->sb.nr_devices && c->devs[dev];
 }
 
+static inline bool bch2_version_upgrading_to(const struct bch_fs *c, unsigned new_version)
+{
+	return c->sb.version_upgrade_complete < new_version &&
+		c->sb.version >= new_version;
+}
+
 #define BKEY_PADDED_ONSTACK(key, pad)				\
 	struct { struct bkey_i key; __u64 key ## _pad[pad]; }
 
diff --git a/fs/bcachefs/bcachefs_format.h b/fs/bcachefs/bcachefs_format.h
index 49b86bfda7..c397a3b96b 100644
--- a/fs/bcachefs/bcachefs_format.h
+++ b/fs/bcachefs/bcachefs_format.h
@@ -1748,6 +1748,11 @@ LE64_BITMASK(BCH_SB_JOURNAL_TRANSACTION_NAMES,struct bch_sb, flags[4], 32, 33);
 LE64_BITMASK(BCH_SB_NOCOW,		struct bch_sb, flags[4], 33, 34);
 LE64_BITMASK(BCH_SB_WRITE_BUFFER_SIZE,	struct bch_sb, flags[4], 34, 54);
 
+/* flags[4] 56-64 unused: */
+
+LE64_BITMASK(BCH_SB_VERSION_UPGRADE_COMPLETE,
+					struct bch_sb, flags[5],  0, 16);
+
 /*
  * Features:
  *
diff --git a/fs/bcachefs/recovery.c b/fs/bcachefs/recovery.c
index 9ea85b097e..0173707cfd 100644
--- a/fs/bcachefs/recovery.c
+++ b/fs/bcachefs/recovery.c
@@ -1107,6 +1107,31 @@ static int bch2_fs_upgrade_for_subvolumes(struct bch_fs *c)
 	return ret;
 }
 
+static void check_version_upgrade(struct bch_fs *c)
+{
+	unsigned version = c->sb.version_upgrade_complete ?: c->sb.version;
+
+	if (version < bcachefs_metadata_required_upgrade_below) {
+		struct printbuf buf = PRINTBUF;
+
+		if (version != c->sb.version)
+			prt_str(&buf, "version upgrade incomplete:\n");
+
+		prt_str(&buf, "version ");
+		bch2_version_to_text(&buf, version);
+		prt_str(&buf, " prior to ");
+		bch2_version_to_text(&buf, bcachefs_metadata_required_upgrade_below);
+		prt_str(&buf, ", upgrade and fsck required");
+
+		bch_info(c, "%s", buf.buf);
+		printbuf_exit(&buf);
+
+		c->opts.version_upgrade	= true;
+		c->opts.fsck		= true;
+		c->opts.fix_errors	= FSCK_OPT_YES;
+	}
+}
+
 int bch2_fs_recovery(struct bch_fs *c)
 {
 	struct bch_sb_field_clean *clean = NULL;
@@ -1146,23 +1171,8 @@ int bch2_fs_recovery(struct bch_fs *c)
 		goto err;
 	}
 
-	if (!c->opts.nochanges &&
-	    c->sb.version < bcachefs_metadata_required_upgrade_below) {
-		struct printbuf buf = PRINTBUF;
-
-		prt_str(&buf, "version ");
-		bch2_version_to_text(&buf, c->sb.version);
-		prt_str(&buf, " prior to ");
-		bch2_version_to_text(&buf, bcachefs_metadata_required_upgrade_below);
-		prt_str(&buf, ", upgrade and fsck required");
-
-		bch_info(c, "%s", buf.buf);
-		printbuf_exit(&buf);
-
-		c->opts.version_upgrade	= true;
-		c->opts.fsck		= true;
-		c->opts.fix_errors	= FSCK_OPT_YES;
-	}
+	if (!c->opts.nochanges)
+		check_version_upgrade(c);
 
 	if (c->opts.fsck && c->opts.norecovery) {
 		bch_err(c, "cannot select both norecovery and fsck");
@@ -1406,8 +1416,7 @@ int bch2_fs_recovery(struct bch_fs *c)
 	if (ret)
 		goto err;
 
-	if (c->sb.version < bcachefs_metadata_version_bucket_gens &&
-	    c->opts.version_upgrade) {
+	if (bch2_version_upgrading_to(c, bcachefs_metadata_version_bucket_gens)) {
 		bch_info(c, "initializing bucket_gens");
 		ret = bch2_bucket_gens_init(c);
 		if (ret)
@@ -1415,7 +1424,7 @@ int bch2_fs_recovery(struct bch_fs *c)
 		bch_verbose(c, "bucket_gens init done");
 	}
 
-	if (c->sb.version < bcachefs_metadata_version_snapshot_2) {
+	if (bch2_version_upgrading_to(c, bcachefs_metadata_version_snapshot_2)) {
 		ret = bch2_fs_upgrade_for_subvolumes(c);
 		if (ret)
 			goto err;
@@ -1443,9 +1452,8 @@ int bch2_fs_recovery(struct bch_fs *c)
 	}
 
 	mutex_lock(&c->sb_lock);
-	if (c->opts.version_upgrade) {
-		c->disk_sb.sb->version = cpu_to_le16(bcachefs_metadata_version_current);
-		c->disk_sb.sb->features[0] |= cpu_to_le64(BCH_SB_FEATURES_ALL);
+	if (BCH_SB_VERSION_UPGRADE_COMPLETE(c->disk_sb.sb) != c->sb.version) {
+		SET_BCH_SB_VERSION_UPGRADE_COMPLETE(c->disk_sb.sb, c->sb.version);
 		write_sb = true;
 	}
 
diff --git a/fs/bcachefs/super-io.c b/fs/bcachefs/super-io.c
index 833e78d48c..cb03e3f0c5 100644
--- a/fs/bcachefs/super-io.c
+++ b/fs/bcachefs/super-io.c
@@ -445,6 +445,7 @@ static void bch2_sb_update(struct bch_fs *c)
 	c->sb.user_uuid		= src->user_uuid;
 	c->sb.version		= le16_to_cpu(src->version);
 	c->sb.version_min	= le16_to_cpu(src->version_min);
+	c->sb.version_upgrade_complete = BCH_SB_VERSION_UPGRADE_COMPLETE(src) ?: c->sb.version;
 	c->sb.nr_devices	= src->nr_devices;
 	c->sb.clean		= BCH_SB_CLEAN(src);
 	c->sb.encryption_type	= BCH_SB_ENCRYPTION_TYPE(src);
@@ -1185,7 +1186,19 @@ int bch2_fs_mark_dirty(struct bch_fs *c)
 
 	mutex_lock(&c->sb_lock);
 	SET_BCH_SB_CLEAN(c->disk_sb.sb, false);
+
+	if (BCH_SB_VERSION_UPGRADE_COMPLETE(c->disk_sb.sb) > bcachefs_metadata_version_current)
+		SET_BCH_SB_VERSION_UPGRADE_COMPLETE(c->disk_sb.sb, bcachefs_metadata_version_current);
+
+	if (c->opts.version_upgrade ||
+	    c->sb.version > bcachefs_metadata_version_current)
+		c->disk_sb.sb->version = cpu_to_le16(bcachefs_metadata_version_current);
+
+	if (c->opts.version_upgrade)
+		c->disk_sb.sb->features[0] |= cpu_to_le64(BCH_SB_FEATURES_ALL);
+
 	c->disk_sb.sb->features[0] |= cpu_to_le64(BCH_SB_FEATURES_ALWAYS);
+
 	c->disk_sb.sb->compat[0] &= cpu_to_le64((1ULL << BCH_COMPAT_NR) - 1);
 	ret = bch2_write_super(c);
 	mutex_unlock(&c->sb_lock);
@@ -1529,6 +1542,11 @@ void bch2_sb_to_text(struct printbuf *out, struct bch_sb *sb,
 	bch2_version_to_text(out, le16_to_cpu(sb->version));
 	prt_newline(out);
 
+	prt_str(out, "Version upgrade complete:");
+	prt_tab(out);
+	bch2_version_to_text(out, BCH_SB_VERSION_UPGRADE_COMPLETE(sb));
+	prt_newline(out);
+
 	prt_printf(out, "Oldest version on disk:");
 	prt_tab(out);
 	bch2_version_to_text(out, le16_to_cpu(sb->version_min));
-- 
2.40.1


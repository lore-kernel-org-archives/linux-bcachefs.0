Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AFF92C001E0
	for <linux-bcachefs@archiver.kernel.org>; Sun,  9 Jul 2023 17:16:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230431AbjGIRQJ (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Sun, 9 Jul 2023 13:16:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230351AbjGIRQH (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Sun, 9 Jul 2023 13:16:07 -0400
Received: from out-42.mta0.migadu.com (out-42.mta0.migadu.com [IPv6:2001:41d0:1004:224b::2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AA00F1
        for <linux-bcachefs@vger.kernel.org>; Sun,  9 Jul 2023 10:16:06 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1688922964;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8fTfAS3diNDitoyd8nRnv3EPPQ/kSVZuafbJiiuc6zI=;
        b=Y/Ri2Vhdo+ZhfTMPjB9i3j7Nla7yLR3jTWoz1p82BUoHm03AVaJX2+sU/vu35oQKScwPs5
        PgDwYA7PncGbFq+nrXgweQY6zxAdh1Po9GHyfWwGsZEicEtvMLFmj/RN+H2MbSnoAAmd1S
        qkT+LNFWq5BbRwOT3bsUhocFVWk6q9E=
From:   Kent Overstreet <kent.overstreet@linux.dev>
To:     linux-bcachefs@vger.kernel.org
Cc:     Kent Overstreet <kent.overstreet@linux.dev>, bfoster@redhat.com,
        sandeen@redhat.com
Subject: [PATCH 06/10] bcachefs: version_upgrade is now an enum
Date:   Sun,  9 Jul 2023 13:15:47 -0400
Message-Id: <20230709171551.2349961-7-kent.overstreet@linux.dev>
In-Reply-To: <20230709171551.2349961-1-kent.overstreet@linux.dev>
References: <20230709171551.2349961-1-kent.overstreet@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

The version_upgrade parameter is now an enum, not a bool, and it's
persistent in the superblock:
 - compatible (default):	upgrade to the latest compatible version
 - incompatible:		upgrade to latest incompatible version
 - none

Currently all upgrades are incompatible upgrades, but the next release
will introduce major:minor versions.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/bcachefs.h        |  1 +
 fs/bcachefs/bcachefs_format.h | 12 ++++++++++++
 fs/bcachefs/opts.c            |  5 +++++
 fs/bcachefs/opts.h            |  5 +++--
 fs/bcachefs/recovery.c        | 19 +++++++++++--------
 fs/bcachefs/super-io.c        |  6 +++---
 6 files changed, 35 insertions(+), 13 deletions(-)

diff --git a/fs/bcachefs/bcachefs.h b/fs/bcachefs/bcachefs.h
index d7f030aa30..1ab32b61f0 100644
--- a/fs/bcachefs/bcachefs.h
+++ b/fs/bcachefs/bcachefs.h
@@ -573,6 +573,7 @@ enum {
 	BCH_FS_INITIAL_GC_UNFIXED,	/* kill when we enumerate fsck errors */
 	BCH_FS_NEED_ANOTHER_GC,
 
+	BCH_FS_VERSION_UPGRADE,
 	BCH_FS_HAVE_DELETED_SNAPSHOTS,
 
 	/* errors: */
diff --git a/fs/bcachefs/bcachefs_format.h b/fs/bcachefs/bcachefs_format.h
index c397a3b96b..8a0f90a83d 100644
--- a/fs/bcachefs/bcachefs_format.h
+++ b/fs/bcachefs/bcachefs_format.h
@@ -1747,6 +1747,7 @@ LE64_BITMASK(BCH_SB_JOURNAL_RECLAIM_DELAY,struct bch_sb, flags[4], 0, 32);
 LE64_BITMASK(BCH_SB_JOURNAL_TRANSACTION_NAMES,struct bch_sb, flags[4], 32, 33);
 LE64_BITMASK(BCH_SB_NOCOW,		struct bch_sb, flags[4], 33, 34);
 LE64_BITMASK(BCH_SB_WRITE_BUFFER_SIZE,	struct bch_sb, flags[4], 34, 54);
+LE64_BITMASK(BCH_SB_VERSION_UPGRADE,	struct bch_sb, flags[4], 54, 56);
 
 /* flags[4] 56-64 unused: */
 
@@ -1819,6 +1820,17 @@ enum bch_sb_compat {
 
 /* options: */
 
+#define BCH_VERSION_UPGRADE_OPTS()	\
+	x(compatible,		0)	\
+	x(incompatible,		1)	\
+	x(none,			2)
+
+enum bch_version_upgrade_opts {
+#define x(t, n) BCH_VERSION_UPGRADE_##t = n,
+	BCH_VERSION_UPGRADE_OPTS()
+#undef x
+};
+
 #define BCH_REPLICAS_MAX		4U
 
 #define BCH_BKEY_PTRS_MAX		16U
diff --git a/fs/bcachefs/opts.c b/fs/bcachefs/opts.c
index a05c389830..0c0c83fa42 100644
--- a/fs/bcachefs/opts.c
+++ b/fs/bcachefs/opts.c
@@ -16,6 +16,11 @@ const char * const bch2_error_actions[] = {
 	NULL
 };
 
+const char * const bch2_version_upgrade_opts[] = {
+	BCH_VERSION_UPGRADE_OPTS()
+	NULL
+};
+
 const char * const bch2_sb_features[] = {
 	BCH_SB_FEATURES()
 	NULL
diff --git a/fs/bcachefs/opts.h b/fs/bcachefs/opts.h
index e7cf7e92f3..e105a742fd 100644
--- a/fs/bcachefs/opts.h
+++ b/fs/bcachefs/opts.h
@@ -9,6 +9,7 @@
 #include "bcachefs_format.h"
 
 extern const char * const bch2_error_actions[];
+extern const char * const bch2_version_upgrade_opts[];
 extern const char * const bch2_sb_features[];
 extern const char * const bch2_sb_compat[];
 extern const char * const bch2_btree_ids[];
@@ -388,8 +389,8 @@ enum opt_type {
 	  NULL,		"Reconstruct alloc btree")			\
 	x(version_upgrade,		u8,				\
 	  OPT_FS|OPT_MOUNT,						\
-	  OPT_BOOL(),							\
-	  BCH2_NO_SB_OPT,		false,				\
+	  OPT_STR(bch2_version_upgrade_opts),				\
+	  BCH_SB_VERSION_UPGRADE,	BCH_VERSION_UPGRADE_compatible,	\
 	  NULL,		"Set superblock to latest version,\n"		\
 			"allowing any new features to be used")		\
 	x(buckets_nouse,		u8,				\
diff --git a/fs/bcachefs/recovery.c b/fs/bcachefs/recovery.c
index 0173707cfd..c90205aa22 100644
--- a/fs/bcachefs/recovery.c
+++ b/fs/bcachefs/recovery.c
@@ -1111,11 +1111,16 @@ static void check_version_upgrade(struct bch_fs *c)
 {
 	unsigned version = c->sb.version_upgrade_complete ?: c->sb.version;
 
-	if (version < bcachefs_metadata_required_upgrade_below) {
+	if (version < bcachefs_metadata_required_upgrade_below ||
+	    (version < bcachefs_metadata_version_current &&
+	     c->opts.version_upgrade != BCH_VERSION_UPGRADE_none)) {
 		struct printbuf buf = PRINTBUF;
 
-		if (version != c->sb.version)
-			prt_str(&buf, "version upgrade incomplete:\n");
+		if (version != c->sb.version) {
+			prt_str(&buf, "version upgrade to ");
+			bch2_version_to_text(&buf, c->sb.version);
+			prt_str(&buf, " incomplete:\n");
+		}
 
 		prt_str(&buf, "version ");
 		bch2_version_to_text(&buf, version);
@@ -1126,9 +1131,9 @@ static void check_version_upgrade(struct bch_fs *c)
 		bch_info(c, "%s", buf.buf);
 		printbuf_exit(&buf);
 
-		c->opts.version_upgrade	= true;
 		c->opts.fsck		= true;
 		c->opts.fix_errors	= FSCK_OPT_YES;
+		set_bit(BCH_FS_VERSION_UPGRADE, &c->flags);
 	}
 }
 
@@ -1534,11 +1539,9 @@ int bch2_fs_initialize(struct bch_fs *c)
 	c->disk_sb.sb->compat[0] |= cpu_to_le64(1ULL << BCH_COMPAT_extents_above_btree_updates_done);
 	c->disk_sb.sb->compat[0] |= cpu_to_le64(1ULL << BCH_COMPAT_bformat_overflow_done);
 
-	if (c->sb.version < bcachefs_metadata_version_inode_v3)
-		c->opts.version_upgrade	= true;
-
-	if (c->opts.version_upgrade) {
+	if (c->opts.version_upgrade != BCH_VERSION_UPGRADE_none) {
 		c->disk_sb.sb->version = cpu_to_le16(bcachefs_metadata_version_current);
+		SET_BCH_SB_VERSION_UPGRADE_COMPLETE(c->disk_sb.sb, bcachefs_metadata_version_current);
 		c->disk_sb.sb->features[0] |= cpu_to_le64(BCH_SB_FEATURES_ALL);
 		bch2_write_super(c);
 	}
diff --git a/fs/bcachefs/super-io.c b/fs/bcachefs/super-io.c
index cb03e3f0c5..b174003b57 100644
--- a/fs/bcachefs/super-io.c
+++ b/fs/bcachefs/super-io.c
@@ -809,7 +809,7 @@ int bch2_write_super(struct bch_fs *c)
 	closure_init_stack(cl);
 	memset(&sb_written, 0, sizeof(sb_written));
 
-	if (c->opts.version_upgrade) {
+	if (test_bit(BCH_FS_VERSION_UPGRADE, &c->flags)) {
 		c->disk_sb.sb->magic = BCHFS_MAGIC;
 		c->disk_sb.sb->layout.magic = BCHFS_MAGIC;
 	}
@@ -1190,11 +1190,11 @@ int bch2_fs_mark_dirty(struct bch_fs *c)
 	if (BCH_SB_VERSION_UPGRADE_COMPLETE(c->disk_sb.sb) > bcachefs_metadata_version_current)
 		SET_BCH_SB_VERSION_UPGRADE_COMPLETE(c->disk_sb.sb, bcachefs_metadata_version_current);
 
-	if (c->opts.version_upgrade ||
+	if (test_bit(BCH_FS_VERSION_UPGRADE, &c->flags) ||
 	    c->sb.version > bcachefs_metadata_version_current)
 		c->disk_sb.sb->version = cpu_to_le16(bcachefs_metadata_version_current);
 
-	if (c->opts.version_upgrade)
+	if (test_bit(BCH_FS_VERSION_UPGRADE, &c->flags))
 		c->disk_sb.sb->features[0] |= cpu_to_le64(BCH_SB_FEATURES_ALL);
 
 	c->disk_sb.sb->features[0] |= cpu_to_le64(BCH_SB_FEATURES_ALWAYS);
-- 
2.40.1


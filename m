Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 934BD1598F4
	for <linux-bcachefs@vger.kernel.org>; Wed, 16 Apr 2025 13:39:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744810792; cv=none; b=mL/HUPVSU13U31K3PFpnNSLhBRhpp9djwqVvZm91cV26ZVeHCxNwwz946U0gJsss4onxYjZslrA8BSjzGsaYjIPchcl7h71CwD2rwKTPrlrDN2ITvck/Hem23AFXKUtGKqjFr0QLsOyGN04wV4IbsCoCUdLwvFvAExdD8QUA/JY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744810792; c=relaxed/simple;
	bh=qXmF6FQcG2TSmO1CyrrIrdJW6BUPnRonkO7m+9txQYc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=n/gJwPllpQGFwio1Jwv5NC/lux+tFy5RUiQ611uF+lCN5+FOtUxmnvXNUyUsalwexEK1CAKJ55o0NFvwDleZ+c0Z7kupd6UXHS1BC/n9vzIWqw8AmHbMaqCXDs7RJIIwnprUUuqGaER54/vo0lBgb2AO2H4M56/Yqygf2XUoPhc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=s/GkPz0m; arc=none smtp.client-ip=91.218.175.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="s/GkPz0m"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1744810788;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=TET6igpOswublPek14GWlpb7/N+98KWuGNZq0HnA/XI=;
	b=s/GkPz0mEHnk7YaefkUSUHF2vNBJKlyjwVZdpZDLjVB/yEnbuXnPAvQrkzqu0CUn6jvdVJ
	EW0RI/B9mZAdAvsDSJSBhrGzWXojDxzSZlZrBRCrRDUFsoDA49QTXJKWUEjTbrLgSSw8yf
	kGqNTnJ+OJsadlYv60dwVhi/hRHPoXk=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 1/3] bcachefs: BCH_FEATURE_no_alloc_info
Date: Wed, 16 Apr 2025 09:39:41 -0400
Message-ID: <20250416133943.3654046-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

If a filesystem is going to only be used read-only, and will be a
deployable image, we can strip out alloc info for a substantial
reduction in metadata size - around half, due to backpointers.

Alloc info will be regenerated on first read-write mount.

Remounting RW is disallowed for now, since we don't yet have
check_allocations running in RW mode.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/bcachefs_format.h       |  3 ++-
 fs/bcachefs/errcode.h               |  1 +
 fs/bcachefs/recovery.c              | 28 ++++++++++++++++++++++------
 fs/bcachefs/recovery.h              |  1 +
 fs/bcachefs/recovery_passes.c       | 14 +++++++++++++-
 fs/bcachefs/recovery_passes_types.h | 18 ++++++++++--------
 fs/bcachefs/sb-members.c            |  6 ++++++
 fs/bcachefs/super.c                 |  6 ++++++
 8 files changed, 61 insertions(+), 16 deletions(-)

diff --git a/fs/bcachefs/bcachefs_format.h b/fs/bcachefs/bcachefs_format.h
index e6203665f230..7e2debc40045 100644
--- a/fs/bcachefs/bcachefs_format.h
+++ b/fs/bcachefs/bcachefs_format.h
@@ -918,7 +918,8 @@ static inline void SET_BCH_SB_BACKGROUND_COMPRESSION_TYPE(struct bch_sb *sb, __u
 	x(alloc_v2,			17)	\
 	x(extents_across_btree_nodes,	18)	\
 	x(incompat_version_field,	19)	\
-	x(casefolding,			20)
+	x(casefolding,			20)	\
+	x(no_alloc_info,		21)
 
 #define BCH_SB_FEATURES_ALWAYS				\
 	(BIT_ULL(BCH_FEATURE_new_extent_overwrite)|	\
diff --git a/fs/bcachefs/errcode.h b/fs/bcachefs/errcode.h
index 4a040085454c..e54c8264e7e1 100644
--- a/fs/bcachefs/errcode.h
+++ b/fs/bcachefs/errcode.h
@@ -221,6 +221,7 @@
 	x(EROFS,			erofs_unfixed_errors)			\
 	x(EROFS,			erofs_norecovery)			\
 	x(EROFS,			erofs_nochanges)			\
+	x(EROFS,			erofs_no_alloc_info)			\
 	x(EROFS,			insufficient_devices)			\
 	x(0,				operation_blocked)			\
 	x(BCH_ERR_operation_blocked,	btree_cache_cannibalize_lock_blocked)	\
diff --git a/fs/bcachefs/recovery.c b/fs/bcachefs/recovery.c
index 58ee1ebdcbaa..fbe2e6406f53 100644
--- a/fs/bcachefs/recovery.c
+++ b/fs/bcachefs/recovery.c
@@ -32,7 +32,6 @@
 #include <linux/sort.h>
 #include <linux/stat.h>
 
-
 int bch2_btree_lost_data(struct bch_fs *c, enum btree_id btree)
 {
 	u64 b = BIT_ULL(btree);
@@ -113,11 +112,8 @@ static void kill_btree(struct bch_fs *c, enum btree_id btree)
 }
 
 /* for -o reconstruct_alloc: */
-static void bch2_reconstruct_alloc(struct bch_fs *c)
+void bch2_reconstruct_alloc(struct bch_fs *c)
 {
-	bch2_journal_log_msg(c, "dropping alloc info");
-	bch_info(c, "dropping and reconstructing all alloc info");
-
 	mutex_lock(&c->sb_lock);
 	struct bch_sb_field_ext *ext = bch2_sb_field_get(c->disk_sb.sb, ext);
 
@@ -159,6 +155,8 @@ static void bch2_reconstruct_alloc(struct bch_fs *c)
 
 	c->opts.recovery_passes |= bch2_recovery_passes_from_stable(le64_to_cpu(ext->recovery_passes_required[0]));
 
+	c->disk_sb.sb->features[0] &= ~cpu_to_le64(BIT_ULL(BCH_FEATURE_no_alloc_info));
+
 	bch2_write_super(c);
 	mutex_unlock(&c->sb_lock);
 
@@ -888,8 +886,26 @@ int bch2_fs_recovery(struct bch_fs *c)
 	if (ret)
 		goto err;
 
-	if (c->opts.reconstruct_alloc)
+	if (!c->opts.read_only &&
+	    (c->sb.features & BIT_ULL(BCH_FEATURE_no_alloc_info))) {
+		bch_info(c, "mounting a filesystem with no alloc info read-write; will recreate");
+
 		bch2_reconstruct_alloc(c);
+	} else if (c->opts.reconstruct_alloc) {
+		bch2_journal_log_msg(c, "dropping alloc info");
+		bch_info(c, "dropping and reconstructing all alloc info");
+
+		bch2_reconstruct_alloc(c);
+	}
+
+	if (c->sb.features & BIT_ULL(BCH_FEATURE_no_alloc_info)) {
+		/* We can't go RW to fix errors without alloc info */
+		if (c->opts.fix_errors == FSCK_FIX_yes ||
+		    c->opts.fix_errors == FSCK_FIX_ask)
+			c->opts.fix_errors = FSCK_FIX_no;
+		if (c->opts.errors == BCH_ON_ERROR_fix_safe)
+			c->opts.errors = BCH_ON_ERROR_continue;
+	}
 
 	/*
 	 * After an unclean shutdown, skip then next few journal sequence
diff --git a/fs/bcachefs/recovery.h b/fs/bcachefs/recovery.h
index b0d55754b21b..d858ba674eaa 100644
--- a/fs/bcachefs/recovery.h
+++ b/fs/bcachefs/recovery.h
@@ -3,6 +3,7 @@
 #define _BCACHEFS_RECOVERY_H
 
 int bch2_btree_lost_data(struct bch_fs *, enum btree_id);
+void bch2_reconstruct_alloc(struct bch_fs *);
 
 int bch2_journal_replay(struct bch_fs *);
 
diff --git a/fs/bcachefs/recovery_passes.c b/fs/bcachefs/recovery_passes.c
index 92e431af9ac3..7a6444088aa6 100644
--- a/fs/bcachefs/recovery_passes.c
+++ b/fs/bcachefs/recovery_passes.c
@@ -46,8 +46,18 @@ static int bch2_set_may_go_rw(struct bch_fs *c)
 
 	set_bit(BCH_FS_may_go_rw, &c->flags);
 
-	if (keys->nr || !c->opts.read_only || c->opts.fsck || !c->sb.clean || c->opts.recovery_passes)
+	if (keys->nr ||
+	    !c->opts.read_only ||
+	    !c->sb.clean ||
+	    c->opts.recovery_passes ||
+	    (c->opts.fsck && !(c->sb.features & BIT_ULL(BCH_FEATURE_no_alloc_info)))) {
+		if (c->sb.features & BIT_ULL(BCH_FEATURE_no_alloc_info)) {
+			bch_info(c, "mounting a filesystem with no alloc info read-write; will recreate");
+			bch2_reconstruct_alloc(c);
+		}
+
 		return bch2_fs_read_write_early(c);
+	}
 	return 0;
 }
 
@@ -239,6 +249,8 @@ static bool should_run_recovery_pass(struct bch_fs *c, enum bch_recovery_pass pa
 {
 	struct recovery_pass_fn *p = recovery_pass_fns + pass;
 
+	if ((p->when & PASS_ALLOC) && (c->sb.features & BIT_ULL(BCH_FEATURE_no_alloc_info)))
+		return false;
 	if (c->opts.recovery_passes_exclude & BIT_ULL(pass))
 		return false;
 	if (c->opts.recovery_passes & BIT_ULL(pass))
diff --git a/fs/bcachefs/recovery_passes_types.h b/fs/bcachefs/recovery_passes_types.h
index 4671ccf2d560..f9d565bb50dd 100644
--- a/fs/bcachefs/recovery_passes_types.h
+++ b/fs/bcachefs/recovery_passes_types.h
@@ -7,6 +7,8 @@
 #define PASS_UNCLEAN		BIT(2)
 #define PASS_ALWAYS		BIT(3)
 #define PASS_ONLINE		BIT(4)
+#define PASS_ALLOC		BIT(5)
+#define PASS_FSCK_ALLOC		(PASS_FSCK|PASS_ALLOC)
 
 #ifdef CONFIG_BCACHEFS_DEBUG
 #define PASS_FSCK_DEBUG		BIT(1)
@@ -27,17 +29,17 @@
 	x(stripes_read,				 1, 0)					\
 	x(initialize_subvolumes,		 2, 0)					\
 	x(snapshots_read,			 3, PASS_ALWAYS)			\
-	x(check_allocations,			 5, PASS_FSCK)				\
-	x(trans_mark_dev_sbs,			 6, PASS_ALWAYS|PASS_SILENT)		\
-	x(fs_journal_alloc,			 7, PASS_ALWAYS|PASS_SILENT)		\
+	x(check_allocations,			 5, PASS_FSCK_ALLOC)			\
+	x(trans_mark_dev_sbs,			 6, PASS_ALWAYS|PASS_SILENT|PASS_ALLOC)	\
+	x(fs_journal_alloc,			 7, PASS_ALWAYS|PASS_SILENT|PASS_ALLOC)	\
 	x(set_may_go_rw,			 8, PASS_ALWAYS|PASS_SILENT)		\
 	x(journal_replay,			 9, PASS_ALWAYS)			\
-	x(check_alloc_info,			10, PASS_ONLINE|PASS_FSCK)		\
-	x(check_lrus,				11, PASS_ONLINE|PASS_FSCK)		\
-	x(check_btree_backpointers,		12, PASS_ONLINE|PASS_FSCK)		\
+	x(check_alloc_info,			10, PASS_ONLINE|PASS_FSCK_ALLOC)	\
+	x(check_lrus,				11, PASS_ONLINE|PASS_FSCK_ALLOC)	\
+	x(check_btree_backpointers,		12, PASS_ONLINE|PASS_FSCK_ALLOC)	\
 	x(check_backpointers_to_extents,	13, PASS_ONLINE|PASS_FSCK_DEBUG)	\
-	x(check_extents_to_backpointers,	14, PASS_ONLINE|PASS_FSCK)		\
-	x(check_alloc_to_lru_refs,		15, PASS_ONLINE|PASS_FSCK)		\
+	x(check_extents_to_backpointers,	14, PASS_ONLINE|PASS_FSCK_ALLOC)	\
+	x(check_alloc_to_lru_refs,		15, PASS_ONLINE|PASS_FSCK_ALLOC)	\
 	x(fs_freespace_init,			16, PASS_ALWAYS|PASS_SILENT)		\
 	x(bucket_gens_init,			17, 0)					\
 	x(reconstruct_snapshots,		38, 0)					\
diff --git a/fs/bcachefs/sb-members.c b/fs/bcachefs/sb-members.c
index cdc4258c3c21..9a82ed3f18f5 100644
--- a/fs/bcachefs/sb-members.c
+++ b/fs/bcachefs/sb-members.c
@@ -188,6 +188,12 @@ static int validate_member(struct printbuf *err,
 		return -BCH_ERR_invalid_sb_members;
 	}
 
+	if (BCH_MEMBER_FREESPACE_INITIALIZED(&m) &&
+	    sb->features[0] & BIT_ULL(BCH_FEATURE_no_alloc_info)) {
+		prt_printf(err, "device %u: freespace initialized but fs has no alloc info", i);
+		return -BCH_ERR_invalid_sb_members;
+	}
+
 	return 0;
 }
 
diff --git a/fs/bcachefs/super.c b/fs/bcachefs/super.c
index 2d244deb07a8..797601756af1 100644
--- a/fs/bcachefs/super.c
+++ b/fs/bcachefs/super.c
@@ -464,6 +464,9 @@ static int __bch2_fs_read_write(struct bch_fs *c, bool early)
 
 	BUG_ON(!test_bit(BCH_FS_may_go_rw, &c->flags));
 
+	if (WARN_ON(c->sb.features & BIT_ULL(BCH_FEATURE_no_alloc_info)))
+		return -BCH_ERR_erofs_no_alloc_info;
+
 	if (test_bit(BCH_FS_initial_gc_unfixed, &c->flags)) {
 		bch_err(c, "cannot go rw, unfixed btree errors");
 		return -BCH_ERR_erofs_unfixed_errors;
@@ -550,6 +553,9 @@ int bch2_fs_read_write(struct bch_fs *c)
 	if (c->opts.nochanges)
 		return -BCH_ERR_erofs_nochanges;
 
+	if (c->sb.features & BIT_ULL(BCH_FEATURE_no_alloc_info))
+		return -BCH_ERR_erofs_no_alloc_info;
+
 	return __bch2_fs_read_write(c, false);
 }
 
-- 
2.49.0


Received: from out-173.mta1.migadu.com (out-173.mta1.migadu.com [95.215.58.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6693820469E
	for <linux-bcachefs@vger.kernel.org>; Tue, 15 Apr 2025 14:29:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744727371; cv=none; b=GZ7XdfV4sqyRUnO0YIApoUk8RJLl58ZZ0vGtOl96nnk+Z8K5am+mkWdcWez/nV5rJRQNH6CPPKiutkMkJ3YxYn4fhPh/jNhkBjwlLJgtwCg/84c7tpmmPVJ7YBgdzErJiipeZoMCDpez0R836cbrUwRR7MTSDVUxfiv44bCcss0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744727371; c=relaxed/simple;
	bh=Jm2Thnve3VH5N6KYrb7EckyV2TXEnymRPvXmAHN8fXM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sO6gISm4GhhD5VPEJup55C8FiLhFlY3ZvVxa2FV9BXqInW4jWh2oe0I9BgzYZgnQnZ8SLiRI5lCx3EmO7REitOUVZiQ1bHVTbN7J6kUW0DN6yLhqZhaSskjnb5lOllUnTtsDna4cVL5Ea7HiMG5Z3jGdXzzWDL4ceUnat1tZRBQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=EEsDcenn; arc=none smtp.client-ip=95.215.58.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="EEsDcenn"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1744727367;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KFsHgqNEq2fzTgRldz9xhnaE1Db//oQcQy3B++qG9+g=;
	b=EEsDcennazl9kdrXNgCPUbEAwnucAXAP18Z9G8omWGj3b/fYDOD177muW4hAsDjijXSZfP
	HurXy/jCy1LFTQTR4FWSkTDsoMuTubRm2t/hzbkyKIQYbRRHQxymnxzM1E3PDCYVMTChVE
	DowovoYwnJJMMYj3Gm4tvNqnuVv1Rzk=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 2/3] bcachefs: Clean up option pre/post hooks, small fixes
Date: Tue, 15 Apr 2025 10:29:20 -0400
Message-ID: <20250415142921.2624601-2-kent.overstreet@linux.dev>
In-Reply-To: <20250415142921.2624601-1-kent.overstreet@linux.dev>
References: <20250415142921.2624601-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

The helpers are now:
- bch2_opt_hook_pre_set()
- bch2_opts_hooks_pre_set()
- bch2_opt_hook_post_set

Fix a bug where the filesystem discard option would incorrectly be
changed when setting the device option, and don't trigger rebalance
scans unnecessarily (when options aren't changing).

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/inode.h |  2 +-
 fs/bcachefs/opts.c  | 81 +++++++++++++++++++++++++++++++++++++++------
 fs/bcachefs/opts.h  | 11 +++---
 fs/bcachefs/super.c |  2 +-
 fs/bcachefs/sysfs.c | 29 ++++------------
 fs/bcachefs/xattr.c |  2 +-
 6 files changed, 87 insertions(+), 40 deletions(-)

diff --git a/fs/bcachefs/inode.h b/fs/bcachefs/inode.h
index f82cfbf460d0..1b2fc902af1c 100644
--- a/fs/bcachefs/inode.h
+++ b/fs/bcachefs/inode.h
@@ -284,7 +284,7 @@ static inline bool bch2_inode_should_have_single_bp(struct bch_inode_unpacked *i
 struct bch_opts bch2_inode_opts_to_opts(struct bch_inode_unpacked *);
 void bch2_inode_opts_get(struct bch_io_opts *, struct bch_fs *,
 			 struct bch_inode_unpacked *);
-int bch2_inum_opts_get(struct btree_trans*, subvol_inum, struct bch_io_opts *);
+int bch2_inum_opts_get(struct btree_trans *, subvol_inum, struct bch_io_opts *);
 
 #include "rebalance.h"
 
diff --git a/fs/bcachefs/opts.c b/fs/bcachefs/opts.c
index b3fcffc91d6f..386482ff8e7b 100644
--- a/fs/bcachefs/opts.c
+++ b/fs/bcachefs/opts.c
@@ -7,7 +7,9 @@
 #include "compress.h"
 #include "disk_groups.h"
 #include "error.h"
+#include "movinggc.h"
 #include "opts.h"
+#include "rebalance.h"
 #include "recovery_passes.h"
 #include "super-io.h"
 #include "util.h"
@@ -516,7 +518,7 @@ void bch2_opts_to_text(struct printbuf *out,
 	}
 }
 
-int bch2_opt_check_may_set(struct bch_fs *c, struct bch_dev *ca, int id, u64 v)
+int bch2_opt_hook_pre_set(struct bch_fs *c, struct bch_dev *ca, enum bch_opt_id id, u64 v)
 {
 	int ret = 0;
 
@@ -534,15 +536,17 @@ int bch2_opt_check_may_set(struct bch_fs *c, struct bch_dev *ca, int id, u64 v)
 		if (v)
 			bch2_check_set_feature(c, BCH_FEATURE_ec);
 		break;
+	default:
+		break;
 	}
 
 	return ret;
 }
 
-int bch2_opts_check_may_set(struct bch_fs *c)
+int bch2_opts_hooks_pre_set(struct bch_fs *c)
 {
 	for (unsigned i = 0; i < bch2_opts_nr; i++) {
-		int ret = bch2_opt_check_may_set(c, NULL, i, bch2_opt_get_by_id(&c->opts, i));
+		int ret = bch2_opt_hook_pre_set(c, NULL, i, bch2_opt_get_by_id(&c->opts, i));
 		if (ret)
 			return ret;
 	}
@@ -550,6 +554,52 @@ int bch2_opts_check_may_set(struct bch_fs *c)
 	return 0;
 }
 
+void bch2_opt_hook_post_set(struct bch_fs *c, struct bch_dev *ca, u64 inum,
+			    struct bch_opts *new_opts, enum bch_opt_id id)
+{
+	switch (id) {
+	case Opt_foreground_target:
+		if (new_opts->foreground_target &&
+		    !new_opts->background_target)
+			bch2_set_rebalance_needs_scan(c, inum);
+		break;
+	case Opt_compression:
+		if (new_opts->compression &&
+		    !new_opts->background_compression)
+			bch2_set_rebalance_needs_scan(c, inum);
+		break;
+	case Opt_background_target:
+		if (new_opts->background_target)
+			bch2_set_rebalance_needs_scan(c, inum);
+		break;
+	case Opt_background_compression:
+		if (new_opts->background_compression)
+			bch2_set_rebalance_needs_scan(c, inum);
+		break;
+	case Opt_rebalance_enabled:
+		bch2_rebalance_wakeup(c);
+		break;
+	case Opt_copygc_enabled:
+		bch2_copygc_wakeup(c);
+		break;
+	case Opt_discard:
+		if (!ca) {
+			mutex_lock(&c->sb_lock);
+			for_each_member_device(c, ca) {
+				struct bch_member *m =
+					bch2_members_v2_get_mut(ca->disk_sb.sb, ca->dev_idx);
+				SET_BCH_MEMBER_DISCARD(m, c->opts.discard);
+			}
+
+			bch2_write_super(c);
+			mutex_unlock(&c->sb_lock);
+		}
+		break;
+	default:
+		break;
+	}
+}
+
 int bch2_parse_one_mount_opt(struct bch_fs *c, struct bch_opts *opts,
 			     struct printbuf *parse_later,
 			     const char *name, const char *val)
@@ -709,9 +759,11 @@ int bch2_opts_from_sb(struct bch_opts *opts, struct bch_sb *sb)
 	return 0;
 }
 
-void __bch2_opt_set_sb(struct bch_sb *sb, int dev_idx,
+bool __bch2_opt_set_sb(struct bch_sb *sb, int dev_idx,
 		       const struct bch_option *opt, u64 v)
 {
+	bool changed = false;
+
 	if (opt->flags & OPT_SB_FIELD_SECTORS)
 		v >>= 9;
 
@@ -721,26 +773,35 @@ void __bch2_opt_set_sb(struct bch_sb *sb, int dev_idx,
 	if (opt->flags & OPT_SB_FIELD_ONE_BIAS)
 		v++;
 
-	if ((opt->flags & OPT_FS) && opt->set_sb && dev_idx < 0)
+	if ((opt->flags & OPT_FS) && opt->set_sb && dev_idx < 0) {
+		changed = v != opt->get_sb(sb);
+
 		opt->set_sb(sb, v);
+	}
 
 	if ((opt->flags & OPT_DEVICE) && opt->set_member && dev_idx >= 0) {
 		if (WARN(!bch2_member_exists(sb, dev_idx),
 			 "tried to set device option %s on nonexistent device %i",
 			 opt->attr.name, dev_idx))
-			return;
+			return false;
 
-		opt->set_member(bch2_members_v2_get_mut(sb, dev_idx), v);
+		struct bch_member *m = bch2_members_v2_get_mut(sb, dev_idx);
+		changed = v != opt->get_member(m);
+		opt->set_member(m, v);
 	}
+
+	return changed;
 }
 
-void bch2_opt_set_sb(struct bch_fs *c, struct bch_dev *ca,
+bool bch2_opt_set_sb(struct bch_fs *c, struct bch_dev *ca,
 		     const struct bch_option *opt, u64 v)
 {
 	mutex_lock(&c->sb_lock);
-	__bch2_opt_set_sb(c->disk_sb.sb, ca ? ca->dev_idx : -1, opt, v);
-	bch2_write_super(c);
+	bool changed = __bch2_opt_set_sb(c->disk_sb.sb, ca ? ca->dev_idx : -1, opt, v);
+	if (changed)
+		bch2_write_super(c);
 	mutex_unlock(&c->sb_lock);
+	return changed;
 }
 
 /* io opts: */
diff --git a/fs/bcachefs/opts.h b/fs/bcachefs/opts.h
index 4be0634eae80..f69ba5e63e15 100644
--- a/fs/bcachefs/opts.h
+++ b/fs/bcachefs/opts.h
@@ -607,10 +607,10 @@ void bch2_opt_set_by_id(struct bch_opts *, enum bch_opt_id, u64);
 
 u64 bch2_opt_from_sb(struct bch_sb *, enum bch_opt_id, int);
 int bch2_opts_from_sb(struct bch_opts *, struct bch_sb *);
-void __bch2_opt_set_sb(struct bch_sb *, int, const struct bch_option *, u64);
+bool __bch2_opt_set_sb(struct bch_sb *, int, const struct bch_option *, u64);
 
 struct bch_dev;
-void bch2_opt_set_sb(struct bch_fs *, struct bch_dev *, const struct bch_option *, u64);
+bool bch2_opt_set_sb(struct bch_fs *, struct bch_dev *, const struct bch_option *, u64);
 
 int bch2_opt_lookup(const char *);
 int bch2_opt_validate(const struct bch_option *, u64, struct printbuf *);
@@ -627,8 +627,11 @@ void bch2_opts_to_text(struct printbuf *,
 		       struct bch_fs *, struct bch_sb *,
 		       unsigned, unsigned, unsigned);
 
-int bch2_opt_check_may_set(struct bch_fs *, struct bch_dev *, int, u64);
-int bch2_opts_check_may_set(struct bch_fs *);
+int bch2_opt_hook_pre_set(struct bch_fs *, struct bch_dev *, enum bch_opt_id, u64);
+int bch2_opts_hooks_pre_set(struct bch_fs *);
+void bch2_opt_hook_post_set(struct bch_fs *, struct bch_dev *, u64,
+			    struct bch_opts *, enum bch_opt_id);
+
 int bch2_parse_one_mount_opt(struct bch_fs *, struct bch_opts *,
 			     struct printbuf *, const char *, const char *);
 int bch2_parse_mount_opts(struct bch_fs *, struct bch_opts *, struct printbuf *,
diff --git a/fs/bcachefs/super.c b/fs/bcachefs/super.c
index 72e001e4c151..1d27a306938d 100644
--- a/fs/bcachefs/super.c
+++ b/fs/bcachefs/super.c
@@ -1099,7 +1099,7 @@ int bch2_fs_start(struct bch_fs *c)
 	if (ret)
 		goto err;
 
-	ret = bch2_opts_check_may_set(c);
+	ret = bch2_opts_hooks_pre_set(c);
 	if (ret)
 		goto err;
 
diff --git a/fs/bcachefs/sysfs.c b/fs/bcachefs/sysfs.c
index 00405372af5e..455c6ae9a494 100644
--- a/fs/bcachefs/sysfs.c
+++ b/fs/bcachefs/sysfs.c
@@ -749,36 +749,19 @@ static ssize_t sysfs_opt_store(struct bch_fs *c,
 
 	u64 v;
 	ret =   bch2_opt_parse(c, opt, strim(tmp), &v, NULL) ?:
-		bch2_opt_check_may_set(c, ca, id, v);
+		bch2_opt_hook_pre_set(c, ca, id, v);
 	kfree(tmp);
 
 	if (ret < 0)
 		goto err;
 
-	bch2_opt_set_sb(c, ca, opt, v);
-	bch2_opt_set_by_id(&c->opts, id, v);
+	bool changed = bch2_opt_set_sb(c, ca, opt, v);
 
-	if (v &&
-	    (id == Opt_background_target ||
-	     (id == Opt_foreground_target && !c->opts.background_target) ||
-	     id == Opt_background_compression ||
-	     (id == Opt_compression && !c->opts.background_compression)))
-		bch2_set_rebalance_needs_scan(c, 0);
+	if (!ca)
+		bch2_opt_set_by_id(&c->opts, id, v);
 
-	if (v && id == Opt_rebalance_enabled)
-		bch2_rebalance_wakeup(c);
-
-	if (v && id == Opt_copygc_enabled)
-		bch2_copygc_wakeup(c);
-
-	if (id == Opt_discard && !ca) {
-		mutex_lock(&c->sb_lock);
-		for_each_member_device(c, ca)
-			opt->set_member(bch2_members_v2_get_mut(ca->disk_sb.sb, ca->dev_idx), v);
-
-		bch2_write_super(c);
-		mutex_unlock(&c->sb_lock);
-	}
+	if (changed)
+		bch2_opt_hook_post_set(c, ca, 0, &c->opts, id);
 
 	ret = size;
 err:
diff --git a/fs/bcachefs/xattr.c b/fs/bcachefs/xattr.c
index 651da52b2cbc..3d324e485ee9 100644
--- a/fs/bcachefs/xattr.c
+++ b/fs/bcachefs/xattr.c
@@ -523,7 +523,7 @@ static int bch2_xattr_bcachefs_set(const struct xattr_handler *handler,
 		if (ret < 0)
 			goto err_class_exit;
 
-		ret = bch2_opt_check_may_set(c, NULL, opt_id, v);
+		ret = bch2_opt_hook_pre_set(c, NULL, opt_id, v);
 		if (ret < 0)
 			goto err_class_exit;
 
-- 
2.49.0


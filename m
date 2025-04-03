Received: from out-187.mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 939251F8720
	for <linux-bcachefs@vger.kernel.org>; Thu,  3 Apr 2025 17:18:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743700683; cv=none; b=cnnUaV+rfYu3EKwdiHtAT0I3bYNlwUaFZXtQ0bZaHAgqaQ7AgAfHdlJj8MZG2T/SAcdWtnzwzpBe7cE3makAgU4CUxFaW20nMW9UlZVzY9Y0diWz1zW9HhEvB+vvyySq3nDPBSFMn11n42SKNaZMVmsRZ3oFgNu9BzqRdvtK/HA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743700683; c=relaxed/simple;
	bh=fxkm9NOuhZYJOfQ5ZoaO88smZR12MkVrSXmcOCzSaUI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gTTrQAWumHTmieew8Rfj5ohi2OqUa/vmBcODNA0YTQv/h4npGf9q0j7Xo1w5Rw9aFn3GsZgCZB9b9A878Z0rNwwIiG86WWVU+ZRM/NtwCBIAOJzb2m/MyVvZaFJldGQE4k1bNGHkj4v+yNSYuHThWIx26TgVUAvI+Y1ZPFBWI1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=TAldnvo7; arc=none smtp.client-ip=95.215.58.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="TAldnvo7"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1743700678;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Fyk/NHA+ut0gpPHBAHG+jIwSyDW4VPPrdJJINhTNOGk=;
	b=TAldnvo7o0bQ3ewv211QmHzQWxp3w7Nvl14MBekPVGV2MHTro7FMCXzcQq1pt3C+r+Ms/3
	HDdyNfUKyS583u6UkDmOGiO5wzXlYNiXOK5SvmnLptyEXUz3Bkoblhlv51d0ECtsazkzLk
	GXh8IH9KSVLcpezoBM5c8/i3ovb0g4o=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 2/2] bcachefs: Single device mode
Date: Thu,  3 Apr 2025 13:17:51 -0400
Message-ID: <20250403171751.2384984-2-kent.overstreet@linux.dev>
In-Reply-To: <20250403171751.2384984-1-kent.overstreet@linux.dev>
References: <20250403171751.2384984-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

This provides a new option for single device mode - which allows
multiple filesystems with the same UUID to be mounted simultaneously.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/bcachefs_format.h |  2 +-
 fs/bcachefs/debug.c           |  6 +++++-
 fs/bcachefs/errcode.h         |  2 ++
 fs/bcachefs/opts.c            |  6 ++++++
 fs/bcachefs/opts.h            | 11 ++++++++---
 fs/bcachefs/super.c           | 14 ++++++++++----
 6 files changed, 32 insertions(+), 9 deletions(-)

diff --git a/fs/bcachefs/bcachefs_format.h b/fs/bcachefs/bcachefs_format.h
index a3db328dee31..8a1366aabebd 100644
--- a/fs/bcachefs/bcachefs_format.h
+++ b/fs/bcachefs/bcachefs_format.h
@@ -842,7 +842,7 @@ LE64_BITMASK(BCH_SB_SHARD_INUMS,	struct bch_sb, flags[3], 28, 29);
 LE64_BITMASK(BCH_SB_INODES_USE_KEY_CACHE,struct bch_sb, flags[3], 29, 30);
 LE64_BITMASK(BCH_SB_JOURNAL_FLUSH_DELAY,struct bch_sb, flags[3], 30, 62);
 LE64_BITMASK(BCH_SB_JOURNAL_FLUSH_DISABLED,struct bch_sb, flags[3], 62, 63);
-/* one free bit */
+LE64_BITMASK(BCH_SB_SINGLE_DEVICE,	struct bch_sb,	flags[3], 63, 64);
 LE64_BITMASK(BCH_SB_JOURNAL_RECLAIM_DELAY,struct bch_sb, flags[4], 0, 32);
 LE64_BITMASK(BCH_SB_JOURNAL_TRANSACTION_NAMES,struct bch_sb, flags[4], 32, 33);
 LE64_BITMASK(BCH_SB_NOCOW,		struct bch_sb, flags[4], 33, 34);
diff --git a/fs/bcachefs/debug.c b/fs/bcachefs/debug.c
index f4b7877c0843..09b672799ca9 100644
--- a/fs/bcachefs/debug.c
+++ b/fs/bcachefs/debug.c
@@ -933,7 +933,11 @@ void bch2_fs_debug_init(struct bch_fs *c)
 	if (IS_ERR_OR_NULL(bch_debug))
 		return;
 
-	snprintf(name, sizeof(name), "%pU", c->sb.user_uuid.b);
+	if (!c->opts.single_device)
+		snprintf(name, sizeof(name), "%pU", c->sb.user_uuid.b);
+	else
+		strscpy(name, c->name, sizeof(name));
+
 	c->fs_debug_dir = debugfs_create_dir(name, bch_debug);
 	if (IS_ERR_OR_NULL(c->fs_debug_dir))
 		return;
diff --git a/fs/bcachefs/errcode.h b/fs/bcachefs/errcode.h
index c8696f01eb14..c4eb0ed9838d 100644
--- a/fs/bcachefs/errcode.h
+++ b/fs/bcachefs/errcode.h
@@ -192,6 +192,8 @@
 	x(BCH_ERR_data_update_done,	data_update_done_no_rw_devs)		\
 	x(EINVAL,			device_state_not_allowed)		\
 	x(EINVAL,			member_info_missing)			\
+	x(EINVAL,			single_device_filesystem)		\
+	x(EINVAL,			not_single_device_filesystem)		\
 	x(EINVAL,			mismatched_block_size)			\
 	x(EINVAL,			block_size_too_small)			\
 	x(EINVAL,			bucket_size_too_small)			\
diff --git a/fs/bcachefs/opts.c b/fs/bcachefs/opts.c
index af3258814822..808f1285b5e8 100644
--- a/fs/bcachefs/opts.c
+++ b/fs/bcachefs/opts.c
@@ -498,6 +498,12 @@ int bch2_opt_check_may_set(struct bch_fs *c, struct bch_dev *ca, int id, u64 v)
 		if (v)
 			bch2_check_set_feature(c, BCH_FEATURE_ec);
 		break;
+	case Opt_single_device:
+		mutex_lock(&c->sb_lock);
+		if (bch2_sb_nr_devices(c->disk_sb.sb) > 1)
+			ret = -BCH_ERR_not_single_device_filesystem;
+		mutex_unlock(&c->sb_lock);
+		break;
 	}
 
 	return ret;
diff --git a/fs/bcachefs/opts.h b/fs/bcachefs/opts.h
index 4d06313076ff..45b393f83776 100644
--- a/fs/bcachefs/opts.h
+++ b/fs/bcachefs/opts.h
@@ -517,7 +517,7 @@ enum fsck_err_opts {
 	  BCH_MEMBER_DATA_ALLOWED,	BIT(BCH_DATA_journal)|BIT(BCH_DATA_btree)|BIT(BCH_DATA_user),\
 	  "types",	"Allowed data types for this device: journal, btree, and/or user")\
 	x(discard,			u8,				\
-	  OPT_MOUNT|OPT_DEVICE|OPT_RUNTIME,				\
+	  OPT_MOUNT|OPT_FS|OPT_DEVICE|OPT_RUNTIME,			\
 	  OPT_BOOL(),							\
 	  BCH_MEMBER_DISCARD,		true,				\
 	  NULL,		"Enable discard/TRIM support")			\
@@ -525,8 +525,13 @@ enum fsck_err_opts {
 	  OPT_FS|OPT_MOUNT|OPT_RUNTIME,					\
 	  OPT_BOOL(),							\
 	  BCH2_NO_SB_OPT,		true,				\
-	  NULL,		"BTREE_ITER_prefetch casuse btree nodes to be\n"\
-	  " prefetched sequentially")
+	  NULL,		"BTREE_ITER_prefetch causes btree nodes to be\n"\
+	  " prefetched sequentially")					\
+	x(single_device,		u8,				\
+	  OPT_FS|OPT_MOUNT|OPT_RUNTIME,					\
+	  OPT_BOOL(),							\
+	  BCH_SB_SINGLE_DEVICE,		false,				\
+	  NULL,		"Devices with the same UUID may be mounted simultaneously")
 
 struct bch_opts {
 #define x(_name, _bits, ...)	unsigned _name##_defined:1;
diff --git a/fs/bcachefs/super.c b/fs/bcachefs/super.c
index 07c8149c6712..f868bc5cd19a 100644
--- a/fs/bcachefs/super.c
+++ b/fs/bcachefs/super.c
@@ -708,7 +708,8 @@ static int bch2_fs_online(struct bch_fs *c)
 
 	lockdep_assert_held(&bch_fs_list_lock);
 
-	if (__bch2_uuid_to_fs(c->sb.uuid)) {
+	if (!c->opts.single_device &&
+	    __bch2_uuid_to_fs(c->sb.uuid)) {
 		bch_err(c, "filesystem UUID already open");
 		return -EINVAL;
 	}
@@ -721,7 +722,9 @@ static int bch2_fs_online(struct bch_fs *c)
 
 	bch2_fs_debug_init(c);
 
-	ret = kobject_add(&c->kobj, NULL, "%pU", c->sb.user_uuid.b) ?:
+	ret = (!c->opts.single_device
+	       ? kobject_add(&c->kobj, NULL, "%pU", c->sb.user_uuid.b)
+	       : kobject_add(&c->kobj, NULL, "%s", c->name)) ?:
 	    kobject_add(&c->internal, &c->kobj, "internal") ?:
 	    kobject_add(&c->opts_dir, &c->kobj, "options") ?:
 #ifndef CONFIG_BCACHEFS_NO_LATENCY_ACCT
@@ -897,7 +900,7 @@ static struct bch_fs *bch2_fs_alloc(struct bch_sb *sb, struct bch_opts opts,
 		goto err;
 	}
 
-	if (sbs->nr != 1)
+	if (sbs->nr != 1 && !c->opts.single_device)
 		pr_uuid(&name, c->sb.user_uuid.b);
 	else
 		prt_bdevname(&name, sbs->data[0].bdev);
@@ -1114,6 +1117,9 @@ static int bch2_dev_may_add(struct bch_sb *sb, struct bch_fs *c)
 {
 	struct bch_member m = bch2_sb_member_get(sb, sb->dev_idx);
 
+	if (c->opts.single_device)
+		return -BCH_ERR_single_device_filesystem;
+
 	if (le16_to_cpu(sb->block_size) != block_sectors(c))
 		return -BCH_ERR_mismatched_block_size;
 
@@ -1781,7 +1787,7 @@ int bch2_dev_remove(struct bch_fs *c, struct bch_dev *ca, int flags)
 int bch2_dev_add(struct bch_fs *c, const char *path)
 {
 	struct bch_opts opts = bch2_opts_empty();
-	struct bch_sb_handle sb;
+	struct bch_sb_handle sb = {};
 	struct bch_dev *ca = NULL;
 	struct printbuf errbuf = PRINTBUF;
 	struct printbuf label = PRINTBUF;
-- 
2.49.0


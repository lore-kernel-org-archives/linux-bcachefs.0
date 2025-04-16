Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35AFB179A7
	for <linux-bcachefs@vger.kernel.org>; Wed, 16 Apr 2025 13:36:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744810602; cv=none; b=ijrv3mQlvzl6wPkK0LFy9l5kz4PNIzFakOwwvphEN1nR/Jzc0TLkyuUbvy3Iu9l7c4au7F3jhoJOHmayzV2ln6EJ5Wh4fF7odhAxa0RbSoKWumi4YqFarifrUOH+1LTXjBSKoRtJ+2F6DDugRaiQiHnD4ZwnH9bTRt3MFiyfYyw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744810602; c=relaxed/simple;
	bh=r61ie0NzkY2JLAeYqKSgg46Zr9E3KWBa5fQXwAdcaRs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=rJ2TuRftA0OPpipLkXAZQQ1sp/c7GK0oNw9/fRjisBm7erv9TOfFVOWpbsfkEZuCUrlzcK3XiVrweL4TjlPfBur3U/y90kQcP4WaHOBQouflYGj3SNOVq8mDxAxJnDC+ljZvI5odqnjNAF7EuU5U9JrCDlROiYp1BuMENw9RjBM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=pwLcJu+K; arc=none smtp.client-ip=91.218.175.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="pwLcJu+K"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1744810595;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=WdVKK0o/W2z+hBCSP2vmAdao9O+sQiBoc8jtGTFbYdY=;
	b=pwLcJu+KC15BhwtgVHDm8e2rXKTPh8+IrwVGWXigJ3kp3H4h5pn5BZoVAlIQvGl0Df4aPN
	InZnfb/Z3kJ9hEMWKT1dwjJKAJBTanL99O6jdW4OGMfTV1OCbh7jZB8VGOkrWRTqZaWnKM
	EYQVoQhH9YuggfKa6O4wd2H+hEo4Ni8=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH] bcachefs: Single device mode
Date: Wed, 16 Apr 2025 09:36:31 -0400
Message-ID: <20250416133631.3653533-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Single device filesystems are now identified by the block device name,
not the UUID - and single device filesystems with the same UUID can be
mounted simultaneously, without any special options.

This allocates a new bit in the superblock, BCH_SB_MULTI_DEVICE, which
indicates whether a filesystem has ever been multi device.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/bcachefs.h        |  1 +
 fs/bcachefs/bcachefs_format.h |  2 +-
 fs/bcachefs/debug.c           |  6 +++++-
 fs/bcachefs/errcode.h         |  1 +
 fs/bcachefs/fs.c              |  7 ++++++-
 fs/bcachefs/opts.h            |  4 ++--
 fs/bcachefs/super-io.c        |  4 ++++
 fs/bcachefs/super.c           | 30 ++++++++++++++++++++++++------
 8 files changed, 44 insertions(+), 11 deletions(-)

diff --git a/fs/bcachefs/bcachefs.h b/fs/bcachefs/bcachefs.h
index 8518dcd059a8..4e5cc127ea93 100644
--- a/fs/bcachefs/bcachefs.h
+++ b/fs/bcachefs/bcachefs.h
@@ -780,6 +780,7 @@ struct bch_fs {
 
 		u8		nr_devices;
 		u8		clean;
+		bool		multi_device; /* true if we've ever had more than one device */
 
 		u8		encryption_type;
 
diff --git a/fs/bcachefs/bcachefs_format.h b/fs/bcachefs/bcachefs_format.h
index 0f6e3a661e55..e6203665f230 100644
--- a/fs/bcachefs/bcachefs_format.h
+++ b/fs/bcachefs/bcachefs_format.h
@@ -842,7 +842,7 @@ LE64_BITMASK(BCH_SB_SHARD_INUMS,	struct bch_sb, flags[3], 28, 29);
 LE64_BITMASK(BCH_SB_INODES_USE_KEY_CACHE,struct bch_sb, flags[3], 29, 30);
 LE64_BITMASK(BCH_SB_JOURNAL_FLUSH_DELAY,struct bch_sb, flags[3], 30, 62);
 LE64_BITMASK(BCH_SB_JOURNAL_FLUSH_DISABLED,struct bch_sb, flags[3], 62, 63);
-/* one free bit */
+LE64_BITMASK(BCH_SB_MULTI_DEVICE,	struct bch_sb,	flags[3], 63, 64);
 LE64_BITMASK(BCH_SB_JOURNAL_RECLAIM_DELAY,struct bch_sb, flags[4], 0, 32);
 LE64_BITMASK(BCH_SB_JOURNAL_TRANSACTION_NAMES,struct bch_sb, flags[4], 32, 33);
 LE64_BITMASK(BCH_SB_NOCOW,		struct bch_sb, flags[4], 33, 34);
diff --git a/fs/bcachefs/debug.c b/fs/bcachefs/debug.c
index f4b7877c0843..8ad710bb5a43 100644
--- a/fs/bcachefs/debug.c
+++ b/fs/bcachefs/debug.c
@@ -933,7 +933,11 @@ void bch2_fs_debug_init(struct bch_fs *c)
 	if (IS_ERR_OR_NULL(bch_debug))
 		return;
 
-	snprintf(name, sizeof(name), "%pU", c->sb.user_uuid.b);
+	if (c->sb.multi_device)
+		snprintf(name, sizeof(name), "%pU", c->sb.user_uuid.b);
+	else
+		strscpy(name, c->name, sizeof(name));
+
 	c->fs_debug_dir = debugfs_create_dir(name, bch_debug);
 	if (IS_ERR_OR_NULL(c->fs_debug_dir))
 		return;
diff --git a/fs/bcachefs/errcode.h b/fs/bcachefs/errcode.h
index cf1083ce243e..4a040085454c 100644
--- a/fs/bcachefs/errcode.h
+++ b/fs/bcachefs/errcode.h
@@ -201,6 +201,7 @@
 	x(EINVAL,			device_has_been_removed)		\
 	x(EINVAL,			device_splitbrain)			\
 	x(EINVAL,			device_already_online)			\
+	x(EINVAL,			filesystem_uuid_already_open)		\
 	x(EINVAL,			insufficient_devices_to_start)		\
 	x(EINVAL,			invalid)				\
 	x(EINVAL,			internal_fsck_err)			\
diff --git a/fs/bcachefs/fs.c b/fs/bcachefs/fs.c
index 5a41b1a8e54f..5b2f87439b48 100644
--- a/fs/bcachefs/fs.c
+++ b/fs/bcachefs/fs.c
@@ -2220,7 +2220,12 @@ static int bch2_fs_get_tree(struct fs_context *fc)
 	sb->s_time_min		= div_s64(S64_MIN, c->sb.time_units_per_sec) + 1;
 	sb->s_time_max		= div_s64(S64_MAX, c->sb.time_units_per_sec);
 	super_set_uuid(sb, c->sb.user_uuid.b, sizeof(c->sb.user_uuid));
-	super_set_sysfs_name_uuid(sb);
+
+	if (c->sb.multi_device)
+		super_set_sysfs_name_uuid(sb);
+	else
+		strscpy(sb->s_sysfs_name, c->name, sizeof(sb->s_sysfs_name));
+
 	sb->s_shrink->seeks	= 0;
 	c->vfs_sb		= sb;
 	strscpy(sb->s_id, c->name, sizeof(sb->s_id));
diff --git a/fs/bcachefs/opts.h b/fs/bcachefs/opts.h
index bed0c8c7a853..4be0634eae80 100644
--- a/fs/bcachefs/opts.h
+++ b/fs/bcachefs/opts.h
@@ -513,7 +513,7 @@ enum fsck_err_opts {
 	  BCH_MEMBER_DATA_ALLOWED,	BIT(BCH_DATA_journal)|BIT(BCH_DATA_btree)|BIT(BCH_DATA_user),\
 	  "types",	"Allowed data types for this device: journal, btree, and/or user")\
 	x(discard,			u8,				\
-	  OPT_MOUNT|OPT_DEVICE|OPT_RUNTIME,				\
+	  OPT_MOUNT|OPT_FS|OPT_DEVICE|OPT_RUNTIME,			\
 	  OPT_BOOL(),							\
 	  BCH_MEMBER_DISCARD,		true,				\
 	  NULL,		"Enable discard/TRIM support")			\
@@ -521,7 +521,7 @@ enum fsck_err_opts {
 	  OPT_FS|OPT_MOUNT|OPT_RUNTIME,					\
 	  OPT_BOOL(),							\
 	  BCH2_NO_SB_OPT,		true,				\
-	  NULL,		"BTREE_ITER_prefetch casuse btree nodes to be\n"\
+	  NULL,		"BTREE_ITER_prefetch causes btree nodes to be\n"\
 	  " prefetched sequentially")
 
 struct bch_opts {
diff --git a/fs/bcachefs/super-io.c b/fs/bcachefs/super-io.c
index f5897f75489a..fa4d323ddada 100644
--- a/fs/bcachefs/super-io.c
+++ b/fs/bcachefs/super-io.c
@@ -468,6 +468,9 @@ int bch2_sb_validate(struct bch_sb *sb, u64 read_offset,
 			SET_BCH_SB_VERSION_INCOMPAT_ALLOWED(sb, BCH_SB_VERSION_INCOMPAT(sb));
 	}
 
+	if (sb->nr_devices > 1)
+		SET_BCH_SB_MULTI_DEVICE(sb, true);
+
 	if (!flags) {
 		/*
 		 * Been seeing a bug where these are getting inexplicably
@@ -612,6 +615,7 @@ static void bch2_sb_update(struct bch_fs *c)
 
 	c->sb.features		= le64_to_cpu(src->features[0]);
 	c->sb.compat		= le64_to_cpu(src->compat[0]);
+	c->sb.multi_device	= BCH_SB_MULTI_DEVICE(src);
 
 	memset(c->sb.errors_silent, 0, sizeof(c->sb.errors_silent));
 
diff --git a/fs/bcachefs/super.c b/fs/bcachefs/super.c
index 0c3f5d84d7a1..222b31f23799 100644
--- a/fs/bcachefs/super.c
+++ b/fs/bcachefs/super.c
@@ -709,9 +709,10 @@ static int bch2_fs_online(struct bch_fs *c)
 
 	lockdep_assert_held(&bch_fs_list_lock);
 
-	if (__bch2_uuid_to_fs(c->sb.uuid)) {
+	if (c->sb.multi_device &&
+	    __bch2_uuid_to_fs(c->sb.uuid)) {
 		bch_err(c, "filesystem UUID already open");
-		return -EINVAL;
+		return -BCH_ERR_filesystem_uuid_already_open;
 	}
 
 	ret = bch2_fs_chardev_init(c);
@@ -722,7 +723,9 @@ static int bch2_fs_online(struct bch_fs *c)
 
 	bch2_fs_debug_init(c);
 
-	ret = kobject_add(&c->kobj, NULL, "%pU", c->sb.user_uuid.b) ?:
+	ret = (c->sb.multi_device
+	       ? kobject_add(&c->kobj, NULL, "%pU", c->sb.user_uuid.b)
+	       : kobject_add(&c->kobj, NULL, "%s", c->name)) ?:
 	    kobject_add(&c->internal, &c->kobj, "internal") ?:
 	    kobject_add(&c->opts_dir, &c->kobj, "options") ?:
 #ifndef CONFIG_BCACHEFS_NO_LATENCY_ACCT
@@ -931,7 +934,7 @@ static struct bch_fs *bch2_fs_alloc(struct bch_sb *sb, struct bch_opts opts,
 		goto err;
 	}
 
-	if (sbs->nr != 1)
+	if (c->sb.multi_device)
 		pr_uuid(&name, c->sb.user_uuid.b);
 	else
 		prt_bdevname(&name, sbs->data[0].bdev);
@@ -1798,11 +1801,11 @@ int bch2_dev_remove(struct bch_fs *c, struct bch_dev *ca, int flags)
 int bch2_dev_add(struct bch_fs *c, const char *path)
 {
 	struct bch_opts opts = bch2_opts_empty();
-	struct bch_sb_handle sb;
+	struct bch_sb_handle sb = {};
 	struct bch_dev *ca = NULL;
 	struct printbuf errbuf = PRINTBUF;
 	struct printbuf label = PRINTBUF;
-	int ret;
+	int ret = 0;
 
 	ret = bch2_read_super(path, &opts, &sb);
 	bch_err_msg(c, ret, "reading super");
@@ -1819,6 +1822,20 @@ int bch2_dev_add(struct bch_fs *c, const char *path)
 		}
 	}
 
+	if (list_empty(&c->list)) {
+		mutex_lock(&bch_fs_list_lock);
+		if (__bch2_uuid_to_fs(c->sb.uuid))
+			ret = -BCH_ERR_filesystem_uuid_already_open;
+		else
+			list_add(&c->list, &bch_fs_list);
+		mutex_unlock(&bch_fs_list_lock);
+
+		if (ret) {
+			bch_err(c, "filesystem UUID already open");
+			goto err;
+		}
+	}
+
 	ret = bch2_dev_may_add(sb.sb, c);
 	if (ret)
 		goto err;
@@ -1835,6 +1852,7 @@ int bch2_dev_add(struct bch_fs *c, const char *path)
 
 	down_write(&c->state_lock);
 	mutex_lock(&c->sb_lock);
+	SET_BCH_SB_MULTI_DEVICE(c->disk_sb.sb, true);
 
 	ret = bch2_sb_from_fs(c, ca);
 	bch_err_msg(c, ret, "setting up new superblock");
-- 
2.49.0


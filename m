Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF78E21B183
	for <linux-bcachefs@vger.kernel.org>; Fri,  7 Mar 2025 13:49:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741355389; cv=none; b=fQGHEC9YlMiJbAg7fANVzWS563jn/Uh8xjpEXmU5p2DOPyUC65IwfJtpZ6zLvl+lwRqU/7v4OrFFsDbPpF3aFhBVt7z9RpGjcAjgmlcGBUv0XGzLlPRElYvu4gStj78ayLTGDGLGaRsLlmykUlGH8r8OszVftMmGUYNfOrqfhlM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741355389; c=relaxed/simple;
	bh=UwCAiAJk8a0FhYx5e7ekQxVFl3kVmc4cgPx9AGzJKPE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zmp6dxUmdbEn7ot3zttnyCok+Df+C3X+s5vZb9MEM0pX47Q9KkXChH/H90CPRdpkYxlUHTWV/T/ohAauBFxGX3NpgbK2AjyffSVZtO8785LJy+NwQTfr+XeBN/15MDvqukC7u0g4VSwt+fyIqS+atWP66+Z+f3rTA/JKuiWnMLo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=PX/DvRpY; arc=none smtp.client-ip=95.215.58.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="PX/DvRpY"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1741355385;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Z6jW7sIZDKGN//InFjXTx2v/9Ue/mZirsyApk04RQs8=;
	b=PX/DvRpYUiIzeQ+62kUuMgo3uryTn27izG4CBJg32R6KOXH+L60uXLejbov46XD+buMob3
	s1HvlAPndIUZSF/0+4J8Sm15MrTnlLGlaJlFZC+cjLXtOjpe96nav0FI75MtnIKgekeZlQ
	9CbXShlQft08UM3/XhUvuHNzXcTNAEU=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 7/7] bcachefs: Implement freeze/thaw
Date: Fri,  7 Mar 2025 08:49:31 -0500
Message-ID: <20250307134933.1033872-8-kent.overstreet@linux.dev>
In-Reply-To: <20250307134933.1033872-1-kent.overstreet@linux.dev>
References: <20250307134933.1033872-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

This fills out our blk_holders_ops with freeze and thaw callbacks, for
shutting down IO (generally during a system suspend).

This is implemented completely differently as on other filesystems
since we have a low level synchronization object which conveniently
works well for us - bch_dev.io_ref, normally used for guarding against a
device being offlined while in use.

bch2_dev_get_ioref() now checks if a freeze is in progress if it fails
to get ca->io_ref, and sleeps until complete and ca->io_ref is alive.

We also need a bit of synchronization for freeze/suspend vs. device
online/offline, done with the new bch_dev.io_ref_statechange_lock.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/bcachefs.h   |  3 ++
 fs/bcachefs/journal_io.c |  2 +-
 fs/bcachefs/sb-members.c | 49 ++++++++++++++++++++++
 fs/bcachefs/sb-members.h | 20 +--------
 fs/bcachefs/super.c      | 87 +++++++++++++++++++++++++++++++++++++---
 5 files changed, 136 insertions(+), 25 deletions(-)

diff --git a/fs/bcachefs/bcachefs.h b/fs/bcachefs/bcachefs.h
index d2c3f59a668f..d03aa62907ad 100644
--- a/fs/bcachefs/bcachefs.h
+++ b/fs/bcachefs/bcachefs.h
@@ -526,6 +526,9 @@ struct bch_dev {
 	struct completion	ref_completion;
 	struct percpu_ref	io_ref;
 	struct completion	io_ref_completion;
+	struct mutex		io_ref_statechange_lock;
+	unsigned		frozen;
+	wait_queue_head_t	frozen_wait;
 
 	struct bch_fs		*fs;
 
diff --git a/fs/bcachefs/journal_io.c b/fs/bcachefs/journal_io.c
index a510755a8364..6979fef5c128 100644
--- a/fs/bcachefs/journal_io.c
+++ b/fs/bcachefs/journal_io.c
@@ -1769,7 +1769,7 @@ static CLOSURE_CALLBACK(journal_write_submit)
 		struct bch_dev *ca = bch2_dev_get_ioref(c, ptr->dev, WRITE);
 		if (!ca) {
 			/* XXX: fix this */
-			bch_err(c, "missing device for journal write\n");
+			bch_err(c, "missing device for journal write");
 			continue;
 		}
 
diff --git a/fs/bcachefs/sb-members.c b/fs/bcachefs/sb-members.c
index 116131f95815..2363367cb32d 100644
--- a/fs/bcachefs/sb-members.c
+++ b/fs/bcachefs/sb-members.c
@@ -9,6 +9,55 @@
 #include "sb-members.h"
 #include "super-io.h"
 
+/*
+ * Use of bch2_dev_get_ioref() is subject to deadlocks if used incorrectly, and
+ * we cannot write asserts for correct usage, so: pay attention, because this is
+ * where we implement freeze.
+ *
+ * Waiting on an outstanding freeze to complete will indirectly wait on all
+ * other outstanding io_refs to be released. That means:
+ *
+ * - Don't use bch2_dev_get_ioref() if you already have an io_ref, use
+ *   percpu_ref_get(). Since dev_get_ioref() has tryget() semantics, that's what
+ *   you should be doing anyways.
+ *
+ * - All io_refs must be released without blocking on locks that might be held
+ *   while calling dev_get_ioref(). This is easy to obey since we generally
+ *   release io_refs from endio functions.
+ *
+ */
+struct bch_dev *bch2_dev_get_ioref(struct bch_fs *c, unsigned dev, int rw)
+{
+	might_sleep();
+again:
+	rcu_read_lock();
+	struct bch_dev *ca = bch2_dev_rcu(c, dev);
+	if (likely(ca)) {
+		if (unlikely(!percpu_ref_tryget(&ca->io_ref))) {
+			smp_mb();
+			if (ca->frozen) {
+				bch2_dev_get(ca);
+				rcu_read_unlock();
+
+				wait_event(ca->frozen_wait, !ca->frozen);
+				bch2_dev_put(ca);
+				goto again;
+			}
+			ca = NULL;
+		}
+	}
+	rcu_read_unlock();
+
+	if (ca &&
+	    (ca->mi.state == BCH_MEMBER_STATE_rw ||
+	    (ca->mi.state == BCH_MEMBER_STATE_ro && rw == READ)))
+		return ca;
+
+	if (ca)
+		percpu_ref_put(&ca->io_ref);
+	return NULL;
+}
+
 void bch2_dev_missing(struct bch_fs *c, unsigned dev)
 {
 	if (dev != BCH_SB_MEMBER_INVALID)
diff --git a/fs/bcachefs/sb-members.h b/fs/bcachefs/sb-members.h
index df91b02ce575..b3359ee63b0e 100644
--- a/fs/bcachefs/sb-members.h
+++ b/fs/bcachefs/sb-members.h
@@ -281,25 +281,7 @@ static inline struct bch_dev *bch2_dev_iterate(struct bch_fs *c, struct bch_dev
 	return bch2_dev_tryget(c, dev_idx);
 }
 
-static inline struct bch_dev *bch2_dev_get_ioref(struct bch_fs *c, unsigned dev, int rw)
-{
-	might_sleep();
-
-	rcu_read_lock();
-	struct bch_dev *ca = bch2_dev_rcu(c, dev);
-	if (ca && !percpu_ref_tryget(&ca->io_ref))
-		ca = NULL;
-	rcu_read_unlock();
-
-	if (ca &&
-	    (ca->mi.state == BCH_MEMBER_STATE_rw ||
-	    (ca->mi.state == BCH_MEMBER_STATE_ro && rw == READ)))
-		return ca;
-
-	if (ca)
-		percpu_ref_put(&ca->io_ref);
-	return NULL;
-}
+struct bch_dev *bch2_dev_get_ioref(struct bch_fs *, unsigned, int);
 
 /* XXX kill, move to struct bch_fs */
 static inline struct bch_devs_mask bch2_online_devs(struct bch_fs *c)
diff --git a/fs/bcachefs/super.c b/fs/bcachefs/super.c
index 05a2dc5ef513..dfdeab7d847c 100644
--- a/fs/bcachefs/super.c
+++ b/fs/bcachefs/super.c
@@ -1236,6 +1236,22 @@ static void bch2_dev_free(struct bch_dev *ca)
 	kobject_put(&ca->kobj);
 }
 
+static void bch2_dev_io_ref_stop(struct bch_dev *ca)
+{
+	lockdep_assert_held(&ca->io_ref_statechange_lock);
+
+	reinit_completion(&ca->io_ref_completion);
+	percpu_ref_kill(&ca->io_ref);
+	wait_for_completion(&ca->io_ref_completion);
+}
+
+static void bch2_dev_io_ref_start(struct bch_dev *ca)
+{
+	lockdep_assert_held(&ca->io_ref_statechange_lock);
+
+	percpu_ref_reinit(&ca->io_ref);
+}
+
 static void __bch2_dev_offline(struct bch_fs *c, struct bch_dev *ca)
 {
 
@@ -1246,13 +1262,14 @@ static void __bch2_dev_offline(struct bch_fs *c, struct bch_dev *ca)
 
 	__bch2_dev_read_only(c, ca);
 
-	reinit_completion(&ca->io_ref_completion);
-	percpu_ref_kill(&ca->io_ref);
-	wait_for_completion(&ca->io_ref_completion);
-
 	bch2_dev_unlink(ca);
 
+	mutex_lock(&ca->io_ref_statechange_lock);
+	bch2_dev_io_ref_stop(ca);
+
 	bch2_free_super(&ca->disk_sb);
+	mutex_unlock(&ca->io_ref_statechange_lock);
+
 	bch2_dev_journal_exit(ca);
 }
 
@@ -1334,6 +1351,8 @@ static struct bch_dev *__bch2_dev_alloc(struct bch_fs *c,
 	kobject_init(&ca->kobj, &bch2_dev_ktype);
 	init_completion(&ca->ref_completion);
 	init_completion(&ca->io_ref_completion);
+	mutex_init(&ca->io_ref_statechange_lock);
+	init_waitqueue_head(&ca->frozen_wait);
 
 	INIT_WORK(&ca->io_error_work, bch2_io_error_work);
 
@@ -1428,6 +1447,8 @@ static int __bch2_dev_attach_bdev(struct bch_dev *ca, struct bch_sb_handle *sb)
 	if (ret)
 		return ret;
 
+	mutex_lock(&ca->io_ref_statechange_lock);
+
 	/* Commit: */
 	ca->disk_sb = *sb;
 	memset(sb, 0, sizeof(*sb));
@@ -1441,7 +1462,9 @@ static int __bch2_dev_attach_bdev(struct bch_dev *ca, struct bch_sb_handle *sb)
 
 	ca->dev = ca->disk_sb.bdev->bd_dev;
 
-	percpu_ref_reinit(&ca->io_ref);
+	if (!ca->frozen)
+		bch2_dev_io_ref_start(ca);
+	mutex_unlock(&ca->io_ref_statechange_lock);
 
 	return 0;
 }
@@ -2115,9 +2138,63 @@ static void bch2_fs_bdev_sync(struct block_device *bdev)
 	bch2_ro_ref_put(c);
 }
 
+static int bch2_fs_bdev_freeze(struct block_device *bdev)
+{
+	int ret = -EINVAL;
+	struct bch_fs *c = bdev_get_fs(bdev);
+	if (!c)
+		return ret;
+
+	struct bch_dev *ca = bdev_to_bch_dev(c, bdev);
+	if (!ca)
+		goto err;
+
+	mutex_lock(&ca->io_ref_statechange_lock);
+	ca->frozen++;
+	smp_mb();
+	bch2_dev_io_ref_stop(ca);
+	mutex_unlock(&ca->io_ref_statechange_lock);
+
+	ret = sync_blockdev(bdev);
+
+	bch2_dev_put(ca);
+err:
+	bch2_ro_ref_put(c);
+	return ret;
+}
+
+static int bch2_fs_bdev_thaw(struct block_device *bdev)
+{
+	int ret = -EINVAL;
+	struct bch_fs *c = bdev_get_fs(bdev);
+	if (!c)
+		return ret;
+
+	struct bch_dev *ca = bdev_to_bch_dev(c, bdev);
+	if (!ca)
+		goto err;
+
+	mutex_lock(&ca->io_ref_statechange_lock);
+	if (ca->disk_sb.bdev &&
+	    ca->frozen == 1)
+		bch2_dev_io_ref_start(ca);
+	--ca->frozen;
+	wake_up(&ca->frozen_wait);
+	mutex_unlock(&ca->io_ref_statechange_lock);
+
+	ret = 0;
+
+	bch2_dev_put(ca);
+err:
+	bch2_ro_ref_put(c);
+	return ret;
+}
+
 const struct blk_holder_ops bch2_sb_handle_bdev_ops = {
 	.mark_dead		= bch2_fs_bdev_mark_dead,
 	.sync			= bch2_fs_bdev_sync,
+	.freeze			= bch2_fs_bdev_freeze,
+	.thaw			= bch2_fs_bdev_thaw,
 };
 
 /* Filesystem open: */
-- 
2.47.2


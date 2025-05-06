Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F9CC30C922
	for <linux-bcachefs@vger.kernel.org>; Tue,  6 May 2025 02:36:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746498983; cv=none; b=CIVlmuIcKsSf/Nw1MsDqIIEo4GeeXI/ZUKEYkvMB7K4zazspEu11MO8B+Gz+AnYjLaATvzwvrGEE9zDcQZXowjem9YpxmdFbeX9cqOtBb3KsB3w2Ouo7b84SMpmRW2wilcO+YmJLYsKX0EuvOR8ZUkyxsmKvyn1rRJNoLXw9wOU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746498983; c=relaxed/simple;
	bh=tCi+OfHwlBOfMaNXGxckbaez1eMEyxPYBK7MlqauRuY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=C1c7KGTiSRr0rfebcgdIaPoDhisk4/f2UEUv21TjZ0x4e8CXAzZlYOsQ9URaGS3gCVjojMU0xN++pWWrzkDhfnXcwA4rcp6qyew1a7sfIDjtd1gTaBBR+qq3qSWM5j/3acZXPxeSRqloH8PBv9gTHZYoGPDPBioUKVEQrEWlVG0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=X8nexD8U; arc=none smtp.client-ip=91.218.175.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="X8nexD8U"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1746498974;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=PFIiin1hMaBGIL4UFg7D+vMMQ6i7PTD1D6IG3u5VG8w=;
	b=X8nexD8Uq8nmEs6q7WG1Bkfnf/aFux+f/nn5qjKPzrF1HWnCMWwz51woLXaUwEo93LcEb1
	DO8QL4oqSlmr3IirCkdXXYiLgxSshBnoggae5z8ARrJTBCls9YtvQz1yuLDGGlH37Ae/mZ
	rXi4mjCrI/xhoyWxtmtyzdOvggpT1K4=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH] bcachefs: opts.rebalance_on_ac_only
Date: Mon,  5 May 2025 22:36:09 -0400
Message-ID: <20250506023609.2587987-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Add an option for setting rebalance to only run when connected to mains
power.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/bcachefs_format.h |  1 +
 fs/bcachefs/opts.h            |  5 ++++
 fs/bcachefs/rebalance.c       | 48 ++++++++++++++++++++++++++++++++---
 fs/bcachefs/rebalance.h       |  4 ++-
 fs/bcachefs/rebalance_types.h |  3 +++
 fs/bcachefs/super.c           |  3 ++-
 6 files changed, 58 insertions(+), 6 deletions(-)

diff --git a/fs/bcachefs/bcachefs_format.h b/fs/bcachefs/bcachefs_format.h
index baaf9786238b..a483d440fa39 100644
--- a/fs/bcachefs/bcachefs_format.h
+++ b/fs/bcachefs/bcachefs_format.h
@@ -871,6 +871,7 @@ LE64_BITMASK(BCH_SB_WRITE_ERROR_TIMEOUT,struct bch_sb, flags[6],  4, 14);
 LE64_BITMASK(BCH_SB_CSUM_ERR_RETRY_NR,	struct bch_sb, flags[6], 14, 20);
 LE64_BITMASK(BCH_SB_DEGRADED_ACTION,	struct bch_sb, flags[6], 20, 22);
 LE64_BITMASK(BCH_SB_CASEFOLD,		struct bch_sb, flags[6], 22, 23);
+LE64_BITMASK(BCH_SB_REBALANCE_AC_ONLY,	struct bch_sb, flags[6], 23, 24);
 
 static inline __u64 BCH_SB_COMPRESSION_TYPE(const struct bch_sb *sb)
 {
diff --git a/fs/bcachefs/opts.h b/fs/bcachefs/opts.h
index b8cd0b04e62a..f4c014ad43c1 100644
--- a/fs/bcachefs/opts.h
+++ b/fs/bcachefs/opts.h
@@ -490,6 +490,11 @@ enum fsck_err_opts {
 	  BCH2_NO_SB_OPT,			true,			\
 	  NULL,		"Enable rebalance: disable for debugging, or to\n"\
 			"quiet the system when doing performance testing\n")\
+	x(rebalance_on_ac_only,		u8,				\
+	  OPT_FS|OPT_MOUNT|OPT_RUNTIME,					\
+	  OPT_BOOL(),							\
+	  BCH_SB_REBALANCE_AC_ONLY,		false,			\
+	  NULL,		"Enable rebalance while on mains power only\n")	\
 	x(no_data_io,			u8,				\
 	  OPT_MOUNT,							\
 	  OPT_BOOL(),							\
diff --git a/fs/bcachefs/rebalance.c b/fs/bcachefs/rebalance.c
index a94f66ff4c59..0546ed35666d 100644
--- a/fs/bcachefs/rebalance.c
+++ b/fs/bcachefs/rebalance.c
@@ -518,6 +518,13 @@ static void rebalance_wait(struct bch_fs *c)
 	bch2_kthread_io_clock_wait(clock, r->wait_iotime_end, MAX_SCHEDULE_TIMEOUT);
 }
 
+static bool bch2_rebalance_enabled(struct bch_fs *c)
+{
+	return c->opts.rebalance_enabled &&
+		!(c->opts.rebalance_on_ac_only &&
+		  c->rebalance.on_battery);
+}
+
 static int do_rebalance(struct moving_context *ctxt)
 {
 	struct btree_trans *trans = ctxt->trans;
@@ -537,9 +544,9 @@ static int do_rebalance(struct moving_context *ctxt)
 			     BTREE_ITER_all_snapshots);
 
 	while (!bch2_move_ratelimit(ctxt)) {
-		if (!c->opts.rebalance_enabled) {
+		if (!bch2_rebalance_enabled(c)) {
 			bch2_moving_ctxt_flush_all(ctxt);
-			kthread_wait_freezable(c->opts.rebalance_enabled ||
+			kthread_wait_freezable(bch2_rebalance_enabled(c) ||
 					       kthread_should_stop());
 		}
 
@@ -714,9 +721,42 @@ int bch2_rebalance_start(struct bch_fs *c)
 	return 0;
 }
 
-void bch2_fs_rebalance_init(struct bch_fs *c)
+#ifdef CONFIG_POWER_SUPPLY
+#include <linux/power_supply.h>
+
+static int bch2_rebalance_power_notifier(struct notifier_block *nb,
+					 unsigned long event, void *data)
+{
+	struct bch_fs *c = container_of(nb, struct bch_fs, rebalance.power_notifier);
+
+	c->rebalance.on_battery = !power_supply_is_system_supplied();
+	bch2_rebalance_wakeup(c);
+	return NOTIFY_OK;
+}
+#endif
+
+void bch2_fs_rebalance_exit(struct bch_fs *c)
 {
-	bch2_pd_controller_init(&c->rebalance.pd);
+#ifdef CONFIG_POWER_SUPPLY
+	power_supply_unreg_notifier(&c->rebalance.power_notifier);
+#endif
+}
+
+int bch2_fs_rebalance_init(struct bch_fs *c)
+{
+	struct bch_fs_rebalance *r = &c->rebalance;
+
+	bch2_pd_controller_init(&r->pd);
+
+#ifdef CONFIG_POWER_SUPPLY
+	r->power_notifier.notifier_call = bch2_rebalance_power_notifier;
+	int ret = power_supply_reg_notifier(&r->power_notifier);
+	if (ret)
+		return ret;
+
+	r->on_battery = !power_supply_is_system_supplied();
+#endif
+	return 0;
 }
 
 static int check_rebalance_work_one(struct btree_trans *trans,
diff --git a/fs/bcachefs/rebalance.h b/fs/bcachefs/rebalance.h
index b7c8c0652ad6..5d9214fe1a22 100644
--- a/fs/bcachefs/rebalance.h
+++ b/fs/bcachefs/rebalance.h
@@ -52,7 +52,9 @@ void bch2_rebalance_status_to_text(struct printbuf *, struct bch_fs *);
 
 void bch2_rebalance_stop(struct bch_fs *);
 int bch2_rebalance_start(struct bch_fs *);
-void bch2_fs_rebalance_init(struct bch_fs *);
+
+void bch2_fs_rebalance_exit(struct bch_fs *);
+int bch2_fs_rebalance_init(struct bch_fs *);
 
 int bch2_check_rebalance_work(struct bch_fs *);
 
diff --git a/fs/bcachefs/rebalance_types.h b/fs/bcachefs/rebalance_types.h
index fe5098c17dfc..76187c6572ea 100644
--- a/fs/bcachefs/rebalance_types.h
+++ b/fs/bcachefs/rebalance_types.h
@@ -30,6 +30,9 @@ struct bch_fs_rebalance {
 	struct bbpos			scan_start;
 	struct bbpos			scan_end;
 	struct bch_move_stats		scan_stats;
+
+	bool				on_battery;
+	struct notifier_block		power_notifier;
 };
 
 #endif /* _BCACHEFS_REBALANCE_TYPES_H */
diff --git a/fs/bcachefs/super.c b/fs/bcachefs/super.c
index a33872d0172c..c6c63ae0ae97 100644
--- a/fs/bcachefs/super.c
+++ b/fs/bcachefs/super.c
@@ -578,6 +578,7 @@ static void __bch2_fs_free(struct bch_fs *c)
 	bch2_fs_snapshots_exit(c);
 	bch2_fs_sb_errors_exit(c);
 	bch2_fs_replicas_exit(c);
+	bch2_fs_rebalance_exit(c);
 	bch2_fs_quota_exit(c);
 	bch2_fs_nocow_locking_exit(c);
 	bch2_fs_journal_exit(&c->journal);
@@ -862,7 +863,6 @@ static struct bch_fs *bch2_fs_alloc(struct bch_sb *sb, struct bch_opts *opts,
 	bch2_fs_move_init(c);
 	bch2_fs_nocow_locking_init_early(c);
 	bch2_fs_quota_init(c);
-	bch2_fs_rebalance_init(c);
 	bch2_fs_sb_errors_init_early(c);
 	bch2_fs_snapshots_init_early(c);
 	bch2_fs_subvolumes_init_early(c);
@@ -984,6 +984,7 @@ static struct bch_fs *bch2_fs_alloc(struct bch_sb *sb, struct bch_opts *opts,
 	    bch2_fs_fsio_init(c) ?:
 	    bch2_fs_fs_io_direct_init(c) ?:
 	    bch2_fs_io_read_init(c) ?:
+	    bch2_fs_rebalance_init(c) ?:
 	    bch2_fs_sb_errors_init(c) ?:
 	    bch2_fs_vfs_init(c);
 	if (ret)
-- 
2.49.0


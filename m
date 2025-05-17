Received: from out-178.mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCB07212FB8
	for <linux-bcachefs@vger.kernel.org>; Sat, 17 May 2025 19:25:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747509960; cv=none; b=KoRRE20cCR96ywSEZKuKC1j0wCFJ1xHpn4NjR1jNWyjPAF7B333AwOdb7yuuD8KVYNlklMj31kWaUIkYbXpP1BKKATAjVhNIIKCDPDjSX/VIxT2XLkDtKn9MZ9fKPHeKEfW7J1q1xUAplUffS0ODo/s1DpDmbbUnVCIMp5Y+PzI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747509960; c=relaxed/simple;
	bh=WWLNzV9bxvYc1OEjCuO+CgePp404M87TqTNtd6ZbTbM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dsF/j21omYCHbH1bdHgDNuKq9QexoR1BLGB7yqn7CXU9bm/r4eF1qwJCqK/kfCSYdpa2gGtuHAXyaVOOimVnQNdG49+OmN9M3WU77YZXUJHljkmTM6UgquOH6wyroJN8OY0f2aLIQsIZAzvkTmKKojVWdin3OojSOfDItWcW6lc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=PG3PnbJ9; arc=none smtp.client-ip=95.215.58.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="PG3PnbJ9"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1747509957;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GhQeS5NFw5MiwpZqMI4DJsIdsiEVs3fX3pswm41NIGw=;
	b=PG3PnbJ9UxaHIejM5f8sdNeA5ydp3GWFLfZhXZ3+GCHVT7dUDm/KpA8cXC0+fS3frbkyj2
	QL/uWgrzIXen7fU4mWipF10csi3THXyfoplofdPJW50nsXb4JKrd5rmrWT+PPQYxMGquiy
	Eg1Hcu+dpAjO4bsoyT3UwnFKJbY4LjY=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 4/8] bcachefs: bch2_recovery_pass_status_to_text()
Date: Sat, 17 May 2025 15:25:41 -0400
Message-ID: <20250517192547.3849149-5-kent.overstreet@linux.dev>
In-Reply-To: <20250517192547.3849149-1-kent.overstreet@linux.dev>
References: <20250517192547.3849149-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Show recovery pass status in sysfs - important now that we're running
them automatically in the background.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/recovery_passes.c | 24 ++++++++++++++++++++++++
 fs/bcachefs/recovery_passes.h |  2 ++
 fs/bcachefs/sysfs.c           |  6 ++++++
 3 files changed, 32 insertions(+)

diff --git a/fs/bcachefs/recovery_passes.c b/fs/bcachefs/recovery_passes.c
index e0e261aa752e..02639b3d86b0 100644
--- a/fs/bcachefs/recovery_passes.c
+++ b/fs/bcachefs/recovery_passes.c
@@ -444,6 +444,30 @@ int bch2_run_recovery_passes(struct bch_fs *c, enum bch_recovery_pass from)
 	return ret;
 }
 
+static void prt_passes(struct printbuf *out, const char *msg, u64 passes)
+{
+	prt_printf(out, "%s:\t", msg);
+	prt_bitflags(out, bch2_recovery_passes, passes);
+	prt_newline(out);
+}
+
+void bch2_recovery_pass_status_to_text(struct printbuf *out, struct bch_fs *c)
+{
+	struct bch_fs_recovery *r = &c->recovery;
+
+	printbuf_tabstop_push(out, 32);
+	prt_passes(out, "Scheduled passes", c->sb.recovery_passes_required);
+	prt_passes(out, "Scheduled online passes", c->sb.recovery_passes_required &
+		   bch2_recovery_passes_match(PASS_ONLINE));
+	prt_passes(out, "Complete passes", r->passes_complete);
+	prt_passes(out, "Failing passes", r->passes_failing);
+
+	if (r->curr_pass) {
+		prt_printf(out, "Current pass:\t%s\n", bch2_recovery_passes[r->curr_pass]);
+		prt_passes(out, "Current passes", r->passes_to_run);
+	}
+}
+
 void bch2_fs_recovery_passes_init(struct bch_fs *c)
 {
 	spin_lock_init(&c->recovery.lock);
diff --git a/fs/bcachefs/recovery_passes.h b/fs/bcachefs/recovery_passes.h
index 0e79cc33fd8f..8c90e29cd6cb 100644
--- a/fs/bcachefs/recovery_passes.h
+++ b/fs/bcachefs/recovery_passes.h
@@ -20,6 +20,8 @@ int bch2_run_explicit_recovery_pass_persistent(struct bch_fs *, struct printbuf
 int bch2_run_online_recovery_passes(struct bch_fs *, u64);
 int bch2_run_recovery_passes(struct bch_fs *, enum bch_recovery_pass);
 
+void bch2_recovery_pass_status_to_text(struct printbuf *, struct bch_fs *);
+
 void bch2_fs_recovery_passes_init(struct bch_fs *);
 
 #endif /* _BCACHEFS_RECOVERY_PASSES_H */
diff --git a/fs/bcachefs/sysfs.c b/fs/bcachefs/sysfs.c
index 907d4246b8ef..0101eb025117 100644
--- a/fs/bcachefs/sysfs.c
+++ b/fs/bcachefs/sysfs.c
@@ -35,6 +35,7 @@
 #include "nocow_locking.h"
 #include "opts.h"
 #include "rebalance.h"
+#include "recovery_passes.h"
 #include "replicas.h"
 #include "super-io.h"
 #include "tests.h"
@@ -202,6 +203,7 @@ read_attribute(copy_gc_wait);
 sysfs_pd_controller_attribute(rebalance);
 read_attribute(rebalance_status);
 read_attribute(snapshot_delete_status);
+read_attribute(recovery_status);
 
 read_attribute(new_stripes);
 
@@ -437,6 +439,9 @@ SHOW(bch2_fs)
 	if (attr == &sysfs_snapshot_delete_status)
 		bch2_snapshot_delete_status_to_text(out, c);
 
+	if (attr == &sysfs_recovery_status)
+		bch2_recovery_pass_status_to_text(out, c);
+
 	/* Debugging: */
 
 	if (attr == &sysfs_journal_debug)
@@ -587,6 +592,7 @@ struct attribute *bch2_fs_files[] = {
 
 	&sysfs_rebalance_status,
 	&sysfs_snapshot_delete_status,
+	&sysfs_recovery_status,
 
 	&sysfs_compression_stats,
 
-- 
2.49.0


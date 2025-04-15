Received: from out-173.mta1.migadu.com (out-173.mta1.migadu.com [95.215.58.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B611198E9B
	for <linux-bcachefs@vger.kernel.org>; Tue, 15 Apr 2025 14:29:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744727371; cv=none; b=dI7c7nPc59JcjUoR7G4/+avDYmZaBjrZnlVFbhnkhCbH5AvXMaAG5vyIGL/jFAINcOm8MkVMj9ckW97OLiVHAiL6fVG3gbIglxrZgaX1lqx884wDjci/Q35tfdBZpTSTsNpzQl+7m6BIClp5b1y6sqJKNBo9emxUStHONJ/bpis=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744727371; c=relaxed/simple;
	bh=9+iXDBGx7GJVgsGCBR75V7HfOan8iM20BYMf5iIMEzI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ErSgIHZyp266Y87qxRxu73Dl2IGFH9k/W9MsCibqH3LGkFPvbg+L9vxbx9i95jsda6f95PX9EKIB0vUmmLPHoJUypbdPJmr7EC9Uw6ayF/cAL5XdOgIhvuVuBXFtacXWQXQ6Vsk6hpaICJV2i5kcnLd7aN8gi6YR/ldyzA9E0z8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=I+ohC5XB; arc=none smtp.client-ip=95.215.58.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="I+ohC5XB"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1744727366;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=29T8T+1np74bitsFgarWOMcK+5j4YVOYrK3TvqWPsT0=;
	b=I+ohC5XBcyzwwcwpA8pz3bYGdAVneQdUaIexoyDUxLJugZZoO9lwNJIlWs1z4azS1DQHRb
	ENjwVRbpDbVBpNRniWYjlR00tjEvfAgFjoVyDW5jfC4+KyXgpTQuC4KBegK/6i/ONZwzQp
	LUcN799PwTIuhjBcEoO8hFiyo+bB0c8=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 1/3] bcachefs: bch2_copygc_wakeup()
Date: Tue, 15 Apr 2025 10:29:19 -0400
Message-ID: <20250415142921.2624601-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/movinggc.h  | 9 +++++++++
 fs/bcachefs/rebalance.c | 4 ++--
 fs/bcachefs/rebalance.h | 2 +-
 fs/bcachefs/super.c     | 4 ++--
 fs/bcachefs/sysfs.c     | 7 +++----
 5 files changed, 17 insertions(+), 9 deletions(-)

diff --git a/fs/bcachefs/movinggc.h b/fs/bcachefs/movinggc.h
index ea181fef5bc9..d1885cf67a45 100644
--- a/fs/bcachefs/movinggc.h
+++ b/fs/bcachefs/movinggc.h
@@ -5,6 +5,15 @@
 unsigned long bch2_copygc_wait_amount(struct bch_fs *);
 void bch2_copygc_wait_to_text(struct printbuf *, struct bch_fs *);
 
+static inline void bch2_copygc_wakeup(struct bch_fs *c)
+{
+	rcu_read_lock();
+	struct task_struct *p = rcu_dereference(c->copygc_thread);
+	if (p)
+		wake_up_process(p);
+	rcu_read_unlock();
+}
+
 void bch2_copygc_stop(struct bch_fs *);
 int bch2_copygc_start(struct bch_fs *);
 void bch2_fs_copygc_init(struct bch_fs *);
diff --git a/fs/bcachefs/rebalance.c b/fs/bcachefs/rebalance.c
index 63f013496687..d63de50f6323 100644
--- a/fs/bcachefs/rebalance.c
+++ b/fs/bcachefs/rebalance.c
@@ -268,7 +268,7 @@ int bch2_set_rebalance_needs_scan(struct bch_fs *c, u64 inum)
 	int ret = bch2_trans_commit_do(c, NULL, NULL,
 				       BCH_TRANS_COMMIT_no_enospc,
 			    bch2_set_rebalance_needs_scan_trans(trans, inum));
-	rebalance_wakeup(c);
+	bch2_rebalance_wakeup(c);
 	return ret;
 }
 
@@ -670,7 +670,7 @@ void bch2_rebalance_stop(struct bch_fs *c)
 	c->rebalance.thread = NULL;
 
 	if (p) {
-		/* for sychronizing with rebalance_wakeup() */
+		/* for sychronizing with bch2_rebalance_wakeup() */
 		synchronize_rcu();
 
 		kthread_stop(p);
diff --git a/fs/bcachefs/rebalance.h b/fs/bcachefs/rebalance.h
index 62a3859d3823..e5e8eb4a2dd1 100644
--- a/fs/bcachefs/rebalance.h
+++ b/fs/bcachefs/rebalance.h
@@ -37,7 +37,7 @@ int bch2_set_rebalance_needs_scan_trans(struct btree_trans *, u64);
 int bch2_set_rebalance_needs_scan(struct bch_fs *, u64 inum);
 int bch2_set_fs_needs_rebalance(struct bch_fs *);
 
-static inline void rebalance_wakeup(struct bch_fs *c)
+static inline void bch2_rebalance_wakeup(struct bch_fs *c)
 {
 	struct task_struct *p;
 
diff --git a/fs/bcachefs/super.c b/fs/bcachefs/super.c
index 222b31f23799..72e001e4c151 100644
--- a/fs/bcachefs/super.c
+++ b/fs/bcachefs/super.c
@@ -1526,7 +1526,7 @@ static int bch2_dev_attach_bdev(struct bch_fs *c, struct bch_sb_handle *sb)
 	strscpy(ca->name, name.buf, sizeof(ca->name));
 	printbuf_exit(&name);
 
-	rebalance_wakeup(c);
+	bch2_rebalance_wakeup(c);
 	return 0;
 }
 
@@ -1672,7 +1672,7 @@ int __bch2_dev_set_state(struct bch_fs *c, struct bch_dev *ca,
 	if (new_state == BCH_MEMBER_STATE_rw)
 		__bch2_dev_read_write(c, ca);
 
-	rebalance_wakeup(c);
+	bch2_rebalance_wakeup(c);
 
 	return ret;
 }
diff --git a/fs/bcachefs/sysfs.c b/fs/bcachefs/sysfs.c
index fff675edef4e..00405372af5e 100644
--- a/fs/bcachefs/sysfs.c
+++ b/fs/bcachefs/sysfs.c
@@ -766,11 +766,10 @@ static ssize_t sysfs_opt_store(struct bch_fs *c,
 		bch2_set_rebalance_needs_scan(c, 0);
 
 	if (v && id == Opt_rebalance_enabled)
-		rebalance_wakeup(c);
+		bch2_rebalance_wakeup(c);
 
-	if (v && id == Opt_copygc_enabled &&
-	    c->copygc_thread)
-		wake_up_process(c->copygc_thread);
+	if (v && id == Opt_copygc_enabled)
+		bch2_copygc_wakeup(c);
 
 	if (id == Opt_discard && !ca) {
 		mutex_lock(&c->sb_lock);
-- 
2.49.0


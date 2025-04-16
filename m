Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 870E0179A7
	for <linux-bcachefs@vger.kernel.org>; Wed, 16 Apr 2025 13:37:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744810627; cv=none; b=CW2pQsHSoRuxpXDJ0Ud0OaUGsyAln66IUYWC11p3gz41VTgmbZskH6kqGDEbr3w45oaptlZ3fEss+3FnEPtJlnpswM5tsMWGRb+Go0H11ewDyYxwQvkwTUPkt11iKIpSBi8yLF1BVbVXP9oSVSR0ou6//IGFzX1EagIfLQYZxxo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744810627; c=relaxed/simple;
	bh=Sr+fRIRHa+ZHkubWGFIem0SLgA/8ujnZ43BR4+xzZrQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=E5HolhPm+sfB7TTl4xtCZKqyf/2t9YhdKH9cDheSDVzz/87167dHU0zava1SYv+hCAK5VCkF/qsQkn7CZjqbnl05LvzRrkb+4pAHmOG+I+iZFgOCSOmL2ORuDAsHAQU/90vT/eTz0FBeyX/I+ObFgmz+nf//FyRlVH+tuP8iwvE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=xM0YWBmb; arc=none smtp.client-ip=91.218.175.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="xM0YWBmb"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1744810621;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=VvBetXKp+pHAFLGzLzW75HMlaZODYkjbda5Aom+e8ww=;
	b=xM0YWBmbhtrTgLT8Fb+vucYxKrxFbpK7k8NpraVzz0T328u/SylFqwg4z5UlyEHRmSQOD7
	bSgcGh7I9IqTGCBGa316duq4tpRlXL9VgQyZGwbwHYbAxUoCtePlWZHmvE6G+Yej73yMeI
	3MAQ+4CH9uDeO19sF2ArhV714hH+OrA=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 1/3] bcachefs: bch2_copygc_wakeup()
Date: Wed, 16 Apr 2025 09:36:55 -0400
Message-ID: <20250416133657.3653568-1-kent.overstreet@linux.dev>
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
index e5f003c29369..82ee333ddd21 100644
--- a/fs/bcachefs/sysfs.c
+++ b/fs/bcachefs/sysfs.c
@@ -654,11 +654,10 @@ static ssize_t sysfs_opt_store(struct bch_fs *c,
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


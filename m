Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68DF93B796
	for <linux-bcachefs@vger.kernel.org>; Sat, 30 Nov 2024 01:28:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732930117; cv=none; b=i2pdlBKrAr/INCCl4BI4inaDJLGu+eJdFRzRQvdOuPKRfA9NCWEh9+uIq+GUoMDW1KioI6QjpyERPChzAwSj2hOQf8b1vMkQzkM/YQhIptYCwKLp4ITORqjCX+xWiOiavkoTAQ9fVPhPbG/L4lREubnqwlORpYpx0Jzehe2iIO0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732930117; c=relaxed/simple;
	bh=C28yZwvWZvng2VGtunBhexqYmQtsHMBjl3UnLcEEsbw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UYjcAJ7GZBt4KWH/WW9L0GbjF5GP+PkPs2zVeFAAavsnTh2vxmiTh47K9p4GAHgvTEYo98F2r/JjAj10Cnt92Ey8vvvwfCGNAEaimlBIU2iMHicoK3UoF5a4ZjAvhqfQ+W4fmEh95VMS0NzKnIlY+GtOKANjQO+lwBebKs3UoA8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Y/yJSUpk; arc=none smtp.client-ip=91.218.175.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Y/yJSUpk"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1732930112;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WvJPyJBFQMIcJ2oAoZsbI2Ke6Di8pNuLyi2ZnHq+L0o=;
	b=Y/yJSUpkZOEjVR3L9L2711YS0rStc2ss/iws5Eu7umlUtBnit04ccTxMgtTNpjo6Rp/7F3
	HebgX5MmHN87McK/LBB1FksldDQP14nruh1PbT0rf6syfNSn5hTGkUUN3ZAEHxeyRs7fYH
	AIigtUKB156se8qWTyle3T51I1e4zLk=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 4/4] bcachefs: bch2_async_btree_node_rewrites_flush()
Date: Fri, 29 Nov 2024 20:28:10 -0500
Message-ID: <20241130012812.3135521-5-kent.overstreet@linux.dev>
In-Reply-To: <20241130012812.3135521-1-kent.overstreet@linux.dev>
References: <20241130012812.3135521-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Add a method to flush btree node rewrites at the end of recovery, to
ensure that corrected errors are persisted.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/bcachefs.h              |   7 +-
 fs/bcachefs/btree_update_interior.c | 153 ++++++++++++++++------------
 fs/bcachefs/btree_update_interior.h |   1 +
 fs/bcachefs/error.c                 |   4 +-
 fs/bcachefs/recovery.c              |   2 +
 5 files changed, 99 insertions(+), 68 deletions(-)

diff --git a/fs/bcachefs/bcachefs.h b/fs/bcachefs/bcachefs.h
index c16937e54734..b12c9c78beec 100644
--- a/fs/bcachefs/bcachefs.h
+++ b/fs/bcachefs/bcachefs.h
@@ -829,9 +829,10 @@ struct bch_fs {
 	struct work_struct	btree_interior_update_work;
 
 	struct workqueue_struct	*btree_node_rewrite_worker;
-
-	struct list_head	pending_node_rewrites;
-	struct mutex		pending_node_rewrites_lock;
+	struct list_head	btree_node_rewrites;
+	struct list_head	btree_node_rewrites_pending;
+	spinlock_t		btree_node_rewrites_lock;
+	struct closure_waitlist	btree_node_rewrites_wait;
 
 	/* btree_io.c: */
 	spinlock_t		btree_write_error_lock;
diff --git a/fs/bcachefs/btree_update_interior.c b/fs/bcachefs/btree_update_interior.c
index 5eabd532e388..f2a1d5d3d8d5 100644
--- a/fs/bcachefs/btree_update_interior.c
+++ b/fs/bcachefs/btree_update_interior.c
@@ -2206,42 +2206,50 @@ struct async_btree_rewrite {
 	struct list_head	list;
 	enum btree_id		btree_id;
 	unsigned		level;
-	struct bpos		pos;
-	__le64			seq;
+	struct bkey_buf		key;
 };
 
 static int async_btree_node_rewrite_trans(struct btree_trans *trans,
 					  struct async_btree_rewrite *a)
 {
-	struct bch_fs *c = trans->c;
 	struct btree_iter iter;
-	struct btree *b;
-	int ret;
-
-	bch2_trans_node_iter_init(trans, &iter, a->btree_id, a->pos,
+	bch2_trans_node_iter_init(trans, &iter,
+				  a->btree_id, a->key.k->k.p,
 				  BTREE_MAX_DEPTH, a->level, 0);
-	b = bch2_btree_iter_peek_node(&iter);
-	ret = PTR_ERR_OR_ZERO(b);
+	struct btree *b = bch2_btree_iter_peek_node(&iter);
+	int ret = PTR_ERR_OR_ZERO(b);
 	if (ret)
 		goto out;
 
-	if (!b || b->data->keys.seq != a->seq) {
+	bool found = b && btree_ptr_hash_val(&b->key) == btree_ptr_hash_val(a->key.k);
+	ret = found
+		? bch2_btree_node_rewrite(trans, &iter, b, 0)
+		: -ENOENT;
+
+#if 0
+	/* Tracepoint... */
+	if (!ret || ret == -ENOENT) {
+		struct bch_fs *c = trans->c;
 		struct printbuf buf = PRINTBUF;
 
-		if (b)
-			bch2_bkey_val_to_text(&buf, c, bkey_i_to_s_c(&b->key));
-		else
-			prt_str(&buf, "(null");
-		bch_info(c, "%s: node to rewrite not found:, searching for seq %llu, got\n%s",
-			 __func__, a->seq, buf.buf);
+		if (!ret) {
+			prt_printf(&buf, "rewrite node:\n  ");
+			bch2_bkey_val_to_text(&buf, c, bkey_i_to_s_c(a->key.k));
+		} else {
+			prt_printf(&buf, "node to rewrite not found:\n  want: ");
+			bch2_bkey_val_to_text(&buf, c, bkey_i_to_s_c(a->key.k));
+			prt_printf(&buf, "\n  got:  ");
+			if (b)
+				bch2_bkey_val_to_text(&buf, c, bkey_i_to_s_c(&b->key));
+			else
+				prt_str(&buf, "(null)");
+		}
+		bch_info(c, "%s", buf.buf);
 		printbuf_exit(&buf);
-		goto out;
 	}
-
-	ret = bch2_btree_node_rewrite(trans, &iter, b, 0);
+#endif
 out:
 	bch2_trans_iter_exit(trans, &iter);
-
 	return ret;
 }
 
@@ -2252,81 +2260,96 @@ static void async_btree_node_rewrite_work(struct work_struct *work)
 	struct bch_fs *c = a->c;
 
 	int ret = bch2_trans_do(c, async_btree_node_rewrite_trans(trans, a));
-	bch_err_fn_ratelimited(c, ret);
+	if (ret != -ENOENT)
+		bch_err_fn_ratelimited(c, ret);
+
+	spin_lock(&c->btree_node_rewrites_lock);
+	list_del(&a->list);
+	spin_unlock(&c->btree_node_rewrites_lock);
+
+	closure_wake_up(&c->btree_node_rewrites_wait);
+
+	bch2_bkey_buf_exit(&a->key, c);
 	bch2_write_ref_put(c, BCH_WRITE_REF_node_rewrite);
 	kfree(a);
 }
 
 void bch2_btree_node_rewrite_async(struct bch_fs *c, struct btree *b)
 {
-	struct async_btree_rewrite *a;
-	int ret;
-
-	a = kmalloc(sizeof(*a), GFP_NOFS);
-	if (!a) {
-		bch_err(c, "%s: error allocating memory", __func__);
+	struct async_btree_rewrite *a = kmalloc(sizeof(*a), GFP_NOFS);
+	if (!a)
 		return;
-	}
 
 	a->c		= c;
 	a->btree_id	= b->c.btree_id;
 	a->level	= b->c.level;
-	a->pos		= b->key.k.p;
-	a->seq		= b->data->keys.seq;
 	INIT_WORK(&a->work, async_btree_node_rewrite_work);
 
-	if (unlikely(!test_bit(BCH_FS_may_go_rw, &c->flags))) {
-		mutex_lock(&c->pending_node_rewrites_lock);
-		list_add(&a->list, &c->pending_node_rewrites);
-		mutex_unlock(&c->pending_node_rewrites_lock);
-		return;
-	}
+	bch2_bkey_buf_init(&a->key);
+	bch2_bkey_buf_copy(&a->key, c, &b->key);
 
-	if (!bch2_write_ref_tryget(c, BCH_WRITE_REF_node_rewrite)) {
-		if (test_bit(BCH_FS_started, &c->flags)) {
-			bch_err(c, "%s: error getting c->writes ref", __func__);
-			kfree(a);
-			return;
-		}
+	bool now = false, pending = false;
 
-		ret = bch2_fs_read_write_early(c);
-		bch_err_msg(c, ret, "going read-write");
-		if (ret) {
-			kfree(a);
-			return;
-		}
+	spin_lock(&c->btree_node_rewrites_lock);
+	if (bch2_write_ref_tryget(c, BCH_WRITE_REF_node_rewrite)) {
+		list_add(&a->list, &c->btree_node_rewrites);
+		now = true;
+	} else if (!test_bit(BCH_FS_may_go_rw, &c->flags)) {
+		list_add(&a->list, &c->btree_node_rewrites_pending);
+		pending = true;
+	}
+	spin_unlock(&c->btree_node_rewrites_lock);
 
-		bch2_write_ref_get(c, BCH_WRITE_REF_node_rewrite);
+	if (now) {
+		queue_work(c->btree_node_rewrite_worker, &a->work);
+	} else if (pending) {
+		/* bch2_do_pending_node_rewrites will execute */
+	} else {
+		bch2_bkey_buf_exit(&a->key, c);
+		kfree(a);
 	}
+}
 
-	queue_work(c->btree_node_rewrite_worker, &a->work);
+void bch2_async_btree_node_rewrites_flush(struct bch_fs *c)
+{
+	closure_wait_event(&c->btree_node_rewrites_wait,
+			   list_empty(&c->btree_node_rewrites));
 }
 
 void bch2_do_pending_node_rewrites(struct bch_fs *c)
 {
-	struct async_btree_rewrite *a, *n;
-
-	mutex_lock(&c->pending_node_rewrites_lock);
-	list_for_each_entry_safe(a, n, &c->pending_node_rewrites, list) {
-		list_del(&a->list);
+	while (1) {
+		spin_lock(&c->btree_node_rewrites_lock);
+		struct async_btree_rewrite *a =
+			list_pop_entry(&c->btree_node_rewrites_pending,
+				       struct async_btree_rewrite, list);
+		if (a)
+			list_add(&a->list, &c->btree_node_rewrites);
+		spin_unlock(&c->btree_node_rewrites_lock);
+
+		if (!a)
+			break;
 
 		bch2_write_ref_get(c, BCH_WRITE_REF_node_rewrite);
 		queue_work(c->btree_node_rewrite_worker, &a->work);
 	}
-	mutex_unlock(&c->pending_node_rewrites_lock);
 }
 
 void bch2_free_pending_node_rewrites(struct bch_fs *c)
 {
-	struct async_btree_rewrite *a, *n;
+	while (1) {
+		spin_lock(&c->btree_node_rewrites_lock);
+		struct async_btree_rewrite *a =
+			list_pop_entry(&c->btree_node_rewrites_pending,
+				       struct async_btree_rewrite, list);
+		spin_unlock(&c->btree_node_rewrites_lock);
 
-	mutex_lock(&c->pending_node_rewrites_lock);
-	list_for_each_entry_safe(a, n, &c->pending_node_rewrites, list) {
-		list_del(&a->list);
+		if (!a)
+			break;
 
+		bch2_bkey_buf_exit(&a->key, c);
 		kfree(a);
 	}
-	mutex_unlock(&c->pending_node_rewrites_lock);
 }
 
 static int __bch2_btree_node_update_key(struct btree_trans *trans,
@@ -2683,6 +2706,9 @@ void bch2_btree_reserve_cache_to_text(struct printbuf *out, struct bch_fs *c)
 
 void bch2_fs_btree_interior_update_exit(struct bch_fs *c)
 {
+	WARN_ON(!list_empty(&c->btree_node_rewrites));
+	WARN_ON(!list_empty(&c->btree_node_rewrites_pending));
+
 	if (c->btree_node_rewrite_worker)
 		destroy_workqueue(c->btree_node_rewrite_worker);
 	if (c->btree_interior_update_worker)
@@ -2698,8 +2724,9 @@ void bch2_fs_btree_interior_update_init_early(struct bch_fs *c)
 	mutex_init(&c->btree_interior_update_lock);
 	INIT_WORK(&c->btree_interior_update_work, btree_interior_update_work);
 
-	INIT_LIST_HEAD(&c->pending_node_rewrites);
-	mutex_init(&c->pending_node_rewrites_lock);
+	INIT_LIST_HEAD(&c->btree_node_rewrites);
+	INIT_LIST_HEAD(&c->btree_node_rewrites_pending);
+	spin_lock_init(&c->btree_node_rewrites_lock);
 }
 
 int bch2_fs_btree_interior_update_init(struct bch_fs *c)
diff --git a/fs/bcachefs/btree_update_interior.h b/fs/bcachefs/btree_update_interior.h
index 1c6cf3e2e6a9..7930ffea3075 100644
--- a/fs/bcachefs/btree_update_interior.h
+++ b/fs/bcachefs/btree_update_interior.h
@@ -334,6 +334,7 @@ void bch2_journal_entry_to_btree_root(struct bch_fs *, struct jset_entry *);
 struct jset_entry *bch2_btree_roots_to_journal_entries(struct bch_fs *,
 					struct jset_entry *, unsigned long);
 
+void bch2_async_btree_node_rewrites_flush(struct bch_fs *);
 void bch2_do_pending_node_rewrites(struct bch_fs *);
 void bch2_free_pending_node_rewrites(struct bch_fs *);
 
diff --git a/fs/bcachefs/error.c b/fs/bcachefs/error.c
index 9e34374960f3..7af5c5946cc2 100644
--- a/fs/bcachefs/error.c
+++ b/fs/bcachefs/error.c
@@ -477,8 +477,8 @@ int __bch2_bkey_fsck_err(struct bch_fs *c,
 
 	unsigned fsck_flags = 0;
 	if (!(from.flags & (BCH_VALIDATE_write|BCH_VALIDATE_commit))) {
-		if (test_bit(err, c->sb.errors_silent))
-			return -BCH_ERR_fsck_delete_bkey;
+		//if (test_bit(err, c->sb.errors_silent))
+		//	return -BCH_ERR_fsck_delete_bkey;
 
 		fsck_flags |= FSCK_AUTOFIX|FSCK_CAN_FIX;
 	}
diff --git a/fs/bcachefs/recovery.c b/fs/bcachefs/recovery.c
index c50dede64785..a342744fd275 100644
--- a/fs/bcachefs/recovery.c
+++ b/fs/bcachefs/recovery.c
@@ -931,6 +931,8 @@ int bch2_fs_recovery(struct bch_fs *c)
 	/* in case we don't run journal replay, i.e. norecovery mode */
 	set_bit(BCH_FS_accounting_replay_done, &c->flags);
 
+	bch2_async_btree_node_rewrites_flush(c);
+
 	/* fsync if we fixed errors */
 	if (test_bit(BCH_FS_errors_fixed, &c->flags)) {
 		bch2_journal_flush_all_pins(&c->journal);
-- 
2.45.2


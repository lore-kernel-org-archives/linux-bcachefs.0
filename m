Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBED038DD5
	for <linux-bcachefs@vger.kernel.org>; Fri, 10 Nov 2023 16:32:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="BhFYOR/G"
Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 263083EB11
	for <linux-bcachefs@vger.kernel.org>; Fri, 10 Nov 2023 08:32:12 -0800 (PST)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1699633930;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jylsn7uuE2kV5i4VIf0RJBe/xvISddDzk9yoAhgkenA=;
	b=BhFYOR/G9h5QEbEGJbZNKHYex5Z31+NVIr25rh6tqgYEd3Pf3LcyhKnxii7Xx47dUsMe8a
	TeWyGU1hfu2I3zMfelhcVNRL/14W/IXkRm7G8R1aQGa20d0ZzJE+VAcS80QN+8VkcaHw2c
	AHBBIbm77gD8kUfwjyvuMrQsuc6/AKQ=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 12/17] bcachefs: Clean up btree write buffer write ref handling
Date: Fri, 10 Nov 2023 11:31:49 -0500
Message-ID: <20231110163157.2736111-13-kent.overstreet@linux.dev>
In-Reply-To: <20231110163157.2736111-1-kent.overstreet@linux.dev>
References: <20231110163157.2736111-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

__bch2_btree_write_buffer_flush() now assumes a write ref is already
held (as called by the transaction commit path); and the wrappers
bch2_write_buffer_flush() and flush_sync() take an explicit write ref.

This means internally the write buffer code can always use
BTREE_INSERT_NOCHECK_RW, instead of in the previous code passing flags
around and hoping the NOCHECK_RW flag was always carried around
correctly.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/bcachefs.h           |  3 ++-
 fs/bcachefs/btree_trans_commit.c |  6 ++----
 fs/bcachefs/btree_write_buffer.c | 33 +++++++++++++++++++++-----------
 fs/bcachefs/btree_write_buffer.h |  2 +-
 fs/bcachefs/inode.c              | 10 +++++-----
 5 files changed, 32 insertions(+), 22 deletions(-)

diff --git a/fs/bcachefs/bcachefs.h b/fs/bcachefs/bcachefs.h
index 3117ab4426a7..748164c0e82b 100644
--- a/fs/bcachefs/bcachefs.h
+++ b/fs/bcachefs/bcachefs.h
@@ -664,7 +664,8 @@ struct btree_trans_buf {
 	x(invalidate)							\
 	x(delete_dead_snapshots)					\
 	x(snapshot_delete_pagecache)					\
-	x(sysfs)
+	x(sysfs)							\
+	x(btree_write_buffer)
 
 enum bch_write_ref {
 #define x(n) BCH_WRITE_REF_##n,
diff --git a/fs/bcachefs/btree_trans_commit.c b/fs/bcachefs/btree_trans_commit.c
index f231f01072c2..929fe398f1db 100644
--- a/fs/bcachefs/btree_trans_commit.c
+++ b/fs/bcachefs/btree_trans_commit.c
@@ -962,8 +962,7 @@ int bch2_trans_commit_error(struct btree_trans *trans, unsigned flags,
 
 			if (wb->state.nr > wb->size * 3 / 4) {
 				bch2_trans_begin(trans);
-				ret = __bch2_btree_write_buffer_flush(trans,
-						flags|BTREE_INSERT_NOCHECK_RW, true);
+				ret = __bch2_btree_write_buffer_flush(trans, true);
 				if (!ret) {
 					trace_and_count(c, trans_restart_write_buffer_flush, trans, _THIS_IP_);
 					ret = btree_trans_restart(trans, BCH_ERR_transaction_restart_write_buffer_flush);
@@ -1082,8 +1081,7 @@ int __bch2_trans_commit(struct btree_trans *trans, unsigned flags)
 		bch2_trans_begin(trans);
 		bch2_trans_unlock(trans);
 
-		ret = __bch2_btree_write_buffer_flush(trans,
-					flags|BTREE_INSERT_NOCHECK_RW, true);
+		ret = __bch2_btree_write_buffer_flush(trans, true);
 		if (!ret) {
 			trace_and_count(c, trans_restart_write_buffer_flush, trans, _THIS_IP_);
 			ret = btree_trans_restart(trans, BCH_ERR_transaction_restart_write_buffer_flush);
diff --git a/fs/bcachefs/btree_write_buffer.c b/fs/bcachefs/btree_write_buffer.c
index f40ac365620f..7f358a3d0789 100644
--- a/fs/bcachefs/btree_write_buffer.c
+++ b/fs/bcachefs/btree_write_buffer.c
@@ -137,8 +137,7 @@ btree_write_buffered_insert(struct btree_trans *trans,
 	return ret;
 }
 
-int __bch2_btree_write_buffer_flush(struct btree_trans *trans, unsigned commit_flags,
-				    bool locked)
+int __bch2_btree_write_buffer_flush(struct btree_trans *trans, bool locked)
 {
 	struct bch_fs *c = trans->c;
 	struct journal *j = &c->journal;
@@ -210,8 +209,8 @@ int __bch2_btree_write_buffer_flush(struct btree_trans *trans, unsigned commit_f
 		iter.path->preserve = false;
 
 		do {
-			ret = bch2_btree_write_buffer_flush_one(trans, &iter, i,
-						commit_flags, &write_locked, &fast);
+			ret = bch2_btree_write_buffer_flush_one(trans, &iter, i, 0,
+								&write_locked, &fast);
 			if (!write_locked)
 				bch2_trans_begin(trans);
 		} while (bch2_err_matches(ret, BCH_ERR_transaction_restart));
@@ -252,9 +251,6 @@ int __bch2_btree_write_buffer_flush(struct btree_trans *trans, unsigned commit_f
 	     btree_write_buffered_journal_cmp,
 	     NULL);
 
-	commit_flags &= ~BCH_WATERMARK_MASK;
-	commit_flags |= BCH_WATERMARK_reclaim;
-
 	for (i = keys; i < keys + nr; i++) {
 		if (!i->journal_seq)
 			continue;
@@ -263,7 +259,8 @@ int __bch2_btree_write_buffer_flush(struct btree_trans *trans, unsigned commit_f
 			      bch2_btree_write_buffer_journal_flush);
 
 		ret = commit_do(trans, NULL, NULL,
-				commit_flags|
+				BCH_WATERMARK_reclaim|
+				BTREE_INSERT_NOCHECK_RW|
 				BTREE_INSERT_NOFAIL|
 				BTREE_INSERT_JOURNAL_REPLAY|
 				BTREE_INSERT_JOURNAL_RECLAIM,
@@ -277,14 +274,28 @@ int __bch2_btree_write_buffer_flush(struct btree_trans *trans, unsigned commit_f
 
 int bch2_btree_write_buffer_flush_sync(struct btree_trans *trans)
 {
+	struct bch_fs *c = trans->c;
+
+	if (!bch2_write_ref_tryget(c, BCH_WRITE_REF_btree_write_buffer))
+		return -BCH_ERR_erofs_no_writes;
+
 	bch2_trans_unlock(trans);
 	mutex_lock(&trans->c->btree_write_buffer.flush_lock);
-	return __bch2_btree_write_buffer_flush(trans, 0, true);
+	int ret = __bch2_btree_write_buffer_flush(trans, true);
+	bch2_write_ref_put(c, BCH_WRITE_REF_btree_write_buffer);
+	return ret;
 }
 
 int bch2_btree_write_buffer_flush(struct btree_trans *trans)
 {
-	return __bch2_btree_write_buffer_flush(trans, 0, false);
+	struct bch_fs *c = trans->c;
+
+	if (!bch2_write_ref_tryget(c, BCH_WRITE_REF_btree_write_buffer))
+		return -BCH_ERR_erofs_no_writes;
+
+	int ret = __bch2_btree_write_buffer_flush(trans, false);
+	bch2_write_ref_put(c, BCH_WRITE_REF_btree_write_buffer);
+	return ret;
 }
 
 static int bch2_btree_write_buffer_journal_flush(struct journal *j,
@@ -296,7 +307,7 @@ static int bch2_btree_write_buffer_journal_flush(struct journal *j,
 	mutex_lock(&wb->flush_lock);
 
 	return bch2_trans_run(c,
-			__bch2_btree_write_buffer_flush(trans, BTREE_INSERT_NOCHECK_RW, true));
+			__bch2_btree_write_buffer_flush(trans, true));
 }
 
 static inline u64 btree_write_buffer_ref(int idx)
diff --git a/fs/bcachefs/btree_write_buffer.h b/fs/bcachefs/btree_write_buffer.h
index 322df1c8304e..8639b4209544 100644
--- a/fs/bcachefs/btree_write_buffer.h
+++ b/fs/bcachefs/btree_write_buffer.h
@@ -2,7 +2,7 @@
 #ifndef _BCACHEFS_BTREE_WRITE_BUFFER_H
 #define _BCACHEFS_BTREE_WRITE_BUFFER_H
 
-int __bch2_btree_write_buffer_flush(struct btree_trans *, unsigned, bool);
+int __bch2_btree_write_buffer_flush(struct btree_trans *, bool);
 int bch2_btree_write_buffer_flush_sync(struct btree_trans *);
 int bch2_btree_write_buffer_flush(struct btree_trans *);
 
diff --git a/fs/bcachefs/inode.c b/fs/bcachefs/inode.c
index def77f2d8802..a8488237d0bb 100644
--- a/fs/bcachefs/inode.c
+++ b/fs/bcachefs/inode.c
@@ -1157,10 +1157,6 @@ int bch2_delete_dead_inodes(struct bch_fs *c)
 again:
 	need_another_pass = false;
 
-	ret = bch2_btree_write_buffer_flush_sync(trans);
-	if (ret)
-		goto err;
-
 	/*
 	 * Weird transaction restart handling here because on successful delete,
 	 * bch2_inode_rm_snapshot() will return a nested transaction restart,
@@ -1189,8 +1185,12 @@ int bch2_delete_dead_inodes(struct bch_fs *c)
 	}
 	bch2_trans_iter_exit(trans, &iter);
 
-	if (!ret && need_another_pass)
+	if (!ret && need_another_pass) {
+		ret = bch2_btree_write_buffer_flush_sync(trans);
+		if (ret)
+			goto err;
 		goto again;
+	}
 err:
 	bch2_trans_put(trans);
 
-- 
2.42.0


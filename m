Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DDAF14885D
	for <linux-bcachefs@vger.kernel.org>; Wed, 16 Apr 2025 13:37:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744810653; cv=none; b=HlqXGKRLxSmB0miHvhTjowuqDRUxddTjIDlxR8zI3HPEhT8tpAPjPT53IfzEZbblJgYSjKuMGEusHwhxYxnqjXObf3KRT/MCS/s1uSsc2hC5gQwHLNgAQcXaN2VFm+Ro8ruwydZpX1LtQX8+ZLIM5x44fhXWjqsOwIuIjE85ls8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744810653; c=relaxed/simple;
	bh=WfADcz+vSUSOXiXhwFbhBRW7tErmOId80iJF6c2C3+o=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Ku4A68L9opfPDX7CGCl9RZ50SMCwj/jmLgD98gFi4SzRRrpMrcURpGXnRBcZziEJzgDV+jS4rdz3X3Wo8yZtIjBduD4gzLYGRrDyo+rqIM6H81WcbDfIUcR7dkafykRwoC3Dw+KrVMRRHOmSNGcd/tw447pbzuhQLxoZ522VXn0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=OKc0BasO; arc=none smtp.client-ip=91.218.175.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="OKc0BasO"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1744810649;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=SaTRO3LhfyXwnB4Y0uO8TW2Rr3Rtp9Zf0C0S3xD38Nw=;
	b=OKc0BasOAbLWwRjKaSR2QwzHFtnHtxbCUTHLfCt75K4fbfV7ktTKINhF9VOuCnnqO3eFt+
	evAN2lmAURz6SD9Edp2NKDQBeC3F9y4NjGz0EPj4gPHvq5sZkyE5xutMc3OeGzzBXj59KQ
	HG7W2ucxdPAviLGn/7CxRefxeBXJvb8=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 1/6] bcachefs: bch2_run_explicit_recovery_pass_printbuf()
Date: Wed, 16 Apr 2025 09:37:19 -0400
Message-ID: <20250416133724.3653606-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

We prefer helpers that emit log messages to printbufs rather than
printing them directly; that way, we can ensure that different log
messages from the same event are grouped together and formatted
appropriately in the dmesg log.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/buckets.c         | 33 +++++++++++++++++++++---------
 fs/bcachefs/error.c           |  2 +-
 fs/bcachefs/recovery_passes.c | 38 +++++++++++++++++++++++++++--------
 fs/bcachefs/recovery_passes.h |  3 +++
 4 files changed, 57 insertions(+), 19 deletions(-)

diff --git a/fs/bcachefs/buckets.c b/fs/bcachefs/buckets.c
index 4ef261e8db4f..cebd4d21f361 100644
--- a/fs/bcachefs/buckets.c
+++ b/fs/bcachefs/buckets.c
@@ -400,7 +400,8 @@ static int bucket_ref_update_err(struct btree_trans *trans, struct printbuf *buf
 
 	__bch2_count_fsck_err(c, id, buf->buf, &repeat, &print, &suppress);
 
-	int ret = bch2_run_explicit_recovery_pass(c, BCH_RECOVERY_PASS_check_allocations);
+	int ret = bch2_run_explicit_recovery_pass_printbuf(c, buf,
+					BCH_RECOVERY_PASS_check_allocations);
 
 	if (insert) {
 		print = true;
@@ -959,14 +960,27 @@ static int __bch2_trans_mark_metadata_bucket(struct btree_trans *trans,
 		return PTR_ERR(a);
 
 	if (a->v.data_type && type && a->v.data_type != type) {
-		bch2_run_explicit_recovery_pass(c, BCH_RECOVERY_PASS_check_allocations);
-		log_fsck_err(trans, bucket_metadata_type_mismatch,
-			"bucket %llu:%llu gen %u different types of data in same bucket: %s, %s\n"
-			"while marking %s",
-			iter.pos.inode, iter.pos.offset, a->v.gen,
-			bch2_data_type_str(a->v.data_type),
-			bch2_data_type_str(type),
-			bch2_data_type_str(type));
+		struct printbuf buf = PRINTBUF;
+		bch2_log_msg_start(c, &buf);
+		prt_printf(&buf, "bucket %llu:%llu gen %u different types of data in same bucket: %s, %s\n"
+			   "while marking %s\n",
+			   iter.pos.inode, iter.pos.offset, a->v.gen,
+			   bch2_data_type_str(a->v.data_type),
+			   bch2_data_type_str(type),
+			   bch2_data_type_str(type));
+
+		bool repeat = false, print = true, suppress = false;
+		bch2_count_fsck_err(c, bucket_metadata_type_mismatch, buf.buf,
+				    &repeat, &print, &suppress);
+
+		bch2_run_explicit_recovery_pass_printbuf(c, &buf,
+					BCH_RECOVERY_PASS_check_allocations);
+
+		if (suppress)
+			prt_printf(&buf, "Ratelimiting new instances of previous error\n");
+		if (print)
+			bch2_print_string_as_lines(KERN_ERR, buf.buf);
+		printbuf_exit(&buf);
 		ret = -BCH_ERR_metadata_bucket_inconsistency;
 		goto err;
 	}
@@ -978,7 +992,6 @@ static int __bch2_trans_mark_metadata_bucket(struct btree_trans *trans,
 		ret = bch2_trans_update(trans, &iter, &a->k_i, 0);
 	}
 err:
-fsck_err:
 	bch2_trans_iter_exit(trans, &iter);
 	return ret;
 }
diff --git a/fs/bcachefs/error.c b/fs/bcachefs/error.c
index baf5dfb32298..c3385bc0d1ef 100644
--- a/fs/bcachefs/error.c
+++ b/fs/bcachefs/error.c
@@ -104,7 +104,7 @@ int __bch2_topology_error(struct bch_fs *c, struct printbuf *out)
 		__bch2_inconsistent_error(c, out);
 		return -BCH_ERR_btree_need_topology_repair;
 	} else {
-		return bch2_run_explicit_recovery_pass(c, BCH_RECOVERY_PASS_check_topology) ?:
+		return bch2_run_explicit_recovery_pass_printbuf(c, out, BCH_RECOVERY_PASS_check_topology) ?:
 			-BCH_ERR_btree_node_read_validate_error;
 	}
 }
diff --git a/fs/bcachefs/recovery_passes.c b/fs/bcachefs/recovery_passes.c
index 593ff142530d..4744e2e5f2ab 100644
--- a/fs/bcachefs/recovery_passes.c
+++ b/fs/bcachefs/recovery_passes.c
@@ -100,7 +100,8 @@ u64 bch2_recovery_passes_from_stable(u64 v)
 /*
  * For when we need to rewind recovery passes and run a pass we skipped:
  */
-static int __bch2_run_explicit_recovery_pass(struct bch_fs *c,
+static int __bch2_run_explicit_recovery_pass(struct printbuf *out,
+					     struct bch_fs *c,
 					     enum bch_recovery_pass pass)
 {
 	if (c->curr_recovery_pass == ARRAY_SIZE(recovery_pass_fns))
@@ -114,15 +115,15 @@ static int __bch2_run_explicit_recovery_pass(struct bch_fs *c,
 	if (pass < BCH_RECOVERY_PASS_set_may_go_rw &&
 	    c->curr_recovery_pass >= BCH_RECOVERY_PASS_set_may_go_rw) {
 		if (print)
-			bch_info(c, "need recovery pass %s (%u), but already rw",
-				 bch2_recovery_passes[pass], pass);
+			prt_printf(out, "need recovery pass %s (%u), but already rw",
+				   bch2_recovery_passes[pass], pass);
 		return -BCH_ERR_cannot_rewind_recovery;
 	}
 
 	if (print)
-		bch_info(c, "running explicit recovery pass %s (%u), currently at %s (%u)",
-			 bch2_recovery_passes[pass], pass,
-			 bch2_recovery_passes[c->curr_recovery_pass], c->curr_recovery_pass);
+		prt_printf(out, "running explicit recovery pass %s (%u), currently at %s (%u)",
+			   bch2_recovery_passes[pass], pass,
+			   bch2_recovery_passes[c->curr_recovery_pass], c->curr_recovery_pass);
 
 	c->opts.recovery_passes |= BIT_ULL(pass);
 
@@ -135,13 +136,34 @@ static int __bch2_run_explicit_recovery_pass(struct bch_fs *c,
 	}
 }
 
-int bch2_run_explicit_recovery_pass(struct bch_fs *c,
+int bch2_run_explicit_recovery_pass_printbuf(struct bch_fs *c,
+				    struct printbuf *out,
 				    enum bch_recovery_pass pass)
 {
+	bch2_printbuf_make_room(out, 1024);
+	out->atomic++;
+
 	unsigned long flags;
 	spin_lock_irqsave(&c->recovery_pass_lock, flags);
-	int ret = __bch2_run_explicit_recovery_pass(c, pass);
+	int ret = __bch2_run_explicit_recovery_pass(out, c, pass);
 	spin_unlock_irqrestore(&c->recovery_pass_lock, flags);
+
+	--out->atomic;
+	return ret;
+}
+
+int bch2_run_explicit_recovery_pass(struct bch_fs *c,
+				    enum bch_recovery_pass pass)
+{
+	struct printbuf buf = PRINTBUF;
+	bch2_log_msg_start(c, &buf);
+	unsigned len = buf.pos;
+
+	int ret = bch2_run_explicit_recovery_pass_printbuf(c, &buf, pass);
+
+	if (len != buf.pos)
+		bch2_print_string_as_lines(KERN_NOTICE, buf.buf);
+	printbuf_exit(&buf);
 	return ret;
 }
 
diff --git a/fs/bcachefs/recovery_passes.h b/fs/bcachefs/recovery_passes.h
index 7d7339c8fa29..e19a8aaba2f8 100644
--- a/fs/bcachefs/recovery_passes.h
+++ b/fs/bcachefs/recovery_passes.h
@@ -8,6 +8,9 @@ u64 bch2_recovery_passes_from_stable(u64 v);
 
 u64 bch2_fsck_recovery_passes(void);
 
+int bch2_run_explicit_recovery_pass_printbuf(struct bch_fs *,
+				    struct printbuf *,
+				    enum bch_recovery_pass);
 int bch2_run_explicit_recovery_pass(struct bch_fs *, enum bch_recovery_pass);
 int bch2_run_explicit_recovery_pass_persistent_locked(struct bch_fs *, enum bch_recovery_pass);
 int bch2_run_explicit_recovery_pass_persistent(struct bch_fs *, enum bch_recovery_pass);
-- 
2.49.0


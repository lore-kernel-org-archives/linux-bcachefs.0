Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E45DB7DA82
	for <linux-bcachefs@vger.kernel.org>; Thu, 22 May 2025 17:00:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747933229; cv=none; b=dP/x6MjvNYlAnIG+ykccZGl+SAu8AmoaKkr5dhn3mBvVhZAOKgLGkfcgJjvapQ41umIpdaA0Fh1Xb6q9urB3cVDTba9LX8Tp35yTCWQ3+Xc2fcuqDsJZdjRPimYT+Kta/BZnvbfMdj6/qZs1YwYk8w6EGR+gnqZyTJU4aLo+upA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747933229; c=relaxed/simple;
	bh=846abecOQ13mXRh0jre/QSNiTp9mrU9ufxPQAYh/fsQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PQyIdroo2bKlqb+VZ3BljATKhy/amtbBdwgbDvBY1drsyVKMU40ImZnTowxcnv9wzH8+NiXHku2uLoPr+dpmWg0B8lQOOYhnIJsMfNjGnbl+ZJXXNBZalrNwW7+py1xtTBat9LrYvUg4g47Zrj/5rOwk60Rcr1AIc/eyLdw9DKs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Iim/dT7R; arc=none smtp.client-ip=91.218.175.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Iim/dT7R"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1747933224;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9XDnciBDD11ORFcMxlE/J3Yy6/bDdQsNOtR+/bB+vG4=;
	b=Iim/dT7Rv+FpaXzTnqn9AwRzSkF+1Mp5FLWJkphX+3u0dLvZwKny7v4NR7OEvLXpXJtaWB
	S4SxjZht/g8/lzKU6TrFbQ9QQbidNHN/IWk37OMtXGEwsKR6siM5WkK4/y6thkbINa6cLh
	IgZfVIv/v6KApaNjeFgxycMAu5mLpYU=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 3/3] bcachefs: Reduce stack usage in data_update_index_update()
Date: Thu, 22 May 2025 13:00:19 -0400
Message-ID: <20250522170019.2909181-3-kent.overstreet@linux.dev>
In-Reply-To: <20250522170019.2909181-1-kent.overstreet@linux.dev>
References: <20250522170019.2909181-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Separate tracepoint message generation and other slowpath code into
non-inline functions, and use bch2_trans_log_str() instead of using a
printbuf for our journal message.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/data_update.c | 154 +++++++++++++++++++++-----------------
 1 file changed, 87 insertions(+), 67 deletions(-)

diff --git a/fs/bcachefs/data_update.c b/fs/bcachefs/data_update.c
index ef648a6d9c52..c34e5b88ba9d 100644
--- a/fs/bcachefs/data_update.c
+++ b/fs/bcachefs/data_update.c
@@ -100,9 +100,10 @@ static bool bkey_nocow_lock(struct bch_fs *c, struct moving_context *ctxt, struc
 	return true;
 }
 
-static noinline void trace_io_move_finish2(struct data_update *u,
-					       struct bkey_i *new,
-					       struct bkey_i *insert)
+noinline_for_stack
+static void trace_io_move_finish2(struct data_update *u,
+				  struct bkey_i *new,
+				  struct bkey_i *insert)
 {
 	struct bch_fs *c = u->op.c;
 	struct printbuf buf = PRINTBUF;
@@ -124,6 +125,7 @@ static noinline void trace_io_move_finish2(struct data_update *u,
 	printbuf_exit(&buf);
 }
 
+noinline_for_stack
 static void trace_io_move_fail2(struct data_update *m,
 			 struct bkey_s_c new,
 			 struct bkey_s_c wrote,
@@ -179,19 +181,84 @@ static void trace_io_move_fail2(struct data_update *m,
 	printbuf_exit(&buf);
 }
 
+noinline_for_stack
+static void trace_data_update2(struct data_update *m,
+			       struct bkey_s_c old, struct bkey_s_c k,
+			       struct bkey_i *insert)
+{
+	struct bch_fs *c = m->op.c;
+	struct printbuf buf = PRINTBUF;
+
+	prt_str(&buf, "\nold: ");
+	bch2_bkey_val_to_text(&buf, c, old);
+	prt_str(&buf, "\nk:   ");
+	bch2_bkey_val_to_text(&buf, c, k);
+	prt_str(&buf, "\nnew: ");
+	bch2_bkey_val_to_text(&buf, c, bkey_i_to_s_c(insert));
+
+	trace_data_update(c, buf.buf);
+	printbuf_exit(&buf);
+}
+
+noinline_for_stack
+static void trace_io_move_created_rebalance2(struct data_update *m,
+					     struct bkey_s_c old, struct bkey_s_c k,
+					     struct bkey_i *insert)
+{
+	struct bch_fs *c = m->op.c;
+	struct printbuf buf = PRINTBUF;
+
+	bch2_data_update_opts_to_text(&buf, c, &m->op.opts, &m->data_opts);
+
+	prt_str(&buf, "\nold: ");
+	bch2_bkey_val_to_text(&buf, c, old);
+	prt_str(&buf, "\nk:   ");
+	bch2_bkey_val_to_text(&buf, c, k);
+	prt_str(&buf, "\nnew: ");
+	bch2_bkey_val_to_text(&buf, c, bkey_i_to_s_c(insert));
+
+	trace_io_move_created_rebalance(c, buf.buf);
+	printbuf_exit(&buf);
+
+	this_cpu_inc(c->counters[BCH_COUNTER_io_move_created_rebalance]);
+}
+
+noinline_for_stack
+static int data_update_invalid_bkey(struct data_update *m,
+				    struct bkey_s_c old, struct bkey_s_c k,
+				    struct bkey_i *insert)
+{
+	struct bch_fs *c = m->op.c;
+	struct printbuf buf = PRINTBUF;
+	bch2_log_msg_start(c, &buf);
+
+	prt_str(&buf, "about to insert invalid key in data update path");
+	prt_printf(&buf, "\nop.nonce: %u", m->op.nonce);
+	prt_str(&buf, "\nold: ");
+	bch2_bkey_val_to_text(&buf, c, old);
+	prt_str(&buf, "\nk:   ");
+	bch2_bkey_val_to_text(&buf, c, k);
+	prt_str(&buf, "\nnew: ");
+	bch2_bkey_val_to_text(&buf, c, bkey_i_to_s_c(insert));
+
+	bch2_fs_emergency_read_only2(c, &buf);
+
+	bch2_print_str(c, KERN_ERR, buf.buf);
+	printbuf_exit(&buf);
+
+	return -BCH_ERR_invalid_bkey;
+}
+
 static int __bch2_data_update_index_update(struct btree_trans *trans,
 					   struct bch_write_op *op)
 {
 	struct bch_fs *c = op->c;
 	struct btree_iter iter;
-	struct data_update *m =
-		container_of(op, struct data_update, op);
-	struct keylist *keys = &op->insert_keys;
-	struct printbuf journal_msg = PRINTBUF;
+	struct data_update *m = container_of(op, struct data_update, op);
 	int ret = 0;
 
 	bch2_trans_iter_init(trans, &iter, m->btree_id,
-			     bkey_start_pos(&bch2_keylist_front(keys)->k),
+			     bkey_start_pos(&bch2_keylist_front(&op->insert_keys)->k),
 			     BTREE_ITER_slots|BTREE_ITER_intent);
 
 	while (1) {
@@ -216,11 +283,11 @@ static int __bch2_data_update_index_update(struct btree_trans *trans,
 		if (ret)
 			goto err;
 
-		new = bkey_i_to_extent(bch2_keylist_front(keys));
+		new = bkey_i_to_extent(bch2_keylist_front(&op->insert_keys));
 
 		if (!bch2_extents_match(k, old)) {
 			trace_io_move_fail2(m, k, bkey_i_to_s_c(&new->k_i),
-						NULL, "no match:");
+					    NULL, "no match:");
 			goto nowork;
 		}
 
@@ -239,7 +306,7 @@ static int __bch2_data_update_index_update(struct btree_trans *trans,
 		if (ret)
 			goto err;
 
-		bkey_copy(&new->k_i, bch2_keylist_front(keys));
+		bkey_copy(&new->k_i, bch2_keylist_front(&op->insert_keys));
 		bch2_cut_front(iter.pos, &new->k_i);
 
 		bch2_cut_front(iter.pos,	insert);
@@ -353,31 +420,11 @@ static int __bch2_data_update_index_update(struct btree_trans *trans,
 							.flags	= BCH_VALIDATE_commit,
 						 });
 		if (unlikely(invalid)) {
-			struct printbuf buf = PRINTBUF;
-			bch2_log_msg_start(c, &buf);
-
-			prt_str(&buf, "about to insert invalid key in data update path");
-			prt_printf(&buf, "\nop.nonce: %u", m->op.nonce);
-			prt_str(&buf, "\nold: ");
-			bch2_bkey_val_to_text(&buf, c, old);
-			prt_str(&buf, "\nk:   ");
-			bch2_bkey_val_to_text(&buf, c, k);
-			prt_str(&buf, "\nnew: ");
-			bch2_bkey_val_to_text(&buf, c, bkey_i_to_s_c(insert));
-
-			bch2_fs_emergency_read_only2(c, &buf);
-
-			bch2_print_str(c, KERN_ERR, buf.buf);
-			printbuf_exit(&buf);
-
-			ret = -BCH_ERR_invalid_bkey;
+			ret = data_update_invalid_bkey(m, old, k, insert);
 			goto out;
 		}
 
-		printbuf_reset(&journal_msg);
-		prt_str(&journal_msg, bch2_data_update_type_strs[m->type]);
-
-		ret =   bch2_trans_log_msg(trans, &journal_msg) ?:
+		ret =   bch2_trans_log_str(trans, bch2_data_update_type_strs[m->type]) ?:
 			bch2_trans_log_bkey(trans, m->btree_id, 0, m->k.k) ?:
 			bch2_insert_snapshot_whiteouts(trans, m->btree_id,
 						k.k->p, bkey_start_pos(&insert->k)) ?:
@@ -389,38 +436,12 @@ static int __bch2_data_update_index_update(struct btree_trans *trans,
 		if (ret)
 			goto err;
 
-		if (trace_data_update_enabled()) {
-			struct printbuf buf = PRINTBUF;
-
-			prt_str(&buf, "\nold: ");
-			bch2_bkey_val_to_text(&buf, c, old);
-			prt_str(&buf, "\nk:   ");
-			bch2_bkey_val_to_text(&buf, c, k);
-			prt_str(&buf, "\nnew: ");
-			bch2_bkey_val_to_text(&buf, c, bkey_i_to_s_c(insert));
-
-			trace_data_update(c, buf.buf);
-			printbuf_exit(&buf);
-		}
+		if (trace_data_update_enabled())
+			trace_data_update2(m, old, k, insert);
 
 		if (bch2_bkey_sectors_need_rebalance(c, bkey_i_to_s_c(insert)) * k.k->size >
-		    bch2_bkey_sectors_need_rebalance(c, k) * insert->k.size) {
-			struct printbuf buf = PRINTBUF;
-
-			bch2_data_update_opts_to_text(&buf, c, &m->op.opts, &m->data_opts);
-
-			prt_str(&buf, "\nold: ");
-			bch2_bkey_val_to_text(&buf, c, old);
-			prt_str(&buf, "\nk:   ");
-			bch2_bkey_val_to_text(&buf, c, k);
-			prt_str(&buf, "\nnew: ");
-			bch2_bkey_val_to_text(&buf, c, bkey_i_to_s_c(insert));
-
-			trace_io_move_created_rebalance(c, buf.buf);
-			printbuf_exit(&buf);
-
-			this_cpu_inc(c->counters[BCH_COUNTER_io_move_created_rebalance]);
-		}
+		    bch2_bkey_sectors_need_rebalance(c, k) * insert->k.size)
+			trace_io_move_created_rebalance2(m, old, k, insert);
 
 		ret =   bch2_trans_commit(trans, &op->res,
 				NULL,
@@ -441,9 +462,9 @@ static int __bch2_data_update_index_update(struct btree_trans *trans,
 		if (ret)
 			break;
 next:
-		while (bkey_ge(iter.pos, bch2_keylist_front(keys)->k.p)) {
-			bch2_keylist_pop_front(keys);
-			if (bch2_keylist_empty(keys))
+		while (bkey_ge(iter.pos, bch2_keylist_front(&op->insert_keys)->k.p)) {
+			bch2_keylist_pop_front(&op->insert_keys);
+			if (bch2_keylist_empty(&op->insert_keys))
 				goto out;
 		}
 		continue;
@@ -461,7 +482,6 @@ static int __bch2_data_update_index_update(struct btree_trans *trans,
 		goto next;
 	}
 out:
-	printbuf_exit(&journal_msg);
 	bch2_trans_iter_exit(trans, &iter);
 	BUG_ON(bch2_err_matches(ret, BCH_ERR_transaction_restart));
 	return ret;
-- 
2.49.0


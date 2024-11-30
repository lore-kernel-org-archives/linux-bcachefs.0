Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89D0B4594D
	for <linux-bcachefs@vger.kernel.org>; Sat, 30 Nov 2024 01:39:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732930782; cv=none; b=mz3qbspkCkvRQ2rgYUxMJ6WfjO1zr67piMZNUiSITR01DWi9u/ssq9NhZUAUey+8cFoLW8WD3UiZGkG7A7jDxlgSf8vFIauK0j9p2zNqO9oMHMRf/28tSrvUKGuMkQWGwJ7SoUIwuiSf/wow3DASXOzhibn15311ng9mSv23+5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732930782; c=relaxed/simple;
	bh=mu+PRy0nc4xt5iziH6Xmvi5IQ1keVTolx6MZ3sISs04=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Li9qK5zA2rnZfrSkjIOo+WIbLho/TMptVmDSaBDWohayISjeamIPvMxqJIX+R2QiUvsZHzhyvQhYI9j67qY7AfqJfSs005v0O2rGVkksftt9mlXyvbeAe8ysUVZXgJCqOHOyfgND/NsGHMhuW8i5FNeAinPeGbqABKAze8U7DO8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=hHepASsG; arc=none smtp.client-ip=91.218.175.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="hHepASsG"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1732930778;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GF767pKE1ajohTG3YCaxxllKOL43byiXD6UzYGUfe14=;
	b=hHepASsGG1P+2Lf96qvUifFl18J5U/ggurp6a15kBGg/hAgDWbrYvxePWiy2qKxIO0tLCC
	sUsrZHlyZuhqVyzfHvUkHp+UUdc6GErybwKZIxTdyk0b7SXgEUFU8JOGbTmCraZFQ64AHW
	C1hnXcNQ0i1CB9a4YtfEVQgQsc17GQw=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 7/8] bcachefs: bch2_backpointer_get_key() now repairs dangling backpointers
Date: Fri, 29 Nov 2024 20:39:19 -0500
Message-ID: <20241130013922.3135792-8-kent.overstreet@linux.dev>
In-Reply-To: <20241130013922.3135792-1-kent.overstreet@linux.dev>
References: <20241130013922.3135792-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Continuing on with the self healing theme, we should be running any
check and repair code at runtime that we can - instead of declaring the
filesystemt inconsistent.

This will also let us skip running the backpointers -> extents fsck pass
except in debug mode.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/backpointers.c | 66 +++++++++++++++-----------------------
 1 file changed, 25 insertions(+), 41 deletions(-)

diff --git a/fs/bcachefs/backpointers.c b/fs/bcachefs/backpointers.c
index 81dff1819cb8..72f3717131e9 100644
--- a/fs/bcachefs/backpointers.c
+++ b/fs/bcachefs/backpointers.c
@@ -171,9 +171,10 @@ int bch2_bucket_backpointer_mod_nowritebuffer(struct btree_trans *trans,
 
 static int bch2_backpointer_del(struct btree_trans *trans, struct bpos pos)
 {
-	return likely(!bch2_backpointers_no_use_write_buffer)
-	       ? bch2_btree_delete_at_buffered(trans, BTREE_ID_backpointers, pos)
-	       : bch2_btree_delete(trans, BTREE_ID_backpointers, pos, 0);
+	return (likely(!bch2_backpointers_no_use_write_buffer)
+		? bch2_btree_delete_at_buffered(trans, BTREE_ID_backpointers, pos)
+		: bch2_btree_delete(trans, BTREE_ID_backpointers, pos, 0)) ?:
+		 bch2_trans_commit(trans, NULL, NULL, BCH_TRANS_COMMIT_no_enospc);
 }
 
 static int bch2_backpointers_maybe_flush(struct btree_trans *trans,
@@ -185,20 +186,23 @@ static int bch2_backpointers_maybe_flush(struct btree_trans *trans,
 		: 0;
 }
 
-static void backpointer_target_not_found(struct btree_trans *trans,
-					 struct bkey_s_c_backpointer bp,
-					 struct bkey_s_c target_k)
+static int backpointer_target_not_found(struct btree_trans *trans,
+				  struct bkey_s_c_backpointer bp,
+				  struct bkey_s_c target_k,
+				  struct bkey_buf *last_flushed)
 {
 	struct bch_fs *c = trans->c;
 	struct printbuf buf = PRINTBUF;
+	int ret = 0;
 
 	/*
 	 * If we're using the btree write buffer, the backpointer we were
 	 * looking at may have already been deleted - failure to find what it
 	 * pointed to is not an error:
 	 */
-	if (likely(!bch2_backpointers_no_use_write_buffer))
-		return;
+	ret = bch2_backpointers_maybe_flush(trans, bp.s_c, last_flushed);
+	if (ret)
+		return ret;
 
 	prt_printf(&buf, "backpointer doesn't match %s it points to:\n  ",
 		   bp.v->level ? "btree node" : "extent");
@@ -206,12 +210,13 @@ static void backpointer_target_not_found(struct btree_trans *trans,
 	prt_printf(&buf, "\n  ");
 
 	bch2_bkey_val_to_text(&buf, c, target_k);
-	if (c->curr_recovery_pass >= BCH_RECOVERY_PASS_check_extents_to_backpointers)
-		bch_err_ratelimited(c, "%s", buf.buf);
-	else
-		bch2_trans_inconsistent(trans, "%s", buf.buf);
 
+	if (fsck_err(trans, backpointer_to_missing_ptr,
+		     "%s", buf.buf))
+		ret = bch2_backpointer_del(trans, bp.k->p);
+fsck_err:
 	printbuf_exit(&buf);
+	return ret;
 }
 
 struct bkey_s_c bch2_backpointer_get_key(struct btree_trans *trans,
@@ -242,15 +247,13 @@ struct bkey_s_c bch2_backpointer_get_key(struct btree_trans *trans,
 			return k;
 
 		bch2_trans_iter_exit(trans, iter);
-		backpointer_target_not_found(trans, bp, k);
-		return bkey_s_c_null;
+		int ret = backpointer_target_not_found(trans, bp, k, last_flushed);
+		return ret ? bkey_s_c_err(ret) : bkey_s_c_null;
 	} else {
 		struct btree *b = bch2_backpointer_get_node(trans, bp, iter, last_flushed);
+		if (IS_ERR_OR_NULL(b))
+			return ((struct bkey_s_c) { .k = ERR_CAST(b) });
 
-		if (IS_ERR_OR_NULL(b)) {
-			bch2_trans_iter_exit(trans, iter);
-			return IS_ERR(b) ? bkey_s_c_err(PTR_ERR(b)) : bkey_s_c_null;
-		}
 		return bkey_i_to_s_c(&b->key);
 	}
 }
@@ -283,8 +286,8 @@ struct btree *bch2_backpointer_get_node(struct btree_trans *trans,
 	if (btree_node_will_make_reachable(b)) {
 		b = ERR_PTR(-BCH_ERR_backpointer_to_overwritten_btree_node);
 	} else {
-		backpointer_target_not_found(trans, bp, bkey_i_to_s_c(&b->key));
-		b = NULL;
+		int ret = backpointer_target_not_found(trans, bp, bkey_i_to_s_c(&b->key), last_flushed);
+		b = ret ? ERR_PTR(ret) : NULL;
 	}
 err:
 	bch2_trans_iter_exit(trans, iter);
@@ -1100,9 +1103,7 @@ static int check_one_backpointer(struct btree_trans *trans,
 		return 0;
 
 	struct bkey_s_c_backpointer bp = bkey_s_c_to_backpointer(bp_k);
-	struct bch_fs *c = trans->c;
 	struct bbpos pos = bp_to_bbpos(*bp.v);
-	struct printbuf buf = PRINTBUF;
 
 	if (bbpos_cmp(pos, start) < 0 ||
 	    bbpos_cmp(pos, end) > 0)
@@ -1116,23 +1117,7 @@ static int check_one_backpointer(struct btree_trans *trans,
 	if (ret)
 		return ret;
 
-	if (!k.k) {
-		ret = bch2_backpointers_maybe_flush(trans, bp.s_c, last_flushed);
-		if (ret)
-			goto out;
-
-		if (fsck_err(trans, backpointer_to_missing_ptr,
-			     "backpointer for missing %s\n  %s",
-			     bp.v->level ? "btree node" : "extent",
-			     (bch2_bkey_val_to_text(&buf, c, bp.s_c), buf.buf))) {
-			ret = bch2_backpointer_del(trans, bp.k->p);
-			goto out;
-		}
-	}
-out:
-fsck_err:
 	bch2_trans_iter_exit(trans, &iter);
-	printbuf_exit(&buf);
 	return ret;
 }
 
@@ -1148,9 +1133,8 @@ static int bch2_check_backpointers_to_extents_pass(struct btree_trans *trans,
 	bkey_init(&last_flushed.k->k);
 	progress_init(&progress, trans->c, BIT_ULL(BTREE_ID_backpointers));
 
-	int ret = for_each_btree_key_commit(trans, iter, BTREE_ID_backpointers,
-				  POS_MIN, BTREE_ITER_prefetch, k,
-				  NULL, NULL, BCH_TRANS_COMMIT_no_enospc, ({
+	int ret = for_each_btree_key(trans, iter, BTREE_ID_backpointers,
+				     POS_MIN, BTREE_ITER_prefetch, k, ({
 			progress_update_iter(trans, &progress, &iter, "backpointers_to_extents");
 			check_one_backpointer(trans, start, end, k, &last_flushed);
 	}));
-- 
2.45.2


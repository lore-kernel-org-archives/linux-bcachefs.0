Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2BCE3BBEA
	for <linux-bcachefs@vger.kernel.org>; Mon, 18 Nov 2024 01:45:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731894316; cv=none; b=uqf6k3kR/m7R1ESAsemcwjPJvfeQXkdYwP1j1Rwq5cp7DDS0f5pTs4bHGsDWJ2fOTjvN0oknVHYKlKuuoXS25wkF7I0Qd+Ftd/SEeY1KgjXxeCFwcB9ZQ8EZJEDvVdxGWKcIVYBXjyuqnN63P/5bpOK8dP6El7wU7jGzcnsI1iA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731894316; c=relaxed/simple;
	bh=1JZVhdHNkSgEOpDFnBuiMmU6h5V3t+FGUCQz8uPRu1g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ibcaQIE6zABcKKpfL5DiGDrsuSQxmrY4xSufa+7ZAlK8RG2FVg3+MGy1kzWOUEaMCIZzfPgVsmLNxS7mM03OE+EGKK8Z6npSFvfENawcwdX3FTv9/f4ADte+ItgN1d/q3o9WwgX0v57BGfwzQq8TnJRdrA8vX0pRkPqCU5Vq+6M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=loXFKcAp; arc=none smtp.client-ip=91.218.175.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="loXFKcAp"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1731894313;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ME9RZhNzi0nSJqsPeWaYbP+sbNYA4l61DIFh2R/bbtU=;
	b=loXFKcApYu6VuiBAeD41UccQVf17qf+nXafe5W5/Xm2G1dxHj0dFPtPImfqnBvuMs/0Q0D
	WeAe8aXlRB5qymK3rg5UwjY+w2qSDm4TGpVpsSFMYY6hPkFMmm61639mY0IHa5DcdnLMI4
	oyuAWcArSVzfFhxREFUEskhtcsGYiys=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 7/7] bcachefs: New backpointers helpers
Date: Sun, 17 Nov 2024 20:44:48 -0500
Message-ID: <20241118014451.2275941-8-kent.overstreet@linux.dev>
In-Reply-To: <20241118014451.2275941-1-kent.overstreet@linux.dev>
References: <20241118014451.2275941-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

- bch2_backpointer_del()
- bch2_backpointer_maybe_flush()

Kill a bit of open coding and make sure we're properly handling the
btree write buffer.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/backpointers.c | 58 +++++++++++++++++++++++++++++---------
 1 file changed, 45 insertions(+), 13 deletions(-)

diff --git a/fs/bcachefs/backpointers.c b/fs/bcachefs/backpointers.c
index bd14900773d2..11d367662c8f 100644
--- a/fs/bcachefs/backpointers.c
+++ b/fs/bcachefs/backpointers.c
@@ -195,6 +195,22 @@ int bch2_bucket_backpointer_mod_nowritebuffer(struct btree_trans *trans,
 	return ret;
 }
 
+static int bch2_backpointer_del(struct btree_trans *trans, struct bpos pos)
+{
+	return likely(!bch2_backpointers_no_use_write_buffer)
+	       ? bch2_btree_delete_at_buffered(trans, BTREE_ID_backpointers, pos)
+	       : bch2_btree_delete(trans, BTREE_ID_backpointers, pos, 0);
+}
+
+static int bch2_backpointers_maybe_flush(struct btree_trans *trans,
+					 struct bkey_s_c visiting_k,
+					 struct bkey_buf *last_flushed)
+{
+	return likely(!bch2_backpointers_no_use_write_buffer)
+		? bch2_btree_write_buffer_maybe_flush(trans, visiting_k, last_flushed)
+		: 0;
+}
+
 static void backpointer_target_not_found(struct btree_trans *trans,
 					 struct bkey_s_c_backpointer bp,
 					 struct bkey_s_c target_k)
@@ -296,9 +312,12 @@ struct btree *bch2_backpointer_get_node(struct btree_trans *trans,
 	return b;
 }
 
-static int bch2_check_btree_backpointer(struct btree_trans *trans, struct btree_iter *bp_iter,
-					struct bkey_s_c k)
+static int bch2_check_backpointer_has_valid_bucket(struct btree_trans *trans, struct bkey_s_c k,
+						   struct bkey_buf *last_flushed)
 {
+	if (k.k->type != KEY_TYPE_backpointer)
+		return 0;
+
 	struct bch_fs *c = trans->c;
 	struct btree_iter alloc_iter = { NULL };
 	struct bkey_s_c alloc_k;
@@ -307,10 +326,14 @@ static int bch2_check_btree_backpointer(struct btree_trans *trans, struct btree_
 
 	struct bpos bucket;
 	if (!bp_pos_to_bucket_nodev_noerror(c, k.k->p, &bucket)) {
+		ret = bch2_backpointers_maybe_flush(trans, k, last_flushed);
+		if (ret)
+			goto out;
+
 		if (fsck_err(trans, backpointer_to_missing_device,
 			     "backpointer for missing device:\n%s",
 			     (bch2_bkey_val_to_text(&buf, c, k), buf.buf)))
-			ret = bch2_btree_delete_at(trans, bp_iter, 0);
+			ret = bch2_backpointer_del(trans, k.k->p);
 		goto out;
 	}
 
@@ -319,13 +342,16 @@ static int bch2_check_btree_backpointer(struct btree_trans *trans, struct btree_
 	if (ret)
 		goto out;
 
-	if (fsck_err_on(alloc_k.k->type != KEY_TYPE_alloc_v4,
-			trans, backpointer_to_missing_alloc,
-			"backpointer for nonexistent alloc key: %llu:%llu:0\n%s",
-			alloc_iter.pos.inode, alloc_iter.pos.offset,
-			(bch2_bkey_val_to_text(&buf, c, k), buf.buf))) {
-		ret = bch2_btree_delete_at(trans, bp_iter, 0);
-		goto out;
+	if (alloc_k.k->type != KEY_TYPE_alloc_v4) {
+		ret = bch2_backpointers_maybe_flush(trans, k, last_flushed);
+		if (ret)
+			goto out;
+
+		if (fsck_err(trans, backpointer_to_missing_alloc,
+			     "backpointer for nonexistent alloc key: %llu:%llu:0\n%s",
+			     alloc_iter.pos.inode, alloc_iter.pos.offset,
+			     (bch2_bkey_val_to_text(&buf, c, k), buf.buf)))
+			ret = bch2_backpointer_del(trans, k.k->p);
 	}
 out:
 fsck_err:
@@ -337,11 +363,17 @@ static int bch2_check_btree_backpointer(struct btree_trans *trans, struct btree_
 /* verify that every backpointer has a corresponding alloc key */
 int bch2_check_btree_backpointers(struct bch_fs *c)
 {
+	struct bkey_buf last_flushed;
+	bch2_bkey_buf_init(&last_flushed);
+	bkey_init(&last_flushed.k->k);
+
 	int ret = bch2_trans_run(c,
 		for_each_btree_key_commit(trans, iter,
 			BTREE_ID_backpointers, POS_MIN, 0, k,
 			NULL, NULL, BCH_TRANS_COMMIT_no_enospc,
-		  bch2_check_btree_backpointer(trans, &iter, k)));
+		  bch2_check_backpointer_has_valid_bucket(trans, k, &last_flushed)));
+
+	bch2_bkey_buf_exit(&last_flushed, c);
 	bch_err_fn(c, ret);
 	return ret;
 }
@@ -883,7 +915,7 @@ static int check_one_backpointer(struct btree_trans *trans,
 		return ret;
 
 	if (!k.k) {
-		ret = bch2_btree_write_buffer_maybe_flush(trans, bp.s_c, last_flushed);
+		ret = bch2_backpointers_maybe_flush(trans, bp.s_c, last_flushed);
 		if (ret)
 			goto out;
 
@@ -891,7 +923,7 @@ static int check_one_backpointer(struct btree_trans *trans,
 			     "backpointer for missing %s\n  %s",
 			     bp.v->level ? "btree node" : "extent",
 			     (bch2_bkey_val_to_text(&buf, c, bp.s_c), buf.buf))) {
-			ret = bch2_btree_delete_at_buffered(trans, BTREE_ID_backpointers, bp.k->p);
+			ret = bch2_backpointer_del(trans, bp.k->p);
 			goto out;
 		}
 	}
-- 
2.45.2


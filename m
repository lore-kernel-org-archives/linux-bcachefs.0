Received: from out-174.mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6933021CFEF
	for <linux-bcachefs@vger.kernel.org>; Wed, 18 Jun 2025 21:54:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750283692; cv=none; b=jffYyS1Divyyaj9EHDsGy3SoqaXj3fUP5Qv/yWEjSKKV1aSTv6TEfWAuJ60pl6nZMYGBcxu4WBuuk25bDVvvozizW7ny7RRvzG83ChvIIl9mLb6zYLdB8mbK+xi3sy3gJlH6xn/GRqlE0BpZEtlWOsfib/cUQAZwfPl1QaJr/w0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750283692; c=relaxed/simple;
	bh=VWx5HF0o3XSAtmmiuI7V/M3HBSpdY5Fh443HJxwgMuE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=irXAG8wgIcyaqRPJxYs54qkF3MmWBz5RJTz6X5hykW6fM0jAMDtvZqQtFaN7KJuuzQE9C/o5wd771WGLmdQRfpV9q+oo5iXE69fZHruNDYNJl35c1AaslwK3xHhPuzqm/q+NgheZ8zQapDKYuzSQJevOPYz7Vb234HcHMehJbMM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Pzwr+r8Y; arc=none smtp.client-ip=95.215.58.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Pzwr+r8Y"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1750283688;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RYk0qcNDS91fB3pYh0IztUj8heRfIXzNUlHA3rJIdok=;
	b=Pzwr+r8YCAallm/ZejJShdDMKSa4TawhNOiCOIJx1hiAYtIc74Oywb7CH5GXPooPJpFu17
	iKuZkNs64bfX5aANgXf+oHUEnuAuK3ufMQ8Po3RyY3rXX9PTT6TMo82VbtMr0FZm4ywjGU
	VIsBFCam6/9QjlfvriqI2SP0oCQOlvU=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 08/37] bcachefs: btree_iter: fix updates, journal overlay
Date: Wed, 18 Jun 2025 17:53:59 -0400
Message-ID: <20250618215431.738317-9-kent.overstreet@linux.dev>
In-Reply-To: <20250618215431.738317-1-kent.overstreet@linux.dev>
References: <20250618215431.738317-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

We need to start searching from search_key - _not_ path->pos, which will
point to the key we found in the btree

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/btree_iter.c | 29 +++++++++++++++++------------
 1 file changed, 17 insertions(+), 12 deletions(-)

diff --git a/fs/bcachefs/btree_iter.c b/fs/bcachefs/btree_iter.c
index e2747c57ba2a..061603999ae5 100644
--- a/fs/bcachefs/btree_iter.c
+++ b/fs/bcachefs/btree_iter.c
@@ -2076,14 +2076,14 @@ inline bool bch2_btree_iter_rewind(struct btree_trans *trans, struct btree_iter
 
 static noinline
 void bch2_btree_trans_peek_prev_updates(struct btree_trans *trans, struct btree_iter *iter,
-					struct bkey_s_c *k)
+					struct bpos search_key, struct bkey_s_c *k)
 {
 	struct bpos end = path_l(btree_iter_path(trans, iter))->b->data->min_key;
 
 	trans_for_each_update(trans, i)
 		if (!i->key_cache_already_flushed &&
 		    i->btree_id == iter->btree_id &&
-		    bpos_le(i->k->k.p, iter->pos) &&
+		    bpos_le(i->k->k.p, search_key) &&
 		    bpos_ge(i->k->k.p, k->k ? k->k->p : end)) {
 			iter->k = i->k->k;
 			*k = bkey_i_to_s_c(i->k);
@@ -2092,6 +2092,7 @@ void bch2_btree_trans_peek_prev_updates(struct btree_trans *trans, struct btree_
 
 static noinline
 void bch2_btree_trans_peek_updates(struct btree_trans *trans, struct btree_iter *iter,
+				   struct bpos search_key,
 				   struct bkey_s_c *k)
 {
 	struct btree_path *path = btree_iter_path(trans, iter);
@@ -2100,7 +2101,7 @@ void bch2_btree_trans_peek_updates(struct btree_trans *trans, struct btree_iter
 	trans_for_each_update(trans, i)
 		if (!i->key_cache_already_flushed &&
 		    i->btree_id == iter->btree_id &&
-		    bpos_ge(i->k->k.p, path->pos) &&
+		    bpos_ge(i->k->k.p, search_key) &&
 		    bpos_le(i->k->k.p, k->k ? k->k->p : end)) {
 			iter->k = i->k->k;
 			*k = bkey_i_to_s_c(i->k);
@@ -2122,13 +2123,14 @@ void bch2_btree_trans_peek_slot_updates(struct btree_trans *trans, struct btree_
 
 static struct bkey_i *bch2_btree_journal_peek(struct btree_trans *trans,
 					      struct btree_iter *iter,
+					      struct bpos search_pos,
 					      struct bpos end_pos)
 {
 	struct btree_path *path = btree_iter_path(trans, iter);
 
 	return bch2_journal_keys_peek_max(trans->c, iter->btree_id,
 					   path->level,
-					   path->pos,
+					   search_pos,
 					   end_pos,
 					   &iter->journal_idx);
 }
@@ -2138,7 +2140,7 @@ struct bkey_s_c btree_trans_peek_slot_journal(struct btree_trans *trans,
 					      struct btree_iter *iter)
 {
 	struct btree_path *path = btree_iter_path(trans, iter);
-	struct bkey_i *k = bch2_btree_journal_peek(trans, iter, path->pos);
+	struct bkey_i *k = bch2_btree_journal_peek(trans, iter, path->pos, path->pos);
 
 	if (k) {
 		iter->k = k->k;
@@ -2151,11 +2153,12 @@ struct bkey_s_c btree_trans_peek_slot_journal(struct btree_trans *trans,
 static noinline
 void btree_trans_peek_journal(struct btree_trans *trans,
 			      struct btree_iter *iter,
+			      struct bpos search_key,
 			      struct bkey_s_c *k)
 {
 	struct btree_path *path = btree_iter_path(trans, iter);
 	struct bkey_i *next_journal =
-		bch2_btree_journal_peek(trans, iter,
+		bch2_btree_journal_peek(trans, iter, search_key,
 				k->k ? k->k->p : path_l(path)->b->key.k.p);
 	if (next_journal) {
 		iter->k = next_journal->k;
@@ -2165,13 +2168,14 @@ void btree_trans_peek_journal(struct btree_trans *trans,
 
 static struct bkey_i *bch2_btree_journal_peek_prev(struct btree_trans *trans,
 					      struct btree_iter *iter,
+					      struct bpos search_key,
 					      struct bpos end_pos)
 {
 	struct btree_path *path = btree_iter_path(trans, iter);
 
 	return bch2_journal_keys_peek_prev_min(trans->c, iter->btree_id,
 					   path->level,
-					   path->pos,
+					   search_key,
 					   end_pos,
 					   &iter->journal_idx);
 }
@@ -2179,11 +2183,12 @@ static struct bkey_i *bch2_btree_journal_peek_prev(struct btree_trans *trans,
 static noinline
 void btree_trans_peek_prev_journal(struct btree_trans *trans,
 				   struct btree_iter *iter,
+				   struct bpos search_key,
 				   struct bkey_s_c *k)
 {
 	struct btree_path *path = btree_iter_path(trans, iter);
 	struct bkey_i *next_journal =
-		bch2_btree_journal_peek_prev(trans, iter,
+		bch2_btree_journal_peek_prev(trans, iter, search_key,
 				k->k ? k->k->p : path_l(path)->b->key.k.p);
 
 	if (next_journal) {
@@ -2292,11 +2297,11 @@ static struct bkey_s_c __bch2_btree_iter_peek(struct btree_trans *trans, struct
 		}
 
 		if (unlikely(iter->flags & BTREE_ITER_with_journal))
-			btree_trans_peek_journal(trans, iter, &k);
+			btree_trans_peek_journal(trans, iter, search_key, &k);
 
 		if (unlikely((iter->flags & BTREE_ITER_with_updates) &&
 			     trans->nr_updates))
-			bch2_btree_trans_peek_updates(trans, iter, &k);
+			bch2_btree_trans_peek_updates(trans, iter, search_key, &k);
 
 		if (k.k && bkey_deleted(k.k)) {
 			/*
@@ -2584,11 +2589,11 @@ static struct bkey_s_c __bch2_btree_iter_peek_prev(struct btree_trans *trans, st
 		}
 
 		if (unlikely(iter->flags & BTREE_ITER_with_journal))
-			btree_trans_peek_prev_journal(trans, iter, &k);
+			btree_trans_peek_prev_journal(trans, iter, search_key, &k);
 
 		if (unlikely((iter->flags & BTREE_ITER_with_updates) &&
 			     trans->nr_updates))
-			bch2_btree_trans_peek_prev_updates(trans, iter, &k);
+			bch2_btree_trans_peek_prev_updates(trans, iter, search_key, &k);
 
 		if (likely(k.k && !bkey_deleted(k.k))) {
 			break;
-- 
2.50.0


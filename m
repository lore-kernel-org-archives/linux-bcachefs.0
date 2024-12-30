Received: from out-187.mta0.migadu.com (out-187.mta0.migadu.com [91.218.175.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E20F61991CA
	for <linux-bcachefs@vger.kernel.org>; Mon, 30 Dec 2024 21:42:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735594981; cv=none; b=ncMgSKJyi9dhQJUi1g2ocW/tIdewEMpkV1G/DbneBKISR1aLSgOM+0dmm2Ou7Jzwp+4jxpp2t1CUF1VBJZXgDV4T0NsrryrwqSGxu7AuyVtlypuX2V+PErK8p1ArzM2tnoKiwPnGrdQHB08Rl3yGaXPQNgfoH5LBi3Lc5pIrzT8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735594981; c=relaxed/simple;
	bh=sQhIlXsSqqL28K64U1nCmyGAcmrSp3ArrVkV2NygV1U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PrhgwKSm+msYsnotxJ5DgaTjp0Fla8TG6fW+inOrlx5lfyXWEKLlo53FSPq+FeuxuQ0uIpYOaPodmNHKyV5VqjZe3p80hmgzmrBMgzsPe0T1K9PJyi0jAzzd1QTqiLgqvjBj8CJKNhJAEZfDFZdlfu7bgDeu9WkNz8DtQBssck4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=UQi2JNEB; arc=none smtp.client-ip=91.218.175.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="UQi2JNEB"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1735594978;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GNTwx2xesbCR/BqZyTJRrn58I3VCXSSo64Z6GcO64/I=;
	b=UQi2JNEBtRr8yq/+RBElzTCw2z+dyjguvJDknKeEwTR/dnAWIXE3XgBwVN+AIApTbagMBG
	3UPp/gqPafBrvjdA6dk12L0Zik0DPfmGjO14cYFL4PTb2PJlmw9vnwA+ekjjNu1wmZcc4y
	YqQHUx+elQpXOhqggz3D8oaQGmm3AJA=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 02/11] bcachefs: backpointer_get_key() doesn't pull in btree node
Date: Mon, 30 Dec 2024 16:42:40 -0500
Message-ID: <20241230214249.242966-2-kent.overstreet@linux.dev>
In-Reply-To: <20241230214249.242966-1-kent.overstreet@linux.dev>
References: <20241230214249.242966-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

We may not need to pull in a btree node when walking backpointers -
don't do so unnecessarily when using backpointer_get_key().

It'll still fall back to backpointer_get_node() in a few situations,
including btree roots (where an iterator can't point at just the key),
and races due to the interior update path not having deleted a
backpointer to an old node yet.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/backpointers.c | 34 +++++++++++++++++++---------------
 1 file changed, 19 insertions(+), 15 deletions(-)

diff --git a/fs/bcachefs/backpointers.c b/fs/bcachefs/backpointers.c
index ebeb6a5ff9d2..655be2332742 100644
--- a/fs/bcachefs/backpointers.c
+++ b/fs/bcachefs/backpointers.c
@@ -244,27 +244,31 @@ struct bkey_s_c bch2_backpointer_get_key(struct btree_trans *trans,
 	if (unlikely(bp.v->btree_id >= btree_id_nr_alive(c)))
 		return bkey_s_c_null;
 
-	if (likely(!bp.v->level)) {
-		bch2_trans_node_iter_init(trans, iter,
-					  bp.v->btree_id,
-					  bp.v->pos,
-					  0, 0,
-					  iter_flags);
-		struct bkey_s_c k = bch2_btree_iter_peek_slot(iter);
-		if (bkey_err(k)) {
-			bch2_trans_iter_exit(trans, iter);
-			return k;
-		}
+	bch2_trans_node_iter_init(trans, iter,
+				  bp.v->btree_id,
+				  bp.v->pos,
+				  0,
+				  bp.v->level,
+				  iter_flags);
+	struct bkey_s_c k = bch2_btree_iter_peek_slot(iter);
+	if (bkey_err(k)) {
+		bch2_trans_iter_exit(trans, iter);
+		return k;
+	}
 
-		if (k.k &&
-		    extent_matches_bp(c, bp.v->btree_id, bp.v->level, k, bp))
-			return k;
+	if (k.k &&
+	    extent_matches_bp(c, bp.v->btree_id, bp.v->level, k, bp))
+		return k;
 
-		bch2_trans_iter_exit(trans, iter);
+	bch2_trans_iter_exit(trans, iter);
+
+	if (!bp.v->level) {
 		int ret = backpointer_target_not_found(trans, bp, k, last_flushed);
 		return ret ? bkey_s_c_err(ret) : bkey_s_c_null;
 	} else {
 		struct btree *b = bch2_backpointer_get_node(trans, bp, iter, last_flushed);
+		if (b == ERR_PTR(-BCH_ERR_backpointer_to_overwritten_btree_node))
+			return bkey_s_c_null;
 		if (IS_ERR_OR_NULL(b))
 			return ((struct bkey_s_c) { .k = ERR_CAST(b) });
 
-- 
2.45.2


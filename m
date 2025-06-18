Received: from out-171.mta1.migadu.com (out-171.mta1.migadu.com [95.215.58.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1ABF827E7C1
	for <linux-bcachefs@vger.kernel.org>; Wed, 18 Jun 2025 21:55:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750283712; cv=none; b=oiupRzr+x+s6XNLW8DAmIwkIpF5+ezy670az8KRKmIEuu+JmytFpk7GAMaVO3aQutSvYa7ETHcoxszSYWmN7Yjh5uPT/kns5Aykc4Ky4HTJrWsg5GxHHK/JR+GfFc+L7wDdYttCO5OpryBsrbY/HYgpTWgQ4RlHXW3PQ1qnfw20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750283712; c=relaxed/simple;
	bh=A8B5bkCO7VlHgd1e5C0OYUIFhmfZlh3K1vH3Rprz1LM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hU9HF1AcCbuSHT8biNG/1eusiBMOifFbenGGcwiLeaG5ugMf+8yRxn5cqthzlhkehWJhfds3YWRReklVllMnmlDZ+4BcbtMydHf9FpmARj+/dgjcB0O5v0kebqtSiyAtuMoivr7J6mbcojkbY1rkJvJbW11tWKnN7HdWQ/bgZps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=eby/enV8; arc=none smtp.client-ip=95.215.58.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="eby/enV8"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1750283709;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3TLnRpLb8fWFva4bvtlqeEfVdnOiXuPfG9ruHelzo3s=;
	b=eby/enV82aAMWaDnxRZCGWNetL5RHVqaMZptamvMQwI03hgdgao3itlhYmlKSskhmgwwim
	hxiytAG9wSno7YchXAd27vUsNTtqsr7gaPKVzrT+GSwm2xKK2pApQj0Nkdg2n6RmmbTZYZ
	njpLapzDwc+vD/kMYZzrnWgu7+etJJg=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 32/37] bcachefs: Fix restart handling in btree_node_scrub_work()
Date: Wed, 18 Jun 2025 17:54:23 -0400
Message-ID: <20250618215431.738317-33-kent.overstreet@linux.dev>
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

btree node scrub was sometimes failing to rewrite nodes with errors;
bch2_btree_node_rewrite() can return a transaction restart and we
weren't checking - the lockrestart_do() needs to wrap the entire
operation.

And there's a better helper it should've been using,
bch2_btree_node_rewrite_key(), which makes all this more convenient.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/btree_io.c              | 28 ++++++----------------------
 fs/bcachefs/btree_update_interior.c | 11 +++++------
 fs/bcachefs/btree_update_interior.h |  3 +++
 3 files changed, 14 insertions(+), 28 deletions(-)

diff --git a/fs/bcachefs/btree_io.c b/fs/bcachefs/btree_io.c
index dca5530a2f49..08b22bddd747 100644
--- a/fs/bcachefs/btree_io.c
+++ b/fs/bcachefs/btree_io.c
@@ -1986,28 +1986,12 @@ static void btree_node_scrub_work(struct work_struct *work)
 	prt_newline(&err);
 
 	if (!btree_node_scrub_check(c, scrub->buf, scrub->written, &err)) {
-		struct btree_trans *trans = bch2_trans_get(c);
-
-		struct btree_iter iter;
-		bch2_trans_node_iter_init(trans, &iter, scrub->btree,
-					  scrub->key.k->k.p, 0, scrub->level - 1, 0);
-
-		struct btree *b;
-		int ret = lockrestart_do(trans,
-			PTR_ERR_OR_ZERO(b = bch2_btree_iter_peek_node(trans, &iter)));
-		if (ret)
-			goto err;
-
-		if (bkey_i_to_btree_ptr_v2(&b->key)->v.seq == scrub->seq) {
-			bch_err(c, "error validating btree node during scrub on %s at btree %s",
-				scrub->ca->name, err.buf);
-
-			ret = bch2_btree_node_rewrite(trans, &iter, b, 0, 0);
-		}
-err:
-		bch2_trans_iter_exit(trans, &iter);
-		bch2_trans_begin(trans);
-		bch2_trans_put(trans);
+		int ret = bch2_trans_do(c,
+			bch2_btree_node_rewrite_key(trans, scrub->btree, scrub->level - 1,
+						    scrub->key.k, 0));
+		if (!bch2_err_matches(ret, ENOENT) &&
+		    !bch2_err_matches(ret, EROFS))
+			bch_err_fn_ratelimited(c, ret);
 	}
 
 	printbuf_exit(&err);
diff --git a/fs/bcachefs/btree_update_interior.c b/fs/bcachefs/btree_update_interior.c
index e77584607f0d..7bf1bd6a6e92 100644
--- a/fs/bcachefs/btree_update_interior.c
+++ b/fs/bcachefs/btree_update_interior.c
@@ -2293,9 +2293,9 @@ int bch2_btree_node_rewrite(struct btree_trans *trans,
 	goto out;
 }
 
-static int bch2_btree_node_rewrite_key(struct btree_trans *trans,
-				       enum btree_id btree, unsigned level,
-				       struct bkey_i *k, unsigned flags)
+int bch2_btree_node_rewrite_key(struct btree_trans *trans,
+				enum btree_id btree, unsigned level,
+				struct bkey_i *k, unsigned flags)
 {
 	struct btree_iter iter;
 	bch2_trans_node_iter_init(trans, &iter,
@@ -2367,9 +2367,8 @@ static void async_btree_node_rewrite_work(struct work_struct *work)
 
 	int ret = bch2_trans_do(c, bch2_btree_node_rewrite_key(trans,
 						a->btree_id, a->level, a->key.k, 0));
-	if (ret != -ENOENT &&
-	    !bch2_err_matches(ret, EROFS) &&
-	    ret != -BCH_ERR_journal_shutdown)
+	if (!bch2_err_matches(ret, ENOENT) &&
+	    !bch2_err_matches(ret, EROFS))
 		bch_err_fn_ratelimited(c, ret);
 
 	spin_lock(&c->btree_node_rewrites_lock);
diff --git a/fs/bcachefs/btree_update_interior.h b/fs/bcachefs/btree_update_interior.h
index b649c36c3fbb..ac04e45a8515 100644
--- a/fs/bcachefs/btree_update_interior.h
+++ b/fs/bcachefs/btree_update_interior.h
@@ -176,6 +176,9 @@ static inline int bch2_foreground_maybe_merge(struct btree_trans *trans,
 
 int bch2_btree_node_rewrite(struct btree_trans *, struct btree_iter *,
 			    struct btree *, unsigned, unsigned);
+int bch2_btree_node_rewrite_key(struct btree_trans *,
+				enum btree_id, unsigned,
+				struct bkey_i *, unsigned);
 int bch2_btree_node_rewrite_pos(struct btree_trans *,
 				enum btree_id, unsigned,
 				struct bpos, unsigned, unsigned);
-- 
2.50.0


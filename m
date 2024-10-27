Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEC556FB6
	for <linux-bcachefs@vger.kernel.org>; Sun, 27 Oct 2024 00:51:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729990321; cv=none; b=VGTpWBdZCZ4C/nJCxMnQq8sGjC3w2dENidqYRTShhOUTOM4RIr3r0Ay4kI7E+7thWyaG4lkNe7dQub2XCoK9Tu/qoV7ddDqxn9yvq72JReSr9gqt6Fkf+vNTSNYR/RhVXTgq9MgHQZymqB4+jC2vtIPAFIqXJVGfPg0hhpDSYWU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729990321; c=relaxed/simple;
	bh=2O1PN4gVdSzNgmE6jpyy01a7ayHDsy76Ftpppg2C/CY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CxYXGdR7iiB0DeZ6FMEN+v39uVORKuFO5Cq4XKxnzbuaO/0KWszri5mN0KgbWVYaIwRgTUEsZRDvPFiA+6wmg4dl3yn5S9T2OCoinnUAEWPJlNUFrmunz2G2djUc4LWRlHJqD6AZ+RTLdXLh84h6TpZCn9aqZr2i/WcSzhxe2Xk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=qNgRHu78; arc=none smtp.client-ip=95.215.58.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="qNgRHu78"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1729990317;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QLRI6qYUEHHskurpOOIhpL7V2QGvc7iNqiR55gXkYU0=;
	b=qNgRHu78vZUfE/x2FZWXyDMHQTpcHWLecW46ITTeorRqmjYI4dEN3ad8y1ra1rsA0MgP5M
	4jhwQEQn1dzn3lk7FUtIfb+sDhzgEWI8+Vf982hQqYUOCzclln7PRyEJA4VebvdkDFjTrV
	LUcgM7Gc73vywsNuSlKN4sca4B5nEQg=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 6/9] bcachefs: Simplify btree_iter_peek() filter_snapshots
Date: Sat, 26 Oct 2024 20:51:35 -0400
Message-ID: <20241027005141.2337634-7-kent.overstreet@linux.dev>
In-Reply-To: <20241027005141.2337634-1-kent.overstreet@linux.dev>
References: <20241027005141.2337634-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Collapse all the BTREE_ITER_filter_snapshots handling down into a single
block; btree iteration is much simpler in the !filter_snapshots case.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/btree_iter.c | 129 +++++++++++++++++++--------------------
 1 file changed, 62 insertions(+), 67 deletions(-)

diff --git a/fs/bcachefs/btree_iter.c b/fs/bcachefs/btree_iter.c
index 78e370c2b790..e16dbf431c10 100644
--- a/fs/bcachefs/btree_iter.c
+++ b/fs/bcachefs/btree_iter.c
@@ -1837,7 +1837,6 @@ struct bkey_s_c bch2_btree_path_peek_slot(struct btree_path *path, struct bkey *
 	return (struct bkey_s_c) { u, NULL };
 }
 
-
 void bch2_set_btree_iter_dontneed(struct btree_iter *iter)
 {
 	struct btree_trans *trans = iter->trans;
@@ -2195,8 +2194,6 @@ static struct bkey_s_c __bch2_btree_iter_peek(struct btree_iter *iter, struct bp
 	bch2_btree_iter_verify(iter);
 
 	while (1) {
-		struct btree_path_level *l;
-
 		iter->path = bch2_btree_path_set_pos(trans, iter->path, search_key,
 					iter->flags & BTREE_ITER_intent,
 					btree_iter_ip_allocated(iter));
@@ -2210,7 +2207,7 @@ static struct bkey_s_c __bch2_btree_iter_peek(struct btree_iter *iter, struct bp
 		}
 
 		struct btree_path *path = btree_iter_path(trans, iter);
-		l = path_l(path);
+		struct btree_path_level *l = path_l(path);
 
 		if (unlikely(!l->b)) {
 			/* No btree nodes at requested level: */
@@ -2286,10 +2283,11 @@ struct bkey_s_c bch2_btree_iter_peek_max(struct btree_iter *iter, struct bpos en
 	struct btree_trans *trans = iter->trans;
 	struct bpos search_key = btree_iter_search_key(iter);
 	struct bkey_s_c k;
-	struct bpos iter_pos;
+	struct bpos iter_pos = iter->pos;
 	int ret;
 
 	bch2_trans_verify_not_unlocked(trans);
+	bch2_btree_iter_verify_entry_exit(iter);
 	EBUG_ON((iter->flags & BTREE_ITER_filter_snapshots) && bkey_eq(end, POS_MAX));
 
 	ret = trans_maybe_inject_restart(trans, _RET_IP_);
@@ -2304,8 +2302,6 @@ struct bkey_s_c bch2_btree_iter_peek_max(struct btree_iter *iter, struct bpos en
 		iter->update_path = 0;
 	}
 
-	bch2_btree_iter_verify_entry_exit(iter);
-
 	while (1) {
 		k = __bch2_btree_iter_peek(iter, search_key);
 		if (unlikely(!k.k))
@@ -2313,75 +2309,74 @@ struct bkey_s_c bch2_btree_iter_peek_max(struct btree_iter *iter, struct bpos en
 		if (unlikely(bkey_err(k)))
 			goto out_no_locked;
 
-		/*
-		 * We need to check against @end before FILTER_SNAPSHOTS because
-		 * if we get to a different inode that requested we might be
-		 * seeing keys for a different snapshot tree that will all be
-		 * filtered out.
-		 *
-		 * But we can't do the full check here, because bkey_start_pos()
-		 * isn't monotonically increasing before FILTER_SNAPSHOTS, and
-		 * that's what we check against in extents mode:
-		 */
-		if (unlikely(!(iter->flags & BTREE_ITER_is_extents)
-			     ? bkey_gt(k.k->p, end)
-			     : k.k->p.inode > end.inode))
-			goto end;
+		if (iter->flags & BTREE_ITER_filter_snapshots) {
+			/*
+			 * We need to check against @end before FILTER_SNAPSHOTS because
+			 * if we get to a different inode that requested we might be
+			 * seeing keys for a different snapshot tree that will all be
+			 * filtered out.
+			 *
+			 * But we can't do the full check here, because bkey_start_pos()
+			 * isn't monotonically increasing before FILTER_SNAPSHOTS, and
+			 * that's what we check against in extents mode:
+			 */
+			if (unlikely(!(iter->flags & BTREE_ITER_is_extents)
+				     ? bkey_gt(k.k->p, end)
+				     : k.k->p.inode > end.inode))
+				goto end;
+
+			if (iter->update_path &&
+			    !bkey_eq(trans->paths[iter->update_path].pos, k.k->p)) {
+				bch2_path_put_nokeep(trans, iter->update_path,
+						     iter->flags & BTREE_ITER_intent);
+				iter->update_path = 0;
+			}
 
-		if (iter->update_path &&
-		    !bkey_eq(trans->paths[iter->update_path].pos, k.k->p)) {
-			bch2_path_put_nokeep(trans, iter->update_path,
-					     iter->flags & BTREE_ITER_intent);
-			iter->update_path = 0;
-		}
+			if ((iter->flags & BTREE_ITER_intent) &&
+			    !(iter->flags & BTREE_ITER_is_extents) &&
+			    !iter->update_path) {
+				struct bpos pos = k.k->p;
 
-		if ((iter->flags & BTREE_ITER_filter_snapshots) &&
-		    (iter->flags & BTREE_ITER_intent) &&
-		    !(iter->flags & BTREE_ITER_is_extents) &&
-		    !iter->update_path) {
-			struct bpos pos = k.k->p;
+				if (pos.snapshot < iter->snapshot) {
+					search_key = bpos_successor(k.k->p);
+					continue;
+				}
 
-			if (pos.snapshot < iter->snapshot) {
-				search_key = bpos_successor(k.k->p);
-				continue;
-			}
+				pos.snapshot = iter->snapshot;
 
-			pos.snapshot = iter->snapshot;
+				/*
+				 * advance, same as on exit for iter->path, but only up
+				 * to snapshot
+				 */
+				__btree_path_get(trans, trans->paths + iter->path, iter->flags & BTREE_ITER_intent);
+				iter->update_path = iter->path;
+
+				iter->update_path = bch2_btree_path_set_pos(trans,
+							iter->update_path, pos,
+							iter->flags & BTREE_ITER_intent,
+							_THIS_IP_);
+				ret = bch2_btree_path_traverse(trans, iter->update_path, iter->flags);
+				if (unlikely(ret)) {
+					k = bkey_s_c_err(ret);
+					goto out_no_locked;
+				}
+			}
 
 			/*
-			 * advance, same as on exit for iter->path, but only up
-			 * to snapshot
+			 * We can never have a key in a leaf node at POS_MAX, so
+			 * we don't have to check these successor() calls:
 			 */
-			__btree_path_get(trans, trans->paths + iter->path, iter->flags & BTREE_ITER_intent);
-			iter->update_path = iter->path;
-
-			iter->update_path = bch2_btree_path_set_pos(trans,
-						iter->update_path, pos,
-						iter->flags & BTREE_ITER_intent,
-						_THIS_IP_);
-			ret = bch2_btree_path_traverse(trans, iter->update_path, iter->flags);
-			if (unlikely(ret)) {
-				k = bkey_s_c_err(ret);
-				goto out_no_locked;
+			if (!bch2_snapshot_is_ancestor(trans->c,
+						       iter->snapshot,
+						       k.k->p.snapshot)) {
+				search_key = bpos_successor(k.k->p);
+				continue;
 			}
-		}
 
-		/*
-		 * We can never have a key in a leaf node at POS_MAX, so
-		 * we don't have to check these successor() calls:
-		 */
-		if ((iter->flags & BTREE_ITER_filter_snapshots) &&
-		    !bch2_snapshot_is_ancestor(trans->c,
-					       iter->snapshot,
-					       k.k->p.snapshot)) {
-			search_key = bpos_successor(k.k->p);
-			continue;
-		}
-
-		if (bkey_whiteout(k.k) &&
-		    !(iter->flags & BTREE_ITER_all_snapshots)) {
-			search_key = bkey_successor(iter, k.k->p);
-			continue;
+			if (bkey_whiteout(k.k)) {
+				search_key = bkey_successor(iter, k.k->p);
+				continue;
+			}
 		}
 
 		/*
-- 
2.45.2


Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8423C1EB18E
	for <linux-bcachefs@vger.kernel.org>; Fri,  2 May 2025 20:00:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746216016; cv=none; b=QEFNaTdxSCBbTks8pbOrqSQWquogO41fJGtMDWuvzRmFbJM9nLTn1bXKu96bJeSoeu1SNEkaEDaliBBEOU9g4gQh5v30xUcWekiMCznuZ6WTESSLxWIktHHKH2+F6dwcqaY2WdQuaPwWNGZuQpV6CsPL/hyNWC182dakdUmEKYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746216016; c=relaxed/simple;
	bh=1k/qLvfk5Gpy98xthVQ1JPV5K5pWtiv6CS8I/dN1uKs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=du840YrCrtK/eDhNOkBtkuFnfCU/fUKZ5QLYGh3J/WTkJm41T4DtmnqyugY3mAPIlpdl/BSss8zu4XX+xG+T97NkqydwFfg7jWxMe5qxjqEk45fzx7iMf6A5XTFJjXahD7roJwBJWEGalCdFATeQWqM25lq02sxs9V16kcMZpYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=HtEJJu5m; arc=none smtp.client-ip=91.218.175.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="HtEJJu5m"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1746216012;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UReUCsLGNEVLao4OCJWiFeZpqM6wWN3x9UsUAyCZv4U=;
	b=HtEJJu5mjs5w3XtaV3C/aYZYgZmTXLepn67CcXJSx4mNelhkM9umx8DSM47LexRCewWwxm
	GDBb5u8o9/jSoj922iW1qhK7SwB5H193EFKjmxZmnTm0JLN2b8uTMPUfy9Pit52iKFgrx1
	3XApM+3fD3G7nREK0VyAgMhtuDFVdes=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 5/8] bcachefs: Skip unrelated snapshot trees in snapshot deletion
Date: Fri,  2 May 2025 15:59:57 -0400
Message-ID: <20250502200002.1309862-6-kent.overstreet@linux.dev>
In-Reply-To: <20250502200002.1309862-1-kent.overstreet@linux.dev>
References: <20250502200002.1309862-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Don't scan keys in inodes for which the snapshot tree doesn't match any
we're deleting from.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/snapshot.c       | 35 +++++++++++++++++++++++++++++++++--
 fs/bcachefs/snapshot_types.h |  1 +
 2 files changed, 34 insertions(+), 2 deletions(-)

diff --git a/fs/bcachefs/snapshot.c b/fs/bcachefs/snapshot.c
index 2f2f129ce482..219cba038778 100644
--- a/fs/bcachefs/snapshot.c
+++ b/fs/bcachefs/snapshot.c
@@ -1432,6 +1432,24 @@ static int delete_dead_snapshots_process_key(struct btree_trans *trans,
 	return 0;
 }
 
+static bool skip_unrelated_snapshot_tree(struct btree_trans *trans, struct btree_iter *iter)
+{
+	struct bch_fs *c = trans->c;
+	struct snapshot_delete *d = &c->snapshot_delete;
+
+	bool ret = !snapshot_list_has_id(&d->deleting_from_trees,
+					 bch2_snapshot_tree(c, iter->pos.snapshot));
+	if (unlikely(ret)) {
+		struct bpos pos = iter->pos;
+		pos.snapshot = 0;
+		if (iter->btree_id != BTREE_ID_inodes)
+			pos.offset = U64_MAX;
+		bch2_btree_iter_set_pos(trans, iter, bpos_nosnap_successor(pos));
+	}
+
+	return ret;
+}
+
 /*
  * For a given snapshot, if it doesn't have a subvolume that points to it, and
  * it doesn't have child snapshot nodes - it's now redundant and we can mark it
@@ -1457,8 +1475,11 @@ static int check_should_delete_snapshot(struct btree_trans *trans, struct bkey_s
 			!snapshot_list_has_id(&d->delete_leaves, child);
 	}
 
+	u32 tree = bch2_snapshot_tree(c, s.k->p.offset);
+
 	if (live_children == 0) {
-		return snapshot_list_add(c, &d->delete_leaves, s.k->p.offset);
+		return  snapshot_list_add_nodup(c, &d->deleting_from_trees, tree) ?:
+			snapshot_list_add(c, &d->delete_leaves, s.k->p.offset);
 	} else if (live_children == 1) {
 		struct snapshot_interior_delete n = {
 			.id		= s.k->p.offset,
@@ -1470,7 +1491,8 @@ static int check_should_delete_snapshot(struct btree_trans *trans, struct bkey_s
 			return -EINVAL;
 		}
 
-		return darray_push(&d->delete_interior, n);
+		return  snapshot_list_add_nodup(c, &d->deleting_from_trees, tree) ?:
+			darray_push(&d->delete_interior, n);
 	} else {
 		return 0;
 	}
@@ -1551,6 +1573,10 @@ static int bch2_fix_child_of_deleted_snapshot(struct btree_trans *trans,
 
 static void bch2_snapshot_delete_nodes_to_text(struct printbuf *out, struct snapshot_delete *d)
 {
+	prt_printf(out, "deleting from trees");
+	darray_for_each(d->deleting_from_trees, i)
+		prt_printf(out, " %u", *i);
+
 	prt_printf(out, "deleting leaves");
 	darray_for_each(d->delete_leaves, i)
 		prt_printf(out, " %u", *i);
@@ -1611,6 +1637,10 @@ int bch2_delete_dead_snapshots(struct bch_fs *c)
 				BTREE_ITER_prefetch|BTREE_ITER_all_snapshots, k,
 				&res, NULL, BCH_TRANS_COMMIT_no_enospc, ({
 			d->pos.pos = iter.pos;
+
+			if (skip_unrelated_snapshot_tree(trans, &iter))
+				continue;
+
 			delete_dead_snapshots_process_key(trans, &iter, k);
 		}));
 
@@ -1653,6 +1683,7 @@ int bch2_delete_dead_snapshots(struct bch_fs *c)
 	}
 err:
 	mutex_lock(&d->lock);
+	darray_exit(&d->deleting_from_trees);
 	darray_exit(&d->delete_interior);
 	darray_exit(&d->delete_leaves);
 	d->running = false;
diff --git a/fs/bcachefs/snapshot_types.h b/fs/bcachefs/snapshot_types.h
index bb67a6beb6e3..39fb47f43183 100644
--- a/fs/bcachefs/snapshot_types.h
+++ b/fs/bcachefs/snapshot_types.h
@@ -15,6 +15,7 @@ struct snapshot_delete {
 	struct work_struct	work;
 
 	struct mutex		lock;
+	snapshot_id_list	deleting_from_trees;
 	snapshot_id_list	delete_leaves;
 	interior_delete_list	delete_interior;
 
-- 
2.49.0


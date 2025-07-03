Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E930275AEF
	for <linux-bcachefs@vger.kernel.org>; Thu,  3 Jul 2025 23:17:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751584670; cv=none; b=mVwyDK/VbaI7p3RMW/LKPEKGxhcfnRFaYRNcJR9QzGKKpia6S377uDSkzRv7xuWVtIzk6vlYy7BUqCcr/huYA9eqtVDsmLv6KKoBdLsR/UWB3203pQw7+mNHseI5LiW5N23cT2/Gpq+03AYMsJ8ezTaLXYhYIwB6m1GNULBWvJk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751584670; c=relaxed/simple;
	bh=aG1t3lDDdHLZM1GiJBo129Cy6KbEeQWu673JuIK75hM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=J2bR3zQBO/By+hFfZ+m3ahbU0r5HwVCl/3Sscx33AcXvUMftMP+3Fqfh4o2M8GT1qSaUNsa2LLjopAtR6VRFp7WOciuwOnAWNJ+UY9Zfr60X0NTV7IdhASthpT0k4o8Qc0hq6SBozj2MOrnoqKB0tHFqwqQJHOKuco2f9E7IBBc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=t8IT7qQD; arc=none smtp.client-ip=91.218.175.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="t8IT7qQD"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1751584665;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=RuFh9YGGZLmMUOknf8SyknFFjWzpCNU8SN2dWAFNgY8=;
	b=t8IT7qQD2HUFdjDKnSmfuINkijgEyxH4bIdnh05ssZXqB4iKgCoJshnlWFAxD8bNqnaLZp
	/RqYie9HoK6wp7CjU5xpeimwsLNNhjJ8F6L3je25TV2U5HulEzUIUpbIZxsgRrdV+S7l0l
	C+rXB9C9t92pLIazZB8eTE7g9JGqiRc=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>,
	Nikita Ofitserov <himikof@gmail.com>
Subject: [PATCH 1/2] bcachefs: Tweak btree cache helpers for use by btree node scan
Date: Thu,  3 Jul 2025 19:17:39 -0400
Message-ID: <20250703231740.248219-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

btree node scan needs to not use the btree node cache: that causes
interference from prior failed reads and parallel workers.

Instead we need to allocate btree nodes that don't live in the btree
cache, so that we can call bch2_btree_node_read_done() directly.

This patch tweaks the low level helpers so they don't touch the btree
cache lists.

Cc: Nikita Ofitserov <himikof@gmail.com>
Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/btree_cache.c | 21 ++++++++++++---------
 fs/bcachefs/btree_cache.h |  1 +
 fs/bcachefs/debug.c       |  2 --
 3 files changed, 13 insertions(+), 11 deletions(-)

diff --git a/fs/bcachefs/btree_cache.c b/fs/bcachefs/btree_cache.c
index a3631a903ecf..702c8f7081d7 100644
--- a/fs/bcachefs/btree_cache.c
+++ b/fs/bcachefs/btree_cache.c
@@ -86,7 +86,7 @@ void bch2_btree_node_to_freelist(struct bch_fs *c, struct btree *b)
 	six_unlock_intent(&b->c.lock);
 }
 
-static void __btree_node_data_free(struct btree_cache *bc, struct btree *b)
+void __btree_node_data_free(struct btree *b)
 {
 	BUG_ON(!list_empty(&b->list));
 	BUG_ON(btree_node_hashed(b));
@@ -113,16 +113,17 @@ static void __btree_node_data_free(struct btree_cache *bc, struct btree *b)
 	munmap(b->aux_data, btree_aux_data_bytes(b));
 #endif
 	b->aux_data = NULL;
-
-	btree_node_to_freedlist(bc, b);
 }
 
 static void btree_node_data_free(struct btree_cache *bc, struct btree *b)
 {
 	BUG_ON(list_empty(&b->list));
 	list_del_init(&b->list);
+
+	__btree_node_data_free(b);
+
 	--bc->nr_freeable;
-	__btree_node_data_free(bc, b);
+	btree_node_to_freedlist(bc, b);
 }
 
 static int bch2_btree_cache_cmp_fn(struct rhashtable_compare_arg *arg,
@@ -199,8 +200,6 @@ struct btree *__bch2_btree_node_mem_alloc(struct bch_fs *c)
 	}
 
 	bch2_btree_lock_init(&b->c, 0, GFP_KERNEL);
-
-	__bch2_btree_node_to_freelist(bc, b);
 	return b;
 }
 
@@ -526,7 +525,8 @@ static unsigned long bch2_btree_cache_scan(struct shrinker *shrink,
 			--touched;;
 		} else if (!btree_node_reclaim(c, b)) {
 			__bch2_btree_node_hash_remove(bc, b);
-			__btree_node_data_free(bc, b);
+			__btree_node_data_free(b);
+			btree_node_to_freedlist(bc, b);
 
 			freed++;
 			bc->nr_freed++;
@@ -667,9 +667,12 @@ int bch2_fs_btree_cache_init(struct bch_fs *c)
 
 	bch2_recalc_btree_reserve(c);
 
-	for (i = 0; i < bc->nr_reserve; i++)
-		if (!__bch2_btree_node_mem_alloc(c))
+	for (i = 0; i < bc->nr_reserve; i++) {
+		struct btree *b = __bch2_btree_node_mem_alloc(c);
+		if (!b)
 			goto err;
+		__bch2_btree_node_to_freelist(bc, b);
+	}
 
 	list_splice_init(&bc->live[0].list, &bc->freeable);
 
diff --git a/fs/bcachefs/btree_cache.h b/fs/bcachefs/btree_cache.h
index 3264801cbcbe..649e9dfd178a 100644
--- a/fs/bcachefs/btree_cache.h
+++ b/fs/bcachefs/btree_cache.h
@@ -30,6 +30,7 @@ void bch2_btree_node_update_key_early(struct btree_trans *, enum btree_id, unsig
 void bch2_btree_cache_cannibalize_unlock(struct btree_trans *);
 int bch2_btree_cache_cannibalize_lock(struct btree_trans *, struct closure *);
 
+void __btree_node_data_free(struct btree *);
 struct btree *__bch2_btree_node_mem_alloc(struct bch_fs *);
 struct btree *bch2_btree_node_mem_alloc(struct btree_trans *, bool);
 
diff --git a/fs/bcachefs/debug.c b/fs/bcachefs/debug.c
index 901f643ead83..79d64052215c 100644
--- a/fs/bcachefs/debug.c
+++ b/fs/bcachefs/debug.c
@@ -153,8 +153,6 @@ void __bch2_btree_verify(struct bch_fs *c, struct btree *b)
 		c->verify_data = __bch2_btree_node_mem_alloc(c);
 		if (!c->verify_data)
 			goto out;
-
-		list_del_init(&c->verify_data->list);
 	}
 
 	BUG_ON(b->nsets != 1);
-- 
2.50.0


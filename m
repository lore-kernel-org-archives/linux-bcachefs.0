Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45FDB2D46C3
	for <linux-bcachefs@vger.kernel.org>; Thu,  3 Jul 2025 23:17:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751584671; cv=none; b=uIYl973VETag10HDcM+xtzVFx9Rv+e69IcCot0j8fTX/TY7jC0/JEcDwomNZ8ro5Ghw2sBM4TNClfMyG2R62nGo3YYQAuuP9XbcaTTuWzwvY5b8fi0GnBG6N+tjO9uirYV18xDlZ+NC93n7kOWZQMp3FGomNaqrolum6wSJIhXk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751584671; c=relaxed/simple;
	bh=tLlL5noP7AdebCL2WEnyrpI0PXgi9Ng3/b2Bli7+dvw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C/534NjpUbFY9fdKVQzrTvbuPj96gdQZt/Tw9dx8KFkr2E2LT24/UdLH8XHQWOFPWb+lXtrrR22+g7n7bXNKJsqdy9KKIedIeHNVLbu3bCe4/IEBaWYzJZiqc/YN2RS4U3fEZ+Oqr5dQgCHko2WmyvOEOa+VLAzLrTveGxKu/uA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=JWGb26HU; arc=none smtp.client-ip=91.218.175.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="JWGb26HU"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1751584666;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VTx+NL06nIvBM1wp38J5qUwwvbmwF2zFqTNvMKcL7+E=;
	b=JWGb26HUkiYeBggBh6Ne7bDuVhNPMtZwfPpvCnDK+gjomkbkhnqAz6/kZYHpsPpmv3dAV/
	Pd7Rk+o3IYJBeq3Va8MvAlaHq/lAwbIA2JhaJjiw7Xtta5/4ybI3ooLFTD2oX1JioWZEMK
	s3sNoIZmR6izu4L4GcZaNVbvwkXx90A=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>,
	Nikita Ofitserov <himikof@gmail.com>
Subject: [PATCH 2/2] bcachefs: btree node scan no longer uses btree cache
Date: Thu,  3 Jul 2025 19:17:40 -0400
Message-ID: <20250703231740.248219-2-kent.overstreet@linux.dev>
In-Reply-To: <20250703231740.248219-1-kent.overstreet@linux.dev>
References: <20250703231740.248219-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Previously, btree node scan used the btree node cache to check if btree
nodes were readable, but this is subject to interference from threads
scanning different devices trying to read the same node - and more
critically, nodes that we already attempted and failed to read before
kicking off scan.

Instead, we now allocate a 'struct btree' that does not live in the
btree node cache, and call bch2_btree_node_read_done() directly.

Cc: Nikita Ofitserov <himikof@gmail.com>
Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/btree_node_scan.c | 70 ++++++++++++++---------------------
 1 file changed, 27 insertions(+), 43 deletions(-)

diff --git a/fs/bcachefs/btree_node_scan.c b/fs/bcachefs/btree_node_scan.c
index 23d8c62ea4b6..69edeb3b38f9 100644
--- a/fs/bcachefs/btree_node_scan.c
+++ b/fs/bcachefs/btree_node_scan.c
@@ -75,39 +75,6 @@ static inline u64 bkey_journal_seq(struct bkey_s_c k)
 	}
 }
 
-static bool found_btree_node_is_readable(struct btree_trans *trans,
-					 struct found_btree_node *f)
-{
-	struct { __BKEY_PADDED(k, BKEY_BTREE_PTR_VAL_U64s_MAX); } tmp;
-
-	found_btree_node_to_key(&tmp.k, f);
-
-	struct btree *b = bch2_btree_node_get_noiter(trans, &tmp.k, f->btree_id, f->level, false);
-	bool ret = !IS_ERR_OR_NULL(b);
-	if (!ret)
-		return ret;
-
-	f->sectors_written = b->written;
-	f->journal_seq = le64_to_cpu(b->data->keys.journal_seq);
-
-	struct bkey_s_c k;
-	struct bkey unpacked;
-	struct btree_node_iter iter;
-	for_each_btree_node_key_unpack(b, k, &iter, &unpacked)
-		f->journal_seq = max(f->journal_seq, bkey_journal_seq(k));
-
-	six_unlock_read(&b->c.lock);
-
-	/*
-	 * We might update this node's range; if that happens, we need the node
-	 * to be re-read so the read path can trim keys that are no longer in
-	 * this node
-	 */
-	if (b != btree_node_root(trans->c, b))
-		bch2_btree_node_evict(trans, &tmp.k);
-	return ret;
-}
-
 static int found_btree_node_cmp_cookie(const void *_l, const void *_r)
 {
 	const struct found_btree_node *l = _l;
@@ -159,17 +126,17 @@ static const struct min_heap_callbacks found_btree_node_heap_cbs = {
 };
 
 static void try_read_btree_node(struct find_btree_nodes *f, struct bch_dev *ca,
-				struct bio *bio, struct btree_node *bn, u64 offset)
+				struct btree *b, struct bio *bio, u64 offset)
 {
 	struct bch_fs *c = container_of(f, struct bch_fs, found_btree_nodes);
+	struct btree_node *bn = b->data;
 
 	bio_reset(bio, ca->disk_sb.bdev, REQ_OP_READ);
 	bio->bi_iter.bi_sector	= offset;
-	bch2_bio_map(bio, bn, PAGE_SIZE);
+	bch2_bio_map(bio, b->data, c->opts.block_size);
 
 	u64 submit_time = local_clock();
 	submit_bio_wait(bio);
-
 	bch2_account_io_completion(ca, BCH_MEMBER_ERROR_read, submit_time, !bio->bi_status);
 
 	if (bio->bi_status) {
@@ -201,6 +168,14 @@ static void try_read_btree_node(struct find_btree_nodes *f, struct bch_dev *ca,
 	if (BTREE_NODE_ID(bn) >= BTREE_ID_NR_MAX)
 		return;
 
+	bio_reset(bio, ca->disk_sb.bdev, REQ_OP_READ);
+	bio->bi_iter.bi_sector	= offset;
+	bch2_bio_map(bio, b->data, c->opts.btree_node_size);
+
+	submit_time = local_clock();
+	submit_bio_wait(bio);
+	bch2_account_io_completion(ca, BCH_MEMBER_ERROR_read, submit_time, !bio->bi_status);
+
 	rcu_read_lock();
 	struct found_btree_node n = {
 		.btree_id	= BTREE_NODE_ID(bn),
@@ -217,7 +192,10 @@ static void try_read_btree_node(struct find_btree_nodes *f, struct bch_dev *ca,
 	};
 	rcu_read_unlock();
 
-	if (bch2_trans_run(c, found_btree_node_is_readable(trans, &n))) {
+	found_btree_node_to_key(&b->key, &n);
+
+	CLASS(printbuf, buf)();
+	if (!bch2_btree_node_read_done(c, ca, b, NULL, &buf)) {
 		mutex_lock(&f->lock);
 		if (BSET_BIG_ENDIAN(&bn->keys) != CPU_BIG_ENDIAN) {
 			bch_err(c, "try_read_btree_node() can't handle endian conversion");
@@ -237,12 +215,18 @@ static int read_btree_nodes_worker(void *p)
 	struct find_btree_nodes_worker *w = p;
 	struct bch_fs *c = container_of(w->f, struct bch_fs, found_btree_nodes);
 	struct bch_dev *ca = w->ca;
-	void *buf = (void *) __get_free_page(GFP_KERNEL);
-	struct bio *bio = bio_alloc(NULL, 1, 0, GFP_KERNEL);
 	unsigned long last_print = jiffies;
 
-	if (!buf || !bio) {
-		bch_err(c, "read_btree_nodes_worker: error allocating bio/buf");
+	struct btree *b = __bch2_btree_node_mem_alloc(c);
+	if (!b) {
+		bch_err(c, "read_btree_nodes_worker: error allocating buf");
+		w->f->ret = -ENOMEM;
+		goto err;
+	}
+
+	struct bio *bio = bio_alloc(NULL, buf_pages(b->data, c->opts.btree_node_size), 0, GFP_KERNEL);
+	if (!bio) {
+		bch_err(c, "read_btree_nodes_worker: error allocating bio");
 		w->f->ret = -ENOMEM;
 		goto err;
 	}
@@ -266,11 +250,11 @@ static int read_btree_nodes_worker(void *p)
 			    !bch2_dev_btree_bitmap_marked_sectors(ca, sector, btree_sectors(c)))
 				continue;
 
-			try_read_btree_node(w->f, ca, bio, buf, sector);
+			try_read_btree_node(w->f, ca, b, bio, sector);
 		}
 err:
+	__btree_node_data_free(b);
 	bio_put(bio);
-	free_page((unsigned long) buf);
 	enumerated_ref_put(&ca->io_ref[READ], BCH_DEV_READ_REF_btree_node_scan);
 	closure_put(w->cl);
 	kfree(w);
-- 
2.50.0


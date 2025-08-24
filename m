Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C8FB274658
	for <linux-bcachefs@vger.kernel.org>; Sun, 24 Aug 2025 12:38:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756039092; cv=none; b=hle+2yKSmP0GOY5IvzNXRlVl9NVx8EKel2nMZvoSECRlp23Zjg5R5lZjIa/pLd84r4b6qrsXiCD2Kllu6QpphneWtoDUAkacUwgEwb9tpuB9VRWKZgLREQFwbO6GDjH2hHPavEp3Jumfyz1YwuogG/8FSy7TS+e8aPewkDZs5tQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756039092; c=relaxed/simple;
	bh=h1u3sTc2Eli1jJgqLlKmXlur573q9CJCAqgJtxS+7gI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BTbHbab3nd4LswGbtGbvw9HHfZ3uJ/KorvAXGMV2p40mvqPK/uT5SjudP/XZ9Y1foOvO8AOpwPBtv4dTMQx3hWvqDWXFA5g/PLyj57p8BZcbBcsGCVBuf9nre/2yB2DoVPEo/+hDjgI5YYLkX+XoX+RXK8LPbgC9kk48/8X9lU8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=AYNBsA36; arc=none smtp.client-ip=91.218.175.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="AYNBsA36"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1756039088;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Tfa+Qsrbfl7panFedr84ntsq4MJCHQlKI/SdDml9SSQ=;
	b=AYNBsA36HynpxywgHf47O3zxryIN5QUZBK1PbKek8K4QWiuIAwAwm6zjmrv3ZzN9aNZ24o
	tVKHkuY999ZpdEnDyCzbAtuTigdvvzmYP/u2Sn15NBt+jJbOQpYMIPT2jJVKkFrTC96/DR
	r4FEicn5qEzjtniacVgh/n6uyiRBE2M=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 02/21] bcachefs: Inode opt helper refactoring
Date: Sun, 24 Aug 2025 08:37:39 -0400
Message-ID: <20250824123800.1617669-3-kent.overstreet@linux.dev>
In-Reply-To: <20250824123800.1617669-1-kent.overstreet@linux.dev>
References: <20250824123800.1617669-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/fs-io-buffered.c |  8 ++++----
 fs/bcachefs/fs-io-direct.c   |  6 +++---
 fs/bcachefs/fs-io.c          |  2 +-
 fs/bcachefs/inode.c          | 17 +++++++++--------
 fs/bcachefs/inode.h          |  5 ++---
 fs/bcachefs/move.c           | 14 +++++++++-----
 fs/bcachefs/move.h           |  2 +-
 fs/bcachefs/opts.c           | 11 +++++------
 fs/bcachefs/opts.h           |  2 +-
 9 files changed, 35 insertions(+), 32 deletions(-)

diff --git a/fs/bcachefs/fs-io-buffered.c b/fs/bcachefs/fs-io-buffered.c
index 7ba4ef3173c7..a027992d769c 100644
--- a/fs/bcachefs/fs-io-buffered.c
+++ b/fs/bcachefs/fs-io-buffered.c
@@ -284,12 +284,12 @@ void bch2_readahead(struct readahead_control *ractl)
 {
 	struct bch_inode_info *inode = to_bch_ei(ractl->mapping->host);
 	struct bch_fs *c = inode->v.i_sb->s_fs_info;
-	struct bch_inode_opts opts;
 	struct folio *folio;
 	struct readpages_iter readpages_iter;
 	struct blk_plug plug;
 
-	bch2_inode_opts_get(&opts, c, &inode->ei_inode);
+	struct bch_inode_opts opts;
+	bch2_inode_opts_get_inode(c, &inode->ei_inode, &opts);
 
 	int ret = readpages_iter_init(&readpages_iter, ractl);
 	if (ret)
@@ -361,7 +361,7 @@ int bch2_read_single_folio(struct folio *folio, struct address_space *mapping)
 	if (!bch2_folio_create(folio, GFP_KERNEL))
 		return -ENOMEM;
 
-	bch2_inode_opts_get(&opts, c, &inode->ei_inode);
+	bch2_inode_opts_get_inode(c, &inode->ei_inode, &opts);
 
 	rbio = rbio_init(bio_alloc_bioset(NULL, 1, REQ_OP_READ, GFP_KERNEL, &c->bio_read),
 			 c,
@@ -683,7 +683,7 @@ int bch2_writepages(struct address_space *mapping, struct writeback_control *wbc
 	struct bch_fs *c = mapping->host->i_sb->s_fs_info;
 	struct bch_writepage_state *w = kzalloc(sizeof(*w), GFP_NOFS|__GFP_NOFAIL);
 
-	bch2_inode_opts_get(&w->opts, c, &to_bch_ei(mapping->host)->ei_inode);
+	bch2_inode_opts_get_inode(c, &to_bch_ei(mapping->host)->ei_inode, &w->opts);
 
 	blk_start_plug(&w->plug);
 	int ret = bch2_write_cache_pages(mapping, wbc, w);
diff --git a/fs/bcachefs/fs-io-direct.c b/fs/bcachefs/fs-io-direct.c
index 2ee6e1720515..a104b9d70bea 100644
--- a/fs/bcachefs/fs-io-direct.c
+++ b/fs/bcachefs/fs-io-direct.c
@@ -68,7 +68,6 @@ static int bch2_direct_IO_read(struct kiocb *req, struct iov_iter *iter)
 	struct file *file = req->ki_filp;
 	struct bch_inode_info *inode = file_bch_inode(file);
 	struct bch_fs *c = inode->v.i_sb->s_fs_info;
-	struct bch_inode_opts opts;
 	struct dio_read *dio;
 	struct bio *bio;
 	struct blk_plug plug;
@@ -78,7 +77,8 @@ static int bch2_direct_IO_read(struct kiocb *req, struct iov_iter *iter)
 	size_t shorten;
 	ssize_t ret;
 
-	bch2_inode_opts_get(&opts, c, &inode->ei_inode);
+	struct bch_inode_opts opts;
+	bch2_inode_opts_get_inode(c, &inode->ei_inode, &opts);
 
 	/* bios must be 512 byte aligned: */
 	if ((offset|iter->count) & (SECTOR_SIZE - 1))
@@ -451,7 +451,7 @@ static __always_inline long bch2_dio_write_loop(struct dio_write *dio)
 	bool sync = dio->sync, dropped_locks;
 	long ret;
 
-	bch2_inode_opts_get(&opts, c, &inode->ei_inode);
+	bch2_inode_opts_get_inode(c, &inode->ei_inode, &opts);
 
 	while (1) {
 		iter_count = dio->iter.count;
diff --git a/fs/bcachefs/fs-io.c b/fs/bcachefs/fs-io.c
index f71909e4ef1d..57e9459afa07 100644
--- a/fs/bcachefs/fs-io.c
+++ b/fs/bcachefs/fs-io.c
@@ -630,7 +630,7 @@ static noinline int __bchfs_fallocate(struct bch_inode_info *inode, int mode,
 	struct bch_inode_opts opts;
 	int ret = 0;
 
-	bch2_inode_opts_get(&opts, c, &inode->ei_inode);
+	bch2_inode_opts_get_inode(c, &inode->ei_inode, &opts);
 
 	CLASS(btree_trans, trans)(c);
 	CLASS(btree_iter, iter)(trans, BTREE_ID_extents,
diff --git a/fs/bcachefs/inode.c b/fs/bcachefs/inode.c
index 30dc6631c333..b7fcdb76483c 100644
--- a/fs/bcachefs/inode.c
+++ b/fs/bcachefs/inode.c
@@ -1224,21 +1224,22 @@ struct bch_opts bch2_inode_opts_to_opts(struct bch_inode_unpacked *inode)
 	return ret;
 }
 
-void bch2_inode_opts_get(struct bch_inode_opts *opts, struct bch_fs *c,
-			 struct bch_inode_unpacked *inode)
+void bch2_inode_opts_get_inode(struct bch_fs *c,
+			       struct bch_inode_unpacked *inode,
+			       struct bch_inode_opts *ret)
 {
 #define x(_name, _bits)							\
 	if ((inode)->bi_##_name) {					\
-		opts->_name = inode->bi_##_name - 1;			\
-		opts->_name##_from_inode = true;			\
+		ret->_name = inode->bi_##_name - 1;			\
+		ret->_name##_from_inode = true;				\
 	} else {							\
-		opts->_name = c->opts._name;				\
-		opts->_name##_from_inode = false;			\
+		ret->_name = c->opts._name;				\
+		ret->_name##_from_inode = false;			\
 	}
 	BCH_INODE_OPTS()
 #undef x
 
-	bch2_io_opts_fixups(opts);
+	bch2_io_opts_fixups(ret);
 }
 
 int bch2_inum_opts_get(struct btree_trans *trans, subvol_inum inum, struct bch_inode_opts *opts)
@@ -1249,7 +1250,7 @@ int bch2_inum_opts_get(struct btree_trans *trans, subvol_inum inum, struct bch_i
 	if (ret)
 		return ret;
 
-	bch2_inode_opts_get(opts, trans->c, &inode);
+	bch2_inode_opts_get_inode(trans->c, &inode, opts);
 	return 0;
 }
 
diff --git a/fs/bcachefs/inode.h b/fs/bcachefs/inode.h
index c26f48fdaa81..12e0a104c196 100644
--- a/fs/bcachefs/inode.h
+++ b/fs/bcachefs/inode.h
@@ -289,8 +289,7 @@ int bch2_inode_nlink_inc(struct bch_inode_unpacked *);
 void bch2_inode_nlink_dec(struct btree_trans *, struct bch_inode_unpacked *);
 
 struct bch_opts bch2_inode_opts_to_opts(struct bch_inode_unpacked *);
-void bch2_inode_opts_get(struct bch_inode_opts *, struct bch_fs *,
-			 struct bch_inode_unpacked *);
+void bch2_inode_opts_get_inode(struct bch_fs *, struct bch_inode_unpacked *, struct bch_inode_opts *);
 int bch2_inum_opts_get(struct btree_trans *, subvol_inum, struct bch_inode_opts *);
 int bch2_inode_set_casefold(struct btree_trans *, subvol_inum,
 			    struct bch_inode_unpacked *, unsigned);
@@ -301,7 +300,7 @@ static inline struct bch_extent_rebalance
 bch2_inode_rebalance_opts_get(struct bch_fs *c, struct bch_inode_unpacked *inode)
 {
 	struct bch_inode_opts io_opts;
-	bch2_inode_opts_get(&io_opts, c, inode);
+	bch2_inode_opts_get_inode(c, inode, &io_opts);
 	return io_opts_to_rebalance_opts(c, &io_opts);
 }
 
diff --git a/fs/bcachefs/move.c b/fs/bcachefs/move.c
index 39bec75890f4..03b3060f1964 100644
--- a/fs/bcachefs/move.c
+++ b/fs/bcachefs/move.c
@@ -481,7 +481,7 @@ struct bch_inode_opts *bch2_move_get_io_opts(struct btree_trans *trans,
 				break;
 
 			struct snapshot_io_opts_entry e = { .snapshot = k.k->p.snapshot };
-			bch2_inode_opts_get(&e.io_opts, trans->c, &inode);
+			bch2_inode_opts_get_inode(trans->c, &inode, &e.io_opts);
 
 			darray_push(&io_opts->d, e);
 		}));
@@ -512,7 +512,7 @@ int bch2_move_get_io_opts_one(struct btree_trans *trans,
 {
 	struct bch_fs *c = trans->c;
 
-	*io_opts = bch2_opts_to_inode_opts(c->opts);
+	bch2_inode_opts_get(c, io_opts);
 
 	/* reflink btree? */
 	if (extent_k.k->p.inode) {
@@ -527,7 +527,7 @@ int bch2_move_get_io_opts_one(struct btree_trans *trans,
 		if (!ret && bkey_is_inode(inode_k.k)) {
 			struct bch_inode_unpacked inode;
 			bch2_inode_unpack(inode_k, &inode);
-			bch2_inode_opts_get(io_opts, c, &inode);
+			bch2_inode_opts_get_inode(c, &inode, io_opts);
 		}
 	}
 
@@ -855,7 +855,6 @@ static int __bch2_move_data_phys(struct moving_context *ctxt,
 	struct btree_trans *trans = ctxt->trans;
 	struct bch_fs *c = trans->c;
 	bool is_kthread = current->flags & PF_KTHREAD;
-	struct bch_inode_opts io_opts = bch2_opts_to_inode_opts(c->opts);
 	struct btree_iter iter = {};
 	struct bkey_buf sk;
 	struct bkey_s_c k;
@@ -863,6 +862,9 @@ static int __bch2_move_data_phys(struct moving_context *ctxt,
 	u64 check_mismatch_done = bucket_start;
 	int ret = 0;
 
+	struct bch_inode_opts io_opts;
+	bch2_inode_opts_get(c, &io_opts);
+
 	CLASS(bch2_dev_tryget, ca)(c, dev);
 	if (!ca)
 		return 0;
@@ -1085,7 +1087,6 @@ static int bch2_move_btree(struct bch_fs *c,
 			   struct bch_move_stats *stats)
 {
 	bool kthread = (current->flags & PF_KTHREAD) != 0;
-	struct bch_inode_opts io_opts = bch2_opts_to_inode_opts(c->opts);
 	struct moving_context ctxt;
 	struct btree_trans *trans;
 	struct btree_iter iter;
@@ -1094,6 +1095,9 @@ static int bch2_move_btree(struct bch_fs *c,
 	struct data_update_opts data_opts;
 	int ret = 0;
 
+	struct bch_inode_opts io_opts;
+	bch2_inode_opts_get(c, &io_opts);
+
 	bch2_moving_ctxt_init(&ctxt, c, NULL, stats,
 			      writepoint_ptr(&c->btree_write_point),
 			      true);
diff --git a/fs/bcachefs/move.h b/fs/bcachefs/move.h
index a5561e02c38c..18021d2c51d0 100644
--- a/fs/bcachefs/move.h
+++ b/fs/bcachefs/move.h
@@ -102,7 +102,7 @@ struct per_snapshot_io_opts {
 static inline void per_snapshot_io_opts_init(struct per_snapshot_io_opts *io_opts, struct bch_fs *c)
 {
 	memset(io_opts, 0, sizeof(*io_opts));
-	io_opts->fs_io_opts = bch2_opts_to_inode_opts(c->opts);
+	bch2_inode_opts_get(c, &io_opts->fs_io_opts);
 }
 
 static inline void per_snapshot_io_opts_exit(struct per_snapshot_io_opts *io_opts)
diff --git a/fs/bcachefs/opts.c b/fs/bcachefs/opts.c
index 6091e6d55a17..10d472d3e7d1 100644
--- a/fs/bcachefs/opts.c
+++ b/fs/bcachefs/opts.c
@@ -802,16 +802,15 @@ bool bch2_opt_set_sb(struct bch_fs *c, struct bch_dev *ca,
 
 /* io opts: */
 
-struct bch_inode_opts bch2_opts_to_inode_opts(struct bch_opts src)
+void bch2_inode_opts_get(struct bch_fs *c, struct bch_inode_opts *ret)
 {
-	struct bch_inode_opts opts = {
-#define x(_name, _bits)	._name = src._name,
+	memset(ret, 0, sizeof(*ret));
+
+#define x(_name, _bits)	ret->_name = c->opts._name,
 	BCH_INODE_OPTS()
 #undef x
-	};
 
-	bch2_io_opts_fixups(&opts);
-	return opts;
+	bch2_io_opts_fixups(ret);
 }
 
 bool bch2_opt_is_inode_opt(enum bch_opt_id id)
diff --git a/fs/bcachefs/opts.h b/fs/bcachefs/opts.h
index 40a55335998d..9e0c73b7bd3a 100644
--- a/fs/bcachefs/opts.h
+++ b/fs/bcachefs/opts.h
@@ -692,7 +692,7 @@ static inline void bch2_io_opts_fixups(struct bch_inode_opts *opts)
 	}
 }
 
-struct bch_inode_opts bch2_opts_to_inode_opts(struct bch_opts);
+void bch2_inode_opts_get(struct bch_fs *, struct bch_inode_opts *);
 bool bch2_opt_is_inode_opt(enum bch_opt_id);
 
 #endif /* _BCACHEFS_OPTS_H */
-- 
2.50.1


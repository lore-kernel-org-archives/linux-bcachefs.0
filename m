Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B9062B2D7
	for <linux-bcachefs@vger.kernel.org>; Sun, 24 Aug 2025 12:38:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756039093; cv=none; b=nVgMle8W5lfAclMNqOxR5gpRYABqLGvHZg7Pk2t86WKI0RmazeY43v3diUAEeKNtS8mqs06tS/mjh0spxTPUH2ow1stgzGf93uhhjHPk0Tl0VuhuCfNVPEd0ruNcNJ7vbGJjJ/F6u1rNLHn1ToSVNLTq+ymbWGbMR/4PBkDQfdw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756039093; c=relaxed/simple;
	bh=TKL2LrcxO4F1/f0C5Xv0E0wsoP5syNYN5bVUE+szEvE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XeQWrW/Z6RmBZAGGZhbEPkoFpFrgGSxSOb8IHQ47scv8Smivr3hDEFVrFpgU7H68Be95wCUZkJC+tHAIPKbnZzsXS2P788N732mQPl5Lr0ypHebN8FkvIxqMXPQMlMZth2665Nx04/5Lv4+n4AM5lcM+mqEYsAbVDvNF59nTSeg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=m1PEZWXz; arc=none smtp.client-ip=91.218.175.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="m1PEZWXz"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1756039087;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JeTHUGOftQJyurQE0zUh6AOmP02rhjIWAY5xXEF8xCI=;
	b=m1PEZWXzp/xWKHjpitjyD/KSBduf9JHlgJmA8C18lOCC5JCylYb17bcBQy4ZQVmvO6Tv4g
	FkZEzT5kEhlWp7mKxRQO3oTWfgf7oVdX/ZB64ZKZXlS9fUyRdbSdzsF8PzaQ3nr7ZkfhTP
	IpZM1nlTBTQnzq0PWmiXYdSx3EpsvVs=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 01/21] bcachefs: s/bch_io_opts/bch_inode_opts
Date: Sun, 24 Aug 2025 08:37:38 -0400
Message-ID: <20250824123800.1617669-2-kent.overstreet@linux.dev>
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

Prep for introducing a new bch_io_opts with just the io path options.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/checksum.h       |  2 +-
 fs/bcachefs/data_update.c    | 10 +++++-----
 fs/bcachefs/data_update.h    |  8 ++++----
 fs/bcachefs/extents.c        |  6 +++---
 fs/bcachefs/extents.h        |  4 ++--
 fs/bcachefs/fs-io-buffered.c |  6 +++---
 fs/bcachefs/fs-io-direct.c   |  4 ++--
 fs/bcachefs/fs-io.c          |  2 +-
 fs/bcachefs/inode.c          |  4 ++--
 fs/bcachefs/inode.h          |  6 +++---
 fs/bcachefs/io_misc.c        |  4 ++--
 fs/bcachefs/io_misc.h        |  2 +-
 fs/bcachefs/io_read.c        |  2 +-
 fs/bcachefs/io_read.h        |  4 ++--
 fs/bcachefs/io_write.h       |  2 +-
 fs/bcachefs/io_write_types.h |  2 +-
 fs/bcachefs/move.c           | 34 +++++++++++++++++-----------------
 fs/bcachefs/move.h           | 12 ++++++------
 fs/bcachefs/opts.c           |  4 ++--
 fs/bcachefs/opts.h           |  6 +++---
 fs/bcachefs/rebalance.c      | 18 +++++++++---------
 fs/bcachefs/rebalance.h      |  6 +++---
 fs/bcachefs/reflink.c        |  2 +-
 23 files changed, 75 insertions(+), 75 deletions(-)

diff --git a/fs/bcachefs/checksum.h b/fs/bcachefs/checksum.h
index 7bd9cf6104ca..10bfadcde80a 100644
--- a/fs/bcachefs/checksum.h
+++ b/fs/bcachefs/checksum.h
@@ -130,7 +130,7 @@ static inline enum bch_csum_type bch2_csum_opt_to_type(enum bch_csum_opt type,
 }
 
 static inline enum bch_csum_type bch2_data_checksum_type(struct bch_fs *c,
-							 struct bch_io_opts opts)
+							 struct bch_inode_opts opts)
 {
 	if (opts.nocow)
 		return 0;
diff --git a/fs/bcachefs/data_update.c b/fs/bcachefs/data_update.c
index 2c997fddefb3..968850da0d23 100644
--- a/fs/bcachefs/data_update.c
+++ b/fs/bcachefs/data_update.c
@@ -613,7 +613,7 @@ int bch2_update_unwritten_extent(struct btree_trans *trans,
 }
 
 void bch2_data_update_opts_to_text(struct printbuf *out, struct bch_fs *c,
-				   struct bch_io_opts *io_opts,
+				   struct bch_inode_opts *io_opts,
 				   struct data_update_opts *data_opts)
 {
 	if (!out->nr_tabstops)
@@ -681,7 +681,7 @@ void bch2_data_update_inflight_to_text(struct printbuf *out, struct data_update
 int bch2_extent_drop_ptrs(struct btree_trans *trans,
 			  struct btree_iter *iter,
 			  struct bkey_s_c k,
-			  struct bch_io_opts *io_opts,
+			  struct bch_inode_opts *io_opts,
 			  struct data_update_opts *data_opts)
 {
 	struct bch_fs *c = trans->c;
@@ -731,7 +731,7 @@ int bch2_extent_drop_ptrs(struct btree_trans *trans,
 }
 
 static int __bch2_data_update_bios_init(struct data_update *m, struct bch_fs *c,
-					struct bch_io_opts *io_opts,
+					struct bch_inode_opts *io_opts,
 					unsigned buf_bytes)
 {
 	unsigned nr_vecs = DIV_ROUND_UP(buf_bytes, PAGE_SIZE);
@@ -758,7 +758,7 @@ static int __bch2_data_update_bios_init(struct data_update *m, struct bch_fs *c,
 }
 
 int bch2_data_update_bios_init(struct data_update *m, struct bch_fs *c,
-			       struct bch_io_opts *io_opts)
+			       struct bch_inode_opts *io_opts)
 {
 	struct bkey_ptrs_c ptrs = bch2_bkey_ptrs_c(bkey_i_to_s_c(m->k.k));
 	const union bch_extent_entry *entry;
@@ -830,7 +830,7 @@ int bch2_data_update_init(struct btree_trans *trans,
 			  struct moving_context *ctxt,
 			  struct data_update *m,
 			  struct write_point_specifier wp,
-			  struct bch_io_opts *io_opts,
+			  struct bch_inode_opts *io_opts,
 			  struct data_update_opts data_opts,
 			  enum btree_id btree_id,
 			  struct bkey_s_c k)
diff --git a/fs/bcachefs/data_update.h b/fs/bcachefs/data_update.h
index fc12aa65366f..3b0ba6f6497f 100644
--- a/fs/bcachefs/data_update.h
+++ b/fs/bcachefs/data_update.h
@@ -23,7 +23,7 @@ struct data_update_opts {
 };
 
 void bch2_data_update_opts_to_text(struct printbuf *, struct bch_fs *,
-				   struct bch_io_opts *, struct data_update_opts *);
+				   struct bch_inode_opts *, struct data_update_opts *);
 
 #define BCH_DATA_UPDATE_TYPES()		\
 	x(copygc,	0)		\
@@ -76,18 +76,18 @@ void bch2_data_update_read_done(struct data_update *);
 int bch2_extent_drop_ptrs(struct btree_trans *,
 			  struct btree_iter *,
 			  struct bkey_s_c,
-			  struct bch_io_opts *,
+			  struct bch_inode_opts *,
 			  struct data_update_opts *);
 
 int bch2_data_update_bios_init(struct data_update *, struct bch_fs *,
-			       struct bch_io_opts *);
+			       struct bch_inode_opts *);
 
 void bch2_data_update_exit(struct data_update *);
 int bch2_data_update_init(struct btree_trans *, struct btree_iter *,
 			  struct moving_context *,
 			  struct data_update *,
 			  struct write_point_specifier,
-			  struct bch_io_opts *, struct data_update_opts,
+			  struct bch_inode_opts *, struct data_update_opts,
 			  enum btree_id, struct bkey_s_c);
 void bch2_data_update_opts_normalize(struct bkey_s_c, struct data_update_opts *);
 
diff --git a/fs/bcachefs/extents.c b/fs/bcachefs/extents.c
index 68a61f7bc737..016242ffc98d 100644
--- a/fs/bcachefs/extents.c
+++ b/fs/bcachefs/extents.c
@@ -1151,7 +1151,7 @@ bch2_extent_has_ptr(struct bkey_s_c k1, struct extent_ptr_decoded p1, struct bke
 	return NULL;
 }
 
-static bool want_cached_ptr(struct bch_fs *c, struct bch_io_opts *opts,
+static bool want_cached_ptr(struct bch_fs *c, struct bch_inode_opts *opts,
 			    struct bch_extent_ptr *ptr)
 {
 	unsigned target = opts->promote_target ?: opts->foreground_target;
@@ -1165,7 +1165,7 @@ static bool want_cached_ptr(struct bch_fs *c, struct bch_io_opts *opts,
 }
 
 void bch2_extent_ptr_set_cached(struct bch_fs *c,
-				struct bch_io_opts *opts,
+				struct bch_inode_opts *opts,
 				struct bkey_s k,
 				struct bch_extent_ptr *ptr)
 {
@@ -1241,7 +1241,7 @@ bool bch2_extent_normalize(struct bch_fs *c, struct bkey_s k)
  * the promote target.
  */
 bool bch2_extent_normalize_by_opts(struct bch_fs *c,
-				   struct bch_io_opts *opts,
+				   struct bch_inode_opts *opts,
 				   struct bkey_s k)
 {
 	struct bkey_ptrs ptrs;
diff --git a/fs/bcachefs/extents.h b/fs/bcachefs/extents.h
index f6dcb17108cd..03ea7c689d9a 100644
--- a/fs/bcachefs/extents.h
+++ b/fs/bcachefs/extents.h
@@ -686,10 +686,10 @@ bool bch2_extents_match(struct bkey_s_c, struct bkey_s_c);
 struct bch_extent_ptr *
 bch2_extent_has_ptr(struct bkey_s_c, struct extent_ptr_decoded, struct bkey_s);
 
-void bch2_extent_ptr_set_cached(struct bch_fs *, struct bch_io_opts *,
+void bch2_extent_ptr_set_cached(struct bch_fs *, struct bch_inode_opts *,
 				struct bkey_s, struct bch_extent_ptr *);
 
-bool bch2_extent_normalize_by_opts(struct bch_fs *, struct bch_io_opts *, struct bkey_s);
+bool bch2_extent_normalize_by_opts(struct bch_fs *, struct bch_inode_opts *, struct bkey_s);
 bool bch2_extent_normalize(struct bch_fs *, struct bkey_s);
 
 void bch2_extent_ptr_to_text(struct printbuf *out, struct bch_fs *, const struct bch_extent_ptr *);
diff --git a/fs/bcachefs/fs-io-buffered.c b/fs/bcachefs/fs-io-buffered.c
index 9532f1a73053..7ba4ef3173c7 100644
--- a/fs/bcachefs/fs-io-buffered.c
+++ b/fs/bcachefs/fs-io-buffered.c
@@ -284,7 +284,7 @@ void bch2_readahead(struct readahead_control *ractl)
 {
 	struct bch_inode_info *inode = to_bch_ei(ractl->mapping->host);
 	struct bch_fs *c = inode->v.i_sb->s_fs_info;
-	struct bch_io_opts opts;
+	struct bch_inode_opts opts;
 	struct folio *folio;
 	struct readpages_iter readpages_iter;
 	struct blk_plug plug;
@@ -350,7 +350,7 @@ int bch2_read_single_folio(struct folio *folio, struct address_space *mapping)
 	struct bch_inode_info *inode = to_bch_ei(mapping->host);
 	struct bch_fs *c = inode->v.i_sb->s_fs_info;
 	struct bch_read_bio *rbio;
-	struct bch_io_opts opts;
+	struct bch_inode_opts opts;
 	struct blk_plug plug;
 	int ret;
 	DECLARE_COMPLETION_ONSTACK(done);
@@ -407,7 +407,7 @@ struct bch_writepage_io {
 
 struct bch_writepage_state {
 	struct bch_writepage_io	*io;
-	struct bch_io_opts	opts;
+	struct bch_inode_opts	opts;
 	struct bch_folio_sector	*tmp;
 	unsigned		tmp_sectors;
 	struct blk_plug		plug;
diff --git a/fs/bcachefs/fs-io-direct.c b/fs/bcachefs/fs-io-direct.c
index 79823234160f..2ee6e1720515 100644
--- a/fs/bcachefs/fs-io-direct.c
+++ b/fs/bcachefs/fs-io-direct.c
@@ -68,7 +68,7 @@ static int bch2_direct_IO_read(struct kiocb *req, struct iov_iter *iter)
 	struct file *file = req->ki_filp;
 	struct bch_inode_info *inode = file_bch_inode(file);
 	struct bch_fs *c = inode->v.i_sb->s_fs_info;
-	struct bch_io_opts opts;
+	struct bch_inode_opts opts;
 	struct dio_read *dio;
 	struct bio *bio;
 	struct blk_plug plug;
@@ -445,7 +445,7 @@ static __always_inline long bch2_dio_write_loop(struct dio_write *dio)
 	struct kiocb *req = dio->req;
 	struct address_space *mapping = dio->mapping;
 	struct bch_inode_info *inode = dio->inode;
-	struct bch_io_opts opts;
+	struct bch_inode_opts opts;
 	struct bio *bio = &dio->op.wbio.bio;
 	unsigned unaligned, iter_count;
 	bool sync = dio->sync, dropped_locks;
diff --git a/fs/bcachefs/fs-io.c b/fs/bcachefs/fs-io.c
index de0d965f3fde..f71909e4ef1d 100644
--- a/fs/bcachefs/fs-io.c
+++ b/fs/bcachefs/fs-io.c
@@ -627,7 +627,7 @@ static noinline int __bchfs_fallocate(struct bch_inode_info *inode, int mode,
 {
 	struct bch_fs *c = inode->v.i_sb->s_fs_info;
 	struct bpos end_pos = POS(inode->v.i_ino, end_sector);
-	struct bch_io_opts opts;
+	struct bch_inode_opts opts;
 	int ret = 0;
 
 	bch2_inode_opts_get(&opts, c, &inode->ei_inode);
diff --git a/fs/bcachefs/inode.c b/fs/bcachefs/inode.c
index 4aa130ff7cf6..30dc6631c333 100644
--- a/fs/bcachefs/inode.c
+++ b/fs/bcachefs/inode.c
@@ -1224,7 +1224,7 @@ struct bch_opts bch2_inode_opts_to_opts(struct bch_inode_unpacked *inode)
 	return ret;
 }
 
-void bch2_inode_opts_get(struct bch_io_opts *opts, struct bch_fs *c,
+void bch2_inode_opts_get(struct bch_inode_opts *opts, struct bch_fs *c,
 			 struct bch_inode_unpacked *inode)
 {
 #define x(_name, _bits)							\
@@ -1241,7 +1241,7 @@ void bch2_inode_opts_get(struct bch_io_opts *opts, struct bch_fs *c,
 	bch2_io_opts_fixups(opts);
 }
 
-int bch2_inum_opts_get(struct btree_trans *trans, subvol_inum inum, struct bch_io_opts *opts)
+int bch2_inum_opts_get(struct btree_trans *trans, subvol_inum inum, struct bch_inode_opts *opts)
 {
 	struct bch_inode_unpacked inode;
 	int ret = lockrestart_do(trans, bch2_inode_find_by_inum_trans(trans, inum, &inode));
diff --git a/fs/bcachefs/inode.h b/fs/bcachefs/inode.h
index 79092ea74844..c26f48fdaa81 100644
--- a/fs/bcachefs/inode.h
+++ b/fs/bcachefs/inode.h
@@ -289,9 +289,9 @@ int bch2_inode_nlink_inc(struct bch_inode_unpacked *);
 void bch2_inode_nlink_dec(struct btree_trans *, struct bch_inode_unpacked *);
 
 struct bch_opts bch2_inode_opts_to_opts(struct bch_inode_unpacked *);
-void bch2_inode_opts_get(struct bch_io_opts *, struct bch_fs *,
+void bch2_inode_opts_get(struct bch_inode_opts *, struct bch_fs *,
 			 struct bch_inode_unpacked *);
-int bch2_inum_opts_get(struct btree_trans *, subvol_inum, struct bch_io_opts *);
+int bch2_inum_opts_get(struct btree_trans *, subvol_inum, struct bch_inode_opts *);
 int bch2_inode_set_casefold(struct btree_trans *, subvol_inum,
 			    struct bch_inode_unpacked *, unsigned);
 
@@ -300,7 +300,7 @@ int bch2_inode_set_casefold(struct btree_trans *, subvol_inum,
 static inline struct bch_extent_rebalance
 bch2_inode_rebalance_opts_get(struct bch_fs *c, struct bch_inode_unpacked *inode)
 {
-	struct bch_io_opts io_opts;
+	struct bch_inode_opts io_opts;
 	bch2_inode_opts_get(&io_opts, c, inode);
 	return io_opts_to_rebalance_opts(c, &io_opts);
 }
diff --git a/fs/bcachefs/io_misc.c b/fs/bcachefs/io_misc.c
index fa0b06e17d17..5e03574059e0 100644
--- a/fs/bcachefs/io_misc.c
+++ b/fs/bcachefs/io_misc.c
@@ -24,7 +24,7 @@ int bch2_extent_fallocate(struct btree_trans *trans,
 			  subvol_inum inum,
 			  struct btree_iter *iter,
 			  u64 sectors,
-			  struct bch_io_opts opts,
+			  struct bch_inode_opts opts,
 			  s64 *i_sectors_delta,
 			  struct write_point_specifier write_point)
 {
@@ -373,7 +373,7 @@ static int __bch2_resume_logged_op_finsert(struct btree_trans *trans,
 	struct btree_iter iter;
 	struct bkey_i_logged_op_finsert *op = bkey_i_to_logged_op_finsert(op_k);
 	subvol_inum inum = { le32_to_cpu(op->v.subvol), le64_to_cpu(op->v.inum) };
-	struct bch_io_opts opts;
+	struct bch_inode_opts opts;
 	u64 dst_offset = le64_to_cpu(op->v.dst_offset);
 	u64 src_offset = le64_to_cpu(op->v.src_offset);
 	s64 shift = dst_offset - src_offset;
diff --git a/fs/bcachefs/io_misc.h b/fs/bcachefs/io_misc.h
index b93e4d4b3c0c..6a294f2a6dd6 100644
--- a/fs/bcachefs/io_misc.h
+++ b/fs/bcachefs/io_misc.h
@@ -3,7 +3,7 @@
 #define _BCACHEFS_IO_MISC_H
 
 int bch2_extent_fallocate(struct btree_trans *, subvol_inum, struct btree_iter *,
-			  u64, struct bch_io_opts, s64 *,
+			  u64, struct bch_inode_opts, s64 *,
 			  struct write_point_specifier);
 
 int bch2_fpunch_snapshot(struct btree_trans *, struct bpos, struct bpos);
diff --git a/fs/bcachefs/io_read.c b/fs/bcachefs/io_read.c
index e7d53ab1cf55..74c3238230fe 100644
--- a/fs/bcachefs/io_read.c
+++ b/fs/bcachefs/io_read.c
@@ -158,7 +158,7 @@ static bool ptr_being_rewritten(struct bch_read_bio *orig, unsigned dev)
 
 static inline int should_promote(struct bch_fs *c, struct bkey_s_c k,
 				  struct bpos pos,
-				  struct bch_io_opts opts,
+				  struct bch_inode_opts opts,
 				  unsigned flags,
 				  struct bch_io_failures *failed)
 {
diff --git a/fs/bcachefs/io_read.h b/fs/bcachefs/io_read.h
index 1e1c0476bd03..df4632f6fe9e 100644
--- a/fs/bcachefs/io_read.h
+++ b/fs/bcachefs/io_read.h
@@ -74,7 +74,7 @@ struct bch_read_bio {
 	struct bpos		data_pos;
 	struct bversion		version;
 
-	struct bch_io_opts	opts;
+	struct bch_inode_opts	opts;
 
 	struct work_struct	work;
 
@@ -192,7 +192,7 @@ static inline struct bch_read_bio *rbio_init_fragment(struct bio *bio,
 
 static inline struct bch_read_bio *rbio_init(struct bio *bio,
 					     struct bch_fs *c,
-					     struct bch_io_opts opts,
+					     struct bch_inode_opts opts,
 					     bio_end_io_t end_io)
 {
 	struct bch_read_bio *rbio = to_rbio(bio);
diff --git a/fs/bcachefs/io_write.h b/fs/bcachefs/io_write.h
index 2c0a8f35ee1f..6c05ba6e15d6 100644
--- a/fs/bcachefs/io_write.h
+++ b/fs/bcachefs/io_write.h
@@ -31,7 +31,7 @@ int bch2_extent_update(struct btree_trans *, subvol_inum,
 		       struct disk_reservation *, u64, s64 *, bool);
 
 static inline void bch2_write_op_init(struct bch_write_op *op, struct bch_fs *c,
-				      struct bch_io_opts opts)
+				      struct bch_inode_opts opts)
 {
 	op->c			= c;
 	op->end_io		= NULL;
diff --git a/fs/bcachefs/io_write_types.h b/fs/bcachefs/io_write_types.h
index 5da4eb8bb6f6..ab36b03e0a46 100644
--- a/fs/bcachefs/io_write_types.h
+++ b/fs/bcachefs/io_write_types.h
@@ -90,7 +90,7 @@ struct bch_write_op {
 	struct bch_devs_list	devs_have;
 	u16			target;
 	u16			nonce;
-	struct bch_io_opts	opts;
+	struct bch_inode_opts	opts;
 
 	u32			subvol;
 	struct bpos		pos;
diff --git a/fs/bcachefs/move.c b/fs/bcachefs/move.c
index 4f41f1f6ec6c..39bec75890f4 100644
--- a/fs/bcachefs/move.c
+++ b/fs/bcachefs/move.c
@@ -46,12 +46,12 @@ struct evacuate_bucket_arg {
 
 static bool evacuate_bucket_pred(struct bch_fs *, void *,
 				 enum btree_id, struct bkey_s_c,
-				 struct bch_io_opts *,
+				 struct bch_inode_opts *,
 				 struct data_update_opts *);
 
 static noinline void
 trace_io_move2(struct bch_fs *c, struct bkey_s_c k,
-	       struct bch_io_opts *io_opts,
+	       struct bch_inode_opts *io_opts,
 	       struct data_update_opts *data_opts)
 {
 	CLASS(printbuf, buf)();
@@ -72,7 +72,7 @@ static noinline void trace_io_move_read2(struct bch_fs *c, struct bkey_s_c k)
 
 static noinline void
 trace_io_move_pred2(struct bch_fs *c, struct bkey_s_c k,
-		    struct bch_io_opts *io_opts,
+		    struct bch_inode_opts *io_opts,
 		    struct data_update_opts *data_opts,
 		    move_pred_fn pred, void *_arg, bool p)
 {
@@ -325,7 +325,7 @@ int bch2_move_extent(struct moving_context *ctxt,
 		     struct move_bucket *bucket_in_flight,
 		     struct btree_iter *iter,
 		     struct bkey_s_c k,
-		     struct bch_io_opts io_opts,
+		     struct bch_inode_opts io_opts,
 		     struct data_update_opts data_opts)
 {
 	struct btree_trans *trans = ctxt->trans;
@@ -447,7 +447,7 @@ int bch2_move_extent(struct moving_context *ctxt,
 	return ret;
 }
 
-struct bch_io_opts *bch2_move_get_io_opts(struct btree_trans *trans,
+struct bch_inode_opts *bch2_move_get_io_opts(struct btree_trans *trans,
 			  struct per_snapshot_io_opts *io_opts,
 			  struct bpos extent_pos, /* extent_iter, extent_k may be in reflink btree */
 			  struct btree_iter *extent_iter,
@@ -455,7 +455,7 @@ struct bch_io_opts *bch2_move_get_io_opts(struct btree_trans *trans,
 {
 	struct bch_fs *c = trans->c;
 	u32 restart_count = trans->restart_count;
-	struct bch_io_opts *opts_ret = &io_opts->fs_io_opts;
+	struct bch_inode_opts *opts_ret = &io_opts->fs_io_opts;
 	int ret = 0;
 
 	if (btree_iter_path(trans, extent_iter)->level)
@@ -506,7 +506,7 @@ struct bch_io_opts *bch2_move_get_io_opts(struct btree_trans *trans,
 }
 
 int bch2_move_get_io_opts_one(struct btree_trans *trans,
-			      struct bch_io_opts *io_opts,
+			      struct bch_inode_opts *io_opts,
 			      struct btree_iter *extent_iter,
 			      struct bkey_s_c extent_k)
 {
@@ -618,7 +618,7 @@ int bch2_move_data_btree(struct moving_context *ctxt,
 	struct btree_trans *trans = ctxt->trans;
 	struct bch_fs *c = trans->c;
 	struct per_snapshot_io_opts snapshot_io_opts;
-	struct bch_io_opts *io_opts;
+	struct bch_inode_opts *io_opts;
 	struct bkey_buf sk;
 	struct btree_iter iter, reflink_iter = {};
 	struct bkey_s_c k;
@@ -855,7 +855,7 @@ static int __bch2_move_data_phys(struct moving_context *ctxt,
 	struct btree_trans *trans = ctxt->trans;
 	struct bch_fs *c = trans->c;
 	bool is_kthread = current->flags & PF_KTHREAD;
-	struct bch_io_opts io_opts = bch2_opts_to_inode_opts(c->opts);
+	struct bch_inode_opts io_opts = bch2_opts_to_inode_opts(c->opts);
 	struct btree_iter iter = {};
 	struct bkey_buf sk;
 	struct bkey_s_c k;
@@ -1034,7 +1034,7 @@ int bch2_move_data_phys(struct bch_fs *c,
 
 static bool evacuate_bucket_pred(struct bch_fs *c, void *_arg,
 				 enum btree_id btree, struct bkey_s_c k,
-				 struct bch_io_opts *io_opts,
+				 struct bch_inode_opts *io_opts,
 				 struct data_update_opts *data_opts)
 {
 	struct evacuate_bucket_arg *arg = _arg;
@@ -1075,7 +1075,7 @@ int bch2_evacuate_bucket(struct moving_context *ctxt,
 }
 
 typedef bool (*move_btree_pred)(struct bch_fs *, void *,
-				struct btree *, struct bch_io_opts *,
+				struct btree *, struct bch_inode_opts *,
 				struct data_update_opts *);
 
 static int bch2_move_btree(struct bch_fs *c,
@@ -1085,7 +1085,7 @@ static int bch2_move_btree(struct bch_fs *c,
 			   struct bch_move_stats *stats)
 {
 	bool kthread = (current->flags & PF_KTHREAD) != 0;
-	struct bch_io_opts io_opts = bch2_opts_to_inode_opts(c->opts);
+	struct bch_inode_opts io_opts = bch2_opts_to_inode_opts(c->opts);
 	struct moving_context ctxt;
 	struct btree_trans *trans;
 	struct btree_iter iter;
@@ -1154,7 +1154,7 @@ static int bch2_move_btree(struct bch_fs *c,
 
 static bool rereplicate_pred(struct bch_fs *c, void *arg,
 			     enum btree_id btree, struct bkey_s_c k,
-			     struct bch_io_opts *io_opts,
+			     struct bch_inode_opts *io_opts,
 			     struct data_update_opts *data_opts)
 {
 	unsigned nr_good = bch2_bkey_durability(c, k);
@@ -1185,7 +1185,7 @@ static bool rereplicate_pred(struct bch_fs *c, void *arg,
 
 static bool migrate_pred(struct bch_fs *c, void *arg,
 			 enum btree_id btree, struct bkey_s_c k,
-			 struct bch_io_opts *io_opts,
+			 struct bch_inode_opts *io_opts,
 			 struct data_update_opts *data_opts)
 {
 	struct bkey_ptrs_c ptrs = bch2_bkey_ptrs_c(k);
@@ -1222,7 +1222,7 @@ static bool bformat_needs_redo(struct bkey_format *f)
 
 static bool rewrite_old_nodes_pred(struct bch_fs *c, void *arg,
 				   struct btree *b,
-				   struct bch_io_opts *io_opts,
+				   struct bch_inode_opts *io_opts,
 				   struct data_update_opts *data_opts)
 {
 	if (b->version_ondisk != c->sb.version ||
@@ -1259,7 +1259,7 @@ int bch2_scan_old_btree_nodes(struct bch_fs *c, struct bch_move_stats *stats)
 
 static bool drop_extra_replicas_pred(struct bch_fs *c, void *arg,
 			     enum btree_id btree, struct bkey_s_c k,
-			     struct bch_io_opts *io_opts,
+			     struct bch_inode_opts *io_opts,
 			     struct data_update_opts *data_opts)
 {
 	unsigned durability = bch2_bkey_durability(c, k);
@@ -1297,7 +1297,7 @@ static bool drop_extra_replicas_pred(struct bch_fs *c, void *arg,
 
 static bool scrub_pred(struct bch_fs *c, void *_arg,
 		       enum btree_id btree, struct bkey_s_c k,
-		       struct bch_io_opts *io_opts,
+		       struct bch_inode_opts *io_opts,
 		       struct data_update_opts *data_opts)
 {
 	struct bch_ioctl_data *arg = _arg;
diff --git a/fs/bcachefs/move.h b/fs/bcachefs/move.h
index 481026ff99ab..a5561e02c38c 100644
--- a/fs/bcachefs/move.h
+++ b/fs/bcachefs/move.h
@@ -73,7 +73,7 @@ do {									\
 } while (1)
 
 typedef bool (*move_pred_fn)(struct bch_fs *, void *, enum btree_id, struct bkey_s_c,
-			     struct bch_io_opts *, struct data_update_opts *);
+			     struct bch_inode_opts *, struct data_update_opts *);
 
 extern const char * const bch2_data_ops_strs[];
 
@@ -90,12 +90,12 @@ int bch2_move_ratelimit(struct moving_context *);
 /* Inodes in different snapshots may have different IO options: */
 struct snapshot_io_opts_entry {
 	u32			snapshot;
-	struct bch_io_opts	io_opts;
+	struct bch_inode_opts	io_opts;
 };
 
 struct per_snapshot_io_opts {
 	u64			cur_inum;
-	struct bch_io_opts	fs_io_opts;
+	struct bch_inode_opts	fs_io_opts;
 	DARRAY(struct snapshot_io_opts_entry) d;
 };
 
@@ -110,7 +110,7 @@ static inline void per_snapshot_io_opts_exit(struct per_snapshot_io_opts *io_opt
 	darray_exit(&io_opts->d);
 }
 
-int bch2_move_get_io_opts_one(struct btree_trans *, struct bch_io_opts *,
+int bch2_move_get_io_opts_one(struct btree_trans *, struct bch_inode_opts *,
 			      struct btree_iter *, struct bkey_s_c);
 
 int bch2_scan_old_btree_nodes(struct bch_fs *, struct bch_move_stats *);
@@ -119,10 +119,10 @@ int bch2_move_extent(struct moving_context *,
 		     struct move_bucket *,
 		     struct btree_iter *,
 		     struct bkey_s_c,
-		     struct bch_io_opts,
+		     struct bch_inode_opts,
 		     struct data_update_opts);
 
-struct bch_io_opts *bch2_move_get_io_opts(struct btree_trans *,
+struct bch_inode_opts *bch2_move_get_io_opts(struct btree_trans *,
 			  struct per_snapshot_io_opts *, struct bpos,
 			  struct btree_iter *, struct bkey_s_c);
 
diff --git a/fs/bcachefs/opts.c b/fs/bcachefs/opts.c
index c3ef35dc01e2..6091e6d55a17 100644
--- a/fs/bcachefs/opts.c
+++ b/fs/bcachefs/opts.c
@@ -802,9 +802,9 @@ bool bch2_opt_set_sb(struct bch_fs *c, struct bch_dev *ca,
 
 /* io opts: */
 
-struct bch_io_opts bch2_opts_to_inode_opts(struct bch_opts src)
+struct bch_inode_opts bch2_opts_to_inode_opts(struct bch_opts src)
 {
-	struct bch_io_opts opts = {
+	struct bch_inode_opts opts = {
 #define x(_name, _bits)	._name = src._name,
 	BCH_INODE_OPTS()
 #undef x
diff --git a/fs/bcachefs/opts.h b/fs/bcachefs/opts.h
index 31a3abcbd83e..40a55335998d 100644
--- a/fs/bcachefs/opts.h
+++ b/fs/bcachefs/opts.h
@@ -670,7 +670,7 @@ int bch2_parse_mount_opts(struct bch_fs *, struct bch_opts *, struct printbuf *,
 
 /* inode opts: */
 
-struct bch_io_opts {
+struct bch_inode_opts {
 #define x(_name, _bits)	u##_bits _name;
 	BCH_INODE_OPTS()
 #undef x
@@ -679,7 +679,7 @@ struct bch_io_opts {
 #undef x
 };
 
-static inline void bch2_io_opts_fixups(struct bch_io_opts *opts)
+static inline void bch2_io_opts_fixups(struct bch_inode_opts *opts)
 {
 	if (!opts->background_target)
 		opts->background_target = opts->foreground_target;
@@ -692,7 +692,7 @@ static inline void bch2_io_opts_fixups(struct bch_io_opts *opts)
 	}
 }
 
-struct bch_io_opts bch2_opts_to_inode_opts(struct bch_opts);
+struct bch_inode_opts bch2_opts_to_inode_opts(struct bch_opts);
 bool bch2_opt_is_inode_opt(enum bch_opt_id);
 
 #endif /* _BCACHEFS_OPTS_H */
diff --git a/fs/bcachefs/rebalance.c b/fs/bcachefs/rebalance.c
index 25bf72dc6488..9590c57798c6 100644
--- a/fs/bcachefs/rebalance.c
+++ b/fs/bcachefs/rebalance.c
@@ -44,7 +44,7 @@ static const struct bch_extent_rebalance *bch2_bkey_rebalance_opts(struct bkey_s
 }
 
 static inline unsigned bch2_bkey_ptrs_need_compress(struct bch_fs *c,
-					   struct bch_io_opts *opts,
+					   struct bch_inode_opts *opts,
 					   struct bkey_s_c k,
 					   struct bkey_ptrs_c ptrs)
 {
@@ -71,7 +71,7 @@ static inline unsigned bch2_bkey_ptrs_need_compress(struct bch_fs *c,
 }
 
 static inline unsigned bch2_bkey_ptrs_need_move(struct bch_fs *c,
-				       struct bch_io_opts *opts,
+				       struct bch_inode_opts *opts,
 				       struct bkey_ptrs_c ptrs)
 {
 	if (!opts->background_target ||
@@ -92,7 +92,7 @@ static inline unsigned bch2_bkey_ptrs_need_move(struct bch_fs *c,
 }
 
 static unsigned bch2_bkey_ptrs_need_rebalance(struct bch_fs *c,
-					      struct bch_io_opts *opts,
+					      struct bch_inode_opts *opts,
 					      struct bkey_s_c k)
 {
 	struct bkey_ptrs_c ptrs = bch2_bkey_ptrs_c(k);
@@ -145,7 +145,7 @@ u64 bch2_bkey_sectors_need_rebalance(struct bch_fs *c, struct bkey_s_c k)
 	return sectors;
 }
 
-static bool bch2_bkey_rebalance_needs_update(struct bch_fs *c, struct bch_io_opts *opts,
+static bool bch2_bkey_rebalance_needs_update(struct bch_fs *c, struct bch_inode_opts *opts,
 					     struct bkey_s_c k)
 {
 	if (!bkey_extent_is_direct_data(k.k))
@@ -161,7 +161,7 @@ static bool bch2_bkey_rebalance_needs_update(struct bch_fs *c, struct bch_io_opt
 	}
 }
 
-int bch2_bkey_set_needs_rebalance(struct bch_fs *c, struct bch_io_opts *opts,
+int bch2_bkey_set_needs_rebalance(struct bch_fs *c, struct bch_inode_opts *opts,
 				  struct bkey_i *_k)
 {
 	if (!bkey_extent_is_direct_data(&_k->k))
@@ -187,7 +187,7 @@ int bch2_bkey_set_needs_rebalance(struct bch_fs *c, struct bch_io_opts *opts,
 }
 
 int bch2_get_update_rebalance_opts(struct btree_trans *trans,
-				   struct bch_io_opts *io_opts,
+				   struct bch_inode_opts *io_opts,
 				   struct btree_iter *iter,
 				   struct bkey_s_c k)
 {
@@ -356,7 +356,7 @@ static int bch2_bkey_clear_needs_rebalance(struct btree_trans *trans,
 static struct bkey_s_c next_rebalance_extent(struct btree_trans *trans,
 			struct bpos work_pos,
 			struct btree_iter *extent_iter,
-			struct bch_io_opts *io_opts,
+			struct bch_inode_opts *io_opts,
 			struct data_update_opts *data_opts)
 {
 	struct bch_fs *c = trans->c;
@@ -435,7 +435,7 @@ static int do_rebalance_extent(struct moving_context *ctxt,
 	struct bch_fs *c = trans->c;
 	struct bch_fs_rebalance *r = &trans->c->rebalance;
 	struct data_update_opts data_opts;
-	struct bch_io_opts io_opts;
+	struct bch_inode_opts io_opts;
 	struct bkey_s_c k;
 	struct bkey_buf sk;
 	int ret;
@@ -508,7 +508,7 @@ static int do_rebalance_scan(struct moving_context *ctxt,
 					 BTREE_ITER_prefetch, k, ({
 		ctxt->stats->pos = BBPOS(iter.btree_id, iter.pos);
 
-		struct bch_io_opts *io_opts = bch2_move_get_io_opts(trans,
+		struct bch_inode_opts *io_opts = bch2_move_get_io_opts(trans,
 					&snapshot_io_opts, iter.pos, &iter, k);
 		PTR_ERR_OR_ZERO(io_opts);
 	})) ?:
diff --git a/fs/bcachefs/rebalance.h b/fs/bcachefs/rebalance.h
index 7a565ea7dbfc..9f2839ddb60e 100644
--- a/fs/bcachefs/rebalance.h
+++ b/fs/bcachefs/rebalance.h
@@ -8,7 +8,7 @@
 #include "rebalance_types.h"
 
 static inline struct bch_extent_rebalance io_opts_to_rebalance_opts(struct bch_fs *c,
-								    struct bch_io_opts *opts)
+								    struct bch_inode_opts *opts)
 {
 	struct bch_extent_rebalance r = {
 		.type = BIT(BCH_EXTENT_ENTRY_rebalance),
@@ -27,9 +27,9 @@ static inline struct bch_extent_rebalance io_opts_to_rebalance_opts(struct bch_f
 };
 
 u64 bch2_bkey_sectors_need_rebalance(struct bch_fs *, struct bkey_s_c);
-int bch2_bkey_set_needs_rebalance(struct bch_fs *, struct bch_io_opts *, struct bkey_i *);
+int bch2_bkey_set_needs_rebalance(struct bch_fs *, struct bch_inode_opts *, struct bkey_i *);
 int bch2_get_update_rebalance_opts(struct btree_trans *,
-				   struct bch_io_opts *,
+				   struct bch_inode_opts *,
 				   struct btree_iter *,
 				   struct bkey_s_c);
 
diff --git a/fs/bcachefs/reflink.c b/fs/bcachefs/reflink.c
index 238a362de19e..55ad8ab7a148 100644
--- a/fs/bcachefs/reflink.c
+++ b/fs/bcachefs/reflink.c
@@ -589,7 +589,7 @@ s64 bch2_remap_range(struct bch_fs *c,
 	struct bpos dst_start = POS(dst_inum.inum, dst_offset);
 	struct bpos src_start = POS(src_inum.inum, src_offset);
 	struct bpos dst_end = dst_start, src_end = src_start;
-	struct bch_io_opts opts;
+	struct bch_inode_opts opts;
 	struct bpos src_want;
 	u64 dst_done = 0;
 	u32 dst_snapshot, src_snapshot;
-- 
2.50.1


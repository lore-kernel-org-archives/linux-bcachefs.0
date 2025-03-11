Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45E4E262817
	for <linux-bcachefs@vger.kernel.org>; Tue, 11 Mar 2025 20:15:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741724139; cv=none; b=Scb0fSvmQY7AtW9UmwoRYoJ0KedAxKWGo6Jlz4uaJ5nrNtmRPD2xP9A4sDyxt+FHjgWxigBbaO29qSAZNAvvERRMhMtxnEZ1mDumYBWxLLrRNvkQ3AXkgyo4NX3opwXlwTIn5stST/GBPnXaxXl2OnCpUUEhRArs6VckxAEGeLY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741724139; c=relaxed/simple;
	bh=Js70HwunBiNDIwn29w2itgfXT50YGhAWU7rwsTR6S/U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bNzYldWken8hsfVyno6p1bh898qpHlYOVtGEzWPbX7ZUm4rAE9irNIYIgS0bUggA/fJzxJolcqZX/SucSkkYOrPtVfV4MRDew+7VXz057tWJsIhZFOs2fUf43YRMV5Lmjc3d3VwNGyR+WjA4IsZMimFpaBErw5XIL2i7L2elMiU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=tK+ybl4C; arc=none smtp.client-ip=91.218.175.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="tK+ybl4C"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1741724134;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3Y6HZ8he06ba9YUOxMJp0RkOs7PgNSSUznv3NFChkIo=;
	b=tK+ybl4CfleeT/L5mEmQVstcnn8n4NSPWRHjefL2pD07jrJ5Zp7sl29cjIV8w5Egmq+BAZ
	V5lURQ7QzjumcLp9+ceiOw9aavvRk5NdOHYarfaCNFpY17YpSKr6nsuxIvaXqI/f7IFh5B
	lZqE7DXe52b7yNA+GItZ9IndIyIHTKo=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 08/14] bcachefs: Checksum errors get additional retries
Date: Tue, 11 Mar 2025 16:15:10 -0400
Message-ID: <20250311201518.3573009-9-kent.overstreet@linux.dev>
In-Reply-To: <20250311201518.3573009-1-kent.overstreet@linux.dev>
References: <20250311201518.3573009-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

It's possible for checksum errors to be transient - e.g. flakey
controller or cable, thus we need additional retries (besides retrying
from different replicas) before we can definitely return an error.

This is particularly important for the next patch, which will allow the
data move path to move extents with checksum errors - we don't want to
accidentally introduce bitrot due to a transient error!

- bch2_bkey_pick_read_device() is substantially reworked, and
  bch2_dev_io_failures is expanded to record more information about the
  type of failure (i.e. number of checksum errors).

  It now returns an error code that describes more precisely the reason
  for the failure - checksum error, io error, or offline device, instead
  of the previous generic "insufficient devices". This is important for
  the next patches that add poisoning, as we only want to poison extents
  when we've got real checksum errors (or perhaps IO errors?) - not
  because a device was offline.

- Add a new option and superblock field for the number of checksum
  retries.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/bcachefs_format.h |   2 +
 fs/bcachefs/btree_io.c        |   2 +-
 fs/bcachefs/errcode.h         |   4 +-
 fs/bcachefs/extents.c         | 155 ++++++++++++++++++++--------------
 fs/bcachefs/extents.h         |   7 +-
 fs/bcachefs/extents_types.h   |  11 +--
 fs/bcachefs/io_read.c         |  10 ++-
 fs/bcachefs/opts.h            |   5 ++
 fs/bcachefs/super-io.c        |   4 +
 9 files changed, 121 insertions(+), 79 deletions(-)

diff --git a/fs/bcachefs/bcachefs_format.h b/fs/bcachefs/bcachefs_format.h
index 7a5b0d211a82..e96d87767020 100644
--- a/fs/bcachefs/bcachefs_format.h
+++ b/fs/bcachefs/bcachefs_format.h
@@ -842,6 +842,7 @@ LE64_BITMASK(BCH_SB_SHARD_INUMS,	struct bch_sb, flags[3], 28, 29);
 LE64_BITMASK(BCH_SB_INODES_USE_KEY_CACHE,struct bch_sb, flags[3], 29, 30);
 LE64_BITMASK(BCH_SB_JOURNAL_FLUSH_DELAY,struct bch_sb, flags[3], 30, 62);
 LE64_BITMASK(BCH_SB_JOURNAL_FLUSH_DISABLED,struct bch_sb, flags[3], 62, 63);
+/* one free bit */
 LE64_BITMASK(BCH_SB_JOURNAL_RECLAIM_DELAY,struct bch_sb, flags[4], 0, 32);
 LE64_BITMASK(BCH_SB_JOURNAL_TRANSACTION_NAMES,struct bch_sb, flags[4], 32, 33);
 LE64_BITMASK(BCH_SB_NOCOW,		struct bch_sb, flags[4], 33, 34);
@@ -861,6 +862,7 @@ LE64_BITMASK(BCH_SB_VERSION_INCOMPAT_ALLOWED,
 					struct bch_sb, flags[5], 48, 64);
 LE64_BITMASK(BCH_SB_SHARD_INUMS_NBITS,	struct bch_sb, flags[6],  0,  4);
 LE64_BITMASK(BCH_SB_WRITE_ERROR_TIMEOUT,struct bch_sb, flags[6],  4, 14);
+LE64_BITMASK(BCH_SB_CSUM_ERR_RETRY_NR,	struct bch_sb, flags[6], 14, 20);
 
 static inline __u64 BCH_SB_COMPRESSION_TYPE(const struct bch_sb *sb)
 {
diff --git a/fs/bcachefs/btree_io.c b/fs/bcachefs/btree_io.c
index cd792fee7ee3..6abc9f17ea3c 100644
--- a/fs/bcachefs/btree_io.c
+++ b/fs/bcachefs/btree_io.c
@@ -1355,7 +1355,7 @@ static void btree_node_read_work(struct work_struct *work)
 			percpu_ref_put(&ca->io_ref);
 		rb->have_ioref = false;
 
-		bch2_mark_io_failure(&failed, &rb->pick);
+		bch2_mark_io_failure(&failed, &rb->pick, false);
 
 		can_retry = bch2_bkey_pick_read_device(c,
 				bkey_i_to_s_c(&b->key),
diff --git a/fs/bcachefs/errcode.h b/fs/bcachefs/errcode.h
index afa16d58041e..493cae4efc37 100644
--- a/fs/bcachefs/errcode.h
+++ b/fs/bcachefs/errcode.h
@@ -273,7 +273,6 @@
 	x(EIO,				stripe_reconstruct)			\
 	x(EIO,				key_type_error)				\
 	x(EIO,				extent_poisened)			\
-	x(EIO,				no_device_to_read_from)			\
 	x(EIO,				missing_indirect_extent)		\
 	x(EIO,				invalidate_stripe_to_dev)		\
 	x(EIO,				no_encryption_key)			\
@@ -283,6 +282,9 @@
 	x(EIO,				ec_block_read)				\
 	x(EIO,				ec_block_write)				\
 	x(EIO,				data_read)				\
+	x(BCH_ERR_data_read,		no_device_to_read_from)			\
+	x(BCH_ERR_data_read,		data_read_io_err)			\
+	x(BCH_ERR_data_read,		data_read_csum_err)			\
 	x(BCH_ERR_data_read,		data_read_retry)			\
 	x(BCH_ERR_data_read_retry,	data_read_retry_avoid)			\
 	x(BCH_ERR_data_read_retry_avoid,data_read_retry_device_offline)		\
diff --git a/fs/bcachefs/extents.c b/fs/bcachefs/extents.c
index d5f3457179c5..1df0e034e988 100644
--- a/fs/bcachefs/extents.c
+++ b/fs/bcachefs/extents.c
@@ -58,7 +58,8 @@ struct bch_dev_io_failures *bch2_dev_io_failures(struct bch_io_failures *f,
 }
 
 void bch2_mark_io_failure(struct bch_io_failures *failed,
-			  struct extent_ptr_decoded *p)
+			  struct extent_ptr_decoded *p,
+			  bool csum_error)
 {
 	struct bch_dev_io_failures *f = bch2_dev_io_failures(failed, p->ptr.dev);
 
@@ -66,17 +67,16 @@ void bch2_mark_io_failure(struct bch_io_failures *failed,
 		BUG_ON(failed->nr >= ARRAY_SIZE(failed->devs));
 
 		f = &failed->devs[failed->nr++];
-		f->dev		= p->ptr.dev;
-		f->idx		= p->idx;
-		f->nr_failed	= 1;
-		f->nr_retries	= 0;
-	} else if (p->idx != f->idx) {
-		f->idx		= p->idx;
-		f->nr_failed	= 1;
-		f->nr_retries	= 0;
-	} else {
-		f->nr_failed++;
+		memset(f, 0, sizeof(*f));
+		f->dev = p->ptr.dev;
 	}
+
+	if (p->do_ec_reconstruct)
+		f->failed_ec = true;
+	else if (!csum_error)
+		f->failed_io = true;
+	else
+		f->failed_csum_nr++;
 }
 
 static inline u64 dev_latency(struct bch_dev *ca)
@@ -96,35 +96,37 @@ static inline bool ptr_better(struct bch_fs *c,
 			      const struct extent_ptr_decoded p1,
 			      const struct extent_ptr_decoded p2)
 {
-	if (likely(!p1.idx && !p2.idx)) {
-		struct bch_dev *ca1 = bch2_dev_rcu(c, p1.ptr.dev);
-		struct bch_dev *ca2 = bch2_dev_rcu(c, p2.ptr.dev);
+	struct bch_dev *ca1 = bch2_dev_rcu(c, p1.ptr.dev);
+	struct bch_dev *ca2 = bch2_dev_rcu(c, p2.ptr.dev);
 
-		int failed_delta = dev_failed(ca1) - dev_failed(ca2);
+	int failed_delta = dev_failed(ca1) - dev_failed(ca2);
+	if (unlikely(failed_delta))
+		return failed_delta < 0;
 
-		if (failed_delta)
-			return failed_delta < 0;
+	if (unlikely(bch2_force_reconstruct_read))
+		return p1.do_ec_reconstruct > p2.do_ec_reconstruct;
 
-		u64 l1 = dev_latency(ca1);
-		u64 l2 = dev_latency(ca2);
+	if (unlikely(p1.do_ec_reconstruct || p2.do_ec_reconstruct))
+		return p1.do_ec_reconstruct < p2.do_ec_reconstruct;
 
-		/*
-		 * Square the latencies, to bias more in favor of the faster
-		 * device - we never want to stop issuing reads to the slower
-		 * device altogether, so that we can update our latency numbers:
-		 */
-		l1 *= l1;
-		l2 *= l2;
+	int crc_retry_delta = (int) p1.crc_retry_nr - (int) p2.crc_retry_nr;
+	if (unlikely(crc_retry_delta))
+		return crc_retry_delta < 0;
 
-		/* Pick at random, biased in favor of the faster device: */
+	u64 l1 = dev_latency(ca1);
+	u64 l2 = dev_latency(ca2);
 
-		return bch2_rand_range(l1 + l2) > l1;
-	}
+	/*
+	 * Square the latencies, to bias more in favor of the faster
+	 * device - we never want to stop issuing reads to the slower
+	 * device altogether, so that we can update our latency numbers:
+	 */
+	l1 *= l1;
+	l2 *= l2;
 
-	if (bch2_force_reconstruct_read)
-		return p1.idx > p2.idx;
+	/* Pick at random, biased in favor of the faster device: */
 
-	return p1.idx < p2.idx;
+	return bch2_rand_range(l1 + l2) > l1;
 }
 
 /*
@@ -133,73 +135,96 @@ static inline bool ptr_better(struct bch_fs *c,
  * other devices, it will still pick a pointer from avoid.
  */
 int bch2_bkey_pick_read_device(struct bch_fs *c, struct bkey_s_c k,
-			      struct bch_io_failures *failed,
-			      struct extent_ptr_decoded *pick,
-			      int dev)
+			       struct bch_io_failures *failed,
+			       struct extent_ptr_decoded *pick,
+			       int dev)
 {
-	struct bkey_ptrs_c ptrs = bch2_bkey_ptrs_c(k);
-	const union bch_extent_entry *entry;
-	struct extent_ptr_decoded p;
-	struct bch_dev_io_failures *f;
-	int ret = 0;
+	bool have_csum_errors = false, have_io_errors = false, have_missing_devs = false;
+	bool have_dirty_ptrs = false, have_pick = false;
 
 	if (k.k->type == KEY_TYPE_error)
 		return -BCH_ERR_key_type_error;
 
+	struct bkey_ptrs_c ptrs = bch2_bkey_ptrs_c(k);
+
 	if (bch2_bkey_extent_ptrs_flags(ptrs) & BIT_ULL(BCH_EXTENT_FLAG_poisoned))
 		return -BCH_ERR_extent_poisened;
 
 	rcu_read_lock();
+	const union bch_extent_entry *entry;
+	struct extent_ptr_decoded p;
+
 	bkey_for_each_ptr_decode(k.k, ptrs, p, entry) {
+		have_dirty_ptrs |= !p.ptr.cached;
+
 		/*
 		 * Unwritten extent: no need to actually read, treat it as a
 		 * hole and return 0s:
 		 */
 		if (p.ptr.unwritten) {
-			ret = 0;
-			break;
+			rcu_read_unlock();
+			return 0;
 		}
 
 		/* Are we being asked to read from a specific device? */
 		if (dev >= 0 && p.ptr.dev != dev)
 			continue;
 
-		/*
-		 * If there are any dirty pointers it's an error if we can't
-		 * read:
-		 */
-		if (!ret && !p.ptr.cached)
-			ret = -BCH_ERR_no_device_to_read_from;
-
 		struct bch_dev *ca = bch2_dev_rcu(c, p.ptr.dev);
 
 		if (p.ptr.cached && (!ca || dev_ptr_stale_rcu(ca, &p.ptr)))
 			continue;
 
-		f = failed ? bch2_dev_io_failures(failed, p.ptr.dev) : NULL;
-		if (f)
-			p.idx = f->nr_failed < f->nr_retries
-				? f->idx
-				: f->idx + 1;
+		struct bch_dev_io_failures *f =
+			unlikely(failed) ? bch2_dev_io_failures(failed, p.ptr.dev) : NULL;
+		if (unlikely(f)) {
+			p.crc_retry_nr	   = f->failed_csum_nr;
+			p.has_ec	  &= ~f->failed_ec;
 
-		if (!p.idx && (!ca || !bch2_dev_is_online(ca)))
-			p.idx++;
+			if (ca && ca->mi.state != BCH_MEMBER_STATE_failed) {
+				have_io_errors	|= f->failed_io;
+				have_io_errors	|= f->failed_ec;
+			}
+			have_csum_errors	|= !!f->failed_csum_nr;
 
-		if (!p.idx && p.has_ec && bch2_force_reconstruct_read)
-			p.idx++;
+			if (p.has_ec && (f->failed_io || f->failed_csum_nr))
+				p.do_ec_reconstruct = true;
+			else if (f->failed_io ||
+				 f->failed_csum_nr > c->opts.checksum_err_retry_nr)
+				continue;
+		}
 
-		if (p.idx > (unsigned) p.has_ec)
-			continue;
+		have_missing_devs |= ca && !bch2_dev_is_online(ca);
 
-		if (ret > 0 && !ptr_better(c, p, *pick))
-			continue;
+		if (!ca || !bch2_dev_is_online(ca)) {
+			if (!p.has_ec)
+				continue;
+			p.do_ec_reconstruct = true;
+		}
+
+		if (bch2_force_reconstruct_read && p.has_ec)
+			p.do_ec_reconstruct = true;
 
-		*pick = p;
-		ret = 1;
+		if (!have_pick || ptr_better(c, p, *pick)) {
+			*pick = p;
+			have_pick = true;
+		}
 	}
 	rcu_read_unlock();
 
-	return ret;
+	if (have_pick)
+		return 1;
+	if (!have_dirty_ptrs)
+		return 0;
+	if (have_missing_devs)
+		return -BCH_ERR_no_device_to_read_from;
+	if (have_csum_errors)
+		return -BCH_ERR_data_read_csum_err;
+	if (have_io_errors)
+		return -BCH_ERR_data_read_io_err;
+
+	WARN_ONCE(1, "unhandled error case in %s\n", __func__);
+	return -EINVAL;
 }
 
 /* KEY_TYPE_btree_ptr: */
diff --git a/fs/bcachefs/extents.h b/fs/bcachefs/extents.h
index c50c4f353bab..e78a39e7e18f 100644
--- a/fs/bcachefs/extents.h
+++ b/fs/bcachefs/extents.h
@@ -320,8 +320,9 @@ static inline struct bkey_ptrs bch2_bkey_ptrs(struct bkey_s k)
 ({									\
 	__label__ out;							\
 									\
-	(_ptr).idx	= 0;						\
-	(_ptr).has_ec	= false;					\
+	(_ptr).has_ec			= false;			\
+	(_ptr).do_ec_reconstruct	= false;			\
+	(_ptr).crc_retry_nr		= 0;				\
 									\
 	__bkey_extent_entry_for_each_from(_entry, _end, _entry)		\
 		switch (__extent_entry_type(_entry)) {			\
@@ -401,7 +402,7 @@ out:									\
 struct bch_dev_io_failures *bch2_dev_io_failures(struct bch_io_failures *,
 						 unsigned);
 void bch2_mark_io_failure(struct bch_io_failures *,
-			  struct extent_ptr_decoded *);
+			  struct extent_ptr_decoded *, bool);
 int bch2_bkey_pick_read_device(struct bch_fs *, struct bkey_s_c,
 			       struct bch_io_failures *,
 			       struct extent_ptr_decoded *, int);
diff --git a/fs/bcachefs/extents_types.h b/fs/bcachefs/extents_types.h
index 43d6c341ecca..e51529dca4c2 100644
--- a/fs/bcachefs/extents_types.h
+++ b/fs/bcachefs/extents_types.h
@@ -20,8 +20,9 @@ struct bch_extent_crc_unpacked {
 };
 
 struct extent_ptr_decoded {
-	unsigned			idx;
 	bool				has_ec;
+	bool				do_ec_reconstruct;
+	u8				crc_retry_nr;
 	struct bch_extent_crc_unpacked	crc;
 	struct bch_extent_ptr		ptr;
 	struct bch_extent_stripe_ptr	ec;
@@ -31,10 +32,10 @@ struct bch_io_failures {
 	u8			nr;
 	struct bch_dev_io_failures {
 		u8		dev;
-		u8		idx;
-		u8		nr_failed;
-		u8		nr_retries;
-	}			devs[BCH_REPLICAS_MAX];
+		unsigned	failed_csum_nr:6,
+				failed_io:1,
+				failed_ec:1;
+	}			devs[BCH_REPLICAS_MAX + 1];
 };
 
 #endif /* _BCACHEFS_EXTENTS_TYPES_H */
diff --git a/fs/bcachefs/io_read.c b/fs/bcachefs/io_read.c
index 61fb3e558450..40a23e779e6c 100644
--- a/fs/bcachefs/io_read.c
+++ b/fs/bcachefs/io_read.c
@@ -481,7 +481,8 @@ static void bch2_rbio_retry(struct work_struct *work)
 		     bvec_iter_sectors(rbio->bvec_iter));
 
 	if (bch2_err_matches(rbio->ret, BCH_ERR_data_read_retry_avoid))
-		bch2_mark_io_failure(&failed, &rbio->pick);
+		bch2_mark_io_failure(&failed, &rbio->pick,
+				     rbio->ret == -BCH_ERR_data_read_retry_csum_err);
 
 	if (!rbio->split) {
 		rbio->bio.bi_status	= 0;
@@ -983,7 +984,7 @@ int __bch2_read_extent(struct btree_trans *trans, struct bch_read_bio *orig,
 	    ca &&
 	    unlikely(dev_ptr_stale(ca, &pick.ptr))) {
 		read_from_stale_dirty_pointer(trans, ca, k, pick.ptr);
-		bch2_mark_io_failure(failed, &pick);
+		bch2_mark_io_failure(failed, &pick, false);
 		percpu_ref_put(&ca->io_ref);
 		goto retry_pick;
 	}
@@ -1146,7 +1147,7 @@ int __bch2_read_extent(struct btree_trans *trans, struct bch_read_bio *orig,
 	else
 		bch2_trans_unlock_long(trans);
 
-	if (!rbio->pick.idx) {
+	if (likely(!rbio->pick.do_ec_reconstruct)) {
 		if (unlikely(!rbio->have_ioref)) {
 			struct printbuf buf = PRINTBUF;
 			bch2_read_err_msg_trans(trans, &buf, rbio, read_pos);
@@ -1207,7 +1208,8 @@ int __bch2_read_extent(struct btree_trans *trans, struct bch_read_bio *orig,
 		rbio = bch2_rbio_free(rbio);
 
 		if (bch2_err_matches(ret, BCH_ERR_data_read_retry_avoid))
-			bch2_mark_io_failure(failed, &pick);
+			bch2_mark_io_failure(failed, &pick,
+					ret == -BCH_ERR_data_read_retry_csum_err);
 
 		return ret;
 	}
diff --git a/fs/bcachefs/opts.h b/fs/bcachefs/opts.h
index afb89d318d24..baa9c11acb1a 100644
--- a/fs/bcachefs/opts.h
+++ b/fs/bcachefs/opts.h
@@ -186,6 +186,11 @@ enum fsck_err_opts {
 	  OPT_STR(__bch2_csum_opts),					\
 	  BCH_SB_DATA_CSUM_TYPE,	BCH_CSUM_OPT_crc32c,		\
 	  NULL,		NULL)						\
+	x(checksum_err_retry_nr,	u8,				\
+	  OPT_FS|OPT_FORMAT|OPT_MOUNT|OPT_RUNTIME,			\
+	  OPT_UINT(0, 32),						\
+	  BCH_SB_CSUM_ERR_RETRY_NR,	3,				\
+	  NULL,		NULL)						\
 	x(compression,			u8,				\
 	  OPT_FS|OPT_INODE|OPT_FORMAT|OPT_MOUNT|OPT_RUNTIME,		\
 	  OPT_FN(bch2_opt_compression),					\
diff --git a/fs/bcachefs/super-io.c b/fs/bcachefs/super-io.c
index ee32d043414a..f87e3bf33ec0 100644
--- a/fs/bcachefs/super-io.c
+++ b/fs/bcachefs/super-io.c
@@ -457,6 +457,10 @@ static int bch2_sb_validate(struct bch_sb_handle *disk_sb,
 
 		if (!BCH_SB_WRITE_ERROR_TIMEOUT(sb))
 			SET_BCH_SB_WRITE_ERROR_TIMEOUT(sb, 30);
+
+		if (le16_to_cpu(sb->version) <= bcachefs_metadata_version_extent_flags &&
+		    !BCH_SB_CSUM_ERR_RETRY_NR(sb))
+			SET_BCH_SB_CSUM_ERR_RETRY_NR(sb, 3);
 	}
 
 #ifdef __KERNEL__
-- 
2.47.2


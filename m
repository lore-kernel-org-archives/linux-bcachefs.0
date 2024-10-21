Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A081A14A90
	for <linux-bcachefs@vger.kernel.org>; Mon, 21 Oct 2024 03:41:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729482087; cv=none; b=LChn8URWcdeuNoW+BhckniEbw+Mm8VvQ3lVt4c1b6BnLX+82w8lgr/YUqy7YOagAE2nTNRdXvxJMoSq5Akxa8BEIdVB8lgQP9fi090iPkUIC4a3Iq0GY97VXKJVlqdY7Bl4+VfqfTKbvo44JagJfr948I5kzNKAVRuVJDrczzXQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729482087; c=relaxed/simple;
	bh=WSgYt7brn8GdgAwEuoy/c8GSj0HSS1KQVMCps2EB1DE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N/COh30sw+cPHo0cIv29GWiM7x2TQ02v2bXjn5kc404kwLG20fRJPUqmErcr0YV36X73eURACAfHVaECnE+3AZ9chcoaRaPypu+2VPcfeIGqUCUUGDGnJx/sYyxI5s/JCphro5aNCAfjXtpXhvhKz2NIbA64kAF6Es/WzJaxkfo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=xCy00e85; arc=none smtp.client-ip=91.218.175.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="xCy00e85"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1729482082;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=iqQxRMbDg9Mhcd2gLfHt6tHC+InUysHRyvHxdPd/D2o=;
	b=xCy00e85Y+rGGDaM8vp0Am5a15W1QtBfsUrhsUWO+pjwCDOSKw/1DL8DQ+JGiUed/6PujH
	+s3jQSmF/3Zq3jQCxTWiPFCU3Ql1KF2+pOI4pcr+WjE66K0QhtZ/EJGJXH3niOCmCFl4rj
	fKnOTfEa3KM97er+7Q6oz9RruVeRgw0=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>,
	Reed Riley <reed@riley.engineer>
Subject: [PATCH 01/12] bcachefs: Don't keep tons of cached pointers around
Date: Sun, 20 Oct 2024 23:40:52 -0400
Message-ID: <20241021034106.384756-2-kent.overstreet@linux.dev>
In-Reply-To: <20241021034106.384756-1-kent.overstreet@linux.dev>
References: <20241021034106.384756-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

We had a bug report where the data update path was creating an extent
that failed to validate because it had too many pointers; almost all of
them were cached.

To fix this, we have:
- want_cached_ptr(), a new helper that checks if we even want a cached
  pointer (is on appropriate target, device is readable).

- bch2_extent_set_ptr_cached() now only sets a pointer cached if we want
  it.

- bch2_extent_normalize_by_opts() now ensures that we only have a single
  cached pointer that we want.

While working on this, it was noticed that this doesn't work well with
reflinked data and per-file options. Another patch series is coming that
plumbs through additional io path options through bch_extent_rebalance,
with improved option handling.

Reported-by: Reed Riley <reed@riley.engineer>
Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/data_update.c | 21 ++++++----
 fs/bcachefs/data_update.h |  3 +-
 fs/bcachefs/extents.c     | 86 +++++++++++++++++++++++++++++++--------
 fs/bcachefs/extents.h     |  5 ++-
 fs/bcachefs/move.c        |  2 +-
 5 files changed, 89 insertions(+), 28 deletions(-)

diff --git a/fs/bcachefs/data_update.c b/fs/bcachefs/data_update.c
index a6ee0beee6b0..8e75a852b358 100644
--- a/fs/bcachefs/data_update.c
+++ b/fs/bcachefs/data_update.c
@@ -236,7 +236,8 @@ static int __bch2_data_update_index_update(struct btree_trans *trans,
 			if (((1U << i) & m->data_opts.rewrite_ptrs) &&
 			    (ptr = bch2_extent_has_ptr(old, p, bkey_i_to_s(insert))) &&
 			    !ptr->cached) {
-				bch2_extent_ptr_set_cached(bkey_i_to_s(insert), ptr);
+				bch2_extent_ptr_set_cached(c, &m->op.opts,
+							   bkey_i_to_s(insert), ptr);
 				rewrites_found |= 1U << i;
 			}
 			i++;
@@ -284,7 +285,8 @@ static int __bch2_data_update_index_update(struct btree_trans *trans,
 			    durability - ptr_durability >= m->op.opts.data_replicas) {
 				durability -= ptr_durability;
 
-				bch2_extent_ptr_set_cached(bkey_i_to_s(insert), &entry->ptr);
+				bch2_extent_ptr_set_cached(c, &m->op.opts,
+							   bkey_i_to_s(insert), &entry->ptr);
 				goto restart_drop_extra_replicas;
 			}
 		}
@@ -295,7 +297,7 @@ static int __bch2_data_update_index_update(struct btree_trans *trans,
 			bch2_extent_ptr_decoded_append(insert, &p);
 
 		bch2_bkey_narrow_crcs(insert, (struct bch_extent_crc_unpacked) { 0 });
-		bch2_extent_normalize(c, bkey_i_to_s(insert));
+		bch2_extent_normalize_by_opts(c, &m->op.opts, bkey_i_to_s(insert));
 
 		ret = bch2_sum_sector_overwrites(trans, &iter, insert,
 						 &should_check_enospc,
@@ -558,7 +560,8 @@ void bch2_data_update_to_text(struct printbuf *out, struct data_update *m)
 int bch2_extent_drop_ptrs(struct btree_trans *trans,
 			  struct btree_iter *iter,
 			  struct bkey_s_c k,
-			  struct data_update_opts data_opts)
+			  struct bch_io_opts *io_opts,
+			  struct data_update_opts *data_opts)
 {
 	struct bch_fs *c = trans->c;
 	struct bkey_i *n;
@@ -569,11 +572,11 @@ int bch2_extent_drop_ptrs(struct btree_trans *trans,
 	if (ret)
 		return ret;
 
-	while (data_opts.kill_ptrs) {
-		unsigned i = 0, drop = __fls(data_opts.kill_ptrs);
+	while (data_opts->kill_ptrs) {
+		unsigned i = 0, drop = __fls(data_opts->kill_ptrs);
 
 		bch2_bkey_drop_ptrs_noerror(bkey_i_to_s(n), ptr, i++ == drop);
-		data_opts.kill_ptrs ^= 1U << drop;
+		data_opts->kill_ptrs ^= 1U << drop;
 	}
 
 	/*
@@ -581,7 +584,7 @@ int bch2_extent_drop_ptrs(struct btree_trans *trans,
 	 * will do the appropriate thing with it (turning it into a
 	 * KEY_TYPE_error key, or just a discard if it was a cached extent)
 	 */
-	bch2_extent_normalize(c, bkey_i_to_s(n));
+	bch2_extent_normalize_by_opts(c, io_opts, bkey_i_to_s(n));
 
 	/*
 	 * Since we're not inserting through an extent iterator
@@ -720,7 +723,7 @@ int bch2_data_update_init(struct btree_trans *trans,
 		m->data_opts.rewrite_ptrs = 0;
 		/* if iter == NULL, it's just a promote */
 		if (iter)
-			ret = bch2_extent_drop_ptrs(trans, iter, k, m->data_opts);
+			ret = bch2_extent_drop_ptrs(trans, iter, k, &io_opts, &m->data_opts);
 		goto out;
 	}
 
diff --git a/fs/bcachefs/data_update.h b/fs/bcachefs/data_update.h
index 8d36365bdea8..e4b50723428e 100644
--- a/fs/bcachefs/data_update.h
+++ b/fs/bcachefs/data_update.h
@@ -40,7 +40,8 @@ void bch2_data_update_read_done(struct data_update *,
 int bch2_extent_drop_ptrs(struct btree_trans *,
 			  struct btree_iter *,
 			  struct bkey_s_c,
-			  struct data_update_opts);
+			  struct bch_io_opts *,
+			  struct data_update_opts *);
 
 void bch2_data_update_exit(struct data_update *);
 int bch2_data_update_init(struct btree_trans *, struct btree_iter *,
diff --git a/fs/bcachefs/extents.c b/fs/bcachefs/extents.c
index b7b5ea9ca8b2..33f611f13570 100644
--- a/fs/bcachefs/extents.c
+++ b/fs/bcachefs/extents.c
@@ -979,31 +979,54 @@ bch2_extent_has_ptr(struct bkey_s_c k1, struct extent_ptr_decoded p1, struct bke
 	return NULL;
 }
 
-void bch2_extent_ptr_set_cached(struct bkey_s k, struct bch_extent_ptr *ptr)
+static bool want_cached_ptr(struct bch_fs *c, struct bch_io_opts *opts,
+			    struct bch_extent_ptr *ptr)
+{
+	if (!opts->promote_target ||
+	    !bch2_dev_in_target(c, ptr->dev, opts->promote_target))
+		return false;
+
+	struct bch_dev *ca = bch2_dev_rcu_noerror(c, ptr->dev);
+
+	return ca && bch2_dev_is_readable(ca) && !dev_ptr_stale_rcu(ca, ptr);
+}
+
+void bch2_extent_ptr_set_cached(struct bch_fs *c,
+				struct bch_io_opts *opts,
+				struct bkey_s k,
+				struct bch_extent_ptr *ptr)
 {
 	struct bkey_ptrs ptrs = bch2_bkey_ptrs(k);
 	union bch_extent_entry *entry;
-	union bch_extent_entry *ec = NULL;
+	struct extent_ptr_decoded p;
 
-	bkey_extent_entry_for_each(ptrs, entry) {
+	rcu_read_lock();
+	if (!want_cached_ptr(c, opts, ptr)) {
+		extent_entry_drop(k, (union bch_extent_entry *) ptr);
+		goto out;
+	}
+
+	/*
+	 * Stripes can't contain cached data, for - reasons.
+	 *
+	 * Possibly something we can fix in the future?
+	 */
+	bkey_for_each_ptr_decode(k.k, ptrs, p, entry)
 		if (&entry->ptr == ptr) {
-			ptr->cached = true;
-			if (ec)
-				extent_entry_drop(k, ec);
-			return;
+			if (p.has_ec)
+				extent_entry_drop(k, entry);
+			else
+				ptr->cached = true;
+			goto out;
 		}
 
-		if (extent_entry_is_stripe_ptr(entry))
-			ec = entry;
-		else if (extent_entry_is_ptr(entry))
-			ec = NULL;
-	}
-
 	BUG();
+out:
+	rcu_read_unlock();
 }
 
 /*
- * bch_extent_normalize - clean up an extent, dropping stale pointers etc.
+ * bch2_extent_normalize - clean up an extent, dropping stale pointers etc.
  *
  * Returns true if @k should be dropped entirely
  *
@@ -1017,8 +1040,39 @@ bool bch2_extent_normalize(struct bch_fs *c, struct bkey_s k)
 	rcu_read_lock();
 	bch2_bkey_drop_ptrs(k, ptr,
 		ptr->cached &&
-		(ca = bch2_dev_rcu(c, ptr->dev)) &&
-		dev_ptr_stale_rcu(ca, ptr) > 0);
+		(!(ca = bch2_dev_rcu(c, ptr->dev)) ||
+		 dev_ptr_stale_rcu(ca, ptr) > 0));
+	rcu_read_unlock();
+
+	return bkey_deleted(k.k);
+}
+
+/*
+ * bch2_extent_normalize_by_opts - clean up an extent, dropping stale pointers etc.
+ *
+ * Like bch2_extent_normalize(), but also only keeps a single cached pointer on
+ * the promote target.
+ */
+bool bch2_extent_normalize_by_opts(struct bch_fs *c,
+				   struct bch_io_opts *opts,
+				   struct bkey_s k)
+{
+	struct bkey_ptrs ptrs;
+	bool have_cached_ptr;
+
+	rcu_read_lock();
+restart_drop_ptrs:
+	ptrs = bch2_bkey_ptrs(k);
+	have_cached_ptr = false;
+
+	bkey_for_each_ptr(ptrs, ptr)
+		if (ptr->cached) {
+			if (have_cached_ptr || !want_cached_ptr(c, opts, ptr)) {
+				bch2_bkey_drop_ptr(k, ptr);
+				goto restart_drop_ptrs;
+			}
+			have_cached_ptr = true;
+		}
 	rcu_read_unlock();
 
 	return bkey_deleted(k.k);
diff --git a/fs/bcachefs/extents.h b/fs/bcachefs/extents.h
index 923a5f1849a8..bcffcf60aaaf 100644
--- a/fs/bcachefs/extents.h
+++ b/fs/bcachefs/extents.h
@@ -686,9 +686,12 @@ bool bch2_extents_match(struct bkey_s_c, struct bkey_s_c);
 struct bch_extent_ptr *
 bch2_extent_has_ptr(struct bkey_s_c, struct extent_ptr_decoded, struct bkey_s);
 
-void bch2_extent_ptr_set_cached(struct bkey_s, struct bch_extent_ptr *);
+void bch2_extent_ptr_set_cached(struct bch_fs *, struct bch_io_opts *,
+				struct bkey_s, struct bch_extent_ptr *);
 
+bool bch2_extent_normalize_by_opts(struct bch_fs *, struct bch_io_opts *, struct bkey_s);
 bool bch2_extent_normalize(struct bch_fs *, struct bkey_s);
+
 void bch2_extent_ptr_to_text(struct printbuf *out, struct bch_fs *, const struct bch_extent_ptr *);
 void bch2_bkey_ptrs_to_text(struct printbuf *, struct bch_fs *,
 			    struct bkey_s_c);
diff --git a/fs/bcachefs/move.c b/fs/bcachefs/move.c
index 8c456d8b8b99..0ef4a86850bb 100644
--- a/fs/bcachefs/move.c
+++ b/fs/bcachefs/move.c
@@ -266,7 +266,7 @@ int bch2_move_extent(struct moving_context *ctxt,
 	if (!data_opts.rewrite_ptrs &&
 	    !data_opts.extra_replicas) {
 		if (data_opts.kill_ptrs)
-			return bch2_extent_drop_ptrs(trans, iter, k, data_opts);
+			return bch2_extent_drop_ptrs(trans, iter, k, &io_opts, &data_opts);
 		return 0;
 	}
 
-- 
2.45.2


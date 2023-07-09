Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B7BBC04A6A
	for <linux-bcachefs@archiver.kernel.org>; Sun,  9 Jul 2023 17:16:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230351AbjGIRQJ (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Sun, 9 Jul 2023 13:16:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230430AbjGIRQI (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Sun, 9 Jul 2023 13:16:08 -0400
Received: from out-31.mta0.migadu.com (out-31.mta0.migadu.com [IPv6:2001:41d0:1004:224b::1f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3803812A
        for <linux-bcachefs@vger.kernel.org>; Sun,  9 Jul 2023 10:16:05 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1688922962;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=l9oNai8cxkxelqWCU7WY7FMktf0jL4lu1UVnNXRbS98=;
        b=ksAYk5KbRlyRFodiLZXaYmhbnqPt3qXjBFETAOkDiG8g+gGQSzMVWx8GQhcyj4dIB/TvzF
        /nBZxIXxmwAFyA5MbWiRdyVP7T5GoPISWUqu31T7iCKztMcZKQdbt0dcvfhk+wYxarvt9p
        YZHcGCli0PDGnYxxFDPhat8ul+g2c0E=
From:   Kent Overstreet <kent.overstreet@linux.dev>
To:     linux-bcachefs@vger.kernel.org
Cc:     Kent Overstreet <kent.overstreet@linux.dev>, bfoster@redhat.com,
        sandeen@redhat.com
Subject: [PATCH 04/10] bcachefs: Change check for invalid key types
Date:   Sun,  9 Jul 2023 13:15:45 -0400
Message-Id: <20230709171551.2349961-5-kent.overstreet@linux.dev>
In-Reply-To: <20230709171551.2349961-1-kent.overstreet@linux.dev>
References: <20230709171551.2349961-1-kent.overstreet@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

As part of the forward compatibility patch series, we need to allow for
new key types without complaining loudly when running an old version.

This patch changes the flags parameter of bkey_invalid to an enum, and
adds a new flag to indicate we're being called from the transaction
commit path.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/alloc_background.c  | 14 +++++++----
 fs/bcachefs/alloc_background.h  | 17 +++++++++----
 fs/bcachefs/backpointers.c      |  3 ++-
 fs/bcachefs/backpointers.h      |  2 +-
 fs/bcachefs/bkey_methods.c      | 43 ++++++++++++++++++---------------
 fs/bcachefs/bkey_methods.h      | 10 +++++---
 fs/bcachefs/btree_update_leaf.c |  7 ++++--
 fs/bcachefs/dirent.c            |  3 ++-
 fs/bcachefs/dirent.h            |  4 ++-
 fs/bcachefs/ec.c                |  3 ++-
 fs/bcachefs/ec.h                |  4 ++-
 fs/bcachefs/extents.c           | 12 ++++++---
 fs/bcachefs/extents.h           |  9 ++++---
 fs/bcachefs/inode.c             | 12 ++++++---
 fs/bcachefs/inode.h             | 12 ++++++---
 fs/bcachefs/journal_io.c        |  3 ++-
 fs/bcachefs/lru.c               |  3 ++-
 fs/bcachefs/lru.h               |  3 ++-
 fs/bcachefs/quota.c             |  3 ++-
 fs/bcachefs/quota.h             |  4 ++-
 fs/bcachefs/reflink.c           |  9 ++++---
 fs/bcachefs/reflink.h           |  8 +++---
 fs/bcachefs/subvolume.c         |  6 +++--
 fs/bcachefs/subvolume.h         |  6 +++--
 fs/bcachefs/xattr.c             |  3 ++-
 fs/bcachefs/xattr.h             |  3 ++-
 26 files changed, 133 insertions(+), 73 deletions(-)

diff --git a/fs/bcachefs/alloc_background.c b/fs/bcachefs/alloc_background.c
index f7ecea8325..c59629bbbc 100644
--- a/fs/bcachefs/alloc_background.c
+++ b/fs/bcachefs/alloc_background.c
@@ -223,7 +223,8 @@ static unsigned bch_alloc_v1_val_u64s(const struct bch_alloc *a)
 }
 
 int bch2_alloc_v1_invalid(const struct bch_fs *c, struct bkey_s_c k,
-			  unsigned flags, struct printbuf *err)
+			  enum bkey_invalid_flags flags,
+			  struct printbuf *err)
 {
 	struct bkey_s_c_alloc a = bkey_s_c_to_alloc(k);
 
@@ -238,7 +239,8 @@ int bch2_alloc_v1_invalid(const struct bch_fs *c, struct bkey_s_c k,
 }
 
 int bch2_alloc_v2_invalid(const struct bch_fs *c, struct bkey_s_c k,
-			  unsigned flags, struct printbuf *err)
+			  enum bkey_invalid_flags flags,
+			  struct printbuf *err)
 {
 	struct bkey_alloc_unpacked u;
 
@@ -251,7 +253,8 @@ int bch2_alloc_v2_invalid(const struct bch_fs *c, struct bkey_s_c k,
 }
 
 int bch2_alloc_v3_invalid(const struct bch_fs *c, struct bkey_s_c k,
-			  unsigned flags, struct printbuf *err)
+			  enum bkey_invalid_flags flags,
+			  struct printbuf *err)
 {
 	struct bkey_alloc_unpacked u;
 
@@ -282,7 +285,7 @@ int bch2_alloc_v4_invalid(const struct bch_fs *c, struct bkey_s_c k,
 	}
 
 	if (rw == WRITE &&
-	    !(flags & BKEY_INVALID_FROM_JOURNAL) &&
+	    !(flags & BKEY_INVALID_JOURNAL) &&
 	    test_bit(BCH_FS_CHECK_BACKPOINTERS_DONE, &c->flags)) {
 		unsigned i, bp_len = 0;
 
@@ -605,7 +608,8 @@ static unsigned alloc_gen(struct bkey_s_c k, unsigned offset)
 }
 
 int bch2_bucket_gens_invalid(const struct bch_fs *c, struct bkey_s_c k,
-			     unsigned flags, struct printbuf *err)
+			     enum bkey_invalid_flags flags,
+			     struct printbuf *err)
 {
 	if (bkey_val_bytes(k.k) != sizeof(struct bch_bucket_gens)) {
 		prt_printf(err, "bad val size (%lu != %zu)",
diff --git a/fs/bcachefs/alloc_background.h b/fs/bcachefs/alloc_background.h
index 3c4d6d40b1..d1bf45a4b4 100644
--- a/fs/bcachefs/alloc_background.h
+++ b/fs/bcachefs/alloc_background.h
@@ -8,6 +8,8 @@
 #include "debug.h"
 #include "super.h"
 
+enum bkey_invalid_flags;
+
 /* How out of date a pointer gen is allowed to be: */
 #define BUCKET_GC_GEN_MAX	96U
 
@@ -147,10 +149,14 @@ struct bkey_i_alloc_v4 *bch2_alloc_to_v4_mut(struct btree_trans *, struct bkey_s
 
 int bch2_bucket_io_time_reset(struct btree_trans *, unsigned, size_t, int);
 
-int bch2_alloc_v1_invalid(const struct bch_fs *, struct bkey_s_c, unsigned, struct printbuf *);
-int bch2_alloc_v2_invalid(const struct bch_fs *, struct bkey_s_c, unsigned, struct printbuf *);
-int bch2_alloc_v3_invalid(const struct bch_fs *, struct bkey_s_c, unsigned, struct printbuf *);
-int bch2_alloc_v4_invalid(const struct bch_fs *, struct bkey_s_c, unsigned, struct printbuf *);
+int bch2_alloc_v1_invalid(const struct bch_fs *, struct bkey_s_c,
+			  enum bkey_invalid_flags, struct printbuf *);
+int bch2_alloc_v2_invalid(const struct bch_fs *, struct bkey_s_c,
+			  enum bkey_invalid_flags, struct printbuf *);
+int bch2_alloc_v3_invalid(const struct bch_fs *, struct bkey_s_c,
+			  enum bkey_invalid_flags, struct printbuf *);
+int bch2_alloc_v4_invalid(const struct bch_fs *, struct bkey_s_c,
+			  enum bkey_invalid_flags, struct printbuf *);
 void bch2_alloc_v4_swab(struct bkey_s);
 void bch2_alloc_to_text(struct printbuf *, struct bch_fs *, struct bkey_s_c);
 
@@ -187,7 +193,8 @@ void bch2_alloc_to_text(struct printbuf *, struct bch_fs *, struct bkey_s_c);
 	.min_val_size	= 48,				\
 })
 
-int bch2_bucket_gens_invalid(const struct bch_fs *, struct bkey_s_c, unsigned, struct printbuf *);
+int bch2_bucket_gens_invalid(const struct bch_fs *, struct bkey_s_c,
+			     enum bkey_invalid_flags, struct printbuf *);
 void bch2_bucket_gens_to_text(struct printbuf *, struct bch_fs *, struct bkey_s_c);
 
 #define bch2_bkey_ops_bucket_gens ((struct bkey_ops) {	\
diff --git a/fs/bcachefs/backpointers.c b/fs/bcachefs/backpointers.c
index 760c4cc16a..571a7d19be 100644
--- a/fs/bcachefs/backpointers.c
+++ b/fs/bcachefs/backpointers.c
@@ -38,7 +38,8 @@ static bool extent_matches_bp(struct bch_fs *c,
 }
 
 int bch2_backpointer_invalid(const struct bch_fs *c, struct bkey_s_c k,
-			     unsigned flags, struct printbuf *err)
+			     enum bkey_invalid_flags flags,
+			     struct printbuf *err)
 {
 	struct bkey_s_c_backpointer bp = bkey_s_c_to_backpointer(k);
 	struct bpos bucket = bp_pos_to_bucket(c, bp.k->p);
diff --git a/fs/bcachefs/backpointers.h b/fs/bcachefs/backpointers.h
index 3994bc83d6..87e31aa197 100644
--- a/fs/bcachefs/backpointers.h
+++ b/fs/bcachefs/backpointers.h
@@ -8,7 +8,7 @@
 #include "super.h"
 
 int bch2_backpointer_invalid(const struct bch_fs *, struct bkey_s_c k,
-			     unsigned, struct printbuf *);
+			     enum bkey_invalid_flags, struct printbuf *);
 void bch2_backpointer_to_text(struct printbuf *, const struct bch_backpointer *);
 void bch2_backpointer_k_to_text(struct printbuf *, struct bch_fs *, struct bkey_s_c);
 void bch2_backpointer_swab(struct bkey_s);
diff --git a/fs/bcachefs/bkey_methods.c b/fs/bcachefs/bkey_methods.c
index 985ea2daa8..1381166bfc 100644
--- a/fs/bcachefs/bkey_methods.c
+++ b/fs/bcachefs/bkey_methods.c
@@ -123,7 +123,8 @@ const struct bkey_ops bch2_bkey_null_ops = {
 };
 
 int bch2_bkey_val_invalid(struct bch_fs *c, struct bkey_s_c k,
-			  unsigned flags, struct printbuf *err)
+			  enum bkey_invalid_flags flags,
+			  struct printbuf *err)
 {
 	const struct bkey_ops *ops = bch2_bkey_type_ops(k.k->type);
 
@@ -215,14 +216,16 @@ static unsigned bch2_key_types_allowed[] = {
 
 int __bch2_bkey_invalid(struct bch_fs *c, struct bkey_s_c k,
 			enum btree_node_type type,
-			unsigned flags, struct printbuf *err)
+			enum bkey_invalid_flags flags,
+			struct printbuf *err)
 {
 	if (k.k->u64s < BKEY_U64s) {
 		prt_printf(err, "u64s too small (%u < %zu)", k.k->u64s, BKEY_U64s);
 		return -BCH_ERR_invalid_bkey;
 	}
 
-	if (!(bch2_key_types_allowed[type] & (1U << k.k->type))) {
+	if (flags & BKEY_INVALID_COMMIT	 &&
+	    !(bch2_key_types_allowed[type] & (1U << k.k->type))) {
 		prt_printf(err, "invalid key type for btree %s (%s)",
 			   bch2_btree_ids[type], bch2_bkey_types[k.k->type]);
 		return -BCH_ERR_invalid_bkey;
@@ -246,24 +249,23 @@ int __bch2_bkey_invalid(struct bch_fs *c, struct bkey_s_c k,
 		}
 	}
 
-	if (type != BKEY_TYPE_btree &&
-	    !btree_type_has_snapshots(type) &&
-	    k.k->p.snapshot) {
-		prt_printf(err, "nonzero snapshot");
-		return -BCH_ERR_invalid_bkey;
-	}
+	if (type != BKEY_TYPE_btree) {
+		if (!btree_type_has_snapshots((enum btree_id) type) &&
+		    k.k->p.snapshot) {
+			prt_printf(err, "nonzero snapshot");
+			return -BCH_ERR_invalid_bkey;
+		}
 
-	if (type != BKEY_TYPE_btree &&
-	    btree_type_has_snapshots(type) &&
-	    !k.k->p.snapshot) {
-		prt_printf(err, "snapshot == 0");
-		return -BCH_ERR_invalid_bkey;
-	}
+		if (btree_type_has_snapshots((enum btree_id) type) &&
+		    !k.k->p.snapshot) {
+			prt_printf(err, "snapshot == 0");
+			return -BCH_ERR_invalid_bkey;
+		}
 
-	if (type != BKEY_TYPE_btree &&
-	    bkey_eq(k.k->p, POS_MAX)) {
-		prt_printf(err, "key at POS_MAX");
-		return -BCH_ERR_invalid_bkey;
+		if (bkey_eq(k.k->p, POS_MAX)) {
+			prt_printf(err, "key at POS_MAX");
+			return -BCH_ERR_invalid_bkey;
+		}
 	}
 
 	return 0;
@@ -271,7 +273,8 @@ int __bch2_bkey_invalid(struct bch_fs *c, struct bkey_s_c k,
 
 int bch2_bkey_invalid(struct bch_fs *c, struct bkey_s_c k,
 		      enum btree_node_type type,
-		      unsigned flags, struct printbuf *err)
+		      enum bkey_invalid_flags flags,
+		      struct printbuf *err)
 {
 	return __bch2_bkey_invalid(c, k, type, flags, err) ?:
 		bch2_bkey_val_invalid(c, k, flags, err);
diff --git a/fs/bcachefs/bkey_methods.h b/fs/bcachefs/bkey_methods.h
index 32b86c74cc..0f3dc156ad 100644
--- a/fs/bcachefs/bkey_methods.h
+++ b/fs/bcachefs/bkey_methods.h
@@ -13,6 +13,12 @@ enum btree_node_type;
 extern const char * const bch2_bkey_types[];
 extern const struct bkey_ops bch2_bkey_null_ops;
 
+enum bkey_invalid_flags {
+	BKEY_INVALID_WRITE		= (1U << 0),
+	BKEY_INVALID_COMMIT		= (1U << 1),
+	BKEY_INVALID_JOURNAL		= (1U << 2),
+};
+
 /*
  * key_invalid: checks validity of @k, returns 0 if good or -EINVAL if bad. If
  * invalid, entire key will be deleted.
@@ -22,7 +28,7 @@ extern const struct bkey_ops bch2_bkey_null_ops;
  */
 struct bkey_ops {
 	int		(*key_invalid)(const struct bch_fs *c, struct bkey_s_c k,
-				       unsigned flags, struct printbuf *err);
+				       enum bkey_invalid_flags flags, struct printbuf *err);
 	void		(*val_to_text)(struct printbuf *, struct bch_fs *,
 				       struct bkey_s_c);
 	void		(*swab)(struct bkey_s);
@@ -49,8 +55,6 @@ static inline const struct bkey_ops *bch2_bkey_type_ops(enum bch_bkey_type type)
 		: &bch2_bkey_null_ops;
 }
 
-#define BKEY_INVALID_FROM_JOURNAL		(1 << 1)
-
 int bch2_bkey_val_invalid(struct bch_fs *, struct bkey_s_c, unsigned, struct printbuf *);
 int __bch2_bkey_invalid(struct bch_fs *, struct bkey_s_c,
 			enum btree_node_type, unsigned, struct printbuf *);
diff --git a/fs/bcachefs/btree_update_leaf.c b/fs/bcachefs/btree_update_leaf.c
index 1474dca26d..2b43f02fc4 100644
--- a/fs/bcachefs/btree_update_leaf.c
+++ b/fs/bcachefs/btree_update_leaf.c
@@ -856,10 +856,13 @@ static inline int do_bch2_trans_commit(struct btree_trans *trans, unsigned flags
 	struct printbuf buf = PRINTBUF;
 
 	trans_for_each_update(trans, i) {
-		int rw = (flags & BTREE_INSERT_JOURNAL_REPLAY) ? READ : WRITE;
+		enum bkey_invalid_flags invalid_flags = 0;
+
+		if (!(flags & BTREE_INSERT_JOURNAL_REPLAY))
+			invalid_flags |= BKEY_INVALID_WRITE|BKEY_INVALID_COMMIT;
 
 		if (unlikely(bch2_bkey_invalid(c, bkey_i_to_s_c(i->k),
-					       i->bkey_type, rw, &buf)))
+					       i->bkey_type, invalid_flags, &buf)))
 			return bch2_trans_commit_bkey_invalid(trans, flags, i, &buf);
 		btree_insert_entry_checks(trans, i);
 	}
diff --git a/fs/bcachefs/dirent.c b/fs/bcachefs/dirent.c
index ef3f1f9b7e..065ea59ee9 100644
--- a/fs/bcachefs/dirent.c
+++ b/fs/bcachefs/dirent.c
@@ -85,7 +85,8 @@ const struct bch_hash_desc bch2_dirent_hash_desc = {
 };
 
 int bch2_dirent_invalid(const struct bch_fs *c, struct bkey_s_c k,
-			unsigned flags, struct printbuf *err)
+			enum bkey_invalid_flags flags,
+			struct printbuf *err)
 {
 	struct bkey_s_c_dirent d = bkey_s_c_to_dirent(k);
 	unsigned len;
diff --git a/fs/bcachefs/dirent.h b/fs/bcachefs/dirent.h
index bf9ea2e35f..b42f4a13bc 100644
--- a/fs/bcachefs/dirent.h
+++ b/fs/bcachefs/dirent.h
@@ -4,9 +4,11 @@
 
 #include "str_hash.h"
 
+enum bkey_invalid_flags;
 extern const struct bch_hash_desc bch2_dirent_hash_desc;
 
-int bch2_dirent_invalid(const struct bch_fs *, struct bkey_s_c, unsigned, struct printbuf *);
+int bch2_dirent_invalid(const struct bch_fs *, struct bkey_s_c,
+			enum bkey_invalid_flags, struct printbuf *);
 void bch2_dirent_to_text(struct printbuf *, struct bch_fs *, struct bkey_s_c);
 
 #define bch2_bkey_ops_dirent ((struct bkey_ops) {	\
diff --git a/fs/bcachefs/ec.c b/fs/bcachefs/ec.c
index 749be7a9f5..efbb7cf7a5 100644
--- a/fs/bcachefs/ec.c
+++ b/fs/bcachefs/ec.c
@@ -105,7 +105,8 @@ struct ec_bio {
 /* Stripes btree keys: */
 
 int bch2_stripe_invalid(const struct bch_fs *c, struct bkey_s_c k,
-			unsigned flags, struct printbuf *err)
+			enum bkey_invalid_flags flags,
+			struct printbuf *err)
 {
 	const struct bch_stripe *s = bkey_s_c_to_stripe(k).v;
 
diff --git a/fs/bcachefs/ec.h b/fs/bcachefs/ec.h
index 64ca277ca1..1b1848e5fa 100644
--- a/fs/bcachefs/ec.h
+++ b/fs/bcachefs/ec.h
@@ -6,8 +6,10 @@
 #include "buckets_types.h"
 #include "extents_types.h"
 
+enum bkey_invalid_flags;
+
 int bch2_stripe_invalid(const struct bch_fs *, struct bkey_s_c,
-			unsigned, struct printbuf *);
+			enum bkey_invalid_flags, struct printbuf *);
 void bch2_stripe_to_text(struct printbuf *, struct bch_fs *,
 			 struct bkey_s_c);
 
diff --git a/fs/bcachefs/extents.c b/fs/bcachefs/extents.c
index bb5e17eb2a..c13e0afc66 100644
--- a/fs/bcachefs/extents.c
+++ b/fs/bcachefs/extents.c
@@ -163,7 +163,8 @@ int bch2_bkey_pick_read_device(struct bch_fs *c, struct bkey_s_c k,
 /* KEY_TYPE_btree_ptr: */
 
 int bch2_btree_ptr_invalid(const struct bch_fs *c, struct bkey_s_c k,
-			   unsigned flags, struct printbuf *err)
+			   enum bkey_invalid_flags flags,
+			   struct printbuf *err)
 {
 	if (bkey_val_u64s(k.k) > BCH_REPLICAS_MAX) {
 		prt_printf(err, "value too big (%zu > %u)",
@@ -181,7 +182,8 @@ void bch2_btree_ptr_to_text(struct printbuf *out, struct bch_fs *c,
 }
 
 int bch2_btree_ptr_v2_invalid(const struct bch_fs *c, struct bkey_s_c k,
-			      unsigned flags, struct printbuf *err)
+			      enum bkey_invalid_flags flags,
+			      struct printbuf *err)
 {
 	if (bkey_val_u64s(k.k) > BKEY_BTREE_PTR_VAL_U64s_MAX) {
 		prt_printf(err, "value too big (%zu > %zu)",
@@ -371,7 +373,8 @@ bool bch2_extent_merge(struct bch_fs *c, struct bkey_s l, struct bkey_s_c r)
 /* KEY_TYPE_reservation: */
 
 int bch2_reservation_invalid(const struct bch_fs *c, struct bkey_s_c k,
-			     unsigned flags, struct printbuf *err)
+			     enum bkey_invalid_flags flags,
+			     struct printbuf *err)
 {
 	struct bkey_s_c_reservation r = bkey_s_c_to_reservation(k);
 
@@ -1103,7 +1106,8 @@ static int extent_ptr_invalid(const struct bch_fs *c,
 }
 
 int bch2_bkey_ptrs_invalid(const struct bch_fs *c, struct bkey_s_c k,
-			   unsigned flags, struct printbuf *err)
+			   enum bkey_invalid_flags flags,
+			   struct printbuf *err)
 {
 	struct bkey_ptrs_c ptrs = bch2_bkey_ptrs_c(k);
 	const union bch_extent_entry *entry;
diff --git a/fs/bcachefs/extents.h b/fs/bcachefs/extents.h
index 00ddac1f68..d359b3fda9 100644
--- a/fs/bcachefs/extents.h
+++ b/fs/bcachefs/extents.h
@@ -8,6 +8,7 @@
 
 struct bch_fs;
 struct btree_trans;
+enum bkey_invalid_flags;
 
 /* extent entries: */
 
@@ -382,11 +383,13 @@ int bch2_bkey_pick_read_device(struct bch_fs *, struct bkey_s_c,
 
 /* KEY_TYPE_btree_ptr: */
 
-int bch2_btree_ptr_invalid(const struct bch_fs *, struct bkey_s_c, unsigned, struct printbuf *);
+int bch2_btree_ptr_invalid(const struct bch_fs *, struct bkey_s_c,
+			   enum bkey_invalid_flags, struct printbuf *);
 void bch2_btree_ptr_to_text(struct printbuf *, struct bch_fs *,
 			    struct bkey_s_c);
 
-int bch2_btree_ptr_v2_invalid(const struct bch_fs *, struct bkey_s_c, unsigned, struct printbuf *);
+int bch2_btree_ptr_v2_invalid(const struct bch_fs *, struct bkey_s_c,
+			      enum bkey_invalid_flags, struct printbuf *);
 void bch2_btree_ptr_v2_to_text(struct printbuf *, struct bch_fs *, struct bkey_s_c);
 void bch2_btree_ptr_v2_compat(enum btree_id, unsigned, unsigned,
 			      int, struct bkey_s);
@@ -426,7 +429,7 @@ bool bch2_extent_merge(struct bch_fs *, struct bkey_s, struct bkey_s_c);
 /* KEY_TYPE_reservation: */
 
 int bch2_reservation_invalid(const struct bch_fs *, struct bkey_s_c,
-			     unsigned, struct printbuf *);
+			     enum bkey_invalid_flags, struct printbuf *);
 void bch2_reservation_to_text(struct printbuf *, struct bch_fs *, struct bkey_s_c);
 bool bch2_reservation_merge(struct bch_fs *, struct bkey_s, struct bkey_s_c);
 
diff --git a/fs/bcachefs/inode.c b/fs/bcachefs/inode.c
index 64e8d1f8a2..fa435d8655 100644
--- a/fs/bcachefs/inode.c
+++ b/fs/bcachefs/inode.c
@@ -432,7 +432,8 @@ static int __bch2_inode_invalid(struct bkey_s_c k, struct printbuf *err)
 }
 
 int bch2_inode_invalid(const struct bch_fs *c, struct bkey_s_c k,
-		       unsigned flags, struct printbuf *err)
+		       enum bkey_invalid_flags flags,
+		       struct printbuf *err)
 {
 	struct bkey_s_c_inode inode = bkey_s_c_to_inode(k);
 
@@ -446,7 +447,8 @@ int bch2_inode_invalid(const struct bch_fs *c, struct bkey_s_c k,
 }
 
 int bch2_inode_v2_invalid(const struct bch_fs *c, struct bkey_s_c k,
-			  unsigned flags, struct printbuf *err)
+			  enum bkey_invalid_flags flags,
+			  struct printbuf *err)
 {
 	struct bkey_s_c_inode_v2 inode = bkey_s_c_to_inode_v2(k);
 
@@ -460,7 +462,8 @@ int bch2_inode_v2_invalid(const struct bch_fs *c, struct bkey_s_c k,
 }
 
 int bch2_inode_v3_invalid(const struct bch_fs *c, struct bkey_s_c k,
-			  unsigned flags, struct printbuf *err)
+			  enum bkey_invalid_flags flags,
+			  struct printbuf *err)
 {
 	struct bkey_s_c_inode_v3 inode = bkey_s_c_to_inode_v3(k);
 
@@ -517,7 +520,8 @@ void bch2_inode_to_text(struct printbuf *out, struct bch_fs *c, struct bkey_s_c
 }
 
 int bch2_inode_generation_invalid(const struct bch_fs *c, struct bkey_s_c k,
-				  unsigned flags, struct printbuf *err)
+				  enum bkey_invalid_flags flags,
+				  struct printbuf *err)
 {
 	if (k.k->p.inode) {
 		prt_printf(err, "nonzero k.p.inode");
diff --git a/fs/bcachefs/inode.h b/fs/bcachefs/inode.h
index 0c3022d3f9..8f9be5e583 100644
--- a/fs/bcachefs/inode.h
+++ b/fs/bcachefs/inode.h
@@ -5,11 +5,15 @@
 #include "bkey.h"
 #include "opts.h"
 
+enum bkey_invalid_flags;
 extern const char * const bch2_inode_opts[];
 
-int bch2_inode_invalid(const struct bch_fs *, struct bkey_s_c, unsigned, struct printbuf *);
-int bch2_inode_v2_invalid(const struct bch_fs *, struct bkey_s_c, unsigned, struct printbuf *);
-int bch2_inode_v3_invalid(const struct bch_fs *, struct bkey_s_c, unsigned, struct printbuf *);
+int bch2_inode_invalid(const struct bch_fs *, struct bkey_s_c,
+		       enum bkey_invalid_flags, struct printbuf *);
+int bch2_inode_v2_invalid(const struct bch_fs *, struct bkey_s_c,
+			  enum bkey_invalid_flags, struct printbuf *);
+int bch2_inode_v3_invalid(const struct bch_fs *, struct bkey_s_c,
+			  enum bkey_invalid_flags, struct printbuf *);
 void bch2_inode_to_text(struct printbuf *, struct bch_fs *, struct bkey_s_c);
 
 #define bch2_bkey_ops_inode ((struct bkey_ops) {	\
@@ -44,7 +48,7 @@ static inline bool bkey_is_inode(const struct bkey *k)
 }
 
 int bch2_inode_generation_invalid(const struct bch_fs *, struct bkey_s_c,
-				  unsigned, struct printbuf *);
+				  enum bkey_invalid_flags, struct printbuf *);
 void bch2_inode_generation_to_text(struct printbuf *, struct bch_fs *, struct bkey_s_c);
 
 #define bch2_bkey_ops_inode_generation ((struct bkey_ops) {	\
diff --git a/fs/bcachefs/journal_io.c b/fs/bcachefs/journal_io.c
index a084c6d0fe..c7c2ae326f 100644
--- a/fs/bcachefs/journal_io.c
+++ b/fs/bcachefs/journal_io.c
@@ -340,7 +340,8 @@ static int journal_entry_btree_keys_validate(struct bch_fs *c,
 		int ret = journal_validate_key(c, jset, entry,
 					       entry->level,
 					       entry->btree_id,
-					       k, version, big_endian, write|BKEY_INVALID_FROM_JOURNAL);
+					       k, version, big_endian,
+					       write|BKEY_INVALID_JOURNAL);
 		if (ret == FSCK_DELETED_KEY)
 			continue;
 
diff --git a/fs/bcachefs/lru.c b/fs/bcachefs/lru.c
index e04c037f0c..07d1929535 100644
--- a/fs/bcachefs/lru.c
+++ b/fs/bcachefs/lru.c
@@ -11,7 +11,8 @@
 
 /* KEY_TYPE_lru is obsolete: */
 int bch2_lru_invalid(const struct bch_fs *c, struct bkey_s_c k,
-		     unsigned flags, struct printbuf *err)
+		     enum bkey_invalid_flags flags,
+		     struct printbuf *err)
 {
 	if (!lru_pos_time(k.k->p)) {
 		prt_printf(err, "lru entry at time=0");
diff --git a/fs/bcachefs/lru.h b/fs/bcachefs/lru.h
index adb9842924..7a3be20a85 100644
--- a/fs/bcachefs/lru.h
+++ b/fs/bcachefs/lru.h
@@ -43,7 +43,8 @@ static inline enum bch_lru_type lru_type(struct bkey_s_c l)
 	return BCH_LRU_read;
 }
 
-int bch2_lru_invalid(const struct bch_fs *, struct bkey_s_c, unsigned, struct printbuf *);
+int bch2_lru_invalid(const struct bch_fs *, struct bkey_s_c,
+		     enum bkey_invalid_flags, struct printbuf *);
 void bch2_lru_to_text(struct printbuf *, struct bch_fs *, struct bkey_s_c);
 
 void bch2_lru_pos_to_text(struct printbuf *, struct bpos);
diff --git a/fs/bcachefs/quota.c b/fs/bcachefs/quota.c
index 1decb7191d..d90db3fb82 100644
--- a/fs/bcachefs/quota.c
+++ b/fs/bcachefs/quota.c
@@ -60,7 +60,8 @@ const struct bch_sb_field_ops bch_sb_field_ops_quota = {
 };
 
 int bch2_quota_invalid(const struct bch_fs *c, struct bkey_s_c k,
-		       unsigned flags, struct printbuf *err)
+		       enum bkey_invalid_flags flags,
+		       struct printbuf *err)
 {
 	if (k.k->p.inode >= QTYP_NR) {
 		prt_printf(err, "invalid quota type (%llu >= %u)",
diff --git a/fs/bcachefs/quota.h b/fs/bcachefs/quota.h
index b0f7d4ee77..2f463874a3 100644
--- a/fs/bcachefs/quota.h
+++ b/fs/bcachefs/quota.h
@@ -5,9 +5,11 @@
 #include "inode.h"
 #include "quota_types.h"
 
+enum bkey_invalid_flags;
 extern const struct bch_sb_field_ops bch_sb_field_ops_quota;
 
-int bch2_quota_invalid(const struct bch_fs *, struct bkey_s_c, unsigned, struct printbuf *);
+int bch2_quota_invalid(const struct bch_fs *, struct bkey_s_c,
+		       enum bkey_invalid_flags, struct printbuf *);
 void bch2_quota_to_text(struct printbuf *, struct bch_fs *, struct bkey_s_c);
 
 #define bch2_bkey_ops_quota ((struct bkey_ops) {	\
diff --git a/fs/bcachefs/reflink.c b/fs/bcachefs/reflink.c
index 26f0275ff0..39f711d506 100644
--- a/fs/bcachefs/reflink.c
+++ b/fs/bcachefs/reflink.c
@@ -26,7 +26,8 @@ static inline unsigned bkey_type_to_indirect(const struct bkey *k)
 /* reflink pointers */
 
 int bch2_reflink_p_invalid(const struct bch_fs *c, struct bkey_s_c k,
-			   unsigned flags, struct printbuf *err)
+			   enum bkey_invalid_flags flags,
+			   struct printbuf *err)
 {
 	struct bkey_s_c_reflink_p p = bkey_s_c_to_reflink_p(k);
 
@@ -72,7 +73,8 @@ bool bch2_reflink_p_merge(struct bch_fs *c, struct bkey_s _l, struct bkey_s_c _r
 /* indirect extents */
 
 int bch2_reflink_v_invalid(const struct bch_fs *c, struct bkey_s_c k,
-			   unsigned flags, struct printbuf *err)
+			   enum bkey_invalid_flags flags,
+			   struct printbuf *err)
 {
 	return bch2_bkey_ptrs_invalid(c, k, flags, err);
 }
@@ -117,7 +119,8 @@ int bch2_trans_mark_reflink_v(struct btree_trans *trans,
 /* indirect inline data */
 
 int bch2_indirect_inline_data_invalid(const struct bch_fs *c, struct bkey_s_c k,
-				      unsigned flags, struct printbuf *err)
+				      enum bkey_invalid_flags flags,
+				      struct printbuf *err)
 {
 	return 0;
 }
diff --git a/fs/bcachefs/reflink.h b/fs/bcachefs/reflink.h
index ba400188f5..fe52538efb 100644
--- a/fs/bcachefs/reflink.h
+++ b/fs/bcachefs/reflink.h
@@ -2,8 +2,10 @@
 #ifndef _BCACHEFS_REFLINK_H
 #define _BCACHEFS_REFLINK_H
 
+enum bkey_invalid_flags;
+
 int bch2_reflink_p_invalid(const struct bch_fs *, struct bkey_s_c,
-			   unsigned, struct printbuf *);
+			   enum bkey_invalid_flags, struct printbuf *);
 void bch2_reflink_p_to_text(struct printbuf *, struct bch_fs *,
 			    struct bkey_s_c);
 bool bch2_reflink_p_merge(struct bch_fs *, struct bkey_s, struct bkey_s_c);
@@ -18,7 +20,7 @@ bool bch2_reflink_p_merge(struct bch_fs *, struct bkey_s, struct bkey_s_c);
 })
 
 int bch2_reflink_v_invalid(const struct bch_fs *, struct bkey_s_c,
-			   unsigned, struct printbuf *);
+			   enum bkey_invalid_flags, struct printbuf *);
 void bch2_reflink_v_to_text(struct printbuf *, struct bch_fs *,
 			    struct bkey_s_c);
 int bch2_trans_mark_reflink_v(struct btree_trans *, enum btree_id, unsigned,
@@ -34,7 +36,7 @@ int bch2_trans_mark_reflink_v(struct btree_trans *, enum btree_id, unsigned,
 })
 
 int bch2_indirect_inline_data_invalid(const struct bch_fs *, struct bkey_s_c,
-				      unsigned, struct printbuf *);
+				      enum bkey_invalid_flags, struct printbuf *);
 void bch2_indirect_inline_data_to_text(struct printbuf *,
 				struct bch_fs *, struct bkey_s_c);
 int bch2_trans_mark_indirect_inline_data(struct btree_trans *,
diff --git a/fs/bcachefs/subvolume.c b/fs/bcachefs/subvolume.c
index 341c0d1b81..f26397aa2b 100644
--- a/fs/bcachefs/subvolume.c
+++ b/fs/bcachefs/subvolume.c
@@ -23,7 +23,8 @@ void bch2_snapshot_tree_to_text(struct printbuf *out, struct bch_fs *c,
 }
 
 int bch2_snapshot_tree_invalid(const struct bch_fs *c, struct bkey_s_c k,
-			       unsigned flags, struct printbuf *err)
+			       enum bkey_invalid_flags flags,
+			       struct printbuf *err)
 {
 	if (bkey_gt(k.k->p, POS(0, U32_MAX)) ||
 	    bkey_lt(k.k->p, POS(0, 1))) {
@@ -97,7 +98,8 @@ void bch2_snapshot_to_text(struct printbuf *out, struct bch_fs *c,
 }
 
 int bch2_snapshot_invalid(const struct bch_fs *c, struct bkey_s_c k,
-			  unsigned flags, struct printbuf *err)
+			  enum bkey_invalid_flags flags,
+			  struct printbuf *err)
 {
 	struct bkey_s_c_snapshot s;
 	u32 i, id;
diff --git a/fs/bcachefs/subvolume.h b/fs/bcachefs/subvolume.h
index 1a39f713db..105410e080 100644
--- a/fs/bcachefs/subvolume.h
+++ b/fs/bcachefs/subvolume.h
@@ -5,9 +5,11 @@
 #include "darray.h"
 #include "subvolume_types.h"
 
+enum bkey_invalid_flags;
+
 void bch2_snapshot_tree_to_text(struct printbuf *, struct bch_fs *, struct bkey_s_c);
 int bch2_snapshot_tree_invalid(const struct bch_fs *, struct bkey_s_c,
-			       unsigned, struct printbuf *);
+			       enum bkey_invalid_flags, struct printbuf *);
 
 #define bch2_bkey_ops_snapshot_tree ((struct bkey_ops) {	\
 	.key_invalid	= bch2_snapshot_tree_invalid,		\
@@ -19,7 +21,7 @@ int bch2_snapshot_tree_lookup(struct btree_trans *, u32, struct bch_snapshot_tre
 
 void bch2_snapshot_to_text(struct printbuf *, struct bch_fs *, struct bkey_s_c);
 int bch2_snapshot_invalid(const struct bch_fs *, struct bkey_s_c,
-			  unsigned, struct printbuf *);
+			  enum bkey_invalid_flags, struct printbuf *);
 int bch2_mark_snapshot(struct btree_trans *, enum btree_id, unsigned,
 		       struct bkey_s_c, struct bkey_s_c, unsigned);
 
diff --git a/fs/bcachefs/xattr.c b/fs/bcachefs/xattr.c
index f47a085d14..867cc68782 100644
--- a/fs/bcachefs/xattr.c
+++ b/fs/bcachefs/xattr.c
@@ -70,7 +70,8 @@ const struct bch_hash_desc bch2_xattr_hash_desc = {
 };
 
 int bch2_xattr_invalid(const struct bch_fs *c, struct bkey_s_c k,
-		       unsigned flags, struct printbuf *err)
+		       enum bkey_invalid_flags flags,
+		       struct printbuf *err)
 {
 	const struct xattr_handler *handler;
 	struct bkey_s_c_xattr xattr = bkey_s_c_to_xattr(k);
diff --git a/fs/bcachefs/xattr.h b/fs/bcachefs/xattr.h
index b3e16729bc..214cbbaac3 100644
--- a/fs/bcachefs/xattr.h
+++ b/fs/bcachefs/xattr.h
@@ -6,7 +6,8 @@
 
 extern const struct bch_hash_desc bch2_xattr_hash_desc;
 
-int bch2_xattr_invalid(const struct bch_fs *, struct bkey_s_c, unsigned, struct printbuf *);
+int bch2_xattr_invalid(const struct bch_fs *, struct bkey_s_c,
+		       enum bkey_invalid_flags, struct printbuf *);
 void bch2_xattr_to_text(struct printbuf *, struct bch_fs *, struct bkey_s_c);
 
 #define bch2_bkey_ops_xattr ((struct bkey_ops) {	\
-- 
2.40.1


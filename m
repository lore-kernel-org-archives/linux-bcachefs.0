Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6D70C00A8F
	for <linux-bcachefs@archiver.kernel.org>; Tue, 24 Oct 2023 19:14:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344227AbjJXTOd (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Tue, 24 Oct 2023 15:14:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344220AbjJXTOc (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Tue, 24 Oct 2023 15:14:32 -0400
Received: from out-203.mta1.migadu.com (out-203.mta1.migadu.com [95.215.58.203])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C27610C6
        for <linux-bcachefs@vger.kernel.org>; Tue, 24 Oct 2023 12:14:26 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1698174865;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wLiuU0WuP5tJhoiqeNliTHEo1KAYi1R+xeuujnHSW+4=;
        b=YirxWEGqA7l4OM4uOwUIBdUk7gPtfjasHUBiOz0P1gXD9OzGh8YU0bPgxIz1kqVqYQOJFS
        NGi5LQXvcVOrExmGNZm3en6LjpM+RHfAFRc+dL/jridI/S6X55zELYSvLn1G90Xb9DoGYo
        qSGX8zMO2hYSkaus6B2WLzEhI0nQ/WQ=
From:   Kent Overstreet <kent.overstreet@linux.dev>
To:     linux-bcachefs@vger.kernel.org
Cc:     Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 6/6] bcachefs: rebalance_work
Date:   Tue, 24 Oct 2023 15:14:11 -0400
Message-ID: <20231024191414.2157874-7-kent.overstreet@linux.dev>
In-Reply-To: <20231024191414.2157874-1-kent.overstreet@linux.dev>
References: <20231024191414.2157874-1-kent.overstreet@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

This adds a new btree, rebalance_work, to eliminate scanning required
for finding extents that need work done on them in the background - i.e.
for the background_target and background_compression options.

rebalance_work is a bitset btree, where a KEY_TYPE_set corresponds to an
extent in the extents or reflink btree at the same pos.

A new extent field is added, bch_extent_rebalance, which indicates that
this extent has work that needs to be done in the background - and which
options to use. This allows per-inode options to be propagated to
indirect extents - at least in some circumstances. In this patch,
changing IO options on a file will not propagate the new options to
indirect extents pointed to by that file.

Updating (setting/clearing) the rebalance_work btree is done by the
extent trigger, which looks at the bch_extent_rebalance field.

Scanning is still requrired after changing IO path options - either just
for a given inode, or for the whole filesystem. We indicate that
scanning is required by adding a KEY_TYPE_cookie key to the
rebalance_work btree: the cookie counter is so that we can detect that
scanning is still required when an option has been flipped mid-way
through an existing scan.

Future possible work:
 - Propagate options to indirect extents when being changed
 - Add other IO path options - nr_replicas, ec, to rebalance_work so
   they can be applied in the background when they change
 - Add a counter, for bcachefs fs usage output, showing the pending
   amount of rebalance work: we'll probably want to do this after the
   disk space accounting rewrite (moving it to a new btree)

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/bcachefs.h        |   1 +
 fs/bcachefs/bcachefs_format.h |  34 +--
 fs/bcachefs/buckets.c         |  10 +
 fs/bcachefs/compress.c        |  18 +-
 fs/bcachefs/compress.h        |   2 +
 fs/bcachefs/data_update.c     |  11 +-
 fs/bcachefs/extents.c         | 155 +++++++++-
 fs/bcachefs/extents.h         |  20 ++
 fs/bcachefs/io_misc.c         |  11 +-
 fs/bcachefs/io_write.c        |  20 +-
 fs/bcachefs/rebalance.c       | 552 ++++++++++++++++++++--------------
 fs/bcachefs/rebalance.h       |   9 +-
 fs/bcachefs/rebalance_types.h |  31 +-
 fs/bcachefs/recovery.c        |   1 +
 fs/bcachefs/recovery_types.h  |   1 +
 fs/bcachefs/reflink.c         |  19 +-
 fs/bcachefs/sysfs.c           |  14 +-
 fs/bcachefs/xattr.c           |   2 +-
 18 files changed, 597 insertions(+), 314 deletions(-)

diff --git a/fs/bcachefs/bcachefs.h b/fs/bcachefs/bcachefs.h
index bff6324447e1..68f0ff03c28a 100644
--- a/fs/bcachefs/bcachefs.h
+++ b/fs/bcachefs/bcachefs.h
@@ -464,6 +464,7 @@ enum gc_phase {
 	GC_PHASE_BTREE_snapshot_trees,
 	GC_PHASE_BTREE_deleted_inodes,
 	GC_PHASE_BTREE_logged_ops,
+	GC_PHASE_BTREE_rebalance_work,
 
 	GC_PHASE_PENDING_DELETE,
 };
diff --git a/fs/bcachefs/bcachefs_format.h b/fs/bcachefs/bcachefs_format.h
index 99749f3315fe..e04999c57892 100644
--- a/fs/bcachefs/bcachefs_format.h
+++ b/fs/bcachefs/bcachefs_format.h
@@ -613,31 +613,17 @@ struct bch_extent_stripe_ptr {
 #endif
 };
 
-struct bch_extent_reservation {
-#if defined(__LITTLE_ENDIAN_BITFIELD)
-	__u64			type:6,
-				unused:22,
-				replicas:4,
-				generation:32;
-#elif defined (__BIG_ENDIAN_BITFIELD)
-	__u64			generation:32,
-				replicas:4,
-				unused:22,
-				type:6;
-#endif
-};
-
 struct bch_extent_rebalance {
 #if defined(__LITTLE_ENDIAN_BITFIELD)
-	__u64			type:7,
-				unused:33,
-				compression:8,
+	__u64			type:6,
+				unused:34,
+				compression:8, /* enum bch_compression_opt */
 				target:16;
 #elif defined (__BIG_ENDIAN_BITFIELD)
 	__u64			target:16,
 				compression:8,
-				unused:33,
-				type:7;
+				unused:34,
+				type:6;
 #endif
 };
 
@@ -1682,7 +1668,9 @@ struct bch_sb_field_journal_seq_blacklist {
 	x(snapshot_skiplists,		BCH_VERSION(1,  1),		\
 	  BIT_ULL(BCH_RECOVERY_PASS_check_snapshots))			\
 	x(deleted_inodes,		BCH_VERSION(1,  2),		\
-	  BIT_ULL(BCH_RECOVERY_PASS_check_inodes))
+	  BIT_ULL(BCH_RECOVERY_PASS_check_inodes))			\
+	x(rebalance_work,		BCH_VERSION(1,  3),		\
+	  BIT_ULL(BCH_RECOVERY_PASS_set_fs_needs_rebalance))
 
 enum bcachefs_metadata_version {
 	bcachefs_metadata_version_min = 9,
@@ -1693,7 +1681,7 @@ enum bcachefs_metadata_version {
 };
 
 static const __maybe_unused
-unsigned bcachefs_metadata_required_upgrade_below = bcachefs_metadata_version_major_minor;
+unsigned bcachefs_metadata_required_upgrade_below = bcachefs_metadata_version_rebalance_work;
 
 #define bcachefs_metadata_version_current	(bcachefs_metadata_version_max - 1)
 
@@ -2306,7 +2294,9 @@ enum btree_id_flags {
 	  BIT_ULL(KEY_TYPE_set))						\
 	x(logged_ops,		17,	0,					\
 	  BIT_ULL(KEY_TYPE_logged_op_truncate)|					\
-	  BIT_ULL(KEY_TYPE_logged_op_finsert))
+	  BIT_ULL(KEY_TYPE_logged_op_finsert))					\
+	x(rebalance_work,	18,	BTREE_ID_SNAPSHOTS,			\
+	  BIT_ULL(KEY_TYPE_set)|BIT_ULL(KEY_TYPE_cookie))
 
 enum btree_id {
 #define x(name, nr, ...) BTREE_ID_##name = nr,
diff --git a/fs/bcachefs/buckets.c b/fs/bcachefs/buckets.c
index 5c1eca183243..a8af803e7289 100644
--- a/fs/bcachefs/buckets.c
+++ b/fs/bcachefs/buckets.c
@@ -1536,6 +1536,16 @@ int bch2_trans_mark_extent(struct btree_trans *trans,
 			   struct bkey_s_c old, struct bkey_i *new,
 			   unsigned flags)
 {
+	struct bch_fs *c = trans->c;
+	int mod = (int) bch2_bkey_needs_rebalance(c, bkey_i_to_s_c(new)) -
+		  (int) bch2_bkey_needs_rebalance(c, old);
+
+	if (mod) {
+		int ret = bch2_btree_bit_mod(trans, BTREE_ID_rebalance_work, new->k.p, mod > 0);
+		if (ret)
+			return ret;
+	}
+
 	return trigger_run_overwrite_then_insert(__trans_mark_extent, trans, btree_id, level, old, new, flags);
 }
 
diff --git a/fs/bcachefs/compress.c b/fs/bcachefs/compress.c
index 0e3981f42526..a8b148ec2a2b 100644
--- a/fs/bcachefs/compress.c
+++ b/fs/bcachefs/compress.c
@@ -697,18 +697,26 @@ int bch2_opt_compression_parse(struct bch_fs *c, const char *_val, u64 *res,
 	return ret;
 }
 
-void bch2_opt_compression_to_text(struct printbuf *out,
-				  struct bch_fs *c,
-				  struct bch_sb *sb,
-				  u64 v)
+void bch2_compression_opt_to_text(struct printbuf *out, u64 v)
 {
 	struct bch_compression_opt opt = bch2_compression_decode(v);
 
-	prt_str(out, bch2_compression_opts[opt.type]);
+	if (opt.type < BCH_COMPRESSION_OPT_NR)
+		prt_str(out, bch2_compression_opts[opt.type]);
+	else
+		prt_printf(out, "(unknown compression opt %u)", opt.type);
 	if (opt.level)
 		prt_printf(out, ":%u", opt.level);
 }
 
+void bch2_opt_compression_to_text(struct printbuf *out,
+				  struct bch_fs *c,
+				  struct bch_sb *sb,
+				  u64 v)
+{
+	return bch2_compression_opt_to_text(out, v);
+}
+
 int bch2_opt_compression_validate(u64 v, struct printbuf *err)
 {
 	if (!bch2_compression_opt_valid(v)) {
diff --git a/fs/bcachefs/compress.h b/fs/bcachefs/compress.h
index b938fc936365..607fd5e232c9 100644
--- a/fs/bcachefs/compress.h
+++ b/fs/bcachefs/compress.h
@@ -58,6 +58,8 @@ int bch2_check_set_has_compressed_data(struct bch_fs *, unsigned);
 void bch2_fs_compress_exit(struct bch_fs *);
 int bch2_fs_compress_init(struct bch_fs *);
 
+void bch2_compression_opt_to_text(struct printbuf *, u64);
+
 int bch2_opt_compression_parse(struct bch_fs *, const char *, u64 *, struct printbuf *);
 void bch2_opt_compression_to_text(struct printbuf *, struct bch_fs *, struct bch_sb *, u64);
 int bch2_opt_compression_validate(u64, struct printbuf *);
diff --git a/fs/bcachefs/data_update.c b/fs/bcachefs/data_update.c
index 4860f8293a4f..d116f2f03db2 100644
--- a/fs/bcachefs/data_update.c
+++ b/fs/bcachefs/data_update.c
@@ -13,6 +13,7 @@
 #include "keylist.h"
 #include "move.h"
 #include "nocow_locking.h"
+#include "rebalance.h"
 #include "subvolume.h"
 #include "trace.h"
 
@@ -251,11 +252,11 @@ static int __bch2_data_update_index_update(struct btree_trans *trans,
 		ret =   bch2_insert_snapshot_whiteouts(trans, m->btree_id,
 						k.k->p, bkey_start_pos(&insert->k)) ?:
 			bch2_insert_snapshot_whiteouts(trans, m->btree_id,
-						k.k->p, insert->k.p);
-		if (ret)
-			goto err;
-
-		ret   = bch2_trans_update(trans, &iter, insert,
+						k.k->p, insert->k.p) ?:
+			bch2_bkey_set_needs_rebalance(c, insert,
+						      op->opts.background_target,
+						      op->opts.background_compression) ?:
+			bch2_trans_update(trans, &iter, insert,
 				BTREE_UPDATE_INTERNAL_SNAPSHOT_NODE) ?:
 			bch2_trans_commit(trans, &op->res,
 				NULL,
diff --git a/fs/bcachefs/extents.c b/fs/bcachefs/extents.c
index ccb62fa22b04..0c60d49c3599 100644
--- a/fs/bcachefs/extents.c
+++ b/fs/bcachefs/extents.c
@@ -13,6 +13,7 @@
 #include "btree_iter.h"
 #include "buckets.h"
 #include "checksum.h"
+#include "compress.h"
 #include "debug.h"
 #include "disk_groups.h"
 #include "error.h"
@@ -757,18 +758,6 @@ static union bch_extent_entry *extent_entry_prev(struct bkey_ptrs ptrs,
 	return i;
 }
 
-static void extent_entry_drop(struct bkey_s k, union bch_extent_entry *entry)
-{
-	union bch_extent_entry *next = extent_entry_next(entry);
-
-	/* stripes have ptrs, but their layout doesn't work with this code */
-	BUG_ON(k.k->type == KEY_TYPE_stripe);
-
-	memmove_u64s_down(entry, next,
-			  (u64 *) bkey_val_end(k) - (u64 *) next);
-	k.k->u64s -= (u64 *) next - (u64 *) entry;
-}
-
 /*
  * Returns pointer to the next entry after the one being dropped:
  */
@@ -1048,6 +1037,18 @@ void bch2_bkey_ptrs_to_text(struct printbuf *out, struct bch_fs *c,
 			       (u64) ec->idx, ec->block);
 			break;
 		}
+		case BCH_EXTENT_ENTRY_rebalance: {
+			const struct bch_extent_rebalance *r = &entry->rebalance;
+
+			prt_str(out, "rebalance: target ");
+			if (c)
+				bch2_target_to_text(out, c, r->target);
+			else
+				prt_printf(out, "%u", r->target);
+			prt_str(out, " compression ");
+			bch2_compression_opt_to_text(out, r->compression);
+			break;
+		}
 		default:
 			prt_printf(out, "(invalid extent entry %.16llx)", *((u64 *) entry));
 			return;
@@ -1223,9 +1224,18 @@ int bch2_bkey_ptrs_invalid(const struct bch_fs *c, struct bkey_s_c k,
 			}
 			have_ec = true;
 			break;
-		case BCH_EXTENT_ENTRY_rebalance:
+		case BCH_EXTENT_ENTRY_rebalance: {
+			const struct bch_extent_rebalance *r = &entry->rebalance;
+
+			if (!bch2_compression_opt_valid(r->compression)) {
+				struct bch_compression_opt opt = __bch2_compression_decode(r->compression);
+				prt_printf(err, "invalid compression opt %u:%u",
+					   opt.type, opt.level);
+				return -BCH_ERR_invalid_bkey;
+			}
 			break;
 		}
+		}
 	}
 
 	if (!nr_ptrs) {
@@ -1289,6 +1299,125 @@ void bch2_ptr_swab(struct bkey_s k)
 	}
 }
 
+const struct bch_extent_rebalance *bch2_bkey_rebalance_opts(struct bkey_s_c k)
+{
+	struct bkey_ptrs_c ptrs = bch2_bkey_ptrs_c(k);
+	const union bch_extent_entry *entry;
+
+	bkey_extent_entry_for_each(ptrs, entry)
+		if (__extent_entry_type(entry) == BCH_EXTENT_ENTRY_rebalance)
+			return &entry->rebalance;
+
+	return NULL;
+}
+
+unsigned bch2_bkey_ptrs_need_rebalance(struct bch_fs *c, struct bkey_s_c k,
+				       unsigned target, unsigned compression)
+{
+	struct bkey_ptrs_c ptrs = bch2_bkey_ptrs_c(k);
+	unsigned rewrite_ptrs = 0;
+
+	if (compression) {
+		unsigned compression_type = bch2_compression_opt_to_type(compression);
+		const union bch_extent_entry *entry;
+		struct extent_ptr_decoded p;
+		unsigned i = 0;
+
+		bkey_for_each_ptr_decode(k.k, ptrs, p, entry) {
+			if (p.crc.compression_type == BCH_COMPRESSION_TYPE_incompressible) {
+				rewrite_ptrs = 0;
+				goto incompressible;
+			}
+
+			if (!p.ptr.cached && p.crc.compression_type != compression_type)
+				rewrite_ptrs |= 1U << i;
+			i++;
+		}
+	}
+incompressible:
+	if (target && bch2_target_accepts_data(c, BCH_DATA_user, target)) {
+		const struct bch_extent_ptr *ptr;
+		unsigned i = 0;
+
+		bkey_for_each_ptr(ptrs, ptr) {
+			if (!ptr->cached && !bch2_dev_in_target(c, ptr->dev, target))
+				rewrite_ptrs |= 1U << i;
+			i++;
+		}
+	}
+
+	return rewrite_ptrs;
+}
+
+bool bch2_bkey_needs_rebalance(struct bch_fs *c, struct bkey_s_c k)
+{
+	const struct bch_extent_rebalance *r = bch2_bkey_rebalance_opts(k);
+
+	/*
+	 * If it's an indirect extent, we don't delete the rebalance entry when
+	 * done so that we know what options were applied - check if it still
+	 * needs work done:
+	 */
+	if (r &&
+	    k.k->type == KEY_TYPE_reflink_v &&
+	    !bch2_bkey_ptrs_need_rebalance(c, k, r->target, r->compression))
+		r = NULL;
+
+	return r != NULL;
+}
+
+int bch2_bkey_set_needs_rebalance(struct bch_fs *c, struct bkey_i *_k,
+				  unsigned target, unsigned compression)
+{
+	struct bkey_s k = bkey_i_to_s(_k);
+	struct bch_extent_rebalance *r;
+	bool needs_rebalance;
+
+	if (!bkey_extent_is_direct_data(k.k))
+		return 0;
+
+	/* get existing rebalance entry: */
+	r = (struct bch_extent_rebalance *) bch2_bkey_rebalance_opts(k.s_c);
+	if (r) {
+		if (k.k->type == KEY_TYPE_reflink_v) {
+			/*
+			 * indirect extents: existing options take precedence,
+			 * so that we don't move extents back and forth if
+			 * they're referenced by different inodes with different
+			 * options:
+			 */
+			if (r->target)
+				target = r->target;
+			if (r->compression)
+				compression = r->compression;
+		}
+
+		r->target	= target;
+		r->compression	= compression;
+	}
+
+	needs_rebalance = bch2_bkey_ptrs_need_rebalance(c, k.s_c, target, compression);
+
+	if (needs_rebalance && !r) {
+		union bch_extent_entry *new = bkey_val_end(k);
+
+		new->rebalance.type		= 1U << BCH_EXTENT_ENTRY_rebalance;
+		new->rebalance.compression	= compression;
+		new->rebalance.target		= target;
+		new->rebalance.unused		= 0;
+		k.k->u64s += extent_entry_u64s(new);
+	} else if (!needs_rebalance && r && k.k->type != KEY_TYPE_reflink_v) {
+		/*
+		 * For indirect extents, don't delete the rebalance entry when
+		 * we're finished so that we know we specifically moved it or
+		 * compressed it to its current location/compression type
+		 */
+		extent_entry_drop(k, (union bch_extent_entry *) r);
+	}
+
+	return 0;
+}
+
 /* Generic extent code: */
 
 int bch2_cut_front_s(struct bpos where, struct bkey_s k)
diff --git a/fs/bcachefs/extents.h b/fs/bcachefs/extents.h
index ef1b9f18719d..9110acae7e3c 100644
--- a/fs/bcachefs/extents.h
+++ b/fs/bcachefs/extents.h
@@ -89,6 +89,18 @@ static inline void __extent_entry_insert(struct bkey_i *k,
 	memcpy_u64s_small(dst, new, extent_entry_u64s(new));
 }
 
+static inline void extent_entry_drop(struct bkey_s k, union bch_extent_entry *entry)
+{
+	union bch_extent_entry *next = extent_entry_next(entry);
+
+	/* stripes have ptrs, but their layout doesn't work with this code */
+	BUG_ON(k.k->type == KEY_TYPE_stripe);
+
+	memmove_u64s_down(entry, next,
+			  (u64 *) bkey_val_end(k) - (u64 *) next);
+	k.k->u64s -= (u64 *) next - (u64 *) entry;
+}
+
 static inline bool extent_entry_is_ptr(const union bch_extent_entry *e)
 {
 	return extent_entry_type(e) == BCH_EXTENT_ENTRY_ptr;
@@ -698,6 +710,14 @@ int bch2_bkey_ptrs_invalid(const struct bch_fs *, struct bkey_s_c,
 
 void bch2_ptr_swab(struct bkey_s);
 
+const struct bch_extent_rebalance *bch2_bkey_rebalance_opts(struct bkey_s_c);
+unsigned bch2_bkey_ptrs_need_rebalance(struct bch_fs *, struct bkey_s_c,
+				       unsigned, unsigned);
+bool bch2_bkey_needs_rebalance(struct bch_fs *, struct bkey_s_c);
+
+int bch2_bkey_set_needs_rebalance(struct bch_fs *, struct bkey_i *,
+				  unsigned, unsigned);
+
 /* Generic extent code: */
 
 enum bch_extent_overlap {
diff --git a/fs/bcachefs/io_misc.c b/fs/bcachefs/io_misc.c
index 119834cb8f9e..0979d5e05713 100644
--- a/fs/bcachefs/io_misc.c
+++ b/fs/bcachefs/io_misc.c
@@ -16,6 +16,7 @@
 #include "io_misc.h"
 #include "io_write.h"
 #include "logged_ops.h"
+#include "rebalance.h"
 #include "subvolume.h"
 
 /* Overwrites whatever was present with zeroes: */
@@ -355,6 +356,7 @@ static int __bch2_resume_logged_op_finsert(struct btree_trans *trans,
 	struct btree_iter iter;
 	struct bkey_i_logged_op_finsert *op = bkey_i_to_logged_op_finsert(op_k);
 	subvol_inum inum = { le32_to_cpu(op->v.subvol), le64_to_cpu(op->v.inum) };
+	struct bch_io_opts opts;
 	u64 dst_offset = le64_to_cpu(op->v.dst_offset);
 	u64 src_offset = le64_to_cpu(op->v.src_offset);
 	s64 shift = dst_offset - src_offset;
@@ -363,6 +365,10 @@ static int __bch2_resume_logged_op_finsert(struct btree_trans *trans,
 	bool insert = shift > 0;
 	int ret = 0;
 
+	ret = bch2_inum_opts_get(trans, inum, &opts);
+	if (ret)
+		return ret;
+
 	bch2_trans_iter_init(trans, &iter, BTREE_ID_extents,
 			     POS(inum.inum, 0),
 			     BTREE_ITER_INTENT);
@@ -443,7 +449,10 @@ case LOGGED_OP_FINSERT_shift_extents:
 
 		op->v.pos = cpu_to_le64(insert ? bkey_start_offset(&delete.k) : delete.k.p.offset);
 
-		ret =   bch2_btree_insert_trans(trans, BTREE_ID_extents, &delete, 0) ?:
+		ret =   bch2_bkey_set_needs_rebalance(c, copy,
+					opts.background_target,
+					opts.background_compression) ?:
+			bch2_btree_insert_trans(trans, BTREE_ID_extents, &delete, 0) ?:
 			bch2_btree_insert_trans(trans, BTREE_ID_extents, copy, 0) ?:
 			bch2_logged_op_update(trans, &op->k_i) ?:
 			bch2_trans_commit(trans, &disk_res, NULL, BTREE_INSERT_NOFAIL);
diff --git a/fs/bcachefs/io_write.c b/fs/bcachefs/io_write.c
index f7461f60d760..6d9c777213e3 100644
--- a/fs/bcachefs/io_write.c
+++ b/fs/bcachefs/io_write.c
@@ -351,10 +351,13 @@ static int bch2_write_index_default(struct bch_write_op *op)
 				     bkey_start_pos(&sk.k->k),
 				     BTREE_ITER_SLOTS|BTREE_ITER_INTENT);
 
-		ret = bch2_extent_update(trans, inum, &iter, sk.k,
-					 &op->res,
-					 op->new_i_size, &op->i_sectors_delta,
-					 op->flags & BCH_WRITE_CHECK_ENOSPC);
+		ret =   bch2_bkey_set_needs_rebalance(c, sk.k,
+					op->opts.background_target,
+					op->opts.background_compression) ?:
+			bch2_extent_update(trans, inum, &iter, sk.k,
+					&op->res,
+					op->new_i_size, &op->i_sectors_delta,
+					op->flags & BCH_WRITE_CHECK_ENOSPC);
 		bch2_trans_iter_exit(trans, &iter);
 
 		if (bch2_err_matches(ret, BCH_ERR_transaction_restart))
@@ -495,7 +498,6 @@ static void __bch2_write_index(struct bch_write_op *op)
 {
 	struct bch_fs *c = op->c;
 	struct keylist *keys = &op->insert_keys;
-	struct bkey_i *k;
 	unsigned dev;
 	int ret = 0;
 
@@ -505,14 +507,6 @@ static void __bch2_write_index(struct bch_write_op *op)
 			goto err;
 	}
 
-	/*
-	 * probably not the ideal place to hook this in, but I don't
-	 * particularly want to plumb io_opts all the way through the btree
-	 * update stack right now
-	 */
-	for_each_keylist_key(keys, k)
-		bch2_rebalance_add_key(c, bkey_i_to_s_c(k), &op->opts);
-
 	if (!bch2_keylist_empty(keys)) {
 		u64 sectors_start = keylist_sectors(keys);
 
diff --git a/fs/bcachefs/rebalance.c b/fs/bcachefs/rebalance.c
index 92403fa79f1f..6ba8574b4a69 100644
--- a/fs/bcachefs/rebalance.c
+++ b/fs/bcachefs/rebalance.c
@@ -3,13 +3,18 @@
 #include "bcachefs.h"
 #include "alloc_foreground.h"
 #include "btree_iter.h"
+#include "btree_update.h"
+#include "btree_write_buffer.h"
 #include "buckets.h"
 #include "clock.h"
 #include "compress.h"
 #include "disk_groups.h"
 #include "errcode.h"
+#include "error.h"
+#include "inode.h"
 #include "move.h"
 #include "rebalance.h"
+#include "subvolume.h"
 #include "super-io.h"
 #include "trace.h"
 
@@ -17,301 +22,398 @@
 #include <linux/kthread.h>
 #include <linux/sched/cputime.h>
 
-/*
- * Check if an extent should be moved:
- * returns -1 if it should not be moved, or
- * device of pointer that should be moved, if known, or INT_MAX if unknown
- */
-static bool rebalance_pred(struct bch_fs *c, void *arg,
-			   struct bkey_s_c k,
-			   struct bch_io_opts *io_opts,
-			   struct data_update_opts *data_opts)
-{
-	struct bkey_ptrs_c ptrs = bch2_bkey_ptrs_c(k);
-	unsigned i;
+#define REBALANCE_WORK_SCAN_OFFSET	(U64_MAX - 1)
 
-	data_opts->rewrite_ptrs		= 0;
-	data_opts->target		= io_opts->background_target;
-	data_opts->extra_replicas	= 0;
-	data_opts->btree_insert_flags	= 0;
-
-	if (io_opts->background_compression &&
-	    !bch2_bkey_is_incompressible(k)) {
-		const union bch_extent_entry *entry;
-		struct extent_ptr_decoded p;
-
-		i = 0;
-		bkey_for_each_ptr_decode(k.k, ptrs, p, entry) {
-			if (!p.ptr.cached &&
-			    p.crc.compression_type !=
-			    bch2_compression_opt_to_type(io_opts->background_compression))
-				data_opts->rewrite_ptrs |= 1U << i;
-			i++;
-		}
-	}
-
-	if (io_opts->background_target) {
-		const struct bch_extent_ptr *ptr;
+static const char * const bch2_rebalance_state_strs[] = {
+#define x(t) #t,
+	BCH_REBALANCE_STATES()
+	NULL
+#undef x
+};
 
-		i = 0;
-		bkey_for_each_ptr(ptrs, ptr) {
-			if (!ptr->cached &&
-			    !bch2_dev_in_target(c, ptr->dev, io_opts->background_target) &&
-			    bch2_target_accepts_data(c, BCH_DATA_user, io_opts->background_target))
-				data_opts->rewrite_ptrs |= 1U << i;
-			i++;
-		}
-	}
+static int __bch2_set_rebalance_needs_scan(struct btree_trans *trans, u64 inum)
+{
+	struct btree_iter iter;
+	struct bkey_s_c k;
+	struct bkey_i_cookie *cookie;
+	u64 v;
+	int ret;
 
-	return data_opts->rewrite_ptrs != 0;
+	bch2_trans_iter_init(trans, &iter, BTREE_ID_rebalance_work,
+			     SPOS(inum, REBALANCE_WORK_SCAN_OFFSET, U32_MAX),
+			     BTREE_ITER_INTENT);
+	k = bch2_btree_iter_peek_slot(&iter);
+	ret = bkey_err(k);
+	if (ret)
+		goto err;
+
+	v = k.k->type == KEY_TYPE_cookie
+		? le64_to_cpu(bkey_s_c_to_cookie(k).v->cookie)
+		: 0;
+
+	cookie = bch2_trans_kmalloc(trans, sizeof(*cookie));
+	ret = PTR_ERR_OR_ZERO(cookie);
+	if (ret)
+		goto err;
+
+	bkey_cookie_init(&cookie->k_i);
+	cookie->k.p = iter.pos;
+	cookie->v.cookie = cpu_to_le64(v + 1);
+
+	ret = bch2_trans_update(trans, &iter, &cookie->k_i, 0);
+err:
+	bch2_trans_iter_exit(trans, &iter);
+	return ret;
 }
 
-void bch2_rebalance_add_key(struct bch_fs *c,
-			    struct bkey_s_c k,
-			    struct bch_io_opts *io_opts)
+int bch2_set_rebalance_needs_scan(struct bch_fs *c, u64 inum)
 {
-	struct data_update_opts update_opts = { 0 };
-	struct bkey_ptrs_c ptrs;
-	const struct bch_extent_ptr *ptr;
-	unsigned i;
+	int ret = bch2_trans_do(c, NULL, NULL, BTREE_INSERT_NOFAIL|BTREE_INSERT_LAZY_RW,
+			    __bch2_set_rebalance_needs_scan(trans, inum));
+	rebalance_wakeup(c);
+	return ret;
+}
 
-	if (!rebalance_pred(c, NULL, k, io_opts, &update_opts))
-		return;
-
-	i = 0;
-	ptrs = bch2_bkey_ptrs_c(k);
-	bkey_for_each_ptr(ptrs, ptr) {
-		if ((1U << i) && update_opts.rewrite_ptrs)
-			if (atomic64_add_return(k.k->size,
-					&bch_dev_bkey_exists(c, ptr->dev)->rebalance_work) ==
-			    k.k->size)
-				rebalance_wakeup(c);
-		i++;
-	}
+int bch2_set_fs_needs_rebalance(struct bch_fs *c)
+{
+	return bch2_set_rebalance_needs_scan(c, 0);
 }
 
-void bch2_rebalance_add_work(struct bch_fs *c, u64 sectors)
+static int bch2_clear_rebalance_needs_scan(struct btree_trans *trans, u64 inum, u64 cookie)
 {
-	if (atomic64_add_return(sectors, &c->rebalance.work_unknown_dev) ==
-	    sectors)
-		rebalance_wakeup(c);
+	struct btree_iter iter;
+	struct bkey_s_c k;
+	u64 v;
+	int ret;
+
+	bch2_trans_iter_init(trans, &iter, BTREE_ID_rebalance_work,
+			     SPOS(inum, REBALANCE_WORK_SCAN_OFFSET, U32_MAX),
+			     BTREE_ITER_INTENT);
+	k = bch2_btree_iter_peek_slot(&iter);
+	ret = bkey_err(k);
+	if (ret)
+		goto err;
+
+	v = k.k->type == KEY_TYPE_cookie
+		? le64_to_cpu(bkey_s_c_to_cookie(k).v->cookie)
+		: 0;
+
+	if (v == cookie)
+		ret = bch2_btree_delete_at(trans, &iter, 0);
+err:
+	bch2_trans_iter_exit(trans, &iter);
+	return ret;
 }
 
-struct rebalance_work {
-	int		dev_most_full_idx;
-	unsigned	dev_most_full_percent;
-	u64		dev_most_full_work;
-	u64		dev_most_full_capacity;
-	u64		total_work;
-};
+static struct bkey_s_c next_rebalance_entry(struct btree_trans *trans,
+					    struct btree_iter *work_iter)
+{
+	return !kthread_should_stop()
+		? bch2_btree_iter_peek(work_iter)
+		: bkey_s_c_null;
+}
 
-static void rebalance_work_accumulate(struct rebalance_work *w,
-		u64 dev_work, u64 unknown_dev, u64 capacity, int idx)
+static int bch2_bkey_clear_needs_rebalance(struct btree_trans *trans,
+					   struct btree_iter *iter,
+					   struct bkey_s_c k)
 {
-	unsigned percent_full;
-	u64 work = dev_work + unknown_dev;
+	struct bkey_i *n = bch2_bkey_make_mut(trans, iter, &k, 0);
+	int ret = PTR_ERR_OR_ZERO(n);
+	if (ret)
+		return ret;
 
-	/* avoid divide by 0 */
-	if (!capacity)
-		return;
+	extent_entry_drop(bkey_i_to_s(n),
+			  (void *) bch2_bkey_rebalance_opts(bkey_i_to_s_c(n)));
+	return bch2_trans_commit(trans, NULL, NULL, BTREE_INSERT_NOFAIL);
+}
+
+static struct bkey_s_c next_rebalance_extent(struct btree_trans *trans,
+			struct bpos work_pos,
+			struct btree_iter *extent_iter,
+			struct data_update_opts *data_opts)
+{
+	struct bch_fs *c = trans->c;
+	struct bkey_s_c k;
+
+	bch2_trans_iter_exit(trans, extent_iter);
+	bch2_trans_iter_init(trans, extent_iter,
+			     work_pos.inode ? BTREE_ID_extents : BTREE_ID_reflink,
+			     work_pos,
+			     BTREE_ITER_ALL_SNAPSHOTS);
+	k = bch2_btree_iter_peek_slot(extent_iter);
+	if (bkey_err(k))
+		return k;
+
+	const struct bch_extent_rebalance *r = k.k ? bch2_bkey_rebalance_opts(k) : NULL;
+	if (!r) {
+		/* raced due to btree write buffer, nothing to do */
+		return bkey_s_c_null;
+	}
 
-	if (work < dev_work || work < unknown_dev)
-		work = U64_MAX;
-	work = min(work, capacity);
+	memset(data_opts, 0, sizeof(*data_opts));
 
-	percent_full = div64_u64(work * 100, capacity);
+	data_opts->rewrite_ptrs		=
+		bch2_bkey_ptrs_need_rebalance(c, k, r->target, r->compression);
+	data_opts->target		= r->target;
 
-	if (percent_full >= w->dev_most_full_percent) {
-		w->dev_most_full_idx		= idx;
-		w->dev_most_full_percent	= percent_full;
-		w->dev_most_full_work		= work;
-		w->dev_most_full_capacity	= capacity;
+	if (!data_opts->rewrite_ptrs) {
+		/*
+		 * device we would want to write to offline? devices in target
+		 * changed?
+		 *
+		 * We'll now need a full scan before this extent is picked up
+		 * again:
+		 */
+		int ret = bch2_bkey_clear_needs_rebalance(trans, extent_iter, k);
+		if (ret)
+			return bkey_s_c_err(ret);
+		return bkey_s_c_null;
 	}
 
-	if (w->total_work + dev_work >= w->total_work &&
-	    w->total_work + dev_work >= dev_work)
-		w->total_work += dev_work;
+	return k;
 }
 
-static struct rebalance_work rebalance_work(struct bch_fs *c)
+noinline_for_stack
+static int do_rebalance_extent(struct moving_context *ctxt,
+			       struct bpos work_pos,
+			       struct btree_iter *extent_iter)
 {
-	struct bch_dev *ca;
-	struct rebalance_work ret = { .dev_most_full_idx = -1 };
-	u64 unknown_dev = atomic64_read(&c->rebalance.work_unknown_dev);
-	unsigned i;
+	struct btree_trans *trans = ctxt->trans;
+	struct bch_fs *c = trans->c;
+	struct bch_fs_rebalance *r = &trans->c->rebalance;
+	struct data_update_opts data_opts;
+	struct bch_io_opts io_opts;
+	struct bkey_s_c k;
+	struct bkey_buf sk;
+	int ret;
+
+	ctxt->stats = &r->work_stats;
+	r->state = BCH_REBALANCE_working;
 
-	for_each_online_member(ca, c, i)
-		rebalance_work_accumulate(&ret,
-			atomic64_read(&ca->rebalance_work),
-			unknown_dev,
-			bucket_to_sector(ca, ca->mi.nbuckets -
-					 ca->mi.first_bucket),
-			i);
+	bch2_bkey_buf_init(&sk);
 
-	rebalance_work_accumulate(&ret,
-		unknown_dev, 0, c->capacity, -1);
+	ret = bkey_err(k = next_rebalance_extent(trans, work_pos,
+						 extent_iter, &data_opts));
+	if (ret || !k.k)
+		goto out;
 
+	ret = bch2_move_get_io_opts_one(trans, &io_opts, k);
+	if (ret)
+		goto out;
+
+	atomic64_add(k.k->size, &ctxt->stats->sectors_seen);
+
+	/*
+	 * The iterator gets unlocked by __bch2_read_extent - need to
+	 * save a copy of @k elsewhere:
+	 */
+	bch2_bkey_buf_reassemble(&sk, c, k);
+	k = bkey_i_to_s_c(sk.k);
+
+	ret = bch2_move_extent(ctxt, NULL, extent_iter, k, io_opts, data_opts);
+	if (ret) {
+		if (bch2_err_matches(ret, ENOMEM)) {
+			/* memory allocation failure, wait for some IO to finish */
+			bch2_move_ctxt_wait_for_io(ctxt);
+			ret = -BCH_ERR_transaction_restart_nested;
+		}
+
+		if (bch2_err_matches(ret, BCH_ERR_transaction_restart))
+			goto out;
+
+		/* skip it and continue, XXX signal failure */
+		ret = 0;
+	}
+out:
+	bch2_bkey_buf_exit(&sk, c);
 	return ret;
 }
 
-static void rebalance_work_reset(struct bch_fs *c)
+static bool rebalance_pred(struct bch_fs *c, void *arg,
+			   struct bkey_s_c k,
+			   struct bch_io_opts *io_opts,
+			   struct data_update_opts *data_opts)
 {
-	struct bch_dev *ca;
-	unsigned i;
+	unsigned target, compression;
 
-	for_each_online_member(ca, c, i)
-		atomic64_set(&ca->rebalance_work, 0);
+	if (k.k->p.inode) {
+		target		= io_opts->background_target;
+		compression	= io_opts->background_compression ?: io_opts->compression;
+	} else {
+		const struct bch_extent_rebalance *r = bch2_bkey_rebalance_opts(k);
+
+		target		= r ? r->target : io_opts->background_target;
+		compression	= r ? r->compression :
+			(io_opts->background_compression ?: io_opts->compression);
+	}
 
-	atomic64_set(&c->rebalance.work_unknown_dev, 0);
+	data_opts->rewrite_ptrs		= bch2_bkey_ptrs_need_rebalance(c, k, target, compression);
+	data_opts->target		= target;
+	return data_opts->rewrite_ptrs != 0;
 }
 
-static unsigned long curr_cputime(void)
+static int do_rebalance_scan(struct moving_context *ctxt, u64 inum, u64 cookie)
 {
-	u64 utime, stime;
+	struct btree_trans *trans = ctxt->trans;
+	struct bch_fs_rebalance *r = &trans->c->rebalance;
+	int ret;
+
+	bch2_move_stats_init(&r->scan_stats, "rebalance_scan");
+	ctxt->stats = &r->scan_stats;
 
-	task_cputime_adjusted(current, &utime, &stime);
-	return nsecs_to_jiffies(utime + stime);
+	if (!inum) {
+		r->scan_start	= BBPOS_MIN;
+		r->scan_end	= BBPOS_MAX;
+	} else {
+		r->scan_start	= BBPOS(BTREE_ID_extents, POS(inum, 0));
+		r->scan_end	= BBPOS(BTREE_ID_extents, POS(inum, U64_MAX));
+	}
+
+	r->state = BCH_REBALANCE_scanning;
+
+	ret = __bch2_move_data(ctxt, r->scan_start, r->scan_end, rebalance_pred, NULL) ?:
+		commit_do(trans, NULL, NULL, BTREE_INSERT_NOFAIL,
+			  bch2_clear_rebalance_needs_scan(trans, inum, cookie));
+
+	bch2_move_stats_exit(&r->scan_stats, trans->c);
+	return ret;
 }
 
-static int bch2_rebalance_thread(void *arg)
+static void rebalance_wait(struct bch_fs *c)
 {
-	struct bch_fs *c = arg;
 	struct bch_fs_rebalance *r = &c->rebalance;
+	struct bch_dev *ca;
 	struct io_clock *clock = &c->io_clock[WRITE];
-	struct rebalance_work w, p;
-	struct bch_move_stats move_stats;
-	unsigned long start, prev_start;
-	unsigned long prev_run_time, prev_run_cputime;
-	unsigned long cputime, prev_cputime;
-	u64 io_start;
-	long throttle;
+	u64 now = atomic64_read(&clock->now);
+	u64 min_member_capacity = 128 * 2048;
+	unsigned i;
 
-	set_freezable();
+	for_each_rw_member(ca, c, i)
+		min_member_capacity = min(min_member_capacity,
+					  ca->mi.nbuckets * ca->mi.bucket_size);
+
+	r->wait_iotime_end		= now + (min_member_capacity >> 6);
+
+	if (r->state != BCH_REBALANCE_waiting) {
+		r->wait_iotime_start	= now;
+		r->wait_wallclock_start	= ktime_get_real_ns();
+		r->state		= BCH_REBALANCE_waiting;
+	}
 
-	io_start	= atomic64_read(&clock->now);
-	p		= rebalance_work(c);
-	prev_start	= jiffies;
-	prev_cputime	= curr_cputime();
+	bch2_kthread_io_clock_wait(clock, r->wait_iotime_end, MAX_SCHEDULE_TIMEOUT);
+}
 
-	bch2_move_stats_init(&move_stats, "rebalance");
-	while (!kthread_wait_freezable(r->enabled)) {
-		cond_resched();
+static int do_rebalance(struct moving_context *ctxt)
+{
+	struct btree_trans *trans = ctxt->trans;
+	struct bch_fs *c = trans->c;
+	struct bch_fs_rebalance *r = &c->rebalance;
+	struct btree_iter rebalance_work_iter, extent_iter = { NULL };
+	struct bkey_s_c k;
+	int ret = 0;
 
-		start			= jiffies;
-		cputime			= curr_cputime();
+	bch2_move_stats_init(&r->work_stats, "rebalance_work");
+	bch2_move_stats_init(&r->scan_stats, "rebalance_scan");
 
-		prev_run_time		= start - prev_start;
-		prev_run_cputime	= cputime - prev_cputime;
+	bch2_trans_iter_init(trans, &rebalance_work_iter,
+			     BTREE_ID_rebalance_work, POS_MIN,
+			     BTREE_ITER_ALL_SNAPSHOTS);
 
-		w			= rebalance_work(c);
-		BUG_ON(!w.dev_most_full_capacity);
+	while (!bch2_move_ratelimit(ctxt) &&
+	       !kthread_wait_freezable(r->enabled)) {
+		bch2_trans_begin(trans);
 
-		if (!w.total_work) {
-			r->state = REBALANCE_WAITING;
-			kthread_wait_freezable(rebalance_work(c).total_work);
+		ret = bkey_err(k = next_rebalance_entry(trans, &rebalance_work_iter));
+		if (bch2_err_matches(ret, BCH_ERR_transaction_restart))
 			continue;
-		}
+		if (ret || !k.k)
+			break;
 
-		/*
-		 * If there isn't much work to do, throttle cpu usage:
-		 */
-		throttle = prev_run_cputime * 100 /
-			max(1U, w.dev_most_full_percent) -
-			prev_run_time;
-
-		if (w.dev_most_full_percent < 20 && throttle > 0) {
-			r->throttled_until_iotime = io_start +
-				div_u64(w.dev_most_full_capacity *
-					(20 - w.dev_most_full_percent),
-					50);
-
-			if (atomic64_read(&clock->now) + clock->max_slop <
-			    r->throttled_until_iotime) {
-				r->throttled_until_cputime = start + throttle;
-				r->state = REBALANCE_THROTTLED;
-
-				bch2_kthread_io_clock_wait(clock,
-					r->throttled_until_iotime,
-					throttle);
-				continue;
-			}
-		}
+		ret = k.k->type == KEY_TYPE_cookie
+			? do_rebalance_scan(ctxt, k.k->p.inode,
+					    le64_to_cpu(bkey_s_c_to_cookie(k).v->cookie))
+			: do_rebalance_extent(ctxt, k.k->p, &extent_iter);
+
+		if (bch2_err_matches(ret, BCH_ERR_transaction_restart))
+			continue;
+		if (ret)
+			break;
 
-		/* minimum 1 mb/sec: */
-		r->pd.rate.rate =
-			max_t(u64, 1 << 11,
-			      r->pd.rate.rate *
-			      max(p.dev_most_full_percent, 1U) /
-			      max(w.dev_most_full_percent, 1U));
-
-		io_start	= atomic64_read(&clock->now);
-		p		= w;
-		prev_start	= start;
-		prev_cputime	= cputime;
-
-		r->state = REBALANCE_RUNNING;
-		memset(&move_stats, 0, sizeof(move_stats));
-		rebalance_work_reset(c);
-
-		bch2_move_data(c,
-			       BBPOS_MIN, BBPOS_MAX,
-			       /* ratelimiting disabled for now */
-			       NULL, /*  &r->pd.rate, */
-			       &move_stats,
-			       writepoint_ptr(&c->rebalance_write_point),
-			       true,
-			       rebalance_pred, NULL);
+		bch2_btree_iter_advance(&rebalance_work_iter);
 	}
 
-	return 0;
+	bch2_trans_iter_exit(trans, &extent_iter);
+	bch2_trans_iter_exit(trans, &rebalance_work_iter);
+	bch2_move_stats_exit(&r->scan_stats, c);
+
+	if (!ret &&
+	    !kthread_should_stop() &&
+	    !atomic64_read(&r->work_stats.sectors_seen) &&
+	    !atomic64_read(&r->scan_stats.sectors_seen)) {
+		bch2_trans_unlock(trans);
+		rebalance_wait(c);
+	}
+
+	bch_err_fn(c, ret);
+	return ret;
 }
 
-void bch2_rebalance_work_to_text(struct printbuf *out, struct bch_fs *c)
+static int bch2_rebalance_thread(void *arg)
 {
+	struct bch_fs *c = arg;
 	struct bch_fs_rebalance *r = &c->rebalance;
-	struct rebalance_work w = rebalance_work(c);
+	struct moving_context ctxt;
+	int ret;
 
-	if (!out->nr_tabstops)
-		printbuf_tabstop_push(out, 20);
+	set_freezable();
 
-	prt_printf(out, "fullest_dev (%i):", w.dev_most_full_idx);
-	prt_tab(out);
+	bch2_moving_ctxt_init(&ctxt, c, NULL, &r->work_stats,
+			      writepoint_ptr(&c->rebalance_write_point),
+			      true);
 
-	prt_human_readable_u64(out, w.dev_most_full_work << 9);
-	prt_printf(out, "/");
-	prt_human_readable_u64(out, w.dev_most_full_capacity << 9);
-	prt_newline(out);
+	while (!kthread_should_stop() &&
+	       !(ret = do_rebalance(&ctxt)))
+		;
 
-	prt_printf(out, "total work:");
-	prt_tab(out);
+	bch2_moving_ctxt_exit(&ctxt);
 
-	prt_human_readable_u64(out, w.total_work << 9);
-	prt_printf(out, "/");
-	prt_human_readable_u64(out, c->capacity << 9);
-	prt_newline(out);
+	return 0;
+}
+
+void bch2_rebalance_status_to_text(struct printbuf *out, struct bch_fs *c)
+{
+	struct bch_fs_rebalance *r = &c->rebalance;
 
-	prt_printf(out, "rate:");
-	prt_tab(out);
-	prt_printf(out, "%u", r->pd.rate.rate);
+	prt_str(out, bch2_rebalance_state_strs[r->state]);
 	prt_newline(out);
+	printbuf_indent_add(out, 2);
 
 	switch (r->state) {
-	case REBALANCE_WAITING:
-		prt_printf(out, "waiting");
+	case BCH_REBALANCE_waiting: {
+		u64 now = atomic64_read(&c->io_clock[WRITE].now);
+
+		prt_str(out, "io wait duration:  ");
+		bch2_prt_human_readable_s64(out, r->wait_iotime_end - r->wait_iotime_start);
+		prt_newline(out);
+
+		prt_str(out, "io wait remaining: ");
+		bch2_prt_human_readable_s64(out, r->wait_iotime_end - now);
+		prt_newline(out);
+
+		prt_str(out, "duration waited:   ");
+		bch2_pr_time_units(out, ktime_get_real_ns() - r->wait_wallclock_start);
+		prt_newline(out);
 		break;
-	case REBALANCE_THROTTLED:
-		prt_printf(out, "throttled for %lu sec or ",
-		       (r->throttled_until_cputime - jiffies) / HZ);
-		prt_human_readable_u64(out,
-			    (r->throttled_until_iotime -
-			     atomic64_read(&c->io_clock[WRITE].now)) << 9);
-		prt_printf(out, " io");
+	}
+	case BCH_REBALANCE_working:
+		bch2_move_stats_to_text(out, &r->work_stats);
 		break;
-	case REBALANCE_RUNNING:
-		prt_printf(out, "running");
+	case BCH_REBALANCE_scanning:
+		bch2_move_stats_to_text(out, &r->scan_stats);
 		break;
 	}
 	prt_newline(out);
+	printbuf_indent_sub(out, 2);
 }
 
 void bch2_rebalance_stop(struct bch_fs *c)
@@ -360,6 +462,4 @@ int bch2_rebalance_start(struct bch_fs *c)
 void bch2_fs_rebalance_init(struct bch_fs *c)
 {
 	bch2_pd_controller_init(&c->rebalance.pd);
-
-	atomic64_set(&c->rebalance.work_unknown_dev, S64_MAX);
 }
diff --git a/fs/bcachefs/rebalance.h b/fs/bcachefs/rebalance.h
index 7ade0bb81cce..28a52638f16c 100644
--- a/fs/bcachefs/rebalance.h
+++ b/fs/bcachefs/rebalance.h
@@ -4,6 +4,9 @@
 
 #include "rebalance_types.h"
 
+int bch2_set_rebalance_needs_scan(struct bch_fs *, u64 inum);
+int bch2_set_fs_needs_rebalance(struct bch_fs *);
+
 static inline void rebalance_wakeup(struct bch_fs *c)
 {
 	struct task_struct *p;
@@ -15,11 +18,7 @@ static inline void rebalance_wakeup(struct bch_fs *c)
 	rcu_read_unlock();
 }
 
-void bch2_rebalance_add_key(struct bch_fs *, struct bkey_s_c,
-			    struct bch_io_opts *);
-void bch2_rebalance_add_work(struct bch_fs *, u64);
-
-void bch2_rebalance_work_to_text(struct printbuf *, struct bch_fs *);
+void bch2_rebalance_status_to_text(struct printbuf *, struct bch_fs *);
 
 void bch2_rebalance_stop(struct bch_fs *);
 int bch2_rebalance_start(struct bch_fs *);
diff --git a/fs/bcachefs/rebalance_types.h b/fs/bcachefs/rebalance_types.h
index 7462a92e9598..0fffb536c1d0 100644
--- a/fs/bcachefs/rebalance_types.h
+++ b/fs/bcachefs/rebalance_types.h
@@ -2,25 +2,36 @@
 #ifndef _BCACHEFS_REBALANCE_TYPES_H
 #define _BCACHEFS_REBALANCE_TYPES_H
 
+#include "bbpos_types.h"
 #include "move_types.h"
 
-enum rebalance_state {
-	REBALANCE_WAITING,
-	REBALANCE_THROTTLED,
-	REBALANCE_RUNNING,
+#define BCH_REBALANCE_STATES()		\
+	x(waiting)			\
+	x(working)			\
+	x(scanning)
+
+enum bch_rebalance_states {
+#define x(t)	BCH_REBALANCE_##t,
+	BCH_REBALANCE_STATES()
+#undef x
 };
 
 struct bch_fs_rebalance {
-	struct task_struct __rcu *thread;
+	struct task_struct __rcu	*thread;
 	struct bch_pd_controller pd;
 
-	atomic64_t		work_unknown_dev;
+	enum bch_rebalance_states	state;
+	u64				wait_iotime_start;
+	u64				wait_iotime_end;
+	u64				wait_wallclock_start;
+
+	struct bch_move_stats		work_stats;
 
-	enum rebalance_state	state;
-	u64			throttled_until_iotime;
-	unsigned long		throttled_until_cputime;
+	struct bbpos			scan_start;
+	struct bbpos			scan_end;
+	struct bch_move_stats		scan_stats;
 
-	unsigned		enabled:1;
+	unsigned			enabled:1;
 };
 
 #endif /* _BCACHEFS_REBALANCE_TYPES_H */
diff --git a/fs/bcachefs/recovery.c b/fs/bcachefs/recovery.c
index 63faf70434ff..02025099c38f 100644
--- a/fs/bcachefs/recovery.c
+++ b/fs/bcachefs/recovery.c
@@ -23,6 +23,7 @@
 #include "logged_ops.h"
 #include "move.h"
 #include "quota.h"
+#include "rebalance.h"
 #include "recovery.h"
 #include "replicas.h"
 #include "sb-clean.h"
diff --git a/fs/bcachefs/recovery_types.h b/fs/bcachefs/recovery_types.h
index e2d8771909ef..515e3d62c2ac 100644
--- a/fs/bcachefs/recovery_types.h
+++ b/fs/bcachefs/recovery_types.h
@@ -42,6 +42,7 @@
 	x(check_nlinks,			PASS_FSCK)						\
 	x(delete_dead_inodes,		PASS_FSCK|PASS_UNCLEAN)					\
 	x(fix_reflink_p,		0)							\
+	x(set_fs_needs_rebalance,	0)							\
 
 enum bch_recovery_pass {
 #define x(n, when)	BCH_RECOVERY_PASS_##n,
diff --git a/fs/bcachefs/reflink.c b/fs/bcachefs/reflink.c
index 540c78cd4b0c..dbbdf1955f76 100644
--- a/fs/bcachefs/reflink.c
+++ b/fs/bcachefs/reflink.c
@@ -7,6 +7,7 @@
 #include "inode.h"
 #include "io_misc.h"
 #include "io_write.h"
+#include "rebalance.h"
 #include "reflink.h"
 #include "subvolume.h"
 #include "super-io.h"
@@ -252,6 +253,7 @@ s64 bch2_remap_range(struct bch_fs *c,
 	struct bpos dst_start = POS(dst_inum.inum, dst_offset);
 	struct bpos src_start = POS(src_inum.inum, src_offset);
 	struct bpos dst_end = dst_start, src_end = src_start;
+	struct bch_io_opts opts;
 	struct bpos src_want;
 	u64 dst_done;
 	u32 dst_snapshot, src_snapshot;
@@ -269,6 +271,10 @@ s64 bch2_remap_range(struct bch_fs *c,
 	bch2_bkey_buf_init(&new_src);
 	trans = bch2_trans_get(c);
 
+	ret = bch2_inum_opts_get(trans, src_inum, &opts);
+	if (ret)
+		goto err;
+
 	bch2_trans_iter_init(trans, &src_iter, BTREE_ID_extents, src_start,
 			     BTREE_ITER_INTENT);
 	bch2_trans_iter_init(trans, &dst_iter, BTREE_ID_extents, dst_start,
@@ -352,10 +358,13 @@ s64 bch2_remap_range(struct bch_fs *c,
 				min(src_k.k->p.offset - src_want.offset,
 				    dst_end.offset - dst_iter.pos.offset));
 
-		ret = bch2_extent_update(trans, dst_inum, &dst_iter,
-					 new_dst.k, &disk_res,
-					 new_i_size, i_sectors_delta,
-					 true);
+		ret =   bch2_bkey_set_needs_rebalance(c, new_dst.k,
+					opts.background_target,
+					opts.background_compression) ?:
+			bch2_extent_update(trans, dst_inum, &dst_iter,
+					new_dst.k, &disk_res,
+					new_i_size, i_sectors_delta,
+					true);
 		bch2_disk_reservation_put(c, &disk_res);
 	}
 	bch2_trans_iter_exit(trans, &dst_iter);
@@ -386,7 +395,7 @@ s64 bch2_remap_range(struct bch_fs *c,
 
 		bch2_trans_iter_exit(trans, &inode_iter);
 	} while (bch2_err_matches(ret2, BCH_ERR_transaction_restart));
-
+err:
 	bch2_trans_put(trans);
 	bch2_bkey_buf_exit(&new_src, c);
 	bch2_bkey_buf_exit(&new_dst, c);
diff --git a/fs/bcachefs/sysfs.c b/fs/bcachefs/sysfs.c
index d176e46684cc..db2727e5cc5f 100644
--- a/fs/bcachefs/sysfs.c
+++ b/fs/bcachefs/sysfs.c
@@ -212,7 +212,7 @@ read_attribute(copy_gc_wait);
 
 rw_attribute(rebalance_enabled);
 sysfs_pd_controller_attribute(rebalance);
-read_attribute(rebalance_work);
+read_attribute(rebalance_status);
 rw_attribute(promote_whole_extents);
 
 read_attribute(new_stripes);
@@ -386,8 +386,8 @@ SHOW(bch2_fs)
 	if (attr == &sysfs_copy_gc_wait)
 		bch2_copygc_wait_to_text(out, c);
 
-	if (attr == &sysfs_rebalance_work)
-		bch2_rebalance_work_to_text(out, c);
+	if (attr == &sysfs_rebalance_status)
+		bch2_rebalance_status_to_text(out, c);
 
 	sysfs_print(promote_whole_extents,	c->promote_whole_extents);
 
@@ -646,7 +646,7 @@ struct attribute *bch2_fs_internal_files[] = {
 	&sysfs_copy_gc_wait,
 
 	&sysfs_rebalance_enabled,
-	&sysfs_rebalance_work,
+	&sysfs_rebalance_status,
 	sysfs_pd_controller_files(rebalance),
 
 	&sysfs_moving_ctxts,
@@ -707,10 +707,8 @@ STORE(bch2_fs_opts_dir)
 	bch2_opt_set_by_id(&c->opts, id, v);
 
 	if ((id == Opt_background_target ||
-	     id == Opt_background_compression) && v) {
-		bch2_rebalance_add_work(c, S64_MAX);
-		rebalance_wakeup(c);
-	}
+	     id == Opt_background_compression) && v)
+		bch2_set_rebalance_needs_scan(c, 0);
 
 	ret = size;
 err:
diff --git a/fs/bcachefs/xattr.c b/fs/bcachefs/xattr.c
index b069b1a62e25..74b41f567ab8 100644
--- a/fs/bcachefs/xattr.c
+++ b/fs/bcachefs/xattr.c
@@ -590,7 +590,7 @@ static int bch2_xattr_bcachefs_set(const struct xattr_handler *handler,
 	if (value &&
 	    (opt_id == Opt_background_compression ||
 	     opt_id == Opt_background_target))
-		bch2_rebalance_add_work(c, inode->v.i_blocks);
+		bch2_set_rebalance_needs_scan(c, inode->ei_inode.bi_inum);
 
 	return bch2_err_class(ret);
 }
-- 
2.42.0


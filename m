Received: from mail-43166.protonmail.ch (mail-43166.protonmail.ch [185.70.43.166])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0B47190664
	for <linux-bcachefs@vger.kernel.org>; Sat, 24 Jan 2026 11:19:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.70.43.166
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769253598; cv=none; b=SxL5NnEbSYu4AAuPriV1dTbMad+JAZHbTn7x4V2wQFScZKrGDmUUWdmRU4WY/SYRiapiBcxlAAK/t3cSxP8VoOCXXciW0hun/0WfCAMKrGtjvM0f2oLuFTkHMJctyEJPqoiFO/v/cuJcl+4qB4FCmBcNLbEpaUQTfWPndeeNJ6Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769253598; c=relaxed/simple;
	bh=fjfnFZ/t/R6DVgYlrfxA6jJKtws1F55mMjd8CJxymPo=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ggf53ZojotBf8kVE5bT9S91f6E9ijJnipEk/mny/Dgws4ACEwNjyY6PDI6IwiQxdjp3OLuZ2bHjWEp4Mysnepcpy7u3lvjra0zm2z8K6gy3rVFaqtDWe20SS3Vr3DmxgaDQ1Xsb8sldpJD1k7EWKeMXIdHWBIFB9QdgY9kFeZRY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=proton.me; spf=pass smtp.mailfrom=proton.me; dkim=pass (2048-bit key) header.d=proton.me header.i=@proton.me header.b=VdPBCfpK; arc=none smtp.client-ip=185.70.43.166
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=proton.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=proton.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=proton.me header.i=@proton.me header.b="VdPBCfpK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=proton.me;
	s=protonmail; t=1769253585; x=1769512785;
	bh=D1xlHNSdo05Q+yfd1KBUC2uWGZWT+jGv+mtCuiVeLY0=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=VdPBCfpKXcGJPoOk4F7j48P07rZEueedm7hvK+0xUJ0BS3MA4aHqIkUavQhWAE/1i
	 bFKX2z0I1qZ5RFYFVvGlEIt6nEUnRRo9ThjgS8esjAfKDnhVimF2yMMotjzC3PI1Me
	 PGM2H5Kv4Bd4YiGJeDQ8lx28u9/29NtIJvhMzYOwJQnPtCOy+JA1ZlNn6gjSZC60SB
	 N8bzLJJRdFVbJtdVkzepN4kFZnL65iJvIwixPlGtIJnogfhZ/sr344d982zcs54TSx
	 WmU8nDsp4C6kypIDIkERsjSkmRKy5HQSiU1+iF0rLwW3kO00kM4aIoKGC1nJO0P49D
	 y4hX1BkWEeQ2A==
Date: Sat, 24 Jan 2026 11:19:41 +0000
To: linux-bcachefs@vger.kernel.org
From: Jul Lang <jullanggit@proton.me>
Cc: kent.overstreet@linux.dev, Jul Lang <jullanggit@proton.me>
Subject: [PATCH 2/2] fix typos
Message-ID: <20260124111913.6263-3-jullanggit@proton.me>
In-Reply-To: <20260124111913.6263-1-jullanggit@proton.me>
References: <20260124111913.6263-1-jullanggit@proton.me>
Feedback-ID: 86367135:user:proton
X-Pm-Message-ID: 8e308f1b36e81e34e1a9fc959ab366dc1ae416e7
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Signed-off-by: Jul Lang <jullanggit@proton.me>
---
 fs/bcachefs/alloc/accounting.c            |  2 +-
 fs/bcachefs/alloc/buckets.c               |  2 +-
 fs/bcachefs/alloc/check.c                 |  2 +-
 fs/bcachefs/alloc/foreground.c            |  6 +++---
 fs/bcachefs/bcachefs.h                    |  2 +-
 fs/bcachefs/bcachefs_format.h             | 10 +++++-----
 fs/bcachefs/bcachefs_ioctl.h              |  4 ++--
 fs/bcachefs/btree/bkey_methods.c          |  4 ++--
 fs/bcachefs/btree/bkey_methods.h          |  2 +-
 fs/bcachefs/btree/bset.h                  |  4 ++--
 fs/bcachefs/btree/cache.c                 |  2 +-
 fs/bcachefs/btree/interior.h              |  2 +-
 fs/bcachefs/btree/iter.c                  |  4 ++--
 fs/bcachefs/btree/update.c                |  4 ++--
 fs/bcachefs/data/checksum.c               |  2 +-
 fs/bcachefs/data/reconcile/work.c         |  2 +-
 fs/bcachefs/debug/async_objs.c            |  2 +-
 fs/bcachefs/fs/check.c                    |  2 +-
 fs/bcachefs/fs/inode.c                    |  2 +-
 fs/bcachefs/init/passes.c                 |  2 +-
 fs/bcachefs/init/progress.h               |  2 +-
 fs/bcachefs/journal/journal.c             |  4 ++--
 fs/bcachefs/journal/types.h               |  4 ++--
 fs/bcachefs/journal/write.c               |  2 +-
 fs/bcachefs/sb/io.c                       |  2 +-
 fs/bcachefs/sb/members_format.h           |  2 +-
 fs/bcachefs/snapshots/format.h            |  4 ++--
 fs/bcachefs/util/eytzinger.h              |  2 +-
 fs/bcachefs/util/mean_and_variance.h      |  4 ++--
 fs/bcachefs/util/mean_and_variance_test.c |  2 +-
 fs/bcachefs/util/printbuf.c               |  2 +-
 fs/bcachefs/util/printbuf.h               |  4 ++--
 fs/bcachefs/util/rcu_pending.c            |  2 +-
 fs/bcachefs/util/siphash.h                |  2 +-
 fs/bcachefs/util/six.c                    |  6 +++---
 fs/bcachefs/util/six.h                    |  4 ++--
 fs/bcachefs/util/time_stats.h             |  2 +-
 fs/bcachefs/util/util.c                   |  2 +-
 fs/bcachefs/vfs/io.c                      |  2 +-
 39 files changed, 58 insertions(+), 58 deletions(-)

diff --git a/fs/bcachefs/alloc/accounting.c b/fs/bcachefs/alloc/accounting.=
c
index c86a01410..0e3de80b5 100644
--- a/fs/bcachefs/alloc/accounting.c
+++ b/fs/bcachefs/alloc/accounting.c
@@ -525,7 +525,7 @@ void bch2_accounting_mem_gc(struct bch_fs *c)
  * Read out accounting keys for replicas entries, as an array of
  * bch_replicas_usage entries.
  *
- * Note: this may be deprecated/removed at smoe point in the future and re=
placed
+ * Note: this may be deprecated/removed at some point in the future and re=
placed
  * with something more general, it exists to support the ioctl used by the
  * 'bcachefs fs usage' command.
  */
diff --git a/fs/bcachefs/alloc/buckets.c b/fs/bcachefs/alloc/buckets.c
index e6261a6cc..4a3373572 100644
--- a/fs/bcachefs/alloc/buckets.c
+++ b/fs/bcachefs/alloc/buckets.c
@@ -353,7 +353,7 @@ int bch2_check_fix_ptrs(struct btree_trans *trans,
=20
 =09=09=09/*
 =09=09=09 * no locking, we're single threaded and not rw yet, see
-=09=09=09 * the big assertino above that we repeat here:
+=09=09=09 * the big assertion above that we repeat here:
 =09=09=09 */
 =09=09=09BUG_ON(test_bit(BCH_FS_rw, &c->flags));
=20
diff --git a/fs/bcachefs/alloc/check.c b/fs/bcachefs/alloc/check.c
index eef2d8df3..db91af741 100644
--- a/fs/bcachefs/alloc/check.c
+++ b/fs/bcachefs/alloc/check.c
@@ -397,7 +397,7 @@ int __bch2_check_discard_freespace_key(struct btree_tra=
ns *trans, struct btree_i
 =09if (!bch2_dev_bucket_exists(c, bucket)) {
 =09=09if (__fsck_err(trans, fsck_flags,
 =09=09=09       need_discard_freespace_key_to_invalid_dev_bucket,
-=09=09=09       "entry in %s btree for nonexistant dev:bucket %llu:%llu",
+=09=09=09       "entry in %s btree for nonexistent dev:bucket %llu:%llu",
 =09=09=09       bch2_btree_id_str(iter->btree_id), bucket.inode, bucket.of=
fset))
 =09=09=09ret =3D delete_discard_freespace_key(trans, iter, async_repair);
 =09=09else
diff --git a/fs/bcachefs/alloc/foreground.c b/fs/bcachefs/alloc/foreground.=
c
index 7f4a0674d..c7bf0c3f9 100644
--- a/fs/bcachefs/alloc/foreground.c
+++ b/fs/bcachefs/alloc/foreground.c
@@ -388,7 +388,7 @@ static struct open_bucket *bch2_bucket_alloc_freelist(s=
truct btree_trans *trans,
 =09=09=09=09=09 POS(ca->dev_idx, U64_MAX),
 =09=09=09=09=09 0, k, ret) {
 =09=09/*
-=09=09 * peek normally dosen't trim extents - they can span iter.pos,
+=09=09 * peek normally doesn't trim extents - they can span iter.pos,
 =09=09 * which is not what we want here:
 =09=09 */
 =09=09iter.k.size =3D iter.k.p.offset - iter.pos.offset;
@@ -633,7 +633,7 @@ static noinline void bch2_stripe_state_rescale(struct d=
ev_stripe_state *stripe)
 =09 * to the whole filesystem.
 =09 */
 =09u64 scale_max =3D U64_MAX;=09/* maximum we can subtract without underfl=
ow */
-=09u64 scale_min =3D 0;=09=09/* minumum we must subtract to avoid overflow=
 */
+=09u64 scale_min =3D 0;=09=09/* minimum we must subtract to avoid overflow=
 */
=20
 =09for (u64 *v =3D stripe->next_alloc;
 =09     v < stripe->next_alloc + ARRAY_SIZE(stripe->next_alloc); v++) {
@@ -1348,7 +1348,7 @@ void bch2_fs_allocator_foreground_init(struct bch_fs =
*c)
 =09mutex_init(&a->write_points_hash_lock);
 =09a->write_points_nr =3D ARRAY_SIZE(a->write_points);
=20
-=09/* open bucket 0 is a sentinal NULL: */
+=09/* open bucket 0 is a sentinel NULL: */
 =09spin_lock_init(&a->open_buckets[0].lock);
=20
 =09for (ob =3D a->open_buckets + 1;
diff --git a/fs/bcachefs/bcachefs.h b/fs/bcachefs/bcachefs.h
index 8b877099a..d3cfce3a4 100644
--- a/fs/bcachefs/bcachefs.h
+++ b/fs/bcachefs/bcachefs.h
@@ -778,7 +778,7 @@ struct bch_fs {
 =09struct enumerated_ref=09writes;
=20
 =09/*
-=09 * Analagous to c->writes, for asynchronous ops that don't necessarily
+=09 * Analogous to c->writes, for asynchronous ops that don't necessarily
 =09 * need fs to be read-write
 =09 */
 =09refcount_t=09=09ro_ref;
diff --git a/fs/bcachefs/bcachefs_format.h b/fs/bcachefs/bcachefs_format.h
index aa3ffe695..10368565d 100644
--- a/fs/bcachefs/bcachefs_format.h
+++ b/fs/bcachefs/bcachefs_format.h
@@ -238,7 +238,7 @@ struct bkey {
  *
  * Specifically, when i was designing bkey, I wanted the header to be no
  * bigger than necessary so that bkey_packed could use the rest. That mean=
s that
- * decently offten extent keys will fit into only 8 bytes, instead of spil=
ling over
+ * decently often extent keys will fit into only 8 bytes, instead of spill=
ing over
  * to 16.
  *
  * But packed_bkey treats the part after the header - the packed section -
@@ -250,7 +250,7 @@ struct bkey {
  * So that constrains the key part of a bkig endian bkey to start right
  * after the header.
  *
- * If we ever do a bkey_v2 and need to expand the hedaer by another byte f=
or
+ * If we ever do a bkey_v2 and need to expand the header by another byte f=
or
  * some reason - that will clean up this wart.
  */
 __aligned(8)
@@ -844,7 +844,7 @@ struct bch_sb_field_ext {
 =09x(btree_node_accounting,=09BCH_VERSION(1, 31))=09=09\
 =09x(sb_field_extent_type_u64s,=09BCH_VERSION(1, 32))=09=09\
 =09x(reconcile,=09=09=09BCH_VERSION(1, 33))=09=09\
-=09x(extented_key_type_error,=09BCH_VERSION(1, 34))=09=09\
+=09x(extended_key_type_error,=09BCH_VERSION(1, 34))=09=09\
 =09x(bucket_stripe_index,=09=09BCH_VERSION(1, 35))
=20
 enum bcachefs_metadata_version {
@@ -925,7 +925,7 @@ struct bch_sb {
=20
 /*
  * Flags:
- * BCH_SB_INITALIZED=09- set on first mount
+ * BCH_SB_INITIALIZED=09- set on first mount
  * BCH_SB_CLEAN=09=09- did we shut down cleanly? Just a hint, doesn't affe=
ct
  *=09=09=09  behaviour of mount/recovery path:
  * BCH_SB_INODE_32BIT=09- limit inode numbers to 32 bits
@@ -1523,7 +1523,7 @@ static inline bool btree_id_can_reconstruct(enum btre=
e_id btree)
 }
=20
 /*
- * We can reconstruct BTREE_ID_alloc, but reconstucting it from scratch is=
 not
+ * We can reconstruct BTREE_ID_alloc, but reconstructing it from scratch i=
s not
  * so cheap and OOMs on huge filesystems (until we have online
  * check_allocations)
  */
diff --git a/fs/bcachefs/bcachefs_ioctl.h b/fs/bcachefs/bcachefs_ioctl.h
index dd926db42..05e170f06 100644
--- a/fs/bcachefs/bcachefs_ioctl.h
+++ b/fs/bcachefs/bcachefs_ioctl.h
@@ -113,7 +113,7 @@ struct bch_ioctl_query_uuid {
  * may be either offline or offline.
  *
  * Will fail removing @dev would leave us with insufficient read write dev=
ices
- * or degraded/unavailable data, unless the approprate BCH_FORCE_IF_* flag=
s are
+ * or degraded/unavailable data, unless the appropriate BCH_FORCE_IF_* fla=
gs are
  * set.
  */
=20
@@ -136,7 +136,7 @@ struct bch_ioctl_query_uuid {
  *
  * Will fail (similarly to BCH_IOCTL_DISK_SET_STATE) if offlining @dev wou=
ld
  * leave us with insufficient read write devices or degraded/unavailable d=
ata,
- * unless the approprate BCH_FORCE_IF_* flags are set.
+ * unless the appropriate BCH_FORCE_IF_* flags are set.
  */
=20
 struct bch_ioctl_disk {
diff --git a/fs/bcachefs/btree/bkey_methods.c b/fs/bcachefs/btree/bkey_meth=
ods.c
index a694adcca..95a92696a 100644
--- a/fs/bcachefs/btree/bkey_methods.c
+++ b/fs/bcachefs/btree/bkey_methods.c
@@ -89,7 +89,7 @@ void bch2_set_bkey_error(struct bch_fs *c, struct bkey_i =
*k, enum bch_key_type_e
 {
 =09k->k.type =3D KEY_TYPE_error;
=20
-=09if (!bch2_request_incompat_feature(c, bcachefs_metadata_version_extente=
d_key_type_error)) {
+=09if (!bch2_request_incompat_feature(c, bcachefs_metadata_version_extende=
d_key_type_error)) {
 =09=09set_bkey_val_bytes(&k->k, sizeof(struct bch_error));
=20
 =09=09struct bkey_i_error *e =3D bkey_i_to_error(k);
@@ -389,7 +389,7 @@ bool bch2_bkey_merge(struct bch_fs *c, struct bkey_s l,=
 struct bkey_s_c r)
 =09const struct bkey_ops *ops =3D bch2_bkey_type_ops(l.k->type);
=20
 =09return ops->key_merge &&
-=09=09bch2_bkey_maybe_mergable(l.k, r.k) &&
+=09=09bch2_bkey_maybe_mergeable(l.k, r.k) &&
 =09=09(u64) l.k->size + r.k->size <=3D KEY_SIZE_MAX &&
 =09=09!static_branch_unlikely(&bch2_key_merging_disabled) &&
 =09=09ops->key_merge(c, l, r);
diff --git a/fs/bcachefs/btree/bkey_methods.h b/fs/bcachefs/btree/bkey_meth=
ods.h
index 3af1f35b4..08e74d8be 100644
--- a/fs/bcachefs/btree/bkey_methods.h
+++ b/fs/bcachefs/btree/bkey_methods.h
@@ -65,7 +65,7 @@ void bch2_bkey_val_to_text(struct printbuf *, struct bch_=
fs *,
=20
 void bch2_bkey_swab_val(const struct bch_fs *c, struct bkey_s);
=20
-static inline bool bch2_bkey_maybe_mergable(const struct bkey *l, const st=
ruct bkey *r)
+static inline bool bch2_bkey_maybe_mergeable(const struct bkey *l, const s=
truct bkey *r)
 {
 =09return l->type =3D=3D r->type &&
 =09=09!bversion_cmp(l->bversion, r->bversion) &&
diff --git a/fs/bcachefs/btree/bset.h b/fs/bcachefs/btree/bset.h
index f626d2ff8..b51144c7f 100644
--- a/fs/bcachefs/btree/bset.h
+++ b/fs/bcachefs/btree/bset.h
@@ -45,7 +45,7 @@
  * 4 in memory - we lazily resort as needed.
  *
  * We implement code here for creating and maintaining auxiliary search tr=
ees
- * (described below) for searching an individial bset, and on top of that =
we
+ * (described below) for searching an individual bset, and on top of that =
we
  * implement a btree iterator.
  *
  * BTREE ITERATOR:
@@ -179,7 +179,7 @@ static inline enum bset_aux_tree_type bset_aux_tree_typ=
e(const struct bset_tree
  * memory if it was 128.
  *
  * It definites the number of bytes (in struct bset) per struct bkey_float=
 in
- * the auxiliar search tree - when we're done searching the bset_float tre=
e we
+ * the auxiliary search tree - when we're done searching the bset_float tr=
ee we
  * have this many bytes left that we do a linear search over.
  *
  * Since (after level 5) every level of the bset_tree is on a new cachelin=
e,
diff --git a/fs/bcachefs/btree/cache.c b/fs/bcachefs/btree/cache.c
index ce2799114..2a7196782 100644
--- a/fs/bcachefs/btree/cache.c
+++ b/fs/bcachefs/btree/cache.c
@@ -1212,7 +1212,7 @@ struct btree *bch2_btree_node_get(struct btree_trans =
*trans, struct btree_path *
 =09/*
 =09 * Check b->hash_val _before_ calling btree_node_lock() - this might no=
t
 =09 * be the node we want anymore, and trying to lock the wrong node could
-=09 * cause an unneccessary transaction restart:
+=09 * cause an unnecessary transaction restart:
 =09 */
 =09if (unlikely(!c->opts.btree_node_mem_ptr_optimization ||
 =09=09     !b ||
diff --git a/fs/bcachefs/btree/interior.h b/fs/bcachefs/btree/interior.h
index 952a8cd45..1996395f8 100644
--- a/fs/bcachefs/btree/interior.h
+++ b/fs/bcachefs/btree/interior.h
@@ -117,7 +117,7 @@ struct btree_update {
 =09struct keylist=09=09=09parent_keys;
 =09/*
 =09 * Enough room for btree_split's keys without realloc - btree node
-=09 * pointers never have crc/compression info, so we only need to acount
+=09 * pointers never have crc/compression info, so we only need to account
 =09 * for the pointers for three keys
 =09 */
 =09u64=09=09=09=09inline_keys[BKEY_BTREE_PTR_U64s_MAX * 3];
diff --git a/fs/bcachefs/btree/iter.c b/fs/bcachefs/btree/iter.c
index f763449db..2a6b8908a 100644
--- a/fs/bcachefs/btree/iter.c
+++ b/fs/bcachefs/btree/iter.c
@@ -3479,7 +3479,7 @@ u32 bch2_trans_begin(struct btree_trans *trans)
=20
 =09=09/*
 =09=09 * If the transaction wasn't restarted, we're presuming to be
-=09=09 * doing something new: dont keep iterators excpt the ones that
+=09=09 * doing something new: dont keep iterators except the ones that
 =09=09 * are in use - except for the subvolumes btree:
 =09=09 */
 =09=09if (!trans->restarted && path->btree_id !=3D BTREE_ID_subvolumes)
@@ -3623,7 +3623,7 @@ struct btree_trans *__bch2_trans_get(struct bch_fs *c=
, unsigned fn_idx)
=20
 =09*trans_paths_nr(trans->paths) =3D BTREE_ITER_INITIAL;
=20
-=09/* Reserve path 0 for our sentinal value */
+=09/* Reserve path 0 for our sentinel value */
 =09trans->paths_allocated[0] =3D 1;
=20
 =09static struct lock_class_key lockdep_key;
diff --git a/fs/bcachefs/btree/update.c b/fs/bcachefs/btree/update.c
index 5f2de66b4..f03c24b2e 100644
--- a/fs/bcachefs/btree/update.c
+++ b/fs/bcachefs/btree/update.c
@@ -250,7 +250,7 @@ static int bch2_trans_update_extent(struct btree_trans =
*trans,
 =09=09goto out;
=20
 =09if (bkey_eq(k.k->p, bkey_start_pos(&insert->k))) {
-=09=09if (bch2_bkey_maybe_mergable(k.k, &insert->k))
+=09=09if (bch2_bkey_maybe_mergeable(k.k, &insert->k))
 =09=09=09try(extent_front_merge(trans, &iter, k, &insert, flags));
=20
 =09=09goto next;
@@ -293,7 +293,7 @@ static int bch2_trans_update_extent(struct btree_trans =
*trans,
 =09=09=09goto out;
 =09}
=20
-=09if (bch2_bkey_maybe_mergable(&insert->k, k.k))
+=09if (bch2_bkey_maybe_mergeable(&insert->k, k.k))
 =09=09try(extent_back_merge(trans, &iter, insert, k));
 out:
 =09return !bkey_deleted(&insert->k)
diff --git a/fs/bcachefs/data/checksum.c b/fs/bcachefs/data/checksum.c
index 999024202..9b587887f 100644
--- a/fs/bcachefs/data/checksum.c
+++ b/fs/bcachefs/data/checksum.c
@@ -20,7 +20,7 @@
 /*
  * bch2_checksum state is an abstraction of the checksum state calculated =
over different pages.
  * it features page merging without having the checksum algorithm lose its=
 state.
- * for native checksum aglorithms (like crc), a default seed value will do=
.
+ * for native checksum algorithms (like crc), a default seed value will do=
.
  * for hash-like algorithms, a state needs to be stored
  */
=20
diff --git a/fs/bcachefs/data/reconcile/work.c b/fs/bcachefs/data/reconcile=
/work.c
index 1abe4354b..a761eb56d 100644
--- a/fs/bcachefs/data/reconcile/work.c
+++ b/fs/bcachefs/data/reconcile/work.c
@@ -1322,7 +1322,7 @@ void bch2_reconcile_stop(struct bch_fs *c)
 =09c->reconcile.thread =3D NULL;
=20
 =09if (p) {
-=09=09/* for sychronizing with bch2_reconcile_wakeup() */
+=09=09/* for synchronizing with bch2_reconcile_wakeup() */
 =09=09synchronize_rcu();
=20
 =09=09kthread_stop(p);
diff --git a/fs/bcachefs/debug/async_objs.c b/fs/bcachefs/debug/async_objs.=
c
index 6717deadd..9bec6c9e1 100644
--- a/fs/bcachefs/debug/async_objs.c
+++ b/fs/bcachefs/debug/async_objs.c
@@ -1,7 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0
 /*
  * Async obj debugging: keep asynchronous objects on (very fast) lists, ma=
ke
- * them visibile in debugfs:
+ * them visible in debugfs:
  */
=20
 #include "bcachefs.h"
diff --git a/fs/bcachefs/fs/check.c b/fs/bcachefs/fs/check.c
index 6b6da8406..c32fef694 100644
--- a/fs/bcachefs/fs/check.c
+++ b/fs/bcachefs/fs/check.c
@@ -1886,7 +1886,7 @@ int bch2_fix_reflink_p(struct bch_fs *c)
 =09=09=09fix_reflink_p_key(trans, &iter, k));
 }
=20
-/* translate to return code of fsck commad - man(8) fsck */
+/* translate to return code of fsck command - man(8) fsck */
 int bch2_fs_fsck_errcode(struct bch_fs *c, struct printbuf *msg)
 {
 =09int ret =3D 0;
diff --git a/fs/bcachefs/fs/inode.c b/fs/bcachefs/fs/inode.c
index 5a0925edd..ef1105811 100644
--- a/fs/bcachefs/fs/inode.c
+++ b/fs/bcachefs/fs/inode.c
@@ -1367,7 +1367,7 @@ int bch2_delete_dead_inodes(struct bch_fs *c)
 =09/*
 =09 * if we ran check_inodes() unlinked inodes will have already been
 =09 * cleaned up but the write buffer will be out of sync; therefore we
-=09 * alway need a write buffer flush
+=09 * always need a write buffer flush
 =09 *
 =09 * Weird transaction restart handling here because on successful delete=
,
 =09 * bch2_inode_rm_snapshot() will return a nested transaction restart,
diff --git a/fs/bcachefs/init/passes.c b/fs/bcachefs/init/passes.c
index 5e49ca218..1a88cecf9 100644
--- a/fs/bcachefs/init/passes.c
+++ b/fs/bcachefs/init/passes.c
@@ -554,7 +554,7 @@ int bch2_run_recovery_passes(struct bch_fs *c, u64 orig=
_passes_to_run, bool fail
=20
 =09=09if (r->rewound_to) {
 =09=09=09r->rewound_from=09=3D max(r->rewound_from, pass);
-=09=09=09/* Restore r->current_passses up to and including r->rewound_to *=
/
+=09=09=09/* Restore r->current_passes up to and including r->rewound_to */
 =09=09=09r->current_passes |=3D orig_passes_to_run & (~0ULL << r->rewound_=
to);
 =09=09=09r->rewound_to =3D 0;
 =09=09} else if (!ret2) {
diff --git a/fs/bcachefs/init/progress.h b/fs/bcachefs/init/progress.h
index 877b0e311..74dbee395 100644
--- a/fs/bcachefs/init/progress.h
+++ b/fs/bcachefs/init/progress.h
@@ -8,7 +8,7 @@
  * Lame progress indicators
  *
  * We don't like to use these because they print to the dmesg console, whi=
ch is
- * spammy - we much prefer to be wired up to a userspace programm (e.g. vi=
a
+ * spammy - we much prefer to be wired up to a userspace program (e.g. via
  * thread_with_file) and have it print the progress indicator.
  *
  * But some code is old and doesn't support that, or runs in a context whe=
re
diff --git a/fs/bcachefs/journal/journal.c b/fs/bcachefs/journal/journal.c
index 1a680c9a7..2242bdb89 100644
--- a/fs/bcachefs/journal/journal.c
+++ b/fs/bcachefs/journal/journal.c
@@ -123,7 +123,7 @@ journal_error_check_stuck(struct journal *j, int error,=
 unsigned flags)
 =09CLASS(bch_log_msg, msg)(c);
 =09msg.m.suppress =3D true; /* only print once, when we go ERO */
=20
-=09prt_printf(&msg.m, "Journal stuck! Hava a pre-reservation but journal f=
ull (error %s)",
+=09prt_printf(&msg.m, "Journal stuck! Have a pre-reservation but journal f=
ull (error %s)",
 =09=09   bch2_err_str(error));
 =09bch2_journal_debug_to_text(&msg.m, j);
=20
@@ -879,7 +879,7 @@ bool bch2_journal_noflush_seq(struct journal *j, u64 st=
art, u64 end)
 =09     unwritten_seq++) {
 =09=09struct journal_buf *buf =3D journal_seq_to_buf(j, unwritten_seq);
=20
-=09=09/* journal flush already in flight, or flush requseted */
+=09=09/* journal flush already in flight, or flush requested */
 =09=09if (buf->must_flush)
 =09=09=09return false;
=20
diff --git a/fs/bcachefs/journal/types.h b/fs/bcachefs/journal/types.h
index 0d2ec3e04..5a43f619a 100644
--- a/fs/bcachefs/journal/types.h
+++ b/fs/bcachefs/journal/types.h
@@ -130,7 +130,7 @@ union journal_res_state {
 #define JOURNAL_ENTRY_SIZE_MAX=09=09(4U  << 20) /* 4M */
=20
 /*
- * We stash some journal state as sentinal values in cur_entry_offset:
+ * We stash some journal state as sentinel values in cur_entry_offset:
  * note - cur_entry_offset is in units of u64s
  */
 #define JOURNAL_ENTRY_OFFSET_MAX=09((1U << 22) - 1)
@@ -212,7 +212,7 @@ struct journal {
 =09darray_u64=09=09early_journal_entries;
=20
 =09/*
-=09 * Protects journal_buf->data, when accessing without a jorunal
+=09 * Protects journal_buf->data, when accessing without a journal
 =09 * reservation: for synchronization between the btree write buffer code
 =09 * and the journal write path:
 =09 */
diff --git a/fs/bcachefs/journal/write.c b/fs/bcachefs/journal/write.c
index 4d1449a3a..8e9ee9349 100644
--- a/fs/bcachefs/journal/write.c
+++ b/fs/bcachefs/journal/write.c
@@ -289,7 +289,7 @@ static CLOSURE_CALLBACK(journal_write_done)
 =09=09=09=09 * can return an error if appending to
 =09=09=09=09 * replicas_refs failed, but we don't
 =09=09=09=09 * care - it's a preallocated darray so
-=09=09=09=09 * it'll allways be able to do some
+=09=09=09=09 * it'll always be able to do some
 =09=09=09=09 * work, and we have to retry anyways,
 =09=09=09=09 * because we have to drop j->lock to
 =09=09=09=09 * put the replicas refs before updating
diff --git a/fs/bcachefs/sb/io.c b/fs/bcachefs/sb/io.c
index 849d71bc5..80743a474 100644
--- a/fs/bcachefs/sb/io.c
+++ b/fs/bcachefs/sb/io.c
@@ -479,7 +479,7 @@ int bch2_sb_validate(struct bch_sb *sb, struct bch_opts=
 *opts, u64 read_offset,
 =09=09/*
 =09=09 * Been seeing a bug where these are getting inexplicably
 =09=09 * zeroed, so we're now validating them, but we have to be
-=09=09 * careful not to preven people's filesystems from mounting:
+=09=09 * careful not to prevent people's filesystems from mounting:
 =09=09 */
 =09=09if (!BCH_SB_JOURNAL_FLUSH_DELAY(sb))
 =09=09=09SET_BCH_SB_JOURNAL_FLUSH_DELAY(sb, 1000);
diff --git a/fs/bcachefs/sb/members_format.h b/fs/bcachefs/sb/members_forma=
t.h
index 2c9f72653..941507d63 100644
--- a/fs/bcachefs/sb/members_format.h
+++ b/fs/bcachefs/sb/members_format.h
@@ -9,7 +9,7 @@
 #define BCH_SB_MEMBERS_MAX=09=0964
=20
 /*
- * Sentinal value - indicates a device that does not exist
+ * Sentinel value - indicates a device that does not exist
  */
 #define BCH_SB_MEMBER_INVALID=09=09255
=20
diff --git a/fs/bcachefs/snapshots/format.h b/fs/bcachefs/snapshots/format.=
h
index 72c28bd9c..a6e4fd33f 100644
--- a/fs/bcachefs/snapshots/format.h
+++ b/fs/bcachefs/snapshots/format.h
@@ -58,7 +58,7 @@ struct bch_snapshot {
  * something, key should be deleted)
  *
  * NO_KEYS: we don't remove interior snapshot nodes from snapshot trees at
- * runtime, since we can't do the adjustements for the depth/skiplist fiel=
d
+ * runtime, since we can't do the adjustments for the depth/skiplist field
  * atomically - and that breaks e.g. is_ancestor(). Instead, we mark it to=
 be
  * deleted at the next remount; this tells us that we don't need to run th=
e full
  * delete_dead_snapshots().
@@ -78,7 +78,7 @@ LE32_BITMASK(BCH_SNAPSHOT_NO_KEYS,=09struct bch_snapshot,=
 flags,  3,  4)
 /*
  * Snapshot trees:
  *
- * The snapshot_trees btree gives us persistent indentifier for each tree =
of
+ * The snapshot_trees btree gives us persistent identifier for each tree o=
f
  * bch_snapshot nodes, and allow us to record and easily find the root/mas=
ter
  * subvolume that other snapshots were created from:
  */
diff --git a/fs/bcachefs/util/eytzinger.h b/fs/bcachefs/util/eytzinger.h
index b14ae1ff7..43a66cab5 100644
--- a/fs/bcachefs/util/eytzinger.h
+++ b/fs/bcachefs/util/eytzinger.h
@@ -13,7 +13,7 @@
 #endif
=20
 /*
- * Traversal for trees in eytzinger layout - a full binary tree layed out =
in an
+ * Traversal for trees in eytzinger layout - a full binary tree laid out i=
n an
  * array.
  *
  * Consider using an eytzinger tree any time you would otherwise be doing =
binary
diff --git a/fs/bcachefs/util/mean_and_variance.h b/fs/bcachefs/util/mean_a=
nd_variance.h
index 47e4a3c3d..281d6f9d1 100644
--- a/fs/bcachefs/util/mean_and_variance.h
+++ b/fs/bcachefs/util/mean_and_variance.h
@@ -152,7 +152,7 @@ struct mean_and_variance {
 =09u128_u=09sum_squares;
 };
=20
-/* expontentially weighted variant */
+/* exponentially weighted variant */
 struct mean_and_variance_weighted {
 =09s64=09mean;
 =09u64=09variance;
@@ -200,4 +200,4 @@ u64 mean_and_variance_weighted_get_variance(struct mean=
_and_variance_weighted s,
 u32 mean_and_variance_weighted_get_stddev(struct mean_and_variance_weighte=
d s,
 =09=09u8 weight);
=20
-#endif // MEAN_AND_VAIRANCE_H_
+#endif // MEAN_AND_VARIANCE_H_
diff --git a/fs/bcachefs/util/mean_and_variance_test.c b/fs/bcachefs/util/m=
ean_and_variance_test.c
index e9d9c0212..86f38db11 100644
--- a/fs/bcachefs/util/mean_and_variance_test.c
+++ b/fs/bcachefs/util/mean_and_variance_test.c
@@ -25,7 +25,7 @@ static void mean_and_variance_basic_test(struct kunit *te=
st)
 }
=20
 /*
- * Test values computed using a spreadsheet from the psuedocode at the bot=
tom:
+ * Test values computed using a spreadsheet from the pseudocode at the bot=
tom:
  * https://fanf2.user.srcf.net/hermes/doc/antiforgery/stats.pdf
  */
=20
diff --git a/fs/bcachefs/util/printbuf.c b/fs/bcachefs/util/printbuf.c
index 0a6f44fd5..80e101915 100644
--- a/fs/bcachefs/util/printbuf.c
+++ b/fs/bcachefs/util/printbuf.c
@@ -417,7 +417,7 @@ void bch2_prt_tab_rjust(struct printbuf *buf)
  * @str:=09string to print
  * @count:=09number of bytes to print
  *
- * The following contol characters are handled as so:
+ * The following control characters are handled as so:
  *   \n: prt_newline=09newline that obeys current indent level
  *   \t: prt_tab=09advance to next tabstop
  *   \r: prt_tab_rjust=09advance to next tabstop, with right justification
diff --git a/fs/bcachefs/util/printbuf.h b/fs/bcachefs/util/printbuf.h
index 41e8d71d9..fe41736bd 100644
--- a/fs/bcachefs/util/printbuf.h
+++ b/fs/bcachefs/util/printbuf.h
@@ -25,7 +25,7 @@
  * everything to the kernel log buffer, and then those pretty-printers can=
 be
  * used by other code that outputs to kernel log, sysfs, debugfs, etc.
  *
- * Memory allocation: Outputing to a printbuf may allocate memory. This
+ * Memory allocation: Outputting to a printbuf may allocate memory. This
  * allocation is done with GFP_KERNEL, by default: use the newer
  * memalloc_*_(save|restore) functions as needed.
  *
@@ -56,7 +56,7 @@
  * next tabstop - right justifying it.
  *
  * Make sure you use prt_newline() instead of \n in the format string for =
indent
- * level and tabstops to work corretly.
+ * level and tabstops to work correctly.
  *
  * Output units: printbuf->units exists to tell pretty-printers how to out=
put
  * numbers: a raw value (e.g. directly from a superblock field), as bytes,=
 or as
diff --git a/fs/bcachefs/util/rcu_pending.c b/fs/bcachefs/util/rcu_pending.=
c
index 964ed493c..794f2d985 100644
--- a/fs/bcachefs/util/rcu_pending.c
+++ b/fs/bcachefs/util/rcu_pending.c
@@ -349,7 +349,7 @@ rcu_pending_enqueue_list(struct rcu_pending_pcpu *p, rc=
u_gp_poll_state_t seq,
 =09=09=09/*
 =09=09=09 * kvfree_rcu_mightsleep(): we weren't passed an
 =09=09=09 * rcu_head, but we need one: use the low bit of the
-=09=09=09 * ponter to free to flag that the head needs to be
+=09=09=09 * pointer to free to flag that the head needs to be
 =09=09=09 * freed as well:
 =09=09=09 */
 =09=09=09ptr =3D (void *)(((unsigned long) ptr)|1UL);
diff --git a/fs/bcachefs/util/siphash.h b/fs/bcachefs/util/siphash.h
index 3dfaf34a4..7744b4fe0 100644
--- a/fs/bcachefs/util/siphash.h
+++ b/fs/bcachefs/util/siphash.h
@@ -36,7 +36,7 @@
  * optimized for speed on short messages returning a 64bit hash/digest val=
ue.
  *
  * The number of rounds is defined during the initialization:
- *  SipHash24_Init() for the fast and resonable strong version
+ *  SipHash24_Init() for the fast and reasonably strong version
  *  SipHash48_Init() for the strong version (half as fast)
  *
  * struct SIPHASH_CTX ctx;
diff --git a/fs/bcachefs/util/six.c b/fs/bcachefs/util/six.c
index 08083d6ca..cdf7efb0c 100644
--- a/fs/bcachefs/util/six.c
+++ b/fs/bcachefs/util/six.c
@@ -111,7 +111,7 @@ static inline unsigned pcpu_read_count(struct six_lock =
*lock)
  * Returns 1 on success, 0 on failure
  *
  * In percpu reader mode, a failed trylock may cause a spurious trylock fa=
ilure
- * for anoter thread taking the competing lock type, and we may havve to d=
o a
+ * for another thread taking the competing lock type, and we may have to d=
o a
  * wakeup: when a wakeup is required, we return -1 - wakeup_type.
  */
 static int __do_six_trylock(struct six_lock *lock, enum six_lock_type type=
,
@@ -591,7 +591,7 @@ static void do_six_unlock_type(struct six_lock *lock, e=
num six_lock_type type)
  * @type:=09SIX_LOCK_read, SIX_LOCK_intent, or SIX_LOCK_write
  * @ip:=09=09ip parameter for lockdep/lockstat, i.e. _THIS_IP_
  *
- * When a lock is held multiple times (because six_lock_incement()) was us=
ed),
+ * When a lock is held multiple times (because six_lock_increment()) was u=
sed),
  * this decrements the 'lock held' counter by one.
  *
  * For example:
@@ -632,7 +632,7 @@ EXPORT_SYMBOL_GPL(six_unlock_ip);
=20
 /**
  * six_lock_downgrade - convert an intent lock to a read lock
- * @lock:=09lock to dowgrade
+ * @lock:=09lock to downgrade
  *
  * @lock will have read count incremented and intent count decremented
  */
diff --git a/fs/bcachefs/util/six.h b/fs/bcachefs/util/six.h
index 59b851cf8..2f55de935 100644
--- a/fs/bcachefs/util/six.h
+++ b/fs/bcachefs/util/six.h
@@ -79,7 +79,7 @@
  *     six_unlock_read(&foo->lock);
  *   foo->lock is now fully unlocked.
  *
- *   Since the intent state supercedes read, it's legal to increment the r=
ead
+ *   Since the intent state supersedes read, it's legal to increment the r=
ead
  *   counter when holding an intent lock, but not the reverse.
  *
  *   A lock may only be held once for write: six_lock_increment(.., SIX_LO=
CK_write)
@@ -298,7 +298,7 @@ void six_unlock_ip(struct six_lock *lock, enum six_lock=
_type type, unsigned long
  * @lock:=09lock to unlock
  * @type:=09SIX_LOCK_read, SIX_LOCK_intent, or SIX_LOCK_write
  *
- * When a lock is held multiple times (because six_lock_incement()) was us=
ed),
+ * When a lock is held multiple times (because six_lock_increment()) was u=
sed),
  * this decrements the 'lock held' counter by one.
  *
  * For example:
diff --git a/fs/bcachefs/util/time_stats.h b/fs/bcachefs/util/time_stats.h
index 7c7069673..37cf1a286 100644
--- a/fs/bcachefs/util/time_stats.h
+++ b/fs/bcachefs/util/time_stats.h
@@ -12,7 +12,7 @@
  *  - sum of all event durations
  *  - average event duration, standard and weighted
  *  - standard deviation of event durations, standard and weighted
- * and analagous statistics for the frequency of events
+ * and analogous statistics for the frequency of events
  *
  * We provide both mean and weighted mean (exponentially weighted), and st=
andard
  * deviation and weighted standard deviation, to give an efficient-to-comp=
ute
diff --git a/fs/bcachefs/util/util.c b/fs/bcachefs/util/util.c
index d538758b0..a444ec7cd 100644
--- a/fs/bcachefs/util/util.c
+++ b/fs/bcachefs/util/util.c
@@ -501,7 +501,7 @@ void bch2_ratelimit_increment(struct bch_ratelimit *d, =
u64 done)
 /* pd controller: */
=20
 /*
- * Updates pd_controller. Attempts to scale inputed values to units per se=
cond.
+ * Updates pd_controller. Attempts to scale inputted values to units per s=
econd.
  * @target: desired value
  * @actual: current value
  *
diff --git a/fs/bcachefs/vfs/io.c b/fs/bcachefs/vfs/io.c
index 8ea29763d..91d0922a1 100644
--- a/fs/bcachefs/vfs/io.c
+++ b/fs/bcachefs/vfs/io.c
@@ -945,7 +945,7 @@ loff_t bch2_remap_file_range(struct file *file_src, lof=
f_t pos_src,
 =09=09goto err;
=20
 =09/*
-=09 * due to alignment, we might have remapped slightly more than requsted
+=09 * due to alignment, we might have remapped slightly more than requeste=
d
 =09 */
 =09ret =3D min((u64) ret << 9, (u64) len);
=20
--=20
2.52.0



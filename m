Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AE3410A1F
	for <linux-bcachefs@vger.kernel.org>; Fri,  2 May 2025 20:00:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746216014; cv=none; b=du5N8XJCcYvUrtrejUL7sOP2aw1j4zVEyp881jUaxi1LB4qaV08cZbcy63mV481mlQsRdd4guGQB3OwZV4/VusqOtpgqwvnBCpUz0DYNWEP5PWqgCbhPI2j7R5PV7GJ9Loh3BpLylMDgomqvbE5l4YV+52KaOYBisuft+QV2Bi4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746216014; c=relaxed/simple;
	bh=COnXl7xNWOqiKKmxks1tCdAdXNnW+oUqmDfsZHJhInc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T8EbtGOW7Qc+fCtFKbeOAuBV3YCH1CjHL+eGAJ2je4WOG+vLnN37Pn/CRgzOB0mMQx0Qv6f85HpD8NpA+S832GR506vm0r+nVysbss3nrb6bjkt9s6tEJxoDlQTrtMM645C12T/lZ/Mkp80Sw3QMZXqLXxr/zVJurZCFIH5tg/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=TR7wSGmP; arc=none smtp.client-ip=91.218.175.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="TR7wSGmP"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1746216009;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vUabQjbK26Lzn1a14NK0+47lQ7wVHhLpV3brDitDze8=;
	b=TR7wSGmPQwL/LGYU/iIVLo5x2oixNy2bgdP1gAtGh5kcZ4tozlRwQgxIGmacbrn9K6zz0u
	xDGwXIkmYzqUc4PhKDq/IJkqBs8NDXzTroUAZqeyQ4b00UMS3mJeZlTQj/QtlBdNfUIj9X
	iC+mN87XpkIlPsuXJokhx9/FCxtr7kE=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 1/8] bcachefs: snapshot delete progress indicator
Date: Fri,  2 May 2025 15:59:53 -0400
Message-ID: <20250502200002.1309862-2-kent.overstreet@linux.dev>
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

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/bcachefs.h       |   3 +-
 fs/bcachefs/snapshot.c       | 132 ++++++++++++++++++++++-------------
 fs/bcachefs/snapshot.h       |   7 +-
 fs/bcachefs/snapshot_types.h |  25 +++++++
 fs/bcachefs/subvolume.c      |   2 -
 fs/bcachefs/subvolume.h      |   3 -
 fs/bcachefs/super.c          |   1 +
 fs/bcachefs/sysfs.c          |   5 ++
 8 files changed, 121 insertions(+), 57 deletions(-)
 create mode 100644 fs/bcachefs/snapshot_types.h

diff --git a/fs/bcachefs/bcachefs.h b/fs/bcachefs/bcachefs.h
index 0369dd656d32..cd35d1cf3fbb 100644
--- a/fs/bcachefs/bcachefs.h
+++ b/fs/bcachefs/bcachefs.h
@@ -216,6 +216,7 @@
 #include "recovery_passes_types.h"
 #include "sb-errors_types.h"
 #include "seqmutex.h"
+#include "snapshot_types.h"
 #include "time_stats.h"
 #include "util.h"
 
@@ -869,7 +870,7 @@ struct bch_fs {
 	struct mutex		snapshot_table_lock;
 	struct rw_semaphore	snapshot_create_lock;
 
-	struct work_struct	snapshot_delete_work;
+	struct snapshot_delete	snapshot_delete;
 	struct work_struct	snapshot_wait_for_pagecache_and_delete_work;
 	snapshot_id_list	snapshots_unlinked;
 	struct mutex		snapshots_unlinked_lock;
diff --git a/fs/bcachefs/snapshot.c b/fs/bcachefs/snapshot.c
index 94cf60f76b64..2f2f129ce482 100644
--- a/fs/bcachefs/snapshot.c
+++ b/fs/bcachefs/snapshot.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0
 
 #include "bcachefs.h"
+#include "bbpos.h"
 #include "bkey_buf.h"
 #include "btree_cache.h"
 #include "btree_key_cache.h"
@@ -1346,12 +1347,6 @@ int bch2_snapshot_node_create(struct btree_trans *trans, u32 parent,
  * that key to snapshot leaf nodes, where we can mutate it
  */
 
-struct snapshot_interior_delete {
-	u32	id;
-	u32	live_child;
-};
-typedef DARRAY(struct snapshot_interior_delete) interior_delete_list;
-
 static inline u32 interior_delete_has_id(interior_delete_list *l, u32 id)
 {
 	darray_for_each(*l, i)
@@ -1385,28 +1380,28 @@ static unsigned __live_child(struct snapshot_table *t, u32 id,
 	return 0;
 }
 
-static unsigned live_child(struct bch_fs *c, u32 id,
-			   snapshot_id_list *delete_leaves,
-			   interior_delete_list *delete_interior)
+static unsigned live_child(struct bch_fs *c, u32 id)
 {
+	struct snapshot_delete *d = &c->snapshot_delete;
+
 	rcu_read_lock();
 	u32 ret = __live_child(rcu_dereference(c->snapshots), id,
-			       delete_leaves, delete_interior);
+			       &d->delete_leaves, &d->delete_interior);
 	rcu_read_unlock();
 	return ret;
 }
 
 static int delete_dead_snapshots_process_key(struct btree_trans *trans,
 					     struct btree_iter *iter,
-					     struct bkey_s_c k,
-					     snapshot_id_list *delete_leaves,
-					     interior_delete_list *delete_interior)
+					     struct bkey_s_c k)
 {
-	if (snapshot_list_has_id(delete_leaves, k.k->p.snapshot))
+	struct snapshot_delete *d = &trans->c->snapshot_delete;
+
+	if (snapshot_list_has_id(&d->delete_leaves, k.k->p.snapshot))
 		return bch2_btree_delete_at(trans, iter,
 					    BTREE_UPDATE_internal_snapshot_node);
 
-	u32 live_child = interior_delete_has_id(delete_interior, k.k->p.snapshot);
+	u32 live_child = interior_delete_has_id(&d->delete_interior, k.k->p.snapshot);
 	if (live_child) {
 		struct bkey_i *new = bch2_bkey_make_mut_noupdate(trans, k);
 		int ret = PTR_ERR_OR_ZERO(new);
@@ -1442,14 +1437,13 @@ static int delete_dead_snapshots_process_key(struct btree_trans *trans,
  * it doesn't have child snapshot nodes - it's now redundant and we can mark it
  * as deleted.
  */
-static int check_should_delete_snapshot(struct btree_trans *trans, struct bkey_s_c k,
-					snapshot_id_list *delete_leaves,
-					interior_delete_list *delete_interior)
+static int check_should_delete_snapshot(struct btree_trans *trans, struct bkey_s_c k)
 {
 	if (k.k->type != KEY_TYPE_snapshot)
 		return 0;
 
 	struct bch_fs *c = trans->c;
+	struct snapshot_delete *d = &c->snapshot_delete;
 	struct bkey_s_c_snapshot s = bkey_s_c_to_snapshot(k);
 	unsigned live_children = 0;
 
@@ -1460,23 +1454,23 @@ static int check_should_delete_snapshot(struct btree_trans *trans, struct bkey_s
 		u32 child = le32_to_cpu(s.v->children[i]);
 
 		live_children += child &&
-			!snapshot_list_has_id(delete_leaves, child);
+			!snapshot_list_has_id(&d->delete_leaves, child);
 	}
 
 	if (live_children == 0) {
-		return snapshot_list_add(c, delete_leaves, s.k->p.offset);
+		return snapshot_list_add(c, &d->delete_leaves, s.k->p.offset);
 	} else if (live_children == 1) {
-		struct snapshot_interior_delete d = {
+		struct snapshot_interior_delete n = {
 			.id		= s.k->p.offset,
-			.live_child	= live_child(c, s.k->p.offset, delete_leaves, delete_interior),
+			.live_child	= live_child(c, s.k->p.offset),
 		};
 
-		if (!d.live_child) {
-			bch_err(c, "error finding live child of snapshot %u", d.id);
+		if (!n.live_child) {
+			bch_err(c, "error finding live child of snapshot %u", n.id);
 			return -EINVAL;
 		}
 
-		return darray_push(delete_interior, d);
+		return darray_push(&d->delete_interior, n);
 	} else {
 		return 0;
 	}
@@ -1555,39 +1549,48 @@ static int bch2_fix_child_of_deleted_snapshot(struct btree_trans *trans,
 	return bch2_trans_update(trans, iter, &s->k_i, 0);
 }
 
+static void bch2_snapshot_delete_nodes_to_text(struct printbuf *out, struct snapshot_delete *d)
+{
+	prt_printf(out, "deleting leaves");
+	darray_for_each(d->delete_leaves, i)
+		prt_printf(out, " %u", *i);
+
+	prt_printf(out, " interior");
+	darray_for_each(d->delete_interior, i)
+		prt_printf(out, " %u->%u", i->id, i->live_child);
+}
+
 int bch2_delete_dead_snapshots(struct bch_fs *c)
 {
 	if (!test_and_clear_bit(BCH_FS_need_delete_dead_snapshots, &c->flags))
 		return 0;
 
 	struct btree_trans *trans = bch2_trans_get(c);
-	snapshot_id_list delete_leaves = {};
-	interior_delete_list delete_interior = {};
+	struct snapshot_delete *d = &c->snapshot_delete;
 	int ret = 0;
 
 	/*
 	 * For every snapshot node: If we have no live children and it's not
 	 * pointed to by a subvolume, delete it:
 	 */
+	mutex_lock(&d->lock);
+	d->running = true;
+	d->pos = BBPOS_MIN;
+
 	ret = for_each_btree_key(trans, iter, BTREE_ID_snapshots, POS_MIN, 0, k,
-		check_should_delete_snapshot(trans, k, &delete_leaves, &delete_interior));
+		check_should_delete_snapshot(trans, k));
+	mutex_unlock(&d->lock);
 	if (!bch2_err_matches(ret, EROFS))
 		bch_err_msg(c, ret, "walking snapshots");
 	if (ret)
 		goto err;
 
-	if (!delete_leaves.nr && !delete_interior.nr)
+	if (!d->delete_leaves.nr && !d->delete_interior.nr)
 		goto err;
 
 	{
 		struct printbuf buf = PRINTBUF;
-		prt_printf(&buf, "deleting leaves");
-		darray_for_each(delete_leaves, i)
-			prt_printf(&buf, " %u", *i);
-
-		prt_printf(&buf, " interior");
-		darray_for_each(delete_interior, i)
-			prt_printf(&buf, " %u->%u", i->id, i->live_child);
+		bch2_snapshot_delete_nodes_to_text(&buf, d);
 
 		ret = commit_do(trans, NULL, NULL, 0, bch2_trans_log_msg(trans, &buf));
 		printbuf_exit(&buf);
@@ -1595,19 +1598,21 @@ int bch2_delete_dead_snapshots(struct bch_fs *c)
 			goto err;
 	}
 
-	for (unsigned btree = 0; btree < BTREE_ID_NR; btree++) {
+	for (d->pos.btree = 0; d->pos.btree < BTREE_ID_NR; d->pos.btree++) {
 		struct disk_reservation res = { 0 };
 
-		if (!btree_type_has_snapshots(btree))
+		d->pos.pos = POS_MIN;
+
+		if (!btree_type_has_snapshots(d->pos.btree))
 			continue;
 
 		ret = for_each_btree_key_commit(trans, iter,
-				btree, POS_MIN,
+				d->pos.btree, POS_MIN,
 				BTREE_ITER_prefetch|BTREE_ITER_all_snapshots, k,
-				&res, NULL, BCH_TRANS_COMMIT_no_enospc,
-			delete_dead_snapshots_process_key(trans, &iter, k,
-							  &delete_leaves,
-							  &delete_interior));
+				&res, NULL, BCH_TRANS_COMMIT_no_enospc, ({
+			d->pos.pos = iter.pos;
+			delete_dead_snapshots_process_key(trans, &iter, k);
+		}));
 
 		bch2_disk_reservation_put(c, &res);
 
@@ -1617,7 +1622,7 @@ int bch2_delete_dead_snapshots(struct bch_fs *c)
 			goto err;
 	}
 
-	darray_for_each(delete_leaves, i) {
+	darray_for_each(d->delete_leaves, i) {
 		ret = commit_do(trans, NULL, NULL, 0,
 			bch2_snapshot_node_delete(trans, *i));
 		if (!bch2_err_matches(ret, EROFS))
@@ -1634,11 +1639,11 @@ int bch2_delete_dead_snapshots(struct bch_fs *c)
 	ret = for_each_btree_key_commit(trans, iter, BTREE_ID_snapshots, POS_MIN,
 				  BTREE_ITER_intent, k,
 				  NULL, NULL, BCH_TRANS_COMMIT_no_enospc,
-		bch2_fix_child_of_deleted_snapshot(trans, &iter, k, &delete_interior));
+		bch2_fix_child_of_deleted_snapshot(trans, &iter, k, &d->delete_interior));
 	if (ret)
 		goto err;
 
-	darray_for_each(delete_interior, i) {
+	darray_for_each(d->delete_interior, i) {
 		ret = commit_do(trans, NULL, NULL, 0,
 			bch2_snapshot_node_delete(trans, i->id));
 		if (!bch2_err_matches(ret, EROFS))
@@ -1647,8 +1652,11 @@ int bch2_delete_dead_snapshots(struct bch_fs *c)
 			goto err;
 	}
 err:
-	darray_exit(&delete_interior);
-	darray_exit(&delete_leaves);
+	mutex_lock(&d->lock);
+	darray_exit(&d->delete_interior);
+	darray_exit(&d->delete_leaves);
+	d->running = false;
+	mutex_unlock(&d->lock);
 	bch2_trans_put(trans);
 	if (!bch2_err_matches(ret, EROFS))
 		bch_err_fn(c, ret);
@@ -1657,7 +1665,7 @@ int bch2_delete_dead_snapshots(struct bch_fs *c)
 
 void bch2_delete_dead_snapshots_work(struct work_struct *work)
 {
-	struct bch_fs *c = container_of(work, struct bch_fs, snapshot_delete_work);
+	struct bch_fs *c = container_of(work, struct bch_fs, snapshot_delete.work);
 
 	set_worker_desc("bcachefs-delete-dead-snapshots/%s", c->name);
 
@@ -1672,10 +1680,27 @@ void bch2_delete_dead_snapshots_async(struct bch_fs *c)
 
 	BUG_ON(!test_bit(BCH_FS_may_go_rw, &c->flags));
 
-	if (!queue_work(c->write_ref_wq, &c->snapshot_delete_work))
+	if (!queue_work(c->write_ref_wq, &c->snapshot_delete.work))
 		enumerated_ref_put(&c->writes, BCH_WRITE_REF_delete_dead_snapshots);
 }
 
+void bch2_snapshot_delete_status_to_text(struct printbuf *out, struct bch_fs *c)
+{
+	struct snapshot_delete *d = &c->snapshot_delete;
+
+	if (!d->running) {
+		prt_str(out, "(not running)");
+		return;
+	}
+
+	mutex_lock(&d->lock);
+	bch2_snapshot_delete_nodes_to_text(out, d);
+	prt_newline(out);
+	mutex_unlock(&d->lock);
+
+	bch2_bbpos_to_text(out, d->pos);
+}
+
 int __bch2_key_has_snapshot_overwrites(struct btree_trans *trans,
 				       enum btree_id id,
 				       struct bpos pos)
@@ -1750,3 +1775,10 @@ void bch2_fs_snapshots_exit(struct bch_fs *c)
 {
 	kvfree(rcu_dereference_protected(c->snapshots, true));
 }
+
+void bch2_fs_snapshots_init_early(struct bch_fs *c)
+{
+	INIT_WORK(&c->snapshot_delete.work, bch2_delete_dead_snapshots_work);
+	mutex_init(&c->snapshot_delete.lock);
+	mutex_init(&c->snapshots_unlinked_lock);
+}
diff --git a/fs/bcachefs/snapshot.h b/fs/bcachefs/snapshot.h
index 81180181d7c9..24a451bb7024 100644
--- a/fs/bcachefs/snapshot.h
+++ b/fs/bcachefs/snapshot.h
@@ -244,7 +244,6 @@ int bch2_reconstruct_snapshots(struct bch_fs *);
 int bch2_check_key_has_snapshot(struct btree_trans *, struct btree_iter *, struct bkey_s_c);
 
 int bch2_snapshot_node_set_deleted(struct btree_trans *, u32);
-void bch2_delete_dead_snapshots_work(struct work_struct *);
 
 int __bch2_key_has_snapshot_overwrites(struct btree_trans *, enum btree_id, struct bpos);
 
@@ -259,7 +258,13 @@ static inline int bch2_key_has_snapshot_overwrites(struct btree_trans *trans,
 	return __bch2_key_has_snapshot_overwrites(trans, id, pos);
 }
 
+int bch2_delete_dead_snapshots(struct bch_fs *);
+void bch2_delete_dead_snapshots_work(struct work_struct *);
+void bch2_delete_dead_snapshots_async(struct bch_fs *);
+void bch2_snapshot_delete_status_to_text(struct printbuf *, struct bch_fs *);
+
 int bch2_snapshots_read(struct bch_fs *);
 void bch2_fs_snapshots_exit(struct bch_fs *);
+void bch2_fs_snapshots_init_early(struct bch_fs *);
 
 #endif /* _BCACHEFS_SNAPSHOT_H */
diff --git a/fs/bcachefs/snapshot_types.h b/fs/bcachefs/snapshot_types.h
new file mode 100644
index 000000000000..bb67a6beb6e3
--- /dev/null
+++ b/fs/bcachefs/snapshot_types.h
@@ -0,0 +1,25 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _BCACHEFS_SNAPSHOT_TYPES_H
+#define _BCACHEFS_SNAPSHOT_TYPES_H
+
+#include "bbpos_types.h"
+#include "subvolume_types.h"
+
+struct snapshot_interior_delete {
+	u32	id;
+	u32	live_child;
+};
+typedef DARRAY(struct snapshot_interior_delete) interior_delete_list;
+
+struct snapshot_delete {
+	struct work_struct	work;
+
+	struct mutex		lock;
+	snapshot_id_list	delete_leaves;
+	interior_delete_list	delete_interior;
+
+	bool			running;
+	struct bbpos		pos;
+};
+
+#endif /* _BCACHEFS_SNAPSHOT_TYPES_H */
diff --git a/fs/bcachefs/subvolume.c b/fs/bcachefs/subvolume.c
index 51ab2ee10706..3c6ba1469de2 100644
--- a/fs/bcachefs/subvolume.c
+++ b/fs/bcachefs/subvolume.c
@@ -730,8 +730,6 @@ int bch2_fs_upgrade_for_subvolumes(struct bch_fs *c)
 
 void bch2_fs_subvolumes_init_early(struct bch_fs *c)
 {
-	INIT_WORK(&c->snapshot_delete_work, bch2_delete_dead_snapshots_work);
 	INIT_WORK(&c->snapshot_wait_for_pagecache_and_delete_work,
 		  bch2_subvolume_wait_for_pagecache_and_delete);
-	mutex_init(&c->snapshots_unlinked_lock);
 }
diff --git a/fs/bcachefs/subvolume.h b/fs/bcachefs/subvolume.h
index ee5e4e5a0fc8..075f55e25c70 100644
--- a/fs/bcachefs/subvolume.h
+++ b/fs/bcachefs/subvolume.h
@@ -77,9 +77,6 @@ bch2_btree_iter_peek_in_subvolume_max_type(struct btree_trans *trans, struct btr
 					_end, _subvolid, _flags, _k, _do);	\
 })
 
-int bch2_delete_dead_snapshots(struct bch_fs *);
-void bch2_delete_dead_snapshots_async(struct bch_fs *);
-
 int bch2_subvolume_unlink(struct btree_trans *, u32);
 int bch2_subvolume_create(struct btree_trans *, u64, u32, u32, u32 *, u32 *, bool);
 
diff --git a/fs/bcachefs/super.c b/fs/bcachefs/super.c
index 03efda996348..9626468600af 100644
--- a/fs/bcachefs/super.c
+++ b/fs/bcachefs/super.c
@@ -864,6 +864,7 @@ static struct bch_fs *bch2_fs_alloc(struct bch_sb *sb, struct bch_opts *opts,
 	bch2_fs_quota_init(c);
 	bch2_fs_rebalance_init(c);
 	bch2_fs_sb_errors_init_early(c);
+	bch2_fs_snapshots_init_early(c);
 	bch2_fs_subvolumes_init_early(c);
 
 	INIT_LIST_HEAD(&c->list);
diff --git a/fs/bcachefs/sysfs.c b/fs/bcachefs/sysfs.c
index 1d0c0f24a7b9..adf99a805a62 100644
--- a/fs/bcachefs/sysfs.c
+++ b/fs/bcachefs/sysfs.c
@@ -198,6 +198,7 @@ read_attribute(copy_gc_wait);
 
 sysfs_pd_controller_attribute(rebalance);
 read_attribute(rebalance_status);
+read_attribute(snapshot_delete_status);
 
 read_attribute(new_stripes);
 
@@ -320,6 +321,9 @@ SHOW(bch2_fs)
 	if (attr == &sysfs_rebalance_status)
 		bch2_rebalance_status_to_text(out, c);
 
+	if (attr == &sysfs_snapshot_delete_status)
+		bch2_snapshot_delete_status_to_text(out, c);
+
 	/* Debugging: */
 
 	if (attr == &sysfs_journal_debug)
@@ -466,6 +470,7 @@ struct attribute *bch2_fs_files[] = {
 	&sysfs_btree_write_stats,
 
 	&sysfs_rebalance_status,
+	&sysfs_snapshot_delete_status,
 
 	&sysfs_compression_stats,
 
-- 
2.49.0


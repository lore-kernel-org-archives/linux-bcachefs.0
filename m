Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E85622D97A1
	for <linux-bcachefs@vger.kernel.org>; Sun, 24 Aug 2025 12:38:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756039103; cv=none; b=XUx7nVZRdUOW+hCSzs9+YOIA4anS13EnMbLfFGSzVAL+pLPMEjegEyTTOIPGLm13XmsR+V9LEna1KXVsFrbgyG9295DG8zJKl+m10WnC0jottmYg0fahwYOXadRiB3V5ptZLUP+qczDCWsgIh0yYkI7noGaYtL0SMlG4Ht0L7jk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756039103; c=relaxed/simple;
	bh=9m+G12wjRmhhTekO1DwJINv/Mlrvh1Vi6r64hjFK8Gc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FpjNAVdbyqYA3dy7m0Uq6nhAlBI702wMYA5ce8XOowWicc65+GFjDdINNgwNIWtx0k0B/hXghmlecNcgjTQM+c7irKvPaKmFoObIn4vjAyDy2W80dIIAyNh0xNxXmmucp0rquo+ScVsMvM1oeledTcXKjESuk2we8zMfVkpx0Ew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=AFwHBwKi; arc=none smtp.client-ip=91.218.175.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="AFwHBwKi"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1756039099;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wTtONEbiontL6ITC6N0wSeZN+9o5g4C31o4TeEseVuU=;
	b=AFwHBwKi9rtzD7/yDCSedB8Iy+kP39tiBRvegiWdJ5BmjDzqeFB7ivEbRzlXlFXYqctimL
	EsdJEa22oMIo7fQZJ+G8IYXOun1eVKDZb0SAq+T/J/rk6Zt8LEJ4uS9Yew30xFSSWeVwPn
	S9G12+IX7jTg6oLjqyJ41o1Iw+kionQ=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 18/21] bcachefs: bch2_set_rebalance_needs_scan_device()
Date: Sun, 24 Aug 2025 08:37:55 -0400
Message-ID: <20250824123800.1617669-19-kent.overstreet@linux.dev>
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

Rebalance can now evacuate devices in response to state changes.

This obsoletes BCH_DATA_OP_migrate; setting a device to
BCH_MEMBER_STATE_failed (perhaps we should rename this) will cause it to
be evacuated (and the evacuate will resume if e.g. we crash or shutdown
and restart).

Additionally, we'll now be able to automatically evacuate failing
devices. Currently we only set devices read-only in response to IO
errors; we'll need to add configuration/policy/good heuristics (and
clearly document them) for deciding when a device is failing and should
be evacuated.

This works with rebalance scan cookies; these are currently used to
respond to filesystem/inode option changes. Cookies in the range of
1-4095 now refer to devices; when rebalance sees one of those it will
walk backpointers on that device and update bch_extent_rebalance, which
will react to the new device state (or durability setting change).

Performance implications: with BCH_DATA_OP_migrate, we walk backpointers
and do the data moves directly, meaning they happen in device LBA order.

However, by walking backpointers to queue up rebalance work entries and
then doing the work from the rebalance_work btree, we'll do the data
moves in logical key order.

Pro: doing data moves in logical key order will help with
fragmentation/data locality: extents from the same inode will be moved
at the same time, we'll get a bit of defragmentation and do better at
keeping related data together

Con: reads from the device being evacuated will no longer be sequential,
this will hurt performance on spinning rust.

Perhaps add a mode where we kick off data moves from
do_rebalance_scan_bp()? Would be pretty easy

XXX: slurp backpointers into a darray and sort before processing extents
in do_rebalance_scan_device: we recently saw a very slow evacuate that
was mostly just dropping cached data, on a huge filesystem entirely on
spinning rust with only 8GB of ram in the server - the backpointers ->
extents lookups are fairly random, batching + sorting will greatly
improve performance

XXX: add a superblock bit to make this transactional, if we crash
between the write_super for the member state/durability change and
creating the device scan cookie

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/rebalance.c | 77 +++++++++++++++++++++++++++++++++++++++--
 fs/bcachefs/rebalance.h |  1 +
 fs/bcachefs/super.c     |  4 +++
 fs/bcachefs/sysfs.c     |  4 +++
 4 files changed, 83 insertions(+), 3 deletions(-)

diff --git a/fs/bcachefs/rebalance.c b/fs/bcachefs/rebalance.c
index 3a6cd54613a1..7ebd1c982810 100644
--- a/fs/bcachefs/rebalance.c
+++ b/fs/bcachefs/rebalance.c
@@ -3,6 +3,7 @@
 #include "bcachefs.h"
 #include "alloc_background.h"
 #include "alloc_foreground.h"
+#include "backpointers.h"
 #include "btree_iter.h"
 #include "btree_update.h"
 #include "btree_write_buffer.h"
@@ -480,6 +481,11 @@ int bch2_set_rebalance_needs_scan(struct bch_fs *c, u64 inum)
 	return ret;
 }
 
+int bch2_set_rebalance_needs_scan_device(struct bch_fs *c, unsigned dev)
+{
+	return bch2_set_rebalance_needs_scan(c, dev + 1);
+}
+
 int bch2_set_fs_needs_rebalance(struct bch_fs *c)
 {
 	return bch2_set_rebalance_needs_scan(c, 0);
@@ -687,6 +693,65 @@ static int do_rebalance_extent(struct moving_context *ctxt,
 	return ret;
 }
 
+static int do_rebalance_scan_bp(struct btree_trans *trans,
+				struct bkey_s_c_backpointer bp,
+				struct bkey_buf *last_flushed)
+{
+	struct btree_iter iter;
+	struct bkey_s_c k = bch2_backpointer_get_key(trans, bp, &iter, 0, last_flushed);
+	int ret = bkey_err(k);
+	if (ret)
+		return ret;
+
+	struct bch_inode_opts io_opts;
+	ret = bch2_extent_get_io_opts_one(trans, &io_opts, &iter, k,
+					  SET_NEEDS_REBALANCE_opt_change);
+	bch2_trans_iter_exit(&iter);
+	return ret;
+}
+
+static int do_rebalance_scan_device(struct moving_context *ctxt,
+				    unsigned dev, u64 cookie,
+				    u64 *sectors_scanned)
+{
+	struct btree_trans *trans = ctxt->trans;
+	struct bch_fs *c = trans->c;
+	struct bch_fs_rebalance *r = &c->rebalance;
+
+	struct bkey_buf last_flushed;
+	bch2_bkey_buf_init(&last_flushed);
+	bkey_init(&last_flushed.k->k);
+
+	bch2_btree_write_buffer_flush_sync(trans);
+
+	int ret = for_each_btree_key_max(trans, iter, BTREE_ID_backpointers,
+					 POS(dev, 0), POS(dev, U64_MAX),
+					 BTREE_ITER_prefetch, k, ({
+		ctxt->stats->pos = BBPOS(iter.btree_id, iter.pos);
+
+		if (k.k->type != KEY_TYPE_backpointer)
+			continue;
+
+		do_rebalance_scan_bp(trans, bkey_s_c_to_backpointer(k), &last_flushed);
+	})) ?:
+	commit_do(trans, NULL, NULL, BCH_TRANS_COMMIT_no_enospc,
+		  bch2_clear_rebalance_needs_scan(trans, dev + 1, cookie));
+
+	*sectors_scanned += atomic64_read(&r->scan_stats.sectors_seen);
+	/*
+	 * Ensure that the rebalance_work entries we created are seen by the
+	 * next iteration of do_rebalance(), so we don't end up stuck in
+	 * rebalance_wait():
+	 */
+	*sectors_scanned += 1;
+	bch2_move_stats_exit(&r->scan_stats, c);
+
+	bch2_btree_write_buffer_flush_sync(trans);
+
+	bch2_bkey_buf_exit(&last_flushed, c);
+	return ret;
+}
+
 static int do_rebalance_scan_indirect(struct btree_trans *trans,
 				      struct bkey_s_c_reflink_p p,
 				      struct per_snapshot_io_opts *snapshot_io_opts,
@@ -722,15 +787,21 @@ static int do_rebalance_scan(struct moving_context *ctxt,
 	bch2_move_stats_init(&r->scan_stats, "rebalance_scan");
 	ctxt->stats = &r->scan_stats;
 
+	r->state = BCH_REBALANCE_scanning;
+
 	if (!inum) {
 		r->scan_start	= BBPOS_MIN;
 		r->scan_end	= BBPOS_MAX;
-	} else {
+	} else if (inum >= BCACHEFS_ROOT_INO) {
 		r->scan_start	= BBPOS(BTREE_ID_extents, POS(inum, 0));
 		r->scan_end	= BBPOS(BTREE_ID_extents, POS(inum, U64_MAX));
-	}
+	} else {
+		unsigned dev = inum - 1;
+		r->scan_start	= BBPOS(BTREE_ID_backpointers, POS(dev, 0));
+		r->scan_end	= BBPOS(BTREE_ID_backpointers, POS(dev, U64_MAX));
 
-	r->state = BCH_REBALANCE_scanning;
+		return do_rebalance_scan_device(ctxt, inum - 1, cookie, sectors_scanned);
+	}
 
 	int ret = for_each_btree_key_max(trans, iter, BTREE_ID_extents,
 					 r->scan_start.pos, r->scan_end.pos,
diff --git a/fs/bcachefs/rebalance.h b/fs/bcachefs/rebalance.h
index dde7e4cb9533..f6b74d5e1210 100644
--- a/fs/bcachefs/rebalance.h
+++ b/fs/bcachefs/rebalance.h
@@ -76,6 +76,7 @@ int bch2_extent_get_io_opts_one(struct btree_trans *, struct bch_inode_opts *,
 
 int bch2_set_rebalance_needs_scan_trans(struct btree_trans *, u64);
 int bch2_set_rebalance_needs_scan(struct bch_fs *, u64 inum);
+int bch2_set_rebalance_needs_scan_device(struct bch_fs *, unsigned);
 int bch2_set_fs_needs_rebalance(struct bch_fs *);
 
 static inline void bch2_rebalance_wakeup(struct bch_fs *c)
diff --git a/fs/bcachefs/super.c b/fs/bcachefs/super.c
index 793c16fa8b09..b8746a3dd782 100644
--- a/fs/bcachefs/super.c
+++ b/fs/bcachefs/super.c
@@ -1952,6 +1952,10 @@ int __bch2_dev_set_state(struct bch_fs *c, struct bch_dev *ca,
 	if (new_state == BCH_MEMBER_STATE_rw)
 		__bch2_dev_read_write(c, ca);
 
+	/* XXX: add a superblock bit to make this transactional */
+	if (new_state == BCH_MEMBER_STATE_failed)
+		bch2_set_rebalance_needs_scan_device(c, ca->dev_idx);
+
 	bch2_rebalance_wakeup(c);
 
 	return ret;
diff --git a/fs/bcachefs/sysfs.c b/fs/bcachefs/sysfs.c
index bd3fa9c3372d..62ad13b34364 100644
--- a/fs/bcachefs/sysfs.c
+++ b/fs/bcachefs/sysfs.c
@@ -807,6 +807,10 @@ static ssize_t sysfs_opt_store(struct bch_fs *c,
 	if (!ca)
 		bch2_opt_set_by_id(&c->opts, id, v);
 
+	/* XXX: add a superblock bit to make this transactional */
+	if (id == Opt_durability)
+		bch2_set_rebalance_needs_scan_device(c, ca->dev_idx);
+
 	if (changed)
 		bch2_opt_hook_post_set(c, ca, 0, &c->opts, id);
 
-- 
2.50.1


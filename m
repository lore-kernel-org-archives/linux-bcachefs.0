Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7204E212FB6
	for <linux-bcachefs@vger.kernel.org>; Sat, 17 May 2025 19:25:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747509960; cv=none; b=qYUXqvexeVNhtDCexHjX+dCqR9Vlz2KbyEMqhrsLCHEG4dy9pNqRFctRv1Nbmgf/0R7KMNPlRMh5DFxJ+vxEhL+E5FIpjnKz+zhB2XbXDzrFyCi+XhYBiQhbI2kLpjYI06zHWrMR4KdzeWAZaGYfRfE+AIbiTrApjGUrDCvwSMU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747509960; c=relaxed/simple;
	bh=SWHA1yNyRlqwuK76pGS0/lV43AJenUQE0G/nGNd4X20=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tz2+9ZNkaKggtTWPAajnvCh1JHZVsk26kVd5movS2wWUWGhu5oVSxfocger9nwUI/y+mQ0AujWR9PVzUfCjEilLwVziP0elpQCK5qzWjIMCJBIv6AV4Sv2GrBc4YeFhExLfVBXJ8YgMhX3xYLnPX2JUF3KkN/TV/a1I1P8rsEgE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=fUQJKSIy; arc=none smtp.client-ip=95.215.58.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="fUQJKSIy"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1747509956;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1BuM7JSZYlRCY5bMmxjadgriJ3LS2HqP27SNvCvZHp0=;
	b=fUQJKSIy+pjKbMT5brdgjQ6383MjNUD047K24dEsKrkWWpAQfd6xT7KjotX19GrKAgvdxg
	Or4Ezde9GiKCdP/EMW6jGVh47pVK0ZWcwJ+E1az0oesVYBDIhO6o1JmiIMA5I5Bdi9ki1x
	GftWSGt1en9uNxgk0hR4aAaGQ7hD6so=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 3/8] bcachefs: Reduce usage of recovery.curr_pass
Date: Sat, 17 May 2025 15:25:40 -0400
Message-ID: <20250517192547.3849149-4-kent.overstreet@linux.dev>
In-Reply-To: <20250517192547.3849149-1-kent.overstreet@linux.dev>
References: <20250517192547.3849149-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

We want recovery.curr_pass to be private to the recovery passes code,
for better showing recovery pass status; also, it may rewind and is
generally not the correct member to use.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/alloc_background.c      | 3 ++-
 fs/bcachefs/alloc_foreground.c      | 6 +++---
 fs/bcachefs/backpointers.c          | 7 ++++---
 fs/bcachefs/btree_cache.c           | 2 +-
 fs/bcachefs/btree_io.c              | 3 +--
 fs/bcachefs/btree_update_interior.c | 2 +-
 fs/bcachefs/fsck.c                  | 1 -
 fs/bcachefs/snapshot.c              | 2 +-
 8 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/fs/bcachefs/alloc_background.c b/fs/bcachefs/alloc_background.c
index 4ae2aa6ea758..88e710ba2685 100644
--- a/fs/bcachefs/alloc_background.c
+++ b/fs/bcachefs/alloc_background.c
@@ -309,7 +309,8 @@ int bch2_alloc_v4_validate(struct bch_fs *c, struct bkey_s_c k,
 				 "data type inconsistency");
 
 		bkey_fsck_err_on(!a.io_time[READ] &&
-				 c->recovery.curr_pass > BCH_RECOVERY_PASS_check_alloc_to_lru_refs,
+				 !(c->recovery.passes_to_run &
+				   BIT_ULL(BCH_RECOVERY_PASS_check_alloc_to_lru_refs)),
 				 c, alloc_key_cached_but_read_time_zero,
 				 "cached bucket with read_time == 0");
 		break;
diff --git a/fs/bcachefs/alloc_foreground.c b/fs/bcachefs/alloc_foreground.c
index 76641cc4c27d..1a52c12c51ae 100644
--- a/fs/bcachefs/alloc_foreground.c
+++ b/fs/bcachefs/alloc_foreground.c
@@ -154,7 +154,7 @@ static struct open_bucket *bch2_open_bucket_alloc(struct bch_fs *c)
 
 static inline bool is_superblock_bucket(struct bch_fs *c, struct bch_dev *ca, u64 b)
 {
-	if (c->recovery.curr_pass > BCH_RECOVERY_PASS_trans_mark_dev_sbs)
+	if (c->recovery.passes_complete & BIT_ULL(BCH_RECOVERY_PASS_trans_mark_dev_sbs))
 		return false;
 
 	return bch2_is_superblock_bucket(ca, b);
@@ -524,7 +524,7 @@ static struct open_bucket *bch2_bucket_alloc_trans(struct btree_trans *trans,
 
 	if (!avail) {
 		if (req->watermark > BCH_WATERMARK_normal &&
-		    c->recovery.curr_pass <= BCH_RECOVERY_PASS_check_allocations)
+		    c->recovery.pass_done < BCH_RECOVERY_PASS_check_allocations)
 			goto alloc;
 
 		if (cl && !waiting) {
@@ -554,7 +554,7 @@ static struct open_bucket *bch2_bucket_alloc_trans(struct btree_trans *trans,
 		goto alloc;
 	}
 
-	if (!ob && freespace && c->recovery.curr_pass <= BCH_RECOVERY_PASS_check_alloc_info) {
+	if (!ob && freespace && c->recovery.pass_done < BCH_RECOVERY_PASS_check_alloc_info) {
 		freespace = false;
 		goto alloc;
 	}
diff --git a/fs/bcachefs/backpointers.c b/fs/bcachefs/backpointers.c
index 44da8e2657af..d9ddfc4b5dcc 100644
--- a/fs/bcachefs/backpointers.c
+++ b/fs/bcachefs/backpointers.c
@@ -104,6 +104,8 @@ static noinline int backpointer_mod_err(struct btree_trans *trans,
 {
 	struct bch_fs *c = trans->c;
 	struct printbuf buf = PRINTBUF;
+	bool will_check = c->recovery.passes_to_run &
+		BIT_ULL(BCH_RECOVERY_PASS_check_extents_to_backpointers);
 	int ret = 0;
 
 	if (insert) {
@@ -120,7 +122,7 @@ static noinline int backpointer_mod_err(struct btree_trans *trans,
 		bch2_bkey_val_to_text(&buf, c, orig_k);
 
 		bch_err(c, "%s", buf.buf);
-	} else if (c->recovery.curr_pass > BCH_RECOVERY_PASS_check_extents_to_backpointers) {
+	} else if (!will_check) {
 		prt_printf(&buf, "backpointer not found when deleting\n");
 		printbuf_indent_add(&buf, 2);
 
@@ -136,8 +138,7 @@ static noinline int backpointer_mod_err(struct btree_trans *trans,
 		bch2_bkey_val_to_text(&buf, c, orig_k);
 	}
 
-	if (c->recovery.curr_pass > BCH_RECOVERY_PASS_check_extents_to_backpointers &&
-	    __bch2_inconsistent_error(c, &buf))
+	if (!will_check && __bch2_inconsistent_error(c, &buf))
 		ret = -BCH_ERR_erofs_unfixed_errors;
 
 	bch_err(c, "%s", buf.buf);
diff --git a/fs/bcachefs/btree_cache.c b/fs/bcachefs/btree_cache.c
index 2600a97582b1..a5d983309311 100644
--- a/fs/bcachefs/btree_cache.c
+++ b/fs/bcachefs/btree_cache.c
@@ -1019,7 +1019,7 @@ static noinline void btree_bad_header(struct bch_fs *c, struct btree *b)
 {
 	struct printbuf buf = PRINTBUF;
 
-	if (c->recovery.curr_pass <= BCH_RECOVERY_PASS_check_allocations)
+	if (c->recovery.pass_done < BCH_RECOVERY_PASS_check_allocations)
 		return;
 
 	prt_printf(&buf,
diff --git a/fs/bcachefs/btree_io.c b/fs/bcachefs/btree_io.c
index e5db374f001b..34018296053a 100644
--- a/fs/bcachefs/btree_io.c
+++ b/fs/bcachefs/btree_io.c
@@ -1775,8 +1775,7 @@ void bch2_btree_node_read(struct btree_trans *trans, struct btree *b,
 		prt_newline(&buf);
 		bch2_btree_lost_data(c, &buf, b->c.btree_id);
 
-		if (c->opts.recovery_passes & BIT_ULL(BCH_RECOVERY_PASS_check_topology) &&
-		    c->recovery.curr_pass > BCH_RECOVERY_PASS_check_topology &&
+		if (c->recovery.passes_complete & BIT_ULL(BCH_RECOVERY_PASS_check_topology) &&
 		    bch2_fs_emergency_read_only2(c, &buf))
 			ratelimit = false;
 
diff --git a/fs/bcachefs/btree_update_interior.c b/fs/bcachefs/btree_update_interior.c
index a658c97439ed..74e65714fecd 100644
--- a/fs/bcachefs/btree_update_interior.c
+++ b/fs/bcachefs/btree_update_interior.c
@@ -2363,7 +2363,7 @@ void bch2_btree_node_rewrite_async(struct bch_fs *c, struct btree *b)
 	bool now = false, pending = false;
 
 	spin_lock(&c->btree_node_rewrites_lock);
-	if (c->recovery.curr_pass > BCH_RECOVERY_PASS_journal_replay &&
+	if (c->recovery.passes_complete & BIT_ULL(BCH_RECOVERY_PASS_journal_replay) &&
 	    enumerated_ref_tryget(&c->writes, BCH_WRITE_REF_node_rewrite)) {
 		list_add(&a->list, &c->btree_node_rewrites);
 		now = true;
diff --git a/fs/bcachefs/fsck.c b/fs/bcachefs/fsck.c
index 0909716900f9..44997bdef95f 100644
--- a/fs/bcachefs/fsck.c
+++ b/fs/bcachefs/fsck.c
@@ -3140,7 +3140,6 @@ static int bch2_fsck_online_thread_fn(struct thread_with_stdio *stdio)
 	c->opts.fsck = true;
 	set_bit(BCH_FS_in_fsck, &c->flags);
 
-	c->recovery.curr_pass = BCH_RECOVERY_PASS_check_alloc_info;
 	int ret = bch2_run_online_recovery_passes(c, ~0ULL);
 
 	clear_bit(BCH_FS_in_fsck, &c->flags);
diff --git a/fs/bcachefs/snapshot.c b/fs/bcachefs/snapshot.c
index c401d5285701..24903e7de296 100644
--- a/fs/bcachefs/snapshot.c
+++ b/fs/bcachefs/snapshot.c
@@ -348,7 +348,7 @@ static int __bch2_mark_snapshot(struct btree_trans *trans,
 
 		if (BCH_SNAPSHOT_WILL_DELETE(s.v)) {
 			set_bit(BCH_FS_need_delete_dead_snapshots, &c->flags);
-			if (c->recovery.curr_pass > BCH_RECOVERY_PASS_delete_dead_snapshots)
+			if (c->recovery.pass_done > BCH_RECOVERY_PASS_delete_dead_snapshots)
 				bch2_delete_dead_snapshots_async(c);
 		}
 	} else {
-- 
2.49.0


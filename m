Received: from out-175.mta1.migadu.com (out-175.mta1.migadu.com [95.215.58.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC23417B4E2
	for <linux-bcachefs@vger.kernel.org>; Mon,  4 Nov 2024 07:12:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730704326; cv=none; b=cW7tCdSC/MGRI+kKtvmyrXaReR9dIfNRedH5YAdY/AEUaLy30hpaPnbUXKtH3Ma3X8PIHjBKy5zSFxDVOhc6OYrCulLiEnv1X711KyQsll153ai8y+5/fXXcR5oNjFq+vnXGgEiy2NR/LF5o+/zYlAdhv1HcPKiLucik6VKCmXw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730704326; c=relaxed/simple;
	bh=B+FCaPCIwH/gjHzG1V60m9N37jh6P2iXWiYDcmA4wmo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=epGi+SVuZgSjCHFzcrrMgbQA9G3jTVBWsDuH/NPC4kmS7ntv9TwgZc4VS1hDGUzFYTNRVM9A0vYOWouOX3OpkQ0WLKXhP6zrjGviX9Cz0RQiM+JwiLHTxk52Kp0NyGYQwApQ/sagqoG+osmZUW3uBRaEmNbnPIStEWMJkxA265I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Em69xEHc; arc=none smtp.client-ip=95.215.58.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Em69xEHc"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1730704319;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rdHtOz0U7n4y53o25FenFXE2J8taZSyPq7qrxRk7tRw=;
	b=Em69xEHcg8xLsqLzcd0EMEaqKddTDmEFadVeQYccusdVtV8W2rvrAcAGiMXltBpApNPnI3
	xaOZDQX2FHwhk3jeh1tqVNSiywcYRFSAiLEkmpEdiI/mxKsXfb5HCurJHApEzGf2CUL6X2
	6t9H/DI2rm8VDdYq/UMuBiKL1qVYjCM=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 2/3] bcachefs: Reorganize reflink.c a bit
Date: Mon,  4 Nov 2024 02:11:45 -0500
Message-ID: <20241104071146.11926-2-kent.overstreet@linux.dev>
In-Reply-To: <20241104071146.11926-1-kent.overstreet@linux.dev>
References: <20241104071146.11926-1-kent.overstreet@linux.dev>
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
 fs/bcachefs/btree_gc.c |  92 ------------------
 fs/bcachefs/reflink.c  | 214 ++++++++++++++++++++++++++++++-----------
 fs/bcachefs/reflink.h  |   3 +
 3 files changed, 160 insertions(+), 149 deletions(-)

diff --git a/fs/bcachefs/btree_gc.c b/fs/bcachefs/btree_gc.c
index 2be34b747576..e43d28c0be2b 100644
--- a/fs/bcachefs/btree_gc.c
+++ b/fs/bcachefs/btree_gc.c
@@ -937,98 +937,6 @@ static int bch2_gc_alloc_start(struct bch_fs *c)
 	return ret;
 }
 
-static int bch2_gc_write_reflink_key(struct btree_trans *trans,
-				     struct btree_iter *iter,
-				     struct bkey_s_c k,
-				     size_t *idx)
-{
-	struct bch_fs *c = trans->c;
-	const __le64 *refcount = bkey_refcount_c(k);
-	struct printbuf buf = PRINTBUF;
-	struct reflink_gc *r;
-	int ret = 0;
-
-	if (!refcount)
-		return 0;
-
-	while ((r = genradix_ptr(&c->reflink_gc_table, *idx)) &&
-	       r->offset < k.k->p.offset)
-		++*idx;
-
-	if (!r ||
-	    r->offset != k.k->p.offset ||
-	    r->size != k.k->size) {
-		bch_err(c, "unexpected inconsistency walking reflink table at gc finish");
-		return -EINVAL;
-	}
-
-	if (fsck_err_on(r->refcount != le64_to_cpu(*refcount),
-			trans, reflink_v_refcount_wrong,
-			"reflink key has wrong refcount:\n"
-			"  %s\n"
-			"  should be %u",
-			(bch2_bkey_val_to_text(&buf, c, k), buf.buf),
-			r->refcount)) {
-		struct bkey_i *new = bch2_bkey_make_mut_noupdate(trans, k);
-		ret = PTR_ERR_OR_ZERO(new);
-		if (ret)
-			goto out;
-
-		if (!r->refcount)
-			new->k.type = KEY_TYPE_deleted;
-		else
-			*bkey_refcount(bkey_i_to_s(new)) = cpu_to_le64(r->refcount);
-		ret = bch2_trans_update(trans, iter, new, 0);
-	}
-out:
-fsck_err:
-	printbuf_exit(&buf);
-	return ret;
-}
-
-static int bch2_gc_reflink_done(struct bch_fs *c)
-{
-	size_t idx = 0;
-
-	int ret = bch2_trans_run(c,
-		for_each_btree_key_commit(trans, iter,
-				BTREE_ID_reflink, POS_MIN,
-				BTREE_ITER_prefetch, k,
-				NULL, NULL, BCH_TRANS_COMMIT_no_enospc,
-			bch2_gc_write_reflink_key(trans, &iter, k, &idx)));
-	c->reflink_gc_nr = 0;
-	return ret;
-}
-
-static int bch2_gc_reflink_start(struct bch_fs *c)
-{
-	c->reflink_gc_nr = 0;
-
-	int ret = bch2_trans_run(c,
-		for_each_btree_key(trans, iter, BTREE_ID_reflink, POS_MIN,
-				   BTREE_ITER_prefetch, k, ({
-			const __le64 *refcount = bkey_refcount_c(k);
-
-			if (!refcount)
-				continue;
-
-			struct reflink_gc *r = genradix_ptr_alloc(&c->reflink_gc_table,
-							c->reflink_gc_nr++, GFP_KERNEL);
-			if (!r) {
-				ret = -BCH_ERR_ENOMEM_gc_reflink_start;
-				break;
-			}
-
-			r->offset	= k.k->p.offset;
-			r->size		= k.k->size;
-			r->refcount	= 0;
-			0;
-		})));
-
-	bch_err_fn(c, ret);
-	return ret;
-}
-
 static int bch2_gc_write_stripes_key(struct btree_trans *trans,
 				     struct btree_iter *iter,
 				     struct bkey_s_c k)
diff --git a/fs/bcachefs/reflink.c b/fs/bcachefs/reflink.c
index addaf5f74624..36fb1e9473ff 100644
--- a/fs/bcachefs/reflink.c
+++ b/fs/bcachefs/reflink.c
@@ -72,6 +72,66 @@ bool bch2_reflink_p_merge(struct bch_fs *c, struct bkey_s _l, struct bkey_s_c _r
 	return true;
 }
 
+/* indirect extents */
+
+int bch2_reflink_v_validate(struct bch_fs *c, struct bkey_s_c k,
+			    enum bch_validate_flags flags)
+{
+	int ret = 0;
+
+	bkey_fsck_err_on(bkey_gt(k.k->p, POS(0, REFLINK_P_IDX_MAX)),
+			 c, reflink_v_pos_bad,
+			 "indirect extent above maximum position 0:%llu",
+			 REFLINK_P_IDX_MAX);
+
+	ret = bch2_bkey_ptrs_validate(c, k, flags);
+fsck_err:
+	return ret;
+}
+
+void bch2_reflink_v_to_text(struct printbuf *out, struct bch_fs *c,
+			    struct bkey_s_c k)
+{
+	struct bkey_s_c_reflink_v r = bkey_s_c_to_reflink_v(k);
+
+	prt_printf(out, "refcount: %llu ", le64_to_cpu(r.v->refcount));
+
+	bch2_bkey_ptrs_to_text(out, c, k);
+}
+
+#if 0
+Currently disabled, needs to be debugged:
+
+bool bch2_reflink_v_merge(struct bch_fs *c, struct bkey_s _l, struct bkey_s_c _r)
+{
+	struct bkey_s_reflink_v   l = bkey_s_to_reflink_v(_l);
+	struct bkey_s_c_reflink_v r = bkey_s_c_to_reflink_v(_r);
+
+	return l.v->refcount == r.v->refcount && bch2_extent_merge(c, _l, _r);
+}
+#endif
+
+/* indirect inline data */
+
+int bch2_indirect_inline_data_validate(struct bch_fs *c, struct bkey_s_c k,
+				      enum bch_validate_flags flags)
+{
+	return 0;
+}
+
+void bch2_indirect_inline_data_to_text(struct printbuf *out,
+				       struct bch_fs *c, struct bkey_s_c k)
+{
+	struct bkey_s_c_indirect_inline_data d = bkey_s_c_to_indirect_inline_data(k);
+	unsigned datalen = bkey_inline_data_bytes(k.k);
+
+	prt_printf(out, "refcount %llu datalen %u: %*phN",
+	       le64_to_cpu(d.v->refcount), datalen,
+	       min(datalen, 32U), d.v->data);
+}
+
+/* reflink pointer trigger */
+
 static int trans_trigger_reflink_p_segment(struct btree_trans *trans,
 			struct bkey_s_c_reflink_p p, u64 *idx,
 			enum btree_iter_update_trigger_flags flags)
@@ -253,44 +313,7 @@ int bch2_trigger_reflink_p(struct btree_trans *trans,
 	return trigger_run_overwrite_then_insert(__trigger_reflink_p, trans, btree_id, level, old, new, flags);
 }
 
-/* indirect extents */
-
-int bch2_reflink_v_validate(struct bch_fs *c, struct bkey_s_c k,
-			    enum bch_validate_flags flags)
-{
-	int ret = 0;
-
-	bkey_fsck_err_on(bkey_gt(k.k->p, POS(0, REFLINK_P_IDX_MAX)),
-			 c, reflink_v_pos_bad,
-			 "indirect extent above maximum position 0:%llu",
-			 REFLINK_P_IDX_MAX);
-
-	ret = bch2_bkey_ptrs_validate(c, k, flags);
-fsck_err:
-	return ret;
-}
-
-void bch2_reflink_v_to_text(struct printbuf *out, struct bch_fs *c,
-			    struct bkey_s_c k)
-{
-	struct bkey_s_c_reflink_v r = bkey_s_c_to_reflink_v(k);
-
-	prt_printf(out, "refcount: %llu ", le64_to_cpu(r.v->refcount));
-
-	bch2_bkey_ptrs_to_text(out, c, k);
-}
-
-#if 0
-Currently disabled, needs to be debugged:
-
-bool bch2_reflink_v_merge(struct bch_fs *c, struct bkey_s _l, struct bkey_s_c _r)
-{
-	struct bkey_s_reflink_v   l = bkey_s_to_reflink_v(_l);
-	struct bkey_s_c_reflink_v r = bkey_s_c_to_reflink_v(_r);
-
-	return l.v->refcount == r.v->refcount && bch2_extent_merge(c, _l, _r);
-}
-#endif
+/* indirect extent trigger */
 
 static inline void
 check_indirect_extent_deleting(struct bkey_s new,
@@ -316,25 +339,6 @@ int bch2_trigger_reflink_v(struct btree_trans *trans,
 	return bch2_trigger_extent(trans, btree_id, level, old, new, flags);
 }
 
-/* indirect inline data */
-
-int bch2_indirect_inline_data_validate(struct bch_fs *c, struct bkey_s_c k,
-				      enum bch_validate_flags flags)
-{
-	return 0;
-}
-
-void bch2_indirect_inline_data_to_text(struct printbuf *out,
-				       struct bch_fs *c, struct bkey_s_c k)
-{
-	struct bkey_s_c_indirect_inline_data d = bkey_s_c_to_indirect_inline_data(k);
-	unsigned datalen = bkey_inline_data_bytes(k.k);
-
-	prt_printf(out, "refcount %llu datalen %u: %*phN",
-	       le64_to_cpu(d.v->refcount), datalen,
-	       min(datalen, 32U), d.v->data);
-}
-
 int bch2_trigger_indirect_inline_data(struct btree_trans *trans,
 			      enum btree_id btree_id, unsigned level,
 			      struct bkey_s_c old, struct bkey_s new,
@@ -345,6 +349,8 @@ int bch2_trigger_indirect_inline_data(struct btree_trans *trans,
 	return 0;
 }
 
+/* create */
+
 static int bch2_make_extent_indirect(struct btree_trans *trans,
 				     struct btree_iter *extent_iter,
 				     struct bkey_i *orig)
@@ -608,3 +614,97 @@ s64 bch2_remap_range(struct bch_fs *c,
 
 	return dst_done ?: ret ?: ret2;
 }
+
+/* fsck */
+
+static int bch2_gc_write_reflink_key(struct btree_trans *trans,
+				     struct btree_iter *iter,
+				     struct bkey_s_c k,
+				     size_t *idx)
+{
+	struct bch_fs *c = trans->c;
+	const __le64 *refcount = bkey_refcount_c(k);
+	struct printbuf buf = PRINTBUF;
+	struct reflink_gc *r;
+	int ret = 0;
+
+	if (!refcount)
+		return 0;
+
+	while ((r = genradix_ptr(&c->reflink_gc_table, *idx)) &&
+	       r->offset < k.k->p.offset)
+		++*idx;
+
+	if (!r ||
+	    r->offset != k.k->p.offset ||
+	    r->size != k.k->size) {
+		bch_err(c, "unexpected inconsistency walking reflink table at gc finish");
+		return -EINVAL;
+	}
+
+	if (fsck_err_on(r->refcount != le64_to_cpu(*refcount),
+			trans, reflink_v_refcount_wrong,
+			"reflink key has wrong refcount:\n"
+			"  %s\n"
+			"  should be %u",
+			(bch2_bkey_val_to_text(&buf, c, k), buf.buf),
+			r->refcount)) {
+		struct bkey_i *new = bch2_bkey_make_mut_noupdate(trans, k);
+		ret = PTR_ERR_OR_ZERO(new);
+		if (ret)
+			goto out;
+
+		if (!r->refcount)
+			new->k.type = KEY_TYPE_deleted;
+		else
+			*bkey_refcount(bkey_i_to_s(new)) = cpu_to_le64(r->refcount);
+		ret = bch2_trans_update(trans, iter, new, 0);
+	}
+out:
+fsck_err:
+	printbuf_exit(&buf);
+	return ret;
+}
+
+int bch2_gc_reflink_done(struct bch_fs *c)
+{
+	size_t idx = 0;
+
+	int ret = bch2_trans_run(c,
+		for_each_btree_key_commit(trans, iter,
+				BTREE_ID_reflink, POS_MIN,
+				BTREE_ITER_prefetch, k,
+				NULL, NULL, BCH_TRANS_COMMIT_no_enospc,
+			bch2_gc_write_reflink_key(trans, &iter, k, &idx)));
+	c->reflink_gc_nr = 0;
+	return ret;
+}
+
+int bch2_gc_reflink_start(struct bch_fs *c)
+{
+	c->reflink_gc_nr = 0;
+
+	int ret = bch2_trans_run(c,
+		for_each_btree_key(trans, iter, BTREE_ID_reflink, POS_MIN,
+				   BTREE_ITER_prefetch, k, ({
+			const __le64 *refcount = bkey_refcount_c(k);
+
+			if (!refcount)
+				continue;
+
+			struct reflink_gc *r = genradix_ptr_alloc(&c->reflink_gc_table,
+							c->reflink_gc_nr++, GFP_KERNEL);
+			if (!r) {
+				ret = -BCH_ERR_ENOMEM_gc_reflink_start;
+				break;
+			}
+
+			r->offset	= k.k->p.offset;
+			r->size		= k.k->size;
+			r->refcount	= 0;
+			0;
+		})));
+
+	bch_err_fn(c, ret);
+	return ret;
+}
diff --git a/fs/bcachefs/reflink.h b/fs/bcachefs/reflink.h
index 51afe11d8ed6..6ec3a9ea6bb4 100644
--- a/fs/bcachefs/reflink.h
+++ b/fs/bcachefs/reflink.h
@@ -76,4 +76,7 @@ static inline __le64 *bkey_refcount(struct bkey_s k)
 s64 bch2_remap_range(struct bch_fs *, subvol_inum, u64,
 		     subvol_inum, u64, u64, u64, s64 *);
 
+int bch2_gc_reflink_done(struct bch_fs *);
+int bch2_gc_reflink_start(struct bch_fs *);
+
 #endif /* _BCACHEFS_REFLINK_H */
-- 
2.46.0


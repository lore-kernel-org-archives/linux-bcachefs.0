Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E516E1A38EC
	for <linux-bcachefs@vger.kernel.org>; Fri, 29 Nov 2024 20:28:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732912094; cv=none; b=D1DDQTyNklawB97zExpBvpTOW53X8/S5kw0or7mgl2mmAnBlwXO9+dmJQzZED/H4lcmoV5BHvI5eeHQgn4qOmC61W2IXZMl+kaqFpUiqqkShL6kYhXbKdCu/Eu1elI/wkDGR+b730ZuSFvY/NHSJjsufspJzlnAs9Od2xI55tjM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732912094; c=relaxed/simple;
	bh=6AVWeyYW/31nFrVV2Fe4x/GjQupTtX1uNhGidf91cYE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FRO2RCErPG5WB82hSjbimygLgYIKxu+LTd8LSBt0rKfyYgcqk6BiQtyhzGNeAMf8BGrgN0VUBE1tfjCUDQmKHpZC62I1vw+kSL3QM/Hoq7G+I+wJp0e3Asn+FRyui+PKRiheWoqAbCJAtm0Uv9gjhsMI2ujabm9McUmMguZIm7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; arc=none smtp.client-ip=95.215.58.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>,
	syzbot+85700120f75fc10d4e18@syzkaller.appspotmail.com
Subject: [PATCH 29/34] bcachefs: Check for bucket journal seq in the future
Date: Fri, 29 Nov 2024 15:27:28 -0500
Message-ID: <20241129202736.2713679-30-kent.overstreet@linux.dev>
In-Reply-To: <20241129202736.2713679-1-kent.overstreet@linux.dev>
References: <20241129202736.2713679-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

This fixes an assertion pop in bch2_journal_noflush_seq() - log the
error to the superblock and continue instead.

Reported-by: syzbot+85700120f75fc10d4e18@syzkaller.appspotmail.com
Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/alloc_background.c | 63 +++++++++++++++++++---------------
 fs/bcachefs/sb-errors_format.h |  3 +-
 2 files changed, 37 insertions(+), 29 deletions(-)

diff --git a/fs/bcachefs/alloc_background.c b/fs/bcachefs/alloc_background.c
index 6de0387ede99..e8c246e5803c 100644
--- a/fs/bcachefs/alloc_background.c
+++ b/fs/bcachefs/alloc_background.c
@@ -926,37 +926,43 @@ int bch2_trigger_alloc(struct btree_trans *trans,
 	}
 
 	if ((flags & BTREE_TRIGGER_atomic) && (flags & BTREE_TRIGGER_insert)) {
-		u64 journal_seq = trans->journal_res.seq;
-		u64 bucket_journal_seq = new_a->journal_seq;
+		u64 transaction_seq = trans->journal_res.seq;
 
-		if ((flags & BTREE_TRIGGER_insert) &&
-		    data_type_is_empty(old_a->data_type) !=
-		    data_type_is_empty(new_a->data_type) &&
-		    new.k->type == KEY_TYPE_alloc_v4) {
-			struct bch_alloc_v4 *v = bkey_s_to_alloc_v4(new).v;
+		if (log_fsck_err_on(transaction_seq && new_a->journal_seq > transaction_seq,
+				    trans, alloc_key_journal_seq_in_future,
+				    "bucket journal seq in future (currently at %llu)\n%s",
+				    journal_cur_seq(&c->journal),
+				    (bch2_bkey_val_to_text(&buf, c, new.s_c), buf.buf)))
+			new_a->journal_seq = transaction_seq;
 
-			/*
-			 * If the btree updates referring to a bucket weren't flushed
-			 * before the bucket became empty again, then the we don't have
-			 * to wait on a journal flush before we can reuse the bucket:
-			 */
-			v->journal_seq = bucket_journal_seq =
-				data_type_is_empty(new_a->data_type) &&
-				(journal_seq == v->journal_seq ||
-				 bch2_journal_noflush_seq(&c->journal, v->journal_seq))
-				? 0 : journal_seq;
-		}
+		int is_empty_delta = (int) data_type_is_empty(new_a->data_type) -
+				     (int) data_type_is_empty(old_a->data_type);
 
-		if (!data_type_is_empty(old_a->data_type) &&
-		    data_type_is_empty(new_a->data_type) &&
-		    bucket_journal_seq) {
-			ret = bch2_set_bucket_needs_journal_commit(&c->buckets_waiting_for_journal,
-					c->journal.flushed_seq_ondisk,
-					new.k->p.inode, new.k->p.offset,
-					bucket_journal_seq);
-			if (bch2_fs_fatal_err_on(ret, c,
-					"setting bucket_needs_journal_commit: %s", bch2_err_str(ret)))
-				goto err;
+		/* Record journal sequence number of empty -> nonempty transition: */
+		if (is_empty_delta < 0)
+			new_a->journal_seq = max(new_a->journal_seq, transaction_seq);
+
+		/*
+		 * Bucket becomes empty: mark it as waiting for a journal flush,
+		 * unless updates since empty -> nonempty transition were never
+		 * flushed - we may need to ask the journal not to flush
+		 * intermediate sequence numbers:
+		 */
+		if (is_empty_delta > 0) {
+			if (new_a->journal_seq == transaction_seq ||
+			    bch2_journal_noflush_seq(&c->journal, new_a->journal_seq))
+				new_a->journal_seq = 0;
+			else {
+				new_a->journal_seq = transaction_seq;
+
+				ret = bch2_set_bucket_needs_journal_commit(&c->buckets_waiting_for_journal,
+						c->journal.flushed_seq_ondisk,
+						new.k->p.inode, new.k->p.offset,
+						transaction_seq);
+				if (bch2_fs_fatal_err_on(ret, c,
+						"setting bucket_needs_journal_commit: %s", bch2_err_str(ret)))
+					goto err;
+			}
 		}
 
 		if (new_a->gen != old_a->gen) {
@@ -1004,6 +1010,7 @@ int bch2_trigger_alloc(struct btree_trans *trans,
 		rcu_read_unlock();
 	}
 err:
+fsck_err:
 	printbuf_exit(&buf);
 	bch2_dev_put(ca);
 	return ret;
diff --git a/fs/bcachefs/sb-errors_format.h b/fs/bcachefs/sb-errors_format.h
index 382fcafa815a..8e3a6c5da10d 100644
--- a/fs/bcachefs/sb-errors_format.h
+++ b/fs/bcachefs/sb-errors_format.h
@@ -122,6 +122,7 @@ enum bch_fsck_flags {
 	x(alloc_key_cached_sectors_wrong,			109,	FSCK_AUTOFIX)	\
 	x(alloc_key_stripe_wrong,				110,	FSCK_AUTOFIX)	\
 	x(alloc_key_stripe_redundancy_wrong,			111,	FSCK_AUTOFIX)	\
+	x(alloc_key_journal_seq_in_future,			298,	FSCK_AUTOFIX)	\
 	x(bucket_sector_count_overflow,				112,	0)		\
 	x(bucket_metadata_type_mismatch,			113,	0)		\
 	x(need_discard_key_wrong,				114,	FSCK_AUTOFIX)	\
@@ -308,7 +309,7 @@ enum bch_fsck_flags {
 	x(logged_op_but_clean,					283,	FSCK_AUTOFIX)	\
 	x(compression_opt_not_marked_in_sb,			295,	FSCK_AUTOFIX)	\
 	x(compression_type_not_marked_in_sb,			296,	FSCK_AUTOFIX)	\
-	x(MAX,							298,	0)
+	x(MAX,							299,	0)
 
 enum bch_sb_error_id {
 #define x(t, n, ...) BCH_FSCK_ERR_##t = n,
-- 
2.45.2


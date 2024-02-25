Received: from out-173.mta1.migadu.com (out-173.mta1.migadu.com [95.215.58.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B69AB4C96
	for <linux-bcachefs@vger.kernel.org>; Sun, 25 Feb 2024 02:38:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708828720; cv=none; b=ZUn8AB9vLOAQqGO3j/2omAdufXdKwFZRXcIJX0Aeh0XqqUHE04mylkCuND4iaGWzLtgiVOv/BWDaurkRbO0G+5B3QbFV1yunIkKwqh5sOjy9ex5+qJUqyeiDmrB23zsXORxj79LO7iq0bzd/mnH1YL57et4YGSngdAx7JpR8NzI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708828720; c=relaxed/simple;
	bh=K1vgmzriFmWvEgJQok9FDXdRbIZtQ7Piq5QxBv6WPqs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ky1eSLarP+l7wG3/EfYXPgBXfNAljYsFoYfhTSR6D3pCrn1tEXnW7sYkJaJt8Gt3A8U/5HgwiEFlvBwhGfpL2VviVIkJMVNHGOI+GwCtz5CFr3JQ5NYhQKW/JIdagsAGB2IYA7IHN62mll/1RkfrvplyFXN+vDdmQP9Cjq2pNJg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=LVoDiof7; arc=none smtp.client-ip=95.215.58.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="LVoDiof7"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1708828717;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tb3shMFnBEZZ4S6E3i1HVvq3aYHajiaSmFjcTi21EZM=;
	b=LVoDiof7IIb3DSJ7OEkVgngw1g0y5zhCbQNc0/k7+sYocgA3CXFJfK1hTc3qxYNUeH5f1i
	b+x+CSFz7sezKiLEr0q9+DVnPDfNdUrscbrPF4o/VdX0nxV3op4z0niYlDermoB6Hq0IgJ
	hLQNNzDYbMheESPmlyu9rVc6RaMSB3M=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>,
	djwong@kernel.org,
	bfoster@redhat.com
Subject: [PATCH 03/21] bcachefs: btree write buffer knows how to accumulate bch_accounting keys
Date: Sat, 24 Feb 2024 21:38:05 -0500
Message-ID: <20240225023826.2413565-4-kent.overstreet@linux.dev>
In-Reply-To: <20240225023826.2413565-1-kent.overstreet@linux.dev>
References: <20240225023826.2413565-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Teach the btree write buffer how to accumulate accounting keys - instead
of having the newer key overwrite the older key as we do with other
updates, we need to add them together.

Also, add a flag so that write buffer flush knows when journal replay is
finished flushing accounting, and teach it to hold accounting keys until
that flag is set.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/bcachefs.h           |  1 +
 fs/bcachefs/btree_write_buffer.c | 66 +++++++++++++++++++++++++++-----
 fs/bcachefs/recovery.c           |  3 ++
 3 files changed, 61 insertions(+), 9 deletions(-)

diff --git a/fs/bcachefs/bcachefs.h b/fs/bcachefs/bcachefs.h
index 62812fc1cad0..9a24989c9a6a 100644
--- a/fs/bcachefs/bcachefs.h
+++ b/fs/bcachefs/bcachefs.h
@@ -616,6 +616,7 @@ struct bch_dev {
 
 #define BCH_FS_FLAGS()			\
 	x(started)			\
+	x(accounting_replay_done)	\
 	x(may_go_rw)			\
 	x(rw)				\
 	x(was_rw)			\
diff --git a/fs/bcachefs/btree_write_buffer.c b/fs/bcachefs/btree_write_buffer.c
index b77e7b382b66..002a0762fc85 100644
--- a/fs/bcachefs/btree_write_buffer.c
+++ b/fs/bcachefs/btree_write_buffer.c
@@ -5,6 +5,7 @@
 #include "btree_update.h"
 #include "btree_update_interior.h"
 #include "btree_write_buffer.h"
+#include "disk_accounting.h"
 #include "error.h"
 #include "journal.h"
 #include "journal_io.h"
@@ -123,7 +124,9 @@ static noinline int wb_flush_one_slowpath(struct btree_trans *trans,
 
 static inline int wb_flush_one(struct btree_trans *trans, struct btree_iter *iter,
 			       struct btree_write_buffered_key *wb,
-			       bool *write_locked, size_t *fast)
+			       bool *write_locked,
+			       bool *accounting_accumulated,
+			       size_t *fast)
 {
 	struct btree_path *path;
 	int ret;
@@ -136,6 +139,16 @@ static inline int wb_flush_one(struct btree_trans *trans, struct btree_iter *ite
 	if (ret)
 		return ret;
 
+	if (!*accounting_accumulated && wb->k.k.type == KEY_TYPE_accounting) {
+		struct bkey u;
+		struct bkey_s_c k = bch2_btree_path_peek_slot_exact(btree_iter_path(trans, iter), &u);
+
+		if (k.k->type == KEY_TYPE_accounting)
+			bch2_accounting_accumulate(bkey_i_to_accounting(&wb->k),
+						   bkey_s_c_to_accounting(k));
+	}
+	*accounting_accumulated = true;
+
 	/*
 	 * We can't clone a path that has write locks: unshare it now, before
 	 * set_pos and traverse():
@@ -248,8 +261,9 @@ static int bch2_btree_write_buffer_flush_locked(struct btree_trans *trans)
 	struct journal *j = &c->journal;
 	struct btree_write_buffer *wb = &c->btree_write_buffer;
 	struct btree_iter iter = { NULL };
-	size_t skipped = 0, fast = 0, slowpath = 0;
+	size_t overwritten = 0, fast = 0, slowpath = 0, could_not_insert = 0;
 	bool write_locked = false;
+	bool accounting_replay_done = test_bit(BCH_FS_accounting_replay_done, &c->flags);
 	int ret = 0;
 
 	bch2_trans_unlock(trans);
@@ -284,17 +298,29 @@ static int bch2_btree_write_buffer_flush_locked(struct btree_trans *trans)
 
 	darray_for_each(wb->sorted, i) {
 		struct btree_write_buffered_key *k = &wb->flushing.keys.data[i->idx];
+		bool accounting_accumulated = false;
 
 		for (struct wb_key_ref *n = i + 1; n < min(i + 4, &darray_top(wb->sorted)); n++)
 			prefetch(&wb->flushing.keys.data[n->idx]);
 
 		BUG_ON(!k->journal_seq);
 
+		if (!accounting_replay_done &&
+		    k->k.k.type == KEY_TYPE_accounting) {
+			slowpath++;
+			continue;
+		}
+
 		if (i + 1 < &darray_top(wb->sorted) &&
 		    wb_key_eq(i, i + 1)) {
 			struct btree_write_buffered_key *n = &wb->flushing.keys.data[i[1].idx];
 
-			skipped++;
+			if (k->k.k.type == KEY_TYPE_accounting &&
+			    n->k.k.type == KEY_TYPE_accounting)
+				bch2_accounting_accumulate(bkey_i_to_accounting(&n->k),
+							   bkey_i_to_s_c_accounting(&k->k));
+
+			overwritten++;
 			n->journal_seq = min_t(u64, n->journal_seq, k->journal_seq);
 			k->journal_seq = 0;
 			continue;
@@ -325,7 +351,8 @@ static int bch2_btree_write_buffer_flush_locked(struct btree_trans *trans)
 				break;
 			}
 
-			ret = wb_flush_one(trans, &iter, k, &write_locked, &fast);
+			ret = wb_flush_one(trans, &iter, k, &write_locked,
+					   &accounting_accumulated, &fast);
 			if (!write_locked)
 				bch2_trans_begin(trans);
 		} while (bch2_err_matches(ret, BCH_ERR_transaction_restart));
@@ -361,8 +388,15 @@ static int bch2_btree_write_buffer_flush_locked(struct btree_trans *trans)
 			if (!i->journal_seq)
 				continue;
 
-			bch2_journal_pin_update(j, i->journal_seq, &wb->flushing.pin,
-						bch2_btree_write_buffer_journal_flush);
+			if (!accounting_replay_done &&
+			    i->k.k.type == KEY_TYPE_accounting) {
+				could_not_insert++;
+				continue;
+			}
+
+			if (!could_not_insert)
+				bch2_journal_pin_update(j, i->journal_seq, &wb->flushing.pin,
+							bch2_btree_write_buffer_journal_flush);
 
 			bch2_trans_begin(trans);
 
@@ -375,13 +409,27 @@ static int bch2_btree_write_buffer_flush_locked(struct btree_trans *trans)
 					btree_write_buffered_insert(trans, i));
 			if (ret)
 				goto err;
+
+			i->journal_seq = 0;
+		}
+
+		if (could_not_insert) {
+			struct btree_write_buffered_key *dst = wb->flushing.keys.data;
+
+			darray_for_each(wb->flushing.keys, i)
+				if (i->journal_seq)
+					*dst++ = *i;
+			wb->flushing.keys.nr = dst - wb->flushing.keys.data;
 		}
 	}
 err:
+	if (ret || !could_not_insert) {
+		bch2_journal_pin_drop(j, &wb->flushing.pin);
+		wb->flushing.keys.nr = 0;
+	}
+
 	bch2_fs_fatal_err_on(ret, c, "%s: insert error %s", __func__, bch2_err_str(ret));
-	trace_write_buffer_flush(trans, wb->flushing.keys.nr, skipped, fast, 0);
-	bch2_journal_pin_drop(j, &wb->flushing.pin);
-	wb->flushing.keys.nr = 0;
+	trace_write_buffer_flush(trans, wb->flushing.keys.nr, overwritten, fast, 0);
 	return ret;
 }
 
diff --git a/fs/bcachefs/recovery.c b/fs/bcachefs/recovery.c
index 6829d80bd181..b8289af66c8e 100644
--- a/fs/bcachefs/recovery.c
+++ b/fs/bcachefs/recovery.c
@@ -228,6 +228,8 @@ static int bch2_journal_replay(struct bch_fs *c)
 			goto err;
 	}
 
+	set_bit(BCH_FS_accounting_replay_done, &c->flags);
+
 	/*
 	 * First, attempt to replay keys in sorted order. This is more
 	 * efficient - better locality of btree access -  but some might fail if
@@ -1204,6 +1206,7 @@ int bch2_fs_initialize(struct bch_fs *c)
 	 * set up the journal.pin FIFO and journal.cur pointer:
 	 */
 	bch2_fs_journal_start(&c->journal, 1);
+	set_bit(BCH_FS_accounting_replay_done, &c->flags);
 	bch2_journal_set_replay_done(&c->journal);
 
 	ret = bch2_fs_read_write_early(c);
-- 
2.43.0


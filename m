Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF5E238DD3
	for <linux-bcachefs@vger.kernel.org>; Fri, 10 Nov 2023 16:32:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="tjs2Elfj"
Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [IPv6:2001:41d0:1004:224b::b3])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D10D3EB0C
	for <linux-bcachefs@vger.kernel.org>; Fri, 10 Nov 2023 08:32:09 -0800 (PST)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1699633928;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pRfLe/sqECEKYl22qxyfv5y+YIiQDkzwYjAziHjsaWo=;
	b=tjs2ElfjxYOWOtr7NOyh/pZWZnt+dVdU4auWaggcK/CwmQJ6S9j7E/qUR8cn1OSBJt3PuE
	OfD/UjdB9KMxvOR84tE08NiqTmK6iIDAi7lqolRgkCai0sfiME2h0w2InQffiPGuv6SixY
	+ETZKKpfBorXbl/q70MmCCcq/ET5Pe4=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 07/17] bcachefs: Make journal replay more efficient
Date: Fri, 10 Nov 2023 11:31:44 -0500
Message-ID: <20231110163157.2736111-8-kent.overstreet@linux.dev>
In-Reply-To: <20231110163157.2736111-1-kent.overstreet@linux.dev>
References: <20231110163157.2736111-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Journal replay now first attempts to replay keys in sorted order,
similar to how the btree write buffer flush path works.

Any keys that can not be replayed due to journal deadlock are then left
for later and replayed in journal order, unpinning journal entries as we
go.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/errcode.h  |  1 -
 fs/bcachefs/recovery.c | 84 ++++++++++++++++++++++++++++--------------
 2 files changed, 56 insertions(+), 29 deletions(-)

diff --git a/fs/bcachefs/errcode.h b/fs/bcachefs/errcode.h
index 68a1a96bb7ca..e5c3262cc303 100644
--- a/fs/bcachefs/errcode.h
+++ b/fs/bcachefs/errcode.h
@@ -73,7 +73,6 @@
 	x(ENOMEM,			ENOMEM_fsck_add_nlink)			\
 	x(ENOMEM,			ENOMEM_journal_key_insert)		\
 	x(ENOMEM,			ENOMEM_journal_keys_sort)		\
-	x(ENOMEM,			ENOMEM_journal_replay)			\
 	x(ENOMEM,			ENOMEM_read_superblock_clean)		\
 	x(ENOMEM,			ENOMEM_fs_alloc)			\
 	x(ENOMEM,			ENOMEM_fs_name_alloc)			\
diff --git a/fs/bcachefs/recovery.c b/fs/bcachefs/recovery.c
index 6eafff2557a4..3524d1e0003e 100644
--- a/fs/bcachefs/recovery.c
+++ b/fs/bcachefs/recovery.c
@@ -98,6 +98,9 @@ static int bch2_journal_replay_key(struct btree_trans *trans,
 	unsigned update_flags = BTREE_TRIGGER_NORUN;
 	int ret;
 
+	if (k->overwritten)
+		return 0;
+
 	trans->journal_res.seq = k->journal_seq;
 
 	/*
@@ -141,24 +144,14 @@ static int journal_sort_seq_cmp(const void *_l, const void *_r)
 static int bch2_journal_replay(struct bch_fs *c)
 {
 	struct journal_keys *keys = &c->journal_keys;
-	struct journal_key **keys_sorted, *k;
+	DARRAY(struct journal_key *) keys_sorted = { 0 };
+	struct journal_key **kp;
 	struct journal *j = &c->journal;
 	u64 start_seq	= c->journal_replay_seq_start;
 	u64 end_seq	= c->journal_replay_seq_start;
-	size_t i;
+	struct btree_trans *trans = bch2_trans_get(c);
 	int ret;
 
-	keys_sorted = kvmalloc_array(keys->nr, sizeof(*keys_sorted), GFP_KERNEL);
-	if (!keys_sorted)
-		return -BCH_ERR_ENOMEM_journal_replay;
-
-	for (i = 0; i < keys->nr; i++)
-		keys_sorted[i] = &keys->d[i];
-
-	sort(keys_sorted, keys->nr,
-	     sizeof(keys_sorted[0]),
-	     journal_sort_seq_cmp, NULL);
-
 	if (keys->nr) {
 		ret = bch2_journal_log_msg(c, "Starting journal replay (%zu keys in entries %llu-%llu)",
 					   keys->nr, start_seq, end_seq);
@@ -166,26 +159,61 @@ static int bch2_journal_replay(struct bch_fs *c)
 			goto err;
 	}
 
-	for (i = 0; i < keys->nr; i++) {
-		k = keys_sorted[i];
+	/*
+	 * First, attempt to replay keys in sorted order. This is more
+	 * efficient, but some might fail if that would cause a journal
+	 * deadlock.
+	 */
+	for (size_t i = 0; i < keys->nr; i++) {
+		cond_resched();
+
+		struct journal_key *k = keys->d + i;
+
+		ret = commit_do(trans, NULL, NULL,
+				BTREE_INSERT_NOFAIL|
+				BTREE_INSERT_JOURNAL_RECLAIM|
+				(!k->allocated ? BTREE_INSERT_JOURNAL_REPLAY : 0),
+			     bch2_journal_replay_key(trans, k));
+		BUG_ON(!ret && !k->overwritten);
+		if (ret) {
+			ret = darray_push(&keys_sorted, k);
+			if (ret)
+				goto err;
+		}
+	}
+
+	/*
+	 * Now, replay any remaining keys in the order in which they appear in
+	 * the journal, unpinning those journal entries as we go:
+	 */
+	sort(keys_sorted.data, keys_sorted.nr,
+	     sizeof(keys_sorted.data[0]),
+	     journal_sort_seq_cmp, NULL);
 
+	darray_for_each(keys_sorted, kp) {
 		cond_resched();
 
+		struct journal_key *k = *kp;
+
 		replay_now_at(j, k->journal_seq);
 
-		ret = bch2_trans_do(c, NULL, NULL,
-				    BTREE_INSERT_NOFAIL|
-				    (!k->allocated
-				     ? BTREE_INSERT_JOURNAL_REPLAY|BCH_WATERMARK_reclaim
-				     : 0),
+		ret = commit_do(trans, NULL, NULL,
+				BTREE_INSERT_NOFAIL|
+				(!k->allocated
+				 ? BTREE_INSERT_JOURNAL_REPLAY|BCH_WATERMARK_reclaim
+				 : 0),
 			     bch2_journal_replay_key(trans, k));
-		if (ret) {
-			bch_err(c, "journal replay: error while replaying key at btree %s level %u: %s",
-				bch2_btree_id_str(k->btree_id), k->level, bch2_err_str(ret));
+		bch_err_msg(c, ret, "while replaying key at btree %s level %u:",
+			    bch2_btree_id_str(k->btree_id), k->level);
+		if (ret)
 			goto err;
-		}
+
+		BUG_ON(!k->overwritten);
 	}
 
+	bch2_trans_put(trans);
+	trans = NULL;
+
 	replay_now_at(j, j->replay_journal_seq_end);
 	j->replay_journal_seq = 0;
 
@@ -196,10 +224,10 @@ static int bch2_journal_replay(struct bch_fs *c)
 	if (keys->nr && !ret)
 		bch2_journal_log_msg(c, "journal replay finished");
 err:
-	kvfree(keys_sorted);
-
-	if (ret)
-		bch_err_fn(c, ret);
+	if (trans)
+		bch2_trans_put(trans);
+	darray_exit(&keys_sorted);
+	bch_err_fn(c, ret);
 	return ret;
 }
 
-- 
2.42.0


Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2821B38DD5
	for <linux-bcachefs@vger.kernel.org>; Fri, 10 Nov 2023 16:32:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="iKu0KXoU"
Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [IPv6:2001:41d0:1004:224b::b8])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DB173EB05
	for <linux-bcachefs@vger.kernel.org>; Fri, 10 Nov 2023 08:32:07 -0800 (PST)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1699633925;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9JNU0EE+Gm4izWZG8k4GbehhcdCK5Y0XtRRxldKaQq8=;
	b=iKu0KXoU5Qq1D1jU7QK15f0ZqbuwhqVzmcukksZisFUgMxaulQ1fc8ZajDSMlFgOA3lbQZ
	UQPN6iC97b2/04RkKvGREevMqa72d09H6gPAfP9Vn21wIiHtgdjfANrwAktyHcvAz8ynBK
	pHdjfJzfLpOaCUkaDaghi1QdeBEYqWI=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 03/17] bcachefs: Journal pins must always have a flush_fn
Date: Fri, 10 Nov 2023 11:31:40 -0500
Message-ID: <20231110163157.2736111-4-kent.overstreet@linux.dev>
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

flush_fn is how we identify journal pins in debugfs - this is a
debugging aid.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/btree_trans_commit.c    |  9 ++++++++-
 fs/bcachefs/btree_update_interior.c | 21 ++++++++++++++++++---
 fs/bcachefs/btree_write_buffer.c    | 18 +++++++-----------
 fs/bcachefs/journal_reclaim.c       | 12 +++++++-----
 4 files changed, 40 insertions(+), 20 deletions(-)

diff --git a/fs/bcachefs/btree_trans_commit.c b/fs/bcachefs/btree_trans_commit.c
index d0ead308deef..3152f6abf73f 100644
--- a/fs/bcachefs/btree_trans_commit.c
+++ b/fs/bcachefs/btree_trans_commit.c
@@ -841,6 +841,12 @@ static noinline int bch2_trans_commit_bkey_invalid(struct btree_trans *trans,
 	return -EINVAL;
 }
 
+static int bch2_trans_commit_journal_pin_flush(struct journal *j,
+				struct journal_entry_pin *_pin, u64 seq)
+{
+	return 0;
+}
+
 /*
  * Get journal reservation, take write locks, and attempt to do btree update(s):
  */
@@ -884,7 +890,8 @@ static inline int do_bch2_trans_commit(struct btree_trans *trans, unsigned flags
 
 	if (!ret && trans->journal_pin)
 		bch2_journal_pin_add(&c->journal, trans->journal_res.seq,
-				     trans->journal_pin, NULL);
+				     trans->journal_pin,
+				     bch2_trans_commit_journal_pin_flush);
 
 	/*
 	 * Drop journal reservation after dropping write locks, since dropping
diff --git a/fs/bcachefs/btree_update_interior.c b/fs/bcachefs/btree_update_interior.c
index 925837eca369..518e5b003d04 100644
--- a/fs/bcachefs/btree_update_interior.c
+++ b/fs/bcachefs/btree_update_interior.c
@@ -814,6 +814,12 @@ static void btree_update_updated_node(struct btree_update *as, struct btree *b)
 	mutex_unlock(&c->btree_interior_update_lock);
 }
 
+static int bch2_update_reparent_journal_pin_flush(struct journal *j,
+				struct journal_entry_pin *_pin, u64 seq)
+{
+	return 0;
+}
+
 static void btree_update_reparent(struct btree_update *as,
 				  struct btree_update *child)
 {
@@ -824,7 +830,8 @@ static void btree_update_reparent(struct btree_update *as,
 	child->b = NULL;
 	child->mode = BTREE_INTERIOR_UPDATING_AS;
 
-	bch2_journal_pin_copy(&c->journal, &as->journal, &child->journal, NULL);
+	bch2_journal_pin_copy(&c->journal, &as->journal, &child->journal,
+			      bch2_update_reparent_journal_pin_flush);
 }
 
 static void btree_update_updated_root(struct btree_update *as, struct btree *b)
@@ -933,6 +940,12 @@ static void bch2_btree_update_get_open_buckets(struct btree_update *as, struct b
 			b->ob.v[--b->ob.nr];
 }
 
+static int bch2_btree_update_will_free_node_journal_pin_flush(struct journal *j,
+				struct journal_entry_pin *_pin, u64 seq)
+{
+	return 0;
+}
+
 /*
  * @b is being split/rewritten: it may have pointers to not-yet-written btree
  * nodes and thus outstanding btree_updates - redirect @b's
@@ -984,11 +997,13 @@ static void bch2_btree_interior_update_will_free_node(struct btree_update *as,
 	 * when the new nodes are persistent and reachable on disk:
 	 */
 	w = btree_current_write(b);
-	bch2_journal_pin_copy(&c->journal, &as->journal, &w->journal, NULL);
+	bch2_journal_pin_copy(&c->journal, &as->journal, &w->journal,
+			      bch2_btree_update_will_free_node_journal_pin_flush);
 	bch2_journal_pin_drop(&c->journal, &w->journal);
 
 	w = btree_prev_write(b);
-	bch2_journal_pin_copy(&c->journal, &as->journal, &w->journal, NULL);
+	bch2_journal_pin_copy(&c->journal, &as->journal, &w->journal,
+			      bch2_btree_update_will_free_node_journal_pin_flush);
 	bch2_journal_pin_drop(&c->journal, &w->journal);
 
 	mutex_unlock(&c->btree_interior_update_lock);
diff --git a/fs/bcachefs/btree_write_buffer.c b/fs/bcachefs/btree_write_buffer.c
index 5c398b05cb39..9e3107187e1d 100644
--- a/fs/bcachefs/btree_write_buffer.c
+++ b/fs/bcachefs/btree_write_buffer.c
@@ -11,6 +11,9 @@
 
 #include <linux/sort.h>
 
+static int bch2_btree_write_buffer_journal_flush(struct journal *,
+				struct journal_entry_pin *, u64);
+
 static int btree_write_buffered_key_cmp(const void *_l, const void *_r)
 {
 	const struct btree_write_buffered_key *l = _l;
@@ -148,7 +151,8 @@ int __bch2_btree_write_buffer_flush(struct btree_trans *trans, unsigned commit_f
 	if (!locked && !mutex_trylock(&wb->flush_lock))
 		return 0;
 
-	bch2_journal_pin_copy(j, &pin, &wb->journal_pin, NULL);
+	bch2_journal_pin_copy(j, &pin, &wb->journal_pin,
+			      bch2_btree_write_buffer_journal_flush);
 	bch2_journal_pin_drop(j, &wb->journal_pin);
 
 	s = btree_write_buffer_switch(wb);
@@ -250,16 +254,8 @@ int __bch2_btree_write_buffer_flush(struct btree_trans *trans, unsigned commit_f
 		if (!i->journal_seq)
 			continue;
 
-		if (i->journal_seq > pin.seq) {
-			struct journal_entry_pin pin2;
-
-			memset(&pin2, 0, sizeof(pin2));
-
-			bch2_journal_pin_add(j, i->journal_seq, &pin2, NULL);
-			bch2_journal_pin_drop(j, &pin);
-			bch2_journal_pin_copy(j, &pin, &pin2, NULL);
-			bch2_journal_pin_drop(j, &pin2);
-		}
+		bch2_journal_pin_update(j, i->journal_seq, &pin,
+			      bch2_btree_write_buffer_journal_flush);
 
 		ret = commit_do(trans, NULL, NULL,
 				commit_flags|
diff --git a/fs/bcachefs/journal_reclaim.c b/fs/bcachefs/journal_reclaim.c
index 79a6fdc6e6ef..8fa05bedb7df 100644
--- a/fs/bcachefs/journal_reclaim.c
+++ b/fs/bcachefs/journal_reclaim.c
@@ -378,14 +378,16 @@ static inline void bch2_journal_pin_set_locked(struct journal *j, u64 seq,
 {
 	struct journal_entry_pin_list *pin_list = journal_seq_pin(j, seq);
 
+	/*
+	 * flush_fn is how we identify journal pins in debugfs, so must always
+	 * exist, even if it doesn't do anything:
+	 */
+	BUG_ON(!flush_fn);
+
 	atomic_inc(&pin_list->count);
 	pin->seq	= seq;
 	pin->flush	= flush_fn;
-
-	if (flush_fn)
-		list_add(&pin->list, &pin_list->list[type]);
-	else
-		list_add(&pin->list, &pin_list->flushed);
+	list_add(&pin->list, &pin_list->list[type]);
 }
 
 void bch2_journal_pin_copy(struct journal *j,
-- 
2.42.0


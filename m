Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Gkx0au90"
Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4B6FD44
	for <linux-bcachefs@vger.kernel.org>; Wed, 22 Nov 2023 15:51:25 -0800 (PST)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1700697083;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PQGfV5VFS8au12LjZrtn8b0tQCOSeXkZ0y56kHJB+7I=;
	b=Gkx0au90LBttGhlIOAWaKQXy840wWFJArUBU8DkUm5weTz2lBNPc+5O4eonDS+b2QvpRVB
	lmAvC4PyRvLCKooJw8qaVQU41lyf70kDpt1QH8LZpz8KcMUUgJ8X61QuEVD0QkUt317XXV
	r1VDWme5nBnBgEfKgUfWZtcGwdtF1No=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-kernel@vger.kernel.org,
	linux-bcachefs@vger.kernel.org,
	peterz@infradead.org
Cc: boqun.feng@gmail.com,
	longman@redhat.com,
	will@kernel.org,
	mingo@redhat.com,
	Kent Overstreet <kent.overstreet@linux.dev>,
	Kent Overstreet <kent.overstreet@gmail.com>
Subject: [PATCH 3/6] bcachefs: Assert that btree node locks aren't being leaked
Date: Wed, 22 Nov 2023 18:51:10 -0500
Message-ID: <20231122235113.180132-4-kent.overstreet@linux.dev>
In-Reply-To: <20231122235113.180132-1-kent.overstreet@linux.dev>
References: <20231122235113.180132-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

This asserts (when lockdep is enabled) that btree locks aren't held when
exiting a btree_trans.

Signed-off-by: Kent Overstreet <kent.overstreet@gmail.com>
Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/btree_gc.c      | 3 +++
 fs/bcachefs/btree_locking.c | 7 +++++++
 fs/bcachefs/btree_types.h   | 1 +
 3 files changed, 11 insertions(+)

diff --git a/fs/bcachefs/btree_gc.c b/fs/bcachefs/btree_gc.c
index 136df94e9f84..7e5d52f8ffd7 100644
--- a/fs/bcachefs/btree_gc.c
+++ b/fs/bcachefs/btree_gc.c
@@ -1087,6 +1087,9 @@ static int bch2_gc_btrees(struct bch_fs *c, bool initial, bool metadata_only)
 	unsigned i;
 	int ret = 0;
 
+	if (initial)
+		trans->is_initial_gc = true;
+
 	for (i = 0; i < BTREE_ID_NR; i++)
 		ids[i] = i;
 	bubble_sort(ids, BTREE_ID_NR, btree_id_gc_phase_cmp);
diff --git a/fs/bcachefs/btree_locking.c b/fs/bcachefs/btree_locking.c
index 6039278121dc..308c891ad3ca 100644
--- a/fs/bcachefs/btree_locking.c
+++ b/fs/bcachefs/btree_locking.c
@@ -751,6 +751,13 @@ void bch2_trans_unlock(struct btree_trans *trans)
 
 	trans_for_each_path(trans, path)
 		__bch2_btree_path_unlock(trans, path);
+
+	/*
+	 * bch2_gc_btree_init_recurse() doesn't use btree iterators for walking
+	 * btree nodes, it implements its own walking:
+	 */
+	if (!trans->is_initial_gc)
+		bch2_assert_btree_nodes_not_locked();
 }
 
 void bch2_trans_unlock_long(struct btree_trans *trans)
diff --git a/fs/bcachefs/btree_types.h b/fs/bcachefs/btree_types.h
index ca7526603d06..2326bceb34f8 100644
--- a/fs/bcachefs/btree_types.h
+++ b/fs/bcachefs/btree_types.h
@@ -399,6 +399,7 @@ struct btree_trans {
 	bool			memory_allocation_failure:1;
 	bool			journal_transaction_names:1;
 	bool			journal_replay_not_finished:1;
+	bool			is_initial_gc:1;
 	bool			notrace_relock_fail:1;
 	bool			write_locked:1;
 	enum bch_errcode	restarted:16;
-- 
2.42.0


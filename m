Received: from out-185.mta1.migadu.com (out-185.mta1.migadu.com [95.215.58.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07B064A03
	for <linux-bcachefs@vger.kernel.org>; Sun, 27 Oct 2024 00:51:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729990319; cv=none; b=B7FBVDJF16TrrTPQHCMMEBY9ktZSC/HIRieCk6+iSD1i6iMK9QVJ1aINCwuhIKkE7VziVYqKvwUJj4tGPry15W14kksixynvMi6hSGtLK2a2t4XcwF7BlTifGvJqai3uZ4No5Bh4uW3deVk0iVTC5D857tZOSTyDhlpFshAanAY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729990319; c=relaxed/simple;
	bh=CVOF0GUHk2pMauo1AA++cDTs++Ql/PJ4pTVj+0L624U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b+Lr2forAV3gWeAuzZJhHcp0UjSsaoIhBHjM3Gnqi8JfLXlDnGfN/qYTm0r9y/rIaGHzPI5TifktoQ279WRT6SLdMvlO4tzmGIIdFJ6iPYbSkAPTC7rLSOnxCeCyZyUEHRtRGQMtCtnL63wI6bSpFRWswbx7KQNVQ3YqQ4IgUjU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=KsbKF+io; arc=none smtp.client-ip=95.215.58.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="KsbKF+io"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1729990315;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gAUPe5xs1dTS+n97L4TC5FD61LeD5pmlfRGTR5O5F2k=;
	b=KsbKF+iooPdXfR1n81ffKA5K1f4woUOdJQuo0ajOiuLNggS08i/BxxRg3+fzIhUa3zr1MW
	RpwuK70lQADQLfJycPwRSbi90yidkCP07c07mOWlWCWTcoGjsyoWGFnh+nYcAJpnmr3lDb
	c0nHP5giH43RbRAp/+zrXIbxpPYBleI=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 3/9] bcachefs: CONFIG_BCACHEFS_INJECT_TRANSACTION_RESTARTS
Date: Sat, 26 Oct 2024 20:51:32 -0400
Message-ID: <20241027005141.2337634-4-kent.overstreet@linux.dev>
In-Reply-To: <20241027005141.2337634-1-kent.overstreet@linux.dev>
References: <20241027005141.2337634-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Incorrectly handled transaction restarts can be a source of heisenbugs;
add a mode where we randomly inject them to shake them out.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/Kconfig              |  7 +++++++
 fs/bcachefs/btree_iter.c         | 31 ++++++++++++++++++++++++++++++-
 fs/bcachefs/btree_iter.h         | 12 ++++++++++++
 fs/bcachefs/btree_trans_commit.c |  4 ++++
 fs/bcachefs/btree_types.h        |  3 +++
 5 files changed, 56 insertions(+), 1 deletion(-)

diff --git a/fs/bcachefs/Kconfig b/fs/bcachefs/Kconfig
index a61b22c142a1..75aaa59e3baf 100644
--- a/fs/bcachefs/Kconfig
+++ b/fs/bcachefs/Kconfig
@@ -60,6 +60,13 @@ config BCACHEFS_DEBUG
 	The resulting code will be significantly slower than normal; you
 	probably shouldn't select this option unless you're a developer.
 
+config BCACHEFS_INJECT_TRANSACTION_RESTARTS
+	bool "Randomly inject transaction restarts"
+	depends on BCACHEFS_DEBUG
+	help
+	Randomly inject transaction restarts in a few core paths - may have a
+	significant performance penalty
+
 config BCACHEFS_TESTS
 	bool "bcachefs unit and performance tests"
 	depends on BCACHEFS_FS
diff --git a/fs/bcachefs/btree_iter.c b/fs/bcachefs/btree_iter.c
index 15ac72b1af51..2ef3ac463f66 100644
--- a/fs/bcachefs/btree_iter.c
+++ b/fs/bcachefs/btree_iter.c
@@ -2292,6 +2292,12 @@ struct bkey_s_c bch2_btree_iter_peek_upto(struct btree_iter *iter, struct bpos e
 	bch2_trans_verify_not_unlocked(trans);
 	EBUG_ON((iter->flags & BTREE_ITER_filter_snapshots) && bkey_eq(end, POS_MAX));
 
+	ret = trans_maybe_inject_restart(trans, _RET_IP_);
+	if (unlikely(ret)) {
+		k = bkey_s_c_err(ret);
+		goto out_no_locked;
+	}
+
 	if (iter->update_path) {
 		bch2_path_put_nokeep(trans, iter->update_path,
 				     iter->flags & BTREE_ITER_intent);
@@ -2472,6 +2478,10 @@ struct bkey_s_c bch2_btree_iter_peek_prev(struct btree_iter *iter)
 	bch2_btree_iter_verify(iter);
 	bch2_btree_iter_verify_entry_exit(iter);
 
+	ret = trans_maybe_inject_restart(trans, _RET_IP_);
+	if (unlikely(ret))
+		return bkey_s_c_err(ret);
+
 	if (iter->flags & BTREE_ITER_filter_snapshots)
 		search_key.snapshot = U32_MAX;
 
@@ -2606,6 +2616,12 @@ struct bkey_s_c bch2_btree_iter_peek_slot(struct btree_iter *iter)
 	bch2_btree_iter_verify_entry_exit(iter);
 	EBUG_ON(btree_iter_path(trans, iter)->level && (iter->flags & BTREE_ITER_with_key_cache));
 
+	ret = trans_maybe_inject_restart(trans, _RET_IP_);
+	if (unlikely(ret)) {
+		k = bkey_s_c_err(ret);
+		goto out_no_locked;
+	}
+
 	/* extents can't span inode numbers: */
 	if ((iter->flags & BTREE_ITER_is_extents) &&
 	    unlikely(iter->pos.offset == KEY_OFFSET_MAX)) {
@@ -2951,6 +2967,10 @@ void *__bch2_trans_kmalloc(struct btree_trans *trans, size_t size)
 
 	WARN_ON_ONCE(new_bytes > BTREE_TRANS_MEM_MAX);
 
+	ret = trans_maybe_inject_restart(trans, _RET_IP_);
+	if (ret)
+		return ERR_PTR(ret);
+
 	struct btree_transaction_stats *s = btree_trans_stats(trans);
 	s->max_mem = max(s->max_mem, new_bytes);
 
@@ -3008,7 +3028,8 @@ void *__bch2_trans_kmalloc(struct btree_trans *trans, size_t size)
 
 	if (old_bytes) {
 		trace_and_count(c, trans_restart_mem_realloced, trans, _RET_IP_, new_bytes);
-		return ERR_PTR(btree_trans_restart(trans, BCH_ERR_transaction_restart_mem_realloced));
+		return ERR_PTR(btree_trans_restart_ip(trans,
+					BCH_ERR_transaction_restart_mem_realloced, _RET_IP_));
 	}
 out_change_top:
 	p = trans->mem + trans->mem_top;
@@ -3116,6 +3137,14 @@ u32 bch2_trans_begin(struct btree_trans *trans)
 
 	trans->last_begin_ip = _RET_IP_;
 
+#ifdef CONFIG_BCACHEFS_INJECT_TRANSACTION_RESTARTS
+	if (trans->restarted) {
+		trans->restart_count_this_trans++;
+	} else {
+		trans->restart_count_this_trans = 0;
+	}
+#endif
+
 	trans_set_locked(trans);
 
 	if (trans->restarted) {
diff --git a/fs/bcachefs/btree_iter.h b/fs/bcachefs/btree_iter.h
index 36899c6b134e..286c11b0949c 100644
--- a/fs/bcachefs/btree_iter.h
+++ b/fs/bcachefs/btree_iter.h
@@ -363,6 +363,18 @@ static int btree_trans_restart(struct btree_trans *trans, int err)
 	return btree_trans_restart_ip(trans, err, _THIS_IP_);
 }
 
+static inline int trans_maybe_inject_restart(struct btree_trans *trans, unsigned long ip)
+{
+#ifdef CONFIG_BCACHEFS_INJECT_TRANSACTION_RESTARTS
+	if (!(ktime_get_ns() & ~(~0ULL << min(63, (10 + trans->restart_count_this_trans))))) {
+		trace_and_count(trans->c, trans_restart_injected, trans, ip);
+		return btree_trans_restart_ip(trans,
+					BCH_ERR_transaction_restart_fault_inject, ip);
+	}
+#endif
+	return 0;
+}
+
 bool bch2_btree_node_upgrade(struct btree_trans *,
 			     struct btree_path *, unsigned);
 
diff --git a/fs/bcachefs/btree_trans_commit.c b/fs/bcachefs/btree_trans_commit.c
index b47f11881fe4..766c56cfcd7c 100644
--- a/fs/bcachefs/btree_trans_commit.c
+++ b/fs/bcachefs/btree_trans_commit.c
@@ -1027,6 +1027,10 @@ int __bch2_trans_commit(struct btree_trans *trans, unsigned flags)
 	bch2_trans_verify_not_unlocked(trans);
 	bch2_trans_verify_not_in_restart(trans);
 
+	ret = trans_maybe_inject_restart(trans, _RET_IP_);
+	if (unlikely(ret))
+		goto out_reset;
+
 	if (!trans->nr_updates &&
 	    !trans->journal_entries_u64s)
 		goto out_reset;
diff --git a/fs/bcachefs/btree_types.h b/fs/bcachefs/btree_types.h
index baab5288ecc9..3229de2c335c 100644
--- a/fs/bcachefs/btree_types.h
+++ b/fs/bcachefs/btree_types.h
@@ -509,6 +509,9 @@ struct btree_trans {
 	bool			notrace_relock_fail:1;
 	enum bch_errcode	restarted:16;
 	u32			restart_count;
+#ifdef CONFIG_BCACHEFS_INJECT_TRANSACTION_RESTARTS
+	u32			restart_count_this_trans;
+#endif
 
 	u64			last_begin_time;
 	unsigned long		last_begin_ip;
-- 
2.45.2


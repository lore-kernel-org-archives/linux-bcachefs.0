Received: from out-189.mta1.migadu.com (out-189.mta1.migadu.com [95.215.58.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C321827E044
	for <linux-bcachefs@vger.kernel.org>; Wed, 18 Jun 2025 21:54:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750283698; cv=none; b=ZhXIu/fq5QRXXsr8Wsn+wATzQB/nK52p+9s0ba1KCF7htqfpd6tAMrKaYomV+OCFFTWptmKHcnhexH81XwSLYIzYhJOANL3aT8rIp52V0A+XGfRu6aXW98NrKPaSYUIkODj7Dgf2nVJ0D/7xVP/X1i6KAlIA5TfDbWFoblvsDUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750283698; c=relaxed/simple;
	bh=cYVWoJ+UAaPntlSHn0IOoQD+Y2l0j9ebI7pNRZjcQGE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RD7vlDyVw2LmxTWcmbGTHs09gc7qzqg+c4jhDg/gpbRffn0fnw4zdggTM3pp8uGdbL+IfgtO8AOka1vPv/DT4z4xmWx+UbxKaAwixztJXYZMA2iDmE0GmGPbVrp3W/L+il0r4WZmvmWrkSDVxTjNWuUUpbL7/ymO2azWBvbSmRc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=lXY3ottj; arc=none smtp.client-ip=95.215.58.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="lXY3ottj"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1750283695;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qc+sammJw7lkmfChOiCGfqIPKOT2OByZgcPR+aqv3uo=;
	b=lXY3ottj+incvx9VdccFqvkWNPrCGRARli7RAno474U2Hu2GLNb7d15XbZV4pr+D/DLt7Y
	q7gydzhi6CcgcrSBa2iGa637iJZPJxIgsIIVE9RiPnr/Jx330LAYu3gvB4YfexI3gitFXS
	5vBiBecsn55gS4DLOwiVdQAgL+2T/uA=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 16/37] bcachefs: Kill unused tracepoints
Date: Wed, 18 Jun 2025 17:54:07 -0400
Message-ID: <20250618215431.738317-17-kent.overstreet@linux.dev>
In-Reply-To: <20250618215431.738317-1-kent.overstreet@linux.dev>
References: <20250618215431.738317-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Dead code cleanup.

Link: https://lore.kernel.org/linux-bcachefs/20250612224059.39fddd07@batman.local.home/
Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/btree_trans_commit.c |   5 +-
 fs/bcachefs/btree_write_buffer.c |   3 +
 fs/bcachefs/errcode.h            |   5 --
 fs/bcachefs/trace.h              | 100 +------------------------------
 4 files changed, 9 insertions(+), 104 deletions(-)

diff --git a/fs/bcachefs/btree_trans_commit.c b/fs/bcachefs/btree_trans_commit.c
index 61107f2310ab..639ef75b3dbd 100644
--- a/fs/bcachefs/btree_trans_commit.c
+++ b/fs/bcachefs/btree_trans_commit.c
@@ -595,12 +595,13 @@ bch2_trans_commit_write_locked(struct btree_trans *trans, unsigned flags,
 	int ret = 0;
 
 	bch2_trans_verify_not_unlocked_or_in_restart(trans);
-
+#if 0
+	/* todo: bring back dynamic fault injection */
 	if (race_fault()) {
 		trace_and_count(c, trans_restart_fault_inject, trans, trace_ip);
 		return btree_trans_restart(trans, BCH_ERR_transaction_restart_fault_inject);
 	}
-
+#endif
 	/*
 	 * Check if the insert will fit in the leaf node with the write lock
 	 * held, otherwise another thread could write the node changing the
diff --git a/fs/bcachefs/btree_write_buffer.c b/fs/bcachefs/btree_write_buffer.c
index 90b21e61d2b6..21b5c03d1822 100644
--- a/fs/bcachefs/btree_write_buffer.c
+++ b/fs/bcachefs/btree_write_buffer.c
@@ -676,6 +676,9 @@ int bch2_btree_write_buffer_maybe_flush(struct btree_trans *trans,
 			goto err;
 
 		bch2_bkey_buf_copy(last_flushed, c, tmp.k);
+
+		/* can we avoid the unconditional restart? */
+		trace_and_count(c, trans_restart_write_buffer_flush, trans, _RET_IP_);
 		ret = bch_err_throw(c, transaction_restart_write_buffer_flush);
 	}
 err:
diff --git a/fs/bcachefs/errcode.h b/fs/bcachefs/errcode.h
index ac3264134a15..86a842f1e88e 100644
--- a/fs/bcachefs/errcode.h
+++ b/fs/bcachefs/errcode.h
@@ -137,7 +137,6 @@
 	x(BCH_ERR_transaction_restart,	transaction_restart_relock)		\
 	x(BCH_ERR_transaction_restart,	transaction_restart_relock_path)	\
 	x(BCH_ERR_transaction_restart,	transaction_restart_relock_path_intent)	\
-	x(BCH_ERR_transaction_restart,	transaction_restart_relock_after_fill)	\
 	x(BCH_ERR_transaction_restart,	transaction_restart_too_many_iters)	\
 	x(BCH_ERR_transaction_restart,	transaction_restart_lock_node_reused)	\
 	x(BCH_ERR_transaction_restart,	transaction_restart_fill_relock)	\
@@ -148,11 +147,8 @@
 	x(BCH_ERR_transaction_restart,	transaction_restart_would_deadlock_write)\
 	x(BCH_ERR_transaction_restart,	transaction_restart_deadlock_recursion_limit)\
 	x(BCH_ERR_transaction_restart,	transaction_restart_upgrade)		\
-	x(BCH_ERR_transaction_restart,	transaction_restart_key_cache_upgrade)	\
 	x(BCH_ERR_transaction_restart,	transaction_restart_key_cache_fill)	\
 	x(BCH_ERR_transaction_restart,	transaction_restart_key_cache_raced)	\
-	x(BCH_ERR_transaction_restart,	transaction_restart_key_cache_realloced)\
-	x(BCH_ERR_transaction_restart,	transaction_restart_journal_preres_get)	\
 	x(BCH_ERR_transaction_restart,	transaction_restart_split_race)		\
 	x(BCH_ERR_transaction_restart,	transaction_restart_write_buffer_flush)	\
 	x(BCH_ERR_transaction_restart,	transaction_restart_nested)		\
@@ -241,7 +237,6 @@
 	x(BCH_ERR_journal_res_blocked,	journal_buf_enomem)			\
 	x(BCH_ERR_journal_res_blocked,	journal_stuck)				\
 	x(BCH_ERR_journal_res_blocked,	journal_retry_open)			\
-	x(BCH_ERR_journal_res_blocked,	journal_preres_get_blocked)		\
 	x(BCH_ERR_journal_res_blocked,	bucket_alloc_blocked)			\
 	x(BCH_ERR_journal_res_blocked,	stripe_alloc_blocked)			\
 	x(BCH_ERR_invalid,		invalid_sb)				\
diff --git a/fs/bcachefs/trace.h b/fs/bcachefs/trace.h
index e759c9ff3965..9c5a9c551f03 100644
--- a/fs/bcachefs/trace.h
+++ b/fs/bcachefs/trace.h
@@ -1080,34 +1080,14 @@ TRACE_EVENT(trans_blocked_journal_reclaim,
 		  __entry->must_wait)
 );
 
-TRACE_EVENT(trans_restart_journal_preres_get,
-	TP_PROTO(struct btree_trans *trans,
-		 unsigned long caller_ip,
-		 unsigned flags),
-	TP_ARGS(trans, caller_ip, flags),
-
-	TP_STRUCT__entry(
-		__array(char,			trans_fn, 32	)
-		__field(unsigned long,		caller_ip	)
-		__field(unsigned,		flags		)
-	),
-
-	TP_fast_assign(
-		strscpy(__entry->trans_fn, trans->fn, sizeof(__entry->trans_fn));
-		__entry->caller_ip		= caller_ip;
-		__entry->flags			= flags;
-	),
-
-	TP_printk("%s %pS %x", __entry->trans_fn,
-		  (void *) __entry->caller_ip,
-		  __entry->flags)
-);
-
+#if 0
+/* todo: bring back dynamic fault injection */
 DEFINE_EVENT(transaction_event,	trans_restart_fault_inject,
 	TP_PROTO(struct btree_trans *trans,
 		 unsigned long caller_ip),
 	TP_ARGS(trans, caller_ip)
 );
+#endif
 
 DEFINE_EVENT(transaction_event,	trans_traverse_all,
 	TP_PROTO(struct btree_trans *trans,
@@ -1195,19 +1175,6 @@ DEFINE_EVENT(transaction_restart_iter,	trans_restart_relock_parent_for_fill,
 	TP_ARGS(trans, caller_ip, path)
 );
 
-DEFINE_EVENT(transaction_restart_iter,	trans_restart_relock_after_fill,
-	TP_PROTO(struct btree_trans *trans,
-		 unsigned long caller_ip,
-		 struct btree_path *path),
-	TP_ARGS(trans, caller_ip, path)
-);
-
-DEFINE_EVENT(transaction_event,	trans_restart_key_cache_upgrade,
-	TP_PROTO(struct btree_trans *trans,
-		 unsigned long caller_ip),
-	TP_ARGS(trans, caller_ip)
-);
-
 DEFINE_EVENT(transaction_restart_iter,	trans_restart_relock_key_cache_fill,
 	TP_PROTO(struct btree_trans *trans,
 		 unsigned long caller_ip,
@@ -1229,13 +1196,6 @@ DEFINE_EVENT(transaction_restart_iter,	trans_restart_relock_path_intent,
 	TP_ARGS(trans, caller_ip, path)
 );
 
-DEFINE_EVENT(transaction_restart_iter,	trans_restart_traverse,
-	TP_PROTO(struct btree_trans *trans,
-		 unsigned long caller_ip,
-		 struct btree_path *path),
-	TP_ARGS(trans, caller_ip, path)
-);
-
 DEFINE_EVENT(transaction_restart_iter,	trans_restart_memory_allocation_failure,
 	TP_PROTO(struct btree_trans *trans,
 		 unsigned long caller_ip,
@@ -1294,44 +1254,6 @@ TRACE_EVENT(trans_restart_mem_realloced,
 		  __entry->bytes)
 );
 
-TRACE_EVENT(trans_restart_key_cache_key_realloced,
-	TP_PROTO(struct btree_trans *trans,
-		 unsigned long caller_ip,
-		 struct btree_path *path,
-		 unsigned old_u64s,
-		 unsigned new_u64s),
-	TP_ARGS(trans, caller_ip, path, old_u64s, new_u64s),
-
-	TP_STRUCT__entry(
-		__array(char,			trans_fn, 32	)
-		__field(unsigned long,		caller_ip	)
-		__field(enum btree_id,		btree_id	)
-		TRACE_BPOS_entries(pos)
-		__field(u32,			old_u64s	)
-		__field(u32,			new_u64s	)
-	),
-
-	TP_fast_assign(
-		strscpy(__entry->trans_fn, trans->fn, sizeof(__entry->trans_fn));
-		__entry->caller_ip		= caller_ip;
-
-		__entry->btree_id	= path->btree_id;
-		TRACE_BPOS_assign(pos, path->pos);
-		__entry->old_u64s	= old_u64s;
-		__entry->new_u64s	= new_u64s;
-	),
-
-	TP_printk("%s %pS btree %s pos %llu:%llu:%u old_u64s %u new_u64s %u",
-		  __entry->trans_fn,
-		  (void *) __entry->caller_ip,
-		  bch2_btree_id_str(__entry->btree_id),
-		  __entry->pos_inode,
-		  __entry->pos_offset,
-		  __entry->pos_snapshot,
-		  __entry->old_u64s,
-		  __entry->new_u64s)
-);
-
 DEFINE_EVENT(transaction_event,	trans_restart_write_buffer_flush,
 	TP_PROTO(struct btree_trans *trans,
 		 unsigned long caller_ip),
@@ -1927,21 +1849,6 @@ TRACE_EVENT(btree_path_free,
 		  __entry->dup_locked)
 );
 
-TRACE_EVENT(btree_path_free_trans_begin,
-	TP_PROTO(btree_path_idx_t path),
-	TP_ARGS(path),
-
-	TP_STRUCT__entry(
-		__field(btree_path_idx_t,	idx		)
-	),
-
-	TP_fast_assign(
-		__entry->idx			= path;
-	),
-
-	TP_printk("   path %3u", __entry->idx)
-);
-
 #else /* CONFIG_BCACHEFS_PATH_TRACEPOINTS */
 #ifndef _TRACE_BCACHEFS_H
 
@@ -1959,7 +1866,6 @@ static inline void trace_btree_path_traverse_start(struct btree_trans *trans, st
 static inline void trace_btree_path_traverse_end(struct btree_trans *trans, struct btree_path *path) {}
 static inline void trace_btree_path_set_pos(struct btree_trans *trans, struct btree_path *path, struct bpos *new_pos) {}
 static inline void trace_btree_path_free(struct btree_trans *trans, btree_path_idx_t path, struct btree_path *dup) {}
-static inline void trace_btree_path_free_trans_begin(btree_path_idx_t path) {}
 
 #endif
 #endif /* CONFIG_BCACHEFS_PATH_TRACEPOINTS */
-- 
2.50.0


Received: from out-187.mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A874123BE
	for <linux-bcachefs@vger.kernel.org>; Sun, 27 Oct 2024 00:51:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729990319; cv=none; b=r6rFOhcjUn+i4jSnj6EmgO+V5KUDnHuXy1+RoeJOAVgGAcPox7QCa4TWEggvMA9aJ84lNNRfgpCRSfShrc2bpmxaUtYlX53j3FhGC+xNXSQFp1z+5h3CkJS2T9iqX6/PopCo/TqcsVJ+niRyylXu4842/QGEBxWYODmaAcR4tpE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729990319; c=relaxed/simple;
	bh=NzymoJtGsfV/9Bd7uva/lb4G6uM/Pv4hcmDjqMaF4pA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VdQx4OmaFKa/iQcI27cPGcU6TLbFJZHFVFQuTRRAYuVIB+WZUKnQ7FbshQKjsgXyl0Xye84N4Ngdmx76qH3CY9iMKFHxngSdbioiG2c+jlrp/gVXFQNxltte/27HW7YuVSHa3EdH6URSCFpCPo+VxoJSP0I4CY5wP882Jk/4iDg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=EdUo7w69; arc=none smtp.client-ip=95.215.58.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="EdUo7w69"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1729990314;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sl/3oJzXP+tL510Sfqlo56tSAxM5RcZGMe2A5kuQyFI=;
	b=EdUo7w69O/BYmJJbmKp2dvbbobjdiWQrutWIl95L1mqGAA45G2XCEW/NkveKLNkdXnfGMi
	O+y3GEmcPrH4oAs4JDW7+tYH94s8Qs1bl7sTHTFzGEIqtW/Tj2fV4rSOtx+8YS7Rwa2W9W
	iiG6qiZ81La6fIUu7Ji8iapcrA6qM4M=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 2/9] bcachefs: Better in_restart error
Date: Sat, 26 Oct 2024 20:51:31 -0400
Message-ID: <20241027005141.2337634-3-kent.overstreet@linux.dev>
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

We're ramping up on checking transaction restart handling correctness -
so, in debug mode we now save a backtrace for where the restart was
emitted, which makes it much easier to track down the incorrect
handling.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/btree_iter.c  | 12 ++++++++++++
 fs/bcachefs/btree_iter.h  |  4 ++++
 fs/bcachefs/btree_types.h |  3 +++
 3 files changed, 19 insertions(+)

diff --git a/fs/bcachefs/btree_iter.c b/fs/bcachefs/btree_iter.c
index b36ee4e511fa..15ac72b1af51 100644
--- a/fs/bcachefs/btree_iter.c
+++ b/fs/bcachefs/btree_iter.c
@@ -1414,9 +1414,17 @@ void __noreturn bch2_trans_restart_error(struct btree_trans *trans, u32 restart_
 
 void __noreturn bch2_trans_in_restart_error(struct btree_trans *trans)
 {
+#ifdef CONFIG_BCACHEFS_DEBUG
+	struct printbuf buf = PRINTBUF;
+	bch2_prt_backtrace(&buf, &trans->last_restarted_trace);
+	panic("in transaction restart: %s, last restarted by\n%s",
+	      bch2_err_str(trans->restarted),
+	      buf.buf);
+#else
 	panic("in transaction restart: %s, last restarted by %pS\n",
 	      bch2_err_str(trans->restarted),
 	      (void *) trans->last_restarted_ip);
+#endif
 }
 
 void __noreturn bch2_trans_unlocked_error(struct btree_trans *trans)
@@ -3274,6 +3282,10 @@ void bch2_trans_put(struct btree_trans *trans)
 	closure_return_sync(&trans->ref);
 	trans->locking_wait.task = NULL;
 
+#ifdef CONFIG_BCACHEFS_DEBUG
+	darray_exit(&trans->last_restarted_trace);
+#endif
+
 	unsigned long *paths_allocated = trans->paths_allocated;
 	trans->paths_allocated	= NULL;
 	trans->paths		= NULL;
diff --git a/fs/bcachefs/btree_iter.h b/fs/bcachefs/btree_iter.h
index dda07a320488..36899c6b134e 100644
--- a/fs/bcachefs/btree_iter.h
+++ b/fs/bcachefs/btree_iter.h
@@ -350,6 +350,10 @@ static int btree_trans_restart_ip(struct btree_trans *trans, int err, unsigned l
 
 	trans->restarted = err;
 	trans->last_restarted_ip = ip;
+#ifdef CONFIG_BCACHEFS_DEBUG
+	darray_exit(&trans->last_restarted_trace);
+	bch2_save_backtrace(&trans->last_restarted_trace, current, 0, GFP_NOWAIT);
+#endif
 	return -err;
 }
 
diff --git a/fs/bcachefs/btree_types.h b/fs/bcachefs/btree_types.h
index 4568a41fefaf..baab5288ecc9 100644
--- a/fs/bcachefs/btree_types.h
+++ b/fs/bcachefs/btree_types.h
@@ -513,6 +513,9 @@ struct btree_trans {
 	u64			last_begin_time;
 	unsigned long		last_begin_ip;
 	unsigned long		last_restarted_ip;
+#ifdef CONFIG_BCACHEFS_DEBUG
+	bch_stacktrace		last_restarted_trace;
+#endif
 	unsigned long		last_unlock_ip;
 	unsigned long		srcu_lock_time;
 
-- 
2.45.2


Received: from out-172.mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C4E821CA0D
	for <linux-bcachefs@vger.kernel.org>; Wed, 18 Jun 2025 21:54:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750283688; cv=none; b=kfbad8ofO6dkTpTmGMBUf9qebw3fFhdS4ZFB74ja4SMP3zKLBf1/gqQcPzdrRLdnbKCPThNMB6I4V7clC2xDSFc6GNK3etN00ZDFUCMx+8HWG0pKbQFFm/ECE5c1erIs2bR+6JEl9XBVTkxOm9K4FEHJOjipXLsd3F1LB12HBk4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750283688; c=relaxed/simple;
	bh=WvmJb3CZdvQJw/GAzxYuahB7QNQ3emBAE0LQWV2v4Zs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eT5Ur9lNQuQx9HvuiNiQCQJKRCmn7acuUVyxO33yXvMEGQqG/eTVXEibB8HgrfnkxbFlifyjkpGxDXNS+neCVpM1TVz2J9OOTp1zcm07ADuIbadEy4PXttUT3hthnqc90JtwjLKPp7FXAIrMwDZt8yGrB4Rs816InMs1vGJOgzs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=cDd1CezE; arc=none smtp.client-ip=95.215.58.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="cDd1CezE"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1750283684;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dAJjyDl0uZnHz/i0SXFwEV+Pi5055l2K60M1dDy/ZA8=;
	b=cDd1CezEf++gygMJsu9g0cq/YxJAeOFCtp7OakrWprHVJnrfXjzVJoxUfPG/8iocoQLaG8
	/6QBeELQXycqmaQ4Qgi7wy5ggnTRNd2qC/1088cjHa8VQ88/mi7ecRmR5XJMdmWzL+Vj0G
	0VYmqTYUMQW9atTd0Bax66UrtaJuaBc=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Alan Huang <mmpgouride@gmail.com>,
	syzbot+2887a13a5c387e616a68@syzkaller.appspotmail.com,
	Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 04/37] bcachefs: Fix alloc_req use after free
Date: Wed, 18 Jun 2025 17:53:55 -0400
Message-ID: <20250618215431.738317-5-kent.overstreet@linux.dev>
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

From: Alan Huang <mmpgouride@gmail.com>

Now the alloc_req is allocated from the bump allocator, if there is
reallocation, the memory of alloc_req would be frees, fix by delaying the
reallocation to transaction restart, it has to restart anyway.

Reported-by: syzbot+2887a13a5c387e616a68@syzkaller.appspotmail.com
Signed-off-by: Alan Huang <mmpgouride@gmail.com>
Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/btree_iter.c  | 48 +++++++++++++++++++++++++++------------
 fs/bcachefs/btree_types.h |  1 +
 2 files changed, 35 insertions(+), 14 deletions(-)

diff --git a/fs/bcachefs/btree_iter.c b/fs/bcachefs/btree_iter.c
index 55de2e474705..e2747c57ba2a 100644
--- a/fs/bcachefs/btree_iter.c
+++ b/fs/bcachefs/btree_iter.c
@@ -3216,25 +3216,32 @@ void *__bch2_trans_kmalloc(struct btree_trans *trans, size_t size, unsigned long
 		mutex_unlock(&s->lock);
 	}
 
-	if (trans->used_mempool) {
+	if (trans->used_mempool || new_bytes > BTREE_TRANS_MEM_MAX) {
 		EBUG_ON(trans->mem_bytes >= new_bytes);
 		return ERR_PTR(-BCH_ERR_ENOMEM_trans_kmalloc);
 	}
 
-	new_mem = krealloc(trans->mem, new_bytes, GFP_NOWAIT|__GFP_NOWARN);
+	if (old_bytes) {
+		trans->realloc_bytes_required = new_bytes;
+		trace_and_count(c, trans_restart_mem_realloced, trans, _RET_IP_, new_bytes);
+		return ERR_PTR(btree_trans_restart_ip(trans,
+					BCH_ERR_transaction_restart_mem_realloced, _RET_IP_));
+	}
+
+	EBUG_ON(trans->mem);
+
+	new_mem = kmalloc(new_bytes, GFP_NOWAIT|__GFP_NOWARN);
 	if (unlikely(!new_mem)) {
 		bch2_trans_unlock(trans);
 
-		new_mem = krealloc(trans->mem, new_bytes, GFP_KERNEL);
+		new_mem = kmalloc(new_bytes, GFP_KERNEL);
 		if (!new_mem && new_bytes <= BTREE_TRANS_MEM_MAX) {
 			new_mem = mempool_alloc(&c->btree_trans_mem_pool, GFP_KERNEL);
 			new_bytes = BTREE_TRANS_MEM_MAX;
 			trans->used_mempool = true;
-			kfree(trans->mem);
 		}
 
-		if (!new_mem)
-			return ERR_PTR(-BCH_ERR_ENOMEM_trans_kmalloc);
+		EBUG_ON(!new_mem);
 
 		trans->mem = new_mem;
 		trans->mem_bytes = new_bytes;
@@ -3247,14 +3254,6 @@ void *__bch2_trans_kmalloc(struct btree_trans *trans, size_t size, unsigned long
 	trans->mem = new_mem;
 	trans->mem_bytes = new_bytes;
 
-	if (old_bytes) {
-		trace_and_count(c, trans_restart_mem_realloced, trans, _RET_IP_, new_bytes);
-		return ERR_PTR(btree_trans_restart_ip(trans,
-					BCH_ERR_transaction_restart_mem_realloced, _RET_IP_));
-	}
-
-	bch2_trans_kmalloc_trace(trans, size, ip);
-
 	p = trans->mem + trans->mem_top;
 	trans->mem_top += size;
 	memset(p, 0, size);
@@ -3315,6 +3314,27 @@ u32 bch2_trans_begin(struct btree_trans *trans)
 	trans->restart_count++;
 	trans->mem_top			= 0;
 
+	if (trans->restarted == BCH_ERR_transaction_restart_mem_realloced) {
+		EBUG_ON(!trans->mem || !trans->mem_bytes);
+		unsigned new_bytes = trans->realloc_bytes_required;
+		void *new_mem = krealloc(trans->mem, new_bytes, GFP_NOWAIT|__GFP_NOWARN);
+		if (unlikely(!new_mem)) {
+			bch2_trans_unlock(trans);
+			new_mem = krealloc(trans->mem, new_bytes, GFP_KERNEL);
+
+			EBUG_ON(new_bytes > BTREE_TRANS_MEM_MAX);
+
+			if (!new_mem) {
+				new_mem = mempool_alloc(&trans->c->btree_trans_mem_pool, GFP_KERNEL);
+				new_bytes = BTREE_TRANS_MEM_MAX;
+				trans->used_mempool = true;
+				kfree(trans->mem);
+			}
+                }
+		trans->mem = new_mem;
+		trans->mem_bytes = new_bytes;
+	}
+
 	trans_for_each_path(trans, path, i) {
 		path->should_be_locked = false;
 
diff --git a/fs/bcachefs/btree_types.h b/fs/bcachefs/btree_types.h
index 3aa4a602bd02..112170fd9c8f 100644
--- a/fs/bcachefs/btree_types.h
+++ b/fs/bcachefs/btree_types.h
@@ -497,6 +497,7 @@ struct btree_trans {
 	void			*mem;
 	unsigned		mem_top;
 	unsigned		mem_bytes;
+	unsigned		realloc_bytes_required;
 #ifdef CONFIG_BCACHEFS_TRANS_KMALLOC_TRACE
 	darray_trans_kmalloc_trace trans_kmalloc_trace;
 #endif
-- 
2.50.0


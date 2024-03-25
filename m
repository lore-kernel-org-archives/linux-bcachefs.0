Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D26BD34E9D7
	for <linux-bcachefs@vger.kernel.org>; Mon, 25 Mar 2024 02:51:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711335069; cv=none; b=askHelVO6V8NB8xUblPp8pqxkbVYgv7zRjCLQSlmP52BBxtKVqmxYF0zsp2qRRLDRYn2pWyhCC5B0jdLsHA0buWwY5bEDoxv8oqN6frwQJUDcq4ZWRfwlaje63K2PF4ASvvUis7hK1WLZctJwa0iH19QWjGvbeTPL964v8DE6i4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711335069; c=relaxed/simple;
	bh=0N9yW08XMaWWUEeUCx0S+liBSR62MfuQscVCoAkCTF0=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=TfOwZdvEWGuSK0ctNR/nd8HE1XJe2Yb9w2OlTA09LYMMny+C56jfR7wiNPU/E0K2YZUieMCXWTBD2OqGHozWGpHYdEJvhN7elpmR16MFUCWoT5kNYk7CszhENQZSYqh76hdeO3TDsmPyha3bRf63+HjOdC8NfUIt9iydBCRO5fM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.105])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4V2y6p6g5XztQfX;
	Mon, 25 Mar 2024 10:48:34 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (unknown [7.185.36.66])
	by mail.maildlp.com (Postfix) with ESMTPS id 3105814037C;
	Mon, 25 Mar 2024 10:50:57 +0800 (CST)
Received: from huawei.com (10.90.53.73) by dggpeml500022.china.huawei.com
 (7.185.36.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.35; Mon, 25 Mar
 2024 10:50:56 +0800
From: Hongbo Li <lihongbo22@huawei.com>
To: <kent.overstreet@linux.dev>, <bfoster@redhat.com>
CC: <linux-bcachefs@vger.kernel.org>, <lihongbo22@huawei.com>
Subject: [PATCH] bcachefs: fix trans->mem realloc in __bch2_trans_kmalloc
Date: Mon, 25 Mar 2024 10:50:48 +0800
Message-ID: <20240325025048.1420539-1-lihongbo22@huawei.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpeml500022.china.huawei.com (7.185.36.66)

The old code doesn't consider the mem alloced from mempool when call
krealloc on trans->mem. Also in bch2_trans_put, using mempool_free to
free trans->mem by condition "trans->mem_bytes == BTREE_TRANS_MEM_MAX"
is inaccurate when trans->mem was allocated by krealloc function.
Instead, we use used_mempool stuff to record the situation, and realloc
or free the trans->mem in elegant way.

Also, after krealloc failed in __bch2_trans_kmalloc, the old data
should be copied to the new buffer when alloc from mempool_alloc.

Fixes: 31403dca5bb1 ("bcachefs: optimize __bch2_trans_get(), kill DEBUG_TRANSACTIONS")
Signed-off-by: Hongbo Li <lihongbo22@huawei.com>
---
 fs/bcachefs/btree_iter.c | 33 ++++++++++++++++++++++++++++++---
 1 file changed, 30 insertions(+), 3 deletions(-)

diff --git a/fs/bcachefs/btree_iter.c b/fs/bcachefs/btree_iter.c
index 51bcdc6c6d1c..ae4a28a33ad1 100644
--- a/fs/bcachefs/btree_iter.c
+++ b/fs/bcachefs/btree_iter.c
@@ -2790,6 +2790,31 @@ void *__bch2_trans_kmalloc(struct btree_trans *trans, size_t size)
 	struct btree_transaction_stats *s = btree_trans_stats(trans);
 	s->max_mem = max(s->max_mem, new_bytes);
 
+	if (trans->used_mempool) {
+		if (trans->mem_bytes >= new_bytes)
+			goto out_change_top;
+
+		/* No more space from mempool item, need malloc new one */
+		new_mem = kmalloc(new_bytes, GFP_NOWAIT|__GFP_NOWARN);
+		if (unlikely(!new_mem)) {
+			bch2_trans_unlock(trans);
+
+			new_mem = kmalloc(new_bytes, GFP_KERNEL);
+			if (!new_mem)
+				return ERR_PTR(-BCH_ERR_ENOMEM_trans_kmalloc);
+
+			ret = bch2_trans_relock(trans);
+			if (ret) {
+				kfree(new_mem);
+				return ERR_PTR(ret);
+			}
+		}
+		memcpy(new_mem, trans->mem, trans->mem_top);
+		trans->used_mempool = false;
+		mempool_free(trans->mem, &c->btree_trans_mem_pool);
+		goto out_new_mem;
+	}
+
 	new_mem = krealloc(trans->mem, new_bytes, GFP_NOWAIT|__GFP_NOWARN);
 	if (unlikely(!new_mem)) {
 		bch2_trans_unlock(trans);
@@ -2798,6 +2823,8 @@ void *__bch2_trans_kmalloc(struct btree_trans *trans, size_t size)
 		if (!new_mem && new_bytes <= BTREE_TRANS_MEM_MAX) {
 			new_mem = mempool_alloc(&c->btree_trans_mem_pool, GFP_KERNEL);
 			new_bytes = BTREE_TRANS_MEM_MAX;
+			memcpy(new_mem, trans->mem, trans->mem_top);
+			trans->used_mempool = true;
 			kfree(trans->mem);
 		}
 
@@ -2811,7 +2838,7 @@ void *__bch2_trans_kmalloc(struct btree_trans *trans, size_t size)
 		if (ret)
 			return ERR_PTR(ret);
 	}
-
+out_new_mem:
 	trans->mem = new_mem;
 	trans->mem_bytes = new_bytes;
 
@@ -2819,7 +2846,7 @@ void *__bch2_trans_kmalloc(struct btree_trans *trans, size_t size)
 		trace_and_count(c, trans_restart_mem_realloced, trans, _RET_IP_, new_bytes);
 		return ERR_PTR(btree_trans_restart(trans, BCH_ERR_transaction_restart_mem_realloced));
 	}
-
+out_change_top:
 	p = trans->mem + trans->mem_top;
 	trans->mem_top += size;
 	memset(p, 0, size);
@@ -3093,7 +3120,7 @@ void bch2_trans_put(struct btree_trans *trans)
 	if (paths_allocated != trans->_paths_allocated)
 		kvfree_rcu_mightsleep(paths_allocated);
 
-	if (trans->mem_bytes == BTREE_TRANS_MEM_MAX)
+	if (trans->used_mempool)
 		mempool_free(trans->mem, &c->btree_trans_mem_pool);
 	else
 		kfree(trans->mem);
-- 
2.34.1


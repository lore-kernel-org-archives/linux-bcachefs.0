Received: from out-187.mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61BE021CFEF
	for <linux-bcachefs@vger.kernel.org>; Wed, 18 Jun 2025 21:54:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750283687; cv=none; b=CIb9NlwZs6MhDaBiBQeAyFYyerzYtd9ZwFo6ArxqAnnmVr51gD3OisFrJr+J/om4UrCvMz8HY+U/W8Q2dt5ibqrBICzK1OP/H9P2jO7NgdugXRtidc6N1gXfeKAHOKkltqY5qG6isaRVFoBrbhkEX8zctiuXZnFl91R4R35sZL4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750283687; c=relaxed/simple;
	bh=dOsSsf9cWsch0v6FbTZ5jrydXrTDPpQLY1Anqhd3VdQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YnWOzSmY3RW79His/5ryE78iQddY+elpTVQNd7J6XkYoPbfr0N2CxY8h6nbdQatvwpioT6ZQUT5Udu2LtAnXRwOAq7qCkVMBNgZjalP8ExXKfEJ6o9qpC0F/lIwXwUv/gc9Yg0OTVnUp6BdGfEqlQ/kSJrmPD3oUYlcXzNVyycE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=R64xrpwx; arc=none smtp.client-ip=95.215.58.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="R64xrpwx"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1750283683;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kQJRYR5jdeXRfgWFpg98ZVC7v8i4PEuzsPktV0uDqbA=;
	b=R64xrpwxtTs6T93sh7VdhdWfP8jpYexnnPuH3msECjHFYd3pO3+Upg75MvqBaKo1tdASsM
	xeYf5GlRbtdDWSBhLY/F1InHCTibPzcRykvYfTn9r38OFGpb7uEuAwgZjcfS2vPqn5ceJR
	PW6WQBU8fcSF5NKaQEF5JwLiLadDmso=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Alan Huang <mmpgouride@gmail.com>,
	Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 03/37] bcachefs: Don't allocate new memory when mempool is exhausted
Date: Wed, 18 Jun 2025 17:53:54 -0400
Message-ID: <20250618215431.738317-4-kent.overstreet@linux.dev>
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

Allocating new memory when mempool is exhausted is too complicated, just
return ENOMEM is fine. memcpy is not needed, since there might be
pointers point to the old memory, that's the bug.

Signed-off-by: Alan Huang <mmpgouride@gmail.com>
Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/btree_iter.c | 29 ++++-------------------------
 1 file changed, 4 insertions(+), 25 deletions(-)

diff --git a/fs/bcachefs/btree_iter.c b/fs/bcachefs/btree_iter.c
index b586ecf2fdfa..55de2e474705 100644
--- a/fs/bcachefs/btree_iter.c
+++ b/fs/bcachefs/btree_iter.c
@@ -3217,28 +3217,8 @@ void *__bch2_trans_kmalloc(struct btree_trans *trans, size_t size, unsigned long
 	}
 
 	if (trans->used_mempool) {
-		if (trans->mem_bytes >= new_bytes)
-			goto out_change_top;
-
-		/* No more space from mempool item, need malloc new one */
-		new_mem = kmalloc(new_bytes, GFP_NOWAIT|__GFP_NOWARN);
-		if (unlikely(!new_mem)) {
-			bch2_trans_unlock(trans);
-
-			new_mem = kmalloc(new_bytes, GFP_KERNEL);
-			if (!new_mem)
-				return ERR_PTR(-BCH_ERR_ENOMEM_trans_kmalloc);
-
-			ret = bch2_trans_relock(trans);
-			if (ret) {
-				kfree(new_mem);
-				return ERR_PTR(ret);
-			}
-		}
-		memcpy(new_mem, trans->mem, trans->mem_top);
-		trans->used_mempool = false;
-		mempool_free(trans->mem, &c->btree_trans_mem_pool);
-		goto out_new_mem;
+		EBUG_ON(trans->mem_bytes >= new_bytes);
+		return ERR_PTR(-BCH_ERR_ENOMEM_trans_kmalloc);
 	}
 
 	new_mem = krealloc(trans->mem, new_bytes, GFP_NOWAIT|__GFP_NOWARN);
@@ -3249,7 +3229,6 @@ void *__bch2_trans_kmalloc(struct btree_trans *trans, size_t size, unsigned long
 		if (!new_mem && new_bytes <= BTREE_TRANS_MEM_MAX) {
 			new_mem = mempool_alloc(&c->btree_trans_mem_pool, GFP_KERNEL);
 			new_bytes = BTREE_TRANS_MEM_MAX;
-			memcpy(new_mem, trans->mem, trans->mem_top);
 			trans->used_mempool = true;
 			kfree(trans->mem);
 		}
@@ -3264,7 +3243,7 @@ void *__bch2_trans_kmalloc(struct btree_trans *trans, size_t size, unsigned long
 		if (ret)
 			return ERR_PTR(ret);
 	}
-out_new_mem:
+
 	trans->mem = new_mem;
 	trans->mem_bytes = new_bytes;
 
@@ -3273,7 +3252,7 @@ void *__bch2_trans_kmalloc(struct btree_trans *trans, size_t size, unsigned long
 		return ERR_PTR(btree_trans_restart_ip(trans,
 					BCH_ERR_transaction_restart_mem_realloced, _RET_IP_));
 	}
-out_change_top:
+
 	bch2_trans_kmalloc_trace(trans, size, ip);
 
 	p = trans->mem + trans->mem_top;
-- 
2.50.0


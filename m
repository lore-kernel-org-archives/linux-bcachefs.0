Received: from out-177.mta1.migadu.com (out-177.mta1.migadu.com [95.215.58.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2ED93154C04
	for <linux-bcachefs@vger.kernel.org>; Fri, 29 Nov 2024 20:27:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732912078; cv=none; b=F02zPoVNKsHXlW2xfBnFDBDM8zYDiCV40/ubl+2J+NDb4mkuqZSgAbMZEMKsNw9B0T/is9PoZR4zDnzNQAxmPTiu87BwxHM3+uragxAGEjzFPnXVbCQbd/ShVPPKp3MOX3Shz1GFhlFLvOXezrNMu2cnbuEpl1/UbljWf8idvLY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732912078; c=relaxed/simple;
	bh=FV3yja3dLK/hLAncg8crzFxsczRArsHpY7SIog04Nag=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A30LmPpMe+YjImYpZCz8uRcxnG/SINaw82vB13mhjlnzlScFI2pgkJxCJFTNjlscBG7rK1cjCfJyO5z2+//xfjlyWxvDulTPL3bfduOCiayH3uDjgi6HLJ7My1vhobWXB2baMrMApWHHiQiuQhbtmRK6sgMtdFYWaPSY+jkYDAY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; arc=none smtp.client-ip=95.215.58.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>,
	Tyler <th020394@gmail.com>
Subject: [PATCH 13/34] bcachefs: Fix bch2_btree_node_update_key_early()
Date: Fri, 29 Nov 2024 15:27:12 -0500
Message-ID: <20241129202736.2713679-14-kent.overstreet@linux.dev>
In-Reply-To: <20241129202736.2713679-1-kent.overstreet@linux.dev>
References: <20241129202736.2713679-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Fix an assertion pop from the recent btree cache freelist fixes.

Fixes: baefd3f849ed ("bcachefs: btree_cache.freeable list fixes")
Reported-by: Tyler <th020394@gmail.com>
Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/btree_cache.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/bcachefs/btree_cache.c b/fs/bcachefs/btree_cache.c
index 1f06e24e53fc..1117be901cf0 100644
--- a/fs/bcachefs/btree_cache.c
+++ b/fs/bcachefs/btree_cache.c
@@ -326,7 +326,7 @@ void bch2_btree_node_update_key_early(struct btree_trans *trans,
 	if (!IS_ERR_OR_NULL(b)) {
 		mutex_lock(&c->btree_cache.lock);
 
-		bch2_btree_node_hash_remove(&c->btree_cache, b);
+		__bch2_btree_node_hash_remove(&c->btree_cache, b);
 
 		bkey_copy(&b->key, new);
 		ret = __bch2_btree_node_hash_insert(&c->btree_cache, b);
-- 
2.45.2


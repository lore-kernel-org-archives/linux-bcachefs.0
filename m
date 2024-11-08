Received: from out-187.mta0.migadu.com (out-187.mta0.migadu.com [91.218.175.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BC0F1EE02B
	for <linux-bcachefs@vger.kernel.org>; Fri,  8 Nov 2024 17:11:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731085897; cv=none; b=BEclgx+BbwUksDhW+21EiddmjTgEeXFMX3r4NlYpXjIBmAsbVhudXgICLUkLkqHxOGZenjCs4OhTB7jtIZxcJ14VYldgAAPcfvglKDfr3MK6lRaDHFIlVuG+tCLST6ITK+2UkH8gwVno3KSb8mCyRPYvzYRpHTxH95bmZmmvVf8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731085897; c=relaxed/simple;
	bh=75Eg7EgzGb3t2skGxXRtHLRyHgVkEk6GPLFLwnWUtYE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=iG4obYOggbpmG7zBR8ZUgiONCgxf5wzHkQDQ1DETcXZ3VEWKtsb/1DsdQndQYFmtQJSuNCfUPZhkX/uBvzFVk5pHX0UTj7qbXIAEbwCRsrbtfGvADHrBsUZJwrsUz+vpIwismG4Z+E9D9WWxFlg40reNjBHkobZ2P4vY4W1iNvk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=PxLPn6qw; arc=none smtp.client-ip=91.218.175.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="PxLPn6qw"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1731085892;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=k5DHk+sDKjM8ibnVVCT79MDemuf2uF3Kitw2xqyF/tU=;
	b=PxLPn6qwXZ50sll3FIFN4jFLQJdkQzNSiHc7KJkt8lHdBXEs328SBfr3oSp+bGz0Q2/gFn
	H6Ilf6JijbFe0aIygNaDnwvF28MgzFlrD39H7q+BWNu27T1OBfiRc5ILVSB/IGEOH7RhGV
	kOHTdLlBT7A/zHfnp9r9urokJ5ELs7s=
From: Thorsten Blum <thorsten.blum@linux.dev>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Thorsten Blum <thorsten.blum@linux.dev>,
	linux-bcachefs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] bcachefs: Remove unneeded semicolons
Date: Fri,  8 Nov 2024 18:10:16 +0100
Message-ID: <20241108171015.1973-2-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Remove duplicate semicolons.

Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
 fs/bcachefs/btree_cache.c | 2 +-
 fs/bcachefs/btree_iter.c  | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/bcachefs/btree_cache.c b/fs/bcachefs/btree_cache.c
index a0a406b0c7bc..c313a5bce886 100644
--- a/fs/bcachefs/btree_cache.c
+++ b/fs/bcachefs/btree_cache.c
@@ -519,7 +519,7 @@ static unsigned long bch2_btree_cache_scan(struct shrinker *shrink,
 		if (btree_node_accessed(b)) {
 			clear_btree_node_accessed(b);
 			bc->not_freed[BCH_BTREE_CACHE_NOT_FREED_access_bit]++;
-			--touched;;
+			--touched;
 		} else if (!btree_node_reclaim(c, b, true)) {
 			__bch2_btree_node_hash_remove(bc, b);
 			__btree_node_data_free(bc, b);
diff --git a/fs/bcachefs/btree_iter.c b/fs/bcachefs/btree_iter.c
index b47bfcc438f3..cc13fe1d2be6 100644
--- a/fs/bcachefs/btree_iter.c
+++ b/fs/bcachefs/btree_iter.c
@@ -2699,7 +2699,7 @@ struct bkey_s_c bch2_btree_iter_peek_prev_min(struct btree_iter *iter, struct bp
 	}
 
 	/* Extents can straddle iter->pos: */
-	iter->pos = bpos_min(iter->pos, k.k->p);;
+	iter->pos = bpos_min(iter->pos, k.k->p);
 
 	if (iter->flags & BTREE_ITER_filter_snapshots)
 		iter->pos.snapshot = iter->snapshot;
-- 
2.47.0


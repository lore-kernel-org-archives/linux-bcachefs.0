Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4DD38632B
	for <linux-bcachefs@vger.kernel.org>; Mon, 27 Jan 2025 04:12:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737951175; cv=none; b=Lh3OqS8MhM1TYXZtggef8mAshDEDcVqCQEfDWrp+4VQKKI/UCWmJXh9bLFJ+VXV43Z7v81oC5ZhDNwV2Lic19Px65Hg2CLCtbaQRULiiEYdfAmBz2YhMb22hXZGhlQNRuR7XWXKDAsWpBoYGR5BhtDrZ1clDMyPOAJjT5CoTIac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737951175; c=relaxed/simple;
	bh=1hYDL73gNp+6HHDpxSxhQjSg5czzhEP+nkrFER89omU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ncdlLsZhIrqjkWgbEuyNFLR5BJ4K53d93Wqb5GQSvoJN42AKm5LNCzOppukep3PDqyqBps5tQChqdQnQxVODTZJrhdsriqD8sjcUtCRPnV1j7kQkoIxHP1WVCSFcPmbTLOXi0CgjTaC7Sor9hEJuN6bhC0PTRP6zXHuo9pYhErg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=lrXK4wIR; arc=none smtp.client-ip=91.218.175.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="lrXK4wIR"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1737951171;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jqcZTs+gY8LM06H5PQNV6y2WDCyPs+hyddUXgDAZPqQ=;
	b=lrXK4wIRd40sgDiLYj+v7MWKHadz029T20Ordg+ePntP6ZL9bm8YC7f5NDzOWgO8sl3osU
	hBylbbpmbWEG9xd8KxFp2xqd1lRMge20BziX3NFT0B6I0sAz0OC2hH2QzM0x0MVLlV9+RG
	IFWntj3Hn8PYgwigMA7p7bQiYTNCd1o=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 01/11] bcachefs: Fix btree_trans_peek_key_cache()
Date: Sun, 26 Jan 2025 23:12:27 -0500
Message-ID: <20250127041239.2693707-2-kent.overstreet@linux.dev>
In-Reply-To: <20250127041239.2693707-1-kent.overstreet@linux.dev>
References: <20250127041239.2693707-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

BTREE_ITER_cached_nofill has some tricky corner cases; it's used
internally for iterators that aren't walking the key cache, but need to
be coherent with the key cache.

It tells traverse to look up and lock the key cache entry if present,
but don't create one if it doesn't exist.

That means we have to have a BTREE_ITER_UPTODATE path (because after
traverse the path has to be UPTODATE, or we pop assertions) that doesn't
point to anything (which is the less bad option, taken by the previous
fix).

The previous fix for this path missed an issue that can happen in
bch2_trans_peek_key_cache(): we can't set should_be_locked on a path
that doesn't point to anything and doesn't hold locks.

Fixes: bd5b09727f3d ("bcachefs: Don't set btree_path to updtodate if we don't fill")
Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/btree_iter.c      | 3 +--
 fs/bcachefs/btree_key_cache.c | 4 +++-
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/bcachefs/btree_iter.c b/fs/bcachefs/btree_iter.c
index 367231ab1980..5988219c6908 100644
--- a/fs/bcachefs/btree_iter.c
+++ b/fs/bcachefs/btree_iter.c
@@ -2239,8 +2239,6 @@ struct bkey_s_c btree_trans_peek_key_cache(struct btree_iter *iter, struct bpos
 	if (unlikely(ret))
 		return bkey_s_c_err(ret);
 
-	btree_path_set_should_be_locked(trans, trans->paths + iter->key_cache_path);
-
 	k = bch2_btree_path_peek_slot(trans->paths + iter->key_cache_path, &u);
 	if (!k.k)
 		return k;
@@ -2251,6 +2249,7 @@ struct bkey_s_c btree_trans_peek_key_cache(struct btree_iter *iter, struct bpos
 
 	iter->k = u;
 	k.k = &iter->k;
+	btree_path_set_should_be_locked(trans, trans->paths + iter->key_cache_path);
 	return k;
 }
 
diff --git a/fs/bcachefs/btree_key_cache.c b/fs/bcachefs/btree_key_cache.c
index 3b62296c3100..c378b97ebeca 100644
--- a/fs/bcachefs/btree_key_cache.c
+++ b/fs/bcachefs/btree_key_cache.c
@@ -291,8 +291,10 @@ static noinline int btree_key_cache_fill(struct btree_trans *trans,
 					 struct btree_path *ck_path,
 					 unsigned flags)
 {
-	if (flags & BTREE_ITER_cached_nofill)
+	if (flags & BTREE_ITER_cached_nofill) {
+		ck_path->l[0].b = NULL;
 		return 0;
+	}
 
 	struct bch_fs *c = trans->c;
 	struct btree_iter iter;
-- 
2.45.2


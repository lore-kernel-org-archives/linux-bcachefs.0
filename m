Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48B9E481AF
	for <linux-bcachefs@vger.kernel.org>; Sat, 30 Nov 2024 01:39:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732930779; cv=none; b=rpgCc63yhPA7B9w3xVU3AypRjmq4TKkP3rKc++0o9BKNBUk7o9I2AXhi+K4hUxp1zfFfrtgF/H53I8ro/rY4+Fc81jivFJDXCS2c2bT4Zy1o8V53Nt3UtiHOVSHY/Ylyd6LmwCKUK2xKxo0RWGlp/0bNfQ93OfGWd8/TT8EdqZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732930779; c=relaxed/simple;
	bh=f1utI0wPQcQkWtirHdJWJiXNnfr33dVWfAhVvC8oXRU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z8A0veMJGu7Zjyj1sjM14KpIDGc4ts6kfnGWKQTQr8qCy/tzvFkDSC3N/LyjzZj74/Xr0xrbiG0Xbw1/m7m/+6uEb1NhRT+fAmtiUS2x8jDD8MlKe9vi+qlI6DK+JrA20nkIxv58MXxXQlKAbWVzfq5owQAQUPlv1SNV+Vu0BzU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=OHc5NSEQ; arc=none smtp.client-ip=91.218.175.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="OHc5NSEQ"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1732930775;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BCbOw8FE1esG/6fT1kJQ0d+ZjwPb/wXRYTKnPqFF4Vk=;
	b=OHc5NSEQsBn4n3qTViGA+eRYRgUe5dU3gA1geYHVz92/yPH2l/hDF2p6ciEQ4dW87b1dQ2
	KfZ++6Alr40oB5Dpr195I/IiUxPiHbpj4jmDE5NDKnDya7/YBJ6TuuFgMsfp1UxkFK8Hm8
	JmCWVNa2Onb244UmbUG8zoeHs+bZz8s=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 4/8] bcachefs: kill __bch2_extent_ptr_to_bp()
Date: Fri, 29 Nov 2024 20:39:16 -0500
Message-ID: <20241130013922.3135792-5-kent.overstreet@linux.dev>
In-Reply-To: <20241130013922.3135792-1-kent.overstreet@linux.dev>
References: <20241130013922.3135792-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/backpointers.h | 18 +++---------------
 fs/bcachefs/buckets.c      |  7 +++----
 2 files changed, 6 insertions(+), 19 deletions(-)

diff --git a/fs/bcachefs/backpointers.h b/fs/bcachefs/backpointers.h
index d126d40dda99..65ede8adbc36 100644
--- a/fs/bcachefs/backpointers.h
+++ b/fs/bcachefs/backpointers.h
@@ -140,12 +140,11 @@ static inline enum bch_data_type bch2_bkey_ptr_data_type(struct bkey_s_c k,
 	}
 }
 
-static inline void __bch2_extent_ptr_to_bp(
+static inline void bch2_extent_ptr_to_bp(struct bch_fs *c,
 			   enum btree_id btree_id, unsigned level,
 			   struct bkey_s_c k, struct extent_ptr_decoded p,
 			   const union bch_extent_entry *entry,
-			   struct bkey_i_backpointer *bp,
-			   u64 sectors)
+			   struct bkey_i_backpointer *bp)
 {
 	bkey_backpointer_init(&bp->k_i);
 	bp->k.p = POS(p.ptr.dev, ((u64) p.ptr.offset << MAX_EXTENT_COMPRESS_RATIO_SHIFT) + p.crc.offset);
@@ -154,22 +153,11 @@ static inline void __bch2_extent_ptr_to_bp(
 		.level		= level,
 		.data_type	= bch2_bkey_ptr_data_type(k, p, entry),
 		.bucket_gen	= p.ptr.gen,
-		.bucket_len	= sectors,
+		.bucket_len	= ptr_disk_sectors(level ? btree_sectors(c) : k.k->size, p),
 		.pos		= k.k->p,
 	};
 }
 
-static inline void bch2_extent_ptr_to_bp(struct bch_fs *c,
-			   enum btree_id btree_id, unsigned level,
-			   struct bkey_s_c k, struct extent_ptr_decoded p,
-			   const union bch_extent_entry *entry,
-			   struct bkey_i_backpointer *bp)
-{
-	u64 sectors = ptr_disk_sectors(level ? btree_sectors(c) : k.k->size, p);
-
-	__bch2_extent_ptr_to_bp(btree_id, level, k, p, entry, bp, sectors);
-}
-
 struct bkey_s_c bch2_backpointer_get_key(struct btree_trans *, struct bkey_s_c_backpointer,
 					 struct btree_iter *, unsigned);
 struct btree *bch2_backpointer_get_node(struct btree_trans *, struct bkey_s_c_backpointer,
diff --git a/fs/bcachefs/buckets.c b/fs/bcachefs/buckets.c
index 0365f10f3ba5..1e43ece2426e 100644
--- a/fs/bcachefs/buckets.c
+++ b/fs/bcachefs/buckets.c
@@ -574,11 +574,10 @@ static int bch2_trigger_pointer(struct btree_trans *trans,
 	struct printbuf buf = PRINTBUF;
 	int ret = 0;
 
-	u64 abs_sectors = ptr_disk_sectors(level ? btree_sectors(c) : k.k->size, p);
-	*sectors = insert ? abs_sectors : -abs_sectors;
-
 	struct bkey_i_backpointer bp;
-	__bch2_extent_ptr_to_bp(btree_id, level, k, p, entry, &bp, abs_sectors);
+	bch2_extent_ptr_to_bp(c, btree_id, level, k, p, entry, &bp);
+
+	*sectors = insert ? bp.v.bucket_len : -(s64) bp.v.bucket_len;
 
 	struct bch_dev *ca = bch2_dev_tryget(c, p.ptr.dev);
 	if (unlikely(!ca)) {
-- 
2.45.2


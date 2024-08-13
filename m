Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2488F29A5
	for <linux-bcachefs@vger.kernel.org>; Tue, 13 Aug 2024 04:02:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723521748; cv=none; b=IHRonaiuNtVkanSGJGge0n24GH8CeavhHDoMjx5A3T/hp7B6BCJONDXyQILY0RutZZ0d+oT2cUxrssJmdIpjog/Lu3jq9iCLppEKdNq9QjddrADvATyhIcnzxTECavXthJc3v4nQYqDFnahznJeUvHb2wYISo/onqCL/UZblevQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723521748; c=relaxed/simple;
	bh=knOJNp5F87NQ46GP/Rn1vY6A/5trPvfeyF56l3L8+4w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WZfzlpduXrC/V3jVmEQuB7Jl+XSe85coFeUXBkYNCgydox61d5w7/gtTqDVeGJMZXoj2TumGL+8378nYsJzDqoiK3Qthqsq2O/88shUIKYHLSPa2QC77X7uwihcmeAigFMFTHzAmEM+xylWZmdj7scYVRUOBKu9jNgdqbwgxY+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IV0cJz8o; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IV0cJz8o"
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-1fc66fc35f2so41719625ad.0
        for <linux-bcachefs@vger.kernel.org>; Mon, 12 Aug 2024 21:02:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1723521745; x=1724126545; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aKvrwwyQR+w6LIr3qwZiAIpinFXAZRxlavu+x7VxM5Q=;
        b=IV0cJz8ouiWmkcR/4nChcHOY3I2bsH2oF4nRcTuhFHvLKKw/0I4x3/j5veCYd48nSq
         Xh963RKEgWzBc4sTOQAOyrvxGCPEW5fKk2X4iDomV3DtScX/CBKE1+2Zxj4M2rZQjvbK
         +22PXCqWY6U3lNrq1WLcwJYzw/YGdGxcSPipsd9+RQ75HHrvRMS/y+JS32NgcRR5nZcF
         dI7oQqfOQUI2EaGf7zqTofftcnjKKh+Au8WcHr3JLlJTbxLLzKFUullz+0U+OOHN+OCl
         eY7k8jSlqSwALKXwRcbQgRgLoBovGbiJ6S12Z7SX4f7ZlWrqUJ9Fdg30kv5zNz+2lYgI
         R+vQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723521745; x=1724126545;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aKvrwwyQR+w6LIr3qwZiAIpinFXAZRxlavu+x7VxM5Q=;
        b=oKy1VmFM9tej+ABC8uON0vpehM8ZArCvaYUYTvN8xOexw/5h+MDxALMXM7GWlxC89m
         EUOltSvtVw4cFBHWjBVOdxKFcsx6F8q7FwsHIz6TtMPHkJBSaoOOyTRflvSJdK5Yqp+8
         0lUcxGbHjT7XPjOSYnopMaAHxVhbX0YaWJHT+c7BN5AuGU/AA2RLZNhmZkec9j8tCcgF
         GEz7/wmR43R56fBTkH141FZwx/oJcUAwwny+1KqRSf/2HCd9Ben8cxVv+C5fAaGP3ogi
         ZYpb4eneaFivpEaxuhjYKgW06f+lvPri1w+5/tDX4peJwNviiCXG1LRH30FE0OycS4z1
         iI0g==
X-Gm-Message-State: AOJu0YxmDOSeFhkcWq00IkFgKWeB1Wiq68iEG/uXFP0KG+jEX7lEu9gJ
	ED4oUq7a7265/OCE+/hj3yPUt8ioRk1iIAMnY0zs+jO26tUlWTOB
X-Google-Smtp-Source: AGHT+IGEqh62QJGnpk3be+Ca1w4fMev+KG71cp5JlZVRzDEBvV1FrfUh8sshiopjLZNvZyIqftDO/w==
X-Received: by 2002:a17:902:d484:b0:1fd:8b77:998e with SMTP id d9443c01a7336-201cbc9b641mr27516465ad.29.1723521745234;
        Mon, 12 Aug 2024 21:02:25 -0700 (PDT)
Received: from localhost ([2402:d0c0:11:86::1])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-201cd1ab44asm4196085ad.145.2024.08.12.21.02.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Aug 2024 21:02:24 -0700 (PDT)
From: Alan Huang <mmpgouride@gmail.com>
To: kent.overstreet@linux.dev
Cc: linux-bcachefs@vger.kernel.org,
	Alan Huang <mmpgouride@gmail.com>
Subject: [PATCH v2 2/2] bcachefs: Remove the prev array stuff
Date: Tue, 13 Aug 2024 12:01:59 +0800
Message-ID: <20240813040159.375953-3-mmpgouride@gmail.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240813040159.375953-1-mmpgouride@gmail.com>
References: <20240813040159.375953-1-mmpgouride@gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

After reducing the search range when building the aux tree, the prev array
stuff is no longer useful, so remove it.

Signed-off-by: Alan Huang <mmpgouride@gmail.com>
---
 fs/bcachefs/bset.c | 34 ++++------------------------------
 1 file changed, 4 insertions(+), 30 deletions(-)

diff --git a/fs/bcachefs/bset.c b/fs/bcachefs/bset.c
index 43b40f6b8c0a..0ccc1d962428 100644
--- a/fs/bcachefs/bset.c
+++ b/fs/bcachefs/bset.c
@@ -304,11 +304,6 @@ struct bkey_float {
 };
 #define BKEY_MANTISSA_BITS	16
 
-static unsigned bkey_float_byte_offset(unsigned idx)
-{
-	return idx * sizeof(struct bkey_float);
-}
-
 struct ro_aux_tree {
 	u8			nothing[0];
 	struct bkey_float	f[];
@@ -328,8 +323,7 @@ static unsigned bset_aux_tree_buf_end(const struct bset_tree *t)
 		return t->aux_data_offset;
 	case BSET_RO_AUX_TREE:
 		return t->aux_data_offset +
-			DIV_ROUND_UP(t->size * sizeof(struct bkey_float) +
-				     t->size * sizeof(u8), 8);
+			DIV_ROUND_UP(t->size * sizeof(struct bkey_float), 8);
 	case BSET_RW_AUX_TREE:
 		return t->aux_data_offset +
 			DIV_ROUND_UP(sizeof(struct rw_aux_tree) * t->size, 8);
@@ -360,14 +354,6 @@ static struct ro_aux_tree *ro_aux_tree_base(const struct btree *b,
 	return __aux_tree_base(b, t);
 }
 
-static u8 *ro_aux_tree_prev(const struct btree *b,
-			    const struct bset_tree *t)
-{
-	EBUG_ON(bset_aux_tree_type(t) != BSET_RO_AUX_TREE);
-
-	return __aux_tree_base(b, t) + bkey_float_byte_offset(t->size);
-}
-
 static struct bkey_float *bkey_float(const struct btree *b,
 				     const struct bset_tree *t,
 				     unsigned idx)
@@ -479,15 +465,6 @@ static inline struct bkey_packed *tree_to_bkey(const struct btree *b,
 			bkey_float(b, t, j)->key_offset);
 }
 
-static struct bkey_packed *tree_to_prev_bkey(const struct btree *b,
-					     const struct bset_tree *t,
-					     unsigned j)
-{
-	unsigned prev_u64s = ro_aux_tree_prev(b, t)[j];
-
-	return (void *) ((u64 *) tree_to_bkey(b, t, j)->_data - prev_u64s);
-}
-
 static struct rw_aux_tree *rw_aux_tree(const struct btree *b,
 				       const struct bset_tree *t)
 {
@@ -689,8 +666,7 @@ static unsigned __bset_tree_capacity(struct btree *b, const struct bset_tree *t)
 
 static unsigned bset_ro_tree_capacity(struct btree *b, const struct bset_tree *t)
 {
-	return __bset_tree_capacity(b, t) /
-		(sizeof(struct bkey_float) + sizeof(u8));
+	return __bset_tree_capacity(b, t) / sizeof(struct bkey_float);
 }
 
 static unsigned bset_rw_tree_capacity(struct btree *b, const struct bset_tree *t)
@@ -719,7 +695,7 @@ static noinline void __build_rw_aux_tree(struct btree *b, struct bset_tree *t)
 
 static noinline void __build_ro_aux_tree(struct btree *b, struct bset_tree *t)
 {
-	struct bkey_packed *prev = NULL, *k = btree_bkey_first(b, t);
+	struct bkey_packed *k = btree_bkey_first(b, t);
 	struct bkey_i min_key, max_key;
 	unsigned cacheline = 1;
 
@@ -737,7 +713,7 @@ static noinline void __build_ro_aux_tree(struct btree *b, struct bset_tree *t)
 	/* First we figure out where the first key in each cacheline is */
 	eytzinger1_for_each(j, t->size - 1) {
 		while (bkey_to_cacheline(b, t, k) < cacheline)
-			prev = k, k = bkey_p_next(k);
+			k = bkey_p_next(k);
 
 		if (k >= btree_bkey_last(b, t)) {
 			/* XXX: this path sucks */
@@ -745,11 +721,9 @@ static noinline void __build_ro_aux_tree(struct btree *b, struct bset_tree *t)
 			goto retry;
 		}
 
-		ro_aux_tree_prev(b, t)[j] = prev->u64s;
 		bkey_float(b, t, j)->key_offset =
 			bkey_to_cacheline_offset(b, t, cacheline++, k);
 
-		EBUG_ON(tree_to_prev_bkey(b, t, j) != prev);
 		EBUG_ON(tree_to_bkey(b, t, j) != k);
 	}
 
-- 
2.45.2


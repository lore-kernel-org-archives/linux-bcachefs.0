Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BE5115F40D
	for <linux-bcachefs@vger.kernel.org>; Mon, 12 Aug 2024 10:13:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723457602; cv=none; b=Qbk9/nRZHa9w48ks1XgDS3LObdXusZqpw4EsxY02sD3Vc+9pfjx2os6vfj37CJ0Wm7fqY2h6+j36stEZCyG+afsQwkmoNfauHtnYITpyhXhA2nPAl2Qs2Or2brxVEcv+d5BGX/fzWNV1zRahhpcYQCtxP5m6tE7gNbixEiE0DEU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723457602; c=relaxed/simple;
	bh=PBvUF2j2Eso9lueIhWMzfOp1rbWeVI52fcyPrv48os4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iy0TGY/wyGiMHlhv+eTBVFLyzBySl7uWh8MO6t3kUg5RWTKXdXdTWDF+iWBLEEcr4uIXwU87WQuY7gV4ezR+7htwqLTobdo2Mk6PoEb34kAc58dXjd/iyOTkfiHvfC75P0VrUb99f2VPgD7SGEbm1DWizwMWy+qFs9Joboymqzw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=G7vOskGa; arc=none smtp.client-ip=209.85.215.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="G7vOskGa"
Received: by mail-pg1-f180.google.com with SMTP id 41be03b00d2f7-656d8b346d2so2411163a12.2
        for <linux-bcachefs@vger.kernel.org>; Mon, 12 Aug 2024 03:13:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1723457600; x=1724062400; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7Cj74ho1KXFzms5LkGXDM1W5PMglIeXXoOJszo6IGH4=;
        b=G7vOskGaZaoqre5OkggvAZ6o37xPJbd97/I20z0WhJh0Fpc+Z4j930GOdjwlvYMR1h
         OVmazbb6jxIabuchEZQsqyUlqFVPIK6tvMKmKvOe7sZuvgDHNbYI3dX8z1VYFDZONonq
         Tap+Ih2kHY+aP1EkSzpdtxcTNYGV/yUyHv4Q9YVLi6Pf/dPgQdOCX2YUtSGyJ7IUBF3t
         6MX25iYH8H/ob44zfp1WyCl11OPHrx0QdPuCHO6Ck2xVjjDL7sL+PZle9R7YlXmM0Wz3
         jWS7F86WEZfOxTPuEWXuiJN7L6rKhVoNvIKN81AAV2DGJqdANfxXPOx68RzWLFJrO2FR
         kbpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723457600; x=1724062400;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7Cj74ho1KXFzms5LkGXDM1W5PMglIeXXoOJszo6IGH4=;
        b=sSikDBUGfy7Cp9SCs2h62z9sjzs0OOKPiY+RT4MCkr+4PpPZUlYRfQJTY/wpD+Lm8r
         DtjaoBqBSQDc4c4VkLvyliJNK/9qeXY8L6rvPOprSOb6ErG+hFHoh0fi98+/xZy3Sdyl
         PoFQORRvO/SDn+uol2rGBdGhHBNmOD4dWl1rQ0IPQUSC0Zh94UDAELvcJkOiNWMvnI7t
         zEGW0WVQBiiwbfTwo3Ap59MQ5bACqvMKFfSoA+p7GbV2eATExroK1ytdMX/i8mzsq5cH
         auvesq2wu76lmplUHMgZZvRJ9ixr/aRQh2+c/M0hKE/9fYmQaMbVD0na6mJviKUoZvkl
         D9sg==
X-Gm-Message-State: AOJu0Yy0s0Okz2gLmEeU0MH7LiAbiVe/6es+gLVZnQGgfl6D5N5G+2yj
	DLyxL6oHF25uUL/0E4lIZUQLgCmjPvSQQ/GEvfpgiEKX4g1+XGQ/YeofleP2
X-Google-Smtp-Source: AGHT+IFafAvYho83jd/PWJZegkjLD7FyihabTWQ7h8/PbEvrNvqMuC/Dzs+u+ostYmtsA2BJwK1zqg==
X-Received: by 2002:a05:6a20:c886:b0:1c3:b267:4261 with SMTP id adf61e73a8af0-1c89fce5662mr7281408637.12.1723457600167;
        Mon, 12 Aug 2024 03:13:20 -0700 (PDT)
Received: from localhost ([2402:d0c0:11:86::1])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2d1c9c8042asm7841757a91.21.2024.08.12.03.13.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Aug 2024 03:13:19 -0700 (PDT)
From: Alan Huang <mmpgouride@gmail.com>
To: kent.overstreet@linux.dev
Cc: linux-bcachefs@vger.kernel.org,
	Alan Huang <mmpgouride@gmail.com>
Subject: [PATCH 2/2] bcachefs: Remove the prev array stuff
Date: Mon, 12 Aug 2024 18:13:06 +0800
Message-ID: <20240812101306.347179-3-mmpgouride@gmail.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240812101306.347179-1-mmpgouride@gmail.com>
References: <20240812101306.347179-1-mmpgouride@gmail.com>
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
 fs/bcachefs/bset.c | 31 +++----------------------------
 1 file changed, 3 insertions(+), 28 deletions(-)

diff --git a/fs/bcachefs/bset.c b/fs/bcachefs/bset.c
index 43b40f6b8c0a..f2591fa59fa1 100644
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
@@ -360,14 +355,6 @@ static struct ro_aux_tree *ro_aux_tree_base(const struct btree *b,
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
@@ -479,15 +466,6 @@ static inline struct bkey_packed *tree_to_bkey(const struct btree *b,
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
@@ -689,8 +667,7 @@ static unsigned __bset_tree_capacity(struct btree *b, const struct bset_tree *t)
 
 static unsigned bset_ro_tree_capacity(struct btree *b, const struct bset_tree *t)
 {
-	return __bset_tree_capacity(b, t) /
-		(sizeof(struct bkey_float) + sizeof(u8));
+	return __bset_tree_capacity(b, t) / sizeof(struct bkey_float);
 }
 
 static unsigned bset_rw_tree_capacity(struct btree *b, const struct bset_tree *t)
@@ -719,7 +696,7 @@ static noinline void __build_rw_aux_tree(struct btree *b, struct bset_tree *t)
 
 static noinline void __build_ro_aux_tree(struct btree *b, struct bset_tree *t)
 {
-	struct bkey_packed *prev = NULL, *k = btree_bkey_first(b, t);
+	struct bkey_packed *k = btree_bkey_first(b, t);
 	struct bkey_i min_key, max_key;
 	unsigned cacheline = 1;
 
@@ -737,7 +714,7 @@ static noinline void __build_ro_aux_tree(struct btree *b, struct bset_tree *t)
 	/* First we figure out where the first key in each cacheline is */
 	eytzinger1_for_each(j, t->size - 1) {
 		while (bkey_to_cacheline(b, t, k) < cacheline)
-			prev = k, k = bkey_p_next(k);
+			k = bkey_p_next(k);
 
 		if (k >= btree_bkey_last(b, t)) {
 			/* XXX: this path sucks */
@@ -745,11 +722,9 @@ static noinline void __build_ro_aux_tree(struct btree *b, struct bset_tree *t)
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


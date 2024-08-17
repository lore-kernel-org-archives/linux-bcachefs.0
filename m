Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 049B28005B
	for <linux-bcachefs@vger.kernel.org>; Sat, 17 Aug 2024 07:34:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723880054; cv=none; b=ZsUPfdP+aZUo6Si/vcis6peCWu9tlXMddOM/JTw0HZnqQlebf0TCia+tUx2yKPqz2Y5F+xpSbUu62Ws4IpX0rbhCwdUGhQFBRd/9hYWhnq8XKAfEEkcklmaMAYmg1H48MY4Sol5xk7xMhfftXZjytPIgC9GsV2DfIci9LXVnHvM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723880054; c=relaxed/simple;
	bh=n4AR1Yc9SWav4A01JK9xLON835HdIUbjlJcLEwT1Pog=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=XwkgomO0M4wIRNKaOP50bSNNbItA3BfGwapKhS880l4b0SJMzakabYcbEuD5KoRfi4ZT7FmZroo8EarMOZ6Butd9ZghngOxfkChNg6hTk1QeqbT3/Fb+tX9dyTWEJZdPojV/1WXyEXPGOiL8YzvLPwhnMD2XT4TjlNCPMLdP07I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OAYUBzaa; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OAYUBzaa"
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-20202df1c2fso11914435ad.1
        for <linux-bcachefs@vger.kernel.org>; Sat, 17 Aug 2024 00:34:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1723880052; x=1724484852; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=vxZq5c3hEzcQXS8iioh1+Xp19Yf0D00NB35iRPmShNc=;
        b=OAYUBzaa9Iz6VMC8qsKSJK9iW0V/JSBdVtNEuRzGZ6HUflvrV7zG7Ii/cXaV8b4Z3+
         /AZYChWb72SPhy+qz6VlVyS3W0usgu2vy/Y5AKtqoirYkxpbJvS2m5iuY6vxSjqOQCmY
         g8tuEn3EZdryKyaGEprW7Wi6BPQe+1Qb5LaQ4SUu3gxKlIDMNERkyZH9djF044ap8wRE
         8N8D0vQJ0J5lc0Sxui8kn3uy4LIRoEqEKF1uO6oI9tPcQc458lEYuG6E+/+4OUKa3uf1
         YCFMBfsGanMF/+hf0e+OKZ9kw9b6VDcf5lTuNXPYYHrSq8VqCnXRBFyq+WaJSUfTqYsI
         zQJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723880052; x=1724484852;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vxZq5c3hEzcQXS8iioh1+Xp19Yf0D00NB35iRPmShNc=;
        b=WinvWeI3zYSR+UJU/0jgArk/6xqFh9AxCOO1TMx/FAcQRj2Sn1RAU0HVJTdmTSgY6o
         /Y2L9IPlFTqruSmuwBzWa2oO9N5k1LQQywd8aDBua26jQOcUOPMgmYBj1LMWRX5WSoru
         Ui+z2HuIbbp68tQbzfmZA6oQ70DrRNlssuembm8/9nlsN+55r+ogYr/Goh7q1cj7edW+
         IFwsyjR9+Srf+hC9AaoobONmxFFOIB511/rBCmcLCBmdIaNSylBwPw3LWOm7V/P7CrCO
         OHJEvf+MMAUsiyYlqOztdzEIIrkzPJcm6/ayEo1VMVkbnSHnNDfel4l6AacHgF53dYxo
         0BPw==
X-Gm-Message-State: AOJu0Yx8FPgyRb8Y7BjQxJoAylNcZYWFHT2gTmItuJaE86UGUI7B+mDZ
	Uma1VlRRbZHwV3k1r2sR95pGYYgoEhGngm0pg9859c+DkWGr5LKQ
X-Google-Smtp-Source: AGHT+IH9y0kfcUaM+8NLvAJn1RRo9Sgbj3rUGBj9L0qbYWKohyrT4jT8C48pLGrJhHyX2Bth1/oxjQ==
X-Received: by 2002:a17:90a:67ce:b0:2c8:2cd1:881b with SMTP id 98e67ed59e1d1-2d3c3a8acefmr12580450a91.20.1723880051808;
        Sat, 17 Aug 2024 00:34:11 -0700 (PDT)
Received: from localhost ([2402:d0c0:11:86::1])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2d3e2f633absm3185225a91.23.2024.08.17.00.34.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 17 Aug 2024 00:34:11 -0700 (PDT)
From: Alan Huang <mmpgouride@gmail.com>
To: kent.overstreet@linux.dev
Cc: linux-bcachefs@vger.kernel.org,
	Alan Huang <mmpgouride@gmail.com>
Subject: [PATCH v2] bcachefs: Refactor bch2_bset_fix_lookup_table
Date: Sat, 17 Aug 2024 15:34:01 +0800
Message-ID: <20240817073401.517429-1-mmpgouride@gmail.com>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

bch2_bset_fix_lookup_table is too complicated to be easily understood,
the comment "l now > where" there is also incorrect when where ==
t->end_offset. This patch therefore refactor the function, the idea is
that when where >= rw_aux_tree(b, t)[t->size - 1].offset, we don't need
to adjust the rw aux tree.

Signed-off-by: Alan Huang <mmpgouride@gmail.com>
---
Changes in v2:
- rw_aux_tree_build_entry is renamed to rw_aux_tree_insert_entry
- l is renamed to idx
- two comments are removed since there are assertions
- two parameters of the helper function are removed since they can be
  computed through idx
- goto verify instead of return directly

 fs/bcachefs/bset.c | 128 ++++++++++++++++++++++++---------------------
 1 file changed, 68 insertions(+), 60 deletions(-)

diff --git a/fs/bcachefs/bset.c b/fs/bcachefs/bset.c
index 1b66b2c7e018..d1f6092624d8 100644
--- a/fs/bcachefs/bset.c
+++ b/fs/bcachefs/bset.c
@@ -885,6 +885,38 @@ struct bkey_packed *bch2_bkey_prev_filter(struct btree *b,
 
 /* Insert */
 
+static void rw_aux_tree_insert_entry(struct btree *b,
+				     struct bset_tree *t,
+				     unsigned idx)
+{
+	EBUG_ON(!idx || idx > t->size);
+	struct bkey_packed *start = rw_aux_to_bkey(b, t, idx - 1);
+	struct bkey_packed *end = idx < t->size
+				  ? rw_aux_to_bkey(b, t, idx)
+				  : btree_bkey_last(b, t);
+
+	if (t->size < bset_rw_tree_capacity(b, t) &&
+	    (void *) end - (void *) start > L1_CACHE_BYTES) {
+		struct bkey_packed *k = start;
+
+		while (1) {
+			k = bkey_p_next(k);
+			if (k == end)
+				break;
+
+			if ((void *) k - (void *) start >= L1_CACHE_BYTES) {
+				memmove(&rw_aux_tree(b, t)[idx + 1],
+					&rw_aux_tree(b, t)[idx],
+					(void *) &rw_aux_tree(b, t)[t->size] -
+					(void *) &rw_aux_tree(b, t)[idx]);
+				t->size++;
+				rw_aux_tree_set(b, t, idx, k);
+				break;
+			}
+		}
+	}
+}
+
 static void bch2_bset_fix_lookup_table(struct btree *b,
 				       struct bset_tree *t,
 				       struct bkey_packed *_where,
@@ -892,78 +924,54 @@ static void bch2_bset_fix_lookup_table(struct btree *b,
 				       unsigned new_u64s)
 {
 	int shift = new_u64s - clobber_u64s;
-	unsigned l, j, where = __btree_node_key_to_offset(b, _where);
+	unsigned idx, j, where = __btree_node_key_to_offset(b, _where);
 
 	EBUG_ON(bset_has_ro_aux_tree(t));
 
 	if (!bset_has_rw_aux_tree(t))
 		return;
 
+	if (where > rw_aux_tree(b, t)[t->size - 1].offset) {
+		rw_aux_tree_insert_entry(b, t, t->size);
+		goto verify;
+	}
+
 	/* returns first entry >= where */
-	l = rw_aux_tree_bsearch(b, t, where);
-
-	if (!l) /* never delete first entry */
-		l++;
-	else if (l < t->size &&
-		 where < t->end_offset &&
-		 rw_aux_tree(b, t)[l].offset == where)
-		rw_aux_tree_set(b, t, l++, _where);
-
-	/* l now > where */
-
-	for (j = l;
-	     j < t->size &&
-	     rw_aux_tree(b, t)[j].offset < where + clobber_u64s;
-	     j++)
-		;
-
-	if (j < t->size &&
-	    rw_aux_tree(b, t)[j].offset + shift ==
-	    rw_aux_tree(b, t)[l - 1].offset)
-		j++;
-
-	memmove(&rw_aux_tree(b, t)[l],
-		&rw_aux_tree(b, t)[j],
-		(void *) &rw_aux_tree(b, t)[t->size] -
-		(void *) &rw_aux_tree(b, t)[j]);
-	t->size -= j - l;
-
-	for (j = l; j < t->size; j++)
-		rw_aux_tree(b, t)[j].offset += shift;
+	idx = rw_aux_tree_bsearch(b, t, where);
+
+	if (rw_aux_tree(b, t)[idx].offset == where) {
+		if (!idx) { /* never delete first entry */
+			idx++;
+		} else if (where < t->end_offset) {
+			rw_aux_tree_set(b, t, idx++, _where);
+		} else {
+			EBUG_ON(where != t->end_offset);
+			rw_aux_tree_insert_entry(b, t, --t->size);
+			goto verify;
+		}
+	}
 
-	EBUG_ON(l < t->size &&
-		rw_aux_tree(b, t)[l].offset ==
-		rw_aux_tree(b, t)[l - 1].offset);
+	EBUG_ON(idx < t->size && rw_aux_tree(b, t)[idx].offset <= where);
+	if (idx < t->size &&
+	    rw_aux_tree(b, t)[idx].offset + shift ==
+	    rw_aux_tree(b, t)[idx - 1].offset) {
+		memmove(&rw_aux_tree(b, t)[idx],
+			&rw_aux_tree(b, t)[idx + 1],
+			(void *) &rw_aux_tree(b, t)[t->size] -
+			(void *) &rw_aux_tree(b, t)[idx + 1]);
+		t->size -= 1;
+	}
 
-	if (t->size < bset_rw_tree_capacity(b, t) &&
-	    (l < t->size
-	     ? rw_aux_tree(b, t)[l].offset
-	     : t->end_offset) -
-	    rw_aux_tree(b, t)[l - 1].offset >
-	    L1_CACHE_BYTES / sizeof(u64)) {
-		struct bkey_packed *start = rw_aux_to_bkey(b, t, l - 1);
-		struct bkey_packed *end = l < t->size
-			? rw_aux_to_bkey(b, t, l)
-			: btree_bkey_last(b, t);
-		struct bkey_packed *k = start;
+	for (j = idx; j < t->size; j++)
+		rw_aux_tree(b, t)[j].offset += shift;
 
-		while (1) {
-			k = bkey_p_next(k);
-			if (k == end)
-				break;
+	EBUG_ON(idx < t->size &&
+		rw_aux_tree(b, t)[idx].offset ==
+		rw_aux_tree(b, t)[idx - 1].offset);
 
-			if ((void *) k - (void *) start >= L1_CACHE_BYTES) {
-				memmove(&rw_aux_tree(b, t)[l + 1],
-					&rw_aux_tree(b, t)[l],
-					(void *) &rw_aux_tree(b, t)[t->size] -
-					(void *) &rw_aux_tree(b, t)[l]);
-				t->size++;
-				rw_aux_tree_set(b, t, l, k);
-				break;
-			}
-		}
-	}
+	rw_aux_tree_insert_entry(b, t, idx);
 
+verify:
 	bch2_bset_verify_rw_aux_tree(b, t);
 	bset_aux_tree_verify(b);
 }
-- 
2.45.2


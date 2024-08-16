Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3FF681AD7
	for <linux-bcachefs@vger.kernel.org>; Fri, 16 Aug 2024 04:40:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723783233; cv=none; b=SvYx7BJGBQB3IsMRiDrlZjARznnEXREVeHyJ4k2uJt2Mr0RYWkeyYZt9M8cUxGWjFj+vVErnpcZnn/9yu5crnIp8bG6HbKIC2aqbH59VbFuDPnJzYhPmx5RIB13nt2wntPGArOAJQ27Pnt2nFfJnh/bfcWghDi1bTi4HTdsSntM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723783233; c=relaxed/simple;
	bh=akTmFOQP4nWul8sEt0vUrUCM9ARnXcWMRVJhKZXqCRc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=peDIvF3hGqOXmz1FXikVGTDo6AZG6tcKlaFm1OWo0JboudOrwlEG9vv7F62fdSwMedje2x2Br9EU8LO0vTm+VAdOePoIn+yEy9ltWy88wWeX4jBi2vjiLeCo2L4gwLT/cHABr+nyqVZHE/oTJBLcZAzxq+0ejAHn5Na+/6QLPgE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=B4N1A9WY; arc=none smtp.client-ip=209.85.215.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="B4N1A9WY"
Received: by mail-pg1-f180.google.com with SMTP id 41be03b00d2f7-7c6b03c414fso570637a12.2
        for <linux-bcachefs@vger.kernel.org>; Thu, 15 Aug 2024 21:40:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1723783231; x=1724388031; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=vGQogNkIeD+CTgKfahUECQqO2Fy9zYIB8UNHUfqWPlA=;
        b=B4N1A9WYjX/N4QZZre4sZFXIKnrCY5pijUz3goDjmfDFHxEYJSGkzlW/8XF09by5Sx
         abH9VVwJUb/VQAoyF4vN3D0+9Rt27fDBrITyXbMS9jEMAVkxGskyYi9uAEq1tCCLwnCf
         Aj3wCtwcmSwJsgz+DEsHWoE9db6QPwDqGsQvwTwJHi10oI6BtnRtDav+BRR6b/Vf5n8Y
         3RtWOy3wlqSrUxM4hnWkxax1+XHkMnY1JWjwQCRX1xvlbKcZNlDM3ZC6ViLcZi6gzFxE
         xdHRlmMIC0nYh3D7Ncl0a0uj1y2U24Tt5+OzG4IMDtGjbFQjx/CJwwKV3oLCO8N7VM8m
         uLjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723783231; x=1724388031;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vGQogNkIeD+CTgKfahUECQqO2Fy9zYIB8UNHUfqWPlA=;
        b=TeEgwWe4uLaD79WVZVHvD4HSu+JGQer/JEPOTdcWCUMcGJqL2GJFQn+M0c01uSikaw
         eDgZpbFaVW3uxn0fUoth2wt/GgqAxn8jTe7Tf0NGThJdEmE5PdnThleD6yfalD/QO1Mo
         Z7Ah7plCw+YMg2gwp8Pi/q8TbucHWxEWgfKAds+muUa4yXMVImrASau3RnoZeBUOE+NL
         hUfqh34t6Diz2SQINMvfIgmtYAOv3qj9ne7wpVgtki2ql1leqFMWB3QqYZglCU2eUlVm
         UYtOc5d/tHNoU1H6m58pPGsjvBN46Kk7+H7CErVJ7ilWJ8PvRfSgnmtWiF0p2fFr1TZd
         QClg==
X-Gm-Message-State: AOJu0YyRvNB3Sb0gt4hfaIci1hq39Ytg6OxM4GAIFUK7CFXehotrqmLe
	kfpJD4Ar1nQRG5TgVcqaRQS3USs3PmV/DGrl/XdzKarDAZN/gpDR
X-Google-Smtp-Source: AGHT+IGbxzveku5D7mDyp/tG/HgAIok3FLCVs8Oo3EWQjdNmol7OD+9g+N9nZUl0Y24T8N74WkkPfw==
X-Received: by 2002:a05:6a21:e86:b0:1c8:95c9:3016 with SMTP id adf61e73a8af0-1c904f91d04mr1768382637.21.1723783230878;
        Thu, 15 Aug 2024 21:40:30 -0700 (PDT)
Received: from localhost ([2402:d0c0:11:86::1])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2d3e3c752aesm743951a91.42.2024.08.15.21.40.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Aug 2024 21:40:30 -0700 (PDT)
From: Alan Huang <mmpgouride@gmail.com>
To: kent.overstreet@linux.dev
Cc: linux-bcachefs@vger.kernel.org,
	Alan Huang <mmpgouride@gmail.com>
Subject: [PATCH] bcachefs: Refactor bch2_bset_fix_lookup_table
Date: Fri, 16 Aug 2024 12:40:26 +0800
Message-ID: <20240816044026.490107-1-mmpgouride@gmail.com>
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
 fs/bcachefs/bset.c | 116 +++++++++++++++++++++++++--------------------
 1 file changed, 65 insertions(+), 51 deletions(-)

diff --git a/fs/bcachefs/bset.c b/fs/bcachefs/bset.c
index 1b66b2c7e018..c5fffed88c46 100644
--- a/fs/bcachefs/bset.c
+++ b/fs/bcachefs/bset.c
@@ -885,6 +885,34 @@ struct bkey_packed *bch2_bkey_prev_filter(struct btree *b,
 
 /* Insert */
 
+static void rw_aux_tree_build_entry(struct btree *b,
+				    struct bset_tree *t,
+				    struct bkey_packed *start,
+				    struct bkey_packed *end,
+				    unsigned l)
+{
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
+				memmove(&rw_aux_tree(b, t)[l + 1],
+					&rw_aux_tree(b, t)[l],
+					(void *) &rw_aux_tree(b, t)[t->size] -
+					(void *) &rw_aux_tree(b, t)[l]);
+				t->size++;
+				rw_aux_tree_set(b, t, l, k);
+				break;
+			}
+		}
+	}
+}
+
 static void bch2_bset_fix_lookup_table(struct btree *b,
 				       struct bset_tree *t,
 				       struct bkey_packed *_where,
@@ -899,34 +927,42 @@ static void bch2_bset_fix_lookup_table(struct btree *b,
 	if (!bset_has_rw_aux_tree(t))
 		return;
 
+	if (where > rw_aux_tree(b, t)[t->size - 1].offset) {
+build_entry:
+		rw_aux_tree_build_entry(b, t,
+					rw_aux_to_bkey(b, t, t->size - 1),
+					btree_bkey_last(b, t),
+					t->size);
+		return;
+	}
+
 	/* returns first entry >= where */
 	l = rw_aux_tree_bsearch(b, t, where);
 
-	if (!l) /* never delete first entry */
-		l++;
-	else if (l < t->size &&
-		 where < t->end_offset &&
-		 rw_aux_tree(b, t)[l].offset == where)
-		rw_aux_tree_set(b, t, l++, _where);
+	if (rw_aux_tree(b, t)[l].offset == where) {
+		if (!l) { /* never delete first entry */
+			l++;
+		} else if (where < t->end_offset) {
+			rw_aux_tree_set(b, t, l++, _where);
+		} else {
+			/* where == t->end_offset */
+			EBUG_ON(where > t->end_offset);
+			t->size--;
+			goto build_entry;
+		}
+	}
 
 	/* l now > where */
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
+	EBUG_ON(l < t->size && rw_aux_tree(b, t)[l].offset <= where);
+	if (l < t->size &&
+	    rw_aux_tree(b, t)[l].offset + shift ==
+	    rw_aux_tree(b, t)[l - 1].offset) {
+		memmove(&rw_aux_tree(b, t)[l],
+			&rw_aux_tree(b, t)[l + 1],
+			(void *) &rw_aux_tree(b, t)[t->size] -
+			(void *) &rw_aux_tree(b, t)[l + 1]);
+		t->size -= 1;
+	}
 
 	for (j = l; j < t->size; j++)
 		rw_aux_tree(b, t)[j].offset += shift;
@@ -935,34 +971,12 @@ static void bch2_bset_fix_lookup_table(struct btree *b,
 		rw_aux_tree(b, t)[l].offset ==
 		rw_aux_tree(b, t)[l - 1].offset);
 
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
-
-		while (1) {
-			k = bkey_p_next(k);
-			if (k == end)
-				break;
-
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
+	rw_aux_tree_build_entry(b, t,
+				rw_aux_to_bkey(b, t, l - 1),
+				l < t->size
+				? rw_aux_to_bkey(b, t, l)
+				: btree_bkey_last(b, t),
+				l);
 
 	bch2_bset_verify_rw_aux_tree(b, t);
 	bset_aux_tree_verify(b);
-- 
2.45.2


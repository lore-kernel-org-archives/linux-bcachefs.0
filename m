Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A643D29AB05
	for <linux-bcachefs@vger.kernel.org>; Tue, 26 Aug 2025 22:50:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756248607; cv=none; b=rcWmKgGi9cvx9yxAh6vQ/x94TJX+LwNqvIY9PGT83kHu7SKM6vgQPFOHM/6e1RVcHnOFpkElkGzXTwc27hGNiJwYOhbByJmL/5XqC6YGaEZFfR+bekzOm+2eYgME0LBqFBYWJx5cv/i1Pz4uYASHB6JdntKhxIZcJXFlrKVKdco=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756248607; c=relaxed/simple;
	bh=zC1U2DyY2SMMRJYidXE7nYOru7pGqjSyZYCypNooauM=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=kDNHx7jVznfcV5GigkxvFJAGwVzrcW57cChKygC81MH3fnjCk9HAWFPKaMyFjMqp31XGFKrEpjgiflftYkkAODDhxYByptq5NevuZG8Az0sBxdOLl8EW1nEo2n21AyqrQsXo8s8tqkmhs7nVzSeUTs077v8iT4c1M3TLCf5V2MQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qyiXfpTt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qyiXfpTt"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 63C36C19423;
	Tue, 26 Aug 2025 22:50:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756248607;
	bh=zC1U2DyY2SMMRJYidXE7nYOru7pGqjSyZYCypNooauM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=qyiXfpTtceS5CzsI/bcfcFdwGbe4M1+uLbQNdVe2wlhENzo0ne6QULNrQwyJ4zcPT
	 Qxrb4lo0Z8dsZoU0smOQAO7++X2KZ3yeKmvwBKnDFmkesKhwerMM4IRaF4O1aXhKf5
	 jwiFbeSUFNYLf8Fv3+jD/RkdVB8EKUKrlf7CFIyCQZ4j6pmKdBDMbKsqTyh2joLBCH
	 sELNfoEdEdWCimTw1h0JUUsNc/IgPFpmVRSqV6EOnEUCxKj+8oLl73BIIkQ9WlSy5W
	 9cAjWzF7tAWNADHhuDmuLx6WCXb2Hihmf/3bosQewrjPsVkAQOQdBPP4hbJJApt+SY
	 PnE4xLN3qCD3Q==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D12CCA0FF9;
	Tue, 26 Aug 2025 22:50:07 +0000 (UTC)
From: Nikita Ofitserov via B4 Relay <devnull+himikof.gmail.com@kernel.org>
Date: Wed, 27 Aug 2025 01:49:13 +0300
Subject: [PATCH 07/12] bcachefs: More accurate progress reporting for inner
 node iteration
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250827-better-progress-v1-7-74c24de7988a@gmail.com>
References: <20250827-better-progress-v1-0-74c24de7988a@gmail.com>
In-Reply-To: <20250827-better-progress-v1-0-74c24de7988a@gmail.com>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: linux-bcachefs@vger.kernel.org, Nikita Ofitserov <himikof@gmail.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=3496; i=himikof@gmail.com;
 h=from:subject:message-id;
 bh=+yss3zKdgUo3M11y90XdgozWvwalA2Ur+GHO8RDFz14=;
 b=owGbwMvMwCW2edHtzWZP9DIYT6slMWSss5J5cuXmrKkLp5oKb7i//pfdkes9J8JrRJZGX92yx
 36C1wIdtY5SFgYxLgZZMUWWD0u+/lmTaf3HUmivIcwcViaQIQxcnAIwkYlfGf6neZs82bUqPNq6
 TTRm0bmihGe2odd3TlIQ8VGI0WJrfbKNkWH/r9a8Nj5pyXuHLt78Uv3ol9v0yW3fpNLmXHf//If
 h3iZmAA==
X-Developer-Key: i=himikof@gmail.com; a=openpgp;
 fpr=F0A4F5FCAC693BFC3912BD31B3A2DBB336E42E68
X-Endpoint-Received: by B4 Relay for himikof@gmail.com/default with
 auth_id=452
X-Original-From: Nikita Ofitserov <himikof@gmail.com>
Reply-To: himikof@gmail.com

From: Nikita Ofitserov <himikof@gmail.com>

Signed-off-by: Nikita Ofitserov <himikof@gmail.com>
---
 fs/bcachefs/backpointers.c |  4 +++-
 fs/bcachefs/btree_gc.c     | 13 +++++--------
 fs/bcachefs/migrate.c      | 13 +++++++++----
 3 files changed, 17 insertions(+), 13 deletions(-)

diff --git a/fs/bcachefs/backpointers.c b/fs/bcachefs/backpointers.c
index 0d585e5662be3f02580558e9a590075ea73193d5..42370aebb7a442ee368df323eb1f4970f2e5f949 100644
--- a/fs/bcachefs/backpointers.c
+++ b/fs/bcachefs/backpointers.c
@@ -804,7 +804,9 @@ static int bch2_check_extents_to_backpointers_pass(struct btree_trans *trans,
 	struct progress_indicator_state progress;
 	int ret = 0;
 
-	bch2_progress_init(&progress, trans->c, BIT_ULL(BTREE_ID_extents)|BIT_ULL(BTREE_ID_reflink));
+	bch2_progress_init_inner(&progress, trans->c,
+		btree_has_data_ptrs_mask,
+		~0ULL);
 
 	for (enum btree_id btree_id = 0;
 	     btree_id < btree_id_nr_alive(c);
diff --git a/fs/bcachefs/btree_gc.c b/fs/bcachefs/btree_gc.c
index 006bdd5c90bc805219d4e38923135986425ccf17..b89e12a3112868f175d028ce9745c8b4944ca747 100644
--- a/fs/bcachefs/btree_gc.c
+++ b/fs/bcachefs/btree_gc.c
@@ -717,16 +717,12 @@ static int bch2_gc_mark_key(struct btree_trans *trans, enum btree_id btree_id,
 
 static int bch2_gc_btree(struct btree_trans *trans,
 			 struct progress_indicator_state *progress,
-			 enum btree_id btree, bool initial)
+			 enum btree_id btree, unsigned target_depth,
+			 bool initial)
 {
 	struct bch_fs *c = trans->c;
-	unsigned target_depth = BIT_ULL(btree) & btree_leaf_has_triggers_mask ? 0 : 1;
 	int ret = 0;
 
-	/* We need to make sure every leaf node is readable before going RW */
-	if (initial)
-		target_depth = 0;
-
 	for (unsigned level = target_depth; level < BTREE_MAX_DEPTH; level++) {
 		struct btree *prev = NULL;
 		struct btree_iter iter;
@@ -784,7 +780,7 @@ static int bch2_gc_btrees(struct bch_fs *c)
 	int ret = 0;
 
 	struct progress_indicator_state progress;
-	bch2_progress_init(&progress, c, ~0ULL);
+	bch2_progress_init_inner(&progress, c, ~0ULL, ~0ULL);
 
 	enum btree_id ids[BTREE_ID_NR];
 	for (unsigned i = 0; i < BTREE_ID_NR; i++)
@@ -797,7 +793,8 @@ static int bch2_gc_btrees(struct bch_fs *c)
 		if (IS_ERR_OR_NULL(bch2_btree_id_root(c, btree)->b))
 			continue;
 
-		ret = bch2_gc_btree(trans, &progress, btree, true);
+		/* We need to make sure every leaf node is readable before going RW */
+		ret = bch2_gc_btree(trans, &progress, btree, 0, true);
 	}
 
 	bch_err_fn(c, ret);
diff --git a/fs/bcachefs/migrate.c b/fs/bcachefs/migrate.c
index 41657deb0e3807f4968272491faea09d05ec2299..0ef576ec45c7310423cf7cdf902cad30dba257db 100644
--- a/fs/bcachefs/migrate.c
+++ b/fs/bcachefs/migrate.c
@@ -265,10 +265,15 @@ int bch2_dev_data_drop_by_backpointers(struct bch_fs *c, unsigned dev_idx, unsig
 int bch2_dev_data_drop(struct bch_fs *c, unsigned dev_idx, unsigned flags)
 {
 	struct progress_indicator_state progress;
+	int ret;
+
 	bch2_progress_init(&progress, c,
-			   BIT_ULL(BTREE_ID_extents)|
-			   BIT_ULL(BTREE_ID_reflink));
+			   btree_has_data_ptrs_mask & ~BIT_ULL(BTREE_ID_stripes));
+
+	if ((ret = bch2_dev_usrdata_drop(c, &progress, dev_idx, flags)))
+		return ret;
+
+	bch2_progress_init_inner(&progress, c, 0, ~0ULL);
 
-	return bch2_dev_usrdata_drop(c, &progress, dev_idx, flags) ?:
-		bch2_dev_metadata_drop(c, &progress, dev_idx, flags);
+	return bch2_dev_metadata_drop(c, &progress, dev_idx, flags);
 }

-- 
2.50.1



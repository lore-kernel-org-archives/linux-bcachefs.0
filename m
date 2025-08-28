Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64C653101B1
	for <linux-bcachefs@vger.kernel.org>; Thu, 28 Aug 2025 14:16:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756390597; cv=none; b=fm3sBkBiSnS/2SsuUiakrFEKcC/iuilpeZTi2LLfA5Ov9TmxyOBzMO2mW3ypGJuYtvA0Bvjbz/EYy8PNZYICmzHWKsyIHc8GWwCE3iPqoP82bxUeDElBtNWHcgZKGpSAw1c2BblyrSgyzyIUJGqYvCjmcu/kLwdl7lUuCrmbM4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756390597; c=relaxed/simple;
	bh=YxR4aUb6GdLdn02G0HttK4qU0Mi3o7OIhJKad270pTI=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Ua/h4fgc0CM547RM5nuog2s5wuyC8EvZ1Rzoiz/+V8VTxJwwSvBwEJvU6wsOzmolXofPHmhaUBhDOa0vTrjwOUfdH8cnl+9iJ9klaCvAY9+zf3moEdwWVpNnOukrWngEOsmgP5DaGL5kCAKomx+il6+VF8B543grAUiHiGqONug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HjlxP4gF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HjlxP4gF"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3CFA6C4CEF9;
	Thu, 28 Aug 2025 14:16:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756390597;
	bh=YxR4aUb6GdLdn02G0HttK4qU0Mi3o7OIhJKad270pTI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=HjlxP4gF9Oay/cDJDMFHSPdo1HNK8ObrIzN/mit4JJUKxZa7fmHHZUlg+4+flwfXZ
	 yug2I7qTbnCCCMDIxCitrJwyJuPJRScxL3XSMdy7M8vZcShPCsYJqlE94QZ+49qSxx
	 D3QYRDw+uPJpOfzc5SP0RKQc4dWxlORraMjzerISFU1T0OrrReLCV6gmgXT4A95JUX
	 df/eKe5vMaB3FC0xUh1mhvBeOGahr9W94zM5NBuE3jVy8uc9r8U0o9Dy1X8EdYvmIh
	 KjQTTRCHe5LZmKkvNA2ZaoCCa/d2wP6eII0pojeukbbZgWjGgPurysbD7QlEZfsWZE
	 2lNf6avn8xk9A==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32428CA0FFE;
	Thu, 28 Aug 2025 14:16:37 +0000 (UTC)
From: Nikita Ofitserov via B4 Relay <devnull+himikof.gmail.com@kernel.org>
Date: Thu, 28 Aug 2025 17:16:06 +0300
Subject: [PATCH v2 04/15] bcachefs: Refactor/rename btree_type_has_ptrs
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250828-better-progress-v2-4-c088a2003940@gmail.com>
References: <20250828-better-progress-v2-0-c088a2003940@gmail.com>
In-Reply-To: <20250828-better-progress-v2-0-c088a2003940@gmail.com>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: linux-bcachefs@vger.kernel.org, Nikita Ofitserov <himikof@gmail.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=3458; i=himikof@gmail.com;
 h=from:subject:message-id;
 bh=IuZJZ03aibJ8jGB9VpKaLkA4EcKTVOpHE7yXTpzrRlM=;
 b=owGbwMvMwCW2edHtzWZP9DIYT6slMWRsSDnon/pFZO39c+bLeKNYgjLrQ82r1CYopfj8X6r+P
 4ExYW1nRykLgxgXg6yYIsuHJV//rMm0/mMptNcQZg4rE8gQBi5OAZhIHh/D/+pri0Q+3whMOBRd
 ZcB8YfZmoSWJcVltEysqeyXyag4fLWf4Z76k649swp3gt7M4JrOIMu/8ct28VyfN9Myuo/e5L07
 cxgQA
X-Developer-Key: i=himikof@gmail.com; a=openpgp;
 fpr=F0A4F5FCAC693BFC3912BD31B3A2DBB336E42E68
X-Endpoint-Received: by B4 Relay for himikof@gmail.com/default with
 auth_id=452
X-Original-From: Nikita Ofitserov <himikof@gmail.com>
Reply-To: himikof@gmail.com

From: Nikita Ofitserov <himikof@gmail.com>

The new name (btree_type_has_data_ptrs) better reflects the meaning.
Also introduce the explicit mask constant.

Signed-off-by: Nikita Ofitserov <himikof@gmail.com>
---
 fs/bcachefs/backpointers.c | 2 +-
 fs/bcachefs/btree_gc.c     | 2 +-
 fs/bcachefs/btree_types.h  | 8 ++++----
 fs/bcachefs/migrate.c      | 2 +-
 fs/bcachefs/move.c         | 2 +-
 5 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/fs/bcachefs/backpointers.c b/fs/bcachefs/backpointers.c
index cb25cddb759b84bed48c653605ba195218f2140c..0d585e5662be3f02580558e9a590075ea73193d5 100644
--- a/fs/bcachefs/backpointers.c
+++ b/fs/bcachefs/backpointers.c
@@ -809,7 +809,7 @@ static int bch2_check_extents_to_backpointers_pass(struct btree_trans *trans,
 	for (enum btree_id btree_id = 0;
 	     btree_id < btree_id_nr_alive(c);
 	     btree_id++) {
-		int level, depth = btree_type_has_ptrs(btree_id) ? 0 : 1;
+		int level, depth = btree_type_has_data_ptrs(btree_id) ? 0 : 1;
 
 		ret = commit_do(trans, NULL, NULL,
 				BCH_TRANS_COMMIT_no_enospc,
diff --git a/fs/bcachefs/btree_gc.c b/fs/bcachefs/btree_gc.c
index b95a3610900de2eecf978c62f3809453455f7a5c..2338feb8d8ed4bad85a01a6b9181116d918636b5 100644
--- a/fs/bcachefs/btree_gc.c
+++ b/fs/bcachefs/btree_gc.c
@@ -1238,7 +1238,7 @@ int bch2_gc_gens(struct bch_fs *c)
 	}
 
 	for (unsigned i = 0; i < BTREE_ID_NR; i++)
-		if (btree_type_has_ptrs(i)) {
+		if (btree_type_has_data_ptrs(i)) {
 			c->gc_gens_btree = i;
 			c->gc_gens_pos = POS_MIN;
 
diff --git a/fs/bcachefs/btree_types.h b/fs/bcachefs/btree_types.h
index ad9bd18fe9b6e51987da74d373830dca98df56ec..d06991c16d5c24c586e9449efa9553e2b8593bd4 100644
--- a/fs/bcachefs/btree_types.h
+++ b/fs/bcachefs/btree_types.h
@@ -886,15 +886,15 @@ static inline bool btree_type_has_snapshot_field(enum btree_id btree)
 	return BIT_ULL(btree) & mask;
 }
 
-static inline bool btree_type_has_ptrs(enum btree_id btree)
-{
-	const u64 mask = 0
+static const u64 btree_has_data_ptrs_mask = 0
 #define x(name, nr, flags, ...)	|((!!((flags) & BTREE_IS_data)) << nr)
 	BCH_BTREE_IDS()
 #undef x
 	;
 
-	return BIT_ULL(btree) & mask;
+static inline bool btree_type_has_data_ptrs(enum btree_id btree)
+{
+	return BIT_ULL(btree) & btree_has_data_ptrs_mask;
 }
 
 static inline bool btree_type_uses_write_buffer(enum btree_id btree)
diff --git a/fs/bcachefs/migrate.c b/fs/bcachefs/migrate.c
index 892990b4a6a6b16785e5030e5dc7cf15b05c0fc5..41657deb0e3807f4968272491faea09d05ec2299 100644
--- a/fs/bcachefs/migrate.c
+++ b/fs/bcachefs/migrate.c
@@ -122,7 +122,7 @@ static int bch2_dev_usrdata_drop(struct bch_fs *c,
 	CLASS(btree_trans, trans)(c);
 
 	for (unsigned id = 0; id < BTREE_ID_NR; id++) {
-		if (!btree_type_has_ptrs(id))
+		if (!btree_type_has_data_ptrs(id))
 			continue;
 
 		/* Stripe keys have pointers, but are handled separately */
diff --git a/fs/bcachefs/move.c b/fs/bcachefs/move.c
index 4f41f1f6ec6c7fe6af663e11b3479fde02832ef9..1cd81380c7d87ebc446a874f2f4a208442d0c577 100644
--- a/fs/bcachefs/move.c
+++ b/fs/bcachefs/move.c
@@ -820,7 +820,7 @@ static int bch2_move_data(struct bch_fs *c,
 		unsigned min_depth_this_btree = min_depth;
 
 		/* Stripe keys have pointers, but are handled separately */
-		if (!btree_type_has_ptrs(id) ||
+		if (!btree_type_has_data_ptrs(id) ||
 		    id == BTREE_ID_stripes)
 			min_depth_this_btree = max(min_depth_this_btree, 1);
 

-- 
2.50.1



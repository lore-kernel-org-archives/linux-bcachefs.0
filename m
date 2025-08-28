Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 632B630FC2F
	for <linux-bcachefs@vger.kernel.org>; Thu, 28 Aug 2025 14:16:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756390597; cv=none; b=NN7ofvOOQz/nu1ovjHnsw5v/CmQvZr1OPrsx/BNOVPFzygJJODU3qjtHNsErruVx7V0sHjSYsgFHYbbFvNKmVqCQRkymvR5dBjVCStXBoNwjasAzXoPB/Oh7U232y54r8+XbGAHRKOlkwGZmnaKoLtIYUvwE2GhoB+6il9os8fg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756390597; c=relaxed/simple;
	bh=aBs+yP9YbCt/4MZN8wE8KxxrIEfYM8zRS1Atk+Peqp8=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=XrDv3qmE1sKzhSHNQLMgKXJtOv7PnfTISqrJICzPD+o6DtiUgYCYdr8CMBJjhO3JJYJngQTkdV6Mkrtp+0yiwuZF0NK6cRWjTN5Kk1ZJEYbmN5Pd94ViLkWdCxNf/gN0n8yIYtJWh9AsrcPUmWQlQF+0Uw07fDBmkTAfsTdhb30=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GE9V92ls; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GE9V92ls"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 11FBAC4CEF5;
	Thu, 28 Aug 2025 14:16:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756390597;
	bh=aBs+yP9YbCt/4MZN8wE8KxxrIEfYM8zRS1Atk+Peqp8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=GE9V92ls7s38xcc0dh+3CJKpBsPEZ9GlPBpyGamMhYA47QlnNVhQSxOTfKwPGf0WH
	 q6B2quOIwPsfEnbqE39c7wP918S+LYYd4vuKinhsHJgJj3q97QMmNm24ArsTx4jHio
	 ty37Wz/SvMuwrHAvOFgNZF7gH1ZZ5Uq8aVRA3yfCU9+U1BzTlTaRQ83CilP1K0Z5Z0
	 suGK1uWbkJ3uHyPEuvBm1NIpZnRnHnTO03nIWjoO+/Ix/EYh34k+3Pil34abSS/BVq
	 CQpGTcxEImcx/85ZRHTX5V/9OjvKlG/Qs9E7BfVoC4GOIO4yJ7sYPsfE3M7bNm1vGV
	 MwBhG2j7K9mJg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00978CA0EED;
	Thu, 28 Aug 2025 14:16:37 +0000 (UTC)
From: Nikita Ofitserov via B4 Relay <devnull+himikof.gmail.com@kernel.org>
Date: Thu, 28 Aug 2025 17:16:03 +0300
Subject: [PATCH v2 01/15] bcachefs: Introduce btree_leaf_has_triggers_mask
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250828-better-progress-v2-1-c088a2003940@gmail.com>
References: <20250828-better-progress-v2-0-c088a2003940@gmail.com>
In-Reply-To: <20250828-better-progress-v2-0-c088a2003940@gmail.com>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: linux-bcachefs@vger.kernel.org, Nikita Ofitserov <himikof@gmail.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=1519; i=himikof@gmail.com;
 h=from:subject:message-id;
 bh=TYWLHU8w0/8UTBK1GkJbIUDQjni0TKSNwZ+FHNlfT2A=;
 b=owGbwMvMwCW2edHtzWZP9DIYT6slMWRsSDmYUaZ0VUCe0TZrVsbCrU1fOsKqTZiCPi/t1PMye
 /iufW1hRykLgxgXg6yYIsuHJV//rMm0/mMptNcQZg4rE8gQBi5OAZiI6E2Gf4ZneoOZX9S6T5i3
 zndpYs3shewV7jcfu554bs97hff/jVqGv8KlE7/p2Jy4r/6/pcmoykfoYqv8Mv1dRertsdvr2nd
 NZgEA
X-Developer-Key: i=himikof@gmail.com; a=openpgp;
 fpr=F0A4F5FCAC693BFC3912BD31B3A2DBB336E42E68
X-Endpoint-Received: by B4 Relay for himikof@gmail.com/default with
 auth_id=452
X-Original-From: Nikita Ofitserov <himikof@gmail.com>
Reply-To: himikof@gmail.com

From: Nikita Ofitserov <himikof@gmail.com>

Signed-off-by: Nikita Ofitserov <himikof@gmail.com>
---
 fs/bcachefs/btree_gc.c    | 2 +-
 fs/bcachefs/btree_types.h | 3 +++
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/bcachefs/btree_gc.c b/fs/bcachefs/btree_gc.c
index 43f294284d57473fd8868c974c4bdd847fcf2636..2b1b6b7ffdf0af7ec0bf4cbaf68cc9a53a20cfce 100644
--- a/fs/bcachefs/btree_gc.c
+++ b/fs/bcachefs/btree_gc.c
@@ -720,7 +720,7 @@ static int bch2_gc_btree(struct btree_trans *trans,
 			 enum btree_id btree, bool initial)
 {
 	struct bch_fs *c = trans->c;
-	unsigned target_depth = btree_node_type_has_triggers(__btree_node_type(0, btree)) ? 0 : 1;
+	unsigned target_depth = BIT_ULL(btree) & btree_leaf_has_triggers_mask ? 0 : 1;
 	int ret = 0;
 
 	/* We need to make sure every leaf node is readable before going RW */
diff --git a/fs/bcachefs/btree_types.h b/fs/bcachefs/btree_types.h
index e893eb938bb3da441f0ab0096ced3cc3c2a701e2..ad9bd18fe9b6e51987da74d373830dca98df56ec 100644
--- a/fs/bcachefs/btree_types.h
+++ b/fs/bcachefs/btree_types.h
@@ -840,6 +840,9 @@ static inline bool btree_node_type_has_triggers(enum btree_node_type type)
 	return BIT_ULL(type) & BTREE_NODE_TYPE_HAS_TRIGGERS;
 }
 
+/* A mask of btree id bits that have triggers for their leaves */
+static const u64 btree_leaf_has_triggers_mask = BTREE_NODE_TYPE_HAS_TRIGGERS >> 1;
+
 static const u64 btree_is_extents_mask = 0
 #define x(name, nr, flags, ...)	|((!!((flags) & BTREE_IS_extents)) << nr)
 BCH_BTREE_IDS()

-- 
2.50.1



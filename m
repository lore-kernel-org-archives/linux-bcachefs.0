Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2EF52BE7A7
	for <linux-bcachefs@vger.kernel.org>; Tue, 26 Aug 2025 22:50:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756248607; cv=none; b=pv9Mxqu9IeDz+H6qnx5J/pulrXCtPWPdVVNKTw0OkqSNz69Vqeu4tJYPPI+XwJGR1vsNSGLIAZCF/Gc9QgrHKL2qmtVXH6uo960qW8tGw/lHNOZdkuqth2P5fUamMx7hg3KAJCC0K64XaqdV5FRuhku6RYzCxtxZBjQLrzHzX9M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756248607; c=relaxed/simple;
	bh=aBs+yP9YbCt/4MZN8wE8KxxrIEfYM8zRS1Atk+Peqp8=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=TxvORouYUoplUIqnAEf+527Oac3/aQcTynYIlCRuc3jtV8vSgZYy9T1i9autsNNAKGG/f1BIMQoCXyPbx72USfq5gx+CrQVQ1l1AykRM/SMej+2NKWPOBH6YKZsIZcOYx0+EPErgVP3KSR4jSFGD428ADuG8Zq9lKI9W5w/gwEk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rn1924q1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rn1924q1"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 43E4DC16AAE;
	Tue, 26 Aug 2025 22:50:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756248607;
	bh=aBs+yP9YbCt/4MZN8wE8KxxrIEfYM8zRS1Atk+Peqp8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=rn1924q18Npk0FG+uFSAcLJryuVj/brxiktQihJhIKvGxpiT3sg6r/xf1nW8I7kV7
	 dCHRyIc57gF/k1kvjK2XJQQSSIBp6dU5Sgst4n5qU1vDQaHv3HvhLKAJe6uJTws3Qf
	 Aj1JXdZ8bctDdzReCgI0f6DEexYtNY0iRIcGBcoJTeB6SAF4P8lOlDF8o25C8pYFcR
	 VJajP0MpB82C0MDR4Q4qkOPs7DgWNN3L6a1wDrSMg2uTY0ZovaR26zUpOV2njBq2Ki
	 vk0Xe533PAnn8gBedJPY5VILMfJwghgtzTi5QY0yON6Fa7qy3p5tx7tmhwMrYQSMu5
	 f5tO0KUtWp2qg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3CB10CA0FF9;
	Tue, 26 Aug 2025 22:50:07 +0000 (UTC)
From: Nikita Ofitserov via B4 Relay <devnull+himikof.gmail.com@kernel.org>
Date: Wed, 27 Aug 2025 01:49:10 +0300
Subject: [PATCH 04/12] bcachefs: Introduce btree_leaf_has_triggers_mask
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250827-better-progress-v1-4-74c24de7988a@gmail.com>
References: <20250827-better-progress-v1-0-74c24de7988a@gmail.com>
In-Reply-To: <20250827-better-progress-v1-0-74c24de7988a@gmail.com>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: linux-bcachefs@vger.kernel.org, Nikita Ofitserov <himikof@gmail.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=1519; i=himikof@gmail.com;
 h=from:subject:message-id;
 bh=TYWLHU8w0/8UTBK1GkJbIUDQjni0TKSNwZ+FHNlfT2A=;
 b=owGbwMvMwCW2edHtzWZP9DIYT6slMWSss5KZd/Cy8E+T+TG/L916uzzlTD7LYZlEb7MIHt0tX
 96wJkyL7yhlYRDjYpAVU2T5sOTrnzWZ1n8shfYawsxhZQIZwsDFKQATYfnJyNAXrvTomcj+GNYn
 SgqX1onNU5t/9N00yZkRZ87YbuoIfZvIyHCn2eCyk8Dzcx4HLZ0bH/P57/nSwPrQbK/UkYerdB5
 /EeIDAA==
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



Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 794292853E9
	for <linux-bcachefs@vger.kernel.org>; Tue, 26 Aug 2025 22:50:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756248607; cv=none; b=TYb6CH0sO8KWK3n+uE0xur70OmkGdrszVUR/9R8kD6qXpGf+ORzSSI6aRYQubW9WOELCceUhYSBDK71fQ3ODIAADc3e153tZlOLOQj3WWeMED75PE33zQcosuf4UijrnxdAACMFOQs4fR6YwSQNpLN9iH5lVDWUF2zyUuliMrvU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756248607; c=relaxed/simple;
	bh=aFwOmrlBAJSq/JuN0AhbaSxdSmZhWtq7tE6EwixhVWk=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=aC8DDRcfgP+iY60IWLDno5MFm03e2wAkpc598OV2i6ufz7B+0F7jg/xWBQ4WfVG2NVQ/kAW8qYLx2u+xiLMctwZYvusCkaYIPH9ha93DbtJdRD35fgEMiu7Wm6I9vxUbBiVJ6pfXKBvf30Gzv49fi8B+XG7QXJskVLOgNPkAyYw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=agK9CAtE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="agK9CAtE"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2C04BC116C6;
	Tue, 26 Aug 2025 22:50:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756248607;
	bh=aFwOmrlBAJSq/JuN0AhbaSxdSmZhWtq7tE6EwixhVWk=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=agK9CAtEb+/uHboBInV+xVIBqVudoT8J75ObE6EpMGP/MncDjOPbBvnrOwZ764ORr
	 2gT5yDWiPvEenKSJArKHRTtTd0+e5Ww7AtfyFBKcc9YQ4u4xFWAx9uNzqFlhAy/Wv5
	 +Xz7xhT09wNBQxduBimbUMHNCuOFf/5ZYa7NbC3ejm/PyfoYg0gbO0ca9QtWp9NwaF
	 9RFB/cIxYmP5b4BptoOz/SzfL5e/JzklUoSTqBY/qplX+Vh2uOlTfMy91iLY6chZ7s
	 olqbDW9NiV4EgjpO5cjhVBwKK+LQ/quTesfJNs6P3uz8TcycNrjo+GhhcIAaPXDWzv
	 8h9AkhbjJsTEQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E1C2CA0FED;
	Tue, 26 Aug 2025 22:50:07 +0000 (UTC)
From: Nikita Ofitserov via B4 Relay <devnull+himikof.gmail.com@kernel.org>
Date: Wed, 27 Aug 2025 01:49:08 +0300
Subject: [PATCH 02/12] bcachefs: Introduce btree node number accounting
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250827-better-progress-v1-2-74c24de7988a@gmail.com>
References: <20250827-better-progress-v1-0-74c24de7988a@gmail.com>
In-Reply-To: <20250827-better-progress-v1-0-74c24de7988a@gmail.com>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: linux-bcachefs@vger.kernel.org, Nikita Ofitserov <himikof@gmail.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=3296; i=himikof@gmail.com;
 h=from:subject:message-id;
 bh=zwjI5tCeCHw8e+Z7T2bZ8UaDq7Mjfrnlgre8FzWRL8g=;
 b=owGbwMvMwCW2edHtzWZP9DIYT6slMWSss5KR/R35wG5y3YQbe55n+uy+fyX35Q9Z8U6daIYVs
 gt56yrCOkpZGMS4GGTFFFk+LPn6Z02m9R9Lob2GMHNYmUCGMHBxCsBELF8wMqxPfCoudjH9d31O
 3fEJirMaGr4Y3FomzrrwgJu7edgDiTyGv1J87y46Crdt9JAr2f1QaNc35rUSckcmXpWZ++LAUmv
 DnSwA
X-Developer-Key: i=himikof@gmail.com; a=openpgp;
 fpr=F0A4F5FCAC693BFC3912BD31B3A2DBB336E42E68
X-Endpoint-Received: by B4 Relay for himikof@gmail.com/default with
 auth_id=452
X-Original-From: Nikita Ofitserov <himikof@gmail.com>
Reply-To: himikof@gmail.com

From: Nikita Ofitserov <himikof@gmail.com>

Add 2 new counters for BCH_DISK_ACCOUNTING_btree: total number of btree
nodes (ignoring replication) and the number of non-leaf btree nodes
(likewise). Those are to be used by recovery progress reporting instead
 of estimating them.

This commit is missing the required upgrade/downgrade entries and
should be included only together with other accounting updates!

Signed-off-by: Nikita Ofitserov <himikof@gmail.com>
---
 fs/bcachefs/buckets.c                | 16 +++++++++++-----
 fs/bcachefs/disk_accounting_format.h | 10 +++++++++-
 2 files changed, 20 insertions(+), 6 deletions(-)

diff --git a/fs/bcachefs/buckets.c b/fs/bcachefs/buckets.c
index 021f5cb7998de704be9d135064af2817cb2c52fe..99e928f7799971d052f24ba6043eb54765cf42b9 100644
--- a/fs/bcachefs/buckets.c
+++ b/fs/bcachefs/buckets.c
@@ -749,6 +749,7 @@ static int __trigger_extent(struct btree_trans *trans,
 			    enum btree_iter_update_trigger_flags flags)
 {
 	bool gc = flags & BTREE_TRIGGER_gc;
+	bool insert = !(flags & BTREE_TRIGGER_overwrite);
 	struct bkey_ptrs_c ptrs = bch2_bkey_ptrs_c(k);
 	const union bch_extent_entry *entry;
 	struct extent_ptr_decoded p;
@@ -802,7 +803,7 @@ static int __trigger_extent(struct btree_trans *trans,
 
 		if (cur_compression_type &&
 		    cur_compression_type != p.crc.compression_type) {
-			if (flags & BTREE_TRIGGER_overwrite)
+			if (!insert)
 				bch2_u64s_neg(compression_acct, ARRAY_SIZE(compression_acct));
 
 			ret = bch2_disk_accounting_mod2(trans, gc, compression_acct,
@@ -835,7 +836,7 @@ static int __trigger_extent(struct btree_trans *trans,
 	}
 
 	if (cur_compression_type) {
-		if (flags & BTREE_TRIGGER_overwrite)
+		if (!insert)
 			bch2_u64s_neg(compression_acct, ARRAY_SIZE(compression_acct));
 
 		ret = bch2_disk_accounting_mod2(trans, gc, compression_acct,
@@ -845,12 +846,17 @@ static int __trigger_extent(struct btree_trans *trans,
 	}
 
 	if (level) {
-		ret = bch2_disk_accounting_mod2_nr(trans, gc, &replicas_sectors, 1, btree, btree_id);
+		const bool leaf_node = level == 1;
+		s64 v[3] = {
+			replicas_sectors,
+			insert ? 1 : -1,
+			!leaf_node ? (insert ? 1 : -1) : 0,
+		};
+
+		ret = bch2_disk_accounting_mod2(trans, gc, v, btree, btree_id);
 		if (ret)
 			return ret;
 	} else {
-		bool insert = !(flags & BTREE_TRIGGER_overwrite);
-
 		s64 v[3] = {
 			insert ? 1 : -1,
 			insert ? k.k->size : -((s64) k.k->size),
diff --git a/fs/bcachefs/disk_accounting_format.h b/fs/bcachefs/disk_accounting_format.h
index 8269af1dbe2a094454f780194f4ece33c4a4e461..730a17ea42431012282cec9d7803b0ac0b1d339d 100644
--- a/fs/bcachefs/disk_accounting_format.h
+++ b/fs/bcachefs/disk_accounting_format.h
@@ -108,7 +108,7 @@ static inline bool data_type_is_hidden(enum bch_data_type type)
 	x(dev_data_type,	3,	3)	\
 	x(compression,		4,	3)	\
 	x(snapshot,		5,	1)	\
-	x(btree,		6,	1)	\
+	x(btree,		6,	3)	\
 	x(rebalance_work,	7,	1)	\
 	x(inum,			8,	3)
 
@@ -174,6 +174,14 @@ struct bch_acct_snapshot {
 	__u32			id;
 } __packed;
 
+/*
+ * Metadata accounting per btree id:
+ * [
+ *   total btree disk usage in sectors
+ *   total number of btree nodes
+ *   number of non-leaf btree nodes
+ * ]
+ */
 struct bch_acct_btree {
 	__u32			id;
 } __packed;

-- 
2.50.1



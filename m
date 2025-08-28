Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED7EF31CA4E
	for <linux-bcachefs@vger.kernel.org>; Thu, 28 Aug 2025 14:16:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756390598; cv=none; b=LvR9FAWXriKqVqHYWSWkiGlTuE4wR/G7p7jVO2w41OjG+fP1dNNY2gyFPmwyGMi8nqOQ2uHVhWqSvKHjE0/fzfjZCKBySvV0vih0Bbefz2l/CILAKMwGX/2ksOGNUrdFbGt3J3unEu7UVDkiNGxIwIfYOSf17zCUZAbn5i+Jma8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756390598; c=relaxed/simple;
	bh=ruOiu72MVXfinVOxDiZEBKpf2vN4zgoJAC7/ENioTmo=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=NKyjZRsXzeqmBp4BuRPdc/AZnnPyEIUw35uYpED7+AaXdm6htRrjkR4J7LE5cU0yYrEfGdL/gNsyc+9HvtUo0xP1Zt4sdcWAvj4DxnakJOzbltvlT0JKUAleIdj3omiNPLq6Iw4ybf2hG7TObpDO5xCeoHRLVdyqNtUHnIoxDvU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bZYGzMUb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bZYGzMUb"
Received: by smtp.kernel.org (Postfix) with ESMTPS id D307FC4CEFA;
	Thu, 28 Aug 2025 14:16:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756390597;
	bh=ruOiu72MVXfinVOxDiZEBKpf2vN4zgoJAC7/ENioTmo=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=bZYGzMUb89lv/J80cpX28Tq+aSmdMRYaJ5E4h8rn+qUgydXhRimOWkdOS9xDIeHEw
	 UghyqvtuNcxsZoHFDk08huIHhCgrgnAeHd9JEGZ/KPueYi4dWHubOzmbDUIFv0giNK
	 IXKtFd9h79hGsWeRhgXRxIkM+TbvM5wmFQkxeNDFpDKKiLjGcLnjKFUntRP3pvVmlX
	 Rpcn70SACYGCAzzplruCv4NB6H9tojN5/pefa6YyxI2OhajqjHpIQlgnbyjZaJsbR8
	 z6hU8aSdL/rIGjX8ONC5ouCdniB1q7tGGnn/d7uBE/vNHUtBPSw397S8PuPJfGu//M
	 69x4Akh2hE74Q==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9E45CA0FF9;
	Thu, 28 Aug 2025 14:16:37 +0000 (UTC)
From: Nikita Ofitserov via B4 Relay <devnull+himikof.gmail.com@kernel.org>
Date: Thu, 28 Aug 2025 17:16:16 +0300
Subject: [PATCH v2 14/15] bcachefs: Better progress reporting for btree
 iteration without leaves
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250828-better-progress-v2-14-c088a2003940@gmail.com>
References: <20250828-better-progress-v2-0-c088a2003940@gmail.com>
In-Reply-To: <20250828-better-progress-v2-0-c088a2003940@gmail.com>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: linux-bcachefs@vger.kernel.org, Nikita Ofitserov <himikof@gmail.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=2715; i=himikof@gmail.com;
 h=from:subject:message-id;
 bh=wRKn0+FpY3mQVliUpbvtIlpx5Xz4Yan6xBO1SABanUM=;
 b=owGbwMvMwCW2edHtzWZP9DIYT6slMWRsSDmUuvlZgkmN7dW1549erufYdXin988pB6K/7BTZ+
 03z0+7S/o5SFgYxLgZZMUWWD0u+/lmTaf3HUmivIcwcViaQIQxcnAIwEeEshv/VIbaXs60v6new
 LWvdo1Mq+aT4BfNdOdHLzZuydSe+FP3OyPAndIo0l0vggrYlTz4sjVlYveDNtcNbnh3/GlvWc/G
 /dgIPAA==
X-Developer-Key: i=himikof@gmail.com; a=openpgp;
 fpr=F0A4F5FCAC693BFC3912BD31B3A2DBB336E42E68
X-Endpoint-Received: by B4 Relay for himikof@gmail.com/default with
 auth_id=452
X-Original-From: Nikita Ofitserov <himikof@gmail.com>
Reply-To: himikof@gmail.com

From: Nikita Ofitserov <himikof@gmail.com>

Signed-off-by: Nikita Ofitserov <himikof@gmail.com>
---
 fs/bcachefs/progress.c | 17 +++++++++++++----
 fs/bcachefs/progress.h | 12 +++++++++++-
 2 files changed, 24 insertions(+), 5 deletions(-)

diff --git a/fs/bcachefs/progress.c b/fs/bcachefs/progress.c
index 8181f6d2ca3808f57bef179383bd969d9a375d5f..7cc16490ffa98fec34ff228cb56bd1af0f42da3d 100644
--- a/fs/bcachefs/progress.c
+++ b/fs/bcachefs/progress.c
@@ -4,9 +4,10 @@
 #include "disk_accounting.h"
 #include "progress.h"
 
-void bch2_progress_init(struct progress_indicator_state *s,
-			struct bch_fs *c,
-			u64 btree_id_mask)
+void bch2_progress_init_inner(struct progress_indicator_state *s,
+			      struct bch_fs *c,
+			      u64 leaf_btree_id_mask,
+			      u64 inner_btree_id_mask)
 {
 	memset(s, 0, sizeof(*s));
 
@@ -16,6 +17,8 @@ void bch2_progress_init(struct progress_indicator_state *s,
 	const u32 expected_node_disk_sectors =
 		READ_ONCE(c->opts.metadata_replicas) * btree_sectors(c);
 
+	const u64 btree_id_mask = leaf_btree_id_mask | inner_btree_id_mask;
+
 	for (unsigned i = 0; i < btree_id_nr_alive(c); i++) {
 		if (!(btree_id_mask & BIT_ULL(i)))
 			continue;
@@ -31,11 +34,17 @@ void bch2_progress_init(struct progress_indicator_state *s,
 		bch2_accounting_mem_read(c, disk_accounting_pos_to_bpos(&acc),
 			(u64 *)&v, sizeof(v) / sizeof(u64));
 
+		/* Better to estimate as 0 than the total node count */
+		if (inner_btree_id_mask & BIT_ULL(i))
+			s->nodes_total += v.inner_nodes;
+
+		if (!(leaf_btree_id_mask & BIT_ULL(i)))
+			continue;
+
 		/*
 		 * We check for zeros to degrade gracefully when run
 		 * with un-upgraded accounting info (missing some counters).
 		 */
-
 		if (v.total_nodes != 0)
 			s->nodes_total += v.total_nodes - v.inner_nodes;
 		else
diff --git a/fs/bcachefs/progress.h b/fs/bcachefs/progress.h
index 972a73087ffe06632abef015e4556d8ee196eb24..91f3453377093e2713aa4198b68e13601223688e 100644
--- a/fs/bcachefs/progress.h
+++ b/fs/bcachefs/progress.h
@@ -20,7 +20,17 @@ struct progress_indicator_state {
 	struct btree		*last_node;
 };
 
-void bch2_progress_init(struct progress_indicator_state *, struct bch_fs *, u64);
+void bch2_progress_init_inner(struct progress_indicator_state *s,
+			      struct bch_fs *c,
+			      u64 leaf_btree_id_mask,
+			      u64 inner_btree_id_mask);
+
+static inline void bch2_progress_init(struct progress_indicator_state *s,
+				      struct bch_fs *c, u64 btree_id_mask)
+{
+	bch2_progress_init_inner(s, c, btree_id_mask, 0);
+}
+
 void bch2_progress_update_iter(struct btree_trans *,
 			       struct progress_indicator_state *,
 			       struct btree_iter *,

-- 
2.50.1



Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A420F299AAC
	for <linux-bcachefs@vger.kernel.org>; Tue, 26 Aug 2025 22:50:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756248607; cv=none; b=didUePd/ST2xcss+oCtV7wJBtlth32kJeDmGXkgzytFeqPq41bDT9zK6JtbvRLKa6+ClGcxfSYKxbpdUXghtzZezlgzuYWlqbm86OaMk827XrZjYkrO30ZUghh1AOJmdWEotrkITri3A1s+/nX94OScQKG5EjS0i/cpciPqAHlE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756248607; c=relaxed/simple;
	bh=XMEde6sL0KUGjjr6VYBnSK/ADjehfenPUQkmww/m18o=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Tp8J2WZva9XjAwQvb+qZvWB4XAps8i46LAlIGdYzbZagO+SsOJqoHGN11Ov+Li+gB4+fJQed2fSdQK6v3yUWzMGyBmmkpEgA+3PkxoAFWQeQWA+85CY8ygzDz3TbFWRTdnMjVnktdpvGSNvH2Bcx8a3dAG11ZJGt4fOYoKyIE84=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kxQbggwK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kxQbggwK"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 50767C116D0;
	Tue, 26 Aug 2025 22:50:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756248607;
	bh=XMEde6sL0KUGjjr6VYBnSK/ADjehfenPUQkmww/m18o=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=kxQbggwKQ85KRrzYCs1RTCmygySZwXEXkDOqmMbLuX9A/3ABzgMWNA6O44/+5Amrc
	 1dWG+H1XjCFekjKMeWfltXumoE/T4p11i2jNiCsJiegVcVcIQJDQ3k3udr3feJ3srH
	 K8zjEQDiGKJnaJVVUItXfcwr8TtTBRNaRjD7bFk4dtTkskBYwpL1RvSfi2sOxOJrZP
	 uNIACPYt3n8WvRkKe10Jwxdv/13buGRJQX3uJvU3OSTTFzOfeB2aAh3gISwUi3Mat1
	 wHOKquBZwrnNGTxXMSTsed7CQdJ98tqttGvlZ2lbTGv7w3e+QPavsGuxUdoIao6IvV
	 Ou43tuboynm/w==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 479F7CA0FF0;
	Tue, 26 Aug 2025 22:50:07 +0000 (UTC)
From: Nikita Ofitserov via B4 Relay <devnull+himikof.gmail.com@kernel.org>
Date: Wed, 27 Aug 2025 01:49:11 +0300
Subject: [PATCH 05/12] bcachefs: Better progress reporting for btree
 iteration without leaves
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250827-better-progress-v1-5-74c24de7988a@gmail.com>
References: <20250827-better-progress-v1-0-74c24de7988a@gmail.com>
In-Reply-To: <20250827-better-progress-v1-0-74c24de7988a@gmail.com>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: linux-bcachefs@vger.kernel.org, Nikita Ofitserov <himikof@gmail.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=2706; i=himikof@gmail.com;
 h=from:subject:message-id;
 bh=0ayVqa649VFler2gE0/RkQ/6h2fXF6zOAUkxMAASsjs=;
 b=owGbwMvMwCW2edHtzWZP9DIYT6slMWSss5LRVZ20csl3lVfXMiunNslf+bf8fFt5yNk9J/qlG
 ZM4HZqjOkpZGMS4GGTFFFk+LPn6Z02m9R9Lob2GMHNYmUCGMHBxCsBE+H0ZGbZ1Jeh1K/0uZvPQ
 V28W5lkveWOLd4ymam3Eeu+Z05Z+4mH4p3FzapnlTp5Hcw+pMkXmSucZFlmWtImc/2gsofNG8uo
 qfgA=
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
index 3ad4e1f6f653c8c75205efdd6d72560b8dda4c51..013eca7d6017a81390001519f20bfc4d0c6bc173 100644
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
 	for (unsigned i = 0; i < BTREE_ID_NR; i++) {
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



Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2DF123D7D0
	for <linux-bcachefs@vger.kernel.org>; Thu,  4 Sep 2025 05:22:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756963323; cv=none; b=jPk6flyZWXWsXKpVC5ShqCYtVW1fgwYow4sXZz+AxN8l3s0pQ439GVgwnDE8BAX+NowlMBT54I1vbSBS/w/oZBeUyElyLV17Ol7e6NNm4TbjOwJy2WMocIafGMMsBsYhMeKN8NNqSSLS/Euvwj8xgqF4w1njKyEsT2I5DT51m/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756963323; c=relaxed/simple;
	bh=ruOiu72MVXfinVOxDiZEBKpf2vN4zgoJAC7/ENioTmo=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=vEIP/FHBg4PjDSMBgC4rQzftwAz2KWNmpLaE5aOP4sEnQJ9rvL9980QRleCXe1IERkoW+BTF4aivDVI8SUFbm82fPD55d4pJ2qKnFD+70bgoDLne7kHXmGSzF5Bi+mTkZIl30AlGXMrm8XWbYOuCTJE1h6BHLiiWLOkPQreegew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jc/BfmGX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jc/BfmGX"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8DA65C4CEFA;
	Thu,  4 Sep 2025 05:22:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756963323;
	bh=ruOiu72MVXfinVOxDiZEBKpf2vN4zgoJAC7/ENioTmo=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=jc/BfmGX4BRmJkqu381lVRov+PoC/pz5DVmCL4PC6IP+Bo8cIeOPRVWqVgPpPs9QR
	 8ePkGU/+SkwzygHGe0A+Y52XkYk6hNgDk6RMNA2PiyxHI/M4DJKOGO0/rSOaSI/MT1
	 Y3E14gA+ZRxUUTiw9EcXuxUyBA1ybHXKCAEARTP4lex3cyhTWiS9Ng9B6kCpND8ku1
	 HtSuhCIGwJiOgGW3KWBrFojN3P3hfpVTLSmEf3SynXuGx3D9CP69PR0DdW3YaaWmSI
	 vycqQEvyOIQXj9PYr/KHGx0p81LCszEVj3fpxyQjdFCCMkDamp1hKSRCZrWfbPHtKH
	 wR+F06T/+0yqA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80D47CA1017;
	Thu,  4 Sep 2025 05:22:03 +0000 (UTC)
From: Nikita Ofitserov via B4 Relay <devnull+himikof.gmail.com@kernel.org>
Date: Thu, 04 Sep 2025 08:20:37 +0300
Subject: [PATCH v3 6/7] bcachefs: Better progress reporting for btree
 iteration without leaves
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250904-better-progress-v3-6-6cc4edf543f4@gmail.com>
References: <20250904-better-progress-v3-0-6cc4edf543f4@gmail.com>
In-Reply-To: <20250904-better-progress-v3-0-6cc4edf543f4@gmail.com>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: linux-bcachefs@vger.kernel.org, Nikita Ofitserov <himikof@gmail.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=2715; i=himikof@gmail.com;
 h=from:subject:message-id;
 bh=wRKn0+FpY3mQVliUpbvtIlpx5Xz4Yan6xBO1SABanUM=;
 b=owGbwMvMwCW2edHtzWZP9DIYT6slMWTsVPz5RpfDb6v8hG5TrsJbH9sP+UpqLdFfVO9yM4hhw
 ezj2xQ3dJSyMIhxMciKKbJ8WPL1z5pM6z+WQnsNYeawMoEMYeDiFICJBLxiZHgiu/1Q8SkPTwWz
 0gdKlZo1Ca982GoL1Fr5uESieLO2+DP8U6qoUHR/fFXxiniK2vQHF66X5SS17OLt2NLskivvfkO
 PEQA=
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



Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BE20433A9
	for <linux-bcachefs@vger.kernel.org>; Wed,  2 Oct 2024 19:06:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727896007; cv=none; b=a+YV3yiu/VPnk4ZAsYK9Cb6h0wgmwzCvpzrH+bmBfs7omhH9L1ft2We9PMMCS0t21h9CgrlL3ZFbficVt8pR4NQsubyHHF50zIwFPgdiRYRcHlzkNMEb2FZHc7Z1c8xIyCGGEdyEubtPijkXF5LEIr8pl8BrstfuwaSiJI7LhWg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727896007; c=relaxed/simple;
	bh=SdHBHkAsHJfdIhQlYoKc145tS59szFcrfY0zjb/fQNQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g4kvMQYbc7M5CyoOmEbzFEfc8/SfVaOX9+7YQFlTppxJCRGruMtNW5yHAZNDGyZjGIk8cPc9wM/lsd2f6G9frYyPB389f7OzrjWXuKBSpIxsUPgZ4pykKTTT37Mah5iRb6bdJly7n7QrTRMRcrGe6ym7gVgoWrt3gEiMsOO27Ow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ilORthl1; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ilORthl1"
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-20b64584fd4so954295ad.1
        for <linux-bcachefs@vger.kernel.org>; Wed, 02 Oct 2024 12:06:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1727896005; x=1728500805; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oKGxssuRj7bDTSaCQGXVks4JnOkqRhWA4X7fyk3cxC8=;
        b=ilORthl1GM+0nbhaA1QumQ5UEvdZUj3DbLBsUZcGbNxC2Zl8ovMv1msGrl/1Ukcbra
         D/deTJrhC6TCGnB5LEO/SMRxtU1mgTbHvwfHAbLeD+wFnoQ5dh8wIpdlHFGPJTYh1bdB
         pbVdldERVqIkO8oeoWxmB7BdguUIythEGeYnLOH2IF0NhJsg3/60tFjw72/EENm9o6nA
         RmO/fi1btSAqZENYeVHoi+mqBLW4LqE9zXfuGLFUzJgLahqkpZhFaQ0Y43XdqTGaK87y
         EWVh7cdbl8Ob9t9vvF1tFEUGZoS3YvBcNK5oJtgYuth6n7/Iu03icKmwN+76UtS/e4Ge
         17eA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727896005; x=1728500805;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oKGxssuRj7bDTSaCQGXVks4JnOkqRhWA4X7fyk3cxC8=;
        b=wB+LIjnb2rf4r4iLPPV4Y/UOPxK5tepC+vZujnMaMTRqtP58Q4+42FJIa8uf7BPsEp
         vm0wsiWb5v2XOcl61R894YHA3guNphjLVZpu2oMtDksapbxcu4afP1h5Fwk0tdr3Hw8T
         oM29wJt+jPL7LM/4uQAGVTU1rG1zGXEmeAzOnUeIuG8uTpo2k6rYtzDHOoVC3T2DUE+E
         DsdwFhwR2I79bI0MPESv5pPCgRVa3B4zYk5+Wzn2w2/P3zX/+k1Y/doLdRndsaDMxc/W
         l806CxwAgjPBTvBE/mBD67U4+mC/Kq+/k1/TMMTU7X4i3oeaHKZpO+UlHRPpanPoLdDF
         y7Rg==
X-Gm-Message-State: AOJu0Yzyxyx98xA4txXIfrU4MNnvLIvHPOlk6msy9//Dqxi4CpgmW97P
	TzKZqb3lDAtrVtkQChQ+TCxOdJj+iQrj5IkPzbvN2S7b49Jaz0CIqtC6Kv4C
X-Google-Smtp-Source: AGHT+IE/m1ruI5gUsr3rjdwE4ZYLleD91RUljU5fnbLU7ClhiT9bhk41BRg0gSzksNa5KId4aC0DIA==
X-Received: by 2002:a17:903:2348:b0:20b:c258:73af with SMTP id d9443c01a7336-20bc5a712afmr60200665ad.51.1727896005551;
        Wed, 02 Oct 2024 12:06:45 -0700 (PDT)
Received: from localhost ([2402:d0c0:11:86::1])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-20b37e0d6a0sm87713505ad.169.2024.10.02.12.06.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Oct 2024 12:06:45 -0700 (PDT)
From: Alan Huang <mmpgouride@gmail.com>
To: kent.overstreet@linux.dev
Cc: linux-bcachefs@vger.kernel.org,
	Alan Huang <mmpgouride@gmail.com>
Subject: [PATCH 3/4] bcachefs: Only abort the transactions in the cycle
Date: Thu,  3 Oct 2024 03:06:32 +0800
Message-ID: <20241002190633.1454448-3-mmpgouride@gmail.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20241002190633.1454448-1-mmpgouride@gmail.com>
References: <20241002190633.1454448-1-mmpgouride@gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When the cycle doesn't involve the initiator of the cycle detection,
we might choose a transaction that is not involved in the cycle to abort.
It shouldn't be that since it won't break the cycle, this patch
therefore chooses the transaction in the cycle to abort.

Signed-off-by: Alan Huang <mmpgouride@gmail.com>
---
 fs/bcachefs/btree_locking.c | 21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

diff --git a/fs/bcachefs/btree_locking.c b/fs/bcachefs/btree_locking.c
index 8cc648be7d29..70f13ab5ba7b 100644
--- a/fs/bcachefs/btree_locking.c
+++ b/fs/bcachefs/btree_locking.c
@@ -130,11 +130,17 @@ static void lock_graph_down(struct lock_graph *g, struct btree_trans *trans)
 	__lock_graph_down(g, trans);
 }
 
-static bool lock_graph_remove_non_waiters(struct lock_graph *g)
+static bool lock_graph_remove_non_waiters(struct lock_graph *g,
+					  struct trans_waiting_for_lock *from)
 {
 	struct trans_waiting_for_lock *i;
 
-	for (i = g->g + 1; i < g->g + g->nr; i++)
+	if (from->trans->locking != from->node_want) {
+		lock_graph_pop_from(g, from);
+		return true;
+	}
+
+	for (i = from + 1; i < g->g + g->nr; i++)
 		if (i->trans->locking != i->node_want ||
 		    i->trans->locking_wait.start_time != i[-1].lock_start_time) {
 			lock_graph_pop_from(g, i);
@@ -184,13 +190,14 @@ static int btree_trans_abort_preference(struct btree_trans *trans)
 	return 3;
 }
 
-static noinline int break_cycle(struct lock_graph *g, struct printbuf *cycle)
+static noinline int break_cycle(struct lock_graph *g, struct printbuf *cycle,
+				struct trans_waiting_for_lock *from)
 {
 	struct trans_waiting_for_lock *i, *abort = NULL;
 	unsigned best = 0, pref;
 	int ret;
 
-	if (lock_graph_remove_non_waiters(g))
+	if (lock_graph_remove_non_waiters(g, from))
 		return 0;
 
 	/* Only checking, for debugfs: */
@@ -200,7 +207,7 @@ static noinline int break_cycle(struct lock_graph *g, struct printbuf *cycle)
 		goto out;
 	}
 
-	for (i = g->g; i < g->g + g->nr; i++) {
+	for (i = from; i < g->g + g->nr; i++) {
 		pref = btree_trans_abort_preference(i->trans);
 		if (pref > best) {
 			abort = i;
@@ -247,7 +254,7 @@ static int lock_graph_descend(struct lock_graph *g, struct btree_trans *trans,
 	for (i = g->g; i < g->g + g->nr; i++)
 		if (i->trans == trans) {
 			closure_put(&trans->ref);
-			return break_cycle(g, cycle);
+			return break_cycle(g, cycle, i);
 		}
 
 	if (g->nr == ARRAY_SIZE(g->g)) {
@@ -339,7 +346,7 @@ int bch2_check_for_deadlock(struct btree_trans *trans, struct printbuf *cycle)
 				 * structures - which means it can't be blocked
 				 * waiting on a lock:
 				 */
-				if (!lock_graph_remove_non_waiters(&g)) {
+				if (!lock_graph_remove_non_waiters(&g, g.g)) {
 					/*
 					 * If lock_graph_remove_non_waiters()
 					 * didn't do anything, it must be
-- 
2.45.2


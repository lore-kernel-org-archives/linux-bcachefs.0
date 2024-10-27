Received: from out-176.mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC9BD4C83
	for <linux-bcachefs@vger.kernel.org>; Sun, 27 Oct 2024 00:52:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729990322; cv=none; b=TOjkVtRKyBZs7Laekl8E8A9K6mImceickPNMMQ5NHp66NJp0ZXKG/h6B7ug6KuN+gg9QfRt/gbVlWHgmRT+sqc0xh4lR0xkR/2Bu7aaTNN4zRh6noK4skMflxAY/QErB2LqsW7rjW4Ws3rORP0CJlZiMlIU4OMRguM0Of/hcUts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729990322; c=relaxed/simple;
	bh=x4lP4JsP2dg8go7sNTuhDMjDPXRKVAzmL6Mgzoidfu8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GS1z5ZfpmFoFoBC0phdOcuM4DlkP8RDggypAJVSTNR8ycBEbgtgy+L7K8yYWnvR6gTe1ZG7caLYi8l5AVN8KiazPQ7HxFWW0vWo/rst+anI4LSVPlUWrxQX/UB4TVRhBUtfsCXQGNZKJ3eCDMtao5myFO223BTXDiUlE+/8QQLw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=orPXImXJ; arc=none smtp.client-ip=95.215.58.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="orPXImXJ"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1729990318;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qiY9+bQpPkg9dgyFpYoKWXhpEhdYaCNS+rHjFz3jaQU=;
	b=orPXImXJu2gPkIL2N55SsTyeuacT004BwQMpaKmkgoIU03/5fqHfh4pZNhFnckPCBR7ImY
	TCeVDwDEqyv2J+EwkfSnPR2nmQiAaXUkVU7Rgdwk1Tw94JxyhWSGL3rUFKYKUP3LiUQ0Gd
	7yhzwPo3ysP3xGFp7kvXGDUOPAVuQqQ=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 9/9] bcachefs: peek_prev_min(): Search forwards for extents, snapshots
Date: Sat, 26 Oct 2024 20:51:38 -0400
Message-ID: <20241027005141.2337634-10-kent.overstreet@linux.dev>
In-Reply-To: <20241027005141.2337634-1-kent.overstreet@linux.dev>
References: <20241027005141.2337634-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

With extents and snapshots, for slightly different reasons, we may have
to search forwards to find a key that compares equal to iter->pos (i.e.
a key that peek_prev() should return, as it returns keys <= iter->pos).

peek_slot() does this, and is an easy way to fix this case.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/btree_iter.c | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/fs/bcachefs/btree_iter.c b/fs/bcachefs/btree_iter.c
index 6bb2eb388c1b..d22c212bb4e6 100644
--- a/fs/bcachefs/btree_iter.c
+++ b/fs/bcachefs/btree_iter.c
@@ -2564,6 +2564,21 @@ static struct bkey_s_c __bch2_btree_iter_peek_prev(struct btree_iter *iter, stru
  */
 struct bkey_s_c bch2_btree_iter_peek_prev_min(struct btree_iter *iter, struct bpos end)
 {
+	if ((iter->flags & (BTREE_ITER_is_extents|BTREE_ITER_filter_snapshots)) &&
+	   !bkey_eq(iter->pos, POS_MAX)) {
+		/*
+		 * bkey_start_pos(), for extents, is not monotonically
+		 * increasing until after filtering for snapshots:
+		 *
+		 * Thus, for extents we need to search forward until we find a
+		 * real visible extents - easiest to just use peek_slot() (which
+		 * internally uses peek() for extents)
+		 */
+		struct bkey_s_c k = bch2_btree_iter_peek_slot(iter);
+		if (bkey_err(k) || !bkey_deleted(k.k))
+			return k;
+	}
+
 	struct btree_trans *trans = iter->trans;
 	struct bpos search_key = iter->pos;
 	struct bkey_s_c k;
@@ -2579,9 +2594,6 @@ struct bkey_s_c bch2_btree_iter_peek_prev_min(struct btree_iter *iter, struct bp
 		goto out_no_locked;
 	}
 
-	if (iter->flags & BTREE_ITER_filter_snapshots)
-		search_key.snapshot = U32_MAX;
-
 	while (1) {
 		k = __bch2_btree_iter_peek_prev(iter, search_key);
 		if (unlikely(!k.k))
-- 
2.45.2


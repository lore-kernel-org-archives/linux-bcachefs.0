Received: from out-187.mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 244DA2C158B
	for <linux-bcachefs@vger.kernel.org>; Thu,  3 Jul 2025 23:00:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751583612; cv=none; b=NrZIhq7r4rePJRSPr2cVcs3q94CYg/XD8BbEah+yl+mRSDc6ryQl0BbcSifl22Ov7osXiNLJTuMz1fX/znYbHs3mc2ZRRegFci3xDGwV2lTOkUqaJ3UI3hQYE6z3qdKjmDJwWI+fqR6IUne5xDNqT0B0DvN8MfytHaa56A0eDx0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751583612; c=relaxed/simple;
	bh=iRu2w17TSmTNtfF0cxaFQGEZ7TAz68mID9dkaL5B2oU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Jl9ikdEVNUOcBSTkYTccFLfn3DiH4q9L6FB2prYZ8raa+1mcpUe1NOMzJiBX1F235KbMp7wVI6yReJTHFl3I5p8rvANJmgqNtSMpEEk8+YS2TpdHq1D0q1sPYXOaE6jrjfPReHdgbWFkxT6Oyq4qz6o6dM+/Jj2s7OlAEaIW4f4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=bMKBINB2; arc=none smtp.client-ip=95.215.58.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="bMKBINB2"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1751583608;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=CJS+8iqKg2MVdm+iw1FkPlhHS7CHmk1HwSiK08Ir8Sc=;
	b=bMKBINB2UsT+U3bBtYo2NOLpwoIesRz8hiA2GLAEPIO5QbOVwydBh2vkXw9y1ne3FJOcpx
	O8hATc/F0gwDEUuXXeGktd5qkA+u4ndOVNL+1SSCbl2OxU8t+9MTjwYzsW8t0FCODfbVRe
	vXlkVDUNqD47jey0ivMeYEv6XZkB4qs=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>,
	Alan Huang <mmpgouride@gmail.com>
Subject: [PATCH] bcachefs: Fix btree for nonexistent tree depth
Date: Thu,  3 Jul 2025 19:00:00 -0400
Message-ID: <20250703230000.214543-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

The fix for when we should increase tree depth in journal replay was
entirely bogus.

We should only increase the tree depth in journal replay when recovery
from btree node scan, and then only for keys found by btree node scan.

This needs additional work - we should be shooting down existing
interior node pointers when recovery from scan, they shouldn't be
showing up here.

Fixes: b47a82ff4772 ("bcachefs: Only run 'increase_depth' for keys from btree node csan")
Cc: Alan Huang <mmpgouride@gmail.com>
Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/recovery.c | 23 +++++++++++++++++------
 1 file changed, 17 insertions(+), 6 deletions(-)

diff --git a/fs/bcachefs/recovery.c b/fs/bcachefs/recovery.c
index 974f8bf9a574..0def4ecb7f88 100644
--- a/fs/bcachefs/recovery.c
+++ b/fs/bcachefs/recovery.c
@@ -273,24 +273,35 @@ static int bch2_journal_replay_key(struct btree_trans *trans,
 		goto out;
 
 	struct btree_path *path = btree_iter_path(trans, &iter);
-	if (unlikely(!btree_path_node(path, k->level) &&
-		     !k->allocated)) {
+	if (unlikely(!btree_path_node(path, k->level))) {
 		struct bch_fs *c = trans->c;
 
+		CLASS(printbuf, buf)();
+		prt_str(&buf, "btree=");
+		bch2_btree_id_to_text(&buf, k->btree_id);
+		prt_printf(&buf, " level=%u ", k->level);
+		bch2_bkey_val_to_text(&buf, c, bkey_i_to_s_c(k->k));
+
 		if (!(c->recovery.passes_complete & (BIT_ULL(BCH_RECOVERY_PASS_scan_for_btree_nodes)|
 						     BIT_ULL(BCH_RECOVERY_PASS_check_topology)))) {
-			bch_err(c, "have key in journal replay for btree depth that does not exist, confused");
+			bch_err(c, "have key in journal replay for btree depth that does not exist, confused\n%s",
+				buf.buf);
 			ret = -EINVAL;
 		}
-#if 0
+
+		if (!k->allocated) {
+			bch_notice(c, "dropping key in journal replay for depth that does not exist because we're recovering from scan\n%s",
+				   buf.buf);
+			k->overwritten = true;
+			goto out;
+		}
+
 		bch2_trans_iter_exit(trans, &iter);
 		bch2_trans_node_iter_init(trans, &iter, k->btree_id, k->k->k.p,
 					  BTREE_MAX_DEPTH, 0, iter_flags);
 		ret =   bch2_btree_iter_traverse(trans, &iter) ?:
 			bch2_btree_increase_depth(trans, iter.path, 0) ?:
 			-BCH_ERR_transaction_restart_nested;
-#endif
-		k->overwritten = true;
 		goto out;
 	}
 
-- 
2.50.0


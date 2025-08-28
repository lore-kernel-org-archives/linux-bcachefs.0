Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6324530F534
	for <linux-bcachefs@vger.kernel.org>; Thu, 28 Aug 2025 14:16:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756390597; cv=none; b=Ux+rgSD81QKoIxdVPfW3AZgcVvydQXIfPO7QS6KJtOG+iRpWQOyL4yRcL4MmXkYIaVo0Xmyu0+KEdC1/fXMf4Ql5Xr6dJOnbhBWB+CF/siGdW/5ov7PQlTiih3w2vwadbCC4E+H/nAh5wBjlI8L64gXLYoqCue/O7MbpOgU7vzc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756390597; c=relaxed/simple;
	bh=e1qfGJjAFdxoWmmjkWvUhmn0R2pU5ulk1tii8FRuh44=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=bytL+WWaTWgj4LE/uJzbJyIOk2z7hnrWUWN5WNIIBI/rcm37jyQ7e6Zz6g3hQfMtc5C3BhTRIN/9HE5Aqw9nJFBC5jNtFki0IybnXUNkwYPEFR8ioRdDzfo0GNpyDXnEg+tz0wM97Hk4AZV6mVKeDpDG/tpw5PV/9h5NxXkRbEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SNZbSI9V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SNZbSI9V"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 29ECFC4CEF8;
	Thu, 28 Aug 2025 14:16:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756390597;
	bh=e1qfGJjAFdxoWmmjkWvUhmn0R2pU5ulk1tii8FRuh44=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=SNZbSI9VE824W9MOfIld/+Z3CFtguNGNEVkkgW7Gje4djyFrjZDMYQEX4bOuu1966
	 IfX1LInGgvPLEv04JK8cvnRH+ZcQ5xG/bTz3jTAZ+iMGosoJYtlmt+vzefojMmQMnJ
	 MAjJo68wo7ERysLKvqn/QL3HtvRsvy0E2981+wtGCHbn7+zgjwvxXwsfJSsJIzfmqD
	 LEgbTRvL/c93ckTIZ3MOHmXuC/OQFyVO6D/XprAZvI7CkLRVvu1hi1NF5fJXO+mem3
	 n6vCBr+uAYn1ZDcJViOpq+gtiQI8g57V0AS4cY1SYOd9H3JxSye51Fcdz+C+BDUBlt
	 FbTSa6chXnn5Q==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 158D1C8303F;
	Thu, 28 Aug 2025 14:16:37 +0000 (UTC)
From: Nikita Ofitserov via B4 Relay <devnull+himikof.gmail.com@kernel.org>
Date: Thu, 28 Aug 2025 17:16:04 +0300
Subject: [PATCH v2 02/15] bcachefs: Refactor bch2_gc_btree/bch2_gc_btrees
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250828-better-progress-v2-2-c088a2003940@gmail.com>
References: <20250828-better-progress-v2-0-c088a2003940@gmail.com>
In-Reply-To: <20250828-better-progress-v2-0-c088a2003940@gmail.com>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: linux-bcachefs@vger.kernel.org, Nikita Ofitserov <himikof@gmail.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=1558; i=himikof@gmail.com;
 h=from:subject:message-id;
 bh=oDcgd9+Tw5O6XEbdGPb3cpQkJo1A036cADXhKke/lEI=;
 b=owGbwMvMwCW2edHtzWZP9DIYT6slMWRsSDm4VmzdHM77gr8iLXhaFmpHTPYpkHcrEPxkGdwTz
 cktpP+no5SFQYyLQVZMkeXDkq9/1mRa/7EU2msIM4eVCWQIAxenAEwkOoSR4c9iy6wXLKfi0z55
 +h64Wnr+dsbZ7Sy9p8TvPNxsEK6/N4SRoW3tC88YvqSrKqt5Gqe9mHmdZ+v/Q7+6U01jnKWiBKJ
 rmQA=
X-Developer-Key: i=himikof@gmail.com; a=openpgp;
 fpr=F0A4F5FCAC693BFC3912BD31B3A2DBB336E42E68
X-Endpoint-Received: by B4 Relay for himikof@gmail.com/default with
 auth_id=452
X-Original-From: Nikita Ofitserov <himikof@gmail.com>
Reply-To: himikof@gmail.com

From: Nikita Ofitserov <himikof@gmail.com>

Concentrate iteration policy inside the caller so that accurate
progress reporting would be possible.

Signed-off-by: Nikita Ofitserov <himikof@gmail.com>
---
 fs/bcachefs/btree_gc.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/fs/bcachefs/btree_gc.c b/fs/bcachefs/btree_gc.c
index 2b1b6b7ffdf0af7ec0bf4cbaf68cc9a53a20cfce..2a369aebdbe216ed665115e27388ab4821696bf8 100644
--- a/fs/bcachefs/btree_gc.c
+++ b/fs/bcachefs/btree_gc.c
@@ -717,16 +717,12 @@ static int bch2_gc_mark_key(struct btree_trans *trans, enum btree_id btree_id,
 
 static int bch2_gc_btree(struct btree_trans *trans,
 			 struct progress_indicator_state *progress,
-			 enum btree_id btree, bool initial)
+			 enum btree_id btree, unsigned target_depth,
+			 bool initial)
 {
 	struct bch_fs *c = trans->c;
-	unsigned target_depth = BIT_ULL(btree) & btree_leaf_has_triggers_mask ? 0 : 1;
 	int ret = 0;
 
-	/* We need to make sure every leaf node is readable before going RW */
-	if (initial)
-		target_depth = 0;
-
 	for (unsigned level = target_depth; level < BTREE_MAX_DEPTH; level++) {
 		struct btree *prev = NULL;
 		struct btree_iter iter;
@@ -797,7 +793,8 @@ static int bch2_gc_btrees(struct bch_fs *c)
 		if (IS_ERR_OR_NULL(bch2_btree_id_root(c, btree)->b))
 			continue;
 
-		ret = bch2_gc_btree(trans, &progress, btree, true);
+		/* We need to make sure every leaf node is readable before going RW */
+		ret = bch2_gc_btree(trans, &progress, btree, 0, true);
 	}
 
 	bch_err_fn(c, ret);

-- 
2.50.1



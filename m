Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8A814C83
	for <linux-bcachefs@vger.kernel.org>; Sun, 27 Oct 2024 00:51:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729990319; cv=none; b=dGE5z7/TjueqJubsh5PRwoOqYeuHlOfZgCQDD5E6aWGGCz69yW+SCCfzzPMJDz8PFnLNEzD8ccRn1xT/oEB1u/y+Bab8KEON5vF3pShdA9H11U98FQkcdDNzZE5c8AkmNH4QtP9d3QJuZEXHayijxmBlaWNB9ZV+sCVL00C9pTc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729990319; c=relaxed/simple;
	bh=S6bJd+ily91zWlihmedii7PNQIOmnpbX/633yoOKTMk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mL4aaSxXuYOvyYjOZd1IOzikluRwdopZk0OIZiNcx43U9eR7QC44D6zK6gkBXIsXUv4kEDhc5qWR9FCgZxa5I8Zv9RppVFjOOY1BmL4oiiffTpmhW3rvZXHnc9NGNvJ8HavRqqrkyPRYChquWyf2E3FYZLtiprQbmZ+OTbYHr0I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=oguG5flJ; arc=none smtp.client-ip=95.215.58.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="oguG5flJ"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1729990315;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FqaXO9U9So1omYmuuqx0qzXi3e4dZLZe7bDpiac7EQg=;
	b=oguG5flJknQ8RBKMVANtJ8PNsqNBBDVUJ8B/DIpPLZSrQAYBq2sWrg2Bnpy/Q7Gk16N5ET
	K2cuEDD8gNAmC23r4nkResj6eWFfgBS7L/2t0vdLqe9b8ifSU0ptSjY5IVuQHe2cvyiY0o
	c/sGPTfINFnfykwXwtP3NBAOVTL76Vs=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 4/9] bcachefs: Assert that we're not violating key cache coherency rules
Date: Sat, 26 Oct 2024 20:51:33 -0400
Message-ID: <20241027005141.2337634-5-kent.overstreet@linux.dev>
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

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/btree_key_cache.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/fs/bcachefs/btree_key_cache.c b/fs/bcachefs/btree_key_cache.c
index 244610b1d0b5..3bd40ea0fa3d 100644
--- a/fs/bcachefs/btree_key_cache.c
+++ b/fs/bcachefs/btree_key_cache.c
@@ -424,8 +424,15 @@ static int btree_key_cache_flush_pos(struct btree_trans *trans,
 	    !test_bit(JOURNAL_space_low, &c->journal.flags))
 		commit_flags |= BCH_TRANS_COMMIT_no_journal_res;
 
-	ret   = bch2_btree_iter_traverse(&b_iter) ?:
-		bch2_trans_update(trans, &b_iter, ck->k,
+	struct bkey_s_c btree_k = bch2_btree_iter_peek_slot(&b_iter);
+	ret = bkey_err(btree_k);
+	if (ret)
+		goto err;
+
+	/* * Check that we're not violating cache coherency rules: */
+	BUG_ON(bkey_deleted(btree_k.k));
+
+	ret   = bch2_trans_update(trans, &b_iter, ck->k,
 				  BTREE_UPDATE_key_cache_reclaim|
 				  BTREE_UPDATE_internal_snapshot_node|
 				  BTREE_TRIGGER_norun) ?:
@@ -433,7 +440,7 @@ static int btree_key_cache_flush_pos(struct btree_trans *trans,
 				  BCH_TRANS_COMMIT_no_check_rw|
 				  BCH_TRANS_COMMIT_no_enospc|
 				  commit_flags);
-
+err:
 	bch2_fs_fatal_err_on(ret &&
 			     !bch2_err_matches(ret, BCH_ERR_transaction_restart) &&
 			     !bch2_err_matches(ret, BCH_ERR_journal_reclaim_would_deadlock) &&
-- 
2.45.2


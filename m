Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3879B274658
	for <linux-bcachefs@vger.kernel.org>; Sun, 24 Aug 2025 12:38:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756039100; cv=none; b=fByse1Z8wP8i9WSzF81Nx2J0BA7iZCiwNGn4sekRBxzTUKXP2PYtiRtUKmEZ27t9j/1t6tu+J2dlj+3OaN+p9VntJ4jt3V7hT3JNFbx4dLBpsBu0Znk5xq3veb/oKvS4oECjwulWPCMz03LKCjF9+aB7LQdqGMo9mGobaNkfnbs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756039100; c=relaxed/simple;
	bh=bWRJLucl1g9IBIMBa4JHOxV5wgH6ZmUD4eVCT2JoSwQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P3hTSdnicxKN2uMbKEALeD9Sodug6RMlXJXWJSIO3yUWKmtp3sEuBsu/8Npmw23XxYH31ylUmgyiQTTL4NkOhYL8CuEpQl0+izyqnDz09kjpC34rHrVVMK9RTJIaLnqhNRKxrmD2h7iAWR98aCA5NaO8j8vQKaDDbhrqYfzLu08=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ud+xCn0T; arc=none smtp.client-ip=91.218.175.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ud+xCn0T"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1756039097;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9POyBvo9jBQ/ggosAYBESQrv3W435OxEV9NnCfAxOjc=;
	b=ud+xCn0TA0Fa4j5xxjl4PIxmhNJziL8ydpU/kKslTz6JMWBcQNkX0W67GDd4Hsjn0Mca/i
	cFXFyq2s2XFuSZYTBkwAK8TGCbhoUWuGyrSVP9UCeh31wjU8arXGw2gS+kr1VeqZdfd13s
	sW2hOw6ciwO58s6+E40nSEP9a/UxPO4=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 15/21] bcachefs: check_rebalance_work checks option inconsistency
Date: Sun, 24 Aug 2025 08:37:52 -0400
Message-ID: <20250824123800.1617669-16-kent.overstreet@linux.dev>
In-Reply-To: <20250824123800.1617669-1-kent.overstreet@linux.dev>
References: <20250824123800.1617669-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

The previous patch added consistency checking for bch_extent_rebalance
whenever the move or rebalance paths update an extent; now we
additionally check in the check_rebalance_work recovery pass.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/rebalance.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/fs/bcachefs/rebalance.c b/fs/bcachefs/rebalance.c
index 872fff940c5a..70000d9a1ec4 100644
--- a/fs/bcachefs/rebalance.c
+++ b/fs/bcachefs/rebalance.c
@@ -1003,6 +1003,7 @@ int bch2_fs_rebalance_init(struct bch_fs *c)
 static int check_rebalance_work_one(struct btree_trans *trans,
 				    struct btree_iter *extent_iter,
 				    struct btree_iter *rebalance_iter,
+				    struct per_snapshot_io_opts *snapshot_io_opts,
 				    struct bkey_buf *last_flushed)
 {
 	struct bch_fs *c = trans->c;
@@ -1073,6 +1074,13 @@ static int check_rebalance_work_one(struct btree_trans *trans,
 			return ret;
 	}
 
+	struct bch_inode_opts *opts = bch2_extent_get_apply_io_opts(trans,
+				snapshot_io_opts, extent_iter->pos, extent_iter, extent_k,
+				SET_NEEDS_REBALANCE_other);
+	ret = PTR_ERR_OR_ZERO(opts);
+	if (ret)
+		return ret;
+
 	if (cmp <= 0)
 		bch2_btree_iter_advance(extent_iter);
 	if (cmp >= 0)
@@ -1085,10 +1093,14 @@ int bch2_check_rebalance_work(struct bch_fs *c)
 {
 	CLASS(btree_trans, trans)(c);
 	CLASS(btree_iter, extent_iter)(trans, BTREE_ID_reflink, POS_MIN,
+				       BTREE_ITER_not_extents|
 				       BTREE_ITER_prefetch);
 	CLASS(btree_iter, rebalance_iter)(trans, BTREE_ID_rebalance_work, POS_MIN,
 					  BTREE_ITER_prefetch);
 
+	struct per_snapshot_io_opts snapshot_io_opts;
+	per_snapshot_io_opts_init(&snapshot_io_opts, c);
+
 	struct bkey_buf last_flushed;
 	bch2_bkey_buf_init(&last_flushed);
 	bkey_init(&last_flushed.k->k);
@@ -1102,12 +1114,14 @@ int bch2_check_rebalance_work(struct bch_fs *c)
 
 		bch2_trans_begin(trans);
 
-		ret = check_rebalance_work_one(trans, &extent_iter, &rebalance_iter, &last_flushed);
+		ret = check_rebalance_work_one(trans, &extent_iter, &rebalance_iter,
+					       &snapshot_io_opts, &last_flushed);
 
 		if (bch2_err_matches(ret, BCH_ERR_transaction_restart))
 			ret = 0;
 	}
 
+	per_snapshot_io_opts_exit(&snapshot_io_opts);
 	bch2_bkey_buf_exit(&last_flushed, c);
 	return ret < 0 ? ret : 0;
 }
-- 
2.50.1


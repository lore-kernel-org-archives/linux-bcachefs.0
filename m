Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9A7E23BCFD
	for <linux-bcachefs@vger.kernel.org>; Thu,  4 Sep 2025 05:22:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756963323; cv=none; b=RPMO2BAbYLXoU83Q0ItWS4+w2MbqIHRVHM7RFbJgWhlkVCL9/+K/EH9wIWqCXRQyBScbiIPENgXTDbrh+RAg+7hpK1/cSYp4bkncEu2Rv+mboGftQK1isLiq0oUKYgQ9JH3XvUw2LBe7e/zFspTunL8caX1sZ+4ChUfPHS9XJtg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756963323; c=relaxed/simple;
	bh=wVaE6xwxPzMxE8PxNJyR7cyXx4PwGoGZgC2o+bTMFyc=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=TGwVhBQ4XYKPY9StsfPM1yngHs0p1xGONgKDV24A+aYhmxPCtGGUnAwJvOlOnHlqjg+afAKz161FtA39AmkEd+snaIBiRGeDBRpwUe6skl3daBxVibuAwUwgejhgKXGxLUqkEHhCc0nfS+M1GgA4E4tVMiENhjILHmTcdabDtm0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FNzlDy7c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FNzlDy7c"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 98A5FC4CEFB;
	Thu,  4 Sep 2025 05:22:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756963323;
	bh=wVaE6xwxPzMxE8PxNJyR7cyXx4PwGoGZgC2o+bTMFyc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=FNzlDy7cV49gK8ou5dN7Qj/jlUsOk76O+hhQyFSP8XWXkO9/6erXaCiGwsVYsnrMq
	 pnrAucNGWURR+ICH/ZCtSDDv0NohZNv2vcDgJ2JJuTM2hc0KneQUN+qxUd2/8KvOx2
	 7P0erbbYxpIWN1rgSwykoRzPL2SfY2mTwtDC0DDxv1B6jW9Gcg+C2rm+baxBcBCdsI
	 7g9ulGV372TBTdjHoz5pThjWDtTQV7tzwETeGNFaGXOR9hhMXZkOspllxt4sqFAe7P
	 X9257wNDRHlZYUdckjiyeJDfeIz9Z/u8jCZv9vl3ox0fgPxhPPy++429g14xJCkUWz
	 8ZG73wE593a8Q==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91257CA1015;
	Thu,  4 Sep 2025 05:22:03 +0000 (UTC)
From: Nikita Ofitserov via B4 Relay <devnull+himikof.gmail.com@kernel.org>
Date: Thu, 04 Sep 2025 08:20:38 +0300
Subject: [PATCH v3 7/7] bcachefs: More accurate progress reporting for
 inner node iteration
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250904-better-progress-v3-7-6cc4edf543f4@gmail.com>
References: <20250904-better-progress-v3-0-6cc4edf543f4@gmail.com>
In-Reply-To: <20250904-better-progress-v3-0-6cc4edf543f4@gmail.com>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: linux-bcachefs@vger.kernel.org, Nikita Ofitserov <himikof@gmail.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=2388; i=himikof@gmail.com;
 h=from:subject:message-id;
 bh=0y6FqhvH4YgWJi6ZMAsnk4E4uWmbuAqR+vZzxFZ2CqY=;
 b=owGbwMvMwCW2edHtzWZP9DIYT6slMWTsVPy5ztFi7cevlh9WFnetubhh6r47F81umXGaqF8RP
 X3KU2DB545SFgYxLgZZMUWWD0u+/lmTaf3HUmivIcwcViaQIQxcnAIwkYc8jAxTs16s8Do4sSZz
 t4hx5TLWzYqviuurL0z4uDO7bjOTCyMvI8P+TS6Xut8XXxBImP1ittxT2bYYR/6dOsZbNheUCq6
 VM2UCAA==
X-Developer-Key: i=himikof@gmail.com; a=openpgp;
 fpr=F0A4F5FCAC693BFC3912BD31B3A2DBB336E42E68
X-Endpoint-Received: by B4 Relay for himikof@gmail.com/default with
 auth_id=452
X-Original-From: Nikita Ofitserov <himikof@gmail.com>
Reply-To: himikof@gmail.com

From: Nikita Ofitserov <himikof@gmail.com>

Signed-off-by: Nikita Ofitserov <himikof@gmail.com>
---
 fs/bcachefs/backpointers.c |  4 +++-
 fs/bcachefs/btree_gc.c     |  2 +-
 fs/bcachefs/migrate.c      | 13 +++++++++----
 3 files changed, 13 insertions(+), 6 deletions(-)

diff --git a/fs/bcachefs/backpointers.c b/fs/bcachefs/backpointers.c
index 0d585e5662be3f02580558e9a590075ea73193d5..42370aebb7a442ee368df323eb1f4970f2e5f949 100644
--- a/fs/bcachefs/backpointers.c
+++ b/fs/bcachefs/backpointers.c
@@ -804,7 +804,9 @@ static int bch2_check_extents_to_backpointers_pass(struct btree_trans *trans,
 	struct progress_indicator_state progress;
 	int ret = 0;
 
-	bch2_progress_init(&progress, trans->c, BIT_ULL(BTREE_ID_extents)|BIT_ULL(BTREE_ID_reflink));
+	bch2_progress_init_inner(&progress, trans->c,
+		btree_has_data_ptrs_mask,
+		~0ULL);
 
 	for (enum btree_id btree_id = 0;
 	     btree_id < btree_id_nr_alive(c);
diff --git a/fs/bcachefs/btree_gc.c b/fs/bcachefs/btree_gc.c
index 2338feb8d8ed4bad85a01a6b9181116d918636b5..c04e88ec5c0ac73c21f01db597b19d1b0c798299 100644
--- a/fs/bcachefs/btree_gc.c
+++ b/fs/bcachefs/btree_gc.c
@@ -780,7 +780,7 @@ static int bch2_gc_btrees(struct bch_fs *c)
 	int ret = 0;
 
 	struct progress_indicator_state progress;
-	bch2_progress_init(&progress, c, ~0ULL);
+	bch2_progress_init_inner(&progress, c, ~0ULL, ~0ULL);
 
 	enum btree_id ids[BTREE_ID_NR];
 	for (unsigned i = 0; i < BTREE_ID_NR; i++)
diff --git a/fs/bcachefs/migrate.c b/fs/bcachefs/migrate.c
index 8a3981e1016edd3357fa45428c7a28bbb1057ad7..e1bca93294ca5f1badb17c8a6aa71c31c3d78443 100644
--- a/fs/bcachefs/migrate.c
+++ b/fs/bcachefs/migrate.c
@@ -273,10 +273,15 @@ int bch2_dev_data_drop(struct bch_fs *c, unsigned dev_idx,
 		       unsigned flags, struct printbuf *err)
 {
 	struct progress_indicator_state progress;
+	int ret;
+
 	bch2_progress_init(&progress, c,
-			   BIT_ULL(BTREE_ID_extents)|
-			   BIT_ULL(BTREE_ID_reflink));
+			   btree_has_data_ptrs_mask & ~BIT_ULL(BTREE_ID_stripes));
+
+	if ((ret = bch2_dev_usrdata_drop(c, &progress, dev_idx, flags, err)))
+		return ret;
+
+	bch2_progress_init_inner(&progress, c, 0, ~0ULL);
 
-	return bch2_dev_usrdata_drop(c, &progress, dev_idx, flags, err) ?:
-		bch2_dev_metadata_drop(c, &progress, dev_idx, flags, err);
+	return bch2_dev_metadata_drop(c, &progress, dev_idx, flags, err);
 }

-- 
2.50.1



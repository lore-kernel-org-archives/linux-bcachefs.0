Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4DA91BC3C
	for <linux-bcachefs@vger.kernel.org>; Mon, 18 Nov 2024 01:45:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731894312; cv=none; b=k1XabtgPnbDCN3vWlFbFevC4VYYlH+b3qp/OD7p6fAvD+Uyl3AjLcQMFyu6AJ3bKLPQztW4qHi6l+GZZ8YiTPNXDUF9Den1sIG3Ih2Vz7o241CZUI3pIuNyvHlqaVLdRQb177mwhF0XIKDHQofIoME94xJIrF2Gsv8ISr4zvuPo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731894312; c=relaxed/simple;
	bh=9vQ0kXElKaQDqHFMl7CSJC5+fFazM/qXq0pTRWJd5sM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DHin28fviWpaekdevYaKl5oeMQfv9L33leh6Yjr4QOW/s6kc446POFq5lGhzSSo99PX3c77WkYK2NygOPAqYcjnpiubwR+eQ1xNI7fy8Po/amaHppoLdCs9hV38j+c5IB49Gz7o4vWE61Gstwf7+KFm8sv/l5P7Lm/H4wKk5zZs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=XrQAqbOF; arc=none smtp.client-ip=91.218.175.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="XrQAqbOF"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1731894308;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=95TxsndhvMVk6roLo0TZOONcwB+HrMj+bXdLNGTDzi0=;
	b=XrQAqbOFeQZrv9MJKF5btNXfTmIm6wyfWLxqcrEHCpVRu129K3e+jOxKhJ1ErcDJikqOXW
	RS1ph5OfOwczpaEt50vHIrDcjiGWUYqNItNfN0TFQIdDQIGmnwuRWADsr7g9mnwoODf5pU
	/fehxh+WMvqu+mlrdCqEznSsTpSzE3o=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 2/7] bcachefs: bucket_pos_to_bp_end()
Date: Sun, 17 Nov 2024 20:44:43 -0500
Message-ID: <20241118014451.2275941-3-kent.overstreet@linux.dev>
In-Reply-To: <20241118014451.2275941-1-kent.overstreet@linux.dev>
References: <20241118014451.2275941-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Better helpers for iterating over backpointers within a specific bucket

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/backpointers.h | 10 ++++++++++
 fs/bcachefs/ec.c           |  5 +++--
 fs/bcachefs/move.c         |  5 ++---
 3 files changed, 15 insertions(+), 5 deletions(-)

diff --git a/fs/bcachefs/backpointers.h b/fs/bcachefs/backpointers.h
index eda3a78a5e2b..595db7960939 100644
--- a/fs/bcachefs/backpointers.h
+++ b/fs/bcachefs/backpointers.h
@@ -80,6 +80,16 @@ static inline struct bpos bucket_pos_to_bp(const struct bch_dev *ca,
 	return ret;
 }
 
+static inline struct bpos bucket_pos_to_bp_start(const struct bch_dev *ca, struct bpos bucket)
+{
+	return bucket_pos_to_bp(ca, bucket, 0);
+}
+
+static inline struct bpos bucket_pos_to_bp_end(const struct bch_dev *ca, struct bpos bucket)
+{
+	return bpos_nosnap_predecessor(bucket_pos_to_bp(ca, bpos_nosnap_successor(bucket), 0));
+}
+
 int bch2_bucket_backpointer_mod_nowritebuffer(struct btree_trans *, struct bch_dev *,
 				struct bpos bucket, struct bch_backpointer, struct bkey_s_c, bool);
 
diff --git a/fs/bcachefs/ec.c b/fs/bcachefs/ec.c
index aa8ada4f0ec0..a4a2555d7c4f 100644
--- a/fs/bcachefs/ec.c
+++ b/fs/bcachefs/ec.c
@@ -1374,8 +1374,9 @@ static int ec_stripe_update_bucket(struct btree_trans *trans, struct ec_stripe_b
 
 	struct bpos bucket_pos = PTR_BUCKET_POS(ca, &ptr);
 
-	ret = for_each_btree_key_commit(trans, bp_iter, BTREE_ID_backpointers,
-			bucket_pos_to_bp(ca, bucket_pos, 0), 0, bp_k,
+	ret = for_each_btree_key_max_commit(trans, bp_iter, BTREE_ID_backpointers,
+			bucket_pos_to_bp_start(ca, bucket_pos),
+			bucket_pos_to_bp_end(ca, bucket_pos), 0, bp_k,
 			NULL, NULL,
 			BCH_TRANS_COMMIT_no_check_rw|
 			BCH_TRANS_COMMIT_no_enospc, ({
diff --git a/fs/bcachefs/move.c b/fs/bcachefs/move.c
index 88ab9d7e1a1b..8c032ef3a567 100644
--- a/fs/bcachefs/move.c
+++ b/fs/bcachefs/move.c
@@ -692,7 +692,7 @@ int bch2_evacuate_bucket(struct moving_context *ctxt,
 	bch2_trans_begin(trans);
 
 	bch2_trans_iter_init(trans, &bp_iter, BTREE_ID_backpointers,
-			     bucket_pos_to_bp(ca, bucket, 0), 0);
+			     bucket_pos_to_bp_start(ca, bucket), 0);
 
 	bch_err_msg(c, ret, "looking up alloc key");
 	if (ret)
@@ -716,8 +716,7 @@ int bch2_evacuate_bucket(struct moving_context *ctxt,
 		if (ret)
 			goto err;
 
-		if (!k.k ||
-		    bkey_ge(k.k->p, bucket_pos_to_bp(ca, bpos_nosnap_successor(bucket), 0)))
+		if (!k.k || bkey_gt(k.k->p, bucket_pos_to_bp_end(ca, bucket)))
 			break;
 
 		if (k.k->type != KEY_TYPE_backpointer)
-- 
2.45.2


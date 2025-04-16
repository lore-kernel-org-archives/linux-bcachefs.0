Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEC7E1B6D06
	for <linux-bcachefs@vger.kernel.org>; Wed, 16 Apr 2025 13:43:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744811041; cv=none; b=A8+HtiQs0kzIacp2hJNLEp04kXDgeZOLeLbCNchkVrNuoAXQnwJGsaXBQ2R72Hlii1xDbf3ijZKMFKlLpwCkvANvpchlGcTPJqi1TWuPyEyRqtIVdONwdLKBbti7bhEdgGMretP9Pl46rKaWdf6PgtOSnHtXRV4oM0WWy1igvAY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744811041; c=relaxed/simple;
	bh=i+xGGY65sl3DVdAixkytuHZh5DE/xPoIFZxu2BUYgXs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q1WJcfaLTmk463DbJg1MSawK277eFwrANbSjCoiiXTVniJQaJAKrh5JkbwI1O958j9gNtLwzCO/uV8F5AKVOIdos6w6p/761ZSx3i/E7/pfehbA1jRImPeYywPAsVoQN044WFg86VRJasQBzJcNAgLoddXvCmW6p7ewdiCvS9DA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=bnR4HfpM; arc=none smtp.client-ip=91.218.175.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="bnR4HfpM"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1744811037;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vKu5vAiK0fSv3omb6b9rFu6iDQ6py0/ybwqZD7rBhlg=;
	b=bnR4HfpMD5bnN0XCjKodZHu9G8u0A1j9HO0dZrihdmAQuurzps5ydRPKSd/iuXOUP8nBWB
	LIiphOLHBhwEnp53wkGW1V/mU4fo5Chmm6H1vVnPF3Y1HcSxNC6w3VkDXj4WWIDRZSAKX/
	W6CFxVS7JN6jD6ITrjBX0fRFb9njqlA=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 2/4] bcachefs: plumb btree_id through move_pred_fd
Date: Wed, 16 Apr 2025 09:43:47 -0400
Message-ID: <20250416134352.3654545-3-kent.overstreet@linux.dev>
In-Reply-To: <20250416134352.3654545-1-kent.overstreet@linux.dev>
References: <20250416134352.3654545-1-kent.overstreet@linux.dev>
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
 fs/bcachefs/move.c      | 20 +++++++++++---------
 fs/bcachefs/move.h      |  2 +-
 fs/bcachefs/rebalance.c |  2 +-
 3 files changed, 13 insertions(+), 11 deletions(-)

diff --git a/fs/bcachefs/move.c b/fs/bcachefs/move.c
index 983dbba2d3c4..f41913ea85e4 100644
--- a/fs/bcachefs/move.c
+++ b/fs/bcachefs/move.c
@@ -667,7 +667,7 @@ static int bch2_move_data_btree(struct moving_context *ctxt,
 			continue;
 
 		memset(&data_opts, 0, sizeof(data_opts));
-		if (!pred(c, arg, k, io_opts, &data_opts))
+		if (!pred(c, arg, extent_iter->btree_id, k, io_opts, &data_opts))
 			goto next;
 
 		/*
@@ -850,7 +850,7 @@ static int __bch2_move_data_phys(struct moving_context *ctxt,
 		}
 
 		struct data_update_opts data_opts = {};
-		if (!pred(c, arg, k, &io_opts, &data_opts)) {
+		if (!pred(c, arg, bp.v->btree_id, k, &io_opts, &data_opts)) {
 			bch2_trans_iter_exit(trans, &iter);
 			goto next;
 		}
@@ -933,7 +933,8 @@ struct evacuate_bucket_arg {
 	struct data_update_opts	data_opts;
 };
 
-static bool evacuate_bucket_pred(struct bch_fs *c, void *_arg, struct bkey_s_c k,
+static bool evacuate_bucket_pred(struct bch_fs *c, void *_arg,
+				 enum btree_id btree, struct bkey_s_c k,
 				 struct bch_io_opts *io_opts,
 				 struct data_update_opts *data_opts)
 {
@@ -1047,7 +1048,7 @@ static int bch2_move_btree(struct bch_fs *c,
 }
 
 static bool rereplicate_pred(struct bch_fs *c, void *arg,
-			     struct bkey_s_c k,
+			     enum btree_id btree, struct bkey_s_c k,
 			     struct bch_io_opts *io_opts,
 			     struct data_update_opts *data_opts)
 {
@@ -1079,7 +1080,7 @@ static bool rereplicate_pred(struct bch_fs *c, void *arg,
 }
 
 static bool migrate_pred(struct bch_fs *c, void *arg,
-			 struct bkey_s_c k,
+			 enum btree_id btree, struct bkey_s_c k,
 			 struct bch_io_opts *io_opts,
 			 struct data_update_opts *data_opts)
 {
@@ -1106,7 +1107,7 @@ static bool rereplicate_btree_pred(struct bch_fs *c, void *arg,
 				   struct bch_io_opts *io_opts,
 				   struct data_update_opts *data_opts)
 {
-	return rereplicate_pred(c, arg, bkey_i_to_s_c(&b->key), io_opts, data_opts);
+	return rereplicate_pred(c, arg, b->c.btree_id, bkey_i_to_s_c(&b->key), io_opts, data_opts);
 }
 
 /*
@@ -1162,7 +1163,7 @@ int bch2_scan_old_btree_nodes(struct bch_fs *c, struct bch_move_stats *stats)
 }
 
 static bool drop_extra_replicas_pred(struct bch_fs *c, void *arg,
-			     struct bkey_s_c k,
+			     enum btree_id btree, struct bkey_s_c k,
 			     struct bch_io_opts *io_opts,
 			     struct data_update_opts *data_opts)
 {
@@ -1195,11 +1196,12 @@ static bool drop_extra_replicas_btree_pred(struct bch_fs *c, void *arg,
 				   struct bch_io_opts *io_opts,
 				   struct data_update_opts *data_opts)
 {
-	return drop_extra_replicas_pred(c, arg, bkey_i_to_s_c(&b->key), io_opts, data_opts);
+	return drop_extra_replicas_pred(c, arg, b->c.btree_id, bkey_i_to_s_c(&b->key),
+					io_opts, data_opts);
 }
 
 static bool scrub_pred(struct bch_fs *c, void *_arg,
-		       struct bkey_s_c k,
+		       enum btree_id btree, struct bkey_s_c k,
 		       struct bch_io_opts *io_opts,
 		       struct data_update_opts *data_opts)
 {
diff --git a/fs/bcachefs/move.h b/fs/bcachefs/move.h
index 1ab6dd4621d6..9c6c229e583e 100644
--- a/fs/bcachefs/move.h
+++ b/fs/bcachefs/move.h
@@ -72,7 +72,7 @@ do {									\
 		break;							\
 } while (1)
 
-typedef bool (*move_pred_fn)(struct bch_fs *, void *, struct bkey_s_c,
+typedef bool (*move_pred_fn)(struct bch_fs *, void *, enum btree_id, struct bkey_s_c,
 			     struct bch_io_opts *, struct data_update_opts *);
 
 extern const char * const bch2_data_ops_strs[];
diff --git a/fs/bcachefs/rebalance.c b/fs/bcachefs/rebalance.c
index d63de50f6323..2f0f8782105e 100644
--- a/fs/bcachefs/rebalance.c
+++ b/fs/bcachefs/rebalance.c
@@ -454,7 +454,7 @@ static int do_rebalance_extent(struct moving_context *ctxt,
 }
 
 static bool rebalance_pred(struct bch_fs *c, void *arg,
-			   struct bkey_s_c k,
+			   enum btree_id btree, struct bkey_s_c k,
 			   struct bch_io_opts *io_opts,
 			   struct data_update_opts *data_opts)
 {
-- 
2.49.0


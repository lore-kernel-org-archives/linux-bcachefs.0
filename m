Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B8301754B
	for <linux-bcachefs@vger.kernel.org>; Thu, 22 May 2025 17:00:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747933227; cv=none; b=KWM+DYDfpeMp/taICM6oSG6RpT4H9jyN9SJTbZ6OIeQGQdN5dWaSytt9ScawuJE2rinc1/eiNnCYi0Q4g26XAY3gHWKEfGCEHSWmonGer2q0V/Uao4kxrW5zl6ask7MPCtmJzSKbWH9uI8V5FQb995kcdTiSwLPb2yGW4QZ/uJ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747933227; c=relaxed/simple;
	bh=8bycyAX2CnGRWEPfe5QqxjtD/hKLSMfQtjlluZMWa0U=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=HHjGBzE3dEfXG2WN9x7YvSvntFVOXRzyv3NEyjE+RAjkvt+7oFkjbPnBYMEWvZ68PA3IVQ5WPX3rfwmi9xWSvHENTAF+1t7c+YsZ7nXqE6M65U7oprsjw+lH4r48Tj1BY1IaXsEA2n9GwqHxC4x0obXVE7+UQHqUSmso4Q2rfOE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=FBndKRP7; arc=none smtp.client-ip=91.218.175.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="FBndKRP7"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1747933223;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=QaJCO4NPw0lmVfHRFMR+NAX5BhcPb9kBlRlDLeirRDo=;
	b=FBndKRP7/k2vddA4mNOFWHMvgVkdvMs23c+AFSyyjACHnIKGtXgg5vhLWG4xqls+HEXbKE
	FJwyjFWyejK9nEbYAJ97tkToXcSBD2ca3vsQfGWBYzPm9/RXpPmcJVMl/yVTQp3YYiq91z
	5FPLFm2fPL058VSTOx+s3b/zcPJZdHQ=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 1/3] bcachefs: Kill bkey_buf usage in data_update_index_update()
Date: Thu, 22 May 2025 13:00:17 -0400
Message-ID: <20250522170019.2909181-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Reduce stack usage - bkey_buf has a 96 byte buffer on the stack, but the
btree_trans bump allocator works just fine here.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/data_update.c | 26 +++++++++++++++-----------
 1 file changed, 15 insertions(+), 11 deletions(-)

diff --git a/fs/bcachefs/data_update.c b/fs/bcachefs/data_update.c
index de096ca65b4b..ef648a6d9c52 100644
--- a/fs/bcachefs/data_update.c
+++ b/fs/bcachefs/data_update.c
@@ -187,14 +187,9 @@ static int __bch2_data_update_index_update(struct btree_trans *trans,
 	struct data_update *m =
 		container_of(op, struct data_update, op);
 	struct keylist *keys = &op->insert_keys;
-	struct bkey_buf _new, _insert;
 	struct printbuf journal_msg = PRINTBUF;
 	int ret = 0;
 
-	bch2_bkey_buf_init(&_new);
-	bch2_bkey_buf_init(&_insert);
-	bch2_bkey_buf_realloc(&_insert, c, U8_MAX);
-
 	bch2_trans_iter_init(trans, &iter, m->btree_id,
 			     bkey_start_pos(&bch2_keylist_front(keys)->k),
 			     BTREE_ITER_slots|BTREE_ITER_intent);
@@ -229,11 +224,22 @@ static int __bch2_data_update_index_update(struct btree_trans *trans,
 			goto nowork;
 		}
 
-		bkey_reassemble(_insert.k, k);
-		insert = _insert.k;
+		insert = bch2_trans_kmalloc(trans,
+					    bkey_bytes(k.k) +
+					    bkey_val_bytes(&new->k) +
+					    sizeof(struct bch_extent_rebalance));
+		ret = PTR_ERR_OR_ZERO(insert);
+		if (ret)
+			goto err;
+
+		bkey_reassemble(insert, k);
+
+		new = bch2_trans_kmalloc(trans, bkey_bytes(&new->k));
+		ret = PTR_ERR_OR_ZERO(new);
+		if (ret)
+			goto err;
 
-		bch2_bkey_buf_copy(&_new, c, bch2_keylist_front(keys));
-		new = bkey_i_to_extent(_new.k);
+		bkey_copy(&new->k_i, bch2_keylist_front(keys));
 		bch2_cut_front(iter.pos, &new->k_i);
 
 		bch2_cut_front(iter.pos,	insert);
@@ -457,8 +463,6 @@ static int __bch2_data_update_index_update(struct btree_trans *trans,
 out:
 	printbuf_exit(&journal_msg);
 	bch2_trans_iter_exit(trans, &iter);
-	bch2_bkey_buf_exit(&_insert, c);
-	bch2_bkey_buf_exit(&_new, c);
 	BUG_ON(bch2_err_matches(ret, BCH_ERR_transaction_restart));
 	return ret;
 }
-- 
2.49.0


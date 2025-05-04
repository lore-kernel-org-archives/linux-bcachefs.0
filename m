Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 236C31DE4C2
	for <linux-bcachefs@vger.kernel.org>; Sun,  4 May 2025 19:52:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746388336; cv=none; b=OlUNoZxMfeEfpgsOdvEN7wY5xLf0a1wj9UWz58EoLJ3z8edhVNA31ODmScRd8oJ5B+mXwJtvd083HpYfFD3tlaZb6PIJa4njfn6dSrGltaiX6V+S2X3RvRoXuGrJQBwILTzteAfXZWX7oMPpj7eF5EiJx0BZ6zb3MFZC4cVTMJs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746388336; c=relaxed/simple;
	bh=VL8lrTqQKRVTljqIaFWdEPsUBl/Ug0p20X8upqyB5dQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kQIjqx5qjN/cpWkk5w6lN0wCcrkXPjG/DcgjpKPed6oFHIQiV9Q6+qZXQwWug3Cna7eZaTyBYPNNS/EunAUOK7qwioUlHj1c+1wB0jN7fVuE2ldey5fg2BcbnKyvQEjUM3r1VDYAZVkUBbC8ZJ2wAmuqNv2Ef1blTWNG/0YynkU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=NgiklYPx; arc=none smtp.client-ip=91.218.175.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="NgiklYPx"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1746388331;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=q4nBcchKC4kmZxT7+7TCnp3bOMkLBqs1/DSfgv1i6Q4=;
	b=NgiklYPx9tjVJYcllwbR0mrmIMGQJfZwBS3BN69X7eztzBv/kMjefr6wbN/CCdXRInriuq
	OdXgkxiWF0TKw+fIUaZKVamt/pVYa86decqq08t7WlPod63uM/lqNYTZEY114Bu0BtsyTB
	qOFWd7rZSJxOvRxTalCU6lV1l6g1jsQ=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 2/3] bcachefs: bch2_dev_data_drop_by_backpointers()
Date: Sun,  4 May 2025 15:51:58 -0400
Message-ID: <20250504195202.2073437-3-kent.overstreet@linux.dev>
In-Reply-To: <20250504195202.2073437-1-kent.overstreet@linux.dev>
References: <20250504195202.2073437-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Currently, device removal has to scan all metadata for pointers to the
device being removed.

Add a new method, with the same interface as bch2_dev_data_drop(), that
scans by backpointers instead - this will drastically speed up device
removal.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/migrate.c | 107 ++++++++++++++++++++++++++++++++++++------
 fs/bcachefs/migrate.h |   3 +-
 2 files changed, 95 insertions(+), 15 deletions(-)

diff --git a/fs/bcachefs/migrate.c b/fs/bcachefs/migrate.c
index 90dcf80bd64a..f431586a971f 100644
--- a/fs/bcachefs/migrate.c
+++ b/fs/bcachefs/migrate.c
@@ -4,9 +4,11 @@
  */
 
 #include "bcachefs.h"
+#include "backpointers.h"
 #include "bkey_buf.h"
 #include "btree_update.h"
 #include "btree_update_interior.h"
+#include "btree_write_buffer.h"
 #include "buckets.h"
 #include "errcode.h"
 #include "extents.h"
@@ -20,7 +22,7 @@
 #include "super-io.h"
 
 static int drop_dev_ptrs(struct bch_fs *c, struct bkey_s k,
-			 unsigned dev_idx, int flags, bool metadata)
+			 unsigned dev_idx, unsigned flags, bool metadata)
 {
 	unsigned replicas = metadata ? c->opts.metadata_replicas : c->opts.data_replicas;
 	unsigned lost = metadata ? BCH_FORCE_IF_METADATA_LOST : BCH_FORCE_IF_DATA_LOST;
@@ -37,11 +39,28 @@ static int drop_dev_ptrs(struct bch_fs *c, struct bkey_s k,
 	return 0;
 }
 
+static int drop_btree_ptrs(struct btree_trans *trans, struct btree_iter *iter,
+			   struct btree *b, unsigned dev_idx, unsigned flags)
+{
+	struct bch_fs *c = trans->c;
+	struct bkey_buf k;
+
+	bch2_bkey_buf_init(&k);
+	bch2_bkey_buf_copy(&k, c, &b->key);
+
+	int ret = drop_dev_ptrs(c, bkey_i_to_s(k.k), dev_idx, flags, true) ?:
+		bch2_btree_node_update_key(trans, iter, b, k.k, 0, false);
+
+	bch_err_fn(c, ret);
+	bch2_bkey_buf_exit(&k, c);
+	return ret;
+}
+
 static int bch2_dev_usrdata_drop_key(struct btree_trans *trans,
 				     struct btree_iter *iter,
 				     struct bkey_s_c k,
 				     unsigned dev_idx,
-				     int flags)
+				     unsigned flags)
 {
 	struct bch_fs *c = trans->c;
 	struct bkey_i *n;
@@ -77,9 +96,27 @@ static int bch2_dev_usrdata_drop_key(struct btree_trans *trans,
 	return 0;
 }
 
+static int bch2_dev_btree_drop_key(struct btree_trans *trans,
+				   struct bkey_s_c_backpointer bp,
+				   unsigned dev_idx,
+				   struct bkey_buf *last_flushed,
+				   unsigned flags)
+{
+	struct btree_iter iter;
+	struct btree *b = bch2_backpointer_get_node(trans, bp, &iter, last_flushed);
+	int ret = PTR_ERR_OR_ZERO(b);
+	if (ret)
+		return ret == -BCH_ERR_backpointer_to_overwritten_btree_node ? 0 : ret;
+
+	ret = drop_btree_ptrs(trans, &iter, b, dev_idx, flags);
+
+	bch2_trans_iter_exit(trans, &iter);
+	return ret;
+}
+
 static int bch2_dev_usrdata_drop(struct bch_fs *c,
 				 struct progress_indicator_state *progress,
-				 unsigned dev_idx, int flags)
+				 unsigned dev_idx, unsigned flags)
 {
 	struct btree_trans *trans = bch2_trans_get(c);
 	enum btree_id id;
@@ -106,7 +143,7 @@ static int bch2_dev_usrdata_drop(struct bch_fs *c,
 
 static int bch2_dev_metadata_drop(struct bch_fs *c,
 				  struct progress_indicator_state *progress,
-				  unsigned dev_idx, int flags)
+				  unsigned dev_idx, unsigned flags)
 {
 	struct btree_trans *trans;
 	struct btree_iter iter;
@@ -137,20 +174,12 @@ static int bch2_dev_metadata_drop(struct bch_fs *c,
 			if (!bch2_bkey_has_device_c(bkey_i_to_s_c(&b->key), dev_idx))
 				goto next;
 
-			bch2_bkey_buf_copy(&k, c, &b->key);
-
-			ret = drop_dev_ptrs(c, bkey_i_to_s(k.k),
-					    dev_idx, flags, true);
-			if (ret)
-				break;
-
-			ret = bch2_btree_node_update_key(trans, &iter, b, k.k, 0, false);
+			ret = drop_btree_ptrs(trans, &iter, b, dev_idx, flags);
 			if (bch2_err_matches(ret, BCH_ERR_transaction_restart)) {
 				ret = 0;
 				continue;
 			}
 
-			bch_err_msg(c, ret, "updating btree node key");
 			if (ret)
 				break;
 next:
@@ -176,7 +205,57 @@ static int bch2_dev_metadata_drop(struct bch_fs *c,
 	return ret;
 }
 
-int bch2_dev_data_drop(struct bch_fs *c, unsigned dev_idx, int flags)
+static int data_drop_bp(struct btree_trans *trans, unsigned dev_idx,
+			struct bkey_s_c_backpointer bp, struct bkey_buf *last_flushed,
+			unsigned flags)
+{
+	struct btree_iter iter;
+	struct bkey_s_c k = bch2_backpointer_get_key(trans, bp, &iter, 0, last_flushed);
+	int ret = bkey_err(k);
+	if (ret == -BCH_ERR_backpointer_to_overwritten_btree_node)
+		return 0;
+	if (ret)
+		return ret;
+
+	if (!bch2_bkey_has_device_c(k, dev_idx))
+		goto out;
+
+	ret = bkey_is_btree_ptr(k.k)
+		? bch2_dev_btree_drop_key(trans, bp, dev_idx, last_flushed, flags)
+		: bch2_dev_usrdata_drop_key(trans, &iter, k, dev_idx, flags);
+out:
+	bch2_trans_iter_exit(trans, &iter);
+	return ret;
+}
+
+int bch2_dev_data_drop_by_backpointers(struct bch_fs *c, unsigned dev_idx, unsigned flags)
+{
+	struct btree_trans *trans = bch2_trans_get(c);
+
+	struct bkey_buf last_flushed;
+	bch2_bkey_buf_init(&last_flushed);
+	bkey_init(&last_flushed.k->k);
+
+	int ret = bch2_btree_write_buffer_flush_sync(trans) ?:
+		for_each_btree_key_max_commit(trans, iter, BTREE_ID_backpointers,
+				POS(dev_idx, 0),
+				POS(dev_idx, U64_MAX), 0, k,
+				NULL, NULL, BCH_TRANS_COMMIT_no_enospc, ({
+			if (k.k->type != KEY_TYPE_backpointer)
+				continue;
+
+			data_drop_bp(trans, dev_idx, bkey_s_c_to_backpointer(k),
+				     &last_flushed, flags);
+
+	}));
+
+	bch2_bkey_buf_exit(&last_flushed, trans->c);
+	bch2_trans_put(trans);
+	bch_err_fn(c, ret);
+	return ret;
+}
+
+int bch2_dev_data_drop(struct bch_fs *c, unsigned dev_idx, unsigned flags)
 {
 	struct progress_indicator_state progress;
 	bch2_progress_init(&progress, c,
diff --git a/fs/bcachefs/migrate.h b/fs/bcachefs/migrate.h
index 027efaa0d575..30018140711b 100644
--- a/fs/bcachefs/migrate.h
+++ b/fs/bcachefs/migrate.h
@@ -2,6 +2,7 @@
 #ifndef _BCACHEFS_MIGRATE_H
 #define _BCACHEFS_MIGRATE_H
 
-int bch2_dev_data_drop(struct bch_fs *, unsigned, int);
+int bch2_dev_data_drop_by_backpointers(struct bch_fs *, unsigned, unsigned);
+int bch2_dev_data_drop(struct bch_fs *, unsigned, unsigned);
 
 #endif /* _BCACHEFS_MIGRATE_H */
-- 
2.49.0


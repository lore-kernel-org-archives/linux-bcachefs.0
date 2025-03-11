Received: from out-187.mta0.migadu.com (out-187.mta0.migadu.com [91.218.175.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D82C51CAA87
	for <linux-bcachefs@vger.kernel.org>; Tue, 11 Mar 2025 20:15:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741724138; cv=none; b=AgJANSk90n5EQMoxHeCAV31W2x10MxqmVBD3JFWDZKuQ5RvqhimQzD1SktFvzqJGxVpTCL5MiaxD3qdp0rA0toX0VxMzGdMCRW/GKGBXjYcOMNF/tQAwknZCfINrsGYEDzItnVjjaFTwOXR7tEC7HtaQow/FEc6Tf4s4yn30VoA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741724138; c=relaxed/simple;
	bh=hKEBsPBNOeswaCFRWWbFBhKJzsS4Q1dvLkjmGsA2JOc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GPOBjfSw3M3hO8GGe7mjqYaT0e+Fq06Dcl9dop77sHLcdFn3AO0Toj/nDimEO6tv8MeAgRqAsaFU7wgHf91mhf3KshutvJKWzTYqKMDX3e/AqviYhUUFAixUk0Njsbwd91uAZeBmVsCUKCQz5wXbNqhnYLWDeP2EIgItJIpj1J8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=GCtbihfP; arc=none smtp.client-ip=91.218.175.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="GCtbihfP"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1741724135;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9oEysWWcHFJi4gmJuM1nF1Y75ThsuAXPeq+wn+4ASLw=;
	b=GCtbihfPMggFqk8qDEgK+vpq3i3fwLJ+zzuVuQlVme5NgFTZatbI+jcS6M/i2Zww6YJNeg
	9pS6mgrTn4zN2zvj8Vfcl1U7reVO4C4edavpin9dyTe8WWlnDnzixCsUrQLWsjowWprghG
	QAAWyDv6hzfhr2OGjS1SUxCLRder59o=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 09/14] bcachefs: __bch2_read() now takes a btree_trans
Date: Tue, 11 Mar 2025 16:15:11 -0400
Message-ID: <20250311201518.3573009-10-kent.overstreet@linux.dev>
In-Reply-To: <20250311201518.3573009-1-kent.overstreet@linux.dev>
References: <20250311201518.3573009-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Next patch will be checking if the extent we're reading from matches the
IO failure we saw before marking the failure.

For this to work, __bch2_read() needs to take the same transaction
context that bch2_rbio_retry() uses to do that check.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/io_read.c | 90 ++++++++++++++++++++++++++++++++++---------
 fs/bcachefs/io_read.h | 12 +++---
 2 files changed, 79 insertions(+), 23 deletions(-)

diff --git a/fs/bcachefs/io_read.c b/fs/bcachefs/io_read.c
index 40a23e779e6c..b5bcd08fc983 100644
--- a/fs/bcachefs/io_read.c
+++ b/fs/bcachefs/io_read.c
@@ -416,13 +416,53 @@ static void bch2_rbio_done(struct bch_read_bio *rbio)
 	bio_endio(&rbio->bio);
 }
 
-static noinline int bch2_read_retry_nodecode(struct bch_fs *c, struct bch_read_bio *rbio,
-				     struct bvec_iter bvec_iter,
-				     struct bch_io_failures *failed,
-				     unsigned flags)
+static struct bkey_s_c get_rbio_extent(struct btree_trans *trans,
+				       struct bch_read_bio *rbio,
+				       struct btree_iter *iter)
+{
+	if (rbio->flags & BCH_READ_data_update) {
+		struct data_update *u = container_of(rbio, struct data_update, rbio);
+
+		return bch2_bkey_get_iter(trans, iter,
+					  u->btree_id, bkey_start_pos(&u->k.k->k), 0);
+	} else {
+		struct bpos pos = rbio->read_pos;
+		int ret = bch2_subvolume_get_snapshot(trans, rbio->subvol, &pos.snapshot);
+		if (ret)
+			return bkey_s_c_err(ret);
+
+		return bch2_bkey_get_iter(trans, iter, BTREE_ID_extents, pos, 0);
+	}
+}
+
+static void mark_io_failure_if_current_extent_matches(struct btree_trans *trans,
+						      struct bch_read_bio *rbio,
+						      struct bch_io_failures *failed)
+{
+	struct btree_iter iter = {};
+	struct bkey_s_c k;
+	int ret = lockrestart_do(trans,
+				 bkey_err(k = get_rbio_extent(trans, rbio, &iter)));
+
+	if (!ret) {
+		struct bkey_ptrs_c ptrs = bch2_bkey_ptrs_c(k);
+
+		bkey_for_each_ptr(ptrs, ptr)
+			if (bch2_extent_ptr_eq(*ptr, rbio->pick.ptr))
+				bch2_mark_io_failure(failed, &rbio->pick,
+					rbio->ret == -BCH_ERR_data_read_retry_csum_err);
+	}
+
+	bch2_trans_iter_exit(trans, &iter);
+}
+
+static noinline int bch2_read_retry_nodecode(struct btree_trans *trans,
+					struct bch_read_bio *rbio,
+					struct bvec_iter bvec_iter,
+					struct bch_io_failures *failed,
+					unsigned flags)
 {
 	struct data_update *u = container_of(rbio, struct data_update, rbio);
-	struct btree_trans *trans = bch2_trans_get(c);
 retry:
 	bch2_trans_begin(trans);
 
@@ -458,8 +498,6 @@ static noinline int bch2_read_retry_nodecode(struct bch_fs *c, struct bch_read_b
 	}
 
 	BUG_ON(atomic_read(&rbio->bio.__bi_remaining) != 1);
-	bch2_trans_put(trans);
-
 	return ret;
 }
 
@@ -475,14 +513,14 @@ static void bch2_rbio_retry(struct work_struct *work)
 		.inum	= rbio->read_pos.inode,
 	};
 	struct bch_io_failures failed = { .nr = 0 };
+	struct btree_trans *trans = bch2_trans_get(c);
 
 	trace_io_read_retry(&rbio->bio);
 	this_cpu_add(c->counters[BCH_COUNTER_io_read_retry],
 		     bvec_iter_sectors(rbio->bvec_iter));
 
 	if (bch2_err_matches(rbio->ret, BCH_ERR_data_read_retry_avoid))
-		bch2_mark_io_failure(&failed, &rbio->pick,
-				     rbio->ret == -BCH_ERR_data_read_retry_csum_err);
+		mark_io_failure_if_current_extent_matches(trans, rbio, &failed);
 
 	if (!rbio->split) {
 		rbio->bio.bi_status	= 0;
@@ -500,8 +538,8 @@ static void bch2_rbio_retry(struct work_struct *work)
 	flags |= BCH_READ_must_clone;
 
 	int ret = flags & BCH_READ_data_update
-		? bch2_read_retry_nodecode(c, rbio, iter, &failed, flags)
-		: __bch2_read(c, rbio, iter, inum, &failed, flags);
+		? bch2_read_retry_nodecode(trans, rbio, iter, &failed, flags)
+		: __bch2_read(trans, rbio, iter, inum, &failed, flags);
 
 	if (ret) {
 		rbio->ret = ret;
@@ -509,7 +547,7 @@ static void bch2_rbio_retry(struct work_struct *work)
 	} else {
 		struct printbuf buf = PRINTBUF;
 
-		bch2_trans_do(c,
+		lockrestart_do(trans,
 			bch2_inum_offset_err_msg_trans(trans, &buf,
 					(subvol_inum) { subvol, read_pos.inode },
 					read_pos.offset << 9));
@@ -522,6 +560,7 @@ static void bch2_rbio_retry(struct work_struct *work)
 	}
 
 	bch2_rbio_done(rbio);
+	bch2_trans_put(trans);
 }
 
 static void bch2_rbio_error(struct bch_read_bio *rbio,
@@ -1241,11 +1280,11 @@ int __bch2_read_extent(struct btree_trans *trans, struct bch_read_bio *orig,
 	return 0;
 }
 
-int __bch2_read(struct bch_fs *c, struct bch_read_bio *rbio,
-		 struct bvec_iter bvec_iter, subvol_inum inum,
-		 struct bch_io_failures *failed, unsigned flags)
+int __bch2_read(struct btree_trans *trans, struct bch_read_bio *rbio,
+		struct bvec_iter bvec_iter, subvol_inum inum,
+		struct bch_io_failures *failed, unsigned flags)
 {
-	struct btree_trans *trans = bch2_trans_get(c);
+	struct bch_fs *c = trans->c;
 	struct btree_iter iter;
 	struct bkey_buf sk;
 	struct bkey_s_c k;
@@ -1278,6 +1317,23 @@ int __bch2_read(struct bch_fs *c, struct bch_read_bio *rbio,
 		if (ret)
 			goto err;
 
+		if (unlikely(flags & BCH_READ_in_retry)) {
+			struct data_update *u = flags & BCH_READ_data_update
+				? container_of(rbio, struct data_update, rbio)
+				: NULL;
+
+			if (u &&
+			    !bkey_and_val_eq(k, bkey_i_to_s_c(u->k.k))) {
+				/* extent we wanted to read no longer exists: */
+				ret = -BCH_ERR_data_read_key_overwritten;
+				goto err;
+			}
+
+			if (!bkey_deleted(&sk.k->k) &&
+			    !bkey_and_val_eq(k, bkey_i_to_s_c(sk.k)))
+				failed->nr = 0;
+		}
+
 		s64 offset_into_extent = iter.pos.offset -
 			bkey_start_offset(k.k);
 		unsigned sectors = k.k->size - offset_into_extent;
@@ -1342,9 +1398,7 @@ int __bch2_read(struct bch_fs *c, struct bch_read_bio *rbio,
 			bch2_rbio_done(rbio);
 	}
 
-	bch2_trans_put(trans);
 	bch2_bkey_buf_exit(&sk, c);
-
 	return ret;
 }
 
diff --git a/fs/bcachefs/io_read.h b/fs/bcachefs/io_read.h
index 42a22985d789..edcf50a4418c 100644
--- a/fs/bcachefs/io_read.h
+++ b/fs/bcachefs/io_read.h
@@ -3,6 +3,7 @@
 #define _BCACHEFS_IO_READ_H
 
 #include "bkey_buf.h"
+#include "btree_iter.h"
 #include "reflink.h"
 
 struct bch_read_bio {
@@ -140,7 +141,7 @@ static inline void bch2_read_extent(struct btree_trans *trans,
 			   data_btree, k, offset_into_extent, NULL, flags, -1);
 }
 
-int __bch2_read(struct bch_fs *, struct bch_read_bio *, struct bvec_iter,
+int __bch2_read(struct btree_trans *, struct bch_read_bio *, struct bvec_iter,
 		subvol_inum, struct bch_io_failures *, unsigned flags);
 
 static inline void bch2_read(struct bch_fs *c, struct bch_read_bio *rbio,
@@ -150,10 +151,11 @@ static inline void bch2_read(struct bch_fs *c, struct bch_read_bio *rbio,
 
 	rbio->subvol = inum.subvol;
 
-	__bch2_read(c, rbio, rbio->bio.bi_iter, inum, NULL,
-		    BCH_READ_retry_if_stale|
-		    BCH_READ_may_promote|
-		    BCH_READ_user_mapped);
+	bch2_trans_run(c,
+		__bch2_read(trans, rbio, rbio->bio.bi_iter, inum, NULL,
+			    BCH_READ_retry_if_stale|
+			    BCH_READ_may_promote|
+			    BCH_READ_user_mapped));
 }
 
 static inline struct bch_read_bio *rbio_init_fragment(struct bio *bio,
-- 
2.47.2


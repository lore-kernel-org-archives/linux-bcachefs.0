Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D6FA264A70
	for <linux-bcachefs@vger.kernel.org>; Tue, 11 Mar 2025 20:15:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741724139; cv=none; b=nWXF8MPp9H+XdXCqsEhhJIBglehKuZukt7Vif5VmXh9J2kxUeW8c1Tso5WSHGwmRsr16I8grZ07IpitAoE5Po3d/Eidxa1YmQS8isg9/7FhTswrb4/iGoRKIRTazW+D/+GU0d14eRICh5KQwcdpJq1ZpR5zZLO7/QEdYyO60d4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741724139; c=relaxed/simple;
	bh=HUj7j1alDpEFxOoy72+NZ/ol0wT0g+DAW/REEFIiPDM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mW6/Lh1a+YSc4LJ12iI/6U1wvxQLE8Tg5UiCERv/zcHxObR/mc5ITzOgeXpciH/0WnZa5Cji2Afk7XSpW9JTcV7zkVp5csek4CI78LAjMIVnRFfpupsirdEdnJQ4mvnh6i6JuezHvZWyti51hN3SFEZNQWy8WN/1xqG8j3M+HwU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=VjCWeb6A; arc=none smtp.client-ip=91.218.175.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="VjCWeb6A"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1741724135;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=13irsJYN8+xw/Vh31dlMxvxb8tBMoAspFXMTWgG7/L8=;
	b=VjCWeb6AEkFo/uZqFJvUWOcqOsaC7DjiKLLjUYs0yicSPu2nHuW0yWY3ACAsfbKiEmCGZe
	S0kMdohO0ZPzuTzJn6TJEakkBWYBkMGBJVdOv3/QcdSJVl0ljGRHhZfXj9uFrmHZHA9F7E
	WEelZxqknFrjPa13S3+dbPurAb+xhB4=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 10/14] bcachefs: Poison extents that can't be read due to checksum errors
Date: Tue, 11 Mar 2025 16:15:12 -0400
Message-ID: <20250311201518.3573009-11-kent.overstreet@linux.dev>
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

Copygc needs to be able to move extents that have bitrotted. We don't
want to delete them - in the future we'll have an API for "read me the
data even if there's checksum errors", and in general we don't want to
delete anything unless the user asks us to.

That will require writing it with a new checksum, which means we can't
forget that there was a checksum error so we return the correct error to
userspace.

Rebalance also wants to skip bad extents; we can now use the poison flag
for that.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/io_read.c | 60 +++++++++++++++++++++++++++++++++++++++----
 1 file changed, 55 insertions(+), 5 deletions(-)

diff --git a/fs/bcachefs/io_read.c b/fs/bcachefs/io_read.c
index b5bcd08fc983..4fd5a4e646e0 100644
--- a/fs/bcachefs/io_read.c
+++ b/fs/bcachefs/io_read.c
@@ -456,6 +456,47 @@ static void mark_io_failure_if_current_extent_matches(struct btree_trans *trans,
 	bch2_trans_iter_exit(trans, &iter);
 }
 
+static noinline int maybe_poison_extent(struct btree_trans *trans, struct bch_read_bio *rbio,
+					enum btree_id btree, struct bkey_s_c read_k)
+{
+	struct bch_fs *c = trans->c;
+
+	u64 flags = bch2_bkey_extent_flags(read_k);
+	if (flags & BIT_ULL(BCH_EXTENT_FLAG_poisoned))
+		return 0;
+
+	struct btree_iter iter;
+	struct bkey_s_c k = bch2_bkey_get_iter(trans, &iter, btree, bkey_start_pos(read_k.k),
+					       BTREE_ITER_intent);
+	int ret = bkey_err(k);
+	if (ret)
+		return ret;
+
+	if (!bkey_and_val_eq(k, read_k))
+		goto out;
+
+	struct bkey_i *new = bch2_trans_kmalloc(trans,
+					bkey_bytes(k.k) + sizeof(struct bch_extent_flags));
+	ret =   PTR_ERR_OR_ZERO(new) ?:
+		(bkey_reassemble(new, k), 0) ?:
+		bch2_bkey_extent_flags_set(c, new, flags|BIT_ULL(BCH_EXTENT_FLAG_poisoned)) ?:
+		bch2_trans_update(trans, &iter, new, BTREE_UPDATE_internal_snapshot_node) ?:
+		bch2_trans_commit(trans, NULL, NULL, 0);
+
+	if (!ret && (rbio->flags & BCH_READ_data_update)) {
+		/*
+		 * Propagate key change back to data update path, in particular
+		 * so it knows the extent has been poisoned and it's safe to
+		 * change the checksum
+		 */
+		struct data_update *u = container_of(rbio, struct data_update, rbio);
+		bch2_bkey_buf_copy(&u->k, c, new);
+	}
+out:
+	bch2_trans_iter_exit(trans, &iter);
+	return ret;
+}
+
 static noinline int bch2_read_retry_nodecode(struct btree_trans *trans,
 					struct bch_read_bio *rbio,
 					struct bvec_iter bvec_iter,
@@ -489,7 +530,8 @@ static noinline int bch2_read_retry_nodecode(struct btree_trans *trans,
 err:
 	bch2_trans_iter_exit(trans, &iter);
 
-	if (bch2_err_matches(ret, BCH_ERR_data_read_retry))
+	if (bch2_err_matches(ret, BCH_ERR_transaction_restart) ||
+	    bch2_err_matches(ret, BCH_ERR_data_read_retry))
 		goto retry;
 
 	if (ret) {
@@ -988,6 +1030,14 @@ int __bch2_read_extent(struct btree_trans *trans, struct bch_read_bio *orig,
 		goto hole;
 
 	if (unlikely(ret < 0)) {
+		if (ret == -BCH_ERR_data_read_csum_err) {
+			int ret2 = maybe_poison_extent(trans, orig, data_btree, k);
+			if (ret2) {
+				ret = ret2;
+				goto err;
+			}
+		}
+
 		struct printbuf buf = PRINTBUF;
 		bch2_read_err_msg_trans(trans, &buf, orig, read_pos);
 		prt_printf(&buf, "%s\n  ", bch2_err_str(ret));
@@ -1288,6 +1338,7 @@ int __bch2_read(struct btree_trans *trans, struct bch_read_bio *rbio,
 	struct btree_iter iter;
 	struct bkey_buf sk;
 	struct bkey_s_c k;
+	enum btree_id data_btree;
 	int ret;
 
 	BUG_ON(flags & BCH_READ_data_update);
@@ -1298,7 +1349,7 @@ int __bch2_read(struct btree_trans *trans, struct bch_read_bio *rbio,
 			     BTREE_ITER_slots);
 
 	while (1) {
-		enum btree_id data_btree = BTREE_ID_extents;
+		data_btree = BTREE_ID_extents;
 
 		bch2_trans_begin(trans);
 
@@ -1380,9 +1431,7 @@ int __bch2_read(struct btree_trans *trans, struct bch_read_bio *rbio,
 			break;
 	}
 
-	bch2_trans_iter_exit(trans, &iter);
-
-	if (ret) {
+	if (unlikely(ret)) {
 		struct printbuf buf = PRINTBUF;
 		lockrestart_do(trans,
 			bch2_inum_offset_err_msg_trans(trans, &buf, inum,
@@ -1398,6 +1447,7 @@ int __bch2_read(struct btree_trans *trans, struct bch_read_bio *rbio,
 			bch2_rbio_done(rbio);
 	}
 
+	bch2_trans_iter_exit(trans, &iter);
 	bch2_bkey_buf_exit(&sk, c);
 	return ret;
 }
-- 
2.47.2


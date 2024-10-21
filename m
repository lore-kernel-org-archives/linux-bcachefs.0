Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDBFA187FE4
	for <linux-bcachefs@vger.kernel.org>; Mon, 21 Oct 2024 03:41:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729482088; cv=none; b=cp9dbqVHEDUrE2uiQPPUcC+KZbfgQsMMGrtD1iYJh4sTkHIcIqFATZ9si2/XbZODgbjp5R+HF3QrRiJPtGWE0LE7Epoimxo2xtm8pp+C27+6mDqq2dlUtJvMdKDL73aylqFSFIXidd+8nkc+agg5ykypRv8aJqqV2HxTnq6DbIc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729482088; c=relaxed/simple;
	bh=jRbSthYO2pPva+g48o0++UnXd7RJTEIexrqsKTxRvwk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dQnYKKsviQRfaMzRocNDGIVIQTAlF7y87K1DhFy/Q6BisDpDdH71HDvdU4xC+EXdEbolMIXw8i4jjjAoTYJc6Gmnr15amobukeVQILHrZyDF7n6DLllqU8Ik7X+6mPdQS1dNlhHWrCbXjgm0ECFjS6KoL4CFpWvuLtM91g/pE5M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=xfNPyZvq; arc=none smtp.client-ip=91.218.175.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="xfNPyZvq"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1729482083;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GivOOF1AUMaUvoi9CBG2gFB7iU31aLJwwDlWtYAlUtI=;
	b=xfNPyZvqdmIPF42UPDipqpebuiGVccUyJYtQ+HQ8wr39DDMmOgtFNv15rTCXBVNmb/qNcS
	B8Zsavw+0Yv6M4bbJovAnYP/jokns7ommInnMVTYNFmATOeVWV7A9xgQA2d1fyKOTyofl/
	L0CnR31MqhzSRPE1B64ZqR0ETtO98JU=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 04/12] bcachefs: small cleanup for extent ptr bitmasks
Date: Sun, 20 Oct 2024 23:40:55 -0400
Message-ID: <20241021034106.384756-5-kent.overstreet@linux.dev>
In-Reply-To: <20241021034106.384756-1-kent.overstreet@linux.dev>
References: <20241021034106.384756-1-kent.overstreet@linux.dev>
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
 fs/bcachefs/data_update.c | 30 +++++++++++++++---------------
 fs/bcachefs/extents.c     | 12 ++++++------
 fs/bcachefs/io_read.c     |  6 +++---
 3 files changed, 24 insertions(+), 24 deletions(-)

diff --git a/fs/bcachefs/data_update.c b/fs/bcachefs/data_update.c
index a176e5439cbf..90da57a26962 100644
--- a/fs/bcachefs/data_update.c
+++ b/fs/bcachefs/data_update.c
@@ -189,7 +189,7 @@ static int __bch2_data_update_index_update(struct btree_trans *trans,
 		struct bpos next_pos;
 		bool should_check_enospc;
 		s64 i_sectors_delta = 0, disk_sectors_delta = 0;
-		unsigned rewrites_found = 0, durability, i;
+		unsigned rewrites_found = 0, durability, ptr_bit;
 
 		bch2_trans_begin(trans);
 
@@ -226,16 +226,16 @@ static int __bch2_data_update_index_update(struct btree_trans *trans,
 		 *
 		 * Fist, drop rewrite_ptrs from @new:
 		 */
-		i = 0;
+		ptr_bit = 1;
 		bkey_for_each_ptr_decode(old.k, bch2_bkey_ptrs_c(old), p, entry_c) {
-			if (((1U << i) & m->data_opts.rewrite_ptrs) &&
+			if ((ptr_bit & m->data_opts.rewrite_ptrs) &&
 			    (ptr = bch2_extent_has_ptr(old, p, bkey_i_to_s(insert))) &&
 			    !ptr->cached) {
 				bch2_extent_ptr_set_cached(c, &m->op.opts,
 							   bkey_i_to_s(insert), ptr);
-				rewrites_found |= 1U << i;
+				rewrites_found |= ptr_bit;
 			}
-			i++;
+			ptr_bit <<= 1;
 		}
 
 		if (m->data_opts.rewrite_ptrs &&
@@ -609,7 +609,7 @@ int bch2_data_update_init(struct btree_trans *trans,
 	struct bkey_ptrs_c ptrs = bch2_bkey_ptrs_c(k);
 	const union bch_extent_entry *entry;
 	struct extent_ptr_decoded p;
-	unsigned i, reserve_sectors = k.k->size * data_opts.extra_replicas;
+	unsigned reserve_sectors = k.k->size * data_opts.extra_replicas;
 	int ret = 0;
 
 	/*
@@ -652,17 +652,17 @@ int bch2_data_update_init(struct btree_trans *trans,
 
 	unsigned durability_have = 0, durability_removing = 0;
 
-	i = 0;
+	unsigned ptr_bit = 1;
 	bkey_for_each_ptr_decode(k.k, ptrs, p, entry) {
 		if (!p.ptr.cached) {
 			rcu_read_lock();
-			if (BIT(i) & m->data_opts.rewrite_ptrs) {
+			if (ptr_bit & m->data_opts.rewrite_ptrs) {
 				if (crc_is_compressed(p.crc))
 					reserve_sectors += k.k->size;
 
 				m->op.nr_replicas += bch2_extent_ptr_desired_durability(c, &p);
 				durability_removing += bch2_extent_ptr_desired_durability(c, &p);
-			} else if (!(BIT(i) & m->data_opts.kill_ptrs)) {
+			} else if (!(ptr_bit & m->data_opts.kill_ptrs)) {
 				bch2_dev_list_add_dev(&m->op.devs_have, p.ptr.dev);
 				durability_have += bch2_extent_ptr_durability(c, &p);
 			}
@@ -682,7 +682,7 @@ int bch2_data_update_init(struct btree_trans *trans,
 		if (p.crc.compression_type == BCH_COMPRESSION_TYPE_incompressible)
 			m->op.incompressible = true;
 
-		i++;
+		ptr_bit <<= 1;
 	}
 
 	unsigned durability_required = max(0, (int) (io_opts.data_replicas - durability_have));
@@ -745,14 +745,14 @@ int bch2_data_update_init(struct btree_trans *trans,
 void bch2_data_update_opts_normalize(struct bkey_s_c k, struct data_update_opts *opts)
 {
 	struct bkey_ptrs_c ptrs = bch2_bkey_ptrs_c(k);
-	unsigned i = 0;
+	unsigned ptr_bit = 1;
 
 	bkey_for_each_ptr(ptrs, ptr) {
-		if ((opts->rewrite_ptrs & (1U << i)) && ptr->cached) {
-			opts->kill_ptrs |= 1U << i;
-			opts->rewrite_ptrs ^= 1U << i;
+		if ((opts->rewrite_ptrs & ptr_bit) && ptr->cached) {
+			opts->kill_ptrs |= ptr_bit;
+			opts->rewrite_ptrs ^= ptr_bit;
 		}
 
-		i++;
+		ptr_bit <<= 1;
 	}
 }
diff --git a/fs/bcachefs/extents.c b/fs/bcachefs/extents.c
index f0d9390250c4..87e7969b55f4 100644
--- a/fs/bcachefs/extents.c
+++ b/fs/bcachefs/extents.c
@@ -1411,7 +1411,7 @@ unsigned bch2_bkey_ptrs_need_rebalance(struct bch_fs *c, struct bkey_s_c k,
 		unsigned compression_type = bch2_compression_opt_to_type(compression);
 		const union bch_extent_entry *entry;
 		struct extent_ptr_decoded p;
-		unsigned i = 0;
+		unsigned ptr_bit = 1;
 
 		bkey_for_each_ptr_decode(k.k, ptrs, p, entry) {
 			if (p.crc.compression_type == BCH_COMPRESSION_TYPE_incompressible ||
@@ -1421,18 +1421,18 @@ unsigned bch2_bkey_ptrs_need_rebalance(struct bch_fs *c, struct bkey_s_c k,
 			}
 
 			if (!p.ptr.cached && p.crc.compression_type != compression_type)
-				rewrite_ptrs |= 1U << i;
-			i++;
+				rewrite_ptrs |= ptr_bit;
+			ptr_bit <<= 1;
 		}
 	}
 incompressible:
 	if (target && bch2_target_accepts_data(c, BCH_DATA_user, target)) {
-		unsigned i = 0;
+		unsigned ptr_bit = 1;
 
 		bkey_for_each_ptr(ptrs, ptr) {
 			if (!ptr->cached && !bch2_dev_in_target(c, ptr->dev, target))
-				rewrite_ptrs |= 1U << i;
-			i++;
+				rewrite_ptrs |= ptr_bit;
+			ptr_bit <<= 1;
 		}
 	}
 
diff --git a/fs/bcachefs/io_read.c b/fs/bcachefs/io_read.c
index fc246f342820..13dc35cd6562 100644
--- a/fs/bcachefs/io_read.c
+++ b/fs/bcachefs/io_read.c
@@ -231,11 +231,11 @@ static struct promote_op *__promote_alloc(struct btree_trans *trans,
 		update_opts.target = opts.foreground_target;
 
 		struct bkey_ptrs_c ptrs = bch2_bkey_ptrs_c(k);
-		unsigned i = 0;
+		unsigned ptr_bit = 1;
 		bkey_for_each_ptr(ptrs, ptr) {
 			if (bch2_dev_io_failures(failed, ptr->dev))
-				update_opts.rewrite_ptrs |= BIT(i);
-			i++;
+				update_opts.rewrite_ptrs |= ptr_bit;
+			ptr_bit <<= 1;
 		}
 	}
 
-- 
2.45.2


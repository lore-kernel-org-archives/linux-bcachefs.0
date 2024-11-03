Received: from out-185.mta1.migadu.com (out-185.mta1.migadu.com [95.215.58.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69C961632C0
	for <linux-bcachefs@vger.kernel.org>; Sun,  3 Nov 2024 22:32:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730673145; cv=none; b=mWd8djce4f0byqxnHO8sEptz9iEiQbNCcnfJc12vRXjPdU4jyz910DawnUkxW/2osACG3rjrIdPgL+qqsp9tGnnpjbiO7gNlxGZWRG5rjOjQJKdZgSxSzutZbCfES7md3iHtpoU/8gby9w1dTR5xhccmwwdqCrJtJ1r8alnXt18=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730673145; c=relaxed/simple;
	bh=CXdqaXsEExVkO9xa5gyEw1k6g//lbxEbQ4tHvpL+J+8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JRCnYErekrXJfx1/HzD2oO1CYl0pZcfRbwXxeW3BMlGlMt3FyAgo59IP//o5kqfJLcHrZCGqBgIRiYULkWU7IWYZBweFLSRi0jyqKLgL6+nfXBKwN2iRcEpQrvB3hgJqzrrLDlm+KtGSmyIWAbLgPQN2PgRywy5sJ7navZklUxs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=t8DVQpnu; arc=none smtp.client-ip=95.215.58.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="t8DVQpnu"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1730673137;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nPge+gke0fQsFN6Dlo7U40BJwXv30bV4LOBifNlPQFM=;
	b=t8DVQpnu8B1jF1DhxF+M9pwqOFFWIJwcfMoocxyjnSVGaf1lrolilhDsmPcWooq9WWtA6W
	wQUNZ3qlPxtGmbBPAlnGAOD39oO6RE7H+i/sLH3lf7AasN9j4neERmFjlwpwSTFnK8/x1C
	/bofwwVR8xt+w1eMMvWwZQfWM2WK7BM=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 1/5] bcachefs: Fix null ptr deref in bucket_gen_get()
Date: Sun,  3 Nov 2024 17:31:59 -0500
Message-ID: <20241103223205.176754-2-kent.overstreet@linux.dev>
In-Reply-To: <20241103223205.176754-1-kent.overstreet@linux.dev>
References: <20241103223205.176754-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

bucket_gen() checks if we're lookup up a valid bucket and returns NULL
otherwise, but bucket_gen_get() was failing to check; other callers were
correct.

Also do a bit of cleanup on callers.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/btree_node_scan.c |  2 +-
 fs/bcachefs/buckets.h         | 19 +++++++++++--------
 fs/bcachefs/io_read.c         |  7 +++----
 fs/bcachefs/io_write.c        |  7 ++-----
 4 files changed, 17 insertions(+), 18 deletions(-)

diff --git a/fs/bcachefs/btree_node_scan.c b/fs/bcachefs/btree_node_scan.c
index a7aedb134e9f..30131c3bdd97 100644
--- a/fs/bcachefs/btree_node_scan.c
+++ b/fs/bcachefs/btree_node_scan.c
@@ -186,7 +186,7 @@ static void try_read_btree_node(struct find_btree_nodes *f, struct bch_dev *ca,
 		.ptrs[0].type	= 1 << BCH_EXTENT_ENTRY_ptr,
 		.ptrs[0].offset	= offset,
 		.ptrs[0].dev	= ca->dev_idx,
-		.ptrs[0].gen	= *bucket_gen(ca, sector_to_bucket(ca, offset)),
+		.ptrs[0].gen	= bucket_gen_get(ca, sector_to_bucket(ca, offset)),
 	};
 	rcu_read_unlock();
 
diff --git a/fs/bcachefs/buckets.h b/fs/bcachefs/buckets.h
index fd5e6ccad45e..ccc78bfe2fd4 100644
--- a/fs/bcachefs/buckets.h
+++ b/fs/bcachefs/buckets.h
@@ -103,12 +103,18 @@ static inline u8 *bucket_gen(struct bch_dev *ca, size_t b)
 	return gens->b + b;
 }
 
-static inline u8 bucket_gen_get(struct bch_dev *ca, size_t b)
+static inline int bucket_gen_get_rcu(struct bch_dev *ca, size_t b)
+{
+	u8 *gen = bucket_gen(ca, b);
+	return gen ? *gen : -1;
+}
+
+static inline int bucket_gen_get(struct bch_dev *ca, size_t b)
 {
 	rcu_read_lock();
-	u8 gen = *bucket_gen(ca, b);
+	int ret = bucket_gen_get_rcu(ca, b);
 	rcu_read_unlock();
-	return gen;
+	return ret;
 }
 
 static inline size_t PTR_BUCKET_NR(const struct bch_dev *ca,
@@ -169,10 +175,8 @@ static inline int gen_after(u8 a, u8 b)
 
 static inline int dev_ptr_stale_rcu(struct bch_dev *ca, const struct bch_extent_ptr *ptr)
 {
-	u8 *gen = bucket_gen(ca, PTR_BUCKET_NR(ca, ptr));
-	if (!gen)
-		return -1;
-	return gen_after(*gen, ptr->gen);
+	int gen = bucket_gen_get_rcu(ca, PTR_BUCKET_NR(ca, ptr));
+	return gen < 0 ? gen : gen_after(gen, ptr->gen);
 }
 
 /**
@@ -184,7 +188,6 @@ static inline int dev_ptr_stale(struct bch_dev *ca, const struct bch_extent_ptr
 	rcu_read_lock();
 	int ret = dev_ptr_stale_rcu(ca, ptr);
 	rcu_read_unlock();
-
 	return ret;
 }
 
diff --git a/fs/bcachefs/io_read.c b/fs/bcachefs/io_read.c
index fc246f342820..ac6a6fcc2bb8 100644
--- a/fs/bcachefs/io_read.c
+++ b/fs/bcachefs/io_read.c
@@ -802,16 +802,15 @@ static noinline void read_from_stale_dirty_pointer(struct btree_trans *trans,
 			     PTR_BUCKET_POS(ca, &ptr),
 			     BTREE_ITER_cached);
 
-	u8 *gen = bucket_gen(ca, iter.pos.offset);
-	if (gen) {
-
+	int gen = bucket_gen_get(ca, iter.pos.offset);
+	if (gen >= 0) {
 		prt_printf(&buf, "Attempting to read from stale dirty pointer:\n");
 		printbuf_indent_add(&buf, 2);
 
 		bch2_bkey_val_to_text(&buf, c, k);
 		prt_newline(&buf);
 
-		prt_printf(&buf, "memory gen: %u", *gen);
+		prt_printf(&buf, "memory gen: %u", gen);
 
 		ret = lockrestart_do(trans, bkey_err(k = bch2_btree_iter_peek_slot(&iter)));
 		if (!ret) {
diff --git a/fs/bcachefs/io_write.c b/fs/bcachefs/io_write.c
index 8609e25e450f..96720adcfee0 100644
--- a/fs/bcachefs/io_write.c
+++ b/fs/bcachefs/io_write.c
@@ -1300,11 +1300,8 @@ static void bch2_nocow_write(struct bch_write_op *op)
 						 bucket_to_u64(i->b),
 						 BUCKET_NOCOW_LOCK_UPDATE);
 
-			rcu_read_lock();
-			u8 *gen = bucket_gen(ca, i->b.offset);
-			stale = !gen ? -1 : gen_after(*gen, i->gen);
-			rcu_read_unlock();
-
+			int gen = bucket_gen_get(ca, i->b.offset);
+			stale = gen < 0 ? gen : gen_after(gen, i->gen);
 			if (unlikely(stale)) {
 				stale_at = i;
 				goto err_bucket_stale;
-- 
2.46.0


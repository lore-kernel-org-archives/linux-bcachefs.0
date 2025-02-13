Received: from out-176.mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D194245AF2
	for <linux-bcachefs@vger.kernel.org>; Thu, 13 Feb 2025 18:46:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739472384; cv=none; b=O8Hvx/GAdV0VHHCvc2weQEeX12LttRxg5H8vxYD7plxIKv5GNWhGCFstX81FBimS7yzyVlQ2dSZ7zO+JBGYJPuvpX0oGJDO/8TREW0ZmbpminIlNC02JgCf1ao7FTB1ZbScuFBfd0LAyqrCY5LSQGjpLP37sThYL4oFn5jqzJJY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739472384; c=relaxed/simple;
	bh=VE/5xgAzP6oQXd3PgI/pmch9fjnxKoGqLQ/tgfqHcnw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bjo3KuBFoPHW13I6b/Cufnsns6x0YsDPg2DbktGnsBTysgBTIRQb1Gv29G0Swc+7RRP1NsXMFd29cp3XqN3okalzFY3mLJEm3nVlVYep+aS7Buxqr6FcsK5cqL0nJBGPy+8uMQNTqqp3J45JanPCOPhmvGLwx363dENxXuIHbTY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Ny2LZTMe; arc=none smtp.client-ip=95.215.58.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Ny2LZTMe"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1739472380;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XwFAOhg3Uzy8RtsW9MXYmZsq77mgrL5MknlzwxnvJtw=;
	b=Ny2LZTMe9Ihf6Ym/B7aenyLj3ckVUjRd1rAR2sE4P3mHPZJoWu7Den9hQ7e+kHrcC8cJ5H
	ggiHHRqRNvFLt0LCTDWDdEuUEL8IlRV/2FvALbXCRzoOTM9yzpsLCgLYLD1faLyhPbBVmh
	BEeklj3Gx13OG4+A9IgmbDQunOUP9CU=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 05/18] bcachefs: bch2_trigger_stripe_ptr() no longer uses ec_stripes_heap_lock
Date: Thu, 13 Feb 2025 13:45:50 -0500
Message-ID: <20250213184607.18237-6-kent.overstreet@linux.dev>
In-Reply-To: <20250213184607.18237-1-kent.overstreet@linux.dev>
References: <20250213184607.18237-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Introduce per-entry locks, like with struct bucket - the stripes heap is
going away.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/buckets.c       |  6 +++---
 fs/bcachefs/buckets.h       | 27 ---------------------------
 fs/bcachefs/buckets_types.h | 27 +++++++++++++++++++++++++++
 fs/bcachefs/ec.h            | 14 ++++++++++++++
 fs/bcachefs/ec_types.h      |  5 ++---
 5 files changed, 46 insertions(+), 33 deletions(-)

diff --git a/fs/bcachefs/buckets.c b/fs/bcachefs/buckets.c
index 345b117a4a4a..88af61bc799d 100644
--- a/fs/bcachefs/buckets.c
+++ b/fs/bcachefs/buckets.c
@@ -674,10 +674,10 @@ static int bch2_trigger_stripe_ptr(struct btree_trans *trans,
 			return -BCH_ERR_ENOMEM_mark_stripe_ptr;
 		}
 
-		mutex_lock(&c->ec_stripes_heap_lock);
+		gc_stripe_lock(m);
 
 		if (!m || !m->alive) {
-			mutex_unlock(&c->ec_stripes_heap_lock);
+			gc_stripe_unlock(m);
 			struct printbuf buf = PRINTBUF;
 			bch2_bkey_val_to_text(&buf, c, k);
 			bch_err_ratelimited(c, "pointer to nonexistent stripe %llu\n  while marking %s",
@@ -693,7 +693,7 @@ static int bch2_trigger_stripe_ptr(struct btree_trans *trans,
 			.type = BCH_DISK_ACCOUNTING_replicas,
 		};
 		memcpy(&acc.replicas, &m->r.e, replicas_entry_bytes(&m->r.e));
-		mutex_unlock(&c->ec_stripes_heap_lock);
+		gc_stripe_unlock(m);
 
 		acc.replicas.data_type = data_type;
 		int ret = bch2_disk_accounting_mod(trans, &acc, &sectors, 1, true);
diff --git a/fs/bcachefs/buckets.h b/fs/bcachefs/buckets.h
index a9acdd6c0c86..6aeec1c0973c 100644
--- a/fs/bcachefs/buckets.h
+++ b/fs/bcachefs/buckets.h
@@ -39,33 +39,6 @@ static inline u64 sector_to_bucket_and_offset(const struct bch_dev *ca, sector_t
 	for (_b = (_buckets)->b + (_buckets)->first_bucket;	\
 	     _b < (_buckets)->b + (_buckets)->nbuckets; _b++)
 
-/*
- * Ugly hack alert:
- *
- * We need to cram a spinlock in a single byte, because that's what we have left
- * in struct bucket, and we care about the size of these - during fsck, we need
- * in memory state for every single bucket on every device.
- *
- * We used to do
- *   while (xchg(&b->lock, 1) cpu_relax();
- * but, it turns out not all architectures support xchg on a single byte.
- *
- * So now we use bit_spin_lock(), with fun games since we can't burn a whole
- * ulong for this - we just need to make sure the lock bit always ends up in the
- * first byte.
- */
-
-#if __BYTE_ORDER__ == __ORDER_LITTLE_ENDIAN__
-#define BUCKET_LOCK_BITNR	0
-#else
-#define BUCKET_LOCK_BITNR	(BITS_PER_LONG - 1)
-#endif
-
-union ulong_byte_assert {
-	ulong	ulong;
-	u8	byte;
-};
-
 static inline void bucket_unlock(struct bucket *b)
 {
 	BUILD_BUG_ON(!((union ulong_byte_assert) { .ulong = 1UL << BUCKET_LOCK_BITNR }).byte);
diff --git a/fs/bcachefs/buckets_types.h b/fs/bcachefs/buckets_types.h
index 7174047b8e92..900b8680c8b5 100644
--- a/fs/bcachefs/buckets_types.h
+++ b/fs/bcachefs/buckets_types.h
@@ -7,6 +7,33 @@
 
 #define BUCKET_JOURNAL_SEQ_BITS		16
 
+/*
+ * Ugly hack alert:
+ *
+ * We need to cram a spinlock in a single byte, because that's what we have left
+ * in struct bucket, and we care about the size of these - during fsck, we need
+ * in memory state for every single bucket on every device.
+ *
+ * We used to do
+ *   while (xchg(&b->lock, 1) cpu_relax();
+ * but, it turns out not all architectures support xchg on a single byte.
+ *
+ * So now we use bit_spin_lock(), with fun games since we can't burn a whole
+ * ulong for this - we just need to make sure the lock bit always ends up in the
+ * first byte.
+ */
+
+#if __BYTE_ORDER__ == __ORDER_LITTLE_ENDIAN__
+#define BUCKET_LOCK_BITNR	0
+#else
+#define BUCKET_LOCK_BITNR	(BITS_PER_LONG - 1)
+#endif
+
+union ulong_byte_assert {
+	ulong	ulong;
+	u8	byte;
+};
+
 struct bucket {
 	u8			lock;
 	u8			gen_valid:1;
diff --git a/fs/bcachefs/ec.h b/fs/bcachefs/ec.h
index 583ca6a226da..4c9511887655 100644
--- a/fs/bcachefs/ec.h
+++ b/fs/bcachefs/ec.h
@@ -132,6 +132,20 @@ static inline bool bch2_ptr_matches_stripe_m(const struct gc_stripe *m,
 					 m->sectors);
 }
 
+static inline void gc_stripe_unlock(struct gc_stripe *s)
+{
+	BUILD_BUG_ON(!((union ulong_byte_assert) { .ulong = 1UL << BUCKET_LOCK_BITNR }).byte);
+
+	clear_bit_unlock(BUCKET_LOCK_BITNR, (void *) &s->lock);
+	wake_up_bit((void *) &s->lock, BUCKET_LOCK_BITNR);
+}
+
+static inline void gc_stripe_lock(struct gc_stripe *s)
+{
+	wait_on_bit_lock((void *) &s->lock, BUCKET_LOCK_BITNR,
+			 TASK_UNINTERRUPTIBLE);
+}
+
 struct bch_read_bio;
 
 struct ec_stripe_buf {
diff --git a/fs/bcachefs/ec_types.h b/fs/bcachefs/ec_types.h
index 8d1e70e830ac..37558cc2d89f 100644
--- a/fs/bcachefs/ec_types.h
+++ b/fs/bcachefs/ec_types.h
@@ -20,12 +20,11 @@ struct stripe {
 };
 
 struct gc_stripe {
+	u8			lock;
+	unsigned		alive:1; /* does a corresponding key exist in stripes btree? */
 	u16			sectors;
-
 	u8			nr_blocks;
 	u8			nr_redundant;
-
-	unsigned		alive:1; /* does a corresponding key exist in stripes btree? */
 	u16			block_sectors[BCH_BKEY_PTRS_MAX];
 	struct bch_extent_ptr	ptrs[BCH_BKEY_PTRS_MAX];
 
-- 
2.45.2


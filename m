Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B40373EA9B
	for <linux-bcachefs@vger.kernel.org>; Wed, 31 Jan 2024 20:16:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706732194; cv=none; b=UhgNDMXI/LTg5YecR38KsA3trYaeU0w07umd6CG4jjHzEnDUhV6m6QitwKABgybyRZnZ9kJddU+z4qalmoElji8gYUIp6c9zxatB7h98ipPrCMS/A19sL4Gi9xcQ7jMWpVaEReI97iAoyvOQihZp+vIzK6zlV4P9Zi+TbJwgFNc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706732194; c=relaxed/simple;
	bh=B0ywIuQQ5KbPT/MK4uzWxiNtTZNU8Q7g+VwmoVIJPQw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=oxdl95P/wrmZmft/Knp1LwznrBIEd4MKnhx8q5Jok1ATXRR7kBLOBDmRxwJIrxWB+KmUcztrazoxv2db7o1Z5wDIx+eDqLMJYXjAsF20eSFai+LTUL0TTLuFbonHq3NZwarChldS0VLsJ/47vw6i6IYjBl2t6FHD8kzMoseGi/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=unSWgEiE; arc=none smtp.client-ip=91.218.175.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="unSWgEiE"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1706732189;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=nNuI91ZpHa969E6poK92YgyjWpKAsdR/1JQ4Ph0Mld0=;
	b=unSWgEiEhdNLhW8rXpGLfP7vIdfT5SziulYU2EZUe7Sby3Ukoksbgy6j6XnHQDCGvjm9Kz
	Ml+yCAN6GRHZTNiZMU5WSal+GmzK0IUHnOouWHTvZFXTBBL2d9ndAee/rmdIqR+7LifiX1
	DZFT+sTm/PbD+glalo9QCWply4n6HyA=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 1/3] bcachefs: bio per journal buf
Date: Wed, 31 Jan 2024 15:16:20 -0500
Message-ID: <20240131201622.3409726-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Prep work for having multiple journal writes in flight.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/journal.c       | 40 ++++++++++++++++++++-----------------
 fs/bcachefs/journal_io.c    | 21 +++++++++----------
 fs/bcachefs/journal_types.h |  2 +-
 3 files changed, 34 insertions(+), 29 deletions(-)

diff --git a/fs/bcachefs/journal.c b/fs/bcachefs/journal.c
index 13c9b6b5a7da..306d46654df3 100644
--- a/fs/bcachefs/journal.c
+++ b/fs/bcachefs/journal.c
@@ -1234,13 +1234,17 @@ int bch2_fs_journal_start(struct journal *j, u64 cur_seq)
 
 void bch2_dev_journal_exit(struct bch_dev *ca)
 {
-	kfree(ca->journal.bio);
-	kfree(ca->journal.buckets);
-	kfree(ca->journal.bucket_seq);
+	struct journal_device *ja = &ca->journal;
+
+	for (unsigned i = 0; i < ARRAY_SIZE(ja->bio); i++) {
+		kfree(ja->bio[i]);
+		ja->bio[i] = NULL;
+	}
 
-	ca->journal.bio		= NULL;
-	ca->journal.buckets	= NULL;
-	ca->journal.bucket_seq	= NULL;
+	kfree(ja->buckets);
+	kfree(ja->bucket_seq);
+	ja->buckets	= NULL;
+	ja->bucket_seq	= NULL;
 }
 
 int bch2_dev_journal_init(struct bch_dev *ca, struct bch_sb *sb)
@@ -1250,14 +1254,13 @@ int bch2_dev_journal_init(struct bch_dev *ca, struct bch_sb *sb)
 		bch2_sb_field_get(sb, journal);
 	struct bch_sb_field_journal_v2 *journal_buckets_v2 =
 		bch2_sb_field_get(sb, journal_v2);
-	unsigned i, nr_bvecs;
 
 	ja->nr = 0;
 
 	if (journal_buckets_v2) {
 		unsigned nr = bch2_sb_field_journal_v2_nr_entries(journal_buckets_v2);
 
-		for (i = 0; i < nr; i++)
+		for (unsigned i = 0; i < nr; i++)
 			ja->nr += le64_to_cpu(journal_buckets_v2->d[i].nr);
 	} else if (journal_buckets) {
 		ja->nr = bch2_nr_journal_buckets(journal_buckets);
@@ -1267,13 +1270,14 @@ int bch2_dev_journal_init(struct bch_dev *ca, struct bch_sb *sb)
 	if (!ja->bucket_seq)
 		return -BCH_ERR_ENOMEM_dev_journal_init;
 
-	nr_bvecs = DIV_ROUND_UP(JOURNAL_ENTRY_SIZE_MAX, PAGE_SIZE);
+	unsigned nr_bvecs = DIV_ROUND_UP(JOURNAL_ENTRY_SIZE_MAX, PAGE_SIZE);
 
-	ca->journal.bio = bio_kmalloc(nr_bvecs, GFP_KERNEL);
-	if (!ca->journal.bio)
-		return -BCH_ERR_ENOMEM_dev_journal_init;
-
-	bio_init(ca->journal.bio, NULL, ca->journal.bio->bi_inline_vecs, nr_bvecs, 0);
+	for (unsigned i = 0; i < ARRAY_SIZE(ja->bio); i++) {
+		ja->bio[i] = bio_kmalloc(nr_bvecs, GFP_KERNEL);
+		if (!ja->bio[i])
+			return -BCH_ERR_ENOMEM_dev_journal_init;
+		bio_init(ja->bio[i], NULL, ja->bio[i]->bi_inline_vecs, nr_bvecs, 0);
+	}
 
 	ja->buckets = kcalloc(ja->nr, sizeof(u64), GFP_KERNEL);
 	if (!ja->buckets)
@@ -1281,14 +1285,14 @@ int bch2_dev_journal_init(struct bch_dev *ca, struct bch_sb *sb)
 
 	if (journal_buckets_v2) {
 		unsigned nr = bch2_sb_field_journal_v2_nr_entries(journal_buckets_v2);
-		unsigned j, dst = 0;
+		unsigned dst = 0;
 
-		for (i = 0; i < nr; i++)
-			for (j = 0; j < le64_to_cpu(journal_buckets_v2->d[i].nr); j++)
+		for (unsigned i = 0; i < nr; i++)
+			for (unsigned j = 0; j < le64_to_cpu(journal_buckets_v2->d[i].nr); j++)
 				ja->buckets[dst++] =
 					le64_to_cpu(journal_buckets_v2->d[i].start) + j;
 	} else if (journal_buckets) {
-		for (i = 0; i < ja->nr; i++)
+		for (unsigned i = 0; i < ja->nr; i++)
 			ja->buckets[i] = le64_to_cpu(journal_buckets->buckets[i]);
 	}
 
diff --git a/fs/bcachefs/journal_io.c b/fs/bcachefs/journal_io.c
index 5eb80686f0e0..92efacad80e6 100644
--- a/fs/bcachefs/journal_io.c
+++ b/fs/bcachefs/journal_io.c
@@ -1718,13 +1718,14 @@ static CLOSURE_CALLBACK(do_journal_write)
 {
 	closure_type(j, struct journal, io);
 	struct bch_fs *c = container_of(j, struct bch_fs, journal);
-	struct bch_dev *ca;
-	struct journal_buf *w = journal_last_unwritten_buf(j);
-	struct bio *bio;
+	unsigned buf_idx = journal_last_unwritten_seq(j) & JOURNAL_BUF_MASK;
+	struct journal_buf *w = j->buf + buf_idx;
 	unsigned sectors = vstruct_sectors(w->data, c->block_bits);
 
 	extent_for_each_ptr(bkey_i_to_s_extent(&w->key), ptr) {
-		ca = bch_dev_bkey_exists(c, ptr->dev);
+		struct bch_dev *ca = bch_dev_bkey_exists(c, ptr->dev);
+		struct journal_device *ja = &ca->journal;
+
 		if (!percpu_ref_tryget(&ca->io_ref)) {
 			/* XXX: fix this */
 			bch_err(c, "missing device for journal write\n");
@@ -1734,7 +1735,7 @@ static CLOSURE_CALLBACK(do_journal_write)
 		this_cpu_add(ca->io_done->sectors[WRITE][BCH_DATA_journal],
 			     sectors);
 
-		bio = ca->journal.bio;
+		struct bio *bio = ja->bio[buf_idx];
 		bio_reset(bio, ca->disk_sb.bdev, REQ_OP_WRITE|REQ_SYNC|REQ_META);
 		bio->bi_iter.bi_sector	= ptr->offset;
 		bio->bi_end_io		= journal_write_endio;
@@ -1753,8 +1754,7 @@ static CLOSURE_CALLBACK(do_journal_write)
 		trace_and_count(c, journal_write, bio);
 		closure_bio_submit(bio, cl);
 
-		ca->journal.bucket_seq[ca->journal.cur_idx] =
-			le64_to_cpu(w->data->seq);
+		ja->bucket_seq[ja->cur_idx] = le64_to_cpu(w->data->seq);
 	}
 
 	continue_at(cl, journal_write_done, j->wq);
@@ -1936,9 +1936,9 @@ CLOSURE_CALLBACK(bch2_journal_write)
 {
 	closure_type(j, struct journal, io);
 	struct bch_fs *c = container_of(j, struct bch_fs, journal);
-	struct journal_buf *w = journal_last_unwritten_buf(j);
+	unsigned buf_idx = journal_last_unwritten_seq(j) & JOURNAL_BUF_MASK;
+	struct journal_buf *w = j->buf + buf_idx;
 	struct bch_replicas_padded replicas;
-	struct bio *bio;
 	struct printbuf journal_debug_buf = PRINTBUF;
 	unsigned nr_rw_members = 0;
 	int ret;
@@ -2020,7 +2020,8 @@ CLOSURE_CALLBACK(bch2_journal_write)
 		for_each_rw_member(c, ca) {
 			percpu_ref_get(&ca->io_ref);
 
-			bio = ca->journal.bio;
+			struct journal_device *ja = &ca->journal;
+			struct bio *bio = ja->bio[buf_idx];
 			bio_reset(bio, ca->disk_sb.bdev,
 				  REQ_OP_WRITE|REQ_SYNC|REQ_META|REQ_PREFLUSH);
 			bio->bi_end_io		= journal_write_endio;
diff --git a/fs/bcachefs/journal_types.h b/fs/bcachefs/journal_types.h
index 957be8949fb0..a4b07e5b5710 100644
--- a/fs/bcachefs/journal_types.h
+++ b/fs/bcachefs/journal_types.h
@@ -310,7 +310,7 @@ struct journal_device {
 	u64			*buckets;
 
 	/* Bio for journal reads/writes to this device */
-	struct bio		*bio;
+	struct bio		*bio[JOURNAL_BUF_NR];
 
 	/* for bch_journal_read_device */
 	struct closure		read;
-- 
2.43.0


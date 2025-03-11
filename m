Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B47E262818
	for <linux-bcachefs@vger.kernel.org>; Tue, 11 Mar 2025 20:15:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741724140; cv=none; b=KWUoe2JiGRrFD1VQY1E6A6/yhbeTKJUz7eH8hkjGeN/52AYxbfnvn9RrMWgs/PA0yYsnc6fj5CINTtykycUpsZq2kVsjqIXj5SR+9RwarHdo7gMTvj/n4jaXbPlZItkOm2dBhkAhZmziMvpLgpdbmQQ+0Y6X37XcIzNE2pyfs5c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741724140; c=relaxed/simple;
	bh=umLedGQy3KcZs6eCFSDjFNAS1BNfqfnt6r9hASnIou4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Su7mJXN7HAtf7o4ZKIvrHb5Rp7+qmPyXLzAH9kG0j9aXHt8aJSjDrempBTDX8IdFV6CyduBrVFMgTT9Vrf8tGnWBKVNLdnsvFRj1XnnzJnGyvjvtBdnAgd1SEvnUaFsl0LOr7EYsnEfr4FwLPWinhP3jM5t0JqTdOs3q1JNlUHo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Tw8VXH8H; arc=none smtp.client-ip=91.218.175.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Tw8VXH8H"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1741724136;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GPnORd35+VK4PGPYyGO8qZXJ/qCtg0C/JAG+BPK+/vM=;
	b=Tw8VXH8HQjnsVCbxdiWbwR84GCUZeGCsJkHDiH9FAQQHE4bPd0pjZz6OJi2q6nuaLacKWm
	zF9BXb23GOjoCwDEgSbUFaCscgFr61UT4L1QBEKmcFKNnCijh67XgxgiXBzn6A8lNedpvY
	zkcel6vKdZDul9CdPih+OFeteQDuHOs=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 11/14] bcachefs: Data move can read from poisoned extents
Date: Tue, 11 Mar 2025 16:15:13 -0400
Message-ID: <20250311201518.3573009-12-kent.overstreet@linux.dev>
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

Now, if an extent is poisoned we can move it even if there was a
checksum error. We'll have to give it a new checksum, but the poison bit
means that userspace will still see the appropriate error when they try
to read it.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/extents.c |  6 +-----
 fs/bcachefs/io_read.c |  4 ++++
 fs/bcachefs/move.c    | 26 ++++++++++++++++++++------
 3 files changed, 25 insertions(+), 11 deletions(-)

diff --git a/fs/bcachefs/extents.c b/fs/bcachefs/extents.c
index 1df0e034e988..03c260f78406 100644
--- a/fs/bcachefs/extents.c
+++ b/fs/bcachefs/extents.c
@@ -145,12 +145,8 @@ int bch2_bkey_pick_read_device(struct bch_fs *c, struct bkey_s_c k,
 	if (k.k->type == KEY_TYPE_error)
 		return -BCH_ERR_key_type_error;
 
-	struct bkey_ptrs_c ptrs = bch2_bkey_ptrs_c(k);
-
-	if (bch2_bkey_extent_ptrs_flags(ptrs) & BIT_ULL(BCH_EXTENT_FLAG_poisoned))
-		return -BCH_ERR_extent_poisened;
-
 	rcu_read_lock();
+	struct bkey_ptrs_c ptrs = bch2_bkey_ptrs_c(k);
 	const union bch_extent_entry *entry;
 	struct extent_ptr_decoded p;
 
diff --git a/fs/bcachefs/io_read.c b/fs/bcachefs/io_read.c
index 4fd5a4e646e0..1ff4edac7e81 100644
--- a/fs/bcachefs/io_read.c
+++ b/fs/bcachefs/io_read.c
@@ -1022,6 +1022,10 @@ int __bch2_read_extent(struct btree_trans *trans, struct bch_read_bio *orig,
 			     bvec_iter_sectors(iter));
 		goto out_read_done;
 	}
+
+	if ((bch2_bkey_extent_flags(k) & BIT_ULL(BCH_EXTENT_FLAG_poisoned)) &&
+	    !(flags & BCH_READ_data_update))
+		return -BCH_ERR_extent_poisened;
 retry_pick:
 	ret = bch2_bkey_pick_read_device(c, k, failed, &pick, dev);
 
diff --git a/fs/bcachefs/move.c b/fs/bcachefs/move.c
index 8cfd842a86cf..1e8e51fdad4b 100644
--- a/fs/bcachefs/move.c
+++ b/fs/bcachefs/move.c
@@ -114,26 +114,40 @@ static void move_write_done(struct bch_write_op *op)
 
 static void move_write(struct moving_io *io)
 {
+	struct bch_fs *c = io->write.op.c;
 	struct moving_context *ctxt = io->write.ctxt;
+	struct bch_read_bio *rbio = &io->write.rbio;
 
 	if (ctxt->stats) {
-		if (io->write.rbio.bio.bi_status)
+		if (rbio->bio.bi_status)
 			atomic64_add(io->write.rbio.bvec_iter.bi_size >> 9,
 				     &ctxt->stats->sectors_error_uncorrected);
-		else if (io->write.rbio.saw_error)
+		else if (rbio->saw_error)
 			atomic64_add(io->write.rbio.bvec_iter.bi_size >> 9,
 				     &ctxt->stats->sectors_error_corrected);
 	}
 
-	if (unlikely(io->write.rbio.ret ||
-		     io->write.rbio.bio.bi_status ||
-		     io->write.data_opts.scrub)) {
+	/*
+	 * If the extent has been bitrotted, we're going to have to give it a
+	 * new checksum in order to move it - but the poison bit will ensure
+	 * that userspace still gets the appropriate error.
+	 */
+	if (unlikely(rbio->ret == -BCH_ERR_data_read_csum_err &&
+		     (bch2_bkey_extent_flags(bkey_i_to_s_c(io->write.k.k)) & BIT_ULL(BCH_EXTENT_FLAG_poisoned)))) {
+		struct bch_extent_crc_unpacked crc = rbio->pick.crc;
+		struct nonce nonce = extent_nonce(rbio->version, crc);
+
+		rbio->pick.crc.csum	= bch2_checksum_bio(c, rbio->pick.crc.csum_type,
+							    nonce, &rbio->bio);
+		rbio->ret		= 0;
+	}
+
+	if (unlikely(rbio->ret || io->write.data_opts.scrub)) {
 		move_free(io);
 		return;
 	}
 
 	if (trace_io_move_write_enabled()) {
-		struct bch_fs *c = io->write.op.c;
 		struct printbuf buf = PRINTBUF;
 
 		bch2_bkey_val_to_text(&buf, c, bkey_i_to_s_c(io->write.k.k));
-- 
2.47.2


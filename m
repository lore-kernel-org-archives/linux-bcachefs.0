Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 024F219ABBB
	for <linux-bcachefs@vger.kernel.org>; Mon, 30 Dec 2024 21:43:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735594987; cv=none; b=GhCdabtgo0hZvBntXzYntaqknhMexwTMwikmQSM/Lfr6A5xOV02NBQO+xvNS4FX15R7rq7VDwb98xTkhrAGUJ0AdYFI+0/8pjkrHLtK0gpBGwZ/IJT513elD5oCdW0VhP0ttW7TsBLzxzhLkYUMxuN+ZAR1g/RdtawtlSBk1aUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735594987; c=relaxed/simple;
	bh=c/RdZYs+WUbc4gR3SA3CmJu1XuVIqOfvDTOKR2CQQE0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W0a4Zeiyf1Nhih1VUDbd6IaeML36e4Hk+di8nZHLlMo2r05ccc5ZT8bjUvGgPXOLqzNGfs1IueGf4G/ofEQPoWg24Y8ODOenzQL8jeYTvMtj+RLUiw6Gs1rKJjYxpFqilRD+/9smkzvzVx5ZZlsJuoyCCCBzVbO9VMNRfGcSQPE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=dVdp3k/T; arc=none smtp.client-ip=91.218.175.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="dVdp3k/T"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1735594984;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DExYSCDDLVtYVVdprgEt6nACrPJzQlJsMS8r73zRH0g=;
	b=dVdp3k/Tl5iFi6HgEn5zeHsFihSS+Wg6orLOZv04YF2oJskaOanHu8+1MdcqtSVQmQ1nyG
	quw7QbDGvf1miMt16ukyqopSL9rW7Sr65F1SPwFZJzDbUAdxHD0zhTep9P8KJcmn1agnxt
	zR6PBMpvJPHUQY9XWh4REgjo06P/SKc=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 10/11] bcachefs: Internal reads can now correct errors
Date: Mon, 30 Dec 2024 16:42:48 -0500
Message-ID: <20241230214249.242966-10-kent.overstreet@linux.dev>
In-Reply-To: <20241230214249.242966-1-kent.overstreet@linux.dev>
References: <20241230214249.242966-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Rework the read path a bit so that BCH_READ_NODECODE reads now also
self-heal after a read error and a successful retry - prerequisite for
scrub.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/io_read.c | 59 +++++++++++++++++++++++--------------------
 1 file changed, 31 insertions(+), 28 deletions(-)

diff --git a/fs/bcachefs/io_read.c b/fs/bcachefs/io_read.c
index 17a6a3159917..e13766a73300 100644
--- a/fs/bcachefs/io_read.c
+++ b/fs/bcachefs/io_read.c
@@ -740,7 +740,7 @@ static void __bch2_read_endio(struct work_struct *work)
 			bio_copy_data_iter(dst, &dst_iter, src, &src_iter);
 		}
 	}
-
+nodecode:
 	if (rbio->promote) {
 		/*
 		 * Re encrypt data we decrypted, so it's consistent with
@@ -753,7 +753,7 @@ static void __bch2_read_endio(struct work_struct *work)
 		promote_start(rbio->promote, rbio);
 		rbio->promote = NULL;
 	}
-nodecode:
+
 	if (likely(!(rbio->flags & BCH_READ_IN_RETRY))) {
 		rbio = bch2_rbio_free(rbio);
 		bch2_rbio_done(rbio);
@@ -888,6 +888,8 @@ int __bch2_read_extent(struct btree_trans *trans, struct bch_read_bio *orig,
 	struct bpos data_pos = bkey_start_pos(k.k);
 	int pick_ret;
 
+	//BUG_ON(failed && failed->nr);
+
 	if (bkey_extent_is_inline_data(k.k)) {
 		unsigned bytes = min_t(unsigned, iter.bi_size,
 				       bkey_inline_data_bytes(k.k));
@@ -952,7 +954,30 @@ int __bch2_read_extent(struct btree_trans *trans, struct bch_read_bio *orig,
 	 */
 	bch2_trans_unlock(trans);
 
-	if (flags & BCH_READ_NODECODE) {
+	if (!(flags & BCH_READ_NODECODE)) {
+		if (!(flags & BCH_READ_LAST_FRAGMENT) ||
+		    bio_flagged(&orig->bio, BIO_CHAIN))
+			flags |= BCH_READ_MUST_CLONE;
+
+		narrow_crcs = !(flags & BCH_READ_IN_RETRY) &&
+			bch2_can_narrow_extent_crcs(k, pick.crc);
+
+		if (narrow_crcs && (flags & BCH_READ_USER_MAPPED))
+			flags |= BCH_READ_MUST_BOUNCE;
+
+		EBUG_ON(offset_into_extent + bvec_iter_sectors(iter) > k.k->size);
+
+		if (crc_is_compressed(pick.crc) ||
+		    (pick.crc.csum_type != BCH_CSUM_none &&
+		     (bvec_iter_sectors(iter) != pick.crc.uncompressed_size ||
+		      (bch2_csum_type_is_encryption(pick.crc.csum_type) &&
+		       (flags & BCH_READ_USER_MAPPED)) ||
+		      (flags & BCH_READ_MUST_BOUNCE)))) {
+			read_full = true;
+			bounce = true;
+		}
+	} else {
+		read_full = true;
 		/*
 		 * can happen if we retry, and the extent we were going to read
 		 * has been merged in the meantime:
@@ -964,32 +989,10 @@ int __bch2_read_extent(struct btree_trans *trans, struct bch_read_bio *orig,
 		}
 
 		iter.bi_size	= pick.crc.compressed_size << 9;
-		goto get_bio;
 	}
 
-	if (!(flags & BCH_READ_LAST_FRAGMENT) ||
-	    bio_flagged(&orig->bio, BIO_CHAIN))
-		flags |= BCH_READ_MUST_CLONE;
-
-	narrow_crcs = !(flags & BCH_READ_IN_RETRY) &&
-		bch2_can_narrow_extent_crcs(k, pick.crc);
-
-	if (narrow_crcs && (flags & BCH_READ_USER_MAPPED))
-		flags |= BCH_READ_MUST_BOUNCE;
-
-	EBUG_ON(offset_into_extent + bvec_iter_sectors(iter) > k.k->size);
-
-	if (crc_is_compressed(pick.crc) ||
-	    (pick.crc.csum_type != BCH_CSUM_none &&
-	     (bvec_iter_sectors(iter) != pick.crc.uncompressed_size ||
-	      (bch2_csum_type_is_encryption(pick.crc.csum_type) &&
-	       (flags & BCH_READ_USER_MAPPED)) ||
-	      (flags & BCH_READ_MUST_BOUNCE)))) {
-		read_full = true;
-		bounce = true;
-	}
-
-	if (orig->opts.promote_target)// || failed)
+	if ((orig->opts.promote_target && !(flags & BCH_READ_NODECODE)) ||
+	    (failed && failed->nr))
 		promote = promote_alloc(trans, iter, k, &pick, orig->opts, flags,
 					&rbio, &bounce, &read_full, failed);
 
@@ -1010,7 +1013,7 @@ int __bch2_read_extent(struct btree_trans *trans, struct bch_read_bio *orig,
 		pick.crc.offset			= 0;
 		pick.crc.live_size		= bvec_iter_sectors(iter);
 	}
-get_bio:
+
 	if (rbio) {
 		/*
 		 * promote already allocated bounce rbio:
-- 
2.45.2


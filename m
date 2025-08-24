Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BED428980A
	for <linux-bcachefs@vger.kernel.org>; Sun, 24 Aug 2025 12:38:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756039102; cv=none; b=ggkjgniE1gHSEw9mAV0tvaNJXy6fqsafAs5RE4hkoz/eZ8aPRWLDEz7x9pAjzk/wzVq4bFQZVMIJ2JLZ5WGTJ/3laGc3fnfY2RkiYrPUE042FgG99wvBipe5AKpbemmbm21CnvJ0nQjiRSLbc25TJ+cPJAArxA6YkZiixrX/qp4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756039102; c=relaxed/simple;
	bh=AfmoaStBG06scPJIKjRB4ZFahtb+AIiRifnZB1A4dok=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Aedj3khbWiDQu0kNWEsIeeF1gD46jePvDK8cQYbnWOn5KquOjjHVItn3iXjXHUEbSzAGpt/vkG7Oy38YYsZuyYs0ZZprAwohe+bNML3A8sdKdWQh1UV7V+ekQAgNvrP4T4G/NEAkMyB49Bellg9i0CXWJYNKNoHtrO8/6zZqh4A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=skdyfppy; arc=none smtp.client-ip=91.218.175.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="skdyfppy"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1756039095;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=m2rFyAdabdWKDcoffdOn22k3lw2h0EwhxPuWGN9Yn7E=;
	b=skdyfppybdtAfOZfsxuhF+F67PpP1pZQIO2LvVcZFG+FnOlBQDmwM+jErhkzpR7ZTv0XEy
	szwrXpPVVqYPUJ7f0wkRz8Sp/MOY3EuguF1fvG54caZQYTzip5RwEXTDeI/cO8QbJESiSh
	8RMn1lj6P9CkgUDEwOYX3UrrU6TuZV4=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 13/21] bcachefs: rebalance now supports changing checksum type
Date: Sun, 24 Aug 2025 08:37:50 -0400
Message-ID: <20250824123800.1617669-14-kent.overstreet@linux.dev>
In-Reply-To: <20250824123800.1617669-1-kent.overstreet@linux.dev>
References: <20250824123800.1617669-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

We had a user report with a filesystem where data has been written out
with the incorrect checksum type - including no checksum.

That means we need to check/repair such cases, and rebalance is
responsible for handling io path option propagation to extents; thus,
rebalance needs to support checksum type.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/rebalance.c | 31 +++++++++++++++++++++++++------
 1 file changed, 25 insertions(+), 6 deletions(-)

diff --git a/fs/bcachefs/rebalance.c b/fs/bcachefs/rebalance.c
index 0d1abb0eeb88..a2fb2f1cec70 100644
--- a/fs/bcachefs/rebalance.c
+++ b/fs/bcachefs/rebalance.c
@@ -47,10 +47,12 @@ static void bch2_bkey_needs_rebalance(struct bch_fs *c, struct bkey_s_c k,
 				      struct bch_inode_opts *io_opts,
 				      unsigned *move_ptrs,
 				      unsigned *compress_ptrs,
+				      unsigned *csum_ptrs,
 				      u64 *sectors)
 {
 	*move_ptrs	= 0;
 	*compress_ptrs	= 0;
+	*csum_ptrs	= 0;
 	*sectors	= 0;
 
 	struct bkey_ptrs_c ptrs = bch2_bkey_ptrs_c(k);
@@ -66,6 +68,9 @@ static void bch2_bkey_needs_rebalance(struct bch_fs *c, struct bkey_s_c k,
 		bch2_compression_opt_to_type(io_opts
 					     ? io_opts->background_compression
 					     : rb_opts->background_compression);
+	unsigned csum_type = bch2_csum_opt_to_type(io_opts
+						   ? io_opts->data_checksum
+						   : rb_opts->data_checksum, true);
 	unsigned target = io_opts
 		? io_opts->background_target
 		: rb_opts->background_target;
@@ -87,6 +92,9 @@ static void bch2_bkey_needs_rebalance(struct bch_fs *c, struct bkey_s_c k,
 			if (p.crc.compression_type != compression_type)
 				*compress_ptrs |= ptr_idx;
 
+			if (p.crc.csum_type != csum_type)
+				*csum_ptrs |= ptr_idx;
+
 			if (target && !bch2_dev_in_target(c, p.ptr.dev, target))
 				*move_ptrs |= ptr_idx;
 		}
@@ -95,11 +103,11 @@ static void bch2_bkey_needs_rebalance(struct bch_fs *c, struct bkey_s_c k,
 	}
 
 	if (unwritten)
-		*compress_ptrs = 0;
+		*compress_ptrs = *csum_ptrs = 0;
 	if (incompressible)
 		*compress_ptrs = 0;
 
-	unsigned rb_ptrs = *move_ptrs | *compress_ptrs;
+	unsigned rb_ptrs = *move_ptrs | *compress_ptrs | *csum_ptrs;
 
 	if (!rb_ptrs)
 		return;
@@ -116,9 +124,10 @@ u64 bch2_bkey_sectors_need_rebalance(struct bch_fs *c, struct bkey_s_c k)
 {
 	unsigned move_ptrs	= 0;
 	unsigned compress_ptrs	= 0;
+	unsigned csum_ptrs	= 0;
 	u64 sectors		= 0;
 
-	bch2_bkey_needs_rebalance(c, k, NULL, &move_ptrs, &compress_ptrs, &sectors);
+	bch2_bkey_needs_rebalance(c, k, NULL, &move_ptrs, &compress_ptrs, &csum_ptrs, &sectors);
 	return sectors;
 }
 
@@ -128,10 +137,11 @@ static unsigned bch2_bkey_ptrs_need_rebalance(struct bch_fs *c,
 {
 	unsigned move_ptrs	= 0;
 	unsigned compress_ptrs	= 0;
+	unsigned csum_ptrs	= 0;
 	u64 sectors		= 0;
 
-	bch2_bkey_needs_rebalance(c, k, opts, &move_ptrs, &compress_ptrs, &sectors);
-	return move_ptrs|compress_ptrs;
+	bch2_bkey_needs_rebalance(c, k, opts, &move_ptrs, &compress_ptrs, &csum_ptrs, &sectors);
+	return move_ptrs|compress_ptrs|csum_ptrs;
 }
 
 static inline bool bkey_should_have_rb_opts(struct bch_fs *c,
@@ -509,9 +519,10 @@ static struct bkey_s_c next_rebalance_extent(struct btree_trans *trans,
 
 		unsigned move_ptrs	= 0;
 		unsigned compress_ptrs	= 0;
+		unsigned csum_ptrs	= 0;
 		u64 sectors		= 0;
 
-		bch2_bkey_needs_rebalance(c, k, opts, &move_ptrs, &compress_ptrs, &sectors);
+		bch2_bkey_needs_rebalance(c, k, opts, &move_ptrs, &compress_ptrs, &csum_ptrs, &sectors);
 
 		if (move_ptrs) {
 			prt_str(&buf, "move=");
@@ -529,6 +540,14 @@ static struct bkey_s_c next_rebalance_extent(struct btree_trans *trans,
 			prt_newline(&buf);
 		}
 
+		if (csum_ptrs) {
+			prt_str(&buf, "csum=");
+			bch2_prt_csum_opt(&buf, opts->data_checksum);
+			prt_str(&buf, " ");
+			bch2_prt_u64_base2(&buf, csum_ptrs);
+			prt_newline(&buf);
+		}
+
 		trace_rebalance_extent(c, buf.buf);
 	}
 	count_event(c, rebalance_extent);
-- 
2.50.1


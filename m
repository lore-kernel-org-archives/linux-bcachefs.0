Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB0912B2D7
	for <linux-bcachefs@vger.kernel.org>; Sun, 24 Aug 2025 12:38:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756039098; cv=none; b=D/A49ey5yKHcI7oa9QqV8kAoZu/CGFEashVBBXFdz6hBZfxuaRQ4/JIxi70voUrlOa0IcyJvP0vHgeHS7kH7zHqPWtwh7FVzglxJpcuu/vjf2bDHi1sqNqD6OwR15QlgZDCGpTDdqj0WdQ+vMqnCz1E31hc3KbU2xK0a4A/krtc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756039098; c=relaxed/simple;
	bh=DbTrpA0E0VK3PwswN+DR1c0CRto2W1Mcu7iHn2m3QKQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rz3mbdjs/+dp0/ebGxOdIf8TDFcDGF4UNT5nv0hq0xSTqf76C9g9d3fdRzGfmrYwW/h0/QEG/js/Lb1LrcwdbGqAK13RCMh2yKYP5lB6dXWn3ViSZTw6FBn8rhSnJ0CnTz/v/l+6y85WldUHxjG5HCC6uOB2aAoN78UqmqzZ7J4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ZzLIg16z; arc=none smtp.client-ip=91.218.175.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ZzLIg16z"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1756039094;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MYlRT1LJQpQ5Dy/68Pl9UeLcqFtBUHPFVLMNSHN7TVY=;
	b=ZzLIg16zD7ednMJnx40GxaaSToWm0P81YFe3yyBjQOrYfxDe8nK30sYVMB6zT6gUpvCDqb
	weLz5oKdTjlxgFMSkfCSGsc/uueCCdUXXfAwbq1PeB3RoVD6IyrhO4Ez0OBDzMmhlSf9FW
	CA8XNXWLmS0oHsuSqe3mIEj5xKLC3bk=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 12/21] bcachefs: bch2_bkey_needs_rebalance()
Date: Sun, 24 Aug 2025 08:37:49 -0400
Message-ID: <20250824123800.1617669-13-kent.overstreet@linux.dev>
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

Collapse bch2_bkey_sectors_need_rebalance() and
bch2_bkey_ptrs_need_rebalance() down to a single function, which outputs
both the bitmap of pointers that need to be rebalanced and the number of
sectors that need to be processed.

This will enable adding other reasons an extent might need to be
processed by rebalance: changing the checksum type,
increasing/decreasing replication level, enabling/disabling erasure
coding, etc.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/rebalance.c | 171 +++++++++++++++++++---------------------
 1 file changed, 81 insertions(+), 90 deletions(-)

diff --git a/fs/bcachefs/rebalance.c b/fs/bcachefs/rebalance.c
index 9e22ff0e2d28..0d1abb0eeb88 100644
--- a/fs/bcachefs/rebalance.c
+++ b/fs/bcachefs/rebalance.c
@@ -43,106 +43,95 @@ static const struct bch_extent_rebalance *bch2_bkey_rebalance_opts(struct bkey_s
 	return bch2_bkey_ptrs_rebalance_opts(bch2_bkey_ptrs_c(k));
 }
 
-static inline unsigned bch2_bkey_ptrs_need_compress(struct bch_fs *c,
-					   struct bch_inode_opts *opts,
-					   struct bkey_s_c k,
-					   struct bkey_ptrs_c ptrs)
+static void bch2_bkey_needs_rebalance(struct bch_fs *c, struct bkey_s_c k,
+				      struct bch_inode_opts *io_opts,
+				      unsigned *move_ptrs,
+				      unsigned *compress_ptrs,
+				      u64 *sectors)
 {
-	if (!opts->background_compression)
-		return 0;
+	*move_ptrs	= 0;
+	*compress_ptrs	= 0;
+	*sectors	= 0;
+
+	struct bkey_ptrs_c ptrs = bch2_bkey_ptrs_c(k);
+
+	const struct bch_extent_rebalance *rb_opts = bch2_bkey_ptrs_rebalance_opts(ptrs);
+	if (!io_opts && !rb_opts)
+		return;
+
+	if (bch2_bkey_extent_ptrs_flags(ptrs) & BIT_ULL(BCH_EXTENT_FLAG_poisoned))
+		return;
+
+	unsigned compression_type =
+		bch2_compression_opt_to_type(io_opts
+					     ? io_opts->background_compression
+					     : rb_opts->background_compression);
+	unsigned target = io_opts
+		? io_opts->background_target
+		: rb_opts->background_target;
+	if (target && !bch2_target_accepts_data(c, BCH_DATA_user, target))
+		target = 0;
 
-	unsigned compression_type = bch2_compression_opt_to_type(opts->background_compression);
 	const union bch_extent_entry *entry;
 	struct extent_ptr_decoded p;
-	unsigned ptr_bit = 1;
-	unsigned rewrite_ptrs = 0;
-
-	bkey_for_each_ptr_decode(k.k, ptrs, p, entry) {
-		if (p.crc.compression_type == BCH_COMPRESSION_TYPE_incompressible ||
-		    p.ptr.unwritten)
-			return 0;
+	bool incompressible = false, unwritten = false;
 
-		if (!p.ptr.cached && p.crc.compression_type != compression_type)
-			rewrite_ptrs |= ptr_bit;
-		ptr_bit <<= 1;
-	}
+	unsigned ptr_idx = 1;
 
-	return rewrite_ptrs;
-}
+	guard(rcu)();
+	bkey_for_each_ptr_decode(k.k, ptrs, p, entry) {
+		incompressible	|= p.crc.compression_type == BCH_COMPRESSION_TYPE_incompressible;
+		unwritten	|= p.ptr.unwritten;
 
-static inline unsigned bch2_bkey_ptrs_need_move(struct bch_fs *c,
-				       struct bch_inode_opts *opts,
-				       struct bkey_ptrs_c ptrs)
-{
-	if (!opts->background_target ||
-	    !bch2_target_accepts_data(c, BCH_DATA_user, opts->background_target))
-		return 0;
+		if (!p.ptr.cached) {
+			if (p.crc.compression_type != compression_type)
+				*compress_ptrs |= ptr_idx;
 
-	unsigned ptr_bit = 1;
-	unsigned rewrite_ptrs = 0;
+			if (target && !bch2_dev_in_target(c, p.ptr.dev, target))
+				*move_ptrs |= ptr_idx;
+		}
 
-	guard(rcu)();
-	bkey_for_each_ptr(ptrs, ptr) {
-		if (!ptr->cached && !bch2_dev_in_target(c, ptr->dev, opts->background_target))
-			rewrite_ptrs |= ptr_bit;
-		ptr_bit <<= 1;
+		ptr_idx <<= 1;
 	}
 
-	return rewrite_ptrs;
-}
+	if (unwritten)
+		*compress_ptrs = 0;
+	if (incompressible)
+		*compress_ptrs = 0;
 
-static unsigned bch2_bkey_ptrs_need_rebalance(struct bch_fs *c,
-					      struct bch_inode_opts *opts,
-					      struct bkey_s_c k)
-{
-	struct bkey_ptrs_c ptrs = bch2_bkey_ptrs_c(k);
+	unsigned rb_ptrs = *move_ptrs | *compress_ptrs;
 
-	if (bch2_bkey_extent_ptrs_flags(ptrs) & BIT_ULL(BCH_EXTENT_FLAG_poisoned))
-		return 0;
+	if (!rb_ptrs)
+		return;
 
-	return bch2_bkey_ptrs_need_compress(c, opts, k, ptrs) |
-		bch2_bkey_ptrs_need_move(c, opts, ptrs);
+	ptr_idx = 1;
+	bkey_for_each_ptr_decode(k.k, ptrs, p, entry) {
+		if (rb_ptrs & ptr_idx)
+			*sectors += p.crc.compressed_size;
+		ptr_idx <<= 1;
+	}
 }
 
 u64 bch2_bkey_sectors_need_rebalance(struct bch_fs *c, struct bkey_s_c k)
 {
-	struct bkey_ptrs_c ptrs = bch2_bkey_ptrs_c(k);
+	unsigned move_ptrs	= 0;
+	unsigned compress_ptrs	= 0;
+	u64 sectors		= 0;
 
-	const struct bch_extent_rebalance *opts = bch2_bkey_ptrs_rebalance_opts(ptrs);
-	if (!opts)
-		return 0;
-
-	if (bch2_bkey_extent_ptrs_flags(ptrs) & BIT_ULL(BCH_EXTENT_FLAG_poisoned))
-		return 0;
-
-	const union bch_extent_entry *entry;
-	struct extent_ptr_decoded p;
-	u64 sectors = 0;
-
-	if (opts->background_compression) {
-		unsigned compression_type = bch2_compression_opt_to_type(opts->background_compression);
-
-		bkey_for_each_ptr_decode(k.k, ptrs, p, entry) {
-			if (p.crc.compression_type == BCH_COMPRESSION_TYPE_incompressible ||
-			    p.ptr.unwritten) {
-				sectors = 0;
-				goto incompressible;
-			}
+	bch2_bkey_needs_rebalance(c, k, NULL, &move_ptrs, &compress_ptrs, &sectors);
+	return sectors;
+}
 
-			if (!p.ptr.cached && p.crc.compression_type != compression_type)
-				sectors += p.crc.compressed_size;
-		}
-	}
-incompressible:
-	if (opts->background_target) {
-		guard(rcu)();
-		bkey_for_each_ptr_decode(k.k, ptrs, p, entry)
-			if (!p.ptr.cached &&
-			    !bch2_dev_in_target(c, p.ptr.dev, opts->background_target))
-				sectors += p.crc.compressed_size;
-	}
+static unsigned bch2_bkey_ptrs_need_rebalance(struct bch_fs *c,
+					      struct bch_inode_opts *opts,
+					      struct bkey_s_c k)
+{
+	unsigned move_ptrs	= 0;
+	unsigned compress_ptrs	= 0;
+	u64 sectors		= 0;
 
-	return sectors;
+	bch2_bkey_needs_rebalance(c, k, opts, &move_ptrs, &compress_ptrs, &sectors);
+	return move_ptrs|compress_ptrs;
 }
 
 static inline bool bkey_should_have_rb_opts(struct bch_fs *c,
@@ -518,23 +507,25 @@ static struct bkey_s_c next_rebalance_extent(struct btree_trans *trans,
 		bch2_bkey_val_to_text(&buf, c, k);
 		prt_newline(&buf);
 
-		struct bkey_ptrs_c ptrs = bch2_bkey_ptrs_c(k);
+		unsigned move_ptrs	= 0;
+		unsigned compress_ptrs	= 0;
+		u64 sectors		= 0;
 
-		unsigned p = bch2_bkey_ptrs_need_compress(c, opts, k, ptrs);
-		if (p) {
-			prt_str(&buf, "compression=");
-			bch2_compression_opt_to_text(&buf, opts->background_compression);
+		bch2_bkey_needs_rebalance(c, k, opts, &move_ptrs, &compress_ptrs, &sectors);
+
+		if (move_ptrs) {
+			prt_str(&buf, "move=");
+			bch2_target_to_text(&buf, c, opts->background_target);
 			prt_str(&buf, " ");
-			bch2_prt_u64_base2(&buf, p);
+			bch2_prt_u64_base2(&buf, move_ptrs);
 			prt_newline(&buf);
 		}
 
-		p = bch2_bkey_ptrs_need_move(c, opts, ptrs);
-		if (p) {
-			prt_str(&buf, "move=");
-			bch2_target_to_text(&buf, c, opts->background_target);
+		if (compress_ptrs) {
+			prt_str(&buf, "compression=");
+			bch2_compression_opt_to_text(&buf, opts->background_compression);
 			prt_str(&buf, " ");
-			bch2_prt_u64_base2(&buf, p);
+			bch2_prt_u64_base2(&buf, compress_ptrs);
 			prt_newline(&buf);
 		}
 
-- 
2.50.1


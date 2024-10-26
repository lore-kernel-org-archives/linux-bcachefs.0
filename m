Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA668CA5A
	for <linux-bcachefs@vger.kernel.org>; Sat, 26 Oct 2024 05:46:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729921608; cv=none; b=WLEJXHMB0KZogDifBosWpYrbbUduOuwAjBEi0oVUfQRp8j/xfiJ+q4chp5p1TVP0sX0MITi4mJ660ZXu6HGX45VWJeU28wuXFHB2BgLeKmI1A+lsIU1pgArUH73r9w2fO2CbnuRpDyVBaQUvbB/2iHYctSeM7RomixHr6niu3NY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729921608; c=relaxed/simple;
	bh=jIdUeNdWTY25RCzlkRPkK+0PI1ucJGZGWT5tsnq4zQg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=kTheeKAgxrGEmkhrmX+gs8xxhvm5uuUM+O21VkH3CFDFTsE3nomxWqJLJCKsYhjb4UsSDKbAwTGaNNna3dETi5Eptsd175PeYbl5+FvjBPOzz/X+YWKjdojQLx/U9UuwyOEIGPaIu0nlqiS1arNUWKHVyp1mYBNi3W/90PygyLc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=C3RgQMxT; arc=none smtp.client-ip=91.218.175.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="C3RgQMxT"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1729921603;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=UA7LxYsexH7TaTLMb5Ze/CyWACqWVXpQcVXbi2oryIo=;
	b=C3RgQMxTDzzJ3aM+gp4Il2/s9a0RcjKDDsuKa0SWmegN+nMRCHRmdQEHvvJafOrl88d1xR
	idlL3E1PQ7+t8ZcW5KllRuiWfC0tQv2+l90dkVmOHvxu4wXCFzg4V79xz3o+qZLlfgB24H
	3/obiCpm24rvhAhYDl2DUG8KOxMWFzs=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH] bcachefs: Improve trace_rebalance_extent
Date: Sat, 26 Oct 2024 01:46:28 -0400
Message-ID: <20241026054628.2238952-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

We now say explicitly which pointers are being moved or compressed

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/extents.c   | 35 +++--------------------------
 fs/bcachefs/rebalance.c | 26 +++++++++++++++++-----
 fs/bcachefs/rebalance.h | 49 +++++++++++++++++++++++++++++++++++++++++
 3 files changed, 73 insertions(+), 37 deletions(-)

diff --git a/fs/bcachefs/extents.c b/fs/bcachefs/extents.c
index 8376d2a95c86..d4f6032deb8b 100644
--- a/fs/bcachefs/extents.c
+++ b/fs/bcachefs/extents.c
@@ -21,6 +21,7 @@
 #include "extents.h"
 #include "inode.h"
 #include "journal.h"
+#include "rebalance.h"
 #include "replicas.h"
 #include "super.h"
 #include "super-io.h"
@@ -1406,39 +1407,9 @@ unsigned bch2_bkey_ptrs_need_rebalance(struct bch_fs *c,
 				       struct bkey_s_c k)
 {
 	struct bkey_ptrs_c ptrs = bch2_bkey_ptrs_c(k);
-	unsigned rewrite_ptrs = 0;
 
-	if (opts->background_compression) {
-		unsigned compression_type = bch2_compression_opt_to_type(opts->background_compression);
-		const union bch_extent_entry *entry;
-		struct extent_ptr_decoded p;
-		unsigned ptr_bit = 1;
-
-		bkey_for_each_ptr_decode(k.k, ptrs, p, entry) {
-			if (p.crc.compression_type == BCH_COMPRESSION_TYPE_incompressible ||
-			    p.ptr.unwritten) {
-				rewrite_ptrs = 0;
-				goto incompressible;
-			}
-
-			if (!p.ptr.cached && p.crc.compression_type != compression_type)
-				rewrite_ptrs |= ptr_bit;
-			ptr_bit <<= 1;
-		}
-	}
-incompressible:
-	if (opts->background_target &&
-	    bch2_target_accepts_data(c, BCH_DATA_user, opts->background_target)) {
-		unsigned ptr_bit = 1;
-
-		bkey_for_each_ptr(ptrs, ptr) {
-			if (!ptr->cached && !bch2_dev_in_target(c, ptr->dev, opts->background_target))
-				rewrite_ptrs |= ptr_bit;
-			ptr_bit <<= 1;
-		}
-	}
-
-	return rewrite_ptrs;
+	return bch2_bkey_ptrs_need_compress(c, opts, k, ptrs) |
+		bch2_bkey_ptrs_need_move(c, opts, ptrs);
 }
 
 u64 bch2_bkey_sectors_need_rebalance(struct bch_fs *c, struct bkey_s_c k)
diff --git a/fs/bcachefs/rebalance.c b/fs/bcachefs/rebalance.c
index 3be9c85dd55d..124da250cbe7 100644
--- a/fs/bcachefs/rebalance.c
+++ b/fs/bcachefs/rebalance.c
@@ -177,12 +177,28 @@ static struct bkey_s_c next_rebalance_extent(struct btree_trans *trans,
 	if (trace_rebalance_extent_enabled()) {
 		struct printbuf buf = PRINTBUF;
 
-		prt_str(&buf, "target=");
-		bch2_target_to_text(&buf, c, io_opts->background_target);
-		prt_str(&buf, " compression=");
-		bch2_compression_opt_to_text(&buf, io_opts->background_compression);
-		prt_str(&buf, " ");
 		bch2_bkey_val_to_text(&buf, c, k);
+		prt_newline(&buf);
+
+		struct bkey_ptrs_c ptrs = bch2_bkey_ptrs_c(k);
+
+		unsigned p = bch2_bkey_ptrs_need_compress(c, io_opts, k, ptrs);
+		if (p) {
+			prt_str(&buf, "compression=");
+			bch2_compression_opt_to_text(&buf, io_opts->background_compression);
+			prt_str(&buf, " ");
+			bch2_prt_u64_base2(&buf, p);
+			prt_newline(&buf);
+		}
+
+		p = bch2_bkey_ptrs_need_move(c, io_opts, ptrs);
+		if (p) {
+			prt_str(&buf, "move=");
+			bch2_target_to_text(&buf, c, io_opts->background_target);
+			prt_str(&buf, " ");
+			bch2_prt_u64_base2(&buf, p);
+			prt_newline(&buf);
+		}
 
 		trace_rebalance_extent(c, buf.buf);
 		printbuf_exit(&buf);
diff --git a/fs/bcachefs/rebalance.h b/fs/bcachefs/rebalance.h
index 791649c04ff5..606c88f49f7f 100644
--- a/fs/bcachefs/rebalance.h
+++ b/fs/bcachefs/rebalance.h
@@ -2,8 +2,57 @@
 #ifndef _BCACHEFS_REBALANCE_H
 #define _BCACHEFS_REBALANCE_H
 
+#include "compress.h"
+#include "disk_groups.h"
 #include "rebalance_types.h"
 
+static inline unsigned bch2_bkey_ptrs_need_compress(struct bch_fs *c,
+					   struct bch_io_opts *opts,
+					   struct bkey_s_c k,
+					   struct bkey_ptrs_c ptrs)
+{
+	if (!opts->background_compression)
+		return 0;
+
+	unsigned compression_type = bch2_compression_opt_to_type(opts->background_compression);
+	const union bch_extent_entry *entry;
+	struct extent_ptr_decoded p;
+	unsigned ptr_bit = 1;
+	unsigned rewrite_ptrs = 0;
+
+	bkey_for_each_ptr_decode(k.k, ptrs, p, entry) {
+		if (p.crc.compression_type == BCH_COMPRESSION_TYPE_incompressible ||
+		    p.ptr.unwritten)
+			return 0;
+
+		if (!p.ptr.cached && p.crc.compression_type != compression_type)
+			rewrite_ptrs |= ptr_bit;
+		ptr_bit <<= 1;
+	}
+
+	return rewrite_ptrs;
+}
+
+static inline unsigned bch2_bkey_ptrs_need_move(struct bch_fs *c,
+				       struct bch_io_opts *opts,
+				       struct bkey_ptrs_c ptrs)
+{
+	if (!opts->background_target ||
+	    !bch2_target_accepts_data(c, BCH_DATA_user, opts->background_target))
+		return 0;
+
+	unsigned ptr_bit = 1;
+	unsigned rewrite_ptrs = 0;
+
+	bkey_for_each_ptr(ptrs, ptr) {
+		if (!ptr->cached && !bch2_dev_in_target(c, ptr->dev, opts->background_target))
+			rewrite_ptrs |= ptr_bit;
+		ptr_bit <<= 1;
+	}
+
+	return rewrite_ptrs;
+}
+
 int bch2_set_rebalance_needs_scan_trans(struct btree_trans *, u64);
 int bch2_set_rebalance_needs_scan(struct bch_fs *, u64 inum);
 int bch2_set_fs_needs_rebalance(struct bch_fs *);
-- 
2.45.2


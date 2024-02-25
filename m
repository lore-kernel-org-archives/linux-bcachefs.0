Received: from out-174.mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 916891AADA
	for <linux-bcachefs@vger.kernel.org>; Sun, 25 Feb 2024 02:38:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708828735; cv=none; b=kE/yVN1ChKkgr1L62DQiaUxmtu5FsWBOqnvtwBtZXaXX8CgRUWovyfEPIAskH4l5lMPSLdBsyUqZusD/ZljWHMMrjHs0DVil6KwK2VEH0nnTQzzAiBA4ToGxyxAv/iBt0AeMEZsqq2iax1p+COKpHz31m/L331u5da8H5k5Nxh4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708828735; c=relaxed/simple;
	bh=ZgM0zLMZFwJYqyvB4tXh9kF50cWRp9rLDmexM/GbfvM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A3pPFrkG82M/5zW+9+PIlviuZvnMPo8VyDT1v7RAsV5vFjS9MmCbjSKWJgLRgqLceYdYCneKPkuzlVgHq+tiJcO2+mnYoAvDIsW7OmV3PrRrduHpcj3Qwdn/umFr5EIUNYSCJeImiMeAa9vYBEQbT+xIik50iOR1LZqeMRo8WtI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=GtMroGI9; arc=none smtp.client-ip=95.215.58.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="GtMroGI9"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1708828732;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=weqtx2u84KusAKamrBTKZCBf70EK9pRqL6N4MsvPgW0=;
	b=GtMroGI9SLS2HtSssDe36Rm8zROfrOV84oqSilqNyQ2mrClrsaF9kMvGGXEIGcdMFQ+4ox
	yEVdD91npxWvtmF924xIjbT+LsABnJdd8Pk4fMKyoMRA3ZTxdonTPh4BrzJXvRlvxiIqHj
	JLCJDAQVT9YdZ0xYe8lCVAXTYVeoW0U=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>,
	djwong@kernel.org,
	bfoster@redhat.com
Subject: [PATCH 19/21] bcachefs: Convert bch2_compression_stats_to_text() to new accounting
Date: Sat, 24 Feb 2024 21:38:21 -0500
Message-ID: <20240225023826.2413565-20-kent.overstreet@linux.dev>
In-Reply-To: <20240225023826.2413565-1-kent.overstreet@linux.dev>
References: <20240225023826.2413565-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

We no longer have to walk the whole btree to calculate compression
stats.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/sysfs.c | 85 ++++++++++-----------------------------------
 1 file changed, 18 insertions(+), 67 deletions(-)

diff --git a/fs/bcachefs/sysfs.c b/fs/bcachefs/sysfs.c
index c86a93a8d8fc..287a0bf920db 100644
--- a/fs/bcachefs/sysfs.c
+++ b/fs/bcachefs/sysfs.c
@@ -22,6 +22,7 @@
 #include "buckets.h"
 #include "clock.h"
 #include "compress.h"
+#include "disk_accounting.h"
 #include "disk_groups.h"
 #include "ec.h"
 #include "inode.h"
@@ -256,63 +257,6 @@ static size_t bch2_btree_cache_size(struct bch_fs *c)
 
 static int bch2_compression_stats_to_text(struct printbuf *out, struct bch_fs *c)
 {
-	struct btree_trans *trans;
-	enum btree_id id;
-	struct compression_type_stats {
-		u64		nr_extents;
-		u64		sectors_compressed;
-		u64		sectors_uncompressed;
-	} s[BCH_COMPRESSION_TYPE_NR];
-	u64 compressed_incompressible = 0;
-	int ret = 0;
-
-	memset(s, 0, sizeof(s));
-
-	if (!test_bit(BCH_FS_started, &c->flags))
-		return -EPERM;
-
-	trans = bch2_trans_get(c);
-
-	for (id = 0; id < BTREE_ID_NR; id++) {
-		if (!btree_type_has_ptrs(id))
-			continue;
-
-		ret = for_each_btree_key(trans, iter, id, POS_MIN,
-					 BTREE_ITER_ALL_SNAPSHOTS, k, ({
-			struct bkey_ptrs_c ptrs = bch2_bkey_ptrs_c(k);
-			struct bch_extent_crc_unpacked crc;
-			const union bch_extent_entry *entry;
-			bool compressed = false, incompressible = false;
-
-			bkey_for_each_crc(k.k, ptrs, crc, entry) {
-				incompressible	|= crc.compression_type == BCH_COMPRESSION_TYPE_incompressible;
-				compressed	|= crc_is_compressed(crc);
-
-				if (crc_is_compressed(crc)) {
-					s[crc.compression_type].nr_extents++;
-					s[crc.compression_type].sectors_compressed += crc.compressed_size;
-					s[crc.compression_type].sectors_uncompressed += crc.uncompressed_size;
-				}
-			}
-
-			compressed_incompressible += compressed && incompressible;
-
-			if (!compressed) {
-				unsigned t = incompressible ? BCH_COMPRESSION_TYPE_incompressible : 0;
-
-				s[t].nr_extents++;
-				s[t].sectors_compressed += k.k->size;
-				s[t].sectors_uncompressed += k.k->size;
-			}
-			0;
-		}));
-	}
-
-	bch2_trans_put(trans);
-
-	if (ret)
-		return ret;
-
 	prt_str(out, "type");
 	printbuf_tabstop_push(out, 12);
 	prt_tab(out);
@@ -330,28 +274,35 @@ static int bch2_compression_stats_to_text(struct printbuf *out, struct bch_fs *c
 	prt_tab_rjust(out);
 	prt_newline(out);
 
-	for (unsigned i = 0; i < ARRAY_SIZE(s); i++) {
+	for (unsigned i = 1; i < BCH_COMPRESSION_TYPE_NR; i++) {
+		struct disk_accounting_key a = {
+			.type			= BCH_DISK_ACCOUNTING_compression,
+			.compression.type	= i,
+		};
+		struct bpos p = disk_accounting_key_to_bpos(&a);
+		u64 v[3];
+		bch2_accounting_mem_read(c, p, v, ARRAY_SIZE(v));
+
+		u64 nr_extents			= v[0];
+		u64 sectors_uncompressed	= v[1];
+		u64 sectors_compressed		= v[2];
+
 		bch2_prt_compression_type(out, i);
 		prt_tab(out);
 
-		prt_human_readable_u64(out, s[i].sectors_compressed << 9);
+		prt_human_readable_u64(out, sectors_compressed << 9);
 		prt_tab_rjust(out);
 
-		prt_human_readable_u64(out, s[i].sectors_uncompressed << 9);
+		prt_human_readable_u64(out, sectors_uncompressed << 9);
 		prt_tab_rjust(out);
 
-		prt_human_readable_u64(out, s[i].nr_extents
-				       ? div_u64(s[i].sectors_uncompressed << 9, s[i].nr_extents)
+		prt_human_readable_u64(out, nr_extents
+				       ? div_u64(sectors_uncompressed << 9, nr_extents)
 				       : 0);
 		prt_tab_rjust(out);
 		prt_newline(out);
 	}
 
-	if (compressed_incompressible) {
-		prt_printf(out, "%llu compressed & incompressible extents", compressed_incompressible);
-		prt_newline(out);
-	}
-
 	return 0;
 }
 
-- 
2.43.0


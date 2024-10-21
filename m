Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DE332C95
	for <linux-bcachefs@vger.kernel.org>; Mon, 21 Oct 2024 03:41:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729482089; cv=none; b=qBE0dL5k3fSBdLegCKlL3TY29g5F963O5tEjA6hgtZcx9Vp/To74KbRFX8sQr8NAJw8LLe41T2w81rl7XxzQT1P6Hy0EjLwCVulooX0BZhstQbTd7Noi6Go2xjqKZCjIbQOd8oEuHx3+VqPzi4loAydfGKDxaqypaN7D0NX/DW0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729482089; c=relaxed/simple;
	bh=Kwo2KehL1QMw5MWxsiVb53HCyjUlWKPjshybOZbhJ1s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fZfaW4QkqYYmqZbPPeWMFOn9ys6Wb2vaS1zlwNEonETvYDz5qPR1jmRqwHgLGS1SEIbtVGxSNKlNiI8TZvQnqetkYrzErSb8rR8ffJJaOAL0oYumgzq/KCEgdc89x7j3g0l3zr36DLWelyxZ32SlKgcugidD64SCSXXQjyD8GyE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=E9GbFDao; arc=none smtp.client-ip=91.218.175.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="E9GbFDao"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1729482085;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UzqHi+xE+t+yrD0mClSKakxoTfpw8lqkTMjNIsxrGqs=;
	b=E9GbFDao37XcMbLpVCapor92IqdHpUR5ASG8n1y2fxG5NOyDpi9oPxKqcu+8qNGhdwJlRx
	KXYz+IcL0GQZ2k/BseVs6wI932+Youn0fnQ98YpFlXGAVTTlxNj3YL4f4CuNmz9c2K50hN
	9LrsZPBzF8qn/HGOWU3hfGITTGeiN9c=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 06/12] bcachefs: kill __bch2_bkey_sectors_need_rebalance()
Date: Sun, 20 Oct 2024 23:40:57 -0400
Message-ID: <20241021034106.384756-7-kent.overstreet@linux.dev>
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

Single caller, fold into bch2_bkey_sectors_need_rebalance()

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/extents.c | 23 ++++++++++-------------
 1 file changed, 10 insertions(+), 13 deletions(-)

diff --git a/fs/bcachefs/extents.c b/fs/bcachefs/extents.c
index 7a9bc5122674..a409e1258583 100644
--- a/fs/bcachefs/extents.c
+++ b/fs/bcachefs/extents.c
@@ -1439,16 +1439,19 @@ unsigned bch2_bkey_ptrs_need_rebalance(struct bch_fs *c, struct bkey_s_c k,
 	return rewrite_ptrs;
 }
 
-static u64 __bch2_bkey_sectors_need_rebalance(struct bch_fs *c, struct bkey_s_c k,
-				       unsigned target, unsigned compression)
+u64 bch2_bkey_sectors_need_rebalance(struct bch_fs *c, struct bkey_s_c k)
 {
+	const struct bch_extent_rebalance *opts = bch2_bkey_rebalance_opts(k);
+	if (!opts)
+		return 0;
+
 	struct bkey_ptrs_c ptrs = bch2_bkey_ptrs_c(k);
 	const union bch_extent_entry *entry;
 	struct extent_ptr_decoded p;
 	u64 sectors = 0;
 
-	if (compression) {
-		unsigned compression_type = bch2_compression_opt_to_type(compression);
+	if (opts->compression) {
+		unsigned compression_type = bch2_compression_opt_to_type(opts->compression);
 
 		bkey_for_each_ptr_decode(k.k, ptrs, p, entry) {
 			if (p.crc.compression_type == BCH_COMPRESSION_TYPE_incompressible ||
@@ -1462,22 +1465,16 @@ static u64 __bch2_bkey_sectors_need_rebalance(struct bch_fs *c, struct bkey_s_c
 		}
 	}
 incompressible:
-	if (target && bch2_target_accepts_data(c, BCH_DATA_user, target)) {
+	if (opts->target &&
+	    bch2_target_accepts_data(c, BCH_DATA_user, opts->target)) {
 		bkey_for_each_ptr_decode(k.k, ptrs, p, entry)
-			if (!p.ptr.cached && !bch2_dev_in_target(c, p.ptr.dev, target))
+			if (!p.ptr.cached && !bch2_dev_in_target(c, p.ptr.dev, opts->target))
 				sectors += p.crc.compressed_size;
 	}
 
 	return sectors;
 }
 
-u64 bch2_bkey_sectors_need_rebalance(struct bch_fs *c, struct bkey_s_c k)
-{
-	const struct bch_extent_rebalance *r = bch2_bkey_rebalance_opts(k);
-
-	return r ? __bch2_bkey_sectors_need_rebalance(c, k, r->target, r->compression) : 0;
-}
-
 int bch2_bkey_set_needs_rebalance(struct bch_fs *c, struct bkey_i *_k,
 				  struct bch_io_opts *opts)
 {
-- 
2.45.2


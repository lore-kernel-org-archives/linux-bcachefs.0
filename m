Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EC1A1990C8
	for <linux-bcachefs@vger.kernel.org>; Mon, 21 Oct 2024 03:41:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729482089; cv=none; b=NoDzlCV6+dcSFtA4O6w/Va8PId8YJ6gJ+N5lTziHTBNf0iEpvS707VvQIn9Pau1xtYml+6jk7mrKvPUD8UAUxqQYOyr6S88qecLFRJlr/LINBpnyyurOMU9OkLtY1Evc/cHDKr8HkHyawOwrcI2ScVCTciVUT4IJJ/u/rGHIkOk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729482089; c=relaxed/simple;
	bh=yfF01w4TMCRvuNTW4oNUyaCK+4AsPuffhiuFPozYGvY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M5oUhY14iUIlCvyaUBn0V695ZjwKslZxJRRSp20Of8xaRTHXJrtpTjDtOawx8qW9QwBneXXPATqnxLWefeowCS+XBKJBd/lePlFtsHg8alOZQRIjqwc3OlhjQI/m5vmmhWgDKvQGHw1W2FhEeJdeDnhdsoxkGKB3N2E/HRQACqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=pjgeZFsG; arc=none smtp.client-ip=91.218.175.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="pjgeZFsG"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1729482085;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=d5w2xhtIdN259RwaEnA80p4wFVV4q6GvaYnUD+3SgBE=;
	b=pjgeZFsGiZKJrQ2+YN6J0y5hjK5VkEZXoBHwPHFNDgJ54cJ7VbIt2GbX8UWnjpgYP76RN9
	uBnb+oAksyU4R2yJwRyLlDA4B2b3WW7jeYUT0MAPovr4SjlfoNM55Zwe0HEvAX8bSO1rl/
	wXNoHz1DYj+IN+pyfnEnz5hkw5qOAA8=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 07/12] bcachefs: rename bch_extent_rebalance fields to match other opts structs
Date: Sun, 20 Oct 2024 23:40:58 -0400
Message-ID: <20241021034106.384756-8-kent.overstreet@linux.dev>
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

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/extents.c        | 36 ++++++++++++++++++------------------
 fs/bcachefs/extents_format.h |  8 ++++----
 fs/bcachefs/rebalance.c      | 12 ++++++------
 3 files changed, 28 insertions(+), 28 deletions(-)

diff --git a/fs/bcachefs/extents.c b/fs/bcachefs/extents.c
index a409e1258583..132669ee7aaa 100644
--- a/fs/bcachefs/extents.c
+++ b/fs/bcachefs/extents.c
@@ -1161,11 +1161,11 @@ void bch2_bkey_ptrs_to_text(struct printbuf *out, struct bch_fs *c,
 
 			prt_str(out, "rebalance: target ");
 			if (c)
-				bch2_target_to_text(out, c, r->target);
+				bch2_target_to_text(out, c, r->background_target);
 			else
-				prt_printf(out, "%u", r->target);
+				prt_printf(out, "%u", r->background_target);
 			prt_str(out, " compression ");
-			bch2_compression_opt_to_text(out, r->compression);
+			bch2_compression_opt_to_text(out, r->background_compression);
 			break;
 		}
 		default:
@@ -1450,8 +1450,8 @@ u64 bch2_bkey_sectors_need_rebalance(struct bch_fs *c, struct bkey_s_c k)
 	struct extent_ptr_decoded p;
 	u64 sectors = 0;
 
-	if (opts->compression) {
-		unsigned compression_type = bch2_compression_opt_to_type(opts->compression);
+	if (opts->background_compression) {
+		unsigned compression_type = bch2_compression_opt_to_type(opts->background_compression);
 
 		bkey_for_each_ptr_decode(k.k, ptrs, p, entry) {
 			if (p.crc.compression_type == BCH_COMPRESSION_TYPE_incompressible ||
@@ -1465,10 +1465,10 @@ u64 bch2_bkey_sectors_need_rebalance(struct bch_fs *c, struct bkey_s_c k)
 		}
 	}
 incompressible:
-	if (opts->target &&
-	    bch2_target_accepts_data(c, BCH_DATA_user, opts->target)) {
+	if (opts->background_target &&
+	    bch2_target_accepts_data(c, BCH_DATA_user, opts->background_target)) {
 		bkey_for_each_ptr_decode(k.k, ptrs, p, entry)
-			if (!p.ptr.cached && !bch2_dev_in_target(c, p.ptr.dev, opts->target))
+			if (!p.ptr.cached && !bch2_dev_in_target(c, p.ptr.dev, opts->background_target))
 				sectors += p.crc.compressed_size;
 	}
 
@@ -1497,14 +1497,14 @@ int bch2_bkey_set_needs_rebalance(struct bch_fs *c, struct bkey_i *_k,
 			 * they're referenced by different inodes with different
 			 * options:
 			 */
-			if (r->target)
-				target = r->target;
-			if (r->compression)
-				compression = r->compression;
+			if (r->background_target)
+				target = r->background_target;
+			if (r->background_compression)
+				compression = r->background_compression;
 		}
 
-		r->target	= target;
-		r->compression	= compression;
+		r->background_target		= target;
+		r->background_compression	= compression;
 	}
 
 	needs_rebalance = bch2_bkey_ptrs_need_rebalance(c, k.s_c, target, compression);
@@ -1512,10 +1512,10 @@ int bch2_bkey_set_needs_rebalance(struct bch_fs *c, struct bkey_i *_k,
 	if (needs_rebalance && !r) {
 		union bch_extent_entry *new = bkey_val_end(k);
 
-		new->rebalance.type		= 1U << BCH_EXTENT_ENTRY_rebalance;
-		new->rebalance.compression	= compression;
-		new->rebalance.target		= target;
-		new->rebalance.unused		= 0;
+		new->rebalance.type			= 1U << BCH_EXTENT_ENTRY_rebalance;
+		new->rebalance.background_compression	= compression;
+		new->rebalance.background_target	= target;
+		new->rebalance.unused			= 0;
 		k.k->u64s += extent_entry_u64s(new);
 	} else if (!needs_rebalance && r && k.k->type != KEY_TYPE_reflink_v) {
 		/*
diff --git a/fs/bcachefs/extents_format.h b/fs/bcachefs/extents_format.h
index 3bd2fdbb0817..2cc3e60f3b12 100644
--- a/fs/bcachefs/extents_format.h
+++ b/fs/bcachefs/extents_format.h
@@ -205,11 +205,11 @@ struct bch_extent_rebalance {
 #if defined(__LITTLE_ENDIAN_BITFIELD)
 	__u64			type:6,
 				unused:34,
-				compression:8, /* enum bch_compression_opt */
-				target:16;
+				background_compression:8, /* enum bch_compression_opt */
+				background_target:16;
 #elif defined (__BIG_ENDIAN_BITFIELD)
-	__u64			target:16,
-				compression:8,
+	__u64			background_target:16,
+				background_compression:8,
 				unused:34,
 				type:6;
 #endif
diff --git a/fs/bcachefs/rebalance.c b/fs/bcachefs/rebalance.c
index 2f93ae8781bb..dc70e6feaf79 100644
--- a/fs/bcachefs/rebalance.c
+++ b/fs/bcachefs/rebalance.c
@@ -157,8 +157,8 @@ static struct bkey_s_c next_rebalance_extent(struct btree_trans *trans,
 	memset(data_opts, 0, sizeof(*data_opts));
 
 	data_opts->rewrite_ptrs		=
-		bch2_bkey_ptrs_need_rebalance(c, k, r->target, r->compression);
-	data_opts->target		= r->target;
+		bch2_bkey_ptrs_need_rebalance(c, k, r->background_target, r->background_compression);
+	data_opts->target		= r->background_target;
 	data_opts->write_flags		|= BCH_WRITE_ONLY_SPECIFIED_DEVS;
 
 	if (!data_opts->rewrite_ptrs) {
@@ -179,9 +179,9 @@ static struct bkey_s_c next_rebalance_extent(struct btree_trans *trans,
 		struct printbuf buf = PRINTBUF;
 
 		prt_str(&buf, "target=");
-		bch2_target_to_text(&buf, c, r->target);
+		bch2_target_to_text(&buf, c, r->background_target);
 		prt_str(&buf, " compression=");
-		bch2_compression_opt_to_text(&buf, r->compression);
+		bch2_compression_opt_to_text(&buf, r->background_compression);
 		prt_str(&buf, " ");
 		bch2_bkey_val_to_text(&buf, c, k);
 
@@ -261,8 +261,8 @@ static bool rebalance_pred(struct bch_fs *c, void *arg,
 	} else {
 		const struct bch_extent_rebalance *r = bch2_bkey_rebalance_opts(k);
 
-		target		= r ? r->target : io_opts->background_target;
-		compression	= r ? r->compression : io_opts->background_compression;
+		target		= r ? r->background_target : io_opts->background_target;
+		compression	= r ? r->background_compression : io_opts->background_compression;
 	}
 
 	data_opts->rewrite_ptrs		= bch2_bkey_ptrs_need_rebalance(c, k, target, compression);
-- 
2.45.2


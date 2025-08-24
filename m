Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A5062D9ECA
	for <linux-bcachefs@vger.kernel.org>; Sun, 24 Aug 2025 12:38:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756039103; cv=none; b=ZdiqsRqsS9J7/w+u8bDeQBcqUhoIMdj6+8hC7GSGS4U0Ot4RnYRp1P+q6UzW102XpsPSr/WZ+Ed+06484R5ysukngvNLy6S82GPBOW8sdqV4YFLvYd+V0S1MuJjezCMR0I0StOAaGUzdHrPLRiQ9PMJ7vM1T1XPzKXu12/P0xVM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756039103; c=relaxed/simple;
	bh=g5qFImPqNyPSf5gbu0FIzNEEUsxAl0XJKdxdElBgWYk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UScPrugMil/SzIQhjH/ER4ySMpRnTuGIQ7bZLL7O0uNA//DgzPD2LCCG/CgiT9aWgf4mwMl88BaCGkzBQqpX99VLvn3s+/kgYprR9e5O60CelLRXCOpB+p8jZ3RmopUjsz6zrbcttoQUoBHN1rr6e280bF6QogsW70NPruJ1uCo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=O0RrvnXY; arc=none smtp.client-ip=91.218.175.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="O0RrvnXY"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1756039100;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=psGjSin1zbdjSL6mobS0OqBP6lzA2r6QtUaQ/ZYU2Fk=;
	b=O0RrvnXYoyIVCMYydBjUFKMX39hnmtT2B+mCwcpcTIrSFwlrRqxujphG7Bt7BDr6MSTeaG
	EjPvzf0m1b6Ix33dE4WawrAndnN57o7VBw79Cl5XqwKekX+3Wdv+wSHK2elY8CDNU3u7LK
	/3eMZDJw4Y8JLrmIarKVEwDvZyS3arc=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 20/21] bcachefs: rebalance: erasure_code opt change now handled
Date: Sun, 24 Aug 2025 08:37:57 -0400
Message-ID: <20250824123800.1617669-21-kent.overstreet@linux.dev>
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

We had no existing mechanism for applying/removing erasure coding to
existing data, nothing is being obsoleted.

Like other IO path options, rebalance now ensures that data is stored
correctly according to the current erasure_code option.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/rebalance.c | 24 ++++++++++++++++++++----
 1 file changed, 20 insertions(+), 4 deletions(-)

diff --git a/fs/bcachefs/rebalance.c b/fs/bcachefs/rebalance.c
index 29e12dbf3710..525e4d1716c5 100644
--- a/fs/bcachefs/rebalance.c
+++ b/fs/bcachefs/rebalance.c
@@ -593,9 +593,12 @@ static struct bkey_s_c next_rebalance_extent(struct btree_trans *trans,
 	data_opts->target		= opts->background_target;
 	data_opts->write_flags		|= BCH_WRITE_only_specified_devs;
 
+	struct bkey_ptrs_c ptrs = bch2_bkey_ptrs_c(k);
+	const union bch_extent_entry *entry;
+	struct extent_ptr_decoded p;
+
 	if (r.need_rb & BIT(BCH_REBALANCE_data_replicas)) {
 		unsigned durability = bch2_bkey_durability(c, k);
-		struct bkey_ptrs_c ptrs = bch2_bkey_ptrs_c(k);
 		unsigned ptr_bit = 1;
 
 		guard(rcu)();
@@ -609,9 +612,6 @@ static struct bkey_s_c next_rebalance_extent(struct btree_trans *trans,
 
 			data_opts->extra_replicas = opts->data_replicas - durability;
 		} else {
-			const union bch_extent_entry *entry;
-			struct extent_ptr_decoded p;
-
 			bkey_for_each_ptr_decode(k.k, ptrs, p, entry) {
 				unsigned d = bch2_extent_ptr_durability(c, &p);
 
@@ -635,6 +635,22 @@ static struct bkey_s_c next_rebalance_extent(struct btree_trans *trans,
 		}
 	}
 
+	if (r.need_rb & BIT(BCH_REBALANCE_erasure_code)) {
+		if (opts->erasure_code) {
+			data_opts->extra_replicas = min(data_opts->extra_replicas, 1);
+		} else {
+			unsigned ptr_bit = 1;
+			bkey_for_each_ptr_decode(k.k, ptrs, p, entry) {
+				if (p.has_ec) {
+					data_opts->kill_ec_ptrs |= ptr_bit;
+					data_opts->extra_replicas += p.ec.redundancy;
+				}
+
+				ptr_bit <<= 1;
+			}
+		}
+	}
+
 	if (!data_opts->rewrite_ptrs &&
 	    !data_opts->kill_ptrs &&
 	    !data_opts->kill_ec_ptrs &&
-- 
2.50.1


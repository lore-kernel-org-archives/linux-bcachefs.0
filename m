Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDF63192D6E
	for <linux-bcachefs@vger.kernel.org>; Mon, 21 Oct 2024 03:41:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729482088; cv=none; b=PXYhw+IGhaD1OtU2vMFvmFNKIzEdwbSPBYLacB9ikSkuF9RmFoaSal2Yh0ac3vSmoozqcCXEmH+R9ZjlSqL9gfAPOC93mqx1Z3RE95lrZsyzGe7BF9h2hQFmVIrWvQFU+SbqujS528b/sTHBfCZhbipn46IB+H2hsJ6jpftpElg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729482088; c=relaxed/simple;
	bh=4a4ju464KxzjiiGLYJgL1UiSPXtbdRJeabi2F5S+juM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pVlsxAaFCE0m1xvPb6Kma/zV14yXj8tOEjbCL2ane1dgtc0WWn5HlOXEHMbtYMdUvOWTUNDGreA+dZi976hyxQRppaNjHgNwqDGmfbZoj2qbk563pwLpbcMu6vS0jtNXqBilDHolo4MlpIGArxSH1AOU0LM19gbb5oqd9eobxNs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=bcykOS7r; arc=none smtp.client-ip=91.218.175.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="bcykOS7r"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1729482082;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FJEMkiALHMhix59Hrt45kbbjMg97D77kITx8bZ7fcuc=;
	b=bcykOS7rIgRCi3y2rQqLMH0W1r7Mm7sejZTJ7/u/VUpGRy3Bjv00Q6JE5b0f4DKXvtz00t
	XdEVYLPRwaqJYdlKm8XbG72KTVn8ftbhWzxHlUEb8XemT1cetiIQJO7wByZjgHb1dgVAYW
	ufKz+9XuEdgudDOnfZuNAIAvk8QBmuI=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 02/12] bcachefs: use bch2_data_update_opts_to_text() in trace_move_extent_fail()
Date: Sun, 20 Oct 2024 23:40:53 -0400
Message-ID: <20241021034106.384756-3-kent.overstreet@linux.dev>
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
 fs/bcachefs/data_update.c | 33 ++++++++++++++-------------------
 1 file changed, 14 insertions(+), 19 deletions(-)

diff --git a/fs/bcachefs/data_update.c b/fs/bcachefs/data_update.c
index 8e75a852b358..5ea432bc0052 100644
--- a/fs/bcachefs/data_update.c
+++ b/fs/bcachefs/data_update.c
@@ -110,11 +110,8 @@ static void trace_move_extent_fail2(struct data_update *m,
 {
 	struct bch_fs *c = m->op.c;
 	struct bkey_s_c old = bkey_i_to_s_c(m->k.k);
-	const union bch_extent_entry *entry;
-	struct bch_extent_ptr *ptr;
-	struct extent_ptr_decoded p;
 	struct printbuf buf = PRINTBUF;
-	unsigned i, rewrites_found = 0;
+	unsigned rewrites_found = 0;
 
 	if (!trace_move_extent_fail_enabled())
 		return;
@@ -122,27 +119,25 @@ static void trace_move_extent_fail2(struct data_update *m,
 	prt_str(&buf, msg);
 
 	if (insert) {
-		i = 0;
+		const union bch_extent_entry *entry;
+		struct bch_extent_ptr *ptr;
+		struct extent_ptr_decoded p;
+
+		unsigned ptr_bit = 1;
 		bkey_for_each_ptr_decode(old.k, bch2_bkey_ptrs_c(old), p, entry) {
-			if (((1U << i) & m->data_opts.rewrite_ptrs) &&
+			if ((ptr_bit & m->data_opts.rewrite_ptrs) &&
 			    (ptr = bch2_extent_has_ptr(old, p, bkey_i_to_s(insert))) &&
 			    !ptr->cached)
-				rewrites_found |= 1U << i;
-			i++;
+				rewrites_found |= ptr_bit;
+			ptr_bit <<= 1;
 		}
 	}
 
-	prt_printf(&buf, "\nrewrite ptrs:   %u%u%u%u",
-		   (m->data_opts.rewrite_ptrs & (1 << 0)) != 0,
-		   (m->data_opts.rewrite_ptrs & (1 << 1)) != 0,
-		   (m->data_opts.rewrite_ptrs & (1 << 2)) != 0,
-		   (m->data_opts.rewrite_ptrs & (1 << 3)) != 0);
-
-	prt_printf(&buf, "\nrewrites found: %u%u%u%u",
-		   (rewrites_found & (1 << 0)) != 0,
-		   (rewrites_found & (1 << 1)) != 0,
-		   (rewrites_found & (1 << 2)) != 0,
-		   (rewrites_found & (1 << 3)) != 0);
+	prt_str(&buf, "rewrites found:\t");
+	bch2_prt_u64_base2(&buf, rewrites_found);
+	prt_newline(&buf);
+
+	bch2_data_update_opts_to_text(&buf, c, &m->op.opts, &m->data_opts);
 
 	prt_str(&buf, "\nold:    ");
 	bch2_bkey_val_to_text(&buf, c, old);
-- 
2.45.2


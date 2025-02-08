Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 320C0238D5E
	for <linux-bcachefs@vger.kernel.org>; Sat,  8 Feb 2025 11:01:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739012495; cv=none; b=aFHXrfX1Qe2J7sQeM5AtYKWAvqpHk3gUdmJMbcX8geOhpaA3AqywrbKTTht8yr1l+zy3iWD1iK9dPLeBmGOSHGVbHDem+CCWUGwHWwWvzODXoDWoRUgOe30L++xkBmGxRt5HodhIcRHam/fHtwPHbRB4KqNQimILtCaoNh4izHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739012495; c=relaxed/simple;
	bh=cCiUiCQRN5jDS8jDpsRGkBmAfWekhLXHRJx2VWIRft8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nR/TioiuvW63aYbO1buCaWdSOvNA3L/32Cs2wcUELDJsne1a+FqOPcXPEclOz3tmjzRFJGsgzZzxZYDBy04EMiOz5OHmC5QcCfUztANfssEBhbyvMB6GQKFqUSIhSVTGbVziMFr9Sboqup1Nj1A+RGLWd4lpNYO8Lg3SaVtF41s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=MGj2RA16; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MGj2RA16"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1739012493;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jKZ92YV6+Iir1AVW3615YB27Yy+mrQFHSFoKdeABlhw=;
	b=MGj2RA164LuNCIKn4QFKiZ3HzNuzSN/59qs4NDQ4Hv78jpZ4HyFiGNjQihIflRAuoMU/gf
	jSb8DSTh5kaglCz/eSQJXRWK1HkVhG6geHVEl79GhbpzMFW/jMC3m8ZYkULnAV4zVS2yhm
	QPvPQ7/I9ma7mgjI3PzbXn4JpY1MmAU=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-474-2rgfCTQqMKm_mVFJ7ZQq6A-1; Sat,
 08 Feb 2025 06:01:29 -0500
X-MC-Unique: 2rgfCTQqMKm_mVFJ7ZQq6A-1
X-Mimecast-MFC-AGG-ID: 2rgfCTQqMKm_mVFJ7ZQq6A
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7B18A19560A5;
	Sat,  8 Feb 2025 11:01:28 +0000 (UTC)
Received: from pasta.fast.eng.rdu2.dc.redhat.com (unknown [10.45.224.51])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 26D2230001AB;
	Sat,  8 Feb 2025 11:01:26 +0000 (UTC)
From: Andreas Gruenbacher <agruenba@redhat.com>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Andreas Gruenbacher <agruenba@redhat.com>,
	linux-bcachefs@vger.kernel.org
Subject: [PATCH v3 03/21] bcachefs: eytzinger self tests: loop cleanups
Date: Sat,  8 Feb 2025 12:01:00 +0100
Message-ID: <20250208110119.546961-4-agruenba@redhat.com>
In-Reply-To: <20250208110119.546961-1-agruenba@redhat.com>
References: <20250208110119.546961-1-agruenba@redhat.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

The iterator variable of eytzinger0_for_each() loops has been changed to
be locally scoped at some point, so remove variables defined outside the
loop that are now unused.  In addition and for clarity, use a different
variable inside those loops where an outside variable would be shadowed.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
---
 fs/bcachefs/util.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/fs/bcachefs/util.c b/fs/bcachefs/util.c
index e0a876cbaa6b..8fbb256f87af 100644
--- a/fs/bcachefs/util.c
+++ b/fs/bcachefs/util.c
@@ -473,10 +473,10 @@ void bch2_time_stats_to_text(struct printbuf *out, struct bch2_time_stats *stats
 		u64 last_q = 0;
 
 		prt_printf(out, "quantiles (%s):\t", u->name);
-		eytzinger0_for_each(i, NR_QUANTILES) {
-			bool is_last = eytzinger0_next(i, NR_QUANTILES) == -1;
+		eytzinger0_for_each(j, NR_QUANTILES) {
+			bool is_last = eytzinger0_next(j, NR_QUANTILES) == -1;
 
-			u64 q = max(quantiles->entries[i].m, last_q);
+			u64 q = max(quantiles->entries[j].m, last_q);
 			prt_printf(out, "%llu ", div64_u64(q, u->nsecs));
 			if (is_last)
 				prt_newline(out);
@@ -701,7 +701,7 @@ void memcpy_from_bio(void *dst, struct bio *src, struct bvec_iter src_iter)
 #if 0
 void eytzinger1_test(void)
 {
-	unsigned inorder, eytz, size;
+	unsigned inorder, size;
 
 	pr_info("1 based eytzinger test:");
 
@@ -734,7 +734,7 @@ void eytzinger1_test(void)
 void eytzinger0_test(void)
 {
 
-	unsigned inorder, eytz, size;
+	unsigned inorder, size;
 
 	pr_info("0 based eytzinger test:");
 
@@ -764,7 +764,7 @@ void eytzinger0_test(void)
 	}
 }
 
-static inline int cmp_u16(const void *_l, const void *_r, size_t size)
+static inline int cmp_u16(const void *_l, const void *_r)
 {
 	const u16 *l = _l, *r = _r;
 
@@ -787,8 +787,8 @@ static void eytzinger0_find_test_val(u16 *test_array, unsigned nr, u16 search)
 			c2 = test_array[i];
 
 	if (c1 != c2) {
-		eytzinger0_for_each(i, nr)
-			pr_info("[%3u] = %12u", i, test_array[i]);
+		eytzinger0_for_each(j, nr)
+			pr_info("[%3u] = %12u", j, test_array[j]);
 		pr_info("find_le(%2u) -> [%2zi] = %2i should be %2i",
 			i, r, c1, c2);
 	}
@@ -806,9 +806,9 @@ void eytzinger0_find_test(void)
 		eytzinger0_sort(test_array, nr, sizeof(test_array[0]), cmp_u16, NULL);
 
 		/* verify array is sorted correctly: */
-		eytzinger0_for_each(i, nr)
-			BUG_ON(i != eytzinger0_last(nr) &&
-			       test_array[i] > test_array[eytzinger0_next(i, nr)]);
+		eytzinger0_for_each(j, nr)
+			BUG_ON(j != eytzinger0_last(nr) &&
+			       test_array[j] > test_array[eytzinger0_next(j, nr)]);
 
 		for (i = 0; i < U16_MAX; i += 1 << 12)
 			eytzinger0_find_test_val(test_array, nr, i);
-- 
2.48.1


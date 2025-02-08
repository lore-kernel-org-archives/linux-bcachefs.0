Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B92DA23C393
	for <linux-bcachefs@vger.kernel.org>; Sat,  8 Feb 2025 11:02:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739012522; cv=none; b=iZYJy7hWY9KrlvrsP6DI9MO+Xji2Wf2X1Hhsw941GdL+CM+bQOp+OE8ePFHhxujmKTmnsdwlPkMKbu59nVXuJ0/4gBhqk7S7dtx0xf/rKJcgmW3TA6Im+YSbcJV32b0Es//8GO2IJ0FZ+T6hEJs1Tl/8D8pSNeGEyA02wpbDpyQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739012522; c=relaxed/simple;
	bh=EpaWs28Vp+MhRXZ7N6eRK+u9LtPKG7Cc27oTacCFoyk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rVrnyPdkT3bbj4o2/snFKPSPQ0nVU+qO7HO5WqlVr+Hiued0ZFbQgxfCn9A4nxOdY/vS1SPT/R60/olVtw+xjxKPs9rsBpEweirS0UG9kgcAEmkNSPDoUB0LoT/K6xdE2YpbdZz2KD2yf8FLvVQISAdcGnocD7EycBYb+h1QjLs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=GFw+KNfy; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GFw+KNfy"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1739012519;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jce0nO2XJUz7FkbfuiTqyS1B4yEqDT/5zR8pjHY6jcs=;
	b=GFw+KNfy3s/2IXAIuhp3tBFnFh4tqsgJ3K9r35yMV6/FZzHLKPglViSA7GpJ9IQXcwdX1h
	YZPTWT311un58+kMLszXwf2jdMEyTDepO53Q7s4r3e+M6OA+Pzz5wYeUAcB1EzhjyHmibx
	i322xT7kochT1SptmSzH1rrGYrKh+3k=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-643-910G2stTOQeBEWpp8ElNyA-1; Sat,
 08 Feb 2025 06:01:58 -0500
X-MC-Unique: 910G2stTOQeBEWpp8ElNyA-1
X-Mimecast-MFC-AGG-ID: 910G2stTOQeBEWpp8ElNyA
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 35B4E180056F;
	Sat,  8 Feb 2025 11:01:57 +0000 (UTC)
Received: from pasta.fast.eng.rdu2.dc.redhat.com (unknown [10.45.224.51])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id C386B30001AB;
	Sat,  8 Feb 2025 11:01:55 +0000 (UTC)
From: Andreas Gruenbacher <agruenba@redhat.com>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Andreas Gruenbacher <agruenba@redhat.com>,
	linux-bcachefs@vger.kernel.org
Subject: [PATCH v3 18/21] bcachefs: convert eytzinger sort to be 1-based (1)
Date: Sat,  8 Feb 2025 12:01:15 +0100
Message-ID: <20250208110119.546961-19-agruenba@redhat.com>
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

In this first step, convert the eytzinger sort functions to use 1-based
primitives.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
---
 fs/bcachefs/eytzinger.c | 48 +++++++++++++++++++++++++----------------
 1 file changed, 29 insertions(+), 19 deletions(-)

diff --git a/fs/bcachefs/eytzinger.c b/fs/bcachefs/eytzinger.c
index 2eaffe37b5e7..4fe02c93bfb3 100644
--- a/fs/bcachefs/eytzinger.c
+++ b/fs/bcachefs/eytzinger.c
@@ -148,28 +148,28 @@ static int do_cmp(const void *a, const void *b, cmp_r_func_t cmp, const void *pr
 	return cmp(a, b, priv);
 }
 
-static inline int eytzinger0_do_cmp(void *base, size_t n, size_t size,
+static inline int eytzinger1_do_cmp(void *base1, size_t n, size_t size,
 			 cmp_r_func_t cmp_func, const void *priv,
 			 size_t l, size_t r)
 {
-	return do_cmp(base + inorder_to_eytzinger0(l, n) * size,
-		      base + inorder_to_eytzinger0(r, n) * size,
+	return do_cmp(base1 + inorder_to_eytzinger1(l, n) * size,
+		      base1 + inorder_to_eytzinger1(r, n) * size,
 		      cmp_func, priv);
 }
 
-static inline void eytzinger0_do_swap(void *base, size_t n, size_t size,
+static inline void eytzinger1_do_swap(void *base1, size_t n, size_t size,
 			   swap_r_func_t swap_func, const void *priv,
 			   size_t l, size_t r)
 {
-	do_swap(base + inorder_to_eytzinger0(l, n) * size,
-		base + inorder_to_eytzinger0(r, n) * size,
+	do_swap(base1 + inorder_to_eytzinger1(l, n) * size,
+		base1 + inorder_to_eytzinger1(r, n) * size,
 		size, swap_func, priv);
 }
 
-void eytzinger0_sort_r(void *base, size_t n, size_t size,
-		       cmp_r_func_t cmp_func,
-		       swap_r_func_t swap_func,
-		       const void *priv)
+static void eytzinger1_sort_r(void *base1, size_t n, size_t size,
+			      cmp_r_func_t cmp_func,
+			      swap_r_func_t swap_func,
+			      const void *priv)
 {
 	int i, j, k;
 
@@ -178,9 +178,9 @@ void eytzinger0_sort_r(void *base, size_t n, size_t size,
 		swap_func = NULL;
 
 	if (!swap_func) {
-		if (is_aligned(base, size, 8))
+		if (is_aligned(base1, size, 8))
 			swap_func = SWAP_WORDS_64;
-		else if (is_aligned(base, size, 4))
+		else if (is_aligned(base1, size, 4))
 			swap_func = SWAP_WORDS_32;
 		else
 			swap_func = SWAP_BYTES;
@@ -190,47 +190,57 @@ void eytzinger0_sort_r(void *base, size_t n, size_t size,
 	for (i = n / 2 - 1; i >= 0; --i) {
 		/* Find the sift-down path all the way to the leaves. */
 		for (j = i; k = j * 2 + 1, k + 1 < n;)
-			j = eytzinger0_do_cmp(base, n, size, cmp_func, priv, k, k + 1) > 0 ? k : k + 1;
+			j = eytzinger1_do_cmp(base1, n, size, cmp_func, priv, k + 1, k + 2) > 0 ? k : k + 1;
 
 		/* Special case for the last leaf with no sibling. */
 		if (j * 2 + 2 == n)
 			j = j * 2 + 1;
 
 		/* Backtrack to the correct location. */
-		while (j != i && eytzinger0_do_cmp(base, n, size, cmp_func, priv, i, j) >= 0)
+		while (j != i && eytzinger1_do_cmp(base1, n, size, cmp_func, priv, i + 1, j + 1) >= 0)
 			j = (j - 1) / 2;
 
 		/* Shift the element into its correct place. */
 		for (k = j; j != i;) {
 			j = (j - 1) / 2;
-			eytzinger0_do_swap(base, n, size, swap_func, priv, j, k);
+			eytzinger1_do_swap(base1, n, size, swap_func, priv, j + 1, k + 1);
 		}
 	}
 
 	/* sort */
 	for (i = n - 1; i > 0; --i) {
-		eytzinger0_do_swap(base, n, size, swap_func, priv, 0, i);
+		eytzinger1_do_swap(base1, n, size, swap_func, priv, 1, i + 1);
 
 		/* Find the sift-down path all the way to the leaves. */
 		for (j = 0; k = j * 2 + 1, k + 1 < i;)
-			j = eytzinger0_do_cmp(base, n, size, cmp_func, priv, k, k + 1) > 0 ? k : k + 1;
+			j = eytzinger1_do_cmp(base1, n, size, cmp_func, priv, k + 1, k + 2) > 0 ? k : k + 1;
 
 		/* Special case for the last leaf with no sibling. */
 		if (j * 2 + 2 == i)
 			j = j * 2 + 1;
 
 		/* Backtrack to the correct location. */
-		while (j && eytzinger0_do_cmp(base, n, size, cmp_func, priv, 0, j) >= 0)
+		while (j && eytzinger1_do_cmp(base1, n, size, cmp_func, priv, 1, j + 1) >= 0)
 			j = (j - 1) / 2;
 
 		/* Shift the element into its correct place. */
 		for (k = j; j;) {
 			j = (j - 1) / 2;
-			eytzinger0_do_swap(base, n, size, swap_func, priv, j, k);
+			eytzinger1_do_swap(base1, n, size, swap_func, priv, j + 1, k + 1);
 		}
 	}
 }
 
+void eytzinger0_sort_r(void *base, size_t n, size_t size,
+		       cmp_r_func_t cmp_func,
+		       swap_r_func_t swap_func,
+		       const void *priv)
+{
+	void *base1 = base - size;
+
+	return eytzinger1_sort_r(base1, n, size, cmp_func, swap_func, priv);
+}
+
 void eytzinger0_sort(void *base, size_t n, size_t size,
 		     cmp_func_t cmp_func,
 		     swap_func_t swap_func)
-- 
2.48.1


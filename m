Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA50223CF02
	for <linux-bcachefs@vger.kernel.org>; Sat,  8 Feb 2025 11:02:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739012524; cv=none; b=Pn9Z4VfcsO3ZFx9L7PliJTJikhDJh98aQI1l4qvhtdcqZRppfW4OEV/VlchnqHqt83vCOuJtNiOAKWo87Nj+V/2SO6+Yv0S2JURfirjz3aYjVzwVprr9f6VG6tQ2XIW1HFDUCz4TJCSkQF4zoey6JRHCr5ceobTyKQQ9U9ZUGq0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739012524; c=relaxed/simple;
	bh=iH3V1i39adBk8ZujrdwADX35m0HuYuxnB5CelMS7m4Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rtjI9bnmrj1t+vbHLqCxchXIi+fIimPCwIEEZqGCtzTD+DHmJxwem0JKdBrmKD///aLawPU4ILUnk8I1k5dJyXFKFD7LW4eHUGcd7SPNpzkNHCI8ckb5esCm7xtDC78nNp64+UzevE+gOk+mF9JXtMGFrbXjlfQl+3zbk6wR+pE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FkywFYPJ; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FkywFYPJ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1739012521;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=v1fyKD928ep1+Rnr6bOzqnxTrlQt9Iyc9A3mi5URZ1E=;
	b=FkywFYPJRZBWrbBzjkNhV5ioZ67IAZz5h1B1aFIuNlz/W7ZZ1dtxrtPYD1FlL4UfOCoGk3
	Mmpz0mA6jbmOnxZR3nEvalbACsm01OaitnvlLuRGXkU4+vw0BRyIHoWyZ7Ka+b4a4u/r7D
	alLrEZIm90cm/lHLhs2NUrC0Y5HGj1A=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-688-W144UXC4NPWSlYK3xrIaDA-1; Sat,
 08 Feb 2025 06:02:00 -0500
X-MC-Unique: W144UXC4NPWSlYK3xrIaDA-1
X-Mimecast-MFC-AGG-ID: W144UXC4NPWSlYK3xrIaDA
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 10C6018004A7;
	Sat,  8 Feb 2025 11:01:59 +0000 (UTC)
Received: from pasta.fast.eng.rdu2.dc.redhat.com (unknown [10.45.224.51])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id B0D9D30001AB;
	Sat,  8 Feb 2025 11:01:57 +0000 (UTC)
From: Andreas Gruenbacher <agruenba@redhat.com>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Andreas Gruenbacher <agruenba@redhat.com>,
	linux-bcachefs@vger.kernel.org
Subject: [PATCH v3 19/21] bcachefs: convert eytzinger sort to be 1-based (2)
Date: Sat,  8 Feb 2025 12:01:16 +0100
Message-ID: <20250208110119.546961-20-agruenba@redhat.com>
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

In this second step, transform the eytzinger indexes i, j, and k in
eytzinger1_sort_r() from 0-based to 1-based.  This step looks a bit
messy, but the resulting code is slightly better.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
---
 fs/bcachefs/eytzinger.c | 42 ++++++++++++++++++++---------------------
 1 file changed, 21 insertions(+), 21 deletions(-)

diff --git a/fs/bcachefs/eytzinger.c b/fs/bcachefs/eytzinger.c
index 4fe02c93bfb3..0e742555cb0a 100644
--- a/fs/bcachefs/eytzinger.c
+++ b/fs/bcachefs/eytzinger.c
@@ -171,7 +171,7 @@ static void eytzinger1_sort_r(void *base1, size_t n, size_t size,
 			      swap_r_func_t swap_func,
 			      const void *priv)
 {
-	int i, j, k;
+	unsigned i, j, k;
 
 	/* called from 'sort' without swap function, let's pick the default */
 	if (swap_func == SWAP_WRAPPER && !((struct wrapper *)priv)->swap_func)
@@ -187,46 +187,46 @@ static void eytzinger1_sort_r(void *base1, size_t n, size_t size,
 	}
 
 	/* heapify */
-	for (i = n / 2 - 1; i >= 0; --i) {
+	for (i = n / 2; i >= 1; --i) {
 		/* Find the sift-down path all the way to the leaves. */
-		for (j = i; k = j * 2 + 1, k + 1 < n;)
-			j = eytzinger1_do_cmp(base1, n, size, cmp_func, priv, k + 1, k + 2) > 0 ? k : k + 1;
+		for (j = i; k = j * 2, k < n;)
+			j = eytzinger1_do_cmp(base1, n, size, cmp_func, priv, k, k + 1) > 0 ? k : k + 1;
 
 		/* Special case for the last leaf with no sibling. */
-		if (j * 2 + 2 == n)
-			j = j * 2 + 1;
+		if (j * 2 == n)
+			j *= 2;
 
 		/* Backtrack to the correct location. */
-		while (j != i && eytzinger1_do_cmp(base1, n, size, cmp_func, priv, i + 1, j + 1) >= 0)
-			j = (j - 1) / 2;
+		while (j != i && eytzinger1_do_cmp(base1, n, size, cmp_func, priv, i, j) >= 0)
+			j /= 2;
 
 		/* Shift the element into its correct place. */
 		for (k = j; j != i;) {
-			j = (j - 1) / 2;
-			eytzinger1_do_swap(base1, n, size, swap_func, priv, j + 1, k + 1);
+			j /= 2;
+			eytzinger1_do_swap(base1, n, size, swap_func, priv, j, k);
 		}
 	}
 
 	/* sort */
-	for (i = n - 1; i > 0; --i) {
-		eytzinger1_do_swap(base1, n, size, swap_func, priv, 1, i + 1);
+	for (i = n; i > 1; --i) {
+		eytzinger1_do_swap(base1, n, size, swap_func, priv, 1, i);
 
 		/* Find the sift-down path all the way to the leaves. */
-		for (j = 0; k = j * 2 + 1, k + 1 < i;)
-			j = eytzinger1_do_cmp(base1, n, size, cmp_func, priv, k + 1, k + 2) > 0 ? k : k + 1;
+		for (j = 1; k = j * 2, k + 1 < i;)
+			j = eytzinger1_do_cmp(base1, n, size, cmp_func, priv, k, k + 1) > 0 ? k : k + 1;
 
 		/* Special case for the last leaf with no sibling. */
-		if (j * 2 + 2 == i)
-			j = j * 2 + 1;
+		if (j * 2 + 1 == i)
+			j *= 2;
 
 		/* Backtrack to the correct location. */
-		while (j && eytzinger1_do_cmp(base1, n, size, cmp_func, priv, 1, j + 1) >= 0)
-			j = (j - 1) / 2;
+		while (j >= 1 && eytzinger1_do_cmp(base1, n, size, cmp_func, priv, 1, j) >= 0)
+			j /= 2;
 
 		/* Shift the element into its correct place. */
-		for (k = j; j;) {
-			j = (j - 1) / 2;
-			eytzinger1_do_swap(base1, n, size, swap_func, priv, j + 1, k + 1);
+		for (k = j; j > 1;) {
+			j /= 2;
+			eytzinger1_do_swap(base1, n, size, swap_func, priv, j, k);
 		}
 	}
 }
-- 
2.48.1


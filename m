Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B7FD1DE3C7
	for <linux-bcachefs@vger.kernel.org>; Tue, 28 Jan 2025 16:39:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738082397; cv=none; b=KY/S6KNB12MYdLswZpLekWRaaySmrhkWUfzq7MU2wvldDH8WhBMuilcBAoowwSkWNd8mCAIsWrvHF/tMsMmycHLAYGOqmOSQoyUCKZTbENxB54KyUiv6VmCa3lvlRBcPwY7mNvUxMzOGc4IuzLKEu6njE+r9/537IxHWY+p3Q1I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738082397; c=relaxed/simple;
	bh=8tQ6XBEMYbx9V0iHjreFT9NgZ5mT2GIi/oiDgPetvHw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AJw9mqhA58mxi11QWZvZAXFFzyp2+I0HaYlatksiDl3XoRtmQPLbfwF0GC20uUgzdChtdUtcpbzbHt5mdF4ePyvZz7+HQhzSrtHZZQdSGBLuXRTL0sKQxCIWVBn7dFotW3Jdokmtmt+qpFwIYJq9SgTho/PERJ1SSqKjanN3Nk8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BT2xbWR5; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BT2xbWR5"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1738082395;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sNmPQEOvHYWrUX4j7maHpPPS+nivyRuwSBqiMy5hzYE=;
	b=BT2xbWR58XAIPEIuKz7BwU9vE8WogeHkytH1aBqKCirXVo0h4aSCkC0LTi0cKogVqrRMjJ
	Cq3dlWEw+GTUCmfA0TPZFofw/5Eu/Nx4ofZKDs2rW299mVW1r2RRyrB7rE/6DqE9U2bukr
	fJwpGr6mjfKXexj8ipOSOq8ZlV5jBXE=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-610-jGpuxaPmPfGE9fbCFRERiA-1; Tue,
 28 Jan 2025 11:39:52 -0500
X-MC-Unique: jGpuxaPmPfGE9fbCFRERiA-1
X-Mimecast-MFC-AGG-ID: jGpuxaPmPfGE9fbCFRERiA
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1BCB819560B4;
	Tue, 28 Jan 2025 16:39:51 +0000 (UTC)
Received: from pasta.fast.eng.rdu2.dc.redhat.com (unknown [10.45.225.106])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 455DF180035E;
	Tue, 28 Jan 2025 16:39:49 +0000 (UTC)
From: Andreas Gruenbacher <agruenba@redhat.com>
To: Kent Overstreet <kent.overstreet@linux.dev>,
	Shuah Khan <shuah@kernel.org>
Cc: Andreas Gruenbacher <agruenba@redhat.com>,
	linux-bcachefs@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Subject: [PATCH 20/21] bcachefs: convert eytzinger sort to be 1-based (2)
Date: Tue, 28 Jan 2025 17:38:57 +0100
Message-ID: <20250128163859.1883260-21-agruenba@redhat.com>
In-Reply-To: <20250128163859.1883260-1-agruenba@redhat.com>
References: <20250128163859.1883260-1-agruenba@redhat.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

In this second step, transform the eytzinger indexes i, j, and k in
eytzinger1_sort_r() from 0-based to 1-based.  This step looks a bit
messy, but the resulting code is slightly better.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
---
 fs/bcachefs/eytzinger.c | 42 ++++++++++++++++++++---------------------
 1 file changed, 21 insertions(+), 21 deletions(-)

diff --git a/fs/bcachefs/eytzinger.c b/fs/bcachefs/eytzinger.c
index 93a5819a6878..00cc5f0826e3 100644
--- a/fs/bcachefs/eytzinger.c
+++ b/fs/bcachefs/eytzinger.c
@@ -170,7 +170,7 @@ static void eytzinger1_sort_r(void *base1, size_t n, size_t size,
 			      swap_r_func_t swap_func,
 			      const void *priv)
 {
-	int i, j, k;
+	unsigned i, j, k;
 
 	/* called from 'sort' without swap function, let's pick the default */
 	if (swap_func == SWAP_WRAPPER && !((struct wrapper *)priv)->swap_func)
@@ -186,46 +186,46 @@ static void eytzinger1_sort_r(void *base1, size_t n, size_t size,
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


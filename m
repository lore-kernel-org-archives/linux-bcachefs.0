Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCCC823AE6A
	for <linux-bcachefs@vger.kernel.org>; Sat,  8 Feb 2025 11:01:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739012508; cv=none; b=OstzJU1nd/w6P6a2MNHdq8O8v8s3WXpy7MAjIUYqbQPOcjVg+sX/aGb4wAW1tBFqW56H4qtP53xxyJ0ZpKUOsQS9ngmtNEDY3do60BJFQppNsZKyNitDm4P+vSCEaeZH2eM86bUTzIMUSh8cnMwG6Pf8rlCuq0wlzowdwojpeKc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739012508; c=relaxed/simple;
	bh=CBhAcZiXiYYur08cs28ARkqoXh4vwR/iOIjiIeWYBbM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iIoZL2bT26oJJiymrYvTxQXl9y1W8nqCHN99PqjvZzvlaRV+jpiq9KSQ112Y53TeWJ1EjQPA6x2BO5OfzRzFC9gBxAHPYuyHeN/vYeVL7JVb0JFy4RGRH3XbAsSzc+rB+u5+R59cr9y+czMZ0XcWsanVg/CkSN2kztaT95RdAdU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=O8XjccK3; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="O8XjccK3"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1739012505;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=aJQ1v5G+RH2YlXS6fwoDNu84ge/YjtKA14dF7jDANeA=;
	b=O8XjccK3NBkUPamEKQKC9PM1rapDauvu+GLCmP35awsfDWL8ROEuAdRZn0PBVpugGWVXr0
	//m0jpVebk37D6aK2LvS4xSJewEfIGe/SOmlDrvrjoTQ2vbKNX+SkAhLjqiAhtTj6hve13
	s+P+PmOEb9+N177adicdA3qulycXJ9U=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-323-WfqaN0DHMPCZVlvEfqta5Q-1; Sat,
 08 Feb 2025 06:01:42 -0500
X-MC-Unique: WfqaN0DHMPCZVlvEfqta5Q-1
X-Mimecast-MFC-AGG-ID: WfqaN0DHMPCZVlvEfqta5Q
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8A8671956096;
	Sat,  8 Feb 2025 11:01:40 +0000 (UTC)
Received: from pasta.fast.eng.rdu2.dc.redhat.com (unknown [10.45.224.51])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 3978830001AB;
	Sat,  8 Feb 2025 11:01:38 +0000 (UTC)
From: Andreas Gruenbacher <agruenba@redhat.com>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Andreas Gruenbacher <agruenba@redhat.com>,
	linux-bcachefs@vger.kernel.org
Subject: [PATCH v3 09/21] bcachefs: improve eytzinger0_find_le self test
Date: Sat,  8 Feb 2025 12:01:06 +0100
Message-ID: <20250208110119.546961-10-agruenba@redhat.com>
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

Rename eytzinger0_find_test_val() to eytzinger0_find_test_le() and add a
new eytzinger0_find_test_val() wrapper that calls it.

We have already established that the array is sorted in eytzinger order,
so we can use the eytzinger iterator functions and check the boundary
conditions to verify the result of eytzinger0_find_le().

Only scan the entire array if we get an incorrect result.  When we need
to scan, use eytzinger0_for_each_prev() so that we'll stop at the
highest matching element in the array in case there are duplicates;
going through the array linearly wouldn't give us that.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
---
 fs/bcachefs/util.c | 41 ++++++++++++++++++++++++++++++-----------
 1 file changed, 30 insertions(+), 11 deletions(-)

diff --git a/fs/bcachefs/util.c b/fs/bcachefs/util.c
index 5e28a214c005..d25b2e800307 100644
--- a/fs/bcachefs/util.c
+++ b/fs/bcachefs/util.c
@@ -782,29 +782,48 @@ static inline int cmp_u16(const void *_l, const void *_r)
 	return (*l > *r) - (*r > *l);
 }
 
-static void eytzinger0_find_test_val(u16 *test_array, unsigned nr, u16 search)
+static void eytzinger0_find_test_le(u16 *test_array, unsigned nr, u16 search)
 {
-	int i, c1 = -1, c2 = -1;
-	ssize_t r;
+	int r, s;
+	bool bad;
 
 	r = eytzinger0_find_le(test_array, nr,
 			       sizeof(test_array[0]),
 			       cmp_u16, &search);
-	if (r >= 0)
-		c1 = test_array[r];
+	if (r >= 0) {
+		if (test_array[r] > search) {
+			bad = true;
+		} else {
+			s = eytzinger0_next(r, nr);
+			bad = s >= 0 && test_array[s] <= search;
+		}
+	} else {
+		s = eytzinger0_last(nr);
+		bad = s >= 0 && test_array[s] <= search;
+	}
 
-	for (i = 0; i < nr; i++)
-		if (test_array[i] <= search && test_array[i] > c2)
-			c2 = test_array[i];
+	if (bad) {
+		s = -1;
+		eytzinger0_for_each_prev(j, nr) {
+			if (test_array[j] <= search) {
+				s = j;
+				break;
+			}
+		}
 
-	if (c1 != c2) {
 		eytzinger0_for_each(j, nr)
 			pr_info("[%3u] = %12u\n", j, test_array[j]);
-		pr_info("find_le(%2u) -> [%2zi] = %2i should be %2i\n",
-			i, r, c1, c2);
+		pr_info("find_le(%12u) = %3i should be %3i\n",
+			search, r, s);
+		BUG();
 	}
 }
 
+static void eytzinger0_find_test_val(u16 *test_array, unsigned nr, u16 search)
+{
+	eytzinger0_find_test_le(test_array, nr, search);
+}
+
 void eytzinger0_find_test(void)
 {
 	unsigned i, nr, allocated = 1 << 12;
-- 
2.48.1


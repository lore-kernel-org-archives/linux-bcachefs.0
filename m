Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E140C1DE3AE
	for <linux-bcachefs@vger.kernel.org>; Tue, 28 Jan 2025 16:39:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738082377; cv=none; b=FuwHxuV9OBLE1M4A0tcF+QKidYp8zOl7STWgnuNAPQZ+q8HUi7aLTGF6vhXtoLrTyyVV2CHurUt1l1IbZ3LpzwrfW4wJxdLPh6fk6fFgEFKrkxjCRTKhtXB/B9+6NydvEMdAAzsavXbiZKRrM0xrzbbXj4h4iYgBzRmhFNLh1xE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738082377; c=relaxed/simple;
	bh=xYYKSzeUNhktelKMGtWaDjWVNkHylHHNM7lBAJ0mpXU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iQnZv7KONip5PuV3pANmvZMmNAgJAvnJRKhBZ0dF9DLy4TO9kh5an8XOhn6piigT9Gu0lPXKSO69NTaj7Gf7gSF8Ln1bWjpdbX+GV2N1j+XFReall5rFWl8/xOHOtA3q9PsyL8hxDrDd3Nf0PZpaNjIoZiEApbcA31JagJKfRsI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=M2vajaZ9; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="M2vajaZ9"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1738082375;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jSTjRU8OGvFCT9OatwrBdkc0jw3p9R5xmeWWLyB1Jg8=;
	b=M2vajaZ9VE4JOcsx5PjG1YKQ2Qcmhu668CLKtiNcLaiWy5djkykuYU7/0ggBKqtNMVGije
	wCDYXoKZwSNCRVnNR4jjLcaHR1JsR73X/mM1lSiSiHdbjzo6MqKJPuaZ2tdVvMC2wCqW+9
	Y6Uc7WWa/uxxkPfJND+QP9NZiVpRHEE=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-692-0Me6OjgyPEOTm2bDVyCZGg-1; Tue,
 28 Jan 2025 11:39:31 -0500
X-MC-Unique: 0Me6OjgyPEOTm2bDVyCZGg-1
X-Mimecast-MFC-AGG-ID: 0Me6OjgyPEOTm2bDVyCZGg
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A2EE11800373;
	Tue, 28 Jan 2025 16:39:29 +0000 (UTC)
Received: from pasta.fast.eng.rdu2.dc.redhat.com (unknown [10.45.225.106])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id CD98D180035E;
	Tue, 28 Jan 2025 16:39:27 +0000 (UTC)
From: Andreas Gruenbacher <agruenba@redhat.com>
To: Kent Overstreet <kent.overstreet@linux.dev>,
	Shuah Khan <shuah@kernel.org>
Cc: Andreas Gruenbacher <agruenba@redhat.com>,
	linux-bcachefs@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Subject: [PATCH 11/21] bcachefs: improve the eytzinger0_find_le tests
Date: Tue, 28 Jan 2025 17:38:48 +0100
Message-ID: <20250128163859.1883260-12-agruenba@redhat.com>
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
index 3fe9a3b8c696..c772629783f3 100644
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


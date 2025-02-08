Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2994239088
	for <linux-bcachefs@vger.kernel.org>; Sat,  8 Feb 2025 11:01:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739012497; cv=none; b=ju3HxHfxteHZKBAXZochyUqmx+u111Da78Q7DVt+6y/Io58JKe3sCT6SkW8RwypvpbGCyX9WkXVCuiYksfNUOS4HJpxlQdpigGQ05jzvFsrdk3hzYiAPPDBHtS2vhS3VKa8QVsDuSXNVZU1K/OMHz9IUFCcfUxXxH5MojLGFmdk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739012497; c=relaxed/simple;
	bh=r11MR11tGPpxFu+ydYN9Zq80jC4QKu0VAbNDWT9B2qA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JAHvl3aOicF6MthHsiiYlhltyAGBy0USXTbuqFefGzU32d0mWdkYob4SEzGPD+zM2tLRKGaLi3I3KgC4ZQnwhDETAYTRQ5GDdPcI+ADZsSf9zbtyHJc61UfKhH8AmaX/xAfT/osdIpKh7L9oiS4L8sApbvn0dizMJQQnh0E3orw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fGn9z/f2; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fGn9z/f2"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1739012494;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=msXhtK6wBE+E5Y3jFRuRVg2BcvuCp7LsbFarLZak1gI=;
	b=fGn9z/f27sYsLmHlO2qLlK0O7pETR3jVEiYhoOL2cykY3iXfrSl8cDmWO/DzQmFD4a4YaD
	U91jspv3UF2lXUVe9DirL/+iKER26jVD/OGmAdL6pnxSffmnjzmwPMBayw69tQ0Pa9OrOv
	WwKlCU7nGOBjPrCj99nzSqGytf97rmk=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-264-96U3KHFXNKykb_V2M9EvFw-1; Sat,
 08 Feb 2025 06:01:31 -0500
X-MC-Unique: 96U3KHFXNKykb_V2M9EvFw-1
X-Mimecast-MFC-AGG-ID: 96U3KHFXNKykb_V2M9EvFw
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 565B01956086;
	Sat,  8 Feb 2025 11:01:30 +0000 (UTC)
Received: from pasta.fast.eng.rdu2.dc.redhat.com (unknown [10.45.224.51])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id F0FE330001AB;
	Sat,  8 Feb 2025 11:01:28 +0000 (UTC)
From: Andreas Gruenbacher <agruenba@redhat.com>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Andreas Gruenbacher <agruenba@redhat.com>,
	linux-bcachefs@vger.kernel.org
Subject: [PATCH v3 04/21] bcachefs: eytzinger self tests: missing newline termination
Date: Sat,  8 Feb 2025 12:01:01 +0100
Message-ID: <20250208110119.546961-5-agruenba@redhat.com>
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

pr_info() format strings need to be newline terminated.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
---
 fs/bcachefs/util.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/fs/bcachefs/util.c b/fs/bcachefs/util.c
index 8fbb256f87af..e2bcfb38bbae 100644
--- a/fs/bcachefs/util.c
+++ b/fs/bcachefs/util.c
@@ -703,7 +703,7 @@ void eytzinger1_test(void)
 {
 	unsigned inorder, size;
 
-	pr_info("1 based eytzinger test:");
+	pr_info("1 based eytzinger test:\n");
 
 	for (size = 2;
 	     size < 65536;
@@ -711,7 +711,7 @@ void eytzinger1_test(void)
 		unsigned extra = eytzinger1_extra(size);
 
 		if (!(size % 4096))
-			pr_info("tree size %u", size);
+			pr_info("tree size %u\n", size);
 
 		BUG_ON(eytzinger1_prev(0, size) != eytzinger1_last(size));
 		BUG_ON(eytzinger1_next(0, size) != eytzinger1_first(size));
@@ -736,7 +736,7 @@ void eytzinger0_test(void)
 
 	unsigned inorder, size;
 
-	pr_info("0 based eytzinger test:");
+	pr_info("0 based eytzinger test:\n");
 
 	for (size = 1;
 	     size < 65536;
@@ -744,7 +744,7 @@ void eytzinger0_test(void)
 		unsigned extra = eytzinger0_extra(size);
 
 		if (!(size % 4096))
-			pr_info("tree size %u", size);
+			pr_info("tree size %u\n", size);
 
 		BUG_ON(eytzinger0_prev(-1, size) != eytzinger0_last(size));
 		BUG_ON(eytzinger0_next(-1, size) != eytzinger0_first(size));
@@ -788,8 +788,8 @@ static void eytzinger0_find_test_val(u16 *test_array, unsigned nr, u16 search)
 
 	if (c1 != c2) {
 		eytzinger0_for_each(j, nr)
-			pr_info("[%3u] = %12u", j, test_array[j]);
-		pr_info("find_le(%2u) -> [%2zi] = %2i should be %2i",
+			pr_info("[%3u] = %12u\n", j, test_array[j]);
+		pr_info("find_le(%2u) -> [%2zi] = %2i should be %2i\n",
 			i, r, c1, c2);
 	}
 }
@@ -800,7 +800,7 @@ void eytzinger0_find_test(void)
 	u16 *test_array = kmalloc_array(allocated, sizeof(test_array[0]), GFP_KERNEL);
 
 	for (nr = 1; nr < allocated; nr++) {
-		pr_info("testing %u elems", nr);
+		pr_info("testing %u elems\n", nr);
 
 		get_random_bytes(test_array, nr * sizeof(test_array[0]));
 		eytzinger0_sort(test_array, nr, sizeof(test_array[0]), cmp_u16, NULL);
-- 
2.48.1


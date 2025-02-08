Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE55B23C38F
	for <linux-bcachefs@vger.kernel.org>; Sat,  8 Feb 2025 11:01:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739012520; cv=none; b=QXzmrnXwsU8bJ/7IBjzKYa2+2GfJololCCusMTU8bb8cCII6Y4/fiHa5AhZ/CySU/zkMyhBFrJA9Bn7gsHG//ycFxLPOXujsC6XPxyiF48xSYEdkxIWV7GrhjRD1xw1dIgwgB6QVAIKh7ZMacvyolbpfzC0fVTu0qoYGPYEG35E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739012520; c=relaxed/simple;
	bh=i0Q0dqL9qcICAj4eVtPMjTSghekJF6dMOQYuZebYztQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rvJT9lp7NRhKEnUJlFluPyGWA3UArnPEUKZfuAdJxRF50qDTDhr/wTbmLbrZY0IAq5FDkpDzn6VEh57j80LlC/+cuzCofeQpbXeMQXhhxiL20IXemOPsUpN1HS0EozkIwDUwlJ2sbMzy0Xlas4mxdbN1jtvhCuhzia3Jpcyzk/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Y/JDorHF; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Y/JDorHF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1739012517;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uTW0/NJ1EXNk2j7YsqT77Ap3F3jmz7mV3/xFrcNoTKM=;
	b=Y/JDorHF8qHxatEasetAkDm21tTMsZGi2vzx3ZbzTAGfyDXJ1aZGHip4MKqMU/J9Kulxza
	VeaV1iJRxTBPrkoZER490ONWngXqjRCBjZCoVBvFx8ZGExIDMi59ZjMexSHs0jfRSaj/w+
	h+Gc4YFeKRU7uVdJZdgE7LOgvnt/zWU=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-573-04ul6XFFNDOe7HXv81GBiA-1; Sat,
 08 Feb 2025 06:01:54 -0500
X-MC-Unique: 04ul6XFFNDOe7HXv81GBiA-1
X-Mimecast-MFC-AGG-ID: 04ul6XFFNDOe7HXv81GBiA
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 93DE5195608C;
	Sat,  8 Feb 2025 11:01:53 +0000 (UTC)
Received: from pasta.fast.eng.rdu2.dc.redhat.com (unknown [10.45.224.51])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 24A3530001AB;
	Sat,  8 Feb 2025 11:01:51 +0000 (UTC)
From: Andreas Gruenbacher <agruenba@redhat.com>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Andreas Gruenbacher <agruenba@redhat.com>,
	linux-bcachefs@vger.kernel.org
Subject: [PATCH v3 16/21] bcachefs: Add eytzinger0_find self test
Date: Sat,  8 Feb 2025 12:01:13 +0100
Message-ID: <20250208110119.546961-17-agruenba@redhat.com>
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

Function eytzinger0_find() isn't currently covered, so add a self test.

We can rely on eytzinger0_find_le() here because it is being
tested independently.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
---
 fs/bcachefs/util.c | 29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/fs/bcachefs/util.c b/fs/bcachefs/util.c
index c2e1a1fe6f73..a563d75ba72b 100644
--- a/fs/bcachefs/util.c
+++ b/fs/bcachefs/util.c
@@ -893,11 +893,40 @@ static void eytzinger0_find_test_ge(u16 *test_array, unsigned nr, u16 search)
 	}
 }
 
+static void eytzinger0_find_test_eq(u16 *test_array, unsigned nr, u16 search)
+{
+	unsigned r;
+	int s;
+	bool bad;
+
+	r = eytzinger0_find(test_array, nr,
+			    sizeof(test_array[0]),
+			    cmp_u16, &search);
+
+	if (r < nr) {
+		bad = test_array[r] != search;
+	} else {
+		s = eytzinger0_find_le(test_array, nr,
+				       sizeof(test_array[0]),
+				       cmp_u16, &search);
+		bad = s >= 0 && test_array[s] == search;
+	}
+
+	if (bad) {
+		eytzinger0_for_each(j, nr)
+			pr_info("[%3u] = %12u\n", j, test_array[j]);
+		pr_info("find(%12u) = %3i is incorrect\n",
+			search, r);
+		BUG();
+	}
+}
+
 static void eytzinger0_find_test_val(u16 *test_array, unsigned nr, u16 search)
 {
 	eytzinger0_find_test_le(test_array, nr, search);
 	eytzinger0_find_test_gt(test_array, nr, search);
 	eytzinger0_find_test_ge(test_array, nr, search);
+	eytzinger0_find_test_eq(test_array, nr, search);
 }
 
 void eytzinger0_find_test(void)
-- 
2.48.1


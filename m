Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F7801DE3B3
	for <linux-bcachefs@vger.kernel.org>; Tue, 28 Jan 2025 16:39:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738082385; cv=none; b=kWfTmv1oynzAUPPMPTdGMVMJHJH4ycwbjrFwmdEpc9CIbD0QkPLzse0iC7+bxTgiGKHvo4Wu/QDbRcuZoMyAbm7dRTzOtOwygujY62cr0Yg6ckeqpabzUKDm8uyNn7bTGx3Kcq383QAEQEtRANFCmxzjMbdMYr98A7HaJYPss4E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738082385; c=relaxed/simple;
	bh=gD2MOqZe8ovnHyS3V8WoY1tpKSobqoC+vaRjGdjO01A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sDJ9sPJMVRiAeGzqC80E6jOy/bQkk0AV5LzuQnqA9FA5E4OkJQy7BayWckeAxu2243mD3kCFlxCYKat+MnbxczPNDvDLBMBW5JYtWZYTUDkKeqXZShCpuYD6MpgBrww88vSlPRxPqwDdfIx/56yGDsmeAsLsQPFJIQyT3Jps1h4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ArGBl71r; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ArGBl71r"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1738082382;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1zVELwI01VWAwpCtMhLCBjEE0cAM4DjBjLNjy0PGD28=;
	b=ArGBl71rZmZUlwmmbOz+2hLx3rOU23q4iER0ooCob5qr/It7eQ8RpkF1/DdyQ6BQBP41pj
	ZNUMAZhpyhhlOv7Ha30b1uRgYHxXt/NdWIEQOH6JIKZm8BQF9ib2lKM3NGOaNldEAoPr/x
	St883VexAJykYy7WMQDPL2lb3uHes4I=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-303-H4hacxvaPoGPcm4bJc962A-1; Tue,
 28 Jan 2025 11:39:40 -0500
X-MC-Unique: H4hacxvaPoGPcm4bJc962A-1
X-Mimecast-MFC-AGG-ID: H4hacxvaPoGPcm4bJc962A
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 60A7A19560B7;
	Tue, 28 Jan 2025 16:39:39 +0000 (UTC)
Received: from pasta.fast.eng.rdu2.dc.redhat.com (unknown [10.45.225.106])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 3151C18008C0;
	Tue, 28 Jan 2025 16:39:36 +0000 (UTC)
From: Andreas Gruenbacher <agruenba@redhat.com>
To: Kent Overstreet <kent.overstreet@linux.dev>,
	Shuah Khan <shuah@kernel.org>
Cc: Andreas Gruenbacher <agruenba@redhat.com>,
	linux-bcachefs@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Subject: [PATCH 15/21] bcachefs: add eytzinger0_find_gt tests
Date: Tue, 28 Jan 2025 17:38:52 +0100
Message-ID: <20250128163859.1883260-16-agruenba@redhat.com>
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

Add eytzinger0_find_gt() tests similar to the eytzinger0_find_le()
tests.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
---
 fs/bcachefs/util.c | 38 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 38 insertions(+)

diff --git a/fs/bcachefs/util.c b/fs/bcachefs/util.c
index c772629783f3..d84632870b56 100644
--- a/fs/bcachefs/util.c
+++ b/fs/bcachefs/util.c
@@ -819,9 +819,47 @@ static void eytzinger0_find_test_le(u16 *test_array, unsigned nr, u16 search)
 	}
 }
 
+static void eytzinger0_find_test_gt(u16 *test_array, unsigned nr, u16 search)
+{
+	int r, s;
+	bool bad;
+
+	r = eytzinger0_find_gt(test_array, nr,
+			       sizeof(test_array[0]),
+			       cmp_u16, &search);
+	if (r >= 0) {
+		if (test_array[r] <= search) {
+			bad = true;
+		} else {
+			s = eytzinger0_prev(r, nr);
+			bad = s >= 0 && test_array[s] > search;
+		}
+	} else {
+		s = eytzinger0_first(nr);
+		bad = s >= 0 && test_array[s] > search;
+	}
+
+	if (bad) {
+		s = -1;
+		eytzinger0_for_each(j, nr) {
+			if (test_array[j] > search) {
+				s = j;
+				break;
+			}
+		}
+
+		eytzinger0_for_each(j, nr)
+			pr_info("[%3u] = %12u\n", j, test_array[j]);
+		pr_info("find_gt(%12u) = %3i should be %3i\n",
+			search, r, s);
+		BUG();
+	}
+}
+
 static void eytzinger0_find_test_val(u16 *test_array, unsigned nr, u16 search)
 {
 	eytzinger0_find_test_le(test_array, nr, search);
+	eytzinger0_find_test_gt(test_array, nr, search);
 }
 
 void eytzinger0_find_test(void)
-- 
2.48.1


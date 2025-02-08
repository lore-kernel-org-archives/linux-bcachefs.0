Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D637D23C36A
	for <linux-bcachefs@vger.kernel.org>; Sat,  8 Feb 2025 11:01:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739012517; cv=none; b=NRHa6/LCnKs225EuXt/W4NCwLXssJQOMUVNVYSJRv8x6lYkOBQiU0Xks7J3pU9y3Orkpo3CRZe038nS2YTgDSwgfl/5vozLgQkmEqPoMRRMBoegW2JxprvHUY6AY+e+95lalSsnpgIYG+3HYEYqEAL2AmrNJZz9p2IQ9nLvKMP0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739012517; c=relaxed/simple;
	bh=Z1G8XEXbQxBlO1lzdbeo9A5bYeEsNCPPcS5/HBEBCgA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bbLvl9hcIzSVfiYYFjc8gHg6Md4iVlGi+oIrqFCF6kAnpBM1SuiHUQImO9mQfP5BA4NQrtj1xgo6DZRqljGViasiKUWG9TZVtpICGSkPrzk42nLMpqKkp7FHiRUsG2gT+K3nw2ylCNetx1aJeJfMPhl8yhDigCNga4UsbcmFnfo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=T2UqJPCR; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="T2UqJPCR"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1739012514;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Xy0vodMre8rWR2umyQ9YsYd2mY/kzFsfDPpZqiPudIw=;
	b=T2UqJPCR6iULvHtNN7obaFNpnneHpAxEs2jN0tInYLSRvGJE3z/sK/Fx4VO0mSAjetxqhW
	E+JEi8Usfp9H1cf79RQnfHN1+PjzEh513Liv+vrsA40Uj1spzoann8kcwCECFLhzkGv2ak
	CiuyF3pDoWIayDeEpcmQxroIEBMKqso=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-547-Pb5JiqPTMR-OnH3GCZql5A-1; Sat,
 08 Feb 2025 06:01:52 -0500
X-MC-Unique: Pb5JiqPTMR-OnH3GCZql5A-1
X-Mimecast-MFC-AGG-ID: Pb5JiqPTMR-OnH3GCZql5A
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9ECC2195609F;
	Sat,  8 Feb 2025 11:01:51 +0000 (UTC)
Received: from pasta.fast.eng.rdu2.dc.redhat.com (unknown [10.45.224.51])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 50E1830001AB;
	Sat,  8 Feb 2025 11:01:50 +0000 (UTC)
From: Andreas Gruenbacher <agruenba@redhat.com>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Andreas Gruenbacher <agruenba@redhat.com>,
	linux-bcachefs@vger.kernel.org
Subject: [PATCH v3 15/21] bcachefs: add eytzinger0_find_ge self test
Date: Sat,  8 Feb 2025 12:01:12 +0100
Message-ID: <20250208110119.546961-16-agruenba@redhat.com>
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

Add an eytzinger0_find_ge() self test similar to eytzinger0_find_gt().

Note that this test requires eytzinger0_find_ge() to return the first
matching element in the array in case of duplicates.  To prevent
bisection errors, we only add this test after strenghening the original
implementation (see the previous commit).

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
---
 fs/bcachefs/util.c | 38 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 38 insertions(+)

diff --git a/fs/bcachefs/util.c b/fs/bcachefs/util.c
index fed712dd5f82..c2e1a1fe6f73 100644
--- a/fs/bcachefs/util.c
+++ b/fs/bcachefs/util.c
@@ -856,10 +856,48 @@ static void eytzinger0_find_test_gt(u16 *test_array, unsigned nr, u16 search)
 	}
 }
 
+static void eytzinger0_find_test_ge(u16 *test_array, unsigned nr, u16 search)
+{
+	int r, s;
+	bool bad;
+
+	r = eytzinger0_find_ge(test_array, nr,
+			       sizeof(test_array[0]),
+			       cmp_u16, &search);
+	if (r >= 0) {
+		if (test_array[r] < search) {
+			bad = true;
+		} else {
+			s = eytzinger0_prev(r, nr);
+			bad = s >= 0 && test_array[s] >= search;
+		}
+	} else {
+		s = eytzinger0_first(nr);
+		bad = s >= 0 && test_array[s] >= search;
+	}
+
+	if (bad) {
+		s = -1;
+		eytzinger0_for_each(j, nr) {
+			if (test_array[j] >= search) {
+				s = j;
+				break;
+			}
+		}
+
+		eytzinger0_for_each(j, nr)
+			pr_info("[%3u] = %12u\n", j, test_array[j]);
+		pr_info("find_ge(%12u) = %3i should be %3i\n",
+			search, r, s);
+		BUG();
+	}
+}
+
 static void eytzinger0_find_test_val(u16 *test_array, unsigned nr, u16 search)
 {
 	eytzinger0_find_test_le(test_array, nr, search);
 	eytzinger0_find_test_gt(test_array, nr, search);
+	eytzinger0_find_test_ge(test_array, nr, search);
 }
 
 void eytzinger0_find_test(void)
-- 
2.48.1


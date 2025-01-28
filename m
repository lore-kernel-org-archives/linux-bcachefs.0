Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F1A61DE3BB
	for <linux-bcachefs@vger.kernel.org>; Tue, 28 Jan 2025 16:39:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738082381; cv=none; b=rdOGt/KOaoGteY80y3ldwsLmpN7NM3LNJck2XIu9opr6T5Whr9PeLfdHco6remlixnOG+7MHUaN0GUwDcHvz980ZDj3hYQlEozDoVk1wBC6BQDuH4jRxXM0Fb23/1s+CW7y7jzlr0wevFZM3OITLnkyua3bRUfcZha1YECc8pZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738082381; c=relaxed/simple;
	bh=cA0DcHmOCbjpertJ2WrDIHOP2x5boUglDbhmPkrFt9k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S37qTQGIbnym4PHgs/w/bUGnWCOpWrs7djh8Xy/Hs1OPU2W84tGnFAe9crinTaVWtUAnFroHXGre5CDD8MKfdQppj+9QVk0tFNYv9wZATFJNku3YJnXmxFVrQpSGfnTqQUhDeLbzw8anp9YBnnQGOjrwryv7Utng2RFc3bozfjc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=QI69aki2; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QI69aki2"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1738082379;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PZd8+r0Ld1kBa8nPrqbyJF0th13OifpvbO/JPmMcyGI=;
	b=QI69aki2S6topS8sBFf9eAtQTWXclshndaV7y4+2eZgPIi0mB8dhUZ1RhJ/mgG8/oTTQm5
	30SMqj4JwD+Yf6pFTve4gfFu4uhpry88TgHNQQvo4sTiSR7mfZwBI2xzQY49Xb6wyhK1Z2
	A9Dzs5v94a1Ae9m+TbPxlPfX+xDWR3s=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-450-RWm3NFUJNJiinvZ0xkH_Dw-1; Tue,
 28 Jan 2025 11:39:38 -0500
X-MC-Unique: RWm3NFUJNJiinvZ0xkH_Dw-1
X-Mimecast-MFC-AGG-ID: RWm3NFUJNJiinvZ0xkH_Dw
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A96D819560B2;
	Tue, 28 Jan 2025 16:39:36 +0000 (UTC)
Received: from pasta.fast.eng.rdu2.dc.redhat.com (unknown [10.45.225.106])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id CC2DC18008C0;
	Tue, 28 Jan 2025 16:39:34 +0000 (UTC)
From: Andreas Gruenbacher <agruenba@redhat.com>
To: Kent Overstreet <kent.overstreet@linux.dev>,
	Shuah Khan <shuah@kernel.org>
Cc: Andreas Gruenbacher <agruenba@redhat.com>,
	linux-bcachefs@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Subject: [PATCH 14/21] bcachefs: simplify eytzinger0_find_le
Date: Tue, 28 Jan 2025 17:38:51 +0100
Message-ID: <20250128163859.1883260-15-agruenba@redhat.com>
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

Replace the over-complicated implementation of eytzinger0_find_le() by
an equivalent, simplifer version.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
---
 fs/bcachefs/eytzinger.h | 26 ++++++--------------------
 1 file changed, 6 insertions(+), 20 deletions(-)

diff --git a/fs/bcachefs/eytzinger.h b/fs/bcachefs/eytzinger.h
index 130f5fe30bd7..89a0e4192212 100644
--- a/fs/bcachefs/eytzinger.h
+++ b/fs/bcachefs/eytzinger.h
@@ -256,26 +256,12 @@ static inline int eytzinger0_find_le(void *base, size_t nr, size_t size,
 				     cmp_func_t cmp, const void *search)
 {
 	void *base1 = base - size;
-	unsigned i, n = 1;
-
-	if (!nr)
-		return -1;
-
-	do {
-		i = n;
-		n = eytzinger1_child(i, cmp(base1 + i * size, search) <= 0);
-	} while (n <= nr);
-
-	if (!(n & 1)) {
-		/*
-		 * @i was greater than @search, return previous node:
-		 *
-		 * if @i was leftmost/smallest element,
-		 * eytzinger1_prev(eytzinger1_first())) returns 0, as expected
-		 */
-		i = eytzinger1_prev(i, nr);
-	}
-	return i - 1;
+	unsigned n = 1;
+
+	while (n <= nr)
+		n = eytzinger1_child(n, cmp(base1 + n * size, search) <= 0);
+	n >>= __ffs(n) + 1;
+	return n - 1;
 }
 
 static inline int eytzinger0_find_gt(void *base, size_t nr, size_t size,
-- 
2.48.1


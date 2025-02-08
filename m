Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D95A23C363
	for <linux-bcachefs@vger.kernel.org>; Sat,  8 Feb 2025 11:01:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739012516; cv=none; b=TKP9Sc8u+otkkAKc+iJh/jBVIGKSc376VT4SPD+JGvfF2FwAFNz2QADOevOT4gKAKPv8mXtHBhBX1tTC73lmJ86vWW9BFSVa7MYh7I3WawA4zQ5nkIEhFOf1waKeWgHP2sXfPynB5dJHwqM5WZJdKJM9EbLFXI9vG3YtrwVkAFo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739012516; c=relaxed/simple;
	bh=gdXPMPJ7TeiRHGk+ECK7n+MWL7xUqt5fc5Az+lEcJP8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F6xvmgMrF9l2lYSnCy43TcUh3lUc9JkQnI8IP63HM9k0pMCMg7dmXNFSTkz/4yL7Y9knk67V80ng8vAZ52JnXQ24uWRAgacn/IhF0cEd7oFjlTWjPWuOUyrh29SLgOlauGGaJ3AWeDltVlQ7YTXXB03Vn1C5sdxz1F+/bvh/DHs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=SPVdKcKb; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SPVdKcKb"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1739012514;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tzRu0u8rCf0yxiFNU2Yx40bDto7XhdPldWSgTtumACo=;
	b=SPVdKcKbhOWOE4nHDqUIEdcPpdmAbk43ZEPq74K2b6FF34BaUrb1ikQCA8D0HF7OA9WN9F
	EU8wM1EghQgZkPVEyPi2FQJXc3wAhwgQgMVCj2bbNsNNJHg8FvzDSmsN9TomS5pS/jy1r5
	ibSYLwLv42Ni0InUSUt6UR89Q6sBDb0=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-29-rg3tbxGGOK29uMHoOAQIJA-1; Sat,
 08 Feb 2025 06:01:50 -0500
X-MC-Unique: rg3tbxGGOK29uMHoOAQIJA-1
X-Mimecast-MFC-AGG-ID: rg3tbxGGOK29uMHoOAQIJA
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E91EA1800268;
	Sat,  8 Feb 2025 11:01:49 +0000 (UTC)
Received: from pasta.fast.eng.rdu2.dc.redhat.com (unknown [10.45.224.51])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 7C0CE30001AB;
	Sat,  8 Feb 2025 11:01:48 +0000 (UTC)
From: Andreas Gruenbacher <agruenba@redhat.com>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Andreas Gruenbacher <agruenba@redhat.com>,
	linux-bcachefs@vger.kernel.org
Subject: [PATCH v3 14/21] bcachefs: implement eytzinger0_find_ge directly
Date: Sat,  8 Feb 2025 12:01:11 +0100
Message-ID: <20250208110119.546961-15-agruenba@redhat.com>
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

Implement eytzinger0_find_ge() directly instead of implementing it in
terms of eytzinger0_find_le() and adjusting the result.

This turns eytzinger0_find_ge() into a minimum search, so when there are
duplicate elements, the result of eytzinger0_find_ge() will now always
point at the first matching element.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
---
 fs/bcachefs/eytzinger.h | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/fs/bcachefs/eytzinger.h b/fs/bcachefs/eytzinger.h
index 568a04b16d09..e3713b7b4c27 100644
--- a/fs/bcachefs/eytzinger.h
+++ b/fs/bcachefs/eytzinger.h
@@ -275,15 +275,17 @@ static inline int eytzinger0_find_gt(void *base, size_t nr, size_t size,
 	return n - 1;
 }
 
+/* return smallest node >= @search, or -1 if not found */
 static inline int eytzinger0_find_ge(void *base, size_t nr, size_t size,
 				     cmp_func_t cmp, const void *search)
 {
-	ssize_t idx = eytzinger0_find_le(base, nr, size, cmp, search);
-
-	if (idx < nr && !cmp(base + idx * size, search))
-		return idx;
+	void *base1 = base - size;
+	unsigned n = 1;
 
-	return eytzinger0_next(idx, nr);
+	while (n <= nr)
+		n = eytzinger1_child(n, cmp(base1 + n * size, search) < 0);
+	n >>= __ffs(n + 1) + 1;
+	return n - 1;
 }
 
 #define eytzinger0_find(base, nr, size, _cmp, search)			\
-- 
2.48.1


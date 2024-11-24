Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45A7518D65F
	for <linux-bcachefs@vger.kernel.org>; Sun, 24 Nov 2024 13:11:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732453920; cv=none; b=AwFBXqBF4fsx535IuDNYjPV4WVM946cSdRaGpZlOGY/vYZEx3Me7V0CkXFES5MqljI7Bb4EAqth4ciTmWAPPLjPOAyb0y5WRmtkPni+bDjKKUYNtJxVqtKQO2npJAVsCi4atjf62RuTaDOdQ8iQ9oWm5T4PwFH/VUAgr2/NyEgM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732453920; c=relaxed/simple;
	bh=zmu1RseFARs8kWQt7mKNZcuQIBgZUK5Yf545lVP7xrA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=EUkCk/WJTm+QMlHBV2B7Pt1EbQfqLHqbptsC1HKlvQZKCMEiUoZKE3Zh+jVwtvSS9XIVwEV08Okpe1AT0AiIJ9f57HpPUSz8pCKBTR8L8S130Xg9k3WWOUVDepRv16TpucCykppQPgxjIQf5frxPVFztpuEo/+bLtGVrdvtABfo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CfYpe9ze; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CfYpe9ze"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1732453916;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=9oBpUwufGWYbjD9W2JqZ7s6gXl9NPBMw0ftLm4Irn6U=;
	b=CfYpe9zevhfQZtpl2HyM0iJ7SPARACRm07ClVRDNQ6axSm68bmbXOD1gBy69VM4B0t4ArU
	fajZhbA+pk2BlKrx2YfQ6Xz5ZNiD4CYd0VKU1cJVUzTOAJS2nbCK2XDf7m6anq6j1bg3gZ
	DAjq9NhOlKqKtJ2h2Fp5trvvkILZkiI=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-589-WlvI5hmlN2-U9kLPR9tYvQ-1; Sun,
 24 Nov 2024 08:11:52 -0500
X-MC-Unique: WlvI5hmlN2-U9kLPR9tYvQ-1
X-Mimecast-MFC-AGG-ID: WlvI5hmlN2-U9kLPR9tYvQ
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7FBAB19560B1;
	Sun, 24 Nov 2024 13:11:51 +0000 (UTC)
Received: from pasta.fast.eng.rdu2.dc.redhat.com (unknown [10.45.225.117])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id F1EB0195E481;
	Sun, 24 Nov 2024 13:11:49 +0000 (UTC)
From: Andreas Gruenbacher <agruenba@redhat.com>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: linux-bcachefs@vger.kernel.org,
	Andreas Gruenbacher <andreas.gruenbacher@gmail.com>,
	Andreas Gruenbacher <agruenba@redhat.com>
Subject: [PATCH] bcachefs: eytzinger1_{next,prev} cleanup
Date: Sun, 24 Nov 2024 14:11:47 +0100
Message-ID: <20241124131147.1057922-1-agruenba@redhat.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

From: Andreas Gruenbacher <andreas.gruenbacher@gmail.com>

In this place in the code, eytzinger1_next() is trying to move the
lowest child on the left, which is equivalent to doubling i until the
next doubling would cause it to be greater than size.  This is
implemented by shifting i to the left so that the most significant bits
of both numbers align, and then shifting i right by one if it is greater
than size.

The code accidentally computes the most significant bit of (size + 1)
instead of size.  This happens to be harmless because in that case, the
right shifting will compensate, but it is confusing and unnecessary.

Likewise, eytzinger1_prev() is trying to move the lowest child on the
right.  The same applies here.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
---
 fs/bcachefs/eytzinger.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/bcachefs/eytzinger.h b/fs/bcachefs/eytzinger.h
index 0541192d7bc0..9fa63a624c92 100644
--- a/fs/bcachefs/eytzinger.h
+++ b/fs/bcachefs/eytzinger.h
@@ -73,7 +73,7 @@ static inline unsigned eytzinger1_next(unsigned i, unsigned size)
 	if (eytzinger1_right_child(i) <= size) {
 		i = eytzinger1_right_child(i);
 
-		i <<= __fls(size + 1) - __fls(i);
+		i <<= __fls(size) - __fls(i);
 		i >>= i > size;
 	} else {
 		i >>= ffz(i) + 1;
@@ -89,7 +89,7 @@ static inline unsigned eytzinger1_prev(unsigned i, unsigned size)
 	if (eytzinger1_left_child(i) <= size) {
 		i = eytzinger1_left_child(i) + 1;
 
-		i <<= __fls(size + 1) - __fls(i);
+		i <<= __fls(size) - __fls(i);
 		i -= 1;
 		i >>= i > size;
 	} else {
-- 
2.46.2


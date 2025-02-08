Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8604239577
	for <linux-bcachefs@vger.kernel.org>; Sat,  8 Feb 2025 11:01:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739012500; cv=none; b=cbwYiPe9wJFD5Z1yoASRxulZwGG2egF+/mEfq+hyxFRAuQR4NgPSzxKkwdnkhxOjG8TByvDngCnK9mXLfyQ2ll4xorAnIjOBMFlvlX6fXg7+/CiouFOmqYJX4K7MgrQMOwpOQf5dautZ8u2qr0fQf1RE3v51JdK8S61q58FK7xQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739012500; c=relaxed/simple;
	bh=MPXNd6DZuTALzh3eF4wB/5Xl52vfQ9CPGmkrZwGY+E8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NlfHhiI3+TGSujcqv6YU7IWz3Dr9mP8rD6ujUZ9LXKf0QC7MVIgm9SEgZVTmzz4sW0m4mTnU4Jc7yB4hj5OZgNYNOIUm6vxqC19kOgJdQRhrY+tWBcxzmkwBAJSsPGAAb41SRiov+JjncFyhDOD37IYswQRyPniTL5cqx1l47DE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=cOY48IDN; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cOY48IDN"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1739012497;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Z52NIyrubjuSo5ImA+OlDE/j82xu8V6jvHT9HUiqTsc=;
	b=cOY48IDNMUQEkRttDjPNglarYaHsl/SSAUMp+SC4mCys8FCBl09C1+pdahukuWxHdA0D4u
	tosJ40A7jRbG+9WZMBG86RkFHslz5ZWC2AL3ldMNkhVw9csXlkncCp0VmGlyZ1P4UmPU+X
	ivGUEu6EoLzCRJcppnbufjADw9T2WaM=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-596-3lJVf2UFNNiQoGvfBmcZXA-1; Sat,
 08 Feb 2025 06:01:34 -0500
X-MC-Unique: 3lJVf2UFNNiQoGvfBmcZXA-1
X-Mimecast-MFC-AGG-ID: 3lJVf2UFNNiQoGvfBmcZXA
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3427C19560AA;
	Sat,  8 Feb 2025 11:01:33 +0000 (UTC)
Received: from pasta.fast.eng.rdu2.dc.redhat.com (unknown [10.45.224.51])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id CFC4F3001D13;
	Sat,  8 Feb 2025 11:01:30 +0000 (UTC)
From: Andreas Gruenbacher <agruenba@redhat.com>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Andreas Gruenbacher <agruenba@redhat.com>,
	linux-bcachefs@vger.kernel.org
Subject: [PATCH v3 05/21] bcachefs: eytzinger self tests: fix cmp_u16 typo
Date: Sat,  8 Feb 2025 12:01:02 +0100
Message-ID: <20250208110119.546961-6-agruenba@redhat.com>
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

Fix an obvious typo in cmp_u16().

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
---
 fs/bcachefs/util.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/bcachefs/util.c b/fs/bcachefs/util.c
index e2bcfb38bbae..84f139154701 100644
--- a/fs/bcachefs/util.c
+++ b/fs/bcachefs/util.c
@@ -768,7 +768,7 @@ static inline int cmp_u16(const void *_l, const void *_r)
 {
 	const u16 *l = _l, *r = _r;
 
-	return (*l > *r) - (*r - *l);
+	return (*l > *r) - (*r > *l);
 }
 
 static void eytzinger0_find_test_val(u16 *test_array, unsigned nr, u16 search)
-- 
2.48.1


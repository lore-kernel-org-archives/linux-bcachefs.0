Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 649C723BF8C
	for <linux-bcachefs@vger.kernel.org>; Sat,  8 Feb 2025 11:01:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739012512; cv=none; b=nAIKoCRYDqNChQ5Iwg9lhIvF4CxcuWh9HpxLHaSP28fGH7Jim4R7l+dxY/Mh+i+gHBFmhDuw0LGes7Gtbc9rW+cjqf8P76GSxwiSvjP3/R1o3e/xuwcKF81tTzREr9vYPCi4KCy/SPijkxfRhFTpQPeON/x6+wRVb/cqMzKz/HY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739012512; c=relaxed/simple;
	bh=8OczOEl+kqxqSyOdipvN8Cvny4NVtnDkYrVkWMV0iRc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r54NOGAV0n6IzV5+tVlhUkVYoxeC2hkFst2Q6YuktV49/LXTyub1zfDbF1VAjh3gBOoP3X4DBKd7Zf5JPKUrJ7oOWH+F45ATan0yiilL3jnsQgrfW/G9+qREkZ12XY7Qb7wXx1jaO/41GJSVXqyRRkXMtw83fXjCIs8KS/zUpOc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=QyVbECwl; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QyVbECwl"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1739012510;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tq2XfYFY/UjgcleTJtL//pC8JQ1VnxNEw3d2d1+sbQ0=;
	b=QyVbECwl30YZpIXdZH01egFkvF2Q9iKztoRe64k9RFAATR5CZjmBiEPR5JmvnMpM003Cq1
	v6Os+cGDdAbfy8uKiC5GcN7ZAuHKYaQxcTedC7Phy0NQu6bs287hPvzzV+T2umo/68zLfS
	xf9OfOiyGbSg0o8ScEmlOV+uqvrrjwc=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-394-aOpruBbDN-eFBLzNrxjHQQ-1; Sat,
 08 Feb 2025 06:01:49 -0500
X-MC-Unique: aOpruBbDN-eFBLzNrxjHQQ-1
X-Mimecast-MFC-AGG-ID: aOpruBbDN-eFBLzNrxjHQQ
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0443A1955DB8;
	Sat,  8 Feb 2025 11:01:48 +0000 (UTC)
Received: from pasta.fast.eng.rdu2.dc.redhat.com (unknown [10.45.224.51])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 8A9E43001D13;
	Sat,  8 Feb 2025 11:01:46 +0000 (UTC)
From: Andreas Gruenbacher <agruenba@redhat.com>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Andreas Gruenbacher <agruenba@redhat.com>,
	linux-bcachefs@vger.kernel.org
Subject: [PATCH v3 13/21] bcachefs: implement eytzinger0_find_gt directly
Date: Sat,  8 Feb 2025 12:01:10 +0100
Message-ID: <20250208110119.546961-14-agruenba@redhat.com>
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

Instead of implementing eytzinger0_find_gt() in terms of
eytzinger0_find_le() and adjusting the result, implement it directly.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
---
 fs/bcachefs/eytzinger.h | 17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

diff --git a/fs/bcachefs/eytzinger.h b/fs/bcachefs/eytzinger.h
index a530dbcde476..568a04b16d09 100644
--- a/fs/bcachefs/eytzinger.h
+++ b/fs/bcachefs/eytzinger.h
@@ -262,20 +262,17 @@ static inline int eytzinger0_find_le(void *base, size_t nr, size_t size,
 	return n - 1;
 }
 
+/* return smallest node > @search, or -1 if not found */
 static inline int eytzinger0_find_gt(void *base, size_t nr, size_t size,
 				     cmp_func_t cmp, const void *search)
 {
-	ssize_t idx = eytzinger0_find_le(base, nr, size, cmp, search);
+	void *base1 = base - size;
+	unsigned n = 1;
 
-	/*
-	 * if eytitzinger0_find_le() returned -1 - no element was <= search - we
-	 * want to return the first element; next/prev identities mean this work
-	 * as expected
-	 *
-	 * similarly if find_le() returns last element, we should return -1;
-	 * identities mean this all works out:
-	 */
-	return eytzinger0_next(idx, nr);
+	while (n <= nr)
+		n = eytzinger1_child(n, cmp(base1 + n * size, search) <= 0);
+	n >>= __ffs(n + 1) + 1;
+	return n - 1;
 }
 
 static inline int eytzinger0_find_ge(void *base, size_t nr, size_t size,
-- 
2.48.1


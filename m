Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29FB423AE9E
	for <linux-bcachefs@vger.kernel.org>; Sat,  8 Feb 2025 11:01:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739012511; cv=none; b=jxg/amOsetGNHN83pfPlCS5hxfU1W+7OCdovfIECQ8QqxG+Vyv0tGywpKnkZQ/uYX1FO3q27/Q8nUoZLC1L0kb728ShHieJHk2IpdzcicUls6NagOAPm+oxlkT7ez9HuTbQJ9nSEMoc9t7kSV+4OrQLQZWTI6+HzVvh/8L9GB0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739012511; c=relaxed/simple;
	bh=lG5t1aR8UjLx/0lQJ78HPLIk/DTr1TWuMp1e27eZbxw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=htDO7zhDWJFEVBEsBCF52DYHhvxpqZvRI+UxEkst4tUN7QQJXY+IGZAOxxGppATCdPH1zebpvgi3+dIvXJDgvRIccnQm5ma8sCIuwUayuUTXVobkY9ULDghr2uz4gWNGAL4IeKV30VWTfZ45ELpyEc2pfO49S3GCCPQUyWavevA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=LZpcnqIs; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LZpcnqIs"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1739012508;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zf9oCtvD6JP6yX3givhOisNQwUK3E4TiFJLEdhFEVok=;
	b=LZpcnqIsauoXqciCU4JnxkFE1MJP5IwGHWMpCMh3Tr80dwdse3LQG+GIi4PfHSuTSAs9P5
	dgcyqlVbheResNNky/kNwiA0jtpRkWMMpje67pBpMsZmjLZB8SeWOxuc0cUsg3cDrEk6Cl
	jWews8oHIbFbfZ3kprSCZKkd6IRn5ys=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-568-itoJ2Q9VP8Omy7L_TYFHsg-1; Sat,
 08 Feb 2025 06:01:45 -0500
X-MC-Unique: itoJ2Q9VP8Omy7L_TYFHsg-1
X-Mimecast-MFC-AGG-ID: itoJ2Q9VP8Omy7L_TYFHsg
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5B2761800373;
	Sat,  8 Feb 2025 11:01:44 +0000 (UTC)
Received: from pasta.fast.eng.rdu2.dc.redhat.com (unknown [10.45.224.51])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id D8D7930001AB;
	Sat,  8 Feb 2025 11:01:42 +0000 (UTC)
From: Andreas Gruenbacher <agruenba@redhat.com>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Andreas Gruenbacher <agruenba@redhat.com>,
	linux-bcachefs@vger.kernel.org
Subject: [PATCH v3 11/21] bcachefs: simplify eytzinger0_find_le
Date: Sat,  8 Feb 2025 12:01:08 +0100
Message-ID: <20250208110119.546961-12-agruenba@redhat.com>
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

Replace the over-complicated implementation of eytzinger0_find_le() by
an equivalent, simpler version.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
---
 fs/bcachefs/eytzinger.h | 26 ++++++--------------------
 1 file changed, 6 insertions(+), 20 deletions(-)

diff --git a/fs/bcachefs/eytzinger.h b/fs/bcachefs/eytzinger.h
index 08256fcaeeb7..a530dbcde476 100644
--- a/fs/bcachefs/eytzinger.h
+++ b/fs/bcachefs/eytzinger.h
@@ -254,26 +254,12 @@ static inline int eytzinger0_find_le(void *base, size_t nr, size_t size,
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


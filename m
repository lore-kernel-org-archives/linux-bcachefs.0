Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 453A423C39D
	for <linux-bcachefs@vger.kernel.org>; Sat,  8 Feb 2025 11:02:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739012523; cv=none; b=dasSOU8s9nMdyEFe4bnHwfOPPib+ogV7Ooku4w2XECJ9J6bh9y6TEvhP1o+UIChItyoI5xb8LZHk3mttu4lQapo5hnmHIwiwvcO3vjf36EMRLKv0iLp/WWZmxfWfOZu2Ebr0OCDeKkbZuNQOqjoMM4jWpNWt44DsAldopRq1vuI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739012523; c=relaxed/simple;
	bh=ndPtZdEDgU8qK6qTANMpibLssAcNO8dTWY4tQiKl3EA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mj/pPaCtR0lYPkjfgjeckk/bgxI72xPlYrBZvqxmzp/epIMJJvvj73pIYc98FjcnspFwKptk9RZk1lmIH4DxZ6xqhmTBTlgMy2yoI+Oj875teuhFo+5iCGmrpUr7PBl6B5ZgIb5kkNd8isEyHX0iNaPMtv1WmDLa7aPkuUMM6fg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=NE1eF23s; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NE1eF23s"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1739012519;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MmxdZd/4vuPn0Fv+exBK1tqIBDAg3AtzhpHj3By0beg=;
	b=NE1eF23smXY8i2JwcOzLMzYqXstJwCphawGrKquzUCLsbgq7+OUEfjvP7P1/xXHp0sJp0V
	wLO33BvOTE4XWm6ACzR+3wBdvWV1AdSltNjyvVCa4E4TLSHwyHbeIeoIJl5ip4ULPA/pd4
	63R9iaf1PyMgaCgVZkdyFJenAP95DC8=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-563-jIOXzN9cNJGXReFfR0QPDA-1; Sat,
 08 Feb 2025 06:01:56 -0500
X-MC-Unique: jIOXzN9cNJGXReFfR0QPDA-1
X-Mimecast-MFC-AGG-ID: jIOXzN9cNJGXReFfR0QPDA
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4885E1800874;
	Sat,  8 Feb 2025 11:01:55 +0000 (UTC)
Received: from pasta.fast.eng.rdu2.dc.redhat.com (unknown [10.45.224.51])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id ECA6830001AB;
	Sat,  8 Feb 2025 11:01:53 +0000 (UTC)
From: Andreas Gruenbacher <agruenba@redhat.com>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Andreas Gruenbacher <agruenba@redhat.com>,
	linux-bcachefs@vger.kernel.org
Subject: [PATCH v3 17/21] bcachefs: convert eytzinger0_find to be 1-based
Date: Sat,  8 Feb 2025 12:01:14 +0100
Message-ID: <20250208110119.546961-18-agruenba@redhat.com>
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

Several of the algorithms on eytzinger trees are implemented in terms of
the eytzinger0 primitives.  However, those algorithms can just as easily
be expressed in terms of the eytzinger1 primitives, and that leads to
better and easier to understand code.  Start by converting
eytzinger0_find().

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
---
 fs/bcachefs/eytzinger.h | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/fs/bcachefs/eytzinger.h b/fs/bcachefs/eytzinger.h
index e3713b7b4c27..90cd5648b177 100644
--- a/fs/bcachefs/eytzinger.h
+++ b/fs/bcachefs/eytzinger.h
@@ -290,17 +290,17 @@ static inline int eytzinger0_find_ge(void *base, size_t nr, size_t size,
 
 #define eytzinger0_find(base, nr, size, _cmp, search)			\
 ({									\
-	void *_base		= (base);				\
+	size_t _size		= (size);				\
+	void *_base1		= (void *)(base) - _size;		\
 	const void *_search	= (search);				\
 	size_t _nr		= (nr);					\
-	size_t _size		= (size);				\
-	size_t _i		= 0;					\
+	size_t _i		= 1;					\
 	int _res;							\
 									\
-	while (_i < _nr &&						\
-	       (_res = _cmp(_search, _base + _i * _size)))		\
-		_i = eytzinger0_child(_i, _res > 0);			\
-	_i;								\
+	while (_i <= _nr &&						\
+	       (_res = _cmp(_search, _base1 + _i * _size)))		\
+		_i = eytzinger1_child(_i, _res > 0);			\
+	_i - 1;								\
 })
 
 void eytzinger0_sort_r(void *, size_t, size_t,
-- 
2.48.1


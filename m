Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D872D1DE3A9
	for <linux-bcachefs@vger.kernel.org>; Tue, 28 Jan 2025 16:39:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738082379; cv=none; b=rd11nRN+EmFcMeNmiwVICe46FxA9+EQ9hhnUBQ6/fnmEymLHTC36zdXuzIBxOM0uaSyGITxZEoUqZnUHv6NAwH/Q4iLwTYBru9mrDgUYBk9IeFdsiE5Oe8SVtINKk5uWrVb/dLPwkbsr3wLTBLQ7ZC4cbyGrLusfTW84U9DC8ow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738082379; c=relaxed/simple;
	bh=Q4L+OrPQw64EmyoWqeElIQQS4K6CLQeCegeDdBXVELc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bww+TDcTpuBd7Hbn4rQ/INz1/okqXCwxBd+pNO53GRZVWELN5oCyV5OJMt6f/0N8yFKlZafUAuQKfF2GcbiRlf+0SXBklfQNZ/rL5ePtuNmMEHw3IB6fXRR9bSRlcVRSwrWc3LAWSX9G1txNreD1qqXBCpe9CV6wwMSCMbMpeqA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=EfDqVn6s; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EfDqVn6s"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1738082377;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=STYFZq9yGDZAcEa5KK0r23b7pY53kibk/xnRBI6F77I=;
	b=EfDqVn6sMjAog6eJ2veVKO8SUBU9oMUNLwZTtr7HfPgF+Xc2gYCkTD6pCFJeU2cO+P7zvA
	mn9zwA0Pok+Fp5mEr7xWA7/Z8AgrzrUzjbFL1Q3MpIGmXja4Ya56rsMFPjqvC6NDgA9hsH
	Tnwmq5+SMJ72ZkOqiZf+pWaTmj2Zys4=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-678-DhthYg2JPcaI-lC5nhuTGA-1; Tue,
 28 Jan 2025 11:39:31 -0500
X-MC-Unique: DhthYg2JPcaI-lC5nhuTGA-1
X-Mimecast-MFC-AGG-ID: DhthYg2JPcaI-lC5nhuTGA
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 73E8C19560AB;
	Tue, 28 Jan 2025 16:39:27 +0000 (UTC)
Received: from pasta.fast.eng.rdu2.dc.redhat.com (unknown [10.45.225.106])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 7D676180035E;
	Tue, 28 Jan 2025 16:39:25 +0000 (UTC)
From: Andreas Gruenbacher <agruenba@redhat.com>
To: Kent Overstreet <kent.overstreet@linux.dev>,
	Shuah Khan <shuah@kernel.org>
Cc: Andreas Gruenbacher <agruenba@redhat.com>,
	linux-bcachefs@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Subject: [PATCH 10/21] bcachefs: add eytzinger0_for_each_prev
Date: Tue, 28 Jan 2025 17:38:47 +0100
Message-ID: <20250128163859.1883260-11-agruenba@redhat.com>
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

Add an eytzinger0_for_each_prev() macro for iterating through an
eytzinger array in reverse.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
---
 fs/bcachefs/eytzinger.h | 5 +++++
 fs/bcachefs/util.c      | 9 +++++++++
 2 files changed, 14 insertions(+)

diff --git a/fs/bcachefs/eytzinger.h b/fs/bcachefs/eytzinger.h
index 6fa6d51a5420..f25c895aa184 100644
--- a/fs/bcachefs/eytzinger.h
+++ b/fs/bcachefs/eytzinger.h
@@ -246,6 +246,11 @@ static inline unsigned inorder_to_eytzinger0(unsigned i, unsigned size)
 	     (_i) != -1;				\
 	     (_i) = eytzinger0_next((_i), (_size)))
 
+#define eytzinger0_for_each_prev(_i, _size)		\
+	for (unsigned (_i) = eytzinger0_last((_size));	\
+	     (_i) != -1;				\
+	     (_i) = eytzinger0_prev((_i), (_size)))
+
 /* return greatest node <= @search, or -1 if not found */
 static inline int eytzinger0_find_le(void *base, size_t nr, size_t size,
 				     cmp_func_t cmp, const void *search)
diff --git a/fs/bcachefs/util.c b/fs/bcachefs/util.c
index 87502e1ac7ce..3fe9a3b8c696 100644
--- a/fs/bcachefs/util.c
+++ b/fs/bcachefs/util.c
@@ -763,6 +763,15 @@ void eytzinger0_test(void)
 			inorder++;
 		}
 		BUG_ON(inorder != size);
+
+		inorder = size - 1;
+		eytzinger0_for_each_prev(eytz, size) {
+			BUG_ON(eytz != eytzinger0_first(size) &&
+			       eytzinger0_next(eytzinger0_prev(eytz, size), size) != eytz);
+
+			inorder--;
+		}
+		BUG_ON(inorder != -1);
 	}
 }
 
-- 
2.48.1


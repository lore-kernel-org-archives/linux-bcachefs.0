Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CDBF2397AD
	for <linux-bcachefs@vger.kernel.org>; Sat,  8 Feb 2025 11:01:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739012504; cv=none; b=G7ap+Gtqb7VIiYFBj1Pu7E+P1ZzNHPY66qYKtqzEsrBfCgkGuKsWnRZblFaIR6XTRtQA1POchx4WdEO15guEcXM7KRl1jdFz4erO4e1FG9Z8NYSS3r45/nC2UU++gpOIoB5ke9ZL7o9R5yJQRW+8msLROYEmPVr48tLTFr47Yac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739012504; c=relaxed/simple;
	bh=i1S0nATKwIRXBFd9tx6Y4Wzs0+gopqQZ9/SC7hAOuMg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rnC/lvjQu6NzVVkREa0qf6+XsWBRnUzyzbFX7XjQQxPkNQE3FAnOAVtMACJpg7lfbVpgBxxM2PkrcsRzeEJtwKkvBHE7SFk23lH+qyusShzGqBhcshGMeuF9vNGZg/t52RcIzBYhjK28hF/Oq0nRv1cmnxAlfD5hdWsdpCPwzdc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=XFf3r+Q1; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XFf3r+Q1"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1739012501;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LX8KXBYg+mph6Ka1yL8wsS4LE/0UVYG97lTj7RY2CUI=;
	b=XFf3r+Q1rPZNDDBJKtsiVC26pUOHmv5F0onN9WvylsRcnRWFgir8+skydCkdKsW26HMgyc
	6X6+dZ/iF0nTol2u/yWGxwN0SCzYd67ohT347WK9PSybMPGYxQ4k7m4vjg/tjnoBWZeGGY
	7HQ0U/4/nL78qJOxyAcjenoc56wx6Oc=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-652-LjmrTWmwM7mFLHS_tdg71Q-1; Sat,
 08 Feb 2025 06:01:37 -0500
X-MC-Unique: LjmrTWmwM7mFLHS_tdg71Q-1
X-Mimecast-MFC-AGG-ID: LjmrTWmwM7mFLHS_tdg71Q
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E162319560A6;
	Sat,  8 Feb 2025 11:01:36 +0000 (UTC)
Received: from pasta.fast.eng.rdu2.dc.redhat.com (unknown [10.45.224.51])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 8A4B730001AB;
	Sat,  8 Feb 2025 11:01:35 +0000 (UTC)
From: Andreas Gruenbacher <agruenba@redhat.com>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Andreas Gruenbacher <agruenba@redhat.com>,
	linux-bcachefs@vger.kernel.org
Subject: [PATCH v3 07/21] bcachefs: eytzinger0_find_test improvement
Date: Sat,  8 Feb 2025 12:01:04 +0100
Message-ID: <20250208110119.546961-8-agruenba@redhat.com>
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

In eytzinger0_find_test(), remember the smallest element seen so far
instead of comparing adjacent array elements.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
---
 fs/bcachefs/util.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/fs/bcachefs/util.c b/fs/bcachefs/util.c
index 953ed5ad38a4..55bf19578e3a 100644
--- a/fs/bcachefs/util.c
+++ b/fs/bcachefs/util.c
@@ -802,15 +802,18 @@ void eytzinger0_find_test(void)
 	u16 *test_array = kmalloc_array(allocated, sizeof(test_array[0]), GFP_KERNEL);
 
 	for (nr = 1; nr < allocated; nr++) {
+		u16 prev = 0;
+
 		pr_info("testing %u elems\n", nr);
 
 		get_random_bytes(test_array, nr * sizeof(test_array[0]));
 		eytzinger0_sort(test_array, nr, sizeof(test_array[0]), cmp_u16, NULL);
 
 		/* verify array is sorted correctly: */
-		eytzinger0_for_each(j, nr)
-			BUG_ON(j != eytzinger0_last(nr) &&
-			       test_array[j] > test_array[eytzinger0_next(j, nr)]);
+		eytzinger0_for_each(j, nr) {
+			BUG_ON(test_array[j] < prev);
+			prev = test_array[j];
+		}
 
 		for (i = 0; i < U16_MAX; i += 1 << 12)
 			eytzinger0_find_test_val(test_array, nr, i);
-- 
2.48.1


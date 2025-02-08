Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9042023A582
	for <linux-bcachefs@vger.kernel.org>; Sat,  8 Feb 2025 11:01:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739012506; cv=none; b=SdZQ1CzyekkPZg3dSQQvKCewl2XT47IYMEn5bZmKILbDc7pOkP4ePbJixska7E8qQUKzH3RmdnfpbnzK/VBL5It3JKUacA5uL1IxXqCW7Jeg0wKzb9naWft1/vUwHL+782flcCZ83vDlDgcm+jCcj23Ma1iBBUV04e2eb8yzUmY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739012506; c=relaxed/simple;
	bh=gvxAQrqA8pmwJakUvasQDox4izWcJlHmojfOkB/l+gg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F8pXNTQYKz+TUFbRcq9vWQtAkuZ2/kXu5wBzC8WMVoICRKrZlzy6FSIjQhZnBGk7FRX9iRt9Eqt7vU7BJeU51yf3+nn93X12UvPm+y/AGB/lng3x7FpBSxQmNrbtCVeLcW5Z/K7LTsQ+p4XFVl43GEtFtA2zROP3sQQj1k2pxA0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bEvetJ5r; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bEvetJ5r"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1739012503;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vuL7Yzi0kTEM3UlS9Yz5rstjZcC4iVMe9CeUXp4FjqA=;
	b=bEvetJ5rmBapgJt+MHxVry27DXUHoYFbjdMcV9LawK+fLZQ0AwwDjSsl6aXtjQTmfMDeaB
	iebATW0L0SF1HRjDV06qkUKhBB8TsvUjJdjO4jCUVQ5D9SV106hjHSS+M93CMqPibAbTHU
	H94zIMvv+R5H5zWI3BIhtG6HcxWhxkQ=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-646-vRvpbjoLP3qiqmAv267ppg-1; Sat,
 08 Feb 2025 06:01:39 -0500
X-MC-Unique: vRvpbjoLP3qiqmAv267ppg-1
X-Mimecast-MFC-AGG-ID: vRvpbjoLP3qiqmAv267ppg
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B57C31800876;
	Sat,  8 Feb 2025 11:01:38 +0000 (UTC)
Received: from pasta.fast.eng.rdu2.dc.redhat.com (unknown [10.45.224.51])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 65BBD30001AB;
	Sat,  8 Feb 2025 11:01:37 +0000 (UTC)
From: Andreas Gruenbacher <agruenba@redhat.com>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Andreas Gruenbacher <agruenba@redhat.com>,
	linux-bcachefs@vger.kernel.org
Subject: [PATCH v3 08/21] bcachefs: add eytzinger0_for_each_prev
Date: Sat,  8 Feb 2025 12:01:05 +0100
Message-ID: <20250208110119.546961-9-agruenba@redhat.com>
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

Add an eytzinger0_for_each_prev() macro for iterating through an
eytzinger array in reverse.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
---
 fs/bcachefs/eytzinger.h | 5 +++++
 fs/bcachefs/util.c      | 9 +++++++++
 2 files changed, 14 insertions(+)

diff --git a/fs/bcachefs/eytzinger.h b/fs/bcachefs/eytzinger.h
index 5f2f96b1295e..99edae4bb995 100644
--- a/fs/bcachefs/eytzinger.h
+++ b/fs/bcachefs/eytzinger.h
@@ -244,6 +244,11 @@ static inline unsigned inorder_to_eytzinger0(unsigned i, unsigned size)
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
index 55bf19578e3a..5e28a214c005 100644
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


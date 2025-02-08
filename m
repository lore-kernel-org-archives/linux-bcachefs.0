Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4575523E221
	for <linux-bcachefs@vger.kernel.org>; Sat,  8 Feb 2025 11:02:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739012529; cv=none; b=KSa+gRH/jThdu2g8R8IuJHqorIlhfRrTupDq4E6WgyhYE+N94k3VB2+dDVAU6Irhm+50EVwQDtZd/IMIgcbIUSA8NCl4g0nYXxMicaQPOSnucPhBnvymKWFtHkKcKP2VXWcEW0xQKzEE10/KQeykRQkOTFu2yvNEWs/HZEe//iI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739012529; c=relaxed/simple;
	bh=G/vtb+sy3jyb7BlaZDsDz0lKYwQ2GNeCAj8GYOD67t0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nbOdGLkT89S/JU3tGbM+5TISAZhl2OCq6ClsHbYl6vQHQTjtO1ndlDFzl0UZFcdJth6g0UsP7IL3ZPG/mOtgqVtX23zZCgsvvN/ViVjAl0AgHwwDNafgSeas6KBL9XeV5Z+ZFj0aqMOntxTcXwTWUl26NviV1swiLHLo8RNd04Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=SfIodtE0; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SfIodtE0"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1739012527;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=A3ywKS26eBgdzeNoqi3x3u9HN9qupspgbS7WpC3A1oo=;
	b=SfIodtE0vRwbt/SzEUgUiyXU0scYfKb1gSVLZ+SM318LiHiyd0j1T2BTD2ZX42RTOz2l6I
	9YmyTxuzhW7G4COnSH/7znNo+Oac0Qx8wrtmILeicLxa6kbHoaCGNnRPNuIfpG6AQDAnMv
	TEei3v0/HVICYd+DSQyOQqD5Ap9vceA=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-661-qgn_h2w9N1O9iE8g2W1spw-1; Sat,
 08 Feb 2025 06:02:01 -0500
X-MC-Unique: qgn_h2w9N1O9iE8g2W1spw-1
X-Mimecast-MFC-AGG-ID: qgn_h2w9N1O9iE8g2W1spw
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 02BC3180036F;
	Sat,  8 Feb 2025 11:02:01 +0000 (UTC)
Received: from pasta.fast.eng.rdu2.dc.redhat.com (unknown [10.45.224.51])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 8883A30001AB;
	Sat,  8 Feb 2025 11:01:59 +0000 (UTC)
From: Andreas Gruenbacher <agruenba@redhat.com>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Andreas Gruenbacher <agruenba@redhat.com>,
	linux-bcachefs@vger.kernel.org
Subject: [PATCH v3 20/21] bcachefs: eytzinger1_{next,prev} cleanup
Date: Sat,  8 Feb 2025 12:01:17 +0100
Message-ID: <20250208110119.546961-21-agruenba@redhat.com>
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

The eytzinger code was previously relying on the following wrap-around
properties and their "eytzinger0" equivalents:

  eytzinger1_prev(0, size) == eytzinger1_last(size)
  eytzinger1_next(0, size) == eytzinger1_first(size)

However, these properties are no longer relied upon and no longer
necessary, so remove the corresponding asserts and forbid the use of
eytzinger1_prev(0, size) and eytzinger1_next(0, size).

This allows to further simplify the code in eytzinger1_next() and
eytzinger1_prev(): where the left shifting happens, eytzinger1_next() is
trying to move i to the lowest child on the left, which is equivalent to
doubling i until the next doubling would cause it to be greater than
size.  This is implemented by shifting i to the left so that the most
significant bits align and then shifting i to the right by one if the
result is greater than size.

Likewise, eytzinger1_prev() is trying to move to the lowest child on the
right; the same applies here.

The 1-offset in (size - 1) in eytzinger1_next() isn't needed at all, but
the equivalent offset in eytzinger1_prev() is surprisingly needed to
preserve the 'eytzinger1_prev(0, size) == eytzinger1_last(size)'
property.  However, since we no longer support that property, we can get
rid of these offsets as well.  This saves one addition in each function
and makes the code less confusing.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
---
 fs/bcachefs/eytzinger.h | 18 ++++--------------
 fs/bcachefs/util.c      | 12 ------------
 2 files changed, 4 insertions(+), 26 deletions(-)

diff --git a/fs/bcachefs/eytzinger.h b/fs/bcachefs/eytzinger.h
index 90cd5648b177..643c1f716061 100644
--- a/fs/bcachefs/eytzinger.h
+++ b/fs/bcachefs/eytzinger.h
@@ -57,24 +57,14 @@ static inline unsigned eytzinger1_last(unsigned size)
 	return rounddown_pow_of_two(size + 1) - 1;
 }
 
-/*
- * eytzinger1_next() and eytzinger1_prev() have the nice properties that
- *
- * eytzinger1_next(0) == eytzinger1_first())
- * eytzinger1_prev(0) == eytzinger1_last())
- *
- * eytzinger1_prev(eytzinger1_first()) == 0
- * eytzinger1_next(eytzinger1_last()) == 0
- */
-
 static inline unsigned eytzinger1_next(unsigned i, unsigned size)
 {
-	EYTZINGER_BUG_ON(i > size);
+	EYTZINGER_BUG_ON(i == 0 || i > size);
 
 	if (eytzinger1_right_child(i) <= size) {
 		i = eytzinger1_right_child(i);
 
-		i <<= __fls(size + 1) - __fls(i);
+		i <<= __fls(size) - __fls(i);
 		i >>= i > size;
 	} else {
 		i >>= ffz(i) + 1;
@@ -85,12 +75,12 @@ static inline unsigned eytzinger1_next(unsigned i, unsigned size)
 
 static inline unsigned eytzinger1_prev(unsigned i, unsigned size)
 {
-	EYTZINGER_BUG_ON(i > size);
+	EYTZINGER_BUG_ON(i == 0 || i > size);
 
 	if (eytzinger1_left_child(i) <= size) {
 		i = eytzinger1_left_child(i) + 1;
 
-		i <<= __fls(size + 1) - __fls(i);
+		i <<= __fls(size) - __fls(i);
 		i -= 1;
 		i >>= i > size;
 	} else {
diff --git a/fs/bcachefs/util.c b/fs/bcachefs/util.c
index a563d75ba72b..50a90e48f6dd 100644
--- a/fs/bcachefs/util.c
+++ b/fs/bcachefs/util.c
@@ -713,12 +713,6 @@ void eytzinger1_test(void)
 		if (!(size % 4096))
 			pr_info("tree size %u\n", size);
 
-		BUG_ON(eytzinger1_prev(0, size) != eytzinger1_last(size));
-		BUG_ON(eytzinger1_next(0, size) != eytzinger1_first(size));
-
-		BUG_ON(eytzinger1_prev(eytzinger1_first(size), size)	!= 0);
-		BUG_ON(eytzinger1_next(eytzinger1_last(size), size)	!= 0);
-
 		inorder = 1;
 		eytzinger1_for_each(eytz, size) {
 			BUG_ON(__inorder_to_eytzinger1(inorder, size, extra) != eytz);
@@ -747,12 +741,6 @@ void eytzinger0_test(void)
 		if (!(size % 4096))
 			pr_info("tree size %u\n", size);
 
-		BUG_ON(eytzinger0_prev(-1, size) != eytzinger0_last(size));
-		BUG_ON(eytzinger0_next(-1, size) != eytzinger0_first(size));
-
-		BUG_ON(eytzinger0_prev(eytzinger0_first(size), size)	!= -1);
-		BUG_ON(eytzinger0_next(eytzinger0_last(size), size)	!= -1);
-
 		inorder = 0;
 		eytzinger0_for_each(eytz, size) {
 			BUG_ON(__inorder_to_eytzinger0(inorder, size, extra) != eytz);
-- 
2.48.1


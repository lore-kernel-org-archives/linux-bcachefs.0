Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0142123DEBB
	for <linux-bcachefs@vger.kernel.org>; Sat,  8 Feb 2025 11:02:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739012529; cv=none; b=HfYFhLTVZuk15V6I/qySrqNY72nw3RzfENSCmNLAqCEFbw3nSSXQ5VBYI6Tofr1g2Pafw4waB2dewOx+/phKTr78C+pUL4J/RtfuuNsXGHIiz8dNIEJ1mWrl+b6QA8YGWT5xJUtlc7EXSre80aTEz+vIf5Yj+2SKjnwrcVz5y4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739012529; c=relaxed/simple;
	bh=1qnHtKga7wiZLv2r0wEYqpNM8ejWBcjuSfhhzJvx3+M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cSOq6SRNYN5sUHm3FWrpFXd5wM8Eev1p35x+9zLqNoXDUAQ7NQToFI0OcFMYO15W92lQOhcX+y5o76+8WH4zIMwO7huNpK8HCkCCVn4CDeFgeChweeUx44UbPb5DmaPlCqvo4VaHToGSPjynjYkTJPlwTaIIvJis5SdMxYV2CKU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=MPpbSlgu; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MPpbSlgu"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1739012527;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rHg4IVi824Y1rzmWwFz39+xMWr8oKERhBUrpc/HcTok=;
	b=MPpbSlguJkWpXbgBdCg/iVFX7ip3JJco7aWIkvQbCHf8ICSevjB7zKOejQZ6RuCNp38Xpy
	wk71qgo276xHRdUK0s6NXsufpiqjHMeVjI4S219lJ3ADmlMeMECA5Mb0ATq5dHN5UaoyB8
	DUVl5vbp+7pl3HNl/xrQ3ptcKRi1w1I=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-439-0qkQ7uhJO4KqNx5mOkZNWA-1; Sat,
 08 Feb 2025 06:02:03 -0500
X-MC-Unique: 0qkQ7uhJO4KqNx5mOkZNWA-1
X-Mimecast-MFC-AGG-ID: 0qkQ7uhJO4KqNx5mOkZNWA
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id ACDE51955D82;
	Sat,  8 Feb 2025 11:02:02 +0000 (UTC)
Received: from pasta.fast.eng.rdu2.dc.redhat.com (unknown [10.45.224.51])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 5C93230001AB;
	Sat,  8 Feb 2025 11:02:01 +0000 (UTC)
From: Andreas Gruenbacher <agruenba@redhat.com>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Andreas Gruenbacher <agruenba@redhat.com>,
	linux-bcachefs@vger.kernel.org
Subject: [PATCH v3 21/21] bcachefs: Run the eytzinger tests on modprobe
Date: Sat,  8 Feb 2025 12:01:18 +0100
Message-ID: <20250208110119.546961-22-agruenba@redhat.com>
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

FOR DEBUGGING ONLY -- DO NOT MERGE!

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
---
 fs/bcachefs/eytzinger.c | 12 +++---------
 fs/bcachefs/eytzinger.h |  4 ++++
 fs/bcachefs/super.c     |  5 +++++
 fs/bcachefs/util.c      |  2 +-
 fs/bcachefs/util.h      |  4 ++++
 5 files changed, 17 insertions(+), 10 deletions(-)

diff --git a/fs/bcachefs/eytzinger.c b/fs/bcachefs/eytzinger.c
index 0e742555cb0a..c76082b3e7ae 100644
--- a/fs/bcachefs/eytzinger.c
+++ b/fs/bcachefs/eytzinger.c
@@ -253,7 +253,7 @@ void eytzinger0_sort(void *base, size_t n, size_t size,
 	return eytzinger0_sort_r(base, n, size, _CMP_WRAPPER, SWAP_WRAPPER, &w);
 }
 
-#if 0
+#if 1
 #include <linux/slab.h>
 #include <linux/random.h>
 #include <linux/ktime.h>
@@ -274,7 +274,7 @@ static int mycmp(const void *a, const void *b)
 		return 0;
 }
 
-static int test(void)
+void eytzinger_sort_test(void)
 {
 	size_t N, i;
 	ktime_t start, end;
@@ -299,17 +299,11 @@ static int test(void)
 		u32 prev = 0;
 
 		eytzinger0_for_each(i, N) {
-			if (prev > arr[i])
-				goto err;
+			BUG_ON(prev > arr[i]);
 			prev = arr[i];
 		}
 
 		kfree(arr);
 	}
-	return 0;
-
-err:
-	kfree(arr);
-	return -1;
 }
 #endif
diff --git a/fs/bcachefs/eytzinger.h b/fs/bcachefs/eytzinger.h
index 643c1f716061..b5d3e55cd662 100644
--- a/fs/bcachefs/eytzinger.h
+++ b/fs/bcachefs/eytzinger.h
@@ -5,6 +5,8 @@
 #include <linux/bitops.h>
 #include <linux/log2.h>
 
+#define EYTZINGER_DEBUG
+
 #ifdef EYTZINGER_DEBUG
 #include <linux/bug.h>
 #define EYTZINGER_BUG_ON(cond)		BUG_ON(cond)
@@ -297,4 +299,6 @@ void eytzinger0_sort_r(void *, size_t, size_t,
 		       cmp_r_func_t, swap_r_func_t, const void *);
 void eytzinger0_sort(void *, size_t, size_t, cmp_func_t, swap_func_t);
 
+void eytzinger_sort_test(void);
+
 #endif /* _EYTZINGER_H */
diff --git a/fs/bcachefs/super.c b/fs/bcachefs/super.c
index a6ed9a0bf1c7..d8ad43fb48fc 100644
--- a/fs/bcachefs/super.c
+++ b/fs/bcachefs/super.c
@@ -2120,6 +2120,11 @@ static int __init bcachefs_init(void)
 {
 	bch2_bkey_pack_test();
 
+	eytzinger_sort_test();
+	eytzinger1_test();
+	eytzinger0_test();
+	eytzinger0_find_test();
+
 	if (!(bcachefs_kset = kset_create_and_add("bcachefs", NULL, fs_kobj)) ||
 	    bch2_btree_key_cache_init() ||
 	    bch2_chardev_init() ||
diff --git a/fs/bcachefs/util.c b/fs/bcachefs/util.c
index 50a90e48f6dd..7f8882117b54 100644
--- a/fs/bcachefs/util.c
+++ b/fs/bcachefs/util.c
@@ -698,7 +698,7 @@ void memcpy_from_bio(void *dst, struct bio *src, struct bvec_iter src_iter)
 	}
 }
 
-#if 0
+#if 1
 void eytzinger1_test(void)
 {
 	unsigned inorder, size;
diff --git a/fs/bcachefs/util.h b/fs/bcachefs/util.h
index fb02c1c36004..b963c523f5d7 100644
--- a/fs/bcachefs/util.h
+++ b/fs/bcachefs/util.h
@@ -696,4 +696,8 @@ static inline bool test_bit_le64(size_t bit, __le64 *addr)
 	return (addr[bit / 64] & cpu_to_le64(BIT_ULL(bit % 64))) != 0;
 }
 
+void eytzinger1_test(void);
+void eytzinger0_test(void);
+void eytzinger0_find_test(void);
+
 #endif /* _BCACHEFS_UTIL_H */
-- 
2.48.1


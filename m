Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00CC01DE2C7
	for <linux-bcachefs@vger.kernel.org>; Tue, 28 Jan 2025 16:39:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738082355; cv=none; b=AQuK0La6diDj5gRyNwntA9rNS+TsDRacLKCsvnsO0Gew2rwi+e73gAk6lHqIssxeIROPpQY5tjlXDzitLjW5g0cdlxLV9E0sZ2sJX31DAL8H/PYJ/KJhKPgAqZpuMXifFYTon4lIJIHc5CzAp41LTWvPGiVQWX1yroSWru4hKOk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738082355; c=relaxed/simple;
	bh=EgLfDuwKZsdfjpSLwn6zWm6ZYKMx3rY9kKTB7LFXIA4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QBolr7so8HOSPSNSD/Qg/obJpzQfHPSAxHW9mmM/YRHPOitb8uQvUjPaj8pud2y5dG7mKRVrxmuZHZxEMKRUrsummAwKpkxEEG2XCrQMTF2pGtJ73VIjjW9CTRzyw5h8GsynT7Rgrdv5ue5wXZ9f/CVLGP2l8ltI54mBvGoutwo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PnF9rUAe; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PnF9rUAe"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1738082352;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QGhonjcczzQ0bAfctgBIvgS7yZnG/z7g4mNrxvS9W2U=;
	b=PnF9rUAetPIF2ZTLcQ5y7SX4cAG6i/10fl2OTQslvkRaGHG4BAjWhyVjF2cYpBKogzRxct
	5wQisLQkxm3CyeahhXFbpvq43tHOOn8TIITt5Mq/NbSw3sn+HP84bSjh4XB4KKNEBSDIGA
	+I7zW0w9pOQNUICsyznMFMT2xTNxiU8=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-194-x5vRj3D9MKuCmGYjQ4d-OA-1; Tue,
 28 Jan 2025 11:39:11 -0500
X-MC-Unique: x5vRj3D9MKuCmGYjQ4d-OA-1
X-Mimecast-MFC-AGG-ID: x5vRj3D9MKuCmGYjQ4d-OA
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 727661800360;
	Tue, 28 Jan 2025 16:39:10 +0000 (UTC)
Received: from pasta.fast.eng.rdu2.dc.redhat.com (unknown [10.45.225.106])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 9D1D4180035E;
	Tue, 28 Jan 2025 16:39:08 +0000 (UTC)
From: Andreas Gruenbacher <agruenba@redhat.com>
To: Kent Overstreet <kent.overstreet@linux.dev>,
	Shuah Khan <shuah@kernel.org>
Cc: Andreas Gruenbacher <agruenba@redhat.com>,
	linux-bcachefs@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Subject: [PATCH 03/21] bcachefs: Run the eytzinger tests on modprobe
Date: Tue, 28 Jan 2025 17:38:40 +0100
Message-ID: <20250128163859.1883260-4-agruenba@redhat.com>
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
index c0fdfe909cf2..08549ab3c18e 100644
--- a/fs/bcachefs/eytzinger.c
+++ b/fs/bcachefs/eytzinger.c
@@ -242,7 +242,7 @@ void eytzinger0_sort(void *base, size_t n, size_t size,
 	return eytzinger0_sort_r(base, n, size, _CMP_WRAPPER, SWAP_WRAPPER, &w);
 }
 
-#if 0
+#if 1
 #include <linux/slab.h>
 #include <linux/random.h>
 #include <linux/ktime.h>
@@ -263,7 +263,7 @@ static int mycmp(const void *a, const void *b)
 		return 0;
 }
 
-static int test(void)
+void eytzinger_sort_test(void)
 {
 	size_t N, i;
 	ktime_t start, end;
@@ -288,17 +288,11 @@ static int test(void)
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
index 0541192d7bc0..16303908ccff 100644
--- a/fs/bcachefs/eytzinger.h
+++ b/fs/bcachefs/eytzinger.h
@@ -5,6 +5,8 @@
 #include <linux/bitops.h>
 #include <linux/log2.h>
 
+#define EYTZINGER_DEBUG
+
 #ifdef EYTZINGER_DEBUG
 #define EYTZINGER_BUG_ON(cond)		BUG_ON(cond)
 #else
@@ -316,4 +318,6 @@ void eytzinger0_sort_r(void *, size_t, size_t,
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
index e0a876cbaa6b..9a63d971ee65 100644
--- a/fs/bcachefs/util.c
+++ b/fs/bcachefs/util.c
@@ -698,7 +698,7 @@ void memcpy_from_bio(void *dst, struct bio *src, struct bvec_iter src_iter)
 	}
 }
 
-#if 0
+#if 1
 void eytzinger1_test(void)
 {
 	unsigned inorder, eytz, size;
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


Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 825DB14A4C6;
	Wed, 26 Mar 2025 15:26:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743002781; cv=none; b=g686PwssVT+RJuTVUevI+LpmA+6BdPL82pTq01fZg11TYhJtSE1th3ocgk0MYseIixa+On+oy0ZIxZLkjJE7cb+G9n0q5bSvguFrNCeWk1RP0y8SgviNGhoLNy8T2opQ/Q+Ub1fd3OiPdbpkMYxCK7QTpl8T/sFbqZsjdzVzuNY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743002781; c=relaxed/simple;
	bh=KcLx+LUsuQ+1FVIso4P5u4UhRImurn8WgvxTB/HPrz8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Vyh0ZJ5lTl9Hx+3iqDQMGl/N/vbclolNcf0A85j0pOCWT7b4ET54u2U8OLIC+EctIkX3s+rsdVscNZOyz7WvCUb9v1BM1rvDpRBBCyQANkzW++7TsHNF9aYm1uOZFLfDpcHAzyWljBuqzWwJpDgnmVbBcSS+pUDiZZcTljtdMV8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=fMKrbAZ9; arc=none smtp.client-ip=91.218.175.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="fMKrbAZ9"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1743002776;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=EZLo1jQQXln+Xf5Ba7tBgf55edk8Etnb6mTfw0jd+O0=;
	b=fMKrbAZ95CgFQx1idRLbepXmVc+5F+vVd/5nGzLidOuej04JwpEj0X7PHCYyIkPSakfpvt
	f1FAlskEJ+PoDpuNcerDcjYSN52EF2JAGwbuiHyVCiwAxmxLkVKMU2n8XUcy9xrd9jxj6b
	SEIB62cQDziFrnhiJRWaGCgve8x50Bw=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>,
	Kuan-Wei Chiu <visitorckw@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] lib/sort.c: Add _nonatomic() variants with cond_resched()
Date: Wed, 26 Mar 2025 11:26:06 -0400
Message-ID: <20250326152606.2594920-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Andrew - if you're ok with this patch I'd like to get it in soon as a
bugfix, I've been getting quite a few reports on this one.

I don't much care for the naming though, thoughts there?

-- >8 --

bcachefs calls sort() during recovery to sort all keys it found in the
journal, and this may be very large - gigabytes on large machines.

This has been causing "task blocked" warnings, so needs a
cond_resched().

Cc: Kuan-Wei Chiu <visitorckw@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 include/linux/sort.h | 11 +++++++++++
 lib/sort.c           | 46 +++++++++++++++++++++++++++++++++++++++-----
 2 files changed, 52 insertions(+), 5 deletions(-)

diff --git a/include/linux/sort.h b/include/linux/sort.h
index e163287ac6c1..8e5603b10941 100644
--- a/include/linux/sort.h
+++ b/include/linux/sort.h
@@ -13,4 +13,15 @@ void sort(void *base, size_t num, size_t size,
 	  cmp_func_t cmp_func,
 	  swap_func_t swap_func);
 
+/* Versions that periodically call cond_resched(): */
+
+void sort_r_nonatomic(void *base, size_t num, size_t size,
+		      cmp_r_func_t cmp_func,
+		      swap_r_func_t swap_func,
+		      const void *priv);
+
+void sort_nonatomic(void *base, size_t num, size_t size,
+		    cmp_func_t cmp_func,
+		    swap_func_t swap_func);
+
 #endif
diff --git a/lib/sort.c b/lib/sort.c
index 8e73dc55476b..60b51dac00ec 100644
--- a/lib/sort.c
+++ b/lib/sort.c
@@ -186,6 +186,8 @@ static size_t parent(size_t i, unsigned int lsbit, size_t size)
 	return i / 2;
 }
 
+#include <linux/sched.h>
+
 /**
  * sort_r - sort an array of elements
  * @base: pointer to data to sort
@@ -212,10 +214,11 @@ static size_t parent(size_t i, unsigned int lsbit, size_t size)
  * O(n*n) worst-case behavior and extra memory requirements that make
  * it less suitable for kernel use.
  */
-void sort_r(void *base, size_t num, size_t size,
-	    cmp_r_func_t cmp_func,
-	    swap_r_func_t swap_func,
-	    const void *priv)
+static void __sort_r(void *base, size_t num, size_t size,
+		     cmp_r_func_t cmp_func,
+		     swap_r_func_t swap_func,
+		     const void *priv,
+		     bool may_schedule)
 {
 	/* pre-scale counters for performance */
 	size_t n = num * size, a = (num/2) * size;
@@ -286,6 +289,9 @@ void sort_r(void *base, size_t num, size_t size,
 			b = parent(b, lsbit, size);
 			do_swap(base + b, base + c, size, swap_func, priv);
 		}
+
+		if (may_schedule)
+			cond_resched();
 	}
 
 	n -= size;
@@ -293,8 +299,25 @@ void sort_r(void *base, size_t num, size_t size,
 	if (n == size * 2 && do_cmp(base, base + size, cmp_func, priv) > 0)
 		do_swap(base, base + size, size, swap_func, priv);
 }
+
+void sort_r(void *base, size_t num, size_t size,
+	    cmp_r_func_t cmp_func,
+	    swap_r_func_t swap_func,
+	    const void *priv)
+{
+	__sort_r(base, num, size, cmp_func, swap_func, priv, false);
+}
 EXPORT_SYMBOL(sort_r);
 
+void sort_r_nonatomic(void *base, size_t num, size_t size,
+		      cmp_r_func_t cmp_func,
+		      swap_r_func_t swap_func,
+		      const void *priv)
+{
+	__sort_r(base, num, size, cmp_func, swap_func, priv, true);
+}
+EXPORT_SYMBOL(sort_r_nonatomic);
+
 void sort(void *base, size_t num, size_t size,
 	  cmp_func_t cmp_func,
 	  swap_func_t swap_func)
@@ -304,6 +327,19 @@ void sort(void *base, size_t num, size_t size,
 		.swap = swap_func,
 	};
 
-	return sort_r(base, num, size, _CMP_WRAPPER, SWAP_WRAPPER, &w);
+	return __sort_r(base, num, size, _CMP_WRAPPER, SWAP_WRAPPER, &w, false);
 }
 EXPORT_SYMBOL(sort);
+
+void sort_nonatomic(void *base, size_t num, size_t size,
+		    cmp_func_t cmp_func,
+		    swap_func_t swap_func)
+{
+	struct wrapper w = {
+		.cmp  = cmp_func,
+		.swap = swap_func,
+	};
+
+	return __sort_r(base, num, size, _CMP_WRAPPER, SWAP_WRAPPER, &w, true);
+}
+EXPORT_SYMBOL(sort_nonatomic);
-- 
2.49.0


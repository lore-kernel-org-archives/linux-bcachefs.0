Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A264422C6E7;
	Sat,  7 Dec 2024 12:53:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733575993; cv=none; b=RW9I4VnMvHqery/qYgJMDhNgDpOXldAacJcXk1FxhPyfXANpzJPRZGmQPdQgafMVgRE7RelN1eEId8nA+aBKyoNVIgwU9ph2KD9AEdzlHah6NVG2fWP1vv1Z0oUOgBnOFIIeLhPgJS43v103WZrGmzIN6XIe225RKDqOWTDVWWw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733575993; c=relaxed/simple;
	bh=4tRicKgihdN7vzankbrBgJlICBgc0A4MsUdOpS6Zyi4=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=rFWnQWA9VMvB/25sgmgB5lXUx5jBrQjczofllmvcS5KRWAtUbADvKMc7kRb9ccPKXlh5P9L3QyBR02n8cfZFy9tegL0ESPwTcmJiGCFEFA8XFHnaLybNwKls1S48lPBiAWVggIoCvc/2XSeEcqm/67OrZkkJwlpi8Ob/A6NxLPY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Tn7ow+TS; arc=none smtp.client-ip=209.85.210.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Tn7ow+TS"
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-7258ed68cedso2981821b3a.1;
        Sat, 07 Dec 2024 04:53:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1733575991; x=1734180791; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=gpUxiu0t8qgQqyKloRPNPfmECQPMznPWyKHpW180u4Y=;
        b=Tn7ow+TS4BoFgVYe5lVtC1d2HuHF65+8UoNUtXhlVcSJG4+DpSoTyNjDvJ59mbUlXj
         ShCS7jPrn5qEgfYIj6sf0QPX778FMbx7Gw3BbTqEpLcYye+HjiqMLSftJ5eN0/Qyl7MY
         GbJjbVG6B+Wqa8JCgs03wrpDe/UwEx+kXAQ6U+OY8jAXsxKp1nLP+/zOhgPQvhI7vf47
         TybWFvJnsFatwJv9iU5zSocgK9b6Mt8gUi9dHotdge9xcFsoIyehVTl02icAybLK8mUt
         rqcSlp7KllAS/8AbS6Jz3r3vK+t/tCGafFyT6i9ho40yqzoq5Ua7BfJrekuT6+DV1bBZ
         gJOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733575991; x=1734180791;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gpUxiu0t8qgQqyKloRPNPfmECQPMznPWyKHpW180u4Y=;
        b=lRPguco6lJdUlEboQbyw6WCaWJ+naRresh5sKAOWd7WMrQeWaYnupyorWr70UJECHk
         vl6IW2pbqWQa7l4D9jNdJZc0CNn/k7Dnrsq1iXwkTK90iYu/4CxVfbrlURpzzwLPDQyF
         LmGjeOPqzsbcQMe9Pd6g+yN2o64OT/Xfzm0PSPZSiQJy7CDE/f6M1GSNLZA0Hm7lTWL8
         d3fOWvrurVKzlekWZOELnXlzpaXzEfvpfV4k3dPImPFSD/gav6qa0de2enyeISiwnIqx
         FdsUdCFWPHUVVFH5dK7jxqNar5WnMGKd8oyq2Za9+9e3lvATqsGhK9QU2+8rYT7SfI4C
         b9ug==
X-Forwarded-Encrypted: i=1; AJvYcCUC/xfDlujMFyHLunORDxIWT+H2CvnVDg7WLeUQsKRtfF0WYPAZWITFWI8y2ACDS0rEitBT1CfZVGkzqjmNmg==@vger.kernel.org, AJvYcCXcEILD4KatzVK8xmUkm4jHJwUeHdO7zV+M7R7HRdjG+Hc6TZhMIliTZ9tfpqQCQKFW6PmlJDaGf3LaIIgL@vger.kernel.org
X-Gm-Message-State: AOJu0YybwtfU0D6QLANLYO25PxGxUj2HENNs7w2BrfTiZOxnJZmRAaMH
	DajELU/LMqtxKqGCWt2GzbLtYgvdIuEwCg7ovz/+4u1vUHRKjdyK
X-Gm-Gg: ASbGncv9AUHbU7s5BwKFGkBMqBWchlKXqQjcntiokggYUjcbe/IvaVh61dnIXVs0VKX
	Ocv7g0ilZ77KpqDG8C4D+WUL+elyA1vVMoNCiybyRZh7SMvenElNY9jZMvcgpbkr9PXonn+gIqH
	YZ0nlXiLdSM18L41QnLnmvRgAzjKs9ISRAmLL0S8JxPPJAUGu6RadRAdqzFUPf8XjjsvjPFzSOV
	17oPx0whrbiIjOyHNTtajokOweb/8iuJBGAbzgN0oofQ6nXHmkk0OhtqeeHMNICxPIW0WnTgp8N
	LsIB
X-Google-Smtp-Source: AGHT+IF1a6fuobjwEFnwh8GLrlVY+56BcUkwpkbJYzrt8ZkhDKaPiuNuFCOw1qqp7VuZbikK5+IT6w==
X-Received: by 2002:a05:6a00:9292:b0:71e:6b8:2f4a with SMTP id d2e1a72fcca58-725b813e32dmr11187391b3a.12.1733575990968;
        Sat, 07 Dec 2024 04:53:10 -0800 (PST)
Received: from visitorckw-System-Product-Name.. ([140.113.216.168])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-725def37e0asm120509b3a.193.2024.12.07.04.53.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Dec 2024 04:53:10 -0800 (PST)
From: Kuan-Wei Chiu <visitorckw@gmail.com>
To: kent.overstreet@linux.dev
Cc: irogers@google.com,
	colyli@suse.de,
	peterz@infradead.org,
	akpm@linux-foundation.org,
	jserv@ccns.ncku.edu.tw,
	linux-bcachefs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Kuan-Wei Chiu <visitorckw@gmail.com>
Subject: [PATCH] lib min_heap: Use size_t for array size and index variables
Date: Sat,  7 Dec 2024 20:53:05 +0800
Message-Id: <20241207125305.1849876-1-visitorckw@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Replace the int type with size_t for variables representing array sizes
and indices in the min-heap implementation. Using size_t aligns with
standard practices for size-related variables and avoids potential
issues on platforms where int may be insufficient to represent all
valid sizes or indices.

Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
---
Note: This patch is expected to go through the bcachefs tree after the
size field in the min heap struct is changed to size_t.

 include/linux/min_heap.h | 12 ++++++------
 lib/min_heap.c           |  4 ++--
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/include/linux/min_heap.h b/include/linux/min_heap.h
index 6325f6ffb895..9b94df4f5981 100644
--- a/include/linux/min_heap.h
+++ b/include/linux/min_heap.h
@@ -207,7 +207,7 @@ static size_t parent(size_t i, unsigned int lsbit, size_t size)
 
 /* Initialize a min-heap. */
 static __always_inline
-void __min_heap_init_inline(min_heap_char *heap, void *data, int size)
+void __min_heap_init_inline(min_heap_char *heap, void *data, size_t size)
 {
 	heap->nr = 0;
 	heap->size = size;
@@ -242,7 +242,7 @@ bool __min_heap_full_inline(min_heap_char *heap)
 
 /* Sift the element at pos down the heap. */
 static __always_inline
-void __min_heap_sift_down_inline(min_heap_char *heap, int pos, size_t elem_size,
+void __min_heap_sift_down_inline(min_heap_char *heap, size_t pos, size_t elem_size,
 				 const struct min_heap_callbacks *func, void *args)
 {
 	const unsigned long lsbit = elem_size & -elem_size;
@@ -312,7 +312,7 @@ static __always_inline
 void __min_heapify_all_inline(min_heap_char *heap, size_t elem_size,
 			      const struct min_heap_callbacks *func, void *args)
 {
-	int i;
+	ssize_t i;
 
 	for (i = heap->nr / 2 - 1; i >= 0; i--)
 		__min_heap_sift_down_inline(heap, i, elem_size, func, args);
@@ -365,7 +365,7 @@ bool __min_heap_push_inline(min_heap_char *heap, const void *element, size_t ele
 			    const struct min_heap_callbacks *func, void *args)
 {
 	void *data = heap->data;
-	int pos;
+	size_t pos;
 
 	if (WARN_ONCE(heap->nr >= heap->size, "Pushing on a full heap"))
 		return false;
@@ -414,10 +414,10 @@ bool __min_heap_del_inline(min_heap_char *heap, size_t elem_size, size_t idx,
 	__min_heap_del_inline((min_heap_char *)_heap, __minheap_obj_size(_heap), _idx,	\
 			      _func, _args)
 
-void __min_heap_init(min_heap_char *heap, void *data, int size);
+void __min_heap_init(min_heap_char *heap, void *data, size_t size);
 void *__min_heap_peek(struct min_heap_char *heap);
 bool __min_heap_full(min_heap_char *heap);
-void __min_heap_sift_down(min_heap_char *heap, int pos, size_t elem_size,
+void __min_heap_sift_down(min_heap_char *heap, size_t pos, size_t elem_size,
 			  const struct min_heap_callbacks *func, void *args);
 void __min_heap_sift_up(min_heap_char *heap, size_t elem_size, size_t idx,
 			const struct min_heap_callbacks *func, void *args);
diff --git a/lib/min_heap.c b/lib/min_heap.c
index 4485372ff3b1..96f01a4c5fb6 100644
--- a/lib/min_heap.c
+++ b/lib/min_heap.c
@@ -2,7 +2,7 @@
 #include <linux/export.h>
 #include <linux/min_heap.h>
 
-void __min_heap_init(min_heap_char *heap, void *data, int size)
+void __min_heap_init(min_heap_char *heap, void *data, size_t size)
 {
 	__min_heap_init_inline(heap, data, size);
 }
@@ -20,7 +20,7 @@ bool __min_heap_full(min_heap_char *heap)
 }
 EXPORT_SYMBOL(__min_heap_full);
 
-void __min_heap_sift_down(min_heap_char *heap, int pos, size_t elem_size,
+void __min_heap_sift_down(min_heap_char *heap, size_t pos, size_t elem_size,
 			  const struct min_heap_callbacks *func, void *args)
 {
 	__min_heap_sift_down_inline(heap, pos, elem_size, func, args);
-- 
2.34.1


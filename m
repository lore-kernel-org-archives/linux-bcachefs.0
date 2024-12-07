Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EF351DDEA;
	Sat,  7 Dec 2024 13:19:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733577597; cv=none; b=bTJidv/C8UjztmQgVAUvAOTOE8EoD6t0OVoM9x7TCw0RL3BbxVs2OoEnk7WguWgncxJzbUCUMPjhGw32x2bw1Ijsz6sQ1l6cyv8w+5XBNRt4CT+GC7cBUaVAwXNl/caJlWIwfRKDeaX54Ru4GlIumQULx7/SfYeW0hdwKaUQLyQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733577597; c=relaxed/simple;
	bh=iuCsw+WfqbPsOmS1nJ9WB0REkyl0evY9QKZWW0MOJbs=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=oS0Hn/AfodsSy6GRoO0aJKG0uTELJN1v9rhudqQdw9kO+RHNYddSviLR2unOvayuvLA8euyg6cv0xu88KBgZlengAX7bOl+tVSn529Va4JafuMQzGInZ1WOTGk50memCDl9ykK2VreHw5t2oPHytsvWynM+cdnaYpCvS0vUvp6A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QrkSBdZF; arc=none smtp.client-ip=209.85.216.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QrkSBdZF"
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-2ef89dbd8eeso287178a91.0;
        Sat, 07 Dec 2024 05:19:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1733577595; x=1734182395; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=FDBZpTvNiR/DiXDOnPKbSZlVKfo3SdqCEnbL2Ljivn8=;
        b=QrkSBdZFyiPQYKcy/2tSvjvH7JICNEjNPTT9AV3M5uY6p9WbyncSuZ/e0mTs9WcP0o
         0dvje5ZorfH3v6juRw36qZnKb3goJ0J/CzMIaGJgmNaJ7bdGhhUP1mkSW/BCVbM8xpbD
         Si4WBVeV3jrB1MKYzDGECTb6JGgaClNszuxIpB67EfqT+5B1+WAzJO4cUCGu6pgr1oc/
         koN15mKFd6puEBKBWfwPXk/QQN0qLFXltDGJFwtOr1ZWiSJZe4FyPQ8nEpEOHOlj2PVx
         CAco7ThOGN+uLnb5Fx5jQ3PhxMXUKUKUhtl6p0rvD5az6zWeDjADr/Cu4Kr06zBzeKsM
         0xcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733577595; x=1734182395;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FDBZpTvNiR/DiXDOnPKbSZlVKfo3SdqCEnbL2Ljivn8=;
        b=d0krr/OBKv+VLxFO+ZwtWJ3OZAMsrSe2q5SC18G+mwY9MCrGdeYXhEfdt6VR5gmYTM
         oKf0BoLabvW0NYCESY1BcfK0RkzGVWgcbfWqMs6LbXN6PKKkiOBhSQfqDPZbK/snRrrE
         EzSaueyF/xw2PdP5Odo8Spsc6CM9UK0tJFUfz6m+BPqK7ajTZhWusy58Z+PviQECsyFK
         AlEhjN43URsuUoqs5ThLmfths+XkosIW1b4+O0dqNj+Q8YGtarNUUBz3j2yPPoMHSGn+
         SqY+XNT4EJPLIrxAa2iqPfgJ8IpHXH+sYkwvx701srk04tti3vkw/ZFi+gRRQlZgqFmU
         +Xag==
X-Forwarded-Encrypted: i=1; AJvYcCU9t39QXdFPdhwgTms0iVYnaYMAjM52d+goKitsT3QnoIjrKuhm/KdGeoltjH1/NNDUMVbbzUujj1uMJPXjLw==@vger.kernel.org, AJvYcCVkm54UKp/3rB+8WNHDKLOLrsj7Ac0Rh+uyXXm/HklQ22h83AQIjw3OiZfnKGbVONmoews+ZtUwWrDT2Y3b@vger.kernel.org
X-Gm-Message-State: AOJu0YwkbElgbbDjwZIp5ECkuY6v3KVybby5pnSmfHEyBcIgLtPJkzzT
	1EkCgnfefbcFB8/YvDecMTgUm0Q0tfvCRjCzPF5hap/d7WTKOJMD
X-Gm-Gg: ASbGncuUSvy4d0cscsB5Zg+heAbAmk8RRVi1tDG5upOB6a/9S3Jba2NLCOsCLJmLfOG
	YNabC224CK0LP27exL1wFGsFnuc3s79BLo41oQRfZX5YIoKrMg/2uyFgKyxCGi6Cdp/U+DFj/Q0
	TZ4RnnzRHLhllQFPKi+oV8f4KjNxON5ZdK1tn0KvmrOTPR8rhKM1PNHg80PeXjWilYycN7tJ/ZY
	B7eVw1wSyjFGPOsM7QpN6YgF2kdoX+NjXBjElGfjI62kuKbPxxJ4s2baYGyeqyNmG9azpkQN0Ah
	/1Bt
X-Google-Smtp-Source: AGHT+IHf3PzcsFhRJwfL8oUaq3bTjI83mlsZWslYAeGnBswT9OCvEzi2Bb0eQ6J6qn9bWsP8uV/IwA==
X-Received: by 2002:a17:90b:3d4c:b0:2ee:a58d:cd8b with SMTP id 98e67ed59e1d1-2ef6a6c11a6mr8754864a91.18.1733577594826;
        Sat, 07 Dec 2024 05:19:54 -0800 (PST)
Received: from visitorckw-System-Product-Name.. ([140.113.216.168])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2ef94b62561sm120716a91.1.2024.12.07.05.19.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Dec 2024 05:19:54 -0800 (PST)
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
Subject: [PATCH] lib min_heap: Add min_heap_empty()
Date: Sat,  7 Dec 2024 21:19:48 +0800
Message-Id: <20241207131948.1881301-1-visitorckw@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add min_heap_empty() which returns a boolean value indicating whether
the heap is empty.

Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
---
Hi Kent,  
If you plan to use min_heap_empty(), feel free to take this patch.

 include/linux/min_heap.h | 13 +++++++++++++
 lib/min_heap.c           |  6 ++++++
 2 files changed, 19 insertions(+)

diff --git a/include/linux/min_heap.h b/include/linux/min_heap.h
index e781727c8916..bba01453c522 100644
--- a/include/linux/min_heap.h
+++ b/include/linux/min_heap.h
@@ -240,6 +240,16 @@ bool __min_heap_full_inline(min_heap_char *heap)
 #define min_heap_full_inline(_heap)	\
 	__min_heap_full_inline((min_heap_char *)_heap)
 
+/* Check if the heap is empty. */
+static __always_inline
+bool __min_heap_empty_inline(min_heap_char *heap)
+{
+	return !heap->nr;
+}
+
+#define min_heap_empty_inline(_heap)	\
+	__min_heap_empty_inline(container_of(&(_heap)->nr))
+
 /* Sift the element at pos down the heap. */
 static __always_inline
 void __min_heap_sift_down_inline(min_heap_char *heap, int pos, size_t elem_size,
@@ -417,6 +427,7 @@ bool __min_heap_del_inline(min_heap_char *heap, size_t elem_size, size_t idx,
 void __min_heap_init(min_heap_char *heap, void *data, int size);
 void *__min_heap_peek(struct min_heap_char *heap);
 bool __min_heap_full(min_heap_char *heap);
+bool __min_heap_empty(min_heap_char *heap);
 void __min_heap_sift_down(min_heap_char *heap, int pos, size_t elem_size,
 			  const struct min_heap_callbacks *func, void *args);
 void __min_heap_sift_up(min_heap_char *heap, size_t elem_size, size_t idx,
@@ -438,6 +449,8 @@ bool __min_heap_del(min_heap_char *heap, size_t elem_size, size_t idx,
 	(__minheap_cast(_heap) __min_heap_peek((min_heap_char *)_heap))
 #define min_heap_full(_heap)	\
 	__min_heap_full((min_heap_char *)_heap)
+#define min_heap_empty(_heap)	\
+	__min_heap_empty(container_of(&(_heap)->nr))
 #define min_heap_sift_down(_heap, _pos, _func, _args)	\
 	__min_heap_sift_down((min_heap_char *)_heap, _pos, __minheap_obj_size(_heap), _func, _args)
 #define min_heap_sift_up(_heap, _idx, _func, _args)	\
diff --git a/lib/min_heap.c b/lib/min_heap.c
index 4485372ff3b1..f546cd110cea 100644
--- a/lib/min_heap.c
+++ b/lib/min_heap.c
@@ -20,6 +20,12 @@ bool __min_heap_full(min_heap_char *heap)
 }
 EXPORT_SYMBOL(__min_heap_full);
 
+bool __min_heap_empty(min_heap_char *heap)
+{
+	return __min_heap_empty_inline(heap);
+}
+EXPORT_SYMBOL(__min_heap_empty);
+
 void __min_heap_sift_down(min_heap_char *heap, int pos, size_t elem_size,
 			  const struct min_heap_callbacks *func, void *args)
 {
-- 
2.34.1


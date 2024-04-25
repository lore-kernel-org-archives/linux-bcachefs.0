Received: from mout01.posteo.de (mout01.posteo.de [185.67.36.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA46F5B201
	for <linux-bcachefs@vger.kernel.org>; Thu, 25 Apr 2024 13:50:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.67.36.65
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714053053; cv=none; b=t5iGAVMCCStevVSr0Z3tzChVdvnhGoS2rzUowK/gXG//LyGRHoYf8tRLDl+3KDicTbK2NPvHMYhWlmS0ELmzezZW89vr/v5xpmAP/DyJCWdwpfk2SQbDRdRyCb0QEewCJa9VukAgxzVbvyMBGQNz2VCekWQ/YPgKPK303PATlfA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714053053; c=relaxed/simple;
	bh=IjETUOGC1m/Z2gGBfqx+o3NlaNR4nYw7A9zXnI7rOPo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Q9p1JgpyBN0iJ8qkswr8pTVzk1yMggQlW1cyU7eeqbYrwaAd3QhT7w8lLl4TkyaLhIX+GWnBAQ0ntHl04nIcyLuaKHdxF/rWThFZToh01SZyiZ5t1bb+kqb+Dx98hT3LN1jBs+anqjIvFKSB4plhweQLGnjVCM6etRUKsUYxo98=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=posteo.net; spf=pass smtp.mailfrom=posteo.net; dkim=pass (2048-bit key) header.d=posteo.net header.i=@posteo.net header.b=js9bruY8; arc=none smtp.client-ip=185.67.36.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=posteo.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=posteo.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=posteo.net header.i=@posteo.net header.b="js9bruY8"
Received: from submission (posteo.de [185.67.36.169]) 
	by mout01.posteo.de (Postfix) with ESMTPS id 456B4240028
	for <linux-bcachefs@vger.kernel.org>; Thu, 25 Apr 2024 15:50:47 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=posteo.net; s=2017;
	t=1714053047; bh=IjETUOGC1m/Z2gGBfqx+o3NlaNR4nYw7A9zXnI7rOPo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:
	 Content-Transfer-Encoding:From;
	b=js9bruY8VA/lX0AnFVJdpz5pJ29U4DqnxxNARiV1i+rP6dY2zIqid2nU0qlFEWRlW
	 xsJJnfNrKGmy/aT1OPLSPjanxYojBpd09XeStnuIASf9cM84eoYokRyY1mtAhWYNS8
	 sJLA2FEikjT9d3RauUaq+80hxh+HGwfcAo5jUMVPjtIO5i/kPiqwWjBdplJKoQQGFS
	 wOcXAfa+s/DFVK0aNwu0tYRK3TuIdJ9Q87uRCWCUdFaBRdfiZQnZHuDyk4Gv7ZxaVF
	 baWKDk/aZ5lHvwA7QBVM1loVOfNumSUJRVt7JSd7r1cVM4qX0AE7G4Ue/oVCGlbxDQ
	 n2n++Cmw9YRYA==
Received: from customer (localhost [127.0.0.1])
	by submission (posteo.de) with ESMTPSA id 4VQHLZ0pK4z6tvd;
	Thu, 25 Apr 2024 15:50:45 +0200 (CEST)
From: Christopher Fore <csfore@posteo.net>
To: linux-bcachefs@vger.kernel.org
Cc: erhard_f@mailbox.org,
	Christopher Fore <csfore@posteo.net>
Subject: [PATCH] bcachefs-tools: Fix compilation on musl libc
Date: Thu, 25 Apr 2024 13:50:33 +0000
Message-ID: <20240425135033.1163353-1-csfore@posteo.net>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Currently there is not a __attribute_const__ defined anywhere in
linux/sort.c, which results in compilation failure on musl libc
systems. The compiler also does not necessarily guarantee the macro
and has only worked on glibc because of possible leakage from the
header, sys/cdefs.h, which just happened to define __attribute_const__
in the same way that bcachefs-tools defines it. linux/compiler.h has
also been included in files that use __attribute_const__ or
__always_inline without explicit including for futureproofing.

This was narrowed down as the cause by noting that linux/compiler.h is
not included anywhere in linux/sort.c, yet it was compiling
successfully on glibc. Then, the preprocessor definitions were printed
out using the gcc args: -E -dM.

To view the difference, the command:
$ gcc -I./include -E -dM linux/sort.c

on glibc and musl systems will reveal the discrepancy.

Expected output:
#define __attribute_const__ __attribute__ ((__const__))

On musl there is no output.

Closes: https://github.com/koverstreet/bcachefs-tools/issues/248
Signed-off-by: Christopher Fore <csfore@posteo.net>
---
 libbcachefs/bkey.h         | 1 +
 libbcachefs/bset.c         | 1 +
 libbcachefs/btree_iter.h   | 1 +
 libbcachefs/eytzinger.c    | 1 +
 libbcachefs/fs-io-direct.c | 1 +
 libbcachefs/six.c          | 1 +
 libbcachefs/str_hash.h     | 1 +
 libbcachefs/subvolume.c    | 1 +
 linux/mempool.c            | 1 +
 linux/sort.c               | 1 +
 10 files changed, 10 insertions(+)

diff --git a/libbcachefs/bkey.h b/libbcachefs/bkey.h
index 3a45d12..d30d501 100644
--- a/libbcachefs/bkey.h
+++ b/libbcachefs/bkey.h
@@ -3,6 +3,7 @@
 #define _BCACHEFS_BKEY_H
 
 #include <linux/bug.h>
+#include <linux/compiler.h>
 #include "bcachefs_format.h"
 #include "bkey_types.h"
 #include "btree_types.h"
diff --git a/libbcachefs/bset.c b/libbcachefs/bset.c
index 3bb4778..7d6b57f 100644
--- a/libbcachefs/bset.c
+++ b/libbcachefs/bset.c
@@ -17,6 +17,7 @@
 #include <linux/console.h>
 #include <linux/random.h>
 #include <linux/prefetch.h>
+#include <linux/compiler.h>
 
 static inline void __bch2_btree_node_iter_advance(struct btree_node_iter *,
 						  struct btree *);
diff --git a/libbcachefs/btree_iter.h b/libbcachefs/btree_iter.h
index 1c70836..c4376c7 100644
--- a/libbcachefs/btree_iter.h
+++ b/libbcachefs/btree_iter.h
@@ -2,6 +2,7 @@
 #ifndef _BCACHEFS_BTREE_ITER_H
 #define _BCACHEFS_BTREE_ITER_H
 
+#include <linux/compiler.h>
 #include "bset.h"
 #include "btree_types.h"
 #include "trace.h"
diff --git a/libbcachefs/eytzinger.c b/libbcachefs/eytzinger.c
index 0f955c3..49c2069 100644
--- a/libbcachefs/eytzinger.c
+++ b/libbcachefs/eytzinger.c
@@ -1,5 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0
 
+#include <linux/compiler.h>
 #include "eytzinger.h"
 
 /**
diff --git a/libbcachefs/fs-io-direct.c b/libbcachefs/fs-io-direct.c
index b889370..e6598f0 100644
--- a/libbcachefs/fs-io-direct.c
+++ b/libbcachefs/fs-io-direct.c
@@ -14,6 +14,7 @@
 #include <linux/pagemap.h>
 #include <linux/prefetch.h>
 #include <linux/task_io_accounting_ops.h>
+#include <linux/compiler.h>
 
 /* O_DIRECT reads */
 
diff --git a/libbcachefs/six.c b/libbcachefs/six.c
index 3a494c5..a99f365 100644
--- a/libbcachefs/six.c
+++ b/libbcachefs/six.c
@@ -1,5 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0
 
+#include <linux/compiler.h>
 #include <linux/export.h>
 #include <linux/log2.h>
 #include <linux/percpu.h>
diff --git a/libbcachefs/str_hash.h b/libbcachefs/str_hash.h
index 3976f80..ed467d9 100644
--- a/libbcachefs/str_hash.h
+++ b/libbcachefs/str_hash.h
@@ -12,6 +12,7 @@
 #include "super.h"
 
 #include <linux/crc32c.h>
+#include <linux/compiler.h>
 #include <crypto/hash.h>
 #include <crypto/sha2.h>
 
diff --git a/libbcachefs/subvolume.c b/libbcachefs/subvolume.c
index 88a79c8..8312d96 100644
--- a/libbcachefs/subvolume.c
+++ b/libbcachefs/subvolume.c
@@ -10,6 +10,7 @@
 #include "subvolume.h"
 
 #include <linux/random.h>
+#include <linux/compiler.h>
 
 static int bch2_subvolume_delete(struct btree_trans *, u32);
 
diff --git a/linux/mempool.c b/linux/mempool.c
index 74ed17b..5b71f77 100644
--- a/linux/mempool.c
+++ b/linux/mempool.c
@@ -18,6 +18,7 @@
 #include <linux/mempool.h>
 #include <linux/mempool.h>
 #include <linux/sched.h>
+#include <linux/compiler.h>
 
 #if defined(CONFIG_DEBUG_SLAB) || defined(CONFIG_SLUB_DEBUG_ON)
 static void poison_error(mempool_t *pool, void *element, size_t size,
diff --git a/linux/sort.c b/linux/sort.c
index ecce71c..3d4ee41 100644
--- a/linux/sort.c
+++ b/linux/sort.c
@@ -15,6 +15,7 @@
 #include <linux/types.h>
 #include <linux/export.h>
 #include <linux/sort.h>
+#include <linux/compiler.h>
 
 /**
  * is_aligned - is this pointer & size okay for word-wide copying?
-- 
2.44.0


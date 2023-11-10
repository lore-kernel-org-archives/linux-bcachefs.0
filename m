Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4E5B38FAB
	for <linux-bcachefs@vger.kernel.org>; Fri, 10 Nov 2023 16:32:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="O2RLCYqS"
Received: from out-176.mta0.migadu.com (out-176.mta0.migadu.com [IPv6:2001:41d0:1004:224b::b0])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E46BC3EB05
	for <linux-bcachefs@vger.kernel.org>; Fri, 10 Nov 2023 08:32:14 -0800 (PST)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1699633933;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=w4nKHsS57kUpIuCKMwPlcJtkDtpncMSTh8A8FCn6cmU=;
	b=O2RLCYqSjw0qbGgFc7KabcKi85GP0hUoYaE7As+79X95q3LRbAH+HD53Qh87q8hpdWjQ+7
	IBP35Y9w8F4LayC1S0K52eG1EJ8NZN80G/xwXDjwy7r/MhKl4HVFAT8fBAufK/2NANVRhe
	QSzge66Dqr/62tW6t5Jg9L5POIQi3YU=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 17/17] bcachefs: Inline btree write buffer sort
Date: Fri, 10 Nov 2023 11:31:54 -0500
Message-ID: <20231110163157.2736111-18-kent.overstreet@linux.dev>
In-Reply-To: <20231110163157.2736111-1-kent.overstreet@linux.dev>
References: <20231110163157.2736111-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

The sort in the btree write buffer flush path is a very hot path, and
it's particularly performance sensitive since it's single threaded and
can block every other thread on a multithreaded write workload.

It's well worth doing a sort with inlined cmp and swap functions.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/btree_write_buffer.c | 57 +++++++++++++++++++++++++++-----
 1 file changed, 48 insertions(+), 9 deletions(-)

diff --git a/fs/bcachefs/btree_write_buffer.c b/fs/bcachefs/btree_write_buffer.c
index e961cf33db1e..e482bbb767e6 100644
--- a/fs/bcachefs/btree_write_buffer.c
+++ b/fs/bcachefs/btree_write_buffer.c
@@ -10,23 +10,64 @@
 #include "journal_io.h"
 #include "journal_reclaim.h"
 
-#include <linux/sort.h>
-
 static int bch2_btree_write_buffer_journal_flush(struct journal *,
 				struct journal_entry_pin *, u64);
 
 static int bch2_journal_keys_to_write_buffer(struct bch_fs *, struct journal_buf *);
 
-static inline int wb_key_cmp(const void *_l, const void *_r)
+static inline int wb_key_cmp(struct btree_write_buffered_key_ref *l,
+			     struct btree_write_buffered_key_ref *r)
 {
-	const struct btree_write_buffered_key_ref *l = _l;
-	const struct btree_write_buffered_key_ref *r = _r;
-
 	return  cmp_int(l->btree, r->btree) ?:
 		bpos_cmp(l->pos, r->pos) ?:
 		cmp_int(l->idx, r->idx);
 }
 
+static void wb_sort(struct btree_write_buffered_key_ref *base, size_t num)
+{
+	size_t n = num, a = num / 2;
+
+	if (!a)		/* num < 2 || size == 0 */
+		return;
+
+	for (;;) {
+		size_t b, c, d;
+
+		if (a)			/* Building heap: sift down --a */
+			--a;
+		else if (--n)		/* Sorting: Extract root to --n */
+			swap(base[0], base[n]);
+		else			/* Sort complete */
+			break;
+
+		/*
+		 * Sift element at "a" down into heap.  This is the
+		 * "bottom-up" variant, which significantly reduces
+		 * calls to cmp_func(): we find the sift-down path all
+		 * the way to the leaves (one compare per level), then
+		 * backtrack to find where to insert the target element.
+		 *
+		 * Because elements tend to sift down close to the leaves,
+		 * this uses fewer compares than doing two per level
+		 * on the way down.  (A bit more than half as many on
+		 * average, 3/4 worst-case.)
+		 */
+		for (b = a; c = 2*b + 1, (d = c + 1) < n;)
+			b = wb_key_cmp(base + c, base + d) >= 0 ? c : d;
+		if (d == n)		/* Special case last leaf with no sibling */
+			b = c;
+
+		/* Now backtrack from "b" to the correct location for "a" */
+		while (b != a && wb_key_cmp(base + a, base + b) >= 0)
+			b = (b - 1) / 2;
+		c = b;			/* Where "a" belongs */
+		while (b != a) {	/* Shift it into place */
+			b = (b - 1) / 2;
+			swap(base[b], base[c]);
+		}
+	}
+}
+
 static noinline int wb_flush_one_slowpath(struct btree_trans *trans,
 					  struct btree_iter *iter,
 					  struct btree_write_buffered_key *wb)
@@ -202,9 +243,7 @@ static int bch2_btree_write_buffer_flush_locked(struct btree_trans *trans)
 	 * If that happens, simply skip the key so we can optimistically insert
 	 * as many keys as possible in the fast path.
 	 */
-	sort(wb->sorted.data, wb->sorted.nr,
-	     sizeof(wb->sorted.data[0]),
-	     wb_key_cmp, NULL);
+	wb_sort(wb->sorted.data, wb->sorted.nr);
 
 	darray_for_each(wb->sorted, i) {
 		struct btree_write_buffered_key *k = &wb->flushing.keys.data[i->idx];
-- 
2.42.0


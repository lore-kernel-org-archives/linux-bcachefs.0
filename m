Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBCBC13B5BE
	for <linux-bcachefs@vger.kernel.org>; Fri, 19 Apr 2024 18:13:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713550424; cv=none; b=YG8o23k/vY5hZDDGOTLMGvh6hSfrEcIGc8SFk0GgMYh6ReTUc9fZQ/HAlGmtPhT2homFipciXvUiZ/MoKjwFkJM48Z4YUMn/M9Iix7hx7syWXsxgQfcTTeEsKQLhvYwnDrqBqpGY1efP4xjSLGntCXnN/0kHs1LZBYN0V1B3EUA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713550424; c=relaxed/simple;
	bh=5N+FwecE5Dzd6EYjF5GlkqLezJ7ow8PL7yPksoRoSg0=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=o9Llb++DGO5vsbkBYbOOPzYySR70EObf87nyj/WkBLsE3f0bVHrE0XlEmumsNVIdF7R19t3OI2t+uJd+a6xIlTZVIHpTbpOYrIM2sn32IcR6j3Q45A87Eh+CAueIgXwNrwnf7QDFF+pkHA0iRhvuRtDd7DnJjfKMe9UgV0XPX9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=GDPwe8Xd; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GDPwe8Xd"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1713550422;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GbftPYD/rGWdmyI2Tj4bzh2tJAX9pULHMPHd85c8ges=;
	b=GDPwe8XdxKseueRUX0nSzMOuTNnuBUpQFNm9m448LKmQlnmm+wJSvL39RhVOaDmA5LOtul
	Yw2mtJHsCkReZIfApGgU45qamRhNEvr3FyV8ERwfah4Bqegq1L67x+rykrnRmN3ejtHv3l
	nVy7vjClm2bBnJVKqzysbFzOIHuoWac=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-622-z7mOQXwcPcizXxkLVZsnAQ-1; Fri, 19 Apr 2024 14:13:40 -0400
X-MC-Unique: z7mOQXwcPcizXxkLVZsnAQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4C91A810602
	for <linux-bcachefs@vger.kernel.org>; Fri, 19 Apr 2024 18:13:40 +0000 (UTC)
Received: from bfoster.redhat.com (unknown [10.22.8.10])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 31F3943FB1
	for <linux-bcachefs@vger.kernel.org>; Fri, 19 Apr 2024 18:13:40 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
To: linux-bcachefs@vger.kernel.org
Subject: [PATCH v4 4/4] bcachefs: add fiemap delalloc extent detection
Date: Fri, 19 Apr 2024 14:15:38 -0400
Message-ID: <20240419181538.1411082-5-bfoster@redhat.com>
In-Reply-To: <20240419181538.1411082-1-bfoster@redhat.com>
References: <20240419181538.1411082-1-bfoster@redhat.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.5

bcachefs currently populates fiemap data from the extents btree.
This works correctly when the fiemap sync flag is provided, but if
not, it skips all delalloc extents that have not yet been flushed.
This is because delalloc extents from buffered writes are first
stored as reservation in the pagecache, and only become resident in
the extents btree after writeback completes.

Update the fiemap implementation to process holes between extents by
scanning pagecache for data, via seek data/hole. If a valid data
range is found over a hole in the extent btree, fake up an extent
key and flag the extent as delalloc for reporting to userspace.

Note that this does not necessarily change behavior for the case
where there is dirty pagecache over already written extents, where
when in COW mode, writeback will allocate new blocks for the
underlying ranges. The existing behavior is consistent with btrfs
and it is recommended to use the sync flag for the most up to date
extent state from fiemap.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/bcachefs/fs.c | 119 ++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 112 insertions(+), 7 deletions(-)

diff --git a/fs/bcachefs/fs.c b/fs/bcachefs/fs.c
index 5c6af360a61f..b5f95a929bb2 100644
--- a/fs/bcachefs/fs.c
+++ b/fs/bcachefs/fs.c
@@ -989,6 +989,87 @@ static int bch2_fiemap_extent(struct btree_trans *trans,
 	return 0;
 }
 
+/*
+ * Scan a range of an inode for data in pagecache.
+ *
+ * Intended to be retryable, so don't modify the output params until success is
+ * imminent.
+ */
+static int
+bch2_fiemap_hole_pagecache(struct inode *vinode, u64 *start, u64 *end,
+			   bool nonblock)
+{
+	loff_t	dstart, dend;
+
+	dstart = bch2_seek_pagecache_data(vinode, *start, *end, 0, nonblock);
+	if (dstart < 0)
+		return dstart;
+	if (dstart >= *end)
+		return -ENOENT;
+
+	dend = bch2_seek_pagecache_hole(vinode, dstart, *end, 0, nonblock);
+	if (dend < 0)
+		return dend;
+
+	*start = dstart;
+	*end = dend;
+	return 0;
+}
+
+/*
+ * Scan a range of pagecache that corresponds to a file mapping hole in the
+ * extent btree. If data is found, fake up an extent key so it looks like a
+ * delalloc extent to the rest of the fiemap processing code.
+ *
+ * Returns 0 if cached data was found, -ENOENT if not.
+ */
+static int
+bch2_fiemap_hole(struct btree_trans *trans, struct inode *vinode, u64 start,
+		 u64 end, struct bch_fiemap_extent *cur)
+{
+	struct bch_fs		*c = vinode->i_sb->s_fs_info;
+	struct bch_inode_info	*ei = to_bch_ei(vinode);
+	struct bkey_i_extent	*delextent;
+	struct bch_extent_ptr	ptr = {};
+	loff_t			dstart = start, dend = end;
+	int			ret;
+
+	/*
+	 * We hold btree locks here so we cannot block on folio locks without
+	 * dropping trans locks first. Run a nonblocking scan for the common
+	 * case of no folios over holes and fall back on failure.
+	 *
+	 * Note that dropping locks like this is technically racy against
+	 * writeback inserting to the extent tree, but a non-sync fiemap scan is
+	 * fundamentally racy with writeback anyways. Therefore, just report the
+	 * range as delalloc regardless of whether we have to cycle trans locks.
+	 */
+	ret = bch2_fiemap_hole_pagecache(vinode, &dstart, &dend, true);
+	if (ret == -EAGAIN) {
+		/* open coded drop_locks_do() to relock even on error */
+		bch2_trans_unlock(trans);
+		ret = bch2_fiemap_hole_pagecache(vinode, &dstart, &dend, false);
+		bch2_trans_relock(trans);
+	}
+	if (ret < 0)
+		return ret;
+
+	/*
+	 * Create a fake extent key in the buffer. We have to add a dummy extent
+	 * pointer for the fill code to add an extent entry. It's explicitly
+	 * zeroed to reflect delayed allocation (i.e. phys offset 0).
+	 */
+	bch2_bkey_buf_realloc(&cur->kbuf, c, sizeof(*delextent) / sizeof(u64));
+	delextent = bkey_extent_init(cur->kbuf.k);
+	delextent->k.p = POS(ei->v.i_ino, dstart >> 9);
+	bch2_key_resize(&delextent->k, (dend - dstart) >> 9);
+	bch2_bkey_append_ptr(&delextent->k_i, ptr);
+
+	cur->flags = FIEMAP_EXTENT_DELALLOC;
+
+	return 0;
+}
+
 static int bch2_fiemap(struct inode *vinode, struct fiemap_extent_info *info,
 		       u64 start, u64 len)
 {
@@ -1028,16 +1109,40 @@ static int bch2_fiemap(struct inode *vinode, struct fiemap_extent_info *info,
 	while (!(ret = btree_trans_too_many_iters(trans)) &&
 	       (k = bch2_btree_iter_peek_upto(&iter, end)).k &&
 	       !(ret = bkey_err(k))) {
+		bool have_delalloc = false;
 
-		if (!bkey_extent_is_data(k.k) &&
-		    k.k->type != KEY_TYPE_reservation) {
-			bch2_btree_iter_advance(&iter);
-			continue;
+		/*
+		 * If a hole exists before the start of the extent key, scan the
+		 * range for pagecache data that might be pending writeback and
+		 * thus not yet exist in the extent tree.
+		 */
+		if (iter.pos.offset > start) {
+			ret = bch2_fiemap_hole(trans, vinode, start << 9,
+					       iter.pos.offset << 9, &cur);
+			if (!ret)
+				have_delalloc = true;
+			else if (ret != -ENOENT)
+				break;
 		}
 
-		ret = bch2_fiemap_extent(trans, &iter, k, &cur);
-		if (ret)
-			break;
+		 /* process the current key if there's no delalloc to report */
+		if (!have_delalloc) {
+			if (!bkey_extent_is_data(k.k) &&
+			    k.k->type != KEY_TYPE_reservation) {
+				start = bkey_start_offset(k.k) + k.k->size;
+				bch2_btree_iter_advance(&iter);
+				continue;
+			}
+
+			ret = bch2_fiemap_extent(trans, &iter, k, &cur);
+			if (ret)
+				break;
+		}
+
+		/*
+		 * Store the current extent in prev so we can flag the last
+		 * extent on the way out.
+		 */
 		bch2_bkey_buf_realloc(&prev.kbuf, c, cur.kbuf.k->k.u64s);
 		start = cur.kbuf.k->k.p.offset;
 
-- 
2.44.0


Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A5E213F436
	for <linux-bcachefs@vger.kernel.org>; Mon,  8 Apr 2024 14:46:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712587613; cv=none; b=J2gLQqBz4j4tLAwUy+PacNpTdE8+dSe6q4v8nh3HT8ZdQQeEGu0XXki9+SycbNFd99tKZHnTjToj3lt7hCI3zDw3OqLlzQNUHmM+/nhhf9xTlhAsZqvQHG8iXrKpM5y+C4SnVQssa8DWo7HT6EJUgDdFe9EEaHJguJtc+KLyMuc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712587613; c=relaxed/simple;
	bh=jZbfmVoAGdF49eDWK5nr9mC/47Xbcg4Tid8/sLGsn20=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=un6lvSUXDXPYsX116AuKqhFOOrFr5L5ueY4K1v2+gVGxXY5boaHKMxrzUit/cWx555BhmDDnPh0XeFPqO5Tfqt7fooRdn1NptbpaUFsETqfp9UnmxcB/e142Ex7h4LHhlxsm3klGzyjb04xIUtyDPMbp1uDwTujb0xazI3U5lng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=eqDWqNqh; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="eqDWqNqh"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1712587610;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hpGbh1U3gf55uGi2Euny5FiVUb4ij2wS0a6M/H8ijOI=;
	b=eqDWqNqhamMqCF1hdY5xYI0CByXwaHnnuzeEIFMNOjTsxJd9txMp5DA1fvkbYRT6v+fvlC
	xrKh6QNbRk+LzU9772cWXzI9v9NKgmnhtkU+4Io5iyCDAD6SV2HGna0q2s2KdOIYEhkz4K
	/7M8UdFcc3zJn4PWyc3ni1uvvj1ylnk=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-522-azdBcn2pOZO6DXedYXUOyw-1; Mon, 08 Apr 2024 10:46:48 -0400
X-MC-Unique: azdBcn2pOZO6DXedYXUOyw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 48AEC889F46
	for <linux-bcachefs@vger.kernel.org>; Mon,  8 Apr 2024 14:46:48 +0000 (UTC)
Received: from bfoster.redhat.com (unknown [10.22.16.57])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 2DA862026D06
	for <linux-bcachefs@vger.kernel.org>; Mon,  8 Apr 2024 14:46:48 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
To: linux-bcachefs@vger.kernel.org
Subject: [PATCH v3 4/4] bcachefs: add fiemap delalloc extent detection
Date: Mon,  8 Apr 2024 10:48:46 -0400
Message-ID: <20240408144846.1001243-5-bfoster@redhat.com>
In-Reply-To: <20240408144846.1001243-1-bfoster@redhat.com>
References: <20240408144846.1001243-1-bfoster@redhat.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.4

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
 fs/bcachefs/fs.c | 87 +++++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 79 insertions(+), 8 deletions(-)

diff --git a/fs/bcachefs/fs.c b/fs/bcachefs/fs.c
index 9f14eb256c09..77a8c826b637 100644
--- a/fs/bcachefs/fs.c
+++ b/fs/bcachefs/fs.c
@@ -993,6 +993,51 @@ static int bch2_fiemap_extent(struct btree_trans *trans,
 	return 0;
 }
 
+/*
+ * Scan a range of pagecache that corresponds to a file mapping hole in the
+ * extent btree. If found, fake up an extent key so it looks like a delalloc
+ * extent to the rest of the fiemap processing code.
+ *
+ * Returns 0 if cached data was found, -ENOENT if not, or -EAGAIN for folio
+ * trylock failure.
+ */
+static int
+bch2_fiemap_hole(struct inode *vinode, u64 start, u64 end,
+		 struct bch_fiemap_extent *cur)
+{
+	struct bch_fs		*c = vinode->i_sb->s_fs_info;
+	struct bch_inode_info	*ei = to_bch_ei(vinode);
+	struct bkey_i_extent	*delextent;
+	struct bch_extent_ptr	ptr = {};
+	loff_t			dstart, dend;
+
+	/*
+	 * We hold btree node locks here so we cannot block on folio locks.
+	 * Propagate -EAGAIN errors so the caller can retry.
+	 */
+	dstart = bch2_seek_pagecache_data(vinode, start, end, 0, true);
+	if (dstart < 0)
+		return dstart;
+	if (dstart >= end)
+		return -ENOENT;
+	dend = bch2_seek_pagecache_hole(vinode, dstart, end, 0, true);
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
@@ -1032,16 +1077,41 @@ static int bch2_fiemap(struct inode *vinode, struct fiemap_extent_info *info,
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
+		 * thus not yet exist in the extent tree. Note that this can
+		 * return -EAGAIN to request to retry folio locks.
+		 */
+		if (iter.pos.offset > start) {
+			ret = bch2_fiemap_hole(vinode, start << 9,
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
 
@@ -1061,7 +1131,8 @@ static int bch2_fiemap(struct inode *vinode, struct fiemap_extent_info *info,
 	start = iter.pos.offset;
 	bch2_trans_iter_exit(trans, &iter);
 err:
-	if (bch2_err_matches(ret, BCH_ERR_transaction_restart))
+	if (ret == -EAGAIN ||
+	    bch2_err_matches(ret, BCH_ERR_transaction_restart))
 		goto retry;
 
 	if (!ret && have_extent) {
-- 
2.44.0


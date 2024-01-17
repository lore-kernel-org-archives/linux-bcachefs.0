Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E90F21A0E
	for <linux-bcachefs@vger.kernel.org>; Wed, 17 Jan 2024 15:54:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705506899; cv=none; b=L2GpKJ/hao2Jo/pT0JC4bbqJ+l4oQJ0vFKDveVabOYr5K77CoAlSS5eiIztQYFAMCRds5CniJ1KB5L0qkn7A28AcorRYuSnHhOavVaE3LbYxY/yACqi1mk1DphskFkXTA6Pl+mq36l/s0MvctNnu06eEYjJThHrJACRvncS0aQ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705506899; c=relaxed/simple;
	bh=sRJeyaLUAtXjtXbfODJwuJ8S08zNptY3pdo9VFhtoS8=;
	h=DKIM-Signature:Received:X-MC-Unique:Received:Received:From:To:
	 Subject:Date:Message-ID:In-Reply-To:References:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:X-Scanned-By; b=QbiFHZ5YonZ2Bf7c8fvdFkn3azEE4cX7fJ8lRQqhNx5ziu8/UMYucWz6RbsSG3GWqCdYfWFZ1Su0Yv7T5ndA7runhMot5kMECgUVveFYt6x6HyWidX1UmzkqoaN+saO0szMsBEraLCZk6Gjvib5qNgdcivVwk6Hnkn+gBXJSmFA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Q4yD8fqM; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Q4yD8fqM"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1705506897;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MM3wJq1UJI5Fr9MsekGVaEjmH+RLX+6/JO0/DU/gV90=;
	b=Q4yD8fqMF0+7xlaYXFFfQP51qyCT28AVop5FqPs8ZAtkhKOW9Z+yU8DQtsXQOGEB2YqdPC
	90TvWweME0pXRdMH+qoP+SqBtGFkxyXHXEy9+QCV6eydJkKZTE4uHxSLlh74sv9s97PUIE
	3l8zAW6btgNN7/IpizKedm0mD7TpbmY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-627-DgZ4OcS5OkWE8cDotc2CnA-1; Wed, 17 Jan 2024 10:54:55 -0500
X-MC-Unique: DgZ4OcS5OkWE8cDotc2CnA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CDA94872811
	for <linux-bcachefs@vger.kernel.org>; Wed, 17 Jan 2024 15:54:52 +0000 (UTC)
Received: from bfoster.redhat.com (unknown [10.22.8.116])
	by smtp.corp.redhat.com (Postfix) with ESMTP id B342F1074C
	for <linux-bcachefs@vger.kernel.org>; Wed, 17 Jan 2024 15:54:52 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
To: linux-bcachefs@vger.kernel.org
Subject: [PATCH v2 4/4] bcachefs: add fiemap delalloc extent detection
Date: Wed, 17 Jan 2024 10:56:11 -0500
Message-ID: <20240117155611.248042-5-bfoster@redhat.com>
In-Reply-To: <20240117155611.248042-1-bfoster@redhat.com>
References: <20240117155611.248042-1-bfoster@redhat.com>
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
 fs/bcachefs/fs.c | 64 ++++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 57 insertions(+), 7 deletions(-)

diff --git a/fs/bcachefs/fs.c b/fs/bcachefs/fs.c
index 1364f491af87..2e525735dd73 100644
--- a/fs/bcachefs/fs.c
+++ b/fs/bcachefs/fs.c
@@ -923,6 +923,41 @@ static int bch2_fiemap_extent(struct btree_trans *trans,
 	return 0;
 }
 
+/*
+ * Scan a range of pagecache that corresponds to a file mapping hole in the
+ * extent btree. If found, fake up an extent key so it looks like a delalloc
+ * extent to the rest of the fiemap processing code.
+ */
+static bool
+bch2_fiemap_hole(struct inode *vinode, u64 start, u64 end,
+		 struct bch_fiemap_extent *cur)
+{
+	struct bch_fs		*c = vinode->i_sb->s_fs_info;
+	struct bch_inode_info	*ei = to_bch_ei(vinode);
+	struct bkey_i_extent	*delextent;
+	struct bch_extent_ptr	ptr = {};
+
+	start = bch2_seek_pagecache_data(vinode, start, end, 0, false);
+	if (start >= end)
+		return false;
+	end = bch2_seek_pagecache_hole(vinode, start, end, 0, false);
+
+	/*
+	 * Create a fake extent key in the buffer. We have to add a dummy extent
+	 * pointer for the fill code to add an extent entry. It's explicitly
+	 * zeroed to reflect delayed allocation (i.e. phys offset 0).
+	 */
+	bch2_bkey_buf_realloc(&cur->kbuf, c, sizeof(*delextent) / sizeof(u64));
+	delextent = bkey_extent_init(cur->kbuf.k);
+	delextent->k.p = POS(ei->v.i_ino, start >> 9);
+	bch2_key_resize(&delextent->k, (end - start) >> 9);
+	bch2_bkey_append_ptr(&delextent->k_i, ptr);
+
+	cur->flags = FIEMAP_EXTENT_DELALLOC;
+
+	return true;
+}
+
 static int bch2_fiemap(struct inode *vinode, struct fiemap_extent_info *info,
 		       u64 start, u64 len)
 {
@@ -962,16 +997,31 @@ static int bch2_fiemap(struct inode *vinode, struct fiemap_extent_info *info,
 	while (!(ret = btree_trans_too_many_iters(trans)) &&
 	       (k = bch2_btree_iter_peek_upto(&iter, end)).k &&
 	       !(ret = bkey_err(k))) {
+		/*
+		 * If a hole exists before the start of the next key, scan that
+		 * range in pagecache for delalloc data that might be pending
+		 * writeback and report it as delalloc. Otherwise, process the
+		 * key.
+		 */
+		if (iter.pos.offset <= start ||
+		    !bch2_fiemap_hole(vinode, start << 9, iter.pos.offset << 9,
+				      &cur)) {
+			if (!bkey_extent_is_data(k.k) &&
+			    k.k->type != KEY_TYPE_reservation) {
+				start = bkey_start_offset(k.k) + k.k->size;
+				bch2_btree_iter_advance(&iter);
+				continue;
+			}
 
-		if (!bkey_extent_is_data(k.k) &&
-		    k.k->type != KEY_TYPE_reservation) {
-			bch2_btree_iter_advance(&iter);
-			continue;
+			ret = bch2_fiemap_extent(trans, &iter, k, &cur);
+			if (ret)
+				break;
 		}
 
-		ret = bch2_fiemap_extent(trans, &iter, k, &cur);
-		if (ret)
-			break;
+		/*
+		 * Store the current extent in prev so we can flag the last
+		 * extent on the way out.
+		 */
 		bch2_bkey_buf_realloc(&prev.kbuf, c, cur.kbuf.k->k.u64s);
 		start = cur.kbuf.k->k.p.offset;
 
-- 
2.42.0


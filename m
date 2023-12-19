Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 502001D528
	for <linux-bcachefs@vger.kernel.org>; Tue, 19 Dec 2023 14:01:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HkiSvWpn"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1702994479;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/rl8Lie78ChG1Rlb6T9gr3dDIbaxDe2S4OHAG2DCD74=;
	b=HkiSvWpnljgwi2yokmE6deoOfBP3yyH94/eQcSRKnT220plzyRRS/jXqty8v2tiNhw8t8i
	SPveHF8ER7rV/2X+10E/SJs11Y1Dsg9TpKI8VlM6veC96ow4CBOW+Ld0db9EunpIyR2F1r
	RAfqfbgv76j5wV/lKc9DP8vQC8jQWmA=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-84-dVLuSDQXMyiRph2aDPidsw-1; Tue, 19 Dec 2023 09:01:14 -0500
X-MC-Unique: dVLuSDQXMyiRph2aDPidsw-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B9A12835146
	for <linux-bcachefs@vger.kernel.org>; Tue, 19 Dec 2023 14:01:13 +0000 (UTC)
Received: from bfoster.redhat.com (unknown [10.22.8.199])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 9CC60492BF0
	for <linux-bcachefs@vger.kernel.org>; Tue, 19 Dec 2023 14:01:13 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
To: linux-bcachefs@vger.kernel.org
Subject: [PATCH 1/2] bcachefs: add fiemap delalloc extent detection
Date: Tue, 19 Dec 2023 09:02:14 -0500
Message-ID: <20231219140215.300753-2-bfoster@redhat.com>
In-Reply-To: <20231219140215.300753-1-bfoster@redhat.com>
References: <20231219140215.300753-1-bfoster@redhat.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.10

bcachefs currently populates fiemap data from the extents btree.
This works correctly when the fiemap sync flag is provided, but if
not, it skips all delalloc extents that have not yet been flushed.
This is because delalloc extents from buffered writes are first
stored as reservation in the pagecache, and only become resident in
the extents btree after writeback completes.

Update the fiemap implementation to scan the pagecache for data for
file ranges that are not present in the extents btree. This uses the
preexisting seek data/hole mechanism to identify data ranges, and
then formats them as delayed allocation extents in the fiemap info.
This is done by faking up an extent key and passing that along to
the fiemap fill handler. We also tweak bch2_fiemap() to save fiemap
flags for the previous key in order to track that it is delalloc.

One caveat worth noting with respect to fiemap and COW is that
extent btree data is reported even when dirty pagecache exists over
the associated range of the file. This means the range is
reallocated on the next writeback and thus fiemap data is
technically out of date. This is not necessarily a serious issue
given fiemap is racy by definition, the final location of the
unflushed data is unknown, and the caller should probably use the
sync flag for most up to date information. FWIW, btrfs exhibits this
same behavior wrt to dirty pagecache over COW extents as well, so
this patch brings bcachefs to functional parity with btrfs.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/bcachefs/fs.c | 60 ++++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 56 insertions(+), 4 deletions(-)

diff --git a/fs/bcachefs/fs.c b/fs/bcachefs/fs.c
index bc280a0a957d..0b3b35092818 100644
--- a/fs/bcachefs/fs.c
+++ b/fs/bcachefs/fs.c
@@ -868,6 +868,41 @@ static int bch2_fill_extent(struct bch_fs *c,
 	}
 }
 
+/*
+ * Scan a gap in the extent btree for delayed allocation in pagecache. If found,
+ * fake up an extent key so it looks like an extent to the rest of the fiemap
+ * processing code.
+ */
+static bool
+bch2_fiemap_scan_pagecache(struct inode		*vinode,
+			   u64			start,
+			   u64			end,
+			   struct bkey_buf	*cur)
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
+	bch2_bkey_buf_realloc(cur, c, sizeof(*delextent) / sizeof(u64));
+	delextent = bkey_extent_init(cur->k);
+	delextent->k.p = POS(ei->v.i_ino, start >> 9);
+	bch2_key_resize(&delextent->k, (end - start) >> 9);
+	bch2_bkey_append_ptr(&delextent->k_i, ptr);
+
+	return true;
+}
+
 static int bch2_fiemap(struct inode *vinode, struct fiemap_extent_info *info,
 		       u64 start, u64 len)
 {
@@ -879,6 +914,7 @@ static int bch2_fiemap(struct inode *vinode, struct fiemap_extent_info *info,
 	struct bkey_buf cur, prev;
 	struct bpos end = POS(ei->v.i_ino, (start + len) >> 9);
 	unsigned offset_into_extent, sectors;
+	unsigned cflags, pflags;
 	bool have_extent = false;
 	u32 snapshot;
 	int ret = 0;
@@ -916,6 +952,19 @@ static int bch2_fiemap(struct inode *vinode, struct fiemap_extent_info *info,
 			continue;
 		}
 
+		/*
+		 * Outstanding buffered writes aren't tracked in the extent
+		 * btree until dirty folios are written back. Check holes in the
+		 * extent tree for data in pagecache and report it as delalloc.
+		 */
+		if (iter.pos.offset > start &&
+		    bch2_fiemap_scan_pagecache(vinode, start << 9,
+					       iter.pos.offset << 9, &cur)) {
+			cflags = FIEMAP_EXTENT_DELALLOC;
+			start = bkey_start_offset(&cur.k->k) + cur.k->k.size;
+			goto fill;
+		}
+
 		offset_into_extent	= iter.pos.offset -
 			bkey_start_offset(k.k);
 		sectors			= k.k->size - offset_into_extent;
@@ -940,19 +989,22 @@ static int bch2_fiemap(struct inode *vinode, struct fiemap_extent_info *info,
 		cur.k->k.p = iter.pos;
 		cur.k->k.p.offset += cur.k->k.size;
 
+		cflags = 0;
+		start = iter.pos.offset + sectors;
+fill:
 		if (have_extent) {
 			bch2_trans_unlock(trans);
 			ret = bch2_fill_extent(c, info,
-					bkey_i_to_s_c(prev.k), 0);
+					bkey_i_to_s_c(prev.k), pflags);
 			if (ret)
 				break;
 		}
 
 		bkey_copy(prev.k, cur.k);
+		pflags = cflags;
 		have_extent = true;
 
-		bch2_btree_iter_set_pos(&iter,
-			POS(iter.pos.inode, iter.pos.offset + sectors));
+		bch2_btree_iter_set_pos(&iter, POS(iter.pos.inode, start));
 	}
 	start = iter.pos.offset;
 	bch2_trans_iter_exit(trans, &iter);
@@ -963,7 +1015,7 @@ static int bch2_fiemap(struct inode *vinode, struct fiemap_extent_info *info,
 	if (!ret && have_extent) {
 		bch2_trans_unlock(trans);
 		ret = bch2_fill_extent(c, info, bkey_i_to_s_c(prev.k),
-				       FIEMAP_EXTENT_LAST);
+				       pflags|FIEMAP_EXTENT_LAST);
 	}
 
 	bch2_trans_put(trans);
-- 
2.42.0


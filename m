Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FF6B13F428
	for <linux-bcachefs@vger.kernel.org>; Mon,  8 Apr 2024 14:46:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712587614; cv=none; b=k/xK+4fZsYpfSrTtSx98n9PPzob9PbJmV37q0MhPoiSkbyJVhZwSyomteQ8QW1ZUG9WFMOHklUH8/EEkVIQ/9xXszXjX97S00u3PxY2sWSGieP5ik1eM/d4ct/KEQO8QDA3gB2tfQTo6F8txxgTcnzoD0zeiPAKaE8uFU6kFdcc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712587614; c=relaxed/simple;
	bh=FPoItN6ioGnm3QHdhPHDcvAwKSsU31+Scm8DOze77nk=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SVNoHgkS0DVJy7NW1T4PSmMBm2kUfL50OQYkfJTJVUGLxkHsmjks6Dk0T3I1ZZyjynUwTj4afhqVL+/8rSF/1/jnvtrLNtSDivpEiyfUAzN18LoJIlKvE+KYSD/zIOmjlNYNRo77Pi5gLpShzUyrtx+sYjtYhUwcqV5ijNT24qY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=TlhbPdAI; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TlhbPdAI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1712587611;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5RFDHMdttmY1/8IODGzQfl7xdkaGY00TlbFO+UDEc6k=;
	b=TlhbPdAIZZYqrMxjU7q/FTxXZgHQLOco5QE1kinyJgHHS4Il5K+n7l02zuVnbAICcg2/zJ
	Dq1VPcKAvvwcA0pis4zi0uer8qAP4O2PesVMrGwf6iKAHequKOe3tnZJBRUTcyn6/OrS/e
	ks0vqAbvR8PxahsP8gKZeo8fBmRuzM8=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-182-K_ugKzRBNhS2vwh8U2zmqw-1; Mon,
 08 Apr 2024 10:46:48 -0400
X-MC-Unique: K_ugKzRBNhS2vwh8U2zmqw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 206B43C0FCA6
	for <linux-bcachefs@vger.kernel.org>; Mon,  8 Apr 2024 14:46:48 +0000 (UTC)
Received: from bfoster.redhat.com (unknown [10.22.16.57])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 03A522026D06
	for <linux-bcachefs@vger.kernel.org>; Mon,  8 Apr 2024 14:46:47 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
To: linux-bcachefs@vger.kernel.org
Subject: [PATCH v3 3/4] bcachefs: refactor fiemap processing into extent helper and struct
Date: Mon,  8 Apr 2024 10:48:45 -0400
Message-ID: <20240408144846.1001243-4-bfoster@redhat.com>
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

The bulk of the loop in bch2_fiemap() involves processing the
current extent key from the iter, including following indirections
and trimming the extent size and such. This patch makes a few
changes to reduce the size of the loop and facilitate future changes
to support delalloc extents.

Define a new bch_fiemap_extent structure to wrap the bkey buffer
that holds the extent key to report to userspace along with
associated fiemap flags. Update bch2_fill_extent() to take the
bch_fiemap_extent as a param instead of the individual fields.
Finally, lift the bulk of the extent processing into a
bch2_fiemap_extent() helper that takes the current key and formats
the bch_fiemap_extent appropriately for the fill function.

No functional changes intended by this patch.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/bcachefs/fs.c | 90 +++++++++++++++++++++++++++++-------------------
 1 file changed, 55 insertions(+), 35 deletions(-)

diff --git a/fs/bcachefs/fs.c b/fs/bcachefs/fs.c
index 9c86749b256e..9f14eb256c09 100644
--- a/fs/bcachefs/fs.c
+++ b/fs/bcachefs/fs.c
@@ -896,10 +896,18 @@ static int bch2_tmpfile(struct mnt_idmap *idmap,
 	return finish_open_simple(file, 0);
 }
 
+struct bch_fiemap_extent {
+	struct bkey_buf	kbuf;
+	unsigned	flags;
+};
+
 static int bch2_fill_extent(struct bch_fs *c,
 			    struct fiemap_extent_info *info,
-			    struct bkey_s_c k, unsigned flags)
+			    struct bch_fiemap_extent *fe)
 {
+	struct bkey_s_c k = bkey_i_to_s_c(fe->kbuf.k);
+	unsigned flags = fe->flags;
+
 	if (bkey_extent_is_direct_data(k.k)) {
 		struct bkey_ptrs_c ptrs = bch2_bkey_ptrs_c(k);
 		const union bch_extent_entry *entry;
@@ -952,6 +960,39 @@ static int bch2_fill_extent(struct bch_fs *c,
 	}
 }
 
+static int bch2_fiemap_extent(struct btree_trans *trans,
+			      struct btree_iter *iter, struct bkey_s_c k,
+			      struct bch_fiemap_extent *cur)
+{
+	unsigned	offset_into_extent, sectors;
+	enum btree_id	data_btree = BTREE_ID_extents;
+	int		ret;
+
+	offset_into_extent	= iter->pos.offset - bkey_start_offset(k.k);
+	sectors			= k.k->size - offset_into_extent;
+
+	bch2_bkey_buf_reassemble(&cur->kbuf, trans->c, k);
+
+	ret = bch2_read_indirect_extent(trans, &data_btree, &offset_into_extent,
+					&cur->kbuf);
+	if (ret)
+		return ret;
+
+	k = bkey_i_to_s_c(cur->kbuf.k);
+	sectors = min(sectors, k.k->size - offset_into_extent);
+
+	bch2_cut_front(POS(k.k->p.inode,
+			   bkey_start_offset(k.k) + offset_into_extent),
+		       cur->kbuf.k);
+	bch2_key_resize(&cur->kbuf.k->k, sectors);
+	cur->kbuf.k->k.p = iter->pos;
+	cur->kbuf.k->k.p.offset += cur->kbuf.k->k.size;
+
+	cur->flags = 0;
+
+	return 0;
+}
+
 static int bch2_fiemap(struct inode *vinode, struct fiemap_extent_info *info,
 		       u64 start, u64 len)
 {
@@ -960,9 +1001,8 @@ static int bch2_fiemap(struct inode *vinode, struct fiemap_extent_info *info,
 	struct btree_trans *trans;
 	struct btree_iter iter;
 	struct bkey_s_c k;
-	struct bkey_buf cur, prev;
+	struct bch_fiemap_extent cur, prev;
 	struct bpos end = POS(ei->v.i_ino, (start + len) >> 9);
-	unsigned offset_into_extent, sectors;
 	bool have_extent = false;
 	u32 snapshot;
 	int ret = 0;
@@ -976,8 +1016,8 @@ static int bch2_fiemap(struct inode *vinode, struct fiemap_extent_info *info,
 
 	start >>= 9;
 
-	bch2_bkey_buf_init(&cur);
-	bch2_bkey_buf_init(&prev);
+	bch2_bkey_buf_init(&cur.kbuf);
+	bch2_bkey_buf_init(&prev.kbuf);
 	trans = bch2_trans_get(c);
 retry:
 	bch2_trans_begin(trans);
@@ -992,7 +1032,6 @@ static int bch2_fiemap(struct inode *vinode, struct fiemap_extent_info *info,
 	while (!(ret = btree_trans_too_many_iters(trans)) &&
 	       (k = bch2_btree_iter_peek_upto(&iter, end)).k &&
 	       !(ret = bkey_err(k))) {
-		enum btree_id data_btree = BTREE_ID_extents;
 
 		if (!bkey_extent_is_data(k.k) &&
 		    k.k->type != KEY_TYPE_reservation) {
@@ -1000,40 +1039,21 @@ static int bch2_fiemap(struct inode *vinode, struct fiemap_extent_info *info,
 			continue;
 		}
 
-		offset_into_extent	= iter.pos.offset -
-			bkey_start_offset(k.k);
-		sectors			= k.k->size - offset_into_extent;
-
-		bch2_bkey_buf_reassemble(&cur, c, k);
-
-		ret = bch2_read_indirect_extent(trans, &data_btree,
-					&offset_into_extent, &cur);
+		ret = bch2_fiemap_extent(trans, &iter, k, &cur);
 		if (ret)
 			break;
-
-		k = bkey_i_to_s_c(cur.k);
-		bch2_bkey_buf_realloc(&prev, c, k.k->u64s);
-
-		sectors = min(sectors, k.k->size - offset_into_extent);
-		start = iter.pos.offset + sectors;
-
-		bch2_cut_front(POS(k.k->p.inode,
-				   bkey_start_offset(k.k) +
-				   offset_into_extent),
-			       cur.k);
-		bch2_key_resize(&cur.k->k, sectors);
-		cur.k->k.p = iter.pos;
-		cur.k->k.p.offset += cur.k->k.size;
+		bch2_bkey_buf_realloc(&prev.kbuf, c, cur.kbuf.k->k.u64s);
+		start = cur.kbuf.k->k.p.offset;
 
 		if (have_extent) {
 			bch2_trans_unlock(trans);
-			ret = bch2_fill_extent(c, info,
-					bkey_i_to_s_c(prev.k), 0);
+			ret = bch2_fill_extent(c, info, &prev);
 			if (ret)
 				break;
 		}
 
-		bkey_copy(prev.k, cur.k);
+		bkey_copy(prev.kbuf.k, cur.kbuf.k);
+		prev.flags = cur.flags;
 		have_extent = true;
 
 		bch2_btree_iter_set_pos(&iter, POS(iter.pos.inode, start));
@@ -1046,13 +1066,13 @@ static int bch2_fiemap(struct inode *vinode, struct fiemap_extent_info *info,
 
 	if (!ret && have_extent) {
 		bch2_trans_unlock(trans);
-		ret = bch2_fill_extent(c, info, bkey_i_to_s_c(prev.k),
-				       FIEMAP_EXTENT_LAST);
+		prev.flags |= FIEMAP_EXTENT_LAST;
+		ret = bch2_fill_extent(c, info, &prev);
 	}
 
 	bch2_trans_put(trans);
-	bch2_bkey_buf_exit(&cur, c);
-	bch2_bkey_buf_exit(&prev, c);
+	bch2_bkey_buf_exit(&cur.kbuf, c);
+	bch2_bkey_buf_exit(&prev.kbuf, c);
 	return ret < 0 ? ret : 0;
 }
 
-- 
2.44.0


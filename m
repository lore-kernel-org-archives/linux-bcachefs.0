Received: from out-178.mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEEBA172BD0
	for <linux-bcachefs@vger.kernel.org>; Fri, 18 Oct 2024 04:36:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729226175; cv=none; b=VY/9kvpP0hXH8Z+ceQHQk0Qafr/kfumPX8X+1pws1bToQk0xTj6dMV8hlwDEhjjh0kBreCpUh+SV/gopAe8dlvHeVjQLNyGOSSCyUWrSFx2bcRDkKn+X4Xy3ccd31BZ60AUJLDaV2CauN7+X52sKytif4bYJoJZfLiEpHmYddb4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729226175; c=relaxed/simple;
	bh=OjUI2Kd6oR4a36zdPaeD1CZf3ETk43t25JBFvWyEFmU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sb6HsIC4IVvq4Og4esutiEyR2963WpO0Uv2LhlVSkssCV4hN8k2GOyBMasal1i0rXgKD90ti1F8HBvThm0byl6XrI5sU6VpozkGxz8RT+LlDyUXu+nPVvQ//3+8ePGRS92lsxwASk3USQGRFpxjkkYnxEQM6RCdYSQ61lw5CifY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=dPGHxT07; arc=none smtp.client-ip=95.215.58.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="dPGHxT07"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1729226172;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0lUClWVhRJiBC5sfqI0RqMTiuVSb7ZBfIWqf7Q012ao=;
	b=dPGHxT07g6d+KD24g3d+DRNCG6SZ2JtFDHd55siyl9k2kpMcMB4qa/oN+adO9/7BZfUDCe
	HhQ+9etG53/4haXUI/CYFzZFedG5cZBERznKL4OkbXi7R+TlS76dZaScRKvEw3HShp/uGV
	qAL5Jw+dIBSOjVVQ15WHYNW4gZSGsjE=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 3/9] bcachefs: fix restart handling in bch2_fiemap()
Date: Fri, 18 Oct 2024 00:35:53 -0400
Message-ID: <20241018043602.4067344-4-kent.overstreet@linux.dev>
In-Reply-To: <20241018043602.4067344-1-kent.overstreet@linux.dev>
References: <20241018043602.4067344-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

We were leaking transaction restart errors to userspace.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/fs.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/fs/bcachefs/fs.c b/fs/bcachefs/fs.c
index d5d16d12e03a..165d95994bd2 100644
--- a/fs/bcachefs/fs.c
+++ b/fs/bcachefs/fs.c
@@ -1268,7 +1268,7 @@ static int bch2_fiemap(struct inode *vinode, struct fiemap_extent_info *info,
 	bch2_trans_iter_init(trans, &iter, BTREE_ID_extents,
 			     POS(ei->v.i_ino, start), 0);
 
-	while (true) {
+	while (!ret || bch2_err_matches(ret, BCH_ERR_transaction_restart)) {
 		enum btree_id data_btree = BTREE_ID_extents;
 
 		bch2_trans_begin(trans);
@@ -1276,14 +1276,14 @@ static int bch2_fiemap(struct inode *vinode, struct fiemap_extent_info *info,
 		u32 snapshot;
 		ret = bch2_subvolume_get_snapshot(trans, ei->ei_inum.subvol, &snapshot);
 		if (ret)
-			goto err;
+			continue;
 
 		bch2_btree_iter_set_snapshot(&iter, snapshot);
 
 		k = bch2_btree_iter_peek_upto(&iter, end);
 		ret = bkey_err(k);
 		if (ret)
-			goto err;
+			continue;
 
 		if (!k.k)
 			break;
@@ -1303,7 +1303,7 @@ static int bch2_fiemap(struct inode *vinode, struct fiemap_extent_info *info,
 		ret = bch2_read_indirect_extent(trans, &data_btree,
 					&offset_into_extent, &cur);
 		if (ret)
-			break;
+			continue;
 
 		k = bkey_i_to_s_c(cur.k);
 		bch2_bkey_buf_realloc(&prev, c, k.k->u64s);
@@ -1331,10 +1331,6 @@ static int bch2_fiemap(struct inode *vinode, struct fiemap_extent_info *info,
 
 		bch2_btree_iter_set_pos(&iter,
 			POS(iter.pos.inode, iter.pos.offset + sectors));
-err:
-		if (ret &&
-		    !bch2_err_matches(ret, BCH_ERR_transaction_restart))
-			break;
 	}
 	bch2_trans_iter_exit(trans, &iter);
 
-- 
2.45.2


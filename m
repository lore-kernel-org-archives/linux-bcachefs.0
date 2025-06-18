Received: from out-174.mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0073921CA0D
	for <linux-bcachefs@vger.kernel.org>; Wed, 18 Jun 2025 21:54:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750283695; cv=none; b=d8MtcLFFHLCBSX/P0rKewdZlM2EBqgcEWuh9Wm6JMusrmmUYGBzvC26L6lLivszS7Ykss346k2GblwPtH98TR4VkyPO6aFJdLuyPqmEB9PQBlYwyBhbVfwsf1oMRrOVkOoGLKUazfw+jgTXmO50oePDT+qOaiIdUtCKtrzOaMnY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750283695; c=relaxed/simple;
	bh=9l4ZMAXiZidLEY3qjnu8h7mYlIx6/EVFYzgdYGmRgko=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HAE9CLgUjXldiP8fMAgPxeEmSYuBd4epkS1vj2A8Fcdtt5D4SSD6ggWYbnK+iJDdTZbuXn2XyVn4xjEQep6/TCsrDXqkYOt3G5yzOpmhmPeoxkdLfXG+CyEozF7CtCjvhYIQIYrTXJESz85Pnpx1sQi5D9tI4TwdjriglxftX1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=PqDdNjc8; arc=none smtp.client-ip=95.215.58.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="PqDdNjc8"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1750283692;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rG5BUUOOEjvhKu+pvEYkcL2kpBByWgMaS26klQZBu0I=;
	b=PqDdNjc8npUp32ZP1fc/oZ7mt9mDGFkmkitdi27VgkDelC8WZA6rqqAZk6GB5ps8qS0sy+
	013mEjZcum3eIlmCUIu5c9LWr9WwUsOxcO5NPQEmPkPGEr8cvtAmESnsIimG8TGZDIPCrv
	c2fDRlFK6UCxtnnoXO0FwZDGe/btyns=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 12/37] bcachefs: Fix snapshot_key_missing_inode_snapshot repair
Date: Wed, 18 Jun 2025 17:54:03 -0400
Message-ID: <20250618215431.738317-13-kent.overstreet@linux.dev>
In-Reply-To: <20250618215431.738317-1-kent.overstreet@linux.dev>
References: <20250618215431.738317-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

When the inode was a whiteout, we were inserting a new whiteout at the
wrong (old) snapshot.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/fsck.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/fs/bcachefs/fsck.c b/fs/bcachefs/fsck.c
index 68ed69a255e1..b80a56e19b40 100644
--- a/fs/bcachefs/fsck.c
+++ b/fs/bcachefs/fsck.c
@@ -903,17 +903,15 @@ lookup_inode_for_snapshot(struct btree_trans *trans, struct inode_walker *w, str
 			 w->last_pos.inode, k.k->p.snapshot, i->inode.bi_snapshot,
 			 (bch2_bkey_val_to_text(&buf, c, k),
 			  buf.buf))) {
-		struct bch_inode_unpacked new = i->inode;
-		struct bkey_i whiteout;
-
-		new.bi_snapshot = k.k->p.snapshot;
-
 		if (!i->whiteout) {
+			struct bch_inode_unpacked new = i->inode;
+			new.bi_snapshot = k.k->p.snapshot;
 			ret = __bch2_fsck_write_inode(trans, &new);
 		} else {
+			struct bkey_i whiteout;
 			bkey_init(&whiteout.k);
 			whiteout.k.type = KEY_TYPE_whiteout;
-			whiteout.k.p = SPOS(0, i->inode.bi_inum, i->inode.bi_snapshot);
+			whiteout.k.p = SPOS(0, i->inode.bi_inum, k.k->p.snapshot);
 			ret = bch2_btree_insert_nonextent(trans, BTREE_ID_inodes,
 							  &whiteout,
 							  BTREE_UPDATE_internal_snapshot_node);
-- 
2.50.0


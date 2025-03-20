Received: from out-177.mta1.migadu.com (out-177.mta1.migadu.com [95.215.58.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09D2E221F0F
	for <linux-bcachefs@vger.kernel.org>; Thu, 20 Mar 2025 21:30:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742506241; cv=none; b=tQcjqJK6lXqFxxRfu3MtQ08oRObfBwazIcJ6xlVI7PJrK/h3w5iS5aDikAn2rC2ngYYE+5W7W8QSNB27w/k1Iy4rEkGRFS6UslGPbpgncyMgffDUfQ+hgcKVQBAZ4nJJhEvVJxDOoqPNfGHer3QuugV3XSPOb6meWFGAJlkOo7o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742506241; c=relaxed/simple;
	bh=iDz71TO1ZbjDBc08n/rHVyP+Rbmij/SZCMFfafjfaOg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g6olB4RnvflVQM36v2YRg9q4h6ORMTl8MVNHcycWv9uP0gXccIcr6Elt3GtuEtbpUs6bjtipSTGIJxO8CsZslLnRfY/jo/vHblj4MkbJ44IoKaPzy/9xJTvkoVKyeNKIXmFn9llb1G3lUlB/55CzD8DEfkwpcu4vVKl1GXX/XB0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=cM4pUuUf; arc=none smtp.client-ip=95.215.58.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="cM4pUuUf"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1742506238;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AP6TN7KJgHofTMX0lx8iVZOqlPd/lF+IBVrinT/x5bM=;
	b=cM4pUuUfZEoIaT9nzWg4X1c89FwNDMLvpmKEmgSD9+YQtVjIyyuikK7CHUxvbVuqEKzfPG
	nhHJzTGu84uJEfF0j51yhlR8KEjM00wWxCbzpYe+1Iqk6GFDxnJJBTcym5heekvREU6uRz
	Sp+7V/LG8WkP3KYZCIyL3eRppmyRRdU=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 4/4] bcachefs: Run bch2_check_dirent_target() at lookup time
Date: Thu, 20 Mar 2025 17:30:19 -0400
Message-ID: <20250320213022.3359645-5-kent.overstreet@linux.dev>
In-Reply-To: <20250320213022.3359645-1-kent.overstreet@linux.dev>
References: <20250320213022.3359645-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

More on the "full online self healing" project:

We now run most of the dirent <-> inode consistency checks, with repair
code, at runtime - the exact same check and repair code that fsck runs.

This will allow us to repair the "dirent points to inode that does not
point back" inconsistencies that have been popping up at runtime.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/fs.c | 32 +++++++++++++++++---------------
 1 file changed, 17 insertions(+), 15 deletions(-)

diff --git a/fs/bcachefs/fs.c b/fs/bcachefs/fs.c
index 273078ceb4df..fbca200f7636 100644
--- a/fs/bcachefs/fs.c
+++ b/fs/bcachefs/fs.c
@@ -641,7 +641,9 @@ static struct bch_inode_info *bch2_lookup_trans(struct btree_trans *trans,
 	if (ret)
 		return ERR_PTR(ret);
 
-	ret = bch2_dirent_read_target(trans, dir, bkey_s_c_to_dirent(k), &inum);
+	struct bkey_s_c_dirent d = bkey_s_c_to_dirent(k);
+
+	ret = bch2_dirent_read_target(trans, dir, d, &inum);
 	if (ret > 0)
 		ret = -ENOENT;
 	if (ret)
@@ -651,30 +653,30 @@ static struct bch_inode_info *bch2_lookup_trans(struct btree_trans *trans,
 	if (inode)
 		goto out;
 
+	/*
+	 * Note: if check/repair needs it, we commit before
+	 * bch2_inode_hash_init_insert(), as after that point we can't take a
+	 * restart - not in the top level loop with a commit_do(), like we
+	 * usually do:
+	 */
+
 	struct bch_subvolume subvol;
 	struct bch_inode_unpacked inode_u;
 	ret =   bch2_subvolume_get(trans, inum.subvol, true, &subvol) ?:
 		bch2_inode_find_by_inum_nowarn_trans(trans, inum, &inode_u) ?:
+		bch2_check_dirent_target(trans, &dirent_iter, d, &inode_u, false) ?:
+		bch2_trans_commit(trans, NULL, NULL, BCH_TRANS_COMMIT_no_enospc) ?:
 		PTR_ERR_OR_ZERO(inode = bch2_inode_hash_init_insert(trans, inum, &inode_u, &subvol));
 
+	/*
+	 * don't remove it: check_inodes might find another inode that points
+	 * back to this dirent
+	 */
 	bch2_fs_inconsistent_on(bch2_err_matches(ret, ENOENT),
 				c, "dirent to missing inode:\n  %s",
-				(bch2_bkey_val_to_text(&buf, c, k), buf.buf));
+				(bch2_bkey_val_to_text(&buf, c, d.s_c), buf.buf));
 	if (ret)
 		goto err;
-
-	/* regular files may have hardlinks: */
-	if (bch2_fs_inconsistent_on(bch2_inode_should_have_single_bp(&inode_u) &&
-				    !bkey_eq(k.k->p, POS(inode_u.bi_dir, inode_u.bi_dir_offset)),
-				    c,
-				    "dirent points to inode that does not point back:\n  %s",
-				    (bch2_bkey_val_to_text(&buf, c, k),
-				     prt_printf(&buf, "\n  "),
-				     bch2_inode_unpacked_to_text(&buf, &inode_u),
-				     buf.buf))) {
-		ret = -ENOENT;
-		goto err;
-	}
 out:
 	bch2_trans_iter_exit(trans, &dirent_iter);
 	printbuf_exit(&buf);
-- 
2.49.0


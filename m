Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5E7027EC76
	for <linux-bcachefs@vger.kernel.org>; Wed, 18 Jun 2025 21:55:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750283713; cv=none; b=Yl4k6VRK6MQxVYvadCajrGOSpFsd/tJKKYOn9vD0kDq+QHh1C2Ziw//D93CsVgsGz+00WHxbnZYLS9daELTMZnxaa5YG0/oOVc13Ke7UTl1YjlohsAFyTEdEp3mWsw1boob9NU25KOjnZjHkYCx/vCs2Wq9jUfLzMFdYDXz2JDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750283713; c=relaxed/simple;
	bh=iN/vC9jbm//tfODbJocc1cC080KUEfc/bYj2F2D21So=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iPgEW4ncqsg6fFi8yhtvQjqCxiLO4eVaDGc8/J0f9d4Yk2NsyYkb1YtqrDRwm1yXCP21LYE1P8fdjllFydV0ALQs6pGJMqxklh+BOa4AHcmAXH7mZlvvWz9USG0DQl+vTo0I59MMPFiXv08DmKNkDF3V65oVXVfg1DC0MVW1rLI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=PDZnxw5K; arc=none smtp.client-ip=95.215.58.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="PDZnxw5K"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1750283710;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=S+cilbmZnAfDNnTSKY36ZRsggBu/0uNn/ePmfN0gWx4=;
	b=PDZnxw5Kwme6v+K0VGJT/TydBURlU1COQIrL4pQYAkaAwrIyA5LqHWuA/QCCH8HJ4/vHG7
	BlFqRddaCNfWjpRXALqPDh2gqdazG1l2JJJUwDrCN2F9tnmtFxyvm05xhCgrtmTp7DReER
	9TdMmQSupERREjdtfiK7rN3t36aN/JA=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 33/37] bcachefs: fsck: Fix check_directory_structure when no check_dirents
Date: Wed, 18 Jun 2025 17:54:24 -0400
Message-ID: <20250618215431.738317-34-kent.overstreet@linux.dev>
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

check_directory_structure runs after check_dirents, so it expects that
it won't see any inodes with missing backpointers - normally.

But online fsck can't run check_dirents yet, or the user might only be
running a specific pass, so we need to be careful that this isn't an
error. If an inode is unreachable, that's handled by a separate pass.

Also, add a new 'bch2_inode_has_backpointer()' helper, since we were
doing this inconsistently.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/fsck.c  | 18 +++++++++++++-----
 fs/bcachefs/inode.h |  5 +++++
 fs/bcachefs/namei.c |  3 +--
 3 files changed, 19 insertions(+), 7 deletions(-)

diff --git a/fs/bcachefs/fsck.c b/fs/bcachefs/fsck.c
index 73cff24598ed..57ddc20a5cce 100644
--- a/fs/bcachefs/fsck.c
+++ b/fs/bcachefs/fsck.c
@@ -327,7 +327,8 @@ static inline bool inode_should_reattach(struct bch_inode_unpacked *inode)
 	    (inode->bi_flags & BCH_INODE_has_child_snapshot))
 		return false;
 
-	return !inode->bi_dir && !(inode->bi_flags & BCH_INODE_unlinked);
+	return !bch2_inode_has_backpointer(inode) &&
+		!(inode->bi_flags & BCH_INODE_unlinked);
 }
 
 static int maybe_delete_dirent(struct btree_trans *trans, struct bpos d_pos, u32 snapshot)
@@ -514,7 +515,7 @@ static struct bkey_s_c_dirent dirent_get_by_pos(struct btree_trans *trans,
 static int remove_backpointer(struct btree_trans *trans,
 			      struct bch_inode_unpacked *inode)
 {
-	if (!inode->bi_dir)
+	if (!bch2_inode_has_backpointer(inode))
 		return 0;
 
 	u32 snapshot = inode->bi_snapshot;
@@ -1165,13 +1166,14 @@ static int check_inode(struct btree_trans *trans,
 	if (ret)
 		goto err;
 
-	if (u.bi_dir || u.bi_dir_offset) {
+	if (bch2_inode_has_backpointer(&u)) {
 		ret = check_inode_dirent_inode(trans, &u, &do_update);
 		if (ret)
 			goto err;
 	}
 
-	if (fsck_err_on(u.bi_dir && (u.bi_flags & BCH_INODE_unlinked),
+	if (fsck_err_on(bch2_inode_has_backpointer(&u) &&
+			(u.bi_flags & BCH_INODE_unlinked),
 			trans, inode_unlinked_but_has_dirent,
 			"inode unlinked but has dirent\n%s",
 			(printbuf_reset(&buf),
@@ -2751,7 +2753,13 @@ static int check_path_loop(struct btree_trans *trans, struct bkey_s_c inode_k)
 	if (ret)
 		return ret;
 
-	while (!inode.bi_subvol) {
+	/*
+	 * If we're running full fsck, check_dirents() will have already ran,
+	 * and we shouldn't see any missing backpointers here - otherwise that's
+	 * handled separately, by check_unreachable_inodes
+	 */
+	while (!inode.bi_subvol &&
+	       bch2_inode_has_backpointer(&inode)) {
 		struct btree_iter dirent_iter;
 		struct bkey_s_c_dirent d;
 
diff --git a/fs/bcachefs/inode.h b/fs/bcachefs/inode.h
index 82cec2836cbd..b8ec3e628d90 100644
--- a/fs/bcachefs/inode.h
+++ b/fs/bcachefs/inode.h
@@ -254,6 +254,11 @@ static inline bool bch2_inode_casefold(struct bch_fs *c, const struct bch_inode_
 		: c->opts.casefold;
 }
 
+static inline bool bch2_inode_has_backpointer(const struct bch_inode_unpacked *bi)
+{
+	return bi->bi_dir || bi->bi_dir_offset;
+}
+
 /* i_nlink: */
 
 static inline unsigned nlink_bias(umode_t mode)
diff --git a/fs/bcachefs/namei.c b/fs/bcachefs/namei.c
index 7d1068aa998f..c3f87c59922d 100644
--- a/fs/bcachefs/namei.c
+++ b/fs/bcachefs/namei.c
@@ -734,8 +734,7 @@ static int bch2_check_dirent_inode_dirent(struct btree_trans *trans,
 	if (inode_points_to_dirent(target, d))
 		return 0;
 
-	if (!target->bi_dir &&
-	    !target->bi_dir_offset) {
+	if (!bch2_inode_has_backpointer(target)) {
 		fsck_err_on(S_ISDIR(target->bi_mode),
 			    trans, inode_dir_missing_backpointer,
 			    "directory with missing backpointer\n%s",
-- 
2.50.0


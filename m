Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09B2641C63
	for <linux-bcachefs@vger.kernel.org>; Fri, 27 Jun 2025 01:21:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750987290; cv=none; b=bNAjwZW06H6lte28lKkhoSDS9hzvXjZ2PidQkwGosCPP3b8CSK33TRLZ7wOySKzqlujXW9W8f0oCpxyHrJnYskC866hJDqC2VnnEUWUT3PeqCHxcZDqEnTs5HYTa1qLZIPg9YaSO8dyil0YLryGlmnL5hrAg5jjiYro/BLy6fU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750987290; c=relaxed/simple;
	bh=zmp2BR+LTEf7nbM86yaKod0xJjE/UEAE9LnZE2XqcGg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=VtPBCsJ9WFxMa+J54Ec7aqOQjVysuJllF6Yzm8rpxez72Wr8gI/fz2MTDIgi4QtVqIIvdx6/iHaeCno5mgMBX23Qb3m1RzqTd5eBI/eYy1fnh509ePdy90T2dl6i0ela8lUpstLpzxhYfPS7noCPEWyrqrX4IlhwxOeuwQN6HsY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=RSk8vOQP; arc=none smtp.client-ip=91.218.175.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="RSk8vOQP"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1750987286;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0jHEVG0rfttzRt1zyd21KTlJWuRDVM5oEXRmSZeoKDs=;
	b=RSk8vOQPFq4ETnChYLalTFfcHWw9GLAtRMv8dOJszpR0mafoZfH+KvuhcMXWX3eNq48LHI
	0Ve31zltOxka+N54YfBTl5rWlFIok0U7vIaCF6SW/+7INL/AEkhN5GHSKUJEbbNwa3XhqT
	kHVtEloisuubpG13sa60Kx43IW6KVi4=
From: Youling Tang <youling.tang@linux.dev>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: linux-bcachefs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	youling.tang@linux.dev,
	Youling Tang <tangyouling@kylinos.cn>
Subject: [PATCH 3/3] bcachefs: Spilt bchfs_fallocate() into two functions
Date: Fri, 27 Jun 2025 09:21:04 +0800
Message-Id: <20250627012104.222703-3-youling.tang@linux.dev>
In-Reply-To: <20250627012104.222703-1-youling.tang@linux.dev>
References: <20250627012104.222703-1-youling.tang@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Youling Tang <tangyouling@kylinos.cn>

Separating bchfs_fallocate() into two functions to handle
FALLOC_FL_ALLOCATE_RANGE and FALLOC_FL_ZERO_RANGE respectively makes the
code more readable.

Signed-off-by: Youling Tang <tangyouling@kylinos.cn>
---
 fs/bcachefs/fs-io.c | 111 ++++++++++++++++++++++++++++++--------------
 1 file changed, 77 insertions(+), 34 deletions(-)

diff --git a/fs/bcachefs/fs-io.c b/fs/bcachefs/fs-io.c
index 69d3ddd4c6a1..430b59c7b7a3 100644
--- a/fs/bcachefs/fs-io.c
+++ b/fs/bcachefs/fs-io.c
@@ -627,7 +627,7 @@ static noinline long bchfs_fcollapse_finsert(struct bch_inode_info *inode,
 	return ret;
 }
 
-static noinline int __bchfs_fallocate(struct bch_inode_info *inode, int mode,
+static noinline int bchfs_fallocate(struct bch_inode_info *inode, int mode,
 			     u64 start_sector, u64 end_sector)
 {
 	struct bch_fs *c = inode->v.i_sb->s_fs_info;
@@ -757,59 +757,100 @@ static noinline int __bchfs_fallocate(struct bch_inode_info *inode, int mode,
 	return ret;
 }
 
-static noinline long bchfs_fallocate(struct bch_inode_info *inode, int mode,
+static int bchfs_falloc_newsize(struct file *file, int mode, loff_t offset,
+				loff_t len, loff_t *new_size)
+{
+	struct inode *inode = file_inode(file);
+
+	if ((mode & FALLOC_FL_KEEP_SIZE) || offset + len <= i_size_read(inode))
+		return 0;
+	*new_size = offset + len;
+	return inode_newsize_ok(inode, *new_size);
+}
+
+static int bchfs_falloc_setsize(struct bch_fs *c, struct bch_inode_info *inode,
+				loff_t new_size)
+{
+	int ret;
+
+	spin_lock(&inode->v.i_lock);
+	i_size_write(&inode->v, new_size);
+	spin_unlock(&inode->v.i_lock);
+
+	mutex_lock(&inode->ei_update_lock);
+	ret = bch2_write_inode_size(c, inode, new_size, 0);
+	mutex_unlock(&inode->ei_update_lock);
+
+	return ret;
+}
+
+static noinline long bchfs_falloc_allocate_range(struct file *file, int mode,
 			    loff_t offset, loff_t len)
 {
+	struct bch_inode_info *inode = file_bch_inode(file);
 	struct bch_fs *c = inode->v.i_sb->s_fs_info;
 	u64 end		= offset + len;
+	loff_t new_size = 0;
 	u64 block_start	= round_down(offset,	block_bytes(c));
 	u64 block_end	= round_up(end,		block_bytes(c));
+	int ret;
+
+	ret = bchfs_falloc_newsize(file, mode, offset, len, &new_size);
+	if (ret)
+		return ret;
+
+	ret = bchfs_fallocate(inode, mode, block_start >> 9, block_end >> 9);
+	if (ret)
+		return ret;
+
+	if (mode & FALLOC_FL_KEEP_SIZE && end > inode->v.i_size)
+		new_size = inode->v.i_size;
+
+	if (new_size)
+		ret = bchfs_falloc_setsize(c, inode, new_size);
+
+	return ret;
+}
+
+static noinline long bchfs_falloc_zero_range(struct file *file, int mode,
+			    loff_t offset, loff_t len)
+{
+	struct bch_inode_info *inode = file_bch_inode(file);
+	struct bch_fs *c = inode->v.i_sb->s_fs_info;
+	u64 end		= offset + len;
+	loff_t new_size = 0;
+	u64 block_start	= round_up(offset,	block_bytes(c));
+	u64 block_end	= round_down(end,	block_bytes(c));
 	bool truncated_last_page = false;
 	int ret, ret2 = 0;
 
-	if (!(mode & FALLOC_FL_KEEP_SIZE) && end > inode->v.i_size) {
-		ret = inode_newsize_ok(&inode->v, end);
-		if (ret)
-			return ret;
-	}
-
-	if (mode & FALLOC_FL_ZERO_RANGE) {
-		ret = bch2_truncate_folios(inode, offset, end);
-		if (unlikely(ret < 0))
-			return ret;
+	ret = bchfs_falloc_newsize(file, mode, offset, len, &new_size);
+	if (ret)
+		return ret;
 
-		truncated_last_page = ret;
+	ret = bch2_truncate_folios(inode, offset, end);
+	if (unlikely(ret < 0))
+		return ret;
 
-		truncate_pagecache_range(&inode->v, offset, end - 1);
+	truncated_last_page = ret;
 
-		block_start	= round_up(offset,	block_bytes(c));
-		block_end	= round_down(end,	block_bytes(c));
-	}
+	truncate_pagecache_range(&inode->v, offset, end - 1);
 
-	ret = __bchfs_fallocate(inode, mode, block_start >> 9, block_end >> 9);
+	ret = bchfs_fallocate(inode, mode, block_start >> 9, block_end >> 9);
 
 	/*
 	 * On -ENOSPC in ZERO_RANGE mode, we still want to do the inode update,
 	 * so that the VFS cache i_size is consistent with the btree i_size:
 	 */
-	if (ret &&
-	    !(bch2_err_matches(ret, ENOSPC) && (mode & FALLOC_FL_ZERO_RANGE)))
+	if (ret && !(bch2_err_matches(ret, ENOSPC)))
 		return ret;
 
 	if (mode & FALLOC_FL_KEEP_SIZE && end > inode->v.i_size)
-		end = inode->v.i_size;
-
-	if (end >= inode->v.i_size &&
-	    (((mode & FALLOC_FL_ZERO_RANGE) && !truncated_last_page) ||
-	     !(mode & FALLOC_FL_KEEP_SIZE))) {
-		spin_lock(&inode->v.i_lock);
-		i_size_write(&inode->v, end);
-		spin_unlock(&inode->v.i_lock);
-
-		mutex_lock(&inode->ei_update_lock);
-		ret2 = bch2_write_inode_size(c, inode, end, 0);
-		mutex_unlock(&inode->ei_update_lock);
-	}
+		new_size = inode->v.i_size;
+
+	if (new_size &&
+	    ((!truncated_last_page) || !(mode & FALLOC_FL_KEEP_SIZE)))
+		ret2 = bchfs_falloc_setsize(c, inode, new_size);
 
 	return ret ?: ret2;
 }
@@ -843,8 +884,10 @@ long bch2_fallocate_dispatch(struct file *file, int mode,
 
 	switch (mode & FALLOC_FL_MODE_MASK) {
 	case FALLOC_FL_ALLOCATE_RANGE:
+		ret = bchfs_falloc_allocate_range(file, mode, offset, len);
+		break;
 	case FALLOC_FL_ZERO_RANGE:
-		ret = bchfs_fallocate(inode, mode, offset, len);
+		ret = bchfs_falloc_zero_range(file, mode, offset, len);
 		break;
 	case FALLOC_FL_PUNCH_HOLE:
 		ret = bchfs_fpunch(inode, offset, len);
-- 
2.34.1


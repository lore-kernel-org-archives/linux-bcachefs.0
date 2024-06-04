Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FADF1411F7;
	Tue,  4 Jun 2024 08:47:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717490838; cv=none; b=gKfPBractDIUzdbgdne8u/RDJrLmd9sxea4nFiKPt6f35VTyTB3wuB9lW7qepx6doTk7PMmJourkZTCZIVc8TP1boRpnCU8lv3Aoae0DbKlZWNxiC3xvskt4HHrRARnnsqNOqk175VD+HHg7tYVIZcSNhBIekwlbOlhsyvnfz9M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717490838; c=relaxed/simple;
	bh=AA3Rl+0xtoO3H2LbG1/6LvDkAhOdb8JORN3HMqGymmM=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=GxWh3WUMng6WT52sn9niKLjpLar5RF7Cyz5DORTvW70MnYSkLJBZNNuqNfDxUXchKlJ001Hoe35rljqcl1IrIL9jrx0ImHwMAXgqG13Gly9RHVSYegdr8/Zz68qcXxrltXJtVMAjBCyRkwM2WBZM+rrwXoaHoxH+rQA/R08fIOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=SxzTzenQ; arc=none smtp.client-ip=91.218.175.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="SxzTzenQ"
X-Envelope-To: kent.overstreet@linux.dev
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1717490828;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=N5wvSoM1bL8UEGO0xicxwbrkdQzMxVrx45Djt/Yqlo4=;
	b=SxzTzenQU2gRcWNmDyi3KT0CkG4KlH+4yuYh/rWhSz5DyAEPTX1pBqnzMzXomi2A+bvX+0
	D8bGxabvlNGlmv+mCj0/UdyGE6FzEThL4an+GnnXkcFQdCBJamCu0x9vi4S8QYMA98HnJn
	q8nk+yqzBKT4X6EEJ6dx8QDlDE5Q+7g=
X-Envelope-To: bfoster@redhat.com
X-Envelope-To: linux-bcachefs@vger.kernel.org
X-Envelope-To: linux-kernel@vger.kernel.org
X-Envelope-To: tangyouling@kylinos.cn
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Youling Tang <youling.tang@linux.dev>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Brian Foster <bfoster@redhat.com>,
	linux-bcachefs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Youling Tang <tangyouling@kylinos.cn>
Subject: [PATCH] bcachefs: Move the ei_flags setting to after initialization
Date: Tue,  4 Jun 2024 16:46:10 +0800
Message-Id: <20240604084610.94558-1-youling.tang@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Youling Tang <tangyouling@kylinos.cn>

`inode->ei_flags` setting and cleaning should be done after initialization,
otherwise the operation is invalid.

Fixes: 9ca4853b98af ("bcachefs: Fix quota support for snapshots")
Signed-off-by: Youling Tang <tangyouling@kylinos.cn>
---
 fs/bcachefs/fs.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/bcachefs/fs.c b/fs/bcachefs/fs.c
index 0695f478e206..21e5fe296ac8 100644
--- a/fs/bcachefs/fs.c
+++ b/fs/bcachefs/fs.c
@@ -1488,11 +1488,6 @@ static void bch2_vfs_inode_init(struct btree_trans *trans, subvol_inum inum,
 	bch2_iget5_set(&inode->v, &inum);
 	bch2_inode_update_after_write(trans, inode, bi, ~0);
 
-	if (BCH_SUBVOLUME_SNAP(subvol))
-		set_bit(EI_INODE_SNAPSHOT, &inode->ei_flags);
-	else
-		clear_bit(EI_INODE_SNAPSHOT, &inode->ei_flags);
-
 	inode->v.i_blocks	= bi->bi_sectors;
 	inode->v.i_ino		= bi->bi_inum;
 	inode->v.i_rdev		= bi->bi_dev;
@@ -1504,6 +1499,11 @@ static void bch2_vfs_inode_init(struct btree_trans *trans, subvol_inum inum,
 	inode->ei_qid		= bch_qid(bi);
 	inode->ei_subvol	= inum.subvol;
 
+	if (BCH_SUBVOLUME_SNAP(subvol))
+		set_bit(EI_INODE_SNAPSHOT, &inode->ei_flags);
+	else
+		clear_bit(EI_INODE_SNAPSHOT, &inode->ei_flags);
+
 	inode->v.i_mapping->a_ops = &bch_address_space_operations;
 
 	switch (inode->v.i_mode & S_IFMT) {
-- 
2.34.1


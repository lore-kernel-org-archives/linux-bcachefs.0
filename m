Received: from out-178.mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE1FA15ACA
	for <linux-bcachefs@vger.kernel.org>; Tue, 16 Jul 2024 02:58:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721098736; cv=none; b=rEIoOd09W2YOyRudvsdwoYF0QgCTK63b1JHYAVcFCKPqutX0BBUvylTOUCn8Yd6uheSYBzPoEyyLAEfdnYSZmr/Gmz44H/eHyv7Av9W1/WZU+Nhig2GmjhmA3ca3mrnWSNvaegxrvSTK5chp7GNnr+H5iA1dzQkbPjGYPeYosJg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721098736; c=relaxed/simple;
	bh=x93ZBrrNvd/f8ZMmLO3v1L6XGSHURwuLBGCMZo4HrFc=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=GJI9lpqbxANuttCZ6Desaw1qhn1VlWo5/0pIRJnV28dXfhQorcCExBr1ub5c/0kf6OdCRwpi+2f3L+TB3bx3FlP5o0mcywtbxvLb5wfAspSK5taFMcS0vSiaennPdMGGjIxvzQPCB9zyTin/7H9wX6ADGO01EB+U3CObeZcNW24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=jlyZvg+1; arc=none smtp.client-ip=95.215.58.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="jlyZvg+1"
X-Envelope-To: kent.overstreet@linux.dev
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1721098731;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=osOBeiU2E0wMhfDJ/xZ4r4HlfwEbTbhRB9j7IQx7WZc=;
	b=jlyZvg+1EKgEB9S/BDbMCoURP/GAfE0wJkx0F8k3rtUf86MuNrD44D4Y4ZTuPxs8bp1WJM
	d1BS2gFQVAM2ZjpJisszszZ1/05+t5/OCHF7CchrMHygmHqNpuIGxfLiLYBBvo+ldXfZQX
	4wQwy4263SCsc8VpFCwsh4Sn5EOxEVo=
X-Envelope-To: youling.tang@linux.dev
X-Envelope-To: zhengqi.arch@bytedance.com
X-Envelope-To: linux-kernel@vger.kernel.org
X-Envelope-To: linux-bcachefs@vger.kernel.org
X-Envelope-To: tangyouling@kylinos.cn
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Youling Tang <youling.tang@linux.dev>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Youling Tang <youling.tang@linux.dev>,
	Qi Zheng <zhengqi.arch@bytedance.com>,
	linux-kernel@vger.kernel.org,
	linux-bcachefs@vger.kernel.org,
	Youling Tang <tangyouling@kylinos.cn>
Subject: [PATCH] bcachefs: allocate inode by using alloc_inode_sb()
Date: Tue, 16 Jul 2024 10:58:16 +0800
Message-Id: <20240716025816.52156-1-youling.tang@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Youling Tang <tangyouling@kylinos.cn>

The inode allocation is supposed to use alloc_inode_sb(), so convert
kmem_cache_alloc() to alloc_inode_sb().

It will also fix [1] to avoid the NULL pointer dereference BUG in
list_lru_add() when CONFIG_MEMCG is enabled.

Links:
[1]: https://lore.kernel.org/all/20589721-46c0-4344-b2ef-6ab48bbe2ea5@linux.dev/
[2]: https://lore.kernel.org/all/7db60e36-9c96-4938-a28d-a9745e287386@linux.dev/

Fixes: 86d81ec5f5f0 ("bcachefs: Mark bch_inode_info as SLAB_ACCOUNT")
Signed-off-by: Youling Tang <tangyouling@kylinos.cn>
---
 fs/bcachefs/fs.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/bcachefs/fs.c b/fs/bcachefs/fs.c
index f9c9a95d7d4c..34649ed2e3a1 100644
--- a/fs/bcachefs/fs.c
+++ b/fs/bcachefs/fs.c
@@ -227,7 +227,8 @@ static struct inode *bch2_alloc_inode(struct super_block *sb)
 
 static struct bch_inode_info *__bch2_new_inode(struct bch_fs *c)
 {
-	struct bch_inode_info *inode = kmem_cache_alloc(bch2_inode_cache, GFP_NOFS);
+	struct bch_inode_info *inode = alloc_inode_sb(c->vfs_sb,
+						bch2_inode_cache, GFP_NOFS);
 	if (!inode)
 		return NULL;
 
-- 
2.34.1

Received: from out-183.mta1.migadu.com (out-183.mta1.migadu.com [95.215.58.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0928C4DA14
	for <linux-bcachefs@vger.kernel.org>; Wed,  3 Jul 2024 07:10:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719990629; cv=none; b=iHg7bqqrXtmLHnTRrJUSsRk5YrGitTg9/BBnlezjA37sKBFmek8fW68JTQ3KjfUq0e2vRV0qD7Pih383Lh5pSlrIXZSSJMmSu+apNEk+lRG6GZjm6SkeFvFX49tPHwR26EpvBFXX3jBJnXs/YGy2BCGSOxsuRiGT3fqJ+NHOwpo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719990629; c=relaxed/simple;
	bh=OlwUiCXewDyw3zYSLPgZ1L2XZ7B8RYL2CMyOeckMhdc=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Qtsm6HIcUk9f5UOMdaVyuiIzvgh++h7np7GZvGICJ+fn348vJq+iHLwPNpwDOu8IEW5EF2gEvUpYgIMPZkoGhz8TZ1im7o9E8HlMzVRcf3KtdYmrJPukQzFsXBXkQVOg8swTGKyOlO6yxlvV5k/RTQGIuifR2/4bRgP3dCY1fro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=kQadzdev; arc=none smtp.client-ip=95.215.58.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="kQadzdev"
X-Envelope-To: kent.overstreet@linux.dev
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1719990623;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=bhgTv6ReHO7QsWKhJp5T5JfpRyE52nnWo5na3qgj96s=;
	b=kQadzdevaT4Yinmvis3gGKRPoTnuOB5xxjFi8mBkz2rgTiPZiGaKSaf+sRpGjOheiIdhps
	yaXmsIInA40LqMRwUHLzFciZUDcbg9BuERjq/cfkRqlHKKKLCMeTkrFRB9fgZvy5oCYCTN
	VySLjQODtfpAQB6U1a6rDcpqt0BrlfU=
X-Envelope-To: linux-bcachefs@vger.kernel.org
X-Envelope-To: linux-kernel@vger.kernel.org
X-Envelope-To: youling.tang@linux.dev
X-Envelope-To: tangyouling@kylinos.cn
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Youling Tang <youling.tang@linux.dev>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: linux-bcachefs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	youling.tang@linux.dev,
	Youling Tang <tangyouling@kylinos.cn>
Subject: [PATCH] bcachefs: Mark bch_inode_info as SLAB_ACCOUNT
Date: Wed,  3 Jul 2024 15:09:55 +0800
Message-Id: <20240703070955.104163-1-youling.tang@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Youling Tang <tangyouling@kylinos.cn>

After commit 230e9fc28604 ("slab: add SLAB_ACCOUNT flag"), we need to mark
the inode cache as SLAB_ACCOUNT, similar to commit 5d097056c9a0 ("kmemcg:
account for certain kmem allocations to memcg")

Signed-off-by: Youling Tang <tangyouling@kylinos.cn>
---
 fs/bcachefs/fs.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/bcachefs/fs.c b/fs/bcachefs/fs.c
index be7eda94b459..092f95426dce 100644
--- a/fs/bcachefs/fs.c
+++ b/fs/bcachefs/fs.c
@@ -2126,7 +2126,8 @@ int __init bch2_vfs_init(void)
 {
 	int ret = -ENOMEM;
 
-	bch2_inode_cache = KMEM_CACHE(bch_inode_info, SLAB_RECLAIM_ACCOUNT);
+	bch2_inode_cache = KMEM_CACHE(bch_inode_info, SLAB_RECLAIM_ACCOUNT |
+				      SLAB_ACCOUNT);
 	if (!bch2_inode_cache)
 		goto err;
 
-- 
2.34.1


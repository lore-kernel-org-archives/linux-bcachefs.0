Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 721C918991B
	for <linux-bcachefs@vger.kernel.org>; Fri, 27 Sep 2024 08:41:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727426471; cv=none; b=EzEaKsMkjF8a3hlR89ZzIoqSj/3Q5PWEfu494/ahHUo9vATyuhKUOH6VEPgVDehGfBEFSadSQ8Uhwd5AVVGi2+TYeyWJhJHA2uaEgXYpBabM7wMfybAuiLRuRJ60DwmbICg8wy3RSfIritYe4bg3M6tJ8+tycFD+sBj0g8/npwc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727426471; c=relaxed/simple;
	bh=dxFocZxce+i2W1argoetFG02OToqUVITXXHwN45rOJQ=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=mowmkdbAOM1gAx01gfc1sinRZMGK+L/MPtlWCChNzknITrQozEiB/IXbXY5Ae2EwexnNrotxXyNYYuzJNLG2a0HNP49hRQUuejqhnWeg5re2G33oL4ZBXXGAn41GREehDC7I38zelXUEncTYwQP/1Z4fF4WnJlaaX6NxcdI79Pw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=lAL3aABK; arc=none smtp.client-ip=95.215.58.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="lAL3aABK"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1727426464;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=xleER/j794d3ps/0a/VZqhkNaYHQ4vOeDmp7xSkpUEY=;
	b=lAL3aABKfJg4EvPnt4czMlE514jnn30xjneKYq/RY7eiOSead90bTMwZ83C9E1SVhIgpCU
	HXSdck3prdt80FQFGm4lQsN6KBhGWz/Q3mjdmwAnnBMWC+amcI0k2HapvoQbVnmkeXi3NK
	ncnR7uKQnGnWNu7sokGJ9JEahNZKdbY=
From: Youling Tang <youling.tang@linux.dev>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: linux-bcachefs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	youling.tang@linux.dev,
	Youling Tang <tangyouling@kylinos.cn>
Subject: [PATCH] bcachefs: Remove redundant initialization in bch2_vfs_inode_init()
Date: Fri, 27 Sep 2024 16:40:42 +0800
Message-Id: <20240927084042.1516361-1-youling.tang@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Youling Tang <tangyouling@kylinos.cn>

`inode->v.i_ino` has been initialized to `inum.inum`. If `inum.inum` and
`bi->bi_inum` are not equal, BUG_ON() is triggered in
bch2_inode_update_after_write().

Signed-off-by: Youling Tang <tangyouling@kylinos.cn>
---
 fs/bcachefs/fs.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/bcachefs/fs.c b/fs/bcachefs/fs.c
index 4a1bb07a2574..d90ef295c5b1 100644
--- a/fs/bcachefs/fs.c
+++ b/fs/bcachefs/fs.c
@@ -1637,7 +1637,6 @@ static void bch2_vfs_inode_init(struct btree_trans *trans,
 	bch2_inode_update_after_write(trans, inode, bi, ~0);
 
 	inode->v.i_blocks	= bi->bi_sectors;
-	inode->v.i_ino		= bi->bi_inum;
 	inode->v.i_rdev		= bi->bi_dev;
 	inode->v.i_generation	= bi->bi_generation;
 	inode->v.i_size		= bi->bi_size;
-- 
2.34.1


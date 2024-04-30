Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C96110A01
	for <linux-bcachefs@vger.kernel.org>; Tue, 30 Apr 2024 03:29:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714447759; cv=none; b=e/LHeXV/5wKB7PwP7lNoyaZFN0N2xI5afCxn3/Dg0MxiftaBoxrjL7LT01avGgsHBlJCsXOk/Q4ZFF7MbDDMDdEeq8xlBpr6vfrgdldYchq7y4Z+85FmXbGpB3SRcIWYiAJGEUL0R3uEE2DzGqWO9geex8iUBt10surdooIOGHs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714447759; c=relaxed/simple;
	bh=VnRQqHRFLfqPj2Ruvuw9m2DS64Doca7tfk1HEDj7DHA=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=ipx0wFLcHJaf8COx1zyzU1z2OW7ax2nRVVsB80sjbLnlq7KctAhhCs6PTw1+q1XyHtpxHkkSe+j1sYlc460kzWIkE8ITlqtvKpSVdXFOszPhKkGkxMW3O+4+VWd11xMC7F+MsSc2WBctkWnrTU2OfCesm94RMbwUij8lbSvLgd0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=vqLaqusM; arc=none smtp.client-ip=91.218.175.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="vqLaqusM"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1714447754;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=rT1B236ATkF+Ygc2oPrbUXgNg8LDfbudCEbrCvlSDsk=;
	b=vqLaqusMXP++rirvu4u2Sm1t9uhp7geyDr7eFEcy4hSiMKnM2JlmMlnQKO6wF/5mnw8hJZ
	JczWH9fVezQBgUZ5KxJeyP8z6Xrbh+0HCR3YaXtbfIkWLUx7yT3kpDm3MGkVMDihb0YnPc
	bQc9xot/qqpNojQMUmL3S2Jb/J0x6s4=
From: Youling Tang <youling.tang@linux.dev>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: linux-bcachefs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Youling Tang <tangyouling@kylinos.cn>
Subject: [PATCH] bcachefs: Fix error path of bch2_link_trans()
Date: Tue, 30 Apr 2024 11:28:39 +0800
Message-Id: <20240430032839.948404-1-youling.tang@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Youling Tang <tangyouling@kylinos.cn>

In bch2_link_trans(), if bch2_inode_nlink_inc() fails, it needs to
call bch2_trans_iter_exit() in the error path.

Signed-off-by: Youling Tang <tangyouling@kylinos.cn>
---
 fs/bcachefs/fs-common.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/bcachefs/fs-common.c b/fs/bcachefs/fs-common.c
index 6c737def357e..508d029ac53d 100644
--- a/fs/bcachefs/fs-common.c
+++ b/fs/bcachefs/fs-common.c
@@ -200,12 +200,12 @@ int bch2_link_trans(struct btree_trans *trans,
 
 	ret = bch2_inode_peek(trans, &inode_iter, inode_u, inum, BTREE_ITER_intent);
 	if (ret)
-		goto err;
+		return ret;
 
 	inode_u->bi_ctime = now;
 	ret = bch2_inode_nlink_inc(inode_u);
 	if (ret)
-		return ret;
+		goto err;
 
 	ret = bch2_inode_peek(trans, &dir_iter, dir_u, dir, BTREE_ITER_intent);
 	if (ret)
-- 
2.34.1


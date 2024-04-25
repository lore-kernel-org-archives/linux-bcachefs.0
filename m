Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D8EF128363
	for <linux-bcachefs@vger.kernel.org>; Thu, 25 Apr 2024 09:17:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714036665; cv=none; b=IQ0H0R8z+C8ekZDfDxRoYvhNH6XrNCEaNd3XLc5PSlCuut1hsZSe2L8eTZ6UEJBFvG7DsOdjS4t0Faut77x6nPZ8z2u3aVm/6skI/63qAhPoBo52sedhRXCWwBgaoovq3IJ4jlc/W6Mv9/ob8PO9GfluV96WNXtus6fFIa/gu48=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714036665; c=relaxed/simple;
	bh=65YKvGP5ldFEl9ghgHolAKwSIFb4oPQzeVo0l5Pgbv4=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=aEDPOdEkk7077UcKZeTUzUygU8E0//n6yZUumXpMTWt+w1LeSK9yVKAQliBk7UwYV7BnwGrJLcfp1/9jkNKUcL447ukawY1MS2Xfhg7ZhQZ0LyKjSdKlvjD4PY/rYnFIvUgVWUwyu873PPGZNmNpXNSJJjCD1sz0qjkcQQZYZzU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=HQBOLnHA; arc=none smtp.client-ip=95.215.58.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="HQBOLnHA"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1714036661;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=w9QN+P4vB8I0CAC9KqWe0wqLc0QQQLpQU5nSVu5xq8Q=;
	b=HQBOLnHAvyMVhYpOUP0Uy4vb/0VlhxF6hu9ZovWP9+FnnMWH6ZO3dz+BEbGKZdPoUdksWg
	MvsPvYKnkSYuX60kwCTS2RFbFOPiJYG9INYQrfQsbzEZFcgcJZ8ZhFkV9J/16qhEda74+B
	rdodoLIv02D7/9owtFkLy+FjIkYsKW0=
From: Youling Tang <youling.tang@linux.dev>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: linux-bcachefs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Youling Tang <tangyouling@kylinos.cn>
Subject: [PATCH] bcachefs: Use filemap_read() to simplify the execution flow
Date: Thu, 25 Apr 2024 17:16:59 +0800
Message-Id: <20240425091659.6148-1-youling.tang@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Youling Tang <tangyouling@kylinos.cn>

Using filemap_read() can reduce unnecessary code execution
for non IOCB_DIRECT paths.

Signed-off-by: Youling Tang <tangyouling@kylinos.cn>
---
 fs/bcachefs/fs-io-direct.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/bcachefs/fs-io-direct.c b/fs/bcachefs/fs-io-direct.c
index 09d21aef879a..4072a6ba0d51 100644
--- a/fs/bcachefs/fs-io-direct.c
+++ b/fs/bcachefs/fs-io-direct.c
@@ -179,7 +179,7 @@ ssize_t bch2_read_iter(struct kiocb *iocb, struct iov_iter *iter)
 	struct bch_inode_info *inode = file_bch_inode(file);
 	struct address_space *mapping = file->f_mapping;
 	size_t count = iov_iter_count(iter);
-	ssize_t ret;
+	ssize_t ret = 0;
 
 	if (!count)
 		return 0; /* skip atime */
@@ -205,7 +205,7 @@ ssize_t bch2_read_iter(struct kiocb *iocb, struct iov_iter *iter)
 			iocb->ki_pos += ret;
 	} else {
 		bch2_pagecache_add_get(inode);
-		ret = generic_file_read_iter(iocb, iter);
+		ret = filemap_read(iocb, iter, ret);
 		bch2_pagecache_add_put(inode);
 	}
 out:
-- 
2.34.1


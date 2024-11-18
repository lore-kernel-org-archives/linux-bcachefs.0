Received: from out-171.mta1.migadu.com (out-171.mta1.migadu.com [95.215.58.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05862360
	for <linux-bcachefs@vger.kernel.org>; Mon, 18 Nov 2024 01:36:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731893799; cv=none; b=Fgcwl7m/wxQ+qCpD3RJUED34F/eYdl7koBJEfK1+HUBE9Clp6dNijodMo3nYD+IV4Pr0b8Jwd5ShprR2u5bnTlTLXkbsn1ZjOhYGrki4wCX5JjG+rmQfNBSxNVHZ/WTSq1GK2ox2pXDkqpofPYGjYJ7p5el9Hv9A/ghAUEnc0Xk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731893799; c=relaxed/simple;
	bh=+U2h8OWKgkWWgF0Ka/cW4T4tJTeft9j3l6d789NeTKY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=XT6b6kw4VlLv9yxnV4ZlHI2p7P4GkGNYUyAQoK/KBboOHFZMJm+ZtufmNry/KQfFGMu3SYYD0b6eDUS5ZnckT/D3jEN48BIo/ATpkoUqVJIBauIdEJEYTQNRaF3b8QOEFnq/V5xcHEyqmAB3WyjLEcbV7Ze/YsUbngopabwsl0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=H2tt9Be4; arc=none smtp.client-ip=95.215.58.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="H2tt9Be4"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1731893796;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=SODg/e4DKNdfxDSxJ2am3cQe6GgmtPguVkudGOVW3F4=;
	b=H2tt9Be4D7RmMcM3Va3nkX6GHTdq1UdEeJChsJLNRvx4VVvKaDW/QKmTh0aFgSs444vTDg
	TDp4TeBMSZwDsz6rLMEjIit7zNLyu+yEg7+gL9MPC7NKKTWSjMnz79XDJbKjRV3mUh2JWk
	9sg9qF4xvV/vIzDKTq13o/zWYXu2mRQ=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH] bcachefs: add missing BTREE_ITER_intent
Date: Sun, 17 Nov 2024 20:36:21 -0500
Message-ID: <20241118013621.2275126-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

this fixes excessive transaction restarts due to trans_commit having to
upgrade

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/io_write.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/bcachefs/io_write.c b/fs/bcachefs/io_write.c
index f11e11279f01..f97ebb30f6c0 100644
--- a/fs/bcachefs/io_write.c
+++ b/fs/bcachefs/io_write.c
@@ -216,6 +216,7 @@ static inline int bch2_extent_update_i_size_sectors(struct btree_trans *trans,
 			      SPOS(0,
 				   extent_iter->pos.inode,
 				   extent_iter->snapshot),
+			      BTREE_ITER_intent|
 			      BTREE_ITER_cached);
 	int ret = bkey_err(k);
 	if (unlikely(ret))
-- 
2.45.2


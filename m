Received: from mail-m19731117.qiye.163.com (mail-m19731117.qiye.163.com [220.197.31.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E0761F4634
	for <linux-bcachefs@vger.kernel.org>; Fri, 29 Aug 2025 06:16:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.117
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756448173; cv=none; b=dGT2+AP++JVqnp2PySOboJ8nOvfJSUxBczoKq0lLDmUi7Z88m5SmdNisy/dTtchBwsJeOyt3I4I0UzmZnyeZLZ5wF6pZnp+eMqO+Jy7A2PNRe8KAvod2OEJN7FxPKH+S9JGBbJi76bW09+zDiLrTCxhLNOT7XbscRMyBC9oYlw0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756448173; c=relaxed/simple;
	bh=L+0MpWnRDQJZQ8ggjTwYW5IW7cylSNaCMRpgoBK2F3s=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=QcWsSp9v+Jrn2sJJ34CPIR0snUAuSu5GJX6aeT8XdSDlP3crbwCN6OoOiCdlAw8yDXeUKxE0Cm2mrfvhJfKYHMARRxfNSUwJKJlEdEcdgkV5fVXnVoSDalwFNhu3U3O5JaDMpGc1YMEVzdpwdXDEbK/wqE86GdX6NMNib5w+SSw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=easystack.cn; spf=pass smtp.mailfrom=easystack.cn; arc=none smtp.client-ip=220.197.31.117
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=easystack.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=easystack.cn
Received: from localhost.localdomain (unknown [218.94.118.90])
	by smtp.qiye.163.com (Hmail) with ESMTP id f5db89ba;
	Fri, 29 Aug 2025 11:53:34 +0800 (GMT+08:00)
From: Zhen Ni <zhen.ni@easystack.cn>
To: kent.overstreet@linux.dev
Cc: linux-bcachefs@vger.kernel.org,
	Zhen Ni <zhen.ni@easystack.cn>
Subject: [PATCH] bcachefs: Remove redundant null pointer checks in bch2_fs_debug_init()
Date: Fri, 29 Aug 2025 11:53:26 +0800
Message-Id: <20250829035326.1616431-1-zhen.ni@easystack.cn>
X-Mailer: git-send-email 2.20.1
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0a98f3f595560229kunma00e2bf155bd4d
X-HM-MType: 1
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFJQjdXWS1ZQUlXWQ8JGhUIEh9ZQVlCTEpKVk0fTkpIHU9CGEJKGlYVFAkWGhdVGRETFh
	oSFyQUDg9ZV1kYEgtZQVlJSkNVQk9VSkpDVUJLWVdZFhoPEhUdFFlBWU9LSFVKS0lCQ0JKVUpLS1
	VLWQY+

Since the debugfs_create_dir() never returns a null pointer, checking
the return value for a null pointer is redundant, and using IS_ERR is
safe enough.

Signed-off-by: Zhen Ni <zhen.ni@easystack.cn>
---
 fs/bcachefs/debug.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/bcachefs/debug.c b/fs/bcachefs/debug.c
index 07c2a0f73cc2..3aa53a3b5208 100644
--- a/fs/bcachefs/debug.c
+++ b/fs/bcachefs/debug.c
@@ -943,7 +943,7 @@ void bch2_fs_debug_init(struct bch_fs *c)
 		strscpy(name, c->name, sizeof(name));
 
 	c->fs_debug_dir = debugfs_create_dir(name, bch_debug);
-	if (IS_ERR_OR_NULL(c->fs_debug_dir))
+	if (IS_ERR(c->fs_debug_dir))
 		return;
 
 	debugfs_create_file("cached_btree_nodes", 0400, c->fs_debug_dir,
@@ -970,7 +970,7 @@ void bch2_fs_debug_init(struct bch_fs *c)
 	bch2_fs_async_obj_debugfs_init(c);
 
 	c->btree_debug_dir = debugfs_create_dir("btrees", c->fs_debug_dir);
-	if (IS_ERR_OR_NULL(c->btree_debug_dir))
+	if (IS_ERR(c->btree_debug_dir))
 		return;
 
 	for (bd = c->btree_debug;
-- 
2.20.1


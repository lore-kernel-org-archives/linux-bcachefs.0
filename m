Received: from out-171.mta1.migadu.com (out-171.mta1.migadu.com [95.215.58.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A99B27E067
	for <linux-bcachefs@vger.kernel.org>; Wed, 18 Jun 2025 21:54:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750283696; cv=none; b=rH870o0NL7USFBh0n47dKQ4N1JLu3CcYtHipQAXfqg6JIlzuJrjOds+OwSNc9QpXnnLG+cYKhpzv8GU/epuCKBO7e9dDONaTbk2EZHWSAdOIpL0QVM3Ya9cLbeKs6Bw4kDsSYuSNS2iPrdpOyxyc8fW42tM9qoD28y69ZSp+ZBY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750283696; c=relaxed/simple;
	bh=PKuKa/k4IPl8QMS6Zp3TrIFbyUiqaq8zCKdbtDm0d7E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UniDMxQ+40S1b1kek+OPOIkQMZ90XBvo538tlCnIHa4YQIgS4th8LU+ekqtA/x7j6wYFbCf2qLMsrZAUG7vaJy+labPTA4vMTk+0BhAKNTLVu5gKQF3yXAbQT51j3Ftuv+Qk/ZMOyEgBelept8oM3WVbJfeAP4UdTZQsWENL0Gg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=dpriRi5f; arc=none smtp.client-ip=95.215.58.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="dpriRi5f"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1750283692;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WNBPIOb780rmQugv/bbSTkuVKpK+9jocSanWJ34SM2w=;
	b=dpriRi5fr0rfPUOJBC4EP20OXo5uByljPQEWDa5cZBindxHoQ7Bv/45j60xVBSVxhxZnGq
	ZF1eFjHKgnh+oB1ee1WEzYK56KZlud6j2YOXjl2lpj9/4v1tG5llPZ7g1AXmTYbRV0hnmc
	b8jQz/bys9Kfw9l7yX/aOLHssmIkP4A=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 13/37] bcachefs: fsck: fix add_inode()
Date: Wed, 18 Jun 2025 17:54:04 -0400
Message-ID: <20250618215431.738317-14-kent.overstreet@linux.dev>
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

the inode btree uses the offset field for the inum, not the inode field.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/fsck.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/bcachefs/fsck.c b/fs/bcachefs/fsck.c
index b80a56e19b40..28ca07c0e029 100644
--- a/fs/bcachefs/fsck.c
+++ b/fs/bcachefs/fsck.c
@@ -806,7 +806,7 @@ static int add_inode(struct bch_fs *c, struct inode_walker *w,
 	if (!n->whiteout) {
 		return bch2_inode_unpack(inode, &n->inode);
 	} else {
-		n->inode.bi_inum	= inode.k->p.inode;
+		n->inode.bi_inum	= inode.k->p.offset;
 		n->inode.bi_snapshot	= inode.k->p.snapshot;
 		return 0;
 	}
-- 
2.50.0


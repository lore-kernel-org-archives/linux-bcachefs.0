Received: from out-183.mta1.migadu.com (out-183.mta1.migadu.com [95.215.58.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F11821CFEF
	for <linux-bcachefs@vger.kernel.org>; Wed, 18 Jun 2025 21:55:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750283709; cv=none; b=NUdXeM5Aq1RRJJ7QtxZaullG9VuslqY8oB+CZN81vs3hxldtwmgvFOjVtgZbaVXQLZYXyLoQxtpL4vv3jM9NhLotDjG886DSwgvo1eCx+eQbsNXaPuNjIA7LCHqS+9gUDEdVcwzZJQ/ZCldkson6lxjZ7MUrYLnHi2HbFzsoGDg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750283709; c=relaxed/simple;
	bh=ZZsjcby8i3o30JT9m7apwtnw8eibsusjBUQF6Pan+mk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=snAgOrH9j3KipZ5R/RzveaZcww3LVR5y8mrbyXvWmPUFm/TXkho5vi+Bfp2EilNIU0JKul4XzXmOeb+vQE+sIjzq9qy9PysKlU+aXuCjc903UHIcAl9jmuRDpCqPqPxA0uTx0y1x4+PF4aynKe6xB7hN29Zx4KLHXPGefiGtZzw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ESHO/3c/; arc=none smtp.client-ip=95.215.58.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ESHO/3c/"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1750283706;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3LTYjUj0c7ofQNEvdXSrkBMm8KBZisxOqdxQV9YwZCk=;
	b=ESHO/3c/6wm7zKZF8NVjmlA1pf3t6hXLHQEHrKAt5HA33CTpmz8/det3InYnhEMWgNmdY/
	YMq05icvLH3OAqmT96OJzQniGwT364u4gzAAf+R1oMBdNUYH9/p/8ozAlcO4GM+MZG/yty
	hDVCnHu6hZ6ayPzy5WT5SWMFUZF2Jsg=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 28/37] bcachefs: fsck: additional diagnostics for reattach_inode()
Date: Wed, 18 Jun 2025 17:54:19 -0400
Message-ID: <20250618215431.738317-29-kent.overstreet@linux.dev>
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

Log the inode's new path.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/fsck.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/fs/bcachefs/fsck.c b/fs/bcachefs/fsck.c
index 7414a16af990..f2c8e904acab 100644
--- a/fs/bcachefs/fsck.c
+++ b/fs/bcachefs/fsck.c
@@ -399,6 +399,8 @@ static int reattach_inode(struct btree_trans *trans, struct bch_inode_unpacked *
 	if (ret)
 		return ret;
 
+	bch_verbose(c, "got lostfound inum %llu", lostfound.bi_inum);
+
 	lostfound.bi_nlink += S_ISDIR(inode->bi_mode);
 
 	/* ensure lost+found inode is also present in inode snapshot */
@@ -435,6 +437,16 @@ static int reattach_inode(struct btree_trans *trans, struct bch_inode_unpacked *
 	if (ret)
 		return ret;
 
+	{
+		CLASS(printbuf, buf)();
+		ret = bch2_inum_snapshot_to_path(trans, inode->bi_inum,
+						 inode->bi_snapshot, NULL, &buf);
+		if (ret)
+			return ret;
+
+		bch_info(c, "reattached at %s", buf.buf);
+	}
+
 	/*
 	 * Fix up inodes in child snapshots: if they should also be reattached
 	 * update the backpointer field, if they should not be we need to emit
-- 
2.50.0


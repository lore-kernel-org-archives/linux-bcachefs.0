Received: from out-183.mta1.migadu.com (out-183.mta1.migadu.com [95.215.58.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64B8E42A96
	for <linux-bcachefs@vger.kernel.org>; Thu,  3 Apr 2025 17:17:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743700683; cv=none; b=e5/YzqPCHpmaby7ek0Z7XnGv2AYw7r07vhC1yM2qdJ9KxF6zTWo0y4LqlNfx/JJCEemFrvjpqWfk1BhYW+eKMQdGB+bXf+qilu6MDgkNrZGsnobvEOSqHPpMlkQBeAlErFu/FRgq6nnGJERng9OZy//faFXUMXRSzwTCl9NqauA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743700683; c=relaxed/simple;
	bh=HQfh81VIIJsJAElSrooBiWctYGtjORFQuTYT8DaA4eo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=CsrFSUWgs8ckPRbYml9f5t6WFYKAXB/Ktxz1QB+PiyhOsA4ItNpaXRolySmOhOfqjAjCE2fQq/xDD9pAe99SLOtgsoai3SEK6h7o+YvwPy06+YDW0dXFGvsLXppkEHjC38mfrcRh6KHpaA8lfo3DpdxK+lc0mqb9D7ZKn5c0lVk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=jkBotbeY; arc=none smtp.client-ip=95.215.58.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="jkBotbeY"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1743700677;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=cXq14XHmuiRh3b2prvMxSNh0JefBBUU8x1ZOPWYxY1M=;
	b=jkBotbeY2z8CxO1nyJvW99qQBKidR2QvHnGWDhkeSWOcUPTwG+Yw3m6OSGJ9clgTvSWfi/
	dVTJsCKP44aLcduaLJb0u18eNdlg7JB89DTjmJeagdcdSVQWONMBBGmRc1exA730K+j6vB
	Y9yVb3Qq1kGo79Yg+u0gAlLhNqGy0NM=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 1/2] bcachefs: Initialize c->name earlier on single dev filesystems
Date: Thu,  3 Apr 2025 13:17:50 -0400
Message-ID: <20250403171751.2384984-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

On single device filesystems, c->name contains the block device name,
not the UUID.

Initialize this earlier, so that single device mode can use it for
initializing sysfs/debugfs.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/super.c | 33 ++++++++++++++++++---------------
 1 file changed, 18 insertions(+), 15 deletions(-)

diff --git a/fs/bcachefs/super.c b/fs/bcachefs/super.c
index a58edde43bee..07c8149c6712 100644
--- a/fs/bcachefs/super.c
+++ b/fs/bcachefs/super.c
@@ -79,6 +79,8 @@ MODULE_SOFTDEP("pre: chacha20");
 MODULE_SOFTDEP("pre: poly1305");
 MODULE_SOFTDEP("pre: xxhash");
 
+typedef DARRAY(struct bch_sb_handle) bch_sb_handles;
+
 const char * const bch2_fs_flag_strs[] = {
 #define x(n)		#n,
 	BCH_FS_FLAGS()
@@ -750,7 +752,8 @@ static int bch2_fs_online(struct bch_fs *c)
 	return ret;
 }
 
-static struct bch_fs *bch2_fs_alloc(struct bch_sb *sb, struct bch_opts opts)
+static struct bch_fs *bch2_fs_alloc(struct bch_sb *sb, struct bch_opts opts,
+				    bch_sb_handles *sbs)
 {
 	struct bch_fs *c;
 	struct printbuf name = PRINTBUF;
@@ -864,14 +867,6 @@ static struct bch_fs *bch2_fs_alloc(struct bch_sb *sb, struct bch_opts opts)
 	}
 #endif
 
-	pr_uuid(&name, c->sb.user_uuid.b);
-	ret = name.allocation_failure ? -BCH_ERR_ENOMEM_fs_name_alloc : 0;
-	if (ret)
-		goto err;
-
-	strscpy(c->name, name.buf, sizeof(c->name));
-	printbuf_exit(&name);
-
 	/* Compat: */
 	if (le16_to_cpu(sb->version) <= bcachefs_metadata_version_inode_v2 &&
 	    !BCH_SB_JOURNAL_FLUSH_DELAY(sb))
@@ -902,6 +897,18 @@ static struct bch_fs *bch2_fs_alloc(struct bch_sb *sb, struct bch_opts opts)
 		goto err;
 	}
 
+	if (sbs->nr != 1)
+		pr_uuid(&name, c->sb.user_uuid.b);
+	else
+		prt_bdevname(&name, sbs->data[0].bdev);
+
+	ret = name.allocation_failure ? -BCH_ERR_ENOMEM_fs_name_alloc : 0;
+	if (ret)
+		goto err;
+
+	strscpy(c->name, name.buf, sizeof(c->name));
+	printbuf_exit(&name);
+
 	iter_size = sizeof(struct sort_iter) +
 		(btree_blocks(c) + 1) * 2 *
 		sizeof(struct sort_iter_set);
@@ -1497,11 +1504,7 @@ static int bch2_dev_attach_bdev(struct bch_fs *c, struct bch_sb_handle *sb)
 
 	struct printbuf name = PRINTBUF;
 	prt_bdevname(&name, ca->disk_sb.bdev);
-
-	if (c->sb.nr_devices == 1)
-		strscpy(c->name, name.buf, sizeof(c->name));
 	strscpy(ca->name, name.buf, sizeof(ca->name));
-
 	printbuf_exit(&name);
 
 	rebalance_wakeup(c);
@@ -2163,7 +2166,7 @@ static inline int sb_cmp(struct bch_sb *l, struct bch_sb *r)
 struct bch_fs *bch2_fs_open(char * const *devices, unsigned nr_devices,
 			    struct bch_opts opts)
 {
-	DARRAY(struct bch_sb_handle) sbs = { 0 };
+	bch_sb_handles sbs = {};
 	struct bch_fs *c = NULL;
 	struct bch_sb_handle *best = NULL;
 	struct printbuf errbuf = PRINTBUF;
@@ -2216,7 +2219,7 @@ struct bch_fs *bch2_fs_open(char * const *devices, unsigned nr_devices,
 			goto err_print;
 	}
 
-	c = bch2_fs_alloc(best->sb, opts);
+	c = bch2_fs_alloc(best->sb, opts, &sbs);
 	ret = PTR_ERR_OR_ZERO(c);
 	if (ret)
 		goto err;
-- 
2.49.0


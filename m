Received: from out-177.mta1.migadu.com (out-177.mta1.migadu.com [95.215.58.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 690B522171E
	for <linux-bcachefs@vger.kernel.org>; Thu, 20 Mar 2025 21:30:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742506240; cv=none; b=QyQTso3rCSrghPo/U9bCTA33+92fLiFRVl2r0LqVDXwx3BtNbZZgQaR5uF+NC4GyAcQTKqDobkdg7bRIJ1uLR5iz9d8qGINRLB8Aq9iPG/Ex2VsxbVsTZhZ6anAYkXUukNYYJNDqtVB7s+I1SKr8V4r0/QiA/ixoy405RtfUxfY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742506240; c=relaxed/simple;
	bh=4o5eXrNi/d3Hy1I81ZD55l5jr2VsF1+j8+BOAAihXSE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dRW9avogRYozCSvG34x38ShpnEI8blTheoun/H/OnobGiTkyj6pw5i4JIzb5ABvKRA3AAOA+aI61goC7o537JJqBrj2SoPKgafbLU3IvM5hhi0Oo/XI8H2ijXz3XIc2yG6HjTVTd26yFNQgazQ9zxnpSYrsjIW9JROggNTq6/Zc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=tzJ+M1E3; arc=none smtp.client-ip=95.215.58.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="tzJ+M1E3"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1742506236;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yEK37QpJwuZnSbf8muFm+y9LXJEVrVbadIZiuCzz/A0=;
	b=tzJ+M1E3sTSW2QSxRVBNu9FzK234XzFZu6qL6ZeG+SeiRB1vnMAtfczPrZfAuo8cOyULz0
	2rAK/iIL0NqUjSZpDUk9ks1J3ynuXCw/dI0O5ry9HoyHx0wd/8CdrO6XjpjVwOAo5k/eYi
	4smfu0WMYrma8B8GSIKRtYCXPEwI1K0=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 1/4] bcachefs: fs-common.c -> namei.c
Date: Thu, 20 Mar 2025 17:30:16 -0400
Message-ID: <20250320213022.3359645-2-kent.overstreet@linux.dev>
In-Reply-To: <20250320213022.3359645-1-kent.overstreet@linux.dev>
References: <20250320213022.3359645-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

name <-> inode, code for managing the relationships between inodes and
dirents.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/Makefile                 | 2 +-
 fs/bcachefs/error.c                  | 2 +-
 fs/bcachefs/fs-ioctl.c               | 2 +-
 fs/bcachefs/fs.c                     | 2 +-
 fs/bcachefs/fsck.c                   | 2 +-
 fs/bcachefs/{fs-common.c => namei.c} | 2 +-
 fs/bcachefs/{fs-common.h => namei.h} | 6 +++---
 fs/bcachefs/recovery.c               | 2 +-
 8 files changed, 10 insertions(+), 10 deletions(-)
 rename fs/bcachefs/{fs-common.c => namei.c} (99%)
 rename fs/bcachefs/{fs-common.h => namei.h} (93%)

diff --git a/fs/bcachefs/Makefile b/fs/bcachefs/Makefile
index 1cf17a16af9f..9af65079374f 100644
--- a/fs/bcachefs/Makefile
+++ b/fs/bcachefs/Makefile
@@ -41,7 +41,6 @@ bcachefs-y		:=	\
 	extent_update.o		\
 	eytzinger.o		\
 	fs.o			\
-	fs-common.o		\
 	fs-ioctl.o		\
 	fs-io.o			\
 	fs-io-buffered.o	\
@@ -64,6 +63,7 @@ bcachefs-y		:=	\
 	migrate.o		\
 	move.o			\
 	movinggc.o		\
+	namei.o			\
 	nocow_locking.o		\
 	opts.o			\
 	printbuf.o		\
diff --git a/fs/bcachefs/error.c b/fs/bcachefs/error.c
index 6d68c89a49b2..207f35d3cce2 100644
--- a/fs/bcachefs/error.c
+++ b/fs/bcachefs/error.c
@@ -3,8 +3,8 @@
 #include "btree_cache.h"
 #include "btree_iter.h"
 #include "error.h"
-#include "fs-common.h"
 #include "journal.h"
+#include "namei.h"
 #include "recovery_passes.h"
 #include "super.h"
 #include "thread_with_file.h"
diff --git a/fs/bcachefs/fs-ioctl.c b/fs/bcachefs/fs-ioctl.c
index 5b47b94fe1ea..e3a3230fc652 100644
--- a/fs/bcachefs/fs-ioctl.c
+++ b/fs/bcachefs/fs-ioctl.c
@@ -5,8 +5,8 @@
 #include "chardev.h"
 #include "dirent.h"
 #include "fs.h"
-#include "fs-common.h"
 #include "fs-ioctl.h"
+#include "namei.h"
 #include "quota.h"
 
 #include <linux/compat.h>
diff --git a/fs/bcachefs/fs.c b/fs/bcachefs/fs.c
index 4453dd2f888e..273078ceb4df 100644
--- a/fs/bcachefs/fs.c
+++ b/fs/bcachefs/fs.c
@@ -11,7 +11,6 @@
 #include "errcode.h"
 #include "extents.h"
 #include "fs.h"
-#include "fs-common.h"
 #include "fs-io.h"
 #include "fs-ioctl.h"
 #include "fs-io-buffered.h"
@@ -22,6 +21,7 @@
 #include "io_read.h"
 #include "journal.h"
 #include "keylist.h"
+#include "namei.h"
 #include "quota.h"
 #include "rebalance.h"
 #include "snapshot.h"
diff --git a/fs/bcachefs/fsck.c b/fs/bcachefs/fsck.c
index 0e85131d0af8..4271ce4a4c8c 100644
--- a/fs/bcachefs/fsck.c
+++ b/fs/bcachefs/fsck.c
@@ -10,10 +10,10 @@
 #include "dirent.h"
 #include "error.h"
 #include "fs.h"
-#include "fs-common.h"
 #include "fsck.h"
 #include "inode.h"
 #include "keylist.h"
+#include "namei.h"
 #include "recovery_passes.h"
 #include "snapshot.h"
 #include "super.h"
diff --git a/fs/bcachefs/fs-common.c b/fs/bcachefs/namei.c
similarity index 99%
rename from fs/bcachefs/fs-common.c
rename to fs/bcachefs/namei.c
index fbc3da59536c..bc83acbf5414 100644
--- a/fs/bcachefs/fs-common.c
+++ b/fs/bcachefs/namei.c
@@ -4,8 +4,8 @@
 #include "acl.h"
 #include "btree_update.h"
 #include "dirent.h"
-#include "fs-common.h"
 #include "inode.h"
+#include "namei.h"
 #include "subvolume.h"
 #include "xattr.h"
 
diff --git a/fs/bcachefs/fs-common.h b/fs/bcachefs/namei.h
similarity index 93%
rename from fs/bcachefs/fs-common.h
rename to fs/bcachefs/namei.h
index 2b59210bb5e8..7383b76270e9 100644
--- a/fs/bcachefs/fs-common.h
+++ b/fs/bcachefs/namei.h
@@ -1,6 +1,6 @@
 /* SPDX-License-Identifier: GPL-2.0 */
-#ifndef _BCACHEFS_FS_COMMON_H
-#define _BCACHEFS_FS_COMMON_H
+#ifndef _BCACHEFS_NAMEI_H
+#define _BCACHEFS_NAMEI_H
 
 #include "dirent.h"
 
@@ -44,4 +44,4 @@ bool bch2_reinherit_attrs(struct bch_inode_unpacked *,
 
 int bch2_inum_to_path(struct btree_trans *, subvol_inum, struct printbuf *);
 
-#endif /* _BCACHEFS_FS_COMMON_H */
+#endif /* _BCACHEFS_NAMEI_H */
diff --git a/fs/bcachefs/recovery.c b/fs/bcachefs/recovery.c
index a6e26733854d..266c5770c824 100644
--- a/fs/bcachefs/recovery.c
+++ b/fs/bcachefs/recovery.c
@@ -13,12 +13,12 @@
 #include "disk_accounting.h"
 #include "errcode.h"
 #include "error.h"
-#include "fs-common.h"
 #include "journal_io.h"
 #include "journal_reclaim.h"
 #include "journal_seq_blacklist.h"
 #include "logged_ops.h"
 #include "move.h"
+#include "namei.h"
 #include "quota.h"
 #include "rebalance.h"
 #include "recovery.h"
-- 
2.49.0


Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 800121F16B
	for <linux-bcachefs@vger.kernel.org>; Fri, 31 May 2024 02:35:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717122937; cv=none; b=prIpCazqxEdF2O86A+0Ctc5K6RR+t7fjUHsI1yP5Sa3ZNWHu6cMkMm+a5fIqrmz9dQkTzxVF0MXz8qDVwjm7942ah2sk4WCIlY3Eil597LYvjS1EVxAlDVlPYHhUM3ngxxKnESnd3zNcjvFGWjEbhhEp2eui3eIsHAAR8Pxla+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717122937; c=relaxed/simple;
	bh=+S+3Z4sg/PtV/784ZpO2x1NF7WxZqP/12anTbvsYVpg=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=J9fkI/+fcMcsJJUWJngFWr2dHOembrGyURbRF2pJwjYw2eVealVoC00mInjTwY9+yjoKnTOnQsNIP3BJlM3OW8/mwVn0Vt82H1RCFlQdpEs5kIsOCltnvUhaKlUQAynMLOpdjK3Z9nfgIkFCp7DPjfDYTB4SSvsqwjrIyZgdTu0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=aQgR4Ulj; arc=none smtp.client-ip=91.218.175.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="aQgR4Ulj"
X-Envelope-To: kent.overstreet@linux.dev
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1717122933;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=MeS7OizMon/+kVCMifzaTFJG2SOfNtEI6D6D9vCUKmI=;
	b=aQgR4Ulj7Trya0OLEdjXPfEy7UZUIqKb/j2VZAx2MiLAWxoyBJnq7we8Ov0YceiduTKcw+
	/9/cN0rURagSQHl184oWHM15WJVMiCVp9NSAms9GWnSpVkDfFwU2LkL0lt6crjA1gnrddL
	VnisxYwa48jjufdC9LcZSsCwtH1SVS0=
X-Envelope-To: bfoster@redhat.com
X-Envelope-To: linux-bcachefs@vger.kernel.org
X-Envelope-To: linux-kernel@vger.kernel.org
X-Envelope-To: tangyouling@kylinos.cn
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Youling Tang <youling.tang@linux.dev>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Brian Foster <bfoster@redhat.com>,
	linux-bcachefs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Youling Tang <tangyouling@kylinos.cn>
Subject: [PATCH] bcachefs: Add tracepoints for bch2_sync_fs() and bch2_fsync()
Date: Fri, 31 May 2024 10:35:09 +0800
Message-Id: <20240531023509.12274-1-youling.tang@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Youling Tang <tangyouling@kylinos.cn>

Add trace_bch2_sync_fs() and trace_bch2_fsync() implementations.

The output in trace is as follows:
  sync-29779   [000] .....   193.700935: bch2_sync_fs: dev 254,16 wait 1
  <...>-40027  [002] .....   342.535227: bch2_fsync: dev 254,32 ino 4099 parent 4096 datasync 1

Signed-off-by: Youling Tang <tangyouling@kylinos.cn>
---
 fs/bcachefs/fs-io.c |  2 ++
 fs/bcachefs/fs.c    |  3 +++
 fs/bcachefs/trace.h | 50 +++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 55 insertions(+)

diff --git a/fs/bcachefs/fs-io.c b/fs/bcachefs/fs-io.c
index f5b266e51261..e89f01394ccb 100644
--- a/fs/bcachefs/fs-io.c
+++ b/fs/bcachefs/fs-io.c
@@ -194,6 +194,8 @@ int bch2_fsync(struct file *file, loff_t start, loff_t end, int datasync)
 	struct bch_fs *c = inode->v.i_sb->s_fs_info;
 	int ret, err;
 
+	trace_bch2_fsync(file, datasync);
+
 	ret = file_write_and_wait_range(file, start, end);
 	if (ret)
 		goto out;
diff --git a/fs/bcachefs/fs.c b/fs/bcachefs/fs.c
index 9b52ac233bf9..0695f478e206 100644
--- a/fs/bcachefs/fs.c
+++ b/fs/bcachefs/fs.c
@@ -26,6 +26,7 @@
 #include "snapshot.h"
 #include "super.h"
 #include "xattr.h"
+#include "trace.h"
 
 #include <linux/aio.h>
 #include <linux/backing-dev.h>
@@ -1681,6 +1682,8 @@ static int bch2_sync_fs(struct super_block *sb, int wait)
 	struct bch_fs *c = sb->s_fs_info;
 	int ret;
 
+	trace_bch2_sync_fs(sb, wait);
+
 	if (c->opts.journal_flush_disabled)
 		return 0;
 
diff --git a/fs/bcachefs/trace.h b/fs/bcachefs/trace.h
index 362e1fc7ef6a..564e115f4d2e 100644
--- a/fs/bcachefs/trace.h
+++ b/fs/bcachefs/trace.h
@@ -200,6 +200,56 @@ DECLARE_EVENT_CLASS(bio,
 		  (unsigned long long)__entry->sector, __entry->nr_sector)
 );
 
+/* fs.c: */
+TRACE_EVENT(bch2_sync_fs,
+	TP_PROTO(struct super_block *sb, int wait),
+
+	TP_ARGS(sb, wait),
+
+	TP_STRUCT__entry(
+		__field(	dev_t,	dev			)
+		__field(	int,	wait			)
+
+	),
+
+	TP_fast_assign(
+		__entry->dev	= sb->s_dev;
+		__entry->wait	= wait;
+	),
+
+	TP_printk("dev %d,%d wait %d",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->wait)
+);
+
+/* fs-io.c: */
+TRACE_EVENT(bch2_fsync,
+	TP_PROTO(struct file *file, int datasync),
+
+	TP_ARGS(file, datasync),
+
+	TP_STRUCT__entry(
+		__field(	dev_t,	dev			)
+		__field(	ino_t,	ino			)
+		__field(	ino_t,	parent			)
+		__field(	int,	datasync		)
+	),
+
+	TP_fast_assign(
+		struct dentry *dentry = file->f_path.dentry;
+
+		__entry->dev		= dentry->d_sb->s_dev;
+		__entry->ino		= d_inode(dentry)->i_ino;
+		__entry->parent		= d_inode(dentry->d_parent)->i_ino;
+		__entry->datasync	= datasync;
+	),
+
+	TP_printk("dev %d,%d ino %lu parent %lu datasync %d ",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  (unsigned long) __entry->ino,
+		  (unsigned long) __entry->parent, __entry->datasync)
+);
+
 /* super-io.c: */
 TRACE_EVENT(write_super,
 	TP_PROTO(struct bch_fs *c, unsigned long ip),
-- 
2.34.1


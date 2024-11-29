Received: from out-189.mta1.migadu.com (out-189.mta1.migadu.com [95.215.58.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5303E545
	for <linux-bcachefs@vger.kernel.org>; Fri, 29 Nov 2024 20:27:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732912069; cv=none; b=dqcgFQH+oj4ZMcWPKUoOQ25eyrpLe0JtkRbX1EcxZieiwdn9tWfJzWClvUYW/aQQgMHgfTJtQj4rsZSmfFciReC+wHnrhU4OiOZYhIwyiPGKXIGXpZG/ikN+pQLdED3nPRgXENGbbWk/STMZJLZYRcbebgP10xiE8fAzYxL2fJs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732912069; c=relaxed/simple;
	bh=p+vgThMO683pDY0D3pZ7KGocYWzUaZWFrBgtBw44dpk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oZT8XPnx6PocHH0pfmR1bXEE7DSjQlqHzMPUTOsylxdcs389mE7szdoOFmQHTVbh87phURRBS515SmaHkOAUk9QNxHbBdjiABVMi/Jz1hcnw9xIvVBDmCGCAJyMysCbd3XXkw68loFZvauXUWDz/t1+ggIUS+2ILCafMxHzlLeU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; arc=none smtp.client-ip=95.215.58.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 03/34] bcachefs: errcode cleanup: journal errors
Date: Fri, 29 Nov 2024 15:27:02 -0500
Message-ID: <20241129202736.2713679-4-kent.overstreet@linux.dev>
In-Reply-To: <20241129202736.2713679-1-kent.overstreet@linux.dev>
References: <20241129202736.2713679-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Instead of throwing standard error codes, we should be throwing
dedicated private error codes, this greatly improves debugability.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/errcode.h | 2 ++
 fs/bcachefs/journal.c | 4 ++--
 fs/bcachefs/journal.h | 2 +-
 3 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/fs/bcachefs/errcode.h b/fs/bcachefs/errcode.h
index 131b9bef21a0..c989ce4f715f 100644
--- a/fs/bcachefs/errcode.h
+++ b/fs/bcachefs/errcode.h
@@ -241,6 +241,8 @@
 	x(BCH_ERR_invalid_sb,		invalid_sb_downgrade)			\
 	x(BCH_ERR_invalid,		invalid_bkey)				\
 	x(BCH_ERR_operation_blocked,    nocow_lock_blocked)			\
+	x(EIO,				journal_shutdown)			\
+	x(EIO,				journal_flush_err)			\
 	x(EIO,				btree_node_read_err)			\
 	x(BCH_ERR_btree_node_read_err,	btree_node_read_err_cached)		\
 	x(EIO,				sb_not_downgraded)			\
diff --git a/fs/bcachefs/journal.c b/fs/bcachefs/journal.c
index 699db0d0749a..bbdd0b17ae69 100644
--- a/fs/bcachefs/journal.c
+++ b/fs/bcachefs/journal.c
@@ -673,7 +673,7 @@ void bch2_journal_entry_res_resize(struct journal *j,
  * @seq:	seq to flush
  * @parent:	closure object to wait with
  * Returns:	1 if @seq has already been flushed, 0 if @seq is being flushed,
- *		-EIO if @seq will never be flushed
+ *		-BCH_ERR_journal_flush_err if @seq will never be flushed
  *
  * Like bch2_journal_wait_on_seq, except that it triggers a write immediately if
  * necessary
@@ -696,7 +696,7 @@ int bch2_journal_flush_seq_async(struct journal *j, u64 seq,
 
 	/* Recheck under lock: */
 	if (j->err_seq && seq >= j->err_seq) {
-		ret = -EIO;
+		ret = -BCH_ERR_journal_flush_err;
 		goto out;
 	}
 
diff --git a/fs/bcachefs/journal.h b/fs/bcachefs/journal.h
index 71a50846967f..a6a2e888c59b 100644
--- a/fs/bcachefs/journal.h
+++ b/fs/bcachefs/journal.h
@@ -412,7 +412,7 @@ void bch2_journal_halt(struct journal *);
 static inline int bch2_journal_error(struct journal *j)
 {
 	return j->reservations.cur_entry_offset == JOURNAL_ENTRY_ERROR_VAL
-		? -EIO : 0;
+		? -BCH_ERR_journal_shutdown : 0;
 }
 
 struct bch_dev;
-- 
2.45.2


Received: from out-180.mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 932A1286887
	for <linux-bcachefs@vger.kernel.org>; Mon,  4 Aug 2025 17:12:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754327555; cv=none; b=sx7NmF8S9SrEzC4SV20oM8X+rQmVoN5tKv5Wjcny9++dYaXxL25xqLp6hGwnPd8kPyyIugWHp5kP4jWKUrkVbfb5mjoKFBcXviw+X90tfGHscSg80Han6zUf6tRllHnrI9xrH+aMlcW3VydGmAyYUsAIl1VvYRKkJPMRlgDaXNo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754327555; c=relaxed/simple;
	bh=LSJZLOB2jM93ppt4E1cWczAg0HvRNQZ9FSWz1aYFfQk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=VD2jt8UvnB/0azbsCXu2UeRWGb6H5SAbJMUfcJazN7Hs56oSSIHY1zwRsxqR7rkckrPwqDleDwXbqmvDHfAQoYhXhb/Kuykbd2xssOdPl6eInWLpBTwcW75iQnMgJ+4uhN3X/mS8XLMwiu6tdILlg2zeu4pMyTfljedMUueTXgc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=eGVnn9YH; arc=none smtp.client-ip=95.215.58.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="eGVnn9YH"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1754327550;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=ntFiorJLG6CnLnvOQMsR7rrBe5GSREHNZ8jnanGktWM=;
	b=eGVnn9YH4Dlfz/Z7TIWIGb+6Ll2TTpP6bwOvl4klaxkoOSznwcTEXRamN3IDV9bUC8Skay
	Oc61WjQmVDypu3SZH3TgPeJ6Xo2u+G0OppWz+7UQrdhT2JbNsmYMQ+6wTmWkrK1xpnR/4Z
	7Bu8KUmAFF9gxGbaTOCAEhoWXLTllk8=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH] bcachefs: btree_id_can_reconstruct(), btree_id_recovers_from_scan()
Date: Mon,  4 Aug 2025 13:12:26 -0400
Message-ID: <20250804171226.3593343-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Add new helpers to clarify (and fix) repair strategies for different
btrees, and kill incorrect btree_id_is_alloc() use - it's not for
deciding how to repair.

btree node scan was incorrectly skipping BTREE_ID_alloc: while we can
reconstruct this one from scratch, it will fail by OOM on huge
filesystems, it's better to try btree node scan first

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/bcachefs_format.h | 32 ++++++++++++++++++++++++++++++--
 fs/bcachefs/btree_gc.c        | 23 +----------------------
 fs/bcachefs/btree_node_scan.c |  4 ++--
 fs/bcachefs/recovery.c        |  2 +-
 4 files changed, 34 insertions(+), 27 deletions(-)

diff --git a/fs/bcachefs/bcachefs_format.h b/fs/bcachefs/bcachefs_format.h
index a8f59522e258..19961b4f30b8 100644
--- a/fs/bcachefs/bcachefs_format.h
+++ b/fs/bcachefs/bcachefs_format.h
@@ -1438,9 +1438,9 @@ enum btree_id {
  */
 #define BTREE_ID_NR_MAX		63
 
-static inline bool btree_id_is_alloc(enum btree_id id)
+static inline bool btree_id_is_alloc(enum btree_id btree)
 {
-	switch (id) {
+	switch (btree) {
 	case BTREE_ID_alloc:
 	case BTREE_ID_backpointers:
 	case BTREE_ID_need_discard:
@@ -1454,6 +1454,34 @@ static inline bool btree_id_is_alloc(enum btree_id id)
 	}
 }
 
+/* We can reconstruct these btrees from information in other btrees */
+static inline bool btree_id_can_reconstruct(enum btree_id btree)
+{
+	if (btree_id_is_alloc(btree))
+		return true;
+
+	switch (btree) {
+	case BTREE_ID_snapshot_trees:
+	case BTREE_ID_deleted_inodes:
+	case BTREE_ID_logged_ops:
+	case BTREE_ID_rebalance_work:
+	case BTREE_ID_subvolume_children:
+		return true;
+	default:
+		return false;
+	}
+}
+
+/*
+ * We can reconstruct BTREE_ID_alloc, but reconstucting it from scratch is not
+ * so cheap and OOMs on huge filesystems (until we have online
+ * check_allocations)
+ */
+static inline bool btree_id_recovers_from_scan(enum btree_id btree)
+{
+	return btree == BTREE_ID_alloc || !btree_id_can_reconstruct(btree);
+}
+
 #define BTREE_MAX_DEPTH		4U
 
 /* Btree nodes */
diff --git a/fs/bcachefs/btree_gc.c b/fs/bcachefs/btree_gc.c
index 6b91649688da..cbf567679a85 100644
--- a/fs/bcachefs/btree_gc.c
+++ b/fs/bcachefs/btree_gc.c
@@ -44,27 +44,6 @@
 #include <linux/rcupdate.h>
 #include <linux/sched/task.h>
 
-/*
- * Returns true if it's a btree we can easily reconstruct, or otherwise won't
- * cause data loss if it's missing:
- */
-static bool btree_id_important(enum btree_id btree)
-{
-	if (btree_id_is_alloc(btree))
-		return false;
-
-	switch (btree) {
-	case BTREE_ID_quotas:
-	case BTREE_ID_snapshot_trees:
-	case BTREE_ID_logged_ops:
-	case BTREE_ID_rebalance_work:
-	case BTREE_ID_subvolume_children:
-		return false;
-	default:
-		return true;
-	}
-}
-
 static const char * const bch2_gc_phase_strs[] = {
 #define x(n)	#n,
 	GC_PHASES()
@@ -576,7 +555,7 @@ static int bch2_check_root(struct btree_trans *trans, enum btree_id btree,
 
 		if (!ret) {
 			__fsck_err(trans,
-				   FSCK_CAN_FIX|(!btree_id_important(btree) ? FSCK_AUTOFIX : 0),
+				   FSCK_CAN_FIX|(btree_id_can_reconstruct(btree) ? FSCK_AUTOFIX : 0),
 				   btree_root_unreadable_and_scan_found_nothing,
 				   "no nodes found for btree %s, continue?", buf.buf);
 
diff --git a/fs/bcachefs/btree_node_scan.c b/fs/bcachefs/btree_node_scan.c
index 4b7b5ca74ba1..6b747c053e91 100644
--- a/fs/bcachefs/btree_node_scan.c
+++ b/fs/bcachefs/btree_node_scan.c
@@ -149,7 +149,7 @@ static void try_read_btree_node(struct find_btree_nodes *f, struct bch_dev *ca,
 		bch2_encrypt(c, BSET_CSUM_TYPE(&bn->keys), nonce, &bn->flags, bytes);
 	}
 
-	if (btree_id_is_alloc(BTREE_NODE_ID(bn)))
+	if (btree_id_can_reconstruct(BTREE_NODE_ID(bn)))
 		return;
 
 	if (BTREE_NODE_LEVEL(bn) >= BTREE_MAX_DEPTH)
@@ -534,7 +534,7 @@ int bch2_btree_has_scanned_nodes(struct bch_fs *c, enum btree_id btree)
 int bch2_get_scanned_nodes(struct bch_fs *c, enum btree_id btree,
 			   unsigned level, struct bpos node_min, struct bpos node_max)
 {
-	if (btree_id_is_alloc(btree))
+	if (btree_id_recovers_from_scan(btree))
 		return 0;
 
 	struct find_btree_nodes *f = &c->found_btree_nodes;
diff --git a/fs/bcachefs/recovery.c b/fs/bcachefs/recovery.c
index 21aa2edb13ac..29e81f96db0f 100644
--- a/fs/bcachefs/recovery.c
+++ b/fs/bcachefs/recovery.c
@@ -607,7 +607,7 @@ static int read_btree_roots(struct bch_fs *c)
 					c, btree_root_read_error,
 					"error reading btree root %s: %s",
 					buf.buf, bch2_err_str(ret))) {
-			if (btree_id_is_alloc(i))
+			if (btree_id_can_reconstruct(i))
 				r->error = 0;
 			ret = 0;
 		}
-- 
2.50.1


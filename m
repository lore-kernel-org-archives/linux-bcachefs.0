Received: from out-185.mta1.migadu.com (out-185.mta1.migadu.com [95.215.58.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6D61E545
	for <linux-bcachefs@vger.kernel.org>; Fri, 29 Nov 2024 20:27:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732912080; cv=none; b=eB7N2eZBey18s/8xm5U2zseau+C0bE5io3TTKTxetGRPMxobaE4NUT7SD0HsPlrd9JKI8cWSSxD75Mg6YS7DT7mAtmWRH5S1kbDY86AipiMGj5XgvNgmNG5km3+54PjqsSb+GIUBR/MidiVdUl+mZxC2HTpVc4a+kuLWJjwljPU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732912080; c=relaxed/simple;
	bh=pHzDnG8O6lhhWN2/9nd4q/1yWHBKxQ4f9/RKgELm27U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TsZGEgngam+Y3p4akTiClAC2rpXe+RyMQXO0QYLhaPXb4tm79aLxCiIVcZhlT+OW75YRn/JQoWpYjHQRwcByJlKPS00qORN5AMYiq8ZAFVIivYfyo0EaAJpKdxP3nmv2mHk+LtB7an/4N/EfWpBf8t/LKiSg2m0QSXZHxy4nRTE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; arc=none smtp.client-ip=95.215.58.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>,
	syzbot+e22007d6acb9c87c2362@syzkaller.appspotmail.com
Subject: [PATCH 15/34] bcachefs: Fix null ptr deref in btree_path_lock_root()
Date: Fri, 29 Nov 2024 15:27:14 -0500
Message-ID: <20241129202736.2713679-16-kent.overstreet@linux.dev>
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

Historically, we required that all btree node roots point to a valid
(possibly fake) node, but we're improving our ability to continue in the
presence of errors.

Reported-by: syzbot+e22007d6acb9c87c2362@syzkaller.appspotmail.com
Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/btree_iter.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/fs/bcachefs/btree_iter.c b/fs/bcachefs/btree_iter.c
index 89f9665ce70d..80c3b55ce763 100644
--- a/fs/bcachefs/btree_iter.c
+++ b/fs/bcachefs/btree_iter.c
@@ -722,7 +722,7 @@ static inline int btree_path_lock_root(struct btree_trans *trans,
 				       unsigned long trace_ip)
 {
 	struct bch_fs *c = trans->c;
-	struct btree *b, **rootp = &bch2_btree_id_root(c, path->btree_id)->b;
+	struct btree_root *r = bch2_btree_id_root(c, path->btree_id);
 	enum six_lock_type lock_type;
 	unsigned i;
 	int ret;
@@ -730,7 +730,12 @@ static inline int btree_path_lock_root(struct btree_trans *trans,
 	EBUG_ON(path->nodes_locked);
 
 	while (1) {
-		b = READ_ONCE(*rootp);
+		struct btree *b = READ_ONCE(r->b);
+		if (unlikely(!b)) {
+			BUG_ON(!r->error);
+			return r->error;
+		}
+
 		path->level = READ_ONCE(b->c.level);
 
 		if (unlikely(path->level < depth_want)) {
@@ -755,7 +760,7 @@ static inline int btree_path_lock_root(struct btree_trans *trans,
 			BUG();
 		}
 
-		if (likely(b == READ_ONCE(*rootp) &&
+		if (likely(b == READ_ONCE(r->b) &&
 			   b->c.level == path->level &&
 			   !race_fault())) {
 			for (i = 0; i < path->level; i++)
-- 
2.45.2


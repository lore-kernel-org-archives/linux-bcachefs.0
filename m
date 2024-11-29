Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E02BE545
	for <linux-bcachefs@vger.kernel.org>; Fri, 29 Nov 2024 20:28:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732912089; cv=none; b=kI1R2s89maWsBdyn5yDm3uhHXzcKRctmPyykWqhNiwc8imY+rXxKDOsV0h6AHDQqrrH1i5ChQaXvMRpoqDoBfs4b9m1r3hw9+S7WKeY2Bkjsc+HGx06tF9UZUvuGOmocb4M7ByRMfEY5DRh8wtuh+/2YXluiJcboEuknYLfvzpY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732912089; c=relaxed/simple;
	bh=mVkuCxcWvOTUGQpmkHMkjcakzpm8KyKZooQ8rqNrUtc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hBBVdRtrI/ghIzSNRyePZt2C9Fzd3LWyBqU6HU2lCm6mN0aa1oq1vaxwPyfYjxd1LRDcc9JMCctThBCeDKrvHipa6L/tTOOIf1U2aJHGvi16sc7Care7Ov+5bT2L+z3amv2oglFEdsNRKle9YsGhqVLAuJ8jiH4MFDoDurNpMwU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; arc=none smtp.client-ip=95.215.58.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>,
	syzbot+78d82470c16a49702682@syzkaller.appspotmail.com
Subject: [PATCH 22/34] bcachefs: Issue a transaction restart after commit in repair
Date: Fri, 29 Nov 2024 15:27:21 -0500
Message-ID: <20241129202736.2713679-23-kent.overstreet@linux.dev>
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

transaction commits invalidate pointers to btree values, and they also
downgrade intent locks.

This breaks the interior btree update path, which takes intent locks and
then calls into the allocator.

This isn't an ideal solution: we can't unconditionally issue a restart
after a transaction commit, because that would break other codepaths.

Reported-by: syzbot+78d82470c16a49702682@syzkaller.appspotmail.com
Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/alloc_background.c | 2 +-
 fs/bcachefs/errcode.h          | 1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/bcachefs/alloc_background.c b/fs/bcachefs/alloc_background.c
index 8846daaa1162..79af226ca609 100644
--- a/fs/bcachefs/alloc_background.c
+++ b/fs/bcachefs/alloc_background.c
@@ -1384,7 +1384,7 @@ int bch2_check_discard_freespace_key(struct btree_trans *trans, struct btree_ite
 	ret =   bch2_btree_bit_mod_iter(trans, iter, false) ?:
 		bch2_trans_commit(trans, NULL, NULL,
 			BCH_TRANS_COMMIT_no_enospc) ?:
-		1;
+		-BCH_ERR_transaction_restart_commit;
 	goto out;
 }
 
diff --git a/fs/bcachefs/errcode.h b/fs/bcachefs/errcode.h
index a12050e9c191..a0cfc0f286f4 100644
--- a/fs/bcachefs/errcode.h
+++ b/fs/bcachefs/errcode.h
@@ -148,6 +148,7 @@
 	x(BCH_ERR_transaction_restart,	transaction_restart_split_race)		\
 	x(BCH_ERR_transaction_restart,	transaction_restart_write_buffer_flush)	\
 	x(BCH_ERR_transaction_restart,	transaction_restart_nested)		\
+	x(BCH_ERR_transaction_restart,	transaction_restart_commit)		\
 	x(0,				no_btree_node)				\
 	x(BCH_ERR_no_btree_node,	no_btree_node_relock)			\
 	x(BCH_ERR_no_btree_node,	no_btree_node_upgrade)			\
-- 
2.45.2


Received: from out-184.mta1.migadu.com (out-184.mta1.migadu.com [95.215.58.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9DE4156C5E
	for <linux-bcachefs@vger.kernel.org>; Fri, 29 Nov 2024 20:27:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732912068; cv=none; b=c3ta1nwnpdolj3BarYFaIaV1+KiNF+fViTRKAMeDSvpKs/Og4EvenJX1m7GmndP7i3T5SUH7djUHpGHn+0ShgOMwzE/jx92MobMJihCeOSp/iK5YAJkem5uNOWiP/MGO9rCnXXPreoOhMqx1/rM1lTOpiD/K7WKGhSZHQsvECB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732912068; c=relaxed/simple;
	bh=Qh5xOTbYVPJQaxTX2HVzjVxtjk9wyw8+cNHdRuL7zWM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vF557n3pB2xCDlg4QCG+3fQBG54LnvwjDPxDbUVf2QVcmPN+aoqJ2Ixycjvrx6yRpAbcgNa4U9v+HE5Hhuy99x1UPlAyCYLCOOwQRDQUiGOnj7Qj5BKGFe37EcDRPMqL3nydpZZ4Uy1TavQr/B6NS6/TqAhaP/FxQFLlEm0W/0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; arc=none smtp.client-ip=95.215.58.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 01/34] bcachefs: BCH_ERR_btree_node_read_error_cached
Date: Fri, 29 Nov 2024 15:27:00 -0500
Message-ID: <20241129202736.2713679-2-kent.overstreet@linux.dev>
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

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/btree_cache.c | 6 +++---
 fs/bcachefs/errcode.h     | 1 +
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/bcachefs/btree_cache.c b/fs/bcachefs/btree_cache.c
index a0a406b0c7bc..36dfa6a48aa6 100644
--- a/fs/bcachefs/btree_cache.c
+++ b/fs/bcachefs/btree_cache.c
@@ -1131,7 +1131,7 @@ static struct btree *__bch2_btree_node_get(struct btree_trans *trans, struct btr
 
 	if (unlikely(btree_node_read_error(b))) {
 		six_unlock_type(&b->c.lock, lock_type);
-		return ERR_PTR(-BCH_ERR_btree_node_read_error);
+		return ERR_PTR(-BCH_ERR_btree_node_read_err_cached);
 	}
 
 	EBUG_ON(b->c.btree_id != path->btree_id);
@@ -1221,7 +1221,7 @@ struct btree *bch2_btree_node_get(struct btree_trans *trans, struct btree_path *
 
 	if (unlikely(btree_node_read_error(b))) {
 		six_unlock_type(&b->c.lock, lock_type);
-		return ERR_PTR(-BCH_ERR_btree_node_read_error);
+		return ERR_PTR(-BCH_ERR_btree_node_read_err_cached);
 	}
 
 	EBUG_ON(b->c.btree_id != path->btree_id);
@@ -1303,7 +1303,7 @@ struct btree *bch2_btree_node_get_noiter(struct btree_trans *trans,
 
 	if (unlikely(btree_node_read_error(b))) {
 		six_unlock_read(&b->c.lock);
-		b = ERR_PTR(-BCH_ERR_btree_node_read_error);
+		b = ERR_PTR(-BCH_ERR_btree_node_read_err_cached);
 		goto out;
 	}
 
diff --git a/fs/bcachefs/errcode.h b/fs/bcachefs/errcode.h
index 2dda7f962e5b..131b9bef21a0 100644
--- a/fs/bcachefs/errcode.h
+++ b/fs/bcachefs/errcode.h
@@ -242,6 +242,7 @@
 	x(BCH_ERR_invalid,		invalid_bkey)				\
 	x(BCH_ERR_operation_blocked,    nocow_lock_blocked)			\
 	x(EIO,				btree_node_read_err)			\
+	x(BCH_ERR_btree_node_read_err,	btree_node_read_err_cached)		\
 	x(EIO,				sb_not_downgraded)			\
 	x(EIO,				btree_node_write_all_failed)		\
 	x(EIO,				btree_node_read_error)			\
-- 
2.45.2


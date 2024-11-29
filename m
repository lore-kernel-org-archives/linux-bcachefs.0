Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF0EE14D428
	for <linux-bcachefs@vger.kernel.org>; Fri, 29 Nov 2024 20:28:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732912090; cv=none; b=SC7g4gQJuDdFxgUistu+YnEpufjnqqBYRmXWLi1E0OOGNDd5u0xxtf4Ir6RMthClZ8nC06ztJmw/rgwqOjb+1jGnuoOMRaevSCiOYotAID6GKw+XDPqQ4dV4zfj9Gpf0l/ciTsL60qJy8vCLtNYOYXdFmxSiwHLPGX/DjSRabdo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732912090; c=relaxed/simple;
	bh=cD2rd7kMFsa/7kv8sKoebv8dm+YInQdCOxig4HsPkLI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mPa+lz732nqdaVXa6h0nMF15X+D32nqW4Z3QHxvm2E7uOr3djSA6HnT+AD/C/y0etFLdRlPEGL11f8W9YB+I3QcVMr7AvcOXj47Lgci0vlpq7Oen1cBR7VHCwFjNx1LHzRF3YoarZSH0FWcu/VMRe4a/+77cQjZlxD+nepy7SBI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; arc=none smtp.client-ip=95.215.58.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>,
	syzbot+2f7c2225ed8a5cb24af1@syzkaller.appspotmail.com
Subject: [PATCH 24/34] bcachefs: Fix journal_iter list corruption
Date: Fri, 29 Nov 2024 15:27:23 -0500
Message-ID: <20241129202736.2713679-25-kent.overstreet@linux.dev>
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

Fix exiting an iterator that wasn't initialized.

Reported-by: syzbot+2f7c2225ed8a5cb24af1@syzkaller.appspotmail.com
Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/btree_update_interior.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/bcachefs/btree_update_interior.c b/fs/bcachefs/btree_update_interior.c
index 56a70e95ef9a..5eabd532e388 100644
--- a/fs/bcachefs/btree_update_interior.c
+++ b/fs/bcachefs/btree_update_interior.c
@@ -58,6 +58,10 @@ int bch2_btree_node_check_topology(struct btree_trans *trans, struct btree *b)
 	       !bpos_eq(bkey_i_to_btree_ptr_v2(&b->key)->v.min_key,
 			b->data->min_key));
 
+	bch2_bkey_buf_init(&prev);
+	bkey_init(&prev.k->k);
+	bch2_btree_and_journal_iter_init_node_iter(trans, &iter, b);
+
 	if (b == btree_node_root(c, b)) {
 		if (!bpos_eq(b->data->min_key, POS_MIN)) {
 			printbuf_reset(&buf);
@@ -77,11 +81,7 @@ int bch2_btree_node_check_topology(struct btree_trans *trans, struct btree *b)
 	}
 
 	if (!b->c.level)
-		return 0;
-
-	bch2_bkey_buf_init(&prev);
-	bkey_init(&prev.k->k);
-	bch2_btree_and_journal_iter_init_node_iter(trans, &iter, b);
+		goto out;
 
 	while ((k = bch2_btree_and_journal_iter_peek(&iter)).k) {
 		if (k.k->type != KEY_TYPE_btree_ptr_v2)
-- 
2.45.2


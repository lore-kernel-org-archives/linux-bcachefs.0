Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FF9E1F8724
	for <linux-bcachefs@vger.kernel.org>; Wed, 16 Apr 2025 13:44:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744811042; cv=none; b=uggNEKFX8su6X8n3dCzetGYhYo5daTpCC9W1NtZx5707JGqkimGGlZalkkQzUCzs4unZduIN9REziHfNpoEnl0MMyEQ0Lsx3IdnnMPS0eV0uySuHn1OCtBDtO/yNfj/jSx9HxTpnhqaJsqklUnoJFF65hX5ewIoDDtjRn4D9viI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744811042; c=relaxed/simple;
	bh=ETi7RTUGlhxmiH7EYernasykcB4HNDniTwpC1T0zSDU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MhNyG53h1RU1xRWocwNq26lC1NiwFL5tiyIayj196TGdLRFig3WUDPIiQHKBhfPeJklbB9oGkGSXxKwSM1lnWkbysgDMODDSzZfvRE3cWQ21HRn5/IsMqkVYFOxvT4UdhgTu6MG/ZM6plA+zPaAhmVl8abTCIq+9qRBqqPpAZcs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=WGyTH5Gk; arc=none smtp.client-ip=91.218.175.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="WGyTH5Gk"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1744811038;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Dd78pGevsnAVpTjsQADdl0HhhVxJSsac+fDh6x7SD4Q=;
	b=WGyTH5GkagtNLw6GzqjlsWbC6nC11tot1wM3iqymvHnzVnuOz/VKRCA3TaTZxejwQ2SGn5
	OgmMVtpIhkkO0VvSmK0jqPSJHgHFvGd1VU3tn+NtpewoAvc1NxBI5ZwLDB3QrTCXGQFeOe
	U3t2HJiIyi3lmomsSYKzFUDG6MNVTrg=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 4/4] bcachefs: bch2_move_data_btree() can now walk roots
Date: Wed, 16 Apr 2025 09:43:49 -0400
Message-ID: <20250416134352.3654545-5-kent.overstreet@linux.dev>
In-Reply-To: <20250416134352.3654545-1-kent.overstreet@linux.dev>
References: <20250416134352.3654545-1-kent.overstreet@linux.dev>
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
 fs/bcachefs/move.c | 47 +++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 46 insertions(+), 1 deletion(-)

diff --git a/fs/bcachefs/move.c b/fs/bcachefs/move.c
index b594c9ed41f8..f605bd014868 100644
--- a/fs/bcachefs/move.c
+++ b/fs/bcachefs/move.c
@@ -606,7 +606,52 @@ int bch2_move_data_btree(struct moving_context *ctxt,
 		ctxt->stats->pos	= BBPOS(btree_id, start);
 	}
 
+retry_root:
 	bch2_trans_begin(trans);
+
+	if (level == bch2_btree_id_root(c, btree_id)->level + 1) {
+		bch2_trans_node_iter_init(trans, &iter, btree_id, start, 0, level - 1,
+					  BTREE_ITER_prefetch|
+					  BTREE_ITER_not_extents|
+					  BTREE_ITER_all_snapshots);
+		struct btree *b = bch2_btree_iter_peek_node(trans, &iter);
+		ret = PTR_ERR_OR_ZERO(b);
+		if (ret)
+			goto root_err;
+
+		if (b != btree_node_root(c, b)) {
+			bch2_trans_iter_exit(trans, &iter);
+			goto retry_root;
+		}
+
+		k = bkey_i_to_s_c(&b->key);
+
+		io_opts = bch2_move_get_io_opts(trans, &snapshot_io_opts,
+						iter.pos, &iter, k);
+		ret = PTR_ERR_OR_ZERO(io_opts);
+		if (ret)
+			goto root_err;
+
+		memset(&data_opts, 0, sizeof(data_opts));
+		if (!pred(c, arg, iter.btree_id, k, io_opts, &data_opts))
+			goto out;
+
+
+		if (!data_opts.scrub)
+			ret = bch2_btree_node_rewrite_pos(trans, btree_id, level,
+							  k.k->p, data_opts.target, 0);
+		else
+			ret = bch2_btree_node_scrub(trans, btree_id, level, k, data_opts.read_dev);
+
+root_err:
+		if (bch2_err_matches(ret, BCH_ERR_transaction_restart)) {
+			bch2_trans_iter_exit(trans, &iter);
+			goto retry_root;
+		}
+
+		goto out;
+	}
+
 	bch2_trans_node_iter_init(trans, &iter, btree_id, start, 0, level,
 				  BTREE_ITER_prefetch|
 				  BTREE_ITER_not_extents|
@@ -707,7 +752,7 @@ int bch2_move_data_btree(struct moving_context *ctxt,
 next_nondata:
 		bch2_btree_iter_advance(trans, &iter);
 	}
-
+out:
 	bch2_trans_iter_exit(trans, &reflink_iter);
 	bch2_trans_iter_exit(trans, &iter);
 	bch2_bkey_buf_exit(&sk, c);
-- 
2.49.0


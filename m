Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B73ED19A298
	for <linux-bcachefs@vger.kernel.org>; Mon, 30 Dec 2024 21:43:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735594982; cv=none; b=b9TDPorZjImcWXn866Z6F5hiSQBOe6r8SykDD8FEZZaLqqH7KD+McfxtPs3B2dZBrVqiTwLQRtJ1OHVCafBV3yU/acm+T7qhANhKNzA2gCVp5WAtNUdbp9J6yLpS/iKg92j7amDdniA74s2/RQg5G8UIgZKqStDQsNOCviWyaRc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735594982; c=relaxed/simple;
	bh=cL6c/MSJ6jLz6ZPudHs5NHGbi41haY6zffG8A4U9UwY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N9fadvtA9jTu6RPF1DTn+eenYfkFgnS8sScX4DO/rhPAdk8L1/1D49gMpQCueAaa6Gw9EaKOOKlEgolrDTNb9QJ11gbiPVu40tgM+hPgfmr5uGS/mCv7W9pNcDDbM9FFOO3lP78LomU/Bxb4dSgtjLWukDoMalDVWRhP3PLVqMc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=NYCBdj7D; arc=none smtp.client-ip=91.218.175.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="NYCBdj7D"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1735594978;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=znN7eL7OYvl6N5b1BtmrYzF726SCLBWAt0W/orfct6w=;
	b=NYCBdj7DZx9XBNy5SXeaoqfYLelrUiibzg2r0VGD8QdaOHQChs1vKLd30n8onwaCcoYOWH
	F62/W5pUIKybegHXKxQEOB+J3x9uvEIb/ZADJhw2vAkyo2cxcC9eKHTxxUCcYh26zL7dOd
	xZ1S9g9c9ZxjaTVXKUEnj/2aRXBaYC0=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 03/11] bcachefs: bch2_btree_node_rewrite_key()
Date: Mon, 30 Dec 2024 16:42:41 -0500
Message-ID: <20241230214249.242966-3-kent.overstreet@linux.dev>
In-Reply-To: <20241230214249.242966-1-kent.overstreet@linux.dev>
References: <20241230214249.242966-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Add a new helper for rewriting a btree node given a just the key, not a
pointer to the node itself.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/btree_update_interior.c | 20 ++++++++++++++++++++
 fs/bcachefs/btree_update_interior.h |  4 ++++
 2 files changed, 24 insertions(+)

diff --git a/fs/bcachefs/btree_update_interior.c b/fs/bcachefs/btree_update_interior.c
index f4aeadbe53c1..ab111fec1701 100644
--- a/fs/bcachefs/btree_update_interior.c
+++ b/fs/bcachefs/btree_update_interior.c
@@ -2189,6 +2189,26 @@ int bch2_btree_node_rewrite(struct btree_trans *trans,
 	goto out;
 }
 
+int bch2_btree_node_rewrite_key(struct btree_trans *trans,
+				enum btree_id btree, unsigned level,
+				struct bpos pos, unsigned flags)
+{
+	BUG_ON(!level);
+
+	/* Traverse one depth lower to get a pointer to the node itself: */
+	struct btree_iter iter;
+	bch2_trans_node_iter_init(trans, &iter, btree, pos, 0, level - 1, 0);
+	struct btree *b = bch2_btree_iter_peek_node(&iter);
+	int ret = PTR_ERR_OR_ZERO(b);
+	if (ret)
+		goto err;
+
+	ret = bch2_btree_node_rewrite(trans, &iter, b, flags);
+err:
+	bch2_trans_iter_exit(trans, &iter);
+	return ret;
+}
+
 struct async_btree_rewrite {
 	struct bch_fs		*c;
 	struct work_struct	work;
diff --git a/fs/bcachefs/btree_update_interior.h b/fs/bcachefs/btree_update_interior.h
index 7930ffea3075..fa5a88f95d89 100644
--- a/fs/bcachefs/btree_update_interior.h
+++ b/fs/bcachefs/btree_update_interior.h
@@ -169,7 +169,11 @@ static inline int bch2_foreground_maybe_merge(struct btree_trans *trans,
 
 int bch2_btree_node_rewrite(struct btree_trans *, struct btree_iter *,
 			    struct btree *, unsigned);
+int bch2_btree_node_rewrite_key(struct btree_trans *,
+				enum btree_id, unsigned,
+				struct bpos, unsigned);
 void bch2_btree_node_rewrite_async(struct bch_fs *, struct btree *);
+
 int bch2_btree_node_update_key(struct btree_trans *, struct btree_iter *,
 			       struct btree *, struct bkey_i *,
 			       unsigned, bool);
-- 
2.45.2


Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E0EA1991CA
	for <linux-bcachefs@vger.kernel.org>; Mon, 30 Dec 2024 21:43:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735594986; cv=none; b=Fv19STY4OqUEg5oTJzgBYoCyICtdcRvlKwGFQTto2lS8RTG96/gPRDWDCvqTKD1iEOeE1nMMqo6/jiTiJahAIYKZgBHj2vvJX7VgKg53BmWD0zjFriZTxPN8AaWAqnkDZ5aD/432SDPUWL22VrEMp/DBPWCpGFp8p/+4wyH8MQM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735594986; c=relaxed/simple;
	bh=pN4UNx8Gm1U/lCIm8Ayf3Ia8XoEe4PaaaZ2zeFTExtY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SFSq67sjEzphhd0KlKLgQ4+hGgN9uI3D4i9I565S4f3mDoa5HhwoiEtsWn7k+Qca7j7G0gzmUG54tBMfywzzBWKp+9SD4OUIczAWb6qVGikU8+0xT4KXZLAfvThNDeHWpWP2RSaSa692rN4xDDcfYjoznqYg/1CnbjN5O0ApVOc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Vk+l2Rcc; arc=none smtp.client-ip=91.218.175.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Vk+l2Rcc"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1735594982;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NQb6pjava/2wIgV8gWDPhoD/09GqkDRrlmX5zYdFRVI=;
	b=Vk+l2RccAhllQ/tWXQ1ByRVPHS8SAds7+y2OB1yHVSIpSLIJBPU+9WiJZYh5g7fKNwOavh
	Vmc1BYWxzzv4wFnWKNFV1afh6iJrrhkNMzYcAgkZoXADM17aHLhOFFc8e4NTSQbmd3d/pY
	T2WMaooGAxfqgwR9nYOhaZldz0Ppub4=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 08/11] bcachefs: __bch2_btree_pos_to_text()
Date: Mon, 30 Dec 2024 16:42:46 -0500
Message-ID: <20241230214249.242966-8-kent.overstreet@linux.dev>
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

Factor out a version of bch2_btree_pos_to_text() that doesn't take a
pointer to a in-memory btree node, to be used for btree node scrub.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/btree_cache.c | 16 +++++++++++-----
 fs/bcachefs/btree_cache.h |  2 ++
 2 files changed, 13 insertions(+), 5 deletions(-)

diff --git a/fs/bcachefs/btree_cache.c b/fs/bcachefs/btree_cache.c
index b00c6a20be27..672ca2c1d37d 100644
--- a/fs/bcachefs/btree_cache.c
+++ b/fs/bcachefs/btree_cache.c
@@ -1402,18 +1402,24 @@ void bch2_btree_id_level_to_text(struct printbuf *out, enum btree_id btree, unsi
 	prt_printf(out, " level=%u", level);
 }
 
-void bch2_btree_pos_to_text(struct printbuf *out, struct bch_fs *c, const struct btree *b)
+void __bch2_btree_pos_to_text(struct printbuf *out, struct bch_fs *c,
+			      enum btree_id btree, unsigned level, struct bkey_s_c k)
 {
-	bch2_btree_id_to_text(out, b->c.btree_id);
-	prt_printf(out, " level %u/", b->c.level);
-	struct btree_root *r = bch2_btree_id_root(c, b->c.btree_id);
+	bch2_btree_id_to_text(out, btree);
+	prt_printf(out, " level %u/", level);
+	struct btree_root *r = bch2_btree_id_root(c, btree);
 	if (r)
 		prt_printf(out, "%u", r->level);
 	else
 		prt_printf(out, "(unknown)");
 	prt_printf(out, "\n  ");
 
-	bch2_bkey_val_to_text(out, c, bkey_i_to_s_c(&b->key));
+	bch2_bkey_val_to_text(out, c, k);
+}
+
+void bch2_btree_pos_to_text(struct printbuf *out, struct bch_fs *c, const struct btree *b)
+{
+	__bch2_btree_pos_to_text(out, c, b->c.btree_id, b->c.level, bkey_i_to_s_c(&b->key));
 }
 
 void bch2_btree_node_to_text(struct printbuf *out, struct bch_fs *c, const struct btree *b)
diff --git a/fs/bcachefs/btree_cache.h b/fs/bcachefs/btree_cache.h
index dcc34fe4996d..ca3c1b145330 100644
--- a/fs/bcachefs/btree_cache.h
+++ b/fs/bcachefs/btree_cache.h
@@ -147,6 +147,8 @@ const char *bch2_btree_id_str(enum btree_id);	/* avoid */
 void bch2_btree_id_to_text(struct printbuf *, enum btree_id);
 void bch2_btree_id_level_to_text(struct printbuf *, enum btree_id, unsigned);
 
+void __bch2_btree_pos_to_text(struct printbuf *, struct bch_fs *,
+			      enum btree_id, unsigned, struct bkey_s_c);
 void bch2_btree_pos_to_text(struct printbuf *, struct bch_fs *, const struct btree *);
 void bch2_btree_node_to_text(struct printbuf *, struct bch_fs *, const struct btree *);
 void bch2_btree_cache_to_text(struct printbuf *, const struct btree_cache *);
-- 
2.45.2


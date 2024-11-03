Received: from out-174.mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1DDF165F1A
	for <linux-bcachefs@vger.kernel.org>; Sun,  3 Nov 2024 22:32:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730673145; cv=none; b=u0HeVW+dNY9bd6WI/vNiWOIZx4KmCjpRd22GU6qaOZIbxA8iAkv4ITf0h4RgTcbVQioM9Z7zqRr49emf4YAcgOnfaf4eUMYOcyuG6IIWbEHxYGf/EPkkRC0vpHdoJqy3adEJ9eZfRkkk97py4j3JQWlqPBZV8YsOdFnmZ9utjfc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730673145; c=relaxed/simple;
	bh=lMSJGNz6RPpgag04n+ZyvJRU8QCerZhA7SzDrl8mSJA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RTYmoGZ4/H80dS5ythH/NP59Vt7CmZirLi1FA6glqYrMZE02vCX5U2nbGzgsS5AnTVQ81eKnBgUxZ7MXOMJy3QqUD/Evh+OT1/g9J1D3tXf8ltK+E8MwtWOCX1WBaOJQHZRVnYY3AC4jwYU+QRY0KeIfG9TwJsbMN5Wzs6vta2s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Sorw1fRQ; arc=none smtp.client-ip=95.215.58.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Sorw1fRQ"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1730673138;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YsoqFdNMuT8+P2OVUwZ5u2I/PkDXvXOzEXX1ddsFP98=;
	b=Sorw1fRQu0EbVbD++PEYBsNpp9VMp7Dd+KkMq/6c3xopaRKTn6P8Xp6Gs2uAoBUB2cJRvj
	CfMeGJlRQtzQEbak2cX9lzfe5UfABpnM7hXnz6PCPxD9aKmpZ+7O3v+g4jurkMln/x0rMJ
	JLOuUJFvU9S0GzXR7/YUcbuGf9Y3TTE=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 2/5] bcachefs: Fix error handling in bch2_btree_node_prefetch()
Date: Sun,  3 Nov 2024 17:32:00 -0500
Message-ID: <20241103223205.176754-3-kent.overstreet@linux.dev>
In-Reply-To: <20241103223205.176754-1-kent.overstreet@linux.dev>
References: <20241103223205.176754-1-kent.overstreet@linux.dev>
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
 fs/bcachefs/btree_cache.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/bcachefs/btree_cache.c b/fs/bcachefs/btree_cache.c
index 6e4afb2b5441..6f6225703eef 100644
--- a/fs/bcachefs/btree_cache.c
+++ b/fs/bcachefs/btree_cache.c
@@ -1312,9 +1312,12 @@ int bch2_btree_node_prefetch(struct btree_trans *trans,
 
 	b = bch2_btree_node_fill(trans, path, k, btree_id,
 				 level, SIX_LOCK_read, false);
-	if (!IS_ERR_OR_NULL(b))
+	int ret = PTR_ERR_OR_ZERO(b);
+	if (ret)
+		return ret;
+	if (b)
 		six_unlock_read(&b->c.lock);
-	return bch2_trans_relock(trans) ?: PTR_ERR_OR_ZERO(b);
+	return 0;
 }
 
 void bch2_btree_node_evict(struct btree_trans *trans, const struct bkey_i *k)
-- 
2.46.0


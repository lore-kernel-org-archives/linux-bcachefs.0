Received: from out-183.mta1.migadu.com (out-183.mta1.migadu.com [95.215.58.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3ED4F25F97D
	for <linux-bcachefs@vger.kernel.org>; Wed, 18 Jun 2025 21:54:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750283693; cv=none; b=FRARQBQqMnQWGssUQv1SLEV15FQCkSGDD2O0UzHRZeYM99VihnNvl+DIudq21F5CpsDE/aOHH0gqh0gdiABR2IAm1SEHRFCo1KmN1jOIFVJY6NBytjxNa5PSx9JtEj9K2n3pPJdCwUfwS+0sL+d3/BuC0te1uRULRtGZ+3sr3iA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750283693; c=relaxed/simple;
	bh=4Uno3XgivXeYCi6IkHi3IzrwwNSIohfZFfab+ttjWxg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B+EBk6KAcpz1ocLz0xcap6rai2fFq/hPwiUmgLz6yzko6tfbOJy7+jRy09djccIVguKu4OAiaThS5DTllqKudzzyABLUaTFrv1UI85t/5BAkxQWsimhcqEfuSJ5CwBrwx75hMOrAUI/kfVPBswnj936Y3fggJpcjQXZeLjpn2lM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=YQhcCbW4; arc=none smtp.client-ip=95.215.58.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="YQhcCbW4"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1750283689;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vNy6bOeiV9dnI5Yh/W2lFZywqiuOQM5lAy1pUwuI9LE=;
	b=YQhcCbW4rsrj7+j8Uu+koMeOqNHGPmhNsMrDwbbKAzyQLvA8ezyUDw0Bo4W/OTCyZsB25F
	n/RpJzfaH9Lagonf/PA6/tGCRVu4V7ru7voVIZNFjsBnDuO+/YQT7104kFPRCCCx/iia1n
	b3/4f1PZJ019jLWos5U0PGF3i2gzbZ8=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 09/37] bcachefs: better __bch2_snapshot_is_ancestor() assert
Date: Wed, 18 Jun 2025 17:54:00 -0400
Message-ID: <20250618215431.738317-10-kent.overstreet@linux.dev>
In-Reply-To: <20250618215431.738317-1-kent.overstreet@linux.dev>
References: <20250618215431.738317-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Previously, we weren't checking the result of the skiplist walk, just
the is_ancestor bitmap.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/snapshot.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/fs/bcachefs/snapshot.c b/fs/bcachefs/snapshot.c
index 23a332d76b32..38aeaa128d27 100644
--- a/fs/bcachefs/snapshot.c
+++ b/fs/bcachefs/snapshot.c
@@ -135,7 +135,9 @@ static bool test_ancestor_bitmap(struct snapshot_table *t, u32 id, u32 ancestor)
 
 bool __bch2_snapshot_is_ancestor(struct bch_fs *c, u32 id, u32 ancestor)
 {
-	bool ret;
+#ifdef CONFIG_BCACHEFS_DEBUG
+	u32 orig_id = id;
+#endif
 
 	guard(rcu)();
 	struct snapshot_table *t = rcu_dereference(c->snapshots);
@@ -147,11 +149,11 @@ bool __bch2_snapshot_is_ancestor(struct bch_fs *c, u32 id, u32 ancestor)
 		while (id && id < ancestor - IS_ANCESTOR_BITMAP)
 			id = get_ancestor_below(t, id, ancestor);
 
-	ret = id && id < ancestor
+	bool ret = id && id < ancestor
 		? test_ancestor_bitmap(t, id, ancestor)
 		: id == ancestor;
 
-	EBUG_ON(ret != __bch2_snapshot_is_ancestor_early(t, id, ancestor));
+	EBUG_ON(ret != __bch2_snapshot_is_ancestor_early(t, orig_id, ancestor));
 	return ret;
 }
 
-- 
2.50.0


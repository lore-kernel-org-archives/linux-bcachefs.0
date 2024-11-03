Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 565CA154C08
	for <linux-bcachefs@vger.kernel.org>; Sun,  3 Nov 2024 22:32:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730673147; cv=none; b=mQLPwpnS6rSbEqTzgcv17fXaXh7NFi2p8W87di9zfsRpNsn/ecIGJ2wmhRbMdLPuy4SgjXXbW0I163pVAwAq3l5goGQaChrVOkKrLzV6m0XXodK1rJUWJ/aqYecZp0cJWPAGkkY/xq4oN78OG/Bg1X6DwTGBG0B4bdkYS+4YFZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730673147; c=relaxed/simple;
	bh=NnugG4acwjfV7qfCLPK0d1QpRmMGmC+QBJ4O1U90tEA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ExjvWzD67zsKV9RmNcWpOY0UHBT8fp+0vrNAee82F7ioGu8dJNfkr8maumCKLZ7luAnQZBUg2kW2+oJZqO6NjItCOYikFgtrjNZLSHjnKs8HkfixQqWqu1nprzeZANXpEEvMSkRW015vTNnkkqz2tchke8ACsUQ5e9hyg0kOmTI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=LlfKCTGg; arc=none smtp.client-ip=95.215.58.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="LlfKCTGg"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1730673141;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RnFFqp3byWHI/ouarKlRinfT2PlIWMpJ5WdSv0lPSvo=;
	b=LlfKCTGgQZDUbmet5JxlpTaYHUqNkrdF4KOl9Z1iY1Dn5kVV9NPTwZIdlsGMakX0X941x/
	Os/nFJ5Md3nGLIXcMMK3fiikCEoiEaswY9ogtSY2aQpmSy7BEhC4vHnhKeB4fzJsgFD4CM
	0A+a91IzqsX2qiKJpis7S2+DkrYDVj4=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 4/5] bcachefs: Fix topology errors on split after merge
Date: Sun,  3 Nov 2024 17:32:02 -0500
Message-ID: <20241103223205.176754-5-kent.overstreet@linux.dev>
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

If a btree split picks a pivot that's being deleted by a btree node
merge, we're going to have problems.

Fix this by checking if the pivot is being deleted, the same as we check
for deletions in journal replay keys.

Found by single_devic.ktest small_nodes.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/btree_update_interior.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/fs/bcachefs/btree_update_interior.c b/fs/bcachefs/btree_update_interior.c
index 64f0928e1137..c12d7b51de0c 100644
--- a/fs/bcachefs/btree_update_interior.c
+++ b/fs/bcachefs/btree_update_interior.c
@@ -1434,6 +1434,15 @@ bch2_btree_insert_keys_interior(struct btree_update *as,
 	}
 }
 
+static bool key_deleted_in_insert(struct keylist *insert_keys, struct bpos pos)
+{
+	if (insert_keys)
+		for_each_keylist_key(insert_keys, k)
+			if (bkey_deleted(&k->k) && bpos_eq(k->k.p, pos))
+				return true;
+	return false;
+}
+
 /*
  * Move keys from n1 (original replacement node, now lower node) to n2 (higher
  * node)
@@ -1441,7 +1450,8 @@ bch2_btree_insert_keys_interior(struct btree_update *as,
 static void __btree_split_node(struct btree_update *as,
 			       struct btree_trans *trans,
 			       struct btree *b,
-			       struct btree *n[2])
+			       struct btree *n[2],
+			       struct keylist *insert_keys)
 {
 	struct bkey_packed *k;
 	struct bpos n1_pos = POS_MIN;
@@ -1476,7 +1486,8 @@ static void __btree_split_node(struct btree_update *as,
 		if (b->c.level &&
 		    u64s < n1_u64s &&
 		    u64s + k->u64s >= n1_u64s &&
-		    bch2_key_deleted_in_journal(trans, b->c.btree_id, b->c.level, uk.p))
+		    (bch2_key_deleted_in_journal(trans, b->c.btree_id, b->c.level, uk.p) ||
+		     key_deleted_in_insert(insert_keys, uk.p)))
 			n1_u64s += k->u64s;
 
 		i = u64s >= n1_u64s;
@@ -1603,7 +1614,7 @@ static int btree_split(struct btree_update *as, struct btree_trans *trans,
 		n[0] = n1 = bch2_btree_node_alloc(as, trans, b->c.level);
 		n[1] = n2 = bch2_btree_node_alloc(as, trans, b->c.level);
 
-		__btree_split_node(as, trans, b, n);
+		__btree_split_node(as, trans, b, n, keys);
 
 		if (keys) {
 			btree_split_insert_keys(as, trans, path, n1, keys);
-- 
2.46.0


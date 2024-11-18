Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16B181EEE0
	for <linux-bcachefs@vger.kernel.org>; Mon, 18 Nov 2024 01:37:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731893872; cv=none; b=U7DmnKOIqitrurgIF5YEsDWEHYQiFJW/kRBnq5Z7mfGrNUI4isJI7AJJ+QgnPw+njG2X7R+UXf9Ub/lTnsOgUYdjYSzZlmfpeGm8dCqsKbuylazGXbODqoxmUYol/5bZGTVN6MMBAailoT7K3pADcBUeq/UvH3fRiSDqnVqc/Jk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731893872; c=relaxed/simple;
	bh=AUN225LisIbW0NRDkwHyeP6dbVbQkWi9ueDvQYAKNgw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BUB8a3Pewghp6n4rmLzo0/0SPsJ5j23Cti6ZY2O+lbwYJqa1r/whH6yG8gfhNkYNGDgqBfzbVRhbuh2prfgeUkxHgA5VItv+8AoZY2vZKyW8tMA0xA4wy8rQp0t74lKUeGJMPsq9z1tLVqaasHk8LksxUDa4efB+CXHAQkZZ6Rk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=KXmbPd6a; arc=none smtp.client-ip=91.218.175.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="KXmbPd6a"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1731893869;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vA019MVae1Cgx9BU8BO1NsIw4BxPfQeSecYyJgBkJ1w=;
	b=KXmbPd6a0QuCcgXTOUdkMckcN87CdXFohV/T+5l/5TlkB3VAdqCvjXu+IntIHxNB0QV5jr
	n3zuFZyD3/W9NfGyAfMG6k7hqoir7DIgAVgH+8W4Rx7ndMaD7PCh9MT4Kvp88h+WYMjYD6
	/9lnVI1T/TTjaLBrsK5KaNj79PyptTw=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 2/4] bcachefs: journal keys: sort keys for interior nodes first
Date: Sun, 17 Nov 2024 20:37:31 -0500
Message-ID: <20241118013733.2275244-2-kent.overstreet@linux.dev>
In-Reply-To: <20241118013733.2275244-1-kent.overstreet@linux.dev>
References: <20241118013733.2275244-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

There's an unavoidable issue with btree lookups when we're overlaying
journal keys and the journal has many deletions for keys present in the
btree - peek operations will have to iterate over all those deletions to
find the next live key to return.

This is mainly a problem for lookups in interior nodes, if we have to
traverse to a leaf. Looking up an insert position in a leaf (for journal
replay) doesn't have to find the next live key, but walking down the
btree does.

So to ameloriate this, change journal key sort ordering so that we
replay keys from roots and interior nodes first.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/btree_journal_iter.c | 10 ++++------
 fs/bcachefs/btree_journal_iter.h | 13 ++++++++++---
 2 files changed, 14 insertions(+), 9 deletions(-)

diff --git a/fs/bcachefs/btree_journal_iter.c b/fs/bcachefs/btree_journal_iter.c
index 39898baa8854..dbc9bc233cca 100644
--- a/fs/bcachefs/btree_journal_iter.c
+++ b/fs/bcachefs/btree_journal_iter.c
@@ -172,9 +172,8 @@ static void journal_iter_verify(struct journal_iter *iter)
 	if (iter->idx < keys->size) {
 		struct journal_key *k = keys->data + iter->idx;
 
-		int cmp = cmp_int(k->btree_id,	iter->btree_id) ?:
-			  cmp_int(k->level,	iter->level);
-		BUG_ON(cmp < 0);
+		int cmp = __journal_key_btree_cmp(iter->btree_id, iter->level, k);
+		BUG_ON(cmp > 0);
 	}
 }
 
@@ -365,9 +364,8 @@ static struct bkey_s_c bch2_journal_iter_peek(struct journal_iter *iter)
 	while (iter->idx < iter->keys->size) {
 		struct journal_key *k = iter->keys->data + iter->idx;
 
-		int cmp = cmp_int(k->btree_id,	iter->btree_id) ?:
-			  cmp_int(k->level,	iter->level);
-		if (cmp > 0)
+		int cmp = __journal_key_btree_cmp(iter->btree_id, iter->level, k);
+		if (cmp < 0)
 			break;
 		BUG_ON(cmp);
 
diff --git a/fs/bcachefs/btree_journal_iter.h b/fs/bcachefs/btree_journal_iter.h
index 5ddbb7571770..118ada4cdd1b 100644
--- a/fs/bcachefs/btree_journal_iter.h
+++ b/fs/bcachefs/btree_journal_iter.h
@@ -28,14 +28,21 @@ struct btree_and_journal_iter {
 	bool			prefetch;
 };
 
+static inline int __journal_key_btree_cmp(enum btree_id	l_btree_id,
+					  unsigned	l_level,
+					  const struct journal_key *r)
+{
+	return -cmp_int(l_level,	r->level) ?:
+		cmp_int(l_btree_id,	r->btree_id);
+}
+
 static inline int __journal_key_cmp(enum btree_id	l_btree_id,
 				    unsigned		l_level,
 				    struct bpos	l_pos,
 				    const struct journal_key *r)
 {
-	return (cmp_int(l_btree_id,	r->btree_id) ?:
-		cmp_int(l_level,	r->level) ?:
-		bpos_cmp(l_pos,	r->k->k.p));
+	return __journal_key_btree_cmp(l_btree_id, l_level, r) ?:
+		bpos_cmp(l_pos,	r->k->k.p);
 }
 
 static inline int journal_key_cmp(const struct journal_key *l, const struct journal_key *r)
-- 
2.45.2


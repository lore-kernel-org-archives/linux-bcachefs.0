Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65409208C4
	for <linux-bcachefs@vger.kernel.org>; Mon, 18 Nov 2024 01:37:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731893877; cv=none; b=mKAQgNr7B1s0LZER9stFHmyuCGOKGDbV/7hPyLeWFCkwmpaG5PjZrZH9eKLXLuQyKfEJeYknC74B6eVkvc6q46EmFIuMHMHaTCySpgQcnTokAv3JnxHeIzwQ/E29uI257Y/qJWDPX6+8ktmQ4u38r/HD7QfE77hslRvCJgTQ+Cc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731893877; c=relaxed/simple;
	bh=dNj0i4qtuUgBIPXR+z3XtWXhqjEpSwYQGVJ8liYWTiU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GL1RyUU98Kc97YmJzfmpVO4BuCpxELQ07eggk/azUlqXe7+OlCoKWDNf1uiECEtqRGiHrPp/Yo66yvOedlvk0f/duyKD7xEn5qE/oWKHDBAdyKMYQBKCH4M7950ynYyMYjMdnyul6GXSTu5D0LUQmU0eiMnGsI5ix1BAoCTQ60M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=MqZefSyj; arc=none smtp.client-ip=91.218.175.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="MqZefSyj"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1731893870;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Lg+EKjpWt/aUleDXUUfKPGCvgL89Bm8/xlLiwAqL20U=;
	b=MqZefSyjJAi+r0jNDf9N2wFze/p+BZz74E7b3YWDYZAXvpfmvk0fU4flcxz3GhNeDPIfx4
	9qpKQ8Txvpwn25MkwBdU/T6IutGhGVs747+K3peMaz1ktxSERGRYcUUbKBptmjCJfkRhgQ
	KNhwu8BCujeLkPFngoZXIC9IFd6RXY0=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 3/4] bcachefs: btree_and_journal_iter: don't iterate over too many whiteouts when prefetching
Date: Sun, 17 Nov 2024 20:37:32 -0500
Message-ID: <20241118013733.2275244-3-kent.overstreet@linux.dev>
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

To help ameloriate issues with peek operations having to skip over
deletions in the journal - just bail out if all we're doing is
prefetching btree nodes.

Since btree node prefetching runs every time we iterate to a new node,
and has to sequentially scan ahead, this avoids another O(n^2).

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/btree_iter.c         | 2 ++
 fs/bcachefs/btree_journal_iter.c | 9 ++++++++-
 fs/bcachefs/btree_journal_iter.h | 1 +
 3 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/fs/bcachefs/btree_iter.c b/fs/bcachefs/btree_iter.c
index ed74f0655d98..89f9665ce70d 100644
--- a/fs/bcachefs/btree_iter.c
+++ b/fs/bcachefs/btree_iter.c
@@ -825,6 +825,8 @@ static int btree_path_prefetch_j(struct btree_trans *trans, struct btree_path *p
 
 	bch2_bkey_buf_init(&tmp);
 
+	jiter->fail_if_too_many_whiteouts = true;
+
 	while (nr-- && !ret) {
 		if (!bch2_btree_node_relock(trans, path, path->level))
 			break;
diff --git a/fs/bcachefs/btree_journal_iter.c b/fs/bcachefs/btree_journal_iter.c
index dbc9bc233cca..93a5f758d419 100644
--- a/fs/bcachefs/btree_journal_iter.c
+++ b/fs/bcachefs/btree_journal_iter.c
@@ -426,6 +426,7 @@ static void btree_and_journal_iter_prefetch(struct btree_and_journal_iter *_iter
 		: (level > 1 ? 1 : 16);
 
 	iter.prefetch = false;
+	iter.fail_if_too_many_whiteouts = true;
 	bch2_bkey_buf_init(&tmp);
 
 	while (nr--) {
@@ -444,12 +445,18 @@ static void btree_and_journal_iter_prefetch(struct btree_and_journal_iter *_iter
 struct bkey_s_c bch2_btree_and_journal_iter_peek(struct btree_and_journal_iter *iter)
 {
 	struct bkey_s_c btree_k, journal_k = bkey_s_c_null, ret;
+	size_t iters = 0;
 
 	if (iter->prefetch && iter->journal.level)
 		btree_and_journal_iter_prefetch(iter);
-again:
+
 	if (iter->at_end)
 		return bkey_s_c_null;
+again:
+	iters++;
+
+	if (iters > 20 && iter->fail_if_too_many_whiteouts)
+		return bkey_s_c_null;
 
 	while ((btree_k = bch2_journal_iter_peek_btree(iter)).k &&
 	       bpos_lt(btree_k.k->p, iter->pos))
diff --git a/fs/bcachefs/btree_journal_iter.h b/fs/bcachefs/btree_journal_iter.h
index 118ada4cdd1b..9e8f8ab1c6ff 100644
--- a/fs/bcachefs/btree_journal_iter.h
+++ b/fs/bcachefs/btree_journal_iter.h
@@ -26,6 +26,7 @@ struct btree_and_journal_iter {
 	struct bpos		pos;
 	bool			at_end;
 	bool			prefetch;
+	bool			fail_if_too_many_whiteouts;
 };
 
 static inline int __journal_key_btree_cmp(enum btree_id	l_btree_id,
-- 
2.45.2


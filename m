Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E63F419994F
	for <linux-bcachefs@vger.kernel.org>; Mon, 30 Jun 2025 21:29:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751318984; cv=none; b=fQRrnQJl4L73beyT2MvjrxzoBP2FCAce64DN52bpq7EFFxuWW3dSPj8QcDrWxYRYx1Th9fgmhqb5hIQ5t6VdcAN4imjYnNpvx9Aa7H2KU9yEomkuEbpYZx8JPCKiq/29DnhbNLu8PRsKTATkOdKY+K4aujMSpgzRW38I6BUiFE4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751318984; c=relaxed/simple;
	bh=OXQKabQwAzKl3gY8mKCRPBiiqW0XpnjXvnylDhRgANE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=KL3UBcIxFkPnw/SrctVk5Vtg5mFOyOCynG6+5VM2hvXuCvja3hFPA7/XSKIQXmap/8c6HIEzwX4l56Zjf/xRePRJru0lklAmPY4MtwQyw9Z9QLHvjOV8Pzrt8zZ5ET/3eN3Jr7FJFmZ+rJtuFkIfNr8bONQ2LrKh+cPzl7Vy8T4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=N+snK3Ox; arc=none smtp.client-ip=95.215.58.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="N+snK3Ox"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1751318980;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=nDQaDMcHgcDtGw8iLDXLZWwTa06sRWFBBrXGIDtGVyY=;
	b=N+snK3OxZDrQqzxpgWvNjyUd6GV+rTrdz6mr5n6+b0j81Ez6RIuS/sLMQyM958IXvN0CVv
	inuZqriecIcSeEtIUqZPfCb28qxRdzkyOV3UXezM/s0+cWqYhU5lhVsW0New4i/HOPUrCq
	ndq79+Vn46glpu+xvUJCsjic18G4I6g=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH] bcachefs: fix btree_trans_peek_prev_journal()
Date: Mon, 30 Jun 2025 17:29:33 -0400
Message-ID: <20250630212934.2063498-1-kent.overstreet@linux.dev>
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
 fs/bcachefs/btree_iter.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/bcachefs/btree_iter.c b/fs/bcachefs/btree_iter.c
index 352f9cd2634f..f8829b667ad3 100644
--- a/fs/bcachefs/btree_iter.c
+++ b/fs/bcachefs/btree_iter.c
@@ -2189,7 +2189,7 @@ void btree_trans_peek_prev_journal(struct btree_trans *trans,
 	struct btree_path *path = btree_iter_path(trans, iter);
 	struct bkey_i *next_journal =
 		bch2_btree_journal_peek_prev(trans, iter, search_key,
-				k->k ? k->k->p : path_l(path)->b->key.k.p);
+				k->k ? k->k->p : path_l(path)->b->data->min_key);
 
 	if (next_journal) {
 		iter->k = next_journal->k;
-- 
2.50.0


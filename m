Received: from out-172.mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 518576FC3
	for <linux-bcachefs@vger.kernel.org>; Sun, 27 Oct 2024 00:51:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729990321; cv=none; b=l5g0eGMJZPhq4ZEQ0QjZQVzfChm2k1dguV1/a4Sjtqo2dawkRgxKL5vF3IgEz1dDBEwAleRBqJAODDE1MMZxyp9Js6CGJWaJ6Fm3m6ecQ6W10gffPzRgCZMgV15RiB9qRVvnY8OzU2cnMuPheBaKE91botlXDV94Q5MWdrm4wUA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729990321; c=relaxed/simple;
	bh=PU8oSOarCgiQs2E9ReB8tZiSctvLno/8RGl580Wdokg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l3x7g5gez3Ok/EakrcuTwq/N1O4mpzfq4dq/HB+TJ2W81gzRKOSRAtDREaWN6QljK/HUv6XEvDhpp/X+1XWm2s4aLb1AIwvwaP3Q7oNgpA3H5LJp19XyI/OjUD2ldUn3x/gg7rc/NLqvqrs/eLsjZw1Joi7IWF4PIEcTYPEA2oA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=rumsvo8k; arc=none smtp.client-ip=95.215.58.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="rumsvo8k"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1729990317;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MDSheTnl43SP5GlSQibgbCrbvrZzTnYxbJK4DiyJe/k=;
	b=rumsvo8kUapqWrJPabWpd+tEvCItA4vY7WtLoeHu5yxLV/3rwu5PCXF+G6/DfbPQ+IXwda
	MYmqjP6x34/A9e3CnZqXsQA7BEbGgeJmXnwG+CEQ7OjMuwiCDsoEJmV9u3+JOa6sCOF5dG
	vBjsQvN6UaDk7W+yevc+Jk2ejzyOvG8=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 7/9] bcachefs: Kill unnecessary iter_rewind() in bkey_get_empty_slot()
Date: Sat, 26 Oct 2024 20:51:36 -0400
Message-ID: <20241027005141.2337634-8-kent.overstreet@linux.dev>
In-Reply-To: <20241027005141.2337634-1-kent.overstreet@linux.dev>
References: <20241027005141.2337634-1-kent.overstreet@linux.dev>
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
 fs/bcachefs/btree_update.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/fs/bcachefs/btree_update.c b/fs/bcachefs/btree_update.c
index 4bc0b2d52133..402539bea67d 100644
--- a/fs/bcachefs/btree_update.c
+++ b/fs/bcachefs/btree_update.c
@@ -588,12 +588,9 @@ struct jset_entry *__bch2_trans_jset_entry_alloc(struct btree_trans *trans, unsi
 int bch2_bkey_get_empty_slot(struct btree_trans *trans, struct btree_iter *iter,
 			     enum btree_id btree, struct bpos end)
 {
-	struct bkey_s_c k;
-	int ret = 0;
-
 	bch2_trans_iter_init(trans, iter, btree, POS_MAX, BTREE_ITER_intent);
-	k = bch2_btree_iter_prev(iter);
-	ret = bkey_err(k);
+	struct bkey_s_c k = bch2_btree_iter_peek_prev(iter);
+	int ret = bkey_err(k);
 	if (ret)
 		goto err;
 
-- 
2.45.2


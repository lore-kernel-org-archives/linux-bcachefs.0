Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7996240604
	for <linux-bcachefs@vger.kernel.org>; Thu, 19 Jun 2025 16:37:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750351047; cv=none; b=SIrd+mqCXVlYsxchBC92Tvf8VrP+1lVQGsET58fMiKS6KXWhPpdAp3O7SuDTDMfkQP8KOtqQK7EtcQl/Grh+HQyPj4HrLst41saZgqc2OM6I7SOvrFz/37RhGXOgDXIH+wHUDND1uAVAwJ7iJxYhk1cWwTseRAIuSln608tNObU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750351047; c=relaxed/simple;
	bh=56kmV59zh/SpCCuozz5wHyVqWOSBTGYWsTW2U9WJfpc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BUFOnvvJP4JkvL+FHh/FC9tD1SOlK55gFc6WBOsjrOFGvQV0tlClM01ultUDCJHfyOcZj5TNy2fQLliLIXUGIR84i+1zliKAkyh1chzGP7l+eTkVFaMcg7a1WKKJxlvjw7e+ohVTYW5Nipv3ij9DCFJU6Bw8ioqFGfx5wWpxICY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=eCeKntw5; arc=none smtp.client-ip=95.215.58.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="eCeKntw5"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1750351041;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rekGRdanLR58WpiXBTNzAmiZYpjPJc/DMivHqBk9Fp0=;
	b=eCeKntw5HaA8732Q7bdSomlvvKQh2GOFxB0VVQT5a/7DzBuAhYncJhQcDbZ0XM71X6n4/3
	/mLRXPHn3y7KmNLBdUOGe//B1oww3cQlQsy9g46GPCXdTQ6i1iVejJW/p82GGyPqoRXK15
	SunIa6jjebIs/sdvWMaYjddOGe2ghO4=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Alan Huang <mmpgouride@gmail.com>,
	Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 2/3] bcachefs: Fix *__bch2_trans_subbuf_alloc() error path
Date: Thu, 19 Jun 2025 12:37:13 -0400
Message-ID: <20250619163714.767851-2-kent.overstreet@linux.dev>
In-Reply-To: <20250619163714.767851-1-kent.overstreet@linux.dev>
References: <20250619163714.767851-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Don't change buf->size on error - this would usually be a transaction
restart, but it could also be -ENOMEM - when we've exceeded the bump
allocator max).

Fixes: 247abee6ae6d ("bcachefs: btree_trans_subbuf")
Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/btree_update.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/fs/bcachefs/btree_update.c b/fs/bcachefs/btree_update.c
index f7949dbe8f70..668d4feb2879 100644
--- a/fs/bcachefs/btree_update.c
+++ b/fs/bcachefs/btree_update.c
@@ -550,19 +550,26 @@ void *__bch2_trans_subbuf_alloc(struct btree_trans *trans,
 {
 	unsigned new_top = buf->u64s + u64s;
 	unsigned old_size = buf->size;
+	unsigned new_size = buf->size;
 
-	if (new_top > buf->size)
-		buf->size = roundup_pow_of_two(new_top);
+	BUG_ON(roundup_pow_of_two(new_top) > U16_MAX);
 
-	void *n = bch2_trans_kmalloc_nomemzero_ip(trans, buf->size * sizeof(u64), ip);
+	if (new_top > new_size)
+		new_size = roundup_pow_of_two(new_top);
+
+	void *n = bch2_trans_kmalloc_nomemzero_ip(trans, new_size * sizeof(u64), ip);
 	if (IS_ERR(n))
 		return n;
 
+	unsigned offset = (u64 *) n - (u64 *) trans->mem;
+	BUG_ON(offset > U16_MAX);
+
 	if (buf->u64s)
 		memcpy(n,
 		       btree_trans_subbuf_base(trans, buf),
 		       old_size * sizeof(u64));
 	buf->base = (u64 *) n - (u64 *) trans->mem;
+	buf->size = new_size;
 
 	void *p = btree_trans_subbuf_top(trans, buf);
 	buf->u64s = new_top;
-- 
2.50.0


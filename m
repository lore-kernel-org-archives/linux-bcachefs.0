Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 764C717FE
	for <linux-bcachefs@vger.kernel.org>; Mon, 18 Nov 2024 01:45:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731894313; cv=none; b=stWfLIPKVLoySQ2T/+v3ghn9BBf7fCdWounFArLU9TMx6Ze7p29uGQiNpwtmD993TPHkqvnThigm7mkKkXpS7s/YWozUOCd+grpkRDe0AUc2PaYV8bCqV4Gum6PnwYPvJ9RUkItjatVVWKZ1s2nduVWCnr9uOEXtwRzf5Y19D6c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731894313; c=relaxed/simple;
	bh=1u75YR0gAAFd7keXQJn8fvzWbNoljfrpFxhrJcTY0cg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lekPT2JX0VhAWysgE+UsowUgZxJduYgaSYJx9xDMgRiE//6GCWlUoCWXvqZJcKLW2hX9bhC6TO/WzHxlttP0V6+cuvAmwyVMms0kEdvZoepf8QJRSnmvt+h9sQw1txyO7d6FHFxlORNO3ycOJ2+f+IO+0AU4BO51sDcQPSjpvoQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=dgGwY1pL; arc=none smtp.client-ip=91.218.175.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="dgGwY1pL"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1731894309;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=H0EzkXEkxWXInEiyd3G7kgBgx/Xuj9N8STDFgufpamY=;
	b=dgGwY1pLH5zKsHXwiKJaUbSfkg9hfl80hGqkR8GsKTYvJeIXV1sjqqcYAADopvf6CLt4SX
	B0X5Mz7oQxerTzBBhbHOds73bf0LxUz7QnRY1TNZlZe/bRla6dCtKKOV/iFZcmFnpIgOTu
	JHOpo79U5/XX0wAu8HDdxgGvQcFdIjg=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 3/7] bcachefs: Drop swab code for backpointers in alloc keys
Date: Sun, 17 Nov 2024 20:44:44 -0500
Message-ID: <20241118014451.2275941-4-kent.overstreet@linux.dev>
In-Reply-To: <20241118014451.2275941-1-kent.overstreet@linux.dev>
References: <20241118014451.2275941-1-kent.overstreet@linux.dev>
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
 fs/bcachefs/alloc_background.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/fs/bcachefs/alloc_background.c b/fs/bcachefs/alloc_background.c
index e90561b6def6..ae9fdb5ad758 100644
--- a/fs/bcachefs/alloc_background.c
+++ b/fs/bcachefs/alloc_background.c
@@ -322,7 +322,6 @@ int bch2_alloc_v4_validate(struct bch_fs *c, struct bkey_s_c k,
 void bch2_alloc_v4_swab(struct bkey_s k)
 {
 	struct bch_alloc_v4 *a = bkey_s_to_alloc_v4(k).v;
-	struct bch_backpointer *bp, *bps;
 
 	a->journal_seq		= swab64(a->journal_seq);
 	a->flags		= swab32(a->flags);
@@ -333,13 +332,6 @@ void bch2_alloc_v4_swab(struct bkey_s k)
 	a->stripe		= swab32(a->stripe);
 	a->nr_external_backpointers = swab32(a->nr_external_backpointers);
 	a->stripe_sectors	= swab32(a->stripe_sectors);
-
-	bps = alloc_v4_backpointers(a);
-	for (bp = bps; bp < bps + BCH_ALLOC_V4_NR_BACKPOINTERS(a); bp++) {
-		bp->bucket_offset	= swab40(bp->bucket_offset);
-		bp->bucket_len		= swab32(bp->bucket_len);
-		bch2_bpos_swab(&bp->pos);
-	}
 }
 
 void bch2_alloc_to_text(struct printbuf *out, struct bch_fs *c, struct bkey_s_c k)
-- 
2.45.2


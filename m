Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55AB7197531
	for <linux-bcachefs@vger.kernel.org>; Mon, 21 Oct 2024 03:41:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729482088; cv=none; b=Hrbiz2ASoWfW5p9H/2gjVAgx9F/0CKWOARK0EsP6e3+plJ4f/R/DZLgbiQH/YU3IZQwoCVoTeSHIkgQLSZTW7vV3pL/nYGVOj+lVhGKUBOIdNIPpELfK4M9PZFyrkrOgkLv3EUfggv9pVuaYJIuUmiwYpxu56ncZDmgggLi5CSs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729482088; c=relaxed/simple;
	bh=UH3jG5+CmqJ4xcGPueLGBd6446Uj7m833dBSkGi2H1M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Cxqf9X3OkJYpp5pN3kMJ9FBFWEIWAOnK7fuhiDoxa1dFKf1Jjt01F4xPbecwnhGZH2WXSYNppCzCF5PswXytzqbyBamRnf8YTJ72Ihx4eAo51WlCstFXVPdQAjYVx72Mj9dwPrKFpil62d11RU+B2ESpwX5Gs8jhlFcrAiAmXIQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=BVLfQpYS; arc=none smtp.client-ip=91.218.175.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="BVLfQpYS"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1729482084;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oJUcLoT6/88caJMzaZIfrXmjgyQByV+RYLzwCEmIkxU=;
	b=BVLfQpYSqahk6snHJhKVb2G9matmukvgS05x6WWyaJH5xrgbVYx7KiAA6EXwPtsNMMjxDa
	LHhDjX+CE7ReiY0Z6FZjejX9xE+ZaWOHS6MU+xtN1cL6BVJ0yOyG5KtYlQ/akEoc0JRVSB
	/7vj55Bu1ZgwTR3hdekRwYzLeiOTTTc=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 05/12] bcachefs: kill bch2_bkey_needs_rebalance()
Date: Sun, 20 Oct 2024 23:40:56 -0400
Message-ID: <20241021034106.384756-6-kent.overstreet@linux.dev>
In-Reply-To: <20241021034106.384756-1-kent.overstreet@linux.dev>
References: <20241021034106.384756-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Dead code

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/extents.c | 17 -----------------
 fs/bcachefs/extents.h |  1 -
 2 files changed, 18 deletions(-)

diff --git a/fs/bcachefs/extents.c b/fs/bcachefs/extents.c
index 87e7969b55f4..7a9bc5122674 100644
--- a/fs/bcachefs/extents.c
+++ b/fs/bcachefs/extents.c
@@ -1439,23 +1439,6 @@ unsigned bch2_bkey_ptrs_need_rebalance(struct bch_fs *c, struct bkey_s_c k,
 	return rewrite_ptrs;
 }
 
-bool bch2_bkey_needs_rebalance(struct bch_fs *c, struct bkey_s_c k)
-{
-	const struct bch_extent_rebalance *r = bch2_bkey_rebalance_opts(k);
-
-	/*
-	 * If it's an indirect extent, we don't delete the rebalance entry when
-	 * done so that we know what options were applied - check if it still
-	 * needs work done:
-	 */
-	if (r &&
-	    k.k->type == KEY_TYPE_reflink_v &&
-	    !bch2_bkey_ptrs_need_rebalance(c, k, r->target, r->compression))
-		r = NULL;
-
-	return r != NULL;
-}
-
 static u64 __bch2_bkey_sectors_need_rebalance(struct bch_fs *c, struct bkey_s_c k,
 				       unsigned target, unsigned compression)
 {
diff --git a/fs/bcachefs/extents.h b/fs/bcachefs/extents.h
index bcffcf60aaaf..9374599b384d 100644
--- a/fs/bcachefs/extents.h
+++ b/fs/bcachefs/extents.h
@@ -713,7 +713,6 @@ void bch2_ptr_swab(struct bkey_s);
 const struct bch_extent_rebalance *bch2_bkey_rebalance_opts(struct bkey_s_c);
 unsigned bch2_bkey_ptrs_need_rebalance(struct bch_fs *, struct bkey_s_c,
 				       unsigned, unsigned);
-bool bch2_bkey_needs_rebalance(struct bch_fs *, struct bkey_s_c);
 u64 bch2_bkey_sectors_need_rebalance(struct bch_fs *, struct bkey_s_c);
 
 int bch2_bkey_set_needs_rebalance(struct bch_fs *, struct bkey_i *,
-- 
2.45.2


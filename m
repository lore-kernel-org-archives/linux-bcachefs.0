Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6565D9475
	for <linux-bcachefs@vger.kernel.org>; Sun,  8 Jun 2025 00:28:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749342538; cv=none; b=NKBB8Y0QssSyKH2+uLizL97APMhhc8D4mjM7s9E5/lGJ+e9O56KTseTIR/7/KkY6MIkZRTeAA6A5CNAdkz+qh+tWoqn2bUleIN6rzls7oVYL5brNoj4DnviY9+WFr4wljIVSUIXhXRVhRslUpGzRWcFuuJLUxa/+U9dBBEpGXGk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749342538; c=relaxed/simple;
	bh=Kakq3e/Aok/11A/l9ObfFF/Q/rsNWugvD1x+SZXLj7A=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=CsZoz5BrJ63IZ0mmIlq/ttSJswENga6gOa2stSNmflAw6ydgv1CAju7/Eh1I07cCoGRrEeTyKuv/51YoXfsArZkWN/tTcg8isks1NGqEJaMYNw4+J3OZf22OGMg2ruaA4oSFicR+/Q59JOPMLqPHikQc4pTOsEO7R10Lu4frmnA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=dgeeGI17; arc=none smtp.client-ip=91.218.175.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="dgeeGI17"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1749342532;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=xyo7oo6gNQ/CmEzE+Sfbmb64AhpjV3g7UDyPNUAlBms=;
	b=dgeeGI17QWu59TSEst/gWrPiM681lQntGKLYNEUrHsVYKQb4fQiMJqfrfjsnnfUVjnhdVg
	uFGWu0Q1KoBRvIzCxEwQiD9CXJx+VYtBqE7aULRITMC4IFnG7bNLFQkcFjsMdwUS+OlJKc
	5PDbC9/hm9vv0kfeOmal6DVIzJOcR9A=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: mmpgouride@gmail.com,
	Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH] bcachefs: Re-add seemingly duplicate bch2_trans_begin()
Date: Sat,  7 Jun 2025 20:28:47 -0400
Message-ID: <20250608002847.1871960-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Include a comment this time - we can't call iter_init() in a transaction
restart, and write bufer flush doesn't guarantee that we aren't in a
restart when it returns.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/movinggc.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/bcachefs/movinggc.c b/fs/bcachefs/movinggc.c
index 6d7b1d5f7697..697d58b0bf91 100644
--- a/fs/bcachefs/movinggc.c
+++ b/fs/bcachefs/movinggc.c
@@ -154,6 +154,12 @@ static int bch2_copygc_get_buckets(struct moving_context *ctxt,
 	if (bch2_fs_fatal_err_on(ret, c, "%s: from bch2_btree_write_buffer_tryflush()", bch2_err_str(ret)))
 		return ret;
 
+	/*
+	 * we might be in a transaction restart from write buffer flush, start a
+	 * new transaction before iter_init -> path_get
+	 */
+	bch2_trans_begin(trans);
+
 	ret = for_each_btree_key_max(trans, iter, BTREE_ID_lru,
 				  lru_pos(BCH_LRU_BUCKET_FRAGMENTATION, 0, 0),
 				  lru_pos(BCH_LRU_BUCKET_FRAGMENTATION, U64_MAX, LRU_TIME_MAX),
-- 
2.49.0


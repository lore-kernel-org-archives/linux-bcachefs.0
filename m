Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8E702907
	for <linux-bcachefs@vger.kernel.org>; Mon, 27 Jan 2025 04:12:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737951179; cv=none; b=d6V6EUCbp/xikGIbbFI78r6/kUhv9zAfH4oXagAIEyOYwBaSmDrtpF8JOgtC3cHiObmbGJKXDqwl3ZyvJiQcydOA39IdLobkVMDn92Q+LCRRNqmEwFxbskiMcZntVByVSUL2S9fnjF6FxVC+s1utxMLB3ZMoemmqC4YcIaxVym0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737951179; c=relaxed/simple;
	bh=Oh1wdgG+QdN6yzb+hP2e8N0TOAgKkW3Oi6GMBDv+JHE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p/+PjFXSdzp/9SheLQbqissexRrMo7TJZzNymiZu3qxaYkbm/YBmqwK22CGQsuJdWW8CJPzvTcgGu9SPj9jhh9/H0nMuAN5FAKpPCamhYPldvuW3nArAfor1FxnAR5bFWrc2dQRInXUJXgpjFm6IYBxklRD8E8LdoMk47BAEexw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=XW+wmZWG; arc=none smtp.client-ip=91.218.175.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="XW+wmZWG"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1737951176;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UYOR955A+Z4PseNK0oiQ8wXZBVWSuUTb6GfRUe76hdU=;
	b=XW+wmZWG2K2Y1L6NBIOYPHPbVOyzel0spw0sJ15nLNfzeeYxm0o1vWhFqD+EeXnTZOwD12
	jxymGziyBb6Yi+H7vrkeT8SJxQsqaMr2+8/d2oYR+qBYOKwyZlELQ3938nDYhKqkzSstAB
	sump7DHsbMO1lpJzs/4xCkJlkxZgID8=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 07/11] bcachefs: fix bch2_btree_node_flags
Date: Sun, 26 Jan 2025 23:12:33 -0500
Message-ID: <20250127041239.2693707-8-kent.overstreet@linux.dev>
In-Reply-To: <20250127041239.2693707-1-kent.overstreet@linux.dev>
References: <20250127041239.2693707-1-kent.overstreet@linux.dev>
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
 fs/bcachefs/btree_cache.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/bcachefs/btree_cache.c b/fs/bcachefs/btree_cache.c
index 672ca2c1d37d..ca755e8d1a37 100644
--- a/fs/bcachefs/btree_cache.c
+++ b/fs/bcachefs/btree_cache.c
@@ -24,7 +24,10 @@ do {						 \
 } while (0)
 
 const char * const bch2_btree_node_flags[] = {
-#define x(f)	#f,
+	"typebit",
+	"typebit",
+	"typebit",
+#define x(f)	[BTREE_NODE_##f] = #f,
 	BTREE_FLAGS()
 #undef x
 	NULL
-- 
2.45.2


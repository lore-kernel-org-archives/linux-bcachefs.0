Received: from out-177.mta1.migadu.com (out-177.mta1.migadu.com [95.215.58.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 077B31F4706
	for <linux-bcachefs@vger.kernel.org>; Thu,  5 Jun 2025 02:07:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749089234; cv=none; b=G5jyJgbmml3riyHouNW+5dBvykid/74H3dcsQm0JU3pMOCmwUiZHn0cOngO5ilWtewzC+9mPHTT/HyrHmXn/ndVAJncrBaXGlv9KiGoPJM8PUSO7n1pgEM1IBK9z356hg3ftdhpPlpuzlRa78BpvwA+p+aWef6FYfRt+zGO8dq8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749089234; c=relaxed/simple;
	bh=eolgoC1aUmRwxML9vyc1CJHnhATXcRd5QE4p7TSa2nA=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=CfFYMwCuQ2Xp32y05Bp/QsyDGRfKC7rUPiKOCZ3Enc+A2aunAt/qjr6T9xKk9mAiowpLh4rcn1nZSbWS9joPTw3iKk3uaRDKR8RDIiPW30o7Q18aM5oFhgfqw8BBRdJ1/OkPXjjtMionYP9RgiFod8I+cnk/1/kRwG2xoBSYrc8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=MlB7CEjM; arc=none smtp.client-ip=95.215.58.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="MlB7CEjM"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1749089219;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=g8TKW7HqHtcBqqCdcNri6+ScIStdxlz6SwthG5XU7vA=;
	b=MlB7CEjMMu5Yqyiu2FLO1hhBbVu/DDNRQZES60vkOc6fvF4jkLHEKILZMNpqHXYAYnXC8D
	4u5a4FpoeA1LTaHhC1zWDT1fGuPDrZCQnA2/oJQesfS/Wz/5Q12XCcuTnefDKjF9Lq8xD0
	MrRBIIqHMaD941B0Xrsd3b6lWdW/wok=
From: Youling Tang <youling.tang@linux.dev>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: linux-bcachefs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	youling.tang@linux.dev,
	Youling Tang <tangyouling@kylinos.cn>
Subject: [PATCH 1/2] bcachefs: Simplify bch2_bio_map()
Date: Thu,  5 Jun 2025 10:06:38 +0800
Message-Id: <20250605020639.6868-1-youling.tang@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Youling Tang <tangyouling@kylinos.cn>

For the part of directly mapping the kernel virtual address, there is no
need to increase to bio page-by-page. It can be directly replaced by
bio_add_virt_nofail().

For the address part of the vmalloc region, its physical address is
discontinuous and needs to be increased page-by-page to bio. The helper
function bio_add_vmalloc() can be used to simplify the implementation of
bch2_bio_map().

Signed-off-by: Youling Tang <tangyouling@kylinos.cn>
---
NOTE:
The following patch needs to be applied (because the bcachefs.git repository
has not been synchronized to the latest):
commit 850e210d5ad2 ("block: add a bio_add_virt_nofail helper")
commit 8dd16f5e3469 ("block: add a bio_add_vmalloc helpers")

 fs/bcachefs/util.c | 15 ++++-----------
 1 file changed, 4 insertions(+), 11 deletions(-)

diff --git a/fs/bcachefs/util.c b/fs/bcachefs/util.c
index dc3817f545fa..5e5075630bc6 100644
--- a/fs/bcachefs/util.c
+++ b/fs/bcachefs/util.c
@@ -623,17 +623,10 @@ void bch2_pd_controller_debug_to_text(struct printbuf *out, struct bch_pd_contro
 
 void bch2_bio_map(struct bio *bio, void *base, size_t size)
 {
-	while (size) {
-		struct page *page = is_vmalloc_addr(base)
-				? vmalloc_to_page(base)
-				: virt_to_page(base);
-		unsigned offset = offset_in_page(base);
-		unsigned len = min_t(size_t, PAGE_SIZE - offset, size);
-
-		BUG_ON(!bio_add_page(bio, page, len, offset));
-		size -= len;
-		base += len;
-	}
+	if (is_vmalloc_addr(base))
+		bio_add_vmalloc(bio, base, size);
+	else
+		bio_add_virt_nofail(bio, base, size);
 }
 
 int bch2_bio_alloc_pages(struct bio *bio, size_t size, gfp_t gfp_mask)
-- 
2.34.1


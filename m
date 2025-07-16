Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA4B52652B2
	for <linux-bcachefs@vger.kernel.org>; Wed, 16 Jul 2025 16:01:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752681712; cv=none; b=rwfpYjGbp2QKErwPYdNbTkZSvl/GJSdc8XBSuUVfwni+rvuFtLLXsSH9SXPC0nXjb16r5Z1syOY7SG0qrnmUZQU7Qb9K7YOzwnwtTHfTpUL2aUAQbNQqWQu0RKk2UbzrIbyZ/58iw+7rou8IRNDYEbKGzeCtdU8YB1+jrEv5jJc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752681712; c=relaxed/simple;
	bh=iiwTOn2Q5gl9d7MBEIcHT/XtH1hIZ9Grql+Vvt/DoVw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fd2mlE44QERxJF7IKyhkWMuyx7MG5M5gMmnq2dY7OEqI+vD91fWukhLBU3ITkp53spa2/vfA1tU+0ZFIYexxuw4NOlTWyW5SKfwrARtp61wsN/gVcou2Xt9RKX4x1JHt5qmRuuB0YCYM7uIEddOaSlnm09R+p4UGMsI4ImxUb+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=tdu6SDKZ; arc=none smtp.client-ip=95.215.58.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="tdu6SDKZ"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1752681709;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BKQ+3f4Joi/Tm72VDac8z6EmG7uAKHMDEuOeVI4esi0=;
	b=tdu6SDKZfZDnsmVwqxMJe6peKbdV/p0gmEZST1oydquKBILd/GauQhh+32iNxtPJrVmP60
	8vRGRh/lrNJe1WGW4czw0omBJEGEnT7jNIG6Dky0OlsVE6EFbeGgGbkT+/jBNbGKedlwuX
	hmCYObOTsp+W+/wJXUiMNcYOjH2X7eU=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 4/7] bcachefs: Tweak threshold for allocator triggering discards
Date: Wed, 16 Jul 2025 12:01:38 -0400
Message-ID: <20250716160141.1158722-4-kent.overstreet@linux.dev>
In-Reply-To: <20250716160141.1158722-1-kent.overstreet@linux.dev>
References: <20250716160141.1158722-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

The allocator path has a "if we're really low on free buckets, check if
we should issue discards" - tweak this to also trigger discards if more
than 1/128th of the device is in need_discard state.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/alloc_foreground.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/bcachefs/alloc_foreground.c b/fs/bcachefs/alloc_foreground.c
index b375ad610acd..b58525ec7b4d 100644
--- a/fs/bcachefs/alloc_foreground.c
+++ b/fs/bcachefs/alloc_foreground.c
@@ -511,7 +511,8 @@ static struct open_bucket *bch2_bucket_alloc_trans(struct btree_trans *trans,
 	bch2_dev_usage_read_fast(ca, &req->usage);
 	avail = dev_buckets_free(ca, req->usage, req->watermark);
 
-	if (req->usage.buckets[BCH_DATA_need_discard] > avail)
+	if (req->usage.buckets[BCH_DATA_need_discard] >
+	    min(avail, ca->mi.nbuckets >> 7))
 		bch2_dev_do_discards(ca);
 
 	if (req->usage.buckets[BCH_DATA_need_gc_gens] > avail)
-- 
2.50.0


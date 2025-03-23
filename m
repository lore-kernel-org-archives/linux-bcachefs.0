Received: from out-177.mta1.migadu.com (out-177.mta1.migadu.com [95.215.58.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B13C8802
	for <linux-bcachefs@vger.kernel.org>; Sun, 23 Mar 2025 14:14:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742739299; cv=none; b=VYA6atupfhN/FcHSRMdFhxn9YcKHF3IkvbJvNeoR2688rTvYBUD1BKqoUZtBLeG2IU+CU59Hrhxh33kWMwVuhElZJSG4rHlFiGWjAwbiF8PZ+b+oCVvpjanOQRwKXqI30JDi/QSp4S7/L8JKzYbOagYz19XcChhqAeI4UCdUqy0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742739299; c=relaxed/simple;
	bh=x1uzfUinjtG233DVSkk8il5d1LTMQYfCZo7YfJJNyVY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LcQL9Oc3V1B/ydYRIF8Zj1NYY6VavLBhjlooXb5h9xfdh1++h1lZ6BR+iPUBOjfj216s8U9TS/BW52GNRBvWlbbdYuy7vusYSndzP6FfbywU7BVH1aKWJUPmkztcVS1vqMEdTndXvH6OXUh6Iy49oAaSLS50yFvZhYbe51TuLNQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ineaSt8y; arc=none smtp.client-ip=95.215.58.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ineaSt8y"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1742739291;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7GPdnyACOSMG+lW/+ngP08DLCjpk9yVqJdNhMcQ9BT0=;
	b=ineaSt8yZTgT9r3nimNqIR43TWvSIQLyYX93z+x/GJIV/fV8F8xi0jHNiAGWSDvcTW9tB1
	JKCj9X9tIhtplwaBGy/b/cNFtAwJgyFLc+J/Ntlr2PzdZGcXAS7bvrsgXdGP4yjoLWt+I0
	sqyGzzziG1X8gQGX12sDAzG441N3OQE=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 1/8] bcachefs: Kill unnecessary bch2_dev_usage_read()
Date: Sun, 23 Mar 2025 10:14:35 -0400
Message-ID: <20250323141445.566595-2-kent.overstreet@linux.dev>
In-Reply-To: <20250323141445.566595-1-kent.overstreet@linux.dev>
References: <20250323141445.566595-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

bch2_dev_usage_read() is fairly expensive, we should optimize this more.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/alloc_foreground.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/bcachefs/alloc_foreground.c b/fs/bcachefs/alloc_foreground.c
index 95aafc232290..0cac65347a5d 100644
--- a/fs/bcachefs/alloc_foreground.c
+++ b/fs/bcachefs/alloc_foreground.c
@@ -631,7 +631,7 @@ static inline void bch2_dev_stripe_increment_inlined(struct bch_dev *ca,
 			       struct bch_dev_usage *usage)
 {
 	u64 *v = stripe->next_alloc + ca->dev_idx;
-	u64 free_space = dev_buckets_available(ca, BCH_WATERMARK_normal);
+	u64 free_space = __dev_buckets_available(ca, *usage, BCH_WATERMARK_normal);
 	u64 free_space_inv = free_space
 		? div64_u64(1ULL << 48, free_space)
 		: 1ULL << 48;
-- 
2.49.0


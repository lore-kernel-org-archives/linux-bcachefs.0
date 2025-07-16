Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19D2B2652B2
	for <linux-bcachefs@vger.kernel.org>; Wed, 16 Jul 2025 16:01:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752681715; cv=none; b=mgZGUtET9kr0j/MNFbzY2mzo+JhqHOd8rOqr1WCPipXPN+gu+PmFct1ZoEf443bxMjcDUdkjvCS6ureHiMchmdcq0ufZL/4G5dOoxZxvtksFpJOaUoxMnireOcluys3GhzDriqwIOeeQqAhoL8jBm52UcubaJo7xRfFhJlpbzZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752681715; c=relaxed/simple;
	bh=63DFnjFu5gd7l7ndcTsfDpGiqzaJAjI4pe1WOaNXcE0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NKTw78T30HIGLn7wiyQOr+4DYV1CyVpP5N1cUj2LJujqlnwuR0iujaqma7F0WrmCIXigjtoCpcBCkyfGGMMq/fm2eOjBWwP7u8No4RzGpgMXTKVbZl3B2QoITIMfqkJ2XAUOEZCrxnN12xuGkEctQi6eI1VaonDVpk8KF1KSLVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=T0b7GhCS; arc=none smtp.client-ip=95.215.58.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="T0b7GhCS"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1752681711;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cTHNR6st0gzkT5lyf1/juvvm/P+mMSwKhmhHBswWkNk=;
	b=T0b7GhCSO3SMu8qaVk0OadCJG1qM3Jmt7wHxry4h6ZnBJhBBUBinnuNd0TLsPcYws007sp
	tkctm5YPCIEz0tX9ADC2J1SWlnUQXhHic1ZQQCJrjZhsjuiPUQR9r0KWXn4dteQKvC/dGa
	LsQNLFM7bAFHB6EKQXHETxU5w39cOtk=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>,
	syzbot+3168625f36f4a539237e@syzkaller.appspotmail.com
Subject: [PATCH 6/7] bcachefs: Fix reference to invalid bucket in copygc
Date: Wed, 16 Jul 2025 12:01:40 -0400
Message-ID: <20250716160141.1158722-6-kent.overstreet@linux.dev>
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

Use bch2_dev_bucket_tryget() instead of bch2_dev_tryget() before
checking the bucket bitmap.

Reported-by: syzbot+3168625f36f4a539237e@syzkaller.appspotmail.com
Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/movinggc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/bcachefs/movinggc.c b/fs/bcachefs/movinggc.c
index 27e68d470ad0..5e6de91a8763 100644
--- a/fs/bcachefs/movinggc.c
+++ b/fs/bcachefs/movinggc.c
@@ -71,7 +71,7 @@ static int bch2_bucket_is_movable(struct btree_trans *trans,
 	if (ret)
 		return ret;
 
-	struct bch_dev *ca = bch2_dev_tryget(c, k.k->p.inode);
+	struct bch_dev *ca = bch2_dev_bucket_tryget(c, k.k->p);
 	if (!ca)
 		goto out;
 
-- 
2.50.0


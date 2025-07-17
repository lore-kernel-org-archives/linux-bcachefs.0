Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73B96224AEF
	for <linux-bcachefs@vger.kernel.org>; Thu, 17 Jul 2025 20:29:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752784185; cv=none; b=nKZe8rZx/BQP4omHUExhWjSRc2zaDAi3q4dc4Zyb8S3fVUUo5zClFj2tS5Wg7475l/j48//bkeWQiwNl+2q2KPigt8GzxVcA/tzyXz8OkutUp79doBe4VlSJjIvXFngCy+4Sl1bBAfLQHBAPqVhJsiFP7k0qu+Hbc8/62P1m/Os=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752784185; c=relaxed/simple;
	bh=TPJEQcOUOgwjChkyZk4K+ww7t9GgcdjNuDhxQr233BQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=QW6ovwznZkQSV0Zgdqy7y9e+KxbXcstLVsb7hLIjppC5mu3abPKAO+Paie12H9BHNnONn3/QzfLETBrRUAA9GAIfKV0XYsveU/KiDkraH7OPMJQvnl4X7YQBOiazABVoyCwOpTlRPenfdylHS1UQA3fW6tca86527KMdvxlFR90=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=lmvfGX7G; arc=none smtp.client-ip=91.218.175.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="lmvfGX7G"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1752784178;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=/EOC0uhKFcSAO3Ddnt4/AUBmfkJTi7noERbte3hA3qk=;
	b=lmvfGX7GrFisKliE/4zDPzzQB8kY0IY5Eu6neU6oUinuOZWsvApIXcxAROEJLfowLgGpdZ
	ThT/tOBTNFiIAe1SKlIPAmA63vft044WvSx3H5yru9dnQKcgax6agUyngJmZS0OAtYJW08
	7Q7Bvi3SZDjCCHI57kYYlZhmmlxcEGA=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>,
	syzbot+0ea2c41a649240197795@syzkaller.appspotmail.com
Subject: [PATCH] bcachefs: Ensure wo don't return with closure on waitlist
Date: Thu, 17 Jul 2025 16:29:31 -0400
Message-ID: <20250717202931.2161700-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

things will break wildly if we leave a stack allocated closure on a
waitlist

Reported-by: syzbot+0ea2c41a649240197795@syzkaller.appspotmail.com
Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/ec.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/bcachefs/ec.c b/fs/bcachefs/ec.c
index 62dda821247e..8a8c94bd2580 100644
--- a/fs/bcachefs/ec.c
+++ b/fs/bcachefs/ec.c
@@ -2060,6 +2060,8 @@ struct ec_stripe_head *bch2_ec_stripe_head_get(struct btree_trans *trans,
 	BUG_ON(trans->restarted);
 	return h;
 err:
+	if (waiting)
+		closure_wake_up(&c->freelist_wait);
 	bch2_ec_stripe_head_put(c, h);
 	return ERR_PTR(ret);
 }
-- 
2.50.0


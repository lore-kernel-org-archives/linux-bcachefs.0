Received: from out30-124.freemail.mail.aliyun.com (out30-124.freemail.mail.aliyun.com [115.124.30.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2B10383A1;
	Tue, 10 Sep 2024 00:49:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725929352; cv=none; b=bsXdmYJmweovLkSOb2jDZ5n78tFeonhoEXVCGuTkqtVxX07RT89JiQExr3UZ+8fqNp6Gut30Lk6mC2/O9wFFr7/fs0ruxf8w9YoxqL4HxUqUOOnV4Ribos6czlJgL8Fdj/HTNX290/J28VswCL5mNnRMQ2YDO3vINwPgFBL1ho8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725929352; c=relaxed/simple;
	bh=0Pq34FGLz5PDpqHXwIu6shwPkRhwzZRLFooS7lU80j0=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=o7bf1dBpALlttQkwWxD4SPADvF6AI0t6t9VGYAhmispQ8LgesMIXsR+r0qcE0v4tsiv8HJjLM+2sN+myCNprXJHe5mbGWTXheXEz9gqg2YVjeiFU/vkETFe+mtkeXp36Oz2oIXQrKtQAQpH3EH3PU6uy6kDhP8cREbdju8g4ZMs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=M5XSzYAU; arc=none smtp.client-ip=115.124.30.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="M5XSzYAU"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1725929346; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=ngTG0x9JjXf9xOSVJ5quw1HFve2xFpS9Tn58NkPkKns=;
	b=M5XSzYAU4Ju7Qni+xmLil0PLgPmKXzY2SVa7mILINVZ/oOnPTVePs9BizzJl2bBkQlIiaIgHq3RMkY1ZISjHR5hnTooFtakc54Va/cJ7eSQK9EzDn2fZ3aTLbDH71JOiyyyo9KEthij1b7ltOd5lw5hISZdccUC0y6+PdKYYaBw=
Received: from localhost(mailfrom:yang.lee@linux.alibaba.com fp:SMTPD_---0WEhwU3Z_1725929345)
          by smtp.aliyun-inc.com;
          Tue, 10 Sep 2024 08:49:05 +0800
From: Yang Li <yang.lee@linux.alibaba.com>
To: kent.overstreet@linux.dev
Cc: linux-bcachefs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yang Li <yang.lee@linux.alibaba.com>,
	Abaci Robot <abaci@linux.alibaba.com>
Subject: [PATCH -next] bcachefs: Remove unneeded semicolon
Date: Tue, 10 Sep 2024 08:49:03 +0800
Message-Id: <20240910004903.26693-1-yang.lee@linux.alibaba.com>
X-Mailer: git-send-email 2.32.0.3.g01195cf9f
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

./fs/bcachefs/btree_cache.c:502:13-14: Unneeded semicolon

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Closes: https://bugzilla.openanolis.cn/show_bug.cgi?id=10821
Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
---
 fs/bcachefs/btree_cache.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/bcachefs/btree_cache.c b/fs/bcachefs/btree_cache.c
index 7b951b273306..bfd4cec70744 100644
--- a/fs/bcachefs/btree_cache.c
+++ b/fs/bcachefs/btree_cache.c
@@ -499,7 +499,7 @@ static unsigned long bch2_btree_cache_scan(struct shrinker *shrink,
 		if (btree_node_accessed(b)) {
 			clear_btree_node_accessed(b);
 			bc->not_freed[BCH_BTREE_CACHE_NOT_FREED_access_bit]++;
-			--touched;;
+			--touched;
 		} else if (!btree_node_reclaim(c, b, true)) {
 			bch2_btree_node_hash_remove(bc, b);
 
-- 
2.32.0.3.g01195cf9f


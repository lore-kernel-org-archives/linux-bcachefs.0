Received: from njjs-sys-mailin01.njjs.baidu.com (mx310.baidu.com [180.101.52.44])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D746115FD13
	for <linux-bcachefs@vger.kernel.org>; Fri,  7 Feb 2025 06:50:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.101.52.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738911063; cv=none; b=R2xmdEipQeN1zPsyT1CvTTTGYwzGMnS/nKkNVIFaAq1pVOO9ifm8X4s9g5K/OY2DnOMQlfqu/cLgxu6uETZsXEv5Al901G7OaT8Jead0Sv2caZk3BzfwFo/qLiwudnZ0yZ1X2uPKjR/QxuLxe0WKb5U707EF8fLifbINH+Ub33Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738911063; c=relaxed/simple;
	bh=QUI8aa9QsS4j+0agCBR0eTA8d80PqJO2MNf/Q2uyWmo=;
	h=From:To:Cc:Subject:Date:Message-Id; b=ZIxCcP9+D+dlWhFN9K7njrgHGuqumOWi343mbxarH64QG+QYUs1fq5kQ/UL8WCtyQR8uV1yYcFg606Ub7FjReXVyhztiXI3qEwnFHvJqMLeBsZcDuGiv8gXvC9EyU7hs2GGAvj7r70iV7mHs9R2wr1OkXYECBUMLhoov9LlDByg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=baidu.com; spf=pass smtp.mailfrom=baidu.com; arc=none smtp.client-ip=180.101.52.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=baidu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=baidu.com
Received: from localhost (bjhw-sys-rpm015653cc5.bjhw.baidu.com [10.227.53.39])
	by njjs-sys-mailin01.njjs.baidu.com (Postfix) with ESMTP id 580C77F00049;
	Fri,  7 Feb 2025 14:41:04 +0800 (CST)
From: Li RongQing <lirongqing@baidu.com>
To: linux-bcachefs@vger.kernel.org
Cc: Li RongQing <lirongqing@baidu.com>
Subject: [PATCH] bcachefs: use kvfree_rcu to simplify the code
Date: Fri,  7 Feb 2025 14:41:02 +0800
Message-Id: <20250207064102.45568-1-lirongqing@baidu.com>
X-Mailer: git-send-email 2.9.4
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>

The callback function of call_rcu() just calls kvfree(). So, use
kvfree_rcu() instead of call_rcu() + callback function.

Signed-off-by: Li RongQing <lirongqing@baidu.com>
---
 fs/bcachefs/buckets.c | 10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

diff --git a/fs/bcachefs/buckets.c b/fs/bcachefs/buckets.c
index 345b117a4..6d236fa 100644
--- a/fs/bcachefs/buckets.c
+++ b/fs/bcachefs/buckets.c
@@ -1270,14 +1270,6 @@ int bch2_buckets_nouse_alloc(struct bch_fs *c)
 	return 0;
 }
 
-static void bucket_gens_free_rcu(struct rcu_head *rcu)
-{
-	struct bucket_gens *buckets =
-		container_of(rcu, struct bucket_gens, rcu);
-
-	kvfree(buckets);
-}
-
 int bch2_dev_buckets_resize(struct bch_fs *c, struct bch_dev *ca, u64 nbuckets)
 {
 	struct bucket_gens *bucket_gens = NULL, *old_bucket_gens = NULL;
@@ -1322,7 +1314,7 @@ int bch2_dev_buckets_resize(struct bch_fs *c, struct bch_dev *ca, u64 nbuckets)
 	ret = 0;
 err:
 	if (bucket_gens)
-		call_rcu(&bucket_gens->rcu, bucket_gens_free_rcu);
+		kvfree_rcu(bucket_gens, rcu);
 
 	return ret;
 }
-- 
2.9.4


Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8603F9EC
	for <linux-bcachefs@vger.kernel.org>; Tue, 20 Aug 2024 01:21:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724116913; cv=none; b=G8heL1QxgCcoFPzLmLiPqGTyb+0h1o+iZ83Mty0K8LsnUEVAdex07dtVu5PTzScVEypDtK7xm4oooghKNmolTDvKDicmAJwjkodcmRXE2VQi2LuPeI79a/fYdOi8RGBJTl9hre+S46ccWhbbTIPU2rJqoMB9M0loZJi7pljp9uE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724116913; c=relaxed/simple;
	bh=WNqVkg1ZYdh1qyqG+fIPtQB5iWhhluG+NxMCurME6PE=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=lWoBeDu5yjS0W+dyTF3lF+pwZ2BVUuJMHlByqCchERXh1WI4SK+g6vEs1ctj+HeTRMocsYkvOtZCe9mTSfBduLXzavBhKYGbwjisuIHVCrArxYd6nAzWbXFwToJbaZRuNc9Fw+4SU1zeFKO/CyxBbfCU/9mPEq+yZj5ObMiXVKQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.174])
	by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4Wns4z15vGzQq9C;
	Tue, 20 Aug 2024 09:17:07 +0800 (CST)
Received: from kwepemd500012.china.huawei.com (unknown [7.221.188.25])
	by mail.maildlp.com (Postfix) with ESMTPS id B00DF140135;
	Tue, 20 Aug 2024 09:21:47 +0800 (CST)
Received: from huawei.com (10.90.53.73) by kwepemd500012.china.huawei.com
 (7.221.188.25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1258.34; Tue, 20 Aug
 2024 09:21:47 +0800
From: Li Zetao <lizetao1@huawei.com>
To: <kent.overstreet@linux.dev>
CC: <lizetao1@huawei.com>, <linux-bcachefs@vger.kernel.org>
Subject: [PATCH -next] bcachefs: fix opportunity for min/max warnings
Date: Tue, 20 Aug 2024 09:29:14 +0800
Message-ID: <20240820012914.4121703-1-lizetao1@huawei.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 kwepemd500012.china.huawei.com (7.221.188.25)

There are some warnings reported by cocci:

  fs/bcachefs/journal.c:764:20-21: WARNING opportunity for min()
  fs/bcachefs/fsck.c:2050:12-13: WARNING opportunity for min()
  fs/bcachefs/fsck.c:1549:12-13: WARNING opportunity for min()
  fs/bcachefs/buckets.h:180:10-11: WARNING opportunity for max()

Use min() or max() to simplify the code.

Signed-off-by: Li Zetao <lizetao1@huawei.com>
---
 fs/bcachefs/buckets.h | 4 +---
 fs/bcachefs/fsck.c    | 4 ++--
 fs/bcachefs/journal.c | 2 +-
 3 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/fs/bcachefs/buckets.h b/fs/bcachefs/buckets.h
index edbdffd508fc..6974a80f5487 100644
--- a/fs/bcachefs/buckets.h
+++ b/fs/bcachefs/buckets.h
@@ -175,9 +175,7 @@ static inline int gen_cmp(u8 a, u8 b)
 
 static inline int gen_after(u8 a, u8 b)
 {
-	int r = gen_cmp(a, b);
-
-	return r > 0 ? r : 0;
+	return max(gen_cmp(a, b), 0);
 }
 
 static inline int dev_ptr_stale_rcu(struct bch_dev *ca, const struct bch_extent_ptr *ptr)
diff --git a/fs/bcachefs/fsck.c b/fs/bcachefs/fsck.c
index 9138944c5ae6..d290b4f5605a 100644
--- a/fs/bcachefs/fsck.c
+++ b/fs/bcachefs/fsck.c
@@ -1546,7 +1546,7 @@ static int check_extent(struct btree_trans *trans, struct btree_iter *iter,
 
 	ret = bch2_check_key_has_snapshot(trans, iter, k);
 	if (ret) {
-		ret = ret < 0 ? ret : 0;
+		ret = min(ret, 0);
 		goto out;
 	}
 
@@ -2047,7 +2047,7 @@ static int check_dirent(struct btree_trans *trans, struct btree_iter *iter,
 
 	ret = bch2_check_key_has_snapshot(trans, iter, k);
 	if (ret) {
-		ret = ret < 0 ? ret : 0;
+		ret = min(ret, 0);
 		goto out;
 	}
 
diff --git a/fs/bcachefs/journal.c b/fs/bcachefs/journal.c
index 649e3a01608a..959570a367f6 100644
--- a/fs/bcachefs/journal.c
+++ b/fs/bcachefs/journal.c
@@ -761,7 +761,7 @@ int bch2_journal_flush_seq(struct journal *j, u64 seq)
 	if (!ret)
 		bch2_time_stats_update(j->flush_seq_time, start_time);
 
-	return ret ?: ret2 < 0 ? ret2 : 0;
+	return ret ?: min(ret2, 0);
 }
 
 /*
-- 
2.34.1


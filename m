Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2097C8BE2
	for <linux-bcachefs@vger.kernel.org>; Fri, 19 Apr 2024 07:48:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.255
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713512935; cv=none; b=fcWXa4tDOiut2k+Yxl6024a0vb6URn7qNn2i3v8rSKRhbVryQsoGiqBwXWsIw5ki+k1Bo17dKy3vJ7dRZ6v4z4l2+GY5w+1cfrxt2AXU29YB605/1iGeoIZ1t0CdTqYdgl0Ue5zJ+TyPSLTVfFhNXyB8wkGzPUR8nj3zLjHQIHM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713512935; c=relaxed/simple;
	bh=tgsTqjtUDfWcIgBUNjhYDXQZIxhXrPpXWB1tfQ5M21w=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=T5BdmfehIQkQ3jUIOKtwrIBJ7aWyqn/m/gFxLIkZOHAXMv3COxreXyqCXLxddaYD6vWdTjCJysm/To+8h3zhedinjgbwdSN9SUBPpvEi9Uj1Mpbam9yfVKg93/i13AnbCTzjJlfsf5ONhbqo2GLYmhfGFkRi735hPeLblKgJvDA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.255
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.194])
	by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4VLRXL6PW6z1N8Nk;
	Fri, 19 Apr 2024 15:45:54 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (unknown [7.185.36.66])
	by mail.maildlp.com (Postfix) with ESMTPS id B873D140124;
	Fri, 19 Apr 2024 15:48:49 +0800 (CST)
Received: from huawei.com (10.90.53.73) by dggpeml500022.china.huawei.com
 (7.185.36.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.35; Fri, 19 Apr
 2024 15:48:49 +0800
From: Hongbo Li <lihongbo22@huawei.com>
To: <kent.overstreet@linux.dev>, <bfoster@redhat.com>
CC: <linux-bcachefs@vger.kernel.org>, <lihongbo22@huawei.com>
Subject: [PATCH 1/2] bcachefs: eliminate the uninitialized compilation warning in bch2_reconstruct_snapshots
Date: Fri, 19 Apr 2024 15:48:50 +0800
Message-ID: <20240419074851.1583392-2-lihongbo22@huawei.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240419074851.1583392-1-lihongbo22@huawei.com>
References: <20240419074851.1583392-1-lihongbo22@huawei.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpeml500022.china.huawei.com (7.185.36.66)

[BUG]
When compiling the bcachefs-tools, the following compilation warning
is reported:
    libbcachefs/snapshot.c: In function ‘bch2_reconstruct_snapshots’:
    libbcachefs/snapshot.c:915:19: warning: ‘tree_id’ may be used uninitialized in this function [-Wmaybe-uninitialized]
      915 |  snapshot->v.tree = cpu_to_le32(tree_id);
    libbcachefs/snapshot.c:903:6: note: ‘tree_id’ was declared here
      903 |  u32 tree_id;
       |      ^~~~~~~

[CAUSE]
This is a false alert, because @tree_id is changed in
bch2_snapshot_tree_create after it returns 0. And if this function
returns other value, @tree_id wouldn't be used. Thus there should
be nothing wrong in logical.

[FIX]
Although the report itself is a false alert, we can still make it more
explicit by:
  - check the input parameter 'u32 *tree_id' with WARN_ON_ONCE
  - initialize @tree_id to U32_MAX
  - add extra WARN_ON_ONCE to make sure @tree_id is updated

Fixes: a292be3b68f3 ("bcachefs: Reconstruct missing snapshot nodes")
Signed-off-by: Hongbo Li <lihongbo22@huawei.com>
---
 fs/bcachefs/snapshot.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/bcachefs/snapshot.c b/fs/bcachefs/snapshot.c
index 0b26dee17a5a..cad3408903b2 100644
--- a/fs/bcachefs/snapshot.c
+++ b/fs/bcachefs/snapshot.c
@@ -78,6 +78,7 @@ __bch2_snapshot_tree_create(struct btree_trans *trans)
 static int bch2_snapshot_tree_create(struct btree_trans *trans,
 				u32 root_id, u32 subvol_id, u32 *tree_id)
 {
+	WARN_ON_ONCE(!tree_id);
 	struct bkey_i_snapshot_tree *n_tree =
 		__bch2_snapshot_tree_create(trans);
 
@@ -900,7 +901,7 @@ static int check_snapshot_exists(struct btree_trans *trans, u32 id)
 	if (bch2_snapshot_equiv(c, id))
 		return 0;
 
-	u32 tree_id;
+	u32 tree_id = U32_MAX;
 	int ret = bch2_snapshot_tree_create(trans, id, 0, &tree_id);
 	if (ret)
 		return ret;
@@ -910,6 +911,8 @@ static int check_snapshot_exists(struct btree_trans *trans, u32 id)
 	if (ret)
 		return ret;
 
+	/* bch2_snapshot_tree_create returned 0, @tree_id must be updated. */
+	WARN_ON_ONCE(tree_id == U32_MAX);
 	bkey_snapshot_init(&snapshot->k_i);
 	snapshot->k.p		= POS(0, id);
 	snapshot->v.tree	= cpu_to_le32(tree_id);
-- 
2.34.1


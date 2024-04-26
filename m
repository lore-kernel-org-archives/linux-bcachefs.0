Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11F942F36
	for <linux-bcachefs@vger.kernel.org>; Fri, 26 Apr 2024 03:21:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714101689; cv=none; b=dGjil3LRGYq4aGmx26L9NcjzTZl7gTx75/KGTyZNZ14/ZAYkACQX/T0F4MMcesdCPDmywl5sBbuv7LHi8Am6M07oU6iooZG4l8v0Z6jJreOYsYXSuWDVnchfm3yO+hx3/ltkxn9x4sURASJaQgffEjeOBzUYcs8E5teZrATcrOM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714101689; c=relaxed/simple;
	bh=Th7wfQlOJD3VAz87yDG+wvnooy2Nz0wg3MZqiF4tzYY=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=I2lsOpJg3GTCInhxz/cFwH5OkMYlr3MRLoRn9sLcZWFyKXadc/qHJJdLwOXC8Y2wXdqsz7KfvjIIe2y5O9AUhRRj6o3N8mG/cIgCql5rTKlv0RBrKtSr7b+X8hEVMxOowTQx9nyl91hYr1Y8oKaI2cfw3xGIt8sWEWSPUp8yq+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.252])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4VQdJd6F09zcc4M;
	Fri, 26 Apr 2024 11:20:17 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (unknown [7.185.36.66])
	by mail.maildlp.com (Postfix) with ESMTPS id 40E8A180080;
	Fri, 26 Apr 2024 11:21:23 +0800 (CST)
Received: from huawei.com (10.90.53.73) by dggpeml500022.china.huawei.com
 (7.185.36.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.35; Fri, 26 Apr
 2024 11:21:23 +0800
From: Hongbo Li <lihongbo22@huawei.com>
To: <kent.overstreet@linux.dev>, <bfoster@redhat.com>
CC: <linux-bcachefs@vger.kernel.org>, <lihongbo22@huawei.com>
Subject: [PATCH v2 1/2] bcachefs: eliminate the uninitialized compilation warning in bch2_reconstruct_snapshots
Date: Fri, 26 Apr 2024 11:21:35 +0800
Message-ID: <20240426032136.2551471-2-lihongbo22@huawei.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240426032136.2551471-1-lihongbo22@huawei.com>
References: <20240426032136.2551471-1-lihongbo22@huawei.com>
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

When compiling the bcachefs-tools, the following compilation warning
is reported:
    libbcachefs/snapshot.c: In function ‘bch2_reconstruct_snapshots’:
    libbcachefs/snapshot.c:915:19: warning: ‘tree_id’ may be used uninitialized in this function [-Wmaybe-uninitialized]
      915 |  snapshot->v.tree = cpu_to_le32(tree_id);
    libbcachefs/snapshot.c:903:6: note: ‘tree_id’ was declared here
      903 |  u32 tree_id;
       |      ^~~~~~~

This is a false alert, because @tree_id is changed in
bch2_snapshot_tree_create after it returns 0. And if this function
returns other value, @tree_id wouldn't be used. Thus there should
be nothing wrong in logical.

Although the report itself is a false alert, we can still make it more
explicit by setting the initial value of @tree_id to 0 (an invalid
tree ID).

Fixes: a292be3b68f3 ("bcachefs: Reconstruct missing snapshot nodes")
Signed-off-by: Hongbo Li <lihongbo22@huawei.com>
---
v2:
  - Revise the code based on Kent's reviews.

v1: https://lore.kernel.org/all/20240419074851.1583392-2-lihongbo22@huawei.com/T/#u
---
---
 fs/bcachefs/snapshot.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/bcachefs/snapshot.c b/fs/bcachefs/snapshot.c
index 2368218070d4..3aa4686cc71f 100644
--- a/fs/bcachefs/snapshot.c
+++ b/fs/bcachefs/snapshot.c
@@ -900,7 +900,8 @@ static int check_snapshot_exists(struct btree_trans *trans, u32 id)
 	if (bch2_snapshot_equiv(c, id))
 		return 0;
 
-	u32 tree_id;
+	/* 0 is an invalid tree ID */
+	u32 tree_id = 0;
 	int ret = bch2_snapshot_tree_create(trans, id, 0, &tree_id);
 	if (ret)
 		return ret;
-- 
2.34.1


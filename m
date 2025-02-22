Received: from szxga07-in.huawei.com (szxga07-in.huawei.com [45.249.212.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B7812A1CF
	for <linux-bcachefs@vger.kernel.org>; Sat, 22 Feb 2025 01:24:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.35
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740187496; cv=none; b=dg6uaaDwKG/52Zy5JID0AwBZ1HeQJEkloDQWBhqpysh3nocYD8pI4np5gK7CzmlGsuCxn3JCQ6wB7M/4b7gGAY5/AHNozRLyaFv8VpO4I7ySUFYiq4sr1kIzBysD4kWKZ9dNIrXWrExk1Qgqmy3cY0sizxANOofrUexcmJpiy3I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740187496; c=relaxed/simple;
	bh=JosQEqK2+0NAunwvLGwNtdFtnuMkXzr7ClxLPLta8Ms=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=TDKHg+bPBsMXeQ/bp62r2WgKUd/5TMpQIXkQYMPlM10AKOBhl/0l+yvLGGyQqLYHQuHqRi3xtExmqnCvu1rlPLcI4EYjSQ3NnER8lGc83WZxfvzSMEkF0mkAvhG/L/0n1vAAQkrSTt3JS9HRPS0tYPHO78tUm3XxKxBJMi1USfo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.234])
	by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4Z08ML0l4szJ1F5;
	Sat, 22 Feb 2025 09:20:46 +0800 (CST)
Received: from kwepemo500009.china.huawei.com (unknown [7.202.194.199])
	by mail.maildlp.com (Postfix) with ESMTPS id C56C2140155;
	Sat, 22 Feb 2025 09:24:44 +0800 (CST)
Received: from huawei.com (10.90.53.73) by kwepemo500009.china.huawei.com
 (7.202.194.199) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Sat, 22 Feb
 2025 09:24:44 +0800
From: Hongbo Li <lihongbo22@huawei.com>
To: <kent.overstreet@linux.dev>
CC: <linux-bcachefs@vger.kernel.org>, <lihongbo22@huawei.com>
Subject: [PATCH] bcachefs: fix directory i_size checking for the last entry
Date: Sat, 22 Feb 2025 09:24:12 +0800
Message-ID: <20250222012412.460211-1-lihongbo22@huawei.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 kwepemo500009.china.huawei.com (7.202.194.199)

Checking the i_size of the last directory entry when fsck.

Fixes: b9ddb3e1a8aa ("bcachefs: Fix fsck directory i_size checking")
Signed-off-by: Hongbo Li <lihongbo22@huawei.com>
---
 fs/bcachefs/fsck.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/bcachefs/fsck.c b/fs/bcachefs/fsck.c
index 9bf316e7b845..a9480bb308b2 100644
--- a/fs/bcachefs/fsck.c
+++ b/fs/bcachefs/fsck.c
@@ -2470,7 +2470,8 @@ int bch2_check_dirents(struct bch_fs *c)
 				POS(BCACHEFS_ROOT_INO, 0),
 				BTREE_ITER_prefetch|BTREE_ITER_all_snapshots, k,
 			check_dirent(trans, &iter, k, &hash_info, &dir, &target, &s)) ?:
-		check_subdir_count_notnested(trans, &dir));
+		check_subdir_count_notnested(trans, &dir) ?:
+		check_dir_i_size_notnested(trans, &dir));
 
 	snapshots_seen_exit(&s);
 	inode_walker_exit(&dir);
-- 
2.33.0


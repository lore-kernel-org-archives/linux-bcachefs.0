Received: from szxga07-in.huawei.com (szxga07-in.huawei.com [45.249.212.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25141D531
	for <linux-bcachefs@vger.kernel.org>; Tue, 24 Sep 2024 01:31:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.35
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727141509; cv=none; b=sIbQNwNp7gR6PxUL9oaTmEsdQukGCq3Elf8Z3DJLGZjjEJ1OgMheioj371PzbS+jkgaZB1Z+xMEGgtlAyW52ax1oFtsaEnMjFNQFZbmr+9i7RFRn6uPuXyA8/xK8Ds/Wi7HgWOdrA1misQ+TarHA9YHo0avw9jaaf/8Bk7S1zKs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727141509; c=relaxed/simple;
	bh=Jc6v1NtD4IAL8XMxc/nvXFYpGvu33J3RgBEoJoBN0MY=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=aKn/G+2RM9l9omM3Kt+L4apE/U6ybwsdSxIUbHYXHuH9I0ePRkDlX1yVK8kLclJch7xb3uA/Q/yk4EGwEHZOwVCtSWgqQG6rF1AB91Wzbp6zNvgovnX3Re19YX3GUrnEE6YoGgnCEkw7aJwQD1DusbOFQ3R7bvqugKI5J/UOxuk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.162.112])
	by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4XCMkq3yGfz1SBgY;
	Tue, 24 Sep 2024 09:30:59 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (unknown [7.185.36.66])
	by mail.maildlp.com (Postfix) with ESMTPS id B2318140360;
	Tue, 24 Sep 2024 09:31:45 +0800 (CST)
Received: from huawei.com (10.90.53.73) by dggpeml500022.china.huawei.com
 (7.185.36.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.39; Tue, 24 Sep
 2024 09:31:45 +0800
From: Hongbo Li <lihongbo22@huawei.com>
To: <kent.overstreet@linux.dev>
CC: <linux-bcachefs@vger.kernel.org>, <lihongbo22@huawei.com>,
	<chris.zjh@huawei.com>
Subject: [PATCH] bcachefs: fix the memory leak in exception case
Date: Tue, 24 Sep 2024 09:41:46 +0800
Message-ID: <20240924014146.701917-1-lihongbo22@huawei.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpeml500022.china.huawei.com (7.185.36.66)

The pointer clean points the memory allocated by kmemdup, when the
return value of bch2_sb_clean_validate_late is not zero. The memory
pointed by clean is leaked. So we should free it in this case.

Fixes: a37ad1a3aba9 ("bcachefs: sb-clean.c")
Signed-off-by: Hongbo Li <lihongbo22@huawei.com>
---
 fs/bcachefs/sb-clean.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/bcachefs/sb-clean.c b/fs/bcachefs/sb-clean.c
index 025848a9c4c0..005275281804 100644
--- a/fs/bcachefs/sb-clean.c
+++ b/fs/bcachefs/sb-clean.c
@@ -167,6 +167,7 @@ struct bch_sb_field_clean *bch2_read_superblock_clean(struct bch_fs *c)
 
 	ret = bch2_sb_clean_validate_late(c, clean, READ);
 	if (ret) {
+		kfree(clean);
 		mutex_unlock(&c->sb_lock);
 		return ERR_PTR(ret);
 	}
-- 
2.34.1


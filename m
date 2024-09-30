Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CC2F188007
	for <linux-bcachefs@vger.kernel.org>; Mon, 30 Sep 2024 09:29:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727688575; cv=none; b=s8ruwFbqMAaXtWO+6tzblZQHyfHYR/NSv6FW36Z73kVcGDIzcv0Twq75FAaM4Bxv7/RQvhZwkJidsnaoOPbVFl2CzJxuft9kDjRzz6bVgxglGT6l9ulSG2KktG5wFDxB17rn/rI6YpfjJIn+gsL+502m+mkM7D2Cg7kH4NjYJzA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727688575; c=relaxed/simple;
	bh=EvIV5+RotUQU61talGXeF02j2UjmyU0xDEbfYfs32eA=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=XVf57qeyjJxpBgOtZizajNfZJ0+BSlrD+Wjg/3vGO2pZj8GvePDon0lJjNQEijJ+0wy0yJ2DqYvea5E1y61XqmqP3tSvQieUctUemvzoQd+f2Lex34rjf42I694Ba6iCkI/anRZgS6F/pjhozx0IJnlIH678anUi0fpzSQt06gE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.174])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4XHG1l2Wy6zpWQT;
	Mon, 30 Sep 2024 17:27:23 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (unknown [7.185.36.66])
	by mail.maildlp.com (Postfix) with ESMTPS id F3010140393;
	Mon, 30 Sep 2024 17:29:24 +0800 (CST)
Received: from huawei.com (10.90.53.73) by dggpeml500022.china.huawei.com
 (7.185.36.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.39; Mon, 30 Sep
 2024 17:29:24 +0800
From: Hongbo Li <lihongbo22@huawei.com>
To: <kent.overstreet@linux.dev>
CC: <linux-bcachefs@vger.kernel.org>, <lihongbo22@huawei.com>,
	<chris.zjh@huawei.com>
Subject: [PATCH] bcachefs-tools: remove double start for fs when migrate
Date: Mon, 30 Sep 2024 17:39:57 +0800
Message-ID: <20240930093957.2580253-1-lihongbo22@huawei.com>
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

bcachefs migrate will start fs twice, it will triggle BUG_ON
condition and other troubles. Actually, we only need to start
fs once.

Fixes: 38b8d01c4cf8 ("Update bcachefs sources to 481b5f343248 bcachefs: Better error messages for missing inodes in fsck")
Closes: https://github.com/koverstreet/bcachefs/issues/730
Signed-off-by: Hongbo Li <lihongbo22@huawei.com>
---
 c_src/cmd_migrate.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/c_src/cmd_migrate.c b/c_src/cmd_migrate.c
index a5b7786d..f8b4acc8 100644
--- a/c_src/cmd_migrate.c
+++ b/c_src/cmd_migrate.c
@@ -268,10 +268,6 @@ static int migrate_fs(const char		*fs_path,
 	if (ret)
 		die("Error allocating buckets_nouse: %s", bch2_err_str(ret));
 
-	ret = bch2_fs_start(c);
-	if (IS_ERR(c))
-		die("Error starting new filesystem: %s", bch2_err_str(ret));
-
 	mark_unreserved_space(c, extents);
 
 	ret = bch2_fs_start(c);
-- 
2.34.1


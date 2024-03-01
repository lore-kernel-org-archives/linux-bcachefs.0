Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E91B2BAE7
	for <linux-bcachefs@vger.kernel.org>; Fri,  1 Mar 2024 03:18:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.255
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709263113; cv=none; b=hKE7K1TDndtUVCFp3scHsCpGiFTc5wYmJRIhVir/qIKui4gVtxUfsWFH66neHPpBjQHZe3R3Qdju2wfcd8Iuc1N0aqRIdqj96KSag0JTUDaHj5zRz+YP4xXn1TiA8/jN0nCmrNwsDp+Xt43Tn+Xu/J4yQsOmGhHZHjSR0scuxqw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709263113; c=relaxed/simple;
	bh=syeyAnBKH71YnE9Gxz6XsmSt6TX5pWOE1uEhMY/HuxA=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=bOmFIaYXcUd5clyY2xu17NMVKq7K92OZ6k3P1sc3WwA+9VU/L/NetcqsKdlLQFagGLkk3HR5u6y3B3y+olVuPr038pXugJ3h3OI5LGTdFb3AqOkIS5S7C4hvszgy7OdgfOKROrmR6gL4rO6s06AFlSp3bDk87frhhys038EXPbk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.255
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.194])
	by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4TmCt83Ln3z1Q9CG;
	Fri,  1 Mar 2024 11:16:32 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (unknown [7.185.36.66])
	by mail.maildlp.com (Postfix) with ESMTPS id 3D7AD140429;
	Fri,  1 Mar 2024 11:18:23 +0800 (CST)
Received: from huawei.com (10.90.53.73) by dggpeml500022.china.huawei.com
 (7.185.36.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.35; Fri, 1 Mar
 2024 11:18:23 +0800
From: Hongbo Li <lihongbo22@huawei.com>
To: <kent.overstreet@linux.dev>, <bfoster@redhat.com>
CC: <linux-bcachefs@vger.kernel.org>, <ruanjinjie@huawei.com>,
	<lihongbo22@huawei.com>
Subject: [PATCH] bcachefs: avoid returning private error code in bch2_xattr_bcachefs_set
Date: Fri, 1 Mar 2024 11:17:45 +0800
Message-ID: <20240301031745.1912157-1-lihongbo22@huawei.com>
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
 dggpeml500022.china.huawei.com (7.185.36.66)

Avoid the private error code return to caller. The error code
should be transformed into genernal error code.

Signed-off-by: Hongbo Li <lihongbo22@huawei.com>
---
 fs/bcachefs/xattr.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/bcachefs/xattr.c b/fs/bcachefs/xattr.c
index 9c0d2316031b..754f17bba68e 100644
--- a/fs/bcachefs/xattr.c
+++ b/fs/bcachefs/xattr.c
@@ -544,11 +544,11 @@ static int bch2_xattr_bcachefs_set(const struct xattr_handler *handler,
 		kfree(buf);
 
 		if (ret < 0)
-			return ret;
+			goto err_class_exit;
 
 		ret = bch2_opt_check_may_set(c, opt_id, v);
 		if (ret < 0)
-			return ret;
+			goto err_class_exit;
 
 		s.v = v + 1;
 		s.defined = true;
@@ -595,6 +595,7 @@ static int bch2_xattr_bcachefs_set(const struct xattr_handler *handler,
 	     (opt_id == Opt_compression && !inode_opt_get(c, &inode->ei_inode, background_compression))))
 		bch2_set_rebalance_needs_scan(c, inode->ei_inode.bi_inum);
 
+err_class_exit:
 	return bch2_err_class(ret);
 }
 
-- 
2.34.1


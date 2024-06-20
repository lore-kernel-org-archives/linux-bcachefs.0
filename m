Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91BBC1E49E
	for <linux-bcachefs@vger.kernel.org>; Thu, 20 Jun 2024 13:19:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.190
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718889557; cv=none; b=jTPDwi59kKB0WFbq3pcgs9bDxMpmjiD5tmXi7xZ//PzpcCbCHBRrMo4ckmLmu4G+0CMIyzoWv/C9k7XiufxG7+q+mDSSDYagz+b9iPHI7oNSJeFX0cbEfVUzXeq1ZUvs098ceLKnmtblLEwfydz3oRqGHAuucXbP6C/A78CsQ5Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718889557; c=relaxed/simple;
	bh=8v6PVfFKo8UHitvIYtBQA71dJl6jSkmTs/KM5eHASX0=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=P7BnT7B4H0xgWvYmP4/dP/u0cBoEzL6zpLGxfwpuHRYr1PTiG1g90IjuhkcW4TZ5dwAQikOuYUrYreT7zRXrhd9BI7/EDaMIALGXQnEZJffkqEBe655gNj09E3qdrCXbhUvQl4ai6UN+SpHFissQx9FqxvgxA7WxndOScoAqkgQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.190
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.162.112])
	by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4W4gvp2nrFz2CkCj;
	Thu, 20 Jun 2024 21:15:18 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (unknown [7.185.36.66])
	by mail.maildlp.com (Postfix) with ESMTPS id 2F6CF14038F;
	Thu, 20 Jun 2024 21:19:13 +0800 (CST)
Received: from huawei.com (10.90.53.73) by dggpeml500022.china.huawei.com
 (7.185.36.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.39; Thu, 20 Jun
 2024 21:19:12 +0800
From: Hongbo Li <lihongbo22@huawei.com>
To: <kent.overstreet@linux.dev>
CC: <linux-bcachefs@vger.kernel.org>, <lihongbo22@huawei.com>
Subject: [PATCH] bcachefs: allow direct io fallback to buffer io for unaligned length or offset
Date: Thu, 20 Jun 2024 21:21:57 +0800
Message-ID: <20240620132157.888559-1-lihongbo22@huawei.com>
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

Support fallback to buffered I/O if the operation being performed on
unaligned length or offset. This may change the behavior for direct
I/O in some cases.

[Before]
For length which aligned with 256 bytes (not SECTOR aligned) will
read failed under direct I/O.

[After]
For length which aligned with 256 bytes (not SECTOR aligned) will
read the data successfully under direct I/O because it will fallback
to buffer I/O.

Signed-off-by: Hongbo Li <lihongbo22@huawei.com>
---
 fs/bcachefs/errcode.h      |  1 +
 fs/bcachefs/fs-io-direct.c | 19 +++++++++++++------
 2 files changed, 14 insertions(+), 6 deletions(-)

diff --git a/fs/bcachefs/errcode.h b/fs/bcachefs/errcode.h
index a268af3e52bf..ff0bbeadec79 100644
--- a/fs/bcachefs/errcode.h
+++ b/fs/bcachefs/errcode.h
@@ -9,6 +9,7 @@
 	x(BCH_ERR_mount_option,		option_name)				\
 	x(BCH_ERR_mount_option,		option_value)				\
 	x(BCH_ERR_mount_option,         option_not_bool)                        \
+	x(EINVAL,			EINVAL_fallback_buffer_read)		\
 	x(ENOMEM,			ENOMEM_stripe_buf)			\
 	x(ENOMEM,			ENOMEM_replicas_table)			\
 	x(ENOMEM,			ENOMEM_cpu_replicas)			\
diff --git a/fs/bcachefs/fs-io-direct.c b/fs/bcachefs/fs-io-direct.c
index 049b61bc9a5b..bae29696b89e 100644
--- a/fs/bcachefs/fs-io-direct.c
+++ b/fs/bcachefs/fs-io-direct.c
@@ -77,9 +77,9 @@ static int bch2_direct_IO_read(struct kiocb *req, struct iov_iter *iter)
 
 	bch2_inode_opts_get(&opts, c, &inode->ei_inode);
 
-	/* bios must be 512 byte aligned: */
+	/* bios must be 512 byte aligned, otherwise fallback to buffer read. */
 	if ((offset|iter->count) & (SECTOR_SIZE - 1))
-		return -EINVAL;
+		return -BCH_ERR_EINVAL_fallback_buffer_read;
 
 	ret = min_t(loff_t, iter->count,
 		    max_t(loff_t, 0, i_size_read(&inode->v) - offset));
@@ -201,13 +201,20 @@ ssize_t bch2_read_iter(struct kiocb *iocb, struct iov_iter *iter)
 		ret = bch2_direct_IO_read(iocb, iter);
 		blk_finish_plug(&plug);
 
+		if (ret == -BCH_ERR_EINVAL_fallback_buffer_read) {
+			iocb->ki_flags &= ~IOCB_DIRECT;
+			goto fallback_buffer_read;
+		}
 		if (ret >= 0)
 			iocb->ki_pos += ret;
-	} else {
-		bch2_pagecache_add_get(inode);
-		ret = generic_file_read_iter(iocb, iter);
-		bch2_pagecache_add_put(inode);
+		goto out;
 	}
+
+fallback_buffer_read:
+	bch2_pagecache_add_get(inode);
+	ret = generic_file_read_iter(iocb, iter);
+	bch2_pagecache_add_put(inode);
+
 out:
 	return bch2_err_class(ret);
 }
-- 
2.34.1


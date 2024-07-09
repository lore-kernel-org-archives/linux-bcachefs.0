Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CD4B13BC30
	for <linux-bcachefs@vger.kernel.org>; Tue,  9 Jul 2024 08:06:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720512376; cv=none; b=pBmGIIn4eDTB6y8nmlejJRUsW1tjGRHw1kjMYUE/f9maRWfa5Z1K4yf1dVi39T5pPhlYCgqdOi8eQlG2IrfED2i/OUYnTUhgKmu5sga9Hx3Yr7utAy+gdBLTZS+kIuEQ99kyMEqCXAM0aRnbcYMGFQ3p/ZeGIlDWAK9CwMo6/QE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720512376; c=relaxed/simple;
	bh=Av9j6+ZaZF7ujRAD2nBcgdf8EkzdLLGaA1OcFSkRioA=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=t0IbPKOhcFfLV06hgY1qBClqYxg1kIRztGvhd3Ku/7WTrdOnhwvadFgwIthLS8J9nE2UBDDSFPe3IZvnRPrLjl7qEu+U90M/V/XYygdprGI/LtLcx3COY8QYl7kTI9VzpIqbi2ipwIaBN7XNWpg83fb1xPNaqoSZQJPqM2M2sBc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.252])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4WJD343ZKqzxVYY;
	Tue,  9 Jul 2024 16:01:36 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (unknown [7.185.36.66])
	by mail.maildlp.com (Postfix) with ESMTPS id 781FB180AE4;
	Tue,  9 Jul 2024 16:06:10 +0800 (CST)
Received: from huawei.com (10.90.53.73) by dggpeml500022.china.huawei.com
 (7.185.36.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.39; Tue, 9 Jul
 2024 16:06:10 +0800
From: Hongbo Li <lihongbo22@huawei.com>
To: <kent.overstreet@linux.dev>
CC: <linux-bcachefs@vger.kernel.org>, <lihongbo22@huawei.com>
Subject: [PATCH] bcachefs: prevent lookuping excessively long paths
Date: Tue, 9 Jul 2024 16:10:20 +0800
Message-ID: <20240709081020.3728942-1-lihongbo22@huawei.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpeml500022.china.huawei.com (7.185.36.66)

The longest name length for file is BCH_NAME_MAX in bcachefs.
When looking up a longer path, it does not check this limit. So
we add the validation for this to avoid undetermined risk.

Signed-off-by: Hongbo Li <lihongbo22@huawei.com>
---
 fs/bcachefs/fs.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/bcachefs/fs.c b/fs/bcachefs/fs.c
index fd01a5402c28..f8da598ca9f8 100644
--- a/fs/bcachefs/fs.c
+++ b/fs/bcachefs/fs.c
@@ -474,6 +474,9 @@ static struct dentry *bch2_lookup(struct inode *vdir, struct dentry *dentry,
 	struct bch_inode_info *dir = to_bch_ei(vdir);
 	struct bch_hash_info hash = bch2_hash_info_init(c, &dir->ei_inode);
 
+	if (dentry->d_name.len > BCH_NAME_MAX)
+		return ERR_PTR(-ENAMETOOLONG);
+
 	struct bch_inode_info *inode;
 	bch2_trans_do(c, NULL, NULL, 0,
 		PTR_ERR_OR_ZERO(inode = bch2_lookup_trans(trans, inode_inum(dir),
-- 
2.34.1


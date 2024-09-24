Received: from szxga06-in.huawei.com (szxga06-in.huawei.com [45.249.212.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBDDF10940
	for <linux-bcachefs@vger.kernel.org>; Tue, 24 Sep 2024 01:32:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727141552; cv=none; b=MXUn03vd9a9tZkfTo/K4hohOAPoiMMD8nLlAxN35U8B1Ztwg00aHCo2XDZokcUtImhDUCPdzJT7HfTPHQfs1YXk6DH5Uuz8Avs6DyFVI9Q/SVtvp3kqq+bDs5m9yatDnI9GFKxQH54vTyRweRowZdufQgOF4a2jODqEONt65aMw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727141552; c=relaxed/simple;
	bh=LF1DeBAhA8ko13HWXbDdHtrnmOx6KLnhskvu6b/cVo4=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=S8pwYxqIXtcE4AvTrY7K0sqOEIgb8DICsSeq6x+hgchAPyn2h9HdSedrrlmxhoM99N4zy6R3S58cMiDCvZSBPepRfNzG8mhKup+37Byyp+mWgcqm6NVjRqmKlVwV08KY/P/DtUr26bFatWy8jtMnhBips8qKuTbLadVq99JMlMg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.214])
	by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4XCMmR0MCRz1ylwx;
	Tue, 24 Sep 2024 09:32:23 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (unknown [7.185.36.66])
	by mail.maildlp.com (Postfix) with ESMTPS id B10AF1A016C;
	Tue, 24 Sep 2024 09:32:21 +0800 (CST)
Received: from huawei.com (10.90.53.73) by dggpeml500022.china.huawei.com
 (7.185.36.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.39; Tue, 24 Sep
 2024 09:32:21 +0800
From: Hongbo Li <lihongbo22@huawei.com>
To: <kent.overstreet@linux.dev>
CC: <linux-bcachefs@vger.kernel.org>, <lihongbo22@huawei.com>,
	<chris.zjh@huawei.com>
Subject: [PATCH] bcachefs: fast exit when darray_make_room failed
Date: Tue, 24 Sep 2024 09:42:24 +0800
Message-ID: <20240924014224.701966-1-lihongbo22@huawei.com>
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

In downgrade_table_extra, the return value is needed. When it
return failed, we should exit immediately.

Fixes: 7773df19c35f ("bcachefs: metadata version bucket_stripe_sectors")
Signed-off-by: Hongbo Li <lihongbo22@huawei.com>
---
 fs/bcachefs/sb-downgrade.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/bcachefs/sb-downgrade.c b/fs/bcachefs/sb-downgrade.c
index c7e4cdd3f6a5..6f0493f79959 100644
--- a/fs/bcachefs/sb-downgrade.c
+++ b/fs/bcachefs/sb-downgrade.c
@@ -353,7 +353,9 @@ int bch2_sb_downgrade_update(struct bch_fs *c)
 		for (unsigned i = 0; i < src->nr_errors; i++)
 			dst->errors[i] = cpu_to_le16(src->errors[i]);
 
-		downgrade_table_extra(c, &table);
+		ret = downgrade_table_extra(c, &table);
+		if (ret)
+			goto out;
 
 		if (!dst->recovery_passes[0] &&
 		    !dst->recovery_passes[1] &&
-- 
2.34.1


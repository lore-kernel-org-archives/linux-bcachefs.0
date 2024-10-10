Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A574520334
	for <linux-bcachefs@vger.kernel.org>; Thu, 10 Oct 2024 04:02:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.190
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728532958; cv=none; b=k+IN+uEh95DVEybQu851vKKp8DNpeDYf8SfERbLjJeZ163KWgnN0zJ5wQyM4m46frUtiAwXI48B0nurHq7GQHROopXErR1pkX4xY1iY6SSCa5UF58en8/DTmR8ylj+E2eb7p6TpT9xF83QunRHa+rQDApFfZIIHaw8jt4DZUbdc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728532958; c=relaxed/simple;
	bh=/wa5SEggZdXgPY02CDDbNdsUcCznZqVX2/F/EC+bmxU=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=ggPR101T5J8Kg0U5xO+XpMNZtxRqFh2bB8cRxXOPKrHoKHEcXdC3Xn8w/dZGaTTGv1Cgf2iL/3D5nesdz5aTCaHVvOKHdPGlCtRz8jjXTcEeKqRF8BW4A4YPdC1IAq2/Nr7LYEkEZQL4QdaynDJMqn1UHMECjEBThJtuVncCxgQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.190
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.17])
	by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4XPGKb1F58z20pdJ;
	Thu, 10 Oct 2024 12:01:55 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (unknown [7.185.36.66])
	by mail.maildlp.com (Postfix) with ESMTPS id 7ECB81A0188;
	Thu, 10 Oct 2024 12:02:32 +0800 (CST)
Received: from huawei.com (10.90.53.73) by dggpeml500022.china.huawei.com
 (7.185.36.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.39; Thu, 10 Oct
 2024 12:02:32 +0800
From: Hongbo Li <lihongbo22@huawei.com>
To: <kent.overstreet@linux.dev>
CC: <linux-bcachefs@vger.kernel.org>, <lihongbo22@huawei.com>
Subject: [PATCH] bcachefs: skip mount option handle for empty string.
Date: Thu, 10 Oct 2024 12:01:48 +0800
Message-ID: <20241010040148.2333295-1-lihongbo22@huawei.com>
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

The options parse in get_tree will split the options buffer, it will
get the empty string for last one by strsep(). After commit
ea0eeb89b1d5 ("bcachefs: reject unknown mount options") is merged,
unknown mount options is not allowed (here is empty string), and this
causes this errors. This can be reproduced just by the following steps:

    bcachefs format /dev/loop
    mount -t bcachefs -o metadata_target=loop1 /dev/loop1 /mnt/bcachefs/

Fixes: ea0eeb89b1d5 ("bcachefs: reject unknown mount options")
Signed-off-by: Hongbo Li <lihongbo22@huawei.com>
---
 fs/bcachefs/opts.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/bcachefs/opts.c b/fs/bcachefs/opts.c
index f853f2f3d36c..a249bf98b25a 100644
--- a/fs/bcachefs/opts.c
+++ b/fs/bcachefs/opts.c
@@ -595,6 +595,9 @@ int bch2_parse_mount_opts(struct bch_fs *c, struct bch_opts *opts,
 	copied_opts_start = copied_opts;
 
 	while ((opt = strsep(&copied_opts, ",")) != NULL) {
+		if (!*opt)
+			continue;
+
 		name	= strsep(&opt, "=");
 		val	= opt;
 
-- 
2.34.1


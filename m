Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B2F71AC77D
	for <linux-bcachefs@vger.kernel.org>; Thu, 20 Jun 2024 13:18:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718889512; cv=none; b=NuAmGhxqbVY9pmoyPMXphlei1PDhPAj2SalMlt8Ly2MtN0Ceo2fUQYnSoffACU0BTJZE6SnGKw5FfcAmQDViNw2e8t9CJWskisDnYKNJJ6uLT3A2cc7M824/gzqsRnTE2bVG6WGCUmrzWv79ikcOvfAG3apxwwGZPE98UFHYykY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718889512; c=relaxed/simple;
	bh=gMrQru2pTNW6KnkkaHkCeAQuEw3XHbrmx8B24Wn8ECY=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=i6Lg103jxPQE0XUbEdLrfgGQTe69sfYj0P9vG4iWwOksbjSwE/YvZqGcoe6kiWCxO9XewJyLl5LD8rNAARRCJ0JCMNO9Ewqt+MlXYQtvld9bEvp+Ohsz3LZhpyNpnFgRwcQMpOylKV6IIIch4ptNcHQFLyZFex6qNlZp4+GeryI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.105])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4W4gtZ4rBhzvW9v;
	Thu, 20 Jun 2024 21:14:14 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (unknown [7.185.36.66])
	by mail.maildlp.com (Postfix) with ESMTPS id 076E9140158;
	Thu, 20 Jun 2024 21:18:28 +0800 (CST)
Received: from huawei.com (10.90.53.73) by dggpeml500022.china.huawei.com
 (7.185.36.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.39; Thu, 20 Jun
 2024 21:18:27 +0800
From: Hongbo Li <lihongbo22@huawei.com>
To: <kent.overstreet@linux.dev>
CC: <linux-bcachefs@vger.kernel.org>, <lihongbo22@huawei.com>
Subject: [PATCH] bcachefs: support STATX_DIOALIGN for statx file
Date: Thu, 20 Jun 2024 21:21:12 +0800
Message-ID: <20240620132112.888533-1-lihongbo22@huawei.com>
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

Add support for STATX_DIOALIGN to bcachefs, so that direct I/O alignment
restrictions are exposed to userspace in a generic way.

[Before]
```
./statx_test /mnt/bcachefs/test
statx(/mnt/bcachefs/test) = 0
dio mem align:0
dio offset align:0
```

[After]
```
./statx_test /mnt/bcachefs/test
statx(/mnt/bcachefs/test) = 0
dio mem align:1
dio offset align:512
```

Signed-off-by: Hongbo Li <lihongbo22@huawei.com>
---
 fs/bcachefs/fs.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/bcachefs/fs.c b/fs/bcachefs/fs.c
index 4a3e9f429cf7..74e81f90b230 100644
--- a/fs/bcachefs/fs.c
+++ b/fs/bcachefs/fs.c
@@ -880,6 +880,12 @@ static int bch2_getattr(struct mnt_idmap *idmap,
 	stat->subvol	= inode->ei_subvol;
 	stat->result_mask |= STATX_SUBVOL;
 
+	if ((request_mask & STATX_DIOALIGN) && S_ISREG(inode->v.i_mode)) {
+		stat->result_mask |= STATX_DIOALIGN;
+		stat->dio_mem_align = 1;
+		stat->dio_offset_align = SECTOR_SIZE;
+	}
+
 	if (request_mask & STATX_BTIME) {
 		stat->result_mask |= STATX_BTIME;
 		stat->btime = bch2_time_to_timespec(c, inode->ei_inode.bi_otime);
-- 
2.34.1


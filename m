Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 307C0539A
	for <linux-bcachefs@vger.kernel.org>; Fri, 12 Jul 2024 07:05:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.190
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720767912; cv=none; b=uiGfc4qqjseiUb3AHtKYd9YVHZIz2pVQ8lRM27jSbUxTKQabXEKCKqOo0S+5m/FbrbaUT60lFXlIU/ccqKzrrqX2U3wB7RRwfcwZ+K1Y3TP0P5uIQO0Gn3O+DTjHj8VOTVd2rAGxPn8eA07yCFzFXIUHgKmVe/OQxG5pnzQSBXE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720767912; c=relaxed/simple;
	bh=3VwwD9U2Hn91AM9kQr0bEkq0nGT1ABMXpekwrI6NvOc=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=rgrBI2LSy7QonGYnGN9jlP1Jgzs+DLRhREb+eR+Nnfn7ux+4m+HXcJZ3+6igFxpqvcc/2rLRTEymWZo4D16RePr6tnEoMe2eEMgwhjtJ/gBhzk7NyC2BfjYdFl9U/DfGr0SMU3vR2bwfwDeXRppLo7QAWCwGSA9AFsHSLuAKkWU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.190
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.17])
	by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4WL2YV6d4nz2ClCw;
	Fri, 12 Jul 2024 15:00:46 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (unknown [7.185.36.66])
	by mail.maildlp.com (Postfix) with ESMTPS id 080431A0188;
	Fri, 12 Jul 2024 15:05:01 +0800 (CST)
Received: from huawei.com (10.90.53.73) by dggpeml500022.china.huawei.com
 (7.185.36.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.39; Fri, 12 Jul
 2024 15:05:00 +0800
From: Hongbo Li <lihongbo22@huawei.com>
To: <kent.overstreet@linux.dev>
CC: <linux-bcachefs@vger.kernel.org>, <lihongbo22@huawei.com>
Subject: [PATCH] bcachefs: show none if label is not set
Date: Fri, 12 Jul 2024 15:09:25 +0800
Message-ID: <20240712070925.1589874-1-lihongbo22@huawei.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggpeml500022.china.huawei.com (7.185.36.66)

If label is not set, the Label tag in superblock info show '(none)'.

```
[Before]
Device index:                               0
Label:
Version:                                    1.4: member_seq

[After]
Device index:                               0
Label:                                      (none)
Version:                                    1.4: member_seq
```

Signed-off-by: Hongbo Li <lihongbo22@huawei.com>
---
 fs/bcachefs/super-io.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/bcachefs/super-io.c b/fs/bcachefs/super-io.c
index b156fc85b8a3..8bc819832790 100644
--- a/fs/bcachefs/super-io.c
+++ b/fs/bcachefs/super-io.c
@@ -1312,7 +1312,10 @@ void bch2_sb_to_text(struct printbuf *out, struct bch_sb *sb,
 	prt_printf(out, "Device index:\t%u\n", sb->dev_idx);
 
 	prt_printf(out, "Label:\t");
-	prt_printf(out, "%.*s", (int) sizeof(sb->label), sb->label);
+	if (!strlen(sb->label))
+		prt_printf(out, "(none)");
+	else
+		prt_printf(out, "%.*s", (int) sizeof(sb->label), sb->label);
 	prt_newline(out);
 
 	prt_printf(out, "Version:\t");
-- 
2.34.1


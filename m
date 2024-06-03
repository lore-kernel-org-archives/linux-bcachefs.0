Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59C4259B4A
	for <linux-bcachefs@vger.kernel.org>; Mon,  3 Jun 2024 13:22:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717420934; cv=none; b=K5MXMsWDVOEpwwzM0XnOBuaAO1NujcFqrxnhCdsktKd2lkw7iRRsMCHtA7u60TrPvKkETfLpDHRhVWcJl3KyiZVJY/IrAiE7NYC3UWzTYclJBGjewVEfrNlmuRTzIsPeoHKbXVcK3z9O3NYYf6YrY+JAZ+Djr6bgf49fZhFT/F4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717420934; c=relaxed/simple;
	bh=2VLueS6/RDPL+gX5ALRDO5ccZgx9k74QLYcGNf0qCtY=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=UoFHrvq3QQpohGXjH4FeCA5fELQDTHaJB3rRp0yIriMOBMczr4cr46jI+/fekRxnRKA7DOKNnAf31bXFyrd67UCw0LNyYXhBvDGoy+stVU6FFl4kV/POjntOX0UXaEyWzdELHgLDYLs+cK3pWncFHTvwGf5BHVEidbFlNl6iY2w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.174])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4VtDn200WZzxNdK;
	Mon,  3 Jun 2024 21:18:13 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (unknown [7.185.36.66])
	by mail.maildlp.com (Postfix) with ESMTPS id AD05A140417;
	Mon,  3 Jun 2024 21:22:08 +0800 (CST)
Received: from huawei.com (10.90.53.73) by dggpeml500022.china.huawei.com
 (7.185.36.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.39; Mon, 3 Jun
 2024 21:22:08 +0800
From: Hongbo Li <lihongbo22@huawei.com>
To: <kent.overstreet@linux.dev>, <bfoster@redhat.com>
CC: <linux-bcachefs@vger.kernel.org>, <lihongbo22@huawei.com>
Subject: [PATCH] bcachefs: fix the display format for show-super
Date: Mon, 3 Jun 2024 21:23:35 +0800
Message-ID: <20240603132335.4027737-1-lihongbo22@huawei.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpeml500022.china.huawei.com (7.185.36.66)

There are three keys displayed in non-uniform format.
Let's fix them.

[Before]
```
Label:	testbcachefs
Version:	1.9: (unknown version)
Version upgrade complete:	0.0: (unknown version)
```

[After]
```
Label:					testbcachefs
Version:				1.9: (unknown version)
Version upgrade complete:		0.0: (unknown version)
```

Fixes: 7423330e30ab ("bcachefs: prt_printf() now respects \r\n\t")
Signed-off-by: Hongbo Li <lihongbo22@huawei.com>
---
 fs/bcachefs/super-io.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/bcachefs/super-io.c b/fs/bcachefs/super-io.c
index d73a0222f709..055478d21e9e 100644
--- a/fs/bcachefs/super-io.c
+++ b/fs/bcachefs/super-io.c
@@ -1310,15 +1310,15 @@ void bch2_sb_to_text(struct printbuf *out, struct bch_sb *sb,
 
 	prt_printf(out, "Device index:\t%u\n", sb->dev_idx);
 
-	prt_str(out, "Label:\t");
+	prt_printf(out, "Label:\t");
 	prt_printf(out, "%.*s", (int) sizeof(sb->label), sb->label);
 	prt_newline(out);
 
-	prt_str(out, "Version:\t");
+	prt_printf(out, "Version:\t");
 	bch2_version_to_text(out, le16_to_cpu(sb->version));
 	prt_newline(out);
 
-	prt_str(out, "Version upgrade complete:\t");
+	prt_printf(out, "Version upgrade complete:\t");
 	bch2_version_to_text(out, BCH_SB_VERSION_UPGRADE_COMPLETE(sb));
 	prt_newline(out);
 
-- 
2.34.1


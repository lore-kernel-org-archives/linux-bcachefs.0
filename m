Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D973188010
	for <linux-bcachefs@vger.kernel.org>; Tue, 29 Oct 2024 12:54:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730206464; cv=none; b=KkrtPlVUNP+gDhlcLashF2ak1W8jvygywP9XJ8GTElYe8CZg26ShVSLq5TL7OQzQljPQ/WPglvsn4Lz6T8ToiG7g+Q6wmg7WPkU4magrdT4YOwxLp7KiqZpm2TYYJQGt8mGKbctyXc8lu4lIPC/KwKJWtvz/lkhy/ypAXjBLRKc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730206464; c=relaxed/simple;
	bh=teGsxwTRnT5phyc/BeXKjwSw8xHU15L/VaYxygcKuqQ=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=f11PksvW95/j7fOnfPMyaZ4hu9z/x3RX9ZDL34dQQywKvGtZ/pZPhk+wh/RibsVKK0pNGFlrnKwCy29yEB6nLq/1LCvkVoalSLbzsPQTYHvbEadrPnf7vfgvaT0DddMWHDMNZpEY4Hc0WArOLVTuUDqCHiczkdTAlscG28f+4rY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.174])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4Xd9Bb2NtGz10PGC;
	Tue, 29 Oct 2024 20:52:07 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (unknown [7.185.36.66])
	by mail.maildlp.com (Postfix) with ESMTPS id 43E05140257;
	Tue, 29 Oct 2024 20:54:17 +0800 (CST)
Received: from huawei.com (10.90.53.73) by dggpeml500022.china.huawei.com
 (7.185.36.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.39; Tue, 29 Oct
 2024 20:54:17 +0800
From: Hongbo Li <lihongbo22@huawei.com>
To: <kent.overstreet@linux.dev>
CC: <linux-bcachefs@vger.kernel.org>, <lihongbo22@huawei.com>
Subject: [PATCH] bcachefs: remove write permission for gc_gens_pos sysfs interface
Date: Tue, 29 Oct 2024 20:53:50 +0800
Message-ID: <20241029125350.2998851-1-lihongbo22@huawei.com>
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

The gc_gens_pos is used to show the status of bucket gen gc.
There is no need to assign write permissions for this attribute.
Here we can use read_attribute helper to define this attribute.

```
[Before]
  $ ll internal/gc_gens_pos
  -rw-r--r-- 1 root root 4096 Oct 28 15:27 internal/gc_gens_pos

[After]
  $ ll internal/gc_gens_pos
  -r--r--r-- 1 root root 4096 Oct 28 17:27 internal/gc_gens_pos
```

Fixes: ac516d0e7db7 ("bcachefs: Add the status of bucket gen gc to sysfs")
Signed-off-by: Hongbo Li <lihongbo22@huawei.com>
---
 fs/bcachefs/sysfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/bcachefs/sysfs.c b/fs/bcachefs/sysfs.c
index 4ab0ccba2ab5..47ac8d5ab562 100644
--- a/fs/bcachefs/sysfs.c
+++ b/fs/bcachefs/sysfs.c
@@ -146,7 +146,7 @@ write_attribute(trigger_journal_writes);
 write_attribute(trigger_btree_cache_shrink);
 write_attribute(trigger_btree_key_cache_shrink);
 write_attribute(trigger_freelist_wakeup);
-rw_attribute(gc_gens_pos);
+read_attribute(gc_gens_pos);
 
 read_attribute(uuid);
 read_attribute(minor);
-- 
2.34.1


Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 230C118E025
	for <linux-bcachefs@vger.kernel.org>; Wed,  6 Nov 2024 02:06:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.190
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730858771; cv=none; b=Dysnc6ljlMPsaNI/rXotbuTPT6rQEWwR7M03D5DQmoPOXHnVkOnh7l3ENrLOdRBwuyEqfuwdegq5Z1JpJjiQDB8M4fKAxhwOdQPBKqByrJYFsbq4U9/m5uUydrpljJMbI/5yvrGhagDoHskoEtlI3/aGIU866oZv9qcYrnrZwqE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730858771; c=relaxed/simple;
	bh=44KjD1ci01lN1jozQ9VvjPHZm4OFaaBgSgKaW83+/jo=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=S1W8TKhYRgHdLzRvzi9jRd8wr08xalUXYLZQsj2z676tZ3eFhYRYuYAVWKmvWotYREP1L8sAghu9oavNVIN23tJ+KEGDGUctLWskGevP4AGGGiqqo5eRBPN+zizIl6gRfWwJY2sNQvLObMRQW6qus9/FspUJ5f5/6+bVSniDcDY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.190
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.234])
	by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4XjpSC1D7Nz20rSt;
	Wed,  6 Nov 2024 10:04:59 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (unknown [7.185.36.66])
	by mail.maildlp.com (Postfix) with ESMTPS id ABABC14011B;
	Wed,  6 Nov 2024 10:06:05 +0800 (CST)
Received: from huawei.com (10.90.53.73) by dggpeml500022.china.huawei.com
 (7.185.36.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.39; Wed, 6 Nov
 2024 10:06:05 +0800
From: Hongbo Li <lihongbo22@huawei.com>
To: <kent.overstreet@linux.dev>
CC: <linux-bcachefs@vger.kernel.org>, <lihongbo22@huawei.com>
Subject: [PATCH] bcachefs: fix uninitialized percpu variable
Date: Wed, 6 Nov 2024 10:05:41 +0800
Message-ID: <20241106020541.2421993-1-lihongbo22@huawei.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpeml500022.china.huawei.com (7.185.36.66)

When alloc percpu counters in bch2_fs_counters_init, we do not
initialize it. When nr < BCH_COUNTER_NR, the variables after
counters[nr - 1] are not initialized. Considering __GFP_ZERO flags
aren't guaranteed to be all zeros on different archs for percpu
allocations, so here initialize this variable explicitly.

Fixes: 104c69745fdf ("bcachefs: Add persistent counters")
Signed-off-by: Hongbo Li <lihongbo22@huawei.com>
---
 fs/bcachefs/sb-counters.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/bcachefs/sb-counters.c b/fs/bcachefs/sb-counters.c
index 6992e7469112..92cb3745d1c2 100644
--- a/fs/bcachefs/sb-counters.c
+++ b/fs/bcachefs/sb-counters.c
@@ -50,7 +50,7 @@ int bch2_sb_counters_to_cpu(struct bch_fs *c)
 
 	for (i = 0; i < min_t(unsigned int, nr, BCH_COUNTER_NR); i++) {
 		val = le64_to_cpu(ctrs->d[i]);
-		percpu_u64_set(&c->counters[i], val);
+		this_cpu_write(c->counters[i], val);
 		c->counters_on_mount[i] = val;
 	}
 	return 0;
@@ -86,10 +86,15 @@ void bch2_fs_counters_exit(struct bch_fs *c)
 
 int bch2_fs_counters_init(struct bch_fs *c)
 {
+	unsigned int i;
+
 	c->counters = __alloc_percpu(sizeof(u64) * BCH_COUNTER_NR, sizeof(u64));
 	if (!c->counters)
 		return -BCH_ERR_ENOMEM_fs_counters_init;
 
+	for (i = 0; i < BCH_COUNTER_NR; i++)
+		percpu_u64_set(&c->counters[i], 0);
+
 	return bch2_sb_counters_to_cpu(c);
 }
 
-- 
2.34.1


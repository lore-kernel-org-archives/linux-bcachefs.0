Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF70213A889
	for <linux-bcachefs@vger.kernel.org>; Fri, 26 Apr 2024 06:41:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714113684; cv=none; b=Wz/yz2GpIvrQ2u0Ykda0ojMePrQf1gHKQp37pYayWm6nPxTJJOgqOdFpp8LGDIgP0a0qQQfYaT46fgyofNsGMCQWyGxo4/V0ULOpIPj/fB81/DtZxL6VwYKgEd/TVPqgVSySdG7wdxbiwSGS+MtwEcv1v2TH5QhkJntQF3GPoeE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714113684; c=relaxed/simple;
	bh=oHpNNMzfaP9NfvfxrV4fyIYYsNQRnwSmSJyNP0t6ci0=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=tOiX91/OG+JZnmJm9CKpbTsdZTC5EJa66FP10Z8mel2gpXkXpHp4S6OOv9CgpqX+wmPBRqmSNnSzrZ7K6bM/zZfcTrgaz3hbHvulaufry2MGuXbqIQgepe7/C+yGKjNPAGje2CAoQDxMs7wBgL7q+Xe+XkBTgbhlENAW2hA9fR8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.162.254])
	by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4VQjjc3qPvzNtqY;
	Fri, 26 Apr 2024 14:38:44 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (unknown [7.185.36.66])
	by mail.maildlp.com (Postfix) with ESMTPS id EBE1318009D;
	Fri, 26 Apr 2024 14:41:17 +0800 (CST)
Received: from huawei.com (10.90.53.73) by dggpeml500022.china.huawei.com
 (7.185.36.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.35; Fri, 26 Apr
 2024 14:41:17 +0800
From: Hongbo Li <lihongbo22@huawei.com>
To: <kent.overstreet@linux.dev>, <bfoster@redhat.com>
CC: <linux-bcachefs@vger.kernel.org>, <lihongbo22@huawei.com>
Subject: [PATCH v3] bcachefs: eliminate the uninitialized compilation warning in __do_six_trylock
Date: Fri, 26 Apr 2024 14:41:32 +0800
Message-ID: <20240426064132.2611169-1-lihongbo22@huawei.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpeml500022.china.huawei.com (7.185.36.66)

When compiling the bcachefs-tools, the following compilation warning
is reported:
    libbcachefs/six.c: In function ‘__do_six_trylock’:
    libbcachefs/six.c:90:12: warning: ‘old’ may be used uninitialized in this function [-Wmaybe-uninitialized]
       90 |  if (!(old & SIX_LOCK_HELD_intent)) {
        |       ~~~~~^~~~~~~~~~~~~~~~~~~~~~~

This is also a false altert. Only when @type=SIX_LOCK_write and @try=false
are passed in __do_six_trylock, the second condition branch would enter
which does not initialize the @old variable. But six_set_owner will not
use @old if @type is not SIX_LOCK_intent. There should be nothing wrong
in logical too.

Although the report itself is a false alert, we can elimate the unitialize
compilation warning by assigning @old in front.

Fixes: 84a37cbf62e0 ("six locks: Wakeup now takes lock on behalf of waiter")
Signed-off-by: Hongbo Li <lihongbo22@huawei.com>
---
v3:
  - Keep the lock state reading in original branch as Kent's suggestion.

v2: https://lore.kernel.org/linux-bcachefs/4c7f35f0-29c2-4368-8061-d022b7528469@huawei.com/T/#u
  - Fix the error about reading lock->state introduced in v1.

v1: https://lore.kernel.org/all/20240419074851.1583392-3-lihongbo22@huawei.com/T/#u

 fs/bcachefs/six.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/bcachefs/six.c b/fs/bcachefs/six.c
index 3a494c5d1247..086f045dbaa9 100644
--- a/fs/bcachefs/six.c
+++ b/fs/bcachefs/six.c
@@ -118,11 +118,11 @@ static int __do_six_trylock(struct six_lock *lock, enum six_lock_type type,
 			    struct task_struct *task, bool try)
 {
 	int ret;
-	u32 old;
+	u32 old = atomic_read(&lock->state);
 
 	EBUG_ON(type == SIX_LOCK_write && lock->owner != task);
 	EBUG_ON(type == SIX_LOCK_write &&
-		(try != !(atomic_read(&lock->state) & SIX_LOCK_HELD_write)));
+		(try != !(old & SIX_LOCK_HELD_write)));
 
 	/*
 	 * Percpu reader mode:
-- 
2.34.1


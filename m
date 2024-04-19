Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C59BD3D97A
	for <linux-bcachefs@vger.kernel.org>; Fri, 19 Apr 2024 07:48:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713512935; cv=none; b=CY+0r2T31/TgTzHt4518RQrs9a7eD6FtJ+zGFuYQK7gwdghotIH3yq7CQwCqt6pxKhAltJDDQrlPgY88WNWt2CJ/sLLn3jqqvy2q+jmVczzS9UtT1SU+64hKi2DJJbBH+lcJIjvmJIXDl5Jg7JtjWTu2/DL94797vjJAcDRqd+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713512935; c=relaxed/simple;
	bh=eI2Lil9S+QowcBZx8JGMH9qFxIJqL26uB0i+633idQ8=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dVbyQ3oRAW4/Yk6tWwzN0ihjK7Z+kPF5qNMXcVR/4qNaoXfKEK3ESbDGjJ8Vxg9YeoXPYAyS9RML12nJL1yMZQofbUaQw8fu1PMm7TPuAS1Eg9C6C2A+eohADfYn2p62UKROT9aXuc4Xy9xIGyUdJAz7IakCUQidtKDTD9HQUfE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.194])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4VLRXB03X6zcdNn;
	Fri, 19 Apr 2024 15:45:46 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (unknown [7.185.36.66])
	by mail.maildlp.com (Postfix) with ESMTPS id 319571400D5;
	Fri, 19 Apr 2024 15:48:51 +0800 (CST)
Received: from huawei.com (10.90.53.73) by dggpeml500022.china.huawei.com
 (7.185.36.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.35; Fri, 19 Apr
 2024 15:48:50 +0800
From: Hongbo Li <lihongbo22@huawei.com>
To: <kent.overstreet@linux.dev>, <bfoster@redhat.com>
CC: <linux-bcachefs@vger.kernel.org>, <lihongbo22@huawei.com>
Subject: [PATCH 2/2] bcachefs: eliminate the uninitialized compilation warning in __do_six_trylock
Date: Fri, 19 Apr 2024 15:48:51 +0800
Message-ID: <20240419074851.1583392-3-lihongbo22@huawei.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240419074851.1583392-1-lihongbo22@huawei.com>
References: <20240419074851.1583392-1-lihongbo22@huawei.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
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
 fs/bcachefs/six.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/bcachefs/six.c b/fs/bcachefs/six.c
index 3a494c5d1247..9f782e4e3ca9 100644
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
@@ -157,7 +157,6 @@ static int __do_six_trylock(struct six_lock *lock, enum six_lock_type type,
 
 		smp_mb();
 
-		old = atomic_read(&lock->state);
 		ret = !(old & l[type].lock_fail);
 
 		this_cpu_sub(*lock->readers, !ret);
@@ -182,7 +181,6 @@ static int __do_six_trylock(struct six_lock *lock, enum six_lock_type type,
 				ret = -1 - SIX_LOCK_read;
 		}
 	} else {
-		old = atomic_read(&lock->state);
 		do {
 			ret = !(old & l[type].lock_fail);
 			if (!ret || (type == SIX_LOCK_write && !try)) {
-- 
2.34.1


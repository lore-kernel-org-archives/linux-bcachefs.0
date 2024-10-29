Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B87B20265E
	for <linux-bcachefs@vger.kernel.org>; Tue, 29 Oct 2024 12:53:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730206443; cv=none; b=QxBCT5MzUWy3GrzFtfzRh9KZ6NCECqM4CoewpdI97qCy+QwXQR7kQzqa4PhcfVv9EyD2igrSoDb36kjo/DgZN3FrXHfuNTjcMVeK6YcJ9hDgUCU0dcEQdSMY7kkIel6LsAhpgaXT+S5C9W7NvoQmgkrwF4Qk3oo4YgvmQN2yb24=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730206443; c=relaxed/simple;
	bh=doY62dOLXC0NzSYKdXKQK3DMfjhv2rKSzrNydkspcXw=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=aQiMExDZUWvKKGpgGbvXAENaCeEzlLMj0HSJ97lOqzzDGyyBBqgBA0aXPIkP7jxHSG1MmbiFEyZkRZZ1CuQW9gPQLmInc9jwiItAiM5zogk4KJ8lXj6BhXPLzjNL54fmArJoTiSq5kUQWsRxL2njzKA5vZRIPMB922ylXMvj6cw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.162.254])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4Xd9BB1dpnz10PGC;
	Tue, 29 Oct 2024 20:51:46 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (unknown [7.185.36.66])
	by mail.maildlp.com (Postfix) with ESMTPS id 2A07D180103;
	Tue, 29 Oct 2024 20:53:56 +0800 (CST)
Received: from huawei.com (10.90.53.73) by dggpeml500022.china.huawei.com
 (7.185.36.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.39; Tue, 29 Oct
 2024 20:53:55 +0800
From: Hongbo Li <lihongbo22@huawei.com>
To: <kent.overstreet@linux.dev>
CC: <linux-bcachefs@vger.kernel.org>, <lihongbo22@huawei.com>
Subject: [PATCH] bcachefs: check the invalid parameter for perf test
Date: Tue, 29 Oct 2024 20:53:29 +0800
Message-ID: <20241029125329.2992452-1-lihongbo22@huawei.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpeml500022.china.huawei.com (7.185.36.66)

The perf_test does not check the number of iterations and threads
when it is zero. If nr_thread is 0, the perf test will keep
waiting for wakekup. If iteration is 0, it will cause exception
of division by zero. This can be reproduced by:
  echo "rand_insert 0 1" > /sys/fs/bcachefs/${uuid}/perf_test
or
  echo "rand_insert 1 0" > /sys/fs/bcachefs/${uuid}/perf_test

Fixes: 1c6fdbd8f246 ("bcachefs: Initial commit")
Signed-off-by: Hongbo Li <lihongbo22@huawei.com>
---
 fs/bcachefs/tests.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/bcachefs/tests.c b/fs/bcachefs/tests.c
index 315038a0a92d..fb5c1543e52f 100644
--- a/fs/bcachefs/tests.c
+++ b/fs/bcachefs/tests.c
@@ -809,6 +809,11 @@ int bch2_btree_perf_test(struct bch_fs *c, const char *testname,
 	unsigned i;
 	u64 time;
 
+	if (nr == 0 || nr_threads == 0) {
+		pr_err("nr of iterations or threads is not allowed to be 0");
+		return -EINVAL;
+	}
+
 	atomic_set(&j.ready, nr_threads);
 	init_waitqueue_head(&j.ready_wait);
 
-- 
2.34.1


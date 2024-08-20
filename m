Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C39D20B20;
	Tue, 20 Aug 2024 01:19:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.191
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724116802; cv=none; b=rEoL9g8BGjcHOcLP2mhQWOf4hchPOWWkPrmXL3DPy+27++I9yWUy/Dv0fKqoq5aPrnN5VzM2CqzWvbHijyqjECP3nbv4EkF8VrpBSlN3XbflErcPBl9T9/BT7zSvD23ilSvYjBxn4HGSbFNjFOKOBBdToP5f+6Zf8utcmamDVlQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724116802; c=relaxed/simple;
	bh=QwJnsgSf7HZgYjqYfLwpfwG/BggAMvKaf9a7K6aqHTM=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=WK9ZI232lkUVOwQuShlIvy+LztNw5ZqDK9a2U6W70OesRPqjiyYKz8e6emyzZRoAbUhjjGe4kHyBKmhre+g5RfPakVrVCwyrXXQ8pIhnRzUmxHsPkaAnHTY8rgCEt4y290SgjFgKaVYWW4hAuWvcamy5gEhkE6036IwCWok002g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.191
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.214])
	by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4Wns4S66Rdz1HGnx;
	Tue, 20 Aug 2024 09:16:40 +0800 (CST)
Received: from kwepemd500012.china.huawei.com (unknown [7.221.188.25])
	by mail.maildlp.com (Postfix) with ESMTPS id 600E11A016C;
	Tue, 20 Aug 2024 09:19:51 +0800 (CST)
Received: from huawei.com (10.90.53.73) by kwepemd500012.china.huawei.com
 (7.221.188.25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1258.34; Tue, 20 Aug
 2024 09:19:50 +0800
From: Li Zetao <lizetao1@huawei.com>
To: <kent.overstreet@linux.dev>
CC: <lizetao1@huawei.com>, <linux-bcachefs@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
Subject: [PATCH -next 1/2] bcachefs: Remove redundant checks
Date: Tue, 20 Aug 2024 09:27:17 +0800
Message-ID: <20240820012718.4121485-1-lizetao1@huawei.com>
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
 kwepemd500012.china.huawei.com (7.221.188.25)

Since the kthread_create() and strndup_user() do not return a
null pointer, so it is enough to use IS_ERR instead of PTR_ERR_OR_ZERO
to check the return value. Moreover using PTR_ERR_OR_ZERO will do two
checks, while IS_ERR only does one.

No functional change intended.

Signed-off-by: Li Zetao <lizetao1@huawei.com>
---
 fs/bcachefs/chardev.c          | 10 ++++------
 fs/bcachefs/thread_with_file.c |  5 ++---
 2 files changed, 6 insertions(+), 9 deletions(-)

diff --git a/fs/bcachefs/chardev.c b/fs/bcachefs/chardev.c
index ef1f74866e23..c315421bee85 100644
--- a/fs/bcachefs/chardev.c
+++ b/fs/bcachefs/chardev.c
@@ -316,9 +316,8 @@ static long bch2_ioctl_disk_add(struct bch_fs *c, struct bch_ioctl_disk arg)
 		return -EINVAL;
 
 	path = strndup_user((const char __user *)(unsigned long) arg.dev, PATH_MAX);
-	ret = PTR_ERR_OR_ZERO(path);
-	if (ret)
-		return ret;
+	if (IS_ERR(path))
+		return PTR_ERR(path);
 
 	ret = bch2_dev_add(c, path);
 	if (!IS_ERR(path))
@@ -360,9 +359,8 @@ static long bch2_ioctl_disk_online(struct bch_fs *c, struct bch_ioctl_disk arg)
 		return -EINVAL;
 
 	path = strndup_user((const char __user *)(unsigned long) arg.dev, PATH_MAX);
-	ret = PTR_ERR_OR_ZERO(path);
-	if (ret)
-		return ret;
+	if (IS_ERR(path))
+		return PTR_ERR(path);
 
 	ret = bch2_dev_online(c, path);
 	kfree(path);
diff --git a/fs/bcachefs/thread_with_file.c b/fs/bcachefs/thread_with_file.c
index 0807ce9b171a..e8ba0d0cc0df 100644
--- a/fs/bcachefs/thread_with_file.c
+++ b/fs/bcachefs/thread_with_file.c
@@ -39,9 +39,8 @@ int bch2_run_thread_with_file(struct thread_with_file *thr,
 
 	thr->ret = 0;
 	thr->task = kthread_create(fn, thr, "%s", name);
-	ret = PTR_ERR_OR_ZERO(thr->task);
-	if (ret)
-		return ret;
+	if (IS_ERR(thr->task))
+		return PTR_ERR(thr->task);
 
 	ret = get_unused_fd_flags(fd_flags);
 	if (ret < 0)
-- 
2.34.1


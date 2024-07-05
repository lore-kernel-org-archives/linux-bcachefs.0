Received: from szxga07-in.huawei.com (szxga07-in.huawei.com [45.249.212.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB28813A3ED
	for <linux-bcachefs@vger.kernel.org>; Fri,  5 Jul 2024 07:15:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.35
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720163749; cv=none; b=TezwJ34A88YaAASQM4JpJIe+RrKNgPCD9M7njgcelHlWoQo7e1di37vVjXnscUP0hS14LgZvpyg4Rja3azzf8Iogjo149jGANkkAzxOUpAkHc4/p2sbw/g1G2bM6/vf8MqU1nfeRS6/r5I0HGY9DhDv1pFc/Fib61HMDLOjeOfQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720163749; c=relaxed/simple;
	bh=M5b4vL7KG5FajhvXmXpjkLWZXlZtOZgV0rHZJ+0j4jc=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=Fe+OhG1T/X7XCmMZe8Hu5fLGvpbBfBKXtOP+4SsmPdOha8duZBIauof1ETJAXYuwl+VbJ+rVvbYzXWxeYf1kk5NXzzy6YsQ6BFLhPT2AHQoD6Wc8X10X10z5e/DSyFCUz7AdFZpCJ76+x6/s25ZvO47I4dUIUbe3WbWCOZvvIUQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.234])
	by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4WFl754NVpz1X4WF;
	Fri,  5 Jul 2024 15:11:29 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (unknown [7.185.36.66])
	by mail.maildlp.com (Postfix) with ESMTPS id CDD9E1402C7;
	Fri,  5 Jul 2024 15:15:37 +0800 (CST)
Received: from huawei.com (10.90.53.73) by dggpeml500022.china.huawei.com
 (7.185.36.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.39; Fri, 5 Jul
 2024 15:15:37 +0800
From: Hongbo Li <lihongbo22@huawei.com>
To: <kent.overstreet@linux.dev>
CC: <linux-bcachefs@vger.kernel.org>, <lihongbo22@huawei.com>
Subject: [PATCH] bcachefs: add FS_IOC_SETVERSION support
Date: Fri, 5 Jul 2024 15:19:30 +0800
Message-ID: <20240705071930.2768828-1-lihongbo22@huawei.com>
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

As i_generation is used in bcachefs, updating this value by ioctl
(FS_IOC_SETVERSION) should be allowed. Here we implement this cmd
to support modify i_generation.

Signed-off-by: Hongbo Li <lihongbo22@huawei.com>
---
 fs/bcachefs/fs-ioctl.c | 53 +++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 52 insertions(+), 1 deletion(-)

diff --git a/fs/bcachefs/fs-ioctl.c b/fs/bcachefs/fs-ioctl.c
index aea8132d2c40..33728bbab778 100644
--- a/fs/bcachefs/fs-ioctl.c
+++ b/fs/bcachefs/fs-ioctl.c
@@ -277,6 +277,54 @@ static int bch2_ioc_getversion(struct bch_inode_info *inode, u32 __user *arg)
 	return put_user(inode->v.i_generation, arg);
 }
 
+static int bch2_inode_version_set(struct btree_trans *trans,
+				  struct bch_inode_info *inode,
+				  struct bch_inode_unpacked *bi,
+				  void *p)
+{
+	struct bch_fs *c = inode->v.i_sb->s_fs_info;
+	__u32 *generation = p;
+
+	inode->v.i_generation = bi->bi_generation = *generation;
+	bi->bi_ctime = timespec_to_bch2_time(c, current_time(&inode->v));
+
+	return 0;
+}
+
+static int bch2_ioc_setversion(struct bch_fs *c,
+			       struct file *file,
+			       struct bch_inode_info *inode,
+			       void __user *arg)
+{
+	int ret;
+	__u32 generation;
+
+	ret = mnt_want_write_file(file);
+	if (ret)
+		return ret;
+
+	inode_lock(&inode->v);
+	if (!inode_owner_or_capable(file_mnt_idmap(file), &inode->v)) {
+		ret = -EACCES;
+		goto setversion_out;
+	}
+
+	if (get_user(generation, (int __user *) arg)) {
+		ret = -EFAULT;
+		goto setversion_out;
+	}
+
+	mutex_lock(&inode->ei_update_lock);
+	ret = bch2_write_inode(c, inode, bch2_inode_version_set, &generation, ATTR_CTIME);
+	mutex_unlock(&inode->ei_update_lock);
+
+setversion_out:
+	inode_unlock(&inode->v);
+	mnt_drop_write_file(file);
+
+	return ret;
+}
+
 static int bch2_ioc_getlabel(struct bch_fs *c, char __user *user_label)
 {
 	int ret;
@@ -567,7 +615,7 @@ long bch2_fs_file_ioctl(struct file *file, unsigned cmd, unsigned long arg)
 		break;
 
 	case FS_IOC_SETVERSION:
-		ret = -ENOTTY;
+		ret = bch2_ioc_setversion(c, file, inode, (int __user *) arg);
 		break;
 
 	case FS_IOC_GETFSLABEL:
@@ -622,6 +670,9 @@ long bch2_compat_fs_ioctl(struct file *file, unsigned cmd, unsigned long arg)
 	case FS_IOC32_GETVERSION:
 		cmd = FS_IOC_GETVERSION;
 		break;
+	case FS_IOC32_SETVERSION:
+		cmd = FS_IOC_SETVERSION;
+		break;
 	case FS_IOC_GETFSLABEL:
 	case FS_IOC_SETFSLABEL:
 		break;
-- 
2.34.1


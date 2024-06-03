Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC0F012D754
	for <linux-bcachefs@vger.kernel.org>; Mon,  3 Jun 2024 13:25:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717421137; cv=none; b=rsYOAPST3o8IO7brJauXmsUjXNYkgbZe4nn4lS2e34bUKxSsS/+SSgFFvUG7nBV89+pE6oIZkKqMHBGPtxilQvj4AqtnZmPdxWlWgQkcIHLIJ+EIgcPwJYIVvbukh4q2RL2mWVISHAKRNVlb93iP9IZpE0xJkJcae/miFoijbJM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717421137; c=relaxed/simple;
	bh=VW/GPWpa8s+t3NbQpP8lohvhQ1sylnotaa72z9YaRa4=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=u0tkMEjxPKPa4g8Q6fomXS4P5caw8tK2mERRkMNWkRfIExskYi0DiYUx4sN2dfp8eprzjbnbz993A+r1+zh9ns6GLIyWL+7IUDFakid78A1v7Y4miK0Y3mAoWx+BNjIviXYzuS9BOO9Ukb6jqqYzi7vubeALIxffjgafjlGN2cY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.105])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4VtDrz481rzwRL7;
	Mon,  3 Jun 2024 21:21:39 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (unknown [7.185.36.66])
	by mail.maildlp.com (Postfix) with ESMTPS id BA533140382;
	Mon,  3 Jun 2024 21:25:18 +0800 (CST)
Received: from huawei.com (10.90.53.73) by dggpeml500022.china.huawei.com
 (7.185.36.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.39; Mon, 3 Jun
 2024 21:25:04 +0800
From: Hongbo Li <lihongbo22@huawei.com>
To: <kent.overstreet@linux.dev>, <bfoster@redhat.com>
CC: <linux-bcachefs@vger.kernel.org>, <lihongbo22@huawei.com>
Subject: [PATCH 3/3] bcachefs: support FS_IOC_SETFSLABEL
Date: Mon, 3 Jun 2024 21:26:20 +0800
Message-ID: <20240603132620.4027906-4-lihongbo22@huawei.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240603132620.4027906-1-lihongbo22@huawei.com>
References: <20240603132620.4027906-1-lihongbo22@huawei.com>
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

Implement support for FS_IOC_SETFSLABEL ioctl to set filesystem
label.

Signed-off-by: Hongbo Li <lihongbo22@huawei.com>
---
 fs/bcachefs/fs-ioctl.c | 40 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 40 insertions(+)

diff --git a/fs/bcachefs/fs-ioctl.c b/fs/bcachefs/fs-ioctl.c
index dace11ae1931..23427a877b9a 100644
--- a/fs/bcachefs/fs-ioctl.c
+++ b/fs/bcachefs/fs-ioctl.c
@@ -301,6 +301,41 @@ static int bch2_ioc_getlabel(struct bch_fs *c, char __user *user_label)
 	return ret ? -EFAULT : 0;
 }
 
+static int bch2_ioc_setlabel(struct bch_fs *c,
+			     struct file *file,
+			     struct bch_inode_info *inode,
+			     const char __user *user_label)
+{
+	int ret;
+	char label[BCH_SB_LABEL_SIZE];
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	if (copy_from_user(label, user_label, sizeof(label)))
+		return -EFAULT;
+
+	if (strnlen(label, BCH_SB_LABEL_SIZE) == BCH_SB_LABEL_SIZE) {
+		bch_err(c,
+			"unable to set label with more than %d bytes",
+			BCH_SB_LABEL_SIZE - 1);
+		return -EINVAL;
+	}
+
+	ret = mnt_want_write_file(file);
+	if (ret)
+		return ret;
+
+	mutex_lock(&c->sb_lock);
+	strscpy(c->disk_sb.sb->label, label, BCH_SB_LABEL_SIZE);
+	mutex_unlock(&c->sb_lock);
+
+	ret = bch2_write_super(c);
+
+	mnt_drop_write_file(file);
+	return ret;
+}
+
 static int bch2_ioc_goingdown(struct bch_fs *c, u32 __user *arg)
 {
 	u32 flags;
@@ -546,6 +581,10 @@ long bch2_fs_file_ioctl(struct file *file, unsigned cmd, unsigned long arg)
 		ret = bch2_ioc_getlabel(c, (void __user *) arg);
 		break;
 
+	case FS_IOC_SETFSLABEL:
+		ret = bch2_ioc_setlabel(c, file, inode, (const void __user *) arg);
+		break;
+
 	case FS_IOC_GOINGDOWN:
 		ret = bch2_ioc_goingdown(c, (u32 __user *) arg);
 		break;
@@ -591,6 +630,7 @@ long bch2_compat_fs_ioctl(struct file *file, unsigned cmd, unsigned long arg)
 		cmd = FS_IOC_GETVERSION;
 		break;
 	case FS_IOC_GETFSLABEL:
+	case FS_IOC_SETFSLABEL:
 		break;
 	default:
 		return -ENOIOCTLCMD;
-- 
2.34.1


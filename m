Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D4B112D755
	for <linux-bcachefs@vger.kernel.org>; Mon,  3 Jun 2024 13:25:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.255
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717421105; cv=none; b=twF1NiZ6sIoo7M/cFEkeeZL0v+dEbwxxQCg76KswSEvlUtIXeNYRo40ZT/nseFldedWpMvHDOEkezg+n12z/vihcV+z13wOmJIGiyNmhw92R/CVitDZvVge/wbzFHKeO+/gmE1/W7xZdboUFG7QresEji1lJR7Wrlk5mS8mXHFw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717421105; c=relaxed/simple;
	bh=YYtNrRc4RNxc3MzPszRzN3bDo623FyeBj7ZhFWTxrEE=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SfEdlfdropylI6yAqoNJovXVKeLNu4L7b5XnDf0P3CRbqPJLWdNUo5RdAHBF+ZJTaV7lEpA3prSy5lEDk4d5mNNKia5sJRIrnqomf7w4+4coKAAmxC0jEY3O6yIiObGRL+XnQRpral8IHNj6rWqC2Xk2Rn/4IgewakTrgXoqec0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.255
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.252])
	by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4VtDrM1KH7z1S97c;
	Mon,  3 Jun 2024 21:21:07 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (unknown [7.185.36.66])
	by mail.maildlp.com (Postfix) with ESMTPS id 2CE08180A9C;
	Mon,  3 Jun 2024 21:25:01 +0800 (CST)
Received: from huawei.com (10.90.53.73) by dggpeml500022.china.huawei.com
 (7.185.36.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.39; Mon, 3 Jun
 2024 21:25:00 +0800
From: Hongbo Li <lihongbo22@huawei.com>
To: <kent.overstreet@linux.dev>, <bfoster@redhat.com>
CC: <linux-bcachefs@vger.kernel.org>, <lihongbo22@huawei.com>
Subject: [PATCH 1/3] bcachefs: implement FS_IOC_GETVERSION to support lsattr
Date: Mon, 3 Jun 2024 21:26:18 +0800
Message-ID: <20240603132620.4027906-2-lihongbo22@huawei.com>
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

In this patch we add the FS_IOC_GETVERSION ioctl for getting
i_generation from inode, after that, users can list file's
generation number by using "lsattr".

Signed-off-by: Hongbo Li <lihongbo22@huawei.com>
---
 fs/bcachefs/fs-ioctl.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/fs/bcachefs/fs-ioctl.c b/fs/bcachefs/fs-ioctl.c
index 00334e8fa769..19ab28767208 100644
--- a/fs/bcachefs/fs-ioctl.c
+++ b/fs/bcachefs/fs-ioctl.c
@@ -272,6 +272,11 @@ static int bch2_ioc_reinherit_attrs(struct bch_fs *c,
 	return ret;
 }
 
+static int bch2_ioc_getversion(struct bch_inode_info *inode, u32 __user *arg)
+{
+	return put_user(inode->v.i_generation, arg);
+}
+
 static int bch2_ioc_goingdown(struct bch_fs *c, u32 __user *arg)
 {
 	u32 flags;
@@ -506,7 +511,7 @@ long bch2_fs_file_ioctl(struct file *file, unsigned cmd, unsigned long arg)
 		break;
 
 	case FS_IOC_GETVERSION:
-		ret = -ENOTTY;
+		ret = bch2_ioc_getversion(inode, (u32 __user *) arg);
 		break;
 
 	case FS_IOC_SETVERSION:
@@ -554,6 +559,9 @@ long bch2_compat_fs_ioctl(struct file *file, unsigned cmd, unsigned long arg)
 	case FS_IOC32_SETFLAGS:
 		cmd = FS_IOC_SETFLAGS;
 		break;
+	case FS_IOC32_GETVERSION:
+		cmd = FS_IOC_GETVERSION;
+		break;
 	default:
 		return -ENOIOCTLCMD;
 	}
-- 
2.34.1


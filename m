Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFEFB12D753
	for <linux-bcachefs@vger.kernel.org>; Mon,  3 Jun 2024 13:25:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717421123; cv=none; b=DHaWDYtzyLue2S175SllgjWAg8gPbgeLWNt2hk8+/dlZu5UwlUNwNnFW49GZOWs1rxZ51gBUQC5I47PAugGWQqQcDG9kaFRBsSewZ2GyEM6PQSPG/VxWojaa6NJb9wdYi75PdKMog6aU4sdcibfrm6QjbfX3ScxxpvUQmC3Ip/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717421123; c=relaxed/simple;
	bh=WIL2wdbmQ/X3n6o+3duvL/NPr8Xw+TaEgy+noFcPZHo=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Xp9B1lXpj5wU0MSDQFU3kmKk3DC2+oq8sEdElSvvUeBbftH0jq1EefMXpmJi/g2SbdcDUEZ0ep6/1nOZz9mbupWEX8/e9DUrveTvrSkmbpDFlANFLQNSgPDrLrqugaVn/+E2PsAeac9Iduc2PVWrBL+xpNS/VPBPZhF5q9dll2M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.105])
	by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4VtDsR2l1dzPn4C;
	Mon,  3 Jun 2024 21:22:03 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (unknown [7.185.36.66])
	by mail.maildlp.com (Postfix) with ESMTPS id B71C71403D2;
	Mon,  3 Jun 2024 21:25:03 +0800 (CST)
Received: from huawei.com (10.90.53.73) by dggpeml500022.china.huawei.com
 (7.185.36.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.39; Mon, 3 Jun
 2024 21:25:03 +0800
From: Hongbo Li <lihongbo22@huawei.com>
To: <kent.overstreet@linux.dev>, <bfoster@redhat.com>
CC: <linux-bcachefs@vger.kernel.org>, <lihongbo22@huawei.com>
Subject: [PATCH 2/3] bcachefs: support get fs label
Date: Mon, 3 Jun 2024 21:26:19 +0800
Message-ID: <20240603132620.4027906-3-lihongbo22@huawei.com>
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

Implement support for FS_IOC_GETFSLABEL ioctl to read filesystem
label.

Signed-off-by: Hongbo Li <lihongbo22@huawei.com>
---
 fs/bcachefs/fs-ioctl.c | 30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/fs/bcachefs/fs-ioctl.c b/fs/bcachefs/fs-ioctl.c
index 19ab28767208..dace11ae1931 100644
--- a/fs/bcachefs/fs-ioctl.c
+++ b/fs/bcachefs/fs-ioctl.c
@@ -277,6 +277,30 @@ static int bch2_ioc_getversion(struct bch_inode_info *inode, u32 __user *arg)
 	return put_user(inode->v.i_generation, arg);
 }
 
+static int bch2_ioc_getlabel(struct bch_fs *c, char __user *user_label)
+{
+	int ret;
+	size_t len;
+	char label[BCH_SB_LABEL_SIZE];
+
+	BUILD_BUG_ON(BCH_SB_LABEL_SIZE >= FSLABEL_MAX);
+
+	mutex_lock(&c->sb_lock);
+	memcpy(label, c->disk_sb.sb->label, BCH_SB_LABEL_SIZE);
+	mutex_unlock(&c->sb_lock);
+
+	len = strnlen(label, BCH_SB_LABEL_SIZE);
+	if (len == BCH_SB_LABEL_SIZE) {
+		bch_warn(c,
+			"label is too long, return the first %zu bytes",
+			--len);
+	}
+
+	ret = copy_to_user(user_label, label, len);
+
+	return ret ? -EFAULT : 0;
+}
+
 static int bch2_ioc_goingdown(struct bch_fs *c, u32 __user *arg)
 {
 	u32 flags;
@@ -518,6 +542,10 @@ long bch2_fs_file_ioctl(struct file *file, unsigned cmd, unsigned long arg)
 		ret = -ENOTTY;
 		break;
 
+	case FS_IOC_GETFSLABEL:
+		ret = bch2_ioc_getlabel(c, (void __user *) arg);
+		break;
+
 	case FS_IOC_GOINGDOWN:
 		ret = bch2_ioc_goingdown(c, (u32 __user *) arg);
 		break;
@@ -562,6 +590,8 @@ long bch2_compat_fs_ioctl(struct file *file, unsigned cmd, unsigned long arg)
 	case FS_IOC32_GETVERSION:
 		cmd = FS_IOC_GETVERSION;
 		break;
+	case FS_IOC_GETFSLABEL:
+		break;
 	default:
 		return -ENOIOCTLCMD;
 	}
-- 
2.34.1


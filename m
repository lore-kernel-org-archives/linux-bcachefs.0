Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33FDB67E62
	for <linux-bcachefs@vger.kernel.org>; Fri,  1 Mar 2024 06:39:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709275158; cv=none; b=jY4rBRhhBDVy7MDERs7n2uDjrecJgj4bVXnQMpE6xd8BNxlMUiilNrY9eFrLRCGu5xjf/Oow6WFxk3vA6zcZjI/BmHfybW8pOFheiGRpbyBrfNRU55hHkFUbEAueqv3YIjoUDVKLg8+2cLCDJmM2djXENHGCUPAqLuWFHUBHphc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709275158; c=relaxed/simple;
	bh=JiBSx5kAGfwhQWrF2TXQbw5Jg1jZJL8MO0V4BVTPVBI=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=qQTjJjy5PbC19wjXkGuHyNwJ4ogEEn3XyOjWn6eOh8E/N1q1mALAM6TAmIXqr0/AzTtEY4lpldHzk8pxkEC8DtgV4C2uIUXjOKyMKk8fz2dm0L/gQ5mnpB63uNdg49zAUY84xhC3Gks7Ju+Mh1Zo3JlRloZ/hIpApKFsnwH0cns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.252])
	by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4TmJL62byrzNlnQ;
	Fri,  1 Mar 2024 14:37:34 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (unknown [7.185.36.66])
	by mail.maildlp.com (Postfix) with ESMTPS id DDFB6180079;
	Fri,  1 Mar 2024 14:39:06 +0800 (CST)
Received: from huawei.com (10.90.53.73) by dggpeml500022.china.huawei.com
 (7.185.36.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.35; Fri, 1 Mar
 2024 14:39:06 +0800
From: Hongbo Li <lihongbo22@huawei.com>
To: <kent.overstreet@linux.dev>, <bfoster@redhat.com>
CC: <linux-bcachefs@vger.kernel.org>, <ruanjinjie@huawei.com>,
	<lihongbo22@huawei.com>
Subject: [PATCH v2] bcachefs: intercept mountoption value for bool type
Date: Fri, 1 Mar 2024 14:38:33 +0800
Message-ID: <20240301063833.1933506-1-lihongbo22@huawei.com>
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

For mount option with bool type, the value must be 0 or 1 (See
bch2_opt_parse). But this seems does not well intercepted cause
for other value(like 2...), it returns the unexpect return code
with error message printed.

Signed-off-by: Hongbo Li <lihongbo22@huawei.com>
---
v2:
  - refine code by adding private error code for non-bool option

v1: https://lore.kernel.org/linux-bcachefs/6606c887-7bf3-435a-ac6c-5008115607ae@huawei.com/T/#t
---
 fs/bcachefs/errcode.h | 1 +
 fs/bcachefs/opts.c    | 2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/bcachefs/errcode.h b/fs/bcachefs/errcode.h
index a8f1a3976305..47bafbd7707a 100644
--- a/fs/bcachefs/errcode.h
+++ b/fs/bcachefs/errcode.h
@@ -8,6 +8,7 @@
 	x(EINVAL,			mount_option)				\
 	x(BCH_ERR_mount_option,		option_name)				\
 	x(BCH_ERR_mount_option,		option_value)				\
+	x(BCH_ERR_mount_option,         option_not_bool)                        \
 	x(ENOMEM,			ENOMEM_stripe_buf)			\
 	x(ENOMEM,			ENOMEM_replicas_table)			\
 	x(ENOMEM,			ENOMEM_cpu_replicas)			\
diff --git a/fs/bcachefs/opts.c b/fs/bcachefs/opts.c
index 1db11c15b2b9..08ea0cfc4aef 100644
--- a/fs/bcachefs/opts.c
+++ b/fs/bcachefs/opts.c
@@ -314,7 +314,7 @@ int bch2_opt_parse(struct bch_fs *c,
 		if (ret < 0 || (*res != 0 && *res != 1)) {
 			if (err)
 				prt_printf(err, "%s: must be bool", opt->attr.name);
-			return ret;
+			return ret < 0 ? ret : -BCH_ERR_option_not_bool;
 		}
 		break;
 	case BCH_OPT_UINT:
-- 
2.34.1


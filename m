Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53FD93D0CA
	for <linux-bcachefs@vger.kernel.org>; Wed, 21 Feb 2024 09:37:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.191
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708508277; cv=none; b=eHY/HWnOpVzAJDrWXEKqsWuy7o2iAW7i/S/MDaihlXtIZazjEfWwXcw12lG1kGrKdIlWcQAFkZdHPuZPWV8hpmfPjg5UqG4w3Jp9ytiAe+sUjAaUgju27xBFU/Nd8Qwg87Zy6GsWbtEwyeXW5NDHoqkfFztjU8blMQaFFfcLjAI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708508277; c=relaxed/simple;
	bh=yO8GaWx3TzE4qkB8MGfeBSy+f6tNYuvYT22i1dwgYSo=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=ISjl+3yLAt+vW2XXNsQQE0nfsCzI+vrshzA0Jzppwye/PCDLPlFDRO1FysPBYZTotfG2wz9DLS0ydlDAS7zrnZV3kVBflgG8a+ssn37mei0obWvU+kyKtGmZbe+SABdiKMj8y4uEWSEdIgaUfj7D5N/mUqoiOAnHo40NCFQuhOg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.191
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.44])
	by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4Tfrjp1SQLz1h0Sp;
	Wed, 21 Feb 2024 17:35:42 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (unknown [7.185.36.66])
	by mail.maildlp.com (Postfix) with ESMTPS id D16021402CC;
	Wed, 21 Feb 2024 17:37:50 +0800 (CST)
Received: from huawei.com (10.90.53.73) by dggpeml500022.china.huawei.com
 (7.185.36.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Wed, 21 Feb
 2024 17:37:50 +0800
From: Hongbo Li <lihongbo22@huawei.com>
To: <kent.overstreet@linux.dev>, <bfoster@redhat.com>
CC: <linux-bcachefs@vger.kernel.org>, <ruanjinjie@huawei.com>,
	<lihongbo22@huawei.com>, <chris.zjh@huawei.com>
Subject: [PATCH] bcachefs: intercept mountoption value for bool type
Date: Wed, 21 Feb 2024 17:37:04 +0800
Message-ID: <20240221093704.3924287-1-lihongbo22@huawei.com>
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
 dggpeml500022.china.huawei.com (7.185.36.66)

For mount option with bool type, the value must be 0 or 1 (See
bch2_opt_parse). But this seems does not well intercepted cause
for other value(like 2...), it returns the unexpect return code
with error message printed.

Signed-off-by: Hongbo Li <lihongbo22@huawei.com>
---
 fs/bcachefs/opts.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/bcachefs/opts.c b/fs/bcachefs/opts.c
index b1ed0b9a20d3..fe1f17830694 100644
--- a/fs/bcachefs/opts.c
+++ b/fs/bcachefs/opts.c
@@ -314,7 +314,7 @@ int bch2_opt_parse(struct bch_fs *c,
 		if (ret < 0 || (*res != 0 && *res != 1)) {
 			if (err)
 				prt_printf(err, "%s: must be bool", opt->attr.name);
-			return ret;
+			return ret < 0 ?: -EINVAL;
 		}
 		break;
 	case BCH_OPT_UINT:
-- 
2.34.1


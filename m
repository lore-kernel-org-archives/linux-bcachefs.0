Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C29345C14
	for <linux-bcachefs@vger.kernel.org>; Thu, 26 Sep 2024 01:49:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727315400; cv=none; b=n9qZfsnOwckqMl0xatlCoHRIXFKRqZfANMfR8m6MsbgWfrKU+GlrfKDFKBC28XQhSRaRCb1/F/M3qzmzGLiyGdGeG+OHg/jyTx5BastX67+830Ku3MoCE/Qm3F+/7FD3Cv12lM1VkvRODbAmlROzktbBB18S7qYJgo2KEerv69I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727315400; c=relaxed/simple;
	bh=y4YBeaBfDlntQXah1nQJzsc5d1AFVsM020oKrRPxr3o=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=n25cSV2z5+NStH7i0TUQNuVjBwGnI28ykwbESmtGcmLV2Xw6+Bx7ZMcM3r+O/EiygTDESYf4M9merTvIxp23NL4HzO2gqVIt7WjaSAuINyHb1PamFxF+XA9CskHP3gDB2A+w2OVsPyPpOQQjKpOVGFKuMtnjKZIRq2YJ/Yl1hRY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.174])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4XDc1Q1p9KzpW6D;
	Thu, 26 Sep 2024 09:47:54 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (unknown [7.185.36.66])
	by mail.maildlp.com (Postfix) with ESMTPS id BC6BC14037E;
	Thu, 26 Sep 2024 09:49:56 +0800 (CST)
Received: from huawei.com (10.90.53.73) by dggpeml500022.china.huawei.com
 (7.185.36.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.39; Thu, 26 Sep
 2024 09:49:56 +0800
From: Hongbo Li <lihongbo22@huawei.com>
To: <kent.overstreet@linux.dev>
CC: <linux-bcachefs@vger.kernel.org>, <lihongbo22@huawei.com>,
	<chris.zjh@huawei.com>, <ddiss@suse.de>
Subject: [PATCH v2 2/2] bcachefs: fix incorrect show_options results
Date: Thu, 26 Sep 2024 10:00:01 +0800
Message-ID: <20240926020002.1746333-3-lihongbo22@huawei.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240926020002.1746333-1-lihongbo22@huawei.com>
References: <20240926020002.1746333-1-lihongbo22@huawei.com>
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

When call show_options in bcachefs, the options buffer is appeneded
to the seq variable. In fact, it requires an additional comma to be
appended first. This will affect the remount process when reading
existing mount options.

Fixes: 9305cf91d05e ("bcachefs: bch2_opts_to_text()")
Signed-off-by: Hongbo Li <lihongbo22@huawei.com>
---
 fs/bcachefs/fs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/bcachefs/fs.c b/fs/bcachefs/fs.c
index d6e26b5056f3..b42c293f71f8 100644
--- a/fs/bcachefs/fs.c
+++ b/fs/bcachefs/fs.c
@@ -1931,7 +1931,7 @@ static int bch2_show_options(struct seq_file *seq, struct dentry *root)
 	if (buf.allocation_failure)
 		ret = -ENOMEM;
 	else
-		seq_puts(seq, buf.buf);
+		seq_printf(seq, ",%s", buf.buf);
 
 	printbuf_exit(&buf);
 	return ret;
-- 
2.34.1


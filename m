Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE958762D2;
	Thu, 15 Aug 2024 14:13:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.191
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723731214; cv=none; b=qAufHwt3GMlEeVMb4raFq2e55pJgIdjkfrPaKe4KRUwGb193ygFSFdyy0iSqmucyzzFZaDpO+c3NP1VOicREtnhdjFbE+eua4ZvP3X/AE3YN0HOtvcmjmkvaXZuf55X7R+XygMrOEmOLXW9PH2rP3Va3U+POJE/Ye/A+s0+TUT4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723731214; c=relaxed/simple;
	bh=FqoqARnlHZOGk9aeGCyPW1Ynteoqm9vojr5fxezkawE=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=e4w+SVCWuqXWYfHO089zittHmZL5aWjHY1q9zvGOvJeJlwGxFZNewEXR4YsvA6pQLYLmSNmUaEhU9sr1pYv1rDjoZdeaPo9RIRmKgKwBle2vYYpHJm8v8Eq7wxF/iB3GElF2+rLwfheCGHXTUeAjmsCwCHI89f2G2QrBpESVxJs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.191
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.234])
	by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4Wl6RQ4BlLz1j6Tl;
	Thu, 15 Aug 2024 22:08:34 +0800 (CST)
Received: from kwepemd500012.china.huawei.com (unknown [7.221.188.25])
	by mail.maildlp.com (Postfix) with ESMTPS id D8E3014040F;
	Thu, 15 Aug 2024 22:13:27 +0800 (CST)
Received: from huawei.com (10.90.53.73) by kwepemd500012.china.huawei.com
 (7.221.188.25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1258.34; Thu, 15 Aug
 2024 22:13:27 +0800
From: Li Zetao <lizetao1@huawei.com>
To: <kent.overstreet@linux.dev>
CC: <lizetao1@huawei.com>, <linux-bcachefs@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
Subject: [PATCH -next] bcachefs: support iopoll method
Date: Thu, 15 Aug 2024 22:20:34 +0800
Message-ID: <20240815142034.1561661-1-lizetao1@huawei.com>
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
 kwepemd500012.china.huawei.com (7.221.188.25)

When bcachefs uses io_uring, implement the iopoll method to support
IORING_SETUP_IOPOLL.

Signed-off-by: Li Zetao <lizetao1@huawei.com>
---
 fs/bcachefs/fs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/bcachefs/fs.c b/fs/bcachefs/fs.c
index c50457ba808d..c97bc94fcb83 100644
--- a/fs/bcachefs/fs.c
+++ b/fs/bcachefs/fs.c
@@ -1213,6 +1213,7 @@ static const struct file_operations bch_file_operations = {
 	.llseek		= bch2_llseek,
 	.read_iter	= bch2_read_iter,
 	.write_iter	= bch2_write_iter,
+	.iopoll		= iocb_bio_iopoll,
 	.mmap		= bch2_mmap,
 	.get_unmapped_area = thp_get_unmapped_area,
 	.fsync		= bch2_fsync,
-- 
2.34.1


Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB28E1D86D2
	for <linux-bcachefs@vger.kernel.org>; Tue,  5 Nov 2024 14:22:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730816573; cv=none; b=AIGQJ4eHAvUlnEZdYwSbDOQraPMdNQ5addtaeQdreogceK6b22Gf9a81Lg1230wx52RS0YN9voThTK2GeRJBiwU1oip8JizbmOHbTDi3FKabM7ct2mVWc5erxOOuImdVhja+I11T8qQOk+OrRcCoVHcLXv2w5l1J1NL8xKZzSyo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730816573; c=relaxed/simple;
	bh=IU5EslNcHopUSrHO5u06uQY/ykSQDTKUWdKP0JUL+Kg=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=BrLXV+F6Pxq+f4Q+2Fhd/5MHOqUMO1O00o+vlEVBp6AEhZ/1tOrqqpguZft2Ec+KA9cbpS80rSLA37mie2gCd42QBEY8UyyzlsyRNfOFeNCwehw0lK/I+EnnK3OemUMG2DsI8HFiHqF6jvtW82fzSCD7kehv/jOH9HjCF1byIuU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.194])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4XjVpz22GjzfdZx;
	Tue,  5 Nov 2024 22:20:11 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (unknown [7.185.36.66])
	by mail.maildlp.com (Postfix) with ESMTPS id BF4C51400CF;
	Tue,  5 Nov 2024 22:22:47 +0800 (CST)
Received: from huawei.com (10.90.53.73) by dggpeml500022.china.huawei.com
 (7.185.36.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.39; Tue, 5 Nov
 2024 22:22:47 +0800
From: Hongbo Li <lihongbo22@huawei.com>
To: <kent.overstreet@linux.dev>
CC: <linux-bcachefs@vger.kernel.org>, <lihongbo22@huawei.com>
Subject: [PATCH] bcachefs: fix io_read/write counter with wrong unit
Date: Tue, 5 Nov 2024 22:22:24 +0800
Message-ID: <20241105142224.2252301-1-lihongbo22@huawei.com>
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

In bcachefs, io_read and io_write counter record the amount
of data which has been read and written. They increase in
unit of sector, so to display correctly, they need to be
shifted to the left by the size of a sector.

Fixes: 1c6fdbd8f246 ("bcachefs: Initial commit")
Signed-off-by: Hongbo Li <lihongbo22@huawei.com>
---
When I read one 15.7M file, the io_read sysfs interface shows:
- Before this patch
  - original:
    since mount:                   0 B
    since filesystem creation:     5.11 KiB

  - after read:
    since mount:                   31.4 KiB
    since filesystem creation:     36.5 KiB

- After this patch:
  - original:
    since mount:                   0 B
    since filesystem creation:     18.3 MiB

  - after read:
    since mount:                   15.7 MiB
    since filesystem creation:     34.0 MiB
---
 fs/bcachefs/sysfs.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/bcachefs/sysfs.c b/fs/bcachefs/sysfs.c
index 97733c766948..aa46b69da4d8 100644
--- a/fs/bcachefs/sysfs.c
+++ b/fs/bcachefs/sysfs.c
@@ -513,6 +513,11 @@ SHOW(bch2_fs_counters)
 		if (attr == &sysfs_##t) {					\
 			counter             = percpu_u64_get(&c->counters[BCH_COUNTER_##t]);\
 			counter_since_mount = counter - c->counters_on_mount[BCH_COUNTER_##t];\
+			if (attr == &sysfs_io_read || attr == &sysfs_io_write) {\
+				counter <<= 9;					\
+				counter_since_mount <<= 9;			\
+			}							\
+										\
 			prt_printf(out, "since mount:\t");			\
 			prt_human_readable_u64(out, counter_since_mount);	\
 			prt_newline(out);					\
-- 
2.34.1


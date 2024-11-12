Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C67AC1990AF
	for <linux-bcachefs@vger.kernel.org>; Tue, 12 Nov 2024 07:48:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731397692; cv=none; b=f7+CeGfiLBvIwIgt/dIAZ59WpmFXYGmgZS3lfeerp4i+nktFSTgu4GbyuBqJzwObsSxThj9CFf9anzy0ncBeq549WNMbO8G8jufx9rpTCseEUEp2PIkLhm1dbW7ga394qgK7g6pcSj1A0laiiL8TH7f2CNDDtGq2FI+lMs/srPs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731397692; c=relaxed/simple;
	bh=Gh/1QjBnZAm7C3GcpS9hIsMZ2sRfaROj9aPawe1la10=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=XzgibBs4C2cE3NVTsQw29V9QjMefdjPZX3i+BomoyaHUdbnqcTBwlCiCqUCeRwuWAU2NjuEl55l/p//rKfoFsTylyHiIfLvynjfi7Yu3w97IjKneqp997xd55NV4xr0SUBWChrolBTe4rJ+UhRHXONaUvOyWLg/1u04k5Sfu7S4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.162.254])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4XndkT685jz10Qw7;
	Tue, 12 Nov 2024 15:45:37 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (unknown [7.185.36.66])
	by mail.maildlp.com (Postfix) with ESMTPS id BD621180104;
	Tue, 12 Nov 2024 15:48:05 +0800 (CST)
Received: from huawei.com (10.90.53.73) by dggpeml500022.china.huawei.com
 (7.185.36.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.39; Tue, 12 Nov
 2024 15:48:05 +0800
From: Hongbo Li <lihongbo22@huawei.com>
To: <kent.overstreet@linux.dev>
CC: <linux-bcachefs@vger.kernel.org>, <lihongbo22@huawei.com>
Subject: [PATCH v2 0/3] bcachefs: add and use printbuf_err helper
Date: Tue, 12 Nov 2024 15:47:42 +0800
Message-ID: <20241112074745.407848-1-lihongbo22@huawei.com>
X-Mailer: git-send-email 2.34.1
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

Add printbuf_err helper to return standard error when
allocation failure.

v2:
  - add printbuf_err helper and use it.

v1: https://lore.kernel.org/all/20240926020002.1746333-2-lihongbo22@huawei.com/

Hongbo Li (3):
  bcachefs: add printbuf_err helper
  bcachefs: avoid copy from NULL printbuf when allocation failure
  bcachefs: use printbuf_err helper

 fs/bcachefs/fs.c       | 9 +++++++--
 fs/bcachefs/opts.c     | 7 +------
 fs/bcachefs/printbuf.h | 7 +++++++
 fs/bcachefs/sysfs.c    | 4 +---
 4 files changed, 16 insertions(+), 11 deletions(-)

-- 
2.34.1


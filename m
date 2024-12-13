Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 685778F5E
	for <linux-bcachefs@vger.kernel.org>; Fri, 13 Dec 2024 04:03:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734062605; cv=none; b=URhAxbSKnCAXuXwz/bbfh2n2Cb0miJlKgy8IcA7So+RiEP2KtZfR0zZ8txqZsM6u3iwiaPqhFr/B+TmSe9P6iIqMmekn/gvYno9SAcjwxJWKPOobX28N/UY+VdQsRNbXWCLB0X1Tp4voi7UO7nJUpjYj5Yjypcpr+gcwq89RAkM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734062605; c=relaxed/simple;
	bh=MG5F705ibAWrza9t/v4f48vHACZgiV1GinHDBAS/prg=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=q3Ngm3ebjWydw/XCwUQzTpXCD8d4/w4FThJo1pE6FlvOYW0hnLo8fVtHazQuM89ISHaYh7rF3a7RJBSuRZPjzgEglH99SlMdNnntbT9r1pKT0TeRFyCBdaLrikQm4L5LLduqBCHbmSIGNDXgCPzbw1myRu7+vxV1MHhz81Tepuo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.162.254])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4Y8bG33L44z11MK8;
	Fri, 13 Dec 2024 12:00:11 +0800 (CST)
Received: from kwepemo500009.china.huawei.com (unknown [7.202.194.199])
	by mail.maildlp.com (Postfix) with ESMTPS id 98519180101;
	Fri, 13 Dec 2024 12:03:19 +0800 (CST)
Received: from huawei.com (10.90.53.73) by kwepemo500009.china.huawei.com
 (7.202.194.199) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Fri, 13 Dec
 2024 12:03:19 +0800
From: Hongbo Li <lihongbo22@huawei.com>
To: <kent.overstreet@linux.dev>
CC: <lihongbo22@huawei.com>, <linux-bcachefs@vger.kernel.org>
Subject: [PATCH v3 0/3] bcachefs: add and use printbuf_err helper
Date: Fri, 13 Dec 2024 12:03:25 +0800
Message-ID: <20241213040328.2921159-1-lihongbo22@huawei.com>
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
 kwepemo500009.china.huawei.com (7.202.194.199)

Add printbuf_err helper to return standard error when
allocation failure.

v3:
  - Remove extra sign-off and rebase the code.

v2: https://lore.kernel.org/linux-bcachefs/20241112074745.407848-1-lihongbo22@huawei.com/
  - add printbuf_err helper and use it.

v1: https://lore.kernel.org/all/20240926020002.1746333-2-lihongbo22@huawei.com/

Hongbo Li (3):
  bcachefs: add printbuf_err helper
  bcachefs: avoid copy from NULL printbuf when allocation failure
  bcachefs: use printbuf_err helper

 fs/bcachefs/fs.c       | 9 +++++++--
 fs/bcachefs/opts.c     | 7 +------
 fs/bcachefs/printbuf.h | 5 +++++
 fs/bcachefs/sysfs.c    | 4 +---
 4 files changed, 14 insertions(+), 11 deletions(-)

-- 
2.34.1


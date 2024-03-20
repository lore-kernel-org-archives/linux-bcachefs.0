Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2968D22075
	for <linux-bcachefs@vger.kernel.org>; Wed, 20 Mar 2024 06:29:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.190
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710916192; cv=none; b=ksPgbDWOmQkfJGKGBTkSq2nnzc8hrVTqmHIgVz18UmFj31bYaHRXyGGVIA4bBiWUSDWEHg/dF8M38SdzrG9BdKgK6iXg3m7L4OQtrPLxYn9rtl8Pg/aa5730hX6q4zY0D9vGjbj5RyAvp6nDq+xKtyji8Zb0a+qcJ0uEu38v15M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710916192; c=relaxed/simple;
	bh=yGJ2ChLinTqtvTpiBd7c3K2j7JwMTq9nBGO9rVjjuls=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=B3b1sy/qpsz2evZoNtA8FUVkpffSX79cLxiNfXNDIJEut+Z5lC/PAsSMTZ0DF3GmkpjXEHB8M/zlqV1gmdQK9yZLtsXqh4Nzyf3zxEMOAYcY1v/jPVsBdkFiW3s2XYCs9/gPsdcNu9AFfsssnCoXAeFprNUdoIRE6CGhLfIPEl0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.190
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.44])
	by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4TzzD94Gyqz1xs3n;
	Wed, 20 Mar 2024 14:27:53 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (unknown [7.185.36.66])
	by mail.maildlp.com (Postfix) with ESMTPS id 48AF8140411;
	Wed, 20 Mar 2024 14:29:46 +0800 (CST)
Received: from huawei.com (10.90.53.73) by dggpeml500022.china.huawei.com
 (7.185.36.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.35; Wed, 20 Mar
 2024 14:29:46 +0800
From: Hongbo Li <lihongbo22@huawei.com>
To: <kent.overstreet@linux.dev>, <bfoster@redhat.com>
CC: <linux-bcachefs@vger.kernel.org>, <lihongbo22@huawei.com>
Subject: [PATCH RFC 0/2] bcachefs: refactoring of btree_path status
Date: Wed, 20 Mar 2024 14:29:21 +0800
Message-ID: <20240320062923.305431-1-lihongbo22@huawei.com>
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

To enhance the code readability about btree_path structure, we did 
some refactoring on the relevant code based on my understanding.

Hongbo Li (2):
  bcachefs: use btree_path_state to represent btree_path status
  bcachefs: optimize btree_path status representation

 fs/bcachefs/btree_iter.c         | 22 +++++++++++-----------
 fs/bcachefs/btree_iter.h         | 13 +++++++++----
 fs/bcachefs/btree_key_cache.c    | 12 ++++++------
 fs/bcachefs/btree_locking.c      | 14 +++++++-------
 fs/bcachefs/btree_locking.h      |  8 ++++----
 fs/bcachefs/btree_trans_commit.c |  2 +-
 fs/bcachefs/btree_types.h        | 10 +++++-----
 7 files changed, 43 insertions(+), 38 deletions(-)

-- 
2.34.1


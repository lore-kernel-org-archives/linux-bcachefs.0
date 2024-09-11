Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2675717BA6
	for <linux-bcachefs@vger.kernel.org>; Wed, 11 Sep 2024 01:02:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726016563; cv=none; b=DjTyjQD3L5xroYwhtGF4rcgPPH76/8jJarMKW1Iy1lZtcWPB8ii+zypEhi1L4+kauyC5RHcHIdNeaFAOrdcfS0KH9ovgNStIAK7/b5hngDpydWgKuCQqsC84xQqwcVgrrVoFSjo0THI+VlK9yww5EJGL1LLE87K1XV46bHbqV+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726016563; c=relaxed/simple;
	bh=pBeR8xwCBSE6zD+sRJVrl+en+ivGBg0+ug/XYwbmw0s=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=S702LEESrffAHRW5CLJ2FFvztIx8z3odoWWhzIhApqfcW8EO1fzIUmZge22CLwAlh0vhaaGyf4vP2IEUCy35dIDE3X8yVLkdS84Oa7xkJnLWZm+mlRnY9NajI9fhoShCQWDd4nOQqroEH+AaEH8Wq+buMV6W9RIdUg9rqqw5A+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.105])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4X3Mgn3HnJzpVfl;
	Wed, 11 Sep 2024 09:00:37 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (unknown [7.185.36.66])
	by mail.maildlp.com (Postfix) with ESMTPS id 206CD1402C8;
	Wed, 11 Sep 2024 09:02:40 +0800 (CST)
Received: from huawei.com (10.90.53.73) by dggpeml500022.china.huawei.com
 (7.185.36.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.39; Wed, 11 Sep
 2024 09:02:39 +0800
From: Hongbo Li <lihongbo22@huawei.com>
To: <kent.overstreet@linux.dev>
CC: <linux-bcachefs@vger.kernel.org>, <lihongbo22@huawei.com>,
	<chris.zjh@huawei.com>
Subject: [PATCH v2 0/2] bcachefs: make directory i_size meaningful
Date: Wed, 11 Sep 2024 09:11:40 +0800
Message-ID: <20240911011142.741429-1-lihongbo22@huawei.com>
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

The isize of directory is 0 in bcachefs if the directory is empty.
With more child dirents created, its size ought to change. Many
other filesystems changed as that (ie. xfs and btrfs). And many of
them changed as the size of child dirent name. Although the directory
size may not seem to convey much, we can still give it some meaning.

The formula of dentry size as follow:
    occupied_size = 40 + ALIGN(9 + namelen, 8)

To ensure compatibility with the old file system, we have implemented
the check_directory_size in fsck which checks whether the size of
directories matches the expected values during each fsck operation.
To achieve this, we have introduced a new metadata version called
'directory_size' to support this feature. We have conducted the
following tests:
  1. Creating and deleting subitems under the new file system;
  2. Upgrading from the old file system to the new one;

And the directory size feature works well.

Changes since v1: https://lore.kernel.org/all/2sjq2njetbhhqo2zuufrjuarzvo4jl2pid52idwdz45h7li4bm@throc6jwnckk/T/#m3fcb3fbdc17719523285030b9998722df0472ae3
  - Add check_directory_size in fsck period.

Hongbo Li (2):
  bcachefs: make directory i_size meaningful
  bcachefs: bcachefs_metadata_version_directory_size

 fs/bcachefs/bcachefs_format.h  |  3 ++-
 fs/bcachefs/dirent.h           |  5 +++++
 fs/bcachefs/fs-common.c        | 11 +++++++++
 fs/bcachefs/fs.c               | 13 ++++++-----
 fs/bcachefs/fsck.c             | 41 ++++++++++++++++++++++++++++++++++
 fs/bcachefs/sb-downgrade.c     |  5 ++++-
 fs/bcachefs/sb-errors_format.h |  1 +
 7 files changed, 72 insertions(+), 7 deletions(-)

-- 
2.34.1


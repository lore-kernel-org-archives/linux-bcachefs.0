Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C46401DF749
	for <linux-bcachefs@vger.kernel.org>; Tue,  7 Jan 2025 13:27:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736256457; cv=none; b=YsPdqnCtTLx8z0pKFIWQccwL7/5fUsucxe+5DriI0RRNSQbJ+rZS/ZktMMEvm6OgBLCGD2xEFHUO1oPms5MRtaHCair6WfdOlByi6+VsjtcEiH3b2ngpn68vQeNrNe2farq35T9DlV+xZ0UH/NuafsOYUKymOT4iea7t2VD+VMM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736256457; c=relaxed/simple;
	bh=rys4wRX8SCcMIUyK28n51emZUACkG6EOFDDO7GB182k=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=MEKInmFuixHYWTE52iI1sd73vlBOXI88lmJsKeVFyoA4od17b7VsTT1fwtH46dGC36/W2Oh/CrBRVPhtIO3sPOPoj+qa9y5LaEg4NsHBavaG8NKkJp6jJGdubD2UK9nJ0JrlqlEqWO6qWHofXsJwWWOTy/m4wpj1SXO5e058wF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.252])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4YSBZt74JNzxWtG;
	Tue,  7 Jan 2025 21:23:50 +0800 (CST)
Received: from kwepemo500009.china.huawei.com (unknown [7.202.194.199])
	by mail.maildlp.com (Postfix) with ESMTPS id E4EAF1800CB;
	Tue,  7 Jan 2025 21:27:31 +0800 (CST)
Received: from huawei.com (10.67.174.162) by kwepemo500009.china.huawei.com
 (7.202.194.199) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Tue, 7 Jan
 2025 21:27:31 +0800
From: Hongbo Li <lihongbo22@huawei.com>
To: <kent.overstreet@linux.dev>
CC: <linux-bcachefs@vger.kernel.org>, <lihongbo22@huawei.com>
Subject: [PATCH v3 0/2] bcachefs: make directory i_size meaningful
Date: Tue, 7 Jan 2025 13:18:39 +0000
Message-ID: <20250107131841.91603-1-lihongbo22@huawei.com>
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
 kwepemo500009.china.huawei.com (7.202.194.199)

The isize of directory is 0 in bcachefs if the directory is empty.
With more child dirents created, its size ought to change. Many
other filesystems changed as that (ie. xfs and btrfs). And many of
them changed as the size of child dirent name. Although the directory
size may not seem to convey much, we can still give it some meaning.

The formula of dentry size as follow:
    occupied_size = 40 + ALIGN(9 + namelen, 8)  // not include the '\0'

To ensure compatibility with the old file system, we have implemented
the check_directory_size in fsck which checks whether the size of
directories matches the expected values during each fsck operation.
To achieve this, we have introduced a new metadata version called
'directory_size' to support this feature. We have conducted the
following tests:
  1. Creating and deleting subitems under the new file system;
  2. Upgrading from the old file system to the new one;

And the directory size feature works well.

Changes since v2: https://lore.kernel.org/linux-bcachefs/20240911011142.741429-2-lihongbo22@huawei.com/
  - Rebase the code on testing branch.

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
 fs/bcachefs/sb-errors_format.h |  3 ++-
 7 files changed, 73 insertions(+), 8 deletions(-)

-- 
2.34.1


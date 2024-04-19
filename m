Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DC9544C65
	for <linux-bcachefs@vger.kernel.org>; Fri, 19 Apr 2024 07:48:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713512936; cv=none; b=g3dvsvylvBfciQtaEF4tTRJW0GkzdEd/3uR00MBYhw2e5weVIQCEmfunzjM7dBB8Vh4l1oqmhfXeBrbs5XIR1JZfpPTKsqb53mP9z/NAJB+YfCkn4GkhEjNZ7EncMTpIL6dWctjpz4yE4RAeLxI77bdE8QEEtJrihdjbN624JFs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713512936; c=relaxed/simple;
	bh=SZ8QG7GGuQXwhir9PKfmogt8rc610e0Mm0XBum+/Mog=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=jAa+RQxsXbope7b/nWCzu1Vpy3+rl13J7mhWXZ4J4Wuh/vIY3dJAvopXSMX9/FRoWyYJD4yfGuo3RqDQcROe9N7CfmdeP26Iln/LVa0KM17AVcEX6C0ohpY4O4JpUZ2q+JYZ00ENzBXgsX2r1dfI29qnD6q/D5PB40lECuLYF6g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.162.254])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4VLRZW3TkMzJt70;
	Fri, 19 Apr 2024 15:47:47 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (unknown [7.185.36.66])
	by mail.maildlp.com (Postfix) with ESMTPS id 49F3918007D;
	Fri, 19 Apr 2024 15:48:47 +0800 (CST)
Received: from huawei.com (10.90.53.73) by dggpeml500022.china.huawei.com
 (7.185.36.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.35; Fri, 19 Apr
 2024 15:48:47 +0800
From: Hongbo Li <lihongbo22@huawei.com>
To: <kent.overstreet@linux.dev>, <bfoster@redhat.com>
CC: <linux-bcachefs@vger.kernel.org>, <lihongbo22@huawei.com>
Subject: [PATCH 0/2] eliminate the uninitialized compilation warning
Date: Fri, 19 Apr 2024 15:48:49 +0800
Message-ID: <20240419074851.1583392-1-lihongbo22@huawei.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpeml500022.china.huawei.com (7.185.36.66)

Eliminating the uninitialized compilation warning in bcachefs-tools.

Hongbo Li (2):
  bcachefs: eliminate the uninitialized compilation warning in
    bch2_reconstruct_snapshots
  bcachefs: eliminate the uninitialized compilation warning in
    __do_six_trylock

 fs/bcachefs/six.c      | 6 ++----
 fs/bcachefs/snapshot.c | 5 ++++-
 2 files changed, 6 insertions(+), 5 deletions(-)

-- 
2.34.1


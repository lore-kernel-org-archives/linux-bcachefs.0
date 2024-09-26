Received: from szxga07-in.huawei.com (szxga07-in.huawei.com [45.249.212.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33D69C125
	for <linux-bcachefs@vger.kernel.org>; Thu, 26 Sep 2024 01:50:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.35
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727315402; cv=none; b=ofDngLvHRYpdSoKGi/WYyktJ4Qp4Fwd5lYHncsNRtiK35T9Tjgq6xyDgi+seIqpdfj+85ubP3uHBvPcKfGBw7k5Kd8KNrCACx1hzx1pigaWc7NlOfR60tSKCzb7xQmjgUanEQsa366gM0V66kFJ5ZgcPfhsytSAud9XYDUBZ0SA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727315402; c=relaxed/simple;
	bh=hps61kIJ3jXmQn1B81acS1jhStieSHfK0stHh1ZuX4o=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=ZlKdYs3kisnyYwLM4f9GuMOyTUQpDvQh41WRrZrLRLNOzLmpW2NylIWtt76XeA9WNuFb4eoYfGMmo9UwczdlAZ5Qeopx5BLk06HGNRtPF0eWJO/H64Ft0oOMRNMr3bk3kCssQ0FOf95SrToya8bD9M+J34Lh/16eEHhs7MlH01M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.163])
	by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4XDc2l6Jk2z1SBsD;
	Thu, 26 Sep 2024 09:49:03 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (unknown [7.185.36.66])
	by mail.maildlp.com (Postfix) with ESMTPS id 9E713180043;
	Thu, 26 Sep 2024 09:49:52 +0800 (CST)
Received: from huawei.com (10.90.53.73) by dggpeml500022.china.huawei.com
 (7.185.36.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.39; Thu, 26 Sep
 2024 09:49:52 +0800
From: Hongbo Li <lihongbo22@huawei.com>
To: <kent.overstreet@linux.dev>
CC: <linux-bcachefs@vger.kernel.org>, <lihongbo22@huawei.com>,
	<chris.zjh@huawei.com>, <ddiss@suse.de>
Subject: [PATCH v2 0/2] bcachefs: fixes in show_options helper
Date: Thu, 26 Sep 2024 09:59:59 +0800
Message-ID: <20240926020002.1746333-1-lihongbo22@huawei.com>
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

There are two bug in show_options. The one is when printbuf
is allocated failed, no need to copy buffer to seq. Another
is when the option is filled into seqfile, an additional comma
should be appended first. Considering these are two distinct
issues, they have been divided into two separate commits here.

Changes since v1:
  - Put the two related patches together and do the rebase.
  - Adjust the commit msg ahout Fixes tag.

Hongbo Li (2):
  bcachefs: avoid copy from NULL printbuf
  bcachefs: fix incorrect show_options results

 fs/bcachefs/fs.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

-- 
2.34.1


Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90D1612D219
	for <linux-bcachefs@vger.kernel.org>; Mon,  3 Jun 2024 13:25:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717421103; cv=none; b=tOgClOnfoFiX3skbZtx9T9XA4opFP0RNDWb0WjfTJ5pMYQH0lOCqTiSfiKBEwjjA74CBYA8+fRnAKUOMlA93j1355dEkm16jdqstJOurF183vKpiFKNl35liYKz1iNzMW19voz36QrEV5T/FT/3hNUKPG02e34SeoFfEcNdxYbM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717421103; c=relaxed/simple;
	bh=UeQFln4k0Nz6awLScg1fTgilKHe66+oD/RU8q61Dg6s=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=aldAydGebYa5n5mXi/9rmaOXEFzMWaTP4Cycy3s80f5pqjAVrpvfFbI785wKvqrCVlWEGHkvYUG9Rj3YBjJz7Bk4Uap1kqWaIJ+TgLnVBgwOd3MsNrVHSb+FMH9dQslFin6D/emAhplSC1WRdGpbgTl6K1khjyR9XBjIJJwT/EQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.48])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4VtDqc4ybKzmXNR;
	Mon,  3 Jun 2024 21:20:28 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (unknown [7.185.36.66])
	by mail.maildlp.com (Postfix) with ESMTPS id 014B418007C;
	Mon,  3 Jun 2024 21:24:59 +0800 (CST)
Received: from huawei.com (10.90.53.73) by dggpeml500022.china.huawei.com
 (7.185.36.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.39; Mon, 3 Jun
 2024 21:24:58 +0800
From: Hongbo Li <lihongbo22@huawei.com>
To: <kent.overstreet@linux.dev>, <bfoster@redhat.com>
CC: <linux-bcachefs@vger.kernel.org>, <lihongbo22@huawei.com>
Subject: [PATCH 0/3] introduce getversion, getfslabel, setfslabel ioctls
Date: Mon, 3 Jun 2024 21:26:17 +0800
Message-ID: <20240603132620.4027906-1-lihongbo22@huawei.com>
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

GETVERSION: to support lsattr command.
GETFSLABEL: to get fslabel by ioctl.
SETFSLABEL: to set fslabel by ioctl.

Hongbo Li (3):
  bcachefs: implement FS_IOC_GETVERSION to support lsattr
  bcachefs: support get fs label
  bcachefs: support FS_IOC_SETFSLABEL

 fs/bcachefs/fs-ioctl.c | 80 +++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 79 insertions(+), 1 deletion(-)

-- 
2.34.1


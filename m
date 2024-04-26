Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF9652F36
	for <linux-bcachefs@vger.kernel.org>; Fri, 26 Apr 2024 03:21:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.255
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714101682; cv=none; b=U2x1I7QPCeQL8pAiI14j46vNVMnPV1DQZujbgFY9Q5KOj+TCwSCNXVISJOsIwIpGQsPzkIRMCabLJSZDcRRBzj5EdGtrcPhYOABDvuK/U9aTeaFEATsZ4ZMrVSnqPJ32g52VpAf2Egm52A1uTgGHfFpkkH3G7NirZyNEE+KAvsE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714101682; c=relaxed/simple;
	bh=ZK0d4zsKFfSHayxjxOlJ1mJ6sFW2XKpE+ykpYjYqAjI=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=GisDMSQzBx5JVcs6S5V2OYE9m5T32YoDTs8xTReD8AwvsoBpUHO2nE4UdbR1dksrArcGmiFX2d8sM6f2eHfeDUbs9+ZCDZdrFgTvBaKV0oEX0T4+iXUBmt+dL5hzkH0B42BZLjVV+YGhEXBCgVs/WQrlNE4TM36UshnWaRlcTWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.255
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.48])
	by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4VQdGF2Pv2z1R9jD;
	Fri, 26 Apr 2024 11:18:13 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (unknown [7.185.36.66])
	by mail.maildlp.com (Postfix) with ESMTPS id 0D4C718007A;
	Fri, 26 Apr 2024 11:21:17 +0800 (CST)
Received: from huawei.com (10.90.53.73) by dggpeml500022.china.huawei.com
 (7.185.36.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.35; Fri, 26 Apr
 2024 11:21:16 +0800
From: Hongbo Li <lihongbo22@huawei.com>
To: <kent.overstreet@linux.dev>, <bfoster@redhat.com>
CC: <linux-bcachefs@vger.kernel.org>, <lihongbo22@huawei.com>
Subject: [PATCH v2 0/2] eliminate the uninitialized compilation warning
Date: Fri, 26 Apr 2024 11:21:34 +0800
Message-ID: <20240426032136.2551471-1-lihongbo22@huawei.com>
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

 fs/bcachefs/six.c      | 5 ++---
 fs/bcachefs/snapshot.c | 3 ++-
 2 files changed, 4 insertions(+), 4 deletions(-)

-- 
2.34.1


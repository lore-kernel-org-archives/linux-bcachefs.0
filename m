Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 785281662E2
	for <linux-bcachefs@vger.kernel.org>; Fri, 12 Jul 2024 09:41:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720777297; cv=none; b=t4IHqZNmVHOy6XpndZSVNXLbeCzO72LvDh9bxgzkKT/OnYBKnP2yjRgxz4n3LTnnL+xw5nOxWWIRxdoOgZ5EyqNwv74yfzpB1YNs1vhKeef/FEZ6o/CsPdOZ2WR12caCDLOeAw7J/PLf1yTMbtKaWl4OaBSJt58d27CkZudwF1s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720777297; c=relaxed/simple;
	bh=wlxRJ4s07yqVbccbJb0DrRUQtWG7kS8pKgwm/5ahJkQ=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:CC:Content-Type; b=aB1on1qwaO4DQOfFQ8rwpSyVOty6EysytDquyGNOYbPrTJTTwSM8Pu9H4r1ukkATpALl4IM7HkxSIBDlh5D1S6IQRoL/eokfijxUiGvsNjXElZmQvjBd0Qe2jqUiNOF2dHxnESypgbQ8HobZPqB2lTdCBRQoIkoltSBwvv54GME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.194])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4WL61f3pfXzxWGS;
	Fri, 12 Jul 2024 17:36:54 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (unknown [7.185.36.66])
	by mail.maildlp.com (Postfix) with ESMTPS id CD605140B23;
	Fri, 12 Jul 2024 17:41:31 +0800 (CST)
Received: from [10.67.111.104] (10.67.111.104) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Fri, 12 Jul 2024 17:41:31 +0800
Message-ID: <bdeaf82d-9db7-4c6c-80e0-dc6e93a19fa8@huawei.com>
Date: Fri, 12 Jul 2024 17:41:31 +0800
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
From: Hongbo Li <lihongbo22@huawei.com>
Subject: hung during bcachefs umount
To: Kent Overstreet <kent.overstreet@linux.dev>
CC: <linux-bcachefs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpeml500022.china.huawei.com (7.185.36.66)

Hi, Kent,
I found the latest repo( 
69558c638c465a79be3a08bfeb3d5a15979cbe42(bcachefs: fix ei_update_lock 
lock ordering)) on master branch will cause stucking during bcachefs umount.

Here is the test step:

```
mount -t bcachefs /dev/loop1 /mnt/bcachefs
umount /mnt/bcachefs                      ---- stuck here !!!
```

Thanks,
Hongbo

Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 155CA7470
	for <linux-bcachefs@vger.kernel.org>; Wed, 17 Jul 2024 03:12:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.190
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721185943; cv=none; b=I4dtszVo9bVm4bksTyvzjigK3/czoWRNWT4kjBx4In2/wMnAfe+oIdYBtDfPZGeVwiMPpUJZjaoabgotcR9WCvtldehy+QZ6t8Toj5N4PwRUIYqXot9YuzLVoAKdoq+Z1t7TccEHmgUk3GsFYNeFRoULO9McdF8n2CzPyStmXNU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721185943; c=relaxed/simple;
	bh=QFUdsEoTHNvB889Ui2GPOXKgR3ANpQzFumATUVLnsxE=;
	h=Message-ID:Date:MIME-Version:To:CC:From:Subject:Content-Type; b=MocXLR2YzkqNg5UmQJQw6IHepdutw8C1aK/DoEkw8W+vC0peC7vDQZDBOou+7IwpdhsoEczERnFfzPwrt+wp+i3o3r1iK8q6FWwxISob3p1mOJKxKdUXyWKE6pu+QqQKJsKUz1A2U4g1wXX4w0D3qjnknWHS3J90lI+WAMn3yP4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.190
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.163])
	by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4WP18X6qXkz2ClD6;
	Wed, 17 Jul 2024 11:07:56 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (unknown [7.185.36.66])
	by mail.maildlp.com (Postfix) with ESMTPS id 55F06180028;
	Wed, 17 Jul 2024 11:12:15 +0800 (CST)
Received: from [10.67.111.104] (10.67.111.104) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 17 Jul 2024 11:12:15 +0800
Message-ID: <bfb96546-cf04-421b-b876-2017d20d323f@huawei.com>
Date: Wed, 17 Jul 2024 11:12:14 +0800
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: Kent Overstreet <kent.overstreet@linux.dev>
CC: <linux-bcachefs@vger.kernel.org>, <lihongbo22@huawei.com>
From: Hongbo Li <lihongbo22@huawei.com>
Subject: Suggestions for the bcachefs community
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpeml500022.china.huawei.com (7.185.36.66)

Hi, Kent
     I've noticed that the main change log for bcachefs has not been 
included in the release notes for the latest Linux 6.10, which may cause 
some confusion. I'm not sure if it's because you're too busy to publish 
some change logs, or if there are other reasons behind it. I thank it's 
necessary to work together with the bcachefs developers to build up the 
bcachefs community, keeping it in sync with the community development of 
other file systems. Of course, this depends on whether you can spare the 
time to contribute to this, and the efforts of the bcachefs developers 
can also be leveraged to accomplish this work.

Thanks,
Hongbo

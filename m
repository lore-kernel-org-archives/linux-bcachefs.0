Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 575F11F947
	for <linux-bcachefs@vger.kernel.org>; Wed,  9 Oct 2024 02:03:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.255
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728439387; cv=none; b=RCHf5KVxw4l98uhdoKv5iAgxNYEIcO6pyMH6FugeXJB5Qk/kd4Wu9WDBqQ/WS2WMYucFxU5I4jkfo5VuZcLU+lVN26ST+55GJHk06J6x8A2sXiKEHr/MmkOgWpT5Ev2XKFxidGjxDXJhgT3cak1KH2lv8F7RL2vM6dUSKupSlgE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728439387; c=relaxed/simple;
	bh=3/4QdTBoMbMQ7yUWBJqUaaKach33worXOZc072zLwSs=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=M1ER8zq2JnuzAa50ps6IIY0N36NcWoH2u99MrDm01CyphHeIEX8BQRkiudPB2n4rS6WsaxqwH0IHfUt0gTVuVUy3BbwF2B67GmbNl/+IbVlXj+2L/EbhdOiNW+I0SsetPT/CUBuSe2AzLss6GPW1jHWASK6naYNI0Hk4N05TG/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.255
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.252])
	by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4XNbht5WVNz1T8Pn;
	Wed,  9 Oct 2024 10:01:18 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (unknown [7.185.36.66])
	by mail.maildlp.com (Postfix) with ESMTPS id 9832F1800A7;
	Wed,  9 Oct 2024 10:03:01 +0800 (CST)
Received: from [10.67.111.104] (10.67.111.104) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 9 Oct 2024 10:03:01 +0800
Message-ID: <1bfbf6dc-a8c3-47e3-88cf-72d7df7a8860@huawei.com>
Date: Wed, 9 Oct 2024 10:03:01 +0800
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/2] bcachefs: fixes in show_options helper
Content-Language: en-US
To: <kent.overstreet@linux.dev>
CC: <linux-bcachefs@vger.kernel.org>, <chris.zjh@huawei.com>, <ddiss@suse.de>
References: <20240926020002.1746333-1-lihongbo22@huawei.com>
From: Hongbo Li <lihongbo22@huawei.com>
In-Reply-To: <20240926020002.1746333-1-lihongbo22@huawei.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpeml500022.china.huawei.com (7.185.36.66)



On 2024/9/26 9:59, Hongbo Li wrote:
> There are two bug in show_options. The one is when printbuf
> is allocated failed, no need to copy buffer to seq. Another
> is when the option is filled into seqfile, an additional comma
> should be appended first. Considering these are two distinct
> issues, they have been divided into two separate commits here.
> 
> Changes since v1:
>    - Put the two related patches together and do the rebase.
>    - Adjust the commit msg ahout Fixes tag.
> 
> Hongbo Li (2):
>    bcachefs: avoid copy from NULL printbuf
>    bcachefs: fix incorrect show_options results
> 

I saw the patch "bcachefs: reject unknown mount options" has been 
applied in bcachefs-testing. Perhaps adding this can avoid make CI failure.

Thanks,
Hongbo

>   fs/bcachefs/fs.c | 7 +++++--
>   1 file changed, 5 insertions(+), 2 deletions(-)
> 

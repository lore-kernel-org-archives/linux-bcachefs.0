Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D4834C81
	for <linux-bcachefs@vger.kernel.org>; Wed, 24 Apr 2024 01:14:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713921302; cv=none; b=ucYU8AG6K+S4WcaDh3C/4DnhDwC+mDf85Q7VWOhJSZ6OxiuqwhFCsqNusG0pP14xh/ClttKxbfH5KiY67q9O6Vi7VjwDITfvgy1aLsAFB/y2AtpYiS4XTBNBdeHhzg1+m361H8ca5UpvGBF2JkoxMUiG44D5f36+LUjEu4LlF34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713921302; c=relaxed/simple;
	bh=wdvhBGcxVN+terQPKtqziq2XdAI7tYK9hcpo6/9DkOo=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=evJs9xGrY2/P1gw9BsTlPfKODiwadU6enF11AOGnvzGj6xvu3nPj1i735Y8tTlmHCsgEPbPxt0chWdZy4qp6i87VoJ4nDIAsQyELGv5I6J033KoEa+CRHEd3WtrQz+rHMW9zmy4chSWx1823F1x0HUp9rnxIhdtO6KagGYdDJ3U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.105])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4VPLYS16jBzvPv9;
	Wed, 24 Apr 2024 09:11:56 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (unknown [7.185.36.66])
	by mail.maildlp.com (Postfix) with ESMTPS id 5805414037B;
	Wed, 24 Apr 2024 09:14:57 +0800 (CST)
Received: from [10.67.111.104] (10.67.111.104) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Wed, 24 Apr 2024 09:14:57 +0800
Message-ID: <7c56ccf0-18a6-4327-bc37-418e21519045@huawei.com>
Date: Wed, 24 Apr 2024 09:14:56 +0800
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/2] eliminate the uninitialized compilation warning
Content-Language: en-US
To: <kent.overstreet@linux.dev>, <bfoster@redhat.com>
CC: <linux-bcachefs@vger.kernel.org>
References: <20240419074851.1583392-1-lihongbo22@huawei.com>
From: Hongbo Li <lihongbo22@huawei.com>
In-Reply-To: <20240419074851.1583392-1-lihongbo22@huawei.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpeml500022.china.huawei.com (7.185.36.66)

These are two compilation warning in bcachefs-tools, the patches may be 
useful.

Thanks,
Hongbo.

On 2024/4/19 15:48, Hongbo Li wrote:
> Eliminating the uninitialized compilation warning in bcachefs-tools.
> 
> Hongbo Li (2):
>    bcachefs: eliminate the uninitialized compilation warning in
>      bch2_reconstruct_snapshots
>    bcachefs: eliminate the uninitialized compilation warning in
>      __do_six_trylock
> 
>   fs/bcachefs/six.c      | 6 ++----
>   fs/bcachefs/snapshot.c | 5 ++++-
>   2 files changed, 6 insertions(+), 5 deletions(-)
> 

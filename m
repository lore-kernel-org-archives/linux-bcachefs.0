Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C227126AD0
	for <linux-bcachefs@vger.kernel.org>; Mon,  3 Jun 2024 08:44:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717404251; cv=none; b=DxRdF6YvK+254OUhYfvJieWz8KjpfEEceubKPxt01gDbWRCBKzc7ciVknNJHKbR1+f+8nXh+WVDe3NCPwgODgiq0/K6VkJbODkF6JjbYLMkQEcUFK3G4YR113Z0bErbGQgK1qIbw3SZxwWmUxnOXgkr2wiHWFh5sOFZwiZNUFx0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717404251; c=relaxed/simple;
	bh=lFfRJfJGc3DixIKzrXwFqdG88+0T1ZABvVAzDztix8g=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=hoSevbfMJu7MvBxquoWJbaCe3QcG+jG3FSEIIdGnrna3TCdnR5NlfQUhsyGsE6vui1k/frX2Y+cMAN6Ms2xaLgHOGdbLRiOSy270EgCJ1S8RIPKUVWZhDZkFvOfAvMGYdqv3XXABAGX38KGOxXtwBQfqwCMEgOW12HnN/zsli44=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.194])
	by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4Vt6cs0g8QzPlwH;
	Mon,  3 Jun 2024 16:40:45 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (unknown [7.185.36.66])
	by mail.maildlp.com (Postfix) with ESMTPS id 397A21402E1;
	Mon,  3 Jun 2024 16:44:00 +0800 (CST)
Received: from [10.67.111.104] (10.67.111.104) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 3 Jun 2024 16:43:59 +0800
Message-ID: <6459a695-60eb-40c1-8389-fe07ef794c37@huawei.com>
Date: Mon, 3 Jun 2024 16:43:59 +0800
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] bcachefs: eliminate the uninitialized compilation
 warning in __do_six_trylock
To: <kent.overstreet@linux.dev>, <bfoster@redhat.com>
CC: <linux-bcachefs@vger.kernel.org>
References: <20240426064132.2611169-1-lihongbo22@huawei.com>
Content-Language: en-US
From: Hongbo Li <lihongbo22@huawei.com>
In-Reply-To: <20240426064132.2611169-1-lihongbo22@huawei.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpeml500022.china.huawei.com (7.185.36.66)

Hi Kent,
     This compilation warning still exists in latest bcachefs-tools. May 
be this patch is useful.

Thanks,
Hongbo

On 2024/4/26 14:41, Hongbo Li wrote:
> When compiling the bcachefs-tools, the following compilation warning
> is reported:
>      libbcachefs/six.c: In function ‘__do_six_trylock’:
>      libbcachefs/six.c:90:12: warning: ‘old’ may be used uninitialized in this function [-Wmaybe-uninitialized]
>         90 |  if (!(old & SIX_LOCK_HELD_intent)) {
>          |       ~~~~~^~~~~~~~~~~~~~~~~~~~~~~
> 
> This is also a false altert. Only when @type=SIX_LOCK_write and @try=false
> are passed in __do_six_trylock, the second condition branch would enter
> which does not initialize the @old variable. But six_set_owner will not
> use @old if @type is not SIX_LOCK_intent. There should be nothing wrong
> in logical too.
> 
> Although the report itself is a false alert, we can elimate the unitialize
> compilation warning by assigning @old in front.
> 
> Fixes: 84a37cbf62e0 ("six locks: Wakeup now takes lock on behalf of waiter")
> Signed-off-by: Hongbo Li <lihongbo22@huawei.com>
> ---
> v3:
>    - Keep the lock state reading in original branch as Kent's suggestion.
> 
> v2: https://lore.kernel.org/linux-bcachefs/4c7f35f0-29c2-4368-8061-d022b7528469@huawei.com/T/#u
>    - Fix the error about reading lock->state introduced in v1.
> 
> v1: https://lore.kernel.org/all/20240419074851.1583392-3-lihongbo22@huawei.com/T/#u
> 
>   fs/bcachefs/six.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/bcachefs/six.c b/fs/bcachefs/six.c
> index 3a494c5d1247..086f045dbaa9 100644
> --- a/fs/bcachefs/six.c
> +++ b/fs/bcachefs/six.c
> @@ -118,11 +118,11 @@ static int __do_six_trylock(struct six_lock *lock, enum six_lock_type type,
>   			    struct task_struct *task, bool try)
>   {
>   	int ret;
> -	u32 old;
> +	u32 old = atomic_read(&lock->state);
>   
>   	EBUG_ON(type == SIX_LOCK_write && lock->owner != task);
>   	EBUG_ON(type == SIX_LOCK_write &&
> -		(try != !(atomic_read(&lock->state) & SIX_LOCK_HELD_write)));
> +		(try != !(old & SIX_LOCK_HELD_write)));
>   
>   	/*
>   	 * Percpu reader mode:

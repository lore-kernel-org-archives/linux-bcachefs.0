Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4307380
	for <linux-bcachefs@vger.kernel.org>; Fri, 26 Apr 2024 06:09:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714111801; cv=none; b=B6CJsNK9o43/58EPLcUgKv7vqAPmzXRBOaiOoVuciw3/2WTMHabrwR1+sk28FmgVfDB8LBZJJveu+EAu9IrSzoAC31iimVq/JXaZMm1EuQWNFvUXXTwcAcsOmGmxbvjSa8Sq5T3RoNJRMHoo/AQsEjCz45gPkfjNpcBDDHH7Su8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714111801; c=relaxed/simple;
	bh=3SxSnVxkq23khMAeWIM4/Yjc6ErB0wBp/8TccZCIGs0=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=GPHbZof3MpnkCpc1Ly++VkS0cU5S/CgtbPRI7NUbc2tzogDtAOCBACf1psFwXhsUXv9z8atqP9n2KjP88GDgpKJUppdGX/VyZ3Mrox0VmTLFPMvohbf225OK+phLjOmWVc+LucFjon89Szm2jZEKO433Ks2Q3boUknuvV3cynd4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.252])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4VQj0p5rHBzvQNq;
	Fri, 26 Apr 2024 14:06:50 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (unknown [7.185.36.66])
	by mail.maildlp.com (Postfix) with ESMTPS id DBB13180A9C;
	Fri, 26 Apr 2024 14:09:54 +0800 (CST)
Received: from [10.67.111.104] (10.67.111.104) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Fri, 26 Apr 2024 14:09:54 +0800
Message-ID: <4c7f35f0-29c2-4368-8061-d022b7528469@huawei.com>
Date: Fri, 26 Apr 2024 14:09:53 +0800
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/2] bcachefs: eliminate the uninitialized compilation
 warning in __do_six_trylock
Content-Language: en-US
To: Kent Overstreet <kent.overstreet@linux.dev>
CC: <bfoster@redhat.com>, <linux-bcachefs@vger.kernel.org>
References: <20240426032136.2551471-1-lihongbo22@huawei.com>
 <20240426032136.2551471-3-lihongbo22@huawei.com>
 <mk6bvhdvbeo5ey7oxlclkgya4ywk3izi4p2anl5n7a7zngneoj@qddrf2si5nfd>
From: Hongbo Li <lihongbo22@huawei.com>
In-Reply-To: <mk6bvhdvbeo5ey7oxlclkgya4ywk3izi4p2anl5n7a7zngneoj@qddrf2si5nfd>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpeml500022.china.huawei.com (7.185.36.66)



On 2024/4/26 12:04, Kent Overstreet wrote:
> On Fri, Apr 26, 2024 at 11:21:36AM +0800, Hongbo Li wrote:
>> When compiling the bcachefs-tools, the following compilation warning
>> is reported:
>>      libbcachefs/six.c: In function ‘__do_six_trylock’:
>>      libbcachefs/six.c:90:12: warning: ‘old’ may be used uninitialized in this function [-Wmaybe-uninitialized]
>>         90 |  if (!(old & SIX_LOCK_HELD_intent)) {
>>          |       ~~~~~^~~~~~~~~~~~~~~~~~~~~~~
>>
>> This is also a false altert. Only when @type=SIX_LOCK_write and @try=false
>> are passed in __do_six_trylock, the second condition branch would enter
>> which does not initialize the @old variable. But six_set_owner will not
>> use @old if @type is not SIX_LOCK_intent. There should be nothing wrong
>> in logical too.
>>
>> Although the report itself is a false alert, we can elimate the unitialize
>> compilation warning by assigning @old in front.
>>
>> Fixes: 84a37cbf62e0 ("six locks: Wakeup now takes lock on behalf of waiter")
>> Signed-off-by: Hongbo Li <lihongbo22@huawei.com>
> 
> let's just delete the assertion - I don't like moving around reading the
> lock state for this.
ok, thank you, and I will keep "old = atomic_read(&lock->state);" in the 
following else branch for next version.
> 
>> ---
>> v2:
>>    - Fix the error about reading lock->state introduced in v1.
>>
>> v1: https://lore.kernel.org/all/20240419074851.1583392-3-lihongbo22@huawei.com/T/#u
>> ---
>> ---
>>   fs/bcachefs/six.c | 5 ++---
>>   1 file changed, 2 insertions(+), 3 deletions(-)
>>
>> diff --git a/fs/bcachefs/six.c b/fs/bcachefs/six.c
>> index 3a494c5d1247..8bfd22a6f771 100644
>> --- a/fs/bcachefs/six.c
>> +++ b/fs/bcachefs/six.c
>> @@ -118,11 +118,11 @@ static int __do_six_trylock(struct six_lock *lock, enum six_lock_type type,
>>   			    struct task_struct *task, bool try)
>>   {
>>   	int ret;
>> -	u32 old;
>> +	u32 old = atomic_read(&lock->state);
>>   
>>   	EBUG_ON(type == SIX_LOCK_write && lock->owner != task);
>>   	EBUG_ON(type == SIX_LOCK_write &&
>> -		(try != !(atomic_read(&lock->state) & SIX_LOCK_HELD_write)));
>> +		(try != !(old & SIX_LOCK_HELD_write)));
>>   
>>   	/*
>>   	 * Percpu reader mode:
>> @@ -182,7 +182,6 @@ static int __do_six_trylock(struct six_lock *lock, enum six_lock_type type,
>>   				ret = -1 - SIX_LOCK_read;
>>   		}
>>   	} else {
>> -		old = atomic_read(&lock->state);
>>   		do {
>>   			ret = !(old & l[type].lock_fail);
>>   			if (!ret || (type == SIX_LOCK_write && !try)) {
>> -- 
>> 2.34.1
>>
> 

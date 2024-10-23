Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C7D44A32;
	Wed, 23 Oct 2024 01:11:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729645869; cv=none; b=dVxGuvmHqEpcAchNwMUelE4KJC02LmVrht6/l6ps8+NhekCvE7hJdJd8onhEa5mkl0kbofPTtJNr1VO0z+6q80ExxCP2ZmranM1fzxfZ7HF2XmG3M6uS4FCQAZhLYdo+Rlns8EUk+VZH2iYHc/aS8EJ5yymy5FP2COO8GgQzhfA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729645869; c=relaxed/simple;
	bh=6U5By2Ch/g2SvsFdLkpdUpapmFgINR8zZ0uZD7Jbv9k=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=ILGu/xuZ9rXbqhsvQDfteR6lJM7acWAwtr3su3mu5vA5U6D3WtASUKthdx6pMYPONqfK+y+FafUAXmFjTaqPdGyWvdPQBXg88tCoMaRYwX1RRsxCqQcc9DGA8uodMj4J3r9JZrHf5vsBUAF4EGsdilECuDIt6I0hkJ6n2R85aa4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.105])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4XY9t65Ghhz10N07;
	Wed, 23 Oct 2024 09:09:02 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (unknown [7.185.36.66])
	by mail.maildlp.com (Postfix) with ESMTPS id 2C8F514010D;
	Wed, 23 Oct 2024 09:11:04 +0800 (CST)
Received: from [10.67.111.104] (10.67.111.104) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 23 Oct 2024 09:11:03 +0800
Message-ID: <68aa186e-a6ab-4fd8-bc17-6d131a80636b@huawei.com>
Date: Wed, 23 Oct 2024 09:11:01 +0800
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] bcachefs: fix shift oob in alloc_lru_idx_fragmentation
Content-Language: en-US
To: Jeongjun Park <aha310510@gmail.com>
CC: <kent.overstreet@linux.dev>, <mmpgouride@gmail.com>,
	<linux-bcachefs@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<syzbot+7f45fa9805c40db3f108@syzkaller.appspotmail.com>
References: <1e46f070-3e78-4a81-b7c7-ea021271b12b@huawei.com>
 <D983ED6A-1206-4D3F-AAEB-4572BD81AB2B@gmail.com>
From: Hongbo Li <lihongbo22@huawei.com>
In-Reply-To: <D983ED6A-1206-4D3F-AAEB-4572BD81AB2B@gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpeml500022.china.huawei.com (7.185.36.66)



On 2024/10/22 12:05, Jeongjun Park wrote:
> 
> 
>> Hongbo Li <lihongbo22@huawei.com> wrote:
>>
>> ﻿
>>
>>> On 2024/10/21 23:43, Jeongjun Park wrote:
>>> The size of a.data_type is set abnormally large, causing shift-out-of-bounds.
>>> To fix this, we need to add validation on a.data_type in
>>> alloc_lru_idx_fragmentation().
>>> Reported-by: syzbot+7f45fa9805c40db3f108@syzkaller.appspotmail.com
>>> Fixes: 260af1562ec1 ("bcachefs: Kill alloc_v4.fragmentation_lru")
>>> Signed-off-by: Jeongjun Park <aha310510@gmail.com>
>>> ---
>>>   fs/bcachefs/alloc_background.h | 3 +++
>>>   1 file changed, 3 insertions(+)
>>> diff --git a/fs/bcachefs/alloc_background.h b/fs/bcachefs/alloc_background.h
>>> index f8e87c6721b1..163a67b97a40 100644
>>> --- a/fs/bcachefs/alloc_background.h
>>> +++ b/fs/bcachefs/alloc_background.h
>>> @@ -168,6 +168,9 @@ static inline bool data_type_movable(enum bch_data_type type)
>>>   static inline u64 alloc_lru_idx_fragmentation(struct bch_alloc_v4 a,
>>>                             struct bch_dev *ca)
>>>   {
>>> +    if (a.data_type >= BCH_DATA_NR)
>>> +        return 0;
>>> +
>>
>> oh, I found I have done the same thing in [1]("Re: [syzbot] [bcachefs?] UBSAN: shift-out-of-bounds in bch2_alloc_to_text"). But in my humble opinion, the validation changes also should be added. And in addition, move the condition about a.data_type into data_type_movable will be better. Just my personal opinion.:)
>>
>> [1] https://www.spinics.net/lists/kernel/msg5412619.html
> 
> I still disagree with the fix to make data_type_movable() do the validation,
> but I think [1] is definitely a patch that needs to be added.
> 
> However, [1] is far from preventing the shift oob vulnerability described
> in that syzbot report. Therefore, I think [1] should be written as a
> standalone patch and committed, rather than as a patch for that

I'm fine for this.:)

Thanks,
Hongbo

> syzbot report.
> 
>>
>> Thanks,
>> Hongbo
>>
>>>       if (!data_type_movable(a.data_type) ||
>>>           !bch2_bucket_sectors_fragmented(ca, a))
>>>           return 0;
>>> --

Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE3F213790B;
	Tue, 22 Oct 2024 03:06:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729566402; cv=none; b=IvgU16Y1gF3ciCCGHmSfGJja6a+s2CbsqFDU8cen+oHs3FJtV2eXatqpFpTnbM4DlvFfjnUcWnLM4pbflpO3uBmWeBKjg7uOFMgkfSCngqVF8qKL10U2gjv5NVRKku8TY2O8v5cwXGG0d6lZiCYrTH1f27WDjJTUFY9oTertjBg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729566402; c=relaxed/simple;
	bh=5E/F8SMwlkbqTn9yh91xv8MrZrkAwbncTzde9BPHtbU=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=qhOw7gVSAaEkV2mhEOCAvArB29UDlwH8ye9Hda+5xRcfGwwOJgo966zFg1ujvOnYYDFVdQrlZp2mUD2fMMdQqC4R+UoOyq+CvmGom9DKGRYJSjCLsI++bLIOYwzuQ6aCMO7vzVfb7a6YnWKzH6DuPuIkNSH5eNjd9Uyx7g8ZJcg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.252])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4XXcSc0d3wzfdX0;
	Tue, 22 Oct 2024 11:03:28 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (unknown [7.185.36.66])
	by mail.maildlp.com (Postfix) with ESMTPS id C996B1800DE;
	Tue, 22 Oct 2024 11:05:57 +0800 (CST)
Received: from [10.67.111.104] (10.67.111.104) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 22 Oct 2024 11:05:57 +0800
Message-ID: <10aed636-b665-49f0-8fa3-fcb5504c13c6@huawei.com>
Date: Tue, 22 Oct 2024 11:05:55 +0800
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] bcachefs: fix shift oob in alloc_lru_idx_fragmentation
To: Alan Huang <mmpgouride@gmail.com>
CC: Jeongjun Park <aha310510@gmail.com>, Kent Overstreet
	<kent.overstreet@linux.dev>, <linux-bcachefs@vger.kernel.org>, LKML
	<linux-kernel@vger.kernel.org>,
	<syzbot+7f45fa9805c40db3f108@syzkaller.appspotmail.com>
References: <20241021154356.38221-1-aha310510@gmail.com>
 <1e46f070-3e78-4a81-b7c7-ea021271b12b@huawei.com>
 <45EF275D-8F04-41DF-9895-CCAF28D5AAAC@gmail.com>
Content-Language: en-US
From: Hongbo Li <lihongbo22@huawei.com>
In-Reply-To: <45EF275D-8F04-41DF-9895-CCAF28D5AAAC@gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpeml500022.china.huawei.com (7.185.36.66)



On 2024/10/22 10:38, Alan Huang wrote:
> On Oct 22, 2024, at 10:26, Hongbo Li <lihongbo22@huawei.com> wrote:
>>
>>
>>
>> On 2024/10/21 23:43, Jeongjun Park wrote:
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
>>>          struct bch_dev *ca)
>>>   {
>>> + if (a.data_type >= BCH_DATA_NR)
>>> + return 0;
>>> +
>>
>> oh, I found I have done the same thing in [1]("Re: [syzbot] [bcachefs?] UBSAN: shift-out-of-bounds in bch2_alloc_to_text"). But
> 
> Your patch there is still triggering the issue.
Yeah, it just notify the issue and not prevent the issue. So I found it 
should add a.data_type condition indeed. :)
> 
>> in my humble opinion, the validation changes also should be added. And in addition, move the condition about a.data_type into
> 
> There is already the validation:
> 
> bkey_fsck_err_on(alloc_data_type(a, a.data_type) != a.data_type

This is actually not enough. This only do some transition check. For 
example, if a.data_type break when bch2_bucket_sectors_dirty (the data 
corruption can lead to various situations occurring) is true, the helper 
does noting.

Thanks,
Hongbo

> 
> And the unknown data type is already printed in bch2_prt_data_type, additional validation doesn’t help much.
> 
>> data_type_movable will be better. Just my personal opinion.:)
> 
> In my personal opinion, I don’t think so :)
> 
>>
>> [1] https://www.spinics.net/lists/kernel/msg5412619.html
>>
>> Thanks,
>> Hongbo
>>
>>>    if (!data_type_movable(a.data_type) ||
>>>        !bch2_bucket_sectors_fragmented(ca, a))
>>>    return 0;
>>> --
> 
> 

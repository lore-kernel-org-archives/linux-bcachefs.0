Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 444F222615;
	Fri, 30 Aug 2024 03:53:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724989997; cv=none; b=YQQ7D+MLLObMD7dSGY7KdHaX2EiB1/rG8IcqNZfL29Q63/b05A9L343sycDBPnJIQjasyfgKPY7EBrVwjVb1jEyh2I6xgJl1GoiKYyKbmSqS16hyDz6JdYMdzParyOhAvATQCvkW+xKoaYsswrJfTIrKiZDQsl3r9oZ9pFpECe0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724989997; c=relaxed/simple;
	bh=bUHMkOyFBZLttFQKvqDU2ues+Xx48BB5cvtysfduShc=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:CC:References:
	 In-Reply-To:Content-Type; b=XW09GS68b7vQnPCn5tRGfEpoY+mgET7W8AN9aTwXihPnEMYQbl22QMSZ7YuOhhIrogDcqDl2+G2MgkHh5GOq15Tc7nJO+57JUWRBCw8jXRBjn1t0ZpqCnZhI0gdkdg234cpFkWpl3Lz3aqNs6BmKGdKTeAr3mTQIEwU9RRmPnUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.162.254])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4Ww43T0251zyQZh;
	Fri, 30 Aug 2024 11:52:21 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (unknown [7.185.36.66])
	by mail.maildlp.com (Postfix) with ESMTPS id B43ED180105;
	Fri, 30 Aug 2024 11:53:11 +0800 (CST)
Received: from [10.67.111.104] (10.67.111.104) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Fri, 30 Aug 2024 11:53:11 +0800
Message-ID: <3f60f1de-f96c-434b-a4de-355100ce9e79@huawei.com>
Date: Fri, 30 Aug 2024 11:53:11 +0800
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] bcachefs: Remove the handling of bch2_trans_iter_exit()
 in __bch2_bkey_get_iter()
Content-Language: en-US
From: Hongbo Li <lihongbo22@huawei.com>
To: Youling Tang <youling.tang@linux.dev>
CC: <linux-bcachefs@vger.kernel.org>, <linux-kernel@vger.kernel.org>, Youling
 Tang <tangyouling@kylinos.cn>, Kent Overstreet <kent.overstreet@linux.dev>
References: <20240823031955.202795-1-youling.tang@linux.dev>
 <f2uohiy7zaaiv33r7xhofaprv6tk5mumvzzf7plvagdtavrini@3orfgcehid7q>
 <f9f50184-364c-4082-bf19-ea953c3c1429@linux.dev>
 <dcutapnlzvglzlbta2tzcvch26g2nnptluykgz5gabcoolxywu@fwq3u7jzd3y2>
 <3d5e6272-1283-4b43-a30c-d5c4fad88946@linux.dev>
 <0293d72e-8d57-42c2-bb11-a7a553675ae6@huawei.com>
In-Reply-To: <0293d72e-8d57-42c2-bb11-a7a553675ae6@huawei.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpeml500022.china.huawei.com (7.185.36.66)



On 2024/8/30 11:48, Hongbo Li wrote:
> 
> 
> On 2024/8/30 9:19, Youling Tang wrote:
>> On 2024/8/23 22:51, Kent Overstreet wrote:
>>
>>> On Fri, Aug 23, 2024 at 02:07:20PM GMT, Youling Tang wrote:
>>>> On 23/08/2024 11:55, Kent Overstreet wrote:
>>>>> On Fri, Aug 23, 2024 at 11:19:55AM GMT, Youling Tang wrote:
>>>>>> From: Youling Tang <tangyouling@kylinos.cn>
>>>>>>
>>>>>> - Reduces bkey_err() calls.
>>>>>> - Avoid redundant calls to bch2_trans_iter_exit() in some functions.
>>>>> no, a function that returns an error should clean up after itself
>>>> Yes, functions should self-clean when they fail.
>>>>
>>>> However, there are repeated calls to bch2_trans_iter_exit in
>>>> some functions, take lookup_inode() as an example,
>>>>
This is indeed the case. Personally, I think the bcachefs code is quite 
difficult to understand (such as too many macro, etc..), with many parts 
that could be simplified. I think may be only Kent himself can fully 
hold it.

>>>> When bkey_err(k) returns a non-zero, call bch2_trans_iter_exit()
>>>> once in bch2_bkey_get_iter(). It is then called again in
>>>> lookup_inode() via 'goto err'. (We can correct it by simply changing
>>>> it to 'return ret', but there are many similar cases.)
>>> I'm aware, but I'm not looking to microoptimize at the expense of making
>>> the code more fragile and less clear, especially right now when the
>>> priority is stabilizing and fixing bugs.
>>>
>>> If you were also doing performance testing and could show that it
>>> makes a measurable difference I'd consider it. Did you even look at the
>>> assembly output for any of these functions? CSE might be optimizing away
>>> the redundant calls.
>> I haven't performed the corresponding performance testing. Looking at
>> the assembly code, taking `lookup_inode()` as an example,
>>
> I think his point is that your modification is error-free, but improving 
> readability is not a high priority at the moment unless it actually 
> affects performance. There might currently be a shortage of manpower, 
> with many features to be completed and bugs to be fixed.
>> Before the patch,
>>      142f:       74 96 je     13c7 <lookup_inode+0x117>
>>      1431:       48 8d b5 68 ff ff ff lea    -0x98(%rbp),%rsi
>>      1438:       4c 89 e7 mov    %r12,%rdi
>>      143b:       e8 00 00 00 00 call   1440 <lookup_inode+0x190>
>>      1440:       eb b4 jmp    13f6 <lookup_inode+0x146>
>>      1442:       e8 00 00 00 00 call   1447 <lookup_inode+0x197>
>>      1447:       66 0f 1f 84 00 00 00 nopw   0x0(%rax,%rax,1)
>>      144e:       00 00
>>
>> After,
>>      111f:       74 96 je     10b7 <lookup_inode+0x117>
>>      1121:       eb c3 jmp    10e6 <lookup_inode+0x146>
>>      1123:       e8 00 00 00 00 call   1128 <lookup_inode+0x188>
>>      1128:       0f 1f 84 00 00 00 00 nopl   0x0(%rax,%rax,1)
>>      112f:       00
>>
>> The following three assembly instructions have been reduced,
>>      1431:       48 8d b5 68 ff ff ff lea    -0x98(%rbp),%rsi
>>      1438:       4c 89 e7 mov    %r12,%rdi
>>      143b:       e8 00 00 00 00 call   1440 <lookup_inode+0x190>
>>

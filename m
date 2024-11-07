Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEF6D212637
	for <linux-bcachefs@vger.kernel.org>; Thu,  7 Nov 2024 12:53:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.191
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730984030; cv=none; b=KbPV2GD/YRge7SRnqUyxQDPTehVOIBagTe6GBMZboBcJ1E9JqOQeV48IRXgAGH1a6oR8xNowxLVtJen85urwqREyVDZEywsgMhyirEPEft4EzoyRNeI3vDJu85P2dNVlT1Up5f3Ol82LmwrR9Zuo4ujb3k6bdjfsqTXZI/FHNK0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730984030; c=relaxed/simple;
	bh=I7fHhu4dZUtqLRTvvtqif2Eo/nVUQcORmRaXXJzYKkU=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=i+ufnAlqi0dq2DlJJP6mzzbk1Z30jSwz5OTlVi+DHIb4JzuQ4a9NCGR3vrVeZu2vl4ihYGzKJa8yHirfT26iIwg52j6Fho+reGcLWEUzY0VBnTeIMPOomqdcxpCthje56NqhZvx6EbUI5c6Z2l/DLA2EIBgGRp2QOH0n7E9t2Xk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.191
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.162.112])
	by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4Xkhhy3qZpz1JCDY;
	Thu,  7 Nov 2024 20:49:06 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (unknown [7.185.36.66])
	by mail.maildlp.com (Postfix) with ESMTPS id D2400140136;
	Thu,  7 Nov 2024 20:53:43 +0800 (CST)
Received: from [10.67.111.104] (10.67.111.104) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 7 Nov 2024 20:53:43 +0800
Message-ID: <7a270fa8-7737-40b7-bce3-b497c896e5cb@huawei.com>
Date: Thu, 7 Nov 2024 20:53:41 +0800
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] bcachefs: fix io_read/write counter with wrong unit
Content-Language: en-US
To: Kent Overstreet <kent.overstreet@linux.dev>
CC: <linux-bcachefs@vger.kernel.org>
References: <20241105142224.2252301-1-lihongbo22@huawei.com>
 <zin4x2km66m5oblwnrcnq5ux2hrsrvnbvrsydjvlbignjuzlf3@kendrzgvgre3>
From: Hongbo Li <lihongbo22@huawei.com>
In-Reply-To: <zin4x2km66m5oblwnrcnq5ux2hrsrvnbvrsydjvlbignjuzlf3@kendrzgvgre3>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpeml500022.china.huawei.com (7.185.36.66)



On 2024/11/7 5:26, Kent Overstreet wrote:
> On Tue, Nov 05, 2024 at 10:22:24PM +0800, Hongbo Li wrote:
>> In bcachefs, io_read and io_write counter record the amount
>> of data which has been read and written. They increase in
>> unit of sector, so to display correctly, they need to be
>> shifted to the left by the size of a sector.
>>
>> Fixes: 1c6fdbd8f246 ("bcachefs: Initial commit")
>> Signed-off-by: Hongbo Li <lihongbo22@huawei.com>
> 
> Nice, I'd been meaning to fix that
> 
>> ---
>> When I read one 15.7M file, the io_read sysfs interface shows:
>> - Before this patch
>>    - original:
>>      since mount:                   0 B
>>      since filesystem creation:     5.11 KiB
>>
>>    - after read:
>>      since mount:                   31.4 KiB
>>      since filesystem creation:     36.5 KiB
>>
>> - After this patch:
>>    - original:
>>      since mount:                   0 B
>>      since filesystem creation:     18.3 MiB
>>
>>    - after read:
>>      since mount:                   15.7 MiB
>>      since filesystem creation:     34.0 MiB
>> ---
>>   fs/bcachefs/sysfs.c | 5 +++++
>>   1 file changed, 5 insertions(+)
>>
>> diff --git a/fs/bcachefs/sysfs.c b/fs/bcachefs/sysfs.c
>> index 97733c766948..aa46b69da4d8 100644
>> --- a/fs/bcachefs/sysfs.c
>> +++ b/fs/bcachefs/sysfs.c
>> @@ -513,6 +513,11 @@ SHOW(bch2_fs_counters)
>>   		if (attr == &sysfs_##t) {					\
>>   			counter             = percpu_u64_get(&c->counters[BCH_COUNTER_##t]);\
>>   			counter_since_mount = counter - c->counters_on_mount[BCH_COUNTER_##t];\
>> +			if (attr == &sysfs_io_read || attr == &sysfs_io_write) {\
>> +				counter <<= 9;					\
>> +				counter_since_mount <<= 9;			\
>> +			}							\
>> +										\
> 
> But, I really try to avoid this kind of "do something special for one or
> two cases" in generic code, this kind of thing proliferates and then it
> becomes really hard to track down and see where behaviour is coming from
> later.
> 
> We've already got a table of counters - BCH_PERSISTENT_COUNTERS(); it
> would be better to add a "type" column there, and then it'll make it
> easy to spot later if any other counters have the wrong type or need
> different behaviour.

Yeah, I finish it in [1]. For counters like io_read, io_write, io_move 
and move_extent_{read, write, finish} should multiple 512 when they are 
displayed to user.

[1] 
https://lore.kernel.org/linux-bcachefs/20241107123145.1003801-1-lihongbo22@huawei.com/T/#u

Thanks,
Hongbo

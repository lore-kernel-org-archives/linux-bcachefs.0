Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CE7D18A92F
	for <linux-bcachefs@vger.kernel.org>; Fri, 13 Dec 2024 06:40:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.191
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734072030; cv=none; b=fqJ+NYP9SaqQsJjd05WEuVYg12W0zWs5+tSFRasIJ1PWLnXTDrf24mnPP0NvyWJHA3ZoiEEl7QyAScKWl7+lMUdX9ffvN7PzxyJb4d9sFeQanIYhSnB8yj80cmSCdqezste1w8tE1eBOc+WSBzHFyM7nFpSHdQLPDTB9YRvjRLU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734072030; c=relaxed/simple;
	bh=aRQ3NTBpiCQBoihpwuqeOvOX2zLeLq7HtT/wlmmpHQk=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=d0Z1i9GG9hclJwqrIVNfbuK6o+rRNAF8jHXcysLQ+nG07I5pwKqL4KGX2bztna1vjY+7QFqc6hOyNCCW8tLZM0xz2zgRipYNTpquV3zTiKFBOARPqoY0//ibZEpshFjMnhEPVReQFckLU7FwQOhSXdsO1HYfy3p53ZjVgedvP1U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.191
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.162.112])
	by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4Y8fm32ZnVz1kvxt;
	Fri, 13 Dec 2024 14:37:55 +0800 (CST)
Received: from kwepemo500009.china.huawei.com (unknown [7.202.194.199])
	by mail.maildlp.com (Postfix) with ESMTPS id 4CC2414011F;
	Fri, 13 Dec 2024 14:40:23 +0800 (CST)
Received: from [10.67.111.104] (10.67.111.104) by
 kwepemo500009.china.huawei.com (7.202.194.199) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 13 Dec 2024 14:40:22 +0800
Message-ID: <304aef1f-a3e1-44f6-9399-6915d9cbcccc@huawei.com>
Date: Fri, 13 Dec 2024 14:40:21 +0800
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 0/3] bcachefs: add and use printbuf_err helper
Content-Language: en-US
To: Kent Overstreet <kent.overstreet@linux.dev>
CC: <linux-bcachefs@vger.kernel.org>
References: <20241213040328.2921159-1-lihongbo22@huawei.com>
 <4qcmnsjtriihdobz3sbd7patscqj72x3vx44iizvyoiw5fpvkz@bezvyxum6yl7>
From: Hongbo Li <lihongbo22@huawei.com>
In-Reply-To: <4qcmnsjtriihdobz3sbd7patscqj72x3vx44iizvyoiw5fpvkz@bezvyxum6yl7>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 kwepemo500009.china.huawei.com (7.202.194.199)



On 2024/12/13 12:57, Kent Overstreet wrote:
> On Fri, Dec 13, 2024 at 12:03:25PM +0800, Hongbo Li wrote:
>> Add printbuf_err helper to return standard error when
>> allocation failure.
>>
>> v3:
>>    - Remove extra sign-off and rebase the code.
>>
>> v2: https://lore.kernel.org/linux-bcachefs/20241112074745.407848-1-lihongbo22@huawei.com/
>>    - add printbuf_err helper and use it.
>>
>> v1: https://lore.kernel.org/all/20240926020002.1746333-2-lihongbo22@huawei.com/
>>
>> Hongbo Li (3):
>>    bcachefs: add printbuf_err helper
>>    bcachefs: avoid copy from NULL printbuf when allocation failure
>>    bcachefs: use printbuf_err helper
>>
>>   fs/bcachefs/fs.c       | 9 +++++++--
>>   fs/bcachefs/opts.c     | 7 +------
>>   fs/bcachefs/printbuf.h | 5 +++++
>>   fs/bcachefs/sysfs.c    | 4 +---
>>   4 files changed, 14 insertions(+), 11 deletions(-)
>>
>> -- 
>> 2.34.1
>>
> 
> A thought.
> 
> I haven't been liking the idea of adding new error checks all over the
> place (and if we interpret this strictly, they'd need to be added
> _everywhere_) - a lot of pain for very little gain, considering that in
> practice small allocations will never fail.


> 
> And most printbuf uses wouldn't be doing anything with an extra -ENOMEM
> check, the few that need it do check for it explicitly.
How about adjusting the strategies of resize to decrease the realloc in 
bch2_prt_printf (if new size is closed to the original size, it may 
invoke realloc again.)? Or add some limited log for allocation failure. 
Anyway, may be the check for allocation is necessary.
> 
> But this is something that we should handle, because we could be using
> a printbuf in an atomic context, or the debate over memory allocator
> failure behaviour could change (unlikely, but) - or we could be trying
> to print a string for which the initial allocation was over the size
> that's guaranteed not to fail by the allocator.
> 
> So we want a way to make getting the string safe, without affecting the
> ergonomics so much.
> 
> So...
> 
> What if we had a printbuf_str() method for getting the buffer, instead
> of accessing printbuf.buf directly?
It works well for the following step, but it may ignore the memory 
allocator failure cases if lack of the checker. And this makes it 
difficult for debugging.
> 
> Then instead of returning a NULL pointer, if printbuf.buf is null it
> could just return a pointer to the zero page (which conveniently is a
> null terminated zero length string, for our purposes).
> 

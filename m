Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 624148C0E
	for <linux-bcachefs@vger.kernel.org>; Fri,  6 Jun 2025 01:16:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749172580; cv=none; b=YMeh0x+MHS6GIVaPzaSPLJHsZC+gvbTxyKN4R24yLwDt7pC5gYCDzhMEzq7AmPmuP9A/imrn/aAgAKlEUKI1OdpbATroaBcdYu06cj249PJGu9GyjhRzgEi9sSbGdsX0S8FBw6Gt87n30GL4L8XgD28HQ6gDHTws8NmQGd4zr4I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749172580; c=relaxed/simple;
	bh=XoM1JKbfZTIybchpQDOwr96beTFnMZmM8fF6Th/K1h8=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=cj8H7KC1NSCWLVAr7mUX+IH2SotlYi8H7StTAG7VDjfGYOaEm9ALjUkgKoq4SZovd8lgcNlQxum7MgFzFmfW2V0FNtpXY+tq9UiCXVCLCa5/N/FPAZhyejxevLWfHS5Xw3O7c/8+iz3KBvIfoXtfOzHUwytjAFHDfXnFXlx7Axs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.252])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4bD3Jh2hMwztRwd;
	Fri,  6 Jun 2025 09:15:00 +0800 (CST)
Received: from kwepemo500009.china.huawei.com (unknown [7.202.194.199])
	by mail.maildlp.com (Postfix) with ESMTPS id 0DE88180B6A;
	Fri,  6 Jun 2025 09:16:13 +0800 (CST)
Received: from [10.67.111.104] (10.67.111.104) by
 kwepemo500009.china.huawei.com (7.202.194.199) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 6 Jun 2025 09:16:12 +0800
Message-ID: <b7f8d9ea-36eb-4647-b238-615d7416a89b@huawei.com>
Date: Fri, 6 Jun 2025 09:16:12 +0800
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Size of directory entry 16 EiB according to "ls -l"
To: Kent Overstreet <kent.overstreet@linux.dev>
CC: <linux-bcachefs@vger.kernel.org>, Martin Steigerwald <martin@lichtvoll.de>
References: <3009813.e9J7NaK4W3@lichtvoll.de>
 <evvg4qltrboeynoj4j33zzrbr2atye6mywkhzy7l5i2ifehae6@ih62wyi2fsrr>
 <74199382-7c0f-440c-b7b6-45eabc95e332@huawei.com>
 <bhuiydsd4ovig4i2inltu4a325c35xc4zaxyaawdfrjzghgbtr@muphmxvcw7lq>
Content-Language: en-US
From: Hongbo Li <lihongbo22@huawei.com>
In-Reply-To: <bhuiydsd4ovig4i2inltu4a325c35xc4zaxyaawdfrjzghgbtr@muphmxvcw7lq>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 kwepemo500009.china.huawei.com (7.202.194.199)



On 2025/5/31 23:03, Kent Overstreet wrote:
> On Sat, May 31, 2025 at 10:00:55PM +0800, Hongbo Li wrote:
>>
>> 在 2025/5/31 7:16, Kent Overstreet 写道:
>>> On Fri, May 30, 2025 at 11:19:32PM +0200, Martin Steigerwald wrote:
>>>> Hi!
>>>>
>>>> Summary: I am curious why "ls -l" reports 16 EiB as the size of a
>>>> directory entry. As to what I can see the filesystem is perfectly fine.
>>>>
>>>> Kernel 6.15, self compiled. 320 GiB BCacheFS on LUKS encrypted LVM.
>>>> Checksums are xxhash. Filesystem was created recently on self compiled
>>>> 6.15-rc7 with self-compiled bcachefs tools from git tag 1.25.2. "bcachefs"
>>>> reports 1.25.1 as version number.
>>>>
>>>> I have a directory entry that according to ls -l is quite big:
>>>>
>>>> drwxrwxr-x 5 martin martin 18446744073709551400 DATE DIRECTORY
>>> Yes, this is due to a leftover from the directory i_size patchset that
>>> had to be reverted. As long as it's not causing issues it'll be a bit
>>> before I get to it, I've got higher priority bugs I'm working on right
>>> now (as usual).
>>>
>>> Hongbo, whatever happened to that patchset? I thought you were going to
>>> fix it so we could get it back in later?
>> I'm very sorry for the directory i_size problem. And this work has been
>> postponed recently due to my other internal works. Yeah, I will get back to
>> this work after this Dragon Boat festival. I'm really sorry I haven't dealt
>> with it sooner.
> 
> Ok, don't worry about it, the rest of it isn't urgent, just the i_size
> fixes for the revert - I'll try to get that out today.

Hi, Kent,
Thank you, I noticed you have reverted the related patch. I've been to 
busy with some internal matters recently, but I will continue to follow 
up on this task.

Thanks,
Hongbo

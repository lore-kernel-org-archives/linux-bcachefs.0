Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E812B4C74
	for <linux-bcachefs@vger.kernel.org>; Sat, 31 May 2025 14:01:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748700075; cv=none; b=jdqXxUDfvZSXhHfIs2Khn65MJCii9R7hN7bx3SghLHRZBwp8EPVc7drQxIGaJXTmrCGJyElsf6P5MTPpqA+TvJaRF1XE4QhYQL116SRAy9fmJpVlIXI0UONd1g5Wp6yDKjTCcFUrfUsFJuFsrHPLlOopyL9anz3c7EHCJkuy3DU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748700075; c=relaxed/simple;
	bh=56VVYWgG49wHeA6UZsoSMeYCs6usRMhHHjBjqBQVnNA=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:CC:References:
	 In-Reply-To:Content-Type; b=jRzXi++9qBALROu7gqg/G5kJd4ixUv/0wOKAPd51Ws6La0+KWuv7H7bVaTJwdCQwK204eLn4NjZOGXNnLMH4W6xvhDGoTHOF1zdy+TA6B4nI36pzuhCWqCehQIUjB8VjXpoqf9Sv3+0UzhVxfJqIQvUy3GcyU2NllTXYQ8Xrrzo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.162.254])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4b8hYy2XtlznfT0;
	Sat, 31 May 2025 21:59:50 +0800 (CST)
Received: from kwepemo500009.china.huawei.com (unknown [7.202.194.199])
	by mail.maildlp.com (Postfix) with ESMTPS id 11021180235;
	Sat, 31 May 2025 22:01:04 +0800 (CST)
Received: from [10.82.13.123] (10.82.13.123) by kwepemo500009.china.huawei.com
 (7.202.194.199) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Sat, 31 May
 2025 22:01:03 +0800
Message-ID: <74199382-7c0f-440c-b7b6-45eabc95e332@huawei.com>
Date: Sat, 31 May 2025 22:00:55 +0800
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Hongbo Li <lihongbo22@huawei.com>
Subject: Re: Size of directory entry 16 EiB according to "ls -l"
To: Kent Overstreet <kent.overstreet@linux.dev>
CC: <linux-bcachefs@vger.kernel.org>, Martin Steigerwald <martin@lichtvoll.de>
References: <3009813.e9J7NaK4W3@lichtvoll.de>
 <evvg4qltrboeynoj4j33zzrbr2atye6mywkhzy7l5i2ifehae6@ih62wyi2fsrr>
In-Reply-To: <evvg4qltrboeynoj4j33zzrbr2atye6mywkhzy7l5i2ifehae6@ih62wyi2fsrr>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 kwepemo500009.china.huawei.com (7.202.194.199)


在 2025/5/31 7:16, Kent Overstreet 写道:
> On Fri, May 30, 2025 at 11:19:32PM +0200, Martin Steigerwald wrote:
>> Hi!
>>
>> Summary: I am curious why "ls -l" reports 16 EiB as the size of a
>> directory entry. As to what I can see the filesystem is perfectly fine.
>>
>> Kernel 6.15, self compiled. 320 GiB BCacheFS on LUKS encrypted LVM.
>> Checksums are xxhash. Filesystem was created recently on self compiled
>> 6.15-rc7 with self-compiled bcachefs tools from git tag 1.25.2. "bcachefs"
>> reports 1.25.1 as version number.
>>
>> I have a directory entry that according to ls -l is quite big:
>>
>> drwxrwxr-x 5 martin martin 18446744073709551400 DATE DIRECTORY
> Yes, this is due to a leftover from the directory i_size patchset that
> had to be reverted. As long as it's not causing issues it'll be a bit
> before I get to it, I've got higher priority bugs I'm working on right
> now (as usual).
>
> Hongbo, whatever happened to that patchset? I thought you were going to
> fix it so we could get it back in later?
I'm very sorry for the directory i_size problem. And this work has been 
postponed recently due to my other internal works. Yeah, I will get back 
to this work after this Dragon Boat festival. I'm really sorry I haven't 
dealt with it sooner.

Hongbo.

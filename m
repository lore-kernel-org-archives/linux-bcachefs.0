Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D12D8212D16
	for <linux-bcachefs@vger.kernel.org>; Tue, 12 Nov 2024 11:13:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.190
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731410001; cv=none; b=LEudn8jkxUFl44jbwQ4yY45mA2NAQh+n8xbQcqXOaFQZupMNhFWLcjui9rbv83U+FCOF3WNogGxEhlJtaUtu67NZ/LqqD3uHrlg0jBWqzkDZkmBkLeLcx8EeP/Sm9pOfOUA75MI7ujGDY42smwMfk1o23noM7PKa+6YPenwqUPI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731410001; c=relaxed/simple;
	bh=NCmGlj6LdrRJmR+7Sar/0GcMISWPS2ICJdAy4FYwhVU=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=n5voBeUdJMuprxGYszUWGtAzxyPSYHq9oWUuNEJgYjGHhFTu3+ze1wbCNp/8BUYCajTerXOUkOiI1I/0z6loepXbcKaLPhRfkkDQNPaQsRGBQjK+lX+gFQ0+pS8ChtyBwTvr8cUQruWj+6f3Yp8h1kiuhDV4GOYQUzRZpbahs7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.190
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.234])
	by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4XnkHz2d2Bz2Dbyv;
	Tue, 12 Nov 2024 19:11:27 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (unknown [7.185.36.66])
	by mail.maildlp.com (Postfix) with ESMTPS id 1ADC8140113;
	Tue, 12 Nov 2024 19:13:16 +0800 (CST)
Received: from [10.67.111.104] (10.67.111.104) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 12 Nov 2024 19:13:15 +0800
Message-ID: <fa6f17d8-f1fa-4e74-9b44-9217d4ade50e@huawei.com>
Date: Tue, 12 Nov 2024 19:13:14 +0800
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/3] bcachefs: avoid copy from NULL printbuf when
 allocation failure
To: David Disseldorp <ddiss@suse.de>
CC: <kent.overstreet@linux.dev>, <linux-bcachefs@vger.kernel.org>
References: <20241112074745.407848-1-lihongbo22@huawei.com>
 <20241112074745.407848-3-lihongbo22@huawei.com>
 <20241112205025.6eb8c1d3.ddiss@suse.de>
Content-Language: en-US
From: Hongbo Li <lihongbo22@huawei.com>
In-Reply-To: <20241112205025.6eb8c1d3.ddiss@suse.de>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpeml500022.china.huawei.com (7.185.36.66)



On 2024/11/12 17:50, David Disseldorp wrote:
> On Tue, 12 Nov 2024 15:47:44 +0800, Hongbo Li wrote:
> 
>> printbuf.buf may be NULL if allocation_failure is true. Check
>> for this prior to using it as a seq_printf source.
>>
>> Fixes: fa8e94faeece ("bcachefs: Heap allocate printbufs")
>> Signed-off-by: David Disseldorp <ddiss@suse.de>
> 
> This is quite different compared to the patch I initially submitted, so
> please drop my sign-off tag.
ok, I will do it in the next version.

Thanks,
Hongbo

> 
> Thanks, David

Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC6C81F947;
	Wed,  9 Oct 2024 01:28:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.190
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728437291; cv=none; b=stDW8FRqjZXKdiL5lcasbGAQjU8cZkI/3PHa/Oyutrn/S5y5tY1zbT5TxTgwuLrqIG+jlVNUnc/9Qw7/3TbBu2PjaYQp6IxR9YBg7EX/dWXpfbs4cjLVkwgc+iH78EzUYEN1AnLZOnZShxufpkDSinKcpJGI39vOZ4csMLGPmTQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728437291; c=relaxed/simple;
	bh=Zt+WvHMFV+vq/afMTD+xu/ynJMNR45HNAScKN6fRejY=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=r/HaZMoOUGlsyYOWqPpBTnC9imFp9cvWHfa2JT5QD3LWNBIjjpxIdA+4Lepiue6m5vc4nbfeppC0YEVI5zBw+fBXtR0vnow79deiNX/eQnPo57tAyoJ5NVtmdtCyANGjB8Qg0nuQ7tAXkTW0qNVoJiYKTwwxBpFZBtFcxP88AS4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.190
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.214])
	by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4XNZxm3CtFz20q26;
	Wed,  9 Oct 2024 09:27:24 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (unknown [7.185.36.66])
	by mail.maildlp.com (Postfix) with ESMTPS id 90A2D1A016C;
	Wed,  9 Oct 2024 09:28:00 +0800 (CST)
Received: from [10.67.111.104] (10.67.111.104) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 9 Oct 2024 09:28:00 +0800
Message-ID: <d7604803-a26b-448e-a4d8-7247f8ca7bf2@huawei.com>
Date: Wed, 9 Oct 2024 09:28:00 +0800
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH resend v3] bcachefs: Fix NULL pointer dereference in
 bch2_opt_to_text
To: Mohammed Anees <pvmohammedanees2003@gmail.com>
CC: <kent.overstreet@linux.dev>, <linux-bcachefs@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>,
	<syzbot+37186860aa7812b331d5@syzkaller.appspotmail.com>
References: <f8fcc1e6-6de6-4d60-83a7-83e95a7d6b6e@huawei.com>
 <20241008135105.7426-1-pvmohammedanees2003@gmail.com>
Content-Language: en-US
From: Hongbo Li <lihongbo22@huawei.com>
In-Reply-To: <20241008135105.7426-1-pvmohammedanees2003@gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpeml500022.china.huawei.com (7.185.36.66)



On 2024/10/8 21:51, Mohammed Anees wrote:
> Hi Hongbo,
> 
>> As definition, max is the right bound for value. opt->max - 1 is valid.
>> May be you should remove the equals sign.
> 
> This is not true, max is not the right upper bound when it comes to
> this but rather the size of the array instead, therefore opt->max - 1
> is where we should stop.
> 
> const struct bch_option bch2_opt_table[] = {
> #define OPT_BOOL()		.type = BCH_OPT_BOOL, .min = 0, .max = 2
> #define OPT_UINT(_min, _max)	.type = BCH_OPT_UINT,			\
> 				.min = _min, .max = _max
> #define OPT_STR(_choices)	.type = BCH_OPT_STR,			\
> 				.min = 0, .max = ARRAY_SIZE(_choices),	\
> 				.choices = _choices
> ...
> 
> Here if you look at OPT_STR you see that it is indeed the size
> of the array.
> 
>> It should be no problem to just solve this null pointer issue() (How is
>> this stack triggered, may be I lost something.), but this should be a
> 
> The reason this is triggered is because in bch2_opt_to_text,
> the parameter v passed is beyond the number of options available
> to Opt_str_hash.
> 
> #define BCH_STR_HASH_OPTS()		\
> 	x(crc32c,		0)	\
> 	x(crc64,		1)	\
> 	x(siphash,		2)
> 

ok, got! the length of bch2_str_hash_types is bigger than 
BCH_STR_HASH_OPTS, I miss this. Thank you.

> Passing a value v of 3 attempts to access a non-existent fourth element.
> This value v corresponds to str_hash in the bch_opts structure within the
> bch_fs struct. Since print_mount_opts checks each option, it seems
> appropriate to add the validation there. Please let me know if
> I've misunderstood anything.

This situation is due to syzbot constructing abnormal data, for example, 
in the case of bool type option, there may not be an exception here, but 
the printed values may no longer be 0 or 1, this will not cause program 
failure, but it does not match the expected value. Moreover, for 
BITFIELD type option, the value may also exceed the number of bits, 
which should also pose a risk of overflow when printing in prt_bitflags.

Thanks,
Hongbo
> 
> Thanks!
> 

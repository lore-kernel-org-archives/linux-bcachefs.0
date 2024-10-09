Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6C6518B470;
	Wed,  9 Oct 2024 09:12:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728465140; cv=none; b=awZ1p1F+/R/8JaH7/MHJEiO1tXbLwuABwRtO1a9crWUvJMnPwtILtnjoQT6tJu9mg9ztYPRnOQ+hCVbN/9MIT9BYTwvrWSBLCFYAQTs4miEsJQuNJ0X5vtv5dD9wrBmzds7rfej9zvkMpquR6TwNkv6E08KxRzyZtZtycp+DfiI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728465140; c=relaxed/simple;
	bh=axBkdDqEu3amusqnhXgImOWdAOKcm/T0veqzbgfWEpk=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:CC:References:
	 In-Reply-To:Content-Type; b=OHqI5fIHukvqZKmI9+HR53jQWmk8C5bcZHx8PZqiy0I1hAlpXrjgPK4taDGQ+sq/s0BGuasxnUKqQxedryuQZ50guir30GjVwiT62Fqzvrb74icF35FQMBqOX9MuXlr9PUulEAUgxGm6F2e8I7fyeDsCL7JNZ0xMMOceJlExViw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.252])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4XNnDd61p5zySsd;
	Wed,  9 Oct 2024 17:10:57 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (unknown [7.185.36.66])
	by mail.maildlp.com (Postfix) with ESMTPS id 151371800A7;
	Wed,  9 Oct 2024 17:12:14 +0800 (CST)
Received: from [10.67.111.104] (10.67.111.104) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 9 Oct 2024 17:12:13 +0800
Message-ID: <b77b8915-5035-40af-9b11-466fb5adbf5a@huawei.com>
Date: Wed, 9 Oct 2024 17:12:14 +0800
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] bcachefs: Fix shift-out-of-bounds in
 bch2_stripe_to_text
Content-Language: en-US
From: Hongbo Li <lihongbo22@huawei.com>
To: Zhao Mengmeng <zhaomzhao@126.com>, <kent.overstreet@linux.dev>,
	<zhaomengmeng@kylinos.cn>
CC: <linux-bcachefs@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20241009054325.438556-1-zhaomzhao@126.com>
 <b1c2154d-189a-43fa-84ff-a0d96787ff60@huawei.com>
In-Reply-To: <b1c2154d-189a-43fa-84ff-a0d96787ff60@huawei.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpeml500022.china.huawei.com (7.185.36.66)



On 2024/10/9 17:10, Hongbo Li wrote:
> 
> 
> On 2024/10/9 13:43, Zhao Mengmeng wrote:
>> From: Zhao Mengmeng <zhaomengmeng@kylinos.cn>
>>
>> syzbot report a shift-out-of-bounds issue:
>> ------------[ cut here ]------------
>> UBSAN: shift-out-of-bounds in fs/bcachefs/ec.c:147:2
>> shift exponent 108 is too large for 32-bit type 'unsigned int'
>> ----
>> Here s.csum_granularity_bits = 108, so shift is impossible for unsigned
>> int. To fix, add a check in bch2_stripe_validate() to bail out, it has
>> same checking logic with ec_stripe_key_init().
>>
>> Reported-by: syzbot+f8c98a50c323635be65d@syzkaller.appspotmail.com
>> Tested-by: syzbot+f8c98a50c323635be65d@syzkaller.appspotmail.com
>> Closes: https://syzkaller.appspot.com/bug?extid=f8c98a50c323635be65d
>> Suggested-by: Hongbo Li <lihongbo22@huawei.com>
>> Signed-off-by: Zhao Mengmeng <zhaomengmeng@kylinos.cn>
>> ---
>>   fs/bcachefs/ec.c      | 6 ++++++
>>   fs/bcachefs/errcode.h | 3 ++-
>>   2 files changed, 8 insertions(+), 1 deletion(-)
>>
>> diff --git a/fs/bcachefs/ec.c b/fs/bcachefs/ec.c
>> index 141a4c63142f..bc5ff1331c6f 100644
>> --- a/fs/bcachefs/ec.c
>> +++ b/fs/bcachefs/ec.c
>> @@ -113,6 +113,12 @@ int bch2_stripe_validate(struct bch_fs *c, struct 
>> bkey_s_c k,
>>       const struct bch_stripe *s = bkey_s_c_to_stripe(k).v;
>>       int ret = 0;
>> +    if (s->csum_granularity_bits >= ilog2(le16_to_cpu(s->sectors))) {
> 
> csum_granularity_bits should do the left shift.
oh no, I miss your ilog2 helper.
> 
>> +        bch_err_ratelimited(c, "stripe csum gran bits %u too big",
>> +                    s->csum_granularity_bits);
>> +        return -BCH_ERR_stripe_csum_granularity_bits_too_big;
>> +    }
>> +
>>       bkey_fsck_err_on(bkey_eq(k.k->p, POS_MIN) ||
>>                bpos_gt(k.k->p, POS(0, U32_MAX)),
>>                c, stripe_pos_bad,
>> diff --git a/fs/bcachefs/errcode.h b/fs/bcachefs/errcode.h
>> index 742dcdd3e5d7..14ba6bc7a029 100644
>> --- a/fs/bcachefs/errcode.h
>> +++ b/fs/bcachefs/errcode.h
>> @@ -258,7 +258,8 @@
>>       x(BCH_ERR_nopromote,        nopromote_no_writes)            \
>>       x(BCH_ERR_nopromote,        nopromote_enomem)            \
>>       x(0,                invalid_snapshot_node)            \
>> -    x(0,                option_needs_open_fs)
>> +    x(0,                option_needs_open_fs)            \
> There are some changes, this should rebase on the latest tree.
> 
> Thanks,
> Hongbo
>> +    x(EINVAL,            stripe_csum_granularity_bits_too_big)
>>   enum bch_errcode {
>>       BCH_ERR_START        = 2048,

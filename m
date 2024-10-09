Received: from szxga07-in.huawei.com (szxga07-in.huawei.com [45.249.212.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5027F18C91A;
	Wed,  9 Oct 2024 09:25:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.35
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728465951; cv=none; b=lfFYf0Kx7agOA4RpknUJTrhXXJXB4atSgjAN9ToeFF7DKWPtRzOJgK8hojc9B2wk0/9je9GIvmgx0CNTfd92D6XWlJCbgPY77mJJHyzQQYeVydllrcmUg3zbFlrkmOSluSKKabeiBY8QNLNrVVXDK/lfYlREO+BPBEQ4kI8ISQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728465951; c=relaxed/simple;
	bh=i8qUuPXl72YM42vqEQZlOG+NYGtUNHsRsQ5E7hgzw8U=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=ml3iY/Wc0BKvvAoTTZU5S+6gWs+1+vtOwi9XYFjYiL3vBJr0YEhNrHz0vSMuyqK1OCmC15s559CNostv4MOlU5Gu+L5DyT9AmF8PQM0kAbLJQv6CbuXO6N9IyltUJ7tgrZvSJLZNH6na6OZblB3Fxn5Yhx92w4NFI7w2+iaRgoQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.17])
	by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4XNnXQ49wHz1SCJJ;
	Wed,  9 Oct 2024 17:24:38 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (unknown [7.185.36.66])
	by mail.maildlp.com (Postfix) with ESMTPS id 5D3991A0188;
	Wed,  9 Oct 2024 17:25:44 +0800 (CST)
Received: from [10.67.111.104] (10.67.111.104) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 9 Oct 2024 17:25:44 +0800
Message-ID: <45174791-f446-4edf-9ccd-c0021eec2895@huawei.com>
Date: Wed, 9 Oct 2024 17:25:45 +0800
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] bcachefs: Fix shift-out-of-bounds in
 bch2_stripe_to_text
To: Zhao Mengmeng <zhaomengmeng@kylinos.cn>, Zhao Mengmeng
	<zhaomzhao@126.com>, <kent.overstreet@linux.dev>
CC: <linux-bcachefs@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20241009054325.438556-1-zhaomzhao@126.com>
 <b1c2154d-189a-43fa-84ff-a0d96787ff60@huawei.com>
 <633662aa-120c-40e0-a836-da5faa7ed312@kylinos.cn>
Content-Language: en-US
From: Hongbo Li <lihongbo22@huawei.com>
In-Reply-To: <633662aa-120c-40e0-a836-da5faa7ed312@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggpeml500022.china.huawei.com (7.185.36.66)



On 2024/10/9 17:16, Zhao Mengmeng wrote:
> On 2024/10/9 17:10, Hongbo Li wrote:
>>
>>
>> On 2024/10/9 13:43, Zhao Mengmeng wrote:
>>> From: Zhao Mengmeng <zhaomengmeng@kylinos.cn>
>>>
>>> syzbot report a shift-out-of-bounds issue:
>>> ------------[ cut here ]------------
>>> UBSAN: shift-out-of-bounds in fs/bcachefs/ec.c:147:2
>>> shift exponent 108 is too large for 32-bit type 'unsigned int'
>>> ----
>>> Here s.csum_granularity_bits = 108, so shift is impossible for unsigned
>>> int. To fix, add a check in bch2_stripe_validate() to bail out, it has
>>> same checking logic with ec_stripe_key_init().
>>>
>>> Reported-by: syzbot+f8c98a50c323635be65d@syzkaller.appspotmail.com
>>> Tested-by: syzbot+f8c98a50c323635be65d@syzkaller.appspotmail.com
>>> Closes: https://syzkaller.appspot.com/bug?extid=f8c98a50c323635be65d
>>> Suggested-by: Hongbo Li <lihongbo22@huawei.com>
>>> Signed-off-by: Zhao Mengmeng <zhaomengmeng@kylinos.cn>
>>> ---
>>>    fs/bcachefs/ec.c      | 6 ++++++
>>>    fs/bcachefs/errcode.h | 3 ++-
>>>    2 files changed, 8 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/fs/bcachefs/ec.c b/fs/bcachefs/ec.c
>>> index 141a4c63142f..bc5ff1331c6f 100644
>>> --- a/fs/bcachefs/ec.c
>>> +++ b/fs/bcachefs/ec.c
>>> @@ -113,6 +113,12 @@ int bch2_stripe_validate(struct bch_fs *c, struct bkey_s_c k,
>>>        const struct bch_stripe *s = bkey_s_c_to_stripe(k).v;
>>>        int ret = 0;
>>>    +    if (s->csum_granularity_bits >= ilog2(le16_to_cpu(s->sectors))) {
>>
>> csum_granularity_bits should do the left shift.
> 
> If use `1 << s->csum_granularity_bits(108)` to do the check, syzbot will still trigger shift-out-of
> bounds warning. So better check the bits directly.
> 
You are right! :)

Thanks
Hongbo

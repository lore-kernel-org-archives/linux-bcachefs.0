Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B937863D5;
	Thu, 10 Oct 2024 01:39:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728524387; cv=none; b=k+RuVo/OCAB+wymjNOQFOzrySKhJGcLh6atvC7AS7e0KhaGboPsPz5s4NGWMndDw4rWIREU+LMTabDDpUZL5pPLIFcWcxHjfFEfdIvNLONAsmVb5/lAMV5agAgalA6VcvieiNjmQ9c939EkT4oEJvBiSd7UpqABBssxHwDt4wa0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728524387; c=relaxed/simple;
	bh=YM/PsU898sOEccodzl0DMR/xWt0KDevncMELWMotMLc=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=jYTmSk9wn+0mPquBOK7M22tV8h5Jmt/qmTui47vlxqmBTpkHAtAsX4l3JH4G2hKiPGKtJbBdfpaDnO1ToFArIinpgQfA/FufQiG/bqCn6y7d4GxbymTRrvKUbzvom+0nl+dLpYaNU/joNCEYEh/rSXyUvyfs6Q+yuTeA6FmG2PE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.162.254])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4XPC6h646xzfdDc;
	Thu, 10 Oct 2024 09:37:16 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (unknown [7.185.36.66])
	by mail.maildlp.com (Postfix) with ESMTPS id DF84F180105;
	Thu, 10 Oct 2024 09:39:40 +0800 (CST)
Received: from [10.67.111.104] (10.67.111.104) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 10 Oct 2024 09:39:40 +0800
Message-ID: <c6baa632-59b4-4303-9935-e3cc11e79b31@huawei.com>
Date: Thu, 10 Oct 2024 09:39:41 +0800
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] bcachefs: Fix shift-out-of-bounds in
 bch2_stripe_to_text
To: Zhao Mengmeng <zhaomzhao@126.com>, <kent.overstreet@linux.dev>,
	<zhaomengmeng@kylinos.cn>
CC: <linux-bcachefs@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20241009140755.725629-1-zhaomzhao@126.com>
Content-Language: en-US
From: Hongbo Li <lihongbo22@huawei.com>
In-Reply-To: <20241009140755.725629-1-zhaomzhao@126.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggpeml500022.china.huawei.com (7.185.36.66)



On 2024/10/9 22:07, Zhao Mengmeng wrote:
> From: Zhao Mengmeng <zhaomengmeng@kylinos.cn>
> 
> syzbot report a shift-out-of-bounds issue:
> ------------[ cut here ]------------
> UBSAN: shift-out-of-bounds in fs/bcachefs/ec.c:147:2
> shift exponent 108 is too large for 32-bit type 'unsigned int'
> ----
> Here s.csum_granularity_bits = 108, so shift is impossible for unsigned
> int. To fix, add a check in bch2_stripe_validate() to bail out, it has
> same checking logic with ec_stripe_key_init().
> 
> Reported-by: syzbot+f8c98a50c323635be65d@syzkaller.appspotmail.com
> Tested-by: syzbot+f8c98a50c323635be65d@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=f8c98a50c323635be65d
> Suggested-by: Hongbo Li <lihongbo22@huawei.com>
> Signed-off-by: Zhao Mengmeng <zhaomengmeng@kylinos.cn>

Reviewed-by: Hongbo Li <lihongbo22@huawei.com>

Thanks,
Hongbo

> ---
>   fs/bcachefs/ec.c      | 6 ++++++
>   fs/bcachefs/errcode.h | 4 +++-
>   2 files changed, 9 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/bcachefs/ec.c b/fs/bcachefs/ec.c
> index 564841e5a24b..f6a02123144d 100644
> --- a/fs/bcachefs/ec.c
> +++ b/fs/bcachefs/ec.c
> @@ -114,6 +114,12 @@ int bch2_stripe_validate(struct bch_fs *c, struct bkey_s_c k,
>   	const struct bch_stripe *s = bkey_s_c_to_stripe(k).v;
>   	int ret = 0;
>   
> +	if (s->csum_granularity_bits >= ilog2(le16_to_cpu(s->sectors))) {
> +		bch_err_ratelimited(c, "stripe csum gran bits %u too big",
> +				    s->csum_granularity_bits);
> +		return -BCH_ERR_stripe_csum_granularity_bits_too_big;
> +	}
> +
>   	bkey_fsck_err_on(bkey_eq(k.k->p, POS_MIN) ||
>   			 bpos_gt(k.k->p, POS(0, U32_MAX)),
>   			 c, stripe_pos_bad,
> diff --git a/fs/bcachefs/errcode.h b/fs/bcachefs/errcode.h
> index 26990ad584d5..83659cdb93c8 100644
> --- a/fs/bcachefs/errcode.h
> +++ b/fs/bcachefs/errcode.h
> @@ -270,7 +270,9 @@
>   	x(BCH_ERR_nopromote,		nopromote_enomem)			\
>   	x(0,				invalid_snapshot_node)			\
>   	x(0,				option_needs_open_fs)			\
> -	x(0,				remove_disk_accounting_entry)
> +	x(0,				remove_disk_accounting_entry)		\
> +	x(EINVAL,			stripe_csum_granularity_bits_too_big)
> +
>   
>   enum bch_errcode {
>   	BCH_ERR_START		= 2048,

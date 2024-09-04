Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 200AA83CA3
	for <linux-bcachefs@vger.kernel.org>; Wed,  4 Sep 2024 07:12:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725433965; cv=none; b=nFOgMqWfd47tEqEp3e15q+zFXkB+RpHchSTCeMRwviUOITFQITPDXn/lQ45s0dsAqu4L6Afd27lHQg8lwZGvTvPV3U4xLiG/E6JDI5gqLKkgqM9p+LUYgjykgtHGW/8JvbaOq8dqq4LHZrDM2Rak7PkDEGj3cBU/E5uys1hld+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725433965; c=relaxed/simple;
	bh=lwvS7i0ATT3DuqBD1SAeFZPvPlsgCMezR+LUElKNLKY=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=YSHRDdAqzfjXeG00Yd92QFLVQ0gTRwnBBRWMNJ1hcKFJvFYNZH3FiO1XNfCUODFqD+h1oLHsYsONp2aN+zDuajKnjMcPSqylybm4bBlmO5qIPfrnWge9z/rseTPnPelwif6aFtknc5RJUp42bD6hy/SoGH0u9oqHOsFcfu0/XRc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.194])
	by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4WzD8S3GqXz69L9;
	Wed,  4 Sep 2024 15:07:36 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (unknown [7.185.36.66])
	by mail.maildlp.com (Postfix) with ESMTPS id CA0921400CA;
	Wed,  4 Sep 2024 15:12:33 +0800 (CST)
Received: from [10.67.111.104] (10.67.111.104) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 4 Sep 2024 15:12:33 +0800
Message-ID: <ea07e075-de91-40cf-ae14-5542f34c48ae@huawei.com>
Date: Wed, 4 Sep 2024 15:12:33 +0800
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] bcachefs: Fix compilation error for bch2_sb_member_alloc
Content-Language: en-US
To: <kent.overstreet@linux.dev>
CC: <linux-bcachefs@vger.kernel.org>
References: <20240904071532.2812271-1-lihongbo22@huawei.com>
From: Hongbo Li <lihongbo22@huawei.com>
In-Reply-To: <20240904071532.2812271-1-lihongbo22@huawei.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpeml500022.china.huawei.com (7.185.36.66)



On 2024/9/4 15:15, Hongbo Li wrote:
> Fix the following compilation error:
> 
> ```
> fs/bcachefs/sb-members.c: In function ‘bch2_sb_member_alloc’:
> fs/bcachefs/sb-members.c:508:2: error: a label can only be part of a statement and a declaration is not a statement
>    508 |  unsigned nr_devices = max_t(unsigned, dev_idx + 1, c->sb.nr_devices);
> ```
> 
> Fixes: a7d364a133c7 ("bcachefs: bch2_sb_member_alloc()")
> Signed-off-by: Hongbo Li <lihongbo22@huawei.com>
> ---
>   fs/bcachefs/sb-members.c | 16 ++++++++++------
>   1 file changed, 10 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/bcachefs/sb-members.c b/fs/bcachefs/sb-members.c
> index 2aad62961938..02bcde3c1b02 100644
> --- a/fs/bcachefs/sb-members.c
> +++ b/fs/bcachefs/sb-members.c
> @@ -478,11 +478,15 @@ unsigned bch2_sb_nr_devices(const struct bch_sb *sb)
>   int bch2_sb_member_alloc(struct bch_fs *c)
>   {
>   	unsigned dev_idx = c->sb.nr_devices;
> +	struct bch_sb_field_members_v2 *mi;
> +	unsigned nr_devices;
> +	unsigned u64s;
> +	int best = -1;
> +	u64 best_last_mount = 0;
> +
>   	if (dev_idx < BCH_SB_MEMBERS_MAX)
>   		goto have_slot;
>   
> -	int best = -1;
> -	u64 best_last_mount = 0;
>   	for (dev_idx = 0; dev_idx < BCH_SB_MEMBERS_MAX; dev_idx++) {
>   		/* eventually BCH_SB_MEMBERS_MAX will be raised */
>   		if (dev_idx == BCH_SB_MEMBER_INVALID)
> @@ -505,11 +509,11 @@ int bch2_sb_member_alloc(struct bch_fs *c)
>   
>   	return -BCH_ERR_ENOSPC_sb_members;
>   have_slot:
Or add ";" after this label. But I choice move the declared variables to 
the front. May be this way is more closely to the specifications.

Thanks,
Hongbo

> -	unsigned nr_devices = max_t(unsigned, dev_idx + 1, c->sb.nr_devices);
> +	nr_devices = max_t(unsigned, dev_idx + 1, c->sb.nr_devices);
>   
> -	struct bch_sb_field_members_v2 *mi = bch2_sb_field_get(c->disk_sb.sb, members_v2);
> -	unsigned u64s = DIV_ROUND_UP(sizeof(struct bch_sb_field_members_v2) +
> -				     le16_to_cpu(mi->member_bytes) * nr_devices, sizeof(u64));
> +	mi = bch2_sb_field_get(c->disk_sb.sb, members_v2);
> +	u64s = DIV_ROUND_UP(sizeof(struct bch_sb_field_members_v2) +
> +			    le16_to_cpu(mi->member_bytes) * nr_devices, sizeof(u64));
>   
>   	mi = bch2_sb_field_resize(&c->disk_sb, members_v2, u64s);
>   	if (!mi)

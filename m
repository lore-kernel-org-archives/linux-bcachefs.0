Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F1A512D1FA
	for <linux-bcachefs@vger.kernel.org>; Thu, 18 Jul 2024 11:21:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.255
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721301667; cv=none; b=QNCZuWHd5XWidZpV9Ac9K9/TnZ3TTo7M3KI4cT/ssiU77mqaEfsReW/tGF1Nb90BoRL4Lc5jzCaxlJWE9V5lOY1/H5ppipeUABd38gRDSc0Q/6LyD+V7meN9c3rkKnBPYA3znP6QSNZDAUFYSRUdbljhEm7Tvljzy/m+IYmteIk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721301667; c=relaxed/simple;
	bh=vXS3upptxNhN6w9GJnnMN7hOR7YF2Xi1b20TcQVLqU8=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=OCEZaUhGqD0F0uc2cLMS1zVgxVDF/o7lJfIkPS9f7Ic3Yt7WDdiJTzTYsHEjS00e2tui05xHw2i+omdk5PImYKu8ydNNDEAqTNmPGYbfwb+uiGDdzrdcRRa5MMe6Su8OmHIf9bNgkJB05cpAUbLDy/zubpnYGPPvCWC16G3Nxlk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.255
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.252])
	by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4WPqxM3lHJz1JCnx;
	Thu, 18 Jul 2024 19:16:07 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (unknown [7.185.36.66])
	by mail.maildlp.com (Postfix) with ESMTPS id A0AE01800A3;
	Thu, 18 Jul 2024 19:21:00 +0800 (CST)
Received: from [10.67.111.104] (10.67.111.104) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 18 Jul 2024 19:21:00 +0800
Message-ID: <4574f022-0254-4f84-a2c8-5458956661ae@huawei.com>
Date: Thu, 18 Jul 2024 19:20:59 +0800
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] libbcachefs: add support for true/false & yes/no in
 bool-type options
To: Integral <integral@murena.io>, <kent.overstreet@gmail.com>
CC: <linux-bcachefs@vger.kernel.org>
References: <20240718071346.68754-3-integral@murena.io>
Content-Language: en-US
From: Hongbo Li <lihongbo22@huawei.com>
In-Reply-To: <20240718071346.68754-3-integral@murena.io>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpeml500022.china.huawei.com (7.185.36.66)



On 2024/7/18 15:13, Integral wrote:
> This is a resend of my previous patch with code style optimized as I
> forgot to add Kent Overstreet in "To". The previous patch is
> (https://lore.kernel.org/linux-bcachefs/20240718062835.58037-2-integral@murena.io/T/#u).
> 
> Currently, when using bcachefs-tools to set options, bool-type options can
> only accept 1 or 0. Add support for accepting true/false and yes/no for
> these options.
> 
> ---
>   libbcachefs/opts.c | 16 +++++++++-------
Generating diff on bcachefs tree (not bcachefs-tools)?
>   1 file changed, 9 insertions(+), 7 deletions(-)
> 
> diff --git a/libbcachefs/opts.c b/libbcachefs/opts.c
> index 0770aebe..e6ebc4c1 100644
> --- a/libbcachefs/opts.c
> +++ b/libbcachefs/opts.c
> @@ -332,17 +332,19 @@ int bch2_opt_parse(struct bch_fs *c,
>   	switch (opt->type) {
>   	case BCH_OPT_BOOL:
>   		if (val) {
> -			ret = kstrtou64(val, 10, res);
> +			if (!strcmp(val, "1") || !strcmp(val, "true") || !strcmp(val, "yes")) {
Should we use the strcasecmp replace the strcmp?

Thanks,
Hongbo
> +				*res = 1;
> +			} else if (!strcmp(val, "0") || !strcmp(val, "false") || !strcmp(val, "no")) {
> +				*res = 0;
> +			} else {
> +				if (err)
> +					prt_printf(err, "%s: must be bool", opt->attr.name);
> +				return -BCH_ERR_option_not_bool;
> +			}
>   		} else {
> -			ret = 0;
>   			*res = 1;
>   		}
>   
> -		if (ret < 0 || (*res != 0 && *res != 1)) {
> -			if (err)
> -				prt_printf(err, "%s: must be bool", opt->attr.name);
> -			return ret < 0 ? ret : -BCH_ERR_option_not_bool;
> -		}
>   		break;
>   	case BCH_OPT_UINT:
>   		if (!val) {

Received: from szxga07-in.huawei.com (szxga07-in.huawei.com [45.249.212.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD00536B
	for <linux-bcachefs@vger.kernel.org>; Wed, 23 Oct 2024 01:04:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.35
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729645449; cv=none; b=iZftNfRKu6QaFjG/x8Us6hQiaAMBP1ALWqQ82OKM83OfUXahT3mYGt8cXl4s8RiPCLY31WZPVLkAUQAQzBf6abZyWIejm6gONEm6mLHwnVia4EYOLUpcy90QKPNG1Us236S32iNGENJlUDMuuvS/HR7sDBJxXxGdIMo4t1qDwH0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729645449; c=relaxed/simple;
	bh=4Tib3Zkk8XarM9gHKCu+3dGUjbu5IyjIGgeJHKM8FNA=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=Tv6VuT1rmqFBXmWd0wOAJVMFUHXw31CFhoDaBHeHlv5DfoIX+yskhCBG79tMxkZMKsSJ43x0WwyoyXzTS+gV1wwEiGxERbqorKsvDM59oKux6INnEp3rZq60ia4JDzlHMndNdzPiR91BhknoCPf7EJD5L8r7gcoks7UiMpuMwlE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.214])
	by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4XY9kg39V9z1SD2K;
	Wed, 23 Oct 2024 09:02:35 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (unknown [7.185.36.66])
	by mail.maildlp.com (Postfix) with ESMTPS id ACFB41A016C;
	Wed, 23 Oct 2024 09:03:58 +0800 (CST)
Received: from [10.67.111.104] (10.67.111.104) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 23 Oct 2024 09:03:58 +0800
Message-ID: <916cace5-ecf5-426d-a215-17e1107fef88@huawei.com>
Date: Wed, 23 Oct 2024 09:03:56 +0800
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] bcachefs: add support for true/false & yes/no in
 bool-type options
To: Integral <integral@murena.io>
CC: <kent.overstreet@gmail.com>, <kent.overstreet@linux.dev>,
	<linux-bcachefs@vger.kernel.org>, <mmpgouride@gmail.com>
References: <70f82243-359c-4b1e-a9c9-1ecbe1ea9020@huawei.com>
 <20241022131218.300195-3-integral@murena.io>
Content-Language: en-US
From: Hongbo Li <lihongbo22@huawei.com>
In-Reply-To: <20241022131218.300195-3-integral@murena.io>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpeml500022.china.huawei.com (7.185.36.66)



On 2024/10/22 21:12, Integral wrote:
> Here is my modified patch:
> 
> Currently, when using bcachefs-tools to set options, bool-type options
> can only accept 1 or 0. Add support for accepting true/false and yes/no
> for these options.
> 
> Signed-off-by: Integral <integral@murena.io>
> ---
>   fs/bcachefs/opts.c | 26 +++++++++++++++++++-------
>   1 file changed, 19 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/bcachefs/opts.c b/fs/bcachefs/opts.c
> index 68d240126522..26319e7a1c4b 100644
> --- a/fs/bcachefs/opts.c
> +++ b/fs/bcachefs/opts.c
> @@ -1,6 +1,7 @@
>   // SPDX-License-Identifier: GPL-2.0
>   
>   #include <linux/kernel.h>
> +#include <linux/fs_parser.h>
>   
>   #include "bcachefs.h"
>   #include "compress.h"
> @@ -322,6 +323,16 @@ int bch2_opt_validate(const struct bch_option *opt, u64 v, struct printbuf *err)
>   	return 0;
>   }
>   
> +static const struct constant_table bch2_opt_bool_names[] = {
> +	{ "0",		false },
> +	{ "false",	false },
> +	{ "no",		false },
> +	{ "1",		true },
> +	{ "true",	true },
> +	{ "yes",	true },
> +	{ },
> +};
> +
>   int bch2_opt_parse(struct bch_fs *c,
>   		   const struct bch_option *opt,
>   		   const char *val, u64 *res,
> @@ -332,17 +343,18 @@ int bch2_opt_parse(struct bch_fs *c,
>   	switch (opt->type) {
>   	case BCH_OPT_BOOL:
>   		if (val) {
> -			ret = kstrtou64(val, 10, res);
> +			ret = lookup_constant(bch2_opt_bool_names, val, -BCH_ERR_option_not_bool);
> +			if (ret != BCH_ERR_option_not_bool) {
Should it also be modified? Other seems good for me. :)

Thanks,
Hongbo

> +				*res = ret;
> +			} else {
> +				if (err)
> +					prt_printf(err, "%s: must be bool", opt->attr.name);
> +				return ret;
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

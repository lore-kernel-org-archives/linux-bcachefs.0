Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2946B149DF7
	for <linux-bcachefs@vger.kernel.org>; Wed, 23 Oct 2024 06:41:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.190
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729665681; cv=none; b=ovVyk2wV4JMB+DpFX2TFuYikh0U4fUmlpGQE9CQ4hxyshREWBaasn+nyRjoOc6rcfTChtHMhzyo389lFgidxA4O3sZXZ8Ky2SCrd2KPpQ+OvvKhV/4JdLXnOxbbAkyoW+q1FL0keWk5nf82l8hKhVZn3tGuhIzPJZkf50LkWMgg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729665681; c=relaxed/simple;
	bh=uD5EtdX6+UADjI//GWifzRLr19CK2SSlhfUI62astpU=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=C2IqzNkV+35jOUgp5/fRsW1ozp1EoM/KF9flPE4zweyrrDP1SGi7KQIkJ/mDQO/Y/m2PMpJXSnODdlFc1kwxOKFxHX3VcPgB0CVLBgIxiwXyldzCm9U3uLliX/L5wg4Ws+SiBv9KudUxBAsY0Bj2nLDCBnoaXYpM/GiWUu14yI4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.190
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.162.112])
	by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4XYKCs32TNz2FbLq;
	Wed, 23 Oct 2024 14:39:53 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (unknown [7.185.36.66])
	by mail.maildlp.com (Postfix) with ESMTPS id 61B29140337;
	Wed, 23 Oct 2024 14:41:16 +0800 (CST)
Received: from [10.67.111.104] (10.67.111.104) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 23 Oct 2024 14:41:16 +0800
Message-ID: <1d336f3a-2162-4d59-b376-29f2b818cb06@huawei.com>
Date: Wed, 23 Oct 2024 14:41:13 +0800
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4] libbcachefs: add support for true/false & yes/no in
 bool-type options
To: Integral <integral@murena.io>
CC: <kent.overstreet@gmail.com>, <kent.overstreet@linux.dev>,
	<linux-bcachefs@vger.kernel.org>, <mmpgouride@gmail.com>
References: <916cace5-ecf5-426d-a215-17e1107fef88@huawei.com>
 <20241023051504.59321-2-integral@murena.io>
Content-Language: en-US
From: Hongbo Li <lihongbo22@huawei.com>
In-Reply-To: <20241023051504.59321-2-integral@murena.io>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpeml500022.china.huawei.com (7.185.36.66)



On 2024/10/23 13:15, Integral wrote:
> Here is my latest patch:
> 
> Currently, when using bcachefs-tools to set options, bool-type options
> can only accept 1 or 0. Add support for accepting true/false and yes/no
> for these options.
> 
Looks good to me! :)

Thanks
Hongbo

> Signed-off-by: Integral <integral@murena.io>
> ---
>   fs/bcachefs/opts.c | 26 +++++++++++++++++++-------
>   1 file changed, 19 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/bcachefs/opts.c b/fs/bcachefs/opts.c
> index 68d240126522..2d81e39ddd73 100644
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
> +			if (ret != -BCH_ERR_option_not_bool) {
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

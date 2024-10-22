Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13871199246
	for <linux-bcachefs@vger.kernel.org>; Tue, 22 Oct 2024 12:13:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729599193; cv=none; b=HSjUKijz8qUzOcChg+eLwDYWk8M3A1dASPOZghDUgnxOi1aNmkqffI+50pQ6UxKdllpaKc0CAD8Ank5b3kuNF92c7pNZM7Omtnr8oTlatUFK7EswGXhUYb5rSTXWl4KnnpdBKnmfHO3raIOO1a6Mx3UBZgESwP3WcGdh4z5i9Lc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729599193; c=relaxed/simple;
	bh=H0zYx8JlVTSbajyseH849IF6Nap8/o+hbs/UzHfl5t0=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=fCk+viIGHzRPTyZhYZpEh4FbjXAqPcU+PfLvJdr0mCBHrxVDXX6TJwATSQckNCezW40/h0clFk1s3pTx8UtSADV8RSiyCJgLjTlIHdE+ufScuhuLRSMtlSCrWoG1lyAGSZiHX2aeELDvYKUERGCI97VeSqa0YA0KQBxOYMG/iCs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.174])
	by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4XXrds0cXbzQrv9;
	Tue, 22 Oct 2024 20:12:17 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (unknown [7.185.36.66])
	by mail.maildlp.com (Postfix) with ESMTPS id 0DDE114022E;
	Tue, 22 Oct 2024 20:13:08 +0800 (CST)
Received: from [10.67.111.104] (10.67.111.104) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 22 Oct 2024 20:13:07 +0800
Message-ID: <70f82243-359c-4b1e-a9c9-1ecbe1ea9020@huawei.com>
Date: Tue, 22 Oct 2024 20:13:05 +0800
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] bcachefs: add support for true/false & yes/no in
 bool-type options
To: Integral <integral@murena.io>, <mmpgouride@gmail.com>
CC: <kent.overstreet@gmail.com>, <kent.overstreet@linux.dev>,
	<linux-bcachefs@vger.kernel.org>
References: <21B6E9C0-9A84-4B54-9FC8-307E82AB6006@gmail.com>
 <20241003114012.297236-2-integral@murena.io>
Content-Language: en-US
From: Hongbo Li <lihongbo22@huawei.com>
In-Reply-To: <20241003114012.297236-2-integral@murena.io>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpeml500022.china.huawei.com (7.185.36.66)



On 2024/10/3 19:40, Integral wrote:
> Here is my new patch:
> 
> Currently, when using bcachefs-tools to set options, bool-type options can
> only accept 1 or 0. Add support for accepting true/false and yes/no for
> these options.
> 
> Signed-off-by: Integral <integral@murena.io>
> ---
>   fs/bcachefs/opts.c | 28 +++++++++++++++++++++-------
>   1 file changed, 21 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/bcachefs/opts.c b/fs/bcachefs/opts.c
> index 232be8a44051..659536d00cb9 100644
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
> @@ -322,6 +323,18 @@ int bch2_opt_validate(const struct bch_option *opt, u64 v, struct printbuf *err)
>   	return 0;
>   }
>   
> +static const struct constant_table bch2_opt_bool_names[] = {
> +	{ "0",		false },
> +	{ "false",	false },
> +	{ "no",		false },
> +	{ "off",	false },
> +	{ "1",		true },
> +	{ "true",	true },
> +	{ "yes",	true },
> +	{ "on",		true },
> +	{ },
> +};
> +
>   int bch2_opt_parse(struct bch_fs *c,
>   		   const struct bch_option *opt,
>   		   const char *val, u64 *res,
> @@ -332,17 +345,18 @@ int bch2_opt_parse(struct bch_fs *c,
>   	switch (opt->type) {
>   	case BCH_OPT_BOOL:
>   		if (val) {
> -			ret = kstrtou64(val, 10, res);
> +			ret = lookup_constant(bch2_opt_bool_names, val, BCH_ERR_option_not_bool);
> +			if (ret != BCH_ERR_option_not_bool) {

I apologize for looking at your patch so late. But this seems something 
wrong. The third parameter should be -BCH_ERR_option_not_bool. And also 
as noted in [1]. The only accepted bool value are: "0", "1", "no", 
"yes", "false", "true". This just like what has been done in 
fs_param_is_bool helper.

[1] Documentation/filesystems/mount_api.rst

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

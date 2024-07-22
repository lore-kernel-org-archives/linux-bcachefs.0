Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41F992CA9
	for <linux-bcachefs@vger.kernel.org>; Mon, 22 Jul 2024 04:04:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721621044; cv=none; b=s6loppEKaLn2qAwksh0S+svinknKrWtDfAREGKDvKiCVkN2JSgdedQYzmhq1ULOup8NfPhd+xesbW4cZP7ApDw2hL8jVU+nSHWBHMI2rXMXT1q3RrT7Qkb/vwIrJoVc5Ze/Xzo364NTg8hkq4qAVEMzuKa+dPLV5psMpNscaJ/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721621044; c=relaxed/simple;
	bh=qa2GVa6ZzG6053GQbUmFQL9/C0mwXJaOws5Dua6OyQg=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=s1ennVtMiAjSb2NrJz5SgrbJ1+jC4McitAI61jhfVCTjEKbpqfyCTu/hWUNz3COSeGCWrICuiYpsoJ6L6Vl5T3jp5CT5AFXVLQBVoiRiEQf7hH7JLvTyDUbzsusP5aRgu73N+z/A1otJXS9ZXKYt66xyADGsq40tviEB/3n8fXc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.105])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4WS6805l2Jznbwm;
	Mon, 22 Jul 2024 12:03:12 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (unknown [7.185.36.66])
	by mail.maildlp.com (Postfix) with ESMTPS id 2650A140382;
	Mon, 22 Jul 2024 12:03:58 +0800 (CST)
Received: from [10.67.111.104] (10.67.111.104) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 22 Jul 2024 12:03:57 +0800
Message-ID: <55b29fbb-3aa8-4ba7-9668-aa19dbb02e78@huawei.com>
Date: Mon, 22 Jul 2024 12:03:57 +0800
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] Add support for true/false, yes/no & on/off in bool-type
 options
Content-Language: en-US
To: Kent Overstreet <kent.overstreet@linux.dev>, Integral <integral@murena.io>
CC: <kent.overstreet@gmail.com>, <linux-bcachefs@vger.kernel.org>
References: <7f1b35b2-437c-42b2-950b-556ce272c745@huawei.com>
 <20240718122926.99326-3-integral@murena.io>
 <u3wl6277ljmgqlbjw5pxu3oeljgftekeati6xcsyfden25umo6@p3z3z4yc6drg>
From: Hongbo Li <lihongbo22@huawei.com>
In-Reply-To: <u3wl6277ljmgqlbjw5pxu3oeljgftekeati6xcsyfden25umo6@p3z3z4yc6drg>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpeml500022.china.huawei.com (7.185.36.66)



On 2024/7/19 6:50, Kent Overstreet wrote:
> On Thu, Jul 18, 2024 at 08:29:28PM GMT, Integral wrote:
>> Here is the new patch:
>>
>> Currently, when using bcachefs-tools to set options, bool-type options can
>> only accept 1 or 0. Add support for accepting true/false, yes/no &
>> on/off for these options.
>>
>> Signed-off-by: Integral <integral@murena.io>
>> ---
>>   fs/bcachefs/opts.c | 18 +++++++++++-------
>>   1 file changed, 11 insertions(+), 7 deletions(-)
>>
>> diff --git a/fs/bcachefs/opts.c b/fs/bcachefs/opts.c
>> index 0770aebef6d8..0e4cd6984eda 100644
>> --- a/fs/bcachefs/opts.c
>> +++ b/fs/bcachefs/opts.c
>> @@ -332,17 +332,21 @@ int bch2_opt_parse(struct bch_fs *c,
>>   	switch (opt->type) {
>>   	case BCH_OPT_BOOL:
>>   		if (val) {
>> -			ret = kstrtou64(val, 10, res);
>> +			if (!strcasecmp(val, "1") || !strcasecmp(val, "true") ||
>> +				!strcasecmp(val, "yes") || !strcasecmp(val, "on")) {
>> +				*res = 1;
>> +			} else if (!strcasecmp(val, "0") || !strcasecmp(val, "false") ||
>> +				!strcasecmp(val, "no") || !strcasecmp(val, "off")) {
Sorry, may be I was wrong.
>> +				*res = 0;
>> +			} else {
>> +				if (err)
>> +					prt_printf(err, "%s: must be bool", opt->attr.name);
>> +				return -BCH_ERR_option_not_bool;
>> +			}
> 
> There _should_ be something more standard in the kernel for parsing bool
> options (commandline options, module options) - please hunt around for
> that and see if it works; report back on what you find.
I find in Documentation/filesystems/mount_api.rst, it give an explanation.

```
Note that if the value is of fs_param_is_bool type, fs_parse() will try 
 

to match any string value against "0", "1", "no", "yes", "false", "true".
```

But this has been handled in fs_param_is_bool with macro fsparam_bool. 
Many file systems do this in fs_parse. I think the original patch seems ok.

Thanks,
Hongbo

> 
> We want to be consistent on how we parse bools throughout the kernel.

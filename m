Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5948512B7D
	for <linux-bcachefs@vger.kernel.org>; Thu, 22 Feb 2024 01:30:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.191
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708565426; cv=none; b=aeXXhfw2gXQk4rGcVt92geTVHg2cLiKoROXZfsdE6blyZOHOwDuCSMZ9nV1KXTLasq0Sn6TfPRmUme8DgEjyR44hQcIxxc3jU8t7qTT0WGdr7ETp848XlmoScqSILaCnq3LzXnFTt+uMoW1OPg9F/f+271DeFoZlZYCPZefrmcc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708565426; c=relaxed/simple;
	bh=2YQzN3NysKE0UgFuNWwqgiBmM3PpnxBDxodyHlHuClw=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=Z6y5fmM/zdbTVWkLplQw1SLqoOR/Tp39S7z7hEsv6Ihv30fC8VQHZArYasFyFtAqIp0igczUz2D7DWMaly+eG4DQL/27QYK86eKk+P6oy4I/kZ2kVNd4VyHEfGBt/9/MA6BU5apWfOa83E32x+lm0y7d4cerbD77W84MjpiyiJY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.191
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.163])
	by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4TgFnh6bZKz1FL9t;
	Thu, 22 Feb 2024 09:25:28 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (unknown [7.185.36.66])
	by mail.maildlp.com (Postfix) with ESMTPS id 5151F18002F;
	Thu, 22 Feb 2024 09:30:21 +0800 (CST)
Received: from [10.67.111.104] (10.67.111.104) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 22 Feb 2024 09:30:20 +0800
Message-ID: <01e26540-04b6-43b2-b8d4-6d1944475145@huawei.com>
Date: Thu, 22 Feb 2024 09:30:20 +0800
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] bcachefs: intercept mountoption value for bool type
Content-Language: en-US
To: Kent Overstreet <kent.overstreet@linux.dev>, Brian Foster
	<bfoster@redhat.com>
CC: <linux-bcachefs@vger.kernel.org>, <ruanjinjie@huawei.com>,
	<chris.zjh@huawei.com>
References: <20240221093704.3924287-1-lihongbo22@huawei.com>
 <ZdX8ek1o6MQErZMr@bfoster>
 <if2d3bmpvm3hvkgahyn5umjdnfwrtft7567opyr6k2bmwxcf4b@gm34y24jpeqy>
From: Hongbo Li <lihongbo22@huawei.com>
In-Reply-To: <if2d3bmpvm3hvkgahyn5umjdnfwrtft7567opyr6k2bmwxcf4b@gm34y24jpeqy>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpeml500022.china.huawei.com (7.185.36.66)



On 2024/2/22 7:51, Kent Overstreet wrote:
> On Wed, Feb 21, 2024 at 08:36:58AM -0500, Brian Foster wrote:
>> On Wed, Feb 21, 2024 at 05:37:04PM +0800, Hongbo Li wrote:
>>> For mount option with bool type, the value must be 0 or 1 (See
>>> bch2_opt_parse). But this seems does not well intercepted cause
>>> for other value(like 2...), it returns the unexpect return code
>>> with error message printed.
>>>
>>> Signed-off-by: Hongbo Li <lihongbo22@huawei.com>
>>> ---
>>>   fs/bcachefs/opts.c | 2 +-
>>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/fs/bcachefs/opts.c b/fs/bcachefs/opts.c
>>> index b1ed0b9a20d3..fe1f17830694 100644
>>> --- a/fs/bcachefs/opts.c
>>> +++ b/fs/bcachefs/opts.c
>>> @@ -314,7 +314,7 @@ int bch2_opt_parse(struct bch_fs *c,
>>>   		if (ret < 0 || (*res != 0 && *res != 1)) {
>>>   			if (err)
>>>   				prt_printf(err, "%s: must be bool", opt->attr.name);
>>> -			return ret;
>>> +			return ret < 0 ?: -EINVAL;
>>
>> It might be nice for that error message to be more specific in that the
>> bool value must be 0 or 1, but LGTM regardless:
> 
> Please give this a distinct private error code as well (just like we
> discussed in the previous patch)
> 
Here, the -EINVAL refers to the return value of other exception branches 
of this function to keep the consistent error code of this function.

In fact, it is a bit confusing to use whether to return a private error 
code or a system error code in some functions. For example, in 
bch2_opt_validate, the two exception branches of no sector alignment and 
power of 2 do not return internal error codes.

I don't know what the boundaries are for using private error codes. 
Generally, internal functions are passed through private error codes, 
but now I can only refer to this function context to determine the error 
code type.
>>
>> Reviewed-by: Brian Foster <bfoster@redhat.com>
>>
>>>   		}
>>>   		break;
>>>   	case BCH_OPT_UINT:
>>> -- 
>>> 2.34.1
>>>
>>

Received: from mail2.ecloud.global (mail2.ecloud.global [135.181.6.248])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27404139D07
	for <linux-bcachefs@vger.kernel.org>; Thu,  3 Oct 2024 09:35:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=135.181.6.248
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727948150; cv=pass; b=qrVnpP3UbmQ5etJG/AYRnG0ZQNfHQUTUPA+ghAye3ccL9iEmqyf44NyN4ZL6NCYwlhwgbOHaq6XPiJ4qGGoeEqS2tPoZ/Mt32whKCNqLLwFOBaAyZschVedsF/NohI16VfKdpCzUZUv7k08VRa+kplnMcE96F6M8Qb0lAr/KpAk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727948150; c=relaxed/simple;
	bh=geN1Qw2lncYb5HAN342pfyJgiTNclFFBhLpbZQCvpwc=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:Cc:From:
	 In-Reply-To:Content-Type; b=fRzCnGA8WYHgs7nOzFPinCY68q7mOTFenrV0LJR+0RrWRotIEnNCeIJd3CZM98WAqRvTfr0HMt0rTZv4ie3vyWsFjRcW4p45r+DV6b3BGbMo4rApJ5QhO96ULDaGW2XU8cgre+eB4gXW0yPduh1y1MEtHduD03HT2jEfQOSO04s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=murena.io; spf=pass smtp.mailfrom=murena.io; dkim=pass (1024-bit key) header.d=murena.io header.i=@murena.io header.b=dwR65hUY; arc=pass smtp.client-ip=135.181.6.248
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=murena.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=murena.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=murena.io header.i=@murena.io header.b="dwR65hUY"
Received: from authenticated-user (mail2.ecloud.global [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail2.ecloud.global (Postfix) with ESMTPSA id 1B53072059C;
	Thu,  3 Oct 2024 09:35:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=murena.io; s=mail2;
	t=1727948147;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=wJvncHPlELH+SXdxjY5fW9A/7fwy8kMaJIN5iytgybk=;
	b=dwR65hUYhzXeJBOFO52PZHX1A2eDDiILUDbTamUXtCxzgscJcPd08oodG8Ygy5W7gAIsSn
	dEYViOl033szNxeU7h4+NEzp1++s2YL/ZQ2/vOVepI/RVG497Vcem0b7SzvS82BMNxO2mo
	c0wbyw0gbGk9BqPGenXfPUq2AJ5qrnc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=murena.io;
	s=mail2; t=1727948147;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=wJvncHPlELH+SXdxjY5fW9A/7fwy8kMaJIN5iytgybk=;
	b=Gw/qXE0LNOmhUu6WoppMfqeWrNoyrPd0TyoOiocO2NATqAW1bUYrMJO/Ywty2GlK+qmVcq
	fTAVBGoKBPcjMJzRUBfAEzczqCW1Y3pm0/lKjqjcO/d3nBl3ppdtWW42ZR8Mk0ewawMQPf
	gc4hi/0c86WFZuaIZGgvaRHsk+L4tkA=
ARC-Authentication-Results: i=1;
	mail2.ecloud.global;
	auth=pass smtp.mailfrom=integral@murena.io
ARC-Seal: i=1; s=mail2; d=murena.io; t=1727948147; a=rsa-sha256; cv=none;
	b=YS2ho0xWdLcOjsoPL3PIxUn7zcUhe4z1HXkZO9RZ3KdzP52ay8xliXxuazNjMbtWoNnRS9
	y5AABfWanJilOkHNV/8/2QOIJWjC+/caHlon/Djxw8APON+buGhUncq8N6jLE7oXcx0jDV
	YSPAc2k7VyTqrHX5DV37yr50Z9sXgKs=
Message-ID: <a6da5ca3-5698-4934-8213-b52cfcd59bb9@murena.io>
Date: Thu, 3 Oct 2024 17:35:41 +0800
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH] Add support for true/false, yes/no & on/off in bool-type
 options
To: Hongbo Li <lihongbo22@huawei.com>
References: <7f1b35b2-437c-42b2-950b-556ce272c745@huawei.com>
 <20240718122926.99326-3-integral@murena.io>
 <u3wl6277ljmgqlbjw5pxu3oeljgftekeati6xcsyfden25umo6@p3z3z4yc6drg>
 <55b29fbb-3aa8-4ba7-9668-aa19dbb02e78@huawei.com>
Content-Language: en-US
Cc: integral@murena.io, kent.overstreet@gmail.com, kent.overstreet@linux.dev,
 linux-bcachefs@vger.kernel.org
From: Integral <integral@murena.io>
Autocrypt: addr=integral@murena.io; keydata=
 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
In-Reply-To: <55b29fbb-3aa8-4ba7-9668-aa19dbb02e78@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Therefore, if my original patch is okay, could you merge it?


Thanks,

Integral


On 7/22/24 12:03 PM, Hongbo Li wrote:
>
>
> On 2024/7/19 6:50, Kent Overstreet wrote:
>> On Thu, Jul 18, 2024 at 08:29:28PM GMT, Integral wrote:
>>> Here is the new patch:
>>>
>>> Currently, when using bcachefs-tools to set options, bool-type 
>>> options can
>>> only accept 1 or 0. Add support for accepting true/false, yes/no &
>>> on/off for these options.
>>>
>>> Signed-off-by: Integral <integral@murena.io>
>>> ---
>>>   fs/bcachefs/opts.c | 18 +++++++++++-------
>>>   1 file changed, 11 insertions(+), 7 deletions(-)
>>>
>>> diff --git a/fs/bcachefs/opts.c b/fs/bcachefs/opts.c
>>> index 0770aebef6d8..0e4cd6984eda 100644
>>> --- a/fs/bcachefs/opts.c
>>> +++ b/fs/bcachefs/opts.c
>>> @@ -332,17 +332,21 @@ int bch2_opt_parse(struct bch_fs *c,
>>>       switch (opt->type) {
>>>       case BCH_OPT_BOOL:
>>>           if (val) {
>>> -            ret = kstrtou64(val, 10, res);
>>> +            if (!strcasecmp(val, "1") || !strcasecmp(val, "true") ||
>>> +                !strcasecmp(val, "yes") || !strcasecmp(val, "on")) {
>>> +                *res = 1;
>>> +            } else if (!strcasecmp(val, "0") || !strcasecmp(val, 
>>> "false") ||
>>> +                !strcasecmp(val, "no") || !strcasecmp(val, "off")) {
> Sorry, may be I was wrong.
>>> +                *res = 0;
>>> +            } else {
>>> +                if (err)
>>> +                    prt_printf(err, "%s: must be bool", 
>>> opt->attr.name);
>>> +                return -BCH_ERR_option_not_bool;
>>> +            }
>>
>> There _should_ be something more standard in the kernel for parsing bool
>> options (commandline options, module options) - please hunt around for
>> that and see if it works; report back on what you find.
> I find in Documentation/filesystems/mount_api.rst, it give an 
> explanation.
>
> ```
> Note that if the value is of fs_param_is_bool type, fs_parse() will try
>
> to match any string value against "0", "1", "no", "yes", "false", "true".
> ```
>
> But this has been handled in fs_param_is_bool with macro fsparam_bool. 
> Many file systems do this in fs_parse. I think the original patch 
> seems ok.
>
> Thanks,
> Hongbo
>
>>
>> We want to be consistent on how we parse bools throughout the kernel.

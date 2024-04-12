Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15BD28C15
	for <linux-bcachefs@vger.kernel.org>; Fri, 12 Apr 2024 06:32:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712903564; cv=none; b=WZoqjt2gGFv4Kx72qTX9eWjHRIXac2XdclYGMgGXvJohbBnTu5Hjq5Rc75XQyIMHZT8/XExGIgYAZfQdLbk7by0H5ABSYHy5Ra9/6YZiSOkqWUBGa6mzDyndl/K8vtbFLIdpoh0uMrALRTKN4zQLSc/yPahedy6bLD96iIKeFac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712903564; c=relaxed/simple;
	bh=Vo1pehrlbUFaeFWGno8VZMGFdgVG00/aBIz/nXuCr94=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=b+e+AKovls3NEf98hksNkDC3SqwfZbxcKRlzaduLY9fTu3z4l32FI0jXT52/uOJ0nGYnuIkCge75ju1VhqVZUxSKGAM05v7vrGcVlBz5C9AHPIJDJM/VlJFlqIdBO8snVTA9fZSLUkJa2t7y8nzNbU0SrzFoXt52K7MkLD9dUDg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=J+oKZaf2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="J+oKZaf2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 054F1C2BBFC;
	Fri, 12 Apr 2024 06:32:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712903563;
	bh=Vo1pehrlbUFaeFWGno8VZMGFdgVG00/aBIz/nXuCr94=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=J+oKZaf2RNTfBhVCU7ehtO7v/aTKNkZKLzXdvU+2p4zR4ZgQQlWv6eG1OfG/Xer9h
	 81hyTcI/otCWv32UUmCnlQiO4d5c7KT+g++CVeaEGxAz2UOb8t2vKXrXeOM913hP+q
	 u+B+KK4Xn9jM9xwKU+toaL3jIrAfs32EAf+wrDB9pTo6HQcGWDmQCH3KSRC//rwOru
	 4GCjrF7N2kX3Nx2niPG6OJ7pxR1Bmrhcd2VG37ntx2v7yWH7YYxiOCZJqZkJTQwchL
	 NpuG/ou9+BAWRroClTxzj4YI7Dr163KfhRhDqZiA4aQnM6zgS//vxceDaujXAZhIZL
	 b8UvvUc85tQTg==
Message-ID: <99e80830-0eaf-423d-9250-6a0230fdcdc7@kernel.org>
Date: Fri, 12 Apr 2024 14:32:35 +0800
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] bcachefs: fix error path of __bch2_read_super()
To: Hongbo Li <lihongbo22@huawei.com>, kent.overstreet@linux.dev,
 bfoster@redhat.com
Cc: linux-bcachefs@vger.kernel.org
References: <20240411100829.1729332-1-chao@kernel.org>
 <a021f61e-dc98-4324-916c-c65c6d979cc0@huawei.com>
Content-Language: en-US
From: Chao Yu <chao@kernel.org>
In-Reply-To: <a021f61e-dc98-4324-916c-c65c6d979cc0@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 2024/4/11 19:29, Hongbo Li wrote:
> 
> 
> On 2024/4/11 18:08, Chao Yu wrote:
>> In __bch2_read_super(), if kstrdup() fails, it needs to release memory
>> in sb->holder, fix to call bch2_free_super() in the error path.
>>
>> Signed-off-by: Chao Yu <chao@kernel.org>
>> ---
>>   fs/bcachefs/super-io.c | 6 ++++--
>>   1 file changed, 4 insertions(+), 2 deletions(-)
>>
>> diff --git a/fs/bcachefs/super-io.c b/fs/bcachefs/super-io.c
>> index ad28e370b640..cec1470c2dd9 100644
>> --- a/fs/bcachefs/super-io.c
>> +++ b/fs/bcachefs/super-io.c
>> @@ -698,8 +698,10 @@ static int __bch2_read_super(const char *path, struct bch_opts *opts,
>>           return -ENOMEM;
>>       sb->sb_name = kstrdup(path, GFP_KERNEL);
>> -    if (!sb->sb_name)
>> -        return -ENOMEM;
>> +    if (!sb->sb_name) {
>> +        ret = -ENOMEM;
> maybe you should fill err with message info by prt_printf(xxx), because err with no message info when printed in bch2_print_opts.

Oh, yes, will revise in v2, thank you for the comments.

Thanks,

>> +        goto err;
>> +    }
>>   #ifndef __KERNEL__
>>       if (opt_get(*opts, direct_io) == false)

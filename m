Received: from szxga06-in.huawei.com (szxga06-in.huawei.com [45.249.212.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 080B123777
	for <linux-bcachefs@vger.kernel.org>; Wed, 28 Feb 2024 07:17:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709104678; cv=none; b=BA3w22s5c6bSDDmVd/UMs1uHKBHYTO+vWvnkDmM+CGu6fFV6LZUoUlosaK9/U4HVQuhBPG6FfFqVQ9MTUlO24cgUyKMHiXWc0yevuQ+u4rWc2GWVSerziv6ksXOZjgiIODorIbZN0OaRuGYGff78YvQdWBF9tBqQ3yHFATQRC/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709104678; c=relaxed/simple;
	bh=uUo/N7iK4gj8K5a42tth7A5v7cAQj/rZrzMPkqt3f5o=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=gCVIC1FlAQByf+W/aDfGDM1Q1O6wfGsGKnDl0se5chB7cA06Cc80Au5ukvdjCdywyJ/ezEBe4q1ZaE4phhzN52abCsrxh/mnkA3S8fGPG8rq7ZZpgrSYxHzceAfhPWOFuG9cYKp2OMd4Bnwuv1EY283plixyw8VO+18fdwfuDyQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.214])
	by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4Tl5Jr3t08zqhkG;
	Wed, 28 Feb 2024 15:17:16 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (unknown [7.185.36.66])
	by mail.maildlp.com (Postfix) with ESMTPS id A89661A016C;
	Wed, 28 Feb 2024 15:17:53 +0800 (CST)
Received: from [10.67.111.104] (10.67.111.104) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Wed, 28 Feb 2024 15:17:53 +0800
Message-ID: <e2ebc6d8-58e1-4259-b03c-8cc13003059b@huawei.com>
Date: Wed, 28 Feb 2024 15:17:50 +0800
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] bcachefs: fix the error code when mounting with
 incorrect options.
To: Kent Overstreet <kent.overstreet@linux.dev>
CC: <bfoster@redhat.com>, <linux-bcachefs@vger.kernel.org>,
	<ruanjinjie@huawei.com>
References: <20240219122432.2570083-1-lihongbo22@huawei.com>
 <tcjqfii2emtqwpsgt4doldgg2iwjnsh6fzv7nkdccxt43gpu4g@pfasjkkj3e4k>
Content-Language: en-US
From: Hongbo Li <lihongbo22@huawei.com>
In-Reply-To: <tcjqfii2emtqwpsgt4doldgg2iwjnsh6fzv7nkdccxt43gpu4g@pfasjkkj3e4k>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpeml500022.china.huawei.com (7.185.36.66)

ok, I add mount option error code here.

On 2024/2/19 20:27, Kent Overstreet wrote:
> On Mon, Feb 19, 2024 at 08:24:32PM +0800, Hongbo Li wrote:
>> When mount with incorrect options such as:
>> "mount -t bcachefs -o errors=back /dev/loop1 /mnt/bcachefs/".
>> It rebacks the error "mount: /mnt/bcachefs: permission denied."
>>   cause bch2_parse_mount_opts returns -1 and bch2_mount throws
>> it up. This is unreasonable.
>>
>> The real error message should be like this:
>> "mount: /mnt/bcachefs: wrong fs type, bad option, bad
>> superblock on /dev/loop1, missing codepage or helper program,
>> or other error."
>>
>> Adding three private error codes for mounting error. Here are:
>>    - BCH_ERR_mount_option as the parent class for option error.
>>    - BCH_ERR_option_name represents the invalid option name.
>>    - BCH_ERR_option_value represents the invalid option value.
>>
>> Signed-off-by: Hongbo Li <lihongbo22@huawei.com>
> 
> thanks! I'll give this more detailed review tomorrow but at a glance,
> looks good.
> 
>> ---
>> Thanks for reviewing my patch. Here is my new changelog:
>>
>> v2:
>>   - return private error codes for internal functions.
>> v1: https://lore.kernel.org/linux-bcachefs/b3edruyblko7tbpbbpftov75tmnmwir4mx7m2mwpdzzaylt3av@ttwlfwzzoc6s/T/#t
>> ---
>>   fs/bcachefs/errcode.h | 3 +++
>>   fs/bcachefs/fs.c      | 4 +++-
>>   fs/bcachefs/opts.c    | 6 +++---
>>   3 files changed, 9 insertions(+), 4 deletions(-)
>>
>> diff --git a/fs/bcachefs/errcode.h b/fs/bcachefs/errcode.h
>> index fe3fc14d3c9a..3653ff2c0c12 100644
>> --- a/fs/bcachefs/errcode.h
>> +++ b/fs/bcachefs/errcode.h
>> @@ -5,6 +5,9 @@
>>   #define BCH_ERRCODES()								\
>>   	x(ERANGE,			ERANGE_option_too_small)		\
>>   	x(ERANGE,			ERANGE_option_too_big)			\
>> +	x(EINVAL,			mount_option)				\
>> +	x(BCH_ERR_mount_option,		option_name)				\
>> +	x(BCH_ERR_mount_option,		option_value)				\
>>   	x(ENOMEM,			ENOMEM_stripe_buf)			\
>>   	x(ENOMEM,			ENOMEM_replicas_table)			\
>>   	x(ENOMEM,			ENOMEM_cpu_replicas)			\
>> diff --git a/fs/bcachefs/fs.c b/fs/bcachefs/fs.c
>> index 093f5404a655..3f073845bbd7 100644
>> --- a/fs/bcachefs/fs.c
>> +++ b/fs/bcachefs/fs.c
>> @@ -1870,8 +1870,10 @@ static struct dentry *bch2_mount(struct file_system_type *fs_type,
>>   	opt_set(opts, read_only, (flags & SB_RDONLY) != 0);
>>   
>>   	ret = bch2_parse_mount_opts(NULL, &opts, data);
>> -	if (ret)
>> +	if (ret) {
>> +		ret = bch2_err_class(ret);
>>   		return ERR_PTR(ret);
>> +	}
>>   
>>   	if (!dev_name || strlen(dev_name) == 0)
>>   		return ERR_PTR(-EINVAL);
>> diff --git a/fs/bcachefs/opts.c b/fs/bcachefs/opts.c
>> index b1ed0b9a20d3..1db11c15b2b9 100644
>> --- a/fs/bcachefs/opts.c
>> +++ b/fs/bcachefs/opts.c
>> @@ -456,7 +456,7 @@ int bch2_parse_mount_opts(struct bch_fs *c, struct bch_opts *opts,
>>   
>>   	copied_opts = kstrdup(options, GFP_KERNEL);
>>   	if (!copied_opts)
>> -		return -1;
>> +		return -ENOMEM;
>>   	copied_opts_start = copied_opts;
>>   
>>   	while ((opt = strsep(&copied_opts, ",")) != NULL) {
>> @@ -501,11 +501,11 @@ int bch2_parse_mount_opts(struct bch_fs *c, struct bch_opts *opts,
>>   
>>   bad_opt:
>>   	pr_err("Bad mount option %s", name);
>> -	ret = -1;
>> +	ret = -BCH_ERR_option_name;
>>   	goto out;
>>   bad_val:
>>   	pr_err("Invalid mount option %s", err.buf);
>> -	ret = -1;
>> +	ret = -BCH_ERR_option_value;
>>   	goto out;
>>   out:
>>   	kfree(copied_opts_start);
>> -- 
>> 2.34.1
>>

Received: from szxga07-in.huawei.com (szxga07-in.huawei.com [45.249.212.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F9842119
	for <linux-bcachefs@vger.kernel.org>; Wed,  9 Oct 2024 03:24:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.35
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728444256; cv=none; b=iOB8hrK+7E534qqa1B5nF6AdiQzXictsgo2M2XTIXUMXqpme7mbietBrN6XpBhZ4xSLxBvmRN335EbrxQOEvEZJbippo8PGkEVO1cVHNoIwd0UgXtGFyTr5dGSK7jfLPKpRSFcuJdBtPFiunMF3h3Pb+WDNCEKbwIktLR+J/+zc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728444256; c=relaxed/simple;
	bh=6WgBAa0cvUD4TJfL/sKtAZKwJMyNdWeWfstS2rnUKkU=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=Wln+jZUKy4NJD3GzXmsH1QpbSYTOiCHwQPZfQ7wu2f0ptaWJSpW76P8xDB8ZuvrMm593W+NMan/JJsiNPDSSUqsiumYZXawPdU5MPC+fwVaZBmLIG7aS1VWjen+gMej6H+Him5bXlfUr6B6G/25lCJBw+yhv7cT6o6VVbFjwG5I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.163])
	by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4XNdW82dCdz1SCKL;
	Wed,  9 Oct 2024 11:23:00 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (unknown [7.185.36.66])
	by mail.maildlp.com (Postfix) with ESMTPS id CC77D18001B;
	Wed,  9 Oct 2024 11:24:05 +0800 (CST)
Received: from [10.67.111.104] (10.67.111.104) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 9 Oct 2024 11:24:05 +0800
Message-ID: <023e82ad-a6d8-4d76-aceb-273d6bffe724@huawei.com>
Date: Wed, 9 Oct 2024 11:24:06 +0800
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/2] bcachefs: avoid copy from NULL printbuf
Content-Language: en-US
To: Kent Overstreet <kent.overstreet@linux.dev>
CC: <linux-bcachefs@vger.kernel.org>, <chris.zjh@huawei.com>, <ddiss@suse.de>
References: <20240926020002.1746333-1-lihongbo22@huawei.com>
 <20240926020002.1746333-2-lihongbo22@huawei.com>
 <zahnaoa6rppe7niu3erezprogadzdym5rbktqpgp7cseqqqp65@dylrno7fewka>
From: Hongbo Li <lihongbo22@huawei.com>
In-Reply-To: <zahnaoa6rppe7niu3erezprogadzdym5rbktqpgp7cseqqqp65@dylrno7fewka>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpeml500022.china.huawei.com (7.185.36.66)



On 2024/10/9 11:13, Kent Overstreet wrote:
> On Thu, Sep 26, 2024 at 10:00:00AM GMT, Hongbo Li wrote:
>> printbuf.buf may be NULL if allocation_failure is true. Check
>> for this prior to using it as a seq_puts() source.
>>
>> Fixes: fa8e94faeece ("bcachefs: Heap allocate printbufs")
>> Signed-off-by: David Disseldorp <ddiss@suse.de>
>> Signed-off-by: Hongbo Li <lihongbo22@huawei.com>
> 
> Let's do this by adding a proper printbuf_err() helper - have it return
> -ENOMEM on allocation failure, and do a normal
> if (ret)
> 	goto err;
> 
> so it looks more standard.
> 
>> ---
>>   fs/bcachefs/fs.c | 7 +++++--
>>   1 file changed, 5 insertions(+), 2 deletions(-)
>>
>> diff --git a/fs/bcachefs/fs.c b/fs/bcachefs/fs.c
>> index e774cb3e6b1a..d6e26b5056f3 100644
>> --- a/fs/bcachefs/fs.c
>> +++ b/fs/bcachefs/fs.c
>> @@ -1923,13 +1923,16 @@ static int bch2_show_options(struct seq_file *seq, struct dentry *root)
>>   {
>>   	struct bch_fs *c = root->d_sb->s_fs_info;
>>   	struct printbuf buf = PRINTBUF;
>> +	int ret = 0;
>>   
>>   	bch2_opts_to_text(&buf, c->opts, c, c->disk_sb.sb,
>>   			  OPT_MOUNT, OPT_HIDDEN, OPT_SHOW_MOUNT_STYLE);
>>   	printbuf_nul_terminate(&buf);
>> -	seq_puts(seq, buf.buf);

like this?:
         ret = printbuf_err(buf);
         if (ret)
             goto err:
         seq_printf(seq, ",%s", buf.buf);
         printbuf_exit(&buf);

err:
         return ret;


Thanks,
Hongbo

>> +	if (buf.allocation_failure)
>> +		ret = -ENOMEM;
>> +	else
>> +		seq_puts(seq, buf.buf);
>>   
>> -	int ret = buf.allocation_failure ? -ENOMEM : 0;
>>   	printbuf_exit(&buf);
>>   	return ret;
>>   }
>> -- 
>> 2.34.1
>>
> 

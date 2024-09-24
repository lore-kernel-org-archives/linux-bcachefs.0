Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C09238C
	for <linux-bcachefs@vger.kernel.org>; Tue, 24 Sep 2024 01:29:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.191
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727141363; cv=none; b=cBA+zIPTgErQXTF6SSIMxeNDBU2b7wvmitLrUappDMqdKwEMEpUhhSPe/4wHXi/DZSaJiu440sqUar0BaEuM2K4FrWn6LqwB4u/WzIoZ+ErE+tUBKeZIPSknJQyNEagmpiBE26latpRf9e+3P6AE5RpZs6x6M2vgRSeGymUarqY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727141363; c=relaxed/simple;
	bh=5eBz3NzNWVmFrKnsRLs79eHsSZdxl5Bdfx73UyrcA5I=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=Q25z1efSApXXaxC8nukYMA6tj+MpMlWAxwMa0WgJP5DE5WgbOLtqCRUOHZ3LJF0Y2ZVvnK9gECkLUtHrVZLCQ6jG13gSawJdwhabBa8Uf3ROiDy4AWyL9JtRZ8ABpgQ+jCUz+y72WA4w1AGpXikiLQLefcQf4X4lMm+5d+jOV2M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.191
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.162.112])
	by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4XCMgz0Kdlz2QTww;
	Tue, 24 Sep 2024 09:28:31 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (unknown [7.185.36.66])
	by mail.maildlp.com (Postfix) with ESMTPS id 6D356140336;
	Tue, 24 Sep 2024 09:29:16 +0800 (CST)
Received: from [10.67.111.104] (10.67.111.104) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 24 Sep 2024 09:29:16 +0800
Message-ID: <c45c654c-92b7-42c6-ad29-9c2e79cf1207@huawei.com>
Date: Tue, 24 Sep 2024 09:29:15 +0800
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] bcachefs: fix incorrect show_options results
Content-Language: en-US
To: David Disseldorp <ddiss@suse.de>, Kent Overstreet
	<kent.overstreet@linux.dev>
CC: <linux-bcachefs@vger.kernel.org>, <liaochang1@huawei.com>
References: <20240923095003.3559171-1-lihongbo22@huawei.com>
 <20240923143931.3a24e3c9.ddiss@suse.de>
From: Hongbo Li <lihongbo22@huawei.com>
In-Reply-To: <20240923143931.3a24e3c9.ddiss@suse.de>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpeml500022.china.huawei.com (7.185.36.66)



On 2024/9/23 22:39, David Disseldorp wrote:
> On Mon, 23 Sep 2024 17:50:03 +0800, Hongbo Li wrote:
> 
>> When call show_options in bcachefs, the options buffer is appeneded
>> to the seq variable. In fact, it requires an additional comma to be
>> appended first. This will affect the remount process when reading
>> existing mount options.
>>
>> Fixes: 9305cf91d05e ("bcachefs: bch2_opts_to_text()")
> 
> Ah, that'd explain why I wasn't seeing this alongside the
> fail-on-unknown-opt fix. FWIW, this first appears in
> bcachefs-2024-09-21 as 3621ecc10f831f4fd27784083dfaf5b8481098b5 .
> 
>> Signed-off-by: Hongbo Li <lihongbo22@huawei.com>
>> ---
>>   fs/bcachefs/fs.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/fs/bcachefs/fs.c b/fs/bcachefs/fs.c
>> index e774cb3e6b1a..79c3a650b714 100644
>> --- a/fs/bcachefs/fs.c
>> +++ b/fs/bcachefs/fs.c
>> @@ -1927,7 +1927,7 @@ static int bch2_show_options(struct seq_file *seq, struct dentry *root)
>>   	bch2_opts_to_text(&buf, c->opts, c, c->disk_sb.sb,
>>   			  OPT_MOUNT, OPT_HIDDEN, OPT_SHOW_MOUNT_STYLE);
>>   	printbuf_nul_terminate(&buf);
>> -	seq_puts(seq, buf.buf);
>> +	seq_printf(seq, ",%s", buf.buf);
> 
> Looks okay, although it might be simpler to just drop the !first
> conditionals from bch2_opts_to_text() as things were prior to the
> regression.
> 

The bch2_opts_to_text may be intended to provide a unified format(by 
joining options into a string with commas), although currently ther is 
only one call to it.

>>   	int ret = buf.allocation_failure ? -ENOMEM : 0;
> 
> Should the copy from buf into seq occur if allocation_failure
> is already flagged? I'd expect seq_puts() to have oopsed.

Or to be more rigorous, copy buf only when allocation_failure is false?

Thanks,
Hongbo

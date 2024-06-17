Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4457019AA47
	for <linux-bcachefs@vger.kernel.org>; Mon, 17 Jun 2024 12:54:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718628849; cv=none; b=fNHnFM8no6wF6dxJhGlp/jxp/DoNwYJ5vrzad8JWf1B0ONnTIm1aRe24Nu8GeWwhPPY94CUKxrCZARrr/PkXOX6PRH8mypjqi9FDgoejL92KqhsoKQJziPPFb3T0C/EEV1eK7tq8ExAYS4xwnzOkDF6xKi9j7sU88oE6/NXT/gs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718628849; c=relaxed/simple;
	bh=E0mF5r5mk1LFaHaFfRjjlOOXg2nAXYtLk6SaDPVpb7c=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=dL0DCtCSQHgfgR6Cq0gVmbN7LbrfMMzbLtwq89ONLqrdkicFsNakzwAPIyfj2DgpvNRkxlVdVDPblOrVs+ShbfWXBts9XPemP5BkncZFswbUd/PWuiopDd+yCy6h358cFZUcmmDlBRCM3OH0g5HubGqPeMP1SnWqVswmDj7UKFE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.105])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4W2qTr6FQrzxS9k;
	Mon, 17 Jun 2024 20:49:52 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (unknown [7.185.36.66])
	by mail.maildlp.com (Postfix) with ESMTPS id E16B214011B;
	Mon, 17 Jun 2024 20:54:02 +0800 (CST)
Received: from [10.67.111.104] (10.67.111.104) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 17 Jun 2024 20:54:02 +0800
Message-ID: <7611b61b-0d75-47ed-ac5f-4a0ef123f108@huawei.com>
Date: Mon, 17 Jun 2024 20:54:02 +0800
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] bcachefs: support idmap mounts
To: Kent Overstreet <kent.overstreet@linux.dev>
CC: <bfoster@redhat.com>, <linux-bcachefs@vger.kernel.org>,
	<christian@brauner.io>
References: <20240615102038.3110867-1-lihongbo22@huawei.com>
 <fhgec4fmisjfp3sirxlkwl5napoitzxkjdhvvmebmrvlalcqba@mmh2m45hpojb>
Content-Language: en-US
From: Hongbo Li <lihongbo22@huawei.com>
In-Reply-To: <fhgec4fmisjfp3sirxlkwl5napoitzxkjdhvvmebmrvlalcqba@mmh2m45hpojb>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpeml500022.china.huawei.com (7.185.36.66)


Hi Kent,

What's your config for generic.689? I run the testcase successfully in 
local with the following config:

```
export TEST_DEV=/dev/loop1
export TEST_DIR=/mnt/bcachefs
```
and the output are:

```
[root@lhb_qemu xfstests-master]# ./check tests/generic/689
FSTYP         -- bcachefs
PLATFORM      -- Linux/x86_64 lhb_qemu 6.10.0-rc3+ #20 SMP 
PREEMPT_DYNAMIC Sat Jun 15 17:49:33 CST 2024
generic/689       --- lihb mount type:bcachefs
  24s
Ran: generic/689
Passed all 1 tests

```

Thanks,
Hongbo

On 2024/6/17 3:49, Kent Overstreet wrote:
> On Sat, Jun 15, 2024 at 06:20:38PM +0800, Hongbo Li wrote:
>> We enable idmapped mounts for bcachefs. Here, we just pass down
>> the user_namespace argument from the VFS methods to the relevant
>> helpers.
>>
>> The idmap test in bcachefs is as following:
>>
>> ```
>> 1. losetup /dev/loop1 bcachefs.img
>> 2. ./bcachefs format /dev/loop1
>> 3. mount -t bcachefs /dev/loop1 /mnt/bcachefs/
>> 4. ./mount-idmapped --map-mount b:0:1000:1 /mnt/bcachefs /mnt/idmapped1/
>>
>> ll /mnt/bcachefs
>> total 2
>> drwx------. 2 root root    0 Jun 14 14:10 lost+found
>> -rw-r--r--. 1 root root 1945 Jun 14 14:12 profile
>>
>> ll /mnt/idmapped1/
>>
>> total 2
>> drwx------. 2 1000 1000    0 Jun 14 14:10 lost+found
>> -rw-r--r--. 1 1000 1000 1945 Jun 14 14:12 profile
>> ```
>>
>> Signed-off-by: Hongbo Li <lihongbo22@huawei.com>
> 
> new test failure:
> 
> https://evilpiepirate.org/~testdashboard/c/a7d9a88f5cb151b7b9e513f5d40a949a3eda4662/xfstests.generic.689/log.br
> 

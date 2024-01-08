Received: from mail-108-mta131.mxroute.com (mail-108-mta131.mxroute.com [136.175.108.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 136E74B5AE
	for <linux-bcachefs@vger.kernel.org>; Mon,  8 Jan 2024 15:13:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=damenly.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=damenly.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=damenly.org header.i=@damenly.org header.b="vTIsywm6"
Received: from filter006.mxroute.com ([136.175.111.2] filter006.mxroute.com)
 (Authenticated sender: mN4UYu2MZsgR)
 by mail-108-mta131.mxroute.com (ZoneMTA) with ESMTPSA id 18ce99de6480003727.003
 for <linux-bcachefs@vger.kernel.org>
 (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384);
 Mon, 08 Jan 2024 15:08:08 +0000
X-Zone-Loop: df2779c3f0a0b50eef45a11565a5f94f3996862163ee
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=damenly.org
	; s=x; h=Content-Type:MIME-Version:Message-ID:In-reply-to:Date:Subject:Cc:To:
	From:References:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=JjmJw2/GSysvWFbZJzgSITIytMEz3JoHIynrg0+C4es=; b=vTIsywm64BwguT3SMYsyE/oXi0
	vJLGf/PDBV/SWDtVFwCuNvxVhD4kju0wfEWkXBqAk/ULiF7mYB4SEAm9fOGvPiPY4DOXwgd0yHa3F
	ZNCQIl0E+GtVmJPqQAATMcOI4rvIgbAj78ZDYUBIxj4xJYW+KU5hfi70qeBgei4FYz3mEpVmqs3Vl
	xGcUpwTpKGzasmHDDtDvcH9Wh7G5+TDj02w/+0FZIJOHxM+HMORb7u7INjU7wlADj2bmJt6KppgMD
	2Mbw9iWXRWtn+g/m6RQs1MczU2XZNWwzuWo8bzxWSbHehwmY3K5zqixioZU+jEvNfvanJa/uTSXwk
	bj1hVd0Q==;
References: <20240107070559.1097718-1-glass.su@suse.com>
 <ZZwNEjZILprrFVB5@bfoster>
User-agent: mu4e 1.7.5; emacs 28.2
From: Su Yue <l@damenly.org>
To: Brian Foster <bfoster@redhat.com>
Cc: Su Yue <glass.su@suse.com>, linux-bcachefs@vger.kernel.org, l@damenly.org
Subject: Re: [PATCH] bcachefs: fix memleak in bch2_split_devs
Date: Mon, 08 Jan 2024 23:05:29 +0800
In-reply-to: <ZZwNEjZILprrFVB5@bfoster>
Message-ID: <il43lv9y.fsf@damenly.org>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed
X-Authenticated-Id: l@damenly.org


On Mon 08 Jan 2024 at 09:56, Brian Foster <bfoster@redhat.com> 
wrote:

> On Sun, Jan 07, 2024 at 03:05:59PM +0800, Su Yue wrote:
>> The pointer dev_name can be modified by strseq(),
>> then causes the memleak:
>>
>> unreferenced object 0xffff9d08a2916c80 (size 32):
>>   comm "mount.bcachefs", pid 9090, jiffies 4295856224 (age 
>>   17.564s)
>>   hex dump (first 32 bytes):
>>     2f 64 65 76 2f 6d 61 70 70 65 72 2f 74 65 73 74 
>>     /dev/mapper/test
>>     2d 30 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
>>     -0..............
>>   backtrace:
>>     [<00000000c5d3be7d>] __kmem_cache_alloc_node+0x1f3/0x2c0
>>     [<0000000052215d26>] __kmalloc_node_track_caller+0x51/0x150
>>     [<0000000069fea956>] kstrdup+0x32/0x60
>>     [<000000000877fcf1>] bch2_split_devs+0x3f/0x150 [bcachefs]
>>     [<000000007ee93204>] bch2_mount+0xcb/0x640 [bcachefs]
>>     [<000000002dd1e04b>] legacy_get_tree+0x30/0x60
>>     [<000000006afc31d3>] vfs_get_tree+0x28/0xf0
>>     [<000000007b0c538e>] path_mount+0x475/0xb60
>>     [<0000000092de5882>] __x64_sys_mount+0x105/0x140
>>     [<0000000054fc05d8>] do_syscall_64+0x42/0xf0
>>     [<00000000df584910>] 
>>     entry_SYSCALL_64_after_hwframe+0x6e/0x76
>>
>> Fix it by copying pointer dev_name at beginning then freeing 
>> the copied
>> pointer at end.
>>
>> Signed-off-by: Su Yue <glass.su@suse.com>
>> ---
>>  fs/bcachefs/util.c | 8 +++++---
>>  1 file changed, 5 insertions(+), 3 deletions(-)
>>
>> diff --git a/fs/bcachefs/util.c b/fs/bcachefs/util.c
>> index c2ef7cddaa4f..789953c14f55 100644
>> --- a/fs/bcachefs/util.c
>> +++ b/fs/bcachefs/util.c
>> @@ -1186,7 +1186,9 @@ int bch2_split_devs(const char 
>> *_dev_name, darray_str *ret)
>>  {
>>  	darray_init(ret);
>>
>> -	char *dev_name = kstrdup(_dev_name, GFP_KERNEL), *s = 
>> dev_name;
>> +	char *dev_name = kstrdup(_dev_name, GFP_KERNEL);
>> +	char *s = dev_name, *orig = dev_name;
>> +
>
> Thanks for the patch. I see this is just moving the assignment 
> of *s,
> but there's no need for that assignment in this code, right? If 
> not, I
> think this would look a little bit cleaner if it fixed that up 
> as well.
> I.e., something like:
>

Right. v2 sent ;)

--
Su
> 	char *s, *dev_name, *orig;
>
> 	dev_name = orig = kstrdup(_dev_name, GFP_KERNEL);
>>  	if (!dev_name)
>>  		return -ENOMEM;
>>
>
> ... and then otherwise the rest LGTM.
>
> Brian
>
>> @@ -1201,10 +1203,10 @@ int bch2_split_devs(const char 
>> *_dev_name, darray_str *ret)
>>  		}
>>  	}
>>
>> -	kfree(dev_name);
>> +	kfree(orig);
>>  	return 0;
>>  err:
>>  	bch2_darray_str_exit(ret);
>> -	kfree(dev_name);
>> +	kfree(orig);
>>  	return -ENOMEM;
>>  }
>> --
>> 2.43.0
>>
>>

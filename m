Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA825566A
	for <linux-bcachefs@vger.kernel.org>; Wed, 17 Jul 2024 13:34:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721223269; cv=none; b=JS7lXhD9/S7NozCOiySAOuV1izOzFzxGRxC1EkwquxLQJZ2QAIEC7UoGqskxtS3DhwPJUbqBsniQsvr/zwCPGeo7pM9Torg73N6gKDZpdg/q+MrfFAbbQ8vLxYQtc3Qx1M/exgbjCeQ1z5FDgAyAoRjtpnyDZAbJMQI2/W5e/wY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721223269; c=relaxed/simple;
	bh=FKpgTuIOiPrvgk9+xvbHrIRDeEj1tnepGRqRW0wbDEM=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=CE8rJeeAnz0ZO5cVwH5eGAWnKMLYLiE90tSKZsXEq1NhwTTmEKmquCTbFgnZHmzQk/twwq5MAQ5LebFmSDIBMABrzTBl0yiY/PXXYYfNuWZAXD4cwOfJPq0VvYsO/aErzd4u/ysHlkw5WeIz9l35gpc81y6L7HillcEZnVusilA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.105])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4WPH1L6tJvzdhwm;
	Wed, 17 Jul 2024 21:32:38 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (unknown [7.185.36.66])
	by mail.maildlp.com (Postfix) with ESMTPS id C2706140443;
	Wed, 17 Jul 2024 21:34:22 +0800 (CST)
Received: from [10.67.111.104] (10.67.111.104) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 17 Jul 2024 21:34:22 +0800
Message-ID: <225209d0-22a2-4767-b0af-c5985c49114a@huawei.com>
Date: Wed, 17 Jul 2024 21:34:21 +0800
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: hung during bcachefs umount
To: Kent Overstreet <kent.overstreet@linux.dev>
CC: <linux-bcachefs@vger.kernel.org>
References: <bdeaf82d-9db7-4c6c-80e0-dc6e93a19fa8@huawei.com>
 <576l2isttternywqc3t4dcmehqnsssvcenjegt4yhgdbplpg52@eaijyosluq7n>
 <8612d2b9-a04f-4fc7-af46-f7885596f81b@huawei.com>
 <i2lakoxda6e4jdvyrl5dwdev4ebzokgf34zvu4nvbyunmc46qf@rte4xe5eqlyr>
Content-Language: en-US
From: Hongbo Li <lihongbo22@huawei.com>
In-Reply-To: <i2lakoxda6e4jdvyrl5dwdev4ebzokgf34zvu4nvbyunmc46qf@rte4xe5eqlyr>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpeml500022.china.huawei.com (7.185.36.66)



On 2024/7/17 21:25, Kent Overstreet wrote:
> On Wed, Jul 17, 2024 at 09:02:21PM GMT, Hongbo Li wrote:
>>
>>
>> On 2024/7/12 22:29, Kent Overstreet wrote:
>>> On Fri, Jul 12, 2024 at 05:41:31PM GMT, Hongbo Li wrote:
>>>> Hi, Kent,
>>>> I found the latest repo( 69558c638c465a79be3a08bfeb3d5a15979cbe42(bcachefs:
>>>> fix ei_update_lock lock ordering)) on master branch will cause stucking
>>>> during bcachefs umount.
>>>>
>>>> Here is the test step:
>>>>
>>>> ```
>>>> mount -t bcachefs /dev/loop1 /mnt/bcachefs
>>>> umount /mnt/bcachefs                      ---- stuck here !!!
>>>
>>> try a lockdep build
>>
>> I open the lockdep config, and here is the trace:
> 
> this has been fixed, run linus's tree or my master or testing branch
> 
> it was the SLAB_ACCOUNT patch, + not using kmem_cache_alloc_lru
ok, I will try it!

Thanks,
Hongbo
> 
>>
>> ```
>> [ 1262.139731] bcachefs (loop1): mounting version 1.9: disk_accounting_v2
>> [ 1262.139781] bcachefs (loop1): recovering from unclean shutdown
>> [ 1262.139813] bcachefs (loop1): starting journal read
>> [ 1262.395735] bcachefs (loop1): journal read done on device loop1, ret 0
>> [ 1262.395819] bcachefs (loop1): journal read done, replaying entries 9-9
>> [ 1262.395974] bcachefs (loop1): Journal keys: 0 read, 0 after sorting and
>> compacting
>> [ 1262.417883] bcachefs (loop1): accounting_read... done
>> [ 1262.444861] bcachefs (loop1): alloc_read... done
>> [ 1262.444904] bcachefs (loop1): stripes_read... done
>> [ 1262.444943] bcachefs (loop1): snapshots_read... done
>> [ 1262.454903] bcachefs (loop1): going read-write
>> [ 1262.455463] bcachefs (loop1): journal_replay... done
>> [ 1262.455498] bcachefs (loop1): resume_logged_ops... done
>> [ 1262.455518] bcachefs (loop1): delete_dead_inodes... done
>> [ 1262.456851] bcachefs (loop1): done starting filesystem
>> [ 1267.770276] BUG: kernel NULL pointer dereference, address:
>> 0000000000000008
>> [ 1267.770305] #PF: supervisor read access in kernel mode
>> [ 1267.770317] #PF: error_code(0x0000) - not-present page
>> [ 1267.770332] PGD 126009067 P4D 109dd8067 PUD 109ddb067 PMD 0
>> [ 1267.770347] Oops: Oops: 0000 [#1] PREEMPT SMP NOPTI
>> [ 1267.770369] CPU: 3 PID: 1804 Comm: umount Kdump: loaded Not tainted
>> 6.10.0-rc4+ #42
>> [ 1267.770398] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
>> 1.15.0-1 04/01/2014
>> [ 1267.770417] RIP: 0010:list_lru_add+0x86/0x130
>> [ 1267.770487] Code: cc cc 48 8b 04 24 4d 89 f4 48 85 c0 74 12 41 80 7f 1c
>> 00 48 63 b0 e8 08 00 00 74 04 85 f6 79 7d 49 03 2f 48 83 c5 40 48 89 ea <4c>
>> 8b 75 08 48 89 df 48 89 54 24 08 4c 89 f6 e8 16 a7 32 00 84 c0
>> [ 1267.770524] RSP: 0018:ff6096c18275fd98 EFLAGS: 00010246
>> [ 1267.770538] RAX: 0000000000000000 RBX: ff13502246670f20 RCX:
>> ff6096c18275fcf4
>> [ 1267.770566] RDX: 0000000000000000 RSI: ffffffff9b9e6da0 RDI:
>> ff13502269690000
>> [ 1267.770581] RBP: 0000000000000000 R08: 0000000000000000 R09:
>> 0000000000000000
>> [ 1267.770598] R10: 00000000000000ff R11: ff13502269690ed0 R12:
>> 0000000000000000
>> [ 1267.770613] R13: ff13502269522500 R14: 0000000000000000 R15:
>> ff135022688307d0
>> [ 1267.770633] FS:  00007f1524643840(0000) GS:ff1350313fb80000(0000)
>> knlGS:0000000000000000
>> [ 1267.770651] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> [ 1267.771024] CR2: 0000000000000008 CR3: 0000000104cc2002 CR4:
>> 0000000000771ef0
>> [ 1267.771368] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
>> 0000000000000000
>> [ 1267.771698] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7:
>> 0000000000000400
>> [ 1267.772014] PKRU: 55555554
>> [ 1267.772326] Call Trace:
>> [ 1267.772631]  <TASK>
>> [ 1267.772934]  ? __die+0x24/0x70
>> [ 1267.773290]  ? page_fault_oops+0x80/0x140
>> [ 1267.773624]  ? find_held_lock+0x2b/0x80
>> [ 1267.773964]  ? exc_page_fault+0x6c/0x1f0
>> [ 1267.774312]  ? asm_exc_page_fault+0x26/0x30
>> [ 1267.774636]  ? list_lru_add+0x86/0x130
>> [ 1267.774948]  ? list_lru_add+0x102/0x130
>> [ 1267.775257]  __inode_add_lru+0x70/0x90
>> [ 1267.775591]  iput_final+0x11b/0x140
>> [ 1267.775892]  ? dput+0x124/0x230
>> [ 1267.776191]  __dentry_kill+0x77/0x190
>> [ 1267.776490]  ? dput+0x124/0x230
>> [ 1267.776784]  dput+0x150/0x230
>> [ 1267.777083]  shrink_dcache_for_umount+0x83/0x110
>> [ 1267.777380]  generic_shutdown_super+0x20/0x170
>> [ 1267.777692]  bch2_kill_sb+0x16/0x20 [bcachefs]
>> [ 1267.778077]  deactivate_locked_super+0x32/0xb0
>> [ 1267.778370]  cleanup_mnt+0x100/0x160
>> [ 1267.778670]  task_work_run+0x59/0x90
>> [ 1267.778995]  syscall_exit_to_user_mode+0x1f5/0x200
>> [ 1267.779300]  do_syscall_64+0x69/0x170
>> [ 1267.779622]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
>> [ 1267.779922] RIP: 0033:0x7f152450d1ab
>> [ 1267.780220] Code: 7b 3c 0e 00 f7 d8 64 89 01 48 83 c8 ff c3 90 f3 0f 1e
>> fa 31 f6 e9 05 00 00 00 0f 1f 44 00 00 f3 0f 1e fa b8 a6 00 00 00 0f 05 <48>
>> 3d 00 f0 ff ff 77 05 c3 0f 1f 40 00 48 8b 15 41 3c 0e 00 f7 d8
>> [ 1267.780845] RSP: 002b:00007fff04b19eb8 EFLAGS: 00000246 ORIG_RAX:
>> 00000000000000a6
>> [ 1267.781190] RAX: 0000000000000000 RBX: 00007f15247c2264 RCX:
>> 00007f152450d1ab
>> [ 1267.781513] RDX: ffffffffffffff70 RSI: 0000000000000000 RDI:
>> 0000000003a5bd40
>> [ 1267.781837] RBP: 0000000003a57200 R08: 0000000000000000 R09:
>> 00007fff04b18c60
>> [ 1267.782158] R10: 0000000000000000 R11: 0000000000000246 R12:
>> 0000000000000000
>> [ 1267.782471] R13: 0000000003a5bd40 R14: 0000000003a57310 R15:
>> 0000000003a57430
>> [ 1267.782780]  </TASK>
>> ```
>>
>> shrink_dcache_for_umount
>> ----> do_one_tree
>> --------> dput
>> ------------> __dentry_kill
>> ----------------> dentry_unlink_inode
>> --------------------> iput
>> ------------------------> iput_final
>> -----------------------------> __inode_add_lru
>> ---------------------------------> list_lru_add_obj
>> --------------------------------------> list_lru_add
>> cause the null pointer access.
>>
>>
>> Thanks,
>> Hongbo

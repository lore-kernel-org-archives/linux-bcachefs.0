Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A6F55228
	for <linux-bcachefs@vger.kernel.org>; Fri, 12 Jul 2024 02:25:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720751128; cv=none; b=Deos4NQTwquPD4oEvsouAPoyy9c2O54cQO6mr20x3P7VgofHbzNc+RrSiKvJ7gfW/4mJc2Lk/grBI/tXIkL6tmdtgaHq6WsFAUqnag19UqeQrKEvmg3Kj1gpLp0/9r3KRzsH6//z9veUHqDa3U8y7UIys+vWTZ0RNyC1IW+arKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720751128; c=relaxed/simple;
	bh=63QR4v2CyU2y+Gh3TqWF95gTl3In1wGWJ1lZyoFxy4o=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=YhUQeV6vZ/PnK11GgLd/8GiCz45Fj/oz8/wdMI6Zh6DQGl4cW+ndBCF2HjREd+6hxi0UFbGyULMRwF1LQXMkIGZ+U1eAYfrLs8722FwRSEKAxoh5cHi/xYtcVqn4GAQHk1vX7Uj8bxaQic+S1xSNvsvrviSoU7WVW+M7bbAWh9w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=K3w362H3; arc=none smtp.client-ip=91.218.175.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="K3w362H3"
X-Envelope-To: kent.overstreet@linux.dev
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1720751122;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FJptSA34o+4TDzSkA0WYIYafChThJWndF65BevLfR4c=;
	b=K3w362H33ahJqKBUoNiwjrlU4SZcOzJWvKGlJq6DrccS7F2cZ+NPLxnPOHqOqvVE2rAgTn
	jJhsopatBYAWWcPNydV0GTDa+mty/5W1PxUMI+2XMvJNBI7kuj66yqhYQcszLwf8a/teTG
	Qm/Cp7EV8Zdqjg41tfuOcPymlRhaFj4=
X-Envelope-To: linux-bcachefs@vger.kernel.org
X-Envelope-To: linux-kernel@vger.kernel.org
X-Envelope-To: tangyouling@kylinos.cn
Message-ID: <84de6cb1-57bd-42f7-8029-4203820ef0b4@linux.dev>
Date: Fri, 12 Jul 2024 10:24:55 +0800
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH] bcachefs: Mark bch_inode_info as SLAB_ACCOUNT
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Youling Tang <youling.tang@linux.dev>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org,
 Youling Tang <tangyouling@kylinos.cn>
References: <20240703070955.104163-1-youling.tang@linux.dev>
 <m5jemgkisszzs564ikvo6q6qr73tadanvoyyqstthzyamzsr3n@33quhsmhaxhz>
 <20589721-46c0-4344-b2ef-6ab48bbe2ea5@linux.dev>
Content-Language: en-US, en-AU
In-Reply-To: <20589721-46c0-4344-b2ef-6ab48bbe2ea5@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Hi, Kent

On 12/07/2024 09:39, Youling Tang wrote:
> On 12/07/2024 08:03, Kent Overstreet wrote:
>> On Wed, Jul 03, 2024 at 03:09:55PM GMT, Youling Tang wrote:
>>> From: Youling Tang <tangyouling@kylinos.cn>
>>>
>>> After commit 230e9fc28604 ("slab: add SLAB_ACCOUNT flag"), we need 
>>> to mark
>>> the inode cache as SLAB_ACCOUNT, similar to commit 5d097056c9a0 
>>> ("kmemcg:
>>> account for certain kmem allocations to memcg")
>>>
>>> Signed-off-by: Youling Tang <tangyouling@kylinos.cn>
>> Turns out this was never tested with memcg enabled (!).
>>
>> I'm reverting it, please feel free to send me a fixed version.
> Sorry, my oversight.
>
> The following null pointer dereference is triggered after MEMCG 
> configuration is enabled.
> ```
> BUG: kernel NULL pointer dereference, address: 0000000000000008
> #PF: supervisor read access in kernel mode
> #PF: error_code(0x0000) - not-present page
> PGD 0 P4D 0
> Oops: Oops: 0000 [#1] SMP
> CPU: 5 PID: 1702 Comm: umount Not tainted 
> 6.10.0-rc7-ktest-00003-g557bd05b0d4c-dirty #12
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.15.0-1 
> 04/01/2014
> RIP: 0010:list_lru_add+0x83/0x100
> Code: 5f 5d c3 48 8b 45 d0 48 85 c0 74 13 41 80 7c 24 1c 00 48 63 b0 
> 68 06 00 00 74 04 85 f6 79 5e 4d 03 2c 24 49 83 c5 08 4c 89 ea <49> 8b 
> 45 08 49 89 5d 08 48 89 13 48 89 43 08 48 89 18 49 8b 45 10
> RSP: 0018:ffff8881178efd10 EFLAGS: 00010246
> RAX: 0000000000000000 RBX: ffff88810ec140f0 RCX: 0000000000000000
> RDX: 0000000000000000 RSI: 0000000000000017 RDI: ffff8881178efcc8
> RBP: ffff8881178efd48 R08: ffff8881009de780 R09: ffffffff822e0de0
> R10: 0000000000000000 R11: 0000000000000000 R12: ffff888102075c80
> R13: 0000000000000000 R14: ffff88810443e6c0 R15: 0000000000000000
> FS:  00007f9ed1840800(0000) GS:ffff888179940000(0000) 
> knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000000000000008 CR3: 00000001062b9005 CR4: 0000000000370eb0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
>
> Call Trace:
>  <TASK>
>  ? show_regs+0x69/0x70
>  ? __die+0x29/0x70
>  ? page_fault_oops+0x14f/0x3c0
>  ? do_user_addr_fault+0x2d0/0x5b0
>  ? default_wake_function+0x1e/0x30
>  ? exc_page_fault+0x6d/0x130
>  ? asm_exc_page_fault+0x2b/0x30
>  ? list_lru_add+0x83/0x100
>  list_lru_add_obj+0x4b/0x60
>  iput+0x1fe/0x220
>  dentry_unlink_inode+0xbd/0x120
>  __dentry_kill+0x78/0x180
>  dput+0xc7/0x170
>  shrink_dcache_for_umount+0xe8/0x120
>  generic_shutdown_super+0x23/0x150
>  bch2_kill_sb+0x1b/0x30
>  deactivate_locked_super+0x34/0xb0
>  deactivate_super+0x44/0x50
>  cleanup_mnt+0x105/0x160
>  __cleanup_mnt+0x16/0x20
>  task_work_run+0x63/0x90
>  syscall_exit_to_user_mode+0x10d/0x110
>  do_syscall_64+0x57/0x100
>  entry_SYSCALL_64_after_hwframe+0x4b/0x53
> RIP: 0033:0x7f9ed1a7a6e7
> Code: 0c 00 f7 d8 64 89 02 b8 ff ff ff ff c3 66 0f 1f 44 00 00 31 f6 
> e9 09 00 00 00 66 0f 1f 84 00 00 00 00 00 b8 a6 00 00 00 0f 05 <48> 3d 
> 00 f0 ff ff 77 01 c3 48 8b 15 09 97 0c 00 f7 d8 64 89 02 b8
> RSP: 002b:00007ffef8a29128 EFLAGS: 00000246 ORIG_RAX: 00000000000000a6
> RAX: 0000000000000000 RBX: 000055f4671acad8 RCX: 00007f9ed1a7a6e7
> RDX: 0000000000000000 RSI: 0000000000000000 RDI: 000055f4671b1240
> RBP: 0000000000000000 R08: 0000000000000001 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 00007f9ed1bc6244
> R13: 000055f4671b1240 R14: 000055f4671acde0 R15: 000055f4671ac9d0
>  </TASK>
> ```
The direct cause of the BUG is that the return value of 
list_lru_from_memcg_idx()
is NULL, and the execution of l->list will cause NULL pointer dereference.

The return value of list_lru_from_memcg_idx() needs to be determined, 
similar to
commit 5abc1e37afa0 ("mm: list_lru: allocate list_lru_one only when 
needed").

Modified as follows:
diff --git a/mm/list_lru.c b/mm/list_lru.c
index 3fd64736bc45..ee7424c3879d 100644
--- a/mm/list_lru.c
+++ b/mm/list_lru.c
@@ -94,6 +94,9 @@ bool list_lru_add(struct list_lru *lru, struct 
list_head *item, int nid,
         spin_lock(&nlru->lock);
         if (list_empty(item)) {
                 l = list_lru_from_memcg_idx(lru, nid, 
memcg_kmem_id(memcg));
+               if (!l)
+                       goto out;
+
                 list_add_tail(item, &l->list);
                 /* Set shrinker bit if the first element was added */
                 if (!l->nr_items++)
@@ -102,6 +105,7 @@ bool list_lru_add(struct list_lru *lru, struct 
list_head *item, int nid,
                 spin_unlock(&nlru->lock);
                 return true;
         }
+out:
         spin_unlock(&nlru->lock);
         return false;
  }


After ktest test tests/bcachefs/xfstests.ktest can continue to test 
(enable MEMCG
and MEMCG_KMEM).

Thanks,
Youling.

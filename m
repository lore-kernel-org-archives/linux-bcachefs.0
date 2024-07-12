Received: from out-185.mta1.migadu.com (out-185.mta1.migadu.com [95.215.58.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 691A1C2F2
	for <linux-bcachefs@vger.kernel.org>; Fri, 12 Jul 2024 01:40:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720748415; cv=none; b=XN66G78/bqYAAP09CFXmExxQdNheZ8S7jvDrBEdIwWYj6tL6G3sjy6zMUvkBnSJWsYh6+XiLiPJDKg7YFYXyH+5JO6KEyagmDYBB9fgJFkm3JXyAMkTkEl+0FbkAXL+qgzS0zuqbxwUVPo6A4Ejs6z3sL4fNE9OwzTM+8OC6WfM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720748415; c=relaxed/simple;
	bh=hxplaeiPOfntNLsgT3KbZ6SoSJVnJpSGnAPeZ0iCKm4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=C31SzTnb2q0Y7GvctqU7KC71HPBHyhYkNX2u1jep7glOWW6i+cy9QXGgesT5j1P6FIxBwi+64gBbTNXPiUpI1TPkZqhI358oo1Lpy6cPFV68od0rwO33zfvK3PJSf4QJocdy60EzY8bTHBP6pUMDZOO5MENohVT0c8IIkTPyaCE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=QdUPvEnf; arc=none smtp.client-ip=95.215.58.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="QdUPvEnf"
X-Envelope-To: kent.overstreet@linux.dev
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1720748411;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=z4kVCgLQxQ+3RmITCcskQciQroI5JcKysM1VGWZJR6E=;
	b=QdUPvEnfDaswVrBDOVcNUYZEB9GCf4swH+WJBXpX/3rLKsfMPTb9iqawZS5OJtoh22IgQx
	EAuecbaDLqZ8TeEZmehDhf8+7NKBIDNGgONUmXP2UODpigBnd6fvZLb7ugy8f2netYbjwP
	uRTHyQdMMoUl3Qw6cZFDbq2VtAoy4Zc=
X-Envelope-To: linux-bcachefs@vger.kernel.org
X-Envelope-To: linux-kernel@vger.kernel.org
X-Envelope-To: tangyouling@kylinos.cn
Message-ID: <20589721-46c0-4344-b2ef-6ab48bbe2ea5@linux.dev>
Date: Fri, 12 Jul 2024 09:39:37 +0800
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH] bcachefs: Mark bch_inode_info as SLAB_ACCOUNT
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org,
 Youling Tang <tangyouling@kylinos.cn>
References: <20240703070955.104163-1-youling.tang@linux.dev>
 <m5jemgkisszzs564ikvo6q6qr73tadanvoyyqstthzyamzsr3n@33quhsmhaxhz>
Content-Language: en-US, en-AU
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Youling Tang <youling.tang@linux.dev>
In-Reply-To: <m5jemgkisszzs564ikvo6q6qr73tadanvoyyqstthzyamzsr3n@33quhsmhaxhz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

On 12/07/2024 08:03, Kent Overstreet wrote:
> On Wed, Jul 03, 2024 at 03:09:55PM GMT, Youling Tang wrote:
>> From: Youling Tang <tangyouling@kylinos.cn>
>>
>> After commit 230e9fc28604 ("slab: add SLAB_ACCOUNT flag"), we need to mark
>> the inode cache as SLAB_ACCOUNT, similar to commit 5d097056c9a0 ("kmemcg:
>> account for certain kmem allocations to memcg")
>>
>> Signed-off-by: Youling Tang <tangyouling@kylinos.cn>
> Turns out this was never tested with memcg enabled (!).
>
> I'm reverting it, please feel free to send me a fixed version.
Sorry, my oversight.

The following null pointer dereference is triggered after MEMCG 
configuration is enabled.
```
BUG: kernel NULL pointer dereference, address: 0000000000000008
#PF: supervisor read access in kernel mode
#PF: error_code(0x0000) - not-present page
PGD 0 P4D 0
Oops: Oops: 0000 [#1] SMP
CPU: 5 PID: 1702 Comm: umount Not tainted 
6.10.0-rc7-ktest-00003-g557bd05b0d4c-dirty #12
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.15.0-1 04/01/2014
RIP: 0010:list_lru_add+0x83/0x100
Code: 5f 5d c3 48 8b 45 d0 48 85 c0 74 13 41 80 7c 24 1c 00 48 63 b0 68 
06 00 00 74 04 85 f6 79 5e 4d 03 2c 24 49 83 c5 08 4c 89 ea <49> 8b 45 
08 49 89 5d 08 48 89 13 48 89 43 08 48 89 18 49 8b 45 10
RSP: 0018:ffff8881178efd10 EFLAGS: 00010246
RAX: 0000000000000000 RBX: ffff88810ec140f0 RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000017 RDI: ffff8881178efcc8
RBP: ffff8881178efd48 R08: ffff8881009de780 R09: ffffffff822e0de0
R10: 0000000000000000 R11: 0000000000000000 R12: ffff888102075c80
R13: 0000000000000000 R14: ffff88810443e6c0 R15: 0000000000000000
FS:  00007f9ed1840800(0000) GS:ffff888179940000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000008 CR3: 00000001062b9005 CR4: 0000000000370eb0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400

Call Trace:
  <TASK>
  ? show_regs+0x69/0x70
  ? __die+0x29/0x70
  ? page_fault_oops+0x14f/0x3c0
  ? do_user_addr_fault+0x2d0/0x5b0
  ? default_wake_function+0x1e/0x30
  ? exc_page_fault+0x6d/0x130
  ? asm_exc_page_fault+0x2b/0x30
  ? list_lru_add+0x83/0x100
  list_lru_add_obj+0x4b/0x60
  iput+0x1fe/0x220
  dentry_unlink_inode+0xbd/0x120
  __dentry_kill+0x78/0x180
  dput+0xc7/0x170
  shrink_dcache_for_umount+0xe8/0x120
  generic_shutdown_super+0x23/0x150
  bch2_kill_sb+0x1b/0x30
  deactivate_locked_super+0x34/0xb0
  deactivate_super+0x44/0x50
  cleanup_mnt+0x105/0x160
  __cleanup_mnt+0x16/0x20
  task_work_run+0x63/0x90
  syscall_exit_to_user_mode+0x10d/0x110
  do_syscall_64+0x57/0x100
  entry_SYSCALL_64_after_hwframe+0x4b/0x53
RIP: 0033:0x7f9ed1a7a6e7
Code: 0c 00 f7 d8 64 89 02 b8 ff ff ff ff c3 66 0f 1f 44 00 00 31 f6 e9 
09 00 00 00 66 0f 1f 84 00 00 00 00 00 b8 a6 00 00 00 0f 05 <48> 3d 00 
f0 ff ff 77 01 c3 48 8b 15 09 97 0c 00 f7 d8 64 89 02 b8
RSP: 002b:00007ffef8a29128 EFLAGS: 00000246 ORIG_RAX: 00000000000000a6
RAX: 0000000000000000 RBX: 000055f4671acad8 RCX: 00007f9ed1a7a6e7
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 000055f4671b1240
RBP: 0000000000000000 R08: 0000000000000001 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00007f9ed1bc6244
R13: 000055f4671b1240 R14: 000055f4671acde0 R15: 000055f4671ac9d0
  </TASK>
```

I'm going to analyze it.

Thanks,
Youling.

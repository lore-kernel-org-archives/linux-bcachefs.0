Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCF49181310
	for <linux-bcachefs@vger.kernel.org>; Sun,  1 Sep 2024 14:09:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725199769; cv=none; b=QHxRv5o466YFFIQqNUS5nqFkyWUB8yFBiv8ps1dId9rin+mhgd95Ho1bSsdeiEum1gPZIzNbXFZGQJSbwm2PWrkgHsRm7wY0phwgJxc3z4Y5W8U6yLSYB4c7bulEa9T0Y6lBExv21kIf+e9ZQLjAaIroHyYIIKCMSHk61oginUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725199769; c=relaxed/simple;
	bh=+SIyGEShH8BRP2gWJRs4V3I8yNOKFRowwYk09N0T1N8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=G/EDzj5bpexBBEoAQ3UMLajIf+QBiEsAJjXm824sWGoUFaTI9V47AAX6VNQIypvpccbJ8kCv8a7H/nSgYHoCKha6Pex0P0UQsB6IFm6LQPkkoRMmqEKNXxnA7O3e22OVyAxOoyvidN/7b7uJ6AZKvSgLlJMHYgxow5tOZ53wraM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=gYlJJ3Dp; arc=none smtp.client-ip=91.218.175.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="gYlJJ3Dp"
Date: Sun, 1 Sep 2024 10:09:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1725199765;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=57DN4AShLkWRHL/01oHU0s+irklAPcT1E9JTZnZ9MF8=;
	b=gYlJJ3Dp5OWIGNhMxSNoWjd5V5jN/lsC3tvktDVp7lrGSNEm1oG/v1d+FiNwxmzrcDcCuM
	hBrF0mFZj/ACD2MLeesBIGbiAsCF+PqneTEth/ulLe71z2EZwLbu4NfI803STRjFE0KNk9
	53VJydsWyiop1SdhG3SFTI9ck3aDC+A=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Hui Guo <guohui.study@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-bcachefs@vger.kernel.org, syzkaller-bugs@googlegroups.com
Subject: Re: general protection fault in bioset_exit
Message-ID: <nm2qm77haolpraz3ta3pxh5mv52yfbxe6qzix5j7h3jmq4zljl@4qfjzp3dfadd>
References: <CAHOo4gJxTt2HrnN8s9zM0spSV385R=ykNd8Mp_zvPS8tGP3Nfw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHOo4gJxTt2HrnN8s9zM0spSV385R=ykNd8Mp_zvPS8tGP3Nfw@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT

On Sun, Sep 01, 2024 at 09:09:19PM GMT, Hui Guo wrote:
> Hi Kernel Maintainers,
> we found a bug "general protection fault in bioset_exit" in upstream,
> and reproduced it successfully:
> HEAD Commit: d5d547aa7b51467b15d9caa86b116f8c2507c72a(Merge tag
> 'random-6.11-rc6-for-linus')
> kernel config: https://github.com/androidAppGuard/KernelBugs/blob/main/6.11.config
> console output:
> https://github.com/androidAppGuard/KernelBugs/blob/main/d5d547aa7b51467b15d9caa86b116f8c2507c72a/5e472bcde03516824974868fc1dd30ab00bd2cd1/log0
> syz reproducer:
> https://github.com/androidAppGuard/KernelBugs/blob/main/d5d547aa7b51467b15d9caa86b116f8c2507c72a/5e472bcde03516824974868fc1dd30ab00bd2cd1/repro.prog
> C reproducer: https://github.com/androidAppGuard/KernelBugs/blob/main/d5d547aa7b51467b15d9caa86b116f8c2507c72a/5e472bcde03516824974868fc1dd30ab00bd2cd1/repro.cprog
> 
> Please let me know if there is anything I can help.
> Best,
> Hui Guo

Can you repro with kasan?

> 
> The following context is the crash report.
> ================================================================================
> bcachefs (loop2): bch2_fs_recovery(): error fsck_errors_not_fixed
> bcachefs (loop2): bch2_fs_start(): error starting filesystem
> fsck_errors_not_fixed
> bcachefs (loop2): shutting down
> bcachefs (loop2): shutdown complete
> Oops: general protection fault, probably for non-canonical address
> 0x2feaecb40264aa05: 0000 [#1] PREEMPT SMP KASAN NOPTI
> CPU: 0 UID: 0 PID: 40510 Comm: syz.2.2252 Not tainted
> 6.11.0-rc5-00081-gd5d547aa7b51 #1
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.15.0-1 04/01/2014
> RIP: 0010:qlist_move_cache+0x6b/0x120
> data/linux_kernel/linux/mm/kasan/quarantine.c:302
> Code: 26 49 83 3e 00 0f 84 bb 00 00 00 49 8b 46 08 4c 89 28 4d 89 6e
> 08 49 c7 45 00 00 00 00 00 49 01 56 10 4d 85 ff 74 6a 4d 89 fd <4d> 8b
> 3f 4c 89 ef e8 5a 53 58 ff 48 c1 e8 0c 48 c1 e0 06 4c 01 e0
> RSP: 0018:ffffc900024f7990 EFLAGS: 00010006
> RAX: ffff88805ba22200 RBX: ffffc900024f79c8 RCX: ffffffff813d99ef
> RDX: 0000000000001100 RSI: ffffffff813d99f9 RDI: 0000000000000007
> RBP: ffff88804bcb2500 R08: 0000000000000001 R09: fffff5200049ef27
> R10: 0000000000000000 R11: 0000000000000000 R12: ffffea0000000000
> R13: 2feaecb40264aa05 R14: ffffffff94c417c0 R15: 2feaecb40264aa05
> FS: 00007f30de39e640(0000) GS:ffff88802c400000(0000) knlGS:0000000000000000
> CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007f7fd3cf0090 CR3: 00000000291d2000 CR4: 0000000000750ef0
> PKRU: 80000000
> Call Trace:
> <TASK>
> kasan_quarantine_remove_cache+0x102/0x190
> data/linux_kernel/linux/mm/kasan/quarantine.c:370
> shutdown_cache data/linux_kernel/linux/mm/slab_common.c:546 [inline]
> kmem_cache_destroy data/linux_kernel/linux/mm/slab_common.c:588 [inline]
> kmem_cache_destroy+0x58/0x1b0 data/linux_kernel/linux/mm/slab_common.c:571
> bio_put_slab data/linux_kernel/linux/block/bio.c:155 [inline]
> bioset_exit+0x2ff/0x5b0 data/linux_kernel/linux/block/bio.c:1750
> bch2_fs_fs_io_direct_exit+0x19/0x30
> data/linux_kernel/linux/fs/bcachefs/fs-io-direct.c:670
> __bch2_fs_free data/linux_kernel/linux/fs/bcachefs/super.c:543 [inline]
> bch2_fs_release+0xad/0x8e0 data/linux_kernel/linux/fs/bcachefs/super.c:608
> kobject_cleanup data/linux_kernel/linux/lib/kobject.c:689 [inline]
> kobject_release data/linux_kernel/linux/lib/kobject.c:720 [inline]
> kref_put data/linux_kernel/linux/include/linux/kref.h:65 [inline]
> kobject_put+0x1af/0x4c0 data/linux_kernel/linux/lib/kobject.c:737
> bch2_fs_get_tree+0x1002/0x1330 data/linux_kernel/linux/fs/bcachefs/fs.c:2041
> vfs_get_tree+0x94/0x380 data/linux_kernel/linux/fs/super.c:1800
> do_new_mount data/linux_kernel/linux/fs/namespace.c:3472 [inline]
> path_mount+0x6b2/0x1ea0 data/linux_kernel/linux/fs/namespace.c:3799
> do_mount data/linux_kernel/linux/fs/namespace.c:3812 [inline]
> __do_sys_mount data/linux_kernel/linux/fs/namespace.c:4020 [inline]
> __se_sys_mount data/linux_kernel/linux/fs/namespace.c:3997 [inline]
> __x64_sys_mount+0x284/0x310 data/linux_kernel/linux/fs/namespace.c:3997
> do_syscall_x64 data/linux_kernel/linux/arch/x86/entry/common.c:52 [inline]
> do_syscall_64+0xcb/0x250 data/linux_kernel/linux/arch/x86/entry/common.c:83
> entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f30dd59b45e
> Code: 48 c7 c0 ff ff ff ff eb aa e8 5e 20 00 00 66 2e 0f 1f 84 00 00
> 00 00 00 0f 1f 40 00 f3 0f 1e fa 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d
> 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007f30de39dda8 EFLAGS: 00000246 ORIG_RAX: 00000000000000a5
> RAX: ffffffffffffffda RBX: 000000000000f61f RCX: 00007f30dd59b45e
> RDX: 000000002000f640 RSI: 000000002000f680 RDI: 00007f30de39de00
> RBP: 00007f30de39de40 R08: 00007f30de39de40 R09: 0000000000000000
> R10: 0000000001200040 R11: 0000000000000246 R12: 000000002000f640
> R13: 000000002000f680 R14: 00007f30de39de00 R15: 0000000020000040
> </TASK>
> Modules linked in:
> ---[ end trace 0000000000000000 ]---
> RIP: 0010:qlist_move_cache+0x6b/0x120
> data/linux_kernel/linux/mm/kasan/quarantine.c:302
> Code: 26 49 83 3e 00 0f 84 bb 00 00 00 49 8b 46 08 4c 89 28 4d 89 6e
> 08 49 c7 45 00 00 00 00 00 49 01 56 10 4d 85 ff 74 6a 4d 89 fd <4d> 8b
> 3f 4c 89 ef e8 5a 53 58 ff 48 c1 e8 0c 48 c1 e0 06 4c 01 e0
> RSP: 0018:ffffc900024f7990 EFLAGS: 00010006
> RAX: ffff88805ba22200 RBX: ffffc900024f79c8 RCX: ffffffff813d99ef
> RDX: 0000000000001100 RSI: ffffffff813d99f9 RDI: 0000000000000007
> RBP: ffff88804bcb2500 R08: 0000000000000001 R09: fffff5200049ef27
> R10: 0000000000000000 R11: 0000000000000000 R12: ffffea0000000000
> R13: 2feaecb40264aa05 R14: ffffffff94c417c0 R15: 2feaecb40264aa05
> FS: 00007f30de39e640(0000) GS:ffff88802c400000(0000) knlGS:0000000000000000
> CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007f7fd3cf0090 CR3: 00000000291d2000 CR4: 0000000000750ef0
> PKRU: 80000000
> ----------------
> Code disassembly (best guess):
> 0: 26 49 83 3e 00 es cmpq $0x0,(%r14)
> 5: 0f 84 bb 00 00 00 je 0xc6
> b: 49 8b 46 08 mov 0x8(%r14),%rax
> f: 4c 89 28 mov %r13,(%rax)
> 12: 4d 89 6e 08 mov %r13,0x8(%r14)
> 16: 49 c7 45 00 00 00 00 movq $0x0,0x0(%r13)
> 1d: 00
> 1e: 49 01 56 10 add %rdx,0x10(%r14)
> 22: 4d 85 ff test %r15,%r15
> 25: 74 6a je 0x91
> 27: 4d 89 fd mov %r15,%r13
> * 2a: 4d 8b 3f mov (%r15),%r15 <-- trapping instruction
> 2d: 4c 89 ef mov %r13,%rdi
> 30: e8 5a 53 58 ff call 0xff58538f
> 35: 48 c1 e8 0c shr $0xc,%rax
> 39: 48 c1 e0 06 shl $0x6,%rax
> 3d: 4c 01 e0 add %r12,%rax

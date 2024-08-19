Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B8BA916C6A3;
	Mon, 19 Aug 2024 13:26:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724074012; cv=none; b=eLkaVDiqRaP8egV5slpozehUDxAtJWvyG2dieqhjrhEfKa/GyuuuqJZUgJABvg2+wRXy0SbynjVOlUq1EFSIj3hDOmzqdnV8Dje0Oo7b1cey87RqYLVk+D4DutdFJLlKQYvZPGYsuzp594V4k0WIckBXRzwDKfIE8Lmryzbl9XM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724074012; c=relaxed/simple;
	bh=+0ol8U+5f4hpIwi2SBjnSUTDnRxgf4ARDPozjyJxXDI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tOfv3zLU6/QITHiWXv2E9Zh8x2TDOVmsg/hslWtuVO0LHGQkHnu23aFoBhZrdwHTIIC/5zwrju7GNZ/IEGErT3XfnumfHNnmybEUbjHPmCmyjuTyg0QTxR1yESb6uZbVtSeQ5FB9L2zgRswH+bdVPzztCz21aJIK6f9IT43V0zk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 39923339;
	Mon, 19 Aug 2024 06:27:16 -0700 (PDT)
Received: from J2N7QTR9R3.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 241DC3F73B;
	Mon, 19 Aug 2024 06:26:49 -0700 (PDT)
Date: Mon, 19 Aug 2024 14:26:43 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: syzbot <syzbot+e199425e3ce5a18d178c@syzkaller.appspotmail.com>
Cc: bfoster@redhat.com, kent.overstreet@linux.dev,
	linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org,
	syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] [bcachefs?] WARNING in __virt_to_phys (5)
Message-ID: <ZsNIEyMZFlpaQtPr@J2N7QTR9R3.cambridge.arm.com>
References: <000000000000983fad061fe3df80@google.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000000000000983fad061fe3df80@google.com>

On Sat, Aug 17, 2024 at 09:50:29AM -0700, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    8867bbd4a056 mm: arm64: Fix the out-of-bounds issue in con..

It looks like that's somewhat stale; that commit no longer exists in the
arm64/linux.git for-kernelci branch.

> git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git for-kernelci
> console output: https://syzkaller.appspot.com/x/log.txt?x=14240e91980000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=1bc88a9f65787e86
> dashboard link: https://syzkaller.appspot.com/bug?extid=e199425e3ce5a18d178c
> compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
> userspace arch: arm64
> 
> Unfortunately, I don't have any reproducer for this issue yet.
> 
> Downloadable assets:
> disk image: https://storage.googleapis.com/syzbot-assets/5ef30d34e749/disk-8867bbd4.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/a21c2389ebfb/vmlinux-8867bbd4.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/9720b12c3f99/Image-8867bbd4.gz.xz
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+e199425e3ce5a18d178c@syzkaller.appspotmail.com
> 
> bcachefs (loop4): done starting filesystem
> ------------[ cut here ]------------
> virt_to_phys used for non-linear address: fffffffffffffff2 (0xfffffffffffffff2)

That address looks like an error pointer (it's -14 AKA -EFAULT), though
it's also possible that this is just an offset of -14 from a NULL
pointer.

> WARNING: CPU: 0 PID: 6849 at arch/arm64/mm/physaddr.c:15 __virt_to_phys+0xc4/0x138 arch/arm64/mm/physaddr.c:12
> Modules linked in:
> CPU: 0 PID: 6849 Comm: syz.4.112 Tainted: G        W          6.10.0-rc2-syzkaller-g8867bbd4a056 #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 06/27/2024
> pstate: 60400005 (nZCv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
> pc : __virt_to_phys+0xc4/0x138 arch/arm64/mm/physaddr.c:12
> lr : __virt_to_phys+0xc4/0x138 arch/arm64/mm/physaddr.c:12
> sp : ffff8000a03b6c00
> x29: ffff8000a03b6c00 x28: 0000000000000002 x27: 1ffff00014076d98
> x26: 1ffff00014076d94 x25: dfff800000000000 x24: fffffffffffffff2
> x23: ffff0000c96a2220 x22: 000f600000000000 x21: 000000000000002d
> x20: fffffffffffffff2 x19: 000ffffffffffff2 x18: 1fffe000367a01de
> x17: ffff80008f3bd000 x16: ffff80008033878c x15: 0000000000000001
> x14: 1fffe000367a2e00 x13: 0000000000000000 x12: 0000000000000003
> x11: 0000000000000001 x10: 0000000000000003 x9 : c187ea6d31d9c500
> x8 : c187ea6d31d9c500 x7 : ffff8000802aebf8 x6 : 0000000000000000
> x5 : 0000000000000001 x4 : 0000000000000001 x3 : 0000000000000000
> x2 : ffff0000dc418000 x1 : ffff80008b3800a0 x0 : ffff8001249f9000
> Call trace:
>  __virt_to_phys+0xc4/0x138 arch/arm64/mm/physaddr.c:12
>  virt_to_phys arch/arm64/include/asm/memory.h:368 [inline]
>  virt_to_pfn arch/arm64/include/asm/memory.h:382 [inline]
>  virt_to_folio include/linux/mm.h:1313 [inline]
>  kfree+0xa4/0x3f4 mm/slub.c:4549
>  bch2_ioctl_fsck_online+0x358/0x580 fs/bcachefs/chardev.c:853

AFAICT that's the kfree in the following block:

	char *optstr = strndup_user((char __user *)(unsigned long) arg.opts, 1 << 16);

	ret =   PTR_ERR_OR_ZERO(optstr) ?:
		bch2_parse_mount_opts(c, &thr->opts, NULL, optstr);
	if (!IS_ERR(optstr))
		kfree(optstr);

... where (in v6.11-rc4) that kfree(optstr) is on line 853, and the
prior strndup_user() can return -EFAULT, but that *should* be caught by
the '!IS_ERR(optstr)' check.

Another possibility is that the kfree is a tail-call at the end of
bch2_parse_mount_opts(), and somehow 'copied_opts_start' there is -EFAULT, but
I cannot immeditately see how that could be the case either.

Mark.

>  bch2_fs_ioctl+0x23ec/0x3980 fs/bcachefs/chardev.c:927
>  bch2_fs_file_ioctl+0x7b8/0x2460 fs/bcachefs/fs-ioctl.c:539
>  vfs_ioctl fs/ioctl.c:51 [inline]
>  __do_sys_ioctl fs/ioctl.c:907 [inline]
>  __se_sys_ioctl fs/ioctl.c:893 [inline]
>  __arm64_sys_ioctl+0x14c/0x1c8 fs/ioctl.c:893
>  __invoke_syscall arch/arm64/kernel/syscall.c:34 [inline]
>  invoke_syscall+0x98/0x2b8 arch/arm64/kernel/syscall.c:48
>  el0_svc_common+0x130/0x23c arch/arm64/kernel/syscall.c:133
>  do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:152
>  el0_svc+0x54/0x168 arch/arm64/kernel/entry-common.c:712
>  el0t_64_sync_handler+0x84/0xfc arch/arm64/kernel/entry-common.c:730
>  el0t_64_sync+0x190/0x194 arch/arm64/kernel/entry.S:598
> irq event stamp: 80570
> hardirqs last  enabled at (80569): [<ffff8000802aec98>] raw_spin_rq_unlock_irq kernel/sched/sched.h:1418 [inline]
> hardirqs last  enabled at (80569): [<ffff8000802aec98>] finish_lock_switch+0xbc/0x1e4 kernel/sched/core.c:5162
> hardirqs last disabled at (80570): [<ffff80008b1fe010>] el1_dbg+0x24/0x80 arch/arm64/kernel/entry-common.c:470
> softirqs last  enabled at (80550): [<ffff8000801ea530>] softirq_handle_end kernel/softirq.c:400 [inline]
> softirqs last  enabled at (80550): [<ffff8000801ea530>] handle_softirqs+0xa60/0xc34 kernel/softirq.c:582
> softirqs last disabled at (80541): [<ffff800080020de8>] __do_softirq+0x14/0x20 kernel/softirq.c:588
> ---[ end trace 0000000000000000 ]---
> Unable to handle kernel paging request at virtual address ffffffffc375ffc8
> KASAN: maybe wild-memory-access in range [0x0003fffe1baffe40-0x0003fffe1baffe47]
> Mem abort info:
>   ESR = 0x0000000096000006
>   EC = 0x25: DABT (current EL), IL = 32 bits
>   SET = 0, FnV = 0
>   EA = 0, S1PTW = 0
>   FSC = 0x06: level 2 translation fault
> Data abort info:
>   ISV = 0, ISS = 0x00000006, ISS2 = 0x00000000
>   CM = 0, WnR = 0, TnD = 0, TagAccess = 0
>   GCS = 0, Overlay = 0, DirtyBit = 0, Xs = 0
> swapper pgtable: 4k pages, 48-bit VAs, pgdp=00000001ac6da000
> [ffffffffc375ffc8] pgd=0000000000000000, p4d=00000001afff8003, pud=00000001afff9003, pmd=0000000000000000
> Internal error: Oops: 0000000096000006 [#1] PREEMPT SMP
> Modules linked in:
> CPU: 0 PID: 6849 Comm: syz.4.112 Tainted: G        W          6.10.0-rc2-syzkaller-g8867bbd4a056 #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 06/27/2024
> pstate: 80400005 (Nzcv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
> pc : _compound_head include/linux/page-flags.h:245 [inline]
> pc : virt_to_folio include/linux/mm.h:1315 [inline]
> pc : kfree+0xbc/0x3f4 mm/slub.c:4549
> lr : virt_to_phys arch/arm64/include/asm/memory.h:368 [inline]
> lr : virt_to_pfn arch/arm64/include/asm/memory.h:382 [inline]
> lr : virt_to_folio include/linux/mm.h:1313 [inline]
> lr : kfree+0xa4/0x3f4 mm/slub.c:4549
> sp : ffff8000a03b6c30
> x29: ffff8000a03b6c40 x28: 0000000000000002 x27: 1ffff00014076d98
> x26: 1ffff00014076d94 x25: dfff800000000000 x24: fffffffffffffff2
> x23: ffff0000c96a2220 x22: ffff0000ef24a2d0 x21: fffffffffffffff2
> x20: ffffffffc375ffc0 x19: ffff8000828128a8 x18: 1fffe000367a01de
> x17: ffff80008f3bd000 x16: ffff80008033878c x15: 0000000000000001
> x14: 1fffe000367a2e00 x13: 0000000000000000 x12: 0000000000000003
> x11: 0000000000040000 x10: 0000000000015b3d x9 : 00003e000375ffc0
> x8 : ffffc1ffc0000000 x7 : ffff8000802aebf8 x6 : 0000000000000000
> x5 : 0000000000000001 x4 : 0000000000000001 x3 : 0000000000000000
> x2 : ffff0000dc418000 x1 : ffff80008b3800a0 x0 : 000080011d7ffff2
> Call trace:
>  virt_to_folio include/linux/mm.h:1313 [inline]
>  kfree+0xbc/0x3f4 mm/slub.c:4549
>  bch2_ioctl_fsck_online+0x358/0x580 fs/bcachefs/chardev.c:853
>  bch2_fs_ioctl+0x23ec/0x3980 fs/bcachefs/chardev.c:927
>  bch2_fs_file_ioctl+0x7b8/0x2460 fs/bcachefs/fs-ioctl.c:539
>  vfs_ioctl fs/ioctl.c:51 [inline]
>  __do_sys_ioctl fs/ioctl.c:907 [inline]
>  __se_sys_ioctl fs/ioctl.c:893 [inline]
>  __arm64_sys_ioctl+0x14c/0x1c8 fs/ioctl.c:893
>  __invoke_syscall arch/arm64/kernel/syscall.c:34 [inline]
>  invoke_syscall+0x98/0x2b8 arch/arm64/kernel/syscall.c:48
>  el0_svc_common+0x130/0x23c arch/arm64/kernel/syscall.c:133
>  do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:152
>  el0_svc+0x54/0x168 arch/arm64/kernel/entry-common.c:712
>  el0t_64_sync_handler+0x84/0xfc arch/arm64/kernel/entry-common.c:730
>  el0t_64_sync+0x190/0x194 arch/arm64/kernel/entry.S:598
> Code: 927acd29 f2d83fe8 cb141929 8b080134 (f9400688) 
> ---[ end trace 0000000000000000 ]---
> ----------------
> Code disassembly (best guess):
>    0:	927acd29 	and	x9, x9, #0x3ffffffffffffc0
>    4:	f2d83fe8 	movk	x8, #0xc1ff, lsl #32
>    8:	cb141929 	sub	x9, x9, x20, lsl #6
>    c:	8b080134 	add	x20, x9, x8
> * 10:	f9400688 	ldr	x8, [x20, #8] <-- trapping instruction
> 
> 
> ---
> This report is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
> 
> syzbot will keep track of this issue. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> 
> If the report is already addressed, let syzbot know by replying with:
> #syz fix: exact-commit-title
> 
> If you want to overwrite report's subsystems, reply with:
> #syz set subsystems: new-subsystem
> (See the list of subsystem names on the web dashboard)
> 
> If the report is a duplicate of another one, reply with:
> #syz dup: exact-subject-of-another-report
> 
> If you want to undo deduplication, reply with:
> #syz undup
> 

Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8ABAA22AE6B
	for <linux-bcachefs@vger.kernel.org>; Mon,  9 Jun 2025 03:13:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749438842; cv=none; b=HkYyMYgFSs81h7Gx/io8t/3b6GmVDPZY+mk0LmvXBMZDQNCcvyQudwMgwj0bUr/4AYl3s5n/7uW9TER4InAM7+a1m20AgFYrS88Io1iZEpsva2sR2O17lBW+cn4Y/B9E9JWHKIhcNkrJS4AIiVEC1VtMAC9e64NuMzVFxf9RG7M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749438842; c=relaxed/simple;
	bh=LuC1REvqf2J3I3cUlm7xbcAhQI+rzhMmPRvSkoVm7lU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PqxmZXtbW+yajdsO9xK99E6ChUcYdoKDr3fY3YP1NrpedIMCDbH2NTKnyulPBH9molgqjMZ2by0VOy3GzCjz9uV8WMeo3OKOJojZzEf6CNsZMeEvFq2cZcFge1XMnDHVDmH20lBE8Zx6onJLhFJYOFlKgVGYw9OqCEkWiY2/56k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=qYTrw9yX; arc=none smtp.client-ip=91.218.175.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="qYTrw9yX"
Date: Sun, 8 Jun 2025 23:13:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1749438836;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=77SKXZFXlxBTThsqWIARMtmSrc8b3NwkGRLW9sc79K0=;
	b=qYTrw9yX7COcwvS0mDjTbr4ppYaj300vjOxEhmTd6THWMYtqJMndvebID1h4bhxujzs4lq
	DRB3vMvP9XUzsR93JNVVYfOj9yEWcUMPFgO50iHdC1sBxYKSh4m0nsxxske+gWyRqeh9wn
	UHXnM6uPk2Jpbe38sJPRIbXSTjHgST8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: syzbot <syzbot+e37a1730d63d207fe403@syzkaller.appspotmail.com>
Cc: gregkh@linuxfoundation.org, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com, tj@kernel.org
Subject: Re: [syzbot] [kernfs?] [bcachefs?] general protection fault in
 kernfs_dop_revalidate
Message-ID: <yashsei2srtn35imny476up2r3vui3mj3totulsshbbpvouiqd@ajuj6lafmh4x>
References: <6745a8df.050a0220.1286eb.0015.GAE@google.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6745a8df.050a0220.1286eb.0015.GAE@google.com>
X-Migadu-Flow: FLOW_OUT

I'm not seeing anything connecting this to bcachefs.

On Tue, Nov 26, 2024 at 02:54:23AM -0800, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    28eb75e178d3 Merge tag 'drm-next-2024-11-21' of https://gi..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=17955b78580000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=402159daa216c89d
> dashboard link: https://syzkaller.appspot.com/bug?extid=e37a1730d63d207fe403
> compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=163706e8580000
> 
> Downloadable assets:
> disk image: https://storage.googleapis.com/syzbot-assets/e3c9c97af7d9/disk-28eb75e1.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/1e22f3d29103/vmlinux-28eb75e1.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/8ff56ec30fa6/bzImage-28eb75e1.xz
> mounted in repro: https://storage.googleapis.com/syzbot-assets/92ddc9fa5ec9/mount_0.gz
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+e37a1730d63d207fe403@syzkaller.appspotmail.com
> 
> Oops: general protection fault, probably for non-canonical address 0xdffffc000000000a: 0000 [#1] PREEMPT SMP KASAN PTI
> KASAN: null-ptr-deref in range [0x0000000000000050-0x0000000000000057]
> CPU: 0 UID: 0 PID: 5210 Comm: udevd Not tainted 6.12.0-syzkaller-07749-g28eb75e178d3 #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/30/2024
> RIP: 0010:kernfs_root fs/kernfs/kernfs-internal.h:70 [inline]
> RIP: 0010:kernfs_dop_revalidate+0x8e/0x560 fs/kernfs/dir.c:1158
> Code: c5 80 04 00 00 48 89 e8 48 c1 e8 03 42 80 3c 30 00 74 08 48 89 ef e8 c1 9e c1 ff 4c 8b 7d 00 4d 8d 67 30 4c 89 e3 48 c1 eb 03 <42> 80 3c 33 00 74 08 4c 89 e7 e8 a3 9e c1 ff 49 8b 6f 30 48 85 ed
> RSP: 0018:ffffc900033efa90 EFLAGS: 00010206
> RAX: 1ffff1100c748639 RBX: 000000000000000a RCX: ffff88807deada00
> RDX: ffff88807deada00 RSI: 0000000000000000 RDI: 0000000000000000
> RBP: ffff888063a431c8 R08: ffffffff823b3da8 R09: 1ffffffff20391a6
> R10: dffffc0000000000 R11: ffffffff823b3d80 R12: 0000000000000051
> R13: ffff88807affb318 R14: dffffc0000000000 R15: 0000000000000021
> FS:  00007fa024cb5c80(0000) GS:ffff8880b8600000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007fe48c1ff000 CR3: 000000007d586000 CR4: 00000000003526f0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
>  <TASK>
>  lookup_fast+0x1f4/0x4a0
>  walk_component+0x57/0x410 fs/namei.c:2108
>  lookup_last fs/namei.c:2610 [inline]
>  path_lookupat+0x16f/0x450 fs/namei.c:2634
>  filename_lookup+0x2a3/0x670 fs/namei.c:2663
>  do_readlinkat+0xf0/0x3a0 fs/stat.c:562
>  __do_sys_readlink fs/stat.c:599 [inline]
>  __se_sys_readlink fs/stat.c:596 [inline]
>  __x64_sys_readlink+0x7f/0x90 fs/stat.c:596
>  do_syscall_x64 arch/x86/entry/common.c:52 [inline]
>  do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7fa024917d47
> Code: 73 01 c3 48 8b 0d e1 90 0d 00 f7 d8 64 89 01 48 83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 b8 59 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d b1 90 0d 00 f7 d8 64 89 01 48
> RSP: 002b:00007ffdac68fa58 EFLAGS: 00000246 ORIG_RAX: 0000000000000059
> RAX: ffffffffffffffda RBX: 00007ffdac68fa68 RCX: 00007fa024917d47
> RDX: 0000000000000400 RSI: 00007ffdac68fa68 RDI: 00007ffdac68ff48
> RBP: 0000000000000400 R08: 000055b53fcce374 R09: 0000000000000000
> R10: 0000000000000812 R11: 0000000000000246 R12: 00007ffdac68ff48
> R13: 00007ffdac68feb8 R14: 000055b53fcc3910 R15: 0000000000000000
>  </TASK>
> Modules linked in:
> ---[ end trace 0000000000000000 ]---
> RIP: 0010:kernfs_root fs/kernfs/kernfs-internal.h:70 [inline]
> RIP: 0010:kernfs_dop_revalidate+0x8e/0x560 fs/kernfs/dir.c:1158
> Code: c5 80 04 00 00 48 89 e8 48 c1 e8 03 42 80 3c 30 00 74 08 48 89 ef e8 c1 9e c1 ff 4c 8b 7d 00 4d 8d 67 30 4c 89 e3 48 c1 eb 03 <42> 80 3c 33 00 74 08 4c 89 e7 e8 a3 9e c1 ff 49 8b 6f 30 48 85 ed
> RSP: 0018:ffffc900033efa90 EFLAGS: 00010206
> 
> RAX: 1ffff1100c748639 RBX: 000000000000000a RCX: ffff88807deada00
> RDX: ffff88807deada00 RSI: 0000000000000000 RDI: 0000000000000000
> RBP: ffff888063a431c8 R08: ffffffff823b3da8 R09: 1ffffffff20391a6
> R10: dffffc0000000000 R11: ffffffff823b3d80 R12: 0000000000000051
> R13: ffff88807affb318 R14: dffffc0000000000 R15: 0000000000000021
> FS:  00007fa024cb5c80(0000) GS:ffff8880b8600000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000001b2ee5ffff CR3: 000000007d586000 CR4: 00000000003526f0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> ----------------
> Code disassembly (best guess), 1 bytes skipped:
>    0:	80 04 00 00          	addb   $0x0,(%rax,%rax,1)
>    4:	48 89 e8             	mov    %rbp,%rax
>    7:	48 c1 e8 03          	shr    $0x3,%rax
>    b:	42 80 3c 30 00       	cmpb   $0x0,(%rax,%r14,1)
>   10:	74 08                	je     0x1a
>   12:	48 89 ef             	mov    %rbp,%rdi
>   15:	e8 c1 9e c1 ff       	call   0xffc19edb
>   1a:	4c 8b 7d 00          	mov    0x0(%rbp),%r15
>   1e:	4d 8d 67 30          	lea    0x30(%r15),%r12
>   22:	4c 89 e3             	mov    %r12,%rbx
>   25:	48 c1 eb 03          	shr    $0x3,%rbx
> * 29:	42 80 3c 33 00       	cmpb   $0x0,(%rbx,%r14,1) <-- trapping instruction
>   2e:	74 08                	je     0x38
>   30:	4c 89 e7             	mov    %r12,%rdi
>   33:	e8 a3 9e c1 ff       	call   0xffc19edb
>   38:	49 8b 6f 30          	mov    0x30(%r15),%rbp
>   3c:	48 85 ed             	test   %rbp,%rbp
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
> If you want syzbot to run the reproducer, reply with:
> #syz test: git://repo/address.git branch-or-commit-hash
> If you attach or paste a git patch, syzbot will apply it before testing.
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

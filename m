Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 545AA2E717F
	for <linux-bcachefs@vger.kernel.org>; Fri, 18 Jul 2025 17:48:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752860895; cv=none; b=nfhcyUQj31YHtKsPCJsZDQVYv6tSN+v58F3A/lsZYjtpOkVILklDVH22kMdrxbDrYakJYV93FlA6zhKh0AWL7L4JuDUTvFyqA0Whdxcx7Ks5eXOKMr/7ZOOBM/SB3F2a/4IGnEwUVBzethh6CUKkSHCTZrKReQ7EdaZQ/uDT0qY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752860895; c=relaxed/simple;
	bh=mzzjGN45joZGnvp8f28PqKcd3YKxSWARz+VYx9M6wXw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dkuurCflt5TsfIgKvXes+n7F+NHpw4mVtXoaCaLpzesI28p33oiy9pemmjvq+m2h3BR1kYGA96M7iPmvIBOz0oGmr/fWUs8giTyfS1XVamX4dqcKVn1CtRMj1owxHR7uC+eUkZgBnv/Apb/ZSjvkECJWtn1cP4PT/PAWuCC5dQE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=nbnuni49; arc=none smtp.client-ip=91.218.175.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="nbnuni49"
Date: Fri, 18 Jul 2025 13:48:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1752860890;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=VUTeXIBey0yAZHmz9jTxxcUB9BBedR5oDK38kj40LiE=;
	b=nbnuni49umgLeeQjLqtRoCbnaa6Oilxvo53kUd/FPZJwC2rSAqgFUjdeEGc1MryvYW0ya2
	pQHEgy6swgD5+IqnpV3PzvMKp3pMnlteoKX3yPgHXW0ACjP8UdQhSLGcFhFVnuf3J4qI6D
	6aPSrUyK9qBAS3TYs/D7OCeKpYQjQtc=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: syzbot <syzbot+56edda805363e0a093b8@syzkaller.appspotmail.com>
Cc: linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] [bcachefs?] BUG: unable to handle kernel NULL pointer
 dereference in mempool_alloc_noprof (2)
Message-ID: <bdnhmqeqgv3igi5x33n6j5dhjizodp7s5bugt4omjcfxesqncb@xgarlfhy4i6s>
References: <683bede4.a00a0220.d8eae.002a.GAE@google.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <683bede4.a00a0220.d8eae.002a.GAE@google.com>
X-Migadu-Flow: FLOW_OUT

On Sat, May 31, 2025 at 11:06:28PM -0700, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    4cb6c8af8591 selftests/filesystems: Fix build of anon_inod..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=16a8a00c580000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=43b7075a5c42ffca
> dashboard link: https://syzkaller.appspot.com/bug?extid=56edda805363e0a093b8
> compiler:       Debian clang version 20.1.6 (++20250514063057+1e4d39e07757-1~exp1~20250514183223.118), Debian LLD 20.1.6
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=11c67ed4580000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=147a300c580000
> 
> Downloadable assets:
> disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-4cb6c8af.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/91b28032d866/vmlinux-4cb6c8af.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/7cf2a9f8c096/bzImage-4cb6c8af.xz
> mounted in repro #1: https://storage.googleapis.com/syzbot-assets/9c0eef7ba9b5/mount_0.gz
> mounted in repro #2: https://storage.googleapis.com/syzbot-assets/0c5386ea7a4e/mount_4.gz
>   fsck result: failed (log: https://syzkaller.appspot.com/x/fsck.log?x=12a8a00c580000)
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+56edda805363e0a093b8@syzkaller.appspotmail.com
> 
> BUG: kernel NULL pointer dereference, address: 0000000000000000
> #PF: supervisor instruction fetch in kernel mode
> #PF: error_code(0x0010) - not-present page
> PGD 0 P4D 0 
> Oops: Oops: 0010 [#1] SMP KASAN NOPTI
> CPU: 0 UID: 0 PID: 5317 Comm: syz-executor257 Not tainted 6.15.0-syzkaller-10402-g4cb6c8af8591 #0 PREEMPT(full) 
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
> RIP: 0010:0x0
> Code: Unable to access opcode bytes at 0xffffffffffffffd6.
> RSP: 0018:ffffc9000d3fedb8 EFLAGS: 00010246
> RAX: dffffc0000000000 RBX: 0000000000000000 RCX: ffff888044583ee8
> RDX: 1ffff110088b07dd RSI: 0000000000000000 RDI: 0000000000092800
> RBP: ffffc9000d3fef10 R08: ffffc9000d3fee87 R09: 0000000000000000
> R10: ffffc9000d3fee60 R11: 0000000000000000 R12: 1ffff92001a7fdc8
> R13: ffff888044583ee8 R14: 0000000000092c40 R15: 0000000000092800
> FS:  0000000000000000(0000) GS:ffff88808d265000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: ffffffffffffffd6 CR3: 0000000042a6b000 CR4: 0000000000352ef0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
>  <TASK>
>  mempool_alloc_noprof+0x1a7/0x510 mm/mempool.c:402
>  bch2_btree_update_start+0x549/0x1480 fs/bcachefs/btree_update_interior.c:1194
>  bch2_btree_node_rewrite+0x17e/0x1120 fs/bcachefs/btree_update_interior.c:2208
>  bch2_move_btree+0x6f0/0xc70 fs/bcachefs/move.c:1093
>  bch2_scan_old_btree_nodes+0x95/0x240 fs/bcachefs/move.c:1215
>  bch2_data_job+0x646/0x910 fs/bcachefs/move.c:1354
>  bch2_data_thread+0x8f/0x1d0 fs/bcachefs/chardev.c:315
>  kthread+0x711/0x8a0 kernel/kthread.c:464
>  ret_from_fork+0x3fc/0x770 arch/x86/kernel/process.c:148
>  ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
>  </TASK>
> Modules linked in:
> CR2: 0000000000000000
> ---[ end trace 0000000000000000 ]---
> RIP: 0010:0x0
> Code: Unable to access opcode bytes at 0xffffffffffffffd6.
> RSP: 0018:ffffc9000d3fedb8 EFLAGS: 00010246
> RAX: dffffc0000000000 RBX: 0000000000000000 RCX: ffff888044583ee8
> RDX: 1ffff110088b07dd RSI: 0000000000000000 RDI: 0000000000092800
> RBP: ffffc9000d3fef10 R08: ffffc9000d3fee87 R09: 0000000000000000
> R10: ffffc9000d3fee60 R11: 0000000000000000 R12: 1ffff92001a7fdc8
> R13: ffff888044583ee8 R14: 0000000000092c40 R15: 0000000000092800
> FS:  0000000000000000(0000) GS:ffff88808d265000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: ffffffffffffffd6 CR3: 0000000042a6b000 CR4: 0000000000352ef0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
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

#syz fix: bcachefs: Fix pool->alloc NULL pointer dereference


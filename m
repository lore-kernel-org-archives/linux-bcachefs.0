Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FB8B5234
	for <linux-bcachefs@vger.kernel.org>; Tue, 22 Jul 2025 16:30:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753201804; cv=none; b=Wgv2bJ7cddYLsTbqXksNQuWrFd64K8XWXYy4q6pd5xltYr8frenWEYDpbYufXTfx5mRdJSk8BzKhYqAn0aoFyOE1zP8m73qWAvBk78k7fkYd7e6DVBPsm91Ns8ppmb3+WCHsldMxHGDnQiS0uiCN34ULQad3/hA2qAS9xVGj/34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753201804; c=relaxed/simple;
	bh=AsQvfMdiK8W8NFN90GSwW6ec0JqJcr6L/UUrJiXti/o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Y4T1NOCYtwCEvsWk+yl7x4HUxiOOdE8qKD9JW/G387ATx1Bg9zNINCeGErw92D9BCn0lE1RHJuG55tomGmUyHDphjylN4wMnUqPYIY+FNX1ECMtm06mWG/gzERXCdb8K28oLNU5V91cbh6/Tb6yd2or8EnP6y4vdkQmYw09UNaM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=bBgpmfqF; arc=none smtp.client-ip=95.215.58.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="bBgpmfqF"
Date: Tue, 22 Jul 2025 12:29:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1753201799;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=lPK6JrqfYtm3z9mCpw0FeYHI7qE2MbHiCCmZEkPxiSM=;
	b=bBgpmfqFy50cyG8WqIfqp7eGnTvggVuaYx9Ns5zjMXguNkLVj/7XoAQE89jc/pmLHWFQ3M
	CCNULdQ6uYYd/obxPq+Vufy9FlCp3EnZfbpdpdTGFJfrloW+osNQA8Mr0hftFiIiIsMNDd
	r326Df0jhBjCPWJdgkErT3p8mGUJQkU=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: syzbot <syzbot+e99c7092c361b53acda2@syzkaller.appspotmail.com>
Cc: linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] [bcachefs?] WARNING in bch2_verify_accounting_clean
Message-ID: <jv7oulzafj2lzcp7un5h7n46xg7gt7dvkvaz6vyos3jkfxhomu@jvowpwx7nzac>
References: <67a79f76.050a0220.110943.000e.GAE@google.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <67a79f76.050a0220.110943.000e.GAE@google.com>
X-Migadu-Flow: FLOW_OUT

On Sat, Feb 08, 2025 at 10:16:22AM -0800, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    7ee983c850b4 Merge tag 'drm-fixes-2025-02-08' of https://g..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=11f75ca4580000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=147b7d49d83b8036
> dashboard link: https://syzkaller.appspot.com/bug?extid=e99c7092c361b53acda2
> compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
> 
> Unfortunately, I don't have any reproducer for this issue yet.
> 
> Downloadable assets:
> disk image: https://storage.googleapis.com/syzbot-assets/54ead761f64f/disk-7ee983c8.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/95e57de2a045/vmlinux-7ee983c8.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/d24a612a8ac7/bzImage-7ee983c8.xz
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+e99c7092c361b53acda2@syzkaller.appspotmail.com
> 
> bcachefs (loop3): flushing journal and stopping allocators, journal seq 9
> bcachefs (loop3): flushing journal and stopping allocators complete, journal seq 9
> bcachefs (loop3): clean shutdown complete, journal seq 10
> bcachefs: bch2_verify_accounting_clean() fs_usage_base.nr_inodes mismatch: 0 != 1
> ------------[ cut here ]------------
> WARNING: CPU: 1 PID: 5823 at fs/bcachefs/disk_accounting.c:993 bch2_verify_accounting_clean+0x2917/0x2ad0 fs/bcachefs/disk_accounting.c:993
> Modules linked in:
> CPU: 1 UID: 0 PID: 5823 Comm: syz-executor Not tainted 6.14.0-rc1-syzkaller-00181-g7ee983c850b4 #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 12/27/2024
> RIP: 0010:bch2_verify_accounting_clean+0x2917/0x2ad0 fs/bcachefs/disk_accounting.c:993
> Code: e9 8f fe ff ff e8 09 6b 6d fd 48 c7 c7 a0 6c 52 8c 48 c7 c6 21 c9 12 8e 48 c7 c2 80 6d 52 8c 31 c9 4d 89 e0 e8 3a 0d d5 fc 90 <0f> 0b 90 e9 93 fe ff ff e8 dc 6a 6d fd e9 63 fb ff ff e8 d2 6a 6d
> RSP: 0018:ffffc9000413f5e0 EFLAGS: 00010246
> RAX: 0000000000000051 RBX: 0000000000000000 RCX: 193b5623fccba700
> RDX: 0000000000000000 RSI: 0000000080000000 RDI: 0000000000000000
> RBP: ffffc9000413fa30 R08: ffffffff819f140c R09: fffffbfff1cfa588
> R10: dffffc0000000000 R11: fffffbfff1cfa588 R12: 0000000000000001
> R13: 0000000000000000 R14: 0000000000000000 R15: fffff52000827eec
> FS:  000055557e55e500(0000) GS:ffff8880b8700000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007f8ed0a00000 CR3: 000000005ee48000 CR4: 00000000003526f0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
>  <TASK>
>  bch2_fs_read_only+0x1150/0x12a0 fs/bcachefs/super.c:379
>  __bch2_fs_stop+0x105/0x5c0 fs/bcachefs/super.c:634
>  generic_shutdown_super+0x139/0x2d0 fs/super.c:642
>  bch2_kill_sb+0x41/0x50 fs/bcachefs/fs.c:2312
>  deactivate_locked_super+0xc4/0x130 fs/super.c:473
>  cleanup_mnt+0x41f/0x4b0 fs/namespace.c:1413
>  task_work_run+0x24f/0x310 kernel/task_work.c:227
>  resume_user_mode_work include/linux/resume_user_mode.h:50 [inline]
>  exit_to_user_mode_loop kernel/entry/common.c:114 [inline]
>  exit_to_user_mode_prepare include/linux/entry-common.h:329 [inline]
>  __syscall_exit_to_user_mode_work kernel/entry/common.c:207 [inline]
>  syscall_exit_to_user_mode+0x13f/0x340 kernel/entry/common.c:218
>  do_syscall_64+0x100/0x230 arch/x86/entry/common.c:89
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f049258e117
> Code: a8 ff ff ff f7 d8 64 89 01 48 83 c8 ff c3 0f 1f 44 00 00 31 f6 e9 09 00 00 00 66 0f 1f 84 00 00 00 00 00 b8 a6 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 01 c3 48 c7 c2 a8 ff ff ff f7 d8 64 89 02 b8
> RSP: 002b:00007ffee7626798 EFLAGS: 00000246 ORIG_RAX: 00000000000000a6
> RAX: 0000000000000000 RBX: 00007f049260e08c RCX: 00007f049258e117
> RDX: 0000000000000000 RSI: 0000000000000009 RDI: 00007ffee7626850
> RBP: 00007ffee7626850 R08: 0000000000000000 R09: 0000000000000000
> R10: 00000000ffffffff R11: 0000000000000246 R12: 00007ffee76278e0
> R13: 00007f049260e08c R14: 0000000000010591 R15: 00007ffee7627920
>  </TASK>
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

There were a few recent fixes for accounting updates prior to going
read-write - these were discovered as part of the 'bcachefs image
update' work, which is adding a new device before bch2_fs_start().

So the last of the "in-mem accounting going out of sync with the btree"
bugs should be fixed.

#syz fix: bcachefs: do_bch2_trans_commit_to_journal_replay handles accounting

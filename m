Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B325327AC44
	for <linux-bcachefs@vger.kernel.org>; Tue, 22 Jul 2025 16:25:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753201526; cv=none; b=fKV8Dl4OgUKrJ3ORe5jmxYCNKKKOIQySvDFAjXkgRe/5x4T2JOvV/QlSuKaE4kdnGsOzxFKZrR/2xAU8YYAcr7fLRhHVzL/eqBCHrK2HCU4Qdx8/mYoawwsuukZ+sHstAmWnBQ29+TmgjB42zNChPtQlGu2zVwTIGn8fr4H3NVY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753201526; c=relaxed/simple;
	bh=LsJrl5YU5FmJ++eDK4f7mINLKFSTqistBIDSWE3w4As=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NV8EYqzC8e+iYgANbXMCjri4X36hseLSACGCM/KeVaybXlz0HrsBzO5cM1vVeimShH+qBgUK7yam/5MfKs+EjX5lCWZ3SUVNaetlb7GIbpIlvNnhzpA5Irp+OkpOyHKOYjh3+eecPpUt+LF3XyH1D8vEaX5kre9vud7qCNUBV3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=cYZAwplb; arc=none smtp.client-ip=91.218.175.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="cYZAwplb"
Date: Tue, 22 Jul 2025 12:25:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1753201521;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=RIXLg9v/IdS1mS4xLfLFZRiF5wBRttJDXmavwXsuWE8=;
	b=cYZAwplbUJTotwba/+KO7TaIa35r7BGrlRDwOnzzqnlDdv+eX0VJOXLhbSzme4OMw3oJ3P
	7F6lKpQSy9X3KlAcjyjqKmUPasen2cQ4ddLpfKk6O0EMQPpxQE7XIa/3xR3n0YCRg+1qDv
	V0n1gwZ5r8fMVp2d55fc3MjTNUBo8h8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: syzbot <syzbot+0ea2c41a649240197795@syzkaller.appspotmail.com>
Cc: linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] [bcachefs?] WARNING in closure_put_after_sub
Message-ID: <xebzu2wivmygmp2vv7warfdogmde3ythapjlxzfmlxm5seoq3x@zksozuaettul>
References: <68784c5f.a70a0220.693ce.0036.GAE@google.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <68784c5f.a70a0220.693ce.0036.GAE@google.com>
X-Migadu-Flow: FLOW_OUT

On Wed, Jul 16, 2025 at 06:05:35PM -0700, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    3f31a806a62e Merge tag 'mm-hotfixes-stable-2025-07-11-16-1..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=116e1d82580000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=b309c907eaab29da
> dashboard link: https://syzkaller.appspot.com/bug?extid=0ea2c41a649240197795
> compiler:       Debian clang version 20.1.7 (++20250616065708+6146a88f6049-1~exp1~20250616065826.132), Debian LLD 20.1.7
> 
> Unfortunately, I don't have any reproducer for this issue yet.
> 
> Downloadable assets:
> disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-3f31a806.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/7304d62ced97/vmlinux-3f31a806.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/4913df6ab730/bzImage-3f31a806.xz
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+0ea2c41a649240197795@syzkaller.appspotmail.com
> 
> ------------[ cut here ]------------
> closure has guard bits set: a8000000 (25)
> WARNING: CPU: 0 PID: 5328 at lib/closure.c:22 closure_put_after_sub_checks lib/closure.c:20 [inline]
> WARNING: CPU: 0 PID: 5328 at lib/closure.c:22 closure_put_after_sub+0x173/0x320 lib/closure.c:32
> Modules linked in:
> CPU: 0 UID: 0 PID: 5328 Comm: kworker/u5:2 Not tainted 6.16.0-rc5-syzkaller-00266-g3f31a806a62e #0 PREEMPT(full) 
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
> Workqueue: bcachefs_journal journal_write_done
> RIP: 0010:closure_put_after_sub_checks lib/closure.c:20 [inline]
> RIP: 0010:closure_put_after_sub+0x173/0x320 lib/closure.c:32
> Code: c1 6e 50 ff cd 4c 89 f3 e9 c8 fe ff ff e8 85 f7 c9 fc 90 44 89 f0 48 0f bd d0 48 c7 c7 40 f5 e4 8b 44 89 fe e8 3e da 8d fc 90 <0f> 0b 90 90 e9 d0 fe ff ff e8 5f f7 c9 fc 90 89 ee 81 e6 00 00 00
> RSP: 0018:ffffc9000d5ef820 EFLAGS: 00010246
> RAX: 641034d4b1ecad00 RBX: ffffffff936402f0 RCX: ffff88801c734880
> RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000002
> RBP: 00000000efffffff R08: ffff88801fc24293 R09: 1ffff11003f84852
> R10: dffffc0000000000 R11: ffffed1003f84853 R12: dffffc0000000000
> R13: ffff88805324a9f0 R14: 0000000003ffffff R15: 00000000a8000000
> FS:  0000000000000000(0000) GS:ffff88808d21b000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000563f86c91bc0 CR3: 0000000033352000 CR4: 0000000000352ef0
> Call Trace:
>  <TASK>
>  closure_sub lib/closure.c:61 [inline]
>  __closure_wake_up+0x81/0xb0 lib/closure.c:91
>  closure_wake_up include/linux/closure.h:349 [inline]
>  journal_write_done+0x994/0x1270 fs/bcachefs/journal_io.c:1768
>  process_one_work kernel/workqueue.c:3238 [inline]
>  process_scheduled_works+0xae1/0x17b0 kernel/workqueue.c:3321
>  worker_thread+0x8a0/0xda0 kernel/workqueue.c:3402
>  kthread+0x70e/0x8a0 kernel/kthread.c:464
>  ret_from_fork+0x3fc/0x770 arch/x86/kernel/process.c:148
>  ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
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

ec.c was returning with the passed-in closure on c->freelist_wait,
without returning an error that indicated we were blocking

#syz fix: bcachefs: Ensure we don't return with closure on waitlist

Received: from mout01.posteo.de (mout01.posteo.de [185.67.36.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B211A1D516C
	for <linux-bcachefs@vger.kernel.org>; Wed,  9 Apr 2025 16:09:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.67.36.65
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744214989; cv=none; b=CPdovobDVUbFmQtN5bBLN9B7s21Dk8Eg+xy0cpgR6GCHC9/g6xdgK5xCJm3c6K1eaNvMteUM2axP22Xu4luwis2Vzye1jraDekTwalHKiD/YWEUojoNyVsSZGTn8hYNecVKIHWYkW9SNq4N0x/bxLgRvolGeKF2kH52OhEDb+C4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744214989; c=relaxed/simple;
	bh=YAIk8YC+InUQBAT/tdz5r5BfPfHq2GwlGqV0TbjAmQI=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=OOuQRgnEDDf/Vq1sVWTiUjPDbSvChGDfaabx7Dha2kfyI4OG+M9BCkPHqMPsIHd9IAR3y02wzmd6omMqx4VLHawX6NcGKBMpRavZZ1a7d7/9nXArlAN63+sCC1uB6s6yn57MImqjePxtLP5iKUpgLlbp5EkbIJOYBuFCqpLp9s0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=posteo.net; spf=pass smtp.mailfrom=posteo.net; dkim=pass (2048-bit key) header.d=posteo.net header.i=@posteo.net header.b=IFbtFwS7; arc=none smtp.client-ip=185.67.36.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=posteo.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=posteo.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=posteo.net header.i=@posteo.net header.b="IFbtFwS7"
Received: from submission (posteo.de [185.67.36.169]) 
	by mout01.posteo.de (Postfix) with ESMTPS id C00F2240029
	for <linux-bcachefs@vger.kernel.org>; Wed,  9 Apr 2025 18:09:43 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=posteo.net; s=2017;
	t=1744214983; bh=YAIk8YC+InUQBAT/tdz5r5BfPfHq2GwlGqV0TbjAmQI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type:
	 From;
	b=IFbtFwS790K5tuYYjRPD44RA9AmXRc51puUH/B63xn1+ej/vMAvmcRJd6Fk3lDraC
	 MiFf1DFCsDX6wq1Of0XeqKAseg0JeHneqLQ/VmGJEzpMOqMIgTYollfFB4gOBKbM0C
	 CLGqJhwbk+sBdBtyxblEvaEHVcHP6q3tJUblQhmbPvIukuWFw73lMKCd1KycIhLeV6
	 AjQSKdIYYm7g9omb+1DlKdKeNAmR/y7hKl1Xc5g9PuN9b6jBbOtjF/ksl2wRvQuTd7
	 BS7JK0asIx+OX+NiI+B4guL8ock3jcbLrooV3BhjUG+Hoh7wwtXfbN9gJRvDA0pgwH
	 Qv3VJSKKCWkSg==
Received: from customer (localhost [127.0.0.1])
	by submission (posteo.de) with ESMTPSA id 4ZXnvp2VqPz9rxG;
	Wed,  9 Apr 2025 18:09:42 +0200 (CEST)
From: Charalampos Mitrodimas <charmitro@posteo.net>
To: syzbot <syzbot+aec9606169fbc3a12ca6@syzkaller.appspotmail.com>
Cc: kent.overstreet@linux.dev,  linux-bcachefs@vger.kernel.org,
  linux-kernel@vger.kernel.org,  syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] [bcachefs?] WARNING in bch2_dev_free
In-Reply-To: <67f50e3e.050a0220.396535.0560.GAE@google.com> (syzbot's message
	of "Tue, 08 Apr 2025 04:53:34 -0700")
References: <67f50e3e.050a0220.396535.0560.GAE@google.com>
Date: Wed, 09 Apr 2025 16:09:41 +0000
Message-ID: <m25xjds4e2.fsf@posteo.net>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

syzbot <syzbot+aec9606169fbc3a12ca6@syzkaller.appspotmail.com> writes:

> Hello,
>
> syzbot found the following issue on:
>
> HEAD commit:    a4cda136f021 Add linux-next specific files for 20250404
> git tree:       linux-next
> console+strace: https://syzkaller.appspot.com/x/log.txt?x=12c3db4c580000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=8a257c454bb1afb7
> dashboard link: https://syzkaller.appspot.com/bug?extid=aec9606169fbc3a12ca6
> compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=17ca0c04580000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=11c3db4c580000
>
> Downloadable assets:
> disk image: https://storage.googleapis.com/syzbot-assets/59048bc9c206/disk-a4cda136.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/ad2ba7306f20/vmlinux-a4cda136.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/b3bef7acbf10/bzImage-a4cda136.xz
> mounted in repro: https://storage.googleapis.com/syzbot-assets/110624be1513/mount_0.gz
>
> The issue was bisected to:
>
> commit dcffc3b1ae3251d796a25c673f614e3099ca83d3
> Author: Kent Overstreet <kent.overstreet@linux.dev>
> Date:   Sun Mar 30 03:11:08 2025 +0000
>
>     bcachefs: Split up bch_dev.io_ref
>
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=13948c04580000
> final oops:     https://syzkaller.appspot.com/x/report.txt?x=10548c04580000
> console output: https://syzkaller.appspot.com/x/log.txt?x=17948c04580000
>
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+aec9606169fbc3a12ca6@syzkaller.appspotmail.com
> Fixes: dcffc3b1ae32 ("bcachefs: Split up bch_dev.io_ref")
>
> bcachefs (loop0): shutting down
> ------------[ cut here ]------------
> WARNING: CPU: 0 PID: 5844 at fs/bcachefs/super.c:1229 bch2_dev_free+0x228/0x290 fs/bcachefs/super.c:1229
> Modules linked in:
> CPU: 0 UID: 0 PID: 5844 Comm: syz-executor121 Not tainted 6.14.0-next-20250404-syzkaller #0 PREEMPT(full) 
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 02/12/2025
> RIP: 0010:bch2_dev_free+0x228/0x290 fs/bcachefs/super.c:1229
> Code: ff e8 4c cf 74 00 4c 89 ef e8 44 cf 74 00 48 89 df 48 83 c4 10 5b 41 5c 41 5d 41 5e 41 5f 5d e9 ee 53 96 07 e8 59 e9 32 fd 90 <0f> 0b 90 e9 09 fe ff ff e8 4b e9 32 fd 90 0f 0b 90 e9 15 fe ff ff
> RSP: 0018:ffffc9000406fb88 EFLAGS: 00010293
> RAX: ffffffff849073d7 RBX: ffff888035282000 RCX: ffff888034af9e00
> RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
> RBP: ffff8880352820c0 R08: ffffffff850552f7 R09: 0000000000000000
> R10: ffff888035282208 R11: ffffed1006a5044a R12: ffff888075e003f0
> R13: ffff8880352820b0 R14: ffff888075e00000 R15: ffff888075e007b2
> FS:  000055558bb20380(0000) GS:ffff888124f8f000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 000000000045bdd0 CR3: 00000000122a0000 CR4: 00000000003526f0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
>  <TASK>
>  bch2_fs_free+0x2b0/0x400 fs/bcachefs/super.c:688
>  deactivate_locked_super+0xc4/0x130 fs/super.c:473
>  cleanup_mnt+0x422/0x4c0 fs/namespace.c:1435
>  task_work_run+0x251/0x310 kernel/task_work.c:227
>  ptrace_notify+0x2dc/0x390 kernel/signal.c:2520
>  ptrace_report_syscall include/linux/ptrace.h:415 [inline]
>  ptrace_report_syscall_exit include/linux/ptrace.h:477 [inline]
>  syscall_exit_work+0xc7/0x1d0 kernel/entry/common.c:173
>  syscall_exit_to_user_mode_prepare kernel/entry/common.c:200 [inline]
>  __syscall_exit_to_user_mode_work kernel/entry/common.c:205 [inline]
>  syscall_exit_to_user_mode+0x24a/0x340 kernel/entry/common.c:218
>  do_syscall_64+0x100/0x230 arch/x86/entry/syscall_64.c:100
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f49b0cec447
> Code: 07 00 48 83 c4 08 5b 5d c3 66 2e 0f 1f 84 00 00 00 00 00 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 b8 a6 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 01 c3 48 c7 c2 b8 ff ff ff f7 d8 64 89 02 b8
> RSP: 002b:00007ffd94723978 EFLAGS: 00000206 ORIG_RAX: 00000000000000a6
> RAX: 0000000000000000 RBX: 0000000000000000 RCX: 00007f49b0cec447
> RDX: 0000000000000000 RSI: 0000000000000009 RDI: 00007ffd94723a30
> RBP: 00007ffd94723a30 R08: 0000000000000000 R09: 0000000000000000
> R10: 00000000ffffffff R11: 0000000000000206 R12: 00007ffd94724aa0
> R13: 000055558bb216c0 R14: 0000000000000001 R15: 431bde82d7b634db
>  </TASK>
>
>
> ---

#syz test

From: Charalampos Mitrodimas <charmitro@posteo.net>
Subject: [PATCH] bcachefs: Fix WARN_ON in bch2_dev_free

After splitting bch_dev.io_ref into separate READ and WRITE refs, we
need to ensure both refs are properly stopped before freeing a device.
Add bch2_dev_io_ref_stop(ca, WRITE) to bch2_fs_free() to prevent the
WARNING in bch2_dev_free().

Reported-by: syzbot+aec9606169fbc3a12ca6@syzkaller.appspotmail.com
Fixes: dcffc3b1ae32 ("bcachefs: Split up bch_dev.io_ref")
Signed-off-by: Charalampos Mitrodimas <charmitro@posteo.net>
---
 fs/bcachefs/super.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/bcachefs/super.c b/fs/bcachefs/super.c
index a58edde43bee..089b69b685d9 100644
--- a/fs/bcachefs/super.c
+++ b/fs/bcachefs/super.c
@@ -684,6 +684,7 @@ void bch2_fs_free(struct bch_fs *c)
 		if (ca) {
 			EBUG_ON(atomic_long_read(&ca->ref) != 1);
 			bch2_dev_io_ref_stop(ca, READ);
+			bch2_dev_io_ref_stop(ca, WRITE);
 			bch2_free_super(&ca->disk_sb);
 			bch2_dev_free(ca);
 		}
-- 
2.39.5


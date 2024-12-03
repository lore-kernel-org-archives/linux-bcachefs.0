Received: from mail-io1-f77.google.com (mail-io1-f77.google.com [209.85.166.77])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 108751F6696
	for <linux-bcachefs@vger.kernel.org>; Tue,  3 Dec 2024 14:40:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.77
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733236830; cv=none; b=mqF7gzLhFLFO5QVaw+Yda6NPYC4wg03vLwKKrfSDJxT/Sm41Qw5BL/CiI8KprOnMf5RvHBEy7t7FWgqEpVW5dogxSTem7Ihkpf/QbTDuAw4y6kPI3UHY7AhUOQqyXqyk5ruGl2O4NNCkPbnZsSc+/GzJLAclTVBZVO9GBXtckFg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733236830; c=relaxed/simple;
	bh=xnZIPtFgulb7ZmC7MRw/l7zrErAuPTxpjo7bVnr+NIE=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=pD9usMgD6+vg4v2M4R+cSaPcWNp0a/pZD1cmslWUBMPXj/SopNCwgqORjRzWcIWlYSJ0JWgdFuYGKwMBFqag9xCVOO6Uu+173535NCEni2trMy8wpja4rf3ehy2MYWMDECZ27Swweu5GwbIWZycZ/XPkQCx3/kuPTp3q8MuIET4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.77
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f77.google.com with SMTP id ca18e2360f4ac-841a3f2aebfso473164839f.0
        for <linux-bcachefs@vger.kernel.org>; Tue, 03 Dec 2024 06:40:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733236828; x=1733841628;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=B+UJUOlZeSFS4ejT0gYOMuHI+JYM5aJ8as82cOBhLZU=;
        b=n3uyvAwnWAw3+SQhw+MM4PQMpIsKWwdjjdfSfk4NpTkZUCeq81ledTlFnIBa1CFCY3
         s/kws/bkEBWEjXBWNzIEaEt8ix9c9HvcGHHeACbJ22u3zFqzR/KNrrDdpJkWYMxDmvtx
         Wa9bedtV+0+n7AKJKRc7ApR+FWplV5qRYZs1+BtDZ92IyGVse+1xkbzhLLgOIKtgFCqu
         p0ieqA24uOONAvdAAau0C7hR6Rp1QV0hg8Gb7zfInJ9dvMIL0LR8jMaqWN3y4j3tP9MB
         tQHDk7GqJLPZALgomB7klBuekuzi6ifD17C1jqQ/OQ9uy60sS6BfnlJNJajIhh2nbXWJ
         JTPQ==
X-Forwarded-Encrypted: i=1; AJvYcCUrroL11j7rXdf/Wzfv8TLbBlLUXJ0jeu3bklekP6pRPNO6OIrn8GGv5lloR/GEQTLImHDHKcHxh9tkCgNbSw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yyy3n3fVcRkrEZlXUQBkT1SkSH+uy0ZgUJIxV+gWTl3MrD1ldzB
	dt8yIE0X6xEXrBGFV+r2OoUJ9cEQEAWPYUf33dGAC8nSxu48N/t6A4d2l1d36wf7Pfj0sEr3cYs
	GVJVSJ2zbgPX/NwtwCiT5jnxqPArmFVz4NW57iTQWaeH/Gf1WeqfWFp4=
X-Google-Smtp-Source: AGHT+IGHriJz0yQmo8UxkNOK8Bqz1kYnubFeO4Y2UzLjzRLRPoLoMVIHX+vHkOi6PTYXcazovDy0TONbi+mVQD/Z0TIPPH9D31Nl
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:18c6:b0:3a7:e103:3c43 with SMTP id
 e9e14a558f8ab-3a7f9a9fce0mr34758215ab.19.1733236828101; Tue, 03 Dec 2024
 06:40:28 -0800 (PST)
Date: Tue, 03 Dec 2024 06:40:28 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <674f185c.050a0220.48a03.003a.GAE@google.com>
Subject: [syzbot] [bcachefs?] general protection fault in closure_put_after_sub
 (2)
From: syzbot <syzbot+92b863cc48ee12775386@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    cdd30ebb1b9f module: Convert symbol namespace to string li..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=121770df980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=91c852e3d1d7c1a6
dashboard link: https://syzkaller.appspot.com/bug?extid=92b863cc48ee12775386
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/e7e1e116ea6e/disk-cdd30ebb.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/76410fd02a13/vmlinux-cdd30ebb.xz
kernel image: https://storage.googleapis.com/syzbot-assets/60bcdb55dd9c/bzImage-cdd30ebb.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+92b863cc48ee12775386@syzkaller.appspotmail.com

Oops: general protection fault, probably for non-canonical address 0xf26afc1ffff11006: 0000 [#1] PREEMPT SMP KASAN PTI
KASAN: maybe wild-memory-access in range [0x935800ffff888030-0x935800ffff888037]
CPU: 0 UID: 0 PID: 40 Comm: kworker/0:1H Not tainted 6.13.0-rc1-syzkaller-00002-gcdd30ebb1b9f #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 09/13/2024
Workqueue: bcachefs_btree_io btree_node_write_work
RIP: 0010:__lock_acquire+0x6a/0x2100 kernel/locking/lockdep.c:5089
Code: b6 04 30 84 c0 0f 85 f8 16 00 00 45 31 f6 83 3d fb 9b 9d 0e 00 0f 84 c8 13 00 00 89 54 24 60 89 5c 24 38 4c 89 f8 48 c1 e8 03 <80> 3c 30 00 74 12 4c 89 ff e8 a8 7b 8c 00 48 be 00 00 00 00 00 fc
RSP: 0018:ffffc90000b07510 EFLAGS: 00010806
RAX: 126b001ffff11006 RBX: 0000000000000000 RCX: 0000000000000000
RDX: 0000000000000000 RSI: dffffc0000000000 RDI: 935800ffff888032
RBP: 0000000000000001 R08: 0000000000000001 R09: 0000000000000001
R10: dffffc0000000000 R11: fffffbfff203036f R12: ffff888020ad5a00
R13: 0000000000000000 R14: 0000000000000000 R15: 935800ffff888032
FS:  0000000000000000(0000) GS:ffff8880b8600000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000000110c24a819 CR3: 0000000032630000 CR4: 00000000003526f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5849
 __raw_spin_lock include/linux/spinlock_api_smp.h:133 [inline]
 _raw_spin_lock+0x2e/0x40 kernel/locking/spinlock.c:154
 __queue_work+0x759/0xf50
 queue_work_on+0x1c2/0x380 kernel/workqueue.c:2390
 queue_work include/linux/workqueue.h:662 [inline]
 closure_queue include/linux/closure.h:268 [inline]
 closure_put_after_sub+0x2b1/0x330 lib/closure.c:42
 bch2_btree_complete_write fs/bcachefs/btree_io.c:1789 [inline]
 __btree_node_write_done+0x268/0x440 fs/bcachefs/btree_io.c:1800
 btree_node_write_done fs/bcachefs/btree_io.c:1840 [inline]
 btree_node_write_work+0x9d3/0xba0 fs/bcachefs/btree_io.c:1882
 process_one_work kernel/workqueue.c:3229 [inline]
 process_scheduled_works+0xa66/0x1840 kernel/workqueue.c:3310
 worker_thread+0x870/0xd30 kernel/workqueue.c:3391
 kthread+0x2f0/0x390 kernel/kthread.c:389
 ret_from_fork+0x4b/0x80 arch/x86/kernel/process.c:147
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:__lock_acquire+0x6a/0x2100 kernel/locking/lockdep.c:5089
Code: b6 04 30 84 c0 0f 85 f8 16 00 00 45 31 f6 83 3d fb 9b 9d 0e 00 0f 84 c8 13 00 00 89 54 24 60 89 5c 24 38 4c 89 f8 48 c1 e8 03 <80> 3c 30 00 74 12 4c 89 ff e8 a8 7b 8c 00 48 be 00 00 00 00 00 fc
RSP: 0018:ffffc90000b07510 EFLAGS: 00010806
RAX: 126b001ffff11006 RBX: 0000000000000000 RCX: 0000000000000000
RDX: 0000000000000000 RSI: dffffc0000000000 RDI: 935800ffff888032
RBP: 0000000000000001 R08: 0000000000000001 R09: 0000000000000001
R10: dffffc0000000000 R11: fffffbfff203036f R12: ffff888020ad5a00
R13: 0000000000000000 R14: 0000000000000000 R15: 935800ffff888032
FS:  0000000000000000(0000) GS:ffff8880b8600000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000000110c24a819 CR3: 0000000032630000 CR4: 00000000003526f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
----------------
Code disassembly (best guess):
   0:	b6 04                	mov    $0x4,%dh
   2:	30 84 c0 0f 85 f8 16 	xor    %al,0x16f8850f(%rax,%rax,8)
   9:	00 00                	add    %al,(%rax)
   b:	45 31 f6             	xor    %r14d,%r14d
   e:	83 3d fb 9b 9d 0e 00 	cmpl   $0x0,0xe9d9bfb(%rip)        # 0xe9d9c10
  15:	0f 84 c8 13 00 00    	je     0x13e3
  1b:	89 54 24 60          	mov    %edx,0x60(%rsp)
  1f:	89 5c 24 38          	mov    %ebx,0x38(%rsp)
  23:	4c 89 f8             	mov    %r15,%rax
  26:	48 c1 e8 03          	shr    $0x3,%rax
* 2a:	80 3c 30 00          	cmpb   $0x0,(%rax,%rsi,1) <-- trapping instruction
  2e:	74 12                	je     0x42
  30:	4c 89 ff             	mov    %r15,%rdi
  33:	e8 a8 7b 8c 00       	call   0x8c7be0
  38:	48                   	rex.W
  39:	be 00 00 00 00       	mov    $0x0,%esi
  3e:	00 fc                	add    %bh,%ah


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.

If the report is already addressed, let syzbot know by replying with:
#syz fix: exact-commit-title

If you want to overwrite report's subsystems, reply with:
#syz set subsystems: new-subsystem
(See the list of subsystem names on the web dashboard)

If the report is a duplicate of another one, reply with:
#syz dup: exact-subject-of-another-report

If you want to undo deduplication, reply with:
#syz undup

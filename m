Received: from mail-io1-f71.google.com (mail-io1-f71.google.com [209.85.166.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F6738C1A
	for <linux-bcachefs@vger.kernel.org>; Mon, 22 Jul 2024 14:42:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721659358; cv=none; b=KJYAJpd3Cl8MnzJX726Kz86XIwU/PqxtZ7ssZXqmtbMBri/dDOzQeZylvUlWrvH0zDZ5PsmufrVK6ABEG+uFO7KWj1HQnRTncHuuYaiAekykV2pHwSYISIlN4MJoucNMRUUfMJZ7mdcmh/d7d1SmdJUmkqSofYxy9QYqPahQKNE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721659358; c=relaxed/simple;
	bh=Zie3hndK/+jy0eGBxYvNqHkOM4xG0Bl7NL/fSzSywLo=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=XH9YQ3DvDkMLV8d+FxJ7V4icEEQdCSOobuEcYYPfVlefdF5d26NnSOXvgHYSlStRqk4TX2CkyyBSgWT89sJx0SZJ0cjgncYJCoiYsBCgjA6jo20I8eqFzGYvlzGw7hHockoXFBqBzAr0BvQqJAyB58oaFCmsTlcjAoDksgkR0mk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f71.google.com with SMTP id ca18e2360f4ac-806199616d0so713582539f.2
        for <linux-bcachefs@vger.kernel.org>; Mon, 22 Jul 2024 07:42:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721659356; x=1722264156;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=sTa1aFDadFRqKTnzJzDkp3TlrT/LXicGWcAimTXo8lA=;
        b=wAYwE88HK32k+BYuCsEQcStGkRkkDohT7OVgDIAUOW01AR+W01NfCNwcYfd9iRN/pV
         /xFatbIhTzDGkzMpjbWotl2lfPV0xKypaP5HaA8brkfiae6hbUa2YraVYR87Xtpsjs4G
         CUlbfW+SIdSyHUfi1NHvBVDBFZ12EM0OkC2XyCfA29xIfzZRYvP9O1nlEcdglnYZvszM
         M7Xh3UnARuMYO+Ed1auQMTgwefMeGQNoZYCtOJp+0kSQNDDEkxTGdH5pJYmU8dzPO4MO
         6LLdJUkCh+f3AJWCH7k8qGExRbyJGmEEo0olDQ18utZvbqlbcwvUW8vO3ngqNyCxNegD
         RXQw==
X-Forwarded-Encrypted: i=1; AJvYcCXn2DUGuCMSWlvGkeJbp1tqDodXsjj9m7om3tsmsKcTcFi1EhGiCP7hvVbz0eqcrTmSKOQDx8Uo1FbEA2hVBD0ZYnK22tB21CjYT6WFvyg=
X-Gm-Message-State: AOJu0YxKCL+X6Ym5ovforKFFKUL6adPrCPXCSwDi8ZIbSj0gm0rbRFFe
	mAlkr4xV+lan3etobJCG0Xk0eN6mS/qz45i5dpO3CwlSfUJ9KcIEOQavcx4mXYS8rXkiT/5fjzF
	El0frev9SP7kqbvJgLyAqMNRkHu4/IrZvER+TSExdpo121dyo46cPDU0=
X-Google-Smtp-Source: AGHT+IHesvNRHIU7/UvpO8C/NLYFyDeqyZy0+w6MnPJWWNRTaEfTbj0QEL7Tu7Ws+TWTTlRD6pbixlQLOPpF01wd7b/teebD0Hry
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6638:841f:b0:4c0:a8a5:81e9 with SMTP id
 8926c6da1cb9f-4c23fe63d83mr373948173.3.1721659356272; Mon, 22 Jul 2024
 07:42:36 -0700 (PDT)
Date: Mon, 22 Jul 2024 07:42:36 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000005aed00061dd70e04@google.com>
Subject: [syzbot] [bcachefs?] BUG: sleeping function called from invalid
 context in bch2_printbuf_make_room
From: syzbot <syzbot+f765e51170cf13493f0b@syzkaller.appspotmail.com>
To: bfoster@redhat.com, kent.overstreet@linux.dev, 
	linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    73399b58e5e5 Add linux-next specific files for 20240718
git tree:       linux-next
console+strace: https://syzkaller.appspot.com/x/log.txt?x=155c13e9980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=54e443ddc2b981c8
dashboard link: https://syzkaller.appspot.com/bug?extid=f765e51170cf13493f0b
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1390d2f1980000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=146805fd980000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/fbab059c854f/disk-73399b58.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/874a209f4c3f/vmlinux-73399b58.xz
kernel image: https://storage.googleapis.com/syzbot-assets/f34e5c7be278/bzImage-73399b58.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/db661929ee72/mount_0.gz

The issue was bisected to:

commit f7643bc9749f270d487c32dc35b578575bf1adb0
Author: Kent Overstreet <kent.overstreet@linux.dev>
Date:   Wed Apr 17 05:26:02 2024 +0000

    bcachefs: make btree read errors silent during scan

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=123cf7a5980000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=113cf7a5980000
console output: https://syzkaller.appspot.com/x/log.txt?x=163cf7a5980000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+f765e51170cf13493f0b@syzkaller.appspotmail.com
Fixes: f7643bc9749f ("bcachefs: make btree read errors silent during scan")

bcachefs (loop0): recovering from clean shutdown, journal seq 13
bcachefs (loop0): Doing compatible version upgrade from 1.7: mi_btree_bitmap to 1.9: disk_accounting_v2
  running recovery passes: check_allocations
BUG: sleeping function called from invalid context at include/linux/sched/mm.h:337
in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 5104, name: syz-executor271
preempt_count: 1, expected: 0
RCU nest depth: 0, expected: 0
2 locks held by syz-executor271/5104:
 #0: ffff888078f00278 (&c->state_lock){+.+.}-{3:3}, at: bch2_fs_start+0x45/0x5b0 fs/bcachefs/super.c:1006
 #1: ffff888078f4a880 (&j->lock){+.+.}-{2:2}, at: spin_lock include/linux/spinlock.h:351 [inline]
 #1: ffff888078f4a880 (&j->lock){+.+.}-{2:2}, at: bch2_fs_journal_start+0x1219/0x14a0 fs/bcachefs/journal.c:1265
Preemption disabled at:
[<0000000000000000>] 0x0
CPU: 0 UID: 0 PID: 5104 Comm: syz-executor271 Not tainted 6.10.0-next-20240718-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 06/27/2024
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0x241/0x360 lib/dump_stack.c:120
 __might_resched+0x5d4/0x780 kernel/sched/core.c:8526
 might_alloc include/linux/sched/mm.h:337 [inline]
 slab_pre_alloc_hook mm/slub.c:3939 [inline]
 slab_alloc_node mm/slub.c:4017 [inline]
 __do_kmalloc_node mm/slub.c:4157 [inline]
 __kmalloc_node_track_caller_noprof+0xcb/0x440 mm/slub.c:4177
 __do_krealloc mm/slab_common.c:1280 [inline]
 krealloc_noprof+0x7d/0x120 mm/slab_common.c:1313
 bch2_printbuf_make_room+0x1f1/0x350 fs/bcachefs/printbuf.c:59
 bch2_prt_printf+0x267/0x6d0 fs/bcachefs/printbuf.c:186
 bch2_journal_space_available+0x89b/0x1b00 fs/bcachefs/journal_reclaim.c:209
 bch2_fs_journal_start+0x1356/0x14a0 fs/bcachefs/journal.c:1275
 bch2_fs_recovery+0x1ec8/0x38d0 fs/bcachefs/recovery.c:833
 bch2_fs_start+0x356/0x5b0 fs/bcachefs/super.c:1036
 bch2_fs_get_tree+0xd61/0x1700 fs/bcachefs/fs.c:1951
 vfs_get_tree+0x90/0x2a0 fs/super.c:1789
 do_new_mount+0x2be/0xb40 fs/namespace.c:3472
 do_mount fs/namespace.c:3812 [inline]
 __do_sys_mount fs/namespace.c:4020 [inline]
 __se_sys_mount+0x2d6/0x3c0 fs/namespace.c:3997
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fdab3de2dea
Code: d8 64 89 02 48 c7 c0 ff ff ff ff eb a6 e8 5e 04 00 00 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffc5678dad8 EFLAGS: 00000282 ORIG_RAX: 00000000000000a5
RAX: ffffffffffffffda RBX: 00007ffc5678daf0 RCX: 00007fdab3de2dea
RDX: 0000000020000000 RSI: 000000002000f680 RDI: 00007ffc5678daf0
RBP: 0000000000000004 R08: 00007ffc5678db30 R09: 000000000000f626
R10: 0000000000200012 R11: 0000000000000282 R12: 0000000000200012
R13: 00007ffc5678db30 R14: 0000000000000003 R15: 0000000001000000
 </TASK>
bcachefs (loop0): insufficient writeable journal devices available: have 0, need 1
rw journal devs:
bcachefs (loop0): accounting_read... done
bcachefs (loop0): alloc_read... done
bcachefs (loop0): stripes_read... done
bcachefs (loop0): snapshots_read... done
bcachefs (loop0): check_allocations...
btree ptr not marked in member info btree allocated bitmap
  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq 1818ce08861e3527 written 40 min_key POS_MIN durability: 1 ptr: 0:26:0 gen 0, shutting down
bcachefs (loop0): inconsistency detected - emergency read only at journal seq 13
bcachefs (loop0): bch2_gc_mark_key(): error fsck_errors_not_fixed
bcachefs (loop0): bch2_gc_btree(): error fsck_errors_not_fixed
bcachefs (loop0): bch2_gc_btrees(): error fsck_errors_not_fixed
bcachefs (loop0): bch2_check_allocations(): error fsck_errors_not_fixed
bcachefs (loop0): bch2_fs_recovery(): error fsck_errors_not_fixed
bcachefs (loop0): bch2_fs_start(): error starting filesystem fsck_errors_not_fixed
bcachefs (loop0): shutting down
bcachefs (loop0): shutdown complete
bcachefs: bch2_fs_get_tree() error: fsck_errors_not_fixed


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection

If the report is already addressed, let syzbot know by replying with:
#syz fix: exact-commit-title

If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.

If you want to overwrite report's subsystems, reply with:
#syz set subsystems: new-subsystem
(See the list of subsystem names on the web dashboard)

If the report is a duplicate of another one, reply with:
#syz dup: exact-subject-of-another-report

If you want to undo deduplication, reply with:
#syz undup

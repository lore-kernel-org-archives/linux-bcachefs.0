Received: from mail-io1-f80.google.com (mail-io1-f80.google.com [209.85.166.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6216E13B5B0
	for <linux-bcachefs@vger.kernel.org>; Tue, 14 May 2024 10:39:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715683169; cv=none; b=taxtlHk49nFAFPEAP9QzXNJvDrpcimglK8byDoMDAyXXd47hIRbU8qieuvrlRx6CJqjPJ0+o3heJ5J1JlnuWaSy+awZptQuP00M3MbNV8oDZBp4RUXGM5B2x+NQzNfbqvm/O6Qvt0oc6WzWP7Ttrt/pZzxtW3o4oo8GhAMYL4oo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715683169; c=relaxed/simple;
	bh=6UPQyeg0/NEklFVQsWYpVDYn6YwqQ616Kg0qAhdUXaQ=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=V3WtNPGa1WyEtzoMHFH1XoBwRaVT5f45MDZU/PdmFw76m9N6DdoGF6wpEr3a7xSlbR5zJiUU5uSmKKiH+KhamMABn0kgQ6ZiSicyycfUCCYCAGH0AXe8kAyg1JZeFRmlR1Mso1BLNbfG/cohGDd2ciltp3vqa0mzE9QenyiSh/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f80.google.com with SMTP id ca18e2360f4ac-7e17a8bed9eso544351539f.0
        for <linux-bcachefs@vger.kernel.org>; Tue, 14 May 2024 03:39:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715683166; x=1716287966;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=lPAYknr1g5jVKi+ThJU5ulKyp6rTzheR6mKSF8PP+pk=;
        b=YcW9rpbosO2xKahet5GgpmBa4mTDLRAHT/fdHVFNu2bZLNu8crIg7V78LGxraD5VjD
         goNy53j3iTyK5MoRh9EAXmzOoghoELzhffO7EMspdXkW2gU2C928lJGraNmkA0258+Js
         /fJHEFD6KqokSsmDA825ZBZjNVfUYaUnzR1aEkUVcLnbhzJqSZz03a7fl5jKR0q5b046
         y4A8/3ECGUFFt8XdIYuEC+zS6z16Ob5DFLOdjQnHzgznwspc1cgT5cw6p8xtEYQGQ0mq
         3/Bq2+QbYJ/btNEixWP5jfwt0fa4xmdwBK2xOmffWwpyoUEmfN9pAuF4vLQhO2noafNo
         1zOw==
X-Forwarded-Encrypted: i=1; AJvYcCXr8M6CrdOLj8gefvQubsGOP4XKCwwbkLfiUKVQ4nStz/LbzHdWm2Pvt/bRRc4Dbm0tpWV5kMhcC+PiolVnGZj34hfB5t7eQBD95gVvN74=
X-Gm-Message-State: AOJu0YxSPddbr2rs80t0N49sglwKffdrCsQPxvqGY4CkkBbq18X+2a8i
	bgyWRZfMPZF02WHGgYjy/h8CqPX+Zwx4QS+LrclgLIEkqaWC06MZ/68wMB5k9UqRVqzatRc+PPC
	HdTtLH5rwAQYf4kOvnVyk+m1tGcptvVwqOWhyjFwbFv/g32IaQZUPZ+g=
X-Google-Smtp-Source: AGHT+IGhBohnYpxANGC97Cdo3Ti41CFL8EhfzDHVZAoy0td1kuokLJE8mTFG9/f8ADdFOJMjP2QuWBgMmdVA47QZxwttQwHZCnZK
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6638:8917:b0:488:9fae:e95c with SMTP id
 8926c6da1cb9f-48958e02868mr1453317173.4.1715683166680; Tue, 14 May 2024
 03:39:26 -0700 (PDT)
Date: Tue, 14 May 2024 03:39:26 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000b2883b0618679d34@google.com>
Subject: [syzbot] [bcachefs?] general protection fault in __bch2_insert_snapshot_whiteouts
From: syzbot <syzbot+1c9fca23fe478633b305@syzkaller.appspotmail.com>
To: bfoster@redhat.com, kent.overstreet@linux.dev, 
	linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    75fa778d74b7 Add linux-next specific files for 20240510
git tree:       linux-next
console+strace: https://syzkaller.appspot.com/x/log.txt?x=131c3100980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=ccdd3ebd6715749a
dashboard link: https://syzkaller.appspot.com/bug?extid=1c9fca23fe478633b305
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=13e892e4980000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=118d0fb8980000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/ad9391835bcf/disk-75fa778d.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/d827b3da9a26/vmlinux-75fa778d.xz
kernel image: https://storage.googleapis.com/syzbot-assets/8f32f0182388/bzImage-75fa778d.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/056346e690a7/mount_0.gz

The issue was bisected to:

commit f7643bc9749f270d487c32dc35b578575bf1adb0
Author: Kent Overstreet <kent.overstreet@linux.dev>
Date:   Wed Apr 17 05:26:02 2024 +0000

    bcachefs: make btree read errors silent during scan

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=100ed95c980000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=120ed95c980000
console output: https://syzkaller.appspot.com/x/log.txt?x=140ed95c980000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+1c9fca23fe478633b305@syzkaller.appspotmail.com
Fixes: f7643bc9749f ("bcachefs: make btree read errors silent during scan")

Oops: general protection fault, probably for non-canonical address 0xdffffc0000000002: 0000 [#1] PREEMPT SMP KASAN PTI
KASAN: null-ptr-deref in range [0x0000000000000010-0x0000000000000017]
CPU: 1 PID: 5094 Comm: syz-executor156 Not tainted 6.9.0-rc7-next-20240510-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 04/02/2024
RIP: 0010:bch2_snapshot_has_children fs/bcachefs/snapshot.h:184 [inline]
RIP: 0010:__bch2_insert_snapshot_whiteouts+0x306/0x15e0 fs/bcachefs/btree_update.c:135
Code: fb 0f 86 c2 11 00 00 e8 28 d9 7c fd 49 6b c7 38 49 8d 5c 04 18 48 8d 7b 14 48 89 f8 48 c1 e8 03 49 bc 00 00 00 00 00 fc ff df <42> 0f b6 04 20 84 c0 0f 85 3d 12 00 00 44 8b 7b 14 48 83 c3 18 48
RSP: 0018:ffffc900037be0c0 EFLAGS: 00010203
RAX: 0000000000000002 RBX: 0000000000000000 RCX: ffff8880296b0000
RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000014
RBP: ffffc900037be420 R08: ffffffff841942f8 R09: 1ffffffff25f64b0
R10: dffffc0000000000 R11: fffffbfff25f64b1 R12: dffffc0000000000
R13: ffffc900037be380 R14: ffffffff84194214 R15: 00000000ffffffff
FS:  000055555dcea380(0000) GS:ffff8880b9500000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000559e8263e0b0 CR3: 000000006fca6000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 bch2_insert_snapshot_whiteouts fs/bcachefs/btree_update.h:95 [inline]
 bch2_trans_update_extent_overwrite+0xfd6/0x3710 fs/bcachefs/btree_update.c:218
 bch2_trans_update_extent fs/bcachefs/btree_update.c:318 [inline]
 bch2_trans_update+0x186f/0x2550 fs/bcachefs/btree_update.c:514
 bch2_extent_update+0x43c/0xbb0 fs/bcachefs/io_write.c:325
 bch2_write_index_default fs/bcachefs/io_write.c:374 [inline]
 __bch2_write_index+0xee9/0x2190 fs/bcachefs/io_write.c:527
 bch2_write_data_inline fs/bcachefs/io_write.c:1551 [inline]
 bch2_write+0xf4d/0x1670 fs/bcachefs/io_write.c:1619
 closure_queue include/linux/closure.h:269 [inline]
 closure_call include/linux/closure.h:402 [inline]
 bch2_writepage_do_io fs/bcachefs/fs-io-buffered.c:460 [inline]
 bch2_writepages+0x27d/0x380 fs/bcachefs/fs-io-buffered.c:652
 do_writepages+0x359/0x870 mm/page-writeback.c:2634
 filemap_fdatawrite_wbc+0x125/0x180 mm/filemap.c:397
 __filemap_fdatawrite_range mm/filemap.c:430 [inline]
 file_write_and_wait_range+0x1aa/0x290 mm/filemap.c:788
 bch2_fsync+0x93/0x130 fs/bcachefs/fs-io.c:197
 generic_write_sync include/linux/fs.h:2794 [inline]
 bch2_buffered_write fs/bcachefs/fs-io-buffered.c:1128 [inline]
 bch2_write_iter+0x262e/0x2840 fs/bcachefs/fs-io-buffered.c:1136
 new_sync_write fs/read_write.c:497 [inline]
 vfs_write+0xa72/0xc90 fs/read_write.c:590
 ksys_write+0x1a0/0x2c0 fs/read_write.c:643
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf5/0x240 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fbe67e38979
Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 61 17 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffd7ce752c8 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
RAX: ffffffffffffffda RBX: 00007fbe67e8104b RCX: 00007fbe67e38979
RDX: 000000000000000b RSI: 0000000020000680 RDI: 0000000000000004
RBP: 00007fbe67ebe610 R08: 00007ffd7ce75498 R09: 00007ffd7ce75498
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000001
R13: 00007ffd7ce75488 R14: 0000000000000001 R15: 0000000000000001
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:bch2_snapshot_has_children fs/bcachefs/snapshot.h:184 [inline]
RIP: 0010:__bch2_insert_snapshot_whiteouts+0x306/0x15e0 fs/bcachefs/btree_update.c:135
Code: fb 0f 86 c2 11 00 00 e8 28 d9 7c fd 49 6b c7 38 49 8d 5c 04 18 48 8d 7b 14 48 89 f8 48 c1 e8 03 49 bc 00 00 00 00 00 fc ff df <42> 0f b6 04 20 84 c0 0f 85 3d 12 00 00 44 8b 7b 14 48 83 c3 18 48
RSP: 0018:ffffc900037be0c0 EFLAGS: 00010203
RAX: 0000000000000002 RBX: 0000000000000000 RCX: ffff8880296b0000
RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000014
RBP: ffffc900037be420 R08: ffffffff841942f8 R09: 1ffffffff25f64b0
R10: dffffc0000000000 R11: fffffbfff25f64b1 R12: dffffc0000000000
R13: ffffc900037be380 R14: ffffffff84194214 R15: 00000000ffffffff
FS:  000055555dcea380(0000) GS:ffff8880b9400000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000000002000193c CR3: 000000006fca6000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
----------------
Code disassembly (best guess):
   0:	fb                   	sti
   1:	0f 86 c2 11 00 00    	jbe    0x11c9
   7:	e8 28 d9 7c fd       	call   0xfd7cd934
   c:	49 6b c7 38          	imul   $0x38,%r15,%rax
  10:	49 8d 5c 04 18       	lea    0x18(%r12,%rax,1),%rbx
  15:	48 8d 7b 14          	lea    0x14(%rbx),%rdi
  19:	48 89 f8             	mov    %rdi,%rax
  1c:	48 c1 e8 03          	shr    $0x3,%rax
  20:	49 bc 00 00 00 00 00 	movabs $0xdffffc0000000000,%r12
  27:	fc ff df
* 2a:	42 0f b6 04 20       	movzbl (%rax,%r12,1),%eax <-- trapping instruction
  2f:	84 c0                	test   %al,%al
  31:	0f 85 3d 12 00 00    	jne    0x1274
  37:	44 8b 7b 14          	mov    0x14(%rbx),%r15d
  3b:	48 83 c3 18          	add    $0x18,%rbx
  3f:	48                   	rex.W


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

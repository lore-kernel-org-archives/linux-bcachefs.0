Received: from mail-io1-f78.google.com (mail-io1-f78.google.com [209.85.166.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7967C14EC4A
	for <linux-bcachefs@vger.kernel.org>; Tue,  7 May 2024 10:15:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715076924; cv=none; b=iy/R7H+wi5Ax2iNAzj6pkVNYu/KVqrwpp8Yfx6ZBIm+XQyfuBPNxYOA2ws+VDWPn/QIDkj43hUfj4PLdLnmk2q5EtMt5aNL9vwJcEM07dykv41ftaSoC0J1+SGL9k4TR4yxalOdlf5dzW8BETRJbM9oDNEJeJaKzgIQ2978/cIM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715076924; c=relaxed/simple;
	bh=G3lhNLoSVzVwAYj4orpBtWCzukJvuGV3dda6v/anHrY=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=nAp2Yepv3HpEfvIEsn/2pl4e+/F9y3k71qZbXy5dBvWwjYssoXKreOo+ZIvH+5k67hojPi0x6qpiET4jhu9VlPsmqQyi6wueT78Dyq5wzzxCjiG9Q36yARAQZawMlaeJ0A25JU7IJ7jC083mBUBvxgytoovEBTuwl5c46cMGru8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f78.google.com with SMTP id ca18e2360f4ac-7e186a8af8bso24555139f.3
        for <linux-bcachefs@vger.kernel.org>; Tue, 07 May 2024 03:15:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715076922; x=1715681722;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=z6+v8NHIB48he+Pi+SNSoHsPxi35G0HSK4pj5yhcJ1s=;
        b=H97zWhfKs32xxXwC7o1mrZbTRS1yDf7YvDSnHivD6WwZTjWojAJpgW288rbL5Of5RW
         ZupWmKXksM5MoYm9HPJ9dGVZrcVG1KIGU7OO5FMmiO/ne0/B1qa8z3KQ+8Vg0adxf6BZ
         NlNiN8mgsiKftf4h3oJJpGvCnagSHGqWXyP+dE2KgO1BUkkUSKc60/LRv7jetniEgbLV
         D99baHW82bmlGa6jirsOvVf4XTQ4OozBjQh+bL0wQkzeQblvw1NqSrEmrVAgLSRi45KN
         P9XD64zD9FyMO10+DE/Vbwj3ZPCJ0BPVMKfmy2PcYFKHclCoe/BmwGh6dYM+nSGRowuj
         21Mw==
X-Forwarded-Encrypted: i=1; AJvYcCXUq6BFEjNi5z06ML56M0/h0T4jUQVFHeeGtp4X4HwAd/TG8hdACOevzrfOd2F+vBRLAbIhMoeFBnmPbZUeogY+Bywas87qOsiUj2Ren4Y=
X-Gm-Message-State: AOJu0YwK7em7mSh+jjs/JcF+370dR1Eaax+CPT/3M6jDE2JZrzhFeGfy
	XLVq5NB8WBqfhvOfrHXwqsULSxbmy2myAXaV/ZZ1ehfBGNqcITCAF/bllZFxqFsk7+tVTLRk760
	8qvHlfInOe18fHGw1P2FVbw5NXqm+eEweSPd/6ih660QP5sjk34tBl/M=
X-Google-Smtp-Source: AGHT+IHwsqkNaczCNpvvk8ZZqs4EcktZ4KyUYFOS+mtjoVm5/uo+RpW2rCvIiXUyPo7MubB/mmxuKmLg9yACrsrWttf+uhkr9J0Z
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:12c3:b0:36b:140e:a4c with SMTP id
 i3-20020a056e0212c300b0036b140e0a4cmr463079ilm.3.1715076922615; Tue, 07 May
 2024 03:15:22 -0700 (PDT)
Date: Tue, 07 May 2024 03:15:22 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000bc3c710617da7605@google.com>
Subject: [syzbot] [bcachefs?] WARNING in bch2_fs_usage_read_one
From: syzbot <syzbot+b68fa126ff948672f1fd@syzkaller.appspotmail.com>
To: bfoster@redhat.com, kent.overstreet@linux.dev, 
	linux-bcachefs@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    2b84edefcad1 Add linux-next specific files for 20240506
git tree:       linux-next
console+strace: https://syzkaller.appspot.com/x/log.txt?x=121197df180000
kernel config:  https://syzkaller.appspot.com/x/.config?x=b499929e4aaba1af
dashboard link: https://syzkaller.appspot.com/bug?extid=b68fa126ff948672f1fd
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=155c109f180000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=136e52b8980000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/6a22cf95ee14/disk-2b84edef.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/f5c45b515282/vmlinux-2b84edef.xz
kernel image: https://storage.googleapis.com/syzbot-assets/9bf98258a662/bzImage-2b84edef.xz
mounted in repro #1: https://storage.googleapis.com/syzbot-assets/a691ba218fae/mount_0.gz
mounted in repro #2: https://storage.googleapis.com/syzbot-assets/b4b43602eca5/mount_3.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+b68fa126ff948672f1fd@syzkaller.appspotmail.com

------------[ cut here ]------------
WARNING: CPU: 0 PID: 35 at fs/bcachefs/buckets.c:108 bch2_fs_usage_read_one+0x638/0x6a0 fs/bcachefs/buckets.c:108
Modules linked in:
CPU: 0 PID: 35 Comm: kworker/u8:2 Not tainted 6.9.0-rc7-next-20240506-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 03/27/2024
Workqueue: writeback wb_workfn (flush-bcachefs-1)
RIP: 0010:bch2_fs_usage_read_one+0x638/0x6a0 fs/bcachefs/buckets.c:108
Code: 24 38 49 01 c7 4d 01 fc 4d 01 e5 4c 89 e8 48 81 c4 a0 00 00 00 5b 41 5c 41 5d 41 5e 41 5f 5d c3 cc cc cc cc e8 f9 9a 78 fd 90 <0f> 0b 90 e9 ba fa ff ff 89 d9 80 e1 07 80 c1 03 38 c1 0f 8c 32 fa
RSP: 0018:ffffc90000ab6308 EFLAGS: 00010293
RAX: ffffffff841d7e37 RBX: 0000000000000000 RCX: ffff88801b685a00
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: ffffc90000ab64f0 R08: ffffffff841d78e6 R09: 0000000000000000
R10: ffffc90000ab6440 R11: fffff52000156c8d R12: ffff888075cf8500
R13: dffffc0000000000 R14: ffff88806b180000 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff8880b9400000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fb172fff000 CR3: 0000000079a6e000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 bch2_fs_alloc_debug_to_text+0x181/0x630 fs/bcachefs/alloc_foreground.c:1634
 bch2_print_allocator_stuck+0xc9/0x180 fs/bcachefs/alloc_foreground.c:1657
 __bch2_write+0x5471/0x5c40 fs/bcachefs/io_write.c:1493
 bch2_write+0x947/0x1670 fs/bcachefs/io_write.c:1622
 closure_queue include/linux/closure.h:269 [inline]
 closure_call include/linux/closure.h:402 [inline]
 bch2_writepage_do_io fs/bcachefs/fs-io-buffered.c:460 [inline]
 __bch2_writepage+0x1416/0x2b50 fs/bcachefs/fs-io-buffered.c:607
 write_cache_pages+0xd0/0x230 mm/page-writeback.c:2591
 bch2_writepages+0x14f/0x380 fs/bcachefs/fs-io-buffered.c:650
 do_writepages+0x359/0x870 mm/page-writeback.c:2634
 __writeback_single_inode+0x165/0x10b0 fs/fs-writeback.c:1651
 writeback_sb_inodes+0x99c/0x1380 fs/fs-writeback.c:1947
 __writeback_inodes_wb+0x11b/0x260 fs/fs-writeback.c:2018
 wb_writeback+0x495/0xd40 fs/fs-writeback.c:2129
 wb_check_background_flush fs/fs-writeback.c:2199 [inline]
 wb_do_writeback fs/fs-writeback.c:2287 [inline]
 wb_workfn+0xc58/0x1090 fs/fs-writeback.c:2314
 process_one_work kernel/workqueue.c:3231 [inline]
 process_scheduled_works+0xa2c/0x1830 kernel/workqueue.c:3312
 worker_thread+0x86d/0xd70 kernel/workqueue.c:3393
 kthread+0x2f0/0x390 kernel/kthread.c:389
 ret_from_fork+0x4b/0x80 arch/x86/kernel/process.c:147
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244
 </TASK>


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.

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

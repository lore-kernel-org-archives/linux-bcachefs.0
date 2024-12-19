Received: from mail-il1-f205.google.com (mail-il1-f205.google.com [209.85.166.205])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7941F223304
	for <linux-bcachefs@vger.kernel.org>; Thu, 19 Dec 2024 10:14:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.205
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734603267; cv=none; b=kssDGrGf7hqUALn4YqIRuwSOXjbRNRDW0ytCMMsV5O1Kv8AHAchuH/djX++zcw9gfA7GmXzrsbcSo6Vj6cEQK6vj+45v/T9sfU2GNaO3iuo10+fNHD6Pjqamd38ZVWXqxD0fE3d/Vfr3FvbbRiS0jyuSBS6Mp45FobV7hHoZKcA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734603267; c=relaxed/simple;
	bh=9A7P3OP0ujKJxhAc+ae2yaqIuXJVUhNcxQWayTsFI0g=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=IDKnUc/b5PwcHzM7HeWfH7/+sg8a2PzaNfpwiJzjt8GzZ3po1SljUoTA5OK8y4Sco8Gd+44OR5omhaBXJd3V7W2d7oZGfl38YQk29Iv7I38hBx3BoHhzCvErxK5BSzLM67gYuiqGFNbPW//B8OJdXuJb81eCk++jreVFrrwbLH0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.205
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f205.google.com with SMTP id e9e14a558f8ab-3a9cc5c246bso5339275ab.2
        for <linux-bcachefs@vger.kernel.org>; Thu, 19 Dec 2024 02:14:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734603264; x=1735208064;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Mq6Fwc+H5/qeI3hD3pgUtuis7pE+SoKmahUjZamY6H4=;
        b=KS25OX7kvOZvtn1BxP7v/Krv3S4Ml6P3IL8NBVjpoM3g/orBOTy9z2YkGMwcKX4de8
         QWFKgFk+FCSnIAHRA96PsA9cDQN6GS/kbPFUIbigkRY01IjiDZ6pZZ0OCBBi/Ia5j/Fk
         Lm71Q1oC2W7bg435Hr307+py4USvUMFn6c2iyFNEW2spyKYzOd6+6yTZHwrb+x/AII9C
         7CbMPwAB1lKBgbGl3WYE15LX1HH6Nqjd9XpjAm/qvGO1cVtjotezsbCqwvx1+Eqpcr/0
         zEk7a0vTPgnHeM7AIuVs91IhYoc4mspRg1+9lmfzREvT15zZAw7Oatb7XjO7BFgtBhgB
         yuow==
X-Forwarded-Encrypted: i=1; AJvYcCWi7Z9uPzY8FJoTywFMnwFeSotO0Hs9BravajA90nH3y+dZEHbdY1um6TohZQDgqMQCtVn0IlwYpr+1IQYbgg==@vger.kernel.org
X-Gm-Message-State: AOJu0YzN/aikR7NWm6MVC9NTXXQ1t/gL79RjN32gs872LC0a/XKdHcaO
	G8MXucOh/7NgMxb1HfsJU3VQWlcW7JoPNZwc6etnbDR0hXme2oENhClP9YYqE2hFAc354QVSmu2
	8vHBEFAOZbIcNUSDrjzBFAUycbPjGbN81c8KySEOzuqKLGYrrfBcUMJo=
X-Google-Smtp-Source: AGHT+IFeF68A1bis9r54EUUoRwkuhS17gS4X3R54BtaCd9LOOCv2M78GIEnNep3MHFxLp1VJEq1xwL13fcHzQh+9V1xwlnX2WfLs
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:19c9:b0:3a7:e0c0:5f0d with SMTP id
 e9e14a558f8ab-3bdc0411cbbmr54003235ab.3.1734603264552; Thu, 19 Dec 2024
 02:14:24 -0800 (PST)
Date: Thu, 19 Dec 2024 02:14:24 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6763f200.050a0220.15da49.000d.GAE@google.com>
Subject: [syzbot] [bcachefs?] KMSAN: uninit-value in bch2_dirent_rename (2)
From: syzbot <syzbot+af2db1cea2ed7231e15b@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    a0e3919a2df2 Merge tag 'usb-6.13-rc3' of git://git.kernel...
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=105407e8580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=95d0bb0535bcaca0
dashboard link: https://syzkaller.appspot.com/bug?extid=af2db1cea2ed7231e15b
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/458b3e5de594/disk-a0e3919a.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/35b6151a9024/vmlinux-a0e3919a.xz
kernel image: https://storage.googleapis.com/syzbot-assets/5d6ac5e24841/bzImage-a0e3919a.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+af2db1cea2ed7231e15b@syzkaller.appspotmail.com

bcachefs (loop3): check_allocations... done
bcachefs (loop3): going read-write
bcachefs (loop3): done starting filesystem
=====================================================
BUG: KMSAN: uninit-value in dirent_is_visible fs/bcachefs/dirent.c:88 [inline]
BUG: KMSAN: uninit-value in is_visible_key fs/bcachefs/str_hash.h:148 [inline]
BUG: KMSAN: uninit-value in bch2_hash_lookup_in_snapshot fs/bcachefs/str_hash.h:167 [inline]
BUG: KMSAN: uninit-value in bch2_hash_lookup fs/bcachefs/str_hash.h:195 [inline]
BUG: KMSAN: uninit-value in bch2_dirent_rename+0xa9c/0x5e30 fs/bcachefs/dirent.c:298
 dirent_is_visible fs/bcachefs/dirent.c:88 [inline]
 is_visible_key fs/bcachefs/str_hash.h:148 [inline]
 bch2_hash_lookup_in_snapshot fs/bcachefs/str_hash.h:167 [inline]
 bch2_hash_lookup fs/bcachefs/str_hash.h:195 [inline]
 bch2_dirent_rename+0xa9c/0x5e30 fs/bcachefs/dirent.c:298
 bch2_rename_trans+0xb47/0x26f0 fs/bcachefs/fs-common.c:417
 bch2_rename2+0x1863/0x3600 fs/bcachefs/fs.c:895
 vfs_rename+0x1d9d/0x2280 fs/namei.c:5067
 do_renameat2+0x18d0/0x1d50 fs/namei.c:5224
 __do_sys_rename fs/namei.c:5271 [inline]
 __se_sys_rename fs/namei.c:5269 [inline]
 __x64_sys_rename+0xe8/0x140 fs/namei.c:5269
 x64_sys_call+0x36cb/0x3c30 arch/x86/include/generated/asm/syscalls_64.h:83
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xcd/0x1e0 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Uninit was created at:
 ___kmalloc_large_node+0x22c/0x370 mm/slub.c:4253
 __kmalloc_large_node_noprof+0x3f/0x1e0 mm/slub.c:4270
 __do_kmalloc_node mm/slub.c:4286 [inline]
 __kmalloc_node_noprof+0xc96/0x1250 mm/slub.c:4304
 __kvmalloc_node_noprof+0xc0/0x2d0 mm/util.c:650
 btree_bounce_alloc fs/bcachefs/btree_io.c:124 [inline]
 btree_node_sort+0x78a/0x1d30 fs/bcachefs/btree_io.c:323
 bch2_btree_post_write_cleanup+0x1b0/0xf20 fs/bcachefs/btree_io.c:2248
 bch2_btree_node_prep_for_write+0x494/0x720 fs/bcachefs/btree_trans_commit.c:93
 bch2_trans_lock_write+0x7ef/0xc00 fs/bcachefs/btree_trans_commit.c:129
 do_bch2_trans_commit fs/bcachefs/btree_trans_commit.c:896 [inline]
 __bch2_trans_commit+0x31c4/0xd190 fs/bcachefs/btree_trans_commit.c:1121
 bch2_trans_commit fs/bcachefs/btree_update.h:184 [inline]
 __bch2_create+0xfd8/0x1700 fs/bcachefs/fs.c:540
 bch2_mknod fs/bcachefs/fs.c:673 [inline]
 bch2_create+0xc0/0x1d0 fs/bcachefs/fs.c:687
 lookup_open fs/namei.c:3649 [inline]
 open_last_lookups fs/namei.c:3748 [inline]
 path_openat+0x2e9e/0x6200 fs/namei.c:3984
 do_filp_open+0x268/0x600 fs/namei.c:4014
 do_sys_openat2+0x1bf/0x2f0 fs/open.c:1402
 do_sys_open fs/open.c:1417 [inline]
 __do_sys_creat fs/open.c:1495 [inline]
 __se_sys_creat fs/open.c:1489 [inline]
 __x64_sys_creat+0xe6/0x140 fs/open.c:1489
 x64_sys_call+0x12e3/0x3c30 arch/x86/include/generated/asm/syscalls_64.h:86
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xcd/0x1e0 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

CPU: 0 UID: 0 PID: 25892 Comm: syz.3.5499 Not tainted 6.13.0-rc2-syzkaller-00333-ga0e3919a2df2 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 11/25/2024
=====================================================


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

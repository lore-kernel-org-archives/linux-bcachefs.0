Received: from mail-il1-f200.google.com (mail-il1-f200.google.com [209.85.166.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0948170A3D
	for <linux-bcachefs@vger.kernel.org>; Mon, 21 Oct 2024 23:24:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729553072; cv=none; b=i+/NQDXJ6HGJzhseJIpgOPUzC1RvXj6kVb5a0Iu281LWFZG5n6ZvgwSSh3Ztbd/MBV1hRzUQC2BOci0ZnCuA8HwPtS/XBgpPotF+1L3FeGm2HZ2SlBaBUqh4pSyHk0FrR+PjfHMkVtIyJP1byCkvXCvIvLuXkYpdDZfUwQukXeM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729553072; c=relaxed/simple;
	bh=nWte0rIwsiPYg/2z1oNJxZphdrJMIOoYTnZRr/jmGN4=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=magTpOyECAjX2BxKIFD2EOBz0vbX5w9gf7Sz7pkPMUd60XfK39aCUXc7/fdvM2TYN3vfrP99kfdl39b4+g7ylgekpeIcL9KlvRWulRDbCYjMxJ8a9qq7wcSaTAYCOGHjzL5l/XfSoa4DXU0UX8jU1+6tpzp5QODIBzHT3SwkPI4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f200.google.com with SMTP id e9e14a558f8ab-3a3da2d46b9so39868705ab.0
        for <linux-bcachefs@vger.kernel.org>; Mon, 21 Oct 2024 16:24:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729553070; x=1730157870;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=5EtVU8wF8I3uPj7jrX2LycPFXepNNMWXE8z8NE4TEZg=;
        b=JSHk3LmfFik7paj3zsqxRfnkaruRNzOU58DC0yOw7FQE2y0Bt6TJ1/EJQMQx47xV+1
         bckAbOG4kIjvfX9blExXpHXgRJ/yuZ5Di+6zT05UgFwtADVoPq4k/0mjb4jJIK935TBb
         WRGr/EcbKQcaU7zU1D8WyHEfGfnqBla4rH+yJGZwQNV+NlffHqrPHWBIdeVbETCHpbna
         3NZEQ9SN2qhzDC6+oi1/fjb/hsnivHuoKaVX8WichBDjepO6IEStjA6cH76ZSKudLy5/
         Z4TJHGQKvlVB1tTHyZ2IDm+PmDoPNYPy8l4X58IqmGsmzWXBSiDo0Moju1K4q4hDw86o
         9XIw==
X-Forwarded-Encrypted: i=1; AJvYcCXa9TPEKNTKFh3eH7GqGVm2DFn6WctuqZ9oBeBtCrTSSZRtHg1H13OqlNoidO6ewvC5XVcZ9MQp9s44NBi4PA==@vger.kernel.org
X-Gm-Message-State: AOJu0YzTj32tYgboJtrtkQJFofCIr5oao+tROPBLpOK1lLVcFqhQ7wCi
	pmjbo+bH7AYmtI++ARzSdgF7ggIevRYnQrK8lb3yfiIiSAac27J+SqoY3zICasW/xMBt7NLyzWL
	bc865RtAlOfx33KIOE1Y0GZA4T63xAXiC+QqXAfAtj+6ai0WTA1AS76Y=
X-Google-Smtp-Source: AGHT+IH5r39cG8ivF0vBaX5o682H9BVhpiUSpBAdGGy8OTrMavIihYbVjg6x1sdPJ+GReOMYRJ/5MqkiSjVet1pP0XbADjiwmu4Z
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:3c08:b0:3a0:8d2f:2914 with SMTP id
 e9e14a558f8ab-3a3f40b73camr118342365ab.23.1729553068253; Mon, 21 Oct 2024
 16:24:28 -0700 (PDT)
Date: Mon, 21 Oct 2024 16:24:28 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6716e2ac.050a0220.1e4b4d.0064.GAE@google.com>
Subject: [syzbot] [bcachefs?] WARNING: locking bug in rcu_pending_exit
From: syzbot <syzbot+8d7226784b8fcb4c9d04@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    6efbea77b390 Merge tag 'arm64-fixes' of git://git.kernel.o..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=14689830580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=164d2822debd8b0d
dashboard link: https://syzkaller.appspot.com/bug?extid=8d7226784b8fcb4c9d04
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/5dbbf0b1a9a5/disk-6efbea77.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/fd272a84cc09/vmlinux-6efbea77.xz
kernel image: https://storage.googleapis.com/syzbot-assets/cfcfcf079289/bzImage-6efbea77.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+8d7226784b8fcb4c9d04@syzkaller.appspotmail.com

------------[ cut here ]------------
Looking for class "ock" with key rcu_pending_init.__key, but found a different class "&p->lock" with the same key
WARNING: CPU: 0 PID: 9466 at kernel/locking/lockdep.c:939 look_up_lock_class+0xdc/0x170 kernel/locking/lockdep.c:936
Modules linked in:
CPU: 0 UID: 0 PID: 9466 Comm: syz.3.337 Not tainted 6.12.0-rc3-syzkaller-00183-g6efbea77b390 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 09/13/2024
RIP: 0010:look_up_lock_class+0xdc/0x170 kernel/locking/lockdep.c:936
Code: 01 0f 85 8a 00 00 00 c6 05 6c c9 47 04 01 90 49 8b 16 49 8b 76 18 48 8b 8b b8 00 00 00 48 c7 c7 c0 eb 0a 8c e8 25 14 98 f5 90 <0f> 0b 90 90 eb 61 90 e8 78 e2 f2 f8 e8 f3 50 b7 f5 48 c7 c7 00 eb
RSP: 0000:ffffc90004a4f370 EFLAGS: 00010046
RAX: 7709172c58e83300 RBX: ffffffff93c6f5f8 RCX: 0000000000040000
RDX: ffffc9000e182000 RSI: 000000000003ffff RDI: 0000000000040000
RBP: ffffc90004a4f480 R08: ffffffff8155e322 R09: 1ffff110170c519a
R10: dffffc0000000000 R11: ffffed10170c519b R12: ffffe8ffffd35a68
R13: ffffe8ffffd35a68 R14: ffffe8ffffd35a68 R15: ffffffff9a53f580
FS:  00007fed5bab66c0(0000) GS:ffff8880b8600000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fa687e0f000 CR3: 000000006ba2a000 CR4: 00000000003526f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 register_lock_class+0x102/0x980 kernel/locking/lockdep.c:1290
 __lock_acquire+0xf0/0x2050 kernel/locking/lockdep.c:5077
 lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5825
 __raw_spin_lock_irq include/linux/spinlock_api_smp.h:119 [inline]
 _raw_spin_lock_irq+0xd3/0x120 kernel/locking/spinlock.c:170
 spin_lock_irq include/linux/spinlock.h:376 [inline]
 rcu_pending_has_pending_or_armed fs/bcachefs/rcu_pending.c:576 [inline]
 rcu_pending_exit+0x13f/0x7a0 fs/bcachefs/rcu_pending.c:594
 bch2_fs_btree_key_cache_exit+0x97f/0xab0 fs/bcachefs/btree_key_cache.c:741
 __bch2_fs_free fs/bcachefs/super.c:555 [inline]
 bch2_fs_release+0x206/0x7d0 fs/bcachefs/super.c:610
 kobject_cleanup lib/kobject.c:689 [inline]
 kobject_release lib/kobject.c:720 [inline]
 kref_put include/linux/kref.h:65 [inline]
 kobject_put+0x22f/0x480 lib/kobject.c:737
 bch2_fs_get_tree+0xd9f/0x1710 fs/bcachefs/fs.c:2269
 vfs_get_tree+0x90/0x2b0 fs/super.c:1800
 do_new_mount+0x2be/0xb40 fs/namespace.c:3507
 do_mount fs/namespace.c:3847 [inline]
 __do_sys_mount fs/namespace.c:4055 [inline]
 __se_sys_mount+0x2d6/0x3c0 fs/namespace.c:4032
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fed5ad7f79a
Code: d8 64 89 02 48 c7 c0 ff ff ff ff eb a6 e8 de 1a 00 00 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fed5bab5e68 EFLAGS: 00000246 ORIG_RAX: 00000000000000a5
RAX: ffffffffffffffda RBX: 00007fed5bab5ef0 RCX: 00007fed5ad7f79a
RDX: 00000000200000c0 RSI: 0000000020000000 RDI: 00007fed5bab5eb0
RBP: 00000000200000c0 R08: 00007fed5bab5ef0 R09: 0000000000800000
R10: 0000000000800000 R11: 0000000000000246 R12: 0000000020000000
R13: 00007fed5bab5eb0 R14: 0000000000005903 R15: 0000000020000480
 </TASK>


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

Received: from mail-io1-f71.google.com (mail-io1-f71.google.com [209.85.166.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA6F6D528
	for <linux-bcachefs@vger.kernel.org>; Thu,  9 May 2024 08:04:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715241872; cv=none; b=tPZqyFxM/cqcz8Z62m2F7ESQyUqBSHpzWl6eII4+JpBxhp2I6SaVxqbt9kJckivFA2PlTlj12a1wSUuLbDIUN9QxYexZNlep/uC/aExrD9PfKBn5XasocJ3AknbsB1d13XUXC0rAxFarywql1SbNhBRfT5l3MhT7W/B/9nU2Y/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715241872; c=relaxed/simple;
	bh=AOAGAwHKkno5a95ONp8pj3QT+1lZ+pzzTkKRt1yTzM0=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=sdoHISIZHospO+3x7eD4V2+hB3iOQu8OCcL/J0LAq4Sly087tbkjSOKg5CRkQHaib9SPaQenRp6dRFsb4KXzZr14Xy9/PayKfCkkxnz6kpC93y2dKt2EWw4d8UHFbO3FQLXNKcR9kRX5m5i4a0uy1oAK5Xv7shs2fjdfSW9aAqw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f71.google.com with SMTP id ca18e2360f4ac-7da41da873bso72696739f.3
        for <linux-bcachefs@vger.kernel.org>; Thu, 09 May 2024 01:04:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715241870; x=1715846670;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=FKNzW6w0GewPH7g4yc3G6iWNlN/MKnU/QLnxdRBlVl4=;
        b=UvqSu6HscO962JCvaFy+icDIfJbkXpWzeGoCn556DUoExu86ryuHkHqepOxMLVrLZy
         7PfpKDXPuuIvOTWxCZ/O7HwQIVaZo67xSDEFKTWyNvh/T4Az4Uh6/bizJILeW+0byWGJ
         cM01ngtUFv2hmYm/0TqwUgZswOX/xsEZY5TKY+sAPHDQZU6dcRW4Lvc8/AdIOREx7JwT
         noWOIvf+TGClr43QZPAVItMo9rN+y3RI8YvUKsWs3GsJQwStbqLfjZcmENYcImlhTHo7
         /JMRvqVLLsq63eFDhAPSKp9PAt3YON9rMxblYkfRr/J51xFAombZXK4CIWpsw/p6i5aH
         npOQ==
X-Forwarded-Encrypted: i=1; AJvYcCUj6/Ghwi65UKdbk0FSNK9bgVLotvYXkZ6c+ghuJpo0y++m5i5/pCrqyThO5OZVpCy16TCGCUJUVsTC+ib0+BHdCEki2kIXnJjGuwVA5+8=
X-Gm-Message-State: AOJu0YwUu3mMLZfoKMM3rbTz8vTHgGVT+Q3zJgehdaHdM81A6qFEeUXe
	c0CXiB5AIGu2/K9aONEzMwoZwINuZ9PdsKEUSIJIxstN6yfjXqzf8++f5HM1HKDciAWfBNliTo1
	lAVVzEidJNCE/wjpEesOyJwKVk8P+4j1Uqja4+anWkLV41Z+fE0tojXw=
X-Google-Smtp-Source: AGHT+IHKGgxbY5fqxkbP30isurw6G9OrQUxxEknM75ilSFKZGVSWSIHomwUVfIAw9zBTFFHJ/oakdb4R3yl5nBX9hcKPw2IGKlvo
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6638:1610:b0:488:e34a:5f72 with SMTP id
 8926c6da1cb9f-488fd6f24eamr324837173.2.1715241870232; Thu, 09 May 2024
 01:04:30 -0700 (PDT)
Date: Thu, 09 May 2024 01:04:30 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000611ffc061800de0d@google.com>
Subject: [syzbot] [bcachefs?] kernel BUG in __journal_res_get
From: syzbot <syzbot+c60cd352aedb109528bf@syzkaller.appspotmail.com>
To: bfoster@redhat.com, kent.overstreet@linux.dev, 
	linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    1c9135d29e9e Merge branch 'for-next/core' into for-kernelci
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git for-kernelci
console output: https://syzkaller.appspot.com/x/log.txt?x=112d6eb8980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=7d2d53e64c7e6a4f
dashboard link: https://syzkaller.appspot.com/bug?extid=c60cd352aedb109528bf
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
userspace arch: arm64
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=120c63bc980000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1360afff180000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/52dd1b4921ab/disk-1c9135d2.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/1a4f1788dc25/vmlinux-1c9135d2.xz
kernel image: https://storage.googleapis.com/syzbot-assets/b8d8ebd42a80/Image-1c9135d2.gz.xz
mounted in repro #1: https://storage.googleapis.com/syzbot-assets/4034fbab270b/mount_0.gz
mounted in repro #2: https://storage.googleapis.com/syzbot-assets/fb9b707711cf/mount_1.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+c60cd352aedb109528bf@syzkaller.appspotmail.com

  bp_start          7, fixing
bcachefs (loop0): alloc_read... done
bcachefs (loop0): stripes_read... done
bcachefs (loop0): snapshots_read... done
------------[ cut here ]------------
kernel BUG at fs/bcachefs/journal.c:370!
Internal error: Oops - BUG: 00000000f2000800 [#1] PREEMPT SMP
Modules linked in:
CPU: 0 PID: 6237 Comm: syz-executor338 Not tainted 6.9.0-rc7-syzkaller-g1c9135d29e9e #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 03/27/2024
pstate: 80400005 (Nzcv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
pc : journal_entry_open fs/bcachefs/journal.c:370 [inline]
pc : __journal_res_get+0x1d64/0x1f6c fs/bcachefs/journal.c:555
lr : journal_entry_open fs/bcachefs/journal.c:370 [inline]
lr : __journal_res_get+0x1d64/0x1f6c fs/bcachefs/journal.c:555
sp : ffff80009c676980
x29: ffff80009c676be0 x28: ffff80009c676b20 x27: 00000000003ffffe
x26: ffff0000dcdca7c0 x25: ffff0000dcd80870 x24: ffff0000dcdca7b8
x23: dfff800000000000 x22: 1fffe0001b9b94d5 x21: 0111110080100107
x20: 1fffe0001b9b9430 x19: ffff0000dcdca180 x18: ffff80009c676880
x17: 000000000000caa6 x16: ffff800080331e9c x15: 0000000000000001
x14: 1fffe0001b9b94f7 x13: 0000000000000000 x12: 0000000000000000
x11: ffff60001b9b94f8 x10: 0000000000ff0100 x9 : 0000000000000000
x8 : ffff0000d0f6bc80 x7 : ffff8000828e150c x6 : 0000000000000000
x5 : 0000000000000000 x4 : 0000000000000001 x3 : ffff8000828e163c
x2 : 0000000000000000 x1 : 0000000000000002 x0 : 0000000000000000
Call trace:
 journal_entry_open fs/bcachefs/journal.c:370 [inline]
 __journal_res_get+0x1d64/0x1f6c fs/bcachefs/journal.c:555
 bch2_journal_res_get_slowpath+0x9c/0x2a4 fs/bcachefs/journal.c:617
 bch2_journal_res_get+0x124/0x1b4 fs/bcachefs/journal.h:382
 bch2_journal_meta+0x9c/0x268 fs/bcachefs/journal.c:832
 bch2_fs_recovery+0x2f4c/0x4854 fs/bcachefs/recovery.c:798
 bch2_fs_start+0x30c/0x53c fs/bcachefs/super.c:1043
 bch2_fs_open+0x8b4/0xb64 fs/bcachefs/super.c:2102
 bch2_mount+0x558/0xe10 fs/bcachefs/fs.c:1903
 legacy_get_tree+0xd4/0x16c fs/fs_context.c:662
 vfs_get_tree+0x90/0x288 fs/super.c:1779
 do_new_mount+0x278/0x900 fs/namespace.c:3352
 path_mount+0x590/0xe04 fs/namespace.c:3679
 do_mount fs/namespace.c:3692 [inline]
 __do_sys_mount fs/namespace.c:3898 [inline]
 __se_sys_mount fs/namespace.c:3875 [inline]
 __arm64_sys_mount+0x45c/0x594 fs/namespace.c:3875
 __invoke_syscall arch/arm64/kernel/syscall.c:34 [inline]
 invoke_syscall+0x98/0x2b8 arch/arm64/kernel/syscall.c:48
 el0_svc_common+0x130/0x23c arch/arm64/kernel/syscall.c:133
 do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:152
 el0_svc+0x54/0x168 arch/arm64/kernel/entry-common.c:712
 el0t_64_sync_handler+0x84/0xfc arch/arm64/kernel/entry-common.c:730
 el0t_64_sync+0x190/0x194 arch/arm64/kernel/entry.S:598
Code: 17ffff9c 9771bacd d4210000 9771bacb (d4210000) 
---[ end trace 0000000000000000 ]---


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

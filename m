Received: from mail-io1-f70.google.com (mail-io1-f70.google.com [209.85.166.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 466A8233D6B
	for <linux-bcachefs@vger.kernel.org>; Sat,  9 Nov 2024 15:43:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731167012; cv=none; b=GQ0Oh5TR5GcCwi+OQALXZCdg+5BnACRV28EWIEr6dBTqpPWFkG2DcLBeP5wvxotpikIAHACrrKbkz++p6BKAaJiEMlTvOEjkfLRNxujy6yDwddyVjCUBR953bxpCvQWHbqODcIauMmjF/+zTVLUOGI9OEgIn1W38dhOKo3e0mLA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731167012; c=relaxed/simple;
	bh=1tf54VEjItzPAjtELjSSi5kTvx1ne2UDY16WbcOufM8=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=T38dHpOUGbTEQGLUzWTs0AZzZZH9tte2Msn0+RDMPO7qDL6/Qf1X4NtfktjlzO0s/lRjDxTyp+KM30+7o4mZWc1NzAVputRw6sAFgRusV1VRTOon4oz/eXQMSXh/+A9jpdVBFdwpF0TmyLGXk+9K+oaONIoKwBpGZ3F7M1mMQRs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f70.google.com with SMTP id ca18e2360f4ac-83ab369a523so347692239f.3
        for <linux-bcachefs@vger.kernel.org>; Sat, 09 Nov 2024 07:43:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731167010; x=1731771810;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=GseIcgIr6X/8m67ZFLgAx9zFE4QGPHGtQSWIAD46AMY=;
        b=qMZHZ8Xdj7ZKAKtFypcuQ1N/agstMuVTGauc3z9G/p8fAwy5/e6CFSIYl6kgIdRDZQ
         KFbUBebndXB2tKv+fZ/JkGfZulbAps/ukOZvt5hN9qOgo9DxsR+SkGugefz/Ycr22Q7q
         bT4Q0LV1CvhanqAsGw6iFtz8WPiY9oCy8OgjndwuppG95K2n8tf2aTIxsrGvpu71uLkO
         BaYtTjUOm6TJoomiDpj/tQfaCMa7NrrF4dt81xsRkWyD0/2ggAR7c1cqh/DO2jp0IW9p
         yLRorniP+4kmVJPkSTc43J852a6Kzgud1DxA9eKA7k6nXbzvBmUtJMpr5gfRm/UmGVUE
         k1zQ==
X-Forwarded-Encrypted: i=1; AJvYcCVx5LTfzdfdotVfE94RE6n4VsDPENnDE/56qBlwUVBrDGEsm5gC/EIKjpJCO8qbahV1th55JFp7+Iy0x1ZdAw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yx8QempA5Oht3KtrtpStU42rQqtw+sRuFeD/iQHBpiCtIEu5IeG
	ldngTdASzeqS07fdrScFHmU4sOnezwMeAHtq80MbkyP3O5kvNdW5XxrVmjb6GVTC/kpzrx3DWLk
	bw/1SKSLNUhQOJLLweRkOKuSXfMB64llQbAzWJbbGoj5pHVnXjlhLNlo=
X-Google-Smtp-Source: AGHT+IHQx13L5JlX4aNY1LnhMf25cy0+Zv2fe1fZJ3rOjqe9fIzLX+jsYaXgUwLOZB/arcRZl47pCI8sCzq0EPVC8kK2GW59dXOQ
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1745:b0:3a0:480c:6ac4 with SMTP id
 e9e14a558f8ab-3a6f1a481b3mr65185515ab.22.1731167010493; Sat, 09 Nov 2024
 07:43:30 -0800 (PST)
Date: Sat, 09 Nov 2024 07:43:30 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <672f8322.050a0220.320e73.0316.GAE@google.com>
Subject: [syzbot] [bcachefs?] kernel BUG in __bch2_btree_node_hash_insert
From: syzbot <syzbot+19c1a30221401d741bc2@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com, 
	terrelln@fb.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    850f22c42f4b Add linux-next specific files for 20241105
git tree:       linux-next
console+strace: https://syzkaller.appspot.com/x/log.txt?x=16d656a7980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=20c0926a86d94a8
dashboard link: https://syzkaller.appspot.com/bug?extid=19c1a30221401d741bc2
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=10198e30580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=12fdb587980000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/2f4977b60e81/disk-850f22c4.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/5574d3bf40f3/vmlinux-850f22c4.xz
kernel image: https://storage.googleapis.com/syzbot-assets/013dbea598ca/bzImage-850f22c4.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/442d7ae00d08/mount_0.gz

The issue was bisected to:

commit bf4baaa087e2be0279991f1dbf9acaa7a4c9148c
Author: Kent Overstreet <kent.overstreet@linux.dev>
Date:   Sat Oct 5 21:37:02 2024 +0000

    bcachefs: Fix lockdep splat in bch2_accounting_read

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=122c36a7980000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=112c36a7980000
console output: https://syzkaller.appspot.com/x/log.txt?x=162c36a7980000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+19c1a30221401d741bc2@syzkaller.appspotmail.com
Fixes: bf4baaa087e2 ("bcachefs: Fix lockdep splat in bch2_accounting_read")

  parent: u64s 5 type btree_ptr SPOS_MAX len 0 ver 0
  child: u64s 11 type btree_ptr_v2 U64_MAX:18374686479671623680:50331647 len 0 ver 0: seq 2285c34bed0abe32 written 16 min_key POS_MIN durability: 1 ptr: 0:31:0 gen 0, fixing
bcachefs (loop0): bch2_get_scanned_nodes(): recovery btree=xattrs level=0 U64_MAX:18374686479671623680:50331648 - SPOS_MAX
bcachefs (loop0): set_node_max(): u64s 11 type btree_ptr_v2 U64_MAX:18374686479671623680:50331647 len 0 ver 0: seq 2285c34bed0abe32 written 16 min_key POS_MIN durability: 1 ptr: 0:31:0 gen 0 -> SPOS_MAX
------------[ cut here ]------------
kernel BUG at fs/bcachefs/btree_cache.c:280!
Oops: invalid opcode: 0000 [#1] PREEMPT SMP KASAN PTI
CPU: 1 UID: 0 PID: 5854 Comm: syz-executor700 Not tainted 6.12.0-rc6-next-20241105-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 09/13/2024
RIP: 0010:__bch2_btree_node_hash_insert+0x12ed/0x1310 fs/bcachefs/btree_cache.c:280
Code: f6 fd e9 9d f5 ff ff 89 d9 80 e1 07 80 c1 03 38 c1 0f 8c f2 f7 ff ff 48 89 df e8 2e d5 f6 fd e9 e5 f7 ff ff e8 04 74 8c fd 90 <0f> 0b e8 fc 73 8c fd 90 0f 0b e8 f4 73 8c fd 90 0f 0b e8 1c 6c bc
RSP: 0018:ffffc90003d36640 EFLAGS: 00010293
RAX: ffffffff840963bc RBX: ffff8880282a0228 RCX: ffff888034390000
RDX: 0000000000000000 RSI: ffff8880282a0000 RDI: ffff888075b81a90
RBP: ffffc90003d36770 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 000000000001f001 R12: 1ffff11005054045
R13: dffffc0000000000 R14: ffff888075b81a90 R15: ffff8880282a0000
FS:  0000555559c71380(0000) GS:ffff8880b8700000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000055792096e558 CR3: 00000000758cc000 CR4: 00000000003526f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 set_node_max+0x542/0x710 fs/bcachefs/btree_gc.c:188
 btree_repair_node_end fs/bcachefs/btree_gc.c:301 [inline]
 bch2_btree_repair_topology_recurse+0x5a7c/0x6c10 fs/bcachefs/btree_gc.c:427
 bch2_check_topology+0x6d4/0xba0 fs/bcachefs/btree_gc.c:554
 bch2_run_recovery_pass+0xf0/0x1e0 fs/bcachefs/recovery_passes.c:216
 bch2_run_recovery_passes+0x290/0x9f0 fs/bcachefs/recovery_passes.c:286
 bch2_fs_recovery+0x25cc/0x39b0 fs/bcachefs/recovery.c:893
 bch2_fs_start+0x37c/0x610 fs/bcachefs/super.c:1037
 bch2_fs_get_tree+0xd68/0x1710 fs/bcachefs/fs.c:2186
 vfs_get_tree+0x90/0x2b0 fs/super.c:1814
 do_new_mount+0x2be/0xb40 fs/namespace.c:3507
 do_mount fs/namespace.c:3847 [inline]
 __do_sys_mount fs/namespace.c:4057 [inline]
 __se_sys_mount+0x2d6/0x3c0 fs/namespace.c:4034
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fa63b34497a
Code: d8 64 89 02 48 c7 c0 ff ff ff ff eb a6 e8 5e 04 00 00 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fff4e112dd8 EFLAGS: 00000282 ORIG_RAX: 00000000000000a5
RAX: ffffffffffffffda RBX: 00007fff4e112df0 RCX: 00007fa63b34497a
RDX: 0000000020000180 RSI: 0000000020000000 RDI: 00007fff4e112df0
RBP: 0000000000000004 R08: 00007fff4e112e30 R09: 00000000000059b6
R10: 0000000000800008 R11: 0000000000000282 R12: 0000000000800008
R13: 00007fff4e112e30 R14: 0000000000000003 R15: 0000000001000000
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:__bch2_btree_node_hash_insert+0x12ed/0x1310 fs/bcachefs/btree_cache.c:280
Code: f6 fd e9 9d f5 ff ff 89 d9 80 e1 07 80 c1 03 38 c1 0f 8c f2 f7 ff ff 48 89 df e8 2e d5 f6 fd e9 e5 f7 ff ff e8 04 74 8c fd 90 <0f> 0b e8 fc 73 8c fd 90 0f 0b e8 f4 73 8c fd 90 0f 0b e8 1c 6c bc
RSP: 0018:ffffc90003d36640 EFLAGS: 00010293
RAX: ffffffff840963bc RBX: ffff8880282a0228 RCX: ffff888034390000
RDX: 0000000000000000 RSI: ffff8880282a0000 RDI: ffff888075b81a90
RBP: ffffc90003d36770 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 000000000001f001 R12: 1ffff11005054045
R13: dffffc0000000000 R14: ffff888075b81a90 R15: ffff8880282a0000
FS:  0000555559c71380(0000) GS:ffff8880b8700000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000055792096e558 CR3: 00000000758cc000 CR4: 00000000003526f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400


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

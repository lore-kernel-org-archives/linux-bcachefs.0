Received: from mail-io1-f77.google.com (mail-io1-f77.google.com [209.85.166.77])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C18913A271
	for <linux-bcachefs@vger.kernel.org>; Tue, 14 May 2024 10:38:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.77
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715683109; cv=none; b=sv0xoeudnzGgMZVgvi40erL9f7ngNzeQDQ14CzG24W7f2SgIsr/OTWm1CSIxM3HOqXylj/6rebUT+jms+DT87DXXQWWNwdvP4I8BVFQvjSFLZivh/vVfdQgTTxF9E78KwJYQvpWmeYblwKBnaX6d+RZaK9J5JASFVZRNyiDwMKQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715683109; c=relaxed/simple;
	bh=h8Q92DdaiairHNOkDqw++E0u5GkNT2R2/9tsFBAFDUY=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=Hw3iDYDyPBXDs6TmilvXA4cuamO7nUwUGpodohIwL2Rk18GI72aY9rn1DGrMpzYr+chTHYaLpBMDSbz5+vPsbOOz1yL29FkYw8M+mOLUS4z1+QMlvsDgj2hZDRq3VVdGNaL8lnb3sGrIKEd1JQG7XwSAv9irYb+Rf0mthaGbdu8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.77
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f77.google.com with SMTP id ca18e2360f4ac-7e1fb54d1e5so44368839f.0
        for <linux-bcachefs@vger.kernel.org>; Tue, 14 May 2024 03:38:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715683107; x=1716287907;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=fliv4DnuliadWO8SZntjxBjMS1vRXtFssXEpMtEUoEQ=;
        b=CbAsn3MRGt3XHciiAeU+j8P7j9TH59gAQva1bLYbac+PI/lQckB5Drj7N08EON779Z
         59M55Plzr/dcfx0lhL0sUOkcynU4gw4vQOmTO9eItz4A1ZG+q52njRPgJC6gXVf4SyUT
         0w79f2mmMuzgN4sHwYlqo6Ao6ePh2lhBOkUgbIvm0FAPq6V6zX2uF3ukgVY2cAzoUgyd
         T3KI3QHJar4wkEXFnIUyKsuJAjt27YTznVE0iwbroH51gXRXQxYuiUFcFjDXHw0/WVjO
         QiGzdFLHfldjZl5HuKzTUfj1JGWiC76aCeAvAu8CyDQXzunJVeoQA1X+KC3I8U3nL5nX
         Zv8Q==
X-Forwarded-Encrypted: i=1; AJvYcCWFfMItFsvH03qU2YBhDywWrojF2qPBg5wLgz9Bw3jJRifC9/bHg1GQBLkrd/1ZoTcrvJ0sByTozgtqmV2Cnrfx8yy1FQtGC2dMeR+14To=
X-Gm-Message-State: AOJu0Yy/TytE9Hq2yoRoX5yFAxvI/EmDpFBKUkZPAFOMvDy3Zm4I/KQ/
	Rk55jlTorkV36T5cT+GGwe0qRVeeBx7bM+CNrAioH23hPiO6lokpfI3hDy089K2KchFJbCxraUd
	/mlmx9Q9NE+D1aKD6+zD6Geiax0Rykmy4bGkZ4ZPLp7xRcu1HxTgXfiQ=
X-Google-Smtp-Source: AGHT+IFYOUdkrDe9zm3kRHVzey7vDY72H0L+kGhOj6DXemTKxw6+QAeS0LR2Z7xB8kxmUfepGX+mWPsqusixguR3ssQfNHh03W0l
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6602:27ca:b0:7cc:cc9:4332 with SMTP id
 ca18e2360f4ac-7e1b521fc11mr61703739f.4.1715683107680; Tue, 14 May 2024
 03:38:27 -0700 (PDT)
Date: Tue, 14 May 2024 03:38:27 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000002e433b0618679a5e@google.com>
Subject: [syzbot] [bcachefs?] kernel BUG in bch2_checksum
From: syzbot <syzbot+e951ad5349f3a34a715a@syzkaller.appspotmail.com>
To: bfoster@redhat.com, kent.overstreet@linux.dev, 
	linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    75fa778d74b7 Add linux-next specific files for 20240510
git tree:       linux-next
console+strace: https://syzkaller.appspot.com/x/log.txt?x=10a7705c980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=ccdd3ebd6715749a
dashboard link: https://syzkaller.appspot.com/bug?extid=e951ad5349f3a34a715a
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=169cb8d0980000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=12ea5c5c980000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/ad9391835bcf/disk-75fa778d.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/d827b3da9a26/vmlinux-75fa778d.xz
kernel image: https://storage.googleapis.com/syzbot-assets/8f32f0182388/bzImage-75fa778d.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/a1fc97fcc95e/mount_0.gz

The issue was bisected to:

commit f7643bc9749f270d487c32dc35b578575bf1adb0
Author: Kent Overstreet <kent.overstreet@linux.dev>
Date:   Wed Apr 17 05:26:02 2024 +0000

    bcachefs: make btree read errors silent during scan

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=122e3084980000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=112e3084980000
console output: https://syzkaller.appspot.com/x/log.txt?x=162e3084980000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+e951ad5349f3a34a715a@syzkaller.appspotmail.com
Fixes: f7643bc9749f ("bcachefs: make btree read errors silent during scan")

loop0: detected capacity change from 0 to 32768
bcachefs (loop0): mounting version 1.7: mi_btree_bitmap opts=metadata_checksum=none,data_checksum=xxhash,compression=zstd,nojournal_transaction_names
bcachefs (loop0): recovering from clean shutdown, journal seq 10
------------[ cut here ]------------
kernel BUG at fs/bcachefs/checksum.c:236!
Oops: invalid opcode: 0000 [#1] PREEMPT SMP KASAN PTI
CPU: 1 PID: 5095 Comm: syz-executor222 Not tainted 6.9.0-rc7-next-20240510-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 04/02/2024
RIP: 0010:bch2_checksum+0x717/0x730 fs/bcachefs/checksum.c:236
Code: ff ff 89 d9 80 e1 07 80 c1 03 38 c1 0f 8c 0a fe ff ff 48 89 df e8 19 0b dc fd e9 fd fd ff ff e8 1f b4 6a 07 e8 9a 52 76 fd 90 <0f> 0b e8 92 52 76 fd 90 0f 0b e8 8a 52 76 fd 90 0f 0b 0f 1f 80 00
RSP: 0018:ffffc9000368e340 EFLAGS: 00010293
RAX: ffffffff841fc9e6 RBX: 20000004b5d608e4 RCX: ffff888027f9da00
RDX: 0000000000000000 RSI: ffffffff8e92a440 RDI: 000000000000000f
RBP: ffffc9000368e6b0 R08: 0000000000000005 R09: ffffffff841fc3aa
R10: 0000000000000008 R11: ffff888027f9da00 R12: ffffc9000368e3e0
R13: dffffc0000000000 R14: 000000000000000f R15: 1ffff920006d1c70
FS:  00005555916b4380(0000) GS:ffff8880b9500000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007ffd20783dd4 CR3: 00000000799da000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 bch2_btree_node_read_done+0x13d4/0x6770 fs/bcachefs/btree_io.c:1110
 btree_node_read_work+0x68b/0x1260 fs/bcachefs/btree_io.c:1340
 bch2_btree_node_read+0x2467/0x2a40
 __bch2_btree_root_read fs/bcachefs/btree_io.c:1764 [inline]
 bch2_btree_root_read+0x61e/0x970 fs/bcachefs/btree_io.c:1788
 read_btree_roots+0x22d/0x7b0 fs/bcachefs/recovery.c:472
 bch2_fs_recovery+0x2346/0x3700 fs/bcachefs/recovery.c:800
 bch2_fs_start+0x356/0x5b0 fs/bcachefs/super.c:1031
 bch2_fs_open+0xa8d/0xdf0 fs/bcachefs/super.c:2123
 bch2_mount+0x71d/0x1320 fs/bcachefs/fs.c:1917
 legacy_get_tree+0xee/0x190 fs/fs_context.c:662
 vfs_get_tree+0x90/0x2a0 fs/super.c:1780
 do_new_mount+0x2be/0xb40 fs/namespace.c:3352
 do_mount fs/namespace.c:3692 [inline]
 __do_sys_mount fs/namespace.c:3898 [inline]
 __se_sys_mount+0x2d9/0x3c0 fs/namespace.c:3875
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf5/0x240 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f31632de93a
Code: d8 64 89 02 48 c7 c0 ff ff ff ff eb a6 e8 5e 04 00 00 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffdd671fda8 EFLAGS: 00000282 ORIG_RAX: 00000000000000a5
RAX: ffffffffffffffda RBX: 00007ffdd671fdc0 RCX: 00007f31632de93a
RDX: 0000000020011a00 RSI: 0000000020011a40 RDI: 00007ffdd671fdc0
RBP: 0000000000000004 R08: 00007ffdd671fe00 R09: 00000000000119f5
R10: 0000000001200014 R11: 0000000000000282 R12: 0000000001200014
R13: 00007ffdd671fe00 R14: 0000000000000003 R15: 0000000001000000
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:bch2_checksum+0x717/0x730 fs/bcachefs/checksum.c:236
Code: ff ff 89 d9 80 e1 07 80 c1 03 38 c1 0f 8c 0a fe ff ff 48 89 df e8 19 0b dc fd e9 fd fd ff ff e8 1f b4 6a 07 e8 9a 52 76 fd 90 <0f> 0b e8 92 52 76 fd 90 0f 0b e8 8a 52 76 fd 90 0f 0b 0f 1f 80 00
RSP: 0018:ffffc9000368e340 EFLAGS: 00010293
RAX: ffffffff841fc9e6 RBX: 20000004b5d608e4 RCX: ffff888027f9da00
RDX: 0000000000000000 RSI: ffffffff8e92a440 RDI: 000000000000000f
RBP: ffffc9000368e6b0 R08: 0000000000000005 R09: ffffffff841fc3aa
R10: 0000000000000008 R11: ffff888027f9da00 R12: ffffc9000368e3e0
R13: dffffc0000000000 R14: 000000000000000f R15: 1ffff920006d1c70
FS:  00005555916b4380(0000) GS:ffff8880b9500000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007ffd20783dd4 CR3: 00000000799da000 CR4: 00000000003506f0
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

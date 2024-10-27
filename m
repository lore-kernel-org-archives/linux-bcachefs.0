Received: from mail-il1-f200.google.com (mail-il1-f200.google.com [209.85.166.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71F4E801
	for <linux-bcachefs@vger.kernel.org>; Sun, 27 Oct 2024 01:10:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729991435; cv=none; b=hgng7UzHESf6TtK6xRwQ0+kC2SVjljxSmM95VD4nROjO7Y9/SI5WgkbtEWiKjWal6XfkdsSQsiAckYwab1NND9Yzv82HOGO4VxwjeZBfjPY1dlHRqJ06INeCKKKOBsaqa5UGa7P3uzQueUQUpvZ6KZZ3UqAR3AtGK27NjLAlIQw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729991435; c=relaxed/simple;
	bh=RVe5zB2v8sRHDPxZBzwzhebeG6gsX4agM1TUjewIrVc=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=p3gVqAqMAcwcphXlyItrEO+gq7WQpF9kkteFwEyOJXz+b4UveMWXlRrTjtVVIDEBkk+EPKi2gw6pP0nDhhdRxmYF+TTLYpNWJH6qInVcx/VuDbmiFBOR8VUcaIJZN/y686inEHy9T6i7nQXHxUh+bbZM9NYeTU2LPmRVryVI5bk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f200.google.com with SMTP id e9e14a558f8ab-3a3c9886eccso28327165ab.2
        for <linux-bcachefs@vger.kernel.org>; Sat, 26 Oct 2024 18:10:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729991432; x=1730596232;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=hTIHbezt4reFwj95Pb6zRzUVs06JKt5WN8r4BEZS25Y=;
        b=AWsSJavl44bQoHBz0LZJCptGaILGWtg6Zg6NXGNUui5Z3ZEwuSUYEc9moCDy2Vcx6x
         pEk155aPAm3AOX0lPLFDpS2dFn6TASTAvPJ1xZ2LnXZKwybn4cuXtxx3jdgpEj61k8rz
         0F8ZMplo6pHBWIKEyXwGjyXhBhic+XZjm3iFX3/aA/48qBrH8uZ3y6SFdjmZp3sQTWgm
         XhqJdoC9ycdXduirlwRNecUq6ZF5Eu4+1ok2J/c4Q5gRhBwFdnFb8urBwuv8qpQQKP1q
         lj50C8X+LLr4J9G272kRMP+nVUGNDON7U0fYwNDlln+l09VtglaAOUr+1PI8m/lMrnwu
         3E4Q==
X-Forwarded-Encrypted: i=1; AJvYcCVaNmXoatfRFedJ0izspM9J0wMIX2UywdGUwEuLmKDVc61Lz/g87GbmyDVocgJx+p9E6TR01bqcy+v2wWKT+w==@vger.kernel.org
X-Gm-Message-State: AOJu0YzcqO9tB3Go7uj1IZdWXV30f1Vf3wfQmyRQT276uzZUrijyp7hx
	N9Vj0+Za2R3L8GvNs0bbYHD5Gi8ZuJSjpF7TqqFFMU8c6L9vcbyq5yArSxhEGdvZPl4woPlfw68
	x/B4zpic/Fy1LGhoSnsq+S00u5mF1li5BsTiZ7gLz9L1IHb02IOFIFbk=
X-Google-Smtp-Source: AGHT+IEkDD9rh6XnYs19d1oNwKksln82HtCBI5JGOCntmV4RQoIfyHGv4vshUjydH8BhVokdFyEoiwq5vnzZq6ZpT3fsyuD/8caK
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1a67:b0:3a3:f8e3:6dbc with SMTP id
 e9e14a558f8ab-3a4ed2fbd93mr32746395ab.21.1729991432614; Sat, 26 Oct 2024
 18:10:32 -0700 (PDT)
Date: Sat, 26 Oct 2024 18:10:32 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <671d9308.050a0220.2fdf0c.0232.GAE@google.com>
Subject: [syzbot] [bcachefs?] kernel BUG in bch2_bkey_pack_pos_lossy
From: syzbot <syzbot+e8bd437eb38c35c5f35a@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    c2ee9f594da8 KVM: selftests: Fix build on on non-x86 archi..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1051ca5f980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=fc6f8ce8c5369043
dashboard link: https://syzkaller.appspot.com/bug?extid=e8bd437eb38c35c5f35a
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=16e1a640580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=15344287980000

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/7feb34a89c2a/non_bootable_disk-c2ee9f59.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/8a3541902b13/vmlinux-c2ee9f59.xz
kernel image: https://storage.googleapis.com/syzbot-assets/a00efacc2604/bzImage-c2ee9f59.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/e27719dd0715/mount_0.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+e8bd437eb38c35c5f35a@syzkaller.appspotmail.com

bcachefs (loop0): alloc_read... done
bcachefs (loop0): stripes_read... done
bcachefs (loop0): snapshots_read... done
bcachefs (loop0): check_allocations...
------------[ cut here ]------------
kernel BUG at fs/bcachefs/bkey.c:130!
Oops: invalid opcode: 0000 [#1] PREEMPT SMP KASAN NOPTI
CPU: 0 UID: 0 PID: 5096 Comm: syz-executor440 Not tainted 6.12.0-rc4-syzkaller-00047-gc2ee9f594da8 #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
RIP: 0010:pack_state_finish fs/bcachefs/bkey.c:130 [inline]
RIP: 0010:bch2_bkey_pack_pos_lossy+0x1956/0x1990 fs/bcachefs/bkey.c:525
Code: fd 90 0f 0b e8 5b b8 83 fd 90 0f 0b e8 53 b8 83 fd 90 0f 0b e8 4b b8 83 fd 90 0f 0b e8 43 b8 83 fd 90 0f 0b e8 3b b8 83 fd 90 <0f> 0b e8 33 47 b5 07 e8 2e b8 83 fd 90 0f 0b e8 26 b8 83 fd 90 0f
RSP: 0018:ffffc90002c3dd20 EFLAGS: 00010293
RAX: ffffffff84111fa5 RBX: ffffc90802c3e0b8 RCX: ffff88801fa9a440
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: ffffc90002c3df58 R08: ffffffff84110ea6 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: dffffc0000000000
R13: ffff8880408320c0 R14: 0000000000000000 R15: ffffc90002c3e0c0
FS:  0000555561411380(0000) GS:ffff88801fc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000055cccf015d88 CR3: 0000000040a32000 CR4: 0000000000352ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 bch2_btree_node_iter_init+0x894/0x4280 fs/bcachefs/bset.c:1313
 __btree_path_level_init fs/bcachefs/btree_iter.c:615 [inline]
 bch2_btree_path_level_init+0x4d2/0x9f0 fs/bcachefs/btree_iter.c:635
 btree_path_lock_root fs/bcachefs/btree_iter.c:769 [inline]
 bch2_btree_path_traverse_one+0x10de/0x2940 fs/bcachefs/btree_iter.c:1170
 bch2_btree_path_traverse fs/bcachefs/btree_iter.h:247 [inline]
 __bch2_btree_iter_peek fs/bcachefs/btree_iter.c:2197 [inline]
 bch2_btree_iter_peek_upto+0xb58/0x70e0 fs/bcachefs/btree_iter.c:2297
 bch2_btree_iter_peek_upto_type fs/bcachefs/btree_iter.h:685 [inline]
 bch2_gc_btree fs/bcachefs/btree_gc.c:670 [inline]
 bch2_gc_btrees fs/bcachefs/btree_gc.c:729 [inline]
 bch2_check_allocations+0x1a8b/0x6e80 fs/bcachefs/btree_gc.c:1123
 bch2_run_recovery_pass+0xf0/0x1e0 fs/bcachefs/recovery_passes.c:185
 bch2_run_recovery_passes+0x387/0x870 fs/bcachefs/recovery_passes.c:232
 bch2_fs_recovery+0x25cc/0x39c0 fs/bcachefs/recovery.c:862
 bch2_fs_start+0x356/0x5b0 fs/bcachefs/super.c:1036
 bch2_fs_get_tree+0xd68/0x1710 fs/bcachefs/fs.c:2174
 vfs_get_tree+0x90/0x2b0 fs/super.c:1800
 do_new_mount+0x2be/0xb40 fs/namespace.c:3507
 do_mount fs/namespace.c:3847 [inline]
 __do_sys_mount fs/namespace.c:4057 [inline]
 __se_sys_mount+0x2d6/0x3c0 fs/namespace.c:4034
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f354cc85c3a
Code: d8 64 89 02 48 c7 c0 ff ff ff ff eb a6 e8 5e 04 00 00 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fff33d28828 EFLAGS: 00000282 ORIG_RAX: 00000000000000a5
RAX: ffffffffffffffda RBX: 00007fff33d28840 RCX: 00007f354cc85c3a
RDX: 00000000200058c0 RSI: 0000000020005900 RDI: 00007fff33d28840
RBP: 0000000000000004 R08: 00007fff33d28880 R09: 0000000000005932
R10: 0000000000010000 R11: 0000000000000282 R12: 0000000000010000
R13: 00007fff33d28880 R14: 0000000000000003 R15: 0000000001000000
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:pack_state_finish fs/bcachefs/bkey.c:130 [inline]
RIP: 0010:bch2_bkey_pack_pos_lossy+0x1956/0x1990 fs/bcachefs/bkey.c:525
Code: fd 90 0f 0b e8 5b b8 83 fd 90 0f 0b e8 53 b8 83 fd 90 0f 0b e8 4b b8 83 fd 90 0f 0b e8 43 b8 83 fd 90 0f 0b e8 3b b8 83 fd 90 <0f> 0b e8 33 47 b5 07 e8 2e b8 83 fd 90 0f 0b e8 26 b8 83 fd 90 0f
RSP: 0018:ffffc90002c3dd20 EFLAGS: 00010293
RAX: ffffffff84111fa5 RBX: ffffc90802c3e0b8 RCX: ffff88801fa9a440
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: ffffc90002c3df58 R08: ffffffff84110ea6 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: dffffc0000000000
R13: ffff8880408320c0 R14: 0000000000000000 R15: ffffc90002c3e0c0
FS:  0000555561411380(0000) GS:ffff88801fc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000055cccf015d88 CR3: 0000000040a32000 CR4: 0000000000352ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400


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

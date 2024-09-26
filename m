Received: from mail-il1-f197.google.com (mail-il1-f197.google.com [209.85.166.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 887891D5ABA
	for <linux-bcachefs@vger.kernel.org>; Thu, 26 Sep 2024 04:02:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727323349; cv=none; b=g99qUuLuIlWS7yQ/rcxC4EwMKBeaKO1hiMkjXO+pETIZYH3g4NVeZa2XUp2WQSP3Y3xtkYQrGClnWl+CYMDQjlS0DJ55l5QypxTJMyu8sZ3RGaAPUb8Pj9Tl3CM3GUW9+/hL8rN3XY3vcTJbuaChV7ET9r/TZ2wmiakQJKobKns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727323349; c=relaxed/simple;
	bh=fMWPfu9FJkZxYnNqK6kp/28nndQp0mqwMK8Hlmf7660=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=TIxGJuBPNiplWeGGhrfjzL5FCzBHDIiaxVFpE5+2DeoV/dTugT4eDTNxOhxskYjGgle1i6Jf0a90HEyoNb5FoidEfmfQU4VcRDHxUqvqDbH1rXqbXFFt0N9cm4VMhZTiQYWaQAwGW4vkPTIQU5iKuEU2CJ0PQtSxNFRuKodlDb8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-3a1957c7cf3so6237275ab.2
        for <linux-bcachefs@vger.kernel.org>; Wed, 25 Sep 2024 21:02:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727323346; x=1727928146;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=m6AHITBFcHYLvt7nE1Q6Ch127vP6+FBh72zrJdlA9Uw=;
        b=aTUPaf+zSGRe3LTovmD2Kz8x5Whimxk3gssooZ9w/6lpPJoEO8rJ/tafcruMNbpxal
         KMO1BQPuTHGlasX9y4UI42oYWVecI4QfGJz493Y6EP/dkJQXySVOR2U1ZRwvUkt1Sehj
         IVwWQiKOpomeFkFLMOBQ9tINZt+fUVQj6QKpmfRRJagwxlJpqvf793LHehTBO0S+6bF6
         MtPObfgqMhqnPTBUR8FCyGqH0u6WuHw7pnFgrCPmBnOkWpRA2nrqueEOUjhcjJm6d6sL
         qZjt9ShrXVsfqVeTHjKFM/ROGYBNguxERjIPS8lw26AnR4kcAFzUcNkhd5eI21dY/MT5
         gadA==
X-Forwarded-Encrypted: i=1; AJvYcCVEWHejuE9XHUd8Gh4VR7tXkN6Z6Malh0+Hz1hb4mJOpbtJ5kkZe6PgRhOcv1GW8p7leRXn2YHGxv4FgR4UYg==@vger.kernel.org
X-Gm-Message-State: AOJu0YzMfZBs49iWx6vduIPu6QyV+vNBIAwNO7Rl7auBR7JXZzJp4/zJ
	60oZTYwHFdRyKz7BjR1Oersv4otUSRABzFnZcw6X5TjTB9HUkDexirKan0hxqQusbuIKb1etZ3q
	4cizIS01Em1jT3S7T6WvZ9iXqcstetuga2KHb6ye4rqMCa2nVZIgICCg=
X-Google-Smtp-Source: AGHT+IEeM7Xdo3aXQnKZvPp9KJctY4UnXNoVObnXe8akTQMzAgghX9EM4hQkFEhbm7X1twlsHPsp0rRwej8gswt/w2pDCnynjHsV
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1448:b0:3a0:8c5f:90d8 with SMTP id
 e9e14a558f8ab-3a26d732381mr48110885ab.6.1727323346613; Wed, 25 Sep 2024
 21:02:26 -0700 (PDT)
Date: Wed, 25 Sep 2024 21:02:26 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <66f4dcd2.050a0220.211276.003a.GAE@google.com>
Subject: [syzbot] [bcachefs?] UBSAN: shift-out-of-bounds in bch2_stripe_to_text
From: syzbot <syzbot+f8c98a50c323635be65d@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    1ec6d097897a Merge tag 's390-6.12-1' of git://git.kernel.o..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=14c0b080580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=6265dd30e362bb47
dashboard link: https://syzkaller.appspot.com/bug?extid=f8c98a50c323635be65d
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12e58e07980000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=12c0b080580000

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/7bc7510fe41f/non_bootable_disk-1ec6d097.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/0b74fa2b2b4e/vmlinux-1ec6d097.xz
kernel image: https://storage.googleapis.com/syzbot-assets/1ed852a3c5d1/bzImage-1ec6d097.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/19c2305bd0ee/mount_0.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+f8c98a50c323635be65d@syzkaller.appspotmail.com

bcachefs (loop0): Doing compatible version upgrade from 1.7: mi_btree_bitmap to 1.12: rebalance_work_acct_fix
  running recovery passes: check_allocations
------------[ cut here ]------------
UBSAN: shift-out-of-bounds in fs/bcachefs/ec.c:147:2
shift exponent 108 is too large for 32-bit type 'unsigned int'
CPU: 0 UID: 0 PID: 5088 Comm: syz-executor278 Not tainted 6.11.0-syzkaller-08068-g1ec6d097897a #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:93 [inline]
 dump_stack_lvl+0x241/0x360 lib/dump_stack.c:119
 ubsan_epilogue lib/ubsan.c:231 [inline]
 __ubsan_handle_shift_out_of_bounds+0x3c8/0x420 lib/ubsan.c:468
 bch2_stripe_to_text+0x899/0x8c0 fs/bcachefs/ec.c:147
 __bch2_bkey_fsck_err+0x11f/0x230 fs/bcachefs/error.c:429
 bch2_stripe_validate+0x3ca/0x630 fs/bcachefs/ec.c:116
 bch2_btree_node_read_done+0x3dc6/0x5d60 fs/bcachefs/btree_io.c:1219
 btree_node_read_work+0x68b/0x1260 fs/bcachefs/btree_io.c:1323
 bch2_btree_node_read+0x2433/0x2a10
 __bch2_btree_root_read fs/bcachefs/btree_io.c:1749 [inline]
 bch2_btree_root_read+0x626/0x980 fs/bcachefs/btree_io.c:1773
 read_btree_roots+0x296/0x840 fs/bcachefs/recovery.c:523
 bch2_fs_recovery+0x24ac/0x38b0 fs/bcachefs/recovery.c:851
 bch2_fs_start+0x356/0x5b0 fs/bcachefs/super.c:1036
 bch2_fs_get_tree+0xd61/0x1700 fs/bcachefs/fs.c:1956
 vfs_get_tree+0x90/0x2b0 fs/super.c:1800
 do_new_mount+0x2be/0xb40 fs/namespace.c:3507
 do_mount fs/namespace.c:3847 [inline]
 __do_sys_mount fs/namespace.c:4055 [inline]
 __se_sys_mount+0x2d6/0x3c0 fs/namespace.c:4032
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fbcc7b8a8fa
Code: d8 64 89 02 48 c7 c0 ff ff ff ff eb a6 e8 5e 04 00 00 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffc0febe3f8 EFLAGS: 00000282 ORIG_RAX: 00000000000000a5
RAX: ffffffffffffffda RBX: 00007ffc0febe410 RCX: 00007fbcc7b8a8fa
RDX: 0000000020005d80 RSI: 0000000020005dc0 RDI: 00007ffc0febe410
RBP: 0000000000000004 R08: 00007ffc0febe450 R09: 0000000000005d9a
R10: 0000000000200400 R11: 0000000000000282 R12: 0000000000200400
R13: 00007ffc0febe450 R14: 0000000000000003 R15: 0000000001000000
 </TASK>
---[ end trace ]---


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

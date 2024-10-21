Received: from mail-il1-f199.google.com (mail-il1-f199.google.com [209.85.166.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D56071CFEC9
	for <linux-bcachefs@vger.kernel.org>; Mon, 21 Oct 2024 06:44:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729493070; cv=none; b=oVevXrdceT+yGUg9s9EFqHVoJHNDq6hRr9AkjPbQMRXgBHLV18NPYyun8dnzIOrOyxVa0m9k4mXCi4W5f3y8Ey49nkwLOloH3zb6J1CVsre3FqDQARpO6aOMuj26EznxxoX9RxIobpmSSP95Vi/a/P8sUY7PBID6pnOERjhxW6E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729493070; c=relaxed/simple;
	bh=pPqt3RugRon24hNfN+Wo0Qd2b7xX+v0scX0th/xtPVk=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=mgehdq9gu4Vn5CDPSdKLVV3eTbabuuIu93/RM/r/R3HDyFiUwnMvZwi+N7I6Al0Wi7bAUwICg5daCFbbxc9tyi4SCvzwHup1PP+mFAQYcC2VxKsjW+HwNZv5/as5btlyH1GL2FVk+LzI4puG6HBnLAHzOOxwYZjUzZz13LAFYhg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f199.google.com with SMTP id e9e14a558f8ab-3a3da2d46b9so32482755ab.0
        for <linux-bcachefs@vger.kernel.org>; Sun, 20 Oct 2024 23:44:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729493068; x=1730097868;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=OoBkKRTOllHFi8zTnZEUwNteyoiy7CSSHa8XM1jHGKE=;
        b=LTMGkMJJYaLjRs0BwrPPc4QtYsltqEIzJrc2AJQpJeLcgQCivteUr+Lw3wKVJ9HXWL
         w4PS5dKQPXRJWa7/jiW4urS6A5e3RUxzUnm3UX6KvwBw2AShTuhDmn/Rz8Kody+HfMbw
         KC1n6kOjou8D8MNw1sxbWhJ+FlDQ/c79VPWg8wgcgAnVmCQ4/nRctDk8ZUf0lextnqkp
         hFhrQfaxqXrL7G4Ay8N9FJ5R3MttSrCmMZHUuMaE/vtsLzX9dK2BgeiKQ7o0xkyrovkh
         F8RYfbuV4k9+4JG1NsX6LbaRq8SSlxmB5tAlE/cnaRBPsHtEBojtqWciwjBAhcuEXI/Q
         /pOA==
X-Forwarded-Encrypted: i=1; AJvYcCUHtMc9zAPM+xksKJm5uGQQVpgCFh/7aHEizJgVURmoBDk8oo95YVpyMNDlxIWhjH3lg6fMWfNBR59MkAaEMA==@vger.kernel.org
X-Gm-Message-State: AOJu0YwsWcWfr19SBRX/SfnNteYxJRJDcxCit3AIUXiYhXkdyi5Y/xAT
	O+nNIO5RDDZxaqkxErYfClG4vW3yg2eoH/Ohs15T7uCJA0CTLdjs4t2lYNyaOnhnXoCct7vZ8BL
	ddRtl9yFcAKH2rxD2JFWPQrVZk3QwLWKk4oFVhqjQVl2w1zArAlEs+uo=
X-Google-Smtp-Source: AGHT+IEDdJroIBNPT80drRkeuVN/w+F8f240nebGk8Hd5ZyrQnwZcTdIC1pgng7jRcNQ2RP83LQ78irISg30pkvTMyCT/laljQ4b
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:2192:b0:3a0:985b:ddb4 with SMTP id
 e9e14a558f8ab-3a3f404ff3amr86757085ab.2.1729493067862; Sun, 20 Oct 2024
 23:44:27 -0700 (PDT)
Date: Sun, 20 Oct 2024 23:44:27 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6715f84b.050a0220.10f4f4.003e.GAE@google.com>
Subject: [syzbot] [bcachefs?] UBSAN: shift-out-of-bounds in bch2_alloc_to_text
From: syzbot <syzbot+7f45fa9805c40db3f108@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    c964ced77262 Merge tag 'for-linus' of git://git.kernel.org..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=12d9745f980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=cfbd94c114a3d407
dashboard link: https://syzkaller.appspot.com/bug?extid=7f45fa9805c40db3f108
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12637887980000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=12a1e830580000

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/7feb34a89c2a/non_bootable_disk-c964ced7.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/e937ef58569a/vmlinux-c964ced7.xz
kernel image: https://storage.googleapis.com/syzbot-assets/f1df9880ca4b/bzImage-c964ced7.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/00439b875347/mount_0.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+7f45fa9805c40db3f108@syzkaller.appspotmail.com

bcachefs (loop0): fatal error - emergency read only
bcachefs (loop0): insufficient writeable journal devices available: have 0, need 1
rw journal devs: loop0
------------[ cut here ]------------
UBSAN: shift-out-of-bounds in fs/bcachefs/alloc_background.h:165:13
shift exponent 129 is too large for 32-bit type 'unsigned int'
CPU: 0 UID: 0 PID: 5104 Comm: syz-executor159 Not tainted 6.12.0-rc3-syzkaller-00087-gc964ced77262 #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0x241/0x360 lib/dump_stack.c:120
 ubsan_epilogue lib/ubsan.c:231 [inline]
 __ubsan_handle_shift_out_of_bounds+0x3c8/0x420 lib/ubsan.c:468
 data_type_movable fs/bcachefs/alloc_background.h:165 [inline]
 alloc_lru_idx_fragmentation fs/bcachefs/alloc_background.h:171 [inline]
 bch2_alloc_to_text+0xc79/0xce0 fs/bcachefs/alloc_background.c:369
 __bch2_bkey_fsck_err+0x1c8/0x280 fs/bcachefs/error.c:454
 bch2_alloc_v4_validate+0x931/0xef0 fs/bcachefs/alloc_background.c:259
 bch2_btree_node_read_done+0x3e7e/0x5e90 fs/bcachefs/btree_io.c:1223
 btree_node_read_work+0x68b/0x1260 fs/bcachefs/btree_io.c:1327
 bch2_btree_node_read+0x2433/0x2a10
 __bch2_btree_root_read fs/bcachefs/btree_io.c:1753 [inline]
 bch2_btree_root_read+0x617/0x7a0 fs/bcachefs/btree_io.c:1775
 read_btree_roots+0x296/0x840 fs/bcachefs/recovery.c:524
 bch2_fs_recovery+0x2585/0x39c0 fs/bcachefs/recovery.c:854
 bch2_fs_start+0x356/0x5b0 fs/bcachefs/super.c:1036
 bch2_fs_get_tree+0xd68/0x1710 fs/bcachefs/fs.c:2174
 vfs_get_tree+0x90/0x2b0 fs/super.c:1800
 do_new_mount+0x2be/0xb40 fs/namespace.c:3507
 do_mount fs/namespace.c:3847 [inline]
 __do_sys_mount fs/namespace.c:4055 [inline]
 __se_sys_mount+0x2d6/0x3c0 fs/namespace.c:4032
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f7b61a11dea
Code: d8 64 89 02 48 c7 c0 ff ff ff ff eb a6 e8 5e 04 00 00 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffff7f9a888 EFLAGS: 00000282 ORIG_RAX: 00000000000000a5
RAX: ffffffffffffffda RBX: 00007ffff7f9a8a0 RCX: 00007f7b61a11dea
RDX: 00000000200058c0 RSI: 0000000020000100 RDI: 00007ffff7f9a8a0
RBP: 0000000000000004 R08: 00007ffff7f9a8e0 R09: 00000000000058c6
R10: 0000000000000000 R11: 0000000000000282 R12: 0000000000000000
R13: 00007ffff7f9a8e0 R14: 0000000000000003 R15: 0000000001000000
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

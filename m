Received: from mail-io1-f70.google.com (mail-io1-f70.google.com [209.85.166.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 819A31B0F14
	for <linux-bcachefs@vger.kernel.org>; Fri, 25 Oct 2024 06:49:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729838968; cv=none; b=AE+WG7FlPkjT0FMdaCjtwotESejzvt+uOFiFGq0PEJdIBsOzXSIKzrJNJ0Ul67QZ1+UGZzyEwyZJ6r0IZnsBMvkdzPqSkMSlBeDdc9iCVGO6kRGd5LCigG2T0fHdgR35rhXuOU2jSuFwO/XSwpEyEXrrtH2vHZWjvWGjzQKIPzA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729838968; c=relaxed/simple;
	bh=8OI7fKu4JN8SV9hH1JY0dB7+o5CBmigLV5JLhPHOtvk=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=JB8IhWaUoro9P421374tPWHK93bhOF4gseRSxDJ4ukCQorGRcNrA1bRTvWEJv0bbrOZQVZfWgEPXf0Vs+akBjHjd99lP8qMt5a2hhqG2cCp16+gC0YijYaOsswDC1VhFwBx9ok3Z8ZSzdq/nyYiwC4rwHO3uvsJKigieYrnobQ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f70.google.com with SMTP id ca18e2360f4ac-83aae46538bso161058739f.1
        for <linux-bcachefs@vger.kernel.org>; Thu, 24 Oct 2024 23:49:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729838965; x=1730443765;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=aEEym5pvVLpeSNzCyzbGPdwWKZHWd7ogh6bRqG2sb9w=;
        b=Zsn3AfR7xWIzvBouIrBaCnYCKgCbu++oZ6Wt9m964jVsYC+zvNmAfF+bwepgu89mDP
         KLErYjTSZqwkAK7Dzhm4+RsLF3jk81DSduCJmdHc4rx6atE64BCW9XV6MlBxCPlhs4ie
         7ljygQEs2gGOJzM4mSwzFV/9KyymE1JidoWqtyEAAMqNEGFcFnp3UKw/cKYMsc2Xnafa
         DL+BCzHdkJCfFAkTxs6WMMMMUGcEm9X1wSn3XzaXLEyh9GME4WY31DBUutwhZ8TK6vfx
         C4ccE/IZLBELOS1B2ZpyIMM49azOH9/y7tEe6jSIHVvYOshuQ9jm/0viXM0HAC3dNVAu
         E4LQ==
X-Forwarded-Encrypted: i=1; AJvYcCUiB8Rzr6ZAaVBci/0LDzFKJXF4siONZ0Kz3gDmqRMmBWMvkMvfL7uH+dg2QYtJwB5Y7uBnwr+CNu/wmvbS9w==@vger.kernel.org
X-Gm-Message-State: AOJu0YzYHyXFLzjOvQfkgY0lxcxJD1OHCJY/eeoUmF1qWy9EplGEwkjv
	nsTW7NpbWGpK5NP8CJUFW0SckYQl3cDeUmuQmVkOdiE7I/HMYxf5Ql/pp1IK56C1gkjb+DBX5HP
	+vaKX7384Sak3fvR+McI5JUkW2Ly+agP6P3dm8GfMcPhgpJlVn4ZIiAE=
X-Google-Smtp-Source: AGHT+IGeCOvlQPQVKjVm7g4uMIbVu9jmnYO7fa534FObxE5It0DQUAZW9bBK6kGeUmQDT9ucm5F3T8hpaYrcDx7+4Jp/a6ySQUgR
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6602:1414:b0:835:4d07:9d46 with SMTP id
 ca18e2360f4ac-83af6403645mr1091452539f.15.1729838965720; Thu, 24 Oct 2024
 23:49:25 -0700 (PDT)
Date: Thu, 24 Oct 2024 23:49:25 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <671b3f75.050a0220.2eb763.00d8.GAE@google.com>
Subject: [syzbot] [bcachefs?] kernel BUG in bch2_trans_node_iter_init
From: syzbot <syzbot+b17df21b4d370f2dc330@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    c2ee9f594da8 KVM: selftests: Fix build on on non-x86 archi..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=109288a7980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=fc6f8ce8c5369043
dashboard link: https://syzkaller.appspot.com/bug?extid=b17df21b4d370f2dc330
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=178dd640580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=176b2a5f980000

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/7feb34a89c2a/non_bootable_disk-c2ee9f59.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/8a3541902b13/vmlinux-c2ee9f59.xz
kernel image: https://storage.googleapis.com/syzbot-assets/a00efacc2604/bzImage-c2ee9f59.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/c3f485acb30c/mount_0.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+b17df21b4d370f2dc330@syzkaller.appspotmail.com

  got:   u64s 5 type deleted 0:8388608:0 len 0 ver 0
  want:  u64s 9 type backpointer 0:8388608:0 len 0 ver 0: bucket=0:32:0 btree=snapshots l=1 offset=0:0 len=256 pos=SPOS_MAX, fixing
------------[ cut here ]------------
kernel BUG at fs/bcachefs/btree_iter.c:2916!
Oops: invalid opcode: 0000 [#1] PREEMPT SMP KASAN NOPTI
CPU: 0 UID: 0 PID: 5092 Comm: syz-executor289 Not tainted 6.12.0-rc4-syzkaller-00047-gc2ee9f594da8 #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
RIP: 0010:bch2_trans_node_iter_init+0x61d/0x630 fs/bcachefs/btree_iter.c:2916
Code: 89 d9 80 e1 07 fe c1 38 c1 0f 8c aa fd ff ff 48 89 df e8 46 5f e3 fd e9 9d fd ff ff e8 2c 9a 79 fd 90 0f 0b e8 24 9a 79 fd 90 <0f> 0b e8 1c 9a 79 fd 90 0f 0b e8 14 29 ab 07 0f 1f 40 00 90 90 90
RSP: 0018:ffffc9000b1e6020 EFLAGS: 00010293
RAX: ffffffff841b3dbc RBX: 0000000000000003 RCX: ffff88801ef8c880
RDX: 0000000000000000 RSI: 000000000000000b RDI: 0000000000000003
RBP: ffffc9000b1e6158 R08: ffffffff841b3b8b R09: ffffffffffffffff
R10: ffffffffffffffff R11: ffffffffffffffff R12: dffffc0000000000
R13: 000000000000000b R14: 0000000000000000 R15: 0000000000000000
FS:  0000555558106380(0000) GS:ffff88801fc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000055d8cc97e028 CR3: 000000004113e000 CR4: 0000000000352ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 bch2_backpointer_get_node+0x2c6/0x880 fs/bcachefs/backpointers.c:358
 bch2_backpointer_get_key+0x61c/0x970 fs/bcachefs/backpointers.c:335
 check_bp_exists fs/bcachefs/backpointers.c:579 [inline]
 check_extent_to_backpointers+0x21f9/0x46b0 fs/bcachefs/backpointers.c:683
 check_btree_root_to_backpointers fs/bcachefs/backpointers.c:717 [inline]
 bch2_check_extents_to_backpointers_pass fs/bcachefs/backpointers.c:868 [inline]
 bch2_check_extents_to_backpointers+0xeb8/0x1bf0 fs/bcachefs/backpointers.c:932
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
RIP: 0033:0x7ffaca565dba
Code: d8 64 89 02 48 c7 c0 ff ff ff ff eb a6 e8 5e 04 00 00 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffd941c4cb8 EFLAGS: 00000282 ORIG_RAX: 00000000000000a5
RAX: ffffffffffffffda RBX: 00007ffd941c4cd0 RCX: 00007ffaca565dba
RDX: 0000000020000040 RSI: 0000000020005900 RDI: 00007ffd941c4cd0
RBP: 0000000000000004 R08: 00007ffd941c4d10 R09: 002c647261637350
R10: 0000000000000000 R11: 0000000000000282 R12: 0000000000000000
R13: 00007ffd941c4d10 R14: 0000000000000003 R15: 0000000001000000
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:bch2_trans_node_iter_init+0x61d/0x630 fs/bcachefs/btree_iter.c:2916
Code: 89 d9 80 e1 07 fe c1 38 c1 0f 8c aa fd ff ff 48 89 df e8 46 5f e3 fd e9 9d fd ff ff e8 2c 9a 79 fd 90 0f 0b e8 24 9a 79 fd 90 <0f> 0b e8 1c 9a 79 fd 90 0f 0b e8 14 29 ab 07 0f 1f 40 00 90 90 90
RSP: 0018:ffffc9000b1e6020 EFLAGS: 00010293
RAX: ffffffff841b3dbc RBX: 0000000000000003 RCX: ffff88801ef8c880
RDX: 0000000000000000 RSI: 000000000000000b RDI: 0000000000000003
RBP: ffffc9000b1e6158 R08: ffffffff841b3b8b R09: ffffffffffffffff
R10: ffffffffffffffff R11: ffffffffffffffff R12: dffffc0000000000
R13: 000000000000000b R14: 0000000000000000 R15: 0000000000000000
FS:  0000555558106380(0000) GS:ffff88801fc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000055d8cc97e028 CR3: 000000004113e000 CR4: 0000000000352ef0
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

Received: from mail-io1-f78.google.com (mail-io1-f78.google.com [209.85.166.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E154418E20
	for <linux-bcachefs@vger.kernel.org>; Sun,  1 Jun 2025 04:54:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748753679; cv=none; b=IEfM6V3VFM3/lyyJsYftlia6msTQG8dyCLfD3zOK3NlXx9EimL6h6n8iHQ/+aRQvCndF4phqQMXHrDMX1tj9kYN8Y6mnAjsmqZWmWIvgliwPMTxBo+ki23bI8p4g/aKGMAJZ04Fygovzo10OpBXtaUIfPIwpzqDmMUP+rX6tGuo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748753679; c=relaxed/simple;
	bh=qHEqHIgRcmAPeu0jPrUbfuslBZ5Cj/TfGeW8xZ8TNQU=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=aVduRMaTngCMDmi31m0ephgCemvh3Q7O5o1e2H+QmQg8ej1HSBy1l0NKVxercP56jVaNzz+OD4KGq+dN4Kl6sC61pxz0aS7/+WBvxHjZUMaK1kyMZZTw+bF/HPAploDnCG0j0NIV2QQjv6fZHa6b4WV90RpyBpSHviThviEr+SQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f78.google.com with SMTP id ca18e2360f4ac-86d126265baso88005339f.0
        for <linux-bcachefs@vger.kernel.org>; Sat, 31 May 2025 21:54:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748753677; x=1749358477;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=+8qegP7nG4ylERrKp9Olu0X9clu/U8M9idwqPn1t/fc=;
        b=aKhPU+g5n7LDnS27yI93p1E98RVA3XUL42vw5hKPxjUWpLMws0hXksG6REpH77SMon
         8AkWEnVNdA2c9eaxHSpntCyU+AlDzMdhDUiAUg5VDiTdPkFzoSeZvg/gMh46Kxj3Vf7A
         y8lybqrPnp6Fs9G8WlrvzeBfMxabnDdOyPZBRZDjP96NfSKqjv1Tbl3rIr0/Ok40ZrBV
         ZfBPvFVV2hhx7iAUKTCUbwfpCO7Be3OSLyfrI6EDHCN3ebMy07b0ILCGOyZtBtNl4b9O
         geQEM3oL/uVDDw2/8gFc31B62eyGWX7pKn34vvQeQbnD0wq8NVlOFmnnZk3Z1MVnK6ai
         41Pw==
X-Forwarded-Encrypted: i=1; AJvYcCWu8uoB4YGeSjKpyXMfrNqKeSFV8puECAwiLZKQvrStAI4Gd+OulSajJ64ZlqpLRKyhuBO67c0M7twIvXLuSQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YwJEitXGjYTTw5W0VZ3VfpcyfcK5HydqAavkeYN5q2pfxnSHTe5
	zvLPK9/E9h77qvB1ArZrXQ/2FgO5r/3nrcGHutUGM1rJNOF0Z8ccHLqaSM6aGS4Jri+9oklbziE
	NkaQuMB9dFB+R6XGG2iIGUfiLFviW0iCc2H9yb+gZ1mbDwD2d1V7ROsTydwY=
X-Google-Smtp-Source: AGHT+IEePnUSWW4j6v3h2tb3cxHJXga/PTaDbhqI+uUU3lWikyUSq4jz5Xlmk02Ja6N2iPJteyApPFmjmll0j1eKL+k3nLY4VE+b
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1a6b:b0:3dc:8a5f:7cc1 with SMTP id
 e9e14a558f8ab-3dd99bd0075mr97088195ab.3.1748753677041; Sat, 31 May 2025
 21:54:37 -0700 (PDT)
Date: Sat, 31 May 2025 21:54:37 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <683bdd0d.a00a0220.d8eae.0027.GAE@google.com>
Subject: [syzbot] [bcachefs?] WARNING in bch2_alloc_sectors_start_trans
From: syzbot <syzbot+23573dac1278bb26916d@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    c89756bcf406 Merge tag 'pm-6.16-rc1' of git://git.kernel.o..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=12297170580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=ded97a85afe9a6c8
dashboard link: https://syzkaller.appspot.com/bug?extid=23573dac1278bb26916d
compiler:       Debian clang version 20.1.6 (++20250514063057+1e4d39e07757-1~exp1~20250514183223.118), Debian LLD 20.1.6
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=16297170580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=166666d4580000

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-c89756bc.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/b21d74e73303/vmlinux-c89756bc.xz
kernel image: https://storage.googleapis.com/syzbot-assets/b778ededeb75/bzImage-c89756bc.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/f56f82635bb3/mount_2.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+23573dac1278bb26916d@syzkaller.appspotmail.com

bcachefs (loop0): snapshot points to missing/incorrect tree:
  u64s 8 type snapshot 0:4294967295:0 len 0 ver 0: subvol parent          0 children          0          0 subvol 1 tree 0, fixing
------------[ cut here ]------------
WARNING: CPU: 0 PID: 5305 at fs/bcachefs/btree_iter.c:3132 __bch2_trans_kmalloc+0x5fb/0xc80 fs/bcachefs/btree_iter.c:3132
Modules linked in:
CPU: 0 UID: 0 PID: 5305 Comm: syz-executor289 Not tainted 6.15.0-syzkaller-03478-gc89756bcf406 #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
RIP: 0010:__bch2_trans_kmalloc+0x5fb/0xc80 fs/bcachefs/btree_iter.c:3132
Code: 00 e8 d9 e2 33 00 48 c7 c3 74 f7 ff ff 48 89 d8 48 83 c4 58 5b 41 5c 41 5d 41 5e 41 5f 5d e9 8c 9e 3e 07 cc e8 b6 ad 9d fd 90 <0f> 0b 90 e9 f0 fa ff ff 48 89 df e8 75 cc 02 00 43 80 7c 35 00 00
RSP: 0018:ffffc9000d24e2b0 EFLAGS: 00010293
RAX: ffffffff8422449a RBX: ffff88804ac38000 RCX: ffff8880002c2440
RDX: 0000000000000000 RSI: 0000000000020000 RDI: 0000000000010000
RBP: ffffc9000d24e568 R08: ffffc9000d24e7b0 R09: 0000000000000001
R10: ffffc9000d24e6c0 R11: fffff52001a49ca5 R12: 0000000000000011
R13: 1ffff11009587000 R14: dffffc0000000000 R15: 0000000000020000
FS:  0000555591a7f380(0000) GS:ffff88808d28f000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f8c1260c000 CR3: 00000000350fa000 CR4: 0000000000352ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 bch2_trans_kmalloc_nomemzero_ip fs/bcachefs/btree_iter.h:586 [inline]
 bch2_trans_kmalloc_nomemzero fs/bcachefs/btree_iter.h:621 [inline]
 bch2_alloc_sectors_start_trans+0x254b/0x26a0 fs/bcachefs/alloc_foreground.c:1253
 __bch2_btree_node_alloc fs/bcachefs/btree_update_interior.c:321 [inline]
 bch2_btree_reserve_get+0x641/0x1810 fs/bcachefs/btree_update_interior.c:535
 bch2_btree_update_start+0x10ff/0x1480 fs/bcachefs/btree_update_interior.c:1255
 bch2_btree_split_leaf+0x14b/0x8e0 fs/bcachefs/btree_update_interior.c:1886
 bch2_trans_commit_error+0x1a8/0x1100 fs/bcachefs/btree_trans_commit.c:910
 __bch2_trans_commit+0x1cee/0x8820 fs/bcachefs/btree_trans_commit.c:1084
 bch2_trans_commit fs/bcachefs/btree_update.h:232 [inline]
 bch2_check_snapshots+0x5b3/0x1f20 fs/bcachefs/snapshot.c:863
 bch2_run_recovery_pass fs/bcachefs/recovery_passes.c:415 [inline]
 __bch2_run_recovery_passes+0x382/0x10b0 fs/bcachefs/recovery_passes.c:470
 bch2_run_recovery_passes+0x184/0x210 fs/bcachefs/recovery_passes.c:541
 bch2_fs_recovery+0x2617/0x3970 fs/bcachefs/recovery.c:974
 bch2_fs_start+0xa43/0xd30 fs/bcachefs/super.c:1206
 bch2_fs_get_tree+0xbfc/0x15f0 fs/bcachefs/fs.c:2479
 vfs_get_tree+0x92/0x2b0 fs/super.c:1809
 do_new_mount+0x24a/0xa40 fs/namespace.c:3882
 do_mount fs/namespace.c:4222 [inline]
 __do_sys_mount fs/namespace.c:4433 [inline]
 __se_sys_mount+0x317/0x410 fs/namespace.c:4410
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f8e37c74f6a
Code: d8 64 89 02 48 c7 c0 ff ff ff ff eb a6 e8 5e 04 00 00 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffebaab1338 EFLAGS: 00000282 ORIG_RAX: 00000000000000a5
RAX: ffffffffffffffda RBX: 00007ffebaab1350 RCX: 00007f8e37c74f6a
RDX: 00002000000000c0 RSI: 0000200000000080 RDI: 00007ffebaab1350
RBP: 0000200000000080 R08: 00007ffebaab1390 R09: 0000000000005963
R10: 0000000000818001 R11: 0000000000000282 R12: 00002000000000c0
R13: 0000000000000004 R14: 0000000000000003 R15: 00007ffebaab1390
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

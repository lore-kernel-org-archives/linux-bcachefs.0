Received: from mail-il1-f205.google.com (mail-il1-f205.google.com [209.85.166.205])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2ED00227E98
	for <linux-bcachefs@vger.kernel.org>; Thu, 19 Jun 2025 11:18:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.205
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750331908; cv=none; b=a5Nkkdmlq/eBJtwcjSaEVn/qGlzjDEE8o6KztXyid/wtrFYiY/4xJhX/6EwhF7PAW8xLsVwn09LK+8nc5eQqjMRSrhZtEoA8WQ8jB3aAToHSr0Xc94sDfN7l6gW9K7N7XtL1younnvcwEsjm6LxaDPMkyXL572aqNDm83LliSwQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750331908; c=relaxed/simple;
	bh=fgTJEWDIgLJEB6L603O2U7ZkCtCfHRU4iXl4rqLtf7I=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=kY6jH0xSgmc2L0OMCxUm1GaVx5TaZ5gRshUEhzWAhjwP4txlCOYdGVTVRAuxb2IEquUQAW7/5Ve9S/Q/Qwzns8DY3ogFQvXdNLYz2m+mVnoBTlCtrLpcleBv1TNooKsj/LTfXFap4blSfD3OQ5B8O3lIFuJ1QObxSsq8MqR5IrY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.205
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f205.google.com with SMTP id e9e14a558f8ab-3ddafe52d04so18415525ab.1
        for <linux-bcachefs@vger.kernel.org>; Thu, 19 Jun 2025 04:18:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750331906; x=1750936706;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=KiuthdvB6IXwhrgylKLALiTm1dCzTP5ssA1/QhUUPak=;
        b=OwI240Z+Mxvswcf+KqU6a0TkvMuxNmPIY3BH9yXRHJoV4zSgnUNbSSTqr8RpxSTSW4
         t6Tu3N6mI5QoDuT2szMm5unE6hlWtvKBgz0SpXUEjX+GZl8PPC3p+DtZNDZ5s2QlU4Bo
         aZ9+spKIQ12XViWzDRoWVcaAxVu1mGlrnyu4Bb/19c5tJZopdSnUlnsvTrt/Lp3h1YFY
         WtcUVdEKdTtxDUdhkVkuTInB6ih/6uw0SF1I22YDwGAkR3yG8GHkQM3gtCHSHcnnNnhz
         DcrMtfQcnXkUGdbmQD0IOHjE1VdyVYDDJEGOROKchDksyks4YAlpokwBS4rqlogBJTLn
         chHQ==
X-Forwarded-Encrypted: i=1; AJvYcCWhpXlTyHH8YaXp62NcP9MzGk5dyF7McTjZ5qi9RCsUVAawdNyALlkF9roDLzL/sIbVw7/0UhDEt8ujdQ12kQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YzWepH8nlCfMIyJSIUL7Bp2Or9Z3vZpLB6S0RZ3G7SS8M1x5/1X
	s7GcIT+GDgH7iDVQBUPB10Q4Qqzx/CgV5+22YNZtHzGryPCwMy248X6+CJ7CpI9pdmY7xgKXLJu
	vLCYERA7OcLkZePm1FdFOe4e5VjrjHvVoesUekgkW8I+2R9h5fQrfKJyTyQo=
X-Google-Smtp-Source: AGHT+IEa61JNLGpN3VEyfjTxtGovGXJcT4/lyn3TsJ23TplE81GxXtxxFgXam2by9YobAUUY+T+SKI9sAL8m0wTTWWkyNiS/X+kG
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:5e0a:b0:3de:1200:219f with SMTP id
 e9e14a558f8ab-3de12002a2fmr152618775ab.22.1750331906191; Thu, 19 Jun 2025
 04:18:26 -0700 (PDT)
Date: Thu, 19 Jun 2025 04:18:26 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6853f202.a00a0220.137b3.0005.GAE@google.com>
Subject: [syzbot] [bcachefs?] kernel BUG in bch2_trans_update_by_path
From: syzbot <syzbot+210dfbddd64294066983@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    fb4d33ab452e Merge tag '6.16-rc2-ksmbd-server-fixes' of gi..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=12eb6d0c580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=d11f52d3049c3790
dashboard link: https://syzkaller.appspot.com/bug?extid=210dfbddd64294066983
compiler:       Debian clang version 20.1.6 (++20250514063057+1e4d39e07757-1~exp1~20250514183223.118), Debian LLD 20.1.6

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-fb4d33ab.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/123054ec64c2/vmlinux-fb4d33ab.xz
kernel image: https://storage.googleapis.com/syzbot-assets/5e5e20b8a324/bzImage-fb4d33ab.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+210dfbddd64294066983@syzkaller.appspotmail.com

bcachefs (loop0): no nodes found for btree extents, continuing
bcachefs (loop0): btree root inodes unreadable, must recover from scan
bcachefs (loop0): bch2_get_scanned_nodes(): recovery btree=inodes level=0 POS_MIN - SPOS_MAX
bcachefs (loop0): bch2_get_scanned_nodes(): recovering u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq 7589ab5e0c11cc7a written 24 min_key POS_MIN durability: 1 ptr: 0:38:0 gen 0
bcachefs (loop0): empty interior btree node at btree=inodes level=1
  u64s 5 type btree_ptr SPOS_MAX len 0 ver 0, fixing
bcachefs (loop0): bch2_btree_repair_topology_recurse(): error ECHILD
bcachefs (loop0): empty btree root inodes
bcachefs (loop0): btree root subvolumes unreadable, must recover from scan
bcachefs (loop0): bch2_get_scanned_nodes(): recovery btree=subvolumes level=0 POS_MIN - SPOS_MAX
bcachefs (loop0): bch2_get_scanned_nodes(): recovering u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c0bef60d07ceb940 written 16 min_key POS_MIN durability: 1 ptr: 0:35:0 gen 0
 done
bcachefs (loop0): accounting_read... done
bcachefs (loop0): alloc_read... done
bcachefs (loop0): snapshots_read... done
bcachefs (loop0): check_allocations...
bcachefs (loop0): bucket 0:26 data type btree ptr gen 0 missing in alloc btree
  while marking u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq ac62141f8dc7e261 written 24 min_key POS_MIN durability: 1 ptr: 0:26:0 gen 0, fixing
bcachefs (loop0): bucket 0:41 data type btree ptr gen 0 missing in alloc btree
  while marking u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq 9aa2895aefce4bdf written 24 min_key POS_MIN durability: 1 ptr: 0:41:0 gen 0, fixing
bcachefs (loop0): bucket 0:35 data type btree ptr gen 0 missing in alloc btree
  while marking u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c0bef60d07ceb940 written 16 min_key POS_MIN durability: 1 ptr: 0:35:0 gen 0, fixing
bcachefs (loop0): bucket 0:1 gen 0 has wrong data_type: got free, should be sb, fixing
bcachefs (loop0): bucket 0:1 gen 0 data type sb has wrong dirty_sectors: got 0, should be 256, fixing
bcachefs (loop0): bucket 0:2 gen 0 has wrong data_type: got free, should be sb, fixing
bcachefs (loop0): bucket 0:2 gen 0 data type sb has wrong dirty_sectors: got 0, should be 256, fixing
bcachefs (loop0): bucket 0:3 gen 0 has wrong data_type: got free, should be sb, fixing
bcachefs (loop0): bucket 0:3 gen 0 data type sb has wrong dirty_sectors: got 0, should be 256, fixing
bcachefs (loop0): bucket 0:4 gen 0 has wrong data_type: got free, should be sb, fixing
bcachefs (loop0): bucket 0:4 gen 0 data type sb has wrong dirty_sectors: got 0, should be 256, fixing
bcachefs (loop0): bucket 0:5 gen 0 has wrong data_type: got free, should be sb, fixing
bcachefs (loop0): bucket 0:5 gen 0 data type sb has wrong dirty_sectors: got 0, should be 256, fixing
bcachefs (loop0): bucket 0:6 gen 0 has wrong data_type: got free, should be sb, fixing
bcachefs (loop0): bucket 0:6 gen 0 data type sb has wrong dirty_sectors: got 0, should be 256, fixing
bcachefs (loop0): bucket 0:7 gen 0 has wrong data_type: got free, should be sb, fixing
bcachefs (loop0): bucket 0:7 gen 0 data type sb has wrong dirty_sectors: got 0, should be 256, fixing
bcachefs (loop0): bucket 0:8 gen 0 has wrong data_type: got free, should be sb, fixing
bcachefs (loop0): bucket 0:8 gen 0 data type sb has wrong dirty_sectors: got 0, should be 8, fixing
bcachefs (loop0): bucket 0:9 gen 0 has wrong data_type: got free, should be journal, fixing
bcachefs (loop0): bucket 0:9 gen 0 data type journal has wrong dirty_sectors: got 0, should be 256, fixing
bcachefs (loop0): bucket 0:10 gen 0 has wrong data_type: got free, should be journal, fixing
bcachefs (loop0): bucket 0:10 gen 0 data type journal has wrong dirty_sectors: got 0, should be 256, fixing
bcachefs (loop0): bucket 0:11 gen 0 has wrong data_type: got free, should be journal, fixing
  Ratelimiting new instances of previous error
bcachefs (loop0): bucket 0:11 gen 0 data type journal has wrong dirty_sectors: got 0, should be 256, fixing
  Ratelimiting new instances of previous error
 done
bcachefs (loop0): going read-write
bcachefs (loop0): journal_replay...
------------[ cut here ]------------
kernel BUG at fs/bcachefs/btree_update.c:375!
Oops: invalid opcode: 0000 [#1] SMP KASAN NOPTI
CPU: 0 UID: 0 PID: 5324 Comm: syz.0.0 Not tainted 6.16.0-rc2-syzkaller-00082-gfb4d33ab452e #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
RIP: 0010:bch2_trans_update_by_path+0x1efb/0x1f30 fs/bcachefs/btree_update.c:375
Code: 80 e1 07 fe c1 38 c1 0f 8c 40 f7 ff ff 48 8b 7c 24 28 e8 88 5e fa fd e9 31 f7 ff ff e8 ce df 96 fd 90 0f 0b e8 c6 df 96 fd 90 <0f> 0b e8 be df 96 fd 90 0f 0b e8 b6 df 96 fd 90 0f 0b e8 ae df 96
RSP: 0018:ffffc9000d6be9c8 EFLAGS: 00010283
RAX: ffffffff84297c8a RBX: 0000000000008541 RCX: 0000000000100000
RDX: ffffc9000e002000 RSI: 00000000000b63ac RDI: 00000000000b63ad
RBP: 1ffff1100a622002 R08: ffffffff844d525f R09: 0000000000000002
R10: 0000000000000003 R11: 0000000000000002 R12: 1ffff1100a62205e
R13: ffff888053110010 R14: 0000000000000088 R15: ffff8880531102f0
FS:  00007f529748d6c0(0000) GS:ffff88808d251000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fffb9f0fabc CR3: 0000000043ca6000 CR4: 0000000000352ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 bch2_trans_update_ip+0x9a6/0x1db0 fs/bcachefs/btree_update.c:531
 bch2_trans_update fs/bcachefs/btree_update.h:123 [inline]
 bch2_journal_replay_key+0x46a/0xb10 fs/bcachefs/recovery.c:311
 bch2_journal_replay+0x1727/0x2620 fs/bcachefs/recovery.c:396
 bch2_run_recovery_pass fs/bcachefs/recovery_passes.c:485 [inline]
 __bch2_run_recovery_passes+0x395/0x1010 fs/bcachefs/recovery_passes.c:540
 bch2_run_recovery_passes+0x184/0x210 fs/bcachefs/recovery_passes.c:611
 bch2_fs_recovery+0x25fd/0x3950 fs/bcachefs/recovery.c:989
 bch2_fs_start+0xa99/0xd90 fs/bcachefs/super.c:1203
 bch2_fs_get_tree+0xb02/0x14f0 fs/bcachefs/fs.c:2489
 vfs_get_tree+0x8f/0x2b0 fs/super.c:1804
 do_new_mount+0x24a/0xa40 fs/namespace.c:3885
 do_mount fs/namespace.c:4222 [inline]
 __do_sys_mount fs/namespace.c:4433 [inline]
 __se_sys_mount+0x317/0x410 fs/namespace.c:4410
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f52965900ca
Code: d8 64 89 02 48 c7 c0 ff ff ff ff eb a6 e8 de 1a 00 00 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f529748ce68 EFLAGS: 00000246 ORIG_RAX: 00000000000000a5
RAX: ffffffffffffffda RBX: 00007f529748cef0 RCX: 00007f52965900ca
RDX: 00002000000000c0 RSI: 0000200000000080 RDI: 00007f529748ceb0
RBP: 00002000000000c0 R08: 00007f529748cef0 R09: 0000000000818001
R10: 0000000000818001 R11: 0000000000000246 R12: 0000200000000080
R13: 00007f529748ceb0 R14: 00000000000059a7 R15: 0000200000000200
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:bch2_trans_update_by_path+0x1efb/0x1f30 fs/bcachefs/btree_update.c:375
Code: 80 e1 07 fe c1 38 c1 0f 8c 40 f7 ff ff 48 8b 7c 24 28 e8 88 5e fa fd e9 31 f7 ff ff e8 ce df 96 fd 90 0f 0b e8 c6 df 96 fd 90 <0f> 0b e8 be df 96 fd 90 0f 0b e8 b6 df 96 fd 90 0f 0b e8 ae df 96
RSP: 0018:ffffc9000d6be9c8 EFLAGS: 00010283
RAX: ffffffff84297c8a RBX: 0000000000008541 RCX: 0000000000100000
RDX: ffffc9000e002000 RSI: 00000000000b63ac RDI: 00000000000b63ad
RBP: 1ffff1100a622002 R08: ffffffff844d525f R09: 0000000000000002
R10: 0000000000000003 R11: 0000000000000002 R12: 1ffff1100a62205e
R13: ffff888053110010 R14: 0000000000000088 R15: ffff8880531102f0
FS:  00007f529748d6c0(0000) GS:ffff88808d251000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fffb9f0fabc CR3: 0000000043ca6000 CR4: 0000000000352ef0
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

If you want to overwrite report's subsystems, reply with:
#syz set subsystems: new-subsystem
(See the list of subsystem names on the web dashboard)

If the report is a duplicate of another one, reply with:
#syz dup: exact-subject-of-another-report

If you want to undo deduplication, reply with:
#syz undup

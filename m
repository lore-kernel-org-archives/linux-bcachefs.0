Received: from mail-il1-f199.google.com (mail-il1-f199.google.com [209.85.166.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64C6A1F95A
	for <linux-bcachefs@vger.kernel.org>; Sun, 29 Sep 2024 07:31:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727595090; cv=none; b=Px5Tj/91Dsb5EGsGIIwXb8ic/lfX+XhqqcwtcbF2KDlzqOEMWj3XLnD3/iAHW1qF3/2vtwWWLXcBYB/JNJ5e3rsoasVZo7RfRl86zSH1kiqFLACeR08ZA5Wu7kGzL43bzd7IMRabhg1UjYtUc+lsoe7qo0Ud5vlqPKqj1gDFmD4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727595090; c=relaxed/simple;
	bh=R+dMAjlTpvWSXQlmacmnfum+6y28L9wC3XDEC8CpdAs=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=sG38iv7+dvYs/BbkoEbb3dNvZVfPhpekzqu6Nominpa6QQ9Hd+H8HmPckWTAQXy/JeXDm7UK4nk3XdCMoAPeZk+nACbZqkNh+iKtXWiakB4E0jxhLvkl/GbEvtD8ukAPtFWPSw5lyHyMvuwU0Mqa1GoAFoHQ/Tm1kpyDNR8ruVQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f199.google.com with SMTP id e9e14a558f8ab-3a342620f50so30393545ab.3
        for <linux-bcachefs@vger.kernel.org>; Sun, 29 Sep 2024 00:31:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727595087; x=1728199887;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=prVWdaKgVgcULBAx62A6Fp2zG6Ti93Dcxc/1rBbZYEU=;
        b=GjkzIy7MNjLiQ8RQCzmrf67zsxpapppa2iCjFGBUPX76NWlMV0mMlVT1YdFP4q7ZOE
         oxVPXBMir/W8aJr4RjRHXOBxW/6uNon3CVRzdAHbWG2Pggx7MlarH5Xll20nNRN5yMNv
         O8YAbzMxL9wx6WMlCxhHLDGSWr7fEv8RFxvjBmnyV9Cee5DLWgUuvQivXQlrjbJJa3ws
         5Q6E/WNyL9ChPYXVHEKLYtj1BRkrRBFJpnxIoGseJuFFw8+jM6cW8Ey2PZgem7LLaTb8
         Ee0bvHJ0mANLOTDGV38RlHZfz4GYR3cPVrgp/H3JI96B0BRo+s4JyKPkKwwSjD2alyBC
         WrhA==
X-Forwarded-Encrypted: i=1; AJvYcCVcQ2qI+dgCXMQ6+hlzhZFPBecuJZ+dd4FnVygLC36lwT59oR0pJPLxHPJo4BoVaDCvHq93AUAXYB1dpzLa+g==@vger.kernel.org
X-Gm-Message-State: AOJu0Yy1s7HTQr/soG3ZMPtALVABABpCWa5aHiMtcs/hE5ANBL4ikJv6
	OSgGM8KcCZVVtU6p1UPQTNhovoAEqIjBmg6APqSHMqSdCHxKNm69siVPUovvGangj66i3jeMwBB
	C2bsDROyVx6JiKQICu+B2Q6BUTQtn2r8Op86+ZNIbJuU3ta3fDfN1cj8=
X-Google-Smtp-Source: AGHT+IH73vO2Ysg3dbEQzFYRdP454MWmM5mukn3/TPb/507aHVzkot5LAFVgrl3jNhLoWHT44f0mkDhsxn3mjGjAUDYxjbXNv9p4
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1524:b0:3a2:7651:9876 with SMTP id
 e9e14a558f8ab-3a345178919mr65549195ab.13.1727595087538; Sun, 29 Sep 2024
 00:31:27 -0700 (PDT)
Date: Sun, 29 Sep 2024 00:31:27 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <66f9024f.050a0220.aab67.0010.GAE@google.com>
Subject: [syzbot] [bcachefs?] possible deadlock in bch2_symlink
From: syzbot <syzbot+7836a68852a10ec3d790@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    ad46e8f95e93 Merge tag 'pm-6.12-rc1-2' of git://git.kernel..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=17eb9e80580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=62086b2fd100a029
dashboard link: https://syzkaller.appspot.com/bug?extid=7836a68852a10ec3d790
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/7feb34a89c2a/non_bootable_disk-ad46e8f9.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/72b7539cbeb1/vmlinux-ad46e8f9.xz
kernel image: https://storage.googleapis.com/syzbot-assets/73c9b9cebaf4/bzImage-ad46e8f9.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+7836a68852a10ec3d790@syzkaller.appspotmail.com

loop0: detected capacity change from 0 to 32768
bcachefs (loop0): starting version 1.7: mi_btree_bitmap opts=errors=continue,compression=lz4,nojournal_transaction_names
bcachefs (loop0): recovering from clean shutdown, journal seq 7
bcachefs (loop0): Doing compatible version upgrade from 1.7: mi_btree_bitmap to 1.12: rebalance_work_acct_fix
  running recovery passes: check_allocations
invalid bkey u64s 11 type alloc_v4 0:14:0 len 0 ver 0: 
  gen 0 oldest_gen 0 data_type journal
  journal_seq       1
  need_discard      1
  need_inc_gen      1
  dirty_sectors     256
  stripe_sectors    0
  cached_sectors    0
  stripe            67108864
  stripe_redundancy 0
  io_time[READ]     1
  io_time[WRITE]    1
  fragmentation     0
  bp_start          8
  invalid data type (got 2 should be 7): delete?, fixing
bcachefs (loop0): accounting_read... done
bcachefs (loop0): alloc_read... done
bcachefs (loop0): stripes_read... done
bcachefs (loop0): snapshots_read... done
bcachefs (loop0): check_allocations...
btree ptr not marked in member info btree allocated bitmap
  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq 75277f57b0c8c24 written 32 min_key POS_MIN durability: 1 ptr: 0:26:0 gen 0, fixing
btree ptr not marked in member info btree allocated bitmap
  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq 19bc58a6c09b6540 written 24 min_key POS_MIN durability: 1 ptr: 0:38:0 gen 0, fixing
btree ptr not marked in member info btree allocated bitmap
  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c18f4a4face03c6 written 24 min_key POS_MIN durability: 1 ptr: 0:41:0 gen 0, fixing
btree ptr not marked in member info btree allocated bitmap
  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq 7675f41d391e5d36 written 16 min_key POS_MIN durability: 1 ptr: 0:35:0 gen 0, fixing
btree ptr not marked in member info btree allocated bitmap
  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq bcb9905dfb2993d5 written 16 min_key POS_MIN durability: 1 ptr: 0:32:0 gen 0, fixing
btree ptr not marked in member info btree allocated bitmap
  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq 9a831b4a3f983356 written 32 min_key POS_MIN durability: 1 ptr: 0:29:0 gen 0, fixing
bucket 0:14 gen 0 has wrong data_type: got free, should be journal, fixing
bucket 0:14 gen 0 data type journal has wrong dirty_sectors: got 0, should be 256, fixing
 done
bcachefs (loop0): going read-write
bcachefs (loop0): journal_replay... done
bcachefs (loop0): resume_logged_ops... done
bcachefs (loop0): delete_dead_inodes... done
bcachefs (loop0): Fixed errors, running fsck a second time to verify fs is clean
bcachefs (loop0): resume_logged_ops... done
bcachefs (loop0): delete_dead_inodes... done
bcachefs (loop0): done starting filesystem
============================================
WARNING: possible recursive locking detected
6.11.0-syzkaller-11728-gad46e8f95e93 #0 Not tainted
--------------------------------------------
syz.0.0/5107 is trying to acquire lock:
ffff888012fadae8 (&sb->s_type->i_mutex_key#19){++++}-{3:3}, at: inode_lock include/linux/fs.h:815 [inline]
ffff888012fadae8 (&sb->s_type->i_mutex_key#19){++++}-{3:3}, at: bch2_symlink+0x176/0x310 fs/bcachefs/fs.c:700

but task is already holding lock:
ffff888012facbf8 (&sb->s_type->i_mutex_key#19){++++}-{3:3}, at: inode_lock include/linux/fs.h:815 [inline]
ffff888012facbf8 (&sb->s_type->i_mutex_key#19){++++}-{3:3}, at: ovl_copy_up_workdir fs/overlayfs/copy_up.c:783 [inline]
ffff888012facbf8 (&sb->s_type->i_mutex_key#19){++++}-{3:3}, at: ovl_do_copy_up fs/overlayfs/copy_up.c:1002 [inline]
ffff888012facbf8 (&sb->s_type->i_mutex_key#19){++++}-{3:3}, at: ovl_copy_up_one fs/overlayfs/copy_up.c:1203 [inline]
ffff888012facbf8 (&sb->s_type->i_mutex_key#19){++++}-{3:3}, at: ovl_copy_up_flags+0x1900/0x46f0 fs/overlayfs/copy_up.c:1258

other info that might help us debug this:
 Possible unsafe locking scenario:

       CPU0
       ----
  lock(&sb->s_type->i_mutex_key#19);
  lock(&sb->s_type->i_mutex_key#19);

 *** DEADLOCK ***

 May be due to missing lock nesting notation

6 locks held by syz.0.0/5107:
 #0: ffff88804e2a6420 (sb_writers#12){.+.+}-{0:0}, at: mnt_want_write+0x3f/0x90 fs/namespace.c:515
 #1: ffff888040e71e50 (&ovl_i_mutex_dir_key[depth]/1){+.+.}-{3:3}, at: inode_lock_nested include/linux/fs.h:850 [inline]
 #1: ffff888040e71e50 (&ovl_i_mutex_dir_key[depth]/1){+.+.}-{3:3}, at: filename_create+0x260/0x540 fs/namei.c:4026
 #2: ffff888040e72418 (&ovl_i_mutex_key[depth]){+.+.}-{3:3}, at: inode_lock include/linux/fs.h:815 [inline]
 #2: ffff888040e72418 (&ovl_i_mutex_key[depth]){+.+.}-{3:3}, at: vfs_link+0x3b2/0x6e0 fs/namei.c:4730
 #3: ffff888040e727d0 (&ovl_i_lock_key[depth]){+.+.}-{3:3}, at: ovl_inode_lock_interruptible fs/overlayfs/overlayfs.h:657 [inline]
 #3: ffff888040e727d0 (&ovl_i_lock_key[depth]){+.+.}-{3:3}, at: ovl_copy_up_start+0x53/0x310 fs/overlayfs/util.c:719
 #4: ffff88804e256420 (sb_writers#11){.+.+}-{0:0}, at: ovl_copy_up_workdir fs/overlayfs/copy_up.c:782 [inline]
 #4: ffff88804e256420 (sb_writers#11){.+.+}-{0:0}, at: ovl_do_copy_up fs/overlayfs/copy_up.c:1002 [inline]
 #4: ffff88804e256420 (sb_writers#11){.+.+}-{0:0}, at: ovl_copy_up_one fs/overlayfs/copy_up.c:1203 [inline]
 #4: ffff88804e256420 (sb_writers#11){.+.+}-{0:0}, at: ovl_copy_up_flags+0x18e9/0x46f0 fs/overlayfs/copy_up.c:1258
 #5: ffff888012facbf8 (&sb->s_type->i_mutex_key#19){++++}-{3:3}, at: inode_lock include/linux/fs.h:815 [inline]
 #5: ffff888012facbf8 (&sb->s_type->i_mutex_key#19){++++}-{3:3}, at: ovl_copy_up_workdir fs/overlayfs/copy_up.c:783 [inline]
 #5: ffff888012facbf8 (&sb->s_type->i_mutex_key#19){++++}-{3:3}, at: ovl_do_copy_up fs/overlayfs/copy_up.c:1002 [inline]
 #5: ffff888012facbf8 (&sb->s_type->i_mutex_key#19){++++}-{3:3}, at: ovl_copy_up_one fs/overlayfs/copy_up.c:1203 [inline]
 #5: ffff888012facbf8 (&sb->s_type->i_mutex_key#19){++++}-{3:3}, at: ovl_copy_up_flags+0x1900/0x46f0 fs/overlayfs/copy_up.c:1258

stack backtrace:
CPU: 0 UID: 0 PID: 5107 Comm: syz.0.0 Not tainted 6.11.0-syzkaller-11728-gad46e8f95e93 #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0x241/0x360 lib/dump_stack.c:120
 print_deadlock_bug+0x483/0x620 kernel/locking/lockdep.c:3034
 check_deadlock kernel/locking/lockdep.c:3086 [inline]
 validate_chain+0x15e2/0x5920 kernel/locking/lockdep.c:3888
 __lock_acquire+0x1384/0x2050 kernel/locking/lockdep.c:5199
 lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5822
 down_write+0x99/0x220 kernel/locking/rwsem.c:1579
 inode_lock include/linux/fs.h:815 [inline]
 bch2_symlink+0x176/0x310 fs/bcachefs/fs.c:700
 vfs_symlink+0x137/0x2e0 fs/namei.c:4615
 ovl_do_symlink+0x85/0xd0 fs/overlayfs/overlayfs.h:267
 ovl_create_real+0x346/0x550 fs/overlayfs/dir.c:206
 ovl_copy_up_workdir fs/overlayfs/copy_up.c:784 [inline]
 ovl_do_copy_up fs/overlayfs/copy_up.c:1002 [inline]
 ovl_copy_up_one fs/overlayfs/copy_up.c:1203 [inline]
 ovl_copy_up_flags+0x193c/0x46f0 fs/overlayfs/copy_up.c:1258
 ovl_link+0x85/0x320 fs/overlayfs/dir.c:716
 vfs_link+0x4f0/0x6e0 fs/namei.c:4739
 do_linkat+0x555/0x6f0 fs/namei.c:4809
 __do_sys_link fs/namei.c:4843 [inline]
 __se_sys_link fs/namei.c:4841 [inline]
 __x64_sys_link+0x82/0x90 fs/namei.c:4841
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f9772d7dff9
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f9773bdf038 EFLAGS: 00000246 ORIG_RAX: 0000000000000056
RAX: ffffffffffffffda RBX: 00007f9772f36058 RCX: 00007f9772d7dff9
RDX: 0000000000000000 RSI: 0000000020000300 RDI: 0000000020000200
RBP: 00007f9772df0296 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 0000000000000000 R14: 00007f9772f36058 R15: 00007fff2ceaaba8
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

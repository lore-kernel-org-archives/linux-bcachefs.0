Received: from mail-il1-f199.google.com (mail-il1-f199.google.com [209.85.166.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A88DD17107F
	for <linux-bcachefs@vger.kernel.org>; Tue, 17 Sep 2024 16:42:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726591352; cv=none; b=lsneIund1jwKOuSjI1oucBGDXW/3wgyxZb5xFEQntNnckPvSULzdc9VaH69ah6PDdLtvgKtIUuEiVf8JIc5Aj/MV3qGfmNTIgaG2qFpz31hCKp+vMCqWiL/QW35RldRbqEuDmtqAhtWcK9Wp4ooEe211K7XBV79bUquWJ7bZvBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726591352; c=relaxed/simple;
	bh=O00U2Lw7XCTlprHN3LPFMEwtMiRuCPTFKp9WF81djpQ=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=tLsKHcXJ1YUdLKwqwZROubEg2/cIJLDtwJ8yRT4VrUC5LeqPJzMbjzbpR6VXX//VTm+9nKX9p9p0ySJJnq4pnYGAwSEXoz6D5Q9yXsn9vbWOQYFJqmDcfk78W6jSOWfxzGx6JCj4AcGjNu4G0UvZ0SPu01pHIGrCjpGjay2jrGM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f199.google.com with SMTP id e9e14a558f8ab-3a0629ed658so104007005ab.1
        for <linux-bcachefs@vger.kernel.org>; Tue, 17 Sep 2024 09:42:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726591350; x=1727196150;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=kryu4qXfYZyxDhbMn+VxtRpLP88xAziAi7S5mIPE/BU=;
        b=KTExrEjedJj81ijihf5se3n8z4nhS5XxrIDKcN4ktAtblNdEnNGE0GSeenwjw+VPp9
         E2HhuZdYgWC7a7puoRzQtBl8OZpcFbgSzVrgrGJPOblPs7lUzrBxYX1UGEqyKxgN3DGi
         yKoAylUkhKqaQS0cvK92qcHWgzYIXB4qkx0JtOkEQGVP/G6UYswhVkdx8ttCUGB9sg7K
         VFJNx1r5m7FwkDG/ffBdvFgYLjV2l+thcuLpLuG7hjHPY4kR87j4XOb0x2BU8MLz4l2c
         eWPE4MlUMmxeA6dYKT+bUbmHWFUAqeKoSioxrPZI5n8weEl+TpBYPY4KISoKTGqZdyze
         gwWA==
X-Forwarded-Encrypted: i=1; AJvYcCXJqX9YruaYeBEmQZn+QoVr3NqypIuInUnhCAqxd/V1hdzMaMO47QRYltcf4Mz/cZTRRLyjb2qxbeCX5pj0Hw==@vger.kernel.org
X-Gm-Message-State: AOJu0YzuUe63aDGdTvZWA8lHMZGF/zaXSvgPYqRnNzl0lkAsU/VSG/tW
	sLDaBDk58Iw+0INJaQ4YFYkYUO/YrQ/Zg9u9QiLxLvkvcSkhxOE1a5nP6hctl/KYUN5/2iC8RSm
	a5aGIvXc7tcPh1Jj9r4KGqMcCwEY00hn4ZMloX4gKT7x16+k23V6GoBU=
X-Google-Smtp-Source: AGHT+IHQPpLp4LtHlMcs8rT4o7wR5y1sE0QHT/rSQ+Sw38R7zshg6AfALohpyAsCgogA/yXe1J7U4/DxQOvjBWDGM0GoRLkGxGK0
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1d1a:b0:3a0:97fe:e89e with SMTP id
 e9e14a558f8ab-3a097fee929mr101867685ab.18.1726591349872; Tue, 17 Sep 2024
 09:42:29 -0700 (PDT)
Date: Tue, 17 Sep 2024 09:42:29 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000014ea2d062253601e@google.com>
Subject: [syzbot] [bcachefs?] WARNING: suspicious RCU usage in bch2_snapshot_tree_oldest_subvol
From: syzbot <syzbot+f7c41a878676b72c16a6@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    a430d95c5efa Merge tag 'lsm-pr-20240911' of git://git.kern..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=11949d00580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=1653f803fffa3848
dashboard link: https://syzkaller.appspot.com/bug?extid=f7c41a878676b72c16a6
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15c46a77980000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=13c1dc07980000

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/7bc7510fe41f/non_bootable_disk-a430d95c.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/66a65abf87c4/vmlinux-a430d95c.xz
kernel image: https://storage.googleapis.com/syzbot-assets/09c88015f9aa/bzImage-a430d95c.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/a2e2f261011a/mount_0.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+f7c41a878676b72c16a6@syzkaller.appspotmail.com

snapshot points to missing/incorrect tree:
  u64s 8 type snapshot 0:4294967295:0 len 0 ver 0: is_subvol 1 deleted 0 parent          0 children          0          0 subvol 1 tree 0, fixing
=============================
WARNING: suspicious RCU usage
6.11.0-syzkaller-02574-ga430d95c5efa #0 Not tainted
-----------------------------
fs/bcachefs/snapshot.h:45 suspicious rcu_dereference_check() usage!

other info that might help us debug this:


rcu_scheduler_active = 2, debug_locks = 1
3 locks held by syz-executor345/5099:
 #0: ffff888041400278 (&c->state_lock){+.+.}-{3:3}, at: bch2_fs_start+0x45/0x5b0 fs/bcachefs/super.c:1006
 #1: ffff8880414042c0 (&c->btree_trans_barrier){.+.+}-{0:0}, at: srcu_lock_acquire include/linux/srcu.h:151 [inline]
 #1: ffff8880414042c0 (&c->btree_trans_barrier){.+.+}-{0:0}, at: srcu_read_lock include/linux/srcu.h:250 [inline]
 #1: ffff8880414042c0 (&c->btree_trans_barrier){.+.+}-{0:0}, at: __bch2_trans_get+0x7de/0xd20 fs/bcachefs/btree_iter.c:3200
 #2: ffff88801a898128 (bcachefs_btree){+.+.}-{0:0}, at: srcu_lock_acquire include/linux/srcu.h:151 [inline]
 #2: ffff88801a898128 (bcachefs_btree){+.+.}-{0:0}, at: srcu_read_lock include/linux/srcu.h:250 [inline]
 #2: ffff88801a898128 (bcachefs_btree){+.+.}-{0:0}, at: __bch2_trans_get+0x7de/0xd20 fs/bcachefs/btree_iter.c:3200

stack backtrace:
CPU: 0 UID: 0 PID: 5099 Comm: syz-executor345 Not tainted 6.11.0-syzkaller-02574-ga430d95c5efa #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:93 [inline]
 dump_stack_lvl+0x241/0x360 lib/dump_stack.c:119
 lockdep_rcu_suspicious+0x221/0x340 kernel/locking/lockdep.c:6724
 snapshot_t fs/bcachefs/snapshot.h:45 [inline]
 bch2_snapshot_tree_oldest_subvol+0x485/0x550 fs/bcachefs/snapshot.c:473
 snapshot_tree_ptr_repair fs/bcachefs/snapshot.c:714 [inline]
 check_snapshot fs/bcachefs/snapshot.c:836 [inline]
 bch2_check_snapshots+0x3f59/0x5320 fs/bcachefs/snapshot.c:889
 bch2_run_recovery_pass+0xf0/0x1e0 fs/bcachefs/recovery_passes.c:183
 bch2_run_recovery_passes+0x19e/0x820 fs/bcachefs/recovery_passes.c:230
 bch2_fs_recovery+0x24f9/0x38b0 fs/bcachefs/recovery.c:859
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
RIP: 0033:0x7faacfc929ea
Code: d8 64 89 02 48 c7 c0 ff ff ff ff eb a6 e8 5e 04 00 00 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007faacfc47088 EFLAGS: 00000282 ORIG_RAX: 00000000000000a5
RAX: ffffffffffffffda RBX: 00007faacfc470a0 RCX: 00007faacfc929ea
RDX: 0000000020005d80 RSI: 0000000020005dc0 RDI: 00007faacfc470a0
RBP: 0000000000000004 R08: 00007faacfc470e0 R09: 0000000000005d77
R10: 0000000000000000 R11: 0000000000000282 R12: 00007faacfc470e0
R13: 0000000000000000 R14: 0000000000000003 R15: 0000000001000000
 </TASK>
 done
bcachefs (loop0): check_subvols... done
bcachefs (loop0): check_subvol_children... done
bcachefs (loop0): delete_dead_snapshots... done
bcachefs (loop0): check_inodes... done
bcachefs (loop0): check_extents... done
bcachefs (loop0): check_indirect_extents... done
bcachefs (loop0): check_dirents... done
bcachefs (loop0): check_xattrs... done
bcachefs (loop0): check_root... done
bcachefs (loop0): check_subvolume_structure... done
bcachefs (loop0): check_directory_structure... done
bcachefs (loop0): check_nlinks... done
bcachefs (loop0): resume_logged_ops... done
bcachefs (loop0): delete_dead_inodes... done
bcachefs (loop0): Fixed errors, running fsck a second time to verify fs is clean
bcachefs (loop0): check_alloc_info... done
bcachefs (loop0): check_lrus... done
bcachefs (loop0): check_btree_backpointers... done
bcachefs (loop0): check_backpointers_to_extents... done
bcachefs (loop0): check_extents_to_backpointers... done
bcachefs (loop0): check_alloc_to_lru_refs... done
bcachefs (loop0): check_snapshot_trees... done
bcachefs (loop0): check_snapshots... done
bcachefs (loop0): check_subvols... done
bcachefs (loop0): check_subvol_children... done
bcachefs (loop0): delete_dead_snapshots... done
bcachefs (loop0): check_inodes... done
bcachefs (loop0): check_extents... done
bcachefs (loop0): check_indirect_extents... done
bcachefs (loop0): check_dirents... done
bcachefs (loop0): check_xattrs... done
bcachefs (loop0): check_root... done
bcachefs (loop0): check_subvolume_structure... done
bcachefs (loop0): check_directory_structure... done
bcachefs (loop0): check_nlinks... done
bcachefs (loop0): resume_logged_ops... done
bcachefs (loop0): delete_dead_inodes... done
bcachefs (loop0): done starting filesystem
loop0: detected capacity change from 32768 to 32767
syz-executor345 (5099) used greatest stack depth: 12192 bytes left


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

Received: from mail-io1-f69.google.com (mail-io1-f69.google.com [209.85.166.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 296A419CD18
	for <linux-bcachefs@vger.kernel.org>; Tue,  9 Jul 2024 14:58:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720537106; cv=none; b=VbM+JEA3gIH9aYWkvOr+D8CQwIefUB4/GP2djD6X5gh1alUVg+N4ThHhz5FgeJDZyxR29WT16enXOM/WABDMN3D3dqrciKrJu9bNFewcrKIhZ/jTjT3zP3FcJe8WcBC3uRX79Z+pLUUDwfdiNat25uvGYl1BTSmyRozMQ87Jygg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720537106; c=relaxed/simple;
	bh=vSTCHLGuCHe7D6rcZRmdQJaq8ydwYCjHHy2ZWljf0tc=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=ROaeJfZCaoPml8gexy3KQAAaxJQacNZRa4jRADIhpG16A3Zh0tndz6rD6RVYel2nkKy7VXf6/vJLxWCfFaO20o3NPyu5pzM1C7dxfrtTLflmq+0z/8veYLGfxKYo7aLTOlDvZgDevW5UGbE3ggS8lCl+vujWsY5E2ZFcM2FUpKg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f69.google.com with SMTP id ca18e2360f4ac-7f61da4d7beso645927339f.2
        for <linux-bcachefs@vger.kernel.org>; Tue, 09 Jul 2024 07:58:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720537104; x=1721141904;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=WPJjJcj7VngdiZf+A4w3M17sKSvfb6WSVtNSm/hzGtE=;
        b=npvp7j7BLkOopNrbmPMJ+E7p804qegjtMkxu542KLBCrx3+iwHvgBcZaSai9pSoOIs
         L47pygur/VYt2rewq4KcYDZj3o9oDPCBcBtIzx9T/mTYS6wUoljzL2lsihbcGfWM5+Mz
         Vt/rgkzDQys6hzchfhZlcBPedur4my6Z89rShSqRbXOlKq+yqPJrjmeEIRjQy/9qKz5h
         26B0vYO9q5ffBlbVcCT5Bl525s+R0XAQNIG0ZunnXa3Wf+OUzBM+mrLHOs3o9hUbeF+J
         imL8f1OBOFAXvk1Ca7fudIL9XvqLDL7Rkkvkx+j9ETDd+o4/L3HmdU6q9GG6Mt/Bxr62
         ZkwA==
X-Forwarded-Encrypted: i=1; AJvYcCWx1xPhoyYXBcO1mW3y7GVwNIOH2b0apEPcSUvyhWoaIDG0MceKX3QtZ+KNz+KlChDLAezri1H5x0z7FlgXJ9LYZIj6Sy2OmpG9+HzVJB0=
X-Gm-Message-State: AOJu0YwW06NoFrpwdoo4psv3bDXYMyrBddXuYHcVxsuMffdFqvC2FPlf
	UOTv0k29EeQ8YlkTD921edz6Yd0vjz8SsBBI6gzO9f9H8IrOLbCl8yOErm419SQm/e1P4/gNACV
	tvzHFjmafE5YUC9NEPRXD6tyRggIQsxsUP8i6CV4kvW9MfafUkJAnzlQ=
X-Google-Smtp-Source: AGHT+IHgzNjjFUCHR2VKWP0iH+rBAa6ZiouYheTep8sADKHdHdLaYG7dZZ/eCb+N6aWWs1wtvYcvY8EPzMdLJ+expSBOcjBrIxrF
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6638:710a:b0:4b9:def5:3dcb with SMTP id
 8926c6da1cb9f-4c0b29ba495mr248148173.2.1720537104398; Tue, 09 Jul 2024
 07:58:24 -0700 (PDT)
Date: Tue, 09 Jul 2024 07:58:24 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000ee4d7c061cd1c21f@google.com>
Subject: [syzbot] [bcachefs?] WARNING: suspicious RCU usage in bch2_bucket_ref_update
From: syzbot <syzbot+e74fea078710bbca6f4b@syzkaller.appspotmail.com>
To: bfoster@redhat.com, kent.overstreet@linux.dev, 
	linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    256abd8e550c Linux 6.10-rc7
git tree:       upstream
console+strace: https://syzkaller.appspot.com/x/log.txt?x=1606fe6e980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=42a432cfd0e579e0
dashboard link: https://syzkaller.appspot.com/bug?extid=e74fea078710bbca6f4b
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=119422a5980000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=15869b76980000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/49b114b276ef/disk-256abd8e.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/ef1a6b8836ca/vmlinux-256abd8e.xz
kernel image: https://storage.googleapis.com/syzbot-assets/4c81ede104a4/bzImage-256abd8e.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/99b2b0c25d67/mount_0.gz

The issue was bisected to:

commit f7643bc9749f270d487c32dc35b578575bf1adb0
Author: Kent Overstreet <kent.overstreet@linux.dev>
Date:   Wed Apr 17 05:26:02 2024 +0000

    bcachefs: make btree read errors silent during scan

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=12c7687e980000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=11c7687e980000
console output: https://syzkaller.appspot.com/x/log.txt?x=16c7687e980000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+e74fea078710bbca6f4b@syzkaller.appspotmail.com
Fixes: f7643bc9749f ("bcachefs: make btree read errors silent during scan")

bcachefs (loop0): done starting filesystem
=============================
WARNING: suspicious RCU usage
6.10.0-rc7-syzkaller #0 Not tainted
-----------------------------
fs/bcachefs/buckets.h:107 suspicious rcu_dereference_check() usage!

other info that might help us debug this:


rcu_scheduler_active = 2, debug_locks = 1
9 locks held by syz-executor107/5084:
 #0: ffff88807441c420 (sb_writers#9){.+.+}-{0:0}, at: mnt_want_write+0x3f/0x90 fs/namespace.c:409
 #1: ffff88807441c730 (&type->s_vfs_rename_key){+.+.}-{3:3}, at: lock_rename fs/namei.c:3078 [inline]
 #1: ffff88807441c730 (&type->s_vfs_rename_key){+.+.}-{3:3}, at: do_renameat2+0x5cf/0x13f0 fs/namei.c:4985
 #2: ffff88807a278150 (&type->i_mutex_dir_key#6/1){+.+.}-{3:3}, at: inode_lock_nested include/linux/fs.h:826 [inline]
 #2: ffff88807a278150 (&type->i_mutex_dir_key#6/1){+.+.}-{3:3}, at: lock_two_directories+0x145/0x220 fs/namei.c:3044
 #3: ffff88807a2788b8 (&type->i_mutex_dir_key#6/5){+.+.}-{3:3}, at: inode_lock_nested include/linux/fs.h:826 [inline]
 #3: ffff88807a2788b8 (&type->i_mutex_dir_key#6/5){+.+.}-{3:3}, at: lock_two_directories+0x16f/0x220 fs/namei.c:3045
 #4: ffff888077f842d8 (&c->btree_trans_barrier){.+.+}-{0:0}, at: srcu_lock_acquire include/linux/srcu.h:116 [inline]
 #4: ffff888077f842d8 (&c->btree_trans_barrier){.+.+}-{0:0}, at: srcu_read_lock include/linux/srcu.h:215 [inline]
 #4: ffff888077f842d8 (&c->btree_trans_barrier){.+.+}-{0:0}, at: __bch2_trans_get+0x840/0xce0 fs/bcachefs/btree_iter.c:3193
 #5: ffff88802fc93070 (&dev->mutex){....}-{3:3}, at: six_relock_type fs/bcachefs/six.h:289 [inline]
 #5: ffff88802fc93070 (&dev->mutex){....}-{3:3}, at: __bch2_btree_node_relock+0x142/0x9c0 fs/bcachefs/btree_locking.c:507
 #6: ffff88802fc93070 (&dev->mutex){....}-{3:3}, at: btree_node_lock_increment fs/bcachefs/btree_locking.h:248 [inline]
 #6: ffff88802fc93070 (&dev->mutex){....}-{3:3}, at: __bch2_btree_node_relock+0x675/0x9c0 fs/bcachefs/btree_locking.c:509
 #7: ffff88807a0db340 (&dev->mutex){....}-{3:3}, at: six_relock_type fs/bcachefs/six.h:289 [inline]
 #7: ffff88807a0db340 (&dev->mutex){....}-{3:3}, at: __bch2_btree_node_relock+0x142/0x9c0 fs/bcachefs/btree_locking.c:507
 #8: ffff88802b279870 (&dev->mutex){....}-{3:3}, at: six_relock_type fs/bcachefs/six.h:289 [inline]
 #8: ffff88802b279870 (&dev->mutex){....}-{3:3}, at: __bch2_btree_node_relock+0x142/0x9c0 fs/bcachefs/btree_locking.c:507

stack backtrace:
CPU: 0 PID: 5084 Comm: syz-executor107 Not tainted 6.10.0-rc7-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 06/07/2024
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0x241/0x360 lib/dump_stack.c:114
 lockdep_rcu_suspicious+0x221/0x340 kernel/locking/lockdep.c:6712
 bucket_gens fs/bcachefs/buckets.h:103 [inline]
 bucket_gen fs/bcachefs/buckets.h:112 [inline]
 bch2_bucket_ref_update+0xbe1/0x1100 fs/bcachefs/buckets.c:808
 __mark_pointer fs/bcachefs/buckets.c:1000 [inline]
 bch2_trigger_pointer fs/bcachefs/buckets.c:1037 [inline]
 __trigger_extent+0x1524/0x6260 fs/bcachefs/buckets.c:1176
 bch2_trigger_extent+0x636/0x920 fs/bcachefs/buckets.c:1261
 bch2_key_trigger fs/bcachefs/bkey_methods.h:88 [inline]
 bch2_key_trigger_old fs/bcachefs/bkey_methods.h:102 [inline]
 run_one_trans_trigger fs/bcachefs/btree_trans_commit.c:514 [inline]
 run_btree_triggers+0xadb/0x11d0 fs/bcachefs/btree_trans_commit.c:544
 bch2_trans_commit_run_triggers fs/bcachefs/btree_trans_commit.c:576 [inline]
 __bch2_trans_commit+0x3a6/0x88e0 fs/bcachefs/btree_trans_commit.c:1022
 bch2_trans_commit fs/bcachefs/btree_update.h:170 [inline]
 bch2_inode_delete_keys+0xae8/0x1440 fs/bcachefs/inode.c:845
 bch2_inode_rm+0x165/0xd40 fs/bcachefs/inode.c:874
 bch2_evict_inode+0x21c/0x3c0 fs/bcachefs/fs.c:1588
 evict+0x2a8/0x630 fs/inode.c:667
 __dentry_kill+0x20d/0x630 fs/dcache.c:603
 dput+0x19f/0x2b0 fs/dcache.c:845
 do_renameat2+0xda1/0x13f0 fs/namei.c:5052
 __do_sys_renameat2 fs/namei.c:5084 [inline]
 __se_sys_renameat2 fs/namei.c:5081 [inline]
 __x64_sys_renameat2+0xd2/0xf0 fs/namei.c:5081
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f491fe4ad59
Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 f1 17 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fff84583f28 EFLAGS: 00000246 ORIG_RAX: 000000000000013c
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f491fe4ad59
RDX: 0000000000000004 RSI: 0000000020000080 RDI: 00000000ffffff9c
RBP: 00007f491fec45f0 R08: 0000000000000000 R09: 000055555e2ff4c0
R10: 0000000020000980 R11: 0000000000000246 R12: 00007fff84583f50
R13: 00007fff84584178 R14: 431bde82d7b634db R15: 00007f491fe9403b
 </TASK>
bucket 0:34 gen 7 (mem gen 0) data type user: stale dirty ptr (gen 0)
while marking u64s 7 type extent 536870913:8:U32_MAX len 8 ver 0: durability: 1 crc: c_size 8 size 8 offset 0 nonce 0 csum crc32c compress incompressible ptr: 0:34:0 gen 0, shutting down
bcachefs (loop0): inconsistency detected - emergency read only at journal seq 11
syz-executor107 (5084) used greatest stack depth: 18488 bytes left


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

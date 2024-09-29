Received: from mail-il1-f199.google.com (mail-il1-f199.google.com [209.85.166.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1E72F9CB
	for <linux-bcachefs@vger.kernel.org>; Sun, 29 Sep 2024 16:17:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727626653; cv=none; b=BnLFl93Pmm+SCj2f6hresoj+eluoJDFdQRvLhsAGPh7PRQEB1EjK0w7SqR7aUx2ZkGhC9tw1SMDBAeBkHAJrsQtSyprgemX3y1V0R+oT4DCdUAFglzsde/CRM/G4BFeKKRWP3e68cDOjCpwgzDtaGSjXqe4JqJc14GN59V3A/C4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727626653; c=relaxed/simple;
	bh=k8NXOyMsWQAD5a3hs3ZVeALAHMwKQjzLJ791Q2lg9wI=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=M/clwebqzDFKRlSkPlPgVZVAJkUMcRdrfjdspJYBo64eSe78VlskPHRW3y9WVV741emhRnq8aHHJ15HfHQwnaWQsPON0/z2rE7MWqtKKSu1YGUGmcjzM406a3uzttVT69m9zTZLqG7oujXMxE1EckK09zvGcwQHcT97mOzVkwj4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f199.google.com with SMTP id e9e14a558f8ab-3a19534ac2fso52501465ab.2
        for <linux-bcachefs@vger.kernel.org>; Sun, 29 Sep 2024 09:17:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727626651; x=1728231451;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=PyikQQfIDGxtwVPQfab24lvxnKgbV99eRP3XmaKomBM=;
        b=mgqDZx3CvT2up9v31fAHVWUq0AWdON88DSLOiOe6WmV7SvDBwymBErCx9W5EO7k/Je
         r7cXEPBfQGVq+1IX7c22f4/5CBLhTBavOPNG/5VWoQaQhOBd22c/Aj6P9faptUC16GBh
         ebuWEct67tMXQ0bOOGF+bhoDRXpi19rWvGM9Qtgy+NY6rLVD6n8wMnMzNCCckm5RWPS5
         gNGguWDupFFyXWrQFz3PaPB+r4iZKAa/b4crFPwpMLGa8sLI7X8yv8hxC77O8ZlOUQeM
         LXJ/vdzOZI3kJg/kk2ZIJyRs6cVJyFaScxnn4BsZrDOt81gJ5vbMTlXJR5jYAVslEVpg
         XFAw==
X-Forwarded-Encrypted: i=1; AJvYcCV/qwNNmtt/FkhTz1vxbr/2L/IpwIpvjW19RO48IgAWEn4igiHEgXRyGNBGZap5G7XFp+DD/c0uciTj9Ya3fw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yy592NVx0cem3YcIL44S5hk5mDTE8/Cytm/6QVEmgh+01RPdMd8
	VOIfauTOqUSF8TpO5otAkbjJyx9sT6zmGTcP5bxUGM4mktLntkQWMTjTtxtXajmWmhFReWiUVoP
	pUMAQTlBPJ1I4hZi17mGT88zpTmXG/jsgWzqDLCMKxLxt2LP5bQeb9GQ=
X-Google-Smtp-Source: AGHT+IEjPaqQX7Gyca/pqAUM0VEKV1ihnLjf8SH5hmQY5QucOkr0RSXUxnJg5hRltiNwYzsc1exOUan6rxU31b1NQErmNRWpQQIr
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a92:ca06:0:b0:3a2:f7b1:2f89 with SMTP id
 e9e14a558f8ab-3a3451bbf5amr72695195ab.18.1727626650871; Sun, 29 Sep 2024
 09:17:30 -0700 (PDT)
Date: Sun, 29 Sep 2024 09:17:30 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <66f97d9a.050a0220.6bad9.001d.GAE@google.com>
Subject: [syzbot] [bcachefs?] possible deadlock in pcpu_alloc_noprof
From: syzbot <syzbot+fe63f377148a6371a9db@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    684a64bf32b6 Merge tag 'nfs-for-6.12-1' of git://git.linux..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=14c6a99f980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=bd75e1a00004094f
dashboard link: https://syzkaller.appspot.com/bug?extid=fe63f377148a6371a9db
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/7bc7510fe41f/non_bootable_disk-684a64bf.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/f05b4b08a420/vmlinux-684a64bf.xz
kernel image: https://storage.googleapis.com/syzbot-assets/d59f9edaf3bc/bzImage-684a64bf.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+fe63f377148a6371a9db@syzkaller.appspotmail.com

netlink: 'syz.0.0': attribute type 1 has an invalid length.
netlink: 9364 bytes leftover after parsing attributes in process `syz.0.0'.
netlink: 'syz.0.0': attribute type 1 has an invalid length.
loop0: detected capacity change from 0 to 32768
bcachefs (loop0): starting version 1.7: mi_btree_bitmap opts=errors=continue,compression=lz4,no_splitbrain_check,norecovery,recovery_pass_last=check_dirents,reconstruct_alloc
bcachefs (loop0): recovering from clean shutdown, journal seq 7
bcachefs (loop0): Doing compatible version upgrade from 1.7: mi_btree_bitmap to 1.12: rebalance_work_acct_fix
  running recovery passes: check_allocations
bcachefs (loop0): dropping and reconstructing all alloc info
bcachefs (loop0): accounting_read... done
bcachefs (loop0): alloc_read... done
bcachefs (loop0): stripes_read... done
bcachefs (loop0): snapshots_read... done
bcachefs (loop0): check_allocations...
btree ptr not marked in member info btree allocated bitmap
  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq 19bc58a6c09b6540 written 24 min_key POS_MIN durability: 1 ptr: 0:38:0 gen 0, fixing
btree ptr not marked in member info btree allocated bitmap
  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c18f4a4face03c6 written 24 min_key POS_MIN durability: 1 ptr: 0:41:0 gen 0, fixing
btree ptr not marked in member info btree allocated bitmap
  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq 7675f41d391e5d36 written 16 min_key POS_MIN durability: 1 ptr: 0:35:0 gen 0, fixing
btree ptr not marked in member info btree allocated bitmap
  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq bcb9905dfb2993d5 written 16 min_key POS_MIN durability: 1 ptr: 0:32:0 gen 0, fixing
bucket 0:34 gen 0 data type user has wrong fragmentation_lru: got 0, should be 67108864, fixing
bucket 0:36 gen 0 data type user has wrong fragmentation_lru: got 0, should be 67108864, fixing
 done
bcachefs (loop0): going read-write
bcachefs (loop0): Fixed errors, running fsck a second time to verify fs is clean
bcachefs (loop0): done starting filesystem
======================================================
WARNING: possible circular locking dependency detected
6.11.0-syzkaller-10547-g684a64bf32b6 #0 Not tainted
------------------------------------------------------
syz.0.0/5104 is trying to acquire lock:
ffffffff8ea171e8 (pcpu_alloc_mutex){+.+.}-{3:3}, at: pcpu_alloc_noprof+0x27f/0x16e0 mm/percpu.c:1795

but task is already holding lock:
ffff88804b901c50 (&bc->lock){+.+.}-{3:3}, at: bch2_btree_node_mem_alloc+0x4ec/0x1340 fs/bcachefs/btree_cache.c:782

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #2 (&bc->lock){+.+.}-{3:3}:
       lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5822
       __mutex_lock_common kernel/locking/mutex.c:608 [inline]
       __mutex_lock+0x136/0xd70 kernel/locking/mutex.c:752
       bch2_btree_cache_scan+0x192/0xd00 fs/bcachefs/btree_cache.c:460
       do_shrink_slab+0x701/0x1160 mm/shrinker.c:435
       shrink_slab+0x1093/0x14d0 mm/shrinker.c:662
       shrink_one+0x43b/0x850 mm/vmscan.c:4818
       shrink_many mm/vmscan.c:4879 [inline]
       lru_gen_shrink_node mm/vmscan.c:4957 [inline]
       shrink_node+0x3799/0x3de0 mm/vmscan.c:5937
       kswapd_shrink_node mm/vmscan.c:6765 [inline]
       balance_pgdat mm/vmscan.c:6957 [inline]
       kswapd+0x1ca3/0x3700 mm/vmscan.c:7226
       kthread+0x2f0/0x390 kernel/kthread.c:389
       ret_from_fork+0x4b/0x80 arch/x86/kernel/process.c:147
       ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244

-> #1 (fs_reclaim){+.+.}-{0:0}:
       lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5822
       __fs_reclaim_acquire mm/page_alloc.c:3834 [inline]
       fs_reclaim_acquire+0x88/0x140 mm/page_alloc.c:3848
       might_alloc include/linux/sched/mm.h:327 [inline]
       slab_pre_alloc_hook mm/slub.c:4037 [inline]
       slab_alloc_node mm/slub.c:4115 [inline]
       __do_kmalloc_node mm/slub.c:4264 [inline]
       __kmalloc_noprof+0xa9/0x400 mm/slub.c:4277
       kmalloc_noprof include/linux/slab.h:882 [inline]
       kzalloc_noprof include/linux/slab.h:1014 [inline]
       pcpu_mem_zalloc mm/percpu.c:510 [inline]
       pcpu_alloc_chunk mm/percpu.c:1443 [inline]
       pcpu_create_chunk+0x57/0xbc0 mm/percpu-vm.c:338
       pcpu_balance_populated mm/percpu.c:2075 [inline]
       pcpu_balance_workfn+0xc4d/0xd40 mm/percpu.c:2212
       process_one_work kernel/workqueue.c:3229 [inline]
       process_scheduled_works+0xa63/0x1850 kernel/workqueue.c:3310
       worker_thread+0x870/0xd30 kernel/workqueue.c:3391
       kthread+0x2f0/0x390 kernel/kthread.c:389
       ret_from_fork+0x4b/0x80 arch/x86/kernel/process.c:147
       ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244

-> #0 (pcpu_alloc_mutex){+.+.}-{3:3}:
       check_prev_add kernel/locking/lockdep.c:3158 [inline]
       check_prevs_add kernel/locking/lockdep.c:3277 [inline]
       validate_chain+0x18ef/0x5920 kernel/locking/lockdep.c:3901
       __lock_acquire+0x1384/0x2050 kernel/locking/lockdep.c:5199
       lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5822
       __mutex_lock_common kernel/locking/mutex.c:608 [inline]
       __mutex_lock+0x136/0xd70 kernel/locking/mutex.c:752
       pcpu_alloc_noprof+0x27f/0x16e0 mm/percpu.c:1795
       __six_lock_init+0x104/0x150 fs/bcachefs/six.c:863
       bch2_btree_lock_init+0x38/0x100 fs/bcachefs/btree_locking.c:12
       bch2_btree_node_mem_alloc+0x4f8/0x1340 fs/bcachefs/btree_cache.c:785
       __bch2_btree_node_alloc fs/bcachefs/btree_update_interior.c:325 [inline]
       bch2_btree_reserve_get+0x2df/0x1890 fs/bcachefs/btree_update_interior.c:554
       bch2_btree_update_start+0xe56/0x14e0 fs/bcachefs/btree_update_interior.c:1252
       bch2_btree_split_leaf+0x123/0x840 fs/bcachefs/btree_update_interior.c:1850
       bch2_trans_commit_error+0x212/0x1390 fs/bcachefs/btree_trans_commit.c:903
       __bch2_trans_commit+0x286e/0x9130 fs/bcachefs/btree_trans_commit.c:1135
       bch2_trans_commit fs/bcachefs/btree_update.h:184 [inline]
       bch2_logged_op_start+0x1c8/0x310 fs/bcachefs/logged_ops.c:83
       bch2_truncate+0x1a5/0x2c0 fs/bcachefs/io_misc.c:291
       bchfs_truncate+0x965/0xc70 fs/bcachefs/fs-io.c:464
       notify_change+0xbca/0xe90 fs/attr.c:503
       do_truncate+0x220/0x310 fs/open.c:65
       handle_truncate fs/namei.c:3395 [inline]
       do_open fs/namei.c:3778 [inline]
       path_openat+0x2e1e/0x3590 fs/namei.c:3933
       do_filp_open+0x235/0x490 fs/namei.c:3960
       do_sys_openat2+0x13e/0x1d0 fs/open.c:1415
       do_sys_open fs/open.c:1430 [inline]
       __do_sys_openat fs/open.c:1446 [inline]
       __se_sys_openat fs/open.c:1441 [inline]
       __x64_sys_openat+0x247/0x2a0 fs/open.c:1441
       do_syscall_x64 arch/x86/entry/common.c:52 [inline]
       do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

other info that might help us debug this:

Chain exists of:
  pcpu_alloc_mutex --> fs_reclaim --> &bc->lock

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(&bc->lock);
                               lock(fs_reclaim);
                               lock(&bc->lock);
  lock(pcpu_alloc_mutex);

 *** DEADLOCK ***

6 locks held by syz.0.0/5104:
 #0: ffff88804e51c420 (sb_writers#11){.+.+}-{0:0}, at: mnt_want_write+0x3f/0x90 fs/namespace.c:515
 #1: ffff88804d1e9038 (&sb->s_type->i_mutex_key#19){++++}-{3:3}, at: inode_lock include/linux/fs.h:815 [inline]
 #1: ffff88804d1e9038 (&sb->s_type->i_mutex_key#19){++++}-{3:3}, at: do_truncate+0x20c/0x310 fs/open.c:63
 #2: ffff88804b900a38 (&c->snapshot_create_lock){.+.+}-{3:3}, at: bch2_truncate+0x16d/0x2c0 fs/bcachefs/io_misc.c:290
 #3: ffff88804b904398 (&c->btree_trans_barrier){.+.+}-{0:0}, at: srcu_lock_acquire include/linux/srcu.h:151 [inline]
 #3: ffff88804b904398 (&c->btree_trans_barrier){.+.+}-{0:0}, at: srcu_read_lock include/linux/srcu.h:250 [inline]
 #3: ffff88804b904398 (&c->btree_trans_barrier){.+.+}-{0:0}, at: __bch2_trans_get+0x7de/0xd20 fs/bcachefs/btree_iter.c:3215
 #4: ffff88804b9266d0 (&c->gc_lock){++++}-{3:3}, at: bch2_btree_update_start+0x682/0x14e0 fs/bcachefs/btree_update_interior.c:1202
 #5: ffff88804b901c50 (&bc->lock){+.+.}-{3:3}, at: bch2_btree_node_mem_alloc+0x4ec/0x1340 fs/bcachefs/btree_cache.c:782

stack backtrace:
CPU: 0 UID: 0 PID: 5104 Comm: syz.0.0 Not tainted 6.11.0-syzkaller-10547-g684a64bf32b6 #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0x241/0x360 lib/dump_stack.c:120
 print_circular_bug+0x13a/0x1b0 kernel/locking/lockdep.c:2074
 check_noncircular+0x36a/0x4a0 kernel/locking/lockdep.c:2203
 check_prev_add kernel/locking/lockdep.c:3158 [inline]
 check_prevs_add kernel/locking/lockdep.c:3277 [inline]
 validate_chain+0x18ef/0x5920 kernel/locking/lockdep.c:3901
 __lock_acquire+0x1384/0x2050 kernel/locking/lockdep.c:5199
 lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5822
 __mutex_lock_common kernel/locking/mutex.c:608 [inline]
 __mutex_lock+0x136/0xd70 kernel/locking/mutex.c:752
 pcpu_alloc_noprof+0x27f/0x16e0 mm/percpu.c:1795
 __six_lock_init+0x104/0x150 fs/bcachefs/six.c:863
 bch2_btree_lock_init+0x38/0x100 fs/bcachefs/btree_locking.c:12
 bch2_btree_node_mem_alloc+0x4f8/0x1340 fs/bcachefs/btree_cache.c:785
 __bch2_btree_node_alloc fs/bcachefs/btree_update_interior.c:325 [inline]
 bch2_btree_reserve_get+0x2df/0x1890 fs/bcachefs/btree_update_interior.c:554
 bch2_btree_update_start+0xe56/0x14e0 fs/bcachefs/btree_update_interior.c:1252
 bch2_btree_split_leaf+0x123/0x840 fs/bcachefs/btree_update_interior.c:1850
 bch2_trans_commit_error+0x212/0x1390 fs/bcachefs/btree_trans_commit.c:903
 __bch2_trans_commit+0x286e/0x9130 fs/bcachefs/btree_trans_commit.c:1135
 bch2_trans_commit fs/bcachefs/btree_update.h:184 [inline]
 bch2_logged_op_start+0x1c8/0x310 fs/bcachefs/logged_ops.c:83
 bch2_truncate+0x1a5/0x2c0 fs/bcachefs/io_misc.c:291
 bchfs_truncate+0x965/0xc70 fs/bcachefs/fs-io.c:464
 notify_change+0xbca/0xe90 fs/attr.c:503
 do_truncate+0x220/0x310 fs/open.c:65
 handle_truncate fs/namei.c:3395 [inline]
 do_open fs/namei.c:3778 [inline]
 path_openat+0x2e1e/0x3590 fs/namei.c:3933
 do_filp_open+0x235/0x490 fs/namei.c:3960
 do_sys_openat2+0x13e/0x1d0 fs/open.c:1415
 do_sys_open fs/open.c:1430 [inline]
 __do_sys_openat fs/open.c:1446 [inline]
 __se_sys_openat fs/open.c:1441 [inline]
 __x64_sys_openat+0x247/0x2a0 fs/open.c:1441
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f4a4bf7df39
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f4a4cdf8038 EFLAGS: 00000246 ORIG_RAX: 0000000000000101
RAX: ffffffffffffffda RBX: 00007f4a4c135f80 RCX: 00007f4a4bf7df39
RDX: 0000000000000300 RSI: 0000000020000300 RDI: ffffffffffffff9c
RBP: 00007f4a4bff0b76 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 0000000000000000 R14: 00007f4a4c135f80 R15: 00007fff8cf7cfa8
 </TASK>
bucket 0:34 gen 0 data type user sector count overflow: 0 + -8 > U32_MAX
while marking u64s 7 type extent 536870913:8:U32_MAX len 8 ver 0: durability: 1 crc: c_size 8 size 8 offset 0 nonce 0 csum crc32c 0:cec3872e  compress incompressible ptr: 0:34:0 gen 0, continuing
bucket 0:34 gen 0 data type user sector count overflow: 0 + -8 > U32_MAX
while marking u64s 7 type extent 536870913:8:U32_MAX len 8 ver 0: durability: 1 crc: c_size 8 size 8 offset 0 nonce 0 csum crc32c 0:cec3872e  compress incompressible ptr: 0:34:0 gen 0, continuing
bucket 0:34 gen 0 data type user sector count overflow: 0 + -8 > U32_MAX
while marking u64s 7 type extent 536870913:8:U32_MAX len 8 ver 0: durability: 1 crc: c_size 8 size 8 offset 0 nonce 0 csum crc32c 0:cec3872e  compress incompressible ptr: 0:34:0 gen 0, continuing
syz.0.0 (5104) used greatest stack depth: 6384 bytes left


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

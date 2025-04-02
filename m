Received: from mail-il1-f206.google.com (mail-il1-f206.google.com [209.85.166.206])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05293D299
	for <linux-bcachefs@vger.kernel.org>; Wed,  2 Apr 2025 00:00:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.206
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743552023; cv=none; b=VNEXF+XyjNzBi5qC8zk4EcKExeaSAv1+gN8oEuibgZ3QqGMM6OfJEuirHaugXuMhOHj4GZXJ9qHnlm9vskq4B6crCVE04v2SDChKm/WtKkyn8HDZ7DIb9v8q15kh3UWO2q77qUepBLcWeNA1ikh5RpobMGgbZdDce31nM+3BMOU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743552023; c=relaxed/simple;
	bh=cJxkda7Gx5YVBJViSDIl6CFdsXsvGC+94JzbWEpkWTM=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=YiFyovuyggfygx/2atwQwWeKpCm1u8Oo/LEKCvKbWI4FdDQzDejmlIr8WrtzFbl+RX2YCAEuJbQpc2NXSzV0RMfkndid6jrqYWa7rYBtokO7cFSWLB7c+MTYBxVn5nytxkHXH6FgWAH8Hy9/wU5naqHUt6M3OwnGRyEO9LyzqXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.206
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f206.google.com with SMTP id e9e14a558f8ab-3d5da4fb5e0so47144045ab.2
        for <linux-bcachefs@vger.kernel.org>; Tue, 01 Apr 2025 17:00:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743552020; x=1744156820;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=OaNey3U9DjWvymRTTPA4aTMvYHymOcXePWEHX2t7R6A=;
        b=Bz/Or4WdW4PPfuS6NX8HJbOKNuZA9d3JaXa+ecUr/5IE+1TtFv2jhMV27FXcf2po71
         c/2jv2RWEfIJLjUG16zVPHAp/psV/kGjP4EUO7WX4BZPDBonDHwKQyaOlw2Ew+/NORRI
         BMU9qNqgaKw2x6/JjqtkgvEMayyZhefDNGty5vp20CAcPejeETO8BBmMoltYH5PYCLUM
         y85EddKzjMA2W/CEErpYIdkuejF8DsGUmZUJINXEqfZUbVnnu83ovILepDOrDEJYrBBz
         khDpkYjuIOB5hfD6fkdzvlmuSX17M09+PFdWo80IG+Bnq9NdAT8ix7aaR5SZxPyR/SNt
         a5hw==
X-Forwarded-Encrypted: i=1; AJvYcCWAjR64TSNIZTZMr4xnQ8auZD7cXTBWTDiHluv6pmhtjDWV/B0ZTpvkxXXcDmHHCYGg/mJO2XqJJgp4KDPXIg==@vger.kernel.org
X-Gm-Message-State: AOJu0YwdZpYr4wN2YEPnx4wTrb7pwEUIED+YtGo1dQlG+wDPLdXG+V3Y
	qP7oyiMpJAJA0C2fAyajqEYMYciFeDEmOVhjbtjNEfAtCVVmDUk78JbgQ1NFS657W2pd4EZ9uw0
	1AKncesWrXYsHWLCEQj6Q6SSTSa1yGqIK9pY2OoJyg/3n2NOK1k5LIYc=
X-Google-Smtp-Source: AGHT+IGINzhe34NdLtrWSNq6aybwx4SoRt5Fphr4N5XRLH25tUIMoRoXqNmuEhtzDDSZR3JyOc4eodMvxonYv+EIW+eUuZTqTgHv
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:184e:b0:3d0:4e57:bbda with SMTP id
 e9e14a558f8ab-3d5e08eacfbmr186247725ab.1.1743552020068; Tue, 01 Apr 2025
 17:00:20 -0700 (PDT)
Date: Tue, 01 Apr 2025 17:00:20 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <67ec7e14.050a0220.31979b.002f.GAE@google.com>
Subject: [syzbot] [bcachefs?] BUG: sleeping function called from invalid
 context in bch2_printbuf_make_room (2)
From: syzbot <syzbot+c82cd2906e2f192410bb@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    08733088b566 Merge tag 'rust-fixes-6.15-merge' of git://gi..
git tree:       upstream
console+strace: https://syzkaller.appspot.com/x/log.txt?x=132cfbcf980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=acce2ca43d1e8c46
dashboard link: https://syzkaller.appspot.com/bug?extid=c82cd2906e2f192410bb
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=110f1404580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1794b7b0580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/89e502f70725/disk-08733088.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/a8fe89a101eb/vmlinux-08733088.xz
kernel image: https://storage.googleapis.com/syzbot-assets/6d559e3eea04/bzImage-08733088.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/58c2eae09840/mount_0.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+c82cd2906e2f192410bb@syzkaller.appspotmail.com

  node offset 8/24 bset u64s 375 bset byte offset 184: keys out of order: u64s 11 type alloc_v4 0:32:0 len 0 ver 0 > u64s 11 type alloc_v4 0:2:0 len 0 ver 0, fixing
bcachefs (loop0): btree_node_read_work: rewriting btree node at due to error
  btree=alloc level=0 u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq ac62141f8dc7e261 written 24 min_key POS_MIN durability: 1 ptr: 0:26:0 gen 0
BUG: sleeping function called from invalid context at ./include/linux/sched/mm.h:321
in_atomic(): 0, irqs_disabled(): 0, non_block: 0, pid: 5828, name: syz-executor246
preempt_count: 0, expected: 0
RCU nest depth: 1, expected: 0
3 locks held by syz-executor246/5828:
 #0: ffff88807ad6a0e0 (&type->s_umount_key#42/1){+.+.}-{4:4}, at: alloc_super+0x221/0x9d0 fs/super.c:344
 #1: ffff888075a84210 (&c->btree_trans_barrier){.+.+}-{0:0}, at: srcu_lock_acquire include/linux/srcu.h:161 [inline]
 #1: ffff888075a84210 (&c->btree_trans_barrier){.+.+}-{0:0}, at: srcu_read_lock include/linux/srcu.h:253 [inline]
 #1: ffff888075a84210 (&c->btree_trans_barrier){.+.+}-{0:0}, at: __bch2_trans_get+0x7ed/0xd40 fs/bcachefs/btree_iter.c:3386
 #2: ffffffff8ed3b560 (rcu_read_lock){....}-{1:3}, at: rcu_lock_acquire include/linux/rcupdate.h:331 [inline]
 #2: ffffffff8ed3b560 (rcu_read_lock){....}-{1:3}, at: rcu_read_lock include/linux/rcupdate.h:841 [inline]
 #2: ffffffff8ed3b560 (rcu_read_lock){....}-{1:3}, at: bch2_bkey_pick_read_device+0x29c/0x19b0 fs/bcachefs/extents.c:144
CPU: 0 UID: 0 PID: 5828 Comm: syz-executor246 Not tainted 6.14.0-syzkaller-11270-g08733088b566 #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 02/12/2025
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0x241/0x360 lib/dump_stack.c:120
 __might_resched+0x558/0x6c0 kernel/sched/core.c:8818
 might_alloc include/linux/sched/mm.h:321 [inline]
 slab_pre_alloc_hook mm/slub.c:4089 [inline]
 slab_alloc_node mm/slub.c:4167 [inline]
 __do_kmalloc_node mm/slub.c:4317 [inline]
 __kmalloc_node_track_caller_noprof+0xd3/0x4d0 mm/slub.c:4337
 __do_krealloc mm/slub.c:4895 [inline]
 krealloc_noprof+0x10f/0x300 mm/slub.c:4948
 bch2_printbuf_make_room+0x1f1/0x350 fs/bcachefs/printbuf.c:59
 bch2_prt_printf+0x269/0x6d0 fs/bcachefs/printbuf.c:186
 bch2_log_msg_start fs/bcachefs/error.c:19 [inline]
 bch2_fs_trans_inconsistent fs/bcachefs/error.c:63 [inline]
 bch2_fs_inconsistent+0x143/0x220 fs/bcachefs/error.c:81
 bch2_dev_rcu fs/bcachefs/sb-members.h:226 [inline]
 bch2_bkey_pick_read_device+0x95e/0x19b0 fs/bcachefs/extents.c:165
 bch2_btree_node_read+0x7ac/0x29e0 fs/bcachefs/btree_io.c:1706
 __bch2_btree_root_read fs/bcachefs/btree_io.c:1796 [inline]
 bch2_btree_root_read+0x656/0x7e0 fs/bcachefs/btree_io.c:1818
 read_btree_roots+0x3d7/0xa80 fs/bcachefs/recovery.c:581
 bch2_fs_recovery+0x28e4/0x3e20 fs/bcachefs/recovery.c:928
 bch2_fs_start+0x2fb/0x610 fs/bcachefs/super.c:1060
 bch2_fs_get_tree+0x113e/0x18f0 fs/bcachefs/fs.c:2253
 vfs_get_tree+0x90/0x2b0 fs/super.c:1759
 do_new_mount+0x2cf/0xb70 fs/namespace.c:3878
 do_mount fs/namespace.c:4218 [inline]
 __do_sys_mount fs/namespace.c:4429 [inline]
 __se_sys_mount+0x38c/0x400 fs/namespace.c:4406
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f8dd0844c3a
Code: d8 64 89 02 48 c7 c0 ff ff ff ff eb a6 e8 5e 04 00 00 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffc3c4a4f58 EFLAGS: 00000282 ORIG_RAX: 00000000000000a5
RAX: ffffffffffffffda RBX: 00007ffc3c4a4f70 RCX: 00007f8dd0844c3a
RDX: 0000200000000000 RSI: 0000200000000100 RDI: 00007ffc3c4a4f70
RBP: 0000200000000100 R08: 00007ffc3c4a4fb0 R09: 000000000000596a
R10: 0000000000800800 R11: 0000000000000282 R12: 0000200000000000
R13: 00007ffc3c4a4fb0 R14: 0000000000000003 R15: 0000000000800800
 </TASK>
bcachefs (loop0): pointer to nonexistent device 8
  inconsistency detected - emergency read only at journal seq 10
  
bcachefs (loop0): btree node read error: no device to read from
 at backpointers level 0/0
u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq 4a8b0fa43a9980a6 written 24 min_key POS_MIN durability: 0 ptr: 8:9472 gen 0
bcachefs (loop0): flagging btree backpointers lost data
bcachefs (loop0): running explicit recovery pass check_topology (2), currently at recovery_pass_empty (0)
bcachefs (loop0): error reading btree root btree=backpointers level=0: btree_node_read_error, fixing
bcachefs (loop0): check_topology... done
bcachefs (loop0): accounting_read... done
bcachefs (loop0): alloc_read... done
bcachefs (loop0): snapshots_read... done
bcachefs (loop0): check_allocations...
bcachefs (loop0): bucket 0:26 data type btree ptr gen 0 missing in alloc btree
  while marking u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq ac62141f8dc7e261 written 24 min_key POS_MIN durability: 1 ptr: 0:26:0 gen 0, fixing
bcachefs (loop0): bucket 0:38 data type btree ptr gen 0 missing in alloc btree
  while marking u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq 7589ab5e0c11cc7a written 24 min_key POS_MIN durability: 1 ptr: 0:38:0 gen 0, fixing
bcachefs (loop0): bucket 0:41 data type btree ptr gen 0 missing in alloc btree
  while marking u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq 9aa2895aefce4bdf written 24 min_key POS_MIN durability: 1 ptr: 0:41:0 gen 0, fixing
bcachefs (loop0): bucket 0:35 data type btree ptr gen 0 missing in alloc btree
  while marking u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c0bef60d07ceb940 written 16 min_key POS_MIN durability: 1 ptr: 0:35:0 gen 0, fixing
bcachefs (loop0): bucket 0:29 data type btree ptr gen 0 missing in alloc btree
  while marking u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq e81e1ed936acf3df written 32 min_key POS_MIN durability: 1 ptr: 0:29:0 gen 0, fixing
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
bcachefs (loop0): bucket 0:11 gen 0 data type journal has wrong dirty_sectors: got 0, should be 256, fixing
bcachefs (loop0): bucket 0:12 gen 0 has wrong data_type: got free, should be journal, fixing
bcachefs (loop0): bucket 0:12 gen 0 data type journal has wrong dirty_sectors: got 0, should be 256, fixing
bcachefs (loop0): bucket 0:13 gen 0 has wrong data_type: got free, should be journal, fixing
bcachefs (loop0): bucket 0:13 gen 0 data type journal has wrong dirty_sectors: got 0, should be 256, fixing
bcachefs (loop0): bucket 0:14 gen 0 has wrong data_type: got free, should be journal, fixing
bcachefs (loop0): bucket 0:14 gen 0 data type journal has wrong dirty_sectors: got 0, should be 256, fixing
bcachefs (loop0): bucket 0:15 gen 0 has wrong data_type: got free, should be journal, fixing
bcachefs (loop0): bucket 0:15 gen 0 data type journal has wrong dirty_sectors: got 0, should be 256, fixing
bcachefs (loop0): bucket 0:16 gen 0 has wrong data_type: got free, should be sb, fixing
bcachefs (loop0): bucket 0:16 gen 0 data type sb has wrong dirty_sectors: got 0, should be 256, fixing
bcachefs (loop0): bucket 0:17 gen 0 has wrong data_type: got free, should be sb, fixing
bcachefs (loop0): bucket 0:17 gen 0 data type sb has wrong dirty_sectors: got 0, should be 256, fixing
bcachefs (loop0): bucket 0:18 gen 0 has wrong data_type: got free, should be sb, fixing
bcachefs (loop0): bucket 0:18 gen 0 data type sb has wrong dirty_sectors: got 0, should be 256, fixing
bcachefs (loop0): bucket 0:19 gen 0 has wrong data_type: got free, should be sb, fixing
bcachefs (loop0): bucket 0:19 gen 0 data type sb has wrong dirty_sectors: got 0, should be 256, fixing
bcachefs (loop0): bucket 0:20 gen 0 has wrong data_type: got free, should be sb, fixing
bcachefs (loop0): bucket 0:20 gen 0 data type sb has wrong dirty_sectors: got 0, should be 256, fixing
bcachefs (loop0): bucket 0:21 gen 0 has wrong data_type: got free, should be sb, fixing
bcachefs (loop0): bucket 0:21 gen 0 data type sb has wrong dirty_sectors: got 0, should be 256, fixing
bcachefs (loop0): bucket 0:22 gen 0 has wrong data_type: got free, should be sb, fixing
bcachefs (loop0): bucket 0:22 gen 0 data type sb has wrong dirty_sectors: got 0, should be 256, fixing
bcachefs (loop0): bucket 0:23 gen 0 has wrong data_type: got free, should be sb, fixing
bcachefs (loop0): bucket 0:23 gen 0 data type sb has wrong dirty_sectors: got 0, should be 256, fixing
bcachefs (loop0): bucket 0:24 gen 0 has wrong data_type: got free, should be journal, fixing
bcachefs (loop0): bucket 0:24 gen 0 data type journal has wrong dirty_sectors: got 0, should be 256, fixing
bcachefs (loop0): bucket 0:26 gen 0 has wrong data_type: got free, should be btree, fixing
bcachefs (loop0): bucket 0:26 gen 0 data type btree has wrong dirty_sectors: got 0, should be 256, fixing
bcachefs (loop0): bucket 0:29 gen 0 has wrong data_type: got free, should be btree, fixing
bcachefs (loop0): bucket 0:29 gen 0 data type btree has wrong dirty_sectors: got 0, should be 256, fixing
bcachefs (loop0): bucket 0:32 gen 0 has wrong data_type: got sb, should be btree, fixing
bcachefs (loop0): bucket 0:35 gen 0 has wrong data_type: got free, should be btree, fixing
bcachefs (loop0): bucket 0:35 gen 0 data type btree has wrong dirty_sectors: got 0, should be 256, fixing
bcachefs (loop0): bucket 0:37 gen 0 has wrong data_type: got btree, should be need_discard, fixing
bcachefs (loop0): bucket 0:37 gen 0 data type need_discard has wrong dirty_sectors: got 256, should be 0, fixing
bcachefs (loop0): bucket 0:38 gen 0 has wrong data_type: got free, should be btree, fixing
bcachefs (loop0): bucket 0:38 gen 0 data type btree has wrong dirty_sectors: got 0, should be 256, fixing
bcachefs (loop0): bucket 0:41 gen 0 has wrong data_type: got free, should be btree, fixing
bcachefs (loop0): bucket 0:41 gen 0 data type btree has wrong dirty_sectors: got 0, should be 256, fixing
bcachefs (loop0): bucket 0:120 gen 0 has wrong data_type: got free, should be sb, fixing
bcachefs (loop0): bucket 0:120 gen 0 data type sb has wrong dirty_sectors: got 0, should be 256, fixing
bcachefs (loop0): bucket 0:121 gen 0 has wrong data_type: got free, should be sb, fixing
bcachefs (loop0): bucket 0:121 gen 0 data type sb has wrong dirty_sectors: got 0, should be 256, fixing
bcachefs (loop0): bucket 0:122 gen 0 has wrong data_type: got free, should be sb, fixing
bcachefs (loop0): bucket 0:122 gen 0 data type sb has wrong dirty_sectors: got 0, should be 256, fixing
bcachefs (loop0): bucket 0:123 gen 0 has wrong data_type: got free, should be sb, fixing
bcachefs (loop0): bucket 0:123 gen 0 data type sb has wrong dirty_sectors: got 0, should be 256, fixing
bcachefs (loop0): bucket 0:124 gen 0 has wrong data_type: got free, should be sb, fixing
bcachefs (loop0): bucket 0:124 gen 0 data type sb has wrong dirty_sectors: got 0, should be 256, fixing
bcachefs (loop0): bucket 0:125 gen 0 has wrong data_type: got free, should be sb, fixing
bcachefs (loop0): bucket 0:125 gen 0 data type sb has wrong dirty_sectors: got 0, should be 256, fixing
bcachefs (loop0): bucket 0:126 gen 0 has wrong data_type: got free, should be sb, fixing
bcachefs (loop0): bucket 0:126 gen 0 data type sb has wrong dirty_sectors: got 0, should be 256, fixing
bcachefs (loop0): bucket 0:127 gen 0 has wrong data_type: got free, should be sb, fixing
bcachefs (loop0): bucket 0:127 gen 0 data type sb has wrong dirty_sectors: got 0, should be 256, fixing
 done
bcachefs (loop0): going read-write
bcachefs (loop0): journal_replay...
bcachefs (loop0): bch2_journal_replay(): error journal_shutdown
bcachefs (loop0): bch2_fs_recovery(): error journal_shutdown
bcachefs (loop0): bch2_fs_start(): error starting filesystem journal_shutdown
bcachefs (loop0): shutting down
bcachefs (loop0): shutdown complete
bcachefs: bch2_fs_get_tree() error: journal_shutdown


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

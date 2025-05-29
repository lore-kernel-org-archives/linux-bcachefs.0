Received: from mail-il1-f205.google.com (mail-il1-f205.google.com [209.85.166.205])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE9BD21B9C0
	for <linux-bcachefs@vger.kernel.org>; Thu, 29 May 2025 09:09:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.205
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748509768; cv=none; b=E8rME5cdPGyIBZ1s08Q78noHII9Lz349wZ4lIXCMaVORL1p+6Ty6dNMlSRM5SYZf5MSYWjv5HpqZqsD+iP/d0Q1DdfZDJPfolhLRA1RiqKjd7W+1Nx3YxuHwnMSqqiYX9xhn3cjQBOfSNTcUtAxqf5mjVIudk+QvAsGuYuIQM0I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748509768; c=relaxed/simple;
	bh=HDhGLa9BUE1RuZCVvmy5TBUb5QAequi3Fu6jTKyurWU=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=pw1LuJwM7/e4ntU9hdRq3j9b1YcbTTvamFw/ObCayEbANFCFi81Sjl+YQxXjMaP+Z1vP1kH/VskN4+vXprqiANoJXBKLN7g+Z06F9P5DOYYAPKe12nAbegRVzuawq9i61bYKa3q6K8tU61L4EAx5UTsL0kNMzwwKI36UCIMxvlg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.205
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f205.google.com with SMTP id e9e14a558f8ab-3da6f284ca5so12739355ab.1
        for <linux-bcachefs@vger.kernel.org>; Thu, 29 May 2025 02:09:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748509766; x=1749114566;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LV/VRqy6qB3WWjqQBiweAQ8Emsu50z4cE/8Wq8igof0=;
        b=RXnrrJk7DLpmlnuvk2JQ4y7mOohTCRSG1El82pYclK56YUTe2HhKIlaFiBFmQ+7psx
         MMYXA2AGe545KRfntH/ieEGjZNTVxKW2qF6Vtdjeu/fw4GoJ/DnJ9mlWJxtvZ+gFBAp+
         +iNMiCfdY85Ci5CQrIecao5+F0PWVRzmJogTpJJmTr+nORLwn1HLi8Lo4cI3oE3eRlIO
         98IjGLOadYCX62d4eBV6EkgLpUmxCvoyDg7juQXpbKKQLjxbpNkqjHhvZNb8NZ4C90Z2
         Rs/qYhdi/VjnW0kBTTJG0JtsK2/RJAqMHe0AWilKMFKX0tleO4oW+uNgulU7sItuG74I
         bbiw==
X-Forwarded-Encrypted: i=1; AJvYcCWuw5Gay8lFA3OZKBTCSq6EkRwPI9SYQH3UeHuaLEZQBK/mijFwvgTaNQujMdHpPDIlEkbttQy1uhQxa1SEOg==@vger.kernel.org
X-Gm-Message-State: AOJu0YxJK7cq+RHlQ5k+u8LYpAiiqLeGXHEjQY5BVNUCemLAsAXPrntP
	HowbVOoX/eEk/vh2B3zSDwYO8ejLqzIfInNDYOfUeJAX0ym1NApT/GqPnMCoVKh2c+UDRKiwsAm
	mUobe1OPytuBRg4ZSn7zsfg7s6XfQswzZBILbBU+gRscq5dcQgJOW1UnkgmM=
X-Google-Smtp-Source: AGHT+IHGY2zP3z31h1bS00vF6kAR0qmsW9lQ6f5rfqeLtlGedi49//Ndk3lXa4HuI3HJpCtK9nVSomRnLMJWuMuuXIhw6VJIjXvm
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:188d:b0:3dc:8109:d64b with SMTP id
 e9e14a558f8ab-3dc9b695261mr198504675ab.5.1748509766021; Thu, 29 May 2025
 02:09:26 -0700 (PDT)
Date: Thu, 29 May 2025 02:09:26 -0700
In-Reply-To: <66f97d9a.050a0220.6bad9.001d.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68382446.a70a0220.1765ec.0185.GAE@google.com>
Subject: Re: [syzbot] [bcachefs?] possible deadlock in pcpu_alloc_noprof
From: syzbot <syzbot+fe63f377148a6371a9db@syzkaller.appspotmail.com>
To: axboe@kernel.dk, cl@linux.com, dennis@kernel.org, 
	kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	mhocko@kernel.org, mmpgouride@gmail.com, syzkaller-bugs@googlegroups.com, 
	tj@kernel.org, vbabka@suse.cz
Content-Type: text/plain; charset="UTF-8"

syzbot has found a reproducer for the following issue on:

HEAD commit:    90b83efa6701 Merge tag 'bpf-next-6.16' of git://git.kernel..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=145b4ed4580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=fbd871027e10b130
dashboard link: https://syzkaller.appspot.com/bug?extid=fe63f377148a6371a9db
compiler:       gcc (Debian 12.2.0-14) 12.2.0, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=166807f4580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=125b4ed4580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/7b23158542c6/disk-90b83efa.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/fe77cd0d7150/vmlinux-90b83efa.xz
kernel image: https://storage.googleapis.com/syzbot-assets/fdddbd2ed303/bzImage-90b83efa.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+fe63f377148a6371a9db@syzkaller.appspotmail.com

======================================================
WARNING: possible circular locking dependency detected
6.15.0-syzkaller-07774-g90b83efa6701 #0 Not tainted
------------------------------------------------------
syz-executor398/5854 is trying to acquire lock:
ffffffff8e52d3a8 (pcpu_alloc_mutex){+.+.}-{4:4}, at: pcpu_alloc_noprof+0xb4a/0x1470 mm/percpu.c:1782

but task is already holding lock:
ffff88814333d8b0 (&q->q_usage_counter(io)#58){++++}-{0:0}, at: blk_mq_freeze_queue_nomemsave+0x15/0x20 block/blk-mq.c:205

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #2 (&q->q_usage_counter(io)#58){++++}-{0:0}:
       blk_alloc_queue+0x619/0x760 block/blk-core.c:461
       blk_mq_alloc_queue+0x175/0x290 block/blk-mq.c:4396
       __blk_mq_alloc_disk+0x29/0x120 block/blk-mq.c:4443
       nbd_dev_add+0x4a0/0xbc0 drivers/block/nbd.c:1933
       nbd_init+0x181/0x320 drivers/block/nbd.c:2670
       do_one_initcall+0x120/0x6e0 init/main.c:1257
       do_initcall_level init/main.c:1319 [inline]
       do_initcalls init/main.c:1335 [inline]
       do_basic_setup init/main.c:1354 [inline]
       kernel_init_freeable+0x5c2/0x900 init/main.c:1567
       kernel_init+0x1c/0x2b0 init/main.c:1457
       ret_from_fork+0x5d7/0x6f0 arch/x86/kernel/process.c:148
       ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245

-> #1 (fs_reclaim){+.+.}-{0:0}:
       __fs_reclaim_acquire mm/page_alloc.c:4056 [inline]
       fs_reclaim_acquire+0x102/0x150 mm/page_alloc.c:4070
       might_alloc include/linux/sched/mm.h:318 [inline]
       prepare_alloc_pages+0x162/0x610 mm/page_alloc.c:4738
       __alloc_frozen_pages_noprof+0x18b/0x23f0 mm/page_alloc.c:4959
       __alloc_pages_noprof+0xb/0x1b0 mm/page_alloc.c:5004
       __alloc_pages_node_noprof include/linux/gfp.h:284 [inline]
       alloc_pages_node_noprof include/linux/gfp.h:311 [inline]
       pcpu_alloc_pages mm/percpu-vm.c:95 [inline]
       pcpu_populate_chunk+0x110/0xb00 mm/percpu-vm.c:285
       pcpu_alloc_noprof+0x86a/0x1470 mm/percpu.c:1870
       xt_percpu_counter_alloc+0x13e/0x1b0 net/netfilter/x_tables.c:1931
       find_check_entry.constprop.0+0xbc/0x9b0 net/ipv4/netfilter/ip_tables.c:526
       translate_table+0xc98/0x1720 net/ipv4/netfilter/ip_tables.c:716
       ipt_register_table+0x102/0x430 net/ipv4/netfilter/ip_tables.c:1742
       iptable_raw_table_init+0x63/0x90 net/ipv4/netfilter/iptable_raw.c:49
       xt_find_table_lock+0x2e1/0x520 net/netfilter/x_tables.c:1260
       xt_request_find_table_lock+0x28/0xf0 net/netfilter/x_tables.c:1285
       get_info+0x190/0x610 net/ipv4/netfilter/ip_tables.c:963
       do_ipt_get_ctl+0x169/0xa10 net/ipv4/netfilter/ip_tables.c:1659
       nf_getsockopt+0x7c/0xe0 net/netfilter/nf_sockopt.c:116
       ip_getsockopt+0x18c/0x1e0 net/ipv4/ip_sockglue.c:1777
       tcp_getsockopt+0x9e/0x100 net/ipv4/tcp.c:4760
       do_sock_getsockopt+0x3ff/0x800 net/socket.c:2357
       __sys_getsockopt+0x123/0x1b0 net/socket.c:2386
       __do_sys_getsockopt net/socket.c:2393 [inline]
       __se_sys_getsockopt net/socket.c:2390 [inline]
       __x64_sys_getsockopt+0xbd/0x160 net/socket.c:2390
       do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
       do_syscall_64+0xcd/0x490 arch/x86/entry/syscall_64.c:94
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #0 (pcpu_alloc_mutex){+.+.}-{4:4}:
       check_prev_add kernel/locking/lockdep.c:3168 [inline]
       check_prevs_add kernel/locking/lockdep.c:3287 [inline]
       validate_chain kernel/locking/lockdep.c:3911 [inline]
       __lock_acquire+0x126f/0x1c90 kernel/locking/lockdep.c:5240
       lock_acquire kernel/locking/lockdep.c:5871 [inline]
       lock_acquire+0x179/0x350 kernel/locking/lockdep.c:5828
       __mutex_lock_common kernel/locking/mutex.c:601 [inline]
       __mutex_lock+0x199/0xb90 kernel/locking/mutex.c:746
       pcpu_alloc_noprof+0xb4a/0x1470 mm/percpu.c:1782
       blk_stat_alloc_callback+0xc8/0x280 block/blk-stat.c:116
       wbt_init+0xac/0x540 block/blk-wbt.c:903
       queue_wb_lat_store+0x354/0x3d0 block/blk-sysfs.c:603
       queue_attr_store+0x276/0x320 block/blk-sysfs.c:805
       sysfs_kf_write+0xef/0x150 fs/sysfs/file.c:145
       kernfs_fop_write_iter+0x354/0x510 fs/kernfs/file.c:334
       new_sync_write fs/read_write.c:593 [inline]
       vfs_write+0x6c7/0x1150 fs/read_write.c:686
       ksys_write+0x12a/0x250 fs/read_write.c:738
       do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
       do_syscall_64+0xcd/0x490 arch/x86/entry/syscall_64.c:94
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

other info that might help us debug this:

Chain exists of:
  pcpu_alloc_mutex --> fs_reclaim --> &q->q_usage_counter(io)#58

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(&q->q_usage_counter(io)#58);
                               lock(fs_reclaim);
                               lock(&q->q_usage_counter(io)#58);
  lock(pcpu_alloc_mutex);

 *** DEADLOCK ***

5 locks held by syz-executor398/5854:
 #0: ffff8880316b8428 (sb_writers#7){.+.+}-{0:0}, at: ksys_write+0x12a/0x250 fs/read_write.c:738
 #1: ffff88802a508088 (&of->mutex){+.+.}-{4:4}, at: kernfs_fop_write_iter+0x28f/0x510 fs/kernfs/file.c:325
 #2: ffff888147e9ac38 (kn->active#57){.+.+}-{0:0}, at: kernfs_fop_write_iter+0x2b2/0x510 fs/kernfs/file.c:326
 #3: ffff88814333d8b0 (&q->q_usage_counter(io)#58){++++}-{0:0}, at: blk_mq_freeze_queue_nomemsave+0x15/0x20 block/blk-mq.c:205
 #4: ffff88814333d8e8 (&q->q_usage_counter(queue)#10){+.+.}-{0:0}, at: blk_mq_freeze_queue_nomemsave+0x15/0x20 block/blk-mq.c:205

stack backtrace:
CPU: 1 UID: 0 PID: 5854 Comm: syz-executor398 Not tainted 6.15.0-syzkaller-07774-g90b83efa6701 #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 05/07/2025
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0x116/0x1f0 lib/dump_stack.c:120
 print_circular_bug+0x275/0x350 kernel/locking/lockdep.c:2046
 check_noncircular+0x14c/0x170 kernel/locking/lockdep.c:2178
 check_prev_add kernel/locking/lockdep.c:3168 [inline]
 check_prevs_add kernel/locking/lockdep.c:3287 [inline]
 validate_chain kernel/locking/lockdep.c:3911 [inline]
 __lock_acquire+0x126f/0x1c90 kernel/locking/lockdep.c:5240
 lock_acquire kernel/locking/lockdep.c:5871 [inline]
 lock_acquire+0x179/0x350 kernel/locking/lockdep.c:5828
 __mutex_lock_common kernel/locking/mutex.c:601 [inline]
 __mutex_lock+0x199/0xb90 kernel/locking/mutex.c:746
 pcpu_alloc_noprof+0xb4a/0x1470 mm/percpu.c:1782
 blk_stat_alloc_callback+0xc8/0x280 block/blk-stat.c:116
 wbt_init+0xac/0x540 block/blk-wbt.c:903
 queue_wb_lat_store+0x354/0x3d0 block/blk-sysfs.c:603
 queue_attr_store+0x276/0x320 block/blk-sysfs.c:805
 sysfs_kf_write+0xef/0x150 fs/sysfs/file.c:145
 kernfs_fop_write_iter+0x354/0x510 fs/kernfs/file.c:334
 new_sync_write fs/read_write.c:593 [inline]
 vfs_write+0x6c7/0x1150 fs/read_write.c:686
 ksys_write+0x12a/0x250 fs/read_write.c:738
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xcd/0x490 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f18df4b0e49
Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 e1 1d 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffc61925058 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 00007f18df4b0e49
RDX: 0000000000000801 RSI: 0000200000000240 RDI: 0000000000000003
RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000003
R13: 00007ffc61925090 R14: 00007ffc619250d0 R15: 0000000000000000
 </TASK>


---
If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.

Received: from mail-il1-f207.google.com (mail-il1-f207.google.com [209.85.166.207])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EA4B2FA62D
	for <linux-bcachefs@vger.kernel.org>; Tue, 17 Jun 2025 16:52:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750179156; cv=none; b=BUWCvM6f1pMWM5D3GsEdA0JN+q4Gsfa87frEz/3VtG1pzBbrmAhYhCsMSgcwEYzbJH77DDvcjI2EQXFlBlFX2bIhp2WCp6XiOp84kb4mBxZligNU271fUEyh967jVfN0UPH5pLAai7grhwOO1kUvJg61hjIWKjT1mAnRrQSvyxA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750179156; c=relaxed/simple;
	bh=G9XN6Gxa4InNZ46I4lpQdvj1omBjcsp0ZqmGGWMJ7hk=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=dD0S4aq3jcThNTVWzsH19hfzEdwZozLd4M09TBXnIQiLgjGdGBOhbvRQdrZaSIBLX8Go2bsaVwTh5ak7CZCOX+SJjZTQLboY1YyE0bfMRJTNHexNLqU+TqpSmHHQrZtBvpl+jOi5S3uTiD4odzGTwhTxISbRyU3JcQtXntwlwDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f207.google.com with SMTP id e9e14a558f8ab-3ddd01c6f9bso67132385ab.1
        for <linux-bcachefs@vger.kernel.org>; Tue, 17 Jun 2025 09:52:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750179153; x=1750783953;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=q+5VXpGlrY62/ocw7acqgxcfz5xjkFrvsB9lRHjYsok=;
        b=jabAJ86VvyuS/NZQCjT07ZqDCVzltID+TZq00yKCXk+c0KepGkwz5eearmqO8dn0ee
         2VZAtuMgh0qwiLM6ViEWeWGrFDlVMqTNhnqRiM09uxK9jZnO2E/tOXY77STfu/WiUHWw
         y/8ae12cT+8i7w8x1J8NyJow85T4u3sxM241Jis1MYoddfUcrgjS83GGn/H7snX4sISC
         T4Ub6uv0YqXdWTsi2AIgm8hyNx4fVn4qTOiMNVWZCbrmbc5kewKEVRukJJjjiuiTnlTM
         A1oeZs3SKS+YBMyUdUkxKNU39kkdoWvuPvG7ItcbPwvzGU1QwASAWmTIsmfxUPQYMcsm
         09OA==
X-Forwarded-Encrypted: i=1; AJvYcCV+oD34jPSn0yIwkx5uMJ1Kgsi2edKxlmyXa6IPh6Ojypmk8jhZ+1bm34LXwAE/cX5ruODkaNmcSkhIPchoUg==@vger.kernel.org
X-Gm-Message-State: AOJu0YyL4EkCHXHjlKqI5gWUN9zUFM3wpD3kwKzMeA5Lb9GBt+Z404lX
	piOl8sJpasrV7dlYVcvu6TaLM20eFuNMZvIfTqZc8tgBWQ6h/KLcOk4JYXR70Hs1r4FUyh/5cPL
	lEuEPOzZsfdAqW9Qw6tM5dUk1cV/5R3DQLuiaX6p4fIeLSHAHCBX9PkEu57k=
X-Google-Smtp-Source: AGHT+IEWrRhyWUiQDDE1iWrXRdNzKbiOjV28trpWuh5l7vDLuqorG2+kbBOciA76C/z/u/56Gu3hur92SJuLa4WMGJ5micoY1V1i
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a92:ca48:0:b0:3de:12ce:d832 with SMTP id
 e9e14a558f8ab-3de22d0b292mr37593335ab.10.1750179153237; Tue, 17 Jun 2025
 09:52:33 -0700 (PDT)
Date: Tue, 17 Jun 2025 09:52:33 -0700
In-Reply-To: <675cb812.050a0220.37aaf.00b6.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68519d51.050a0220.2608ac.001d.GAE@google.com>
Subject: Re: [syzbot] [bcachefs?] INFO: task hung in bch2_page_fault
From: syzbot <syzbot+32415e0466b02533303c@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot has found a reproducer for the following issue on:

HEAD commit:    9afe652958c3 Merge tag 'x86_urgent_for_6.16-rc3' of git://..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=11665e82580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=6a237c32900fc479
dashboard link: https://syzkaller.appspot.com/bug?extid=32415e0466b02533303c
compiler:       Debian clang version 20.1.6 (++20250514063057+1e4d39e07757-1~exp1~20250514183223.118), Debian LLD 20.1.6
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=130d790c580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/ca235ca5eaeb/disk-9afe6529.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/ce4a880751fe/vmlinux-9afe6529.xz
kernel image: https://storage.googleapis.com/syzbot-assets/a7c651092242/bzImage-9afe6529.xz
mounted in repro #1: https://storage.googleapis.com/syzbot-assets/eae8507e16f4/mount_0.gz
mounted in repro #2: https://storage.googleapis.com/syzbot-assets/9464fbe325ac/mount_4.gz
mounted in repro #3: https://storage.googleapis.com/syzbot-assets/5eac8f4c23dc/mount_6.gz
  fsck result: OK (log: https://syzkaller.appspot.com/x/fsck.log?x=16665e82580000)
mounted in repro #4: https://storage.googleapis.com/syzbot-assets/6901c045125d/mount_15.gz
  fsck result: failed (log: https://syzkaller.appspot.com/x/fsck.log?x=137355d4580000)

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+32415e0466b02533303c@syzkaller.appspotmail.com

INFO: task syz.4.25:6211 blocked for more than 143 seconds.
      Not tainted 6.16.0-rc2-syzkaller-00024-g9afe652958c3 #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz.4.25        state:D stack:24616 pid:6211  tgid:6211  ppid:5990   task_flags:0x400040 flags:0x00004004
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5396 [inline]
 __schedule+0x16a2/0x4cb0 kernel/sched/core.c:6785
 __schedule_loop kernel/sched/core.c:6863 [inline]
 schedule+0x165/0x360 kernel/sched/core.c:6878
 __bch2_two_state_lock+0x1ea/0x370 fs/bcachefs/two_state_shared_lock.c:7
 bch2_two_state_lock fs/bcachefs/two_state_shared_lock.h:55 [inline]
 bch2_page_fault+0x2f6/0x7a0 fs/bcachefs/fs-io-pagecache.c:592
 __do_fault+0x138/0x390 mm/memory.c:5189
 do_shared_fault mm/memory.c:5674 [inline]
 do_fault mm/memory.c:5748 [inline]
 do_pte_missing mm/memory.c:4251 [inline]
 handle_pte_fault mm/memory.c:6089 [inline]
 __handle_mm_fault+0x198b/0x5620 mm/memory.c:6232
 handle_mm_fault+0x2d5/0x7f0 mm/memory.c:6401
 do_user_addr_fault+0xa81/0x1390 arch/x86/mm/fault.c:1336
 handle_page_fault arch/x86/mm/fault.c:1476 [inline]
 exc_page_fault+0x76/0xf0 arch/x86/mm/fault.c:1532
 asm_exc_page_fault+0x26/0x30 arch/x86/include/asm/idtentry.h:623
RIP: 0033:0x7efe53d567c7
RSP: 002b:00007ffd198848c8 EFLAGS: 00010203
RAX: 0000200000002500 RBX: 0000000000000004 RCX: 0000200000002500
RDX: 00002000000036e8 RSI: 00007efe53825cad RDI: 0000200000002520
RBP: 00007efe53fb7ba0 R08: 0000000000000000 R09: 0000000000000049
R10: 0000000000000000 R11: 0000000000000001 R12: 00007efe53fb616c
R13: 00007efe53fb6160 R14: fffffffffffffffe R15: 00007ffd198849e0
 </TASK>
INFO: task syz.4.25:6212 blocked for more than 144 seconds.
      Not tainted 6.16.0-rc2-syzkaller-00024-g9afe652958c3 #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz.4.25        state:D stack:17736 pid:6212  tgid:6211  ppid:5990   task_flags:0x440140 flags:0x00004006
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5396 [inline]
 __schedule+0x16a2/0x4cb0 kernel/sched/core.c:6785
 __schedule_loop kernel/sched/core.c:6863 [inline]
 schedule+0x165/0x360 kernel/sched/core.c:6878
 __bch2_two_state_lock+0x1ea/0x370 fs/bcachefs/two_state_shared_lock.c:7
 bch2_two_state_lock fs/bcachefs/two_state_shared_lock.h:55 [inline]
 bch2_readahead+0x94f/0x1100 fs/bcachefs/fs-io-buffered.c:296
 read_pages+0x17a/0x580 mm/readahead.c:160
 page_cache_ra_order+0xa24/0xc70 mm/readahead.c:515
 filemap_readahead mm/filemap.c:2571 [inline]
 filemap_get_pages+0xb22/0x1ea0 mm/filemap.c:2616
 filemap_splice_read+0x4fc/0xbc0 mm/filemap.c:2990
 do_splice_read fs/splice.c:979 [inline]
 splice_direct_to_actor+0x4a6/0xcc0 fs/splice.c:1083
 do_splice_direct_actor fs/splice.c:1201 [inline]
 do_splice_direct+0x181/0x270 fs/splice.c:1227
 vfs_copy_file_range+0xabc/0x1310 fs/read_write.c:1627
 __do_sys_copy_file_range fs/read_write.c:1677 [inline]
 __se_sys_copy_file_range+0x2fb/0x470 fs/read_write.c:1644
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7efe53d8e929
RSP: 002b:00007efe54b68038 EFLAGS: 00000246 ORIG_RAX: 0000000000000146
RAX: ffffffffffffffda RBX: 00007efe53fb5fa0 RCX: 00007efe53d8e929
RDX: 0000000000000006 RSI: 0000000000000000 RDI: 0000000000000007
RBP: 00007efe53e10b39 R08: 0000000000400000 R09: 0000000000000000
R10: 00002000000000c0 R11: 0000000000000246 R12: 0000000000000000
R13: 0000000000000000 R14: 00007efe53fb5fa0 R15: 00007ffd19884768
 </TASK>
INFO: task syz.4.25:6264 blocked for more than 145 seconds.
      Not tainted 6.16.0-rc2-syzkaller-00024-g9afe652958c3 #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz.4.25        state:D stack:25976 pid:6264  tgid:6211  ppid:5990   task_flags:0x400040 flags:0x00004006
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5396 [inline]
 __schedule+0x16a2/0x4cb0 kernel/sched/core.c:6785
 __schedule_loop kernel/sched/core.c:6863 [inline]
 schedule+0x165/0x360 kernel/sched/core.c:6878
 io_schedule+0x81/0xe0 kernel/sched/core.c:7723
 folio_wait_bit_common+0x6b0/0xb90 mm/filemap.c:1317
 folio_lock include/linux/pagemap.h:1114 [inline]
 invalidate_inode_pages2_range+0x557/0xa80 mm/truncate.c:690
 bch2_write_invalidate_inode_pages_range+0xc5/0x110 fs/bcachefs/fs-io-pagecache.c:68
 bch2_direct_write+0x2a62/0x2ce0 fs/bcachefs/fs-io-direct.c:662
 bch2_write_iter+0x18f/0x2b90 fs/bcachefs/fs-io-buffered.c:1064
 do_iter_readv_writev+0x56b/0x7f0 fs/read_write.c:-1
 vfs_writev+0x31a/0x960 fs/read_write.c:1057
 do_pwritev fs/read_write.c:1153 [inline]
 __do_sys_pwritev2 fs/read_write.c:1211 [inline]
 __se_sys_pwritev2+0x179/0x290 fs/read_write.c:1202
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7efe53d8e929
RSP: 002b:00007efe54b47038 EFLAGS: 00000246 ORIG_RAX: 0000000000000148
RAX: ffffffffffffffda RBX: 00007efe53fb6080 RCX: 00007efe53d8e929
RDX: 0000000000000001 RSI: 0000200000000240 RDI: 0000000000000005
RBP: 00007efe53e10b39 R08: 0000000000000000 R09: 0000000000000003
R10: 0000000000007000 R11: 0000000000000246 R12: 0000000000000000
R13: 0000000000000001 R14: 00007efe53fb6080 R15: 00007ffd19884768
 </TASK>

Showing all locks held in the system:
1 lock held by khungtaskd/31:
 #0: ffffffff8e13eda0 (rcu_read_lock){....}-{1:3}, at: rcu_lock_acquire include/linux/rcupdate.h:331 [inline]
 #0: ffffffff8e13eda0 (rcu_read_lock){....}-{1:3}, at: rcu_read_lock include/linux/rcupdate.h:841 [inline]
 #0: ffffffff8e13eda0 (rcu_read_lock){....}-{1:3}, at: debug_show_all_locks+0x2e/0x180 kernel/locking/lockdep.c:6770
3 locks held by kworker/0:2/1214:
2 locks held by getty/5584:
 #0: ffff88803543a0a0 (&tty->ldisc_sem){++++}-{0:0}, at: tty_ldisc_ref_wait+0x25/0x70 drivers/tty/tty_ldisc.c:243
 #1: ffffc9000332b2f0 (&ldata->atomic_read_lock){+.+.}-{4:4}, at: n_tty_read+0x43e/0x1400 drivers/tty/n_tty.c:2222
3 locks held by syz-executor/5975:
 #0: ffff88805c16a0e0 (&type->s_umount_key#54){++++}-{4:4}, at: __super_lock fs/super.c:57 [inline]
 #0: ffff88805c16a0e0 (&type->s_umount_key#54){++++}-{4:4}, at: __super_lock_excl fs/super.c:72 [inline]
 #0: ffff88805c16a0e0 (&type->s_umount_key#54){++++}-{4:4}, at: deactivate_super+0xa9/0xe0 fs/super.c:506
 #1: ffff8880ae700278 (&c->state_lock){+.+.}-{4:4}, at: __bch2_fs_stop+0xf8/0x900 fs/bcachefs/super.c:677
 #2: ffffffff8e1448b8 (rcu_state.exp_mutex){+.+.}-{4:4}, at: exp_funnel_lock kernel/rcu/tree_exp.h:336 [inline]
 #2: ffffffff8e1448b8 (rcu_state.exp_mutex){+.+.}-{4:4}, at: synchronize_rcu_expedited+0x3b9/0x730 kernel/rcu/tree_exp.h:998
3 locks held by kworker/0:4/5981:
1 lock held by syz.4.25/6211:
 #0: ffff88805a860a88 (vm_lock){++++}-{0:0}, at: do_user_addr_fault+0x2d9/0x1390 arch/x86/mm/fault.c:1327
1 lock held by syz.4.25/6212:
 #0: ffff8880564d1218 (mapping.invalidate_lock#3){.+.+}-{4:4}, at: filemap_invalidate_lock_shared include/linux/fs.h:934 [inline]
 #0: ffff8880564d1218 (mapping.invalidate_lock#3){.+.+}-{4:4}, at: page_cache_ra_order+0x445/0xc70 mm/readahead.c:491
1 lock held by syz.4.25/6264:
 #0: ffff88802457a428 (sb_writers#13){.+.+}-{0:0}, at: file_start_write include/linux/fs.h:3096 [inline]
 #0: ffff88802457a428 (sb_writers#13){.+.+}-{0:0}, at: vfs_writev+0x288/0x960 fs/read_write.c:1055
1 lock held by syz.3.63/6745:
 #0: ffff888047965948 (vm_lock){++++}-{0:0}, at: do_user_addr_fault+0x2d9/0x1390 arch/x86/mm/fault.c:1327
1 lock held by syz.3.63/6746:
 #0: ffff888056663810 (mapping.invalidate_lock#3){.+.+}-{4:4}, at: filemap_invalidate_lock_shared include/linux/fs.h:934 [inline]
 #0: ffff888056663810 (mapping.invalidate_lock#3){.+.+}-{4:4}, at: page_cache_ra_order+0x445/0xc70 mm/readahead.c:491
1 lock held by syz.3.63/6801:
 #0: ffff88802a336428 (sb_writers#13){.+.+}-{0:0}, at: file_start_write include/linux/fs.h:3096 [inline]
 #0: ffff88802a336428 (sb_writers#13){.+.+}-{0:0}, at: vfs_writev+0x288/0x960 fs/read_write.c:1055
3 locks held by syz-executor/6934:
 #0: ffff88807577a0e0 (&type->s_umount_key#54){++++}-{4:4}, at: __super_lock fs/super.c:57 [inline]
 #0: ffff88807577a0e0 (&type->s_umount_key#54){++++}-{4:4}, at: __super_lock_excl fs/super.c:72 [inline]
 #0: ffff88807577a0e0 (&type->s_umount_key#54){++++}-{4:4}, at: deactivate_super+0xa9/0xe0 fs/super.c:506
 #1: ffff8880b3780278 (&c->state_lock){+.+.}-{4:4}, at: __bch2_fs_stop+0xf8/0x900 fs/bcachefs/super.c:677
 #2: ffff8880b3780918 (&c->sb_lock){+.+.}-{4:4}, at: bch2_fs_mark_clean+0x44/0x380 fs/bcachefs/sb-clean.c:292
1 lock held by syz.5.115/7450:
 #0: ffff888054ecf808 (vm_lock){++++}-{0:0}, at: do_user_addr_fault+0x2d9/0x1390 arch/x86/mm/fault.c:1327
1 lock held by syz.5.115/7451:
 #0: ffff8880564e5e08 (mapping.invalidate_lock#3){.+.+}-{4:4}, at: filemap_invalidate_lock_shared include/linux/fs.h:934 [inline]
 #0: ffff8880564e5e08 (mapping.invalidate_lock#3){.+.+}-{4:4}, at: page_cache_ra_order+0x445/0xc70 mm/readahead.c:491
1 lock held by syz.5.115/7498:
 #0: ffff888030e24428 (sb_writers#13){.+.+}-{0:0}, at: file_start_write include/linux/fs.h:3096 [inline]
 #0: ffff888030e24428 (sb_writers#13){.+.+}-{0:0}, at: vfs_writev+0x288/0x960 fs/read_write.c:1055
1 lock held by syz.7.130/7767:
 #0: ffff888048694bc8 (vm_lock){++++}-{0:0}, at: do_user_addr_fault+0x2d9/0x1390 arch/x86/mm/fault.c:1327
1 lock held by syz.7.130/7768:
 #0: ffff8880564e3fa8 (mapping.invalidate_lock#3){.+.+}-{4:4}, at: filemap_invalidate_lock_shared include/linux/fs.h:934 [inline]
 #0: ffff8880564e3fa8 (mapping.invalidate_lock#3){.+.+}-{4:4}, at: page_cache_ra_order+0x445/0xc70 mm/readahead.c:491
1 lock held by syz.7.130/7816:
 #0: ffff888032802428 (sb_writers#13){.+.+}-{0:0}, at: file_start_write include/linux/fs.h:3096 [inline]
 #0: ffff888032802428 (sb_writers#13){.+.+}-{0:0}, at: vfs_writev+0x288/0x960 fs/read_write.c:1055
3 locks held by syz-executor/7973:
 #0: ffff88807b4300e0 (&type->s_umount_key#54){++++}-{4:4}, at: __super_lock fs/super.c:57 [inline]
 #0: ffff88807b4300e0 (&type->s_umount_key#54){++++}-{4:4}, at: __super_lock_excl fs/super.c:72 [inline]
 #0: ffff88807b4300e0 (&type->s_umount_key#54){++++}-{4:4}, at: deactivate_super+0xa9/0xe0 fs/super.c:506
 #1: ffff888097700278 (&c->state_lock){+.+.}-{4:4}, at: __bch2_fs_stop+0xf8/0x900 fs/bcachefs/super.c:677
 #2: ffff888097700918 (&c->sb_lock){+.+.}-{4:4}, at: bch2_fs_mark_clean+0x44/0x380 fs/bcachefs/sb-clean.c:292
2 locks held by syz.2.173/8269:

=============================================

NMI backtrace for cpu 0
CPU: 0 UID: 0 PID: 31 Comm: khungtaskd Not tainted 6.16.0-rc2-syzkaller-00024-g9afe652958c3 #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 05/07/2025
Call Trace:
 <TASK>
 dump_stack_lvl+0x189/0x250 lib/dump_stack.c:120
 nmi_cpu_backtrace+0x39e/0x3d0 lib/nmi_backtrace.c:113
 nmi_trigger_cpumask_backtrace+0x17a/0x300 lib/nmi_backtrace.c:62
 trigger_all_cpu_backtrace include/linux/nmi.h:158 [inline]
 check_hung_uninterruptible_tasks kernel/hung_task.c:307 [inline]
 watchdog+0xfee/0x1030 kernel/hung_task.c:470
 kthread+0x70e/0x8a0 kernel/kthread.c:464
 ret_from_fork+0x3f9/0x770 arch/x86/kernel/process.c:148
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>
Sending NMI from CPU 0 to CPUs 1:
NMI backtrace for cpu 1
CPU: 1 UID: 0 PID: 23 Comm: ksoftirqd/1 Not tainted 6.16.0-rc2-syzkaller-00024-g9afe652958c3 #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 05/07/2025
RIP: 0010:__orc_find arch/x86/kernel/unwind_orc.c:100 [inline]
RIP: 0010:orc_find arch/x86/kernel/unwind_orc.c:227 [inline]
RIP: 0010:unwind_next_frame+0x12e3/0x2390 arch/x86/kernel/unwind_orc.c:494
Code: 18 48 8b 10 48 c7 c7 00 3a 88 8b 89 de e8 55 de b4 ff e9 43 06 00 00 49 89 d5 48 89 d5 48 89 d8 48 29 e8 48 89 c1 48 c1 f9 02 <48> c1 e8 3f 48 01 c8 48 83 e0 fe 4c 8d 3c 45 00 00 00 00 49 01 ef
RSP: 0018:ffffc900001d7398 EFLAGS: 00000202
RAX: 0000000000000004 RBX: ffffffff8fb37924 RCX: 0000000000000001
RDX: ffffffff8fb37904 RSI: ffffffff902e9bf0 RDI: ffffffff8be1b7a0
RBP: ffffffff8fb37920 R08: 0000000000000009 R09: ffffffff81729af5
R10: ffffc900001d74c8 R11: fffff5200003aea5 R12: ffffffff8172c397
R13: ffffffff8fb3791c R14: ffffc900001d74c8 R15: ffffffff8fb3791c
FS:  0000000000000000(0000) GS:ffff888125d85000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fc7ecf3d000 CR3: 000000002fea8000 CR4: 00000000003526f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 __unwind_start+0x5b9/0x760 arch/x86/kernel/unwind_orc.c:758
 unwind_start arch/x86/include/asm/unwind.h:64 [inline]
 arch_stack_walk+0xe4/0x150 arch/x86/kernel/stacktrace.c:24
 stack_trace_save+0x9c/0xe0 kernel/stacktrace.c:122
 kasan_save_stack mm/kasan/common.c:47 [inline]
 kasan_save_track+0x3e/0x80 mm/kasan/common.c:68
 kasan_save_free_info+0x46/0x50 mm/kasan/generic.c:576
 poison_slab_object mm/kasan/common.c:247 [inline]
 __kasan_slab_free+0x62/0x70 mm/kasan/common.c:264
 kasan_slab_free include/linux/kasan.h:233 [inline]
 slab_free_hook mm/slub.c:2381 [inline]
 slab_free mm/slub.c:4643 [inline]
 kfree+0x18e/0x440 mm/slub.c:4842
 slab_free_after_rcu_debug+0x60/0x2a0 mm/slub.c:4680
 rcu_do_batch kernel/rcu/tree.c:2576 [inline]
 rcu_core+0xca8/0x1710 kernel/rcu/tree.c:2832
 handle_softirqs+0x286/0x870 kernel/softirq.c:579
 run_ksoftirqd+0x9b/0x100 kernel/softirq.c:968
 smpboot_thread_fn+0x53f/0xa60 kernel/smpboot.c:164
 kthread+0x70e/0x8a0 kernel/kthread.c:464
 ret_from_fork+0x3f9/0x770 arch/x86/kernel/process.c:148
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>


---
If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.

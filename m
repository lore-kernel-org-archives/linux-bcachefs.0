Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 748BA1E520A;
	Fri,  8 Aug 2025 05:36:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754631407; cv=none; b=fVbYDtW6vS2c0KHV1g8jegja8vR4BbJSTI3U2eZc8icQXyjrV3FnixpKj/A4/PP8KkAZ8/FC2+BALVQtGaU4OL++mJk7xoNVc0SYgx/ayKE/FoQ1aIwy9tRxDX7FO8iBRFLmZ110bdJyR85FdIAwtk5+rUDMf6FM1rYulGDSW9M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754631407; c=relaxed/simple;
	bh=NOFODb8Fs8lgHN8K7lu2Xkwwuab7kk3BONB2NgQM6qc=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=bBXX4EMQwfzw3EfYmsE0eDVtz1AHVlBvaBJtES1yHwnSw+rfk/rZ3RqC3DzGhQ0QpuLOq8zWuR9MkVpx4XIW5G5c5+afLGtTLhtNm1t9K/MB6ExeYI+9JP8KSPWVAljnk86fj6G8OUJXvqRP4bDmhBaRe29EwgKGgzaNpR0WyXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=B+ch7kId; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="B+ch7kId"
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-2401b855980so12733965ad.1;
        Thu, 07 Aug 2025 22:36:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754631405; x=1755236205; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dAOwONoshHWL7Z9YMNXuFgNTrd/NInlgE1BvtCEip/Y=;
        b=B+ch7kIdX+2fmbhyd7sJ42M4lcClNdVqQMRBLce+hhK32tvDuLMu7NkyGZq4jn8LLM
         QYGbNxktBNifUzDj1tsPjPzwTraMH+KukeG/DbBhqp5fOGh2pvo3kFr2dtMQCmH1hC3Z
         dTaXFv0RQ6Krwsxl7ukli8nYwEeuOVDnrMdgGZBEXvy4O3IyAOq1Xw8h/ih6Le4Qor7+
         GNtDoWUvcgsu9BLGV81oIWV8WdG/cenCQ3fBlsu+MT6igBOMZAAYByHz/YInY/1AQ9G9
         BbS5vCS4qjZ3l7WKLpptdV0hAUlALy7xzCFk7SMRa/79pjAeN52H//+pOLK953zM1E9i
         CZ+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754631405; x=1755236205;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dAOwONoshHWL7Z9YMNXuFgNTrd/NInlgE1BvtCEip/Y=;
        b=PgCcwTCg6RaHKCUuDY09BaufBXoM8eF/Mmq2M3T149nWmYZ71vPsEONfFt/bh7jw8r
         HeKG2QJWxGbHdfJSdHxqHsUYlB4Iuezo43Phl1Vx2GZaPN60ASXnp3Jw1bPA6iXgnrBR
         fotqmicq68xuF/sFzjlT5RgfEcFXLQW3K23UVezlURIoxDLL0bVqCZa/sQ8NbFAfu5e1
         TyJX5GK8GMbktVzOPVV4It+adfAWteNZSzfycifvjOcOawen0hkR2FfcTlMirYKnIiIF
         IskvdJytQrkkVBe6cKvF+Zw3xyNh8kvBG+eQ2ePT0N8p8rdqW57tXQZm+juUJvqjG3Pd
         mYiQ==
X-Forwarded-Encrypted: i=1; AJvYcCUpFLRCbjRf8aTfPvyh+mlryKLJXHnBzSuhKPhNADHBgmGQMiCqsjAm4lYebKmD7EDXy4maJsf78W0ecJhn@vger.kernel.org, AJvYcCWStJheZJicWZHe7XwvJEsB7T7KEJ54Qoslv8+emrIVWWal3nNhpCYj+LIK4+MyM1iq+oy6GcBDYzC6ZCYuag==@vger.kernel.org
X-Gm-Message-State: AOJu0YwWukk8c7DYCudf57xMOZTe3OyjAPthYn9FqLRrVMiy3XVLcH01
	tk2ofkITRqfL/UPvholNphvrLddRJWC3vhwLPCAaiH8VFAlD/d7Yghw/
X-Gm-Gg: ASbGnct6sipPGbsRjsuc/J1aHcLfIWziAuo1jwakAls6QxbrYzJ+gMaswktSZDZydhC
	xJNB6csCEa06rbTWOPmOhQ2fDeDNhRYk3cO7sSLEiTInVa4J3XjeEX+o2vPUO2ptwrhe/fxAuBT
	pZfQXXeAZtURNwy+/XWsn6/ftEWk9rYJm5rbASJHI+my//mXCxbSV5qCtJMy3MGuBi6Z/McQ7+o
	+JdBF3z40eaxX61UHCjte9iTVUWJL17NXldfdBMs1A/lPRP57ileFtrPvd43Cs3LTGXLO83fnX9
	6seMoVeXPbUcSKTxql4OyX8ZXnofHE1RRUTqaPPxt47QP4NgBS922CBt2wWK+YaP78Y62jkWSu0
	Z0SV4bQ==
X-Google-Smtp-Source: AGHT+IG2GN/6kFfFNp2zIqdCbmV4t3f+TYYHCvN//JrZRLVC42Y155nYaeNngKvkaocyATflE5ydnw==
X-Received: by 2002:a17:902:ec83:b0:240:a54e:21a0 with SMTP id d9443c01a7336-242c2007513mr24077225ad.19.1754631404450;
        Thu, 07 Aug 2025 22:36:44 -0700 (PDT)
Received: from smtpclient.apple ([2402:d0c0:11:86::1])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-241e8977345sm198030945ad.108.2025.08.07.22.36.41
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 07 Aug 2025 22:36:43 -0700 (PDT)
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3826.500.181.1.5\))
Subject: Re: [syzbot] [bcachefs?] INFO: task hung in bch2_readahead
From: Alan Huang <mmpgouride@gmail.com>
In-Reply-To: <000000000000545c120618dd6c63@google.com>
Date: Fri, 8 Aug 2025 13:36:28 +0800
Cc: bfoster@redhat.com,
 kent.overstreet@linux.dev,
 linux-bcachefs@vger.kernel.org,
 linux-kernel@vger.kernel.org,
 syzkaller-bugs@googlegroups.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <A89C0538-E1EF-473B-8E95-F5BDE272E03C@gmail.com>
References: <000000000000545c120618dd6c63@google.com>
To: syzbot <syzbot+a6060114362257e9798a@syzkaller.appspotmail.com>
X-Mailer: Apple Mail (2.3826.500.181.1.5)

On May 20, 2024, at 15:12, syzbot =
<syzbot+a6060114362257e9798a@syzkaller.appspotmail.com> wrote:
>=20
> Hello,
>=20
> syzbot found the following issue on:
>=20
> HEAD commit:    8c06da67d0bd Merge tag 'livepatching-for-6.10' of =
git://gi..
> git tree:       upstream
> console output: =
https://syzkaller.appspot.com/x/log.txt?x=3D11e74ef4980000
> kernel config:  =
https://syzkaller.appspot.com/x/.config?x=3Dcc69cd6a2dcb5aa
> dashboard link: =
https://syzkaller.appspot.com/bug?extid=3Da6060114362257e9798a
> compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for =
Debian) 2.40
>=20
> Unfortunately, I don't have any reproducer for this issue yet.
>=20
> Downloadable assets:
> disk image: =
https://storage.googleapis.com/syzbot-assets/331202aeac12/disk-8c06da67.ra=
w.xz
> vmlinux: =
https://storage.googleapis.com/syzbot-assets/4db56871f364/vmlinux-8c06da67=
.xz
> kernel image: =
https://storage.googleapis.com/syzbot-assets/2ab7bc870390/bzImage-8c06da67=
.xz
>=20
> IMPORTANT: if you fix the issue, please add the following tag to the =
commit:
> Reported-by: syzbot+a6060114362257e9798a@syzkaller.appspotmail.com
>=20
> INFO: task syz-executor.4:6256 blocked for more than 143 seconds.
>      Not tainted 6.9.0-syzkaller-07387-g8c06da67d0bd #0
> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this =
message.
> task:syz-executor.4  state:D stack:14936 pid:6256  tgid:6255  =
ppid:5481   flags:0x00004006
> Call Trace:
> <TASK>
> context_switch kernel/sched/core.c:5409 [inline]
> __schedule+0x1796/0x4a00 kernel/sched/core.c:6746
> __schedule_loop kernel/sched/core.c:6823 [inline]
> schedule+0x14b/0x320 kernel/sched/core.c:6838
> __bch2_two_state_lock+0x171/0x200 =
fs/bcachefs/two_state_shared_lock.c:7
> bch2_two_state_lock fs/bcachefs/two_state_shared_lock.h:56 [inline]
> bch2_readahead+0xcf5/0x1870 fs/bcachefs/fs-io-buffered.c:277
> read_pages+0x17e/0x840 mm/readahead.c:160
> page_cache_ra_order+0xa62/0xcc0 mm/readahead.c:531
> filemap_readahead mm/filemap.c:2480 [inline]
> filemap_get_pages+0x743/0x2090 mm/filemap.c:2521
> filemap_splice_read+0x654/0xeb0 mm/filemap.c:2870
> do_splice_read fs/splice.c:985 [inline]
> splice_direct_to_actor+0x4b7/0xc90 fs/splice.c:1089
> do_splice_direct_actor fs/splice.c:1207 [inline]
> do_splice_direct+0x28c/0x3e0 fs/splice.c:1233
> do_sendfile+0x56d/0xdc0 fs/read_write.c:1295
> __do_sys_sendfile64 fs/read_write.c:1362 [inline]
> __se_sys_sendfile64+0x17c/0x1e0 fs/read_write.c:1348
> do_syscall_x64 arch/x86/entry/common.c:52 [inline]
> do_syscall_64+0xf5/0x240 arch/x86/entry/common.c:83
> entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f8ff447cee9
> RSP: 002b:00007f8ff52d30c8 EFLAGS: 00000246 ORIG_RAX: 0000000000000028
> RAX: ffffffffffffffda RBX: 00007f8ff45abf80 RCX: 00007f8ff447cee9
> RDX: 0000000000000000 RSI: 0000000000000005 RDI: 0000000000000006
> RBP: 00007f8ff44c949e R08: 0000000000000000 R09: 0000000000000000
> R10: 000000007ffff000 R11: 0000000000000246 R12: 0000000000000000
> R13: 000000000000000b R14: 00007f8ff45abf80 R15: 00007ffe62ab44e8
> </TASK>
> INFO: task syz-executor.4:6292 blocked for more than 144 seconds.
>      Not tainted 6.9.0-syzkaller-07387-g8c06da67d0bd #0
> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this =
message.
> task:syz-executor.4  state:D
> stack:18064 pid:6292  tgid:6255  ppid:5481   flags:0x00004006
> Call Trace:
> <TASK>
> context_switch kernel/sched/core.c:5409 [inline]
> __schedule+0x1796/0x4a00 kernel/sched/core.c:6746
> __schedule_loop kernel/sched/core.c:6823 [inline]
> schedule+0x14b/0x320 kernel/sched/core.c:6838
> io_schedule+0x8d/0x110 kernel/sched/core.c:9044
> folio_wait_bit_common+0x882/0x12b0 mm/filemap.c:1283
> bch2_seek_pagecache_data+0x2c6/0xac0 fs/bcachefs/fs-io-pagecache.c:690
> bch2_clamp_data_hole+0x121/0x180 fs/bcachefs/fs-io-pagecache.c:793
> __bchfs_fallocate fs/bcachefs/fs-io.c:647 [inline]
> bchfs_fallocate fs/bcachefs/fs-io.c:733 [inline]
> bch2_fallocate_dispatch+0x1a84/0x3810 fs/bcachefs/fs-io.c:780
> vfs_fallocate+0x564/0x6c0 fs/open.c:330
> ksys_fallocate fs/open.c:353 [inline]
> __do_sys_fallocate fs/open.c:361 [inline]
> __se_sys_fallocate fs/open.c:359 [inline]
> __x64_sys_fallocate+0xbd/0x110 fs/open.c:359
> do_syscall_x64 arch/x86/entry/common.c:52 [inline]
> do_syscall_64+0xf5/0x240 arch/x86/entry/common.c:83
> entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f8ff447cee9
> RSP: 002b:00007f8ff52b20c8 EFLAGS: 00000246 ORIG_RAX: 000000000000011d
> RAX: ffffffffffffffda RBX: 00007f8ff45ac050 RCX: 00007f8ff447cee9
> RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000004
> RBP: 00007f8ff44c949e R08: 0000000000000000 R09: 0000000000000000
> R10: 00000000001000f4 R11: 0000000000000246 R12: 0000000000000000
> R13: 000000000000006e R14: 00007f8ff45ac050 R15: 00007ffe62ab44e8
> </TASK>
> INFO: task syz-executor.4:6293 blocked for more than 144 seconds.
>      Not tainted 6.9.0-syzkaller-07387-g8c06da67d0bd #0
> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this =
message.
> task:syz-executor.4  state:D stack:28656 pid:6293  tgid:6255  =
ppid:5481   flags:0x00000006
> Call Trace:
> <TASK>
> context_switch kernel/sched/core.c:5409 [inline]
> __schedule+0x1796/0x4a00 kernel/sched/core.c:6746
> __schedule_loop kernel/sched/core.c:6823 [inline]
> schedule+0x14b/0x320 kernel/sched/core.c:6838
> __bch2_two_state_lock+0x171/0x200 =
fs/bcachefs/two_state_shared_lock.c:7
> bch2_two_state_lock fs/bcachefs/two_state_shared_lock.h:56 [inline]
> bch2_buffered_write fs/bcachefs/fs-io-buffered.c:1045 [inline]
> bch2_write_iter+0x410/0x2840 fs/bcachefs/fs-io-buffered.c:1144
> call_write_iter include/linux/fs.h:2120 [inline]
> new_sync_write fs/read_write.c:497 [inline]
> vfs_write+0xa2d/0xc50 fs/read_write.c:590
> ksys_write+0x1a0/0x2c0 fs/read_write.c:643
> do_syscall_x64 arch/x86/entry/common.c:52 [inline]
> do_syscall_64+0xf5/0x240 arch/x86/entry/common.c:83
> entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f8ff447cee9
> RSP: 002b:00007f8ff52910c8 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
> RAX: ffffffffffffffda RBX: 00007f8ff45ac120 RCX: 00007f8ff447cee9
> RDX: 0000000000000009 RSI: 0000000020000040 RDI: 0000000000000004
> RBP: 00007f8ff44c949e R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 000000000000006e R14: 00007f8ff45ac120 R15: 00007ffe62ab44e8
> </TASK>
>=20
> Showing all locks held in the system:
> 1 lock held by khungtaskd/30:
> #0: ffffffff8e3361e0 (rcu_read_lock){....}-{1:2}, at: rcu_lock_acquire =
include/linux/rcupdate.h:329 [inline]
> #0: ffffffff8e3361e0 (rcu_read_lock){....}-{1:2}, at: rcu_read_lock =
include/linux/rcupdate.h:781 [inline]
> #0: ffffffff8e3361e0 (rcu_read_lock){....}-{1:2}, at: =
debug_show_all_locks+0x55/0x2a0 kernel/locking/lockdep.c:6614
> 4 locks held by kworker/u8:9/2838:
> #0: ffff888015ed3148 ((wq_completion)netns){+.+.}-{0:0}, at: =
process_one_work kernel/workqueue.c:3242 [inline]
> #0: ffff888015ed3148 ((wq_completion)netns){+.+.}-{0:0}, at: =
process_scheduled_works+0x8e0/0x17c0 kernel/workqueue.c:3348
> #1: ffffc9000a487d00 (net_cleanup_work){+.+.}-{0:0}, at: =
process_one_work kernel/workqueue.c:3243 [inline]
> #1: ffffc9000a487d00 (net_cleanup_work){+.+.}-{0:0}, at: =
process_scheduled_works+0x91b/0x17c0 kernel/workqueue.c:3348
> #2: ffffffff8f5c1a10 (pernet_ops_rwsem){++++}-{3:3}, at: =
cleanup_net+0x16a/0xcc0 net/core/net_namespace.c:594
> #3: ffffffff8f5ce3c8 (rtnl_mutex){+.+.}-{3:3}, at: =
default_device_exit_batch+0xe9/0xa90 net/core/dev.c:11745
> 2 locks held by dhcpcd/4752:
> #0: ffff888061cc6678 (nlk_cb_mutex-ROUTE){+.+.}-{3:3}, at: =
__netlink_dump_start+0x119/0x780 net/netlink/af_netlink.c:2418
> #1: ffffffff8f5ce3c8 (rtnl_mutex){+.+.}-{3:3}, at: =
netlink_dump+0x5d3/0xe50 net/netlink/af_netlink.c:2336
> 2 locks held by getty/4839:
> #0: ffff8880785280a0 (&tty->ldisc_sem){++++}-{0:0}, at: =
tty_ldisc_ref_wait+0x25/0x70 drivers/tty/tty_ldisc.c:243
> #1: ffffc90002f162f0 (&ldata->atomic_read_lock){+.+.}-{3:3}, at: =
n_tty_read+0x6b5/0x1e10 drivers/tty/n_tty.c:2201
> 2 locks held by syz-executor.4/6256:
> #0: ffff88805683be30 (mapping.invalidate_lock#4){.+.+}-{3:3}, at: =
filemap_invalidate_lock_shared include/linux/fs.h:846 [inline]
> #0: ffff88805683be30 (mapping.invalidate_lock#4){.+.+}-{3:3}, at: =
page_cache_ra_order+0x3bc/0xcc0 mm/readahead.c:510
> #1: ffff888050b84250 (&c->btree_trans_barrier){.+.+}-{0:0}, at: =
srcu_lock_acquire include/linux/srcu.h:116 [inline]
> #1: ffff888050b84250 (&c->btree_trans_barrier){.+.+}-{0:0}, at: =
srcu_read_lock include/linux/srcu.h:215 [inline]
> #1: ffff888050b84250 (&c->btree_trans_barrier){.+.+}-{0:0}, at: =
__bch2_trans_get+0x911/0xd30 fs/bcachefs/btree_iter.c:3069
> 3 locks held by syz-executor.4/6292:
> #0: ffff8880242c2420 (sb_writers#14){.+.+}-{0:0}, at: file_start_write =
include/linux/fs.h:2871 [inline]
> #0: ffff8880242c2420 (sb_writers#14){.+.+}-{0:0}, at: =
vfs_fallocate+0x4d3/0x6c0 fs/open.c:329
> #1: ffff88805683bc90 (&sb->s_type->i_mutex_key#22){+.+.}-{3:3}, at: =
inode_lock include/linux/fs.h:791 [inline]
> #1: ffff88805683bc90 (&sb->s_type->i_mutex_key#22){+.+.}-{3:3}, at: =
bch2_fallocate_dispatch+0x295/0x3810 fs/bcachefs/fs-io.c:771
> #2: ffff888050b84250 (&c->btree_trans_barrier){.+.+}-{0:0}, at: =
srcu_lock_acquire include/linux/srcu.h:116 [inline]
> #2: ffff888050b84250 (&c->btree_trans_barrier){.+.+}-{0:0}, at: =
srcu_read_lock include/linux/srcu.h:215 [inline]
> #2: ffff888050b84250 (&c->btree_trans_barrier){.+.+}-{0:0}, at: =
bch2_trans_srcu_lock+0xb1/0x220 fs/bcachefs/btree_iter.c:2896
> 2 locks held by syz-executor.4/6293:
> #0: ffff8880246754c8 (&f->f_pos_lock){+.+.}-{3:3}, at: =
__fdget_pos+0x259/0x320 fs/file.c:1191
> #1: ffff8880242c2420 (sb_writers#14){.+.+}-{0:0}, at: file_start_write =
include/linux/fs.h:2871 [inline]
> #1: ffff8880242c2420 (sb_writers#14){.+.+}-{0:0}, at: =
vfs_write+0x227/0xc50 fs/read_write.c:586
> 1 lock held by syz-executor.1/8207:
> #0: ffffffff8e33b5b8 (rcu_state.exp_mutex){+.+.}-{3:3}, at: =
exp_funnel_lock kernel/rcu/tree_exp.h:323 [inline]
> #0: ffffffff8e33b5b8 (rcu_state.exp_mutex){+.+.}-{3:3}, at: =
synchronize_rcu_expedited+0x451/0x830 kernel/rcu/tree_exp.h:939
> 1 lock held by syz-executor.0/8583:
> #0: ffffffff8f5ce3c8 (rtnl_mutex){+.+.}-{3:3}, at: rtnl_lock =
net/core/rtnetlink.c:79 [inline]
> #0: ffffffff8f5ce3c8 (rtnl_mutex){+.+.}-{3:3}, at: __rtnl_newlink =
net/core/rtnetlink.c:3720 [inline]
> #0: ffffffff8f5ce3c8 (rtnl_mutex){+.+.}-{3:3}, at: =
rtnl_newlink+0xab5/0x20a0 net/core/rtnetlink.c:3743
> 5 locks held by syz-executor.3/8673:
> 2 locks held by syz-executor.4/8675:
>=20
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>=20
> NMI backtrace for cpu 0
> CPU: 0 PID: 30 Comm: khungtaskd Not tainted =
6.9.0-syzkaller-07387-g8c06da67d0bd #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, =
BIOS Google 04/02/2024
> Call Trace:
> <TASK>
> __dump_stack lib/dump_stack.c:88 [inline]
> dump_stack_lvl+0x241/0x360 lib/dump_stack.c:114
> nmi_cpu_backtrace+0x49c/0x4d0 lib/nmi_backtrace.c:113
> nmi_trigger_cpumask_backtrace+0x198/0x320 lib/nmi_backtrace.c:62
> trigger_all_cpu_backtrace include/linux/nmi.h:160 [inline]
> check_hung_uninterruptible_tasks kernel/hung_task.c:223 [inline]
> watchdog+0xfde/0x1020 kernel/hung_task.c:380
> kthread+0x2f0/0x390 kernel/kthread.c:389
> ret_from_fork+0x4b/0x80 arch/x86/kernel/process.c:147
> ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244
> </TASK>
> Sending NMI from CPU 0 to CPUs 1:
> NMI backtrace for cpu 1
> CPU: 1 PID: 8673 Comm: syz-executor.3 Not tainted =
6.9.0-syzkaller-07387-g8c06da67d0bd #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, =
BIOS Google 04/02/2024
> RIP: 0010:rcu_dynticks_curr_cpu_in_eqs =
include/linux/context_tracking.h:122 [inline]
> RIP: 0010:rcu_is_watching+0x3a/0xb0 kernel/rcu/tree.c:724
> Code: e8 4b 7c 02 0a 89 c3 83 f8 08 73 7a 49 bf 00 00 00 00 00 fc ff =
df 4c 8d 34 dd 20 7a d9 8d 4c 89 f0 48 c1 e8 03 42 80 3c 38 00 <74> 08 =
4c 89 f7 e8 ac 73 7b 00 48 c7 c3 08 7d 03 00 49 03 1e 48 89
> RSP: 0018:ffffc9000306f600 EFLAGS: 00000246
> RAX: 1ffffffff1bb2f45 RBX: 0000000000000001 RCX: ffffffff8172f1b0
> RDX: 0000000000000000 RSI: ffffffff8c1edc40 RDI: ffffffff8c1edc00
> RBP: ffffc9000306f758 R08: ffffffff8fabae2f R09: 1ffffffff1f575c5
> R10: dffffc0000000000 R11: fffffbfff1f575c6 R12: 1ffff9200060ded0
> R13: ffffffff82010bf4 R14: ffffffff8dd97a28 R15: dffffc0000000000
> FS:  00007f9c691596c0(0000) GS:ffff8880b9500000(0000) =
knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 000055558e530978 CR3: 000000002931c000 CR4: 00000000003506f0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
> <NMI>
> </NMI>
> <TASK>
> trace_lock_release include/trace/events/lock.h:69 [inline]
> lock_release+0xbf/0x9f0 kernel/locking/lockdep.c:5765
> rcu_lock_release include/linux/rcupdate.h:339 [inline]
> rcu_read_unlock include/linux/rcupdate.h:812 [inline]
> percpu_ref_tryget_many include/linux/percpu-refcount.h:250 [inline]
> percpu_ref_tryget+0xf7/0x180 include/linux/percpu-refcount.h:266
> css_tryget include/linux/cgroup_refcnt.h:45 [inline]
> get_mem_cgroup_from_mm+0x103/0x2a0 mm/memcontrol.c:1112
> __mem_cgroup_charge+0x16/0x80 mm/memcontrol.c:7298
> mem_cgroup_charge include/linux/memcontrol.h:691 [inline]
> shmem_alloc_and_add_folio+0x456/0xbc0 mm/shmem.c:1677
> shmem_get_folio_gfp+0x82d/0x1f50 mm/shmem.c:2055
> shmem_get_folio mm/shmem.c:2160 [inline]
> shmem_write_begin+0x170/0x4d0 mm/shmem.c:2744
> generic_perform_write+0x322/0x640 mm/filemap.c:3974
> shmem_file_write_iter+0xfc/0x120 mm/shmem.c:2920
> call_write_iter include/linux/fs.h:2120 [inline]
> new_sync_write fs/read_write.c:497 [inline]
> vfs_write+0xa2d/0xc50 fs/read_write.c:590
> ksys_write+0x1a0/0x2c0 fs/read_write.c:643
> do_syscall_x64 arch/x86/entry/common.c:52 [inline]
> do_syscall_64+0xf5/0x240 arch/x86/entry/common.c:83
> entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f9c6847bc2f
> Code: 89 54 24 18 48 89 74 24 10 89 7c 24 08 e8 b9 80 02 00 48 8b 54 =
24 18 48 8b 74 24 10 41 89 c0 8b 7c 24 08 b8 01 00 00 00 0f 05 <48> 3d =
00 f0 ff ff 77 31 44 89 c7 48 89 44 24 08 e8 0c 81 02 00 48
> RSP: 002b:00007f9c69158e80 EFLAGS: 00000293 ORIG_RAX: 0000000000000001
> RAX: ffffffffffffffda RBX: 00000000013bd7ef RCX: 00007f9c6847bc2f
> RDX: 00000000013bd7ef RSI: 00007f9c5e200000 RDI: 0000000000000005
> RBP: 0000000000000000 R08: 0000000000000000 R09: 000000000000551e
> R10: 00000000000003c8 R11: 0000000000000293 R12: 0000000000000005
> R13: 00007f9c69158f80 R14: 00007f9c69158f40 R15: 00007f9c5e200000
> </TASK>
>=20
>=20
> ---
> This report is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
>=20
> syzbot will keep track of this issue. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
>=20
> If the report is already addressed, let syzbot know by replying with:
> #syz fix: exact-commit-title
>=20
> If you want to overwrite report's subsystems, reply with:
> #syz set subsystems: new-subsystem
> (See the list of subsystem names on the web dashboard)
>=20
> If the report is a duplicate of another one, reply with:
> #syz dup: exact-subject-of-another-report
>=20
> If you want to undo deduplication, reply with:
> #syz undup
>=20

#syz fix: bcachefs: Fix readahead involved deadlock


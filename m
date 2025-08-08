Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4539C78F34;
	Fri,  8 Aug 2025 05:41:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754631710; cv=none; b=HU4wyPVrPU5ZxPyMCwF5ayJCjfgBApkqcoXeCnxQqhjJ8NFEE2sLLxrqMUXd+RMdO6eOGI1x9rRBBrLy7Nq+QpvzBLgsfFEtOhLlAnXsFOwUcZ1BTbfaJjm0MkOiUdPVNJIJxpAPd0jiCtQO3GMPjopH63SZQYOBZw7rz4DTKnk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754631710; c=relaxed/simple;
	bh=kH1qwvorQwD4jyhrWV/OmUdkXTuGxEnhVyp84SFmLNg=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=pMHimz6rIzybUCxPI1NJHm5c91k5q86u2kw+XMgkfSpNYIJuBSvRkq6vf8y+MpX46EHs0UF3rSfWTahauSWaArHnY6MWLcImwAzFHI+eO5OF3BdMBPypOH36P90ambd5dhWSJuZas3obfKb+JqbHTO+WolV4sRCLqU+D4lIwXcM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WPhp+I1d; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WPhp+I1d"
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-2429d9d3755so17969405ad.3;
        Thu, 07 Aug 2025 22:41:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754631708; x=1755236508; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=81gY6+gkAzrt8ggjZbUKzlUuh+M0RVofLrvG24esmoI=;
        b=WPhp+I1d0KRxCUelfxQhRA4LlaK4Eh72BSYfyqs74RkzWCLsVsh4FgVkRIRJ8myZKo
         xxDBp0qPP7QeCqiLNXHJeLdBJaZkd6K0zbI1hIglBBdS57ACxj2lnSwHrXfuZp24FPZQ
         m58QxhYOMebxTSYM44DZsFEjL+ayTX8VIsVOvOQw6zarevQ/usdGx+odFTKsSFbiodgN
         w1mAnHJZVF4FmGY4oK7LoaHMwI1CSpngAe5hqbXLr1g/Eem8DWt29LJR6rdz4s2sPhC+
         M0v/6XxgfJp19qV92AXCTXxJd5/YFdApYkfqUC7bJIOeQbP/bY6WbF/A3/TuSn9kFev6
         f+Vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754631708; x=1755236508;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=81gY6+gkAzrt8ggjZbUKzlUuh+M0RVofLrvG24esmoI=;
        b=sjKZNfcdu44v/wYA+FrXQVqXi6dE/5M/oAB0ZzR3tYrHkOYuGmOmQlY03Htbwbgmle
         onXMvQz/i9s9t3TvDJ6EG8mSKPQHYRxMFw9MjTqVyiTYSBzXaKOxCdRUJi5NAxbpChg0
         ftrLh7F4p65DGUyavUCuw1k3Ya1KtvlJcQMld0xuLEgdj0a+dcGKW5fWjDIvIN6eFY9S
         vA+/4ZFaWn3K5oafRYkuCedAlP3WjVeEYYCUJHAIsdgn2pe3JN+VlUau+VsO4x3j6oXH
         usM9AnoE7wdXqOQ8LXDFx0KmdDgbyZx6NnYsEW/KdE0NowHK/Qbp0qAUbQkgtnX6w0a4
         KmFg==
X-Forwarded-Encrypted: i=1; AJvYcCUHCd990gLZb/KPNXatElt/6rF2iCmlY4Kvb033rpTj8ZEV7sTSxch9ALdgnoG5Lwq8mpmguDWneaolXc35pg==@vger.kernel.org, AJvYcCXMxxgFu5UcEKvPa0bj7cXauWaJKDrt/ArVJeTNPq2D5mZH/z3v68ViUbdTtiMLia/s8p1HnbbfXEX3eurM@vger.kernel.org
X-Gm-Message-State: AOJu0YyGx/XnCEv2ngScTxe/LMMFdlH5KxIXRKqBO+A6biS07BI1b3t4
	sYciy05XTgwCtn6mGK8/6HN67Ma9moXPihCf8ibYFxDimDBe75qLt8bxpJih8g==
X-Gm-Gg: ASbGncsu2Ovpy7mIsnJMsTgMuLaY6nXI8YhWC1Wwq4K2o1EzNrU3Dl4tZ9uL9JTGr1B
	e/gxZ5rUAsIzamDYWaNhbv2sJ61im9tHdsvSpYOnHOcXHQVn4veVLylY+KwUz31E0Bcq7o/dif8
	jjA/N4H7hzDXzsDO9B7VN7aQSAiQ/FzuvIF9JctLF+nbN+Ewuy01JhKffsPxikojot2hqgId2rO
	0StG6Mli9Xn4cnXOoKN1V1/oCZ33rxy7CmuAUd98qw1wLmmKDQni/tYADRPf//8pMp0h6pdCyEs
	W0uztOyjiCKOKODM0bevGYWALEKv/rWGqOoSKC7r6JThm65PgnU36zMo1b+yEQ5OTs1fN4IHAB7
	4WWBNfg==
X-Google-Smtp-Source: AGHT+IHnlQb0Uhz0FixD8Q3HCkF+K3moaB9KAOdyYtefUJZ9mIJtkEvH3vuj3FoX3fOCU/Mso0TH1g==
X-Received: by 2002:a17:903:187:b0:242:3105:1787 with SMTP id d9443c01a7336-242c228d3b7mr23999235ad.50.1754631708372;
        Thu, 07 Aug 2025 22:41:48 -0700 (PDT)
Received: from smtpclient.apple ([2402:d0c0:11:86::1])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-241d1ef47f5sm198892685ad.10.2025.08.07.22.41.45
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 07 Aug 2025 22:41:47 -0700 (PDT)
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3826.500.181.1.5\))
Subject: Re: [syzbot] [bcachefs?] INFO: task hung in
 invalidate_inode_pages2_range (3)
From: Alan Huang <mmpgouride@gmail.com>
In-Reply-To: <67c16ce2.050a0220.1baf.000e.GAE@google.com>
Date: Fri, 8 Aug 2025 13:41:32 +0800
Cc: kent.overstreet@linux.dev,
 linux-bcachefs@vger.kernel.org,
 linux-kernel@vger.kernel.org,
 syzkaller-bugs@googlegroups.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <35B61A44-10F4-4A00-8FD1-8183C7F1EC95@gmail.com>
References: <67c16ce2.050a0220.1baf.000e.GAE@google.com>
To: syzbot <syzbot+de1434c5355cc909b734@syzkaller.appspotmail.com>
X-Mailer: Apple Mail (2.3826.500.181.1.5)

On Feb 28, 2025, at 15:59, syzbot =
<syzbot+de1434c5355cc909b734@syzkaller.appspotmail.com> wrote:
>=20
> Hello,
>=20
> syzbot found the following issue on:
>=20
> HEAD commit:    1e15510b71c9 Merge tag 'net-6.14-rc5' of =
git://git.kernel...
> git tree:       upstream
> console+strace: =
https://syzkaller.appspot.com/x/log.txt?x=3D164eca97980000
> kernel config:  =
https://syzkaller.appspot.com/x/.config?x=3D8de9cc84d5960254
> dashboard link: =
https://syzkaller.appspot.com/bug?extid=3Dde1434c5355cc909b734
> compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for =
Debian) 2.40
> syz repro:      =
https://syzkaller.appspot.com/x/repro.syz?x=3D11d297b8580000
> C reproducer:   =
https://syzkaller.appspot.com/x/repro.c?x=3D119af064580000
>=20
> Downloadable assets:
> disk image: =
https://storage.googleapis.com/syzbot-assets/ac4579f25f13/disk-1e15510b.ra=
w.xz
> vmlinux: =
https://storage.googleapis.com/syzbot-assets/c342a1d6167e/vmlinux-1e15510b=
.xz
> kernel image: =
https://storage.googleapis.com/syzbot-assets/d985a65df547/bzImage-1e15510b=
.xz
> mounted in repro: =
https://storage.googleapis.com/syzbot-assets/4860c171e0ab/mount_0.gz
>=20
> IMPORTANT: if you fix the issue, please add the following tag to the =
commit:
> Reported-by: syzbot+de1434c5355cc909b734@syzkaller.appspotmail.com
>=20
> INFO: task syz-executor337:5843 blocked for more than 143 seconds.
>      Not tainted 6.14.0-rc4-syzkaller-00169-g1e15510b71c9 #0
> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this =
message.
> task:syz-executor337 state:D stack:11416 pid:5843  tgid:5842  =
ppid:5840   task_flags:0x400140 flags:0x00004006
> Call Trace:
> <TASK>
> context_switch kernel/sched/core.c:5378 [inline]
> __schedule+0x18bc/0x4c40 kernel/sched/core.c:6765
> __schedule_loop kernel/sched/core.c:6842 [inline]
> schedule+0x14b/0x320 kernel/sched/core.c:6857
> io_schedule+0x8d/0x110 kernel/sched/core.c:7690
> folio_wait_bit_common+0x839/0xee0 mm/filemap.c:1318
> folio_lock include/linux/pagemap.h:1163 [inline]
> invalidate_inode_pages2_range+0x48f/0x960 mm/truncate.c:637
> bch2_write_invalidate_inode_pages_range+0xce/0x120 =
fs/bcachefs/fs-io-pagecache.c:68
> bch2_direct_write+0x2ebf/0x3190 fs/bcachefs/fs-io-direct.c:653
> bch2_write_iter+0x19d/0x2cd0 fs/bcachefs/fs-io-buffered.c:1047
> iter_file_splice_write+0xbfa/0x1510 fs/splice.c:743
> do_splice_from fs/splice.c:941 [inline]
> direct_splice_actor+0x11b/0x220 fs/splice.c:1164
> splice_direct_to_actor+0x586/0xc80 fs/splice.c:1108
> do_splice_direct_actor fs/splice.c:1207 [inline]
> do_splice_direct+0x289/0x3e0 fs/splice.c:1233
> do_sendfile+0x564/0x8a0 fs/read_write.c:1363
> __do_sys_sendfile64 fs/read_write.c:1424 [inline]
> __se_sys_sendfile64+0x17c/0x1e0 fs/read_write.c:1410
> do_syscall_x64 arch/x86/entry/common.c:52 [inline]
> do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
> entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f49c6338bd9
> RSP: 002b:00007f49c62ef218 EFLAGS: 00000246 ORIG_RAX: 0000000000000028
> RAX: ffffffffffffffda RBX: 00007f49c63c66c8 RCX: 00007f49c6338bd9
> RDX: 0000000000000000 RSI: 0000000000000005 RDI: 0000000000000005
> RBP: 00007f49c63c66c0 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000800000009 R11: 0000000000000246 R12: 00007f49c6392ae4
> R13: 0031656c69662f2e R14: 0000400000000240 R15: 0000400000000040
> </TASK>
> INFO: task syz-executor337:5854 blocked for more than 143 seconds.
>      Not tainted 6.14.0-rc4-syzkaller-00169-g1e15510b71c9 #0
> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this =
message.
> task:syz-executor337 state:D stack:19160 pid:5854  tgid:5842  =
ppid:5840   task_flags:0x440140 flags:0x00004006
> Call Trace:
> <TASK>
> context_switch kernel/sched/core.c:5378 [inline]
> __schedule+0x18bc/0x4c40 kernel/sched/core.c:6765
> __schedule_loop kernel/sched/core.c:6842 [inline]
> schedule+0x14b/0x320 kernel/sched/core.c:6857
> __bch2_two_state_lock+0x229/0x2c0 =
fs/bcachefs/two_state_shared_lock.c:7
> bch2_two_state_lock fs/bcachefs/two_state_shared_lock.h:55 [inline]
> bch2_readahead+0x9e1/0x1240 fs/bcachefs/fs-io-buffered.c:272
> read_pages+0x179/0x570 mm/readahead.c:161
> page_cache_ra_order+0xa36/0xca0 mm/readahead.c:516
> filemap_get_pages+0x59a/0x1fb0 mm/filemap.c:2580
> filemap_splice_read+0x68e/0xef0 mm/filemap.c:2971
> do_splice_read fs/splice.c:985 [inline]
> splice_direct_to_actor+0x4af/0xc80 fs/splice.c:1089
> do_splice_direct_actor fs/splice.c:1207 [inline]
> do_splice_direct+0x289/0x3e0 fs/splice.c:1233
> do_sendfile+0x564/0x8a0 fs/read_write.c:1363
> __do_sys_sendfile64 fs/read_write.c:1424 [inline]
> __se_sys_sendfile64+0x17c/0x1e0 fs/read_write.c:1410
> do_syscall_x64 arch/x86/entry/common.c:52 [inline]
> do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
> entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f49c6338bd9
> RSP: 002b:00007f49c62ce218 EFLAGS: 00000246 ORIG_RAX: 0000000000000028
> RAX: ffffffffffffffda RBX: 00007f49c63c66d8 RCX: 00007f49c6338bd9
> RDX: 0000000000000000 RSI: 0000000000000006 RDI: 0000000000000006
> RBP: 00007f49c63c66d0 R08: 0000000000000000 R09: 0000000000000000
> R10: 000000000e3aa6ea R11: 0000000000000246 R12: 00007f49c6392ae4
> R13: 0031656c69662f2e R14: 0000400000000240 R15: 0000400000000040
> </TASK>
>=20
> Showing all locks held in the system:
> 1 lock held by khungtaskd/30:
> #0: ffffffff8eb38fa0 (rcu_read_lock){....}-{1:3}, at: rcu_lock_acquire =
include/linux/rcupdate.h:337 [inline]
> #0: ffffffff8eb38fa0 (rcu_read_lock){....}-{1:3}, at: rcu_read_lock =
include/linux/rcupdate.h:849 [inline]
> #0: ffffffff8eb38fa0 (rcu_read_lock){....}-{1:3}, at: =
debug_show_all_locks+0x55/0x2a0 kernel/locking/lockdep.c:6746
> 2 locks held by getty/5583:
> #0: ffff88803112f0a0 (&tty->ldisc_sem){++++}-{0:0}, at: =
tty_ldisc_ref_wait+0x25/0x70 drivers/tty/tty_ldisc.c:243
> #1: ffffc90002fde2f0 (&ldata->atomic_read_lock){+.+.}-{4:4}, at: =
n_tty_read+0x616/0x1770 drivers/tty/n_tty.c:2211
> 1 lock held by syz-executor337/5843:
> #0: ffff88807c384420 (sb_writers#9){.+.+}-{0:0}, at: =
direct_splice_actor+0x49/0x220 fs/splice.c:1163
> 1 lock held by syz-executor337/5854:
> #0: ffff888077d68a80 (mapping.invalidate_lock#3){.+.+}-{4:4}, at: =
filemap_invalidate_lock_shared include/linux/fs.h:932 [inline]
> #0: ffff888077d68a80 (mapping.invalidate_lock#3){.+.+}-{4:4}, at: =
page_cache_ra_order+0x45d/0xca0 mm/readahead.c:492
>=20
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>=20
> NMI backtrace for cpu 0
> CPU: 0 UID: 0 PID: 30 Comm: khungtaskd Not tainted =
6.14.0-rc4-syzkaller-00169-g1e15510b71c9 #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, =
BIOS Google 02/12/2025
> Call Trace:
> <TASK>
> __dump_stack lib/dump_stack.c:94 [inline]
> dump_stack_lvl+0x241/0x360 lib/dump_stack.c:120
> nmi_cpu_backtrace+0x49c/0x4d0 lib/nmi_backtrace.c:113
> nmi_trigger_cpumask_backtrace+0x198/0x320 lib/nmi_backtrace.c:62
> trigger_all_cpu_backtrace include/linux/nmi.h:162 [inline]
> check_hung_uninterruptible_tasks kernel/hung_task.c:236 [inline]
> watchdog+0x1058/0x10a0 kernel/hung_task.c:399
> kthread+0x7a9/0x920 kernel/kthread.c:464
> ret_from_fork+0x4b/0x80 arch/x86/kernel/process.c:148
> ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244
> </TASK>
> Sending NMI from CPU 0 to CPUs 1:
> NMI backtrace for cpu 1 skipped: idling at native_safe_halt =
arch/x86/include/asm/irqflags.h:48 [inline]
> NMI backtrace for cpu 1 skipped: idling at arch_safe_halt =
arch/x86/include/asm/irqflags.h:106 [inline]
> NMI backtrace for cpu 1 skipped: idling at acpi_safe_halt+0x21/0x30 =
drivers/acpi/processor_idle.c:111
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
> If you want syzbot to run the reproducer, reply with:
> #syz test: git://repo/address.git branch-or-commit-hash
> If you attach or paste a git patch, syzbot will apply it before =
testing.
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


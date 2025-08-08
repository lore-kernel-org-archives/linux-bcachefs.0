Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CA9B1E2823;
	Fri,  8 Aug 2025 05:38:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754631499; cv=none; b=i25XN5pDxBOWM9VBGkZTEqrrrjlt+pnmcpqr/tiC3rbjY2LW8d3UWY5LdCXMv5pVKfG3j0IrNdtrQVWR4K+ZYo3F6JjRGdYI9BoYRLYp+5wWa1Ex1WVUv/sYXdU/WlfBHsOHgpcebjy6WluCjFgcUQ+m2cNF3i1Fxc7rLEmmx6c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754631499; c=relaxed/simple;
	bh=GOK7nQnmcFXdMJHSV9+mLdanV07JNQKsKl/YG/JjrDA=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=CGYW7w7zWtf7RFWUX7Fop8DwuulT3BDm2TmY47nROvRuONNwnnSe7vLtxV42VzPAmfeAIC3phneWcDh1CWzEkEPWNGLFxmHKUEAbeabXHaElYxOJdCqtMQ5jUrNYPIqNYBgAszQKvSOgfSQsABVnnxdZsgEu5eAt6GFTCC2ZcY8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Wn5bl+gp; arc=none smtp.client-ip=209.85.216.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Wn5bl+gp"
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-31efc10bb03so1623084a91.0;
        Thu, 07 Aug 2025 22:38:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754631496; x=1755236296; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Tf3iMoUqr2JFseDRSIfw5pZdrET6ALrl08a39Cl2/Dc=;
        b=Wn5bl+gpA5ZAh1MtsC2j3mHSdd6O93MYbY601/eMX8syi3l62J4oeB62lhfctEHuq3
         tgVDLqHf8wU1oFFCLXDEyRuTbjTFNqFidd4tX2YnDeB/8+syqptkz4IgZGbIfh7gObot
         x1ZjRcdyGej4XAqrLHCQp32+HBvVv4/gnXv64nJpWDK+f5VtMopVHqSydpiw2q0kqVW6
         s85xdLVz6G6ngCYc28SN+jLfhmlKVHecIA8HxmQMnck1giPLIcQd7+MZXqtSXiGA2KDp
         04F+ggibGq81qQaRHsSwoNhATL4JNEcjqnGCxv9HvfOTuWIj8zU+hxuJ9Cif93vqMHav
         fX/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754631496; x=1755236296;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Tf3iMoUqr2JFseDRSIfw5pZdrET6ALrl08a39Cl2/Dc=;
        b=ImXP4I4cAAWeqQM4jdmI4qTJU3eIh9hdbsXSdwrBghv7bZlDbjpnEHU+8BvuZuIQD3
         J3C9FLlBLf7slpqhvW95LuQYXQHCF4k5JS3Vf+qo7lK9pcplXMCCAUWFzPxZKi8DfQzm
         MUMV5U6DecEIFocTb0eM6XNF7IRbr/MIg68whGNE47R6i8L9IC2VyNV48rz245opyX+2
         sSIx5ZrK60J49tK9IgHSU9RVWFgIHfZjxSO4k/UOIGwb/6+rx1hqPq1kO2aa3bodmw+u
         vjMSKEP/LrfBUimJpEJ1gs4HuPUHkO6zg3N6S833p1vHTd/wAN1buKuskEr9QQEOJwBl
         xwxA==
X-Forwarded-Encrypted: i=1; AJvYcCVVTOladA/hejD8D1NX4gktlXfYA8+9IsxawS1Jo9R0bwgLocmA12PEd81W2Sj+Xw+2jTxHYLBOER7aKOHhQA==@vger.kernel.org, AJvYcCXCC419PY8G7dpw5sHFQnHKJ5mkIk7Qs1TMXQ1YCzsDMZUaQVX8yEkdhuU4mnx5B4CelpadMXG5J10ZnC5H@vger.kernel.org
X-Gm-Message-State: AOJu0YzT4n7fSBdR+7YQQwXeZCPvMwuRkN/WqUPSkIcSuO1dC7ckvV3m
	d95gBfKV0q7S9aQHX1rg7azfx6vl4kCtWeWbo08KVUDDb6Cjz5UA6Sq1SF1tuQ==
X-Gm-Gg: ASbGncu4+Sk60QBOdM2XoBl0ydDhaC7/+24VwiHVQLvuGDASpbDzK1Bp19mlokaR4Ov
	tdmDJbvCOAHw5RpRkb5cluqbo0jxBSfS5TC6reWgV19j21+DsoiKJZvuiTF0DSKgYDSICaemxnK
	pFbjg/GgyiFMPX7NaQSBU7RYvnCg8jSNvZ0UlVNudW4ScjfwN7DQCJevzS6AM5Z6l9w9/vkB2yN
	PBgH1OecDFXNexrQXLqUsWI9i+0t3EMJ4t3S+JvNcKh+XalL6+1QjIIa+WmCifCQSxV4HU0ch6p
	ee/EaHLZinTXDLBwMyJGLumWljajHt/Fiu/vA0GXlczDM/FvGb55u6NS3op8cByYDMk8Cot0Cvg
	118412Z5o6xA/ao9g
X-Google-Smtp-Source: AGHT+IESfLpMJNHbxrim5WfgWnaLrdNirf7oe+EFmCONI9gO1UMwf7kbKt8o3MoWwqOr7sQ/ikqwHA==
X-Received: by 2002:a17:90b:3c10:b0:31f:2ad7:44a3 with SMTP id 98e67ed59e1d1-321839e5a36mr2646128a91.9.1754631496126;
        Thu, 07 Aug 2025 22:38:16 -0700 (PDT)
Received: from smtpclient.apple ([2402:d0c0:11:86::1])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-321626f9ac1sm4163849a91.4.2025.08.07.22.38.13
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 07 Aug 2025 22:38:15 -0700 (PDT)
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3826.500.181.1.5\))
Subject: Re: [syzbot] [bcachefs?] INFO: task hung in bchfs_fpunch (2)
From: Alan Huang <mmpgouride@gmail.com>
In-Reply-To: <685af60a.a00a0220.2e5631.0093.GAE@google.com>
Date: Fri, 8 Aug 2025 13:37:59 +0800
Cc: kent.overstreet@linux.dev,
 linux-bcachefs@vger.kernel.org,
 linux-kernel@vger.kernel.org,
 syzkaller-bugs@googlegroups.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <2AB60EFF-1B62-43C7-B47D-00E2414806D3@gmail.com>
References: <685af60a.a00a0220.2e5631.0093.GAE@google.com>
To: syzbot <syzbot+d25751466d56160d8892@syzkaller.appspotmail.com>
X-Mailer: Apple Mail (2.3826.500.181.1.5)

On Jun 25, 2025, at 03:01, syzbot =
<syzbot+d25751466d56160d8892@syzkaller.appspotmail.com> wrote:
>=20
> Hello,
>=20
> syzbot found the following issue on:
>=20
> HEAD commit:    b67ec639010f Merge tag 'i2c-for-6.16-rc3' of =
git://git.ker..
> git tree:       upstream
> console output: =
https://syzkaller.appspot.com/x/log.txt?x=3D15e46182580000
> kernel config:  =
https://syzkaller.appspot.com/x/.config?x=3D6a237c32900fc479
> dashboard link: =
https://syzkaller.appspot.com/bug?extid=3Dd25751466d56160d8892
> compiler:       Debian clang version 20.1.6 =
(++20250514063057+1e4d39e07757-1~exp1~20250514183223.118), Debian LLD =
20.1.6
> syz repro:      =
https://syzkaller.appspot.com/x/repro.syz?x=3D15c46b0c580000
> C reproducer:   =
https://syzkaller.appspot.com/x/repro.c?x=3D1243db0c580000
>=20
> Downloadable assets:
> disk image: =
https://storage.googleapis.com/syzbot-assets/dbd84edd9de7/disk-b67ec639.ra=
w.xz
> vmlinux: =
https://storage.googleapis.com/syzbot-assets/388ad319d5bf/vmlinux-b67ec639=
.xz
> kernel image: =
https://storage.googleapis.com/syzbot-assets/961e022f7367/bzImage-b67ec639=
.xz
> mounted in repro: =
https://storage.googleapis.com/syzbot-assets/0c8167f99e04/mount_0.gz
>=20
> The issue was bisected to:
>=20
> commit e14e06e91dadcd1c65f08ba5a02716d3e855fc74
> Author: Kent Overstreet <kent.overstreet@linux.dev>
> Date:   Sun Apr 20 15:27:18 2025 +0000
>=20
>    bcachefs: __bch2_fs_read_write() no longer depends on io_ref
>=20
> bisection log:  =
https://syzkaller.appspot.com/x/bisect.txt?x=3D12636182580000
> final oops:     =
https://syzkaller.appspot.com/x/report.txt?x=3D11636182580000
> console output: =
https://syzkaller.appspot.com/x/log.txt?x=3D16636182580000
>=20
> IMPORTANT: if you fix the issue, please add the following tag to the =
commit:
> Reported-by: syzbot+d25751466d56160d8892@syzkaller.appspotmail.com
> Fixes: e14e06e91dad ("bcachefs: __bch2_fs_read_write() no longer =
depends on io_ref")
>=20
> INFO: task syz-executor198:6265 blocked for more than 143 seconds.
>      Not tainted 6.16.0-rc2-syzkaller-00378-gb67ec639010f #0
> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this =
message.
> task:syz-executor198 state:D stack:27144 pid:6265  tgid:6239  =
ppid:5854   task_flags:0x400140 flags:0x00004006
> Call Trace:
> <TASK>
> context_switch kernel/sched/core.c:5396 [inline]
> __schedule+0x16a2/0x4cb0 kernel/sched/core.c:6785
> __schedule_loop kernel/sched/core.c:6863 [inline]
> schedule+0x165/0x360 kernel/sched/core.c:6878
> io_schedule+0x81/0xe0 kernel/sched/core.c:7723
> folio_wait_bit_common+0x6b0/0xb90 mm/filemap.c:1317
> folio_lock include/linux/pagemap.h:1114 [inline]
> truncate_inode_pages_range+0xa77/0xda0 mm/truncate.c:433
> bchfs_fpunch+0x1d8/0x520 fs/bcachefs/fs-io.c:570
> bch2_fallocate_dispatch+0x2bc/0x410 fs/bcachefs/fs-io.c:838
> vfs_fallocate+0x6a0/0x830 fs/open.c:341
> ksys_fallocate fs/open.c:365 [inline]
> __do_sys_fallocate fs/open.c:370 [inline]
> __se_sys_fallocate fs/open.c:368 [inline]
> __x64_sys_fallocate+0xc0/0x110 fs/open.c:368
> do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
> do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
> entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7fd2b7703d79
> RSP: 002b:00007fd2b768f218 EFLAGS: 00000246 ORIG_RAX: 000000000000011d
> RAX: ffffffffffffffda RBX: 00007fd2b778a6d8 RCX: 00007fd2b7703d79
> RDX: 0000000000000000 RSI: 0000000000000003 RDI: 0000000000000005
> RBP: 00007fd2b778a6d0 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000404042bbe R11: 0000000000000246 R12: 00007fd2b7756ba4
> R13: 0000200000000040 R14: 0031656c69662f2e R15: 00002000000005c0
> </TASK>
> INFO: task syz-executor198:6269 blocked for more than 143 seconds.
>      Not tainted 6.16.0-rc2-syzkaller-00378-gb67ec639010f #0
> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this =
message.
> task:syz-executor198 state:D stack:26872 pid:6269  tgid:6239  =
ppid:5854   task_flags:0x440040 flags:0x00004006
> Call Trace:
> <TASK>
> context_switch kernel/sched/core.c:5396 [inline]
> __schedule+0x16a2/0x4cb0 kernel/sched/core.c:6785
> __schedule_loop kernel/sched/core.c:6863 [inline]
> schedule+0x165/0x360 kernel/sched/core.c:6878
> __bch2_two_state_lock+0x1ea/0x370 =
fs/bcachefs/two_state_shared_lock.c:7
> bch2_two_state_lock fs/bcachefs/two_state_shared_lock.h:55 [inline]
> bch2_readahead+0x94f/0x1100 fs/bcachefs/fs-io-buffered.c:296
> read_pages+0x177/0x580 mm/readahead.c:160
> page_cache_ra_order+0xa24/0xc70 mm/readahead.c:515
> filemap_get_pages+0x43c/0x1ea0 mm/filemap.c:2602
> filemap_splice_read+0x4fc/0xbc0 mm/filemap.c:2990
> do_splice_read fs/splice.c:979 [inline]
> splice_direct_to_actor+0x4a9/0xcc0 fs/splice.c:1083
> do_splice_direct_actor fs/splice.c:1201 [inline]
> do_splice_direct+0x181/0x270 fs/splice.c:1227
> do_sendfile+0x4da/0x7e0 fs/read_write.c:1370
> __do_sys_sendfile64 fs/read_write.c:1431 [inline]
> __se_sys_sendfile64+0x13e/0x190 fs/read_write.c:1417
> do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
> do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
> entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7fd2b7703d79
> RSP: 002b:00007fd2b766e218 EFLAGS: 00000246 ORIG_RAX: 0000000000000028
> RAX: ffffffffffffffda RBX: 00007fd2b778a6e8 RCX: 00007fd2b7703d79
> RDX: 0000000000000000 RSI: 0000000000000004 RDI: 0000000000000004
> RBP: 00007fd2b778a6e0 R08: 00007ffd4f811977 R09: 0000000000000000
> R10: 000000000e3aa6ea R11: 0000000000000246 R12: 00007fd2b7756ba4
> R13: 0000200000000040 R14: 0031656c69662f2e R15: 00002000000005c0
> </TASK>
>=20
> Showing all locks held in the system:
> 1 lock held by khungtaskd/31:
> #0: ffffffff8e13ee60 (rcu_read_lock){....}-{1:3}
> , at: rcu_lock_acquire include/linux/rcupdate.h:331 [inline]
> , at: rcu_read_lock include/linux/rcupdate.h:841 [inline]
> , at: debug_show_all_locks+0x2e/0x180 kernel/locking/lockdep.c:6770
> 2 locks held by getty/5582:
> #0: ffff8880358620a0 (&tty->ldisc_sem){++++}-{0:0}, at: =
tty_ldisc_ref_wait+0x25/0x70 drivers/tty/tty_ldisc.c:243
> #1: ffffc9000332b2f0 (&ldata->atomic_read_lock){+.+.}-{4:4}, at: =
n_tty_read+0x43e/0x1400 drivers/tty/n_tty.c:2222
> 2 locks held by syz-executor198/5856:
> 3 locks held by syz-executor198/5857:
> #0: ffff88803537c0e0 (&type->s_umount_key#43){+.+.}-{4:4}, at: =
__super_lock fs/super.c:57 [inline]
> #0: ffff88803537c0e0 (&type->s_umount_key#43){+.+.}-{4:4}, at: =
__super_lock_excl fs/super.c:72 [inline]
> #0: ffff88803537c0e0 (&type->s_umount_key#43){+.+.}-{4:4}, at: =
deactivate_super+0xa9/0xe0 fs/super.c:506
> #1: ffff8880a2380278 (&c->state_lock){+.+.}-{4:4}, at: =
__bch2_fs_stop+0xf8/0x900 fs/bcachefs/super.c:677
> #2: ffffffff8e144978 (rcu_state.exp_mutex){+.+.}-{4:4}, at: =
exp_funnel_lock kernel/rcu/tree_exp.h:304 [inline]
> #2: ffffffff8e144978 (rcu_state.exp_mutex){+.+.}-{4:4}, at: =
synchronize_rcu_expedited+0x2f6/0x730 kernel/rcu/tree_exp.h:998
> 2 locks held by syz-executor198/6265:
> #0: ffff888076150428 (sb_writers#9){.+.+}-{0:0}, at: file_start_write =
include/linux/fs.h:3096 [inline]
> #0: ffff888076150428 (sb_writers#9){.+.+}-{0:0}, at: =
vfs_fallocate+0x62a/0x830 fs/open.c:340
> #1: ffff888078499fa8 (&sb->s_type->i_mutex_key#14){+.+.}-{4:4}, at: =
inode_lock include/linux/fs.h:869 [inline]
> #1: ffff888078499fa8 (&sb->s_type->i_mutex_key#14){+.+.}-{4:4}, at: =
bch2_fallocate_dispatch+0x10e/0x410 fs/bcachefs/fs-io.c:827
> 1 lock held by syz-executor198/6269:
> #0: ffff88807849a148 (mapping.invalidate_lock#3){.+.+}-{4:4}, at: =
filemap_invalidate_lock_shared include/linux/fs.h:934 [inline]
> #0: ffff88807849a148 (mapping.invalidate_lock#3){.+.+}-{4:4}, at: =
page_cache_ra_order+0x445/0xc70 mm/readahead.c:491
> 2 locks held by syz-executor198/7079:
> #0: ffff888028336428 (sb_writers#9){.+.+}-{0:0}, at: file_start_write =
include/linux/fs.h:3096 [inline]
> #0: ffff888028336428 (sb_writers#9){.+.+}-{0:0}, at: =
vfs_fallocate+0x62a/0x830 fs/open.c:340
> #1: ffff88807dd5d4d0 (&sb->s_type->i_mutex_key#14){+.+.}-{4:4}, at: =
inode_lock include/linux/fs.h:869 [inline]
> #1: ffff88807dd5d4d0 (&sb->s_type->i_mutex_key#14){+.+.}-{4:4}, at: =
bch2_fallocate_dispatch+0x10e/0x410 fs/bcachefs/fs-io.c:827
> 1 lock held by syz-executor198/7080:
> #0: ffff88807dd5d670 (mapping.invalidate_lock#3){.+.+}-{4:4}, at: =
filemap_invalidate_lock_shared include/linux/fs.h:934 [inline]
> #0: ffff88807dd5d670 (mapping.invalidate_lock#3){.+.+}-{4:4}, at: =
page_cache_ra_order+0x445/0xc70 mm/readahead.c:491
> 1 lock held by syz-executor198/9504:
>=20
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>=20
> NMI backtrace for cpu 1
> CPU: 1 UID: 0 PID: 31 Comm: khungtaskd Not tainted =
6.16.0-rc2-syzkaller-00378-gb67ec639010f #0 PREEMPT(full)=20
> Hardware name: Google Google Compute Engine/Google Compute Engine, =
BIOS Google 05/07/2025
> Call Trace:
> <TASK>
> dump_stack_lvl+0x189/0x250 lib/dump_stack.c:120
> nmi_cpu_backtrace+0x39e/0x3d0 lib/nmi_backtrace.c:113
> nmi_trigger_cpumask_backtrace+0x17a/0x300 lib/nmi_backtrace.c:62
> trigger_all_cpu_backtrace include/linux/nmi.h:158 [inline]
> check_hung_uninterruptible_tasks kernel/hung_task.c:307 [inline]
> watchdog+0xfee/0x1030 kernel/hung_task.c:470
> kthread+0x70e/0x8a0 kernel/kthread.c:464
> ret_from_fork+0x3fc/0x770 arch/x86/kernel/process.c:148
> ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
> </TASK>
> Sending NMI from CPU 1 to CPUs 0:
> NMI backtrace for cpu 0
> CPU: 0 UID: 0 PID: 5857 Comm: syz-executor198 Not tainted =
6.16.0-rc2-syzkaller-00378-gb67ec639010f #0 PREEMPT(full)=20
> Hardware name: Google Google Compute Engine/Google Compute Engine, =
BIOS Google 05/07/2025
> RIP: 0010:nearest_obj mm/slab.h:331 [inline]
> RIP: 0010:kasan_record_aux_stack+0x62/0xd0 mm/kasan/generic.c:542
> Code: c2 0f 85 81 00 00 00 4c 8b 71 08 48 89 ce 48 2b 35 2b 09 97 0b =
48 c1 e6 06 48 03 35 10 09 97 0b 48 89 d8 48 29 f0 41 8b 7e 18 <48> 89 =
c2 48 c1 ea 20 74 07 48 99 48 f7 ff eb 04 31 d2 f7 f7 48 29
> RSP: 0018:ffffc90000007ab0 EFLAGS: 00000002
> RAX: 00000000000002d0 RBX: ffff8880247b82d0 RCX: ffffea000091ee00
> RDX: fffffffde89b8200 RSI: ffff8880247b8000 RDI: 0000000000000800
> RBP: 0000000000000000 R08: 0000000000000000 R09: ffffffff817451d8
> R10: dffffc0000000000 R11: fffffbfff3399595 R12: dffffc0000000000
> R13: ffff88801a49cc00 R14: ffff88801a441dc0 R15: ffff8880b86395e0
> FS:  000055555795f3c0(0000) GS:ffff888125c85000(0000) =
knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007f5a35185000 CR3: 00000000723be000 CR4: 00000000003526f0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
> <IRQ>
> insert_work+0x3d/0x330 kernel/workqueue.c:2183
> __queue_work+0xcfc/0xfe0 kernel/workqueue.c:2341
> call_timer_fn+0x17b/0x5f0 kernel/time/timer.c:1747
> expire_timers kernel/time/timer.c:1793 [inline]
> __run_timers kernel/time/timer.c:2372 [inline]
> __run_timer_base+0x646/0x860 kernel/time/timer.c:2384
> run_timer_base kernel/time/timer.c:2393 [inline]
> run_timer_softirq+0xb7/0x180 kernel/time/timer.c:2403
> handle_softirqs+0x286/0x870 kernel/softirq.c:579
> __do_softirq kernel/softirq.c:613 [inline]
> invoke_softirq kernel/softirq.c:453 [inline]
> __irq_exit_rcu+0xca/0x1f0 kernel/softirq.c:680
> irq_exit_rcu+0x9/0x30 kernel/softirq.c:696
> instr_sysvec_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1050 =
[inline]
> sysvec_apic_timer_interrupt+0xa6/0xc0 arch/x86/kernel/apic/apic.c:1050
> </IRQ>
> <TASK>
> asm_sysvec_apic_timer_interrupt+0x1a/0x20 =
arch/x86/include/asm/idtentry.h:702
> RIP: 0010:console_trylock_spinning kernel/printk/printk.c:2061 =
[inline]
> RIP: 0010:vprintk_emit+0x58f/0x7a0 kernel/printk/printk.c:2449
> Code: 85 32 01 00 00 e8 91 62 1f 00 41 89 df 4d 85 f6 48 8b 1c 24 75 =
07 e8 80 62 1f 00 eb 06 e8 79 62 1f 00 fb 48 c7 c7 e0 30 13 8e <31> f6 =
ba 01 00 00 00 31 c9 41 b8 01 00 00 00 45 31 c9 53 e8 b9 36
> RSP: 0018:ffffc900043f7820 EFLAGS: 00000293
> RAX: ffffffff81a0e9a7 RBX: ffffffff81a0e864 RCX: ffff88802904da00
> RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffffffff8e1330e0
> RBP: ffffc900043f7930 R08: ffffffff8f9fe0f7 R09: 1ffffffff1f3fc1e
> R10: dffffc0000000000 R11: fffffbfff1f3fc1f R12: dffffc0000000000
> R13: 1ffff9200087ef08 R14: 0000000000000200 R15: 0000000000000052
> bch2_print_maybe_redirect fs/bcachefs/super.c:137 [inline]
> __bch2_print+0x176/0x220 fs/bcachefs/super.c:156
> __bch2_fs_read_only+0x271/0x5b0 fs/bcachefs/super.c:300
> bch2_fs_read_only+0x42a/0xb00 fs/bcachefs/super.c:367
> __bch2_fs_stop+0x100/0x900 fs/bcachefs/super.c:678
> generic_shutdown_super+0x135/0x2c0 fs/super.c:643
> bch2_kill_sb+0x41/0x50 fs/bcachefs/fs.c:2618
> deactivate_locked_super+0xb9/0x130 fs/super.c:474
> cleanup_mnt+0x425/0x4c0 fs/namespace.c:1417
> task_work_run+0x1d1/0x260 kernel/task_work.c:227
> resume_user_mode_work include/linux/resume_user_mode.h:50 [inline]
> exit_to_user_mode_loop+0xec/0x110 kernel/entry/common.c:114
> exit_to_user_mode_prepare include/linux/entry-common.h:330 [inline]
> syscall_exit_to_user_mode_work include/linux/entry-common.h:414 =
[inline]
> syscall_exit_to_user_mode include/linux/entry-common.h:449 [inline]
> do_syscall_64+0x2bd/0x3b0 arch/x86/entry/syscall_64.c:100
> entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7fd2b7704fd7
> Code: 08 00 48 83 c4 08 5b 5d c3 66 2e 0f 1f 84 00 00 00 00 00 c3 66 =
2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 b8 a6 00 00 00 0f 05 <48> 3d =
00 f0 ff ff 77 01 c3 48 c7 c2 b0 ff ff ff f7 d8 64 89 02 b8
> RSP: 002b:00007ffd4f810968 EFLAGS: 00000202 ORIG_RAX: 00000000000000a6
> RAX: 0000000000000000 RBX: 00000000000664e4 RCX: 00007fd2b7704fd7
> RDX: 0000000000000000 RSI: 0000000000000009 RDI: 00007ffd4f810a20
> RBP: 00007ffd4f810a20 R08: 0000000000000000 R09: 0000000000000000
> R10: 00000000ffffffff R11: 0000000000000202 R12: 00007ffd4f811ae0
> R13: 0000555557960700 R14: 431bde82d7b634db R15: 00007ffd4f811a84
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
> For information about bisection process see: =
https://goo.gl/tpsmEJ#bisection
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


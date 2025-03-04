Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AC6A202F8F;
	Tue,  4 Mar 2025 15:14:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741101278; cv=none; b=Z8f0kqeGyGdRaP78SgqT+fysve17OAkuwQ4AyxOfoL1nfVQ258+vSBcx2OtCgS2wxV3PZWBcIKZNt57u7hDDDVEx37RhglN/BDjXVt5tluEWBrJLCxM4UTkjErcw2tV2Whvl36KV2UKagNXkh7hOvy8fAaWN5zIDk5sASpGcfVU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741101278; c=relaxed/simple;
	bh=zWrzCGCyEtmz4bprxj0QGkAf7nnb/KqKRPqPQWMwaxY=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nhySPWhB+8BYwIJCq1VwfggVgtJ7sIkl/ZWDW+nbnQtt8C8deYGAlQZA2cy8FHXs3JvwshjipQPB7npHL3bj4LnI/jqf0Xhlh9yczDjM5gQFmIDea5/vS+b+mpdMxzzhdpGNsSY/uYHByKSTJ4tYpOEt1LzhukmrsdY3GY7CscU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8BC4C4CEE5;
	Tue,  4 Mar 2025 15:14:36 +0000 (UTC)
Date: Tue, 4 Mar 2025 10:15:31 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Strforexc yn <strforexc@gmail.com>
Cc: Lai Jiangshan <jiangshanlai@gmail.com>, "Paul E. McKenney"
 <paulmck@kernel.org>, Josh Triplett <josh@joshtriplett.org>, Mathieu
 Desnoyers <mathieu.desnoyers@efficios.com>, rcu@vger.kernel.org,
 linux-kernel@vger.kernel.org, Kent Overstreet <kent.overstreet@linux.dev>,
 linux-bcachefs@vger.kernel.org
Subject: Re: KASAN: global-out-of-bounds Read in srcu_gp_start_if_needed
Message-ID: <20250304101531.55de1072@gandalf.local.home>
In-Reply-To: <CA+HokZrPb-oHcuZQsc=LZ6_aJfjKy9oMeCBd-tq4b_sX5EG7NQ@mail.gmail.com>
References: <CA+HokZrPb-oHcuZQsc=LZ6_aJfjKy9oMeCBd-tq4b_sX5EG7NQ@mail.gmail.com>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable


I just realized that the bcachefs maintainer wasn't Cc'd on this.

As I believe that this is more likely a bcachefs bug than an RCU bug, I'm
adding the bcachefs maintainer and mailing list to this.


On Mon, 3 Mar 2025 08:44:48 +0800
Strforexc yn <strforexc@gmail.com> wrote:

> Dear Maintainers, When using our customized Syzkaller to fuzz the
> latest Linux kernel, the following crash was triggered.
>=20
> Kernel commit: v6.14-rc4 (Commits on Feb 24, 2025)
> Kernel Config : https://github.com/Strforexc/LinuxKernelbug/blob/main/.co=
nfig
> Kernel Log: attachment
>=20
> I=E2=80=99ve encountered a KASAN-reported global-out-of-bounds read in Li=
nux
> kernel 6.14.0-rc4, involving the RCU subsystem and bcachefs. Here are

In the future, if you see an issue between two subsystems, make sure to
include the maintainers of both subsystems!

Thanks,

-- Steve


> the details:
>=20
> A global-out-of-bounds read of size 1 was detected at address
> ffffffff8b8e8d55 in string_nocheck (lib/vsprintf.c:632), called from
> string (lib/vsprintf.c:714). The buggy address belongs to
> str__rcu__trace_system_name+0x815/0xb40, triggered by a kworker task.
>=20
> The issue occurs during a bcachefs transaction commit
> (bch2_trans_commit), which enqueues an RCU callback via
> srcu_gp_start_if_needed. The out-of-bounds access happens in
> string_nocheck, likely during a printk or tracepoint operation
> (vprintk_emit), triggered by a lockdep warning (__warn_printk). The
> variable str__rcu__trace_system_name (size 0xb40) is overrun at offset
> 0x815, suggesting a string handling bug in RCU or bcachefs debug
> output.
>=20
> The bug was observed in a QEMU environment during
> btree_interior_update_work execution in bcachefs. It may involve
> filesystem operations (e.g., key cache dropping) under load. I don=E2=80=
=99t
> have a precise reproducer yet but can assist with testing.
>=20
> Could RCU or bcachefs maintainers investigate? This might be a
> tracepoint or printk format string issue in srcu_gp_start_if_needed or
> related code. I suspect an invalid index into
> str__rcu__trace_system_name or a pointer corruption. Happy to provide
> more logs or test patches.
>=20
> If you fix this issue, please add the following tag to the commit:
> Reported-by: Zhizhuo Tang <strforexctzzchange@foxmail.com>, Jianzhou
> Zhao <xnxc22xnxc22@qq.com>, Haoran Liu <cherest_san@163.com>
> ------------[ cut here ]------------
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> BUG: KASAN: global-out-of-bounds in string_nocheck lib/vsprintf.c:632 [in=
line]
> BUG: KASAN: global-out-of-bounds in string+0x4b3/0x500 lib/vsprintf.c:714
> Read of size 1 at addr ffffffff8b8e8d55 by task kworker/u10:0/28
>=20
> CPU: 1 UID: 0 PID: 28 Comm: kworker/u10:0 Not tainted 6.14.0-rc4 #1
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.15.0-1 04/0=
1/2014
> Workqueue: btree_update btree_interior_update_work
> Call Trace:
>  <TASK>
>  __dump_stack lib/dump_stack.c:94 [inline]
>  dump_stack_lvl+0x116/0x1b0 lib/dump_stack.c:120
>  print_address_description.constprop.0+0x2c/0x420 mm/kasan/report.c:408
>  print_report+0xaa/0x270 mm/kasan/report.c:521
>  kasan_report+0xbd/0x100 mm/kasan/report.c:634
>  string_nocheck lib/vsprintf.c:632 [inline]
>  string+0x4b3/0x500 lib/vsprintf.c:714
>  vsnprintf+0x620/0x1120 lib/vsprintf.c:2843
>  vprintk_store+0x34f/0xb90 kernel/printk/printk.c:2279
>  vprintk_emit+0x151/0x330 kernel/printk/printk.c:2408
>  __warn_printk+0x162/0x320 kernel/panic.c:797
>  look_up_lock_class+0xad/0x160 kernel/locking/lockdep.c:938
>  register_lock_class+0xb2/0xfc0 kernel/locking/lockdep.c:1292
>  __lock_acquire+0xc3/0x16a0 kernel/locking/lockdep.c:5103
>  lock_acquire+0x181/0x3a0 kernel/locking/lockdep.c:5851
>  __raw_spin_trylock include/linux/spinlock_api_smp.h:90 [inline]
>  _raw_spin_trylock+0x76/0xa0 kernel/locking/spinlock.c:138
>  spin_lock_irqsave_sdp_contention kernel/rcu/srcutree.c:375 [inline]
>  srcu_gp_start_if_needed+0x1a9/0x5f0 kernel/rcu/srcutree.c:1270
>  __call_rcu fs/bcachefs/rcu_pending.c:76 [inline]
>  __rcu_pending_enqueue fs/bcachefs/rcu_pending.c:497 [inline]
>  rcu_pending_enqueue+0x686/0xd30 fs/bcachefs/rcu_pending.c:531
>  bkey_cached_free+0xfd/0x170 fs/bcachefs/btree_key_cache.c:115
>  bch2_btree_key_cache_drop+0xe7/0x770 fs/bcachefs/btree_key_cache.c:613
>  bch2_trans_commit_write_locked.constprop.0+0x2bc6/0x3bc0
> fs/bcachefs/btree_trans_commit.c:794
>  do_bch2_trans_commit.isra.0+0x7a6/0x12f0 fs/bcachefs/btree_trans_commit.=
c:866
>  __bch2_trans_commit+0x1018/0x18e0 fs/bcachefs/btree_trans_commit.c:1070
>  bch2_trans_commit fs/bcachefs/btree_update.h:183 [inline]
>  btree_update_nodes_written+0x1352/0x2210
> fs/bcachefs/btree_update_interior.c:708
>  btree_interior_update_work+0xda/0x100 fs/bcachefs/btree_update_interior.=
c:846
>  process_one_work+0x109d/0x18c0 kernel/workqueue.c:3236
>  process_scheduled_works kernel/workqueue.c:3317 [inline]
>  worker_thread+0x677/0xe90 kernel/workqueue.c:3398
>  kthread+0x3b3/0x760 kernel/kthread.c:464
>  ret_from_fork+0x48/0x80 arch/x86/kernel/process.c:148
>  ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244
>  </TASK>
>=20
> The buggy address belongs to the variable:
>  str__rcu__trace_system_name+0x815/0xb40
>=20
> The buggy address belongs to the physical page:
> page: refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0xb8e8
> flags: 0xfff00000002000(reserved|node=3D0|zone=3D1|lastcpupid=3D0x7ff)
> raw: 00fff00000002000 ffffea00002e3a08 ffffea00002e3a08 0000000000000000
> raw: 0000000000000000 0000000000000000 00000001ffffffff 0000000000000000
> page dumped because: kasan: bad access detected
> page_owner info is not present (never set?)
>=20
> Memory state around the buggy address:
>  ffffffff8b8e8c00: f9 f9 f9 f9 00 00 00 00 03 f9 f9 f9 f9 f9 f9 f9
>  ffffffff8b8e8c80: 00 00 00 00 00 00 01 f9 f9 f9 f9 f9 00 00 00 07
> >ffffffff8b8e8d00: f9 f9 f9 f9 00 00 00 03 f9 f9 f9 f9 00 00 00 06 =20
>                                                  ^
>  ffffffff8b8e8d80: f9 f9 f9 f9 00 00 03 f9 f9 f9 f9 f9 00 00 01 f9
>  ffffffff8b8e8e00: f9 f9 f9 f9 00 01 f9 f9 f9 f9 f9 f9 00 00 00 00
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> Thanks,
> Zhizhuo Tang


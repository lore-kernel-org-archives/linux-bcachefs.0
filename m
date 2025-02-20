Received: from out-171.mta1.migadu.com (out-171.mta1.migadu.com [95.215.58.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 709BB1E9B0B
	for <linux-bcachefs@vger.kernel.org>; Thu, 20 Feb 2025 12:40:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740055251; cv=none; b=uSe8IB8BenzK9jJ50fxc1F3hrHc5UK4r6OU3pVVPqJreAe/Pu45CLW9yCYb61l1bu+QWHn+W2w4RRUABkLrYmi1O7ITQttTwcTqDdd27ZGA2/nYWzx5sZeQuTVXgX62q5IFRIa2UFHYfyv2tUA+ahsmkGjS0XiKJE/bjlzn32ZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740055251; c=relaxed/simple;
	bh=tJwm7ncrrCmtyW5ywbP7vBDZMjPaFso/iRCadgGCkwM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=u99u0Vfgfh8mp3/5GXUUSe738Wh7FPLgx2yUK5Nbp6TXrODRm5aH7IO6W/Z1PYIPF5ODn677Wnob8E9HqpK06A10LwmD+SEiwIP8+CoN4iXCLscI3paEg1Ad5ChAU3ZnPfqDnGmOYGj6SIjf5cPZIWS60Hatk/DM178i5rz3HUY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=YWXtkqwh; arc=none smtp.client-ip=95.215.58.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="YWXtkqwh"
Date: Thu, 20 Feb 2025 07:40:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1740055246;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ApU+yyrD5SkVpAN2fNtyIpXQJjZPXT2F7B9bMrsuFug=;
	b=YWXtkqwhfnKZ0A2F4De63Jh6p9XbQDOtpgeQgwvSTGmnobetxdoYE8OB2AB9DyoDYt5GL/
	jgaYkDz1/8fyJ9EOQhLcyAaJG2VDnn9X89DrBoh2KQRXFSB+Nk0dKKs7AVUrtSnJ9K+Hkm
	tXEY+BKDXdImcntHSkrnHrKjt2IrAMk=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Alan Huang <mmpgouride@gmail.com>
Cc: linux-bcachefs@vger.kernel.org, 
	syzbot+fe63f377148a6371a9db@syzkaller.appspotmail.com, linux-mm@kvack.org, Tejun Heo <tj@kernel.org>, 
	Dennis Zhou <dennis@kernel.org>, Christoph Lameter <cl@linux.com>
Subject: Re: [PATCH] bcachefs: Use alloc_percpu_gfp to avoid deadlock
Message-ID: <n4sd227mmkto6mfufmkazq5c7ywf6qoguwetjca7dcgvmz7q3u@ojdqlmjkuklp>
References: <20250212100625.55860-1-mmpgouride@gmail.com>
 <issmt55cogzyglrmao7hmqdbhvu7n6eii625ydm4irktfkfnrp@wtdbg42tumpr>
 <25FBAAE5-8BC6-41F3-9A6D-65911BA5A5D7@gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <25FBAAE5-8BC6-41F3-9A6D-65911BA5A5D7@gmail.com>
X-Migadu-Flow: FLOW_OUT

On Thu, Feb 20, 2025 at 06:57:32PM +0800, Alan Huang wrote:
> Ping

I really want to get this fixed in percpu...

let's leave this until we can fix it properly, this has come up before
and I don't want to just kick the can down again

(yes, that means fixing the global percpu allocation lock)

> 
> > On Feb 12, 2025, at 22:27, Kent Overstreet <kent.overstreet@linux.dev> wrote:
> > 
> > Adding pcpu people to the CC
> > 
> > On Wed, Feb 12, 2025 at 06:06:25PM +0800, Alan Huang wrote:
> >> The cycle:
> >> 
> >> CPU0: CPU1:
> >> bc->lock pcpu_alloc_mutex
> >> pcpu_alloc_mutex bc->lock
> >> 
> >> Reported-by: syzbot+fe63f377148a6371a9db@syzkaller.appspotmail.com
> >> Tested-by: syzbot+fe63f377148a6371a9db@syzkaller.appspotmail.com
> >> Signed-off-by: Alan Huang <mmpgouride@gmail.com>
> > 
> > So pcpu_alloc_mutex -> fs_reclaim?
> > 
> > That's really awkward; seems like something that might invite more
> > issues. We can apply your fix if we need to, but I want to hear with the
> > percpu people have to say first.
> > 
> > ======================================================
> > WARNING: possible circular locking dependency detected
> > 6.14.0-rc2-syzkaller-00039-g09fbf3d50205 #0 Not tainted
> > ------------------------------------------------------
> > syz.0.21/5625 is trying to acquire lock:
> > ffffffff8ea19608 (pcpu_alloc_mutex){+.+.}-{4:4}, at: pcpu_alloc_noprof+0x293/0x1760 mm/percpu.c:1782
> > 
> > but task is already holding lock:
> > ffff888051401c68 (&bc->lock){+.+.}-{4:4}, at: bch2_btree_node_mem_alloc+0x559/0x16f0 fs/bcachefs/btree_cache.c:804
> > 
> > which lock already depends on the new lock.
> > 
> > 
> > the existing dependency chain (in reverse order) is:
> > 
> > -> #2 (&bc->lock){+.+.}-{4:4}:
> >       lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5851
> >       __mutex_lock_common kernel/locking/mutex.c:585 [inline]
> >       __mutex_lock+0x19c/0x1010 kernel/locking/mutex.c:730
> >       bch2_btree_cache_scan+0x184/0xec0 fs/bcachefs/btree_cache.c:482
> >       do_shrink_slab+0x72d/0x1160 mm/shrinker.c:437
> >       shrink_slab+0x1093/0x14d0 mm/shrinker.c:664
> >       shrink_one+0x43b/0x850 mm/vmscan.c:4868
> >       shrink_many mm/vmscan.c:4929 [inline]
> >       lru_gen_shrink_node mm/vmscan.c:5007 [inline]
> >       shrink_node+0x37c5/0x3e50 mm/vmscan.c:5978
> >       kswapd_shrink_node mm/vmscan.c:6807 [inline]
> >       balance_pgdat mm/vmscan.c:6999 [inline]
> >       kswapd+0x20f3/0x3b10 mm/vmscan.c:7264
> >       kthread+0x7a9/0x920 kernel/kthread.c:464
> >       ret_from_fork+0x4b/0x80 arch/x86/kernel/process.c:148
> >       ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244
> > 
> > -> #1 (fs_reclaim){+.+.}-{0:0}:
> >       lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5851
> >       __fs_reclaim_acquire mm/page_alloc.c:3853 [inline]
> >       fs_reclaim_acquire+0x88/0x130 mm/page_alloc.c:3867
> >       might_alloc include/linux/sched/mm.h:318 [inline]
> >       slab_pre_alloc_hook mm/slub.c:4066 [inline]
> >       slab_alloc_node mm/slub.c:4144 [inline]
> >       __do_kmalloc_node mm/slub.c:4293 [inline]
> >       __kmalloc_noprof+0xae/0x4c0 mm/slub.c:4306
> >       kmalloc_noprof include/linux/slab.h:905 [inline]
> >       kzalloc_noprof include/linux/slab.h:1037 [inline]
> >       pcpu_mem_zalloc mm/percpu.c:510 [inline]
> >       pcpu_alloc_chunk mm/percpu.c:1430 [inline]
> >       pcpu_create_chunk+0x57/0xbc0 mm/percpu-vm.c:338
> >       pcpu_balance_populated mm/percpu.c:2063 [inline]
> >       pcpu_balance_workfn+0xc4d/0xd40 mm/percpu.c:2200
> >       process_one_work kernel/workqueue.c:3236 [inline]
> >       process_scheduled_works+0xa66/0x1840 kernel/workqueue.c:3317
> >       worker_thread+0x870/0xd30 kernel/workqueue.c:3398
> >       kthread+0x7a9/0x920 kernel/kthread.c:464
> >       ret_from_fork+0x4b/0x80 arch/x86/kernel/process.c:148
> >       ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244
> > 
> > -> #0 (pcpu_alloc_mutex){+.+.}-{4:4}:
> >       check_prev_add kernel/locking/lockdep.c:3163 [inline]
> >       check_prevs_add kernel/locking/lockdep.c:3282 [inline]
> >       validate_chain+0x18ef/0x5920 kernel/locking/lockdep.c:3906
> >       __lock_acquire+0x1397/0x2100 kernel/locking/lockdep.c:5228
> >       lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5851
> >       __mutex_lock_common kernel/locking/mutex.c:585 [inline]
> >       __mutex_lock+0x19c/0x1010 kernel/locking/mutex.c:730
> >       pcpu_alloc_noprof+0x293/0x1760 mm/percpu.c:1782
> >       __six_lock_init+0x104/0x150 fs/bcachefs/six.c:876
> >       bch2_btree_lock_init+0x38/0x100 fs/bcachefs/btree_locking.c:12
> >       bch2_btree_node_mem_alloc+0x565/0x16f0 fs/bcachefs/btree_cache.c:807
> >       __bch2_btree_node_alloc fs/bcachefs/btree_update_interior.c:304 [inline]
> >       bch2_btree_reserve_get+0x2df/0x1890 fs/bcachefs/btree_update_interior.c:532
> >       bch2_btree_update_start+0xe56/0x14e0 fs/bcachefs/btree_update_interior.c:1230
> >       bch2_btree_split_leaf+0x121/0x880 fs/bcachefs/btree_update_interior.c:1851
> >       bch2_trans_commit_error+0x212/0x1380 fs/bcachefs/btree_trans_commit.c:908
> >       __bch2_trans_commit+0x812b/0x97a0 fs/bcachefs/btree_trans_commit.c:1085
> >       bch2_trans_commit fs/bcachefs/btree_update.h:183 [inline]
> >       bch2_trans_mark_metadata_bucket+0x47a/0x17b0 fs/bcachefs/buckets.c:1043
> >       bch2_trans_mark_metadata_sectors fs/bcachefs/buckets.c:1060 [inline]
> >       __bch2_trans_mark_dev_sb fs/bcachefs/buckets.c:1100 [inline]
> >       bch2_trans_mark_dev_sb+0x3f6/0x820 fs/bcachefs/buckets.c:1128
> >       bch2_trans_mark_dev_sbs_flags+0x6be/0x720 fs/bcachefs/buckets.c:1138
> >       bch2_fs_initialize+0xba0/0x1610 fs/bcachefs/recovery.c:1149
> >       bch2_fs_start+0x36d/0x610 fs/bcachefs/super.c:1042
> >       bch2_fs_get_tree+0xd8d/0x1740 fs/bcachefs/fs.c:2203
> >       vfs_get_tree+0x90/0x2b0 fs/super.c:1814
> >       do_new_mount+0x2be/0xb40 fs/namespace.c:3560
> >       do_mount fs/namespace.c:3900 [inline]
> >       __do_sys_mount fs/namespace.c:4111 [inline]
> >       __se_sys_mount+0x2d6/0x3c0 fs/namespace.c:4088
> >       do_syscall_x64 arch/x86/entry/common.c:52 [inline]
> >       do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
> >       entry_SYSCALL_64_after_hwframe+0x77/0x7f
> > 
> > other info that might help us debug this:
> > 
> > Chain exists of:
> >  pcpu_alloc_mutex --> fs_reclaim --> &bc->lock
> > 
> > Possible unsafe locking scenario:
> > 
> >       CPU0                    CPU1
> >       ----                    ----
> >  lock(&bc->lock);
> >                               lock(fs_reclaim);
> >                               lock(&bc->lock);
> >  lock(pcpu_alloc_mutex);
> > 
> > *** DEADLOCK ***
> > 
> > 4 locks held by syz.0.21/5625:
> > #0: ffff888051400278 (&c->state_lock){+.+.}-{4:4}, at: bch2_fs_start+0x45/0x610 fs/bcachefs/super.c:1010
> > #1: ffff888051404378 (&c->btree_trans_barrier){.+.+}-{0:0}, at: srcu_lock_acquire include/linux/srcu.h:164 [inline]
> > #1: ffff888051404378 (&c->btree_trans_barrier){.+.+}-{0:0}, at: srcu_read_lock include/linux/srcu.h:256 [inline]
> > #1: ffff888051404378 (&c->btree_trans_barrier){.+.+}-{0:0}, at: __bch2_trans_get+0x7e4/0xd30 fs/bcachefs/btree_iter.c:3377
> > #2: ffff8880514266d0 (&c->gc_lock){.+.+}-{4:4}, at: bch2_btree_update_start+0x682/0x14e0 fs/bcachefs/btree_update_interior.c:1180
> > #3: ffff888051401c68 (&bc->lock){+.+.}-{4:4}, at: bch2_btree_node_mem_alloc+0x559/0x16f0 fs/bcachefs/btree_cache.c:804
> > 
> > stack backtrace:
> > CPU: 0 UID: 0 PID: 5625 Comm: syz.0.21 Not tainted 6.14.0-rc2-syzkaller-00039-g09fbf3d50205 #0
> > Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
> > Call Trace:
> > <TASK>
> > __dump_stack lib/dump_stack.c:94 [inline]
> > dump_stack_lvl+0x241/0x360 lib/dump_stack.c:120
> > print_circular_bug+0x13a/0x1b0 kernel/locking/lockdep.c:2076
> > check_noncircular+0x36a/0x4a0 kernel/locking/lockdep.c:2208
> > check_prev_add kernel/locking/lockdep.c:3163 [inline]
> > check_prevs_add kernel/locking/lockdep.c:3282 [inline]
> > validate_chain+0x18ef/0x5920 kernel/locking/lockdep.c:3906
> > __lock_acquire+0x1397/0x2100 kernel/locking/lockdep.c:5228
> > lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5851
> > __mutex_lock_common kernel/locking/mutex.c:585 [inline]
> > __mutex_lock+0x19c/0x1010 kernel/locking/mutex.c:730
> > pcpu_alloc_noprof+0x293/0x1760 mm/percpu.c:1782
> > __six_lock_init+0x104/0x150 fs/bcachefs/six.c:876
> > bch2_btree_lock_init+0x38/0x100 fs/bcachefs/btree_locking.c:12
> > bch2_btree_node_mem_alloc+0x565/0x16f0 fs/bcachefs/btree_cache.c:807
> > __bch2_btree_node_alloc fs/bcachefs/btree_update_interior.c:304 [inline]
> > bch2_btree_reserve_get+0x2df/0x1890 fs/bcachefs/btree_update_interior.c:532
> > bch2_btree_update_start+0xe56/0x14e0 fs/bcachefs/btree_update_interior.c:1230
> > bch2_btree_split_leaf+0x121/0x880 fs/bcachefs/btree_update_interior.c:1851
> > bch2_trans_commit_error+0x212/0x1380 fs/bcachefs/btree_trans_commit.c:908
> > __bch2_trans_commit+0x812b/0x97a0 fs/bcachefs/btree_trans_commit.c:1085
> > bch2_trans_commit fs/bcachefs/btree_update.h:183 [inline]
> > bch2_trans_mark_metadata_bucket+0x47a/0x17b0 fs/bcachefs/buckets.c:1043
> > bch2_trans_mark_metadata_sectors fs/bcachefs/buckets.c:1060 [inline]
> > __bch2_trans_mark_dev_sb fs/bcachefs/buckets.c:1100 [inline]
> > bch2_trans_mark_dev_sb+0x3f6/0x820 fs/bcachefs/buckets.c:1128
> > bch2_trans_mark_dev_sbs_flags+0x6be/0x720 fs/bcachefs/buckets.c:1138
> > bch2_fs_initialize+0xba0/0x1610 fs/bcachefs/recovery.c:1149
> > bch2_fs_start+0x36d/0x610 fs/bcachefs/super.c:1042
> > bch2_fs_get_tree+0xd8d/0x1740 fs/bcachefs/fs.c:2203
> > vfs_get_tree+0x90/0x2b0 fs/super.c:1814
> > do_new_mount+0x2be/0xb40 fs/namespace.c:3560
> > do_mount fs/namespace.c:3900 [inline]
> > __do_sys_mount fs/namespace.c:4111 [inline]
> > __se_sys_mount+0x2d6/0x3c0 fs/namespace.c:4088
> > do_syscall_x64 arch/x86/entry/common.c:52 [inline]
> > do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
> > entry_SYSCALL_64_after_hwframe+0x77/0x7f
> > RIP: 0033:0x7fcaed38e58a
> > Code: d8 64 89 02 48 c7 c0 ff ff ff ff eb a6 e8 de 1a 00 00 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
> > RSP: 002b:00007fcaec5fde68 EFLAGS: 00000246 ORIG_RAX: 00000000000000a5
> > RAX: ffffffffffffffda RBX: 00007fcaec5fdef0 RCX: 00007fcaed38e58a
> > RDX: 00004000000000c0 RSI: 0000400000000180 RDI: 00007fcaec5fdeb0
> > RBP: 00004000000000c0 R08: 00007fcaec5fdef0 R09: 0000000000000000
> > 
> >> ---
> >> fs/bcachefs/six.c | 2 +-
> >> 1 file changed, 1 insertion(+), 1 deletion(-)
> >> 
> >> diff --git a/fs/bcachefs/six.c b/fs/bcachefs/six.c
> >> index 7e7c66a1e1a6..ccdc6d496910 100644
> >> --- a/fs/bcachefs/six.c
> >> +++ b/fs/bcachefs/six.c
> >> @@ -873,7 +873,7 @@ void __six_lock_init(struct six_lock *lock, const char *name,
> >> * failure if they wish by checking lock->readers, but generally
> >> * will not want to treat it as an error.
> >> */
> >> - lock->readers = alloc_percpu(unsigned);
> >> + lock->readers = alloc_percpu_gfp(unsigned, GFP_NOWAIT|__GFP_NOWARN);
> >> }
> >> #endif
> >> }
> >> -- 
> >> 2.47.0
> >> 
> 

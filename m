Received: from mail-qk1-f182.google.com (mail-qk1-f182.google.com [209.85.222.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66B7D286298
	for <linux-bcachefs@vger.kernel.org>; Thu, 20 Feb 2025 12:44:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740055485; cv=none; b=hOjU9XjD0uQRfhdjk3DN2Ymz4M3R2+whPPraBbMjM9Yg6P4rN/6WFf0k/xW6pRTwVBDOqPclJzu6LaZQbsXytvsgTpDSK19VI98ViKsSWQmazJ03gdJm389ZBVn45WED2jLS7OoDNQG8RJtsb5PkXhFszQFJvLSGJJBZ3drg1Vc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740055485; c=relaxed/simple;
	bh=EcIF7IT6+7wAI0uwoU2YPIHSUep6VuBO0lRRkHxfMTo=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=n6uhVgVuCzBGDP4CQQ2pG2/MkIRpEAoYeta/LoJuvh+MepDZAwAmib+D68ahG1t9OO7tLynmGNhd+yPYnEIvsvXk5CCIyJNZX8QJUhFzImm/gx14JJvXSEmK7qsCaQM8G0OtFmfaBM5zS3de1B2mwPh2wcvg7thlotzdRBa2p4o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IKEAGj0a; arc=none smtp.client-ip=209.85.222.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IKEAGj0a"
Received: by mail-qk1-f182.google.com with SMTP id af79cd13be357-7c0a1c4780bso79879885a.3
        for <linux-bcachefs@vger.kernel.org>; Thu, 20 Feb 2025 04:44:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1740055482; x=1740660282; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BDaZaY0Du2EeWTyDtvHLozAnt6F+sCECf/kzNNq8glI=;
        b=IKEAGj0aMspbkgDfZU/ouHDOQ39dYEoo4ovu3m7Pa+2kVo/31qVxFsA3of/sebtiK4
         HH0aXU38aTL27ucj5OZxYiqdQjYAkH/8NOC5KwFGGwfipQJl7I0yKTfmcqqA4RSr1kBu
         KjDplh+ycsn328x5zbv0Zrumn21ip3vPcwoliiG/Dc+eWROQMaUnAzyoHS6GoZ19pqlA
         YZ3tz54pMC7jQ8PH7SMnTD5uyWwU68XI8tqaa9n4+zEYv9Hm1WI3GGyk7v/E7MYRPaCS
         vp48PlE1JITv1xijY5BHEIyw4fH3ESrsOOle88mzU76+ROSd206f75MinBg8Jw1G4nez
         QDFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740055482; x=1740660282;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BDaZaY0Du2EeWTyDtvHLozAnt6F+sCECf/kzNNq8glI=;
        b=PgFiMxHvzcDReo71BC9WtiQO/74Xv4qYMzuU/rXwhaf9od8RdP5tRmi0BwVhqUSr4k
         t4gEyyRQuyxzmSmJmyELPOLYw6WdeKLpar47K+/Q4w5nkwSrIxS5yH4ofvHcTpBwXVnw
         PRn0UConpKaDh2Rk1pDUqPT9ZgGA/rMQ9DTEcHm4zNyeiUJ5OmqwK8pldLJmjdByAFAw
         6VjkWaP9cp7rJ8nSYLTmI0zXkQqqSi/8AqIMgg/G2NYuVtJTy1r+K7W13iyM/vyX1X1J
         1zcxLVjCP7aEmX4bbGut3O6d8+xAp478l3zV+0VOc5ZesM3c5qQSKuGweowmXvNHKlvZ
         255g==
X-Gm-Message-State: AOJu0YyDXa0uEt34NLNi+62APwf5J14lbexg5GxWkMK3JUQbRseNDKz8
	sgkj3sP9ct08B2tD3zwq6fCAwDQEaOcmuB/x5Jg4r6MxLcw4D4/n
X-Gm-Gg: ASbGncuuJKWG/NtpIYrq76k5QdTtPuNYQRCEIMHLDunYWEqG5esvYCFaa+l5RnLdDz/
	MtO8Oq3JpUc03BsIPVDaJb9rBiXx32thvEM5HF0LHBFyBvPiWrMROdbBjQrhASBjSCpm4pgOnAp
	lvMeGS1STTgItgcaQ/fzx6puKpXtdop8BmBjqIu9AE62v/x+shFVxZxsn18f4FhZ7+Udv9CTkL4
	rgVCtoiqH6Nm6rv89S2B9qzg+5WFiKv8SPcC9lGnvMInsZ8qYtRXVF25xD0akdybXVBW3IKtm0=
X-Google-Smtp-Source: AGHT+IF1AHq64/AeHVwjuT1SMlY+ILxCwbD4ptHHVwWPhSLT1Sz3YXdUZhYa6Q8aHb9D3rsj5okGkQ==
X-Received: by 2002:a05:620a:4412:b0:7c0:6865:ad8a with SMTP id af79cd13be357-7c0b5366bb9mr1234186685a.56.1740055482185;
        Thu, 20 Feb 2025 04:44:42 -0800 (PST)
Received: from smtpclient.apple ([2402:d0c0:11:86::1])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7c0b1027932sm273798485a.115.2025.02.20.04.44.38
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 20 Feb 2025 04:44:41 -0800 (PST)
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3826.400.131.1.6\))
Subject: Re: [PATCH] bcachefs: Use alloc_percpu_gfp to avoid deadlock
From: Alan Huang <mmpgouride@gmail.com>
In-Reply-To: <n4sd227mmkto6mfufmkazq5c7ywf6qoguwetjca7dcgvmz7q3u@ojdqlmjkuklp>
Date: Thu, 20 Feb 2025 20:44:24 +0800
Cc: linux-bcachefs@vger.kernel.org,
 syzbot+fe63f377148a6371a9db@syzkaller.appspotmail.com,
 linux-mm@kvack.org,
 Tejun Heo <tj@kernel.org>,
 Dennis Zhou <dennis@kernel.org>,
 Christoph Lameter <cl@linux.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <34A7FB0C-6488-4068-B5B8-F9D72529D2D3@gmail.com>
References: <20250212100625.55860-1-mmpgouride@gmail.com>
 <issmt55cogzyglrmao7hmqdbhvu7n6eii625ydm4irktfkfnrp@wtdbg42tumpr>
 <25FBAAE5-8BC6-41F3-9A6D-65911BA5A5D7@gmail.com>
 <n4sd227mmkto6mfufmkazq5c7ywf6qoguwetjca7dcgvmz7q3u@ojdqlmjkuklp>
To: Kent Overstreet <kent.overstreet@linux.dev>
X-Mailer: Apple Mail (2.3826.400.131.1.6)



> On Feb 20, 2025, at 20:40, Kent Overstreet <kent.overstreet@linux.dev> =
wrote:
>=20
> On Thu, Feb 20, 2025 at 06:57:32PM +0800, Alan Huang wrote:
>> Ping
>=20
> I really want to get this fixed in percpu...
>=20
> let's leave this until we can fix it properly, this has come up before
> and I don't want to just kick the can down again
>=20
> (yes, that means fixing the global percpu allocation lock)

The ping is for the percpu people...

>=20
>>=20
>>> On Feb 12, 2025, at 22:27, Kent Overstreet =
<kent.overstreet@linux.dev> wrote:
>>>=20
>>> Adding pcpu people to the CC
>>>=20
>>> On Wed, Feb 12, 2025 at 06:06:25PM +0800, Alan Huang wrote:
>>>> The cycle:
>>>>=20
>>>> CPU0: CPU1:
>>>> bc->lock pcpu_alloc_mutex
>>>> pcpu_alloc_mutex bc->lock
>>>>=20
>>>> Reported-by: syzbot+fe63f377148a6371a9db@syzkaller.appspotmail.com
>>>> Tested-by: syzbot+fe63f377148a6371a9db@syzkaller.appspotmail.com
>>>> Signed-off-by: Alan Huang <mmpgouride@gmail.com>
>>>=20
>>> So pcpu_alloc_mutex -> fs_reclaim?
>>>=20
>>> That's really awkward; seems like something that might invite more
>>> issues. We can apply your fix if we need to, but I want to hear with =
the
>>> percpu people have to say first.
>>>=20
>>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
>>> WARNING: possible circular locking dependency detected
>>> 6.14.0-rc2-syzkaller-00039-g09fbf3d50205 #0 Not tainted
>>> ------------------------------------------------------
>>> syz.0.21/5625 is trying to acquire lock:
>>> ffffffff8ea19608 (pcpu_alloc_mutex){+.+.}-{4:4}, at: =
pcpu_alloc_noprof+0x293/0x1760 mm/percpu.c:1782
>>>=20
>>> but task is already holding lock:
>>> ffff888051401c68 (&bc->lock){+.+.}-{4:4}, at: =
bch2_btree_node_mem_alloc+0x559/0x16f0 fs/bcachefs/btree_cache.c:804
>>>=20
>>> which lock already depends on the new lock.
>>>=20
>>>=20
>>> the existing dependency chain (in reverse order) is:
>>>=20
>>> -> #2 (&bc->lock){+.+.}-{4:4}:
>>>      lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5851
>>>      __mutex_lock_common kernel/locking/mutex.c:585 [inline]
>>>      __mutex_lock+0x19c/0x1010 kernel/locking/mutex.c:730
>>>      bch2_btree_cache_scan+0x184/0xec0 fs/bcachefs/btree_cache.c:482
>>>      do_shrink_slab+0x72d/0x1160 mm/shrinker.c:437
>>>      shrink_slab+0x1093/0x14d0 mm/shrinker.c:664
>>>      shrink_one+0x43b/0x850 mm/vmscan.c:4868
>>>      shrink_many mm/vmscan.c:4929 [inline]
>>>      lru_gen_shrink_node mm/vmscan.c:5007 [inline]
>>>      shrink_node+0x37c5/0x3e50 mm/vmscan.c:5978
>>>      kswapd_shrink_node mm/vmscan.c:6807 [inline]
>>>      balance_pgdat mm/vmscan.c:6999 [inline]
>>>      kswapd+0x20f3/0x3b10 mm/vmscan.c:7264
>>>      kthread+0x7a9/0x920 kernel/kthread.c:464
>>>      ret_from_fork+0x4b/0x80 arch/x86/kernel/process.c:148
>>>      ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244
>>>=20
>>> -> #1 (fs_reclaim){+.+.}-{0:0}:
>>>      lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5851
>>>      __fs_reclaim_acquire mm/page_alloc.c:3853 [inline]
>>>      fs_reclaim_acquire+0x88/0x130 mm/page_alloc.c:3867
>>>      might_alloc include/linux/sched/mm.h:318 [inline]
>>>      slab_pre_alloc_hook mm/slub.c:4066 [inline]
>>>      slab_alloc_node mm/slub.c:4144 [inline]
>>>      __do_kmalloc_node mm/slub.c:4293 [inline]
>>>      __kmalloc_noprof+0xae/0x4c0 mm/slub.c:4306
>>>      kmalloc_noprof include/linux/slab.h:905 [inline]
>>>      kzalloc_noprof include/linux/slab.h:1037 [inline]
>>>      pcpu_mem_zalloc mm/percpu.c:510 [inline]
>>>      pcpu_alloc_chunk mm/percpu.c:1430 [inline]
>>>      pcpu_create_chunk+0x57/0xbc0 mm/percpu-vm.c:338
>>>      pcpu_balance_populated mm/percpu.c:2063 [inline]
>>>      pcpu_balance_workfn+0xc4d/0xd40 mm/percpu.c:2200
>>>      process_one_work kernel/workqueue.c:3236 [inline]
>>>      process_scheduled_works+0xa66/0x1840 kernel/workqueue.c:3317
>>>      worker_thread+0x870/0xd30 kernel/workqueue.c:3398
>>>      kthread+0x7a9/0x920 kernel/kthread.c:464
>>>      ret_from_fork+0x4b/0x80 arch/x86/kernel/process.c:148
>>>      ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244
>>>=20
>>> -> #0 (pcpu_alloc_mutex){+.+.}-{4:4}:
>>>      check_prev_add kernel/locking/lockdep.c:3163 [inline]
>>>      check_prevs_add kernel/locking/lockdep.c:3282 [inline]
>>>      validate_chain+0x18ef/0x5920 kernel/locking/lockdep.c:3906
>>>      __lock_acquire+0x1397/0x2100 kernel/locking/lockdep.c:5228
>>>      lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5851
>>>      __mutex_lock_common kernel/locking/mutex.c:585 [inline]
>>>      __mutex_lock+0x19c/0x1010 kernel/locking/mutex.c:730
>>>      pcpu_alloc_noprof+0x293/0x1760 mm/percpu.c:1782
>>>      __six_lock_init+0x104/0x150 fs/bcachefs/six.c:876
>>>      bch2_btree_lock_init+0x38/0x100 fs/bcachefs/btree_locking.c:12
>>>      bch2_btree_node_mem_alloc+0x565/0x16f0 =
fs/bcachefs/btree_cache.c:807
>>>      __bch2_btree_node_alloc fs/bcachefs/btree_update_interior.c:304 =
[inline]
>>>      bch2_btree_reserve_get+0x2df/0x1890 =
fs/bcachefs/btree_update_interior.c:532
>>>      bch2_btree_update_start+0xe56/0x14e0 =
fs/bcachefs/btree_update_interior.c:1230
>>>      bch2_btree_split_leaf+0x121/0x880 =
fs/bcachefs/btree_update_interior.c:1851
>>>      bch2_trans_commit_error+0x212/0x1380 =
fs/bcachefs/btree_trans_commit.c:908
>>>      __bch2_trans_commit+0x812b/0x97a0 =
fs/bcachefs/btree_trans_commit.c:1085
>>>      bch2_trans_commit fs/bcachefs/btree_update.h:183 [inline]
>>>      bch2_trans_mark_metadata_bucket+0x47a/0x17b0 =
fs/bcachefs/buckets.c:1043
>>>      bch2_trans_mark_metadata_sectors fs/bcachefs/buckets.c:1060 =
[inline]
>>>      __bch2_trans_mark_dev_sb fs/bcachefs/buckets.c:1100 [inline]
>>>      bch2_trans_mark_dev_sb+0x3f6/0x820 fs/bcachefs/buckets.c:1128
>>>      bch2_trans_mark_dev_sbs_flags+0x6be/0x720 =
fs/bcachefs/buckets.c:1138
>>>      bch2_fs_initialize+0xba0/0x1610 fs/bcachefs/recovery.c:1149
>>>      bch2_fs_start+0x36d/0x610 fs/bcachefs/super.c:1042
>>>      bch2_fs_get_tree+0xd8d/0x1740 fs/bcachefs/fs.c:2203
>>>      vfs_get_tree+0x90/0x2b0 fs/super.c:1814
>>>      do_new_mount+0x2be/0xb40 fs/namespace.c:3560
>>>      do_mount fs/namespace.c:3900 [inline]
>>>      __do_sys_mount fs/namespace.c:4111 [inline]
>>>      __se_sys_mount+0x2d6/0x3c0 fs/namespace.c:4088
>>>      do_syscall_x64 arch/x86/entry/common.c:52 [inline]
>>>      do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
>>>      entry_SYSCALL_64_after_hwframe+0x77/0x7f
>>>=20
>>> other info that might help us debug this:
>>>=20
>>> Chain exists of:
>>> pcpu_alloc_mutex --> fs_reclaim --> &bc->lock
>>>=20
>>> Possible unsafe locking scenario:
>>>=20
>>>      CPU0                    CPU1
>>>      ----                    ----
>>> lock(&bc->lock);
>>>                              lock(fs_reclaim);
>>>                              lock(&bc->lock);
>>> lock(pcpu_alloc_mutex);
>>>=20
>>> *** DEADLOCK ***
>>>=20
>>> 4 locks held by syz.0.21/5625:
>>> #0: ffff888051400278 (&c->state_lock){+.+.}-{4:4}, at: =
bch2_fs_start+0x45/0x610 fs/bcachefs/super.c:1010
>>> #1: ffff888051404378 (&c->btree_trans_barrier){.+.+}-{0:0}, at: =
srcu_lock_acquire include/linux/srcu.h:164 [inline]
>>> #1: ffff888051404378 (&c->btree_trans_barrier){.+.+}-{0:0}, at: =
srcu_read_lock include/linux/srcu.h:256 [inline]
>>> #1: ffff888051404378 (&c->btree_trans_barrier){.+.+}-{0:0}, at: =
__bch2_trans_get+0x7e4/0xd30 fs/bcachefs/btree_iter.c:3377
>>> #2: ffff8880514266d0 (&c->gc_lock){.+.+}-{4:4}, at: =
bch2_btree_update_start+0x682/0x14e0 =
fs/bcachefs/btree_update_interior.c:1180
>>> #3: ffff888051401c68 (&bc->lock){+.+.}-{4:4}, at: =
bch2_btree_node_mem_alloc+0x559/0x16f0 fs/bcachefs/btree_cache.c:804
>>>=20
>>> stack backtrace:
>>> CPU: 0 UID: 0 PID: 5625 Comm: syz.0.21 Not tainted =
6.14.0-rc2-syzkaller-00039-g09fbf3d50205 #0
>>> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS =
1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
>>> Call Trace:
>>> <TASK>
>>> __dump_stack lib/dump_stack.c:94 [inline]
>>> dump_stack_lvl+0x241/0x360 lib/dump_stack.c:120
>>> print_circular_bug+0x13a/0x1b0 kernel/locking/lockdep.c:2076
>>> check_noncircular+0x36a/0x4a0 kernel/locking/lockdep.c:2208
>>> check_prev_add kernel/locking/lockdep.c:3163 [inline]
>>> check_prevs_add kernel/locking/lockdep.c:3282 [inline]
>>> validate_chain+0x18ef/0x5920 kernel/locking/lockdep.c:3906
>>> __lock_acquire+0x1397/0x2100 kernel/locking/lockdep.c:5228
>>> lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5851
>>> __mutex_lock_common kernel/locking/mutex.c:585 [inline]
>>> __mutex_lock+0x19c/0x1010 kernel/locking/mutex.c:730
>>> pcpu_alloc_noprof+0x293/0x1760 mm/percpu.c:1782
>>> __six_lock_init+0x104/0x150 fs/bcachefs/six.c:876
>>> bch2_btree_lock_init+0x38/0x100 fs/bcachefs/btree_locking.c:12
>>> bch2_btree_node_mem_alloc+0x565/0x16f0 fs/bcachefs/btree_cache.c:807
>>> __bch2_btree_node_alloc fs/bcachefs/btree_update_interior.c:304 =
[inline]
>>> bch2_btree_reserve_get+0x2df/0x1890 =
fs/bcachefs/btree_update_interior.c:532
>>> bch2_btree_update_start+0xe56/0x14e0 =
fs/bcachefs/btree_update_interior.c:1230
>>> bch2_btree_split_leaf+0x121/0x880 =
fs/bcachefs/btree_update_interior.c:1851
>>> bch2_trans_commit_error+0x212/0x1380 =
fs/bcachefs/btree_trans_commit.c:908
>>> __bch2_trans_commit+0x812b/0x97a0 =
fs/bcachefs/btree_trans_commit.c:1085
>>> bch2_trans_commit fs/bcachefs/btree_update.h:183 [inline]
>>> bch2_trans_mark_metadata_bucket+0x47a/0x17b0 =
fs/bcachefs/buckets.c:1043
>>> bch2_trans_mark_metadata_sectors fs/bcachefs/buckets.c:1060 [inline]
>>> __bch2_trans_mark_dev_sb fs/bcachefs/buckets.c:1100 [inline]
>>> bch2_trans_mark_dev_sb+0x3f6/0x820 fs/bcachefs/buckets.c:1128
>>> bch2_trans_mark_dev_sbs_flags+0x6be/0x720 fs/bcachefs/buckets.c:1138
>>> bch2_fs_initialize+0xba0/0x1610 fs/bcachefs/recovery.c:1149
>>> bch2_fs_start+0x36d/0x610 fs/bcachefs/super.c:1042
>>> bch2_fs_get_tree+0xd8d/0x1740 fs/bcachefs/fs.c:2203
>>> vfs_get_tree+0x90/0x2b0 fs/super.c:1814
>>> do_new_mount+0x2be/0xb40 fs/namespace.c:3560
>>> do_mount fs/namespace.c:3900 [inline]
>>> __do_sys_mount fs/namespace.c:4111 [inline]
>>> __se_sys_mount+0x2d6/0x3c0 fs/namespace.c:4088
>>> do_syscall_x64 arch/x86/entry/common.c:52 [inline]
>>> do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
>>> entry_SYSCALL_64_after_hwframe+0x77/0x7f
>>> RIP: 0033:0x7fcaed38e58a
>>> Code: d8 64 89 02 48 c7 c0 ff ff ff ff eb a6 e8 de 1a 00 00 66 2e 0f =
1f 84 00 00 00 00 00 0f 1f 40 00 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d =
01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
>>> RSP: 002b:00007fcaec5fde68 EFLAGS: 00000246 ORIG_RAX: =
00000000000000a5
>>> RAX: ffffffffffffffda RBX: 00007fcaec5fdef0 RCX: 00007fcaed38e58a
>>> RDX: 00004000000000c0 RSI: 0000400000000180 RDI: 00007fcaec5fdeb0
>>> RBP: 00004000000000c0 R08: 00007fcaec5fdef0 R09: 0000000000000000
>>>=20
>>>> ---
>>>> fs/bcachefs/six.c | 2 +-
>>>> 1 file changed, 1 insertion(+), 1 deletion(-)
>>>>=20
>>>> diff --git a/fs/bcachefs/six.c b/fs/bcachefs/six.c
>>>> index 7e7c66a1e1a6..ccdc6d496910 100644
>>>> --- a/fs/bcachefs/six.c
>>>> +++ b/fs/bcachefs/six.c
>>>> @@ -873,7 +873,7 @@ void __six_lock_init(struct six_lock *lock, =
const char *name,
>>>> * failure if they wish by checking lock->readers, but generally
>>>> * will not want to treat it as an error.
>>>> */
>>>> - lock->readers =3D alloc_percpu(unsigned);
>>>> + lock->readers =3D alloc_percpu_gfp(unsigned, =
GFP_NOWAIT|__GFP_NOWARN);
>>>> }
>>>> #endif
>>>> }
>>>> --=20
>>>> 2.47.0
>>>>=20
>>=20


Received: from mail-yb1-f169.google.com (mail-yb1-f169.google.com [209.85.219.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28E0C266196;
	Mon, 24 Feb 2025 18:52:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740423159; cv=none; b=fIQmQ+Wj+mzjn1LLIfooVMrZKLoH1oAJlen60wq9vyzZaPzqOHWmQJgJ7Y9JkJ+5ACRfRixOt7Tiznw5b8JYOaOU/QJEO0bhTBZdEIe/DgxfLYj4CNajKBdOygYKe4Sf9Eyll36lF6VtsTCIbOpTXtkPdd3f/O8+c9v08+E71Gc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740423159; c=relaxed/simple;
	bh=NRqmJrka1KFCKrbmi1NfqRE1Svd7bhfDRuWVbmXIb/U=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=smZ9HkW1tdwfgvovvKz7MlrWJP9n3b9yGvCN2OUG0fiCQni6ZFYGLTgDCfxBuklpPVkSctlDIEWI/q4NFvrshhm/PiMqW8PO7hba2Sl5cpQEihkKldDYoFogLoEGb9xRbCsJeBdrLGuWJBS0qQKsmWxftETJSxQg6vMK/QiwEFc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=m7UoD+wb; arc=none smtp.client-ip=209.85.219.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="m7UoD+wb"
Received: by mail-yb1-f169.google.com with SMTP id 3f1490d57ef6-e46ebe19489so3381103276.2;
        Mon, 24 Feb 2025 10:52:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1740423156; x=1741027956; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=d7U1sT68Ju6x/uUPaDyaf4r2qRxDAkfJXgbOu58Kb8U=;
        b=m7UoD+wbLcC/Mc8Lu1nscwVGK5o//K1pSOvyEGDu0F6xjqMUZDnOqnTH8J/IPRZp/4
         GmPxxyTTb2ewhMddjQhgubkxCig5ompvKh2ZynYg0bm6/ucSPpqBvv0EuRoqkPWpXpzl
         fv+/JW/9d6NU0VuKq8be7B5ys72463l2Ns3JClLyla+vwn0rCyNEvYRXfbyzmgpKtf5R
         p2d+nDQaVJQlvT+tle2bIAnzT//01SgVtHEqgQVag2n056bLAwirgB6QitVMBclgCvzz
         xtgCQBDfLOgDv4ft9/fY7xbPCzA797nAes4BH/zDs98yS1mDSLR1Sx5eJ6Elz3Sr/szw
         17Bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740423156; x=1741027956;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=d7U1sT68Ju6x/uUPaDyaf4r2qRxDAkfJXgbOu58Kb8U=;
        b=IYeHsoxH3Mr1pUUX2K5ji+Pn8EKbwfky7zKNhBVPtDVXBN0TcUT7KqIkMC4N6BmD37
         plAT7udSodSp6CiqQqHzZoOEAOxl/iyMCaE68MBB4+gQ0n2hbG7PPdWUWcPC+wF2qaCL
         +Jo4frqrEpjCIQnXsQoj5cwd670knpJA7x14S599wx+RNzoZOgeUf+iUY6YAtGntqIuU
         iIars/C/5wRRXQek7Og+kyKXsjbUurAScK9/NQ0Q8ct3cC6tpNRzo4QzkRNb2lqvcB83
         sk0ElV3oWsXpN6mpg4j5ePVvbB67CeD0N7H9fUVI2a3p+rb79FnXhjmn6QF6+CWDwnBI
         fSxg==
X-Forwarded-Encrypted: i=1; AJvYcCV0EfBMXwXaQtAeHLJAjQPTkhmALRaMBEVruDihNyqpdnnXmm5WKxtfHaWybvKPWM9tsv++Kt2VP/wevoYj@vger.kernel.org, AJvYcCWPetIVP6e0iMhNuDkl+hCIuAzbU/9Zse8/4AoAs7N/48BuVGCBY+5qp6QEAZ6QEBLPwMTYkZBOtFESHJYsIg==@vger.kernel.org
X-Gm-Message-State: AOJu0YzGz4b2QTFU+L91dJysI4f0UKdPKhN/wkEPXZwzBQyujc9T7F8i
	5QfGc0wvT1RdMlLeML7EnM8q2UHH8NEtsGDL+h7Qx0sD7WPpdt3i
X-Gm-Gg: ASbGncvThR9JWI8Daikbm6wkv/TqC3whkGQgQIKNMPfoE8Be1Y6HNC8R3y039BZEuBD
	EE9zUaxLlQtwdrhUCUdlmHC/TyFpcgwzJr6QL/RLKoHWF5LG4xdOer8aKDkR5P1Q1L9IjJ74xjA
	FO3bz0RQu25Gv4TuZ05ZuE46hnpfC0WFUKCIFSLEikWEqfziku1PGjMx28eNBbFZ/B7ugplHGU+
	fITLi3mVurrH8fSi5/tsapnUd84eT0mgYNPZa+ZJYFEXWfMhAifG2e64OX3UgkxBe5zFNaIAqCK
	t0avgYeJtQ==
X-Google-Smtp-Source: AGHT+IEdPIxJRhoe3fabHRoPZTnfAvMKgtBxPVqAHZ4MAbojsmngt25mShKoPUBRjnNJ06R823ntyg==
X-Received: by 2002:a05:6902:1028:b0:e57:34b3:3a1 with SMTP id 3f1490d57ef6-e5e24601df2mr11215271276.25.1740423155874;
        Mon, 24 Feb 2025 10:52:35 -0800 (PST)
Received: from smtpclient.apple ([2402:d0c0:11:86::1])
        by smtp.gmail.com with ESMTPSA id 3f1490d57ef6-e5dadfc0919sm6065085276.34.2025.02.24.10.52.33
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 24 Feb 2025 10:52:35 -0800 (PST)
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3826.400.131.1.6\))
Subject: Re: [syzbot] [bcachefs?] possible deadlock in pcpu_alloc_noprof
From: Alan Huang <mmpgouride@gmail.com>
In-Reply-To: <67ac241e.050a0220.110943.0047.GAE@google.com>
Date: Tue, 25 Feb 2025 02:52:18 +0800
Cc: kent.overstreet@linux.dev,
 linux-bcachefs@vger.kernel.org,
 linux-kernel@vger.kernel.org,
 syzkaller-bugs@googlegroups.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <4659682E-734B-439A-9C3B-02257858B8F1@gmail.com>
References: <67ac241e.050a0220.110943.0047.GAE@google.com>
To: syzbot <syzbot+fe63f377148a6371a9db@syzkaller.appspotmail.com>
X-Mailer: Apple Mail (2.3826.400.131.1.6)


> On Feb 12, 2025, at 12:31, syzbot =
<syzbot+fe63f377148a6371a9db@syzkaller.appspotmail.com> wrote:
>=20
> syzbot has found a reproducer for the following issue on:
>=20
> HEAD commit:    09fbf3d50205 Merge tag 'tomoyo-pr-20250211' of =
git://git.c..
> git tree:       upstream
> console output: =
https://syzkaller.appspot.com/x/log.txt?x=3D14370aa4580000
> kernel config:  =
https://syzkaller.appspot.com/x/.config?x=3D3c2347dd6174fbe2
> dashboard link: =
https://syzkaller.appspot.com/bug?extid=3Dfe63f377148a6371a9db
> compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for =
Debian) 2.40
> syz repro:      =
https://syzkaller.appspot.com/x/repro.syz?x=3D17404718580000
>=20
> Downloadable assets:
> disk image (non-bootable): =
https://storage.googleapis.com/syzbot-assets/7feb34a89c2a/non_bootable_dis=
k-09fbf3d5.raw.xz
> vmlinux: =
https://storage.googleapis.com/syzbot-assets/835b3d29c46c/vmlinux-09fbf3d5=
.xz
> kernel image: =
https://storage.googleapis.com/syzbot-assets/ff4bfd8a5d42/bzImage-09fbf3d5=
.xz
> mounted in repro #1: =
https://storage.googleapis.com/syzbot-assets/24d046ee591e/mount_7.gz
> mounted in repro #2: =
https://storage.googleapis.com/syzbot-assets/fc8a49472f19/mount_9.gz
>=20
> IMPORTANT: if you fix the issue, please add the following tag to the =
commit:
> Reported-by: syzbot+fe63f377148a6371a9db@syzkaller.appspotmail.com
>=20
> bcachefs (loop0): initializing new filesystem
> bcachefs (loop0): going read-write
> bcachefs (loop0): marking superblocks
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
> WARNING: possible circular locking dependency detected
> 6.14.0-rc2-syzkaller-00039-g09fbf3d50205 #0 Not tainted
> ------------------------------------------------------
> syz.0.21/5625 is trying to acquire lock:
> ffffffff8ea19608 (pcpu_alloc_mutex){+.+.}-{4:4}, at: =
pcpu_alloc_noprof+0x293/0x1760 mm/percpu.c:1782
>=20
> but task is already holding lock:
> ffff888051401c68 (&bc->lock){+.+.}-{4:4}, at: =
bch2_btree_node_mem_alloc+0x559/0x16f0 fs/bcachefs/btree_cache.c:804
>=20
> which lock already depends on the new lock.
>=20
>=20
> the existing dependency chain (in reverse order) is:
>=20
> -> #2 (&bc->lock){+.+.}-{4:4}:
>       lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5851
>       __mutex_lock_common kernel/locking/mutex.c:585 [inline]
>       __mutex_lock+0x19c/0x1010 kernel/locking/mutex.c:730
>       bch2_btree_cache_scan+0x184/0xec0 fs/bcachefs/btree_cache.c:482
>       do_shrink_slab+0x72d/0x1160 mm/shrinker.c:437
>       shrink_slab+0x1093/0x14d0 mm/shrinker.c:664
>       shrink_one+0x43b/0x850 mm/vmscan.c:4868
>       shrink_many mm/vmscan.c:4929 [inline]
>       lru_gen_shrink_node mm/vmscan.c:5007 [inline]
>       shrink_node+0x37c5/0x3e50 mm/vmscan.c:5978
>       kswapd_shrink_node mm/vmscan.c:6807 [inline]
>       balance_pgdat mm/vmscan.c:6999 [inline]
>       kswapd+0x20f3/0x3b10 mm/vmscan.c:7264
>       kthread+0x7a9/0x920 kernel/kthread.c:464
>       ret_from_fork+0x4b/0x80 arch/x86/kernel/process.c:148
>       ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244
>=20
> -> #1 (fs_reclaim){+.+.}-{0:0}:
>       lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5851
>       __fs_reclaim_acquire mm/page_alloc.c:3853 [inline]
>       fs_reclaim_acquire+0x88/0x130 mm/page_alloc.c:3867
>       might_alloc include/linux/sched/mm.h:318 [inline]
>       slab_pre_alloc_hook mm/slub.c:4066 [inline]
>       slab_alloc_node mm/slub.c:4144 [inline]
>       __do_kmalloc_node mm/slub.c:4293 [inline]
>       __kmalloc_noprof+0xae/0x4c0 mm/slub.c:4306
>       kmalloc_noprof include/linux/slab.h:905 [inline]
>       kzalloc_noprof include/linux/slab.h:1037 [inline]
>       pcpu_mem_zalloc mm/percpu.c:510 [inline]
>       pcpu_alloc_chunk mm/percpu.c:1430 [inline]
>       pcpu_create_chunk+0x57/0xbc0 mm/percpu-vm.c:338
>       pcpu_balance_populated mm/percpu.c:2063 [inline]
>       pcpu_balance_workfn+0xc4d/0xd40 mm/percpu.c:2200
>       process_one_work kernel/workqueue.c:3236 [inline]
>       process_scheduled_works+0xa66/0x1840 kernel/workqueue.c:3317
>       worker_thread+0x870/0xd30 kernel/workqueue.c:3398
>       kthread+0x7a9/0x920 kernel/kthread.c:464
>       ret_from_fork+0x4b/0x80 arch/x86/kernel/process.c:148
>       ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244
>=20
> -> #0 (pcpu_alloc_mutex){+.+.}-{4:4}:
>       check_prev_add kernel/locking/lockdep.c:3163 [inline]
>       check_prevs_add kernel/locking/lockdep.c:3282 [inline]
>       validate_chain+0x18ef/0x5920 kernel/locking/lockdep.c:3906
>       __lock_acquire+0x1397/0x2100 kernel/locking/lockdep.c:5228
>       lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5851
>       __mutex_lock_common kernel/locking/mutex.c:585 [inline]
>       __mutex_lock+0x19c/0x1010 kernel/locking/mutex.c:730
>       pcpu_alloc_noprof+0x293/0x1760 mm/percpu.c:1782
>       __six_lock_init+0x104/0x150 fs/bcachefs/six.c:876
>       bch2_btree_lock_init+0x38/0x100 fs/bcachefs/btree_locking.c:12
>       bch2_btree_node_mem_alloc+0x565/0x16f0 =
fs/bcachefs/btree_cache.c:807
>       __bch2_btree_node_alloc fs/bcachefs/btree_update_interior.c:304 =
[inline]
>       bch2_btree_reserve_get+0x2df/0x1890 =
fs/bcachefs/btree_update_interior.c:532
>       bch2_btree_update_start+0xe56/0x14e0 =
fs/bcachefs/btree_update_interior.c:1230
>       bch2_btree_split_leaf+0x121/0x880 =
fs/bcachefs/btree_update_interior.c:1851
>       bch2_trans_commit_error+0x212/0x1380 =
fs/bcachefs/btree_trans_commit.c:908
>       __bch2_trans_commit+0x812b/0x97a0 =
fs/bcachefs/btree_trans_commit.c:1085
>       bch2_trans_commit fs/bcachefs/btree_update.h:183 [inline]
>       bch2_trans_mark_metadata_bucket+0x47a/0x17b0 =
fs/bcachefs/buckets.c:1043
>       bch2_trans_mark_metadata_sectors fs/bcachefs/buckets.c:1060 =
[inline]
>       __bch2_trans_mark_dev_sb fs/bcachefs/buckets.c:1100 [inline]
>       bch2_trans_mark_dev_sb+0x3f6/0x820 fs/bcachefs/buckets.c:1128
>       bch2_trans_mark_dev_sbs_flags+0x6be/0x720 =
fs/bcachefs/buckets.c:1138
>       bch2_fs_initialize+0xba0/0x1610 fs/bcachefs/recovery.c:1149
>       bch2_fs_start+0x36d/0x610 fs/bcachefs/super.c:1042
>       bch2_fs_get_tree+0xd8d/0x1740 fs/bcachefs/fs.c:2203
>       vfs_get_tree+0x90/0x2b0 fs/super.c:1814
>       do_new_mount+0x2be/0xb40 fs/namespace.c:3560
>       do_mount fs/namespace.c:3900 [inline]
>       __do_sys_mount fs/namespace.c:4111 [inline]
>       __se_sys_mount+0x2d6/0x3c0 fs/namespace.c:4088
>       do_syscall_x64 arch/x86/entry/common.c:52 [inline]
>       do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
>       entry_SYSCALL_64_after_hwframe+0x77/0x7f
>=20
> other info that might help us debug this:
>=20
> Chain exists of:
>  pcpu_alloc_mutex --> fs_reclaim --> &bc->lock
>=20
> Possible unsafe locking scenario:
>=20
>       CPU0                    CPU1
>       ----                    ----
>  lock(&bc->lock);
>                               lock(fs_reclaim);
>                               lock(&bc->lock);
>  lock(pcpu_alloc_mutex);
>=20
> *** DEADLOCK ***
>=20
> 4 locks held by syz.0.21/5625:
> #0: ffff888051400278 (&c->state_lock){+.+.}-{4:4}, at: =
bch2_fs_start+0x45/0x610 fs/bcachefs/super.c:1010
> #1: ffff888051404378 (&c->btree_trans_barrier){.+.+}-{0:0}, at: =
srcu_lock_acquire include/linux/srcu.h:164 [inline]
> #1: ffff888051404378 (&c->btree_trans_barrier){.+.+}-{0:0}, at: =
srcu_read_lock include/linux/srcu.h:256 [inline]
> #1: ffff888051404378 (&c->btree_trans_barrier){.+.+}-{0:0}, at: =
__bch2_trans_get+0x7e4/0xd30 fs/bcachefs/btree_iter.c:3377
> #2: ffff8880514266d0 (&c->gc_lock){.+.+}-{4:4}, at: =
bch2_btree_update_start+0x682/0x14e0 =
fs/bcachefs/btree_update_interior.c:1180
> #3: ffff888051401c68 (&bc->lock){+.+.}-{4:4}, at: =
bch2_btree_node_mem_alloc+0x559/0x16f0 fs/bcachefs/btree_cache.c:804
>=20
> stack backtrace:
> CPU: 0 UID: 0 PID: 5625 Comm: syz.0.21 Not tainted =
6.14.0-rc2-syzkaller-00039-g09fbf3d50205 #0
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS =
1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
> Call Trace:
> <TASK>
> __dump_stack lib/dump_stack.c:94 [inline]
> dump_stack_lvl+0x241/0x360 lib/dump_stack.c:120
> print_circular_bug+0x13a/0x1b0 kernel/locking/lockdep.c:2076
> check_noncircular+0x36a/0x4a0 kernel/locking/lockdep.c:2208
> check_prev_add kernel/locking/lockdep.c:3163 [inline]
> check_prevs_add kernel/locking/lockdep.c:3282 [inline]
> validate_chain+0x18ef/0x5920 kernel/locking/lockdep.c:3906
> __lock_acquire+0x1397/0x2100 kernel/locking/lockdep.c:5228
> lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5851
> __mutex_lock_common kernel/locking/mutex.c:585 [inline]
> __mutex_lock+0x19c/0x1010 kernel/locking/mutex.c:730
> pcpu_alloc_noprof+0x293/0x1760 mm/percpu.c:1782
> __six_lock_init+0x104/0x150 fs/bcachefs/six.c:876
> bch2_btree_lock_init+0x38/0x100 fs/bcachefs/btree_locking.c:12
> bch2_btree_node_mem_alloc+0x565/0x16f0 fs/bcachefs/btree_cache.c:807
> __bch2_btree_node_alloc fs/bcachefs/btree_update_interior.c:304 =
[inline]
> bch2_btree_reserve_get+0x2df/0x1890 =
fs/bcachefs/btree_update_interior.c:532
> bch2_btree_update_start+0xe56/0x14e0 =
fs/bcachefs/btree_update_interior.c:1230
> bch2_btree_split_leaf+0x121/0x880 =
fs/bcachefs/btree_update_interior.c:1851
> bch2_trans_commit_error+0x212/0x1380 =
fs/bcachefs/btree_trans_commit.c:908
> __bch2_trans_commit+0x812b/0x97a0 =
fs/bcachefs/btree_trans_commit.c:1085
> bch2_trans_commit fs/bcachefs/btree_update.h:183 [inline]
> bch2_trans_mark_metadata_bucket+0x47a/0x17b0 =
fs/bcachefs/buckets.c:1043
> bch2_trans_mark_metadata_sectors fs/bcachefs/buckets.c:1060 [inline]
> __bch2_trans_mark_dev_sb fs/bcachefs/buckets.c:1100 [inline]
> bch2_trans_mark_dev_sb+0x3f6/0x820 fs/bcachefs/buckets.c:1128
> bch2_trans_mark_dev_sbs_flags+0x6be/0x720 fs/bcachefs/buckets.c:1138
> bch2_fs_initialize+0xba0/0x1610 fs/bcachefs/recovery.c:1149
> bch2_fs_start+0x36d/0x610 fs/bcachefs/super.c:1042
> bch2_fs_get_tree+0xd8d/0x1740 fs/bcachefs/fs.c:2203
> vfs_get_tree+0x90/0x2b0 fs/super.c:1814
> do_new_mount+0x2be/0xb40 fs/namespace.c:3560
> do_mount fs/namespace.c:3900 [inline]
> __do_sys_mount fs/namespace.c:4111 [inline]
> __se_sys_mount+0x2d6/0x3c0 fs/namespace.c:4088
> do_syscall_x64 arch/x86/entry/common.c:52 [inline]
> do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
> entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7fcaed38e58a
> Code: d8 64 89 02 48 c7 c0 ff ff ff ff eb a6 e8 de 1a 00 00 66 2e 0f =
1f 84 00 00 00 00 00 0f 1f 40 00 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d =
01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007fcaec5fde68 EFLAGS: 00000246 ORIG_RAX: 00000000000000a5
> RAX: ffffffffffffffda RBX: 00007fcaec5fdef0 RCX: 00007fcaed38e58a
> RDX: 00004000000000c0 RSI: 0000400000000180 RDI: 00007fcaec5fdeb0
> RBP: 00004000000000c0 R08: 00007fcaec5fdef0 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000400000000180
> R13: 00007fcaec5fdeb0 R14: 0000000000005a05 R15: 0000400000000480
> </TASK>
> bcachefs (loop0): initializing freespace
> bcachefs (loop0): done initializing freespace
> bcachefs (loop0): reading snapshots table
> bcachefs (loop0): reading snapshots done
> bcachefs (loop0): done starting filesystem
>=20
>=20
> ---
> If you want syzbot to run the reproducer, reply with:
> #syz test: git://repo/address.git branch-or-commit-hash
> If you attach or paste a git patch, syzbot will apply it before =
testing.
>=20

#syz test


diff --git a/fs/bcachefs/btree_cache.c b/fs/bcachefs/btree_cache.c
index ca755e8d1a37..9761dc05ba07 100644
--- a/fs/bcachefs/btree_cache.c
+++ b/fs/bcachefs/btree_cache.c
@@ -794,17 +794,17 @@ struct btree *bch2_btree_node_mem_alloc(struct =
btree_trans *trans, bool pcpu_rea
                        goto got_node;
                }
=20
+       mutex_unlock(&bc->lock);
        b =3D __btree_node_mem_alloc(c, GFP_NOWAIT|__GFP_NOWARN);
        if (!b) {
-               mutex_unlock(&bc->lock);
                bch2_trans_unlock(trans);
                b =3D __btree_node_mem_alloc(c, GFP_KERNEL);
                if (!b)
                        goto err;
-               mutex_lock(&bc->lock);
        }
=20
        bch2_btree_lock_init(&b->c, pcpu_read_locks ? SIX_LOCK_INIT_PCPU =
: 0);
+       mutex_lock(&bc->lock);
=20
        BUG_ON(!six_trylock_intent(&b->c.lock));
        BUG_ON(!six_trylock_write(&b->c.lock));



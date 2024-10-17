Received: from smtp.carlthompson.net (charon.carlthompson.net [45.77.7.122])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 044285CB8
	for <linux-bcachefs@vger.kernel.org>; Thu, 17 Oct 2024 09:15:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.77.7.122
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729156532; cv=none; b=n3R54bPTsnRM3Dg8owSaRMalnPRSAzriF4BTQ5tkFCX/EM84m7n4kXJnhzHfMGFTIkAAArd5kZmXmsMdkwWnRRYM0gI+owGWt4SR50Viw5eLQRRsyjzhN3EZb+w8qOHOnPb/SvuKP1VrPZG6PT1LtccNmUZl3hlX6+F7u8kPCME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729156532; c=relaxed/simple;
	bh=iKSiPb13ojJop/hUR1Y7Pscy3LLxdzVL1EaGvBh0PqI=;
	h=Date:From:To:Cc:Message-ID:In-Reply-To:References:Subject:
	 MIME-Version:Content-Type; b=NHSIymPtNbcm6iK7UDveA73uopLPjoWPRxZYBizBF60HvDYKypbzGquXP3hSaNvEUX8/SjDN/QmRUVtTFHuL729ZIMCoxsiDuwaNJjvbDjOe79+Ura3w/XLmNQX0IVMHiWdtZ9hUrruhxhFdGecjnH0xKbZWZWfcAqjtJKq3Lcg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=carlthompson.net; spf=pass smtp.mailfrom=carlthompson.net; arc=none smtp.client-ip=45.77.7.122
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=carlthompson.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=carlthompson.net
Received: from mail.carlthompson.net (mail.home [10.35.20.252])
	(Authenticated sender: cet@carlthompson.net)
	by smtp.carlthompson.net (Postfix) with ESMTPSA id C9DDF401590AB;
	Thu, 17 Oct 2024 02:15:27 -0700 (PDT)
Date: Thu, 17 Oct 2024 02:15:27 -0700 (PDT)
From: "Carl E. Thompson" <list-bcachefs@carlthompson.net>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: "linux-bcachefs@vger.kernel.org" <linux-bcachefs@vger.kernel.org>
Message-ID: <724749266.890.1729156527639@mail.carlthompson.net>
In-Reply-To: <xcdedhwtm4aajc4fhpb2d2urtvss7bxxzdtt2hw73hewjgr2o5@4vyurjq5v5mq>
References: <873903780.802.1729054276600@mail.carlthompson.net>
 <46uitwudetmmygddpxufepddca7azsim6trqj4o2ivsccdeavz@uztkfyqtjgks>
 <1823582410.854.1729153747302@mail.carlthompson.net>
 <xcdedhwtm4aajc4fhpb2d2urtvss7bxxzdtt2hw73hewjgr2o5@4vyurjq5v5mq>
Subject: Re: Another bcachefs version downgrade bug
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Priority: 3
Importance: Normal
X-Mailer: Open-Xchange Mailer v7.10.6-Rev53
X-Originating-Client: open-xchange-appsuite


> On 2024-10-17 1:39 AM PDT Kent Overstreet <kent.overstreet@linux.dev> wrote:

> ...

> Again - bcachefs was only merged in 6.7, clearly marked experimental,
> and you're running 6.9; this kind of bug is exactly the sort of thing we
> try to shake out in the experimental phase.

Not a bcachefs problem but as a distribution user I would have no idea that bcachefs was experimental. Every major distribution I've looked at recently includes the bcachefs module and tools and there is nothing to tell the user it's experimental. Only the person who actually configured the kernel (or people who read mailing lists) would know that it's experimental.

Perhaps if this is to be expected right now the bcachefs command line tool should output a big warning letting users know that bcachefs is experimental and might eat their data?

> Also, a fsck would have sufficed, if you haven't ran that already.

That must be a different bug because that doesn't work. I still have the old filesystem images and I just tried fsck again, then mounted, then tried to unmount and immediately got the same filesystem lockup. Time to reboot. See below.

Carl


fsck test:
---

[clip carl]# fsck.bcachefs /dev/clip/local.old
Running userspace offline fsck
starting version 1.12: (unknown version) opts=ro,compression=lz4,nopromote_whole_extents,degraded,fsck,fix_errors=ask,read_only
recovering from clean shutdown, journal seq 5004
Version downgrade required:
  running recovery passes: check_allocations
accounting_read... done
alloc_read... done
stripes_read... done
snapshots_read... done
check_allocations... done
going read-write
journal_replay... done
check_alloc_info... done
check_lrus... done
check_btree_backpointers... done
check_backpointers_to_extents... done
check_extents_to_backpointers... done
check_alloc_to_lru_refs... done
check_snapshot_trees... done
check_snapshots... done
check_subvols... done
check_subvol_children... done
delete_dead_snapshots... done
check_inodes... done
check_extents... done
check_indirect_extents... done
check_dirents... done
check_xattrs... done
check_root... done
check_subvolume_structure... done
check_directory_structure... done
check_nlinks... done
resume_logged_ops... done
delete_dead_inodes... done
shutdown complete, journal seq 5005


[clip carl]# mount /dev/clip/local.old /cet

[clip carl]# umount /cet



^C^C^C^C^C



From dmesg:
---

[10679.819992] bcachefs (dm-7): mounting version 1.11: (unknown version) opts=compression=lz4
[10679.820007] bcachefs (dm-7): recovering from clean shutdown, journal seq 5005
[10679.820009] bcachefs (dm-7): Version downgrade required:
[10679.828985] bcachefs (dm-7): alloc_read... done
[10679.828999] bcachefs (dm-7): stripes_read... done
[10679.829004] bcachefs (dm-7): snapshots_read... done
[10679.829439] bcachefs (dm-7): journal_replay... done
[10679.829445] bcachefs (dm-7): resume_logged_ops... done
[10679.829454] bcachefs (dm-7): going read-write
[10929.797197] Process accounting resumed
[10930.010868] r8169 0000:02:00.0 eth0: Link is Down
[10935.961246] INFO: task bch-copygc/dm-7:28532 blocked for more than 122 seconds.
[10935.961252]       Not tainted 6.9.4-arch1-1 #1
[10935.961253] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[10935.961255] task:bch-copygc/dm-7 state:D stack:0     pid:28532 tgid:28532 ppid:2      flags:0x00024000
[10935.961259] Call Trace:
[10935.961261]  <TASK>
[10935.961265]  __schedule+0x3c7/0x1510
[10935.961275]  schedule+0x27/0xf0
[10935.961278]  __closure_sync+0x7e/0x140
[10935.961283]  __bch2_write+0x136b/0x1660 [bcachefs 8d6f6bf430dcfbb124cd4a016333997e24e1fc8a]
[10935.961336]  ? srso_alias_return_thunk+0x5/0xfbef5
[10935.961339]  ? __kmalloc+0x1a7/0x440
[10935.961343]  ? srso_alias_return_thunk+0x5/0xfbef5
[10935.961346]  ? srso_alias_return_thunk+0x5/0xfbef5
[10935.961351]  ? srso_alias_return_thunk+0x5/0xfbef5
[10935.961353]  ? local_clock_noinstr+0xd/0xd0
[10935.961355]  ? srso_alias_return_thunk+0x5/0xfbef5
[10935.961357]  ? srso_alias_return_thunk+0x5/0xfbef5
[10935.961360]  ? bch2_moving_ctxt_do_pending_writes+0x11a/0x220 [bcachefs 8d6f6bf430dcfbb124cd4a016333997e24e1fc8a]
[10935.961397]  bch2_moving_ctxt_do_pending_writes+0x11a/0x220 [bcachefs 8d6f6bf430dcfbb124cd4a016333997e24e1fc8a]
[10935.961426]  ? srso_alias_return_thunk+0x5/0xfbef5
[10935.961428]  ? bch2_btree_path_traverse_one+0x958/0xcf0 [bcachefs 8d6f6bf430dcfbb124cd4a016333997e24e1fc8a]
[10935.961467]  bch2_data_update_init+0x68b/0x1420 [bcachefs 8d6f6bf430dcfbb124cd4a016333997e24e1fc8a]
[10935.961512]  ? bch2_move_extent+0x3da/0xed0 [bcachefs 8d6f6bf430dcfbb124cd4a016333997e24e1fc8a]
[10935.961549]  bch2_move_extent+0x3da/0xed0 [bcachefs 8d6f6bf430dcfbb124cd4a016333997e24e1fc8a]
[10935.961584]  ? bch2_evacuate_bucket+0x9d4/0xc00 [bcachefs 8d6f6bf430dcfbb124cd4a016333997e24e1fc8a]
[10935.961615]  bch2_evacuate_bucket+0x9d4/0xc00 [bcachefs 8d6f6bf430dcfbb124cd4a016333997e24e1fc8a]
[10935.961653]  ? bch2_copygc+0x210/0x880 [bcachefs 8d6f6bf430dcfbb124cd4a016333997e24e1fc8a]
[10935.961684]  bch2_copygc+0x210/0x880 [bcachefs 8d6f6bf430dcfbb124cd4a016333997e24e1fc8a]
[10935.961718]  bch2_copygc_thread+0x152/0x3d0 [bcachefs 8d6f6bf430dcfbb124cd4a016333997e24e1fc8a]
[10935.961749]  ? bch2_copygc_thread+0xcf/0x3d0 [bcachefs 8d6f6bf430dcfbb124cd4a016333997e24e1fc8a]
[10935.961784]  ? __pfx_bch2_copygc_thread+0x10/0x10 [bcachefs 8d6f6bf430dcfbb124cd4a016333997e24e1fc8a]
[10935.961813]  kthread+0xcf/0x100
[10935.961818]  ? __pfx_kthread+0x10/0x10
[10935.961821]  ret_from_fork+0x31/0x50
[10935.961825]  ? __pfx_kthread+0x10/0x10
[10935.961828]  ret_from_fork_asm+0x1a/0x30
[10935.961834]  </TASK>
[10935.961835] INFO: task umount:28561 blocked for more than 122 seconds.
[10935.961837]       Not tainted 6.9.4-arch1-1 #1
[10935.961838] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[10935.961839] task:umount          state:D stack:0     pid:28561 tgid:28561 ppid:27681  flags:0x00004004
[10935.961842] Call Trace:
[10935.961844]  <TASK>
[10935.961846]  __schedule+0x3c7/0x1510
[10935.961850]  ? schedule+0x27/0xf0
[10935.961855]  schedule+0x27/0xf0
[10935.961857]  schedule_timeout+0x12f/0x160
[10935.961862]  wait_for_completion+0x86/0x170
[10935.961866]  kthread_stop+0x6a/0x180
[10935.961869]  bch2_copygc_stop+0x1e/0x80 [bcachefs 8d6f6bf430dcfbb124cd4a016333997e24e1fc8a]
[10935.961900]  __bch2_fs_read_only+0x3b/0x210 [bcachefs 8d6f6bf430dcfbb124cd4a016333997e24e1fc8a]
[10935.961938]  bch2_fs_read_only+0x140/0x3f0 [bcachefs 8d6f6bf430dcfbb124cd4a016333997e24e1fc8a]
[10935.961972]  ? __pfx_autoremove_wake_function+0x10/0x10
[10935.961976]  __bch2_fs_stop+0x5a/0x380 [bcachefs 8d6f6bf430dcfbb124cd4a016333997e24e1fc8a]
[10935.962009]  generic_shutdown_super+0x77/0x170
[10935.962014]  bch2_kill_sb+0x16/0x20 [bcachefs 8d6f6bf430dcfbb124cd4a016333997e24e1fc8a]
[10935.962053]  deactivate_locked_super+0x30/0xb0
[10935.962057]  cleanup_mnt+0xba/0x150
[10935.962061]  task_work_run+0x59/0x90
[10935.962065]  syscall_exit_to_user_mode+0x1fe/0x210
[10935.962067]  do_syscall_64+0x8f/0x190
[10935.962071]  ? syscall_exit_to_user_mode+0x75/0x210
[10935.962073]  ? srso_alias_return_thunk+0x5/0xfbef5
[10935.962075]  ? do_syscall_64+0x8f/0x190
[10935.962077]  ? srso_alias_return_thunk+0x5/0xfbef5
[10935.962079]  ? srso_alias_return_thunk+0x5/0xfbef5
[10935.962081]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
[10935.962085] RIP: 0033:0x79801ee197a9
[10935.962127] RSP: 002b:00007ffd0559c690 EFLAGS: 00000246 ORIG_RAX: 00000000000000a6
[10935.962130] RAX: 0000000000000000 RBX: 000079801edcfb50 RCX: 000079801ee197a9
[10935.962132] RDX: 000000000000034a RSI: 0000000000000000 RDI: 000056a4fc1f53b0
[10935.962133] RBP: 000056a4fc1f53b0 R08: 00000000ffffff9c R09: 0000000000000000
[10935.962135] R10: 00000000fffffffe R11: 0000000000000246 R12: 0000000000000000
[10935.962136] R13: 000079801edcfc58 R14: 000056a4fc1f5740 R15: 0000000000000000
[10935.962140]  </TASK>

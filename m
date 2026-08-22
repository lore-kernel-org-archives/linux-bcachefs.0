Received: from rere.qmqm.pl (rere.qmqm.pl [91.227.64.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFF5123D2A1;
	Sat, 22 Aug 2026 10:37:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.227.64.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787395039; cv=none; b=MmlIaDDlZU6u9jvY7Yk7wJ/8kLuLZzefQ1O0hOGXJ0ghXipBCb5OqKA5sMRFDY4cSE6b/OJy9E5+xjV17egDBR8mchF4RnAgvTFDibkMcKHZ1eTEBfx1ITb9varCPvUj0dkkquoDAsjeQqNZ5gB+74NX8Tvh4N0VWIoIMZS4lno=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787395039; c=relaxed/simple;
	bh=KbiDhXWNk/3xbMJT++wLnTNZNs5FsVAHE2Qxivf44dw=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=FZQWoxNOrKqh0k53NQqFeV6NaZs6DWcj14ZWTUBCD0xSrVRO+WiY0AJUPOwiuKMwcU2f2boo4vzjopmVKBA8ZcBHC45gISMI3ZaH08cJ8nap4JAaqbwiVX4ezJESyw+g+6I00Xwdj8RvTcCKC4xTTaHPPsAFjwAvXcukXPblcAc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=rere.qmqm.pl; spf=pass smtp.mailfrom=rere.qmqm.pl; dkim=pass (2048-bit key) header.d=rere.qmqm.pl header.i=@rere.qmqm.pl header.b=sLFKGe5Q; arc=none smtp.client-ip=91.227.64.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=rere.qmqm.pl
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rere.qmqm.pl
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rere.qmqm.pl header.i=@rere.qmqm.pl header.b="sLFKGe5Q"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=rere.qmqm.pl; s=1;
	t=1787395033; bh=KbiDhXWNk/3xbMJT++wLnTNZNs5FsVAHE2Qxivf44dw=;
	h=Date:From:To:Cc:Subject:From;
	b=sLFKGe5Q8o3k0NyFLUAJd3HSt0oU1LQuPbhInHAAhWKrjqyH8DOvSqGoFh+scN+F/
	 xEOSQFrbVhLL5D8oBgVsGObl42YLnuaRJehIjpLHNhAdZjMytgBU1ukOcaNHNSFD6D
	 HcXmiJ3+0TH18DMIvm43nFjjZ95LwE+vuvfxqgwdiEDvSLiu8Qi4hYD47NexeqP8t2
	 f07Suqaib1xMcSmprq64F2QPEdFuy/ssg12G3UYmiTaz7CHoR+o2yX/nWUGiex8Z5c
	 GlZcZVdntkk6XQZYKzVVxlnE9VO2CzUX50U+DQ0YuIaNlKu9t+3Y9Naelg9uDVfSOm
	 Y84NBEB/MwyNQ==
X-Virus-Status: Clean
X-Virus-Scanned: clamav-milter 1.4.3 at mail
Received: from remote.user (localhost [127.0.0.1])
	by rere.qmqm.pl (Postfix) with ESMTPSA id 4hRtsP2dxwz5J;
	Sat, 22 Aug 2026 12:37:13 +0200 (CEST)
Date: Sat, 22 Aug 2026 12:37:11 +0200
From: =?iso-8859-2?Q?Micha=B3_Miros=B3aw?= <mirq-linux@rere.qmqm.pl>
To: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, linux-bcachefs@vger.kernel.org
Subject: sched/core: WARN_ON(is_migration_disabled()) triggers
Message-ID: <aol71wZct39LD5WX@qmqm.qmqm.pl>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Dear scheduler maintainers,

A lockdep splat gets triggered by WARN_ON_ONCE(is_migration_disabled()) in =
set_task_cpu().
It seems a race triggerred e.g. by heavy load (in this case: kernel compile=
 or copying
large files into the filesystem). I don't think this is bcachefs-related, t=
hough, as I
also found the same WARN triggered from other code (see: the second report =
below). I have
only the two reports from 7.1.x, pasted below. In the most recent one, set_=
task_cpu() got
triggered from mutex_unlock() in bcachefs.bch2_alloc_sectors_done_inlined().

Background on the bcachefs workqueues: The bch2_alloc_sectors_done_inlined =
can run
on either bcachefs or bcachefs_copygc workqueue. Both workqueues are alloca=
ted with
WQ_HIGHPRI|WQ_FREEZABLE|WQ_MEM_RECLAIM|WQ_UNBOUND, differing in alloc_workq=
ueue(max_active)
arg: bcachefs: 512, bcachefs_copygc: 1.

In case this matters, the CPU is AMD Threadripper 7960X (24-core). Source f=
or the
7.1.8+ kernel is at commit b5522de4e4e1 from git://rere.qmqm.pl/linux stagi=
ng.

Best Regards
Micha=B3 Miros=B3aw

------------[ cut here ]------------
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
WARNING: possible circular locking dependency detected
7.1.8+ #72 Tainted: G           OE     =20
------------------------------------------------------
kworker/u201:6/64564 is trying to acquire lock:
ffffffff8da67d80 (console_owner){-.-.}-{0:0}, at: console_lock_spinning_ena=
ble+0x3c/0x60

but task is already holding lock:
ff11268eacf409a0 (&p->pi_lock){-.-.}-{2:2}, at: try_to_wake_up+0x50/0x710

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #2 (&p->pi_lock){-.-.}-{2:2}:
       _raw_spin_lock_irqsave+0x3f/0x90
       try_to_wake_up+0x50/0x710
       create_worker+0x14f/0x1d0
       workqueue_init+0x2c4/0x330
       kernel_init_freeable+0x12f/0x2c0
       kernel_init+0x16/0x130
       ret_from_fork+0x29a/0x3c0
       ret_from_fork_asm+0x11/0x20

-> #1 (&pool->lock){-.-.}-{2:2}:
       _raw_spin_lock+0x30/0x70
       __queue_work+0xd8/0x770
       queue_work_on+0x9b/0xd0
       soft_cursor+0x189/0x200
       bit_cursor+0x2d1/0x530
       hide_cursor+0x27/0xb0
       vt_console_print+0x449/0x460
       console_flush_one_record+0x2eb/0x4e0
       console_unlock+0x78/0x140
       vprintk_emit+0x352/0x420
       _printk+0x57/0x80
       bt_info+0x6d/0x90
       btmtk_usb_setup+0x6e4/0xac4 [btmtk]
       hci_dev_open_sync+0x107/0xc60
       hci_dev_do_open+0x25/0x70
       hci_power_on+0x4b/0x250
       process_one_work+0x202/0x5d0
       worker_thread+0x1dc/0x3e0
       kthread+0xf0/0x130
       ret_from_fork+0x29a/0x3c0
       ret_from_fork_asm+0x11/0x20

-> #0 (console_owner){-.-.}-{0:0}:
       __lock_acquire+0x1409/0x2690
       lock_acquire+0xba/0x2f0
       console_lock_spinning_enable+0x58/0x60
       console_flush_one_record+0x2ad/0x4e0
       console_unlock+0x78/0x140
       vprintk_emit+0x352/0x420
       _printk+0x57/0x80
       __report_bug.cold+0x37/0xe2
       report_bug+0x28/0x70
       handle_bug+0x223/0x270
       exc_invalid_op+0x13/0x60
       asm_exc_invalid_op+0x16/0x20
       set_task_cpu+0x27d/0x290
       try_to_wake_up+0x169/0x710
       wake_up_q+0x45/0x90
       __mutex_unlock_slowpath+0x1b2/0x3c0
       bch2_alloc_sectors_done_inlined+0x180/0x3a0 [bcachefs]
       bch2_btree_reserve_get+0x45b/0x8a0 [bcachefs]
       bch2_btree_update_start+0x83c/0xfc0 [bcachefs]
       bch2_btree_split_leaf+0x5d/0x1e0 [bcachefs]
       __bch2_trans_commit_error.isra.0+0x371/0xa90 [bcachefs]
       bch2_trans_commit_error.isra.0+0x16/0x90 [bcachefs]
       __bch2_trans_commit+0xab3/0x19c0 [bcachefs]
       bch2_extent_update+0x281/0x370 [bcachefs]
       bch2_write_index_default+0x269/0x550 [bcachefs]
       __bch2_write_index+0x25d/0x730 [bcachefs]
       bch2_write_point_do_index_updates+0xc4/0x1d0 [bcachefs]
       process_one_work+0x202/0x5d0
       worker_thread+0x1dc/0x3e0
       kthread+0xf0/0x130
       ret_from_fork+0x29a/0x3c0
       ret_from_fork_asm+0x11/0x20

other info that might help us debug this:

Chain exists of:
  console_owner --> &pool->lock --> &p->pi_lock

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(&p->pi_lock);
                               lock(&pool->lock);
                               lock(&p->pi_lock);
  lock(console_owner);

 *** DEADLOCK ***

8 locks held by kworker/u201:6/64564:
 #0: ff112682d7295550 ((wq_completion)bcachefs){+.+.}-{0:0}, at: process_on=
e_work+0x546/0x5d0
 #1: ff614dc54aedfe40 ((work_completion)(&wp->index_update_work)){+.+.}-{0:=
0}, at: process_one_work+0x1ce/0x5d0
 #2: ff112682cd810030 (&c->btree.trans.barrier){.+.+}-{0:0}, at: __bch2_tra=
ns_get+0x1c6/0x3d0 [bcachefs]
 #3: ff112682cd832bc0 (&c->gc.lock){.+.+}-{4:4}, at: bch2_btree_update_star=
t+0x378/0xfc0 [bcachefs]
 #4: ff112687486a01e8 (bcachefs_btree){+.+.}-{0:0}, at: __bch2_trans_relock=
+0x116/0x1d0 [bcachefs]
 #5: ff11268eacf409a0 (&p->pi_lock){-.-.}-{2:2}, at: try_to_wake_up+0x50/0x=
710
 #6: ffffffff8dc27fc0 (console_lock){+.+.}-{0:0}, at: _printk+0x57/0x80
 #7: ffffffff8dc28018 (console_srcu){....}-{0:0}, at: console_flush_one_rec=
ord+0x81/0x4e0

stack backtrace:
CPU: 2 UID: 0 PID: 64564 Comm: kworker/u201:6 Tainted: G           OE      =
 7.1.8+ #72 PREEMPTLAZY=20
Tainted: [O]=3DOOT_MODULE, [E]=3DUNSIGNED_MODULE
Hardware name: ASUS System Product Name/Pro WS TRX50-SAGE WIFI, BIOS 1317 0=
2/03/2026
Workqueue: bcachefs bch2_write_point_do_index_updates [bcachefs]
Call Trace:
 <TASK>
 dump_stack_lvl+0x69/0xa0
 print_circular_bug.cold+0x178/0x1be
 check_noncircular+0x12b/0x140
 ? save_trace+0x49/0x3a0
 ? srso_alias_return_thunk+0x5/0xfbef5
 __lock_acquire+0x1409/0x2690
 lock_acquire+0xba/0x2f0
 ? console_lock_spinning_enable+0x3c/0x60
 ? local_clock_noinstr+0x3a/0xd0
 ? srso_alias_return_thunk+0x5/0xfbef5
 ? srso_alias_return_thunk+0x5/0xfbef5
 console_lock_spinning_enable+0x58/0x60
 ? console_lock_spinning_enable+0x3c/0x60
 console_flush_one_record+0x2ad/0x4e0
 console_unlock+0x78/0x140
 vprintk_emit+0x352/0x420
 ? set_task_cpu+0x27d/0x290
 _printk+0x57/0x80
 ? srso_alias_return_thunk+0x5/0xfbef5
 ? set_task_cpu+0x27d/0x290
 __report_bug.cold+0x37/0xe2
 ? __bfs+0x13c/0x230
 ? set_task_cpu+0x27d/0x290
 report_bug+0x28/0x70
 handle_bug+0x223/0x270
 exc_invalid_op+0x13/0x60
 asm_exc_invalid_op+0x16/0x20
RIP: 0010:set_task_cpu+0x27d/0x290
Code: 00 84 c0 0f 85 15 fe ff ff 48 8d 3d dd 51 a7 01 67 48 0f b9 3a e9 04 =
fe ff ff 0f 0b 66 83 bb c0 03 00 00 00 0f 84 da fd ff ff <0f> 0b e9 d3 fd f=
f ff 66 66 2e 0f 1f 84 00 00 00 00 00 90 0f 1f 44
RSP: 0018:ff614dc54aedf3a0 EFLAGS: 00010002
RAX: 0000000000000001 RBX: ff11268eacf40000 RCX: 0000000000000001
RDX: 0000000000000046 RSI: ff11268eacf409a0 RDI: ff11268f640156d8
RBP: 0000000000000000 R08: 0000000000000001 R09: 0000000000000001
R10: 0000000000000000 R11: 0000000000000005 R12: 0000000000000000
R13: ff11268eacf40988 R14: ff11268eacf40000 R15: 0000000000000000
 try_to_wake_up+0x169/0x710
 ? mark_held_locks+0x40/0x70
 wake_up_q+0x45/0x90
 __mutex_unlock_slowpath+0x1b2/0x3c0
 bch2_alloc_sectors_done_inlined+0x180/0x3a0 [bcachefs]
 ? srso_alias_return_thunk+0x5/0xfbef5
 ? __mutex_unlock_slowpath+0x3f/0x3c0
 bch2_btree_reserve_get+0x45b/0x8a0 [bcachefs]
 ? bch2_btree_reserve_get+0x2c2/0x8a0 [bcachefs]
 ? srso_alias_return_thunk+0x5/0xfbef5
 ? __mutex_unlock_slowpath+0x3f/0x3c0
 bch2_btree_update_start+0x83c/0xfc0 [bcachefs]
 ? srso_alias_return_thunk+0x5/0xfbef5
 bch2_btree_split_leaf+0x5d/0x1e0 [bcachefs]
 __bch2_trans_commit_error.isra.0+0x371/0xa90 [bcachefs]
 ? srso_alias_return_thunk+0x5/0xfbef5
 ? run_one_trans_trigger+0x195/0x280 [bcachefs]
 bch2_trans_commit_error.isra.0+0x16/0x90 [bcachefs]
 __bch2_trans_commit+0xab3/0x19c0 [bcachefs]
 ? bch2_extent_update+0x281/0x370 [bcachefs]
 ? srso_alias_return_thunk+0x5/0xfbef5
 bch2_extent_update+0x281/0x370 [bcachefs]
 ? bch2_write_index_default+0x269/0x550 [bcachefs]
 bch2_write_index_default+0x269/0x550 [bcachefs]
 ? srso_alias_return_thunk+0x5/0xfbef5
 ? srso_alias_return_thunk+0x5/0xfbef5
 ? lockdep_hardirqs_on_prepare+0xd3/0x180
 ? srso_alias_return_thunk+0x5/0xfbef5
 ? srso_alias_return_thunk+0x5/0xfbef5
 ? __lock_acquire+0x487/0x2690
 ? __bch2_write_index+0x25d/0x730 [bcachefs]
 __bch2_write_index+0x25d/0x730 [bcachefs]
 ? bch2_write_point_do_index_updates+0x2a/0x1d0 [bcachefs]
 ? srso_alias_return_thunk+0x5/0xfbef5
 ? mark_held_locks+0x40/0x70
 ? srso_alias_return_thunk+0x5/0xfbef5
 bch2_write_point_do_index_updates+0xc4/0x1d0 [bcachefs]
 process_one_work+0x202/0x5d0
 ? find_held_lock+0x2b/0x80
 ? srso_alias_return_thunk+0x5/0xfbef5
 worker_thread+0x1dc/0x3e0
 ? rescuer_thread+0x5a0/0x5a0
 kthread+0xf0/0x130
 ? kthread_affine_node+0xf0/0xf0
 ret_from_fork+0x29a/0x3c0
 ? kthread_affine_node+0xf0/0xf0
 ret_from_fork_asm+0x11/0x20
 </TASK>
is_migration_disabled(p)
WARNING: kernel/sched/core.c:3339 at set_task_cpu+0x27d/0x290, CPU#2: kwork=
er/u201:6/64564
Modules linked in: ntfs3 uas usb_storage uinput rfcomm algif_hash algif_skc=
ipher af_alg bnep snd_seq_dummy snd_hrtimer snd_seq_midi snd_seq_midi_event=
 snd_rawmidi snd_seq snd_seq_device nf_conntrack_netlink xfrm_user xfrm_alg=
o qrtr overlay cpufreq_powersave cpufreq_userspace cpufreq_conservative xfs=
 dm_raid btrfs libblake2b ccm bridge binfmt_misc bcachefs(OE) lz4hc_compres=
s lz4_compress hid_logitech_hidpp r8153_ecm cdc_ether usbnet btusb nls_utf8=
 btmtk nls_cp852 pl2303 btrtl r8152 squashfs btbcm vfat lz4_decompress mii =
cdc_acm hid_logitech_dj hid_dr usbserial btintel fat amdgpu cxl_pci snd_hda=
_codec_alc882 cxl_mem snd_hda_codec_realtek_lib snd_hda_codec_atihdmi snd_h=
da_codec_generic snd_hda_codec_hdmi cxl_acpi cxl_port cxl_pmem mt7925e i2c_=
algo_bit mt7925_common libnvdimm drm_buddy snd_hda_intel kvm_amd mt792x_lib=
 drm_ttm_helper dax_hmem asus_ec_sensors ttm mt76_connac_lib snd_intel_dspc=
fg kvm snd_hda_codec cxl_core mt76 video wmi_bmof einj irqbypass pcspkr snd=
_hda_core drm_exec drm_suballoc_helper
 snd_hwdep drm_panel_backlight_quirks mac80211 snd_pcm_oss snd_mixer_oss gp=
u_sched amdxcp libarc4 snd_pcm drm_display_helper snd_timer cec 8250 rc_cor=
e snd 8250_base backlight soundcore serial_mctrl_gpio ccp serial_base sg cf=
g80211 nft_masq nft_redir nfsd auth_rpcgss nfs_acl lockd grace nfs_localio =
sch_fq_codel nft_chain_nat nf_nat sunrpc nf_conntrack nf_defrag_ipv6 nf_def=
rag_ipv4 nf_tables i2c_dev loop fuse tpm rng_core autofs4 raid10 raid456 as=
ync_raid6_recov async_memcpy async_pq async_xor xor async_tx raid6_pq raid0=
 linear input_leds joydev xhci_pci xhci_hcd
CPU: 2 UID: 0 PID: 64564 Comm: kworker/u201:6 Tainted: G           OE      =
 7.1.8+ #72 PREEMPTLAZY=20
Tainted: [O]=3DOOT_MODULE, [E]=3DUNSIGNED_MODULE
Hardware name: ASUS System Product Name/Pro WS TRX50-SAGE WIFI, BIOS 1317 0=
2/03/2026
Workqueue: bcachefs bch2_write_point_do_index_updates [bcachefs]
RIP: 0010:set_task_cpu+0x27d/0x290
Code: 00 84 c0 0f 85 15 fe ff ff 48 8d 3d dd 51 a7 01 67 48 0f b9 3a e9 04 =
fe ff ff 0f 0b 66 83 bb c0 03 00 00 00 0f 84 da fd ff ff <0f> 0b e9 d3 fd f=
f ff 66 66 2e 0f 1f 84 00 00 00 00 00 90 0f 1f 44
RSP: 0018:ff614dc54aedf3a0 EFLAGS: 00010002
RAX: 0000000000000001 RBX: ff11268eacf40000 RCX: 0000000000000001
RDX: 0000000000000046 RSI: ff11268eacf409a0 RDI: ff11268f640156d8
RBP: 0000000000000000 R08: 0000000000000001 R09: 0000000000000001
R10: 0000000000000000 R11: 0000000000000005 R12: 0000000000000000
R13: ff11268eacf40988 R14: ff11268eacf40000 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ff11268660912000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00002d8b08291fc0 CR3: 0000000c92079001 CR4: 0000000000771ef0
PKRU: 55555554
Call Trace:
 <TASK>
 try_to_wake_up+0x169/0x710
 ? mark_held_locks+0x40/0x70
 wake_up_q+0x45/0x90
 __mutex_unlock_slowpath+0x1b2/0x3c0
 bch2_alloc_sectors_done_inlined+0x180/0x3a0 [bcachefs]
 ? srso_alias_return_thunk+0x5/0xfbef5
 ? __mutex_unlock_slowpath+0x3f/0x3c0
 bch2_btree_reserve_get+0x45b/0x8a0 [bcachefs]
 ? bch2_btree_reserve_get+0x2c2/0x8a0 [bcachefs]
 ? srso_alias_return_thunk+0x5/0xfbef5
 ? __mutex_unlock_slowpath+0x3f/0x3c0
 bch2_btree_update_start+0x83c/0xfc0 [bcachefs]
 ? srso_alias_return_thunk+0x5/0xfbef5
 bch2_btree_split_leaf+0x5d/0x1e0 [bcachefs]
 __bch2_trans_commit_error.isra.0+0x371/0xa90 [bcachefs]
 ? srso_alias_return_thunk+0x5/0xfbef5
 ? run_one_trans_trigger+0x195/0x280 [bcachefs]
 bch2_trans_commit_error.isra.0+0x16/0x90 [bcachefs]
 __bch2_trans_commit+0xab3/0x19c0 [bcachefs]
 ? bch2_extent_update+0x281/0x370 [bcachefs]
 ? srso_alias_return_thunk+0x5/0xfbef5
 bch2_extent_update+0x281/0x370 [bcachefs]
 ? bch2_write_index_default+0x269/0x550 [bcachefs]
 bch2_write_index_default+0x269/0x550 [bcachefs]
 ? srso_alias_return_thunk+0x5/0xfbef5
 ? srso_alias_return_thunk+0x5/0xfbef5
 ? lockdep_hardirqs_on_prepare+0xd3/0x180
 ? srso_alias_return_thunk+0x5/0xfbef5
 ? srso_alias_return_thunk+0x5/0xfbef5
 ? __lock_acquire+0x487/0x2690
 ? __bch2_write_index+0x25d/0x730 [bcachefs]
 __bch2_write_index+0x25d/0x730 [bcachefs]
 ? bch2_write_point_do_index_updates+0x2a/0x1d0 [bcachefs]
 ? srso_alias_return_thunk+0x5/0xfbef5
 ? mark_held_locks+0x40/0x70
 ? srso_alias_return_thunk+0x5/0xfbef5
 bch2_write_point_do_index_updates+0xc4/0x1d0 [bcachefs]
 process_one_work+0x202/0x5d0
 ? find_held_lock+0x2b/0x80
 ? srso_alias_return_thunk+0x5/0xfbef5
 worker_thread+0x1dc/0x3e0
 ? rescuer_thread+0x5a0/0x5a0
 kthread+0xf0/0x130
 ? kthread_affine_node+0xf0/0xf0
 ret_from_fork+0x29a/0x3c0
 ? kthread_affine_node+0xf0/0xf0
 ret_from_fork_asm+0x11/0x20
 </TASK>
irq event stamp: 124856
hardirqs last  enabled at (124855): [<ffffffff8d17d047>] _raw_spin_unlock_i=
rqrestore+0x47/0x70
hardirqs last disabled at (124856): [<ffffffff8d17cdba>] _raw_spin_lock_irq=
save+0x6a/0x90
softirqs last  enabled at (124838): [<ffffffff8c2e5544>] __irq_exit_rcu+0xc=
4/0x100
softirqs last disabled at (124831): [<ffffffff8c2e5544>] __irq_exit_rcu+0xc=
4/0x100
---[ end trace 0000000000000000 ]---


------------[ cut here ]------------
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
WARNING: possible circular locking dependency detected
7.1.5+ #70 Tainted: G           OE     =20
------------------------------------------------------
kworker/1:0H/26 is trying to acquire lock:
ffffffff91a67d80 (console_owner){-.-.}-{0:0}, at: console_lock_spinning_ena=
ble+0x3c/0x60

but task is already holding lock:
ff265b2feedf1c60 (&rq->__lock){-.-.}-{2:2}, at: raw_spin_rq_lock_nested+0x2=
2/0xa0

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #3 (&rq->__lock){-.-.}-{2:2}:
       _raw_spin_lock_nested+0x2e/0x70
       raw_spin_rq_lock_nested+0x22/0xa0
       _task_rq_lock+0x45/0x110
       cgroup_move_task+0x2c/0x110
       css_set_move_task+0xd4/0x220
       cgroup_post_fork+0x94/0x280
       copy_process+0x2018/0x2430
       kernel_clone+0xb2/0x440
       user_mode_thread+0x5d/0x80
       rest_init+0x1e/0x160
       start_kernel+0x7a1/0x7b0
       clear_bss+0x0/0x40
       reserve_bios_regions+0x0/0x60
       common_startup_64+0x13e/0x141

-> #2 (&p->pi_lock){-.-.}-{2:2}:
       _raw_spin_lock_irqsave+0x3f/0x90
       try_to_wake_up+0x50/0x710
       create_worker+0x14f/0x1d0
       workqueue_init+0x2c4/0x330
       kernel_init_freeable+0x12f/0x2c0
       kernel_init+0x16/0x130
       ret_from_fork+0x29a/0x3c0
       ret_from_fork_asm+0x11/0x20

-> #1 (&pool->lock){-.-.}-{2:2}:
       _raw_spin_lock+0x30/0x70
       __queue_work+0x2ce/0x770
       queue_work_on+0x9b/0xd0
       soft_cursor+0x189/0x200
       bit_cursor+0x2d1/0x530
       hide_cursor+0x27/0xb0
       vt_console_print+0x449/0x460
       console_flush_one_record+0x2eb/0x4e0
       console_unlock+0x78/0x140
       vprintk_emit+0x352/0x420
       _printk+0x57/0x80
       bt_info+0x6d/0x90
       btmtk_usb_setup+0x639/0x840 [btmtk]
       hci_dev_open_sync+0x107/0xc60
       hci_dev_do_open+0x25/0x70
       hci_power_on+0x4b/0x250
       process_one_work+0x202/0x5d0
       worker_thread+0x1dc/0x3e0
       kthread+0xf0/0x130
       ret_from_fork+0x29a/0x3c0
       ret_from_fork_asm+0x11/0x20

-> #0 (console_owner){-.-.}-{0:0}:
       __lock_acquire+0x1409/0x2690
       lock_acquire+0xba/0x2f0
       console_lock_spinning_enable+0x58/0x60
       console_flush_one_record+0x2ad/0x4e0
       console_unlock+0x78/0x140
       vprintk_emit+0x352/0x420
       _printk+0x57/0x80
       __report_bug.cold+0x37/0xe2
       report_bug+0x28/0x70
       handle_bug+0x223/0x270
       exc_invalid_op+0x13/0x60
       asm_exc_invalid_op+0x16/0x20
       set_task_cpu+0x27d/0x290
       __schedule+0x29fe/0x2d50
       schedule+0x36/0xf0
       worker_thread+0xbe/0x3e0
       kthread+0xf0/0x130
       ret_from_fork+0x29a/0x3c0
       ret_from_fork_asm+0x11/0x20

other info that might help us debug this:

Chain exists of:
  console_owner --> &p->pi_lock --> &rq->__lock

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(&rq->__lock);
                               lock(&p->pi_lock);
                               lock(&rq->__lock);
  lock(console_owner);

 *** DEADLOCK ***

4 locks held by kworker/1:0H/26:
 #0: ff265b38134a09a0 (&p->pi_lock){-.-.}-{2:2}, at: _task_rq_lock+0x29/0x1=
10
 #1: ff265b2feedf1c60 (&rq->__lock){-.-.}-{2:2}, at: raw_spin_rq_lock_neste=
d+0x22/0xa0
 #2: ffffffff91c27fc0 (console_lock){+.+.}-{0:0}, at: _printk+0x57/0x80
 #3: ffffffff91c28018 (console_srcu){....}-{0:0}, at: console_flush_one_rec=
ord+0x81/0x4e0

stack backtrace:
CPU: 1 UID: 0 PID: 26 Comm: kworker/1:0H Tainted: G           OE       7.1.=
5+ #70 PREEMPTLAZY=20
Tainted: [O]=3DOOT_MODULE, [E]=3DUNSIGNED_MODULE
Hardware name: ASUS System Product Name/Pro WS TRX50-SAGE WIFI, BIOS 1317 0=
2/03/2026
Workqueue:  0x0 (kblockd)
Call Trace:
 <TASK>
 dump_stack_lvl+0x69/0xa0
 print_circular_bug.cold+0x178/0x1be
 check_noncircular+0x12b/0x140
 ? save_trace+0x49/0x3a0
 ? srso_alias_return_thunk+0x5/0xfbef5
 __lock_acquire+0x1409/0x2690
 lock_acquire+0xba/0x2f0
 ? console_lock_spinning_enable+0x3c/0x60
 ? local_clock_noinstr+0x9/0xd0
 ? srso_alias_return_thunk+0x5/0xfbef5
 ? srso_alias_return_thunk+0x5/0xfbef5
 console_lock_spinning_enable+0x58/0x60
 ? console_lock_spinning_enable+0x3c/0x60
 console_flush_one_record+0x2ad/0x4e0
 console_unlock+0x78/0x140
 vprintk_emit+0x352/0x420
 ? set_task_cpu+0x27d/0x290
 _printk+0x57/0x80
 ? set_task_cpu+0x27d/0x290
 __report_bug.cold+0x37/0xe2
 ? srso_alias_return_thunk+0x5/0xfbef5
 ? __lock_acquire+0x487/0x2690
 ? srso_alias_return_thunk+0x5/0xfbef5
 ? __update_load_avg_cfs_rq+0x2f0/0x390
 ? set_task_cpu+0x27d/0x290
 report_bug+0x28/0x70
 handle_bug+0x223/0x270
 exc_invalid_op+0x13/0x60
 asm_exc_invalid_op+0x16/0x20
RIP: 0010:set_task_cpu+0x27d/0x290
Code: 00 84 c0 0f 85 15 fe ff ff 48 8d 3d dd 50 a7 01 67 48 0f b9 3a e9 04 =
fe ff ff 0f 0b 66 83 bb c0 03 00 00 00 0f 84 da fd ff ff <0f> 0b e9 d3 fd f=
f ff 66 66 2e 0f 1f 84 00 00 00 00 00 90 0f 1f 44
RSP: 0018:ff79e53c4478fd88 EFLAGS: 00010002
RAX: 0000000000000001 RBX: ff265b38134a0000 RCX: 0000000000000001
RDX: 0000000000000046 RSI: ff265b38134a09a0 RDI: ff265b2c80a63040
RBP: 0000000000000001 R08: 0000000000000000 R09: 0000000000100000
R10: 000000000686f0c4 R11: 0000000000000000 R12: 0000000000000001
R13: ffffffff926dfc00 R14: ff265b2feedf1c00 R15: ff265b2feedf1c00
 ? set_task_cpu+0x1ff/0x290
 __schedule+0x29fe/0x2d50
 schedule+0x36/0xf0
 worker_thread+0xbe/0x3e0
 ? rescuer_thread+0x5a0/0x5a0
 kthread+0xf0/0x130
 ? kthread_affine_node+0xf0/0xf0
 ret_from_fork+0x29a/0x3c0
 ? kthread_affine_node+0xf0/0xf0
 ret_from_fork_asm+0x11/0x20
 </TASK>
is_migration_disabled(p)
WARNING: kernel/sched/core.c:3339 at set_task_cpu+0x27d/0x290, CPU#1: kwork=
er/1:0H/26
Modules linked in: rfcomm algif_hash algif_skcipher af_alg bnep snd_seq_dum=
my snd_hrtimer snd_seq_midi snd_seq_midi_event snd_rawmidi snd_seq snd_seq_=
device bridge nf_conntrack_netlink xfrm_user xfrm_algo qrtr overlay cpufreq=
_powersave cpufreq_userspace cpufreq_conservative xfs dm_raid btrfs libblak=
e2b binfmt_misc bcachefs(OE) lz4hc_compress lz4_compress hid_logitech_hidpp=
 r8153_ecm cdc_ether usbnet nls_utf8 nls_cp852 btusb btmtk btrtl r8152 pl23=
03 btbcm vfat squashfs lz4_decompress mii fat hid_logitech_dj cdc_acm hid_d=
r btintel usbserial amdgpu snd_hda_codec_alc882 snd_hda_codec_realtek_lib s=
nd_hda_codec_atihdmi snd_hda_codec_generic snd_hda_codec_hdmi cxl_pci cxl_m=
em cxl_acpi snd_hda_intel i2c_algo_bit cxl_port drm_buddy snd_intel_dspcfg =
drm_ttm_helper cxl_pmem snd_hda_codec ttm kvm_amd libnvdimm snd_hda_core vi=
deo mt7925e asus_ec_sensors mt7925_common snd_hwdep drm_exec dax_hmem drm_s=
uballoc_helper snd_pcm_oss mt792x_lib kvm wmi_bmof drm_panel_backlight_quir=
ks mt76_connac_lib snd_mixer_oss cxl_core mt76
 gpu_sched irqbypass pcspkr einj amdxcp snd_pcm mac80211 drm_display_helper=
 libarc4 snd_timer cec 8250 snd rc_core 8250_base soundcore backlight ccp s=
erial_mctrl_gpio serial_base sg nfsd auth_rpcgss nfs_acl lockd grace nfs_lo=
calio sunrpc cfg80211 nft_masq nft_redir sch_fq_codel nft_chain_nat nf_nat =
nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 nf_tables i2c_dev loop fuse tpm =
rng_core autofs4 input_leds joydev raid10 raid456 async_raid6_recov async_m=
emcpy async_pq async_xor xor async_tx raid6_pq raid0 linear xhci_pci xhci_h=
cd
CPU: 1 UID: 0 PID: 26 Comm: kworker/1:0H Tainted: G           OE       7.1.=
5+ #70 PREEMPTLAZY=20
Tainted: [O]=3DOOT_MODULE, [E]=3DUNSIGNED_MODULE
Hardware name: ASUS System Product Name/Pro WS TRX50-SAGE WIFI, BIOS 1317 0=
2/03/2026
Workqueue:  0x0 (kblockd)
RIP: 0010:set_task_cpu+0x27d/0x290
Code: 00 84 c0 0f 85 15 fe ff ff 48 8d 3d dd 50 a7 01 67 48 0f b9 3a e9 04 =
fe ff ff 0f 0b 66 83 bb c0 03 00 00 00 0f 84 da fd ff ff <0f> 0b e9 d3 fd f=
f ff 66 66 2e 0f 1f 84 00 00 00 00 00 90 0f 1f 44
RSP: 0018:ff79e53c4478fd88 EFLAGS: 00010002
RAX: 0000000000000001 RBX: ff265b38134a0000 RCX: 0000000000000001
RDX: 0000000000000046 RSI: ff265b38134a09a0 RDI: ff265b2c80a63040
RBP: 0000000000000001 R08: 0000000000000000 R09: 0000000000100000
R10: 000000000686f0c4 R11: 0000000000000000 R12: 0000000000000001
R13: ffffffff926dfc00 R14: ff265b2feedf1c00 R15: ff265b2feedf1c00
FS:  0000000000000000(0000) GS:ff265b305c712000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000322c000b0000 CR3: 0000000514501006 CR4: 0000000000771ef0
PKRU: 55555554
Call Trace:
 <TASK>
 __schedule+0x29fe/0x2d50
 schedule+0x36/0xf0
 worker_thread+0xbe/0x3e0
 ? rescuer_thread+0x5a0/0x5a0
 kthread+0xf0/0x130
 ? kthread_affine_node+0xf0/0xf0
 ret_from_fork+0x29a/0x3c0
 ? kthread_affine_node+0xf0/0xf0
 ret_from_fork_asm+0x11/0x20
 </TASK>
irq event stamp: 3226690
hardirqs last  enabled at (3226689): [<ffffffff91179f64>] _raw_spin_unlock_=
irq+0x24/0x40
hardirqs last disabled at (3226690): [<ffffffff9116cf51>] __schedule+0x13d1=
/0x2d50
softirqs last  enabled at (3226332): [<ffffffff902e5544>] __irq_exit_rcu+0x=
c4/0x100
softirqs last disabled at (3226323): [<ffffffff902e5544>] __irq_exit_rcu+0x=
c4/0x100
---[ end trace 0000000000000000 ]---


Return-Path: <linux-bcachefs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 757C7C433F5
	for <linux-bcachefs@archiver.kernel.org>; Wed,  9 Mar 2022 21:22:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235881AbiCIVXH (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Wed, 9 Mar 2022 16:23:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238471AbiCIVXE (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Wed, 9 Mar 2022 16:23:04 -0500
X-Greylist: delayed 420 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 09 Mar 2022 13:22:03 PST
Received: from mx.ewheeler.net (mx.ewheeler.net [173.205.220.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9483C9A4E3
        for <linux-bcachefs@vger.kernel.org>; Wed,  9 Mar 2022 13:22:03 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        by mx.ewheeler.net (Postfix) with ESMTP id 6173341;
        Wed,  9 Mar 2022 13:15:03 -0800 (PST)
X-Virus-Scanned: amavisd-new at ewheeler.net
Received: from mx.ewheeler.net ([127.0.0.1])
        by localhost (mx.ewheeler.net [127.0.0.1]) (amavisd-new, port 10024)
        with LMTP id 4ieKtRp_HeqD; Wed,  9 Mar 2022 13:15:01 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx.ewheeler.net (Postfix) with ESMTPSA id CD3F840;
        Wed,  9 Mar 2022 13:15:00 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx.ewheeler.net CD3F840
Date:   Wed, 9 Mar 2022 13:14:58 -0800 (PST)
From:   Eric Wheeler <bcachefs@lists.ewheeler.net>
To:     Kent Overstreet <kent.overstreet@gmail.com>
cc:     linux-bcachefs@vger.kernel.org
Subject: bcachefs: Kernel panic - not syncing: trans path oveflow
Message-ID: <6bc8aca6-2f93-4a81-376-13155fcc5d7@ewheeler.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

Hi Kent,

We just started testing bcachefs snapshots this week: we have a bunch of 
mysql replicas, each in its own subvolume.  Every 4 hours we stop mysql, 
run a subvolume snapshot and restart mysql, so it gets lots of snapshot 
and sync IO from the many database instances.

We hit the following bcachefs panic while testing commit# 
5490c9c529770aa18b2571bd98f5416ed9ae24c6 from March 3rd. Can you tell what 
the issue might be?

It is easily reproducable, the same problem hits shortly after we reboot 
and remount so happy to test patches or git-pull's to rebuild with:

Here is the stack trace (more logs below):

	Kernel panic - not syncing: trans path oveflow
	CPU: 1 PID: 19038 Comm: mysqld Not tainted 5.15.0+ #1
	Hardware name: Red Hat KVM, BIOS 0.5.1 01/01/2011
	Call Trace:
	 dump_stack_lvl+0x45/0x57
	 panic+0xf3/0x2cb
	 ? bch2_dump_trans_paths_updates+0x204/0x229 [bcachefs]
	 btree_path_alloc.cold.73+0x11/0x11 [bcachefs]
	 btree_path_clone+0x21/0x530 [bcachefs]
	 bch2_btree_path_set_pos+0x200/0xb40 [bcachefs]
	 bch2_btree_iter_peek+0x99d/0xa30 [bcachefs]
	 bch2_trans_update_extent+0x12c/0xdc0 [bcachefs]
	 bch2_extent_update+0x198/0x2b0 [bcachefs]
	 bch2_write_index_default+0x25b/0x490 [bcachefs]
	 ? kmem_cache_alloc+0x35/0x3a0
	 ? finish_wait+0x80/0x80
	 ? mempool_alloc+0x67/0x180
	 ? __mod_memcg_lruvec_state+0x21/0x40
	 ? __mod_lruvec_page_state+0x60/0xa0
	 ? bio_add_page+0x62/0x90
	 __bch2_write_index+0x36b/0x410 [bcachefs]
	 bch2_write_index+0x13/0xc0 [bcachefs]
	 bch2_writepage_do_io.isra.65+0x5a/0x80 [bcachefs]
	 bch2_writepages+0xac/0xe0 [bcachefs]
	 do_writepages+0xc2/0x1c0
	 filemap_fdatawrite_wbc+0x7e/0xc0
	 file_write_and_wait_range+0x9c/0xe0
	 bch2_fsync+0x24/0x70 [bcachefs]
	 do_fsync+0x38/0x70
	 __x64_sys_fsync+0x10/0x20
	 do_syscall_64+0x3a/0x80
	 entry_SYSCALL_64_after_hwframe+0x44/0xae
	RIP: 0033:0x7fb784282d7d

Full log output from netconsole is below.  The first section is the 
original boot and the second section is a reboot showing the crash a few 
minutes after remounting bcachefs:


===================================== Original Boot =====================================

[22733.696095] INFO: task mysqld:19038 blocked for more than 122 seconds.
[22733.696769]       Not tainted 5.15.0+ #1
[22733.697310] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[22733.697793] task:mysqld          state:D stack:    0 pid:19038 ppid: 18566 flags:0x00004000
[22733.698257] Call Trace:
[22733.698728]  __schedule+0x294/0x860
[22733.699211]  schedule+0x3a/0xa0
[22733.699675]  io_schedule+0x12/0x40
[22733.700132]  wait_on_page_bit+0xfc/0x220
[22733.700609]  ? __page_cache_alloc+0x80/0x80
[22733.701090]  wait_on_page_writeback+0x22/0x70
[22733.701576]  __filemap_fdatawait_range+0x89/0xf0
[22733.702035]  file_write_and_wait_range+0xbb/0xe0
[22733.702469]  bch2_fsync+0x24/0x70 [bcachefs]
[22733.703068]  do_fsync+0x38/0x70
[22733.703489]  __x64_sys_fsync+0x10/0x20
[22733.703884]  do_syscall_64+0x3a/0x80
[22733.704298]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[22733.704700] RIP: 0033:0x7fb784282d7d
[22733.705057] RSP: 002b:00007fb7801d3d90 EFLAGS: 00000293 ORIG_RAX: 000000000000004a
[22733.705421] RAX: ffffffffffffffda RBX: 0000000000000044 RCX: 00007fb784282d7d
[22733.705789] RDX: 00007fb7801d6a20 RSI: 000000000000000a RDI: 0000000000000044
[22733.706129] RBP: 00007fb7801d3dc0 R08: 0000000000000000 R09: 00001b352a000802
[22733.706487] R10: 0c00000000000000 R11: 0000000000000293 R12: 0000000000010010
[22733.706828] R13: 0000000000000044 R14: 0000000000010010 R15: 0000000000000000
[22979.454081] INFO: task mysqld:19039 blocked for more than 122 seconds.
[22979.454889]       Not tainted 5.15.0+ #1
[22979.455346] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[22979.455764] task:mysqld          state:D stack:    0 pid:19039 ppid: 18566 flags:0x00004000
[22979.456179] Call Trace:
[22979.456597]  __schedule+0x294/0x860
[22979.457110]  ? set_next_entity+0x83/0xa0
[22979.457497]  schedule+0x3a/0xa0
[22979.457902]  schedule_timeout+0x215/0x2b0
[22979.458293]  ? __schedule+0x29c/0x860
[22979.458693]  wait_for_completion+0x9d/0x100
[22979.459138]  bch2_dio_write_loop+0x717/0x8d0 [bcachefs]
[22979.459575]  bch2_direct_write+0x220/0x2b0 [bcachefs]
[22979.459965]  new_sync_write+0x122/0x1b0
[22979.460375]  vfs_write+0x184/0x260
[22979.460773]  ksys_pwrite64+0x61/0xa0
[22979.461148]  ? syscall_trace_enter.isra.21+0x139/0x1b0
[22979.461484]  do_syscall_64+0x3a/0x80
[22979.461841]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[22979.462176] RIP: 0033:0x7fb784283023
[22979.462478] RSP: 002b:00007fb7801874b0 EFLAGS: 00000293 ORIG_RAX: 0000000000000012
[22979.462828] RAX: ffffffffffffffda RBX: 0000000000004000 RCX: 00007fb784283023
[22979.463144] RDX: 0000000000004000 RSI: 00007fb773874000 RDI: 0000000000000018
[22979.463443] RBP: 00007fb7801876a0 R08: 00000000003f4000 R09: 00007fb7801876c0
[22979.463762] R10: 00000000003f4000 R11: 0000000000000293 R12: 0000000000000000
[22979.464159] R13: 00007fb773874000 R14: 0000000000004000 R15: 00000000003f4000
[23102.332539] INFO: task mysqld:5115 blocked for more than 122 seconds.
[23102.332864]       Not tainted 5.15.0+ #1
[23102.333209] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[23102.333581] task:mysqld          state:D stack:    0 pid: 5115 ppid:  4498 flags:0x00004000
[23102.333903] Call Trace:
[23102.334215]  __schedule+0x294/0x860
[23102.334546]  schedule+0x3a/0xa0
[23102.334852]  io_schedule+0x12/0x40
[23102.335168]  wait_on_page_bit+0xfc/0x220
[23102.335504]  ? __page_cache_alloc+0x80/0x80
[23102.335811]  wait_on_page_writeback+0x22/0x70
[23102.336144]  __filemap_fdatawait_range+0x89/0xf0
[23102.336450]  file_write_and_wait_range+0xbb/0xe0
[23102.336779]  bch2_fsync+0x24/0x70 [bcachefs]
[23102.337146]  do_fsync+0x38/0x70
[23102.337496]  __x64_sys_fsync+0x10/0x20
[23102.337795]  do_syscall_64+0x3a/0x80
[23102.338100]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[23102.338395] RIP: 0033:0x7fd78e6a7d7d
[23102.338710] RSP: 002b:00007fd76b7fd620 EFLAGS: 00000293 ORIG_RAX: 000000000000004a
[23102.339032] RAX: ffffffffffffffda RBX: 00007fd76b7fd640 RCX: 00007fd78e6a7d7d
[23102.339345] RDX: 0005e92e00000000 RSI: 0000000000000000 RDI: 000000000000000d
[23102.339686] RBP: 00007fd76b7fd7e0 R08: 00007fd7742e4130 R09: 00000000ffffffee
[23102.340000] R10: 0000000000000001 R11: 0000000000000293 R12: 0000000000000000
[23102.340305] R13: 000000000000000d R14: 00007fd76b7fd6a0 R15: 00007fd7744bb268
[23102.340669] INFO: task mysqld:19038 blocked for more than 122 seconds.
[23102.340993]       Not tainted 5.15.0+ #1
[23102.341299] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[23102.341636] task:mysqld          state:D stack:    0 pid:19038 ppid: 18566 flags:0x00004000
[23102.341967] Call Trace:
[23102.342287]  __schedule+0x294/0x860
[23102.342634]  schedule+0x3a/0xa0
[23102.342956]  io_schedule+0x12/0x40
[23102.343270]  wait_on_page_bit+0xfc/0x220
[23102.343607]  ? __page_cache_alloc+0x80/0x80
[23102.343972]  wait_on_page_writeback+0x22/0x70
[23102.344285]  __filemap_fdatawait_range+0x89/0xf0
[23102.344628]  file_write_and_wait_range+0xbb/0xe0
[23102.344951]  bch2_fsync+0x24/0x70 [bcachefs]
[23102.345300]  do_fsync+0x38/0x70
[23102.345633]  __x64_sys_fsync+0x10/0x20
[23102.345968]  do_syscall_64+0x3a/0x80
[23102.346282]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[23102.346615] RIP: 0033:0x7fb784282d7d
[23102.346920] RSP: 002b:00007fb7801d3d90 EFLAGS: 00000293 ORIG_RAX: 000000000000004a
[23102.347228] RAX: ffffffffffffffda RBX: 0000000000000044 RCX: 00007fb784282d7d
[23102.347563] RDX: 00007fb7801d6a20 RSI: 000000000000000a RDI: 0000000000000044
[23102.347870] RBP: 00007fb7801d3dc0 R08: 0000000000000000 R09: 0000000000000000
[23102.348187] R10: cd0000000000000c R11: 0000000000000293 R12: 0000000000010010
[23102.348535] R13: 0000000000000044 R14: 0000000000010010 R15: 0000000000000000
[23102.348836] INFO: task mysqld:19039 blocked for more than 245 seconds.
[23102.349163]       Not tainted 5.15.0+ #1
[23102.349459] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[23102.349788] task:mysqld          state:D stack:    0 pid:19039 ppid: 18566 flags:0x00004000
[23102.350113] Call Trace:
[23102.350428]  __schedule+0x294/0x860
[23102.350773]  ? set_next_entity+0x83/0xa0
[23102.351094]  schedule+0x3a/0xa0
[23102.351405]  schedule_timeout+0x215/0x2b0
[23102.351789]  ? __schedule+0x29c/0x860
[23102.352139]  wait_for_completion+0x9d/0x100
[23102.352440]  bch2_dio_write_loop+0x717/0x8d0 [bcachefs]
[23102.352824]  bch2_direct_write+0x220/0x2b0 [bcachefs]
[23102.353170]  new_sync_write+0x122/0x1b0
[23102.353492]  vfs_write+0x184/0x260
[23102.353790]  ksys_pwrite64+0x61/0xa0
[23102.354096]  ? syscall_trace_enter.isra.21+0x139/0x1b0
[23102.354392]  do_syscall_64+0x3a/0x80
[23102.354701]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[23102.355016] RIP: 0033:0x7fb784283023
[23102.355305] RSP: 002b:00007fb7801874b0 EFLAGS: 00000293 ORIG_RAX: 0000000000000012
[23102.355618] RAX: ffffffffffffffda RBX: 0000000000004000 RCX: 00007fb784283023
[23102.355922] RDX: 0000000000004000 RSI: 00007fb773874000 RDI: 0000000000000018
[23102.356216] RBP: 00007fb7801876a0 R08: 00000000003f4000 R09: 00007fb7801876c0
[23102.356529] R10: 00000000003f4000 R11: 0000000000000293 R12: 0000000000000000
[23102.356829] R13: 00007fb773874000 R14: 0000000000004000 R15: 00000000003f4000
[23225.211834] INFO: task mysqld:5115 blocked for more than 245 seconds.
[23225.212194]       Not tainted 5.15.0+ #1
[23225.212546] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[23225.212931] task:mysqld          state:D stack:    0 pid: 5115 ppid:  4498 flags:0x00004000
[23225.213292] Call Trace:
[23225.213670]  __schedule+0x294/0x860
[23225.214003]  schedule+0x3a/0xa0
[23225.214323]  io_schedule+0x12/0x40
[23225.214680]  wait_on_page_bit+0xfc/0x220
[23225.215018]  ? __page_cache_alloc+0x80/0x80
[23225.215314]  wait_on_page_writeback+0x22/0x70
[23225.215650]  __filemap_fdatawait_range+0x89/0xf0
[23225.215970]  file_write_and_wait_range+0xbb/0xe0
[23225.216328]  bch2_fsync+0x24/0x70 [bcachefs]
[23225.216718]  do_fsync+0x38/0x70
[23225.217037]  __x64_sys_fsync+0x10/0x20
[23225.217327]  do_syscall_64+0x3a/0x80
[23225.217656]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[23225.217958] RIP: 0033:0x7fd78e6a7d7d
[23225.218246] RSP: 002b:00007fd76b7fd620 EFLAGS: 00000293 ORIG_RAX: 000000000000004a
[23225.218579] RAX: ffffffffffffffda RBX: 00007fd76b7fd640 RCX: 00007fd78e6a7d7d
[23225.218891] RDX: 0005e92e00000000 RSI: 0000000000000000 RDI: 000000000000000d
[23225.219190] RBP: 00007fd76b7fd7e0 R08: 00007fd7742e4130 R09: 00000000ffffffee
[23225.219520] R10: 0000000000000001 R11: 0000000000000293 R12: 0000000000000000
[23225.219830] R13: 000000000000000d R14: 00007fd76b7fd6a0 R15: 00007fd7744bb268
[23225.220140] INFO: task mysqld:19038 blocked for more than 245 seconds.
[23225.220462]       Not tainted 5.15.0+ #1
[23225.220744] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[23225.221047] task:mysqld          state:D stack:    0 pid:19038 ppid: 18566 flags:0x00004000
[23225.221351] Call Trace:
[23225.221690]  __schedule+0x294/0x860
[23225.222018]  schedule+0x3a/0xa0
[23225.222319]  io_schedule+0x12/0x40
[23225.222659]  wait_on_page_bit+0xfc/0x220
[23225.222968]  ? __page_cache_alloc+0x80/0x80
[23225.223269]  wait_on_page_writeback+0x22/0x70
[23225.223610]  __filemap_fdatawait_range+0x89/0xf0
[23225.223920]  file_write_and_wait_range+0xbb/0xe0
[23225.224219]  bch2_fsync+0x24/0x70 [bcachefs]
[23225.224600]  do_fsync+0x38/0x70
[23225.224922]  __x64_sys_fsync+0x10/0x20
[23225.225221]  do_syscall_64+0x3a/0x80
[23225.225555]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[23225.225863] RIP: 0033:0x7fb784282d7d
[23225.226150] RSP: 002b:00007fb7801d3d90 EFLAGS: 00000293 ORIG_RAX: 000000000000004a
[23225.226482] RAX: ffffffffffffffda RBX: 0000000000000044 RCX: 00007fb784282d7d
[23225.226782] RDX: 00007fb7801d6a20 RSI: 000000000000000a RDI: 0000000000000044
[23225.227079] RBP: 00007fb7801d3dc0 R08: 0000000000000000 R09: 0000000000000000
[23225.227368] R10: cd0000000000000c R11: 0000000000000293 R12: 0000000000010010
[23225.227696] R13: 0000000000000044 R14: 0000000000010010 R15: 0000000000000000
[23225.228005] INFO: task mysqld:19039 blocked for more than 368 seconds.
[23225.228285]       Not tainted 5.15.0+ #1
[23225.228599] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[23225.228891] task:mysqld          state:D stack:    0 pid:19039 ppid: 18566 flags:0x00004000
[23225.229184] Call Trace:
[23225.229499]  __schedule+0x294/0x860
[23225.229803]  ? set_next_entity+0x83/0xa0
[23225.230102]  schedule+0x3a/0xa0
[23225.230437]  schedule_timeout+0x215/0x2b0
[23225.230730]  ? __schedule+0x29c/0x860
[23225.231045]  wait_for_completion+0x9d/0x100
[23225.231339]  bch2_dio_write_loop+0x717/0x8d0 [bcachefs]
[23225.231698]  bch2_direct_write+0x220/0x2b0 [bcachefs]
[23225.232036]  new_sync_write+0x122/0x1b0
[23225.232331]  vfs_write+0x184/0x260
[23225.232653]  ksys_pwrite64+0x61/0xa0
[23225.232954]  ? syscall_trace_enter.isra.21+0x139/0x1b0
[23225.233244]  do_syscall_64+0x3a/0x80
[23225.233553]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[23225.233854] RIP: 0033:0x7fb784283023
[23225.234136] RSP: 002b:00007fb7801874b0 EFLAGS: 00000293 ORIG_RAX: 0000000000000012
[23225.234447] RAX: ffffffffffffffda RBX: 0000000000004000 RCX: 00007fb784283023
[23225.234733] RDX: 0000000000004000 RSI: 00007fb773874000 RDI: 0000000000000018
[23225.235031] RBP: 00007fb7801876a0 R08: 00000000003f4000 R09: 00007fb7801876c0
[23225.235319] R10: 00000000003f4000 R11: 0000000000000293 R12: 0000000000000000
[23225.235634] R13: 00007fb773874000 R14: 0000000000004000 R15: 00000000003f4000
[23348.090437] INFO: task mysqld:5115 blocked for more than 368 seconds.
[23348.090771]       Not tainted 5.15.0+ #1
[23348.091053] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[23348.091427] task:mysqld          state:D stack:    0 pid: 5115 ppid:  4498 flags:0x00004000
[23348.091737] Call Trace:
[23348.092045]  __schedule+0x294/0x860
[23348.092411]  schedule+0x3a/0xa0
[23348.092731]  io_schedule+0x12/0x40
[23348.093034]  wait_on_page_bit+0xfc/0x220
[23348.093377]  ? __page_cache_alloc+0x80/0x80
[23348.093694]  wait_on_page_writeback+0x22/0x70
[23348.093998]  __filemap_fdatawait_range+0x89/0xf0
[23348.094301]  file_write_and_wait_range+0xbb/0xe0
[23348.094655]  bch2_fsync+0x24/0x70 [bcachefs]
[23348.094992]  do_fsync+0x38/0x70
[23348.095289]  __x64_sys_fsync+0x10/0x20
[23348.095619]  do_syscall_64+0x3a/0x80
[23348.095927]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[23348.096202] RIP: 0033:0x7fd78e6a7d7d
[23348.096541] RSP: 002b:00007fd76b7fd620 EFLAGS: 00000293 ORIG_RAX: 000000000000004a
[23348.096849] RAX: ffffffffffffffda RBX: 00007fd76b7fd640 RCX: 00007fd78e6a7d7d
[23348.097145] RDX: 0005e92e00000000 RSI: 0000000000000000 RDI: 000000000000000d
[23348.097496] RBP: 00007fd76b7fd7e0 R08: 00007fd7742e4130 R09: 00000000ffffffee
[23348.097819] R10: 0000000000000001 R11: 0000000000000293 R12: 0000000000000000
[23348.098111] R13: 000000000000000d R14: 00007fd76b7fd6a0 R15: 00007fd7744bb268
[23348.098481] INFO: task mysqld:19038 blocked for more than 368 seconds.
[23348.098783]       Not tainted 5.15.0+ #1
[23348.099074] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[23348.099420] task:mysqld          state:D stack:    0 pid:19038 ppid: 18566 flags:0x00004000
[23348.099739] Call Trace:
[23348.100047]  __schedule+0x294/0x860
[23348.100407]  schedule+0x3a/0xa0
[23348.100735]  io_schedule+0x12/0x40
[23348.101044]  wait_on_page_bit+0xfc/0x220
[23348.101394]  ? __page_cache_alloc+0x80/0x80
[23348.101704]  wait_on_page_writeback+0x22/0x70
[23348.102013]  __filemap_fdatawait_range+0x89/0xf0
[23348.102365]  file_write_and_wait_range+0xbb/0xe0
[23348.102735]  bch2_fsync+0x24/0x70 [bcachefs]
[23348.103084]  do_fsync+0x38/0x70
[23348.103437]  __x64_sys_fsync+0x10/0x20
[23348.103764]  do_syscall_64+0x3a/0x80
[23348.104068]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[23348.104420] RIP: 0033:0x7fb784282d7d
[23348.104716] RSP: 002b:00007fb7801d3d90 EFLAGS: 00000293 ORIG_RAX: 000000000000004a
[23348.105023] RAX: ffffffffffffffda RBX: 0000000000000044 RCX: 00007fb784282d7d
[23348.105370] RDX: 00007fb7801d6a20 RSI: 000000000000000a RDI: 0000000000000044
[23348.105676] RBP: 00007fb7801d3dc0 R08: 0000000000000000 R09: 0000000000000000
[23348.105973] R10: cd0000000000000c R11: 0000000000000293 R12: 0000000000010010
[23348.106266] R13: 0000000000000044 R14: 0000000000010010 R15: 0000000000000000
[33659.991879] path: idx 1 ref 0:0 S P btree=extents l=0 pos 4997:0:4294967288 locks 1 0x0
[33659.993107] path: idx 2 ref 2:2 S P btree=extents l=0 pos 4997:1:4294967288 locks 1 0x0
[33659.993416] path: idx 5 ref 0:0 S btree=extents l=0 pos 5043:24239:4294967288 locks 1 0x0
[33659.993763] path: idx 7 ref 0:0 S btree=extents l=0 pos 5044:145824:4294967288 locks 1 0x0
[33659.994084] path: idx 8 ref 0:0 S btree=extents l=0 pos 5044:254688:4294967288 locks 1 0x0
[33659.994499] path: idx 9 ref 0:0 S btree=extents l=0 pos 5044:315872:4294967288 locks 1 0x0
[33659.994814] path: idx 10 ref 0:0 S btree=extents l=0 pos 5044:365616:4294967288 locks 1 0x0
[33659.995159] path: idx 11 ref 0:0 S btree=extents l=0 pos 5044:466856:4294967288 locks 1 0x0
[33659.995488] path: idx 12 ref 0:0 S btree=extents l=0 pos 5044:531864:4294967288 locks 1 0x0
[33659.995776] path: idx 13 ref 0:0 S btree=extents l=0 pos 5044:598768:4294967288 locks 1 0x0
[33659.996115] path: idx 14 ref 0:0 S btree=extents l=0 pos 5044:675200:4294967288 locks 1 0x0
[33659.996403] path: idx 15 ref 0:0 S btree=extents l=0 pos 5045:228476:4294967288 locks 1 0x0
[33659.996686] path: idx 16 ref 0:0 S btree=extents l=0 pos 5045:342176:4294967288 locks 1 0x0
[33659.997014] path: idx 17 ref 0:0 S btree=extents l=0 pos 5045:412888:4294967288 locks 1 0x0
[33659.997292] path: idx 18 ref 0:0 S btree=extents l=0 pos 5045:475976:4294967288 locks 1 0x0
[33659.997590] path: idx 19 ref 0:0 S btree=extents l=0 pos 5045:525712:4294967288 locks 1 0x0
[33659.997881] path: idx 20 ref 0:0 S btree=extents l=0 pos 5045:590736:4294967288 locks 1 0x0
[33659.998132] path: idx 21 ref 0:0 S btree=extents l=0 pos 5045:661448:4294967288 locks 1 0x0
[33659.998409] path: idx 22 ref 0:0 S btree=extents l=0 pos 5045:711200:4294967288 locks 1 0x0
[33659.998688] path: idx 23 ref 0:0 S btree=extents l=0 pos 5045:760944:4294967288 locks 1 0x0
[33659.998958] path: idx 24 ref 0:0 S btree=extents l=0 pos 5045:811260:4294967288 locks 1 0x0
[33659.999220] path: idx 25 ref 0:0 S btree=extents l=0 pos 5045:864240:4294967288 locks 1 0x0
[33659.999481] path: idx 26 ref 0:0 S btree=extents l=0 pos 5045:913984:4294967288 locks 1 0x0
[33659.999716] path: idx 27 ref 0:0 S btree=extents l=0 pos 5045:963728:4294967288 locks 1 0x0
[33659.999987] path: idx 28 ref 0:0 S btree=extents l=0 pos 5045:1013480:4294967288 locks 1 0x0
[33660.000196] path: idx 29 ref 0:0 S btree=extents l=0 pos 5045:1063224:4294967288 locks 1 0x0
[33660.000434] path: idx 30 ref 0:0 S btree=extents l=0 pos 5045:1112960:4294967288 locks 1 0x0
[33660.000672] path: idx 31 ref 0:0 S btree=extents l=0 pos 5045:1162712:4294967288 locks 1 0x0
[33660.000912] path: idx 32 ref 0:0 S btree=extents l=0 pos 5045:1212456:4294967288 locks 1 0x0
[33660.001119] path: idx 33 ref 0:0 S btree=extents l=0 pos 5048:33532:4294967288 locks 1 0x0
[33660.001351] path: idx 34 ref 0:0 S btree=extents l=0 pos 5053:81564:4294967288 locks 1 0x0
[33660.001559] path: idx 35 ref 0:0 S btree=extents l=0 pos 5053:294912:4294967288 locks 1 0x0
[33660.001801] path: idx 36 ref 0:0 S btree=extents l=0 pos 5092:87592:4294967288 locks 1 0x0
[33660.002054] path: idx 37 ref 0:0 S btree=extents l=0 pos 5096:404775:4294967288 locks 1 0x0
[33660.002332] path: idx 38 ref 0:0 S btree=extents l=0 pos 5096:982183:4294967288 locks 1 0x0
[33660.002567] path: idx 39 ref 0:0 S btree=extents l=0 pos 5096:1559463:4294967288 locks 1 0x0
[33660.002851] path: idx 40 ref 0:0 S btree=extents l=0 pos 5096:2137127:4294967288 locks 1 0x0
[33660.003164] path: idx 41 ref 0:0 S btree=extents l=0 pos 5096:2714407:4294967288 locks 1 0x0
[33660.003375] path: idx 42 ref 0:0 S btree=extents l=0 pos 5096:3291815:4294967288 locks 1 0x0
[33660.003626] path: idx 43 ref 0:0 S btree=extents l=0 pos 5096:3869095:4294967288 locks 1 0x0
[33660.003943] path: idx 44 ref 0:0 S btree=extents l=0 pos 5096:4446503:4294967288 locks 1 0x0
[33660.004190] path: idx 45 ref 0:0 S btree=extents l=0 pos 5096:5023864:4294967288 locks 1 0x0
[33660.004416] path: idx 46 ref 0:0 S btree=extents l=0 pos 5096:5600551:4294967288 locks 1 0x0
[33660.004635] path: idx 47 ref 0:0 S btree=extents l=0 pos 5096:6178215:4294967288 locks 1 0x0
[33660.004836] path: idx 48 ref 0:0 S btree=extents l=0 pos 5096:6755751:4294967288 locks 1 0x0
[33660.005034] path: idx 49 ref 0:0 S btree=extents l=0 pos 5096:7334008:4294967288 locks 1 0x0
[33660.005213] path: idx 50 ref 0:0 S btree=extents l=0 pos 5096:7911400:4294967288 locks 1 0x0
[33660.005415] path: idx 51 ref 0:0 S btree=extents l=0 pos 5096:8488743:4294967288 locks 1 0x0
[33660.005584] path: idx 52 ref 0:0 S btree=extents l=0 pos 5096:9066151:4294967288 locks 1 0x0
[33660.005759] path: idx 53 ref 0:0 S btree=extents l=0 pos 5096:9643687:4294967288 locks 1 0x0
[33660.005943] path: idx 54 ref 0:0 S btree=extents l=0 pos 5096:10223271:4294967288 locks 1 0x0
[33660.006107] path: idx 55 ref 0:0 S btree=extents l=0 pos 5096:10800551:4294967288 locks 1 0x0
[33660.006279] path: idx 56 ref 0:0 S btree=extents l=0 pos 5096:11378983:4294967288 locks 1 0x0
[33660.006473] path: idx 57 ref 0:0 S btree=extents l=0 pos 5096:11956464:4294967288 locks 1 0x0
[33660.006650] path: idx 58 ref 0:0 S btree=extents l=0 pos 5096:12533760:4294967288 locks 1 0x0
[33660.006843] path: idx 59 ref 0:0 S btree=extents l=0 pos 5096:13111975:4294967288 locks 1 0x0
[33660.007009] path: idx 60 ref 0:0 S btree=extents l=0 pos 5096:13689127:4294967288 locks 1 0x0
[33660.007161] path: idx 61 ref 0:0 S btree=extents l=0 pos 5096:14266608:4294967288 locks 1 0x0
[33660.007327] path: idx 62 ref 0:0 S btree=extents l=0 pos 5096:14843904:4294967288 locks 1 0x0
[33660.007511] path: idx 63 ref 0:0 S btree=extents l=0 pos 5096:15421351:4294967288 locks 1 0x0
[33660.007685] path: idx 6 ref 1:1 S btree=extents l=0 pos 5096:15421351:4294967291 locks 1 0x0
[33660.007886] path: idx 3 ref 0:0 S btree=extents l=0 pos 5098:1:4294967288 locks 1 0x0
[33660.008051] path: idx 4 ref 1:1 S P btree=inodes l=0 pos 0:4997:4294967288 locks 1 0x0
[33660.008218] path: idx 0 ref 0:0 S P btree=subvolumes l=0 pos 0:8:0 locks 1 0x0
[33660.008830] update: btree extents bch2_trans_update_extent+0xad4/0xdc0 [bcachefs]#012[33660.008830]   old u64s 15 type inline_data 4997:1:4294967288 len 1 ver 0: datalen 80: 2e2f6d7973716c642d6d79637a702d7777772e3030303032330a2e2f6d797371#012[33660.008830]   new u64s 5 type deleted 4997:1:4294967288 len 0 ver 0
[33660.008936] Kernel panic - not syncing: trans path oveflow
[33660.010392] CPU: 1 PID: 19038 Comm: mysqld Not tainted 5.15.0+ #1
[33660.010804] Hardware name: Red Hat KVM, BIOS 0.5.1 01/01/2011
[33660.011239] Call Trace:
[33660.011748]  dump_stack_lvl+0x45/0x57
[33660.012308]  panic+0xf3/0x2cb
[33660.012774]  ? bch2_dump_trans_paths_updates+0x204/0x229 [bcachefs]
[33660.013304]  btree_path_alloc.cold.73+0x11/0x11 [bcachefs]
[33660.013841]  btree_path_clone+0x21/0x530 [bcachefs]
[33660.014292]  bch2_btree_path_set_pos+0x200/0xb40 [bcachefs]
[33660.014758]  bch2_btree_iter_peek+0x99d/0xa30 [bcachefs]
[33660.015262]  bch2_trans_update_extent+0x12c/0xdc0 [bcachefs]
[33660.015845]  bch2_extent_update+0x198/0x2b0 [bcachefs]
[33660.016371]  bch2_write_index_default+0x25b/0x490 [bcachefs]
[33660.016948]  ? kmem_cache_alloc+0x35/0x3a0
[33660.017449]  ? finish_wait+0x80/0x80
[33660.017913]  ? mempool_alloc+0x67/0x180
[33660.018455]  ? __mod_memcg_lruvec_state+0x21/0x40
[33660.018896]  ? __mod_lruvec_page_state+0x60/0xa0
[33660.019395]  ? bio_add_page+0x62/0x90
[33660.019832]  __bch2_write_index+0x36b/0x410 [bcachefs]
[33660.020358]  bch2_write_index+0x13/0xc0 [bcachefs]
[33660.020884]  bch2_writepage_do_io.isra.65+0x5a/0x80 [bcachefs]
[33660.021486]  bch2_writepages+0xac/0xe0 [bcachefs]
[33660.022002]  do_writepages+0xc2/0x1c0
[33660.022464]  filemap_fdatawrite_wbc+0x7e/0xc0
[33660.022902]  file_write_and_wait_range+0x9c/0xe0
[33660.023349]  bch2_fsync+0x24/0x70 [bcachefs]
[33660.023874]  do_fsync+0x38/0x70
[33660.024332]  __x64_sys_fsync+0x10/0x20
[33660.024805]  do_syscall_64+0x3a/0x80
[33660.025243]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[33660.025715] RIP: 0033:0x7fb784282d7d
[33660.026135] Code: c6 20 00 00 75 10 b8 4a 00 00 00 0f 05 48 3d 01 f0 ff ff 73 31 c3 48 83 ec 08 e8 ce f6 ff ff 48 89 04 24 b8 4a 00 00 00 0f 05 <48> 8b 3c 24 48 89 c2 e8 17 f7 ff ff 48 89 d0 48 83 c4 08 48 3d 01
[33660.027008] RSP: 002b:00007fb7801d36b0 EFLAGS: 00000293 ORIG_RAX: 000000000000004a
[33660.027530] RAX: ffffffffffffffda RBX: 0000000000000035 RCX: 00007fb784282d7d
[33660.027986] RDX: 00007fb7801d6a20 RSI: 000000000000000a RDI: 0000000000000035
[33660.028481] RBP: 00007fb7801d36e0 R08: 0000000000000035 R09: 0000000000000000
[33660.028939] R10: 0000000000000000 R11: 0000000000000293 R12: 0000000000010010
[33660.029437] R13: 0000000000000035 R14: 0000000000010010 R15: 0000000000000000
[33660.030097] Kernel Offset: 0xa000000 from 0xffffffff81000000 (relocation range: 0xffffffff80000000-0xffffffffbfffffff)
[33660.030497] ---[ end Kernel panic - not syncing: trans path oveflow ]---


===================================== Reboot and remount =====================================

[... snip early boot noise ...]

[   46.707545] SGI XFS with ACLs, security attributes, quota, no debug enabled
[   67.916617] bcachefs (dm-7): recovering from unclean shutdown
[   67.917947] bcachefs (dm-7): found duplicate but non identical journal entries (seq 1), exiting
[   67.917985] bcachefs (dm-7): Unable to continue, halting
[   67.918084] bcachefs (dm-7): Error in recovery: cannot allocate memory (1)
[   67.918114] bcachefs (dm-7): filesystem contains errors: please report this to the developers
[   67.918135] mount with -o fix_errors to repair
[   83.385670] bcachefs (dm-7): recovering from unclean shutdown
[   83.389215] bcachefs (dm-7): found duplicate but non identical journal entries (seq 1), fixing
[   83.389291] bcachefs (dm-7): duplicate journal entry 1 on same device
[   83.413441] bcachefs (dm-7): found duplicate but non identical journal entries (seq 2), fixing
[   83.413497] bcachefs (dm-7): duplicate journal entry 2 on same device
[   83.428635] bcachefs (dm-7): found duplicate but non identical journal entries (seq 3), fixing
[   83.428801] bcachefs (dm-7): duplicate journal entry 3 on same device
[   83.429268] bcachefs (dm-7): found duplicate but non identical journal entries (seq 4), fixing
[   83.429309] bcachefs (dm-7): duplicate journal entry 4 on same device
[  130.295337] bcachefs (dm-7): journal read done, 518806 keys in 14479 entries, seq 55507
[  131.737777] bcachefs (dm-7): checking allocations
[  135.637314] bcachefs (dm-7): going read-write
[  136.717296] bcachefs (dm-7): journal replay done
[  137.581345] bcachefs (dm-7): mounted with opts: noinodes_use_key_cache,fix_errors
[  232.270577] path: idx 1 ref 0:0 S P btree=extents l=0 pos 4997:0:4294967288 locks 1 0x0
[  232.270659] path: idx 2 ref 2:2 S P btree=extents l=0 pos 4997:1:4294967288 locks 1 0x0
[  232.270684] path: idx 5 ref 0:0 S btree=extents l=0 pos 5043:24239:4294967288 locks 1 0x0
[  232.270712] path: idx 7 ref 0:0 S btree=extents l=0 pos 5044:145824:4294967288 locks 1 0x0
[  232.270758] path: idx 8 ref 0:0 S btree=extents l=0 pos 5044:254688:4294967288 locks 1 0x0
[  232.270783] path: idx 9 ref 0:0 S btree=extents l=0 pos 5044:315872:4294967288 locks 1 0x0
[  232.270824] path: idx 10 ref 0:0 S btree=extents l=0 pos 5044:365616:4294967288 locks 1 0x0
[  232.270850] path: idx 11 ref 0:0 S btree=extents l=0 pos 5044:466856:4294967288 locks 1 0x0
[  232.270889] path: idx 12 ref 0:0 S btree=extents l=0 pos 5044:531864:4294967288 locks 1 0x0
[  232.270935] path: idx 13 ref 0:0 S btree=extents l=0 pos 5044:598768:4294967288 locks 1 0x0
[  232.270964] path: idx 14 ref 0:0 S btree=extents l=0 pos 5044:675200:4294967288 locks 1 0x0
[  232.271065] path: idx 15 ref 0:0 S btree=extents l=0 pos 5045:228476:4294967288 locks 1 0x0
[  232.271117] path: idx 16 ref 0:0 S btree=extents l=0 pos 5045:342176:4294967288 locks 1 0x0
[  232.271206] path: idx 17 ref 0:0 S btree=extents l=0 pos 5045:412888:4294967288 locks 1 0x0
[  232.271279] path: idx 18 ref 0:0 S btree=extents l=0 pos 5045:475976:4294967288 locks 1 0x0
[  232.271362] path: idx 19 ref 0:0 S btree=extents l=0 pos 5045:525712:4294967288 locks 1 0x0
[  232.271395] path: idx 20 ref 0:0 S btree=extents l=0 pos 5045:590736:4294967288 locks 1 0x0
[  232.271441] path: idx 21 ref 0:0 S btree=extents l=0 pos 5045:661448:4294967288 locks 1 0x0
[  232.271497] path: idx 22 ref 0:0 S btree=extents l=0 pos 5045:711200:4294967288 locks 1 0x0
[  232.271581] path: idx 23 ref 0:0 S btree=extents l=0 pos 5045:760944:4294967288 locks 1 0x0
[  232.271647] path: idx 24 ref 0:0 S btree=extents l=0 pos 5045:811260:4294967288 locks 1 0x0
[  232.271702] path: idx 25 ref 0:0 S btree=extents l=0 pos 5045:864240:4294967288 locks 1 0x0
[  232.271766] path: idx 26 ref 0:0 S btree=extents l=0 pos 5045:913984:4294967288 locks 1 0x0
[  232.272298] path: idx 27 ref 0:0 S btree=extents l=0 pos 5045:963728:4294967288 locks 1 0x0
[  232.272598] path: idx 28 ref 0:0 S btree=extents l=0 pos 5045:1013480:4294967288 locks 1 0x0
[  232.273111] path: idx 29 ref 0:0 S btree=extents l=0 pos 5045:1063224:4294967288 locks 1 0x0
[  232.273523] path: idx 30 ref 0:0 S btree=extents l=0 pos 5045:1112960:4294967288 locks 1 0x0
[  232.273811] path: idx 31 ref 0:0 S btree=extents l=0 pos 5045:1162712:4294967288 locks 1 0x0
[  232.274132] path: idx 32 ref 0:0 S btree=extents l=0 pos 5045:1212456:4294967288 locks 1 0x0
[  232.274435] path: idx 33 ref 0:0 S btree=extents l=0 pos 5048:33532:4294967288 locks 1 0x0
[  232.274704] path: idx 34 ref 0:0 S btree=extents l=0 pos 5053:81564:4294967288 locks 1 0x0
[  232.274998] path: idx 35 ref 0:0 S btree=extents l=0 pos 5053:294912:4294967288 locks 1 0x0
[  232.275308] path: idx 36 ref 0:0 S btree=extents l=0 pos 5092:87592:4294967288 locks 1 0x0
[  232.275573] path: idx 37 ref 0:0 S btree=extents l=0 pos 5096:404775:4294967288 locks 1 0x0
[  232.275843] path: idx 38 ref 0:0 S btree=extents l=0 pos 5096:982183:4294967288 locks 1 0x0
[  232.276106] path: idx 39 ref 0:0 S btree=extents l=0 pos 5096:1559463:4294967288 locks 1 0x0
[  232.276395] path: idx 40 ref 0:0 S btree=extents l=0 pos 5096:2137127:4294967288 locks 1 0x0
[  232.276705] path: idx 41 ref 0:0 S btree=extents l=0 pos 5096:2714407:4294967288 locks 1 0x0
[  232.277027] path: idx 42 ref 0:0 S btree=extents l=0 pos 5096:3291815:4294967288 locks 1 0x0
[  232.277414] path: idx 43 ref 0:0 S btree=extents l=0 pos 5096:3869095:4294967288 locks 1 0x0
[  232.277742] path: idx 44 ref 0:0 S btree=extents l=0 pos 5096:4446503:4294967288 locks 1 0x0
[  232.277976] path: idx 45 ref 0:0 S btree=extents l=0 pos 5096:5023864:4294967288 locks 1 0x0
[  232.278187] path: idx 46 ref 0:0 S btree=extents l=0 pos 5096:5600551:4294967288 locks 1 0x0
[  232.278455] path: idx 47 ref 0:0 S btree=extents l=0 pos 5096:6178215:4294967288 locks 1 0x0
[  232.278647] path: idx 48 ref 0:0 S btree=extents l=0 pos 5096:6755751:4294967288 locks 1 0x0
[  232.278843] path: idx 49 ref 0:0 S btree=extents l=0 pos 5096:7334008:4294967288 locks 1 0x0
[  232.279069] path: idx 50 ref 0:0 S btree=extents l=0 pos 5096:7911400:4294967288 locks 1 0x0
[  232.279291] path: idx 51 ref 0:0 S btree=extents l=0 pos 5096:8488743:4294967288 locks 1 0x0
[  232.279469] path: idx 52 ref 0:0 S btree=extents l=0 pos 5096:9066151:4294967288 locks 1 0x0
[  232.279665] path: idx 53 ref 0:0 S btree=extents l=0 pos 5096:9643687:4294967288 locks 1 0x0
[  232.279838] path: idx 54 ref 0:0 S btree=extents l=0 pos 5096:10223271:4294967288 locks 1 0x0
[  232.280031] path: idx 55 ref 0:0 S btree=extents l=0 pos 5096:10800551:4294967288 locks 1 0x0
[  232.280248] path: idx 56 ref 0:0 S btree=extents l=0 pos 5096:11378983:4294967288 locks 1 0x0
[  232.280421] path: idx 57 ref 0:0 S btree=extents l=0 pos 5096:11956464:4294967288 locks 1 0x0
[  232.280591] path: idx 58 ref 0:0 S btree=extents l=0 pos 5096:12533760:4294967288 locks 1 0x0
[  232.280776] path: idx 59 ref 0:0 S btree=extents l=0 pos 5096:13111975:4294967288 locks 1 0x0
[  232.280972] path: idx 60 ref 0:0 S btree=extents l=0 pos 5096:13689127:4294967288 locks 1 0x0
[  232.281152] path: idx 61 ref 0:0 S btree=extents l=0 pos 5096:14266608:4294967288 locks 1 0x0
[  232.281379] path: idx 62 ref 0:0 S btree=extents l=0 pos 5096:14843904:4294967288 locks 1 0x0
[  232.281550] path: idx 63 ref 0:0 S btree=extents l=0 pos 5096:15421351:4294967288 locks 1 0x0
[  232.281730] path: idx 6 ref 1:1 S btree=extents l=0 pos 5096:15421351:4294967291 locks 1 0x0
[  232.281890] path: idx 3 ref 0:0 S btree=extents l=0 pos 5098:1:4294967288 locks 1 0x0
[  232.282109] path: idx 4 ref 1:1 S P btree=inodes l=0 pos 0:4997:4294967288 locks 1 0x0
[  232.282346] path: idx 0 ref 0:0 S P btree=subvolumes l=0 pos 0:8:0 locks 1 0x0
[  232.283910] update: btree extents bch2_trans_update_extent+0xad4/0xdc0 [bcachefs]#012[  232.283910]   old u64s 15 type inline_data 4997:1:4294967288 len 1 ver 0: datalen 80: 2e2f6d7973716c642d6d79637a702d7777772e3030303032330a2e2f6d797371#012[  232.283910]   new u64s 5 type deleted 4997:1:4294967288 len 0 ver 0
[  232.284039] Kernel panic - not syncing: trans path oveflow
[  232.285049] CPU: 1 PID: 8613 Comm: mysqld Not tainted 5.15.0+ #1
[  232.285314] Hardware name: Red Hat KVM, BIOS 0.5.1 01/01/2011
[  232.285554] Call Trace:
[  232.285791]  dump_stack_lvl+0x45/0x57
[  232.286040]  panic+0xf3/0x2cb
[  232.286274]  ? bch2_dump_trans_paths_updates+0x204/0x229 [bcachefs]
[  232.286554]  btree_path_alloc.cold.73+0x11/0x11 [bcachefs]
[  232.286843]  btree_path_clone+0x21/0x530 [bcachefs]
[  232.287137]  bch2_btree_path_set_pos+0x200/0xb40 [bcachefs]
[  232.287407]  bch2_btree_iter_peek+0x99d/0xa30 [bcachefs]
[  232.287679]  bch2_trans_update_extent+0x12c/0xdc0 [bcachefs]
[  232.287974]  bch2_extent_update+0x198/0x2b0 [bcachefs]
[  232.288261]  bch2_write_index_default+0x25b/0x490 [bcachefs]
[  232.288551]  ? kmem_cache_alloc+0x35/0x3a0
[  232.288826]  ? finish_wait+0x80/0x80
[  232.289119]  ? mempool_alloc+0x67/0x180
[  232.289390]  ? __mod_memcg_lruvec_state+0x21/0x40
[  232.289662]  ? bio_add_page+0x62/0x90
[  232.289956]  __bch2_write_index+0x36b/0x410 [bcachefs]
[  232.290261]  bch2_write_index+0x13/0xc0 [bcachefs]
[  232.290570]  bch2_writepage_do_io.isra.65+0x5a/0x80 [bcachefs]
[  232.290891]  bch2_writepages+0xac/0xe0 [bcachefs]
[  232.291212]  ? __vfs_getxattr+0x53/0x70
[  232.291479]  do_writepages+0xc2/0x1c0
[  232.291744]  filemap_fdatawrite_wbc+0x7e/0xc0
[  232.292023]  file_write_and_wait_range+0x9c/0xe0
[  232.292308]  bch2_fsync+0x24/0x70 [bcachefs]
[  232.292624]  do_fsync+0x38/0x70
[  232.292911]  __x64_sys_fsync+0x10/0x20
[  232.293213]  do_syscall_64+0x3a/0x80
[  232.293512]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[  232.293823] RIP: 0033:0x7f42c8171d7d
[  232.294142] Code: c6 20 00 00 75 10 b8 4a 00 00 00 0f 05 48 3d 01 f0 ff ff 73 31 c3 48 83 ec 08 e8 ce f6 ff ff 48 89 04 24 b8 4a 00 00 00 0f 05 <48> 8b 3c 24 48 89 c2 e8 17 f7 ff ff 48 89 d0 48 83 c4 08 48 3d 01
[  232.294786] RSP: 002b:00007ffd78ce58b0 EFLAGS: 00000293 ORIG_RAX: 000000000000004a
[  232.295145] RAX: ffffffffffffffda RBX: 0000000000000001 RCX: 00007f42c8171d7d
[  232.295481] RDX: 00007f42c8dd8a60 RSI: 000000000000000a RDI: 0000000000000001
[  232.295816] RBP: 00007ffd78ce58e0 R08: 0000000000000001 R09: 0000000000000000
[  232.296161] R10: 00005572ab8cad0c R11: 0000000000000293 R12: 0000000000010010
[  232.296496] R13: 0000000000000001 R14: 0000000000010010 R15: 00005572aada6880
[  232.297067] Kernel Offset: 0x6000000 from 0xffffffff81000000 (relocation range: 0xffffffff80000000-0xffffffffbfffffff)
[  232.297389] ---[ end Kernel panic - not syncing: trans path oveflow ]---


--
Eric Wheeler

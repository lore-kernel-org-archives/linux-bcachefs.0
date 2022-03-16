Return-Path: <linux-bcachefs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54CEBC433EF
	for <linux-bcachefs@archiver.kernel.org>; Wed, 16 Mar 2022 22:58:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229866AbiCPW76 (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Wed, 16 Mar 2022 18:59:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229501AbiCPW76 (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Wed, 16 Mar 2022 18:59:58 -0400
Received: from mx.ewheeler.net (mx.ewheeler.net [173.205.220.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D817BB61
        for <linux-bcachefs@vger.kernel.org>; Wed, 16 Mar 2022 15:58:40 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by mx.ewheeler.net (Postfix) with ESMTP id 7BAE447;
        Wed, 16 Mar 2022 15:58:40 -0700 (PDT)
X-Virus-Scanned: amavisd-new at ewheeler.net
Received: from mx.ewheeler.net ([127.0.0.1])
        by localhost (mx.ewheeler.net [127.0.0.1]) (amavisd-new, port 10024)
        with LMTP id ns1WObj-d_l1; Wed, 16 Mar 2022 15:58:36 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx.ewheeler.net (Postfix) with ESMTPSA id DDBF639;
        Wed, 16 Mar 2022 15:58:35 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx.ewheeler.net DDBF639
Date:   Wed, 16 Mar 2022 15:58:34 -0700 (PDT)
From:   Eric Wheeler <bcachefs@lists.ewheeler.net>
To:     Kent Overstreet <kent.overstreet@gmail.com>
cc:     linux-bcachefs@vger.kernel.org
Subject: bcachefs filesystem corruption
Message-ID: <a55372e3-c4d5-ecb0-782e-242d166140c5@lists.ewheeler.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

Hi Kent,

The MySQL+snapshots deployment we has become corrupt and InnoDB is 
crashing with a stack trace and lots of borken database noise.

We are going to rebuild it from other replicas and see if it happens 
again.  We started using your new-allocator code (commit 
3985f5f4eff86ee667da7da6e36ca2c346f56be3) after the original deployment 
and we haven't re-loaded since you fixed the snapshot iterator issue, or 
maybe it broke during the allocator conversion, can't be certain.

There isn't any especially obvious problem but there are some WARNING's 
below that you might look at.

There were lots of these:
	WARNING: CPU: 0 PID: 7796 at fs/bcachefs/fs-io.c:1290 
	  bch2_writepage_io_done (fs/bcachefs/fs-io.c:1290 (discriminator 1)) bcachefs

and lots of hung processes as seen below with a `grep -A10 hung`. Further 
down you will find the whole `dmesg` output.

Will let you know if the corruption happens again after we rebuild the 
replicas on bcachefs.

-Eric


~]$ grep hung /tmp/pico.79315 -A10
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:kworker/u4:3    state:D stack:    0 pid:10501 ppid:     2 flags:0x00004000
Workqueue: writeback wb_workfn (flush-bcachefs-1)
Call Trace:
 <TASK>
__schedule (kernel/sched/core.c:4975 kernel/sched/core.c:6253) 
schedule (kernel/sched/core.c:6327 (discriminator 1)) 
schedule_timeout (kernel/time/timer.c:1858) 
? __mod_memcg_lruvec_state (mm/memcontrol.c:635 mm/memcontrol.c:708) 
__down (kernel/locking/semaphore.c:225 kernel/locking/semaphore.c:241) 
down (kernel/locking/semaphore.c:62) 
--
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:mysqld          state:D stack:    0 pid:16761 ppid: 16251 flags:0x00000000
Call Trace:
 <TASK>
__schedule (kernel/sched/core.c:4975 kernel/sched/core.c:6253) 
schedule (kernel/sched/core.c:6327 (discriminator 1)) 
io_schedule (kernel/sched/core.c:8346 kernel/sched/core.c:8372) 
folio_wait_bit (mm/filemap.c:1363 mm/filemap.c:1431) 
? filemap_alloc_folio (mm/filemap.c:1143) 
folio_wait_writeback (./arch/x86/include/asm/bitops.h:207 ./include/asm-generic/bitops/instrumented-non-atomic.h:135 ./include/linux/page-flags.h:464 mm/page-writeback.c:2923) 
__filemap_fdatawait_range (./include/linux/page-flags.h:198 (discriminator 3) ./include/linux/page-flags.h:419 (discriminator 3) mm/filemap.c:544 (discriminator 3)) 
--
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:mysqld          state:D stack:    0 pid:18048 ppid: 17541 flags:0x00000000
Call Trace:
 <TASK>
__schedule (kernel/sched/core.c:4975 kernel/sched/core.c:6253) 
schedule (kernel/sched/core.c:6327 (discriminator 1)) 
schedule_timeout (kernel/time/timer.c:1858) 
? write_cache_pages (mm/page-writeback.c:2209) 
? bch2_truncate_pages (fs/bcachefs/fs-io.c:1361) bcachefs
__down (kernel/locking/semaphore.c:225 kernel/locking/semaphore.c:241) 
? preempt_count_add (./include/linux/ftrace.h:894 kernel/sched/core.c:5413 kernel/sched/core.c:5410 kernel/sched/core.c:5438) 
--
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:mysqld          state:D stack:    0 pid:18340 ppid: 17541 flags:0x00000000
Call Trace:
 <TASK>
__schedule (kernel/sched/core.c:4975 kernel/sched/core.c:6253) 
schedule (kernel/sched/core.c:6327 (discriminator 1)) 
schedule_timeout (kernel/time/timer.c:1858) 
? write_cache_pages (mm/page-writeback.c:2209) 
? bch2_truncate_pages (fs/bcachefs/fs-io.c:1361) bcachefs
__down (kernel/locking/semaphore.c:225 kernel/locking/semaphore.c:241) 
? preempt_count_add (./include/linux/ftrace.h:894 kernel/sched/core.c:5413 kernel/sched/core.c:5410 kernel/sched/core.c:5438) 
--
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:mysqld          state:D stack:    0 pid:18387 ppid: 18206 flags:0x00004000
Call Trace:
 <TASK>
__schedule (kernel/sched/core.c:4975 kernel/sched/core.c:6253) 
schedule (kernel/sched/core.c:6327 (discriminator 1)) 
schedule_timeout (kernel/time/timer.c:1858) 
? __cond_resched (kernel/sched/core.c:8133) 
wait_for_completion (kernel/sched/completion.c:86 kernel/sched/completion.c:106 kernel/sched/completion.c:117 kernel/sched/completion.c:138) 
bch2_dio_write_loop (fs/bcachefs/fs-io.c:2207) bcachefs
bch2_direct_write (fs/bcachefs/fs-io.c:2340) bcachefs
--
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:mysqld          state:D stack:    0 pid:18394 ppid: 18206 flags:0x00000000
Call Trace:
 <TASK>
__schedule (kernel/sched/core.c:4975 kernel/sched/core.c:6253) 
schedule (kernel/sched/core.c:6327 (discriminator 1)) 
schedule_timeout (kernel/time/timer.c:1858) 
? __mod_memcg_lruvec_state (mm/memcontrol.c:635 mm/memcontrol.c:708) 
__down (kernel/locking/semaphore.c:225 kernel/locking/semaphore.c:241) 
? preempt_count_add (./include/linux/ftrace.h:894 kernel/sched/core.c:5413 kernel/sched/core.c:5410 kernel/sched/core.c:5438) 
down (kernel/locking/semaphore.c:62) 
--
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:mysqld          state:D stack:    0 pid:18407 ppid: 18206 flags:0x00000000
Call Trace:
 <TASK>
__schedule (kernel/sched/core.c:4975 kernel/sched/core.c:6253) 
? __remove_hrtimer (kernel/time/hrtimer.c:1116) 
schedule (kernel/sched/core.c:6327 (discriminator 1)) 
schedule_timeout (kernel/time/timer.c:1858) 
? __mod_memcg_lruvec_state (mm/memcontrol.c:635 mm/memcontrol.c:708) 
__down (kernel/locking/semaphore.c:225 kernel/locking/semaphore.c:241) 
? preempt_count_add (./include/linux/ftrace.h:894 kernel/sched/core.c:5413 kernel/sched/core.c:5410 kernel/sched/core.c:5438) 
--
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:kworker/u4:3    state:D stack:    0 pid:10501 ppid:     2 flags:0x00004000
Workqueue: writeback wb_workfn (flush-bcachefs-1)
Call Trace:
 <TASK>
__schedule (kernel/sched/core.c:4975 kernel/sched/core.c:6253) 
schedule (kernel/sched/core.c:6327 (discriminator 1)) 
schedule_timeout (kernel/time/timer.c:1858) 
? __mod_memcg_lruvec_state (mm/memcontrol.c:635 mm/memcontrol.c:708) 
__down (kernel/locking/semaphore.c:225 kernel/locking/semaphore.c:241) 
down (kernel/locking/semaphore.c:62) 
--
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:mysqld          state:D stack:    0 pid:16761 ppid: 16251 flags:0x00000000
Call Trace:
 <TASK>
__schedule (kernel/sched/core.c:4975 kernel/sched/core.c:6253) 
schedule (kernel/sched/core.c:6327 (discriminator 1)) 
io_schedule (kernel/sched/core.c:8346 kernel/sched/core.c:8372) 
folio_wait_bit (mm/filemap.c:1363 mm/filemap.c:1431) 
? filemap_alloc_folio (mm/filemap.c:1143) 
folio_wait_writeback (./arch/x86/include/asm/bitops.h:207 ./include/asm-generic/bitops/instrumented-non-atomic.h:135 ./include/linux/page-flags.h:464 mm/page-writeback.c:2923) 
__filemap_fdatawait_range (./include/linux/page-flags.h:198 (discriminator 3) ./include/linux/page-flags.h:419 (discriminator 3) mm/filemap.c:544 (discriminator 3)) 
--
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:mysqld          state:D stack:    0 pid:18048 ppid: 17541 flags:0x00000000
Call Trace:
 <TASK>
__schedule (kernel/sched/core.c:4975 kernel/sched/core.c:6253) 
schedule (kernel/sched/core.c:6327 (discriminator 1)) 
schedule_timeout (kernel/time/timer.c:1858) 
? write_cache_pages (mm/page-writeback.c:2209) 
? bch2_truncate_pages (fs/bcachefs/fs-io.c:1361) bcachefs
__down (kernel/locking/semaphore.c:225 kernel/locking/semaphore.c:241) 
? preempt_count_add (./include/linux/ftrace.h:894 kernel/sched/core.c:5413 kernel/sched/core.c:5410 kernel/sched/core.c:5438) 



Linux version 5.16.0+ (root@rl8-dev.ewheeler.net) (gcc (GCC) 8.5.0 20210514 (Red Hat 8.5.0-4), GNU ld version 2.30-108.el8_5.1) #1 SMP PREEMPT Tue Mar 15 10:05:37 PDT 2022
Command line: BOOT_IMAGE=/vmlinuz-5.16.0+ root=/dev/mapper/centos_sbo-root ro rd.lvm.lv=centos_sbo/root rd.lvm.lv=centos_sbo/swap rd.lvm.lv=centos_sbo/usr

[...]

bcachefs (dm-6): initializing new filesystem
bcachefs (dm-6): going read-write
bucket 0:10 gen 0 different types of data in same bucket: btree, journal
while marking journal
bcachefs (dm-6): inconsistency detected - emergency read only
bcachefs: bch2_fs_initialize() Error initializing new filesystem: error marking superblock and journal (-5)
bcachefs (dm-6): IO error
bcachefs (dm-6): recovering from clean shutdown, journal seq 420
bcachefs (dm-6): going read-write
bcachefs (dm-6): mounted with opts: noinodes_use_key_cache
------------[ cut here ]------------
WARNING: CPU: 0 PID: 7796 at fs/bcachefs/fs-io.c:1290 bch2_writepage_io_done (fs/bcachefs/fs-io.c:1290 (discriminator 1)) bcachefs
Modules linked in: bcachefs lz4_compress crc64 xor raid6_pq zstd_compress libcrc32c xt_comment iptable_filter binfmt_misc rfkill cirrus drm_kms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops drm pcspkr sg i2c_piix4 virtio_balloon floppy i2c_core ip_tables ext4 mbcache jbd2 sr_mod cdrom ata_generic pata_acpi ata_piix libata virtio_net net_failover failover serio_raw dm_mirror dm_region_hash dm_log dm_mod
CPU: 0 PID: 7796 Comm: kworker/0:2 Not tainted 5.16.0+ #1
Hardware name: Red Hat KVM, BIOS 0.5.1 01/01/2011
Workqueue: bcachefs bch2_write_index [bcachefs]
RIP: 0010:bch2_writepage_io_done (fs/bcachefs/fs-io.c:1290 (discriminator 1)) bcachefs
Code: 80 64 24 28 f0 e8 58 6d 23 f6 0f b7 83 a0 03 00 00 44 39 f8 0f 8f 63 ff ff ff 48 8b b3 48 01 00 00 48 85 f6 0f 8e 82 fd ff ff <0f> 0b e9 7b fd ff ff 48 83 c5 40 b9 00 10 00 00 e9 bf fd ff ff 8b
All code
========
   0:	80 64 24 28 f0       	andb   $0xf0,0x28(%rsp)
   5:	e8 58 6d 23 f6       	callq  0xfffffffff6236d62
   a:	0f b7 83 a0 03 00 00 	movzwl 0x3a0(%rbx),%eax
  11:	44 39 f8             	cmp    %r15d,%eax
  14:	0f 8f 63 ff ff ff    	jg     0xffffffffffffff7d
  1a:	48 8b b3 48 01 00 00 	mov    0x148(%rbx),%rsi
  21:	48 85 f6             	test   %rsi,%rsi
  24:	0f 8e 82 fd ff ff    	jle    0xfffffffffffffdac
  2a:*	0f 0b                	ud2    		<-- trapping instruction
  2c:	e9 7b fd ff ff       	jmpq   0xfffffffffffffdac
  31:	48 83 c5 40          	add    $0x40,%rbp
  35:	b9 00 10 00 00       	mov    $0x1000,%ecx
  3a:	e9 bf fd ff ff       	jmpq   0xfffffffffffffdfe
  3f:	8b                   	.byte 0x8b

Code starting with the faulting instruction
===========================================
   0:	0f 0b                	ud2    
   2:	e9 7b fd ff ff       	jmpq   0xfffffffffffffd82
   7:	48 83 c5 40          	add    $0x40,%rbp
   b:	b9 00 10 00 00       	mov    $0x1000,%ecx
  10:	e9 bf fd ff ff       	jmpq   0xfffffffffffffdd4
  15:	8b                   	.byte 0x8b
RSP: 0018:ffffa6c4418d3e68 EFLAGS: 00010202
RAX: 0000000080000000 RBX: ffff8c2cc6604000 RCX: 0000000000000001
RDX: 0000000080000001 RSI: 0000000000000008 RDI: 00000000ffffffff
RBP: ffff8c2cff415540 R08: 000000000007c12a R09: 0000000000000000
R10: 0000000000000000 R11: 00000000ffffffff R12: ffffc6c43fc08f00
R13: 0000000000000020 R14: ffff8c2d7ca2ee00 R15: ffffc6c43fc08f05
FS:  0000000000000000(0000) GS:ffff8c2d7ca00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f9b5c3504b1 CR3: 0000000004b5e000 CR4: 00000000000006f0
Call Trace:
 <TASK>
process_one_work (./arch/x86/include/asm/jump_label.h:27 ./include/linux/jump_label.h:212 ./include/trace/events/workqueue.h:108 kernel/workqueue.c:2303) 
worker_thread (./include/linux/list.h:284 kernel/workqueue.c:2446) 
? process_one_work (kernel/workqueue.c:2388) 
kthread (kernel/kthread.c:327) 
? set_kthread_struct (kernel/kthread.c:272) 
ret_from_fork (arch/x86/entry/entry_64.S:301) 
 </TASK>
---[ end trace ae1f1e0405dedf14 ]---
------------[ cut here ]------------
WARNING: CPU: 0 PID: 7796 at fs/bcachefs/fs-io.c:1290 bch2_writepage_io_done (fs/bcachefs/fs-io.c:1290 (discriminator 1)) bcachefs
Modules linked in: bcachefs lz4_compress crc64 xor raid6_pq zstd_compress libcrc32c xt_comment iptable_filter binfmt_misc rfkill cirrus drm_kms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops drm pcspkr sg i2c_piix4 virtio_balloon floppy i2c_core ip_tables ext4 mbcache jbd2 sr_mod cdrom ata_generic pata_acpi ata_piix libata virtio_net net_failover failover serio_raw dm_mirror dm_region_hash dm_log dm_mod
CPU: 0 PID: 7796 Comm: kworker/0:2 Tainted: G        W         5.16.0+ #1
Hardware name: Red Hat KVM, BIOS 0.5.1 01/01/2011
Workqueue: bcachefs bch2_write_index [bcachefs]
RIP: 0010:bch2_writepage_io_done (fs/bcachefs/fs-io.c:1290 (discriminator 1)) bcachefs
Code: 80 64 24 28 f0 e8 58 6d 23 f6 0f b7 83 a0 03 00 00 44 39 f8 0f 8f 63 ff ff ff 48 8b b3 48 01 00 00 48 85 f6 0f 8e 82 fd ff ff <0f> 0b e9 7b fd ff ff 48 83 c5 40 b9 00 10 00 00 e9 bf fd ff ff 8b
All code
========
   0:	80 64 24 28 f0       	andb   $0xf0,0x28(%rsp)
   5:	e8 58 6d 23 f6       	callq  0xfffffffff6236d62
   a:	0f b7 83 a0 03 00 00 	movzwl 0x3a0(%rbx),%eax
  11:	44 39 f8             	cmp    %r15d,%eax
  14:	0f 8f 63 ff ff ff    	jg     0xffffffffffffff7d
  1a:	48 8b b3 48 01 00 00 	mov    0x148(%rbx),%rsi
  21:	48 85 f6             	test   %rsi,%rsi
  24:	0f 8e 82 fd ff ff    	jle    0xfffffffffffffdac
  2a:*	0f 0b                	ud2    		<-- trapping instruction
  2c:	e9 7b fd ff ff       	jmpq   0xfffffffffffffdac
  31:	48 83 c5 40          	add    $0x40,%rbp
  35:	b9 00 10 00 00       	mov    $0x1000,%ecx
  3a:	e9 bf fd ff ff       	jmpq   0xfffffffffffffdfe
  3f:	8b                   	.byte 0x8b

Code starting with the faulting instruction
===========================================
   0:	0f 0b                	ud2    
   2:	e9 7b fd ff ff       	jmpq   0xfffffffffffffd82
   7:	48 83 c5 40          	add    $0x40,%rbp
   b:	b9 00 10 00 00       	mov    $0x1000,%ecx
  10:	e9 bf fd ff ff       	jmpq   0xfffffffffffffdd4
  15:	8b                   	.byte 0x8b
RSP: 0018:ffffa6c4418d3e68 EFLAGS: 00010202
RAX: 0000000080000000 RBX: ffff8c2cfda3e000 RCX: 0000000000000001
RDX: 0000000080000001 RSI: 0000000000000008 RDI: 00000000ffffffff
RBP: ffff8c2cff415540 R08: 000000000007c159 R09: 0000000000000000
R10: 0000000000000000 R11: 00000000ffffffff R12: ffffc6c43fc08f00
R13: 0000000000000020 R14: ffff8c2d7ca2ee00 R15: ffffc6c43fc08f05
FS:  0000000000000000(0000) GS:ffff8c2d7ca00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f8f454f5800 CR3: 0000000004b5e000 CR4: 00000000000006f0
Call Trace:
 <TASK>
process_one_work (./arch/x86/include/asm/jump_label.h:27 ./include/linux/jump_label.h:212 ./include/trace/events/workqueue.h:108 kernel/workqueue.c:2303) 
worker_thread (./include/linux/list.h:284 kernel/workqueue.c:2446) 
? process_one_work (kernel/workqueue.c:2388) 
kthread (kernel/kthread.c:327) 
? set_kthread_struct (kernel/kthread.c:272) 
ret_from_fork (arch/x86/entry/entry_64.S:301) 
 </TASK>
---[ end trace ae1f1e0405dedf15 ]---
INFO: task kworker/u4:3:10501 blocked for more than 122 seconds.
      Tainted: G        W         5.16.0+ #1
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:kworker/u4:3    state:D stack:    0 pid:10501 ppid:     2 flags:0x00004000
Workqueue: writeback wb_workfn (flush-bcachefs-1)
Call Trace:
 <TASK>
__schedule (kernel/sched/core.c:4975 kernel/sched/core.c:6253) 
schedule (kernel/sched/core.c:6327 (discriminator 1)) 
schedule_timeout (kernel/time/timer.c:1858) 
? __mod_memcg_lruvec_state (mm/memcontrol.c:635 mm/memcontrol.c:708) 
__down (kernel/locking/semaphore.c:225 kernel/locking/semaphore.c:241) 
down (kernel/locking/semaphore.c:62) 
bch2_writepage_do_io.isra.70 (fs/bcachefs/fs-io.c:1321) bcachefs
__bch2_writepage (fs/bcachefs/fs-io.c:1465) bcachefs
? percpu_counter_add_batch (./arch/x86/include/asm/preempt.h:103 (discriminator 82) lib/percpu_counter.c:97 (discriminator 82)) 
write_cache_pages (mm/page-writeback.c:2256) 
? bch2_truncate_pages (fs/bcachefs/fs-io.c:1361) bcachefs
bch2_writepages (fs/bcachefs/fs-io.c:1502) bcachefs
do_writepages (mm/page-writeback.c:2367) 
__writeback_single_inode (fs/fs-writeback.c:1616) 
writeback_sb_inodes (fs/fs-writeback.c:1883) 
__writeback_inodes_wb (fs/fs-writeback.c:1952) 
wb_writeback (fs/fs-writeback.c:2056) 
 [78646.329608] wb_workfn (fs/fs-writeback.c:2156 fs/fs-writeback.c:2209 fs/fs-writeback.c:2238) 
? _raw_spin_unlock (./arch/x86/include/asm/preempt.h:103 ./include/linux/spinlock_api_smp.h:143 kernel/locking/spinlock.c:186) 
process_one_work (./arch/x86/include/asm/jump_label.h:27 ./include/linux/jump_label.h:212 ./include/trace/events/workqueue.h:108 kernel/workqueue.c:2303) 
worker_thread (./include/linux/list.h:284 kernel/workqueue.c:2446) 
? process_one_work (kernel/workqueue.c:2388) 
kthread (kernel/kthread.c:327) 
? set_kthread_struct (kernel/kthread.c:272) 
ret_from_fork (arch/x86/entry/entry_64.S:301) 
 </TASK>
INFO: task mysqld:16761 blocked for more than 122 seconds.
      Tainted: G        W         5.16.0+ #1
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:mysqld          state:D stack:    0 pid:16761 ppid: 16251 flags:0x00000000
Call Trace:
 <TASK>
__schedule (kernel/sched/core.c:4975 kernel/sched/core.c:6253) 
schedule (kernel/sched/core.c:6327 (discriminator 1)) 
io_schedule (kernel/sched/core.c:8346 kernel/sched/core.c:8372) 
folio_wait_bit (mm/filemap.c:1363 mm/filemap.c:1431) 
? filemap_alloc_folio (mm/filemap.c:1143) 
folio_wait_writeback (./arch/x86/include/asm/bitops.h:207 ./include/asm-generic/bitops/instrumented-non-atomic.h:135 ./include/linux/page-flags.h:464 mm/page-writeback.c:2923) 
__filemap_fdatawait_range (./include/linux/page-flags.h:198 (discriminator 3) ./include/linux/page-flags.h:419 (discriminator 3) mm/filemap.c:544 (discriminator 3)) 
file_write_and_wait_range (mm/filemap.c:830) 
bch2_fsync (fs/bcachefs/fs-io.c:2419) bcachefs
do_fsync (./include/linux/file.h:45 fs/sync.c:207) 
__x64_sys_fsync (fs/sync.c:214 fs/sync.c:212 fs/sync.c:212) 
do_syscall_64 (arch/x86/entry/common.c:50 arch/x86/entry/common.c:80) 
entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:113) 
RIP: 0033:0x7f0eb7663d7d
RSP: 002b:00007f0e997f9620 EFLAGS: 00000293 ORIG_RAX: 000000000000004a
RAX: ffffffffffffffda RBX: 00007f0e997f9640 RCX: 00007f0eb7663d7d
RDX: 0000af3600000000 RSI: 0000000000000000 RDI: 000000000000000b
RBP: 00007f0e997f97e0 R08: 00007f0e9c2e4360 R09: 00000000ffffffef
R10: 0000000000000002 R11: 0000000000000293 R12: 0000000000000000
R13: 000000000000000b R14: 00007f0e997f96a0 R15: 00007f0e9c4b7a78
 </TASK>
INFO: task mysqld:18048 blocked for more than 122 seconds.
      Tainted: G        W         5.16.0+ #1
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:mysqld          state:D stack:    0 pid:18048 ppid: 17541 flags:0x00000000
Call Trace:
 <TASK>
__schedule (kernel/sched/core.c:4975 kernel/sched/core.c:6253) 
schedule (kernel/sched/core.c:6327 (discriminator 1)) 
schedule_timeout (kernel/time/timer.c:1858) 
? write_cache_pages (mm/page-writeback.c:2209) 
? bch2_truncate_pages (fs/bcachefs/fs-io.c:1361) bcachefs
__down (kernel/locking/semaphore.c:225 kernel/locking/semaphore.c:241) 
? preempt_count_add (./include/linux/ftrace.h:894 kernel/sched/core.c:5413 kernel/sched/core.c:5410 kernel/sched/core.c:5438) 
down (kernel/locking/semaphore.c:62) 
bch2_writepage_do_io.isra.70 (fs/bcachefs/fs-io.c:1321) bcachefs
bch2_writepages (fs/bcachefs/fs-io.c:1504) bcachefs
do_writepages (mm/page-writeback.c:2367) 
filemap_fdatawrite_wbc (mm/filemap.c:408 mm/filemap.c:397) 
file_write_and_wait_range (mm/filemap.c:440 mm/filemap.c:824) 
bch2_fsync (fs/bcachefs/fs-io.c:2419) bcachefs
do_fsync (./include/linux/file.h:45 fs/sync.c:207) 
__x64_sys_fdatasync (fs/sync.c:219 fs/sync.c:217 fs/sync.c:217) 
do_syscall_64 (arch/x86/entry/common.c:50 arch/x86/entry/common.c:80) 
entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:113) 
RIP: 0033:0x7f367975dc6d
RSP: 002b:00007f35c07fa560 EFLAGS: 00000293 ORIG_RAX: 000000000000004b
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f367975dc6d
RDX: 0000000000000001 RSI: 0000000000000000 RDI: 0000000000000009
RBP: 00007f35c07fa590 R08: 0000000000000800 R09: 000000105269934b
R10: 0000000000000019 R11: 0000000000000293 R12: 0000000000000009
R13: 0000000051eb851f R14: 00007f35cf2953f8 R15: 00000000000023fc
 </TASK>
INFO: task mysqld:18340 blocked for more than 122 seconds.
      Tainted: G        W         5.16.0+ #1
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:mysqld          state:D stack:    0 pid:18340 ppid: 17541 flags:0x00000000
Call Trace:
 <TASK>
__schedule (kernel/sched/core.c:4975 kernel/sched/core.c:6253) 
schedule (kernel/sched/core.c:6327 (discriminator 1)) 
schedule_timeout (kernel/time/timer.c:1858) 
? write_cache_pages (mm/page-writeback.c:2209) 
? bch2_truncate_pages (fs/bcachefs/fs-io.c:1361) bcachefs
__down (kernel/locking/semaphore.c:225 kernel/locking/semaphore.c:241) 
? preempt_count_add (./include/linux/ftrace.h:894 kernel/sched/core.c:5413 kernel/sched/core.c:5410 kernel/sched/core.c:5438) 
down (kernel/locking/semaphore.c:62) 
bch2_writepage_do_io.isra.70 (fs/bcachefs/fs-io.c:1321) bcachefs
bch2_writepages (fs/bcachefs/fs-io.c:1504) bcachefs
do_writepages (mm/page-writeback.c:2367) 
filemap_fdatawrite_wbc (mm/filemap.c:408 mm/filemap.c:397) 
file_write_and_wait_range (mm/filemap.c:440 mm/filemap.c:824) 
bch2_fsync (fs/bcachefs/fs-io.c:2419) bcachefs
do_fsync (./include/linux/file.h:45 fs/sync.c:207) 
__x64_sys_fdatasync (fs/sync.c:219 fs/sync.c:217 fs/sync.c:217) 
do_syscall_64 (arch/x86/entry/common.c:50 arch/x86/entry/common.c:80) 
entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:113) 
RIP: 0033:0x7f367975dc6d
RSP: 002b:00007f367aa357d0 EFLAGS: 00000293 ORIG_RAX: 000000000000004b
RAX: ffffffffffffffda RBX: 00007f35cf3e92f8 RCX: 00007f367975dc6d
RDX: 00007f367aa36a50 RSI: 0000000000000001 RDI: 000000000000002f
RBP: 00007f367aa35810 R08: 0000000000000000 R09: 00007f35cf3e8648
R10: 0000000000000001 R11: 0000000000000293 R12: 0000000000000000
R13: 000000000000002f R14: 0000000000000010 R15: 00007f35cf3e8000
 </TASK>
INFO: task mysqld:18387 blocked for more than 122 seconds.
      Tainted: G        W         5.16.0+ #1
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:mysqld          state:D stack:    0 pid:18387 ppid: 18206 flags:0x00004000
Call Trace:
 <TASK>
__schedule (kernel/sched/core.c:4975 kernel/sched/core.c:6253) 
schedule (kernel/sched/core.c:6327 (discriminator 1)) 
schedule_timeout (kernel/time/timer.c:1858) 
? __cond_resched (kernel/sched/core.c:8133) 
wait_for_completion (kernel/sched/completion.c:86 kernel/sched/completion.c:106 kernel/sched/completion.c:117 kernel/sched/completion.c:138) 
bch2_dio_write_loop (fs/bcachefs/fs-io.c:2207) bcachefs
bch2_direct_write (fs/bcachefs/fs-io.c:2340) bcachefs
new_sync_write (fs/read_write.c:504 (discriminator 1)) 
vfs_write (fs/read_write.c:590 fs/read_write.c:570) 
ksys_pwrite64 (./include/linux/file.h:45 fs/read_write.c:698) 
? syscall_trace_enter.isra.20 (./include/linux/audit.h:350 kernel/entry/common.c:40 kernel/entry/common.c:79) 
do_syscall_64 (arch/x86/entry/common.c:50 arch/x86/entry/common.c:80) 
entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:113) 
RIP: 0033:0x7f515a9b9023
RSP: 002b:00007f513dff4130 EFLAGS: 00000293 ORIG_RAX: 0000000000000012
RAX: ffffffffffffffda RBX: 00000000000e0000 RCX: 00007f515a9b9023
RDX: 00000000000e0000 RSI: 00007f513d6f4000 RDI: 0000000000000006
RBP: 00007f513dff4320 R08: 0000000000200000 R09: 00007f513dff4340
R10: 0000000000200000 R11: 0000000000000293 R12: 0000000000000000
R13: 00007f513d6f4000 R14: 00000000000e0000 R15: 0000000000200000
 </TASK>






WARNING: CPU: 0 PID: 24621 at fs/bcachefs/fs-io.c:1290 bch2_writepage_io_done (fs/bcachefs/fs-io.c:1290 (discriminator 1)) bcachefs
Modules linked in: bcachefs lz4_compress crc64 xor raid6_pq zstd_compress libcrc32c xt_comment iptable_filter binfmt_misc rfkill cirrus drm_kms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops drm pcspkr sg i2c_piix4 virtio_balloon floppy i2c_core ip_tables ext4 mbcache jbd2 sr_mod cdrom ata_generic pata_acpi ata_piix libata virtio_net net_failover failover serio_raw dm_mirror dm_region_hash dm_log dm_mod
CPU: 0 PID: 24621 Comm: kworker/0:0 Tainted: G        W         5.16.0+ #1
Hardware name: Red Hat KVM, BIOS 0.5.1 01/01/2011
Workqueue: bcachefs bch2_write_index [bcachefs]
RIP: 0010:bch2_writepage_io_done (fs/bcachefs/fs-io.c:1290 (discriminator 1)) bcachefs
Code: 80 64 24 28 f0 e8 58 6d 23 f6 0f b7 83 a0 03 00 00 44 39 f8 0f 8f 63 ff ff ff 48 8b b3 48 01 00 00 48 85 f6 0f 8e 82 fd ff ff <0f> 0b e9 7b fd ff ff 48 83 c5 40 b9 00 10 00 00 e9 bf fd ff ff 8b
All code
========
   0:	80 64 24 28 f0       	andb   $0xf0,0x28(%rsp)
   5:	e8 58 6d 23 f6       	callq  0xfffffffff6236d62
   a:	0f b7 83 a0 03 00 00 	movzwl 0x3a0(%rbx),%eax
  11:	44 39 f8             	cmp    %r15d,%eax
  14:	0f 8f 63 ff ff ff    	jg     0xffffffffffffff7d
  1a:	48 8b b3 48 01 00 00 	mov    0x148(%rbx),%rsi
  21:	48 85 f6             	test   %rsi,%rsi
  24:	0f 8e 82 fd ff ff    	jle    0xfffffffffffffdac
  2a:*	0f 0b                	ud2    		<-- trapping instruction
  2c:	e9 7b fd ff ff       	jmpq   0xfffffffffffffdac
  31:	48 83 c5 40          	add    $0x40,%rbp
  35:	b9 00 10 00 00       	mov    $0x1000,%ecx
  3a:	e9 bf fd ff ff       	jmpq   0xfffffffffffffdfe
  3f:	8b                   	.byte 0x8b

Code starting with the faulting instruction
===========================================
   0:	0f 0b                	ud2    
   2:	e9 7b fd ff ff       	jmpq   0xfffffffffffffd82
   7:	48 83 c5 40          	add    $0x40,%rbp
   b:	b9 00 10 00 00       	mov    $0x1000,%ecx
  10:	e9 bf fd ff ff       	jmpq   0xfffffffffffffdd4
  15:	8b                   	.byte 0x8b
RSP: 0018:ffffa6c447f2fe68 EFLAGS: 00010202
RAX: 0000000080000000 RBX: ffff8c2cc469e000 RCX: 0000000000000001
RDX: 0000000080000001 RSI: 0000000000000008 RDI: 00000000ffffffff
RBP: ffff8c2cc46f2540 R08: 0000000000047670 R09: 0000000000000001
R10: 0000000000000000 R11: 00000000ffffffff R12: ffffc6c43fc08f00
R13: 0000000000000020 R14: ffff8c2d7ca2ee00 R15: ffffc6c43fc08f05
FS:  0000000000000000(0000) GS:ffff8c2d7ca00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00000000020f8000 CR3: 000000003f6e2000 CR4: 00000000000006f0
Call Trace:
 <TASK>
process_one_work (./arch/x86/include/asm/jump_label.h:27 ./include/linux/jump_label.h:212 ./include/trace/events/workqueue.h:108 kernel/workqueue.c:2303) 
worker_thread (./include/linux/list.h:284 kernel/workqueue.c:2446) 
? process_one_work (kernel/workqueue.c:2388) 
kthread (kernel/kthread.c:327) 
? set_kthread_struct (kernel/kthread.c:272) 
ret_from_fork (arch/x86/entry/entry_64.S:301) 
 </TASK>
---[ end trace ae1f1e0405dedf16 ]---
------------[ cut here ]------------
WARNING: CPU: 0 PID: 21693 at fs/bcachefs/fs-io.c:1290 bch2_writepage_io_done (fs/bcachefs/fs-io.c:1290 (discriminator 1)) bcachefs
Modules linked in: bcachefs lz4_compress crc64 xor raid6_pq zstd_compress libcrc32c xt_comment iptable_filter binfmt_misc rfkill cirrus drm_kms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops drm pcspkr sg i2c_piix4 virtio_balloon floppy i2c_core ip_tables ext4 mbcache jbd2 sr_mod cdrom ata_generic pata_acpi ata_piix libata virtio_net net_failover failover serio_raw dm_mirror dm_region_hash dm_log dm_mod
CPU: 0 PID: 21693 Comm: kworker/0:3 Tainted: G        W         5.16.0+ #1
Hardware name: Red Hat KVM, BIOS 0.5.1 01/01/2011
Workqueue: bcachefs bch2_write_index [bcachefs]
RIP: 0010:bch2_writepage_io_done (fs/bcachefs/fs-io.c:1290 (discriminator 1)) bcachefs
Code: 80 64 24 28 f0 e8 58 6d 23 f6 0f b7 83 a0 03 00 00 44 39 f8 0f 8f 63 ff ff ff 48 8b b3 48 01 00 00 48 85 f6 0f 8e 82 fd ff ff <0f> 0b e9 7b fd ff ff 48 83 c5 40 b9 00 10 00 00 e9 bf fd ff ff 8b
All code
========
   0:	80 64 24 28 f0       	andb   $0xf0,0x28(%rsp)
   5:	e8 58 6d 23 f6       	callq  0xfffffffff6236d62
   a:	0f b7 83 a0 03 00 00 	movzwl 0x3a0(%rbx),%eax
  11:	44 39 f8             	cmp    %r15d,%eax
  14:	0f 8f 63 ff ff ff    	jg     0xffffffffffffff7d
  1a:	48 8b b3 48 01 00 00 	mov    0x148(%rbx),%rsi
  21:	48 85 f6             	test   %rsi,%rsi
  24:	0f 8e 82 fd ff ff    	jle    0xfffffffffffffdac
  2a:*	0f 0b                	ud2    		<-- trapping instruction
  2c:	e9 7b fd ff ff       	jmpq   0xfffffffffffffdac
  31:	48 83 c5 40          	add    $0x40,%rbp
  35:	b9 00 10 00 00       	mov    $0x1000,%ecx
  3a:	e9 bf fd ff ff       	jmpq   0xfffffffffffffdfe
  3f:	8b                   	.byte 0x8b

Code starting with the faulting instruction
===========================================
   0:	0f 0b                	ud2    
   2:	e9 7b fd ff ff       	jmpq   0xfffffffffffffd82
   7:	48 83 c5 40          	add    $0x40,%rbp
   b:	b9 00 10 00 00       	mov    $0x1000,%ecx
  10:	e9 bf fd ff ff       	jmpq   0xfffffffffffffdd4
  15:	8b                   	.byte 0x8b
RSP: 0018:ffffa6c445b97e68 EFLAGS: 00010202
RAX: 0000000080000000 RBX: ffff8c2cff0b7c00 RCX: 0000000000000001
RDX: 0000000080000001 RSI: 0000000000000020 RDI: 00000000ffffffff
RBP: ffff8c2cc46f20c0 R08: 000000000007e0fa R09: 0000000000000000
R10: 0000000000000000 R11: 00000000ffffffff R12: ffffc6c43fc08f00
R13: 0000000000000020 R14: ffff8c2d7ca2ee00 R15: ffffc6c43fc08f05
FS:  0000000000000000(0000) GS:ffff8c2d7ca00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f2eaff77148 CR3: 000000003f6e2000 CR4: 00000000000006f0
Call Trace:
 <TASK>
process_one_work (./arch/x86/include/asm/jump_label.h:27 ./include/linux/jump_label.h:212 ./include/trace/events/workqueue.h:108 kernel/workqueue.c:2303) 
worker_thread (./include/linux/list.h:284 kernel/workqueue.c:2446) 
? process_one_work (kernel/workqueue.c:2388) 
kthread (kernel/kthread.c:327) 
? set_kthread_struct (kernel/kthread.c:272) 
ret_from_fork (arch/x86/entry/entry_64.S:301) 
 </TASK>
---[ end trace ae1f1e0405dedf17 ]---
------------[ cut here ]------------
WARNING: CPU: 0 PID: 5734 at fs/bcachefs/fs-io.c:1290 bch2_writepage_io_done (fs/bcachefs/fs-io.c:1290 (discriminator 1)) bcachefs
Modules linked in: bcachefs lz4_compress crc64 xor raid6_pq zstd_compress libcrc32c xt_comment iptable_filter binfmt_misc rfkill cirrus drm_kms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops drm pcspkr sg i2c_piix4 virtio_balloon floppy i2c_core ip_tables ext4 mbcache jbd2 sr_mod cdrom ata_generic pata_acpi ata_piix libata virtio_net net_failover failover serio_raw dm_mirror dm_region_hash dm_log dm_mod
CPU: 0 PID: 5734 Comm: kworker/0:4 Tainted: G        W         5.16.0+ #1
Hardware name: Red Hat KVM, BIOS 0.5.1 01/01/2011
Workqueue: bcachefs bch2_write_index [bcachefs]
RIP: 0010:bch2_writepage_io_done (fs/bcachefs/fs-io.c:1290 (discriminator 1)) bcachefs
Code: 80 64 24 28 f0 e8 58 6d 23 f6 0f b7 83 a0 03 00 00 44 39 f8 0f 8f 63 ff ff ff 48 8b b3 48 01 00 00 48 85 f6 0f 8e 82 fd ff ff <0f> 0b e9 7b fd ff ff 48 83 c5 40 b9 00 10 00 00 e9 bf fd ff ff 8b
All code
========
   0:	80 64 24 28 f0       	andb   $0xf0,0x28(%rsp)
   5:	e8 58 6d 23 f6       	callq  0xfffffffff6236d62
   a:	0f b7 83 a0 03 00 00 	movzwl 0x3a0(%rbx),%eax
  11:	44 39 f8             	cmp    %r15d,%eax
  14:	0f 8f 63 ff ff ff    	jg     0xffffffffffffff7d
  1a:	48 8b b3 48 01 00 00 	mov    0x148(%rbx),%rsi
  21:	48 85 f6             	test   %rsi,%rsi
  24:	0f 8e 82 fd ff ff    	jle    0xfffffffffffffdac
  2a:*	0f 0b                	ud2    		<-- trapping instruction
  2c:	e9 7b fd ff ff       	jmpq   0xfffffffffffffdac
  31:	48 83 c5 40          	add    $0x40,%rbp
  35:	b9 00 10 00 00       	mov    $0x1000,%ecx
  3a:	e9 bf fd ff ff       	jmpq   0xfffffffffffffdfe
  3f:	8b                   	.byte 0x8b

Code starting with the faulting instruction
===========================================
   0:	0f 0b                	ud2    
   2:	e9 7b fd ff ff       	jmpq   0xfffffffffffffd82
   7:	48 83 c5 40          	add    $0x40,%rbp
   b:	b9 00 10 00 00       	mov    $0x1000,%ecx
  10:	e9 bf fd ff ff       	jmpq   0xfffffffffffffdd4
  15:	8b                   	.byte 0x8b
RSP: 0018:ffffa6c440fbbe68 EFLAGS: 00010202
RAX: 0000000080000000 RBX: ffff8c2cff1b2800 RCX: 0000000000000001
RDX: 0000000080000001 RSI: 0000000000000020 RDI: 00000000ffffffff
RBP: ffff8c2cc46f2f00 R08: 000000000007e340 R09: 0000000000000000
R10: 0000000000000000 R11: 00000000ffffffff R12: ffffc6c43fc08f00
R13: 0000000000000020 R14: ffff8c2d7ca2ee00 R15: ffffc6c43fc08f05
FS:  0000000000000000(0000) GS:ffff8c2d7ca00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fd3c6b36000 CR3: 000000003f6e2000 CR4: 00000000000006f0
Call Trace:
 <TASK>
process_one_work (./arch/x86/include/asm/jump_label.h:27 ./include/linux/jump_label.h:212 ./include/trace/events/workqueue.h:108 kernel/workqueue.c:2303) 
worker_thread (./include/linux/list.h:284 kernel/workqueue.c:2446) 
? process_one_work (kernel/workqueue.c:2388) 
kthread (kernel/kthread.c:327) 
? set_kthread_struct (kernel/kthread.c:272) 
ret_from_fork (arch/x86/entry/entry_64.S:301) 
 </TASK>
---[ end trace ae1f1e0405dedf18 ]---
------------[ cut here ]------------
WARNING: CPU: 0 PID: 21693 at fs/bcachefs/fs-io.c:1290 bch2_writepage_io_done (fs/bcachefs/fs-io.c:1290 (discriminator 1)) bcachefs
Modules linked in: bcachefs lz4_compress crc64 xor raid6_pq zstd_compress libcrc32c xt_comment iptable_filter binfmt_misc rfkill cirrus drm_kms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops drm pcspkr sg i2c_piix4 virtio_balloon floppy i2c_core ip_tables ext4 mbcache jbd2 sr_mod cdrom ata_generic pata_acpi ata_piix libata virtio_net net_failover failover serio_raw dm_mirror dm_region_hash dm_log dm_mod
CPU: 0 PID: 21693 Comm: kworker/0:3 Tainted: G        W         5.16.0+ #1
Hardware name: Red Hat KVM, BIOS 0.5.1 01/01/2011
Workqueue: bcachefs bch2_write_index [bcachefs]
RIP: 0010:bch2_writepage_io_done (fs/bcachefs/fs-io.c:1290 (discriminator 1)) bcachefs
Code: 80 64 24 28 f0 e8 58 6d 23 f6 0f b7 83 a0 03 00 00 44 39 f8 0f 8f 63 ff ff ff 48 8b b3 48 01 00 00 48 85 f6 0f 8e 82 fd ff ff <0f> 0b e9 7b fd ff ff 48 83 c5 40 b9 00 10 00 00 e9 bf fd ff ff 8b
All code
========
   0:	80 64 24 28 f0       	andb   $0xf0,0x28(%rsp)
   5:	e8 58 6d 23 f6       	callq  0xfffffffff6236d62
   a:	0f b7 83 a0 03 00 00 	movzwl 0x3a0(%rbx),%eax
  11:	44 39 f8             	cmp    %r15d,%eax
  14:	0f 8f 63 ff ff ff    	jg     0xffffffffffffff7d
  1a:	48 8b b3 48 01 00 00 	mov    0x148(%rbx),%rsi
  21:	48 85 f6             	test   %rsi,%rsi
  24:	0f 8e 82 fd ff ff    	jle    0xfffffffffffffdac
  2a:*	0f 0b                	ud2    		<-- trapping instruction
  2c:	e9 7b fd ff ff       	jmpq   0xfffffffffffffdac
  31:	48 83 c5 40          	add    $0x40,%rbp
  35:	b9 00 10 00 00       	mov    $0x1000,%ecx
  3a:	e9 bf fd ff ff       	jmpq   0xfffffffffffffdfe
  3f:	8b                   	.byte 0x8b

Code starting with the faulting instruction
===========================================
   0:	0f 0b                	ud2    
   2:	e9 7b fd ff ff       	jmpq   0xfffffffffffffd82
   7:	48 83 c5 40          	add    $0x40,%rbp
   b:	b9 00 10 00 00       	mov    $0x1000,%ecx
  10:	e9 bf fd ff ff       	jmpq   0xfffffffffffffdd4
  15:	8b                   	.byte 0x8b
RSP: 0018:ffffa6c445b97e68 EFLAGS: 00010202
RAX: 0000000080000000 RBX: ffff8c2cff1b2c00 RCX: 0000000000000001
RDX: 0000000080000001 RSI: 0000000000000020 RDI: 00000000ffffffff
RBP: ffff8c2cc46f20c0 R08: 000000000007e33f R09: 0000000000000000
R10: 0000000000000000 R11: 00000000ffffffff R12: ffffc6c43fc08f00
R13: 0000000000000020 R14: ffff8c2d7ca2ee00 R15: ffffc6c43fc08f05
FS:  0000000000000000(0000) GS:ffff8c2d7ca00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fd3c6b36000 CR3: 000000003f6e2000 CR4: 00000000000006f0
Call Trace:
 <TASK>
process_one_work (./arch/x86/include/asm/jump_label.h:27 ./include/linux/jump_label.h:212 ./include/trace/events/workqueue.h:108 kernel/workqueue.c:2303) 
worker_thread (./include/linux/list.h:284 kernel/workqueue.c:2446) 
? process_one_work (kernel/workqueue.c:2388) 
kthread (kernel/kthread.c:327) 
? set_kthread_struct (kernel/kthread.c:272) 
ret_from_fork (arch/x86/entry/entry_64.S:301) 
 </TASK>
---[ end trace ae1f1e0405dedf19 ]---
------------[ cut here ]------------
WARNING: CPU: 1 PID: 16837 at fs/bcachefs/fs-io.c:1290 bch2_writepage_io_done (fs/bcachefs/fs-io.c:1290 (discriminator 1)) bcachefs
Modules linked in: bcachefs lz4_compress crc64 xor raid6_pq zstd_compress libcrc32c xt_comment iptable_filter binfmt_misc rfkill cirrus drm_kms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops drm pcspkr sg i2c_piix4 virtio_balloon floppy i2c_core ip_tables ext4 mbcache jbd2 sr_mod cdrom ata_generic pata_acpi ata_piix libata virtio_net net_failover failover serio_raw dm_mirror dm_region_hash dm_log dm_mod
CPU: 1 PID: 16837 Comm: kworker/1:0 Tainted: G        W         5.16.0+ #1
Hardware name: Red Hat KVM, BIOS 0.5.1 01/01/2011
Workqueue: bcachefs bch2_write_index [bcachefs]
RIP: 0010:bch2_writepage_io_done (fs/bcachefs/fs-io.c:1290 (discriminator 1)) bcachefs
Code: 80 64 24 28 f0 e8 58 6d 23 f6 0f b7 83 a0 03 00 00 44 39 f8 0f 8f 63 ff ff ff 48 8b b3 48 01 00 00 48 85 f6 0f 8e 82 fd ff ff <0f> 0b e9 7b fd ff ff 48 83 c5 40 b9 00 10 00 00 e9 bf fd ff ff 8b
All code
========
   0:	80 64 24 28 f0       	andb   $0xf0,0x28(%rsp)
   5:	e8 58 6d 23 f6       	callq  0xfffffffff6236d62
   a:	0f b7 83 a0 03 00 00 	movzwl 0x3a0(%rbx),%eax
  11:	44 39 f8             	cmp    %r15d,%eax
  14:	0f 8f 63 ff ff ff    	jg     0xffffffffffffff7d
  1a:	48 8b b3 48 01 00 00 	mov    0x148(%rbx),%rsi
  21:	48 85 f6             	test   %rsi,%rsi
  24:	0f 8e 82 fd ff ff    	jle    0xfffffffffffffdac
  2a:*	0f 0b                	ud2    		<-- trapping instruction
  2c:	e9 7b fd ff ff       	jmpq   0xfffffffffffffdac
  31:	48 83 c5 40          	add    $0x40,%rbp
  35:	b9 00 10 00 00       	mov    $0x1000,%ecx
  3a:	e9 bf fd ff ff       	jmpq   0xfffffffffffffdfe
  3f:	8b                   	.byte 0x8b

Code starting with the faulting instruction
===========================================
   0:	0f 0b                	ud2    
   2:	e9 7b fd ff ff       	jmpq   0xfffffffffffffd82
   7:	48 83 c5 40          	add    $0x40,%rbp
   b:	b9 00 10 00 00       	mov    $0x1000,%ecx
  10:	e9 bf fd ff ff       	jmpq   0xfffffffffffffdd4
  15:	8b                   	.byte 0x8b
RSP: 0018:ffffa6c441aa3e68 EFLAGS: 00010202
RAX: 0000000080000000 RBX: ffff8c2cc8773400 RCX: 0000000000000001
RDX: 0000000080000001 RSI: 0000000000000020 RDI: 00000000ffffffff
RBP: ffff8c2cc83d7e40 R08: 000000000007e6c0 R09: 0000000000000000
R10: 0000000000000000 R11: 00000000ffffffff R12: ffffc6c43fd08f00
R13: 0000000000000020 R14: ffff8c2d7cb2ee00 R15: ffffc6c43fd08f05
FS:  0000000000000000(0000) GS:ffff8c2d7cb00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f2eaff77148 CR3: 000000003db44000 CR4: 00000000000006e0
Call Trace:
 <TASK>
process_one_work (./arch/x86/include/asm/jump_label.h:27 ./include/linux/jump_label.h:212 ./include/trace/events/workqueue.h:108 kernel/workqueue.c:2303) 
worker_thread (./include/linux/list.h:284 kernel/workqueue.c:2446) 
? process_one_work (kernel/workqueue.c:2388) 
kthread (kernel/kthread.c:327) 
? set_kthread_struct (kernel/kthread.c:272) 
ret_from_fork (arch/x86/entry/entry_64.S:301) 
 </TASK>
---[ end trace ae1f1e0405dedf1a ]---
------------[ cut here ]------------
WARNING: CPU: 1 PID: 16837 at fs/bcachefs/fs-io.c:1290 bch2_writepage_io_done (fs/bcachefs/fs-io.c:1290 (discriminator 1)) bcachefs
Modules linked in: bcachefs lz4_compress crc64 xor raid6_pq zstd_compress libcrc32c xt_comment iptable_filter binfmt_misc rfkill cirrus drm_kms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops drm pcspkr sg i2c_piix4 virtio_balloon floppy i2c_core ip_tables ext4 mbcache jbd2 sr_mod cdrom ata_generic pata_acpi ata_piix libata virtio_net net_failover failover serio_raw dm_mirror dm_region_hash dm_log dm_mod
CPU: 1 PID: 16837 Comm: kworker/1:0 Tainted: G        W         5.16.0+ #1
Hardware name: Red Hat KVM, BIOS 0.5.1 01/01/2011
Workqueue: bcachefs bch2_write_index [bcachefs]
RIP: 0010:bch2_writepage_io_done (fs/bcachefs/fs-io.c:1290 (discriminator 1)) bcachefs
Code: 80 64 24 28 f0 e8 58 6d 23 f6 0f b7 83 a0 03 00 00 44 39 f8 0f 8f 63 ff ff ff 48 8b b3 48 01 00 00 48 85 f6 0f 8e 82 fd ff ff <0f> 0b e9 7b fd ff ff 48 83 c5 40 b9 00 10 00 00 e9 bf fd ff ff 8b
All code
========
   0:	80 64 24 28 f0       	andb   $0xf0,0x28(%rsp)
   5:	e8 58 6d 23 f6       	callq  0xfffffffff6236d62
   a:	0f b7 83 a0 03 00 00 	movzwl 0x3a0(%rbx),%eax
  11:	44 39 f8             	cmp    %r15d,%eax
  14:	0f 8f 63 ff ff ff    	jg     0xffffffffffffff7d
  1a:	48 8b b3 48 01 00 00 	mov    0x148(%rbx),%rsi
  21:	48 85 f6             	test   %rsi,%rsi
  24:	0f 8e 82 fd ff ff    	jle    0xfffffffffffffdac
  2a:*	0f 0b                	ud2    		<-- trapping instruction
  2c:	e9 7b fd ff ff       	jmpq   0xfffffffffffffdac
  31:	48 83 c5 40          	add    $0x40,%rbp
  35:	b9 00 10 00 00       	mov    $0x1000,%ecx
  3a:	e9 bf fd ff ff       	jmpq   0xfffffffffffffdfe
  3f:	8b                   	.byte 0x8b

Code starting with the faulting instruction
===========================================
   0:	0f 0b                	ud2    
   2:	e9 7b fd ff ff       	jmpq   0xfffffffffffffd82
   7:	48 83 c5 40          	add    $0x40,%rbp
   b:	b9 00 10 00 00       	mov    $0x1000,%ecx
  10:	e9 bf fd ff ff       	jmpq   0xfffffffffffffdd4
  15:	8b                   	.byte 0x8b
RSP: 0018:ffffa6c441aa3e68 EFLAGS: 00010202
RAX: 0000000080000000 RBX: ffff8c2cc86f2400 RCX: 0000000000000001
RDX: 0000000080000001 RSI: 0000000000000008 RDI: 00000000ffffffff
RBP: ffff8c2cc83d7e40 R08: 000000000007e874 R09: 0000000000000000
R10: 0000000000000000 R11: 00000000ffffffff R12: ffffc6c43fd08f00
R13: 0000000000000020 R14: ffff8c2d7cb2ee00 R15: ffffc6c43fd08f05
FS:  0000000000000000(0000) GS:ffff8c2d7cb00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f0e91d94006 CR3: 000000003f6e2000 CR4: 00000000000006e0
Call Trace:
 <TASK>
process_one_work (./arch/x86/include/asm/jump_label.h:27 ./include/linux/jump_label.h:212 ./include/trace/events/workqueue.h:108 kernel/workqueue.c:2303) 
worker_thread (./include/linux/list.h:284 kernel/workqueue.c:2446) 
? process_one_work (kernel/workqueue.c:2388) 
kthread (kernel/kthread.c:327) 
? set_kthread_struct (kernel/kthread.c:272) 
ret_from_fork (arch/x86/entry/entry_64.S:301) 
 </TASK>
---[ end trace ae1f1e0405dedf1b ]---
------------[ cut here ]------------
WARNING: CPU: 1 PID: 29215 at fs/bcachefs/fs-io.c:1290 bch2_writepage_io_done (fs/bcachefs/fs-io.c:1290 (discriminator 1)) bcachefs
Modules linked in: bcachefs lz4_compress crc64 xor raid6_pq zstd_compress libcrc32c xt_comment iptable_filter binfmt_misc rfkill cirrus drm_kms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops drm pcspkr sg i2c_piix4 virtio_balloon floppy i2c_core ip_tables ext4 mbcache jbd2 sr_mod cdrom ata_generic pata_acpi ata_piix libata virtio_net net_failover failover serio_raw dm_mirror dm_region_hash dm_log dm_mod
CPU: 1 PID: 29215 Comm: kworker/1:2 Tainted: G        W         5.16.0+ #1
Hardware name: Red Hat KVM, BIOS 0.5.1 01/01/2011
Workqueue: bcachefs bch2_write_index [bcachefs]
RIP: 0010:bch2_writepage_io_done (fs/bcachefs/fs-io.c:1290 (discriminator 1)) bcachefs
Code: 80 64 24 28 f0 e8 58 6d 23 f6 0f b7 83 a0 03 00 00 44 39 f8 0f 8f 63 ff ff ff 48 8b b3 48 01 00 00 48 85 f6 0f 8e 82 fd ff ff <0f> 0b e9 7b fd ff ff 48 83 c5 40 b9 00 10 00 00 e9 bf fd ff ff 8b
All code
========
   0:	80 64 24 28 f0       	andb   $0xf0,0x28(%rsp)
   5:	e8 58 6d 23 f6       	callq  0xfffffffff6236d62
   a:	0f b7 83 a0 03 00 00 	movzwl 0x3a0(%rbx),%eax
  11:	44 39 f8             	cmp    %r15d,%eax
  14:	0f 8f 63 ff ff ff    	jg     0xffffffffffffff7d
  1a:	48 8b b3 48 01 00 00 	mov    0x148(%rbx),%rsi
  21:	48 85 f6             	test   %rsi,%rsi
  24:	0f 8e 82 fd ff ff    	jle    0xfffffffffffffdac
  2a:*	0f 0b                	ud2    		<-- trapping instruction
  2c:	e9 7b fd ff ff       	jmpq   0xfffffffffffffdac
  31:	48 83 c5 40          	add    $0x40,%rbp
  35:	b9 00 10 00 00       	mov    $0x1000,%ecx
  3a:	e9 bf fd ff ff       	jmpq   0xfffffffffffffdfe
  3f:	8b                   	.byte 0x8b

Code starting with the faulting instruction
===========================================
   0:	0f 0b                	ud2    
   2:	e9 7b fd ff ff       	jmpq   0xfffffffffffffd82
   7:	48 83 c5 40          	add    $0x40,%rbp
   b:	b9 00 10 00 00       	mov    $0x1000,%ecx
  10:	e9 bf fd ff ff       	jmpq   0xfffffffffffffdd4
  15:	8b                   	.byte 0x8b
RSP: 0018:ffffa6c4414bbe68 EFLAGS: 00010202
RAX: 0000000080000000 RBX: ffff8c2cc86f2400 RCX: 0000000000000001
RDX: 0000000080000001 RSI: 0000000000000020 RDI: 00000000ffffffff
RBP: ffff8c2cc11b66c0 R08: 000000000007ec72 R09: 0000000000000000
R10: 0000000000000000 R11: 00000000ffffffff R12: ffffc6c43fd08f00
R13: 0000000000000020 R14: ffff8c2d7cb2ee00 R15: ffffc6c43fd08f05
FS:  0000000000000000(0000) GS:ffff8c2d7cb00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00000000020f8000 CR3: 000000003f6e2000 CR4: 00000000000006e0
Call Trace:
 <TASK>
process_one_work (./arch/x86/include/asm/jump_label.h:27 ./include/linux/jump_label.h:212 ./include/trace/events/workqueue.h:108 kernel/workqueue.c:2303) 
worker_thread (./include/linux/list.h:284 kernel/workqueue.c:2446) 
? process_one_work (kernel/workqueue.c:2388) 
kthread (kernel/kthread.c:327) 
? set_kthread_struct (kernel/kthread.c:272) 
ret_from_fork (arch/x86/entry/entry_64.S:301) 
 </TASK>
---[ end trace ae1f1e0405dedf1c ]---
------------[ cut here ]------------
WARNING: CPU: 0 PID: 21693 at fs/bcachefs/fs-io.c:1290 bch2_writepage_io_done (fs/bcachefs/fs-io.c:1290 (discriminator 1)) bcachefs
Modules linked in: bcachefs lz4_compress crc64 xor raid6_pq zstd_compress libcrc32c xt_comment iptable_filter binfmt_misc rfkill cirrus drm_kms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops drm pcspkr sg i2c_piix4 virtio_balloon floppy i2c_core ip_tables ext4 mbcache jbd2 sr_mod cdrom ata_generic pata_acpi ata_piix libata virtio_net net_failover failover serio_raw dm_mirror dm_region_hash dm_log dm_mod
CPU: 0 PID: 21693 Comm: kworker/0:3 Tainted: G        W         5.16.0+ #1
Hardware name: Red Hat KVM, BIOS 0.5.1 01/01/2011
Workqueue: bcachefs bch2_write_index [bcachefs]
RIP: 0010:bch2_writepage_io_done (fs/bcachefs/fs-io.c:1290 (discriminator 1)) bcachefs
Code: 80 64 24 28 f0 e8 58 6d 23 f6 0f b7 83 a0 03 00 00 44 39 f8 0f 8f 63 ff ff ff 48 8b b3 48 01 00 00 48 85 f6 0f 8e 82 fd ff ff <0f> 0b e9 7b fd ff ff 48 83 c5 40 b9 00 10 00 00 e9 bf fd ff ff 8b
All code
========
   0:	80 64 24 28 f0       	andb   $0xf0,0x28(%rsp)
   5:	e8 58 6d 23 f6       	callq  0xfffffffff6236d62
   a:	0f b7 83 a0 03 00 00 	movzwl 0x3a0(%rbx),%eax
  11:	44 39 f8             	cmp    %r15d,%eax
  14:	0f 8f 63 ff ff ff    	jg     0xffffffffffffff7d
  1a:	48 8b b3 48 01 00 00 	mov    0x148(%rbx),%rsi
  21:	48 85 f6             	test   %rsi,%rsi
  24:	0f 8e 82 fd ff ff    	jle    0xfffffffffffffdac
  2a:*	0f 0b                	ud2    		<-- trapping instruction
  2c:	e9 7b fd ff ff       	jmpq   0xfffffffffffffdac
  31:	48 83 c5 40          	add    $0x40,%rbp
  35:	b9 00 10 00 00       	mov    $0x1000,%ecx
  3a:	e9 bf fd ff ff       	jmpq   0xfffffffffffffdfe
  3f:	8b                   	.byte 0x8b

Code starting with the faulting instruction
===========================================
   0:	0f 0b                	ud2    
   2:	e9 7b fd ff ff       	jmpq   0xfffffffffffffd82
   7:	48 83 c5 40          	add    $0x40,%rbp
   b:	b9 00 10 00 00       	mov    $0x1000,%ecx
  10:	e9 bf fd ff ff       	jmpq   0xfffffffffffffdd4
  15:	8b                   	.byte 0x8b
RSP: 0000:ffffa6c445b97e68 EFLAGS: 00010202
RAX: 0000000080000000 RBX: ffff8c2cc469cc00 RCX: 0000000000000001
RDX: 0000000080000001 RSI: 0000000000000008 RDI: 00000000ffffffff
RBP: ffff8c2cc46f20c0 R08: 000000000007ee28 R09: 0000000000000000
R10: 0000000000000000 R11: 00000000ffffffff R12: ffffc6c43fc08f00
R13: 0000000000000020 R14: ffff8c2d7ca2ee00 R15: ffffc6c43fc08f05
FS:  0000000000000000(0000) GS:ffff8c2d7ca00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00000000020f8000 CR3: 000000000868e000 CR4: 00000000000006f0
Call Trace:
 <TASK>
process_one_work (./arch/x86/include/asm/jump_label.h:27 ./include/linux/jump_label.h:212 ./include/trace/events/workqueue.h:108 kernel/workqueue.c:2303) 
worker_thread (./include/linux/list.h:284 kernel/workqueue.c:2446) 
? process_one_work (kernel/workqueue.c:2388) 
kthread (kernel/kthread.c:327) 
? set_kthread_struct (kernel/kthread.c:272) 
ret_from_fork (arch/x86/entry/entry_64.S:301) 
 </TASK>
---[ end trace ae1f1e0405dedf1d ]---
------------[ cut here ]------------
WARNING: CPU: 0 PID: 21693 at fs/bcachefs/fs-io.c:1290 bch2_writepage_io_done (fs/bcachefs/fs-io.c:1290 (discriminator 1)) bcachefs
Modules linked in: bcachefs lz4_compress crc64 xor raid6_pq zstd_compress libcrc32c xt_comment iptable_filter binfmt_misc rfkill cirrus drm_kms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops drm pcspkr sg i2c_piix4 virtio_balloon floppy i2c_core ip_tables ext4 mbcache jbd2 sr_mod cdrom ata_generic pata_acpi ata_piix libata virtio_net net_failover failover serio_raw dm_mirror dm_region_hash dm_log dm_mod
CPU: 0 PID: 21693 Comm: kworker/0:3 Tainted: G        W         5.16.0+ #1
Hardware name: Red Hat KVM, BIOS 0.5.1 01/01/2011
Workqueue: bcachefs bch2_write_index [bcachefs]
RIP: 0010:bch2_writepage_io_done (fs/bcachefs/fs-io.c:1290 (discriminator 1)) bcachefs
Code: 80 64 24 28 f0 e8 58 6d 23 f6 0f b7 83 a0 03 00 00 44 39 f8 0f 8f 63 ff ff ff 48 8b b3 48 01 00 00 48 85 f6 0f 8e 82 fd ff ff <0f> 0b e9 7b fd ff ff 48 83 c5 40 b9 00 10 00 00 e9 bf fd ff ff 8b
All code
========
   0:	80 64 24 28 f0       	andb   $0xf0,0x28(%rsp)
   5:	e8 58 6d 23 f6       	callq  0xfffffffff6236d62
   a:	0f b7 83 a0 03 00 00 	movzwl 0x3a0(%rbx),%eax
  11:	44 39 f8             	cmp    %r15d,%eax
  14:	0f 8f 63 ff ff ff    	jg     0xffffffffffffff7d
  1a:	48 8b b3 48 01 00 00 	mov    0x148(%rbx),%rsi
  21:	48 85 f6             	test   %rsi,%rsi
  24:	0f 8e 82 fd ff ff    	jle    0xfffffffffffffdac
  2a:*	0f 0b                	ud2    		<-- trapping instruction
  2c:	e9 7b fd ff ff       	jmpq   0xfffffffffffffdac
  31:	48 83 c5 40          	add    $0x40,%rbp
  35:	b9 00 10 00 00       	mov    $0x1000,%ecx
  3a:	e9 bf fd ff ff       	jmpq   0xfffffffffffffdfe
  3f:	8b                   	.byte 0x8b

Code starting with the faulting instruction
===========================================
   0:	0f 0b                	ud2    
   2:	e9 7b fd ff ff       	jmpq   0xfffffffffffffd82
   7:	48 83 c5 40          	add    $0x40,%rbp
   b:	b9 00 10 00 00       	mov    $0x1000,%ecx
  10:	e9 bf fd ff ff       	jmpq   0xfffffffffffffdd4
  15:	8b                   	.byte 0x8b
RSP: 0018:ffffa6c445b97e68 EFLAGS: 00010202
RAX: 0000000080000000 RBX: ffff8c2cc469e800 RCX: 0000000000000001
RDX: 0000000080000001 RSI: 0000000000000020 RDI: 00000000ffffffff
RBP: ffff8c2cc46f20c0 R08: 000000000007ef64 R09: 0000000000000000
R10: 0000000000000000 R11: 00000000ffffffff R12: ffffc6c43fc08f00
R13: 0000000000000020 R14: ffff8c2d7ca2ee00 R15: ffffc6c43fc08f05
FS:  0000000000000000(0000) GS:ffff8c2d7ca00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fc228173838 CR3: 000000003db44000 CR4: 00000000000006f0
Call Trace:
 <TASK>
process_one_work (./arch/x86/include/asm/jump_label.h:27 ./include/linux/jump_label.h:212 ./include/trace/events/workqueue.h:108 kernel/workqueue.c:2303) 
worker_thread (./include/linux/list.h:284 kernel/workqueue.c:2446) 
? process_one_work (kernel/workqueue.c:2388) 
kthread (kernel/kthread.c:327) 
? set_kthread_struct (kernel/kthread.c:272) 
ret_from_fork (arch/x86/entry/entry_64.S:301) 
 </TASK>
---[ end trace ae1f1e0405dedf1e ]---
------------[ cut here ]------------
WARNING: CPU: 1 PID: 16837 at fs/bcachefs/fs-io.c:1290 bch2_writepage_io_done (fs/bcachefs/fs-io.c:1290 (discriminator 1)) bcachefs
Modules linked in: bcachefs lz4_compress crc64 xor raid6_pq zstd_compress libcrc32c xt_comment iptable_filter binfmt_misc rfkill cirrus drm_kms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops drm pcspkr sg i2c_piix4 virtio_balloon floppy i2c_core ip_tables ext4 mbcache jbd2 sr_mod cdrom ata_generic pata_acpi ata_piix libata virtio_net net_failover failover serio_raw dm_mirror dm_region_hash dm_log dm_mod
CPU: 1 PID: 16837 Comm: kworker/1:0 Tainted: G        W         5.16.0+ #1
Hardware name: Red Hat KVM, BIOS 0.5.1 01/01/2011
Workqueue: bcachefs bch2_write_index [bcachefs]
RIP: 0010:bch2_writepage_io_done (fs/bcachefs/fs-io.c:1290 (discriminator 1)) bcachefs
Code: 80 64 24 28 f0 e8 58 6d 23 f6 0f b7 83 a0 03 00 00 44 39 f8 0f 8f 63 ff ff ff 48 8b b3 48 01 00 00 48 85 f6 0f 8e 82 fd ff ff <0f> 0b e9 7b fd ff ff 48 83 c5 40 b9 00 10 00 00 e9 bf fd ff ff 8b
All code
========
   0:	80 64 24 28 f0       	andb   $0xf0,0x28(%rsp)
   5:	e8 58 6d 23 f6       	callq  0xfffffffff6236d62
   a:	0f b7 83 a0 03 00 00 	movzwl 0x3a0(%rbx),%eax
  11:	44 39 f8             	cmp    %r15d,%eax
  14:	0f 8f 63 ff ff ff    	jg     0xffffffffffffff7d
  1a:	48 8b b3 48 01 00 00 	mov    0x148(%rbx),%rsi
  21:	48 85 f6             	test   %rsi,%rsi
  24:	0f 8e 82 fd ff ff    	jle    0xfffffffffffffdac
  2a:*	0f 0b                	ud2    		<-- trapping instruction
  2c:	e9 7b fd ff ff       	jmpq   0xfffffffffffffdac
  31:	48 83 c5 40          	add    $0x40,%rbp
  35:	b9 00 10 00 00       	mov    $0x1000,%ecx
  3a:	e9 bf fd ff ff       	jmpq   0xfffffffffffffdfe
  3f:	8b                   	.byte 0x8b

Code starting with the faulting instruction
===========================================
   0:	0f 0b                	ud2    
   2:	e9 7b fd ff ff       	jmpq   0xfffffffffffffd82
   7:	48 83 c5 40          	add    $0x40,%rbp
   b:	b9 00 10 00 00       	mov    $0x1000,%ecx
  10:	e9 bf fd ff ff       	jmpq   0xfffffffffffffdd4
  15:	8b                   	.byte 0x8b
RSP: 0018:ffffa6c441aa3e68 EFLAGS: 00010202
RAX: 0000000080000000 RBX: ffff8c2cc541d000 RCX: 0000000000000001
RDX: 0000000080000001 RSI: 0000000000000020 RDI: 00000000ffffffff
RBP: ffff8c2cc83d7e40 R08: 000000000007f72c R09: 0000000000000000
R10: 0000000000000000 R11: 00000000ffffffff R12: ffffc6c43fd08f00
R13: 0000000000000020 R14: ffff8c2d7cb2ee00 R15: ffffc6c43fd08f05
FS:  0000000000000000(0000) GS:ffff8c2d7cb00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f0e9210d006 CR3: 000000003db44000 CR4: 00000000000006e0
Call Trace:
 <TASK>
process_one_work (./arch/x86/include/asm/jump_label.h:27 ./include/linux/jump_label.h:212 ./include/trace/events/workqueue.h:108 kernel/workqueue.c:2303) 
worker_thread (./include/linux/list.h:284 kernel/workqueue.c:2446) 
? process_one_work (kernel/workqueue.c:2388) 
kthread (kernel/kthread.c:327) 
? set_kthread_struct (kernel/kthread.c:272) 
ret_from_fork (arch/x86/entry/entry_64.S:301) 
 </TASK>
---[ end trace ae1f1e0405dedf1f ]---
------------[ cut here ]------------
WARNING: CPU: 0 PID: 5699 at fs/bcachefs/fs-io.c:1290 bch2_writepage_io_done (fs/bcachefs/fs-io.c:1290 (discriminator 1)) bcachefs
Modules linked in: bcachefs lz4_compress crc64 xor raid6_pq zstd_compress libcrc32c xt_comment iptable_filter binfmt_misc rfkill cirrus drm_kms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops drm pcspkr sg i2c_piix4 virtio_balloon floppy i2c_core ip_tables ext4 mbcache jbd2 sr_mod cdrom ata_generic pata_acpi ata_piix libata virtio_net net_failover failover serio_raw dm_mirror dm_region_hash dm_log dm_mod
CPU: 0 PID: 5699 Comm: kworker/0:1 Tainted: G        W         5.16.0+ #1
Hardware name: Red Hat KVM, BIOS 0.5.1 01/01/2011
Workqueue: bcachefs bch2_write_index [bcachefs]
RIP: 0010:bch2_writepage_io_done (fs/bcachefs/fs-io.c:1290 (discriminator 1)) bcachefs
Code: 80 64 24 28 f0 e8 58 6d 23 f6 0f b7 83 a0 03 00 00 44 39 f8 0f 8f 63 ff ff ff 48 8b b3 48 01 00 00 48 85 f6 0f 8e 82 fd ff ff <0f> 0b e9 7b fd ff ff 48 83 c5 40 b9 00 10 00 00 e9 bf fd ff ff 8b
All code
========
   0:	80 64 24 28 f0       	andb   $0xf0,0x28(%rsp)
   5:	e8 58 6d 23 f6       	callq  0xfffffffff6236d62
   a:	0f b7 83 a0 03 00 00 	movzwl 0x3a0(%rbx),%eax
  11:	44 39 f8             	cmp    %r15d,%eax
  14:	0f 8f 63 ff ff ff    	jg     0xffffffffffffff7d
  1a:	48 8b b3 48 01 00 00 	mov    0x148(%rbx),%rsi
  21:	48 85 f6             	test   %rsi,%rsi
  24:	0f 8e 82 fd ff ff    	jle    0xfffffffffffffdac
  2a:*	0f 0b                	ud2    		<-- trapping instruction
  2c:	e9 7b fd ff ff       	jmpq   0xfffffffffffffdac
  31:	48 83 c5 40          	add    $0x40,%rbp
  35:	b9 00 10 00 00       	mov    $0x1000,%ecx
  3a:	e9 bf fd ff ff       	jmpq   0xfffffffffffffdfe
  3f:	8b                   	.byte 0x8b

Code starting with the faulting instruction
===========================================
   0:	0f 0b                	ud2    
   2:	e9 7b fd ff ff       	jmpq   0xfffffffffffffd82
   7:	48 83 c5 40          	add    $0x40,%rbp
   b:	b9 00 10 00 00       	mov    $0x1000,%ecx
  10:	e9 bf fd ff ff       	jmpq   0xfffffffffffffdd4
  15:	8b                   	.byte 0x8b
RSP: 0000:ffffa6c440f13e68 EFLAGS: 00010202
RAX: 0000000080000000 RBX: ffff8c2cc6941800 RCX: 0000000000000001
RDX: 0000000080000001 RSI: 0000000000000020 RDI: 00000000ffffffff
RBP: ffff8c2cc83d7d80 R08: 000000000007f814 R09: 0000000000000000
R10: 0000000000000000 R11: 00000000ffffffff R12: ffffc6c43fc08f00
R13: 0000000000000020 R14: ffff8c2d7ca2ee00 R15: ffffc6c43fc08f05
FS:  0000000000000000(0000) GS:ffff8c2d7ca00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f1b3f9bf8c0 CR3: 000000003db44000 CR4: 00000000000006f0
Call Trace:
 <TASK>
process_one_work (./arch/x86/include/asm/jump_label.h:27 ./include/linux/jump_label.h:212 ./include/trace/events/workqueue.h:108 kernel/workqueue.c:2303) 
worker_thread (./include/linux/list.h:284 kernel/workqueue.c:2446) 
? process_one_work (kernel/workqueue.c:2388) 
kthread (kernel/kthread.c:327) 
? set_kthread_struct (kernel/kthread.c:272) 
ret_from_fork (arch/x86/entry/entry_64.S:301) 
 </TASK>
---[ end trace ae1f1e0405dedf20 ]---
------------[ cut here ]------------
WARNING: CPU: 0 PID: 5699 at fs/bcachefs/fs-io.c:1290 bch2_writepage_io_done (fs/bcachefs/fs-io.c:1290 (discriminator 1)) bcachefs
Modules linked in: bcachefs lz4_compress crc64 xor raid6_pq zstd_compress libcrc32c xt_comment iptable_filter binfmt_misc rfkill cirrus drm_kms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops drm pcspkr sg i2c_piix4 virtio_balloon floppy i2c_core ip_tables ext4 mbcache jbd2 sr_mod cdrom ata_generic pata_acpi ata_piix libata virtio_net net_failover failover serio_raw dm_mirror dm_region_hash dm_log dm_mod
CPU: 0 PID: 5699 Comm: kworker/0:1 Tainted: G        W         5.16.0+ #1
Hardware name: Red Hat KVM, BIOS 0.5.1 01/01/2011
Workqueue: bcachefs bch2_write_index [bcachefs]
RIP: 0010:bch2_writepage_io_done (fs/bcachefs/fs-io.c:1290 (discriminator 1)) bcachefs
Code: 80 64 24 28 f0 e8 58 6d 23 f6 0f b7 83 a0 03 00 00 44 39 f8 0f 8f 63 ff ff ff 48 8b b3 48 01 00 00 48 85 f6 0f 8e 82 fd ff ff <0f> 0b e9 7b fd ff ff 48 83 c5 40 b9 00 10 00 00 e9 bf fd ff ff 8b
All code
========
   0:	80 64 24 28 f0       	andb   $0xf0,0x28(%rsp)
   5:	e8 58 6d 23 f6       	callq  0xfffffffff6236d62
   a:	0f b7 83 a0 03 00 00 	movzwl 0x3a0(%rbx),%eax
  11:	44 39 f8             	cmp    %r15d,%eax
  14:	0f 8f 63 ff ff ff    	jg     0xffffffffffffff7d
  1a:	48 8b b3 48 01 00 00 	mov    0x148(%rbx),%rsi
  21:	48 85 f6             	test   %rsi,%rsi
  24:	0f 8e 82 fd ff ff    	jle    0xfffffffffffffdac
  2a:*	0f 0b                	ud2    		<-- trapping instruction
  2c:	e9 7b fd ff ff       	jmpq   0xfffffffffffffdac
  31:	48 83 c5 40          	add    $0x40,%rbp
  35:	b9 00 10 00 00       	mov    $0x1000,%ecx
  3a:	e9 bf fd ff ff       	jmpq   0xfffffffffffffdfe
  3f:	8b                   	.byte 0x8b

Code starting with the faulting instruction
===========================================
   0:	0f 0b                	ud2    
   2:	e9 7b fd ff ff       	jmpq   0xfffffffffffffd82
   7:	48 83 c5 40          	add    $0x40,%rbp
   b:	b9 00 10 00 00       	mov    $0x1000,%ecx
  10:	e9 bf fd ff ff       	jmpq   0xfffffffffffffdd4
  15:	8b                   	.byte 0x8b
RSP: 0000:ffffa6c440f13e68 EFLAGS: 00010202
RAX: 0000000080000000 RBX: ffff8c2cc6943400 RCX: 0000000000000001
RDX: 0000000080000001 RSI: 0000000000000020 RDI: 00000000ffffffff
RBP: ffff8c2cc83d7d80 R08: 000000000007f886 R09: 0000000000000000
R10: 0000000000000000 R11: 00000000ffffffff R12: ffffc6c43fc08f00
R13: 0000000000000020 R14: ffff8c2d7ca2ee00 R15: ffffc6c43fc08f05
FS:  0000000000000000(0000) GS:ffff8c2d7ca00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f366f93c004 CR3: 000000003db44000 CR4: 00000000000006f0
Call Trace:
 <TASK>
process_one_work (./arch/x86/include/asm/jump_label.h:27 ./include/linux/jump_label.h:212 ./include/trace/events/workqueue.h:108 kernel/workqueue.c:2303) 
worker_thread (./include/linux/list.h:284 kernel/workqueue.c:2446) 
? process_one_work (kernel/workqueue.c:2388) 
kthread (kernel/kthread.c:327) 
? set_kthread_struct (kernel/kthread.c:272) 
ret_from_fork (arch/x86/entry/entry_64.S:301) 
 </TASK>
---[ end trace ae1f1e0405dedf21 ]---
------------[ cut here ]------------
WARNING: CPU: 1 PID: 29215 at fs/bcachefs/fs-io.c:1290 bch2_writepage_io_done (fs/bcachefs/fs-io.c:1290 (discriminator 1)) bcachefs
Modules linked in: bcachefs lz4_compress crc64 xor raid6_pq zstd_compress libcrc32c xt_comment iptable_filter binfmt_misc rfkill cirrus drm_kms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops drm pcspkr sg i2c_piix4 virtio_balloon floppy i2c_core ip_tables ext4 mbcache jbd2 sr_mod cdrom ata_generic pata_acpi ata_piix libata virtio_net net_failover failover serio_raw dm_mirror dm_region_hash dm_log dm_mod
CPU: 1 PID: 29215 Comm: kworker/1:2 Tainted: G        W         5.16.0+ #1
Hardware name: Red Hat KVM, BIOS 0.5.1 01/01/2011
Workqueue: bcachefs bch2_write_index [bcachefs]
RIP: 0010:bch2_writepage_io_done (fs/bcachefs/fs-io.c:1290 (discriminator 1)) bcachefs
Code: 80 64 24 28 f0 e8 58 6d 23 f6 0f b7 83 a0 03 00 00 44 39 f8 0f 8f 63 ff ff ff 48 8b b3 48 01 00 00 48 85 f6 0f 8e 82 fd ff ff <0f> 0b e9 7b fd ff ff 48 83 c5 40 b9 00 10 00 00 e9 bf fd ff ff 8b
All code
========
   0:	80 64 24 28 f0       	andb   $0xf0,0x28(%rsp)
   5:	e8 58 6d 23 f6       	callq  0xfffffffff6236d62
   a:	0f b7 83 a0 03 00 00 	movzwl 0x3a0(%rbx),%eax
  11:	44 39 f8             	cmp    %r15d,%eax
  14:	0f 8f 63 ff ff ff    	jg     0xffffffffffffff7d
  1a:	48 8b b3 48 01 00 00 	mov    0x148(%rbx),%rsi
  21:	48 85 f6             	test   %rsi,%rsi
  24:	0f 8e 82 fd ff ff    	jle    0xfffffffffffffdac
  2a:*	0f 0b                	ud2    		<-- trapping instruction
  2c:	e9 7b fd ff ff       	jmpq   0xfffffffffffffdac
  31:	48 83 c5 40          	add    $0x40,%rbp
  35:	b9 00 10 00 00       	mov    $0x1000,%ecx
  3a:	e9 bf fd ff ff       	jmpq   0xfffffffffffffdfe
  3f:	8b                   	.byte 0x8b

Code starting with the faulting instruction
===========================================
   0:	0f 0b                	ud2    
   2:	e9 7b fd ff ff       	jmpq   0xfffffffffffffd82
   7:	48 83 c5 40          	add    $0x40,%rbp
   b:	b9 00 10 00 00       	mov    $0x1000,%ecx
  10:	e9 bf fd ff ff       	jmpq   0xfffffffffffffdd4
  15:	8b                   	.byte 0x8b
RSP: 0018:ffffa6c4414bbe68 EFLAGS: 00010202
RAX: 0000000080000000 RBX: ffff8c2cc469dc00 RCX: 0000000000000001
RDX: 0000000080000001 RSI: 0000000000000020 RDI: 00000000ffffffff
RBP: ffff8c2cc11b66c0 R08: 000000000007f977 R09: 0000000000000000
R10: 0000000000000000 R11: 00000000ffffffff R12: ffffc6c43fd08f00
R13: 0000000000000020 R14: ffff8c2d7cb2ee00 R15: ffffc6c43fd08f05
FS:  0000000000000000(0000) GS:ffff8c2d7cb00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f0e924e8006 CR3: 0000000005318000 CR4: 00000000000006e0
Call Trace:
 <TASK>
process_one_work (./arch/x86/include/asm/jump_label.h:27 ./include/linux/jump_label.h:212 ./include/trace/events/workqueue.h:108 kernel/workqueue.c:2303) 
worker_thread (./include/linux/list.h:284 kernel/workqueue.c:2446) 
? process_one_work (kernel/workqueue.c:2388) 
kthread (kernel/kthread.c:327) 
? set_kthread_struct (kernel/kthread.c:272) 
ret_from_fork (arch/x86/entry/entry_64.S:301) 
 </TASK>
---[ end trace ae1f1e0405dedf22 ]---
------------[ cut here ]------------
WARNING: CPU: 1 PID: 29215 at fs/bcachefs/fs-io.c:1290 bch2_writepage_io_done (fs/bcachefs/fs-io.c:1290 (discriminator 1)) bcachefs
Modules linked in: bcachefs lz4_compress crc64 xor raid6_pq zstd_compress libcrc32c xt_comment iptable_filter binfmt_misc rfkill cirrus drm_kms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops drm pcspkr sg i2c_piix4 virtio_balloon floppy i2c_core ip_tables ext4 mbcache jbd2 sr_mod cdrom ata_generic pata_acpi ata_piix libata virtio_net net_failover failover serio_raw dm_mirror dm_region_hash dm_log dm_mod
CPU: 1 PID: 29215 Comm: kworker/1:2 Tainted: G        W         5.16.0+ #1
Hardware name: Red Hat KVM, BIOS 0.5.1 01/01/2011
Workqueue: bcachefs bch2_write_index [bcachefs]
RIP: 0010:bch2_writepage_io_done (fs/bcachefs/fs-io.c:1290 (discriminator 1)) bcachefs
Code: 80 64 24 28 f0 e8 58 6d 23 f6 0f b7 83 a0 03 00 00 44 39 f8 0f 8f 63 ff ff ff 48 8b b3 48 01 00 00 48 85 f6 0f 8e 82 fd ff ff <0f> 0b e9 7b fd ff ff 48 83 c5 40 b9 00 10 00 00 e9 bf fd ff ff 8b
All code
========
   0:	80 64 24 28 f0       	andb   $0xf0,0x28(%rsp)
   5:	e8 58 6d 23 f6       	callq  0xfffffffff6236d62
   a:	0f b7 83 a0 03 00 00 	movzwl 0x3a0(%rbx),%eax
  11:	44 39 f8             	cmp    %r15d,%eax
  14:	0f 8f 63 ff ff ff    	jg     0xffffffffffffff7d
  1a:	48 8b b3 48 01 00 00 	mov    0x148(%rbx),%rsi
  21:	48 85 f6             	test   %rsi,%rsi
  24:	0f 8e 82 fd ff ff    	jle    0xfffffffffffffdac
  2a:*	0f 0b                	ud2    		<-- trapping instruction
  2c:	e9 7b fd ff ff       	jmpq   0xfffffffffffffdac
  31:	48 83 c5 40          	add    $0x40,%rbp
  35:	b9 00 10 00 00       	mov    $0x1000,%ecx
  3a:	e9 bf fd ff ff       	jmpq   0xfffffffffffffdfe
  3f:	8b                   	.byte 0x8b

Code starting with the faulting instruction
===========================================
   0:	0f 0b                	ud2    
   2:	e9 7b fd ff ff       	jmpq   0xfffffffffffffd82
   7:	48 83 c5 40          	add    $0x40,%rbp
   b:	b9 00 10 00 00       	mov    $0x1000,%ecx
  10:	e9 bf fd ff ff       	jmpq   0xfffffffffffffdd4
  15:	8b                   	.byte 0x8b
RSP: 0018:ffffa6c4414bbe68 EFLAGS: 00010202
RAX: 0000000080000000 RBX: ffff8c2cc469c000 RCX: 0000000000000001
RDX: 0000000080000001 RSI: 0000000000000008 RDI: 00000000ffffffff
RBP: ffff8c2cc11b66c0 R08: 000000000007fa67 R09: 0000000000000000
R10: 0000000000000000 R11: 00000000ffffffff R12: ffffc6c43fd08f00
R13: 0000000000000020 R14: ffff8c2d7cb2ee00 R15: ffffc6c43fd08f05
FS:  0000000000000000(0000) GS:ffff8c2d7cb00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f0e924eb006 CR3: 000000003f6e2000 CR4: 00000000000006e0
Call Trace:
 <TASK>
process_one_work (./arch/x86/include/asm/jump_label.h:27 ./include/linux/jump_label.h:212 ./include/trace/events/workqueue.h:108 kernel/workqueue.c:2303) 
worker_thread (./include/linux/list.h:284 kernel/workqueue.c:2446) 
? process_one_work (kernel/workqueue.c:2388) 
kthread (kernel/kthread.c:327) 
? set_kthread_struct (kernel/kthread.c:272) 
ret_from_fork (arch/x86/entry/entry_64.S:301) 
 </TASK>
---[ end trace ae1f1e0405dedf23 ]---
traps: mysqld[3711] general protection fault ip:557e4d219d79 sp:7fc2782c48f0 error:0 in mysqld[557e4c800000+13af000]
------------[ cut here ]------------
WARNING: CPU: 1 PID: 9529 at fs/bcachefs/fs-io.c:1290 bch2_writepage_io_done (fs/bcachefs/fs-io.c:1290 (discriminator 1)) bcachefs
Modules linked in: bcachefs lz4_compress crc64 xor raid6_pq zstd_compress libcrc32c xt_comment iptable_filter binfmt_misc rfkill cirrus drm_kms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops drm pcspkr sg i2c_piix4 virtio_balloon floppy i2c_core ip_tables ext4 mbcache jbd2 sr_mod cdrom ata_generic pata_acpi ata_piix libata virtio_net net_failover failover serio_raw dm_mirror dm_region_hash dm_log dm_mod
CPU: 1 PID: 9529 Comm: kworker/1:1 Tainted: G        W         5.16.0+ #1
Hardware name: Red Hat KVM, BIOS 0.5.1 01/01/2011
Workqueue: bcachefs bch2_write_index [bcachefs]
RIP: 0010:bch2_writepage_io_done (fs/bcachefs/fs-io.c:1290 (discriminator 1)) bcachefs
Code: 80 64 24 28 f0 e8 58 6d 23 f6 0f b7 83 a0 03 00 00 44 39 f8 0f 8f 63 ff ff ff 48 8b b3 48 01 00 00 48 85 f6 0f 8e 82 fd ff ff <0f> 0b e9 7b fd ff ff 48 83 c5 40 b9 00 10 00 00 e9 bf fd ff ff 8b
All code
========
   0:	80 64 24 28 f0       	andb   $0xf0,0x28(%rsp)
   5:	e8 58 6d 23 f6       	callq  0xfffffffff6236d62
   a:	0f b7 83 a0 03 00 00 	movzwl 0x3a0(%rbx),%eax
  11:	44 39 f8             	cmp    %r15d,%eax
  14:	0f 8f 63 ff ff ff    	jg     0xffffffffffffff7d
  1a:	48 8b b3 48 01 00 00 	mov    0x148(%rbx),%rsi
  21:	48 85 f6             	test   %rsi,%rsi
  24:	0f 8e 82 fd ff ff    	jle    0xfffffffffffffdac
  2a:*	0f 0b                	ud2    		<-- trapping instruction
  2c:	e9 7b fd ff ff       	jmpq   0xfffffffffffffdac
  31:	48 83 c5 40          	add    $0x40,%rbp
  35:	b9 00 10 00 00       	mov    $0x1000,%ecx
  3a:	e9 bf fd ff ff       	jmpq   0xfffffffffffffdfe
  3f:	8b                   	.byte 0x8b

Code starting with the faulting instruction
===========================================
   0:	0f 0b                	ud2    
   2:	e9 7b fd ff ff       	jmpq   0xfffffffffffffd82
   7:	48 83 c5 40          	add    $0x40,%rbp
   b:	b9 00 10 00 00       	mov    $0x1000,%ecx
  10:	e9 bf fd ff ff       	jmpq   0xfffffffffffffdd4
  15:	8b                   	.byte 0x8b
RSP: 0018:ffffa6c440dd7e68 EFLAGS: 00010206
RAX: 0000000080000000 RBX: ffff8c2cc8770800 RCX: 0000000000000001
RDX: 0000000080000001 RSI: 0000000000000018 RDI: 00000000ffffffff
RBP: ffff8c2cc7276300 R08: 00000000000800ef R09: 0000000000000000
R10: 0000000000000000 R11: 00000000ffffffff R12: ffffc6c43fd08f00
R13: 0000000000000020 R14: ffff8c2d7cb2ee00 R15: ffffc6c43fd08f05
FS:  0000000000000000(0000) GS:ffff8c2d7cb00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f2eaff77148 CR3: 000000003f6e2000 CR4: 00000000000006e0
Call Trace:
 <TASK>
process_one_work (./arch/x86/include/asm/jump_label.h:27 ./include/linux/jump_label.h:212 ./include/trace/events/workqueue.h:108 kernel/workqueue.c:2303) 
worker_thread (./include/linux/list.h:284 kernel/workqueue.c:2446) 
? process_one_work (kernel/workqueue.c:2388) 
kthread (kernel/kthread.c:327) 
? set_kthread_struct (kernel/kthread.c:272) 
ret_from_fork (arch/x86/entry/entry_64.S:301) 
 </TASK>
---[ end trace ae1f1e0405dedf24 ]---
------------[ cut here ]------------
WARNING: CPU: 0 PID: 29770 at fs/bcachefs/fs-io.c:1290 bch2_writepage_io_done (fs/bcachefs/fs-io.c:1290 (discriminator 1)) bcachefs
Modules linked in: bcachefs lz4_compress crc64 xor raid6_pq zstd_compress libcrc32c xt_comment iptable_filter binfmt_misc rfkill cirrus drm_kms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops drm pcspkr sg i2c_piix4 virtio_balloon floppy i2c_core ip_tables ext4 mbcache jbd2 sr_mod cdrom ata_generic pata_acpi ata_piix libata virtio_net net_failover failover serio_raw dm_mirror dm_region_hash dm_log dm_mod
CPU: 0 PID: 29770 Comm: kworker/0:0 Tainted: G        W         5.16.0+ #1
Hardware name: Red Hat KVM, BIOS 0.5.1 01/01/2011
Workqueue: bcachefs bch2_write_index [bcachefs]
RIP: 0010:bch2_writepage_io_done (fs/bcachefs/fs-io.c:1290 (discriminator 1)) bcachefs
Code: 80 64 24 28 f0 e8 58 6d 23 f6 0f b7 83 a0 03 00 00 44 39 f8 0f 8f 63 ff ff ff 48 8b b3 48 01 00 00 48 85 f6 0f 8e 82 fd ff ff <0f> 0b e9 7b fd ff ff 48 83 c5 40 b9 00 10 00 00 e9 bf fd ff ff 8b
All code
========
   0:	80 64 24 28 f0       	andb   $0xf0,0x28(%rsp)
   5:	e8 58 6d 23 f6       	callq  0xfffffffff6236d62
   a:	0f b7 83 a0 03 00 00 	movzwl 0x3a0(%rbx),%eax
  11:	44 39 f8             	cmp    %r15d,%eax
  14:	0f 8f 63 ff ff ff    	jg     0xffffffffffffff7d
  1a:	48 8b b3 48 01 00 00 	mov    0x148(%rbx),%rsi
  21:	48 85 f6             	test   %rsi,%rsi
  24:	0f 8e 82 fd ff ff    	jle    0xfffffffffffffdac
  2a:*	0f 0b                	ud2    		<-- trapping instruction
  2c:	e9 7b fd ff ff       	jmpq   0xfffffffffffffdac
  31:	48 83 c5 40          	add    $0x40,%rbp
  35:	b9 00 10 00 00       	mov    $0x1000,%ecx
  3a:	e9 bf fd ff ff       	jmpq   0xfffffffffffffdfe
  3f:	8b                   	.byte 0x8b

Code starting with the faulting instruction
===========================================
   0:	0f 0b                	ud2    
   2:	e9 7b fd ff ff       	jmpq   0xfffffffffffffd82
   7:	48 83 c5 40          	add    $0x40,%rbp
   b:	b9 00 10 00 00       	mov    $0x1000,%ecx
  10:	e9 bf fd ff ff       	jmpq   0xfffffffffffffdd4
  15:	8b                   	.byte 0x8b
RSP: 0000:ffffa6c440523e68 EFLAGS: 00010202
RAX: 0000000080000000 RBX: ffff8c2cc6942800 RCX: 0000000000000001
RDX: 0000000080000001 RSI: 0000000000000020 RDI: 00000000ffffffff
RBP: ffff8c2cff4159c0 R08: 0000000000080c28 R09: 0000000000000000
R10: 0000000000000000 R11: 00000000ffffffff R12: ffffc6c43fc08f00
R13: 0000000000000020 R14: ffff8c2d7ca2ee00 R15: ffffc6c43fc08f05
FS:  0000000000000000(0000) GS:ffff8c2d7ca00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f19ed64a0a0 CR3: 000000004f40a000 CR4: 00000000000006f0
Call Trace:
 <TASK>
process_one_work (./arch/x86/include/asm/jump_label.h:27 ./include/linux/jump_label.h:212 ./include/trace/events/workqueue.h:108 kernel/workqueue.c:2303) 
worker_thread (./include/linux/list.h:284 kernel/workqueue.c:2446) 
? process_one_work (kernel/workqueue.c:2388) 
kthread (kernel/kthread.c:327) 
? set_kthread_struct (kernel/kthread.c:272) 
ret_from_fork (arch/x86/entry/entry_64.S:301) 
 </TASK>
---[ end trace ae1f1e0405dedf25 ]---
------------[ cut here ]------------
WARNING: CPU: 1 PID: 9529 at fs/bcachefs/fs-io.c:1290 bch2_writepage_io_done (fs/bcachefs/fs-io.c:1290 (discriminator 1)) bcachefs
Modules linked in: bcachefs lz4_compress crc64 xor raid6_pq zstd_compress libcrc32c xt_comment iptable_filter binfmt_misc rfkill cirrus drm_kms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops drm pcspkr sg i2c_piix4 virtio_balloon floppy i2c_core ip_tables ext4 mbcache jbd2 sr_mod cdrom ata_generic pata_acpi ata_piix libata virtio_net net_failover failover serio_raw dm_mirror dm_region_hash dm_log dm_mod
CPU: 1 PID: 9529 Comm: kworker/1:1 Tainted: G        W         5.16.0+ #1
Hardware name: Red Hat KVM, BIOS 0.5.1 01/01/2011
Workqueue: bcachefs bch2_write_index [bcachefs]
RIP: 0010:bch2_writepage_io_done (fs/bcachefs/fs-io.c:1290 (discriminator 1)) bcachefs
Code: 80 64 24 28 f0 e8 58 6d 23 f6 0f b7 83 a0 03 00 00 44 39 f8 0f 8f 63 ff ff ff 48 8b b3 48 01 00 00 48 85 f6 0f 8e 82 fd ff ff <0f> 0b e9 7b fd ff ff 48 83 c5 40 b9 00 10 00 00 e9 bf fd ff ff 8b
All code
========
   0:	80 64 24 28 f0       	andb   $0xf0,0x28(%rsp)
   5:	e8 58 6d 23 f6       	callq  0xfffffffff6236d62
   a:	0f b7 83 a0 03 00 00 	movzwl 0x3a0(%rbx),%eax
  11:	44 39 f8             	cmp    %r15d,%eax
  14:	0f 8f 63 ff ff ff    	jg     0xffffffffffffff7d
  1a:	48 8b b3 48 01 00 00 	mov    0x148(%rbx),%rsi
  21:	48 85 f6             	test   %rsi,%rsi
  24:	0f 8e 82 fd ff ff    	jle    0xfffffffffffffdac
  2a:*	0f 0b                	ud2    		<-- trapping instruction
  2c:	e9 7b fd ff ff       	jmpq   0xfffffffffffffdac
  31:	48 83 c5 40          	add    $0x40,%rbp
  35:	b9 00 10 00 00       	mov    $0x1000,%ecx
  3a:	e9 bf fd ff ff       	jmpq   0xfffffffffffffdfe
  3f:	8b                   	.byte 0x8b

Code starting with the faulting instruction
===========================================
   0:	0f 0b                	ud2    
   2:	e9 7b fd ff ff       	jmpq   0xfffffffffffffd82
   7:	48 83 c5 40          	add    $0x40,%rbp
   b:	b9 00 10 00 00       	mov    $0x1000,%ecx
  10:	e9 bf fd ff ff       	jmpq   0xfffffffffffffdd4
  15:	8b                   	.byte 0x8b
RSP: 0018:ffffa6c440dd7e68 EFLAGS: 00010202
RAX: 0000000080000000 RBX: ffff8c2cff1b3400 RCX: 0000000000000001
RDX: 0000000080000001 RSI: 0000000000000008 RDI: 00000000ffffffff
RBP: ffff8c2cc7276300 R08: 0000000000081660 R09: 0000000000000000
R10: 0000000000000000 R11: 00000000ffffffff R12: ffffc6c43fd08f00
R13: 0000000000000020 R14: ffff8c2d7cb2ee00 R15: ffffc6c43fd08f05
FS:  0000000000000000(0000) GS:ffff8c2d7cb00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f56491f80a0 CR3: 000000003f6e2000 CR4: 00000000000006e0
Call Trace:
 <TASK>
process_one_work (./arch/x86/include/asm/jump_label.h:27 ./include/linux/jump_label.h:212 ./include/trace/events/workqueue.h:108 kernel/workqueue.c:2303) 
worker_thread (./include/linux/list.h:284 kernel/workqueue.c:2446) 
? process_one_work (kernel/workqueue.c:2388) 
kthread (kernel/kthread.c:327) 
? set_kthread_struct (kernel/kthread.c:272) 
ret_from_fork (arch/x86/entry/entry_64.S:301) 
 </TASK>
---[ end trace ae1f1e0405dedf26 ]---
------------[ cut here ]------------
WARNING: CPU: 1 PID: 9529 at fs/bcachefs/fs-io.c:1290 bch2_writepage_io_done (fs/bcachefs/fs-io.c:1290 (discriminator 1)) bcachefs
Modules linked in: bcachefs lz4_compress crc64 xor raid6_pq zstd_compress libcrc32c xt_comment iptable_filter binfmt_misc rfkill cirrus drm_kms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops drm pcspkr sg i2c_piix4 virtio_balloon floppy i2c_core ip_tables ext4 mbcache jbd2 sr_mod cdrom ata_generic pata_acpi ata_piix libata virtio_net net_failover failover serio_raw dm_mirror dm_region_hash dm_log dm_mod
CPU: 1 PID: 9529 Comm: kworker/1:1 Tainted: G        W         5.16.0+ #1
Hardware name: Red Hat KVM, BIOS 0.5.1 01/01/2011
Workqueue: bcachefs bch2_write_index [bcachefs]
RIP: 0010:bch2_writepage_io_done (fs/bcachefs/fs-io.c:1290 (discriminator 1)) bcachefs
Code: 80 64 24 28 f0 e8 58 6d 23 f6 0f b7 83 a0 03 00 00 44 39 f8 0f 8f 63 ff ff ff 48 8b b3 48 01 00 00 48 85 f6 0f 8e 82 fd ff ff <0f> 0b e9 7b fd ff ff 48 83 c5 40 b9 00 10 00 00 e9 bf fd ff ff 8b
All code
========
   0:	80 64 24 28 f0       	andb   $0xf0,0x28(%rsp)
   5:	e8 58 6d 23 f6       	callq  0xfffffffff6236d62
   a:	0f b7 83 a0 03 00 00 	movzwl 0x3a0(%rbx),%eax
  11:	44 39 f8             	cmp    %r15d,%eax
  14:	0f 8f 63 ff ff ff    	jg     0xffffffffffffff7d
  1a:	48 8b b3 48 01 00 00 	mov    0x148(%rbx),%rsi
  21:	48 85 f6             	test   %rsi,%rsi
  24:	0f 8e 82 fd ff ff    	jle    0xfffffffffffffdac
  2a:*	0f 0b                	ud2    		<-- trapping instruction
  2c:	e9 7b fd ff ff       	jmpq   0xfffffffffffffdac
  31:	48 83 c5 40          	add    $0x40,%rbp
  35:	b9 00 10 00 00       	mov    $0x1000,%ecx
  3a:	e9 bf fd ff ff       	jmpq   0xfffffffffffffdfe
  3f:	8b                   	.byte 0x8b

Code starting with the faulting instruction
===========================================
   0:	0f 0b                	ud2    
   2:	e9 7b fd ff ff       	jmpq   0xfffffffffffffd82
   7:	48 83 c5 40          	add    $0x40,%rbp
   b:	b9 00 10 00 00       	mov    $0x1000,%ecx
  10:	e9 bf fd ff ff       	jmpq   0xfffffffffffffdd4
  15:	8b                   	.byte 0x8b
RSP: 0018:ffffa6c440dd7e68 EFLAGS: 00010202
RAX: 0000000080000000 RBX: ffff8c2cff1b1400 RCX: 0000000000000001
RDX: 0000000080000001 RSI: 0000000000000008 RDI: 00000000ffffffff
RBP: ffff8c2cc7276300 R08: 0000000000081666 R09: 0000000000000000
R10: 0000000000000000 R11: 00000000ffffffff R12: ffffc6c43fd08f00
R13: 0000000000000020 R14: ffff8c2d7cb2ee00 R15: ffffc6c43fd08f05
FS:  0000000000000000(0000) GS:ffff8c2d7cb00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fa4284ca000 CR3: 000000003f6e2000 CR4: 00000000000006e0
Call Trace:
 <TASK>
process_one_work (./arch/x86/include/asm/jump_label.h:27 ./include/linux/jump_label.h:212 ./include/trace/events/workqueue.h:108 kernel/workqueue.c:2303) 
worker_thread (./include/linux/list.h:284 kernel/workqueue.c:2446) 
? process_one_work (kernel/workqueue.c:2388) 
kthread (kernel/kthread.c:327) 
? set_kthread_struct (kernel/kthread.c:272) 
ret_from_fork (arch/x86/entry/entry_64.S:301) 
 </TASK>
---[ end trace ae1f1e0405dedf27 ]---
------------[ cut here ]------------
WARNING: CPU: 1 PID: 29215 at fs/bcachefs/fs-io.c:1290 bch2_writepage_io_done (fs/bcachefs/fs-io.c:1290 (discriminator 1)) bcachefs
Modules linked in: bcachefs lz4_compress crc64 xor raid6_pq zstd_compress libcrc32c xt_comment iptable_filter binfmt_misc rfkill cirrus drm_kms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops drm pcspkr sg i2c_piix4 virtio_balloon floppy i2c_core ip_tables ext4 mbcache jbd2 sr_mod cdrom ata_generic pata_acpi ata_piix libata virtio_net net_failover failover serio_raw dm_mirror dm_region_hash dm_log dm_mod
CPU: 1 PID: 29215 Comm: kworker/1:2 Tainted: G        W         5.16.0+ #1
Hardware name: Red Hat KVM, BIOS 0.5.1 01/01/2011
Workqueue: bcachefs bch2_write_index [bcachefs]
RIP: 0010:bch2_writepage_io_done (fs/bcachefs/fs-io.c:1290 (discriminator 1)) bcachefs
Code: 80 64 24 28 f0 e8 58 6d 23 f6 0f b7 83 a0 03 00 00 44 39 f8 0f 8f 63 ff ff ff 48 8b b3 48 01 00 00 48 85 f6 0f 8e 82 fd ff ff <0f> 0b e9 7b fd ff ff 48 83 c5 40 b9 00 10 00 00 e9 bf fd ff ff 8b
All code
========
   0:	80 64 24 28 f0       	andb   $0xf0,0x28(%rsp)
   5:	e8 58 6d 23 f6       	callq  0xfffffffff6236d62
   a:	0f b7 83 a0 03 00 00 	movzwl 0x3a0(%rbx),%eax
  11:	44 39 f8             	cmp    %r15d,%eax
  14:	0f 8f 63 ff ff ff    	jg     0xffffffffffffff7d
  1a:	48 8b b3 48 01 00 00 	mov    0x148(%rbx),%rsi
  21:	48 85 f6             	test   %rsi,%rsi
  24:	0f 8e 82 fd ff ff    	jle    0xfffffffffffffdac
  2a:*	0f 0b                	ud2    		<-- trapping instruction
  2c:	e9 7b fd ff ff       	jmpq   0xfffffffffffffdac
  31:	48 83 c5 40          	add    $0x40,%rbp
  35:	b9 00 10 00 00       	mov    $0x1000,%ecx
  3a:	e9 bf fd ff ff       	jmpq   0xfffffffffffffdfe
  3f:	8b                   	.byte 0x8b

Code starting with the faulting instruction
===========================================
   0:	0f 0b                	ud2    
   2:	e9 7b fd ff ff       	jmpq   0xfffffffffffffd82
   7:	48 83 c5 40          	add    $0x40,%rbp
   b:	b9 00 10 00 00       	mov    $0x1000,%ecx
  10:	e9 bf fd ff ff       	jmpq   0xfffffffffffffdd4
  15:	8b                   	.byte 0x8b
RSP: 0018:ffffa6c4414bbe68 EFLAGS: 00010202
RAX: 0000000080000000 RBX: ffff8c2cc86f3800 RCX: 0000000000000001
RDX: 0000000080000001 RSI: 0000000000000020 RDI: 00000000ffffffff
RBP: ffff8c2cc11b66c0 R08: 0000000000082056 R09: 0000000000000000
R10: 0000000000000000 R11: 00000000ffffffff R12: ffffc6c43fd08f00
R13: 0000000000000020 R14: ffff8c2d7cb2ee00 R15: ffffc6c43fd08f05
FS:  0000000000000000(0000) GS:ffff8c2d7cb00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f2a7cec30a0 CR3: 000000003f6e2000 CR4: 00000000000006e0
Call Trace:
 <TASK>
process_one_work (./arch/x86/include/asm/jump_label.h:27 ./include/linux/jump_label.h:212 ./include/trace/events/workqueue.h:108 kernel/workqueue.c:2303) 
worker_thread (./include/linux/list.h:284 kernel/workqueue.c:2446) 
? process_one_work (kernel/workqueue.c:2388) 
kthread (kernel/kthread.c:327) 
? set_kthread_struct (kernel/kthread.c:272) 
ret_from_fork (arch/x86/entry/entry_64.S:301) 
 </TASK>
---[ end trace ae1f1e0405dedf28 ]---
------------[ cut here ]------------
WARNING: CPU: 1 PID: 29215 at fs/bcachefs/fs-io.c:1290 bch2_writepage_io_done (fs/bcachefs/fs-io.c:1290 (discriminator 1)) bcachefs
Modules linked in: bcachefs lz4_compress crc64 xor raid6_pq zstd_compress libcrc32c xt_comment iptable_filter binfmt_misc rfkill cirrus drm_kms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops drm pcspkr sg i2c_piix4 virtio_balloon floppy i2c_core ip_tables ext4 mbcache jbd2 sr_mod cdrom ata_generic pata_acpi ata_piix libata virtio_net net_failover failover serio_raw dm_mirror dm_region_hash dm_log dm_mod
CPU: 1 PID: 29215 Comm: kworker/1:2 Tainted: G        W         5.16.0+ #1
Hardware name: Red Hat KVM, BIOS 0.5.1 01/01/2011
Workqueue: bcachefs bch2_write_index [bcachefs]
RIP: 0010:bch2_writepage_io_done (fs/bcachefs/fs-io.c:1290 (discriminator 1)) bcachefs
Code: 80 64 24 28 f0 e8 58 6d 23 f6 0f b7 83 a0 03 00 00 44 39 f8 0f 8f 63 ff ff ff 48 8b b3 48 01 00 00 48 85 f6 0f 8e 82 fd ff ff <0f> 0b e9 7b fd ff ff 48 83 c5 40 b9 00 10 00 00 e9 bf fd ff ff 8b
All code
========
   0:	80 64 24 28 f0       	andb   $0xf0,0x28(%rsp)
   5:	e8 58 6d 23 f6       	callq  0xfffffffff6236d62
   a:	0f b7 83 a0 03 00 00 	movzwl 0x3a0(%rbx),%eax
  11:	44 39 f8             	cmp    %r15d,%eax
  14:	0f 8f 63 ff ff ff    	jg     0xffffffffffffff7d
  1a:	48 8b b3 48 01 00 00 	mov    0x148(%rbx),%rsi
  21:	48 85 f6             	test   %rsi,%rsi
  24:	0f 8e 82 fd ff ff    	jle    0xfffffffffffffdac
  2a:*	0f 0b                	ud2    		<-- trapping instruction
  2c:	e9 7b fd ff ff       	jmpq   0xfffffffffffffdac
  31:	48 83 c5 40          	add    $0x40,%rbp
  35:	b9 00 10 00 00       	mov    $0x1000,%ecx
  3a:	e9 bf fd ff ff       	jmpq   0xfffffffffffffdfe
  3f:	8b                   	.byte 0x8b

Code starting with the faulting instruction
===========================================
   0:	0f 0b                	ud2    
   2:	e9 7b fd ff ff       	jmpq   0xfffffffffffffd82
   7:	48 83 c5 40          	add    $0x40,%rbp
   b:	b9 00 10 00 00       	mov    $0x1000,%ecx
  10:	e9 bf fd ff ff       	jmpq   0xfffffffffffffdd4
  15:	8b                   	.byte 0x8b
RSP: 0000:ffffa6c4414bbe68 EFLAGS: 00010202
RAX: 0000000080000000 RBX: ffff8c2cff1b1000 RCX: 0000000000000001
RDX: 0000000080000001 RSI: 0000000000000008 RDI: 00000000ffffffff
RBP: ffff8c2cc11b66c0 R08: 00000000000820a9 R09: 0000000000000000
R10: 0000000000000000 R11: 00000000ffffffff R12: ffffc6c43fd08f00
R13: 0000000000000020 R14: ffff8c2d7cb2ee00 R15: ffffc6c43fd08f05
FS:  0000000000000000(0000) GS:ffff8c2d7cb00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fd3c6b36000 CR3: 0000000006d2c000 CR4: 00000000000006e0
Call Trace:
 <TASK>
process_one_work (./arch/x86/include/asm/jump_label.h:27 ./include/linux/jump_label.h:212 ./include/trace/events/workqueue.h:108 kernel/workqueue.c:2303) 
worker_thread (./include/linux/list.h:284 kernel/workqueue.c:2446) 
? process_one_work (kernel/workqueue.c:2388) 
kthread (kernel/kthread.c:327) 
? set_kthread_struct (kernel/kthread.c:272) 
ret_from_fork (arch/x86/entry/entry_64.S:301) 
 </TASK>
---[ end trace ae1f1e0405dedf29 ]---


--
Eric Wheeler

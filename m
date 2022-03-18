Return-Path: <linux-bcachefs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F044EC433F5
	for <linux-bcachefs@archiver.kernel.org>; Fri, 18 Mar 2022 23:22:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241486AbiCRXXe (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Fri, 18 Mar 2022 19:23:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238224AbiCRXXd (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Fri, 18 Mar 2022 19:23:33 -0400
Received: from mx.ewheeler.net (mx.ewheeler.net [173.205.220.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 210AE2DE7BB
        for <linux-bcachefs@vger.kernel.org>; Fri, 18 Mar 2022 16:22:13 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by mx.ewheeler.net (Postfix) with ESMTP id 0A92681;
        Fri, 18 Mar 2022 16:22:12 -0700 (PDT)
X-Virus-Scanned: amavisd-new at ewheeler.net
Received: from mx.ewheeler.net ([127.0.0.1])
        by localhost (mx.ewheeler.net [127.0.0.1]) (amavisd-new, port 10024)
        with LMTP id xMgv8iGhTNKh; Fri, 18 Mar 2022 16:22:07 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx.ewheeler.net (Postfix) with ESMTPSA id 8116D40;
        Fri, 18 Mar 2022 16:22:07 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx.ewheeler.net 8116D40
Date:   Fri, 18 Mar 2022 16:22:03 -0700 (PDT)
From:   Eric Wheeler <bcachefs@lists.ewheeler.net>
To:     Kent Overstreet <kent.overstreet@gmail.com>
cc:     linux-bcachefs@vger.kernel.org
Subject: Re: bcachefs filesystem corruption
In-Reply-To: <df529764-f2d4-9c23-23ca-581155df7e@ewheeler.net>
Message-ID: <806f1a53-cf38-6828-3441-788d38a4abb@ewheeler.net>
References: <a55372e3-c4d5-ecb0-782e-242d166140c5@lists.ewheeler.net> <20220317010742.dm35ejttjbjrddsi@moria.home.lan> <df529764-f2d4-9c23-23ca-581155df7e@ewheeler.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Thu, 17 Mar 2022, Eric Wheeler wrote:
> On Wed, 16 Mar 2022, Kent Overstreet wrote:
> > On Wed, Mar 16, 2022 at 03:58:34PM -0700, Eric Wheeler wrote:
> > > Hi Kent,
> > > 
> > > The MySQL+snapshots deployment we has become corrupt and InnoDB is 
> > > crashing with a stack trace and lots of borken database noise.
> > > 
> > > We are going to rebuild it from other replicas and see if it happens 
> > > again.  We started using your new-allocator code (commit 
> > > 3985f5f4eff86ee667da7da6e36ca2c346f56be3) after the original deployment 
> > > and we haven't re-loaded since you fixed the snapshot iterator issue, or 
> > > maybe it broke during the allocator conversion, can't be certain.
> > > 
> > > There isn't any especially obvious problem but there are some WARNING's 
> > > below that you might look at.
> > > 
> > > There were lots of these:
> > > 	WARNING: CPU: 0 PID: 7796 at fs/bcachefs/fs-io.c:1290 
> > > 	  bch2_writepage_io_done (fs/bcachefs/fs-io.c:1290 (discriminator 1)) bcachefs
> > 
> > So the warnings are just a symptom, and not terribly interesting. I'm changing
> > them to WARN_ON_ONCE().
> > 
> > > bcachefs (dm-6): initializing new filesystem
> > > bcachefs (dm-6): going read-write
> > > bucket 0:10 gen 0 different types of data in same bucket: btree, journal
> > > while marking journal
> > 
> > ^ That's probably the real culprit - we're using the same bucket for both
> > journal and btree, no wonder things got hosed.

Could that have happened from an in-place upgrade of the on-disk 
structures from the new allocator code you added between 
	5490c9c529770aa18b2571bd98f5416ed9ae24c6..3985f5f4eff86ee667da7da6e36ca2c346f56be3 ?

> > 
> > Interesting bug, something strange must have happened for us to not catch this
> > right away.
> 
> The deployment would have been like this:
> 
> 1. Make lots of subvolumes
> 2. Deploy mysql instances with their --datadir pointing to the subvols
> 3. Snapshot every 4 hrs
> 4. Crash because of iterator issue
> 5. Reboot with iterator+new allocator.  This would have done the allocator 
>    upgrade to add the new structures.
> 6. The rest is in this email thread.
> 
> Also we have a weird problem where mkfs hangs, not sure if it is 
> relavent, maybe mkfs isn't finishing, but we think it is because it mounts 
> wihout error.

Ok, so we reproduced what appears to be a userspace deadlock in `bcachefs 
format`.  We are building with the latest version (I think) at commit 
3765483ff0cf9abd0243fcafe11aebd0f9beb03d.  Stack traces are below.

Here is how we reproduce the problem:

	lvcreate -n bcachefstest -L 200g data
	gdb bcachefs format -ex 'run format /dev/data/bcachefstest'

Then it will spin at 100% CPU. We hit CTRL-C when it spins for too long 
and and get a backtrace of each thread using `gdb`.

Interestingly we were able to get it to finish the format reliably with 
`taskset -c 1` and `chrt -f 1` to pin it on one CPU and make it SCHED_FIFO 
to prevent thread interleaving.  Definitely a hack, and I wasn't sure if 
it would make things worse or solve the deadlock, but this _does_ work 
reliably:

	chrt -f 1 taskset -c 1 gdb bcachefs -ex 'run format /dev/data/bcachefstest'

There are quite a few thread traces, most of are not interesting.  
Here is a full stacktrace: https://pastebin.com/0fuv8aHu

And these are the ones that look relevant:

====== Test 1 ======

Starting program: /usr/local/bin/bcachefs format /dev/data/bcachefstest
[Thread debugging using libthread_db enabled]
Using host libthread_db library "/lib64/libthread_db.so.1".
[New Thread 0x7ffff7fe3700 (LWP 18865)]
[New Thread 0x7ffff7fda700 (LWP 18866)]
[New Thread 0x7ffff7fd1700 (LWP 18867)]
[New Thread 0x7ffff7fc8700 (LWP 18868)]
[New Thread 0x7ffff7fbf700 (LWP 18869)]
[New Thread 0x7ffff7fb6700 (LWP 18870)]
[New Thread 0x7ffff7fad700 (LWP 18871)]
External UUID:                  fd0a5313-6cbd-4175-9f99-96b8b02c2d74
Internal UUID:                  06c376af-29f7-4e28-b224-47f0c116d018
Device index:                   0
Label:                          
Version:                        19
Oldest version on disk:         19
Created:                        Fri Mar 18 15:27:58 2022
Sequence number:                0
Superblock size:                816
Clean:                          0
Devices:                        1
Sections:                       members
Features:                       new_siphash,new_extent_overwrite,btree_ptr_v2,extents_above_btree_updates,btree_updates_journalled,new_varint,journal_no_flush,alloc_v2,extents_across_btree_nodes
Compat features:                

Options:
  block_size:                   512
  btree_node_size:              256k
  errors:                       continue [ro] panic 
  metadata_replicas:            1
  data_replicas:                1
  metadata_replicas_required:   1
  data_replicas_required:       1
  encoded_extent_max:           64k
  metadata_checksum:            none [crc32c] crc64 xxhash 
  data_checksum:                none [crc32c] crc64 xxhash 
  compression:                  [none] lz4 gzip zstd 
  background_compression:       [none] lz4 gzip zstd 
  str_hash:                     crc32c crc64 [siphash] 
  metadata_target:              none
  foreground_target:            none
  background_target:            none
  promote_target:               none
  erasure_code:                 0
  inodes_32bit:                 1
  shard_inode_numbers:          1
  inodes_use_key_cache:         1
  gc_reserve_percent:           8
  gc_reserve_bytes:             0
  root_reserve_percent:         0
  wide_macs:                    0
  acl:                          1
  usrquota:                     0
  grpquota:                     0
  prjquota:                     0
  journal_flush_delay:          1000
  journal_flush_disabled:       0
  journal_reclaim_delay:        100
  journal_transaction_names:    1

members (size 64):
  Device:                       0
    UUID:                       50ae6b14-eefc-41a9-8e49-ea62d0d70c15
    Size:                       200G
    Bucket size:                256k
    First bucket:               0
    Buckets:                    819200
    Last mount:                 (never)
    State:                      rw
    Group:                      (none)
    Data allowed:               journal,btree,user
    Has data:                   (none)
    Discard:                    0
    Freespace initialized:      0
bch2_fs_open() 
bch2_read_super() 
bch2_read_super() ret 0
bch2_fs_alloc() 
[New Thread 0x7ffff7f61700 (LWP 18873)]
[New Thread 0x7ffff7f58700 (LWP 18875)]
[New Thread 0x7ffff7f4f700 (LWP 18876)]
[New Thread 0x7ffff7f46700 (LWP 18877)]
bch2_fs_journal_init() 
bch2_fs_journal_init() ret 0
bch2_fs_btree_cache_init() 
bch2_fs_btree_cache_init() ret 0
[New Thread 0x7ffff7e05700 (LWP 18878)]
bch2_fs_encryption_init() 
bch2_fs_encryption_init() ret 0
__bch2_fs_compress_init() 
__bch2_fs_compress_init() ret 0
bch2_dev_alloc() 
bch2_dev_alloc() ret 0
bch2_fs_alloc() ret 0
initializing new filesystem
[New Thread 0x7ffff3ff1700 (LWP 18879)]
going read-write
marking superblocks
[New Thread 0x7ffff3fe8700 (LWP 18880)]
^C
Program received signal SIGINT, Interrupt.
0x00007ffff670dd62 in pthread_mutex_lock () from /lib64/libpthread.so.0

### Note that the stdio output above is from a _different_ run than than for the
### traces below. However, I don't think the stdio output is important, really 
### only the UUIDs change.

### Spinning 100% CPU for a long time so pressed CTRL-C and ran backtraces ###


(gdb) thr a a bt
Thread 1 (Thread 0x7ffff7fe4b80 (LWP 23493)):
	#0  0x00007ffff5c1cd19 in syscall () from /lib64/libc.so.6
	#1  0x0000000000421a32 in futex (val3=0, uaddr2=0x0, timeout=0x0, val=<optimized out>, op=128, uaddr=<optimized out>)
	    at /usr/include/urcu/futex.h:65
	#2  schedule () at linux/sched.c:41
	#3  0x00000000004186e3 in __six_lock_type_slowpath (lock=0x843200, type=type@entry=SIX_LOCK_intent, 
	    should_sleep_fn=0x42fb40 <lock_root_check_fn>, should_sleep_fn@entry=0x7ffffff, p=0x7ffff7f638b0, p@entry=0xffffffffffffffff)
	    at linux/six.c:501
	#4  0x0000000000418d58 in __six_lock_type (p=p@entry=0xffffffffffffffff, should_sleep_fn=should_sleep_fn@entry=0x7ffffff, 
	    type=SIX_LOCK_intent, lock=lock@entry=0xfffffffff0000000) at linux/six.c:531
	#5  six_lock_intent (lock=lock@entry=0x843200, should_sleep_fn=should_sleep_fn@entry=0x42fb40 <lock_root_check_fn>, p=p@entry=0x7ffff7f638b0)
	    at linux/six.c:606
	#6  0x00000000004315c3 in six_lock_type (p=0x7ffff7f638b0, should_sleep_fn=0x42fb40 <lock_root_check_fn>, type=(unknown: 4294954432), 
	    lock=0x843200) at include/linux/six.h:182
	#7  btree_node_lock_type (p=0x7ffff7f638b0, should_sleep_fn=0x42fb40 <lock_root_check_fn>, type=(unknown: 4294954432), level=0, pos=..., 
	    b=0x843200, path=0x91d080, trans=0x7fffffffd400) at libbcachefs/btree_locking.h:157
	#8  __bch2_btree_node_lock (trans=trans@entry=0x7fffffffd400, path=path@entry=0x91d080, b=b@entry=0x843200, pos=..., level=0, 
	    type=type@entry=SIX_LOCK_intent, should_sleep_fn=should_sleep_fn@entry=0x42fb40 <lock_root_check_fn>, p=0x7ffff7f638b0, ip=4430528)
	    at libbcachefs/btree_iter.c:372
	#9  0x0000000000432b7e in btree_node_lock (should_sleep_fn=0x42fb40 <lock_root_check_fn>, ip=4430528, p=0x7ffff7f638b0, type=SIX_LOCK_intent, 
	    level=0, pos=..., b=0x843200, path=0x91d080, trans=0x7fffffffd400) at libbcachefs/btree_locking.h:204
	#10 btree_path_lock_root (trace_ip=<optimized out>, depth_want=<optimized out>, path=0x91d080, trans=0x7fffffffd400)
	    at libbcachefs/btree_iter.c:1230
	#11 btree_path_traverse_one (trans=trans@entry=0x7fffffffd400, path=path@entry=0x91d080, flags=flags@entry=0, trace_ip=trace_ip@entry=4430528)
	    at libbcachefs/btree_iter.c:1607
	#12 0x0000000000439ad4 in bch2_btree_path_traverse_all (trans=0x7fffffffd400) at libbcachefs/btree_iter.c:1488
	#13 bch2_trans_begin (trans=trans@entry=0x7fffffffd400) at libbcachefs/btree_iter.c:3085
	#14 0x0000000000461c39 in bch2_trans_mark_metadata_bucket (trans=trans@entry=0x7fffffffd400, ca=ca@entry=0x914800, b=4781, 
	    type=type@entry=BCH_DATA_journal, sectors=512) at libbcachefs/buckets.c:1905
	#15 0x0000000000461f80 in __bch2_trans_mark_dev_sb (ca=0x914800, trans=0x7fffffffd400) at libbcachefs/buckets.c:1971
	#16 bch2_trans_mark_dev_sb (c=c@entry=0x7ffff7f63000, ca=ca@entry=0x914800) at libbcachefs/buckets.c:1983
	#17 0x000000000049a544 in bch2_fs_initialize (c=0x7ffff7f63000) at libbcachefs/recovery.c:1394
	#18 0x00000000004768c3 in bch2_fs_start (c=c@entry=0x7ffff7f63000) at libbcachefs/super.c:898
	#19 0x0000000000478ee2 in bch2_fs_open (devices=devices@entry=0x8288d0, nr_devices=nr_devices@entry=1, opts=...) at libbcachefs/super.c:1905
	#20 0x0000000000412f92 in cmd_format (argc=argc@entry=2, argv=argv@entry=0x7fffffffe418) at cmd_format.c:268
	#21 0x0000000000407ff7 in main (argc=2, argv=0x7fffffffe418) at bcachefs.c:195

...

Thread 14 (Thread 0x7ffff3ff1700 (LWP 23512)):
	#0  0x00007ffff670ef0e in pthread_mutex_unlock () from /lib64/libpthread.so.0
	#1  0x000000000041c4a0 in del_timer (timer=timer@entry=0x7ffff7f813f0) at linux/timer.c:166
	#2  0x00000000004172f8 in grab_pending (work=work@entry=0x7ffff7f813d0, is_dwork=is_dwork@entry=true) at linux/workqueue.c:118
	#3  0x0000000000417722 in cancel_delayed_work (dwork=dwork@entry=0x7ffff7f813d0) at linux/workqueue.c:210
	#4  0x00000000004b1b8e in __journal_entry_close (j=0x7ffff7f81078, closed_val=<optimized out>) at libbcachefs/journal.c:140
	#5  0x00000000004b511d in __journal_res_get (j=j@entry=0x7ffff7f81078, res=res@entry=0x7ffff3ff08f0, flags=flags@entry=5)
	    at libbcachefs/journal.c:379
	#6  0x00000000004b5959 in bch2_journal_res_get_slowpath (j=0x7ffff7f81078, res=res@entry=0x7ffff3ff08f0, flags=flags@entry=5)
	    at libbcachefs/journal.c:454
	#7  0x00000000004af5a0 in bch2_journal_res_get (flags=5, u64s=<optimized out>, res=0x7ffff3ff08f0, j=<optimized out>)
	    at libbcachefs/journal.h:360
	#8  bch2_trans_journal_res_get (flags=5, trans=0x7ffff3ff0810) at libbcachefs/btree_update_leaf.c:301
	#9  bch2_trans_commit_write_locked (trace_ip=<optimized out>, stopped_at=<synthetic pointer>, trans=0x7ffff3ff0810)
	    at libbcachefs/btree_update_leaf.c:686
	#10 do_bch2_trans_commit (trace_ip=<optimized out>, stopped_at=<synthetic pointer>, trans=0x7ffff3ff0810)
	    at libbcachefs/btree_update_leaf.c:917
	#11 __bch2_trans_commit (trans=trans@entry=0x7ffff3ff0810) at libbcachefs/btree_update_leaf.c:1149
	#12 0x000000000049e5d0 in bch2_trans_commit (flags=<optimized out>, journal_seq=0x0, disk_res=0x0, trans=0x7ffff3ff0810)
	    at libbcachefs/btree_update.h:105
	#13 btree_key_cache_flush_pos (trans=trans@entry=0x7ffff3ff0810, key=..., journal_seq=journal_seq@entry=3, 
	    commit_flags=commit_flags@entry=64, evict=evict@entry=false) at libbcachefs/btree_key_cache.c:418
	#14 0x000000000049e8dc in bch2_btree_key_cache_journal_flush (j=0x7ffff7f81078, pin=0x9ef1c0, seq=3) at libbcachefs/btree_key_cache.c:492
	#15 0x0000000000494b37 in journal_flush_pins (j=j@entry=0x7ffff7f81078, seq_to_flush=seq_to_flush@entry=0, min_any=0, min_key_cache=0, 
	    min_key_cache@entry=1) at libbcachefs/journal_reclaim.c:506
	#16 0x0000000000495dac in __bch2_journal_reclaim (j=j@entry=0x7ffff7f81078, direct=direct@entry=false) at libbcachefs/journal_reclaim.c:645
	#17 0x0000000000495f33 in bch2_journal_reclaim_thread (arg=0x7ffff7f81078) at libbcachefs/journal_reclaim.c:684
	#18 0x00000000004216c3 in kthread_start_fn (data=0x832f40) at linux/kthread.c:25
	#19 0x00007ffff670bea5 in start_thread () from /lib64/libpthread.so.0
	#20 0x00007ffff5c229fd in clone () from /lib64/libc.so.6


====== Test 2 ======


(gdb) thr a a bt

Thread 1 (Thread 0x7ffff7fe4b80 (LWP 27067)):
	#0  0x00007ffff671254d in __lll_lock_wait () from /lib64/libpthread.so.0
	#1  0x00007ffff670de9b in _L_lock_883 () from /lib64/libpthread.so.0
	#2  0x00007ffff670dd68 in pthread_mutex_lock () from /lib64/libpthread.so.0
	#3  0x0000000000496239 in raw_spin_lock (lock=0x7ffff7f81328) at include/linux/spinlock.h:20
	#4  bch2_journal_pin_set (j=0x7ffff7f81078, seq=7, pin=0xbd6fc0, flush_fn=0x49e800 <bch2_btree_key_cache_journal_flush>)
	    at libbcachefs/journal_reclaim.c:380
	#5  0x00000000004a0d43 in bch2_journal_pin_update (flush_fn=0x49e800 <bch2_btree_key_cache_journal_flush>, pin=<optimized out>, 
	    seq=<optimized out>, j=0x7ffff7f81078) at libbcachefs/journal_reclaim.h:66
	#6  bch2_btree_insert_key_cached (trans=trans@entry=0x7fffffffd400, path=<optimized out>, insert=<optimized out>)
	    at libbcachefs/btree_key_cache.c:550
	#7  0x00000000004af900 in do_btree_insert_one (i=0x91f000, trans=0x7fffffffd400) at libbcachefs/btree_update_leaf.c:410
	#8  bch2_trans_commit_write_locked (trace_ip=<optimized out>, stopped_at=<synthetic pointer>, trans=0x7fffffffd400)
	    at libbcachefs/btree_update_leaf.c:738
	#9  do_bch2_trans_commit (trace_ip=<optimized out>, stopped_at=<synthetic pointer>, trans=0x7fffffffd400)
	    at libbcachefs/btree_update_leaf.c:917
	#10 __bch2_trans_commit (trans=trans@entry=0x7fffffffd400) at libbcachefs/btree_update_leaf.c:1149
	#11 0x0000000000461c28 in bch2_trans_commit (flags=0, journal_seq=0x0, disk_res=0x0, trans=0x7fffffffd400) at libbcachefs/btree_update.h:105
	#12 bch2_trans_mark_metadata_bucket (trans=trans@entry=0x7fffffffd400, ca=ca@entry=0x914800, b=4780, type=type@entry=BCH_DATA_journal, 
	    sectors=512) at libbcachefs/buckets.c:1905
	#13 0x0000000000461f80 in __bch2_trans_mark_dev_sb (ca=0x914800, trans=0x7fffffffd400) at libbcachefs/buckets.c:1971
	#14 bch2_trans_mark_dev_sb (c=c@entry=0x7ffff7f63000, ca=ca@entry=0x914800) at libbcachefs/buckets.c:1983
	#15 0x000000000049a544 in bch2_fs_initialize (c=0x7ffff7f63000) at libbcachefs/recovery.c:1394
	#16 0x00000000004768c3 in bch2_fs_start (c=c@entry=0x7ffff7f63000) at libbcachefs/super.c:898
	#17 0x0000000000478ee2 in bch2_fs_open (devices=devices@entry=0x8288d0, nr_devices=nr_devices@entry=1, opts=...) at libbcachefs/super.c:1905
	#18 0x0000000000412f92 in cmd_format (argc=argc@entry=2, argv=argv@entry=0x7fffffffe418) at cmd_format.c:268
	#19 0x0000000000407ff7 in main (argc=2, argv=0x7fffffffe418) at bcachefs.c:195

...

Thread 14 (Thread 0x7ffff3ff1700 (LWP 27169)):
	#0  0x00007ffff670ef0e in pthread_mutex_unlock () from /lib64/libpthread.so.0
	#1  0x000000000041c4a0 in del_timer (timer=timer@entry=0x7ffff7f813f0) at linux/timer.c:166
	#2  0x00000000004172f8 in grab_pending (work=work@entry=0x7ffff7f813d0, is_dwork=is_dwork@entry=true) at linux/workqueue.c:118
	#3  0x0000000000417722 in cancel_delayed_work (dwork=dwork@entry=0x7ffff7f813d0) at linux/workqueue.c:210
	#4  0x00000000004b1b8e in __journal_entry_close (j=0x7ffff7f81078, closed_val=<optimized out>) at libbcachefs/journal.c:140
	#5  0x00000000004b511d in __journal_res_get (j=j@entry=0x7ffff7f81078, res=res@entry=0x7ffff3ff08f0, flags=flags@entry=5)
	    at libbcachefs/journal.c:379
	#6  0x00000000004b5959 in bch2_journal_res_get_slowpath (j=0x7ffff7f81078, res=res@entry=0x7ffff3ff08f0, flags=flags@entry=5)
	    at libbcachefs/journal.c:454
	#7  0x00000000004af5a0 in bch2_journal_res_get (flags=5, u64s=<optimized out>, res=0x7ffff3ff08f0, j=<optimized out>)
	    at libbcachefs/journal.h:360
	#8  bch2_trans_journal_res_get (flags=5, trans=0x7ffff3ff0810) at libbcachefs/btree_update_leaf.c:301
	#9  bch2_trans_commit_write_locked (trace_ip=<optimized out>, stopped_at=<synthetic pointer>, trans=0x7ffff3ff0810)
	    at libbcachefs/btree_update_leaf.c:686
	#10 do_bch2_trans_commit (trace_ip=<optimized out>, stopped_at=<synthetic pointer>, trans=0x7ffff3ff0810)
	    at libbcachefs/btree_update_leaf.c:917
	#11 __bch2_trans_commit (trans=trans@entry=0x7ffff3ff0810) at libbcachefs/btree_update_leaf.c:1149
	#12 0x000000000049e5d0 in bch2_trans_commit (flags=<optimized out>, journal_seq=0x0, disk_res=0x0, trans=0x7ffff3ff0810)
	    at libbcachefs/btree_update.h:105
	#13 btree_key_cache_flush_pos (trans=trans@entry=0x7ffff3ff0810, key=..., journal_seq=journal_seq@entry=3, 
	    commit_flags=commit_flags@entry=64, evict=evict@entry=false) at libbcachefs/btree_key_cache.c:418
	#14 0x000000000049e8dc in bch2_btree_key_cache_journal_flush (j=0x7ffff7f81078, pin=0x9ef2c0, seq=3) at libbcachefs/btree_key_cache.c:492
	#15 0x0000000000494b37 in journal_flush_pins (j=j@entry=0x7ffff7f81078, seq_to_flush=seq_to_flush@entry=0, min_any=0, min_key_cache=0, 
	    min_key_cache@entry=1) at libbcachefs/journal_reclaim.c:506
	#16 0x0000000000495dac in __bch2_journal_reclaim (j=j@entry=0x7ffff7f81078, direct=direct@entry=false) at libbcachefs/journal_reclaim.c:645
	#17 0x0000000000495f33 in bch2_journal_reclaim_thread (arg=0x7ffff7f81078) at libbcachefs/journal_reclaim.c:684
	#18 0x00000000004216c3 in kthread_start_fn (data=0x832f40) at linux/kthread.c:25
	#19 0x00007ffff670bea5 in start_thread () from /lib64/libpthread.so.0
	#20 0x00007ffff5c229fd in clone () from /lib64/libc.so.6


> > Also, how long was the system in use before this happened? How many reboots?
> 
> Only 1 or 2 reboots.  Basically we set it up and it crashed because of the 
> iterator issue. Then we rebooted into the new kernel with both your 
> iterator fix and the new allocater update.  I think that's about it 
> though.
> 
> > Were you by chance running the resize-journal command?
> 
> Nope.  

-Eric

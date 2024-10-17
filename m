Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91FBB23A0
	for <linux-bcachefs@vger.kernel.org>; Thu, 17 Oct 2024 00:09:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729123784; cv=none; b=Ut7WCt6ksznOXhlMKk+O3q76ME22Dw/dbdW7k/1d1Uj3ZvkJKgJVAoIj9FeHnSdBVfz6acwSbCVS8mPNemvndF+SGg96Pqr1WEczkGxuoAL1i9jROtzQlHhwIrbibSnMdVG3lmd1ZV+wHBKQIC0YbiKfgJc7Rven3I0qO8HYIKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729123784; c=relaxed/simple;
	bh=EZCGqLgmfPNOwqN8Efc/5PPnlpY2D4fwv+Dr/+EA9S0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FV3MqJVMG2RnPx4MXJj2iNVSOpEA4okigZJJHqjHP7WvI/3KD0zzc3SLkBHowkL0A8uTPqjl6pPltnvlnfNGczAzgkFVGqUqARR4ZfQADbXQ5wjDyAFSl8Ao7DuVqk/aXl2kXgbSTATBxByB2LjWXekH58r5+N/UjDXiXo9NS1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=UMzLH6O8; arc=none smtp.client-ip=91.218.175.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="UMzLH6O8"
Date: Wed, 16 Oct 2024 20:09:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1729123779;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Z1jPL9y5Y/tCNQKQfi4LJFYG3lBdY6l8Ruhik61UelE=;
	b=UMzLH6O8g7//gJCDXaukCT42qOmHenb6hBJRJVoxhuYPJs7J7XxO2p7GLTsnFbPH5/kPN/
	2jQY27JkgSfEsx560hSGSCQzOwFJXRXNsIZoJ2iyLMfXjMzlE71P+8BVYzb9WT8g0R7RYV
	AW4RxVgMWLAZgTMLFVh0noON3kC+EWc=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: "Carl E. Thompson" <list-bcachefs@carlthompson.net>
Cc: "linux-bcachefs@vger.kernel.org" <linux-bcachefs@vger.kernel.org>
Subject: Re: Another bcachefs version downgrade bug
Message-ID: <46uitwudetmmygddpxufepddca7azsim6trqj4o2ivsccdeavz@uztkfyqtjgks>
References: <873903780.802.1729054276600@mail.carlthompson.net>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <873903780.802.1729054276600@mail.carlthompson.net>
X-Migadu-Flow: FLOW_OUT

On Tue, Oct 15, 2024 at 09:51:16PM -0700, Carl E. Thompson wrote:
> Hi,
> 
>      I believe there is another newer version downgrade bug in bcachefs (tested versions: 6.9.4 <--> 6.11.3).
> 
>      My laptop runs kernel 6.9.4 normally with 4 bcachefs filesystems
>      on LVM2 logical volumes mounted including the root filesystem. I
>      needed to test something under 6.11 so I booted kernel 6.11.3 and
>      used the system normally from the console (bcachefs worked fine
>      under 6.11.3). After attempting to boot back into 6.9.4 my laptop
>      no longer starts and hangs when trying to mount and manipulate
>      the root filesystem. The kernel log shows kernel traces due to
>      hung copygc tasks (see dmesg output below). This happens every
>      time I try to start 6.9.4 now. The kernel log reveals that the
>      bcachefs filesystem seems to complete the version downgrade and
>      initial mount successfully but it starts hanging as soon as the
>      filesystem is used. Booting back into the 6.11.3 kernel causes
>      the filesystems to work again but I can't run 6.11 on my laptop
>      normally because 6.11 (and 6.10) have amdgpu issues that cause
>      irrecoverable graphical desktop lockups. So right now I can
>      either choose to boot with filesystem s that don't work or with
>      periodic hard graphical desktop crashes neither of which is
>      ideal.

Yeah, it looks like 6.9 isn't running the recovery passess specified in
the superblock downgrade section, meaning we start running without
correct accounting counters - 6.10 works, though.

6.10 is a LTS release and 6.9 is not - is 6.10 an option?


> 
>      On my laptop and some of my other computers I boot multiple Linux distributions which usually run different kernels and mount the same filesystems on all of them (except root). So I do need to be able to switch back and forth between kernels as needed on all of my systems and these types of issues give me some pause. I will disable bcachefs use on my dev systems and servers for now until I am more confident that there is a solid testing plan in place to make sure there can be no more of these kind of issues in the future when booting multiple kernels. I will keep bcachefs on my laptop for testing. A fix for my laptop isn't urgent for me personally as I can recreate the filesystems under 6.9.4 and restore from backups. Of course others people might need a fix more quickly. Next time I need to boot a different kernel I'll make sure to create LVM snapshots of the devices first to which I can revert if needed. 
> 
> Thanks,
> Carl
> 
> show-super from one affected filesystem:
> ---
> [clip carl]# bcachefs show-super /dev/clip/root-alpine 
> Device:                                     (unknown device)
> External UUID:                             c992a5de-c9b3-4fd1-82ed-4d2f66bc11cb
> Internal UUID:                             43b4fe97-f5a4-48b3-8d99-3a3dda25211a
> Magic number:                              c68573f6-66ce-90a9-d96a-60cf803df7ef
> Device index:                              0
> Label:                                     (none)
> Version:                                   1.12: (unknown version)
> Version upgrade complete:                  1.12: (unknown version)
> Oldest version on disk:                    1.4: member_seq
> Created:                                   Fri Mar 22 19:19:01 2024
> Sequence number:                           249
> Time of last write:                        Tue Oct 15 20:23:34 2024
> Superblock size:                           4.45 KiB/1.00 MiB
> Clean:                                     0
> Devices:                                   1
> Sections:                                  members_v1,replicas_v0,clean,journal_seq_blacklist,journal_v2,counters,members_v2,errors,ext,downgrade
> Features:                                  lz4,journal_seq_blacklist_v3,reflink,new_siphash,inline_data,new_extent_overwrite,btree_ptr_v2,extents_above_btree_updates,btree_updates_journalled,reflink_inline_data,new_varint,journal_no_flush,alloc_v2,extents_across_btree_nodes
> Compat features:                           alloc_info,alloc_metadata,extents_above_btree_updates_done,bformat_overflow_done
> 
> Options:
>   block_size:                              4.00 KiB
>   btree_node_size:                         256 KiB
>   errors:                                  continue [fix_safe] panic ro 
>   metadata_replicas:                       1
>   data_replicas:                           1
>   metadata_replicas_required:              1
>   data_replicas_required:                  1
>   encoded_extent_max:                      64.0 KiB
>   metadata_checksum:                       none [crc32c] crc64 xxhash 
>   data_checksum:                           none [crc32c] crc64 xxhash 
>   compression:                             lz4
>   background_compression:                  none
>   str_hash:                                crc32c crc64 [siphash] 
>   metadata_target:                         none
>   foreground_target:                       none
>   background_target:                       none
>   promote_target:                          none
>   erasure_code:                            0
>   inodes_32bit:                            1
>   shard_inode_numbers:                     1
>   inodes_use_key_cache:                    1
>   gc_reserve_percent:                      8
>   gc_reserve_bytes:                        0 B
>   root_reserve_percent:                    0
>   wide_macs:                               0
>   promote_whole_extents:                   0
>   acl:                                     1
>   usrquota:                                0
>   grpquota:                                0
>   prjquota:                                0
>   journal_flush_delay:                     1000
>   journal_flush_disabled:                  0
>   journal_reclaim_delay:                   100
>   journal_transaction_names:               1
>   allocator_stuck_timeout:                 30
>   version_upgrade:                         [compatible] incompatible none 
>   nocow:                                   0
> 
> members_v2 (size 160):
> Device:                                    0
>   Label:                                   (none)
>   UUID:                                    352e33b9-dde4-48da-8fe2-255ae78c6320
>   Size:                                    24.0 GiB
>   read errors:                             0
>   write errors:                            0
>   checksum errors:                         2
>   seqread iops:                            0
>   seqwrite iops:                           0
>   randread iops:                           0
>   randwrite iops:                          0
>   Bucket size:                             256 KiB
>   First bucket:                            0
>   Buckets:                                 98304
>   Last mount:                              Tue Oct 15 20:23:32 2024
>   Last superblock write:                   249
>   State:                                   rw
>   Data allowed:                            journal,btree,user
>   Has data:                                journal,btree,user
>   Btree allocated bitmap blocksize:        1.00 MiB
>   Btree allocated bitmap:                  0000000000000000000000000000011111111111111111111111111111111111
>   Durability:                              1
>   Discard:                                 1
>   Freespace initialized:                   1
> 
> errors (size 24):
> bset_bad_csum                               1               Sat Jul  6 07:43:37 2024
> 
> 
> dmesg output:
> ---
> 
> ...
> 
> [  230.456893] bcachefs (dm-7): mounting version 1.12: (unknown version) opts=compression=lz4
> [  230.456911] bcachefs (dm-7): recovering from clean shutdown, journal seq 4901
> [  230.456915] bcachefs (dm-7): Version downgrade required:
> [  230.469098] bcachefs (dm-7): alloc_read... done
> [  230.469111] bcachefs (dm-7): stripes_read... done
> [  230.469115] bcachefs (dm-7): snapshots_read... done
> [  230.469436] bcachefs (dm-7): journal_replay... done
> [  230.469441] bcachefs (dm-7): resume_logged_ops... done
> [  230.469450] bcachefs (dm-7): going read-write
> [  368.351326] INFO: task bch-copygc/dm-7:547 blocked for more than 122 seconds.
> [  368.351336]       Not tainted 6.9.4-arch1-1 #1
> [  368.351338] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [  368.351340] task:bch-copygc/dm-7 state:D stack:0     pid:547   tgid:547   ppid:2      flags:0x00004000
> [  368.351345] Call Trace:
> [  368.351348]  <TASK>
> [  368.351354]  __schedule+0x3c7/0x1510
> [  368.351368]  schedule+0x27/0xf0
> [  368.351372]  __closure_sync+0x7e/0x140
> [  368.351382]  __bch2_write+0x136b/0x1660 [bcachefs 8d6f6bf430dcfbb124cd4a016333997e24e1fc8a]
> [  368.351436]  ? srso_alias_return_thunk+0x5/0xfbef5
> [  368.351440]  ? srso_alias_return_thunk+0x5/0xfbef5
> [  368.351441]  ? __kmalloc+0x1a7/0x440
> [  368.351446]  ? srso_alias_return_thunk+0x5/0xfbef5
> [  368.351448]  ? srso_alias_return_thunk+0x5/0xfbef5
> [  368.351452]  ? srso_alias_return_thunk+0x5/0xfbef5
> [  368.351454]  ? local_clock_noinstr+0xd/0xd0
> [  368.351456]  ? srso_alias_return_thunk+0x5/0xfbef5
> [  368.351457]  ? srso_alias_return_thunk+0x5/0xfbef5
> [  368.351460]  ? bch2_moving_ctxt_do_pending_writes+0x11a/0x220 [bcachefs 8d6f6bf430dcfbb124cd4a016333997e24e1fc8a]
> [  368.351489]  bch2_moving_ctxt_do_pending_writes+0x11a/0x220 [bcachefs 8d6f6bf430dcfbb124cd4a016333997e24e1fc8a]
> [  368.351511]  ? srso_alias_return_thunk+0x5/0xfbef5
> [  368.351512]  ? bch2_btree_path_traverse_one+0x958/0xcf0 [bcachefs 8d6f6bf430dcfbb124cd4a016333997e24e1fc8a]
> [  368.351539]  bch2_data_update_init+0x68b/0x1420 [bcachefs 8d6f6bf430dcfbb124cd4a016333997e24e1fc8a]
> [  368.351573]  ? bch2_move_extent+0x3da/0xed0 [bcachefs 8d6f6bf430dcfbb124cd4a016333997e24e1fc8a]
> [  368.351602]  bch2_move_extent+0x3da/0xed0 [bcachefs 8d6f6bf430dcfbb124cd4a016333997e24e1fc8a]
> [  368.351631]  ? bch2_evacuate_bucket+0x9d4/0xc00 [bcachefs 8d6f6bf430dcfbb124cd4a016333997e24e1fc8a]
> [  368.351652]  bch2_evacuate_bucket+0x9d4/0xc00 [bcachefs 8d6f6bf430dcfbb124cd4a016333997e24e1fc8a]
> [  368.351681]  ? bch2_copygc+0x210/0x880 [bcachefs 8d6f6bf430dcfbb124cd4a016333997e24e1fc8a]
> [  368.351702]  bch2_copygc+0x210/0x880 [bcachefs 8d6f6bf430dcfbb124cd4a016333997e24e1fc8a]
> [  368.351732]  bch2_copygc_thread+0x152/0x3d0 [bcachefs 8d6f6bf430dcfbb124cd4a016333997e24e1fc8a]
> [  368.351775]  ? bch2_copygc_thread+0xcf/0x3d0 [bcachefs 8d6f6bf430dcfbb124cd4a016333997e24e1fc8a]
> [  368.351828]  ? __pfx_bch2_copygc_thread+0x10/0x10 [bcachefs 8d6f6bf430dcfbb124cd4a016333997e24e1fc8a]
> [  368.351868]  kthread+0xcf/0x100
> [  368.351876]  ? __pfx_kthread+0x10/0x10
> [  368.351882]  ret_from_fork+0x31/0x50
> [  368.351889]  ? __pfx_kthread+0x10/0x10
> [  368.351894]  ret_from_fork_asm+0x1a/0x30
> [  368.351905]  </TASK>
> [  491.230894] INFO: task bch-copygc/dm-7:547 blocked for more than 245 seconds.
> [  491.230914]       Not tainted 6.9.4-arch1-1 #1
> [  491.230920] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [  491.230924] task:bch-copygc/dm-7 state:D stack:0     pid:547   tgid:547   ppid:2      flags:0x00004000
> [  491.230939] Call Trace:
> [  491.230944]  <TASK>
> [  491.230955]  __schedule+0x3c7/0x1510
> [  491.230984]  schedule+0x27/0xf0
> [  491.230993]  __closure_sync+0x7e/0x140
> [  491.231011]  __bch2_write+0x136b/0x1660 [bcachefs 8d6f6bf430dcfbb124cd4a016333997e24e1fc8a]
> [  491.231160]  ? srso_alias_return_thunk+0x5/0xfbef5
> [  491.231169]  ? srso_alias_return_thunk+0x5/0xfbef5
> [  491.231174]  ? __kmalloc+0x1a7/0x440
> [  491.231186]  ? srso_alias_return_thunk+0x5/0xfbef5
> [  491.231192]  ? srso_alias_return_thunk+0x5/0xfbef5
> [  491.231206]  ? srso_alias_return_thunk+0x5/0xfbef5
> [  491.231211]  ? local_clock_noinstr+0xd/0xd0
> [  491.231218]  ? srso_alias_return_thunk+0x5/0xfbef5
> [  491.231223]  ? srso_alias_return_thunk+0x5/0xfbef5
> [  491.231232]  ? bch2_moving_ctxt_do_pending_writes+0x11a/0x220 [bcachefs 8d6f6bf430dcfbb124cd4a016333997e24e1fc8a]
> [  491.231340]  bch2_moving_ctxt_do_pending_writes+0x11a/0x220 [bcachefs 8d6f6bf430dcfbb124cd4a016333997e24e1fc8a]
> [  491.231412]  ? srso_alias_return_thunk+0x5/0xfbef5
> [  491.231418]  ? bch2_btree_path_traverse_one+0x958/0xcf0 [bcachefs 8d6f6bf430dcfbb124cd4a016333997e24e1fc8a]
> [  491.231509]  bch2_data_update_init+0x68b/0x1420 [bcachefs 8d6f6bf430dcfbb124cd4a016333997e24e1fc8a]
> [  491.231625]  ? bch2_move_extent+0x3da/0xed0 [bcachefs 8d6f6bf430dcfbb124cd4a016333997e24e1fc8a]
> [  491.231732]  bch2_move_extent+0x3da/0xed0 [bcachefs 8d6f6bf430dcfbb124cd4a016333997e24e1fc8a]
> [  491.231823]  ? bch2_evacuate_bucket+0x9d4/0xc00 [bcachefs 8d6f6bf430dcfbb124cd4a016333997e24e1fc8a]
> [  491.231883]  bch2_evacuate_bucket+0x9d4/0xc00 [bcachefs 8d6f6bf430dcfbb124cd4a016333997e24e1fc8a]
> [  491.231963]  ? bch2_copygc+0x210/0x880 [bcachefs 8d6f6bf430dcfbb124cd4a016333997e24e1fc8a]
> [  491.232022]  bch2_copygc+0x210/0x880 [bcachefs 8d6f6bf430dcfbb124cd4a016333997e24e1fc8a]
> [  491.232089]  bch2_copygc_thread+0x152/0x3d0 [bcachefs 8d6f6bf430dcfbb124cd4a016333997e24e1fc8a]
> [  491.232148]  ? bch2_copygc_thread+0xcf/0x3d0 [bcachefs 8d6f6bf430dcfbb124cd4a016333997e24e1fc8a]
> [  491.232217]  ? __pfx_bch2_copygc_thread+0x10/0x10 [bcachefs 8d6f6bf430dcfbb124cd4a016333997e24e1fc8a]
> [  491.232271]  kthread+0xcf/0x100
> [  491.232282]  ? __pfx_kthread+0x10/0x10
> [  491.232289]  ret_from_fork+0x31/0x50
> [  491.232298]  ? __pfx_kthread+0x10/0x10
> [  491.232304]  ret_from_fork_asm+0x1a/0x30
> [  491.232319]  </TASK>
> 
> ...

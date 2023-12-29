Received: from smtp.carlthompson.net (charon.carlthompson.net [45.77.7.122])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EEF723B3
	for <linux-bcachefs@vger.kernel.org>; Fri, 29 Dec 2023 02:13:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=carlthompson.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=carlthompson.net
Received: from mail.carlthompson.net (mail.home [10.35.20.252])
	(Authenticated sender: cet@carlthompson.net)
	by smtp.carlthompson.net (Postfix) with ESMTPSA id B7B2114006409;
	Thu, 28 Dec 2023 18:13:10 -0800 (PST)
Date: Thu, 28 Dec 2023 18:13:10 -0800 (PST)
From: "Carl E. Thompson" <list-bcachefs@carlthompson.net>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: "linux-bcachefs@vger.kernel.org" <linux-bcachefs@vger.kernel.org>
Message-ID: <640958876.495.1703815990565@mail.carlthompson.net>
In-Reply-To: <1130552865.471.1703815212412@mail.carlthompson.net>
References: <1804957404.243.1703798376220@mail.carlthompson.net>
 <vvwnfhsza5ztknnugwgzwyzduaw4uj4wff3ibhr3etpuphojfm@s4wq6fv4322o>
 <1130552865.471.1703815212412@mail.carlthompson.net>
Subject: Re: bcachefs subvols / snapshots broken
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

One weird thing I notice looking at my show-super output is that is says 'Durability: 2' for the single device used by the filesystem (a LVM2 thin logical volume). I did not fiddle with the durability option and the filesystem only has the one device. I would think that durability for the device should default to 1 not 2 or am I misunderstanding how things work?

Thank you,
Carl Thompson

> On 2023-12-28 6:00 PM PST Carl E. Thompson <list-bcachefs@carlthompson.net> wrote:
> 
>  
> (BTW, I've been silently testing bcachefs for a couple of years or more and I have not had any serious issues. Thanks for all the hard work you've put into it!)
> 
> If it helps here is some more information about the primary system I'm testing on. My other systems use the exact same kernel and similar / same options:
> ---
> [carl@clip test]$ uname -a
> Linux clip 6.7.0-rc7-1-mainline #1 SMP PREEMPT_DYNAMIC Mon, 25 Dec 2023 11:59:43 +0000 x86_64 GNU/Linux
> 
> [carl@clip test]$ zgrep BCACHEFS /proc/config.gz 
> CONFIG_BCACHEFS_FS=m
> CONFIG_BCACHEFS_QUOTA=y
> # CONFIG_BCACHEFS_ERASURE_CODING is not set
> CONFIG_BCACHEFS_POSIX_ACL=y
> # CONFIG_BCACHEFS_DEBUG_TRANSACTIONS is not set
> # CONFIG_BCACHEFS_DEBUG is not set
> # CONFIG_BCACHEFS_TESTS is not set
> # CONFIG_BCACHEFS_LOCK_TIME_STATS is not set
> # CONFIG_BCACHEFS_NO_LATENCY_ACCT is not set
> 
> [carl@clip test]$ sudo bcachefs show-super /dev/clip/home
> External UUID:                              e11c50b1-c943-47cc-ba3d-c3962b730725
> Internal UUID:                              cd1c2204-2dd3-4a3f-a050-3ec49c94c776
> Device index:                               0
> Label:                                      
> Version:                                    1.3: rebalance_work
> Version upgrade complete:                   1.3: rebalance_work
> Oldest version on disk:                     1.3: rebalance_work
> Created:                                    Sun Dec  3 23:02:10 2023
> Sequence number:                            49
> Superblock size:                            4440
> Clean:                                      0
> Devices:                                    1
> Sections:                                   members_v1,replicas_v0,clean,journal_v2,counters,members_v2,errors
> Features:                                   lz4,reflink,new_siphash,inline_data,new_extent_overwrite,btree_ptr_v2,extents_above_btree_updates,btree_updates_journalled,reflink_inline_data,new_varint,journal_no_flush,alloc_v2,extents_across_btree_nodes
> Compat features:                            alloc_info,alloc_metadata,extents_above_btree_updates_done,bformat_overflow_done
> 
> Options:
>   block_size:                               4.00 KiB
>   btree_node_size:                          256 KiB
>   errors:                                   continue [ro] panic 
>   metadata_replicas:                        1
>   data_replicas:                            1
>   metadata_replicas_required:               1
>   data_replicas_required:                   1
>   encoded_extent_max:                       64.0 KiB
>   metadata_checksum:                        none [crc32c] crc64 xxhash 
>   data_checksum:                            none [crc32c] crc64 xxhash 
>   compression:                              lz4
>   background_compression:                   none
>   str_hash:                                 crc32c crc64 [siphash] 
>   metadata_target:                          none
>   foreground_target:                        none
>   background_target:                        none
>   promote_target:                           none
>   erasure_code:                             0
>   inodes_32bit:                             1
>   shard_inode_numbers:                      1
>   inodes_use_key_cache:                     1
>   gc_reserve_percent:                       8
>   gc_reserve_bytes:                         0 B
>   root_reserve_percent:                     0
>   wide_macs:                                0
>   acl:                                      1
>   usrquota:                                 0
>   grpquota:                                 0
>   prjquota:                                 0
>   journal_flush_delay:                      1000
>   journal_flush_disabled:                   0
>   journal_reclaim_delay:                    100
>   journal_transaction_names:                1
>   version_upgrade:                          [compatible] incompatible none 
>   nocow:                                    0
> 
> members_v2 (size 136):
>   Device:                                   0
>     Label:                                  (none)
>     UUID:                                   d63c3aab-8498-4cd9-9758-96321e708509
>     Size:                                   800 GiB
>     read errors:                            0
>     write errors:                           0
>     checksum errors:                        0
>     seqread iops:                           0
>     seqwrite iops:                          0
>     randread iops:                          0
>     randwrite iops:                         0
>     Bucket size:                            512 KiB
>     First bucket:                           0
>     Buckets:                                1638400
>     Last mount:                             Thu Dec 28 12:20:27 2023
>     State:                                  rw
>     Data allowed:                           journal,btree,user
>     Has data:                               journal,btree,user
>     Durability:                             2
>     Discard:                                1
>     Freespace initialized:                  1
> 
> replicas_v0 (size 24):
>   btree: 1 [0] journal: 1 [0] user: 1 [0]
> 
> [carl@clip test]$ bcachefs version
> 1.3.3
> 
> [carl@clip test]$ grep . /sys/fs/bcachefs/e11c50b1-c943-47cc-ba3d-c3962b730725/options/*
> /sys/fs/bcachefs/e11c50b1-c943-47cc-ba3d-c3962b730725/options/acl:1
> /sys/fs/bcachefs/e11c50b1-c943-47cc-ba3d-c3962b730725/options/background_compression:none
> /sys/fs/bcachefs/e11c50b1-c943-47cc-ba3d-c3962b730725/options/background_target:none
> /sys/fs/bcachefs/e11c50b1-c943-47cc-ba3d-c3962b730725/options/block_size:4.00 KiB
> /sys/fs/bcachefs/e11c50b1-c943-47cc-ba3d-c3962b730725/options/btree_node_mem_ptr_optimization:1
> /sys/fs/bcachefs/e11c50b1-c943-47cc-ba3d-c3962b730725/options/btree_node_size:256 KiB
> /sys/fs/bcachefs/e11c50b1-c943-47cc-ba3d-c3962b730725/options/btree_write_buffer_size:8192
> /sys/fs/bcachefs/e11c50b1-c943-47cc-ba3d-c3962b730725/options/compression:lz4
> /sys/fs/bcachefs/e11c50b1-c943-47cc-ba3d-c3962b730725/options/data_checksum:none [crc32c] crc64 xxhash 
> /sys/fs/bcachefs/e11c50b1-c943-47cc-ba3d-c3962b730725/options/data_replicas:1
> /sys/fs/bcachefs/e11c50b1-c943-47cc-ba3d-c3962b730725/options/data_replicas_required:1
> /sys/fs/bcachefs/e11c50b1-c943-47cc-ba3d-c3962b730725/options/degraded:0
> /sys/fs/bcachefs/e11c50b1-c943-47cc-ba3d-c3962b730725/options/direct_io:1
> /sys/fs/bcachefs/e11c50b1-c943-47cc-ba3d-c3962b730725/options/discard:1
> /sys/fs/bcachefs/e11c50b1-c943-47cc-ba3d-c3962b730725/options/encoded_extent_max:64.0 KiB
> /sys/fs/bcachefs/e11c50b1-c943-47cc-ba3d-c3962b730725/options/erasure_code:0
> /sys/fs/bcachefs/e11c50b1-c943-47cc-ba3d-c3962b730725/options/errors:continue [ro] panic 
> /sys/fs/bcachefs/e11c50b1-c943-47cc-ba3d-c3962b730725/options/fix_errors:exit
> /sys/fs/bcachefs/e11c50b1-c943-47cc-ba3d-c3962b730725/options/foreground_target:none
> /sys/fs/bcachefs/e11c50b1-c943-47cc-ba3d-c3962b730725/options/fsck:0
> /sys/fs/bcachefs/e11c50b1-c943-47cc-ba3d-c3962b730725/options/gc_reserve_bytes:0 B
> /sys/fs/bcachefs/e11c50b1-c943-47cc-ba3d-c3962b730725/options/gc_reserve_percent:8
> /sys/fs/bcachefs/e11c50b1-c943-47cc-ba3d-c3962b730725/options/grpquota:0
> /sys/fs/bcachefs/e11c50b1-c943-47cc-ba3d-c3962b730725/options/inline_data:1
> /sys/fs/bcachefs/e11c50b1-c943-47cc-ba3d-c3962b730725/options/inodes_32bit:1
> /sys/fs/bcachefs/e11c50b1-c943-47cc-ba3d-c3962b730725/options/inodes_use_key_cache:1
> /sys/fs/bcachefs/e11c50b1-c943-47cc-ba3d-c3962b730725/options/journal_flush_delay:1000
> /sys/fs/bcachefs/e11c50b1-c943-47cc-ba3d-c3962b730725/options/journal_flush_disabled:0
> /sys/fs/bcachefs/e11c50b1-c943-47cc-ba3d-c3962b730725/options/journal_reclaim_delay:100
> /sys/fs/bcachefs/e11c50b1-c943-47cc-ba3d-c3962b730725/options/journal_transaction_names:1
> /sys/fs/bcachefs/e11c50b1-c943-47cc-ba3d-c3962b730725/options/metadata_checksum:none [crc32c] crc64 xxhash 
> /sys/fs/bcachefs/e11c50b1-c943-47cc-ba3d-c3962b730725/options/metadata_replicas:1
> /sys/fs/bcachefs/e11c50b1-c943-47cc-ba3d-c3962b730725/options/metadata_replicas_required:1
> /sys/fs/bcachefs/e11c50b1-c943-47cc-ba3d-c3962b730725/options/metadata_target:none
> /sys/fs/bcachefs/e11c50b1-c943-47cc-ba3d-c3962b730725/options/move_bytes_in_flight:1.00 MiB
> /sys/fs/bcachefs/e11c50b1-c943-47cc-ba3d-c3962b730725/options/move_ios_in_flight:32
> /sys/fs/bcachefs/e11c50b1-c943-47cc-ba3d-c3962b730725/options/nochanges:0
> /sys/fs/bcachefs/e11c50b1-c943-47cc-ba3d-c3962b730725/options/nocow:0
> /sys/fs/bcachefs/e11c50b1-c943-47cc-ba3d-c3962b730725/options/nocow_enabled:1
> /sys/fs/bcachefs/e11c50b1-c943-47cc-ba3d-c3962b730725/options/noexcl:0
> /sys/fs/bcachefs/e11c50b1-c943-47cc-ba3d-c3962b730725/options/norecovery:0
> /sys/fs/bcachefs/e11c50b1-c943-47cc-ba3d-c3962b730725/options/prjquota:0
> /sys/fs/bcachefs/e11c50b1-c943-47cc-ba3d-c3962b730725/options/promote_target:none
> /sys/fs/bcachefs/e11c50b1-c943-47cc-ba3d-c3962b730725/options/ratelimit_errors:1
> /sys/fs/bcachefs/e11c50b1-c943-47cc-ba3d-c3962b730725/options/read_only:0
> /sys/fs/bcachefs/e11c50b1-c943-47cc-ba3d-c3962b730725/options/reconstruct_alloc:0
> /sys/fs/bcachefs/e11c50b1-c943-47cc-ba3d-c3962b730725/options/root_reserve_percent:0
> /sys/fs/bcachefs/e11c50b1-c943-47cc-ba3d-c3962b730725/options/shard_inode_numbers:1
> /sys/fs/bcachefs/e11c50b1-c943-47cc-ba3d-c3962b730725/options/str_hash:crc32c crc64 [siphash] 
> /sys/fs/bcachefs/e11c50b1-c943-47cc-ba3d-c3962b730725/options/usrquota:0
> /sys/fs/bcachefs/e11c50b1-c943-47cc-ba3d-c3962b730725/options/verbose:0
> /sys/fs/bcachefs/e11c50b1-c943-47cc-ba3d-c3962b730725/options/version_upgrade:[compatible] incompatible none 
> /sys/fs/bcachefs/e11c50b1-c943-47cc-ba3d-c3962b730725/options/very_degraded:0
> /sys/fs/bcachefs/e11c50b1-c943-47cc-ba3d-c3962b730725/options/wide_macs:0
> ---
> 
> Thank you,
> Carl Thompson
> 
> 
> > On 2023-12-28 5:38 PM PST Kent Overstreet <kent.overstreet@linux.dev> wrote:
> > 
> >  
> > On Thu, Dec 28, 2023 at 01:19:36PM -0800, Carl E. Thompson wrote:
> > > Hello, there appears to be a bug in bcachefs in which certain changes to subvolumes and snapshots can result in file contents not being read properly when copied. Specifically, if a snapshot is created of a subvolume and a file in either the subvolume or the snapshot is removed or modified, incorrect data is read from the corresponding unmodified file in the subvolume or snapshot if that corresponding file is copied. I've reproduced on multiple systems running rc6 and rc7 but on my systems I can reproduce this 100% of the time on bcachefs filesystems where the block size is 4k; I cannot reproduce at all on filesystems with 512 byte blocks (but see below). I've only tested with 4k and 512 block sizes. None of the other format options I've tried made a difference in my tests including compression and bucket size.
> > > 
> > > Here is a short example:
> > > ---
> > > [carl@clip test]$ bcachefs subvolume create subvol
> > > 
> > > [carl@clip test]$ echo "Test" > subvol/file
> > > 
> > > [carl@clip test]$ bcachefs subvolume snapshot subvol snapshot_of_subvol
> > > 
> > > [carl@clip test]$ rm subvol/file 
> > > 
> > > [carl@clip test]$ cat snapshot_of_subvol/file 
> > > Test
> > > 
> > > [carl@clip test]$ cp snapshot_of_subvol/file file
> > > 
> > > [carl@clip test]$ cat file
> > > 
> > > [carl@clip test]$ ls -l file
> > > -rw-r--r-- 1 carl carl 5 Dec 28 12:56 file
> > > 
> > > [carl@clip test]$ hexdump -C file
> > > 00000000  00 00 00 00 00                                    |.....|
> > > 00000005
> > > 
> > > [carl@clip test]$ 
> > > ---
> > > 
> > > - The copied file has the correct length but has zeroes instead of the correct data
> > > - The problem also occurs if the file in the **snapshot** is removed or modified and the original file in the subvolume is copied
> > > - In my tests I only see the problem on filesystems with 4k blocks. I've never been able to reproduce with 512 byte blocks. However someone else on Reddit says that it definitely happened to them on a filesystem with 512 byte blocks (but they can't reproduce it now)
> > > - The bug only happens if the file is copied to the same bcachefs filesystem. It does **not** happen if the file is copied to a different bcachefs filesystem or a different filesystem entirely
> > > - The bug does **not** occur if the cp command is given the `--reflink=never` option
> > > - Discussion can be found on this Reddit thread (but not all comments are correct: https://www.reddit.com/r/bcachefs/comments/18sbl9z/how_do_you_restore_a_file_from_a_snapshot/
> > > 
> > > In my opinion this is a severe issue because it could lead to data loss if users rely on copied files having the correct contents.
> > 
> > Curiously, I'm not able to reproduce it so far with your test - but when
> > I test with a larger file, everything after a certain point is all
> > zeroes.
> > 
> > Investigating further...

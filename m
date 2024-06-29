Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 356D440858
	for <linux-bcachefs@vger.kernel.org>; Sat, 29 Jun 2024 23:09:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719702559; cv=none; b=dbS2CZXgJRAKoL+meh9v7zboN+zLySKlzrrj56S0Rs521WW9yL1sm77wcEg5m+iAgelX7VIBhDgs/5kG9AxNGB9QpE+CkTTPI2QDfZmo/kNRYv1tOiMo1B5d3agzEVED8xU0fIqldMc1Kqfq0tNPtwHkWi/LKvdbGRwf6SCIfk0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719702559; c=relaxed/simple;
	bh=Ld9i7lDuJAsxtJ+iGJx1qHxFuAV1zRRUYqF+HiFJgI0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DtssyEypI115poSzd8GSwt9vFQ4Q0crEgfX9T5maeQH1LLAT/3JN+jtneJPK6q2mVe+VodJNTri/8lnz3so9dP7k9KQ8LEuSxxJg1r8upmplHfLPVEClXgguNFA/d+kpgR5F5xzFWhBM5J+KnvD54hJczQK+NU9OgrxEYpTjdBI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=cc/DTKyk; arc=none smtp.client-ip=91.218.175.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="cc/DTKyk"
X-Envelope-To: martin@lichtvoll.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1719702547;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hCNE697dMiBX9X7F6VaRD4tS9eYtAY2P8KIN9RpyhQc=;
	b=cc/DTKykuEEXPkP5mWjvzljd2fzVz/nPV83Ng8TgK9txJBCphBcORwRvzWmmQqm+uk3ipQ
	lmre9UcpyPpwOK/qP8MI7PG/r16fvnnTLU2s08kx3Jr87hYWFnxNFANvM+S6r9p7busUXi
	4NqKYW1/9MBFlM+7dumiXib/dk0K8YQ=
X-Envelope-To: linux-bcachefs@vger.kernel.org
Date: Sat, 29 Jun 2024 19:09:04 -0400
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Martin Steigerwald <martin@lichtvoll.de>
Cc: linux-bcachefs@vger.kernel.org
Subject: Re: rsync stuck in "D" state short after starting to copy to a newly
 created filesystem
Message-ID: <yeufrfd5uy3qhjrzreqg6txlwelx36e7ywobbvvhqzl4cfjzlu@twptk6kdfufr>
References: <22338011.EfDdHjke4D@lichtvoll.de>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <22338011.EfDdHjke4D@lichtvoll.de>
X-Migadu-Flow: FLOW_OUT

On Fri, Jun 28, 2024 at 01:55:08PM +0200, Martin Steigerwald wrote:
> Hi!
> 
> I am ending a migration from a ThinkPad T14 AMD Gen 1 to a ThinkPad T14
> AMD Gen 5.
> 
> Last filesystem is a BCacheFS with some larger files that I use for testing
> BCacheFS. rsync was directly pulling from the older laptop over 1 GBit
> link through my local router. All other filesystems are BTRFS and there
> have not been an issue with migrating about 1,8 TiB of data to three
> BTRFS filesystems via rsync.
> 
> Standard Debian Unstable Kernel as of today (on Devuan):
> 
> Linux version 6.9.7-amd64 (debian-kernel@lists.debian.org)
> (x86_64-linux-gnu-gcc-13 (Debian 13.3.0-1) 13.3.0,
> GNU ld (GNU Binutils for Debian) 2.42.50.20240625)
> #1 SMP PREEMPT_DYNAMIC Debian 6.9.7-1 (2024-06-27)
> 
> % bcachefs version
> 1.9.1
> 
> SSD is 4 TB Samsung 990 Pro. BCacheFS is on LUKS encrypted LVM as the
> BTRFS filesystems as well.
> 
> I created BCacheFS as follows (this is from a subsequent mkfs.bcachefs.
> I do not have initial output anymore as I already overwrote it with the
> new successful attempt in my documentation, but other than UUIDs nothing
> should have changed I bet, the parameters were identical - see below for
> the successful attempt):
> 
> % mkfs.bcachefs --data_checksum xxhash --metadata_checksum xxhash
> --compression=lz4 /dev/nvme1/daten2
> [… identifiers deleted …]
> Device index:                              0
> Label:                                     
> Version:                                   1.7: mi_btree_bitmap
> Version upgrade complete:                  0.0: (unknown version)
> Oldest version on disk:                    1.7: mi_btree_bitmap
> Created:                                   […]
> Sequence number:                           0
> Time of last write:                        Thu Jan  1 01:00:00 1970
> Superblock size:                           976 B/1.00 MiB
> Clean:                                     0
> Devices:                                   1
> Sections:                                  members_v1,members_v2
> Features:                                  
> Compat features:                           
> 
> Options:
> block_size:                              512 B
> btree_node_size:                         256 KiB
> errors:                                  continue [ro] panic 
> metadata_replicas:                       1
> data_replicas:                           1
> metadata_replicas_required:              1
> data_replicas_required:                  1
> encoded_extent_max:                      64.0 KiB
> metadata_checksum:                       none crc32c crc64 [xxhash] 
> data_checksum:                           none crc32c crc64 [xxhash] 
> compression:                             lz4
> background_compression:                  none
> str_hash:                                crc32c crc64 [siphash] 
> metadata_target:                         none
> foreground_target:                       none
> background_target:                       none
> promote_target:                          none
> erasure_code:                            0
> inodes_32bit:                            1
> shard_inode_numbers:                     1
> inodes_use_key_cache:                    1
> gc_reserve_percent:                      8
> gc_reserve_bytes:                        0 B
> root_reserve_percent:                    0
> wide_macs:                               0
> acl:                                     1
> usrquota:                                0
> grpquota:                                0
> prjquota:                                0
> journal_flush_delay:                     1000
> journal_flush_disabled:                  0
> journal_reclaim_delay:                   100
> journal_transaction_names:               1
> version_upgrade:                         [compatible] incompatible none 
> nocow:                                   0
> 
> members_v2 (size 160):
> Device:                                    0
> Label:                                   (none)
> UUID:                                    […]
> Size:                                    300 GiB
> read errors:                             0
> write errors:                            0
> checksum errors:                         0
> seqread iops:                            0
> seqwrite iops:                           0
> randread iops:                           0
> randwrite iops:                          0
> Bucket size:                             256 KiB
> First bucket:                            0
> Buckets:                                 1228800
> Last mount:                              (never)
> Last superblock write:                   0
> State:                                   rw
> Data allowed:                            journal,btree,user
> Has data:                                (none)
> Btree allocated bitmap blocksize:        1.00 B
> Btree allocated bitmap:                  0000000000000000000000000000000000000000000000000000000000000000
> Durability:                              1
> Discard:                                 0
> Freespace initialized:                   0
> 
> 
> Directly after creating it I mounted it from /etc/fstab:
> 
> /dev/nvme1/daten2 /daten2 bcachefs lazytime 0 0
> 
> Soon after the copying process started, rsync got stuck in "D" state.
> It was within the first 500 MiB or so. Nothing in kernel log. I waited
> a bit and then stopped rsync. One rsync process remained in "D" state
> and thus did not go away. I tried another time and one the rsync
> processes was immediately in "D" state.
> 
> Thus I rebooted. Runit hung during reboot. Likely due to processes in
> D state. I eventually switched up the laptop by pressing the power
> button long enough.
> 
> I did an fsck.bcachefs and got:
> 
> % fsck.bcachefs /dev/nvme1/daten2 
> fsck binary is version 1.9: disk_accounting_v2 but filesystem is 1.7: mi_btree_bitmap and kernel is 1.7: mi_btree_bitmap, using kernel fsck
> bcachefs (dm-5): mounting version 1.7: mi_btree_bitmap opts=ro,metadata_checksum=xxhash,data_checksum=xxhash,compression=lz4,degraded,fsck,fix_errors=ask,read_only
> bcachefs (dm-5): recovering from clean shutdown, journal seq 45
> bcachefs (dm-5): journal read done, replaying entries 45-45
> bcachefs (dm-5): alloc_read... done
> bcachefs (dm-5): stripes_read... done
> bcachefs (dm-5): snapshots_read... done
> bcachefs (dm-5): check_allocations...key version number higher than recorded: 73014444594 > 0: fix? (y,n, or Y,N for all errors of this type) y
> key version number higher than recorded: 81604378807 > 73014444594: fix? (y,n, or Y,N for all errors of this type) y
> dev 0 has wrong free buckets: got 0, should be 1220580: fix? (y,n, or Y,N for all errors of this type) y
> dev 0 has wrong sb buckets: got 0, should be 13: fix? (y,n, or Y,N for all errors of this type) y
> dev 0 has wrong sb sectors: got 0, should be 6152: fix? (y,n, or Y,N for all errors of this type) y
> dev 0 has wrong sb fragmented: got 0, should be 504: fix? (y,n, or Y,N for all errors of this type) y
> dev 0 has wrong journal buckets: got 0, should be 8192: fix? (y,n, or Y,N for all errors of this type) y
> dev 0 has wrong journal sectors: got 0, should be 4194304: fix? (y,n, or Y,N for all errors of this type) y
> dev 0 has wrong btree buckets: got 0, should be 15: fix? (y,n, or Y,N for all errors of this type) y
> dev 0 has wrong btree sectors: got 0, should be 7680: fix? (y,n, or Y,N for all errors of this type) y
> fs has wrong hidden: got 0, should be 4200960: fix? (y,n, or Y,N for all errors of this type) y
> fs has wrong btree: got 0, should be 7680: fix? (y,n, or Y,N for all errors of this type) y
> fs has wrong nr_inodes: got 20, should be 22: fix? (y,n, or Y,N for all errors of this type) y
> fs has wrong btree: 1/1 [0]: got 0, should be 7680: fix? (y,n, or Y,N for all errors of this type) y
> done
> bcachefs (dm-5): going read-write
> bcachefs (dm-5): journal_replay... done
> bcachefs (dm-5): check_alloc_info...y done
> bcachefs (dm-5): check_lrus... done
> bcachefs (dm-5): check_btree_backpointers... done
> bcachefs (dm-5): check_backpointers_to_extents... done
> bcachefs (dm-5): check_extents_to_backpointers... done
> bcachefs (dm-5): check_alloc_to_lru_refs... done
> bcachefs (dm-5): check_snapshot_trees... done
> bcachefs (dm-5): check_snapshots... done
> bcachefs (dm-5): check_subvols... done
> bcachefs (dm-5): check_subvol_children... done
> bcachefs (dm-5): delete_dead_snapshots... done
> bcachefs (dm-5): check_inodes... done
> bcachefs (dm-5): check_extents... done
> bcachefs (dm-5): check_indirect_extents... done
> bcachefs (dm-5): check_dirents... done
> bcachefs (dm-5): check_xattrs... done
> bcachefs (dm-5): check_root... done
> bcachefs (dm-5): check_subvolume_structure... done
> bcachefs (dm-5): check_directory_structure... done
> bcachefs (dm-5): check_nlinks... done
> bcachefs (dm-5): resume_logged_ops... done
> bcachefs (dm-5): delete_dead_inodes... done
> bcachefs (dm-5): shutdown complete, journal seq 47
> dm-5: errors fixed
> 
> For a regular unclean shutdown I would not have expected any filesystem
> errors. A subsequent call to "fsck.bcachefs" revealed no further errors.
> 
> I mounted the filesystem again and tried another time with rsync and
> it did not seem to get stuck as before. However I felt uncomfortable
> with continuing with a filesystem that has had errors already.
> Especially at BCacheFS is still marked experimental.

This should all be fixed in this branch:
https://evilpiepirate.org/git/bcachefs.git/log/?h=bcachefs-for-6.9

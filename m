Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF6461DDF5
	for <linux-bcachefs@vger.kernel.org>; Fri, 28 Jun 2024 14:45:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719585919; cv=none; b=GOsxAJUkMaCFRDNJkUG+yTQzna58nqa3VVmTS/K1ETq+Y1ZTJ/iSIRoMshH41aTcpwzC6WCEJkYN/li0fLSFYOUD34ZpLDO+F+t/iXzLIy7k1YGfmUyyAZp0Y3i80vuvdnztqtQXpnF2GiORi/oWN4HeFPOEkP7mo1ejyudyFlg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719585919; c=relaxed/simple;
	bh=ffbztJGr5okQ24X/ZDu8CPa4TbpcmIfw3ntvzlcLh1E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mHlI+lGgKO0QWQtBicg6pPE1O/nf9JejbGLd1q505IS57k8hJWZyFFsQQJ6mmyfwEQmgXPTJrBI8NyodnhsDywr/wUa09iHDMrcNO9v7/bok1VYqBD8aNYxgNuVILYElLSFyzoWW6ZLKvnDpm0yNMk2pqjAwMhFyxyCeDZniNkk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=qwDRGi0A; arc=none smtp.client-ip=91.218.175.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="qwDRGi0A"
X-Envelope-To: martin@lichtvoll.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1719585912;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BBQ/9u3s3GR5igJ0NqLTKQM3C7zVEp7r2xVAeqgt+m4=;
	b=qwDRGi0AqAuKQl5JsqoAOrJFts5dOESl9rQbhPxu3WWjKqPPB4dEf1BbhI+Ki3vuHe7DSw
	HWs7gWJggw3ly4gZJcVBRglW41DicAKwFaDVmvhDRmYYXCxBYSqGDMrqC632i7WbqeN2mV
	gpGhbJ/yfhXGxC/Hy5BdtQJ2oGkRyOs=
X-Envelope-To: linux-bcachefs@vger.kernel.org
Date: Fri, 28 Jun 2024 10:45:09 -0400
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Martin Steigerwald <martin@lichtvoll.de>
Cc: linux-bcachefs@vger.kernel.org
Subject: Re: rsync stuck in "D" state short after starting to copy to a newly
 created filesystem
Message-ID: <5lplsf7uo34apmvo3zq3olnr6zwxe3hdhpny5deyieq3jc3arb@rncjrrcjtxlf>
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

The errors are because tools is currently at on disk format version 1.9,
but Linus's tree is still at 1.7, and there was a bug in the downgrade
sb section code that caused us to not run the right recovery passes when
downgrading (just sent the fix today).

We usually don't do the filesystem initialization in userspace on
version mismatch, but you probably had bcachefs built as a module.

> I mounted the filesystem again and tried another time with rsync and
> it did not seem to get stuck as before. However I felt uncomfortable
> with continuing with a filesystem that has had errors already.
> Especially at BCacheFS is still marked experimental.
> 
> Also I thought maybe it did not like being mounted without a reboot.
> Does not really make much sense to me, but I thought whatever due to
> lack of a better idea let's try it.
> 
> I recreated the filesystem. Then I rebooted.
> 
> Then I started the rsync again.
> 
> So far it still runs at maximum speed of the GBit link of around
> 110 MiB/s.
> 
> Let's see whether it completes this time.
> 
> It did. Nothing in kernel log. fsck.bcachefs is happy, too.
> 
> Wrote about 188 GiB of data without any apparent issues.
> 
> I am not sure what to make of this.

Without more info it's hard to say what happened. We have a lot of
runtime debugging info, so it shouldn't be too hard to see what rsync
was stuck on: /proc/pid/stack to start with, then
/sys/fs/bcachefs/*/internal/alloc_debug if it was the allocator, which
is the most likely culprit.

If you're willing to reproduce it and hop on IRC (irc.oftc.net#bcache),
I'd be happy to walk you through grabbing all the relevant info.

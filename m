Received: from mail.lichtvoll.de (lichtvoll.de [37.120.160.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 833DB481A4
	for <linux-bcachefs@vger.kernel.org>; Fri, 28 Jun 2024 12:04:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=37.120.160.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719576245; cv=none; b=RMea8bOkyKUKGMBL8gQhqsy91XCaNVJwsThSxWda2v9v7e5xBYGjAq4w1881cVlLn88A2T1esSYQj+S7TmOiJt45PrvjkiwSSTanx4z0qNwvSYQRqV0TRY31GCRCOcj6HAbGZsBJojRtzXNa/ckd1FW/+if0hw4cz9Jn/lLb5K0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719576245; c=relaxed/simple;
	bh=JmJec3boAiSCWjKe4J8rPIjqPac+q66ClE0qVqFKzWM=;
	h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type; b=msQSc9rdmDL7PlfjPPbEPLwn47Ucp4jBMDa/kO96Gfl8g/KlLLpzmXShrdYrrSBpXJqTAJroS2rT7qYBpNzoIHKSoKpHRrxOutXXjEaVefwJ4Rq18HlLegCiBuWDNi7bf+jnY5Tj7qUAOOWcKRfgyA1dmd212qPGCuSe+hmEGLE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lichtvoll.de; spf=pass smtp.mailfrom=lichtvoll.de; arc=none smtp.client-ip=37.120.160.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lichtvoll.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lichtvoll.de
Received: from 127.0.0.1 (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (secp384r1) server-digest SHA384)
	(No client certificate requested)
	by mail.lichtvoll.de (Postfix) with ESMTPSA id E077B3A784
	for <linux-bcachefs@vger.kernel.org>; Fri, 28 Jun 2024 11:55:08 +0000 (UTC)
Authentication-Results: mail.lichtvoll.de;
	auth=pass smtp.auth=martin@lichtvoll.de smtp.mailfrom=martin@lichtvoll.de
From: Martin Steigerwald <martin@lichtvoll.de>
To: linux-bcachefs@vger.kernel.org
Subject:
 rsync stuck in "D" state short after starting to copy to a newly created
 filesystem
Date: Fri, 28 Jun 2024 13:55:08 +0200
Message-ID: <22338011.EfDdHjke4D@lichtvoll.de>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="UTF-8"

Hi!

I am ending a migration from a ThinkPad T14 AMD Gen 1 to a ThinkPad T14
AMD Gen 5.

Last filesystem is a BCacheFS with some larger files that I use for testing
BCacheFS. rsync was directly pulling from the older laptop over 1 GBit
link through my local router. All other filesystems are BTRFS and there
have not been an issue with migrating about 1,8 TiB of data to three
BTRFS filesystems via rsync.

Standard Debian Unstable Kernel as of today (on Devuan):

Linux version 6.9.7-amd64 (debian-kernel@lists.debian.org)
(x86_64-linux-gnu-gcc-13 (Debian 13.3.0-1) 13.3.0,
GNU ld (GNU Binutils for Debian) 2.42.50.20240625)
#1 SMP PREEMPT_DYNAMIC Debian 6.9.7-1 (2024-06-27)

% bcachefs version
1.9.1

SSD is 4 TB Samsung 990 Pro. BCacheFS is on LUKS encrypted LVM as the
BTRFS filesystems as well.

I created BCacheFS as follows (this is from a subsequent mkfs.bcachefs.
I do not have initial output anymore as I already overwrote it with the
new successful attempt in my documentation, but other than UUIDs nothing
should have changed I bet, the parameters were identical - see below for
the successful attempt):

% mkfs.bcachefs --data_checksum xxhash --metadata_checksum xxhash
=2D-compression=3Dlz4 /dev/nvme1/daten2
[=E2=80=A6 identifiers deleted =E2=80=A6]
Device index:                              0
Label:                                    =20
Version:                                   1.7: mi_btree_bitmap
Version upgrade complete:                  0.0: (unknown version)
Oldest version on disk:                    1.7: mi_btree_bitmap
Created:                                   [=E2=80=A6]
Sequence number:                           0
Time of last write:                        Thu Jan  1 01:00:00 1970
Superblock size:                           976 B/1.00 MiB
Clean:                                     0
Devices:                                   1
Sections:                                  members_v1,members_v2
=46eatures:                                 =20
Compat features:                          =20

Options:
block_size:                              512 B
btree_node_size:                         256 KiB
errors:                                  continue [ro] panic=20
metadata_replicas:                       1
data_replicas:                           1
metadata_replicas_required:              1
data_replicas_required:                  1
encoded_extent_max:                      64.0 KiB
metadata_checksum:                       none crc32c crc64 [xxhash]=20
data_checksum:                           none crc32c crc64 [xxhash]=20
compression:                             lz4
background_compression:                  none
str_hash:                                crc32c crc64 [siphash]=20
metadata_target:                         none
foreground_target:                       none
background_target:                       none
promote_target:                          none
erasure_code:                            0
inodes_32bit:                            1
shard_inode_numbers:                     1
inodes_use_key_cache:                    1
gc_reserve_percent:                      8
gc_reserve_bytes:                        0 B
root_reserve_percent:                    0
wide_macs:                               0
acl:                                     1
usrquota:                                0
grpquota:                                0
prjquota:                                0
journal_flush_delay:                     1000
journal_flush_disabled:                  0
journal_reclaim_delay:                   100
journal_transaction_names:               1
version_upgrade:                         [compatible] incompatible none=20
nocow:                                   0

members_v2 (size 160):
Device:                                    0
Label:                                   (none)
UUID:                                    [=E2=80=A6]
Size:                                    300 GiB
read errors:                             0
write errors:                            0
checksum errors:                         0
seqread iops:                            0
seqwrite iops:                           0
randread iops:                           0
randwrite iops:                          0
Bucket size:                             256 KiB
=46irst bucket:                            0
Buckets:                                 1228800
Last mount:                              (never)
Last superblock write:                   0
State:                                   rw
Data allowed:                            journal,btree,user
Has data:                                (none)
Btree allocated bitmap blocksize:        1.00 B
Btree allocated bitmap:                  0000000000000000000000000000000000=
000000000000000000000000000000
Durability:                              1
Discard:                                 0
=46reespace initialized:                   0


Directly after creating it I mounted it from /etc/fstab:

/dev/nvme1/daten2 /daten2 bcachefs lazytime 0 0

Soon after the copying process started, rsync got stuck in "D" state.
It was within the first 500 MiB or so. Nothing in kernel log. I waited
a bit and then stopped rsync. One rsync process remained in "D" state
and thus did not go away. I tried another time and one the rsync
processes was immediately in "D" state.

Thus I rebooted. Runit hung during reboot. Likely due to processes in
D state. I eventually switched up the laptop by pressing the power
button long enough.

I did an fsck.bcachefs and got:

% fsck.bcachefs /dev/nvme1/daten2=20
fsck binary is version 1.9: disk_accounting_v2 but filesystem is 1.7: mi_bt=
ree_bitmap and kernel is 1.7: mi_btree_bitmap, using kernel fsck
bcachefs (dm-5): mounting version 1.7: mi_btree_bitmap opts=3Dro,metadata_c=
hecksum=3Dxxhash,data_checksum=3Dxxhash,compression=3Dlz4,degraded,fsck,fix=
_errors=3Dask,read_only
bcachefs (dm-5): recovering from clean shutdown, journal seq 45
bcachefs (dm-5): journal read done, replaying entries 45-45
bcachefs (dm-5): alloc_read... done
bcachefs (dm-5): stripes_read... done
bcachefs (dm-5): snapshots_read... done
bcachefs (dm-5): check_allocations...key version number higher than recorde=
d: 73014444594 > 0: fix? (y,n, or Y,N for all errors of this type) y
key version number higher than recorded: 81604378807 > 73014444594: fix? (y=
,n, or Y,N for all errors of this type) y
dev 0 has wrong free buckets: got 0, should be 1220580: fix? (y,n, or Y,N f=
or all errors of this type) y
dev 0 has wrong sb buckets: got 0, should be 13: fix? (y,n, or Y,N for all =
errors of this type) y
dev 0 has wrong sb sectors: got 0, should be 6152: fix? (y,n, or Y,N for al=
l errors of this type) y
dev 0 has wrong sb fragmented: got 0, should be 504: fix? (y,n, or Y,N for =
all errors of this type) y
dev 0 has wrong journal buckets: got 0, should be 8192: fix? (y,n, or Y,N f=
or all errors of this type) y
dev 0 has wrong journal sectors: got 0, should be 4194304: fix? (y,n, or Y,=
N for all errors of this type) y
dev 0 has wrong btree buckets: got 0, should be 15: fix? (y,n, or Y,N for a=
ll errors of this type) y
dev 0 has wrong btree sectors: got 0, should be 7680: fix? (y,n, or Y,N for=
 all errors of this type) y
fs has wrong hidden: got 0, should be 4200960: fix? (y,n, or Y,N for all er=
rors of this type) y
fs has wrong btree: got 0, should be 7680: fix? (y,n, or Y,N for all errors=
 of this type) y
fs has wrong nr_inodes: got 20, should be 22: fix? (y,n, or Y,N for all err=
ors of this type) y
fs has wrong btree: 1/1 [0]: got 0, should be 7680: fix? (y,n, or Y,N for a=
ll errors of this type) y
done
bcachefs (dm-5): going read-write
bcachefs (dm-5): journal_replay... done
bcachefs (dm-5): check_alloc_info...y done
bcachefs (dm-5): check_lrus... done
bcachefs (dm-5): check_btree_backpointers... done
bcachefs (dm-5): check_backpointers_to_extents... done
bcachefs (dm-5): check_extents_to_backpointers... done
bcachefs (dm-5): check_alloc_to_lru_refs... done
bcachefs (dm-5): check_snapshot_trees... done
bcachefs (dm-5): check_snapshots... done
bcachefs (dm-5): check_subvols... done
bcachefs (dm-5): check_subvol_children... done
bcachefs (dm-5): delete_dead_snapshots... done
bcachefs (dm-5): check_inodes... done
bcachefs (dm-5): check_extents... done
bcachefs (dm-5): check_indirect_extents... done
bcachefs (dm-5): check_dirents... done
bcachefs (dm-5): check_xattrs... done
bcachefs (dm-5): check_root... done
bcachefs (dm-5): check_subvolume_structure... done
bcachefs (dm-5): check_directory_structure... done
bcachefs (dm-5): check_nlinks... done
bcachefs (dm-5): resume_logged_ops... done
bcachefs (dm-5): delete_dead_inodes... done
bcachefs (dm-5): shutdown complete, journal seq 47
dm-5: errors fixed

=46or a regular unclean shutdown I would not have expected any filesystem
errors. A subsequent call to "fsck.bcachefs" revealed no further errors.

I mounted the filesystem again and tried another time with rsync and
it did not seem to get stuck as before. However I felt uncomfortable
with continuing with a filesystem that has had errors already.
Especially at BCacheFS is still marked experimental.

Also I thought maybe it did not like being mounted without a reboot.
Does not really make much sense to me, but I thought whatever due to
lack of a better idea let's try it.

I recreated the filesystem. Then I rebooted.

Then I started the rsync again.

So far it still runs at maximum speed of the GBit link of around
110 MiB/s.

Let's see whether it completes this time.

It did. Nothing in kernel log. fsck.bcachefs is happy, too.

Wrote about 188 GiB of data without any apparent issues.

I am not sure what to make of this.

The only differences during the second attempt were:

1. I rebooted after mkfs.bcachefs.

2. I did not have a hibernation (suspend to disk) or standby (suspend
to RAM) cycle after the reboot. I was testing those before, but unlike=20
with the Gen 1 where both hibernation and standby are broken, I found
no issues with hibernation and standby on the new Gen 5.

That were the only differences. However I doubt one of these has to do
with it. Maybe just a strange race condition?

I am not feeling like retrying the whole process at the moment, being
happy with a completed migration to the new laptop.

Not sure whether this report is of any use. But maybe the fsck output
gives an idea of what might have been the cause. If not, feel free to
disregard. I do not have the old filesystem anymore, so in case further
information is missing it will be lost forever.

Best,
=2D-=20
Martin



Received: from a3.inai.de (a3.inai.de [144.76.212.145])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9FEA35963
	for <linux-bcachefs@vger.kernel.org>; Thu, 17 Jul 2025 15:49:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.212.145
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752767358; cv=none; b=m2BMREqH+Xe4cL5QOlweO5X/nqrkHcnVOER/EZ9a3qLX5aU+CPkq5/zJl2vNXJ6cVUsFxEtjUYPMxLt9TKDBbqZEZhbKIaWgEtxSET9tCjTKCpLou6lIprusEPIwtNeCDlsPBpuLL4hWVPE/mfTs9vFeHMREiskvsB4F0Xg08xw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752767358; c=relaxed/simple;
	bh=Rr5ABOwff4TC7NtE7nq7xarbeL7VJU45wLJjq1KTP64=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type; b=OpTcCHMf4+isf5dLKT1k/2yj7ylJz+aitFbm9OhWWnxsI2Gnfm0+F5xuz7VbK9ATwT+SmoAWkk3hFU3IOjbOyI4waPagK/J9V7RTPcwZLpUXvHvLqq3nDCIqEwXppKk/Aj2A+chSsIoIbuJJq0K6unf5c9iyJ1N94kMonZCNGjQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=inai.de; spf=pass smtp.mailfrom=inai.de; arc=none smtp.client-ip=144.76.212.145
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=inai.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=inai.de
Received: by a3.inai.de (Postfix, from userid 25121)
	id 9F8671003C5101; Thu, 17 Jul 2025 17:40:00 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by a3.inai.de (Postfix) with ESMTP id 9DD581100AF010
	for <linux-bcachefs@vger.kernel.org>; Thu, 17 Jul 2025 17:40:00 +0200 (CEST)
Date: Thu, 17 Jul 2025 17:40:00 +0200 (CEST)
From: Jan Engelhardt <ej@inai.de>
To: linux-bcachefs@vger.kernel.org
Subject: Reported filesystem size (fs usage, df) discrepancies
Message-ID: <558o6n97-6sn1-20ns-5n62-79s106p86747@vanv.qr>
User-Agent: Alpine 2.26 (LSU 649 2022-06-02)
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII


# uname -a
Linux localhost 6.15.4-1-default #1 SMP PREEMPT_DYNAMIC Mon Jun 
30 10:37:39 UTC 2025 (55e70a8) x86_64 x86_64 x86_64 GNU/Linux
[openSUSE Tumbleweed 20250701]
# bcachefs version
1.25.1

# blockdev --getsize64 /dev/disk/by-id/ata-Micron* /dev/disk/by-id/ata-MB1000*
960197124096
960197124096
960197124096
960197124096
1000204886016
1000204886016
(total: 5570 GB / 5440 GiB)

# mount UUID=... /v
# bcachefs fs usage /v | grep capacity:
  capacity:            1000203091968          476934 (x2)
  capacity:             960195723264          457857 (x4)
                        [5440 GiB]

A bit of rounding to cancel out odd disk shapes, perfectly fine.

# bcachefs fs usage /v | grep -P '(free|journal):'
  free:                 992384909312          473206
  journal:                7813988352            3726 (x2)
  free:                 952685821952          454276
  journal:                7501512704            3577 (x4)
                        [5397 GiB]

The journal takes away a bit. Understandable.
Is it always ~0.787%? Could I specify its size manually?

# bcachefs fs usage /v | head -n2
Filesystem: (uuid)
Size:                  5373893950976 [5004 GiB]

How did we reportedly lose 393 GiB / 7%?

# df -BG
/dev/sdh:/dev/sdd:/dev/sda:/dev/sdb:/dev/sdf:/dev/sde     4963G    1G     4886G   1% /v

Another 41 GiB / 0.8% just went away.


=== Full(er) output ===

# cd /dev/disk/by-id; bcachefs format \
  --label=ssd.ssd0 ata-Micron_5200_MTFDDAK960TDN___________26 \
  --label=ssd.ssd1 ata-Micron_5200_MTFDDAK960TDN___________60 \
  --label=ssd.ssd2 ata-Micron_5200_MTFDDAK960TDN___________65 \
  --label=ssd.ssd3 ata-Micron_5200_MTFDDAK960TDN___________6A \
  --label=hdd.hdd0 ata-MB1000GCEEK___________72 \
  --label=hdd.hdd1 ata-MB1000GCEEK___________95 \
  --foreground_target=ssd --promote_target=ssd --background_target=hdd
Device index:                              5
Label:                                     (none)
Version:                                   1.25: extent_flags
Incompatible features allowed:             1.25: extent_flags
Incompatible features in use:              0.0: (unknown version)
Version upgrade complete:                  0.0: (unknown version)
Oldest version on disk:                    1.25: extent_flags
...
Superblock size:                           2.31 KiB/1.00 MiB
Devices:                                   6
Sections:                                  members_v1,disk_groups,members_v2
Features:                                  new_siphash,new_extent_overwrite,btree_ptr_v2,extents_above_btree_updates,btree_updates_journalled,new_varint,journal_no_flush,alloc_v2,extents_across_btree_nodes,incompat_version_field
Compat features:                           
Options:
  block_size:                              4.00 KiB
  btree_node_size:                         256 KiB
  errors:                                  continue [fix_safe] panic ro 
  write_error_timeout:                     30
  metadata_replicas:                       1
  data_replicas:                           1
  metadata_replicas_required:              1
  data_replicas_required:                  1
  encoded_extent_max:                      64.0 KiB
  metadata_checksum:                       none [crc32c] crc64 xxhash 
  data_checksum:                           none [crc32c] crc64 xxhash 
  checksum_err_retry_nr:                   3
  compression:                             none
  background_compression:                  none
  str_hash:                                crc32c crc64 [siphash] 
  metadata_target:                         none
  foreground_target:                       ssd
  background_target:                       hdd
  promote_target:                          ssd
  erasure_code:                            0
  inodes_32bit:                            1
  shard_inode_numbers_bits:                0
  inodes_use_key_cache:                    1
  gc_reserve_percent:                      8
  gc_reserve_bytes:                        0 B
  root_reserve_percent:                    0
  wide_macs:                               0
  promote_whole_extents:                   1
  acl:                                     1
  usrquota:                                0
  grpquota:                                0
  prjquota:                                0
  degraded:                                [ask] yes very no 
  journal_flush_delay:                     1000
  journal_flush_disabled:                  0
  journal_reclaim_delay:                   100
  journal_transaction_names:               1
  allocator_stuck_timeout:                 30
  version_upgrade:                         [compatible] incompatible none 
  nocow:                                   0

members_v2 (size 880):
Device:                                    0
  Label:                                   ssd0 (1)
  UUID:                                    d23de44c-8eab-4653-abcd-62929d6d823c
  Size:                                    894 GiB
  read errors:                             0
  write errors:                            0
  checksum errors:                         0
  seqread iops:                            0
  seqwrite iops:                           0
  randread iops:                           0
  randwrite iops:                          0
  Bucket size:                             2.00 MiB
  First bucket:                            0
  Buckets:                                 457857
  Last mount:                              (never)
  Last superblock write:                   0
  State:                                   rw
  Data allowed:                            journal,btree,user
  Has data:                                (none)
  Btree allocated bitmap blocksize:        1.00 B
  Btree allocated bitmap:                  0000000000000000000000000000000000000000000000000000000000000000
  Durability:                              1
  Discard:                                 1
  Freespace initialized:                   0
  Resize on mount:                         0
(ssd1/ssd2/ssd3 are basically repeats)
Device:                                    4
  Label:                                   hdd0 (6)
  UUID:                                    13b8f1e1-ae2b-47a6-a7e2-718d946ba1fb
  Size:                                    932 GiB
  read errors:                             0
  write errors:                            0
  checksum errors:                         0
  seqread iops:                            0
  seqwrite iops:                           0
  randread iops:                           0
  randwrite iops:                          0
  Bucket size:                             2.00 MiB
  First bucket:                            0
  Buckets:                                 476934
  Last mount:                              (never)
  Last superblock write:                   0
  State:                                   rw
  Data allowed:                            journal,btree,user
  Has data:                                (none)
  Btree allocated bitmap blocksize:        1.00 B
  Btree allocated bitmap:                  0000000000000000000000000000000000000000000000000000000000000000
  Durability:                              1
  Discard:                                 1
  Freespace initialized:                   0
  Resize on mount:                         0
(hdd1 is a repeat)


# bcachefs fs usage /v
Size:                  5373893950976
Used:                        6291456
Online reserved:                   0

Data type       Required/total  Durability    Devices
btree:          1/1             1             [sdh]                1310720
btree:          1/1             1             [sdd]                1572864
btree:          1/1             1             [sda]                1835008
btree:          1/1             1             [sdb]                1572864

Btree usage:
inodes:               262144
dirents:              262144
alloc:               3670016
subvolumes:           262144
snapshots:            262144
lru:                  262144
freespace:            262144
backpointers:         262144
snapshot_trees:       262144
logged_ops:           262144
accounting:           262144

hdd.hdd0 (device 4):             sdf              rw
                                data         buckets    fragmented
  free:                 992384909312          473206
  sb:                        2101248               2       2093056
  journal:                7813988352            3726
  btree:                           0               0
  user:                            0               0
  cached:                          0               0
  parity:                          0               0
  stripe:                          0               0
  need_gc_gens:                    0               0
  need_discard:                    0               0
  unstriped:                       0               0
  capacity:            1000203091968          476934

hdd.hdd1 (device 5):             sde              rw
                                data         buckets    fragmented
  free:                 992384909312          473206
  sb:                        2101248               2       2093056
  journal:                7813988352            3726
  btree:                           0               0
  user:                            0               0
  cached:                          0               0
  parity:                          0               0
  stripe:                          0               0
  need_gc_gens:                    0               0
  need_discard:                    0               0
  unstriped:                       0               0
  capacity:            1000203091968          476934

ssd.ssd0 (device 0):             sdh              rw
                                data         buckets    fragmented
  free:                 952685821952          454276
  sb:                        2101248               2       2093056
  journal:                7501512704            3577
  btree:                     1310720               2       2883584
  user:                            0               0
  cached:                          0               0
  parity:                          0               0
  stripe:                          0               0
  need_gc_gens:                    0               0
  need_discard:                    0               0
  unstriped:                       0               0
  capacity:             960195723264          457857

ssd.ssd1 (device 1):             sdd              rw
                                data         buckets    fragmented
  free:                 952685821952          454276
  sb:                        2101248               2       2093056
  journal:                7501512704            3577
  btree:                     1572864               2       2621440
  user:                            0               0
  cached:                          0               0
  parity:                          0               0
  stripe:                          0               0
  need_gc_gens:                    0               0
  need_discard:                    0               0
  unstriped:                       0               0
  capacity:             960195723264          457857

ssd.ssd2 (device 2):             sda              rw
                                data         buckets    fragmented
  free:                 952685821952          454276
  sb:                        2101248               2       2093056
  journal:                7501512704            3577
  btree:                     1835008               2       2359296
  user:                            0               0
  cached:                          0               0
  parity:                          0               0
  stripe:                          0               0
  need_gc_gens:                    0               0
  need_discard:                    0               0
  unstriped:                       0               0
  capacity:             960195723264          457857

ssd.ssd3 (device 3):             sdb              rw
                                data         buckets    fragmented
  free:                 952685821952          454276
  sb:                        2101248               2       2093056
  journal:                7501512704            3577
  btree:                     1572864               2       2621440
  user:                            0               0
  cached:                          0               0
  parity:                          0               0
  stripe:                          0               0
  need_gc_gens:                    0               0
  need_discard:                    0               0
  unstriped:                       0               0
  capacity:             960195723264          457857

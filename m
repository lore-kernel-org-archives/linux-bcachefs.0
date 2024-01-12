Received: from redpilled.dev (redpilled.dev [195.201.122.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FD035C90C;
	Fri, 12 Jan 2024 07:29:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=redpilled.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redpilled.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redpilled.dev header.i=@redpilled.dev header.b="OT1+6aLG"
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redpilled.dev;
	s=mail; t=1705044078;
	bh=zjv/K4BDJq6mHH6xaikJhlEHfdzmdGc7uo6JC3hv3j0=;
	h=Date:From:To:Subject;
	b=OT1+6aLGje4sy7rLtR0PrhyqpPLx4IL7nE0bVigt7xGjB6vxjqoPJmmdqB/o/EepN
	 7LUG4Iz8pzZUpFdiLO+fQkRcVBC2buopTYMtsfBXoP8HPmXszzuho0WOwuDeKfKv4B
	 vyNQZTsgZOcMdkMqFOpw/GtEDJNjaXl+t6SOMABI=
Date: Fri, 12 Jan 2024 07:21:17 +0000
From: chad@redpilled.dev
To: linux-bcachefs@vger.kernel.org, linux-block@vger.kernel.org
Subject: I/O timeouts and system freezes on Kingston A2000 NVME with BCACHEFS
Message-ID: <52cc9df7fdc3a3f94fa50e32a0da1e5b@redpilled.dev>
X-Sender: chad@redpilled.dev
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit

This issue was originally reported here: 
https://github.com/koverstreet/bcachefs/issues/628

Transferring large amounts of files to the bcachefs from the btrfs 
causes I/O timeouts and freezes the whole system. This doesn't seem to 
be related to the btrfs, but rather to the heavy I/O on the drive, as it 
happens without btrfs being mounted. Transferring the files to the HDD, 
and then from it to the bcachefs on the NVME sometimes doesn't make the 
problem occur.
The problem only happens on the bcachefs, not on btrfs or ext4. It 
doesn't happen on the HDD, I can't test with other NVME drives sadly.
The behaviour when it is frozen is like this: all drive accesses can't 
process, when not cached in ram, so every app that is loaded in the ram, 
continues to function, but at the moment it tries to access the drive it 
freezes, until the drive is reset and those abort status messages appear 
in the dmesg, after that system is unfrozen for a moment, if you keep 
copying the files then the problem reoccurs once again.

This drive is known to have problems with the power management in the 
past:
https://wiki.archlinux.org/title/Solid_state_drive/NVMe#Troubleshooting
But those problems where since fixed with kernel workarounds / firmware 
updates.
This issue is may be related, perhaps bcachefs does something different 
from the other filesystems, and workarounds don't apply, which causes 
the bug to occur only on it. It may be a problem in the nvme subsystem, 
or just some edge case in the bcachefs too, who knows.
I tried to disable ASPM and setting latency to 0 like was suggested, it 
didn't fix the problem, so I don't know.
If this is indeed related to that specific drive it would be hard to 
reproduce.
---

Errors:

```
! dmesg
[   34.890981] bcachefs (nvme0n1p3): mounting version 1.3: 
rebalance_work
[   34.890988] bcachefs (nvme0n1p3): recovering from clean shutdown, 
journal seq 1782
[   34.899111] bcachefs (nvme0n1p3): alloc_read... done
[   34.899130] bcachefs (nvme0n1p3): stripes_read... done
[   34.899132] bcachefs (nvme0n1p3): snapshots_read... done
[   34.906883] bcachefs (nvme0n1p3): journal_replay... done
[   34.906887] bcachefs (nvme0n1p3): resume_logged_ops... done
[   34.907482] bcachefs (nvme0n1p3): going read-write
[   92.196122] nvme nvme0: I/O 512 (I/O Cmd) QID 1 timeout, aborting
[   92.196134] nvme nvme0: I/O 513 (I/O Cmd) QID 1 timeout, aborting
[   92.196138] nvme nvme0: I/O 514 (I/O Cmd) QID 1 timeout, aborting
[   92.196141] nvme nvme0: I/O 515 (I/O Cmd) QID 1 timeout, aborting
[   92.196145] nvme nvme0: I/O 516 (I/O Cmd) QID 1 timeout, aborting
[  122.405176] nvme nvme0: I/O 512 QID 1 timeout, reset controller
[  185.384762] nvme0n1: I/O Cmd(0x2) @ LBA 105272408, 256 blocks, I/O 
Error (sct 0x3 / sc 0x71)
[  185.384768] I/O error, dev nvme0n1, sector 105272408 op 0x0:(READ) 
flags 0x84700 phys_seg 1 prio class 2
[  185.384772] nvme0n1: I/O Cmd(0x2) @ LBA 105272664, 256 blocks, I/O 
Error (sct 0x3 / sc 0x71)
[  185.384774] I/O error, dev nvme0n1, sector 105272664 op 0x0:(READ) 
flags 0x84700 phys_seg 1 prio class 2
[  185.384775] nvme0n1: I/O Cmd(0x2) @ LBA 105272920, 256 blocks, I/O 
Error (sct 0x3 / sc 0x71)
[  185.384776] I/O error, dev nvme0n1, sector 105272920 op 0x0:(READ) 
flags 0x84700 phys_seg 1 prio class 2
[  185.384778] nvme0n1: I/O Cmd(0x2) @ LBA 105273176, 256 blocks, I/O 
Error (sct 0x3 / sc 0x71)
[  185.384779] I/O error, dev nvme0n1, sector 105273176 op 0x0:(READ) 
flags 0x84700 phys_seg 1 prio class 2
[  185.384780] nvme0n1: I/O Cmd(0x2) @ LBA 105273432, 256 blocks, I/O 
Error (sct 0x3 / sc 0x71)
[  185.384781] I/O error, dev nvme0n1, sector 105273432 op 0x0:(READ) 
flags 0x84700 phys_seg 1 prio class 2
[  185.384782] nvme0n1: I/O Cmd(0x2) @ LBA 105273688, 256 blocks, I/O 
Error (sct 0x3 / sc 0x71)
[  185.384783] I/O error, dev nvme0n1, sector 105273688 op 0x0:(READ) 
flags 0x84700 phys_seg 1 prio class 2
[  185.384784] nvme0n1: I/O Cmd(0x2) @ LBA 105273944, 256 blocks, I/O 
Error (sct 0x3 / sc 0x71)
[  185.384785] I/O error, dev nvme0n1, sector 105273944 op 0x0:(READ) 
flags 0x84700 phys_seg 1 prio class 2
[  185.384786] nvme0n1: I/O Cmd(0x2) @ LBA 105274200, 256 blocks, I/O 
Error (sct 0x3 / sc 0x71)
[  185.384787] I/O error, dev nvme0n1, sector 105274200 op 0x0:(READ) 
flags 0x84700 phys_seg 1 prio class 2
[  185.384788] nvme0n1: I/O Cmd(0x2) @ LBA 105274456, 256 blocks, I/O 
Error (sct 0x3 / sc 0x71)
[  185.384789] I/O error, dev nvme0n1, sector 105274456 op 0x0:(READ) 
flags 0x84700 phys_seg 1 prio class 2
[  185.384790] nvme0n1: I/O Cmd(0x2) @ LBA 105274712, 256 blocks, I/O 
Error (sct 0x3 / sc 0x71)
[  185.384791] I/O error, dev nvme0n1, sector 105274712 op 0x0:(READ) 
flags 0x84700 phys_seg 1 prio class 2
[  185.384834] nvme nvme0: Abort status: 0x371
[  185.384836] nvme nvme0: Abort status: 0x371
[  185.384837] nvme nvme0: Abort status: 0x371
[  185.384839] nvme nvme0: Abort status: 0x371
[  185.384840] nvme nvme0: Abort status: 0x371
[  185.388439] nvme nvme0: 8/0/0 default/read/poll queues
```
---

System info:

```
› uname -a
Linux hp-laptop 6.7.0 #1-NixOS SMP PREEMPT_DYNAMIC Sun Jan  7 20:18:38 
UTC 2024 x86_64 GNU/Linux
```

```
› rg -z -i bcachefs  /proc/config.gz
10478:CONFIG_BCACHEFS_FS=m
10479:CONFIG_BCACHEFS_QUOTA=y
10480:# CONFIG_BCACHEFS_ERASURE_CODING is not set
10481:CONFIG_BCACHEFS_POSIX_ACL=y
10482:# CONFIG_BCACHEFS_DEBUG_TRANSACTIONS is not set
10483:# CONFIG_BCACHEFS_DEBUG is not set
10484:# CONFIG_BCACHEFS_TESTS is not set
10485:# CONFIG_BCACHEFS_LOCK_TIME_STATS is not set
10486:# CONFIG_BCACHEFS_NO_LATENCY_ACCT is not set
```

```
! nvme list
Node           Generic     Model                   Namespace  Usage      
                 Format           FW Rev
-------------- ----------- ----------------------- ---------- 
-------------------------- ---------------- --------
/dev/nvme0n1   /dev/ng0n1  KINGSTON SA2000M8500G   0x1        348.70  GB 
/ 500.11  GB    512   B +  0 B   S5Z42109
```

```
› lsblk -f
NAME        FSTYPE   FSVER LABEL   UUID                                 
FSAVAIL FSUSE% MOUNTPOINTS
sda
├─sda1      ext4     1.0   storage 7ad8dd91-b675-4411-81bc-301e72af3ddb
├─sda2
└─sda3      ntfs           System  EAEAA44FEAA419B9
zram0                                                                    
               [SWAP]
nvme0n1
├─nvme0n1p1 vfat     FAT32 boot    145B-7C42                             
402.4M    19% /boot
├─nvme0n1p2 btrfs          iris    0501be49-5d61-483d-b95e-8879cecd0f12  
    50G    66% /home
│                                                                        
               /nix/store
│                                                                        
               /nix
│                                                                        
               /
└─nvme0n1p3 bcachefs 1027  irene   85599249-65d6-47dc-b17c-635dc7407581  
133.8G     2% /mnt
```

---

This is when it happens on my machine:

```
! mkfs -t bcachefs -f /dev/nvme0n1p3
/dev/nvme0n1p3 contains a bcachefs filesystem
External UUID:                              
5bb48a77-c303-4b98-aa7d-ec3d01443fc6
Internal UUID:                              
c8348431-90e8-4cb1-b31d-170fdfe00522
Device index:                               0
Label:
Version:                                    1.3: rebalance_work
Version upgrade complete:                   0.0: (unknown version)
Oldest version on disk:                     1.3: rebalance_work
Created:                                    Wed Jan 10 10:26:51 2024
Sequence number:                            0
Superblock size:                            952
Clean:                                      0
Devices:                                    1
Sections:                                   members_v1,members_v2
Features:                                   
new_siphash,new_extent_overwrite,btree_ptr_v2,extents_above_btree_updates,btree_updates_journalled,new_varint,journal_no_flush,alloc_v2,extents_across_btree_nodes
Compat features:

Options:
   block_size:                               512 B
   btree_node_size:                          256 KiB
   errors:                                   continue [ro] panic
   metadata_replicas:                        1
   data_replicas:                            1
   metadata_replicas_required:               1
   data_replicas_required:                   1
   encoded_extent_max:                       64.0 KiB
   metadata_checksum:                        none [crc32c] crc64 xxhash
   data_checksum:                            none [crc32c] crc64 xxhash
   compression:                              none
   background_compression:                   none
   str_hash:                                 crc32c crc64 [siphash]
   metadata_target:                          none
   foreground_target:                        none
   background_target:                        none
   promote_target:                           none
   erasure_code:                             0
   inodes_32bit:                             1
   shard_inode_numbers:                      1
   inodes_use_key_cache:                     1
   gc_reserve_percent:                       8
   gc_reserve_bytes:                         0 B
   root_reserve_percent:                     0
   wide_macs:                                0
   acl:                                      1
   usrquota:                                 0
   grpquota:                                 0
   prjquota:                                 0
   journal_flush_delay:                      1000
   journal_flush_disabled:                   0
   journal_reclaim_delay:                    100
   journal_transaction_names:                1
   version_upgrade:                          [compatible] incompatible 
none
   nocow:                                    0

members_v2 (size 136):
   Device:                                   0
     Label:                                  (none)
     UUID:                                   
109a3a6c-bf69-435d-b2cc-c6b92dab1a22
     Size:                                   153 GiB
     read errors:                            0
     write errors:                           0
     checksum errors:                        0
     seqread iops:                           0
     seqwrite iops:                          0
     randread iops:                          0
     randwrite iops:                         0
     Bucket size:                            256 KiB
     First bucket:                           0
     Buckets:                                625088
     Last mount:                             (never)
     State:                                  rw
     Data allowed:                           journal,btree,user
     Has data:                               (none)
     Durability:                             2
     Discard:                                0
     Freespace initialized:                  0
mounting version 1.3: rebalance_work
initializing new filesystem
going read-write
initializing freespace

! mount -t bcachefs 
/dev/disk/by-partuuid/dab50f50-ff2e-4a54-8d59-6d267cb31148 /mnt

! cp -ax /home /mnt/
```

---

Please tell as to what other info do you need and how to provide it.

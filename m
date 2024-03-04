Received: from pannekake.samfundet.no (pannekake.samfundet.no [193.35.52.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC2406168B
	for <linux-bcachefs@vger.kernel.org>; Mon,  4 Mar 2024 17:36:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.35.52.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709573812; cv=none; b=pkhjesu4mbqD2dLqfrH0xr6VK/pmJFodIy+Yprsry5aEYkSjvfxlpGcBFXN8yAdrGQDnlZdBesXNEiolg0MmZpTAOccdHjhREo1OhrxuxJjloBLkOln2lUFxd49+/kd/6/265DG6pKfu/cf/Kj/5vZ+bF6T0+GCY4knkh+zB/Bs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709573812; c=relaxed/simple;
	bh=Sl4Y9/LZwh4bKn32sfWGi1C/vt0wNvPqfCo1Re2ezio=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=WcYG/lxG0+sHqOxXY70PgaOZjEZorCq46ksRfwEkK5uUxjBQCUH2az6FhDb9xQBZJ6HAXVrX3LkBPA7Ay4XmlBikeCozSvytf8m8gooSMe9VJtaq35DGo6+62NMH1Mn01Uwu6r+FMLucyIXoh6lJnxZXvQOSHtCRdABsJdPXKtc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gunderson.no; spf=pass smtp.mailfrom=gunderson.no; dkim=pass (2048-bit key) header.d=gunderson.no header.i=@gunderson.no header.b=WXapGKyH; arc=none smtp.client-ip=193.35.52.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gunderson.no
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gunderson.no
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gunderson.no header.i=@gunderson.no header.b="WXapGKyH"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gunderson.no; s=legacy; h=Content-Transfer-Encoding:Content-Type:
	MIME-Version:Message-ID:Subject:To:From:Date:Sender:Reply-To:Cc:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=hrnsxfg/G60r5SONPqT5NtR3O/sJFGxlQQUqP0UTgWU=; b=WXapGKyHlri9qxZAFIp006lRbi
	CgdxIdZggyokwsIy1FuGMFb8fl5EQ/gs50mYZdTXXjEHr4yTG/Sl+aFjEU9FBc9/CZgcqot0/T51J
	zZKDiHf8dIj+akr0kY3Oplb8q3lduVEv3HXH62Zi8E9Gr7BYW0tz5ZN+ZiZnZuEGvBDydCDQ85FA7
	X+Lp7Hn/p7kUuly5nBVrmm8zvJs+g3RevmvMAKKhbLjfRt9Co5QeD6CBxfH1PMZqWPvSQntFULMm2
	qpltqIpkUmuycbbiUTR04HEcjmrWRlvQyfU08TJTSqgXfE/tnprzINwy9/dc/vyY52hZP1O9lRkeL
	2q0GH9Xg==;
Received: from sesse by pannekake.samfundet.no with local (Exim 4.96)
	(envelope-from <steinar+bounces@gunderson.no>)
	id 1rhCF5-00F5zi-1m
	for linux-bcachefs@vger.kernel.org;
	Mon, 04 Mar 2024 18:36:47 +0100
Date: Mon, 4 Mar 2024 18:36:47 +0100
From: "Steinar H. Gunderson" <steinar+bcachefs@gunderson.no>
To: linux-bcachefs@vger.kernel.org
Subject: Broken multi-device filesystem
Message-ID: <20240304173647.s5mpkojd3fnvbpu4@sesse.net>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

Hi,

I have a bcachefs root filesystem over two SSDs, together about ~1TB
of space (replicas=1). For historical reasons, one of them is an LVM
volume, and the other one is a simple partition. This is with a 6.7
kernel (Debian 6.7.7-1, IIRC).

While doing a large-ish build, I noticed the machine got slower and slower,
until it hung completely. I hit the physical reset button, and as the root
filesystem started mounting, it hung in the step after journal replay
(I believe it is called something with “deleted inodes”). After about two
hours, I hit the physical reset button again, and ran bcachefs fsck
(from bcachefs-tools 1.6.3) on the filesystem. It printed out the following
(manually typed from a photo of the display, errors may occur):

  fsck binary is version 1.6: btree_subvolume_children but filesystem is 1.3: rebalance_work and kernel is 1.3: rebalance_work
  mounting version 1.3: rebalance_work opts=ro,compression=lz4,degraded,fsck,fix_errors=ask,read_only
  recovering from unclean shutdown
  Doing compatible version upgrade from 1.3: rebalance_work to 1.6: btree_subvolume_children
    running recovery passes: check_subvols,check_dirents
  journal read done,replaying entries 7263879-7263879
  alloc_read... done
  stripes_read... done
  snapshots_read... done
  check_allocations...dev 0 has wrong free buckets: got 507491, should be 499853: fix?
   (y,n, or Y,N for all errors of this type) Y
  dev 0 has wrong sb buckets: got 0, should be 7, fixing
  dev 0 has wrong sb sectors: got 0, should be 6152: fix?
   (y,n, or Y,N for all errors of this type) Y
  dev 0 has wrong sb fragmented: got 0, should be 1016: fix?
   (y,n, or Y,N for all errors of this type) Y
  dev 0 has wrong journal buckets: got 0, should be 7631, fixing
  dev 0 has wrong journal buckets: got 0, should be 1192480: fix?
   (y,n, or Y,N for all errors of this type) Y
   done
  going read-write
  journal_replay... done
  check_alloc_info... done
  check_lrus... done
  check_btree_backpointers... done
  check_backpointers_to_extents... done
  check_alloc_to_lru_refs... done
  check_snapshot_trees... done
  check_snapshots... done
  check_subvols... done
  check_subvol_children... done
  delete_dead_snapshot... done
  resume_logged_ops... done
  check_inodes...inodes 759339:4294967288 unlinked, but not on deleted list: fix?
  WARNING at libbcachefs/btree_iter.c:2827: btree trans held srcu lock (delaying memory reclaim) for 22 seconds

At this point, there was no visible I/O and no visible progress for about
an hour (and being in initramfs, I couldn't check top), so I Ctrl-C-ed fsck
and tried to mount again. It gave (more manual typing; the top and right is
cut off in the screenshot, and I haven't bothered typing in the
microseconds):

  [  729.446] bcachefs (16494483-fbc6-4e2f-a316-d2777e730960): alloc_read... done
  [  729.452] bcachefs (16494483-fbc6-4e2f-a316-d2777e730960): stripes_read... done
  [  729.457] bcachefs (16494483-fbc6-4e2f-a316-d2777e730960): snapshots_read... done
  [  729.484] bcachefs (16494483-fbc6-4e2f-a316-d2777e730960): journal_replay... done
  [  729.489] bcachefs (16494483-fbc6-4e2f-a316-d2777e730960): check_subvols... done
  [  729.494] bcachefs (16494483-fbc6-4e2f-a316-d2777e730960): resume_logged_ops... done
  [  729.499] bcachefs (16494483-fbc6-4e2f-a316-d2777e730960): check_dirents...
  [  729.543] inode 1410398479:4294966699 has wrong backpointer:
  [  729.543] got       604737456:6483958551636691117
  [  729.543] should be 23149:8508601757679713244, exiting
  [  729.562] bcachefs (16494483-fbc6-4e2f-a316-d2777e730960): Unable to continue, halting
  [  729.567] bcachefs (16494483-fbc6-4e2f-a316-d2777e730960): check_dirent_target(): error fsck_erro
  [  729.572] bcachefs (16494483-fbc6-4e2f-a316-d2777e730960): check_dirent(): error fsck_errors_not_
  [  729.577] bcachefs (16494483-fbc6-4e2f-a316-d2777e730960): bch2_check_dirents(): error fsck_errors
  [  729.583] bcachefs (16494483-fbc6-4e2f-a316-d2777e730960): bch2_fs_start(): error starting filesys
  [  729.588] bcachefs (16494483-fbc6-4e2f-a316-d2777e730960): mounting version 1.6: (unknown version)
  [  729.626] bcachefs (16494483-fbc6-4e2f-a316-d2777e730960): recovering from unclean shutdown
  [  729.631] bcachefs (16494483-fbc6-4e2f-a316-d2777e730960): superblock required following recovery 
  [  729.636]   check_subvols,check_dirents
  [  729.646] bcachefs (16494483-fbc6-4e2f-a316-d2777e730960): Version downgrade required:
  [  729.646]
  [  729.657] bcachefs (16494483-fbc6-4e2f-a316-d2777e730960): Version upgrade from 1.3: rebalance_work
  [  729.657] Doing compatible version upgrade from 1.3: rebalance_work to 1.6: (unknown version)
  [  729.657] 
  [  731.722] bcachefs (16494483-fbc6-4e2f-a316-d2777e730960): journal read done, replaying entries 7263
  [  731.747] bcachefs (16494483-fbc6-4e2f-a316-d2777e730960): alloc_read...  done
  [  731.750] bcachefs (16494483-fbc6-4e2f-a316-d2777e730960): stripes_read... done
  [  731.754] bcachefs (16494483-fbc6-4e2f-a316-d2777e730960): snapshots_read... done
  [  731.759] bcachefs (16494483-fbc6-4e2f-a316-d2777e730960): journal_replay... done
  [  731.786] bcachefs (16494483-fbc6-4e2f-a316-d2777e730960): check_subvols... done
  [  731.791] bcachefs (16494483-fbc6-4e2f-a316-d2777e730960): resume_logged_ops... done
  [  731.796] bcachefs (16494483-fbc6-4e2f-a316-d2777e730960): check_dirents...
  [  731.846] inode 1410398479:4294966699 has wrong backpointer:
  [  731.846] got       604737456:6483958551636691117
  [  731.846] should be 23149:8508601757679713244, exiting
  [  731.867] bcachefs (16494483-fbc6-4e2f-a316-d2777e730960): Unable to continue, halting
  [  731.872] bcachefs (16494483-fbc6-4e2f-a316-d2777e730960): check_dirent_target(): error fsck_errors_no
  [  731.877] bcachefs (16494483-fbc6-4e2f-a316-d2777e730960): check_dirent(): error fsck_errors_not_fixed
  [  731.883] bcachefs (16494483-fbc6-4e2f-a316-d2777e730960): bch2_check_dirents(): error fsck_errors_not
  [  731.888] bcachefs (16494483-fbc6-4e2f-a316-d2777e730960): bch2_fs_recovery(): error fsck_errors_not_f
  [  731.893] bcachefs (16494483-fbc6-4e2f-a316-d2777e730960): bch2_fs_start(): error starting filesys
ERROR - bcachefs::commands::cmd_mount Fatal error: Invalid argument
mount: mounting /dev/mapper/bigscreen--vg-tablebase:/dev/nvme1n1p1 on /root failed: Invalid argument

At this point, I am no longer allowed to try fsck, because it thinks the two
devices have gone into split brain:

  (initramfs) bcachefs fsck /dev/mapper/bigscreen--vg-tablebase:/dev/nvme1n1p1
  bch2_dev_in_fs() Split brain detected between /dev/nvme1n1p1 and /dev/mapper/bigscreen--vg-tablebase:
  /dev/mapper/bigscreen--vg-tablebase believes seq of /dev/nvme1n1p1 to be 126, but /dev/nvme1n1p1 has 130
  Not using /dev/nvme1n1p1
  bch2_fs_open() bcs_fs_open err opening /dev/mapper/bigscreen--vg-tablebase: insufficient_devices_to_start
  bch2_dev_in_fs() Split brain detected between /dev/nvme1n1p1 and /dev/mapper/bigscreen--vg-tablebase:
  /dev/mapper/bigscreen--vg-tablebase believes seq of /dev/nvme1n1p1 to be 126, but /dev/nvme1n1p1 has 130
  Not using /dev/nvme1n1p1
  insufficient devices online (0) for replicas entry journal: 1/1 [0]
  bch2_fs_open() bcs_fs_open err opening /dev/mapper/bigscreen--vg-tablebase: insufficient_devices_to_start

So the entire machine is hosed. (I still have an older copy of the filesystem
in xfs form on a different partition, so I can boot into that, and I do have
backups of all the user data, but it is still pretty inconvenient.) Is there
any cure?

/* Steinar */
-- 
Homepage: https://www.sesse.net/

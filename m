Received: from mail.lichtvoll.de (lichtvoll.de [37.120.160.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A910528314D
	for <linux-bcachefs@vger.kernel.org>; Fri, 30 May 2025 21:27:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=37.120.160.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748640444; cv=none; b=hQagoDmcl1cSUkrNsLlu9IHYl2qntjEjhjLgVinsG8pga0+NCSWkq1fNd2CPk3SqJca9m6DVVONHmu7lpOBmv7dWE42kUthXUHltBFl2my6LfvkQcDp2BQlGPwgsBoFz2M1Z/mla/wmXfR0j1TD3abi3XFRsNh6/kF40DtkaxfU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748640444; c=relaxed/simple;
	bh=HtXBiGmtCzZdH5+TOZgUQyDsUauWBzHvf1BXSVB4FF4=;
	h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type; b=k4Nw7OAmzFMHod2AI3Jpij8ijA8Z04vQTh2yFgPbcT5FzSFcdf7ZxSqcJK+vgnmmyVmUSR1rwD5HxLNlPAL/p1sxGrSMuVxA4CFQVfGgLDZyMPJg2Tm7C87M3iiqMNiedGsKaIoiV3NfQISSD316QCtm95SyFBC49o67sYB/6aI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lichtvoll.de; spf=pass smtp.mailfrom=lichtvoll.de; arc=none smtp.client-ip=37.120.160.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lichtvoll.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lichtvoll.de
Received: from 127.0.0.1 (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (secp384r1) server-digest SHA384)
	(No client certificate requested)
	by mail.lichtvoll.de (Postfix) with ESMTPSA id 2C74E102CC0
	for <linux-bcachefs@vger.kernel.org>; Fri, 30 May 2025 21:19:34 +0000 (UTC)
Authentication-Results: mail.lichtvoll.de;
	auth=pass smtp.auth=martin@lichtvoll.de smtp.mailfrom=martin@lichtvoll.de
From: Martin Steigerwald <martin@lichtvoll.de>
To: linux-bcachefs@vger.kernel.org
Subject: Size of directory entry 16 EiB according to "ls -l"
Date: Fri, 30 May 2025 23:19:32 +0200
Message-ID: <3009813.e9J7NaK4W3@lichtvoll.de>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"

Hi!

Summary: I am curious why "ls -l" reports 16 EiB as the size of a 
directory entry. As to what I can see the filesystem is perfectly fine.

Kernel 6.15, self compiled. 320 GiB BCacheFS on LUKS encrypted LVM. 
Checksums are xxhash. Filesystem was created recently on self compiled 
6.15-rc7 with self-compiled bcachefs tools from git tag 1.25.2. "bcachefs" 
reports 1.25.1 as version number.

I have a directory entry that according to ls -l is quite big:

drwxrwxr-x 5 martin martin 18446744073709551400 DATE DIRECTORY

Or in human readable:

drwxrwxr-x 5 martin martin 16E DATE DIRECTORY

The directory contains about 100 GiB in 14 files. All but one of them 
between 7 GiB and 8 GiB. The other one is about 800 MiB.

Scrubbing reports no error.

Running "fsck.bcachefs -n" online does not report any errors:

% fsck.bcachefs -n DEVICE
Running fsck online
bcachefs (dm-5): check_alloc_info... done
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
bcachefs (dm-5): check_indirect_extents... done
bcachefs (dm-5): check_root... done
bcachefs (dm-5): check_subvolume_structure... done
bcachefs (dm-5): check_directory_structure... done

Cannot run "fsck.bachefs" offline currently as trying to dismount gives:

umount: /MNTPOINT: target is busy.

According to lsof there is no indication on why it would be busy.

Some hours ago I was able to dismount, but then "fsck.bcachefs -n" 
reported that the device would be busy. If need be I can disable automatic 
mounting through "fstab" temporarily to check offline.

However currently I have no indication anything is wrong with the 
filesystem. Still I am curious:

Why does "ls -l" tell me the size of that directory entry is 16 EiB?

I made another directory on the device and "ls -l" reports 0 as the size 
of the directory. I copied the contents of "/usr/bin" to it, but "ls -l" 
still reports 0 as the size. Due to LZ4 compression I still have enough 
free space to duplicate the files from that directory entry with 16 EiB 
size to a test directory if need be.

I have a sub volume on the device with 2 files of 75 GiB files and 6 very 
small files. "ls -l" reports 0 as the size of the directory which holds 
the sub volume.

So what does BCacheFS return as the size of a directory entry and how can 
it be 16 EiB?

Best,
-- 
Martin



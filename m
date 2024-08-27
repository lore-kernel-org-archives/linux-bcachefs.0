Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.2])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 059BD13B588;
	Tue, 27 Aug 2024 09:50:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.2
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724752212; cv=none; b=usaMZqNyxnZ7vFJcRDyuovFQpN+X3a43RPuB7gs7SjNdPvyi747Bgy5uv3GW9m1zs4wuj5pst6hMCBegkgCHHAOoQ/7LKSlOxecTOqD0KqTBy0cCNJwwdT2zRKM/Hqgb7j8H4S3AY1isnCrIA/COrJPE4dMSAMIlAK2qOCdPP9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724752212; c=relaxed/simple;
	bh=3WspzH0ayXuzmye4TMFTA5SKabG1smPbMSDk8Oo6bjk=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=O4Nbp+9sMvkdeAmP0MTs3pP6Xt5bsJknnvHZ6Ym6zCd8O92dWpKz4b93w4z5bX8AsoS4Vzd33IcNw24VTn5yBCh20Rs6JX8BpAFbh77mb/8ggfaQo3Bx2cU6/MrTWxp8UqxK/Sqv81qrhCeXJgkMDksakEItJRXYIamltssjZ1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=DJPz1CDV; arc=none smtp.client-ip=220.197.31.2
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="DJPz1CDV"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=jk20T
	b3e+CGSiqUnBq3as4wi/rgAW0Z861vyIyF0Keo=; b=DJPz1CDVlYtOeHiUFBWqb
	V/JEwif7E134kJ+0v/ddSToeJlzvuiN65k0BqwAPcbzTErG4cg2cGMUa0V2wUGqj
	aKpViXiVm4MBA6us0742b8Lcz2Fgy67m7aoVWINSFN51jowF+szjUdFFSZoiX4dU
	xTBK7ZriwSMu4HFS6Rm2n0=
Received: from localhost.localdomain (unknown [111.35.190.113])
	by gzga-smtp-mta-g2-2 (Coremail) with SMTP id _____wDnTwotoc1mnl1vEA--.38326S4;
	Tue, 27 Aug 2024 17:49:50 +0800 (CST)
From: David Wang <00107082@163.com>
To: kent.overstreet@linux.dev
Cc: linux-bcachefs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [BUG?] bcachefs: keep writing to device when there is no high-level I/O activity.
Date: Tue, 27 Aug 2024 17:49:33 +0800
Message-Id: <20240827094933.6363-1-00107082@163.com>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wDnTwotoc1mnl1vEA--.38326S4
X-Coremail-Antispam: 1Uf129KBjvJXoWxAry7AFy8GryfGr45JF13Jwb_yoWrZw4kpr
	yfJry7GF4kJryUJFWDCayxtryxGrnxtw1DJryUJ348Crs5Zr1UtF42qFyvqFy5JFy8XFy7
	XF48Jw15Grn2vr7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07UDrcfUUUUU=
X-CM-SenderInfo: qqqrilqqysqiywtou0bp/xtbB0gFIqmWXz+r2hQAAsV

Hi,

I was using two partitions on same nvme device to compare filesystem performance,
and I consistantly observed a strange behavior:

After 10 minutes fio test with bcachefs on one partition, performance degrade
significantly for other filesystems on other partition (same device).

	ext4  150M/s --> 143M/s
	xfs   150M/s --> 134M/s
	btrfs 127M/s --> 108M/s

Several round tests show the same pattern that bcachefs seems occupy some device resource
even when there is no high-level I/O.

I monitor /proc/diskstats, and it confirmed that bcachefs do keep writing the device.
Following is the time serial samples for "writes_completed" on my bcachefs partition:

writes_completed @timestamp
	       0 @1724748233.712
	       4 @1724748248.712    <--- mkfs
	       4 @1724748263.712
	      65 @1724748278.712
	   25350 @1724748293.712
	   63839 @1724748308.712    <--- fio started
  	  352228 @1724748323.712
	  621350 @1724748338.712
	  903487 @1724748353.712
        ...
	12790311 @1724748863.712
	13100041 @1724748878.712
	13419642 @1724748893.712
	13701685 @1724748908.712    <--- fio done (10minutes)
	13701769 @1724748923.712    <--- from here, average 5~7writes/second for 2000 seconds
	13701852 @1724748938.712
	13701953 @1724748953.712
	13702032 @1724748968.712
	13702133 @1724748983.712
	13702213 @1724748998.712
	13702265 @1724749013.712
	13702357 @1724749028.712
        ...
	13712984 @1724750858.712
	13713076 @1724750873.712
	13713196 @1724750888.712
	13713299 @1724750903.712
	13713386 @1724750918.712
	13713463 @1724750933.712
	13713501 @1724750948.712   <--- writes stopped here
	13713501 @1724750963.712
	13713501 @1724750978.712
	...

Is this behavior expected? 

My test script:
	set -e
	for fsa in "btrfs" "ext4" "bcachefs" "xfs"
	do
		if [ $fsa == 'ext4' ]; then
			mkfs -t ext4 -F /dev/nvme0n1p1
		else
			mkfs -t $fsa -f /dev/nvme0n1p1
		fi
		mount -t $fsa /dev/nvme0n1p1 /disk02/dir1
		for fsb in "ext4" "bcachefs" "xfs" "btrfs"
		do
			if [ $fsb == 'ext4' ]; then
				mkfs -t ext4 -F /dev/nvme0n1p2
			else
				mkfs -t $fsb -f /dev/nvme0n1p2
			fi
			mount -t $fsb /dev/nvme0n1p2 /disk02/dir2

			cd /disk02/dir1 && fio --randrepeat=1 --ioengine=libaio --direct=1 --name=test  --bs=4k --iodepth=64 --size=1G --readwrite=randrw  --runtime=600 --numjobs=8 --time_based=1 --output=/disk02/fio.${fsa}.${fsb}.0
			sleep 30
			cd /disk02/dir2 && fio --randrepeat=1 --ioengine=libaio --direct=1 --name=test  --bs=4k --iodepth=64 --size=1G --readwrite=randrw  --runtime=600 --numjobs=8 --time_based=1 --output=/disk02/fio.${fsa}.${fsb}.1
			sleep 30
			cd /disk02
			umount /disk02/dir2
		done
		umount /disk02/dir1
	done

And here is a report for one round of test matrix:
+----------+-----------------------------+-----------------------------+-----------------------------+-----------------------------+
|   R|W    |             ext4            |           bcachefs          |             xfs             |            btrfs            |
+----------+-----------------------------+-----------------------------+-----------------------------+-----------------------------+
|   ext4   |    [ext4]147MB/s|147MB/s    |    [ext4]146MB/s|146MB/s    |    [ext4]150MB/s|150MB/s    |    [ext4]149MB/s|149MB/s    |
|          |    [ext4]146MB/s|146MB/s    | [bcachefs]72.2MB/s|72.2MB/s |     [xfs]149MB/s|149MB/s    |    [btrfs]132MB/s|132MB/s   |
| bcachefs | [bcachefs]71.9MB/s|71.9MB/s | [bcachefs]65.1MB/s|65.1MB/s | [bcachefs]69.6MB/s|69.6MB/s | [bcachefs]65.8MB/s|65.8MB/s |
|          |    [ext4]143MB/s|143MB/s    | [bcachefs]71.5MB/s|71.5MB/s |     [xfs]134MB/s|133MB/s    |    [btrfs]108MB/s|108MB/s   |
|   xfs    |     [xfs]148MB/s|148MB/s    |     [xfs]147MB/s|147MB/s    |     [xfs]152MB/s|152MB/s    |     [xfs]151MB/s|151MB/s    |
|          |    [ext4]147MB/s|147MB/s    | [bcachefs]71.3MB/s|71.3MB/s |     [xfs]148MB/s|148MB/s    |    [btrfs]127MB/s|127MB/s   |
|  btrfs   |    [btrfs]132MB/s|132MB/s   |    [btrfs]112MB/s|111MB/s   |    [btrfs]110MB/s|110MB/s   |    [btrfs]110MB/s|110MB/s   |
|          |    [ext4]147MB/s|146MB/s    | [bcachefs]69.7MB/s|69.7MB/s |     [xfs]146MB/s|146MB/s    |    [btrfs]125MB/s|125MB/s   |
+----------+-----------------------------+-----------------------------+-----------------------------+-----------------------------+
(The rows are for the FS on the first partition, and the cols are on the second partition)

The version of bcachefs-tools on my system is 1.9.1.
(The impact is worse, ext4 dropped to 80M/s, when I was using bcachefs-tools from debian repos which is too *old*,
and known to cause bcachefs problems. And that is the reason that I do this kind of test.)


Thanks
David


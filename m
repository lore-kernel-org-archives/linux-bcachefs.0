Received: from vps01.wiesinger.com (vps01.wiesinger.com [46.36.37.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEB4A14F9F1
	for <linux-bcachefs@vger.kernel.org>; Sun,  1 Sep 2024 12:01:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.36.37.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725192091; cv=none; b=Z7PpIKEQzsrc24RAj46T7Zt+6Hi5vkGfpthqL2rPbDpUu8gZQrxibMKyjSVhboDw9tGTweAd12piFee667rLp0ILenyYiEq1w3CGSKFUQrInTc6LrMLeZYIp2yHeenhmuuVUU6vKJiWnexUQoJRs0cO1szjzK3dmTiPPDAsvx8Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725192091; c=relaxed/simple;
	bh=GxX37f5/+Dz/bZMHyHh7CInO2TClpdeoadpw1NwXEvM=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type; b=gr0CJrW9K0sja5aer5T0yJtyYFyzmzpcEFmlYT0RaRYpc4+IpRQ2ljxKiN5mBMDba7aWyAz2BcSb3Fj6GeAxYjh9c+pV0J3bXCR+XJynVCbbBeuwY3YebsHK+/sGKmudqx/X0KpkeNo30QxIMN19LyCjkbpQLOsslupr83Ho404=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=wiesinger.com; spf=pass smtp.mailfrom=wiesinger.com; dkim=pass (4096-bit key) header.d=wiesinger.com header.i=@wiesinger.com header.b=1APOeLH5; arc=none smtp.client-ip=46.36.37.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=wiesinger.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wiesinger.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=wiesinger.com header.i=@wiesinger.com header.b="1APOeLH5"
Received: from wiesinger.com (wiesinger.com [84.112.177.114])
	by vps01.wiesinger.com (Postfix) with ESMTPS id B5D019F210
	for <linux-bcachefs@vger.kernel.org>; Sun,  1 Sep 2024 14:01:27 +0200 (CEST)
Received: from [192.168.32.192] (bgld-ip-192.intern [192.168.32.192])
	(authenticated bits=0)
	by wiesinger.com (8.18.1/8.18.1) with ESMTPSA id 481C1QS81082421
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO)
	for <linux-bcachefs@vger.kernel.org>; Sun, 1 Sep 2024 14:01:26 +0200
DKIM-Filter: OpenDKIM Filter v2.11.0 wiesinger.com 481C1QS81082421
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wiesinger.com;
	s=default; t=1725192086;
	bh=GGuPa12UHj4RrLzlBypj1yMje6idAvUheRZbeprDoLk=;
	h=Date:To:From:Subject:From;
	b=1APOeLH5nwPmJ7gPzf7HtF2FpBKbr2mvIuNkOVbxrxXmQRuDFieFPX6DRHzgz3W9G
	 leU3WiQ2cPKFhkpxghMsA6WE8+FMcbiWlmmhAy0nUL49bWzVn3QD4NYovfazYsaJwM
	 Y08R64QhM75CSYtiGdo454PFqdKZzRw9SNn/WXOhCmQ+6YTc8vAZr9A7bjYqVLzulo
	 vqXSBZfNNTOYSWtqY/nxYWh9+ro3lPXnpsXi3vUoXQHzzjbSxDPzU3RQ86L21HB4Xs
	 1KuOgKCgmm6Q7tJwiK2EzsmwWesoWXESltf4l6hEAWRvgf+n0th1mpfEQqmrPVeBUj
	 +nTTlaLWXgYd4+AM76gGPfhSYDPREiWDd9dYH0kIDuDMT/QpFNxjMx3EgiOT0fnK+u
	 wteG3I8Bff+dD7wo8y+xrNGp7l2JzbPgyW4VoTAR3HQrymMlbL4wXTdNWgh0B+I/Ac
	 PBqmgjYinUVg8704o4klh1l2/2YBRWDeYagkRQQpKu6RgHLWAK/i5ospwaUQ2jjYYn
	 NkczGV7+diSoGeIfEGhwCvACnkMfmBieCOI53wO3znTT3m8RqoX8J2VZQo0+AGhmJX
	 3AWn6iKCrJnquJQ+SARSS2XvtaZiUWC+0bCv33wGX0D8Oh5CHh5AFcxb4SpseZB6LD
	 jRbBb8nx5yHvCuL6INR1UDL0=
Message-ID: <aa613c37-153c-43e4-b68e-9d50744be7de@wiesinger.com>
Date: Sun, 1 Sep 2024 14:01:25 +0200
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
To: linux-bcachefs@vger.kernel.org
Content-Language: en-US
From: Gerhard Wiesinger <lists@wiesinger.com>
Subject: Corrupt bcachefs can't be transferred into a consistent state
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hello,

I'm having some Fedora Linux VMs (actual versions, latest updates) in a 
virtual test infrastructure on Virtualbox. There I run different VMs 
with different filesystems (ext4, xfs, zfs, bcachefs and btrfs).

I had a hardware problem on the underlying hardware where around 1000 4k 
blocks could not be read anymore. I migrated with ddrescure the whole 
disk which worked well.

Of course I was expecting some data loss in the VMs but wanted to get 
them in a consistent state.

The following file systems got very easy in a consistent state with the 
corresponding repair/scrub tools of the filesystems:
- ext4
- xfs
- zfs

Unfortunately 2 filesystem can't get into a state, where the filesystem 
repair tools report "everything fine" (of course with some loss data, 
but that's fine):
- btrfs
- bcachefs

commands run with bcachefs (git version):
git log -n1 | head -n1
commit 1e058db4b603f8992b781b4654b48221dd04407a
./bcachefs version
1.12.0

But bcachefs never got into a consistent state, also with newer 
versions. Also check with older versions (1.7.0) run for a long time.

To reproduce the problem I created a new filesystem and copied some 
files there:
mkfs.bcachefs -f /dev/sdb
time cp -Rap /usr /mnt

Afterwards I created a (quick&dirty) script "corrupt_device.sh" to 
corrupt the device in the same manner as the original failure (1000 4k 
blocks will be randomly overwritten).
Script: see below

~/corrupt_device.sh
./bcachefs fsck -pf /dev/sdb
./bcachefs fsck -pfR /dev/sdb

Result: It can be reproduced, that bcachefs can't be brought into a 
consistent state even after several runs of the repair.

You can also try to reproduce it and create a testcase out of it.

Any ideas how to repair and what can be done to get it into a consistent 
state?

Thnx.

Ciao,
Gerhard

Script corrupt_device.sh:
#!/usr/bin/env bash

RANDOM_DEVICE=/dev/urandom
OUTPUT_DEVICE=/dev/sdb
COUNT=1000
BLOCK_SIZE=4096

MAX_BLOCK_SIZE=$(blockdev --getsize64 ${OUTPUT_DEVICE})

echo "# Configured maximum size=${MAX_BLOCK_SIZE}"
MAX_BLOCK_NUMBER=$((MAX_BLOCK_SIZE/BLOCK_SIZE))
echo "# Maximum block number=${MAX_BLOCK_NUMBER}"

for ((BLOCK_NUMBER=1; BLOCK_NUMBER<=${COUNT}; BLOCK_NUMBER++ )) do
   BLOCK=`shuf --input-range=0-${MAX_BLOCK_NUMBER} --head-count=1`
   dd if=${RANDOM_DEVICE} of=${OUTPUT_DEVICE} bs=${BLOCK_SIZE} 
seek=${BLOCK} count=1 > /dev/null 2>&1
done


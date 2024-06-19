Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 798431C20
	for <linux-bcachefs@vger.kernel.org>; Wed, 19 Jun 2024 01:04:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.190
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718759089; cv=none; b=grPMuOiFOuI84AshvXMrVUmnGTHB/Bvk9YqVwwLARJkwqEKSZwGp9i/G9iQnacBbb4sx5AlqNbgwVIHxwBPhVKx3qLONuTMYMa6C/e9EEbfpxR8ImHq8CHzcDkzXryggSOk+zVM2E4lc5wfaAlPKt+wXeg4zd0eR8iJYHYeXUpg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718759089; c=relaxed/simple;
	bh=kuCc+wGwOYcvG35yBWJdOGSnofI1f+uptR8/a59hEck=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=DRvPN+dPHD5hoDAK+7rA1PeYUS1Q/3P1KiPxr2mWl7vHCxfx2GWn/J0Kh19HfhV7rSdFlofQ4w+n3TolmQB4guZCDfEHleIHf5eghyi6hqcRFvBNAgN7A2JXH+vwl2YUDiwVSz7161b+N5N2csXaVNl/WtKlzkBSFyjFt9geJi8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.190
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.163])
	by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4W3lgC6C4wz1ytRh;
	Wed, 19 Jun 2024 09:01:11 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (unknown [7.185.36.66])
	by mail.maildlp.com (Postfix) with ESMTPS id BA65318001B;
	Wed, 19 Jun 2024 09:04:43 +0800 (CST)
Received: from [10.67.111.104] (10.67.111.104) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 19 Jun 2024 09:04:43 +0800
Message-ID: <77f02a73-524a-42ce-8636-c2f805f818ed@huawei.com>
Date: Wed, 19 Jun 2024 09:04:43 +0800
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] bcachefs: support idmap mounts
To: Kent Overstreet <kent.overstreet@linux.dev>
CC: <bfoster@redhat.com>, <linux-bcachefs@vger.kernel.org>,
	<christian@brauner.io>
References: <20240615102038.3110867-1-lihongbo22@huawei.com>
 <fhgec4fmisjfp3sirxlkwl5napoitzxkjdhvvmebmrvlalcqba@mmh2m45hpojb>
 <7611b61b-0d75-47ed-ac5f-4a0ef123f108@huawei.com>
 <l6nh3aopbeytzbe6n5w35dhmgbo7ucz6kk46o7l6m7qui4isl2@kbgadvicrt7d>
 <ef5899f6-eb82-419c-b3bc-f7e8ea6bd418@huawei.com>
 <wdgnznhxov6abj6b5m2owrgjad4eriijh6nfhy6cds2tl4527e@ueth2dbhhoid>
Content-Language: en-US
From: Hongbo Li <lihongbo22@huawei.com>
In-Reply-To: <wdgnznhxov6abj6b5m2owrgjad4eriijh6nfhy6cds2tl4527e@ueth2dbhhoid>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpeml500022.china.huawei.com (7.185.36.66)



On 2024/6/18 21:54, Kent Overstreet wrote:
> On Tue, Jun 18, 2024 at 09:00:53AM +0800, Hongbo Li wrote:
>> What's about xfstest local.config?
> 
> just run L(*G#F$&* ktest, you shouldn't need me to debug this...

Apologize for this.

Thanks,
Hongbo
> 
> #!/bin/bash
> # xfstests wrapper:
> 
> . $(dirname $(readlink -e "${BASH_SOURCE[0]}"))/test-libs.sh
> 
> require-git https://git.kernel.org/pub/scm/fs/xfs/xfstests-dev.git xfstests
> 
> # disable io_uring - io_uring is currently broken w.r.t. unmounting, we get
> # spurious umount failures with -EBUSY
> export ac_cv_header_liburing_h=no
> 
> require-kernel-config BSD_PROCESS_ACCT
> require-kernel-config FAULT_INJECTION,FAULT_INJECTION_DEBUG_FS,FAIL_MAKE_REQUEST
> require-kernel-config MD,BLK_DEV_DM,DM_FLAKEY,DM_SNAPSHOT,DM_LOG_WRITES
> require-kernel-config DM_THIN_PROVISIONING
> require-kernel-config DM_ZERO
> require-kernel-config BLK_DEV,BLK_DEV_LOOP
> require-kernel-config SCSI_DEBUG=m
> require-kernel-config USER_NS
> require-kernel-config OVERLAY_FS
> 
> # 038,048,312 require > 10G
> config-scratch-devs 14G
> config-scratch-devs 14G
> config-scratch-devs 14G
> 
> # swap
> config-scratch-devs 2G
> 
> config-timeout 7200
> 
> list_tests()
> {
>      pushd $(dirname $(readlink -e "${BASH_SOURCE[0]}"))/xfstests > /dev/null
> 
>      for i in tests/*; do
> 	if [[ -d $i ]]; then
> 	    pushd $i > /dev/null
> 	    ../../tools/mkgroupfile group.list
> 	    popd > /dev/null
> 	fi
>      done
> 
>      for g in generic shared "$FSTYP"; do
> 	[[ ! -f tests/$g/group.list ]] && continue
> 	grep -hE '[0-9][0-9][0-9] .*(auto|dangerous)' tests/$g/group.list|
> 	    sed -e "s/ .*//" -e "s/^/$g\//"
>      done
> 
>      popd > /dev/null
> }
> 
> run_xfstests()
> {
>      if [[ ! -f /xfstests-init-done ]]; then
> 	mkswap ${ktest_scratch_dev[3]}
> 	swapon ${ktest_scratch_dev[3]}
> 
> 	useradd -m fsgqa
> 	useradd fsgqa2
> 	useradd 123456-fsgqa
> 
> 	mkdir -p /mnt/test /mnt/scratch
> 
> 	run_quiet "building $(basename $i)" make -j $ktest_cpus -C "$ktest_dir/tests/xfstests"
> 
> 	rm -rf /ktest-out/xfstests
> 
> 	wipefs -af ${ktest_scratch_dev[0]}
> 	mkfs.$FSTYP $MKFS_OPTIONS -q ${ktest_scratch_dev[0]}
> 
> 	touch /xfstests-init-done
>      fi
> 
>      # mkfs.xfs 5.19 requires these variables to be exported into its
>      # environment to allow sub-300MB filesystems for fstests.
>      export TEST_DEV=${ktest_scratch_dev[0]}
>      export TEST_DIR=/mnt/test
>      cat << EOF > /ktest/tests/xfstests/local.config
> TEST_DEV=${ktest_scratch_dev[0]}
> TEST_DIR=$TEST_DIR
> SCRATCH_DEV=${ktest_scratch_dev[1]}
> SCRATCH_MNT=/mnt/scratch
> LOGWRITES_DEV=${ktest_scratch_dev[2]}
> RESULT_BASE=/ktest-out/xfstests
> LOGGER_PROG=true
> EOF
> 
>      export MKFS_OPTIONS
>      mount -t $FSTYP ${ktest_scratch_dev[0]} /mnt/test
> 
>      cd "$ktest_dir/tests/xfstests"
>      ./check "$@"
> }

Received: from out-186.mta1.migadu.com (out-186.mta1.migadu.com [95.215.58.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB6B027446
	for <linux-bcachefs@vger.kernel.org>; Tue, 18 Jun 2024 13:54:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718718889; cv=none; b=qKXMGFi6q5X911PJzwa+ZYjmnerX0cdqPzBf+F9Y809Ufz7gZHjmDsRKZW2JpPDvxfeiyiVlhxqmCUeIQYHfRMXd0qZM/d9kJTRowoa/UKUspW8GIug/T+P/djFyzXXpOAPkcGKjWy8A0OYfqvLhfCD7Juf+Hc0U1KvIbRw6ueI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718718889; c=relaxed/simple;
	bh=ObPM64H9iOIyRNnzvgxLua5zhsZfs0uBCj9UeQtvqbI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Lc2Gd7k1+9eQy37a+SEFbtXg5Ef4+gi1iI2lTKgTE6KrmVb0gIDsysC1oK6miAkmNxEcNjwxluXEZQtVcHMEmOQv0T5/StJZjR002YaCLTHZea9itkP3WRpoxP4+obsF41a7NKIVhwAw9DWqGD5awbjAIUuCp9grV5UYcPieQMU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=llPMreCD; arc=none smtp.client-ip=95.215.58.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="llPMreCD"
X-Envelope-To: lihongbo22@huawei.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1718718885;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=SOCk1a5F/fJdoPz+R98lxMnpcN77JEbPwUwL0g4/GyU=;
	b=llPMreCDkdrjTI61vJVjEHp63yzlpBa3/8F9xt9oAmVMMdA1j7QYC38ufAqoO1N4OwtUFr
	AV6IscilpKoo4HAJBU8H5kvSbr5tuBSgjWbYNWMZgMa7UT8FH7eNpRgElvp1A4K7GBBHFt
	UM7JvBuUfv9a0RH4p8j3yBHZa5/QEro=
X-Envelope-To: bfoster@redhat.com
X-Envelope-To: linux-bcachefs@vger.kernel.org
X-Envelope-To: christian@brauner.io
Date: Tue, 18 Jun 2024 09:54:42 -0400
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Hongbo Li <lihongbo22@huawei.com>
Cc: bfoster@redhat.com, linux-bcachefs@vger.kernel.org, 
	christian@brauner.io
Subject: Re: [PATCH] bcachefs: support idmap mounts
Message-ID: <wdgnznhxov6abj6b5m2owrgjad4eriijh6nfhy6cds2tl4527e@ueth2dbhhoid>
References: <20240615102038.3110867-1-lihongbo22@huawei.com>
 <fhgec4fmisjfp3sirxlkwl5napoitzxkjdhvvmebmrvlalcqba@mmh2m45hpojb>
 <7611b61b-0d75-47ed-ac5f-4a0ef123f108@huawei.com>
 <l6nh3aopbeytzbe6n5w35dhmgbo7ucz6kk46o7l6m7qui4isl2@kbgadvicrt7d>
 <ef5899f6-eb82-419c-b3bc-f7e8ea6bd418@huawei.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ef5899f6-eb82-419c-b3bc-f7e8ea6bd418@huawei.com>
X-Migadu-Flow: FLOW_OUT

On Tue, Jun 18, 2024 at 09:00:53AM +0800, Hongbo Li wrote:
> What's about xfstest local.config?

just run L(*G#F$&* ktest, you shouldn't need me to debug this...

#!/bin/bash
# xfstests wrapper:

. $(dirname $(readlink -e "${BASH_SOURCE[0]}"))/test-libs.sh

require-git https://git.kernel.org/pub/scm/fs/xfs/xfstests-dev.git xfstests

# disable io_uring - io_uring is currently broken w.r.t. unmounting, we get
# spurious umount failures with -EBUSY
export ac_cv_header_liburing_h=no

require-kernel-config BSD_PROCESS_ACCT
require-kernel-config FAULT_INJECTION,FAULT_INJECTION_DEBUG_FS,FAIL_MAKE_REQUEST
require-kernel-config MD,BLK_DEV_DM,DM_FLAKEY,DM_SNAPSHOT,DM_LOG_WRITES
require-kernel-config DM_THIN_PROVISIONING
require-kernel-config DM_ZERO
require-kernel-config BLK_DEV,BLK_DEV_LOOP
require-kernel-config SCSI_DEBUG=m
require-kernel-config USER_NS
require-kernel-config OVERLAY_FS

# 038,048,312 require > 10G
config-scratch-devs 14G
config-scratch-devs 14G
config-scratch-devs 14G

# swap
config-scratch-devs 2G

config-timeout 7200

list_tests()
{
    pushd $(dirname $(readlink -e "${BASH_SOURCE[0]}"))/xfstests > /dev/null

    for i in tests/*; do
	if [[ -d $i ]]; then
	    pushd $i > /dev/null
	    ../../tools/mkgroupfile group.list
	    popd > /dev/null
	fi
    done

    for g in generic shared "$FSTYP"; do
	[[ ! -f tests/$g/group.list ]] && continue
	grep -hE '[0-9][0-9][0-9] .*(auto|dangerous)' tests/$g/group.list|
	    sed -e "s/ .*//" -e "s/^/$g\//"
    done

    popd > /dev/null
}

run_xfstests()
{
    if [[ ! -f /xfstests-init-done ]]; then
	mkswap ${ktest_scratch_dev[3]}
	swapon ${ktest_scratch_dev[3]}

	useradd -m fsgqa
	useradd fsgqa2
	useradd 123456-fsgqa

	mkdir -p /mnt/test /mnt/scratch

	run_quiet "building $(basename $i)" make -j $ktest_cpus -C "$ktest_dir/tests/xfstests"

	rm -rf /ktest-out/xfstests

	wipefs -af ${ktest_scratch_dev[0]}
	mkfs.$FSTYP $MKFS_OPTIONS -q ${ktest_scratch_dev[0]}

	touch /xfstests-init-done
    fi

    # mkfs.xfs 5.19 requires these variables to be exported into its
    # environment to allow sub-300MB filesystems for fstests.
    export TEST_DEV=${ktest_scratch_dev[0]}
    export TEST_DIR=/mnt/test
    cat << EOF > /ktest/tests/xfstests/local.config
TEST_DEV=${ktest_scratch_dev[0]}
TEST_DIR=$TEST_DIR
SCRATCH_DEV=${ktest_scratch_dev[1]}
SCRATCH_MNT=/mnt/scratch
LOGWRITES_DEV=${ktest_scratch_dev[2]}
RESULT_BASE=/ktest-out/xfstests
LOGGER_PROG=true
EOF

    export MKFS_OPTIONS
    mount -t $FSTYP ${ktest_scratch_dev[0]} /mnt/test

    cd "$ktest_dir/tests/xfstests"
    ./check "$@"
}

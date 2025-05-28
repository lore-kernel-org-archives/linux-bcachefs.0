Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E11022ACCE
	for <linux-bcachefs@vger.kernel.org>; Wed, 28 May 2025 07:06:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748415966; cv=none; b=rFmAw2G8ROEMS9FlXDHM1ojYPr8+CMMq5k/0p8ivCdQdWy7UC6vli+Ih0X0/bmvN5W5/YYmQwqZXk5Y6yTPtCcoJKLtbYDIEo2GmI0NcSSgEUv652f6mkr0CwSWA8UjdHO02YuUwlqH4+wWI/puHmD4tQQ0ZejuOA66D6Gc/4oY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748415966; c=relaxed/simple;
	bh=PxugoUaBEvMbHjZ5AF8wfuv2CNvpLiUz+JxvLYSQRjA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JqdZtbKwddeGqfkxg7sOYxHiC9sArysGjHrW5M8vQfShYZAYtUsGTmc8G2s66y/dFD/4JaULw/JidQ1Yl0L/SXh3fGBtC5EpN+LtTeyQtf9Q6FkPgagApV8qBBkJD9tgAY9Ra079S1B3B+lb7otyBS/actQQf0g3qapSpcEBAoY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=mZ2ARY2o; arc=none smtp.client-ip=95.215.58.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="mZ2ARY2o"
Date: Wed, 28 May 2025 03:05:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1748415952;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=rGJ6H8rmj9CFZfW8rrkxY0Ph27SdcLA3QsZyFDgGUlU=;
	b=mZ2ARY2o66+y0CoXGhCnaqXYhbCxcZzKjIguehyIQiao/3OMJZ1NeeOw2aSG93ztpDGrUs
	jT/A7PVjtS2D9BJhgSKuUwLSsCKrzfwvpw9rOTvrzwx6UKbQxC70+PVGz/ApYuxsSKsqHg
	fM1HNU62PtPP4+iM4JEaUtj48YdFPL0=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: kernel test robot <oliver.sang@intel.com>
Cc: oe-lkp@lists.linux.dev, lkp@intel.com, linux-kernel@vger.kernel.org, 
	linux-bcachefs@vger.kernel.org
Subject: Re: [linus:master] [bcachefs]  cd3cdb1ef7: last_state.incomplete
Message-ID: <uab4hrzt77vunesxicyovjpqvoegqo6tozsb4lndj4c2udcq5f@dbicbg2jyw2i>
References: <202505281410.cca50993-lkp@intel.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202505281410.cca50993-lkp@intel.com>
X-Migadu-Flow: FLOW_OUT

On Wed, May 28, 2025 at 02:31:37PM +0800, kernel test robot wrote:
> 
> 
> Hello,
> 
> 
> for this change, we reported
> "[koverstreet-bcachefs:bcachefs-put-folio-assert] [bcachefs] 0718bafa21: last_state.incomplete"
> in
> https://lore.kernel.org/all/202505081551.92a07edd-lkp@intel.com/ [1]
> upon Ice Lake.
> 
> now we notice the commit is in mainline, and we captured similar issue on
> another platform.
> 
> below full report FYI.
> 
> 
> kernel test robot noticed "last_state.incomplete" on:
> 
> commit: cd3cdb1ef706a1ac725194d81858d58375739b25 ("bcachefs: Single err message for btree node reads")
> https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git master
> 
> [test failed on linus/master      914873bc7df913db988284876c16257e6ab772c6]
> [test failed on linux-next/master fefff2755f2aa4125dce2a1edfe7e545c7c621f2]
> 
> in testcase: xfstests
> version: xfstests-x86_64-e161fc34-1_20250526
> with following parameters:
> 
> 	disk: 4HDD
> 	fs: bcachefs
> 	test: generic-group-67
> 
> 
> 
> config: x86_64-rhel-9.4-func
> compiler: gcc-12
> test machine: 8 threads 1 sockets Intel(R) Core(TM) i7-7700 CPU @ 3.60GHz (Kaby Lake) with 32G memory
> 
> (please refer to attached dmesg/kmsg for entire log/backtrace)
> 
> 
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <oliver.sang@intel.com>
> | Closes: https://lore.kernel.org/oe-lkp/202505281410.cca50993-lkp@intel.com
> 
> 
> The kernel config and materials to reproduce are available at:
> https://download.01.org/0day-ci/archive/20250528/202505281410.cca50993-lkp@intel.com
> 
> 
> similar as report [1], from the dmesg in above link, we still didn't see any
> Call Trace, but below informations
> 
> 
> [   41.372233][ T1447] bcachefs (sda1): starting version 1.13: inode_has_child_snapshots
> [   41.372233][ T1447]   allowing incompatible features above 0.0: (unknown version)
> [   41.387511][ T1447] bcachefs (sda1): recovering from clean shutdown, journal seq 20
> [   41.395125][ T1447] bcachefs (sda1): Doing compatible version upgrade from 1.13: inode_has_child_snapshots to 1.25: extent_flags
> [   41.395125][ T1447]   running recovery passes: check_allocations,check_extents_to_backpointers
> [   41.418989][  T335] LKP: stdout: 307: Kernel tests: Boot OK!
> [   41.418998][  T335] 
> [   41.494922][ T1447] bcachefs (sda1): error reading btree root btree=accounting level=0: btree_node_read_error, fixing
> [   41.505517][ T1447] bcachefs (sda1): bch2_fs_recovery(): error btree_node_read_error
> [   41.513201][ T1447] bcachefs (sda1): bch2_fs_start(): error starting filesystem btree_node_read_error
> [   41.874130][ T1447] bcachefs: bch2_fs_get_tree() error: btree_node_read_error
> [   46.990004][  T335] LKP: stdout: 307: HOSTNAME lkp-kbl-d01, MAC 48:4d:7e:be:54:6f, kernel 6.15.0-rc4-00141-gcd3cdb1ef706 1
> [   46.990016][  T335] 
> [   47.103180][  T337] mount: /fs/sda1: can't read superblock on /dev/sda1.
> [   47.103189][  T337] 
> [   49.036739][  T337]        dmesg(1) may have more information after failed mount system call.
> [   49.036751][  T337] 

Err, what is this?

Is this a fuzz test, something from a test suite I've never heard of?
The log certainly doesn't give any useful context.

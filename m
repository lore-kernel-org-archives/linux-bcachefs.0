Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E9ED29406
	for <linux-bcachefs@vger.kernel.org>; Sat, 21 Sep 2024 23:13:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726960419; cv=none; b=lsIOktBz7F8DldERbI+QlOsS8c/nDjy0E/hpE9US5S1SQFJZlGRbPJJjhluaytIt6tLP6MtDbQEaA0oIM/3Qk9eMfKrpY3H3aoOqHpDwnL9q4ySjt/RLa4upjgHEUb0/rXkkoAiTmaRCK8d4JKyAd+vdG/zFJo65gDRTSOlaxIk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726960419; c=relaxed/simple;
	bh=JP7N9yo7IocGxy674ZuoPcj+KRTvUq9c8h+fWJyawyE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FDIS5afTRd8GlKUDHjoypTG5SRFji7IMrfGl+7Z3R7NAuuGSU11crPGpQ48CdtE6GHQYubKwfX6AEGMEwUteMDkoduYR1vxKuctBRaBKxv8v0KI7kHsQaLmNaFZUoGOGJzDjhYjAq2tcgFmuyagPNtGUOBtrVIRUoLpxLcIzkuI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=YOB9i5Ef; arc=none smtp.client-ip=95.215.58.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="YOB9i5Ef"
Date: Sat, 21 Sep 2024 19:13:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1726960415;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=FhxIRNJn3+wOktd4Wcety7rglVvl6O+KIKTls4uARvk=;
	b=YOB9i5EfxQQ2XatepMPn1vmXgUX4n9jruttEKmLL9hhVtl7ISFArfPZe5wKiD1uGb8lcp+
	CZqVQBoL6ecflgAOLidue4vA4Etrj1KYdgmkv6fYycxp+l82ROy9O2eIFQjY4amUJdgYVw
	EYeG/9HiPGYv6q1Bjtb7ZzeuiImuirg=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: David Disseldorp <ddiss@suse.de>
Cc: linux-bcachefs@vger.kernel.org, Martin Doucha <martin.doucha@suse.com>, 
	Hongbo Li <lihongbo22@huawei.com>
Subject: Re: [PATCH resend v2] bcachefs: reject unknown mount options
Message-ID: <fiwda3johielxusg2ab73km7xo6f3skobw7c7rv3mc4g6epgtf@vo5urbm7nb6a>
References: <20240917013957.13353-1-ddiss@suse.de>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240917013957.13353-1-ddiss@suse.de>
X-Migadu-Flow: FLOW_OUT

On Tue, Sep 17, 2024 at 01:39:57AM GMT, David Disseldorp wrote:
> This is effectively a revert of commit 03ef80b469d5 ("bcachefs: Ignore
> unknown mount options"), rebased atop commit 929d954330142 ("bcachefs:
> use new mount API").
> 
> Contrary to the 03ef80b469d5 commit message, unknown mount options do
> result in failure on other filesystems such as xfs, btrfs, ext4, etc.
> 
> Ignoring unknown options may result in unexpected behaviour: e.g. if
> an application requires future-workload-specific-mount-option to work
> and is run on a system without future-workload-specific-mount-option
> kernel support, then it may fail without indication of the missing
> kernel functionality.
> 
> This reversion may cause failures for existing users reliant on the
> ignore-unknown behaviour, but it should be bearable given bcachefs is
> still flagged experimental.
> 
> Fixes: 03ef80b469d5 ("bcachefs: Ignore unknown mount options")
> Reported-by: Martin Doucha <martin.doucha@suse.com>
> Closes: https://bugzilla.opensuse.org/show_bug.cgi?id=1230065
> Signed-off-by: David Disseldorp <ddiss@suse.de>
> Reviewed-by: Hongbo Li <lihongbo22@huawei.com>

I applied this and got some new failures in the CI - it seems something
is broken in remount.

00162 ========= TEST   ec_small
00162 
00162 WATCHDOG 60
00163 bcachefs (857683e6-ef4f-41f5-abdd-dca191c38fff): starting version 1.12: rebalance_work_acct_fix opts=errors=panic,metadata_replicas=2,data_replicas=2,erasure_code
00163 bcachefs (857683e6-ef4f-41f5-abdd-dca191c38fff): initializing new filesystem
00163 bcachefs (857683e6-ef4f-41f5-abdd-dca191c38fff): going read-write
00163 bcachefs (857683e6-ef4f-41f5-abdd-dca191c38fff): marking superblocks
00163 bcachefs (857683e6-ef4f-41f5-abdd-dca191c38fff): initializing freespace
00163 bcachefs (857683e6-ef4f-41f5-abdd-dca191c38fff): done initializing freespace
00163 bcachefs (857683e6-ef4f-41f5-abdd-dca191c38fff): reading snapshots table
00163 bcachefs (857683e6-ef4f-41f5-abdd-dca191c38fff): reading snapshots done
00163 bcachefs (857683e6-ef4f-41f5-abdd-dca191c38fff): done starting filesystem
00163 1+0 records in
00163 1+0 records out
00163 1048576 bytes (1.0 MB, 1.0 MiB) copied, 0.0115145 s, 91.1 MB/s
00163 bcachefs: bch2_parse_one_mount_opt() Bad mount option rwerrors
00163 Error: Invalid argument
00163 Error 1 at /host//home/testdashboard/ktest/tests/fs/bcachefs/ec.ktest 32 from: mount -o remount,ro /mnt, exiting
00163 Error 1 at /host/home/testdashboard/ktest/tests/prelude.sh 269 from: ( set -e; run_test $i ), exiting
00163 
00163 ========= FAILED ec_small in 2s

The test is just doing
mount -o remount,ro /mnt

Thomas, this is likely something you introduced, think you could take a
look?

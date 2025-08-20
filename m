Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABDC2182D2
	for <linux-bcachefs@vger.kernel.org>; Wed, 20 Aug 2025 15:31:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755703873; cv=none; b=Xw5PiXs++Ep3kCogNhMDb2q/3kpTbpSGaxrjwN/JTxKkhxjh7IgaQAmmUlxqv7TKMjNtSuCvuXNnXKYSmOKOok+cHhOR542GIWVoe3RqF38MhrRibu5OBAIW2oO28/n/y3Ij3YByfdc8o7nI/pRLA9ggy6YP+XulY5pT59bOnv4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755703873; c=relaxed/simple;
	bh=TJWl7ubMPHy5f7ZMC2mAyUcbaCZZBbUr1u6iUSxgDzY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qapiqyT8MmrjhKREBBX2jSWET0r3rSeU4gmYc4wum7APQHl0Qkm0g/+CqoH2M+sSIhCAlQYrbecpRF2URS8Ep8PAv/gT5hIIro9lla9eiOQ5rDMRqvA7GaaP7NRJEK3HnjgOACH+giKycqNstp/H4YYrCzg1xehm0m4RaWwZO7Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=UmSVSOcw; arc=none smtp.client-ip=91.218.175.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="UmSVSOcw"
Date: Wed, 20 Aug 2025 11:31:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1755703868;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=/67YTJi91+wJYTcsEgdWNoASEtxSGtYy70RSlLsO8ao=;
	b=UmSVSOcw+y2qMVn3mMMvmIMCxKsRLXotPs2Cm4SwF6ucyiYqbQr6WWPi0RJb5SufCS1tf8
	Ooec+5YtCDxVPn7YvZhI0Zwr8Z1GL7PBTfMO2rg5gfYjVeNw+6/A2JIu/uz6bpFt6aL9wJ
	2fSWEn3uMxOmVjF63MAxBGALhq7iIo0=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Gerhard Wiesinger <lists@wiesinger.com>
Cc: linux-bcachefs@vger.kernel.org
Subject: Re: Corrupt bcachefs can't be transferred into a consistent state
Message-ID: <ct4xs2rtqsl3ovjgcozl5neky3r3glw6exvu7hbs5geqtflybk@g3f6ciwq7y7r>
References: <aa613c37-153c-43e4-b68e-9d50744be7de@wiesinger.com>
 <ppqn3gvkjjsbg4sprijlqbldkuetnaco5orl4wxapsydee65g5@3nwlodfwjwcx>
 <a9f73879-cc08-45d9-9a3c-fb1f853739b9@wiesinger.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a9f73879-cc08-45d9-9a3c-fb1f853739b9@wiesinger.com>
X-Migadu-Flow: FLOW_OUT

On Wed, Jan 22, 2025 at 07:51:04AM +0100, Gerhard Wiesinger wrote:
> On 05.09.2024 06:29, Kent Overstreet wrote:
> > On Sun, Sep 01, 2024 at 02:01:25PM GMT, Gerhard Wiesinger wrote:
> > > Hello,
> > > 
> > > I'm having some Fedora Linux VMs (actual versions, latest updates) in a
> > > virtual test infrastructure on Virtualbox. There I run different VMs with
> > > different filesystems (ext4, xfs, zfs, bcachefs and btrfs).
> > > 
> > > I had a hardware problem on the underlying hardware where around 1000 4k
> > > blocks could not be read anymore. I migrated with ddrescure the whole disk
> > > which worked well.
> > > 
> > > Of course I was expecting some data loss in the VMs but wanted to get them
> > > in a consistent state.
> > > 
> > > The following file systems got very easy in a consistent state with the
> > > corresponding repair/scrub tools of the filesystems:
> > > - ext4
> > > - xfs
> > > - zfs
> > > 
> > > Unfortunately 2 filesystem can't get into a state, where the filesystem
> > > repair tools report "everything fine" (of course with some loss data, but
> > > that's fine):
> > > - btrfs
> > > - bcachefs
> > > 
> > > commands run with bcachefs (git version):
> > > git log -n1 | head -n1
> > > commit 1e058db4b603f8992b781b4654b48221dd04407a
> > > ./bcachefs version
> > > 1.12.0
> > > 
> > > But bcachefs never got into a consistent state, also with newer versions.
> > > Also check with older versions (1.7.0) run for a long time.
> > > 
> > > To reproduce the problem I created a new filesystem and copied some files
> > > there:
> > > mkfs.bcachefs -f /dev/sdb
> > > time cp -Rap /usr /mnt
> > > 
> > > Afterwards I created a (quick&dirty) script "corrupt_device.sh" to corrupt
> > > the device in the same manner as the original failure (1000 4k blocks will
> > > be randomly overwritten).
> > > Script: see below
> > > 
> > > ~/corrupt_device.sh
> > > ./bcachefs fsck -pf /dev/sdb
> > > ./bcachefs fsck -pfR /dev/sdb
> > > 
> > > Result: It can be reproduced, that bcachefs can't be brought into a
> > > consistent state even after several runs of the repair.
> > > 
> > > You can also try to reproduce it and create a testcase out of it.
> > > 
> > > Any ideas how to repair and what can be done to get it into a consistent
> > > state?
> > If you've got a filesystem you want data off of - send me a metadata
> > dump (join the IRC channel, send it via magic wormhole) and I'll debug.
> > 
> > We still haven't comprehensively torture tested all the repair paths
> > (which is probably the biggest reason it's still marked as
> > experimental); all the repair paths are there, but there's still bugs to
> > shake out.
> > 
> > Thanks for the test - I'll try to make use of it when I'm working in
> > that area again.
> 
> Did you find the time for using the test and fix the issues?

No, not yet... :)

> As bcachefs gets more stable I think we should focus on such
> "destroy&repair" test cases to get consistent again and get trust.

I agree, but still got user bug reports to work through :)

Yesterday we discovered a filesystem where io path options weren't being
correctly applied, and it's serious because the checksum option wasn't
being applied correctly - we found data that wasn't checksummed - so
right now I'm working on extending check_rebalance_work to check/repair
extents that weren't written with the correct options.

If you wanted to help out a bit and bump this up in the queue, have you
looked at ktest? If we could get your test wrapped in a ktest test,
it'll show up in the automated test dashboard and I'll get to it sooner.

(Plus we've already got tests for blowing away btree nodes in
single_device.ktest, maybe have a look at how those work and see if we
can cover the missing cases in a more structured way)

https://evilpiepirate.org/git/ktest.git/

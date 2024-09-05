Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 932CC2F44
	for <linux-bcachefs@vger.kernel.org>; Thu,  5 Sep 2024 04:29:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725510575; cv=none; b=OQMjbIkt/2xk2cgre1zJn06SXplf4Ggc7fXIyr1/PgYtI5XBUF3AIWCvtZsCp/jB5+QvbDcMz0T92oXfkuoWw6mFAPGjubzECv4hv0Hq901PkdfL+xa9BW27bKFNzDWfl9pU8XmNidY8JbN2x5ExoORuLsM9odhE+YuCU+Kf5AQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725510575; c=relaxed/simple;
	bh=HY9r8TLNRQbcgYLJcARe5fGG9eVMaaiiLWiW+9HzwrU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ctMi2tAvSo2nujhMhCwm8BAyRQeAFv9TGE1Z9q+c3lkqre3Ygxzt9tpCpzKRHkYz8GGZIPRJdAvPY/mvUMSqFqLoA31N2QrcS0vjtEt72u2GvCA8MGGX8oCRGDemMb3ZGQ1jEksoeWytvhyH5SuVf36AAa4MPU8DzamwtX+HabI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=lB+o4STI; arc=none smtp.client-ip=91.218.175.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="lB+o4STI"
Date: Thu, 5 Sep 2024 00:29:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1725510571;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=wXwXOGS5exQ+0KdoKiUUba4QLknrVZhhx1HlkjlZT60=;
	b=lB+o4STI5V9dwzcP1oMZSFWqcJECD7eV8YFbQWg+6R4uz1Q1pn34UYLKz13j5Alar8U94o
	Db6N2VR5nKc6k5S5rV5UVzTtysS+qE6tKMtHBGHRVeUNoi+fLxSkHS6oCSheCSOZxWpQnj
	S4jGf05lnpjZ2QZ4Fo/35ZY4cfeuy9Y=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Gerhard Wiesinger <lists@wiesinger.com>
Cc: linux-bcachefs@vger.kernel.org
Subject: Re: Corrupt bcachefs can't be transferred into a consistent state
Message-ID: <ppqn3gvkjjsbg4sprijlqbldkuetnaco5orl4wxapsydee65g5@3nwlodfwjwcx>
References: <aa613c37-153c-43e4-b68e-9d50744be7de@wiesinger.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aa613c37-153c-43e4-b68e-9d50744be7de@wiesinger.com>
X-Migadu-Flow: FLOW_OUT

On Sun, Sep 01, 2024 at 02:01:25PM GMT, Gerhard Wiesinger wrote:
> Hello,
> 
> I'm having some Fedora Linux VMs (actual versions, latest updates) in a
> virtual test infrastructure on Virtualbox. There I run different VMs with
> different filesystems (ext4, xfs, zfs, bcachefs and btrfs).
> 
> I had a hardware problem on the underlying hardware where around 1000 4k
> blocks could not be read anymore. I migrated with ddrescure the whole disk
> which worked well.
> 
> Of course I was expecting some data loss in the VMs but wanted to get them
> in a consistent state.
> 
> The following file systems got very easy in a consistent state with the
> corresponding repair/scrub tools of the filesystems:
> - ext4
> - xfs
> - zfs
> 
> Unfortunately 2 filesystem can't get into a state, where the filesystem
> repair tools report "everything fine" (of course with some loss data, but
> that's fine):
> - btrfs
> - bcachefs
> 
> commands run with bcachefs (git version):
> git log -n1 | head -n1
> commit 1e058db4b603f8992b781b4654b48221dd04407a
> ./bcachefs version
> 1.12.0
> 
> But bcachefs never got into a consistent state, also with newer versions.
> Also check with older versions (1.7.0) run for a long time.
> 
> To reproduce the problem I created a new filesystem and copied some files
> there:
> mkfs.bcachefs -f /dev/sdb
> time cp -Rap /usr /mnt
> 
> Afterwards I created a (quick&dirty) script "corrupt_device.sh" to corrupt
> the device in the same manner as the original failure (1000 4k blocks will
> be randomly overwritten).
> Script: see below
> 
> ~/corrupt_device.sh
> ./bcachefs fsck -pf /dev/sdb
> ./bcachefs fsck -pfR /dev/sdb
> 
> Result: It can be reproduced, that bcachefs can't be brought into a
> consistent state even after several runs of the repair.
> 
> You can also try to reproduce it and create a testcase out of it.
> 
> Any ideas how to repair and what can be done to get it into a consistent
> state?

If you've got a filesystem you want data off of - send me a metadata
dump (join the IRC channel, send it via magic wormhole) and I'll debug.

We still haven't comprehensively torture tested all the repair paths
(which is probably the biggest reason it's still marked as
experimental); all the repair paths are there, but there's still bugs to
shake out.

Thanks for the test - I'll try to make use of it when I'm working in
that area again.

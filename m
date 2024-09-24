Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF36713FFC
	for <linux-bcachefs@vger.kernel.org>; Tue, 24 Sep 2024 02:56:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727146567; cv=none; b=NB+DJZ8oEMmBy8r12r9VK8BsYnucN6+gXcvq+pkj0TmADYQf+QlLKMFFoq/hxnX9mKub7j7S7B8j6kGmMCtsRCXAwsXJvHlfAnC24sFUK76i05Y8QYs5UDMFLrKbZprIt+HTv6o3MpqXIO86EYeDmL1e4oxZO5hain6lnkwWcK4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727146567; c=relaxed/simple;
	bh=L8hUgKfg86tZvM0cve+PTBxrXPKqG2h8HYIh4A0Gs+s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LdNsKDbAMDYM9eNRFrDeVi/Sn/q+SEqz7DoyCUv6okmv0eYhtsgo0lNeFRiYtU0D7MWm/O+43Vupebt5ogAnAfIJ8P9s2Fzx1nN+Oo87yHxlFZNu6IEqEigwqNeuzU0z6fDK+EN0llSz0LffJbE1AcYRbNsD7eUGREw2M9/uUWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=AoPj7dor; arc=none smtp.client-ip=95.215.58.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="AoPj7dor"
Date: Mon, 23 Sep 2024 22:55:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1727146562;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ELo+ULv8YDEvPyxBHuOn8sAdlPAUaZpqZf+a7Q2vueE=;
	b=AoPj7dornC8/o9eZb5S075tvbhvsC44Q2ApWLUBGt6Nk9+tcqdNbk2JHs4uZlx0HBx6h0r
	kCdJuowTwGycnErv7LfGy4gSlK3jfOOxVFXARtijyH64D+hBjvI40oceYxoV4MRSF3BMpO
	E5aAQjpBSs/YU2uvOkkd7GwwYMUitWQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dave Chinner <david@fromorbit.com>, linux-bcachefs@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, Dave Chinner <dchinner@redhat.com>
Subject: Re: [GIT PULL] bcachefs changes for 6.12-rc1
Message-ID: <74sgzrvtnry4wganaatcmxdsfwauv6r33qggxo27yvricrzxvq@77knsf6cfftl>
References: <dtolpfivc4fvdfbqgmljygycyqfqoranpsjty4sle7ouydycez@aw7v34oibdhm>
 <CAHk-=whQTx4xmWp9nGiFofSC-T0U_zfZ9L8yt9mG5Qvx8w=_RQ@mail.gmail.com>
 <6vizzdoktqzzkyyvxqupr6jgzqcd4cclc24pujgx53irxtsy4h@lzevj646ccmg>
 <ZvIHUL+3iO3ZXtw7@dread.disaster.area>
 <CAHk-=whbD0zwn-0RMNdgAw-8wjVJFQh4o_hGqffazAiW7DwXSQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=whbD0zwn-0RMNdgAw-8wjVJFQh4o_hGqffazAiW7DwXSQ@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT

On Mon, Sep 23, 2024 at 07:26:31PM GMT, Linus Torvalds wrote:
> On Mon, 23 Sept 2024 at 17:27, Dave Chinner <david@fromorbit.com> wrote:
> >
> > However, the problematic workload is cold cache operations where
> > the dentry cache repeatedly misses. This places all the operational
> > concurrency directly on the inode hash as new inodes are inserted
> > into the hash. Add memory reclaim and that adds contention as it
> > removes inodes from the hash on eviction.
> 
> Yeah, and then we spend all the time just adding the inodes to the
> hashes, and probably fairly seldom use them. Oh well.
> 
> And I had missed the issue with PREEMPT_RT and the fact that right now
> the inode hash lock is outside the inode lock, which is problematic.
> 
> So it's all a bit nasty.
> 
> But I also assume most of the bad issues end up mainly showing up on
> just fairly synthetic benchmarks with ramdisks, because even with a
> good SSD I suspect the IO for the cold cache would still dominate?

Not for bcachefs, because filling into the vfs inode cache doesn't
require a disk read - they're cached in the inodes btree and much
smaller there. We use a varint encoding so they're typically 50-100
bytes, last I checked.

Compare to ~1k, plus or minus, in the vfs inode cache.

Thomas Bertshinger has been working on applications at LANL where
avoiding pulling into the vfs inode cache seems to make a significant
difference (file indexing in his case) - it turns out there's an xattr
syscall that's missing, which I believe he'll be submitting a patch for.

But stat/statx always pulls into the vfs inode cache, and that's likely
worth fixing.

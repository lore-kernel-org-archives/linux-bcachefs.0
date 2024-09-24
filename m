Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7724E1BC20
	for <linux-bcachefs@vger.kernel.org>; Tue, 24 Sep 2024 03:48:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727149682; cv=none; b=Edy4tp+SiCUQlq4IRedigSCWpNLmQ9kfaKS+9M3h2HrqkN6eJj4uTvHpYsbhWrlgDALN/rLE1HfeoFFYvao6Rp0gzH8WJ6mVaKDPChssogXyMccdMzf49lRxVRTiWgNyKVXtH5Zn+bQBOiw5+55JXwu74mbgWA4mXjThgS16dZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727149682; c=relaxed/simple;
	bh=E5/vfZxk3cSIL1wGQpQXsh0A/6Ct1PDsv88UYf+7p6w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=X6SGq8/OsHLzwVS9QKo8uhp1jtje7ifHVR+WUmWVe4p9ZOv2ZN6aXIa/d5MzDM0iK/r8+eCJTw+883DpU9FSznbR8VZjYagGz/6jD4jkva7NPpcZvdOxTPUMgO2s9ahq1RrQ1egTYoLI4EGZY85vrysix84nKJggOkjHWi7pyA4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=FLK2Hn7o; arc=none smtp.client-ip=95.215.58.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="FLK2Hn7o"
Date: Mon, 23 Sep 2024 23:47:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1727149678;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=pjYzAn+pXV4nSZ6oPS7I6J8AjXnkRAWWTRxkNNGEUPg=;
	b=FLK2Hn7oCBfr4wOWw6uGKIiRC6lPQGmytK6/z5NBlDbegKU5w10th5v7JHInvjT7OYJrJj
	KYbm2k0VBV5HmzWJk4NEflmuasqczoIcTjHENCprhNh5b7rZROIzfuIe1KfBWcEhj10Cpx
	92T/zz60ouq9Te8ebmsBA3EoITy8QpU=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Dave Chinner <david@fromorbit.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, 
	linux-bcachefs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Dave Chinner <dchinner@redhat.com>
Subject: Re: [GIT PULL] bcachefs changes for 6.12-rc1
Message-ID: <dia6l34faugmuwmgpyvpeeppqjwmv2qhhvu57nrerc34qknwlo@ltwkoy7pstrm>
References: <dtolpfivc4fvdfbqgmljygycyqfqoranpsjty4sle7ouydycez@aw7v34oibdhm>
 <CAHk-=whQTx4xmWp9nGiFofSC-T0U_zfZ9L8yt9mG5Qvx8w=_RQ@mail.gmail.com>
 <6vizzdoktqzzkyyvxqupr6jgzqcd4cclc24pujgx53irxtsy4h@lzevj646ccmg>
 <ZvIHUL+3iO3ZXtw7@dread.disaster.area>
 <CAHk-=whbD0zwn-0RMNdgAw-8wjVJFQh4o_hGqffazAiW7DwXSQ@mail.gmail.com>
 <74sgzrvtnry4wganaatcmxdsfwauv6r33qggxo27yvricrzxvq@77knsf6cfftl>
 <ZvIzNlIPX4Dt8t6L@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZvIzNlIPX4Dt8t6L@dread.disaster.area>
X-Migadu-Flow: FLOW_OUT

On Tue, Sep 24, 2024 at 01:34:14PM GMT, Dave Chinner wrote:
> On Mon, Sep 23, 2024 at 10:55:57PM -0400, Kent Overstreet wrote:
> > But stat/statx always pulls into the vfs inode cache, and that's likely
> > worth fixing.
> 
> No, let's not even consider going there.
> 
> Unlike most people, old time XFS developers have direct experience
> with the problems that "uncached" inode access for stat purposes.
> 
> XFS has had the bulkstat API for a long, long time (i.e. since 1998
> on Irix). When it was first implemented on Irix, it was VFS cache
> coherent. But in the early 2000s, that caused problems with HSMs
> needing to scan billions inodes indexing petabytes of stored data
> with certain SLA guarantees (i.e. needing to scan at least a million
> inodes a second).  The CPU overhead of cache instantiation and
> teardown was too great to meet those performance targets on 500MHz
> MIPS CPUs.
> 
> So we converted bulkstat to run directly out of the XFS buffer cache
> (i.e. uncached from the perspective of the VFS). This reduced the
> CPU over per-inode substantially, allowing bulkstat rates to
> increase by a factor of 10. However, it introduced all sorts of
> coherency problems between cached inode state vs what was stored in
> the buffer cache. It was basically O_DIRECT for stat() and, as you'd
> expect from that description, the coherency problems were horrible.
> Detecting iallocated-but-not-yet-updated and
> unlinked-but-not-yet-freed inodes were particularly consistent
> sources of issues.
> 
> The only way to fix these coherency problems was to check the inode
> cache for a resident inode first, which basically defeated the
> entire purpose of bypassing the VFS cache in the first place.

Eh? Of course it'd have to be coherent, but just checking if an inode is
present in the VFS cache is what, 1-2 cache misses? Depending on hash
table fill factor...

That's going to show up, but I have a hard time seeing that "defeating
the entire purpose" of bypassing the VFS cache, as you say.

> Don't hack around VFS scalability issues if it can be avoided.

Well, maybe if your dlock list patches make it in - I still see crazy
lock contention there...

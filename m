Received: from out-175.mta0.migadu.com (out-175.mta0.migadu.com [91.218.175.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD35E1CA89
	for <linux-bcachefs@vger.kernel.org>; Tue, 16 Jan 2024 17:07:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705424829; cv=none; b=X5Y9rLgvZXq1b/YsjLT27rXCLa2nmbcAoqd+X2uygupF9RbC4Pd0s5TepXOj8cPjF1tDPPV8micYVfThCaLv6x+jG8CPIzgU3mu2jwy3M1XMnVQRbYSXPokAKRLD5iN3VaLiLdK78e5MF01bmv/bCyBa1OvEHU+pIi5zFwQy3uk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705424829; c=relaxed/simple;
	bh=hXEzc5dFC/qIa8y8t7HYvYxSv5lMxT9yaa0dVgR3uhU=;
	h=Date:DKIM-Signature:X-Report-Abuse:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Migadu-Flow; b=nK5vLt2Wt/5VhI2dcTyI4yZ3/ZnTP6SiWFC/CIJEgOHp9Bf25K7nZ34jZ6s1bIYKB4dy3KGA3dPfjlSKlnMsMNp3kNq4Ug7dPl91OxbbEEicb7Q7vReHILJc6TCEVkPKQLEmvq5dg8O26cIOIOKwjqctVD+8gbz2hFRXBY7mdyw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=UdW6eQNm
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="UdW6eQNm"
Date: Tue, 16 Jan 2024 12:07:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1705424824;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ovamPvw4s8X658nP+4slh6OfwtndzLZL33SXSJd6jfE=;
	b=UdW6eQNmrFpXid8ikc4tCGzpETmh4SfSRo68+tpzUPb6AmxArOVCRQsY++SM2gZL/9nXdv
	2IQZyz05ZdCOyPzgD3ihA+3HoxvzSzDWJuUGybuLQE6fHXsQUeIizJNA2Q3BekAIXZaGyw
	vMpC2UXwX61BaxN7MNMRny3m7c8sGAs=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Brian Foster <bfoster@redhat.com>
Cc: Su Yue <glass.su@suse.com>, fstests@vger.kernel.org, 
	linux-bcachefs@vger.kernel.org, l@damenly.org
Subject: Re: [PATCH] fstests: introduce MKFS_BCACHEFS_PROG for bcachefs
Message-ID: <eghzohrxjmbvrokpdnfct7easjgm7szzfvm4qdqoy4zi3lcl5z@l6d4r64ksukf>
References: <20240114044120.140111-1-glass.su@suse.com>
 <ZaaGkadipvNY02HM@bfoster>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZaaGkadipvNY02HM@bfoster>
X-Migadu-Flow: FLOW_OUT

On Tue, Jan 16, 2024 at 08:37:21AM -0500, Brian Foster wrote:
> On Sun, Jan 14, 2024 at 12:41:20PM +0800, Su Yue wrote:
> > mkfs.bcachefs supports force overwrite when option '-f' is given:
> > $ mkfs.bcachefs --help | grep force
> >   -f, --force
> > After this commit, MKFS_BCACHEFS_PROG will contains ' -f' so
> > we don't have to add '-f' to $MKFS_OPTIONS manually.
> > 
> > It also fixes generic/466 which unsets MKFS_OPTIONS causing
> > that test hangs in mfks.bcachefs waiting for confirmation of
> > the force overwrite.
> > 
> 
> This seems mostly reasonable to me, but I'm kind of wondering why I
> haven't had to add -f to my MKFS_OPTIONS for bcachefs. Is there
> something unique to the test environment that affects this? I.e., I
> don't see any issue with generic/466 on a recent Fedora, even if I
> pre-format the scratch dev with XFS.

I think there's still multiple screwy things going on with blkid probing
and superblock wiping - I've been noticing that there's a bunch of ktest
tests that don't specify -f and work fine in the CI, but that fail when
I loop them locally.

It appears wipefs only zeroes out the magic number on our first
superblock - but it leaves the layout intact before the first
superblock, so we're still able to find our backup superblocks.

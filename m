Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F970481C7
	for <linux-bcachefs@vger.kernel.org>; Mon,  5 Feb 2024 19:15:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707160545; cv=none; b=hgWZ5C3GvDisjETquiNm36jFn6OxOHBmzeWpXnwb2MIBpCQsMNq/dFiz6EnbwWGpz4JK7uWcGn4Dj1xvR55RSK9QlR9LDpBrCK9ec07A39HmfAqCQE1lcJGYMz9CHFvS6TFpGM8Do2UNY927nCty15scP4X0BZVzPDyiHhQfNNc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707160545; c=relaxed/simple;
	bh=ST25p+sVZTvhGPFzPYOWryDi1C+zxQsPXngteX77vHQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KxGF3dEfXZRuKqlAl8bsohsQmtSVtx4GBjHol+W1QXN71nTeAKP+3dk5p91E7S/O99snhtMqc6AmhyO2ImzbnikIgpL3+sjvRcpQPR16OyEi2Uuwfa94AoFi4zV0ICUNNexeDvzuQb37WKkpOJHSW3V6YJoEI/b8Ld4uArh6MqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=s6GSkg1d; arc=none smtp.client-ip=91.218.175.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="s6GSkg1d"
Date: Mon, 5 Feb 2024 14:15:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1707160540;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=NV1cAy9I+gAwMD1jAYb2ngrg1ndVYX21XQFvVIg+Ot4=;
	b=s6GSkg1de0mk71tZARDNB0qpIYmw8hyzx3+yAhjtjz8L3DF46XW2lIQFmXBoWD3qjGGl9t
	aS06cDJ7+z3B2YHi8Y010EuZ3mquTW2JJb+PzqaG4esNQYlPF8IU2nOUC2LIId77najWb+
	vFsh9BhCA37CCH+/LhfOOMphw89dsi4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Brian Foster <bfoster@redhat.com>
Cc: linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH] bcachefs: fix iov_iter count underflow on sub-block dio
 read
Message-ID: <4fdyk3to57izolmljjiehnn5kt5dxckhh2oodo7vk6gssgqbsb@6gsjfytnv2xy>
References: <20240205154814.910664-1-bfoster@redhat.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240205154814.910664-1-bfoster@redhat.com>
X-Migadu-Flow: FLOW_OUT

On Mon, Feb 05, 2024 at 10:48:14AM -0500, Brian Foster wrote:
> bch2_direct_IO_read() checks the request offset and size for sector
> alignment and then falls through to a couple calculations to shrink
> the size of the request based on the inode size. The problem is that
> these checks round up to the fs block size, which runs the risk of
> underflowing iter->count if the block size happens to be large
> enough. This is triggered by fstest generic/361 with a 4k block
> size, which subsequently leads to a crash.
> 
> After some discussion, the original purpose of the shorten logic in this
> path is not totally clear. It appears to be intended as an optimization
> of limited value, so simplify things and avoid the underflow problem by
> removing it.

Thinking about this a bit more...

All that we're avoiding with the shorten is zeroing out the rest of the
read, which will happen in bch2_read_extent(); we won't be issuing any
IO, since that would require real data extents above i_size, which is of
course not allowed.

But zeroing out the rest of the read is actual work that's being
avoided, since if we return a short read (which is what we're doing
here) it's undefined what happens to the rest of the buffer.

So... maybe we should keep it, for the crazy but inevitable application
that uses a 1MB read buffer for everything, including O_DIRECT reads to
4k files?

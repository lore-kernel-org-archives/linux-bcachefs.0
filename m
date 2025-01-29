Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FD0D199EBB
	for <linux-bcachefs@vger.kernel.org>; Wed, 29 Jan 2025 20:28:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738182523; cv=none; b=YwXKZAZjOturjg4mWAJbjWCZ3g0XACYhKLg5VDX2QoBwV6QX2GSSnsEo9S9UaJ+inqVfrso63A+f/ps6r9UyvG246+EeUCOr/dj+uJaZVQ/XyQNg9mb8EeUZxmabljLnl5KBfpx7eTlrBEb+RIBvU6XD9j1zGczrZ1pWuM9bWHg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738182523; c=relaxed/simple;
	bh=PFH0MDhc/6+z95tGzAmT5X0DEUy3PgdQThFjjKfQABM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qRAEe40evuznlz2ezPYlcdT842QP0Mkhds0VAnxLvhz3Gq+1GsMXPF+AX7HijrAc0TJIG35wwjLGMuOPD8y6vct7LbuAQ0CJSRh8aMQ5wL9TME+/5uXunmzOwCgDcw4OZfJcFmsIT2irZQY6/xwTFeedpeWdcsS2Fy0FNndz8Ig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=bPtPn6cG; arc=none smtp.client-ip=91.218.175.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="bPtPn6cG"
Date: Wed, 29 Jan 2025 15:28:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1738182514;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nzjgquglzwXUzEPcqk4sNGaEUyO0xQ2neoaOKkJCij8=;
	b=bPtPn6cGI79Z8Z7oOrhzRNpPm+UKNRKDmtAS+k9WtEatE6Gp//qp30CN9J9rtF4VHHN49U
	zfy898VdQWdwTqpNyhQWlUyHpGe5MMnHjhYJfhJ2POcIpsTW1sttvFt/W0ODJ/DmKIgDJG
	jyCgXesCK9HxB+NtUS1Vq4E4+F46/7g=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Andreas Gruenbacher <agruenba@redhat.com>
Cc: Shuah Khan <shuah@kernel.org>, linux-bcachefs@vger.kernel.org, 
	linux-kselftest@vger.kernel.org
Subject: Re: [PATCH 11/21] bcachefs: improve the eytzinger0_find_le tests
Message-ID: <rddasfmbw3ul2iezec7rgit2vxnv4p53uvoydck4b5jxuo44kq@7qlk5cru6w7r>
References: <20250128163859.1883260-1-agruenba@redhat.com>
 <20250128163859.1883260-12-agruenba@redhat.com>
 <ajfehauvtid4d7pqy7o3uhe6p7buohwe542wqddkwpdq62lr4g@6cgcfpzcyag3>
 <CAHc6FU6Yzk1Si37nRji-5uDZF9uaYo=G5tbtuS_5FiW6BDVTAg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAHc6FU6Yzk1Si37nRji-5uDZF9uaYo=G5tbtuS_5FiW6BDVTAg@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT

On Wed, Jan 29, 2025 at 07:21:49PM +0100, Andreas Gruenbacher wrote:
> On Wed, Jan 29, 2025 at 7:04 PM Kent Overstreet
> <kent.overstreet@linux.dev> wrote:
> > On Tue, Jan 28, 2025 at 05:38:48PM +0100, Andreas Gruenbacher wrote:
> > > Rename eytzinger0_find_test_val() to eytzinger0_find_test_le() and add a
> > > new eytzinger0_find_test_val() wrapper that calls it.
> > >
> > > We have already established that the array is sorted in eytzinger order,
> > > so we can use the eytzinger iterator functions and check the boundary
> > > conditions to verify the result of eytzinger0_find_le().
> > >
> > > Only scan the entire array if we get an incorrect result.  When we need
> > > to scan, use eytzinger0_for_each_prev() so that we'll stop at the
> > > highest matching element in the array in case there are duplicates;
> > > going through the array linearly wouldn't give us that.
> >
> > For test code, wouldn't it be simpler to iterate over the test array,
> > testing with every element as a search value? There's enough corner
> > cases in lookup that I think it'd be worthwhile (and probably add some
> > extra test values, e.g. first/last elements +1/-1).
> 
> If you expect to get the same index back, that won't work when there
> are duplicates.

No, but we wouldn't expect to get the same index back if we're testing
every combination of elements (+0, -1, +1) x (le, ge, gt) - and it
sounds like perhaps we should, if you've been finding bugs. Thoughts?

I think the test code would have to do short linear searches from the
test element, and then verify the search functions against that.

Have you spotted any issues with searching over arrays with duplicate
elements? 

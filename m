Received: from out-171.mta1.migadu.com (out-171.mta1.migadu.com [95.215.58.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6F0A1E878
	for <linux-bcachefs@vger.kernel.org>; Sun, 21 Jan 2024 17:41:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705858922; cv=none; b=PRaYxXu29FMG32oKjHgJ/QV0gJCvwb2jsyesNRnv7SpTpXUylUjWfKiWIR6/ZIgzdFYmfL3lu3JTJE03zqjB0BaFQhGX8dZ7HTYDFO2/o8BXiuNLLRy7+B1eBST3YB+UbQgc8T5GKze4CgGtIv7wUBGsU5wkETqvI1Y2R+1vEhY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705858922; c=relaxed/simple;
	bh=N2g0NHGKWWZmb/qlzQ163FWOfAKGzGlUYORWKPpiytI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OFXAkWwHEnN7TsOKITSkXqM2hmiZFyFncezmWFKM57QHYRzVCCJtgEQHS61LTUEsTMT0fDOce+LOQA1ZlDII+8I8EnzOlKy4TIrbocqbTg8TDKF//s0YUygID5jPboQj7u+FmBrzyy8CV1NYyHX1lGQT81kqlkqPCQ+BHhAC+RE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=SAnE/LP1; arc=none smtp.client-ip=95.215.58.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="SAnE/LP1"
Date: Sun, 21 Jan 2024 12:41:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1705858918;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=zEZ5U22ZGrF+dm4NBxH8Qr8fPO+NuB0IQfzMnXwEl2I=;
	b=SAnE/LP1jwOwzXFkLVsJ3sKoqSTNCqYfTEYCKAmoFk1FmHnZ26Iz4mV15j37lFPDee+j3n
	sgRxhokF3swjiFCXQMxWTxwVZP3QhEUF+rp94gIAEpt0o4e6y/XV2kDywFSZTWBKXPT5wK
	JqXTf9UqF55p7CtlVOD/ol70LJ9tJIM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Kuan-Wei Chiu <visitorckw@gmail.com>
Cc: colyli@suse.de, bfoster@redhat.com, jserv@ccns.ncku.edu.tw, 
	linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org, linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH 0/5] Optimize number of comparisons for heap/heapsort
 implementaion
Message-ID: <ioyfizrzq7w7mjrqcadtzsfgpuntowtjdw5pgn4qhvsdp4mqqg@nrlek5vmisbu>
References: <20240121153649.2733274-1-visitorckw@gmail.com>
 <nl6kvjxg4gia5pbfb4jibxusvavmlwumrvy3swfs33ciub32wt@2kmeqnqycxxh>
 <Za1Ml/ZUBXdYXOIt@visitorckw-System-Product-Name>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Za1Ml/ZUBXdYXOIt@visitorckw-System-Product-Name>
X-Migadu-Flow: FLOW_OUT

On Mon, Jan 22, 2024 at 12:55:51AM +0800, Kuan-Wei Chiu wrote:
> On Sun, Jan 21, 2024 at 11:21:06AM -0500, Kent Overstreet wrote:
> > On Sun, Jan 21, 2024 at 11:36:44PM +0800, Kuan-Wei Chiu wrote:
> > > Hello,
> > > 
> > > The existing implementations of heap/heapsort follow the conventional
> > > textbook approach, where each heapify operation requires approximately
> > > 2*log2(n) comparisons. In this series, I introduce a bottom-up variant
> > > that reduces the number of comparisons during heapify operations to
> > > approximately log2(n), while maintaining the same number of swap
> > > operations.
> > > 
> > > Thanks,
> > > Kuan-Wei
> > > 
> > > Kuan-Wei Chiu (5):
> > >   bcachefs: Optimize eytzinger0_sort() using bottom-up heapsort
> > >   bcachefs: Introduce parent function for sort_cmp_size()
> > >   bcachefs: Optimize sort_cmp_size() using bottom-up heapsort
> > >   bcachefs: Optimize number of comparisons in heap_sift_down
> > >   bcache: Optimize number of comparisons in heap_sift
> > > 
> > >  drivers/md/bcache/util.h |  23 +++++----
> > >  fs/bcachefs/util.c       | 109 ++++++++++++++++++++++++++-------------
> > >  fs/bcachefs/util.h       |  23 +++++----
> > >  3 files changed, 98 insertions(+), 57 deletions(-)
> > 
> > Good stuff
> > 
> > While we're looking at this code, we should be doing some cleanup too -
> > there's no reason for the heap code to be duplicated in bcache and
> > bcachefs anymore, and it'd also be nice to get fs/bcachefs/eytzinger.h
> > moved to include/linux and bcache converted to use it.
> > 
> > I also would not be surprised if there's another heap implementation in
> > include/linux; we'll want to check for that and if there is decide which
> > is worth keeping.
> >
> Yes, we have 'min_heap.h' in include/linux.

So that has the advantage of more readable code - functions instead of
macros - whereas my version has the type safe interface.

We could combine the two approaches, and put a type-safe interface on
top of the min_heap.h code with some small macro wrappers - see
generic-radix-tree.h for an example of how that's done.

min_heap.h has only one user though? I don't think I can quite believe
that's the only other code in the kernel using a heap, there must be
more open coded out there...

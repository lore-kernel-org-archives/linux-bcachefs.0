Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CD6A1632F1
	for <linux-bcachefs@vger.kernel.org>; Sun, 24 Nov 2024 23:44:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732491865; cv=none; b=fEo6NWylmPVAAPUyB3r0KNq8pZk/SKisy2JvksDwe/xEvLVL43eIB7y+MvFAINY2k4vDcFVhOMgvA61mqF9mqLs4zg974e5PJv+k7LxuKrJbSwYcWdBBOerl0qh9ZqVHN2wOXWBqbktqK4anWmY7KVVa9aul5bdO9ffq1zWT1SI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732491865; c=relaxed/simple;
	bh=WCknJX2JdpYRl8d7EeQhas0k/LDWivaV+k9Bjj9Zkbc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JdaZ57cCZHJbBHA03qnCDekpzZX6HLnwMBwk0o4BnSTkf3HHdqG7IEjaIp3qUl4Y6lOnhH55eqbSfEYPAA51zIlH/56XLV6d/NExhgF4qXkSCLnxJkaM1vawyzv38rkzXJGHGMRcNbp7DwfP66GkuhBnzL8kOCcG4mqUmydamCs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ZkeQJ5eL; arc=none smtp.client-ip=91.218.175.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ZkeQJ5eL"
Date: Sun, 24 Nov 2024 18:44:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1732491859;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=I2kjSbDMLuRM1fwulfXewhsYNuZ3SCPFmW+NjV+0TnE=;
	b=ZkeQJ5eLye4RsgtkQk/gD1V3f0jU8RbH+Z4+c9KDTb0bxuoZRNgfpqxXuMtnRla3jC/xVa
	UYuC0WHJ6mY/0VvF/4Q8vdaSL4F9TAO9dXord8qH0Y8bqasUE8Ym6+7DFrkFf8o/XAHHug
	M4EydvyWwVhZE5V5hgloNjP8nD1nu1w=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Andreas Gruenbacher <agruenba@redhat.com>
Cc: linux-bcachefs@vger.kernel.org, 
	Andreas Gruenbacher <andreas.gruenbacher@gmail.com>
Subject: Re: [PATCH] bcachefs: eytzinger1_{next,prev} cleanup
Message-ID: <b3kgjadx5fskmb26jfttbwo7rmb7pjfsqwycu67g5idqrjos7o@ikp7wda7rjzg>
References: <20241124131147.1057922-1-agruenba@redhat.com>
 <atjh756n4ykf6syi3uxzb6mdxsfdbpfya5mx77bfcxgzl6proj@mrqvwcmdhd62>
 <CAHc6FU78Lphf2CkfK_kBKDegqm0af7NzTh0V1myc_+mQUXYjFg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAHc6FU78Lphf2CkfK_kBKDegqm0af7NzTh0V1myc_+mQUXYjFg@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT

On Mon, Nov 25, 2024 at 12:33:10AM +0100, Andreas Gruenbacher wrote:
> On Sun, Nov 24, 2024 at 8:24 PM Kent Overstreet
> <kent.overstreet@linux.dev> wrote:
> > On Sun, Nov 24, 2024 at 02:11:47PM +0100, Andreas Gruenbacher wrote:
> > > From: Andreas Gruenbacher <andreas.gruenbacher@gmail.com>
> > >
> > > In this place in the code, eytzinger1_next() is trying to move the
> > > lowest child on the left, which is equivalent to doubling i until the
> > > next doubling would cause it to be greater than size.  This is
> > > implemented by shifting i to the left so that the most significant bits
> > > of both numbers align, and then shifting i right by one if it is greater
> > > than size.
> > >
> > > The code accidentally computes the most significant bit of (size + 1)
> > > instead of size.  This happens to be harmless because in that case, the
> > > right shifting will compensate, but it is confusing and unnecessary.
> > >
> > > Likewise, eytzinger1_prev() is trying to move the lowest child on the
> > > right.  The same applies here.
> > >
> > > Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
> >
> > Looks correct. There's eytzinger tests in fs/bcachefs/util.c, could you
> > run those?
> 
> Hmm, this actually breaks the following tests in util.c:
> 
> BUG_ON(eytzinger1_prev(0, size) != eytzinger1_last(size));
> BUG_ON(eytzinger0_prev(-1, size) != eytzinger0_last(size));
> 
> The inverse tests are fine:
> 
> BUG_ON(eytzinger1_next(0, size) != eytzinger1_first(size));
> BUG_ON(eytzinger0_next(-1, size) != eytzinger0_first(size));
> 
> And so are all the other tests.
> 
> Are those identities actually relevant, or are they just a
> peculiarity? Do they justify an additional addition in
> eytzinger1_prev()?

I think they can be considered a peculiarity we can drop, since 0 isn't
a valid element for eytzinger1, and the same for -1 and eytzinger0.

> Note that these tests rely on the behavior of __fls(0), which is
> undefined. On x86_64, __fls(0) returns (long unsigned int)-1.

That's another point in favor of dropping them.

We'll need to be careful with that and do some code auditing or add new
debug asserts, since there are other identities we rely on (e.g. for
eytzinger_for_each() and likely elsewhere).

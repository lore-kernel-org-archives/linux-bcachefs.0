Received: from out-172.mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25A4D1DFD1
	for <linux-bcachefs@vger.kernel.org>; Sun, 20 Oct 2024 21:42:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729460577; cv=none; b=alIioz+99Qj2mdrVDykwRtRdvsuPf0wZS4yBU4roHjvK3r+Tlf775XEwQes3uM4uAk1n8ORqatlrzfvZilvV9AaM2HVY1/WFjg4/1HJbe4ACIOESfXPEAKuyWA6IQpLqdpNtUafqngpbyk48nChQerrt3qdnbUUdWnlJ4jVkllg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729460577; c=relaxed/simple;
	bh=000c9KuRjQpoZGebJASP9IyygbdA6SLW3CjdoH6+9b8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ip8c2KmF6nyIXQyWAPYkQzOYYXaThoX4iwBQS51HiCI3Q3X2iKb/9O+WZNZRHj0EzqgZVJmVtAuOt1W2LmK6SQbHCEBgf6N0eVWE84z0V0A9lfjkRzNIWUZb5m2n96sbKPxemroPy5NNkW5LBKQS9ll3kPOJjaeQYwkkVuuMtTM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=A5JRIwiw; arc=none smtp.client-ip=95.215.58.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="A5JRIwiw"
Date: Sun, 20 Oct 2024 17:42:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1729460573;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=apCHZfjaBtnc+wg5aPyeuh9Kwu3Al3XrgmEHy4xP33k=;
	b=A5JRIwiwqDIs68J2QfAUBc4Skj9S8/3orqYmsCdj8xR/HgF5W7e+uwntFs3Ay2uGk0y9pY
	uQsn71CaBFwje0NGdCPBqmaojzKi4hOfhZfztY87/pcLqbil9MkB9bM3ZN4rQc9M62mOx0
	QJ8d84i9R42RbahLBevS2+Zmua1dYBA=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	linux-bcachefs@vger.kernel.org, linux-mm@kvack.org, Vlastimil Babka <vbabka@suse.cz>, 
	Andrew Morton <akpm@linux-foundation.org>, Uladzislau Rezki <urezki@gmail.com>, 
	Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] mm: Drop INT_MAX limit from kvmalloc()
Message-ID: <otusvo7jpo3phjmutdcrjsuceecieoxihqssauvnnjqzfcqglj@n5jsfwx5xwdj>
References: <CAHk-=wi=PrbZnwnvhKEF6UUQNCZdNsUbr+hk-jOWGr-q4Mmz=Q@mail.gmail.com>
 <m46mlvv57oypstekojhkdwpts6mi4r63l4kugs4lpry3d2r7dq@kbmied6nzsc3>
 <CAHk-=wg8iZWDbX_MAujGtqHJYQneKBwDJnVAY94siNr1gLmtaA@mail.gmail.com>
 <CAHk-=wiW_QZ9VS3Ho2Ff8ZDp-T6SomDFrVPWG3abs45LMZpxZQ@mail.gmail.com>
 <6eo3gekf6twbnzhpsi2emz2s6sgtof6iba2rvbor7himmejoq5@qbfwtpbpvqoe>
 <CAHk-=wga3FXReWVhU2eid8+sXhBF1QgP1iMJu1jnSX6fapoyXQ@mail.gmail.com>
 <ikaf72w2oap3crjrybbd5jp267slnb7dygz4m62dfw3edu2ppj@f7dv2qdx3yga>
 <CAHk-=wggLED-UmxS0gXrtOXBVWexCkyudYCr5zXNh8p5PB9bng@mail.gmail.com>
 <zsx7jruj2lefbippol3zgagkw3sk33pgli476y2rumq3k25xkm@rt6ady5gnkrv>
 <CAHk-=wh5o2ZEk=H_fy=1nZzUxTR8djjDhPp7yV7_5YCA8xQUXw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wh5o2ZEk=H_fy=1nZzUxTR8djjDhPp7yV7_5YCA8xQUXw@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT

On Sun, Oct 20, 2024 at 02:30:43PM -0700, Linus Torvalds wrote:
> On Sun, 20 Oct 2024 at 14:29, Kent Overstreet <kent.overstreet@linux.dev> wrote:
> >
> > That's the same as limiting the amount of dirty metadata.
> 
> Exactly.
> 
> We limit dirty data for a reason. That was what I said, and that was my point.
> 
> Excessive dirty data is a huge latency concern. It's a latency concern
> not just for journal replay, it's a latency concern for anybody who
> then does a "sync" or whatever.

And my counterpoint is that if you've got a huge filesystem, limiting
dirty metadata means that you force it to be written out as a whole
bunch of random tiny writes, instead of allowing them to be batched up.
That's horrible for overall throughput.

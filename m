Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60ED12F43
	for <linux-bcachefs@vger.kernel.org>; Sun, 20 Oct 2024 20:09:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729454943; cv=none; b=NB7fdJGJqpOCe0JIk0A1FMJTyvGBXxktxAWaoUmlpcjZkYGboyHxEGWDlj/xJq/Vro6KdrrJDUbAFWyqiPyDQK5JHK1ctqpdGPMiF40S8j4XwgfMRQQMHNldKzVnKh0z8PmtLuOmmnbA1JB82abdOsLGrwecITnZO8bDUDGrkKk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729454943; c=relaxed/simple;
	bh=E4qLf60PwMnsov7YEUpSwcAb7DCscfMc31eDcJevKX4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YLPz9obgfPVQtWYvZshhEtw8gKV4BYjJqA7y6VE0RljO+gXyExHW+RzTvXgjVo+6jjGGf9x39ayCnnZrWCaU3LqgzCDKyOLCEKuQpQel2zhmAqTvfHBJR5WBGL6e+hEBJ2jvd5FWRvm56/Z1u+xNMU8cyFBuhkYEYZDTVnL3YJ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=YsiqSh4p; arc=none smtp.client-ip=91.218.175.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="YsiqSh4p"
Date: Sun, 20 Oct 2024 16:08:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1729454938;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=YLBMovQKhEK4NKL1ZpIk8uqIHLznemyS3ZLRNZ/M+X8=;
	b=YsiqSh4p2hTOFar5pwm4uGHpLfWG2XdU/iTus+KWBZl2xvR4taFP9rInNOYDtxlOTkQz+a
	8faDi2FPrE0uSKhuj9THPgeEKPH69XWcotmI1pxyWO+UqLhPfZ2bnJzIw8oPJRBPtFv5oI
	hY4m/ou0X61wGQ3vkIzRguNjEPgJiAU=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, linux-bcachefs@vger.kernel.org, linux-mm@kvack.org, 
	Andrew Morton <akpm@linux-foundation.org>, Uladzislau Rezki <urezki@gmail.com>, 
	Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] mm: Drop INT_MAX limit from kvmalloc()
Message-ID: <ocptjlg2m7djlgqymlcoo5d6s5smrjncy4xjxanhr4kk6fg55q@4255xpx24dgf>
References: <20241019210037.146825-1-kent.overstreet@linux.dev>
 <90bc0794-4cab-415f-a442-4af85a32eed8@lucifer.local>
 <ucbcmk4kr7tbvj6uqnjke5662kerawbr4ghtlbw4zim7mdm3fg@vjawfne5rdkp>
 <ebe58a08-2371-403c-a0d7-6280160b6848@lucifer.local>
 <zfr4sh3wtzi4viladlgwyon6voqhcj5fe3fv2nc3hqyyxdw5wd@onyj3r2m3usz>
 <CAHk-=wi=PrbZnwnvhKEF6UUQNCZdNsUbr+hk-jOWGr-q4Mmz=Q@mail.gmail.com>
 <m46mlvv57oypstekojhkdwpts6mi4r63l4kugs4lpry3d2r7dq@kbmied6nzsc3>
 <dccb8ec3-2563-4df7-a52b-0829b9391e43@suse.cz>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dccb8ec3-2563-4df7-a52b-0829b9391e43@suse.cz>
X-Migadu-Flow: FLOW_OUT

On Sun, Oct 20, 2024 at 09:53:06PM +0200, Vlastimil Babka wrote:
> On 10/20/24 20:53, Kent Overstreet wrote:
> > On Sun, Oct 20, 2024 at 11:46:11AM -0700, Linus Torvalds wrote:
> >> On Sun, 20 Oct 2024 at 10:04, Kent Overstreet <kent.overstreet@linux.dev> wrote:
> >> >
> >> > But given that vmalloc() already supports > INT_MAX requests, and memory
> >> > sizes keep growing so 2GB is getting pretty small - I think it's time,
> >> > this is going to come up in other places sooner or later.
> >> 
> >> No.
> >> 
> >> If you need 2GB+ memory for filesystem operations, you fix your code.
> > 
> > This is for journal replay, where we've got a big array of keys and we
> > need to sort them.
> > 
> > The keys have to fit in memory (and had to fit in memory previously, for
> > them to be dirty in the journal);
> 
> What if the disk is moved to a smaller system, should the fs still mount
> there? (I don't mean such a small system that it can't vmalloc() 2GB
> specifically, but in principle...)

You'll have to do journal replay on the bigger system. Once you've done
that, it'll work just fine on the smaller system.

(Now, trying to work with a 75TB filesystem on a small machine is going
to be really painful if you ever need to fsck. That's just an inherently
hard problem, but we've got fsck scalability/performance improvements in
the works).

But journal replay does inherently require the whole contents of the
journal to fit in memory - we have to do the sort + dedup so that we can
overlay the contents of the journal over the btree until journal replay
is finished so that we can get a consistent view of the filesystem,
which we need so that we can run the allocator, and go read-write, which
we need in order to do journal replay.

Fun bootstrap problems.

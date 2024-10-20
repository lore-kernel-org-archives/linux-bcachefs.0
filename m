Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 596BA194A54
	for <linux-bcachefs@vger.kernel.org>; Sun, 20 Oct 2024 20:29:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729456202; cv=none; b=NtpmE+nP73bBkwiILym5NDc0heAW6/KrK7NSUI3Tpge3/S8mWZmxjjToEjR/Ta4vqDoeUqpgs+s1YcHJSMZ+Z3EMmayo08ipkyk04vRlCXWqRYONC7TSUObLVfvHzHP0AdfH5x6P8AWgODl+bhF3SI1FCpGSNyc/+U58FScNJqg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729456202; c=relaxed/simple;
	bh=om0edKodotXeHDUcUmNAyosVE0NGJz25Arm80e6Js4g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=B5jN30Sxl22U7Z/r7JO2jEurfe3Oc9yskXavfRHH7FHpyP2RdOw4/nBRCnlnocTGB+brOfGtckEHJmNLv6POuLJYtkgYdKV8mdiF75Cd2ZGJqCX6YtF5uhuLZevrl4iLR3L53CvVfbILqkOOEH2yq8jTiV++y3Imh8ptLmIXAT0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=LJtRMZ1g; arc=none smtp.client-ip=91.218.175.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="LJtRMZ1g"
Date: Sun, 20 Oct 2024 16:29:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1729456196;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=HJCGZp82jco9S+8nHg93J4Lno8LxTucGPuBhIGaxGsE=;
	b=LJtRMZ1g6OfCEqbnQSgWNT6D6QoXBZyfjcrXT4RRr6l4LNGMiI/zABSn3ywx59/hv7DP/C
	ppp3ijm7ENbwtSD2hWEcXNPDwLNN9JZGUatbje2b0yGRBGMWmJsiALwIJdvVOD7uS+ExpC
	7LwqGqtNBZnaBGUn/Ja1oYDxb/MXg5c=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	linux-bcachefs@vger.kernel.org, linux-mm@kvack.org, Vlastimil Babka <vbabka@suse.cz>, 
	Andrew Morton <akpm@linux-foundation.org>, Uladzislau Rezki <urezki@gmail.com>, 
	Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] mm: Drop INT_MAX limit from kvmalloc()
Message-ID: <ikaf72w2oap3crjrybbd5jp267slnb7dygz4m62dfw3edu2ppj@f7dv2qdx3yga>
References: <90bc0794-4cab-415f-a442-4af85a32eed8@lucifer.local>
 <ucbcmk4kr7tbvj6uqnjke5662kerawbr4ghtlbw4zim7mdm3fg@vjawfne5rdkp>
 <ebe58a08-2371-403c-a0d7-6280160b6848@lucifer.local>
 <zfr4sh3wtzi4viladlgwyon6voqhcj5fe3fv2nc3hqyyxdw5wd@onyj3r2m3usz>
 <CAHk-=wi=PrbZnwnvhKEF6UUQNCZdNsUbr+hk-jOWGr-q4Mmz=Q@mail.gmail.com>
 <m46mlvv57oypstekojhkdwpts6mi4r63l4kugs4lpry3d2r7dq@kbmied6nzsc3>
 <CAHk-=wg8iZWDbX_MAujGtqHJYQneKBwDJnVAY94siNr1gLmtaA@mail.gmail.com>
 <CAHk-=wiW_QZ9VS3Ho2Ff8ZDp-T6SomDFrVPWG3abs45LMZpxZQ@mail.gmail.com>
 <6eo3gekf6twbnzhpsi2emz2s6sgtof6iba2rvbor7himmejoq5@qbfwtpbpvqoe>
 <CAHk-=wga3FXReWVhU2eid8+sXhBF1QgP1iMJu1jnSX6fapoyXQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wga3FXReWVhU2eid8+sXhBF1QgP1iMJu1jnSX6fapoyXQ@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT

On Sun, Oct 20, 2024 at 01:19:42PM -0700, Linus Torvalds wrote:
> On Sun, 20 Oct 2024 at 13:10, Kent Overstreet <kent.overstreet@linux.dev> wrote:
> >
> > And the INT_MAX check wouldn't catch truncation anyways - it'd only
> > catch integer _underflow_, but allocation size calculations pretty much
> > as a rule never use subtractions, so I don't think this check was ever
> > worth much to begin with.
> 
> It fixed a real security issue.

Which you quite conveniently aren't naming.

> Enough said, and you're just making shit up to make excuses.
> 
> Also, you might want to start look at latency numbers in addition to
> throughput. If your journal replay needs an *index* that is 2G in
> size, you may have other issues.

Latency for journal replay?

No, journal replay is only something happens at mount after an unclean
shutdown. We can afford to take some time there, and journal replay
performance hasn't been a concern.

> Your journal size is insane, and your "artificial cap on performance"
> had better come with numbers.

I'm not going to run custom benchmarks just for a silly argument, sorry.

But on a fileserver with 128 GB of ram and a 75 TB filesystem (yes,
that's likely a dedicated fileserver), we can quite easily justify a
btree node cache of perhaps 10GB, and on random update workloads the
journal does need to be that big - otherwise our btree node write size
goes down and throughput suffers.

> Why do you keep on being the person who creates all these pointless
> arguments? Not just with me, btw.

That's only going to get the biggest eyeroll ever.

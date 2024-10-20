Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BCD82F43
	for <linux-bcachefs@vger.kernel.org>; Sun, 20 Oct 2024 21:57:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729461440; cv=none; b=lhzpmSQxCJHwPWmfA/VieREUOv+/fZJAK84MuPjsKTlMAyWtTRIjNM5O8QnPw8+86RRuL64+FFe6eejCLzcuSsAxOexYiho93tnx/daxkh+E8vDvKFCz0/BFSTYgsKbodrfWdic8OermUMzt9XR49zfzd5Z+cXFpHMD+D4AwKqo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729461440; c=relaxed/simple;
	bh=MKU6exgCuHdkLJzZ+U0p7JD0sllcvt56LQMAjmHJEq0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=da4Lp6TqDKCicUiNxirA8loMJES82hV0R7570dCPob7slRlNQVzFchJBUbANEJBkfRawERYS5aAFO2IMUujEGtUMZcGnhQ7ibTPO8Y59eIFTDOXMsZAaaJXQDSB7uMTkSNKnERXaBxhkARNmNfDJtTpW2ds26gpOa5rVAgExTME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=OVTKdxr+; arc=none smtp.client-ip=95.215.58.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="OVTKdxr+"
Date: Sun, 20 Oct 2024 17:57:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1729461435;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=BXZIZH1RB87sxa9BBak3KfUIdbvXtJnNAShnXpitbas=;
	b=OVTKdxr+CZ8a+IT/Cik16l7Py1g91nErkRGXCLXZO4OVAm2/KmMxn6yNPaEu1i4EFL2bEM
	hk1QspwLSnfubjbuNS+gwTfftIPvhHpwua6AtmgLhJyVj+YFu7AAiPovJlh94U7qCjC2SE
	n8r0/chWu649SxTo46/tqLITf2Vz6UE=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Joshua Ashton <joshua@froggi.es>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, linux-bcachefs@vger.kernel.org, linux-mm@kvack.org, 
	Vlastimil Babka <vbabka@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, 
	Uladzislau Rezki <urezki@gmail.com>, Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] mm: Drop INT_MAX limit from kvmalloc()
Message-ID: <4pccb6s6rq3mbpthglkqnee3uebhaqdmdj42quryr2jwz55pio@orztt4y3fpve>
References: <ebe58a08-2371-403c-a0d7-6280160b6848@lucifer.local>
 <zfr4sh3wtzi4viladlgwyon6voqhcj5fe3fv2nc3hqyyxdw5wd@onyj3r2m3usz>
 <CAHk-=wi=PrbZnwnvhKEF6UUQNCZdNsUbr+hk-jOWGr-q4Mmz=Q@mail.gmail.com>
 <m46mlvv57oypstekojhkdwpts6mi4r63l4kugs4lpry3d2r7dq@kbmied6nzsc3>
 <CAHk-=wg8iZWDbX_MAujGtqHJYQneKBwDJnVAY94siNr1gLmtaA@mail.gmail.com>
 <CAHk-=wiW_QZ9VS3Ho2Ff8ZDp-T6SomDFrVPWG3abs45LMZpxZQ@mail.gmail.com>
 <6eo3gekf6twbnzhpsi2emz2s6sgtof6iba2rvbor7himmejoq5@qbfwtpbpvqoe>
 <CAHk-=wga3FXReWVhU2eid8+sXhBF1QgP1iMJu1jnSX6fapoyXQ@mail.gmail.com>
 <ikaf72w2oap3crjrybbd5jp267slnb7dygz4m62dfw3edu2ppj@f7dv2qdx3yga>
 <690cd8b8-5095-4560-a555-773a2068305e@froggi.es>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <690cd8b8-5095-4560-a555-773a2068305e@froggi.es>
X-Migadu-Flow: FLOW_OUT

On Sun, Oct 20, 2024 at 10:51:10PM +0100, Joshua Ashton wrote:
> 
> 
> On 10/20/24 9:29 PM, Kent Overstreet wrote:
> > On Sun, Oct 20, 2024 at 01:19:42PM -0700, Linus Torvalds wrote:
> > > On Sun, 20 Oct 2024 at 13:10, Kent Overstreet <kent.overstreet@linux.dev> wrote:
> > > > 
> > > > And the INT_MAX check wouldn't catch truncation anyways - it'd only
> > > > catch integer _underflow_, but allocation size calculations pretty much
> > > > as a rule never use subtractions, so I don't think this check was ever
> > > > worth much to begin with.
> > > 
> > > It fixed a real security issue.
> > 
> > Which you quite conveniently aren't naming.
> > 
> > > Enough said, and you're just making shit up to make excuses.
> > > 
> > > Also, you might want to start look at latency numbers in addition to
> > > throughput. If your journal replay needs an *index* that is 2G in
> > > size, you may have other issues.
> > 
> > Latency for journal replay?
> > 
> > No, journal replay is only something happens at mount after an unclean
> > shutdown. We can afford to take some time there, and journal replay
> > performance hasn't been a concern.
> 
> Then why are you arguing about there being an "artificial cap on
> performance", if you can "afford to take some time there"?
> 
> Am I missing something?

The journal keys has to exist as a flat sorted array, and it has to
contain _all_ the (sorted, deduped) keys that were in the journal.

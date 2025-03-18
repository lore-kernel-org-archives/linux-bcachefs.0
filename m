Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E414A17548
	for <linux-bcachefs@vger.kernel.org>; Tue, 18 Mar 2025 16:46:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742316394; cv=none; b=V16BjbpXaixM+uTF0I8m1cfV3wEZBho3h8LC/22179NMERzPcBkKLTughZqFlus7Cj8NO5AYG06B37M3y8nIN3tYgib6abnt/e1IqVCAOaGvpIf6bPWtmJMwKKMGkKejDjbCvf21hJ0HsMC/JIM5+0RWUS7lJ1PZELhNCRRbT8I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742316394; c=relaxed/simple;
	bh=pf1CVi+SLvzEFz/fP9L9FI/QLlu9ysIDJfxoLGCWNBA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=X/ArROIRYfFKsKeo0wQpBvnC3IoxFd1TDmNeWNE9KbtA4Hk459ASeTXep/faKm3pn1kqEjKpxB6PhbvT4FqptZ1pRLBI7lTH9WjYSv2DmXQ47AOT63OySbQcKIzt23SfU0NrECb+gk5cy2HUuv03kpv979tsD9lDjaNrGprLukE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=CbLCOLjQ; arc=none smtp.client-ip=91.218.175.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="CbLCOLjQ"
Date: Tue, 18 Mar 2025 12:46:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1742316389;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3BX53hT+zR2t/3RxpJ4O3HgD8HC5PHMZQfENQHa3gEk=;
	b=CbLCOLjQL/3+oUdnYeIap1/v/dm/7LIQNxbNHo91cexbXqxeEQ7dnZUvzj37A/TohTxL4s
	DgfhlQUJGuU7HI6JLpu83HIL08yHrNt6FkTnk6H1kSIObjK6tfCKZPKPOS6B+4PmKj6psd
	cxccsAsTokos+U98u8+w/Vdel8kuNzI=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Alan Huang <mmpgouride@gmail.com>
Cc: John Stoffel <john@stoffel.org>, linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH] bcachefs: Increase blacklist range
Message-ID: <dh3pwb6yaxiqeduza4b7vkay324sns7wycd7truud5ka4kblt7@u3bml3mh23ys>
References: <20250315073942.1909895-1-mmpgouride@gmail.com>
 <26584.36082.936426.143774@quad.stoffel.home>
 <gchq6w4tyrx4wxjepyfoerprnsp3jlzm2acel4hfaf4z3jp4iw@53mpn6u5edc7>
 <26585.33403.270413.729999@quad.stoffel.home>
 <gogyhxsomty6ooldwglk36qa2rqn6iwwwhopslmui2k3naky2i@4vzz3myybst5>
 <482110E9-C91B-4E34-9B42-0D12616C2EBC@gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <482110E9-C91B-4E34-9B42-0D12616C2EBC@gmail.com>
X-Migadu-Flow: FLOW_OUT

On Tue, Mar 18, 2025 at 11:19:52PM +0800, Alan Huang wrote:
> On Mar 18, 2025, at 22:57, Kent Overstreet <kent.overstreet@linux.dev> wrote:
> > In the olden days, in the before times, blacklisting insufficient
> > sequence numbers would mean btree node entries could become visible
> > after a crash that should've been ignored, because they were newer than
> > the newest (flush) journal entry.
> > 
> > That can't happen anymore because pointers to btree nodes now indicate
> > how many sectors we've written and completed within that node, and
> > they're updated after every btree node write (log append).
> > 
> > IOW - our mechanism for sequential consistency now is that the b-tree
> > behaves like a pure COW btree.
> > 
> > So I retract what I said before :) Having just checked the journal read
> > path, and the recovery path that creates the blacklist entries, I think
> > we're good.
> > 
> > The only reason we'd need to blacklist more is if we want some kind of a
> > double check on the modern sequential consistency mechanism, and I don't
> > think we need that.
> 
> What about multi-btree sequential consistency ?
> 
> i.e. one btree completes the entire tree update, but the other doesn’t

Btree updates are completed via journal updates, it's all synchronized
via the journal

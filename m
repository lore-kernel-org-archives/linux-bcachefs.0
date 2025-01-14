Received: from out-173.mta1.migadu.com (out-173.mta1.migadu.com [95.215.58.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11C9F1FA82C
	for <linux-bcachefs@vger.kernel.org>; Tue, 14 Jan 2025 15:32:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736868743; cv=none; b=czTkyBauPLiTJx0g2dnvc3RRZILgcBArIggtQWbESLo07kLHKi+AuwUuMrh1sFiMKeJ0sHJj7iSu4zYoa8puZxmtkHRZOonOTJpoPQOdIO0W+82p9DBekpY3uyqXwOm1LS1Wfyk1Qn2RieNmn4cq/Qg3Nq5VULbjZynalL412BM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736868743; c=relaxed/simple;
	bh=VmCL0MmRy2PWpTM+LvD2L79JiVqGns1QTtuBwvhuF+k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kzXAO9v5YdJi93ewy72FiPp1j2M0Zws7o9lFgoqE4+yXHKHAv3SlMJBkSGx82OKr7uOMg2UJ/xfeNoFTjLBGAEjDjJxVYJ93EzGEbLIfyMGjJISPZJzY1zWo9PEN2o+waDSGMUGOsfMUFv6Ye50CzqAfibc8bBlD0+hcys2wOho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=dfKGf0aB; arc=none smtp.client-ip=95.215.58.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="dfKGf0aB"
Date: Tue, 14 Jan 2025 10:32:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1736868729;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=h8njObODJy6Y78fbgAvHgZlvQd+sjYfAMupkcLCwcBg=;
	b=dfKGf0aBVkB7wmlXn5bsB1J2XxUF1dcmH+BoxPQaaDAAlvQgWyxo1LP3U6j2SjXi1W1hph
	8wCMHCDM5KDz+2wpV7TmpcwE/36uXsMquglosnZeV9kr5JpJQDBNhP8WMNlVLH69fzrPnG
	5z2ZJbYN7e4FJ701hFRsY9TSZOFhvx8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Christian Loehle <christian.loehle@arm.com>, 
	Florian Schmaus <flo@geekplace.eu>, Ingo Molnar <mingo@redhat.com>, 
	Juri Lelli <juri.lelli@redhat.com>, Vincent Guittot <vincent.guittot@linaro.org>, 
	Dietmar Eggemann <dietmar.eggemann@arm.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, 
	Valentin Schneider <vschneid@redhat.com>, linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] bcachefs: set rebalance thread to SCHED_BATCH and
 nice 19
Message-ID: <pj6wif5dkwu5ayqqypvm77wv6dncnpx6sanh46u672gr2yxxss@56s4feeu5auu>
References: <20250114130513.498482-2-flo@geekplace.eu>
 <20250114130513.498482-4-flo@geekplace.eu>
 <28688fa8-718b-4ee6-8417-822efac8b603@arm.com>
 <20250114144000.GU5388@noisy.programming.kicks-ass.net>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250114144000.GU5388@noisy.programming.kicks-ass.net>
X-Migadu-Flow: FLOW_OUT

On Tue, Jan 14, 2025 at 03:40:00PM +0100, Peter Zijlstra wrote:
> On Tue, Jan 14, 2025 at 01:29:04PM +0000, Christian Loehle wrote:
> 
> > I know nothing about bcachefs internals, but could this also be a problem?
> > The rebalance thread might not run for O(second) or so? 
> 
> SCHED_BATCH should not behave anything like that, mostly SCHED_BATCH
> tasks will not cause wakeup preemption. But otherwise they compete at
> the same level as everybody else.
> 
> Notably a BATCH and NORMAL task that are each while(1) loops will get
> the normal 50-50 distribution of time. It's just that when a NORMAL task
> is running, the waking of a BATCH task won't ever kick the NORMAL from
> the CPU, instead waiting for the tick to do so.
> 
> So a task that is IO heavy (as suggested here), that wakes a lot to
> issue further IO, will not immediately interrupt whatever is on the CPU,
> instead it waits until it gets selected through other means.

Ok, thanks for the clarification on SCHED_BATCH - that does make perfect
sense here.

Using nice as a proxy for io scheduler priority does still bug me a bit,
simply because having a working io scheduler is not something we've ever
been able to depend on. That's a hidden internal knob we'd like to make
visible. I wonder if there's some way the tooling could be improved.

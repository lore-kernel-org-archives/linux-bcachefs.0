Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5877A130A73;
	Tue, 14 Jan 2025 14:32:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736865145; cv=none; b=pHXqYe13ntpoluShazKR8CsghyyRsA2yKzexdMKi9epyFi8KC/CEx9ASQ6eE3pho5yraJwd0rSQqoI9Zsb6Ry0TMUgOFveFVs/1E5wzvCGFGw2sb+fHU8I4LGLBUFaUYSwk7BXdgR7gj8AZjvD18nTiDK0fLg26v2M8+lb3d0rQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736865145; c=relaxed/simple;
	bh=IgFCTByyKQexXjchZ0aBGothaScxaomTZLAp06F1fDI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Od1a3WoEHXk2fYg6OHIAHuaTnS18lJRUPJQYQCqR7EwWD6qu9Ej9SOLgHFffaPi0iB/311Ai6FS8lymX00XmBB/fiHGWvXKki3N2V5gViQzElINv0hh+xTTqn5YgJM8FWRbOmi61F3jgVrnFGG+TUxveDigBQSHPR0sW3MVGcEk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=heS5bWZ5; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="heS5bWZ5"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=E6oDlEaqP7wE6MngFKHNSZP+hFRtppxVDJA+dfNXscY=; b=heS5bWZ5oUzDrz1ph4ABNtFl/V
	sZF3EFmh27iPGGvacRCtrAY3Au01MAcCGZOhBz2SalrLdodKEgVGrYN5y8tnL4MwQ4+1SclRSWtNd
	LWy/Y5tnxXU66jezqVQ1IxM9UdrSJ/oVxBtAXNmF0c91776JNcPViXGgR0i7Z7scU/N/fwdxgDdQ0
	Jh/dh1zc60jfFgoj6kktLxOvgqHgtcJ098/K+KduIJbE1lWeQ+aXTiV+1hB/1EaH3XFnPqGqxu2RM
	0L7K10Lxt7MrZjtnGCFQ/7c9o6XfF9hH5v0Qg2LokaMlXEn34d2gjYXtr6m9oYGTblqEKvjZkC+Zh
	f/e3bLVw==;
Received: from 77-249-17-89.cable.dynamic.v4.ziggo.nl ([77.249.17.89] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tXhxm-0000000H32T-2mIe;
	Tue, 14 Jan 2025 14:32:15 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 4046230063F; Tue, 14 Jan 2025 15:32:14 +0100 (CET)
Date: Tue, 14 Jan 2025 15:32:14 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Florian Schmaus <flo@geekplace.eu>
Cc: Ingo Molnar <mingo@redhat.com>, Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
	Kent Overstreet <kent.overstreet@linux.dev>,
	linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] bcachefs: set rebalance thread to SCHED_BATCH and
 nice 19
Message-ID: <20250114143214.GT5388@noisy.programming.kicks-ass.net>
References: <20250114130513.498482-2-flo@geekplace.eu>
 <20250114130513.498482-4-flo@geekplace.eu>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250114130513.498482-4-flo@geekplace.eu>

On Tue, Jan 14, 2025 at 01:47:28PM +0100, Florian Schmaus wrote:
> While the rebalance thread is isually not compute bound, it does cause
> a considerable amount of I/O. Since "reducing" the nice level from 0
> to 19, also implicitly reduces the threads best-effort I/O scheduling
> class level from 4 to 7, the reblance thread's I/O will be depriotized
> over normal I/O.
> 
> Furthermore, we set the rebalance thread's scheduling class to BATCH,
> which means that it will potentially receive a higher scheduling
> latency. Making room for threads that need a low
> schedulinglatency (e.g., interactive onces).

sorta.. what worries me most about these patches are the claims without
backing numbers.

Supposedly there is a problem, and this here fixes it, but it doesn't
really get quantified much here.

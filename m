Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E89B23242C
	for <linux-bcachefs@vger.kernel.org>; Tue, 14 Jan 2025 15:25:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736868352; cv=none; b=Bu36NAwsSNg7tdIXJ9Wc9u1qDxPE8szzDSXjsXwFOQeMfbvleA3PL//hP/PY3h7leaG6G7HFwS3FzdwG6oFwfzH6A6IzxVHbpBBaBfdZLj4a3nZ5KKv2rMppRb18a/Tz7QnozQ/VgvL0rMJqdNVc7KjljB0IHuxwsclBNI/8MeE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736868352; c=relaxed/simple;
	bh=9gJkTjD2SzXnu1lURCtVLGLAcO2szy8CNSNMSmjFXz4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=I7vl98y+oz504YfbiGcPFkEYo4LFM8enHrorwsMvEOR2/o+C8IVD31DglutOx9gSSF83pnDTnIRielcfaG9gRzk2X8CoMET8pnhUBfQgswjR5RMs6DdCkfRKdD7TDKG7zbPCXOGC+whiM5NntA5s/vDedtvWJYpx1L2ILF2ycTY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=by0SYzBQ; arc=none smtp.client-ip=91.218.175.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="by0SYzBQ"
Date: Tue, 14 Jan 2025 10:25:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1736868348;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+wCO6MoExQGV5QU2FgbJ/IJOu5dDT0jLzhFHf4/DCY4=;
	b=by0SYzBQU2yLeA04dJlxCJe/zrgdJMrtC1F28lhRNYad4/bXCT8ohbeJA/OKKJfFxwOYjc
	paoMqAOOoOvC3ExS+OFjIBKHvWLpEyj8T5QKqf9E97vEQs1UEsHwHxSbX+oBU1wt/x5e7X
	MVdn347cgbBEVe9t39Qwodx2Fd42sWE=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Florian Schmaus <flo@geekplace.eu>, Ingo Molnar <mingo@redhat.com>, 
	Juri Lelli <juri.lelli@redhat.com>, Vincent Guittot <vincent.guittot@linaro.org>, 
	Dietmar Eggemann <dietmar.eggemann@arm.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, 
	Valentin Schneider <vschneid@redhat.com>, linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] bcachefs: set rebalance thread to SCHED_BATCH and
 nice 19
Message-ID: <yry5ukfmnfcfemtebcfxgg3mbueil7rgakqzfzdsx6iqn4ush7@3iuxjdj5sdoe>
References: <20250114130513.498482-2-flo@geekplace.eu>
 <20250114130513.498482-4-flo@geekplace.eu>
 <20250114143214.GT5388@noisy.programming.kicks-ass.net>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250114143214.GT5388@noisy.programming.kicks-ass.net>
X-Migadu-Flow: FLOW_OUT

On Tue, Jan 14, 2025 at 03:32:14PM +0100, Peter Zijlstra wrote:
> On Tue, Jan 14, 2025 at 01:47:28PM +0100, Florian Schmaus wrote:
> > While the rebalance thread is isually not compute bound, it does cause
> > a considerable amount of I/O. Since "reducing" the nice level from 0
> > to 19, also implicitly reduces the threads best-effort I/O scheduling
> > class level from 4 to 7, the reblance thread's I/O will be depriotized
> > over normal I/O.
> > 
> > Furthermore, we set the rebalance thread's scheduling class to BATCH,
> > which means that it will potentially receive a higher scheduling
> > latency. Making room for threads that need a low
> > schedulinglatency (e.g., interactive onces).
> 
> sorta.. what worries me most about these patches are the claims without
> backing numbers.
> 
> Supposedly there is a problem, and this here fixes it, but it doesn't
> really get quantified much here.

yeah, it was explained to me and made sense at the time, but things
somehow keep falling out of my overflowing brain.

Florian, could you update the patch message with that? Was it intended
as a partial workaround for the rebalance spinning issue some users have
been hitting?

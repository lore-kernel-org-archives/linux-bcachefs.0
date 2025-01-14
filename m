Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC49E12FB1B
	for <linux-bcachefs@vger.kernel.org>; Tue, 14 Jan 2025 15:19:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736867957; cv=none; b=hzifHIF9UBom7/Nrn2eWJKUTrwze1l1gSR+dcQPUeBXuiIOqXrGgrVIjv//2OKvVJdjm6BkP8RddtN2KNXPJOF0YieJSW4748gF7kSRk1lrWiQyOAv2/jBn+96LRz6ezO1kISepnkmbYrxDwIG8gl4mLW0KqYItLmxE8hM0BYzo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736867957; c=relaxed/simple;
	bh=AICQ5fmyL+0oY2ECwhoIcCcTnuBazIBMKItKvx2mglE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aeWrzbcNtVPj8x7kBkxLIl9bd/wT0zNeQJbIIgdVxKdPG7KtJlDFCMWT0SPzBi61sU37MjbX9eAgkK/UNvBvgeIXjZY24zMuLizMS9wkTKMVKM3fNHDewiVSaJP6jr5041an/eHbBQeDiQiZ2oRqCsOrFOmM+2eK+T7zN5TRdBo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=h2QdR+qg; arc=none smtp.client-ip=91.218.175.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="h2QdR+qg"
Date: Tue, 14 Jan 2025 10:19:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1736867949;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=lSRNyQav0yFm/iZhK95AlhoyW0DiZLXK2lpVbE3f5EE=;
	b=h2QdR+qgR09v7VT1T8NjjhUgES3G+VuntMY6jsYqXSZ5t76IuETnwJjO/9ymvIRSHOKF1a
	rzC5SU03WZktaYRGbFgohMp1E9xY5Ga6/1KwMQgq3ltDIMnANVlKyxRKwgYwjbDwVzRiys
	9+pmB7E/8veQZZom5GsH5req5MaJTGc=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Christian Loehle <christian.loehle@arm.com>
Cc: Florian Schmaus <flo@geekplace.eu>, Ingo Molnar <mingo@redhat.com>, 
	Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>, 
	Vincent Guittot <vincent.guittot@linaro.org>, Dietmar Eggemann <dietmar.eggemann@arm.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, 
	Valentin Schneider <vschneid@redhat.com>, linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] bcachefs: set rebalance thread to SCHED_BATCH and
 nice 19
Message-ID: <ynauark4zdo6iu232kmraqd4guf3ovjd4dcnc7se73khypyc2y@xlnyl7kpwzx3>
References: <20250114130513.498482-2-flo@geekplace.eu>
 <20250114130513.498482-4-flo@geekplace.eu>
 <28688fa8-718b-4ee6-8417-822efac8b603@arm.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <28688fa8-718b-4ee6-8417-822efac8b603@arm.com>
X-Migadu-Flow: FLOW_OUT

On Tue, Jan 14, 2025 at 01:29:04PM +0000, Christian Loehle wrote:
> On 1/14/25 12:47, Florian Schmaus wrote:
> > While the rebalance thread is isually not compute bound, it does cause
> 
> s/isually/usually
> 
> > a considerable amount of I/O. Since "reducing" the nice level from 0
> > to 19, also implicitly reduces the threads best-effort I/O scheduling
> > class level from 4 to 7, the reblance thread's I/O will be depriotized
> 
> s/depriotized/deprioritized/
> 
> > over normal I/O.
> > 
> > Furthermore, we set the rebalance thread's scheduling class to BATCH,
> > which means that it will potentially receive a higher scheduling
> > latency. Making room for threads that need a low
> > schedulinglatency (e.g., interactive onces).
> 
> s/schedulinglatency/
> I know nothing about bcachefs internals, but could this also be a problem?
> The rebalance thread might not run for O(second) or so? 

Actually that is a concern - six locks don't have priority inheritence.

For that matter, standard mutexes and rw semaphores don't either, just
the RT variants, which seems questionable to me...

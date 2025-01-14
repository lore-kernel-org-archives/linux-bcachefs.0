Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FB31232437;
	Tue, 14 Jan 2025 14:40:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736865607; cv=none; b=n0+O9ueIQbuY/F76gGvxhR207YzCPFQypX1TCKmXLkC/n/RcRNIqVtKAYvTExLAb5kIXyYcwms3UHv1+LNtgJNV3Sko7SPV5tBraZoB9A1JCftaTHp7wmwvMUBjVFISvAhEentK5GEOz6xk1dQHAeROO0vSio/dd0x6XK3NTyj8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736865607; c=relaxed/simple;
	bh=CK69cPaqyjX10AH5L2pyg8s9hkkcPSt/EyOfbdFKGNA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NErQbc02IddDv9VQcbqrxG3EWRIxCzhVLuQhkCxo5IRhIhZKS8ipAwr1m/4bhqzk5e9bUxG/tFXuKM1B/firtPjTo/Xy23HprRec9Axuieunx166qCqrmdDWhjkMwr4cIB8DhpG8iyfADYqY4Up9sSuoYOMPduYdYWJxcRaqYCM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=jxZGCdVV; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="jxZGCdVV"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=RkJ82mCc5RNjMWgLxFJLhIzponbfHm0QnzMsNeFjy50=; b=jxZGCdVVuVfnLSQsLf9N5nns8O
	q4rqipawLhTwzWF+TRCWjTgw3dZ/7RE+I4uXxB7YmnFSPW3wL1hta+UzFeec6JYu94KeVVWE0kv25
	v0RqxdLKVxplROUUDY7J3xD8ZEGioFOoCTHzcsVUD+VVLBtzsyAoTh3hoan93IDaIr3bGQj0giGUR
	ApPX7AYo5H94PPv5BvJx8EPg+wPMRAUhT5jG2BaM1rVJsAREkavUz5Luk9rEyai2lL/pEk7GRzO+k
	qcn6OyEO4V9TcrDRf6bT/Fo9gpCW2dP7i/vhys38ShEDrQFy2hWA+cDhXKRTdntsM4hO0Ez+MqjYT
	+zfMDGvw==;
Received: from 77-249-17-89.cable.dynamic.v4.ziggo.nl ([77.249.17.89] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tXi5I-0000000H95i-3784;
	Tue, 14 Jan 2025 14:40:00 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 4F7573003AF; Tue, 14 Jan 2025 15:40:00 +0100 (CET)
Date: Tue, 14 Jan 2025 15:40:00 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Christian Loehle <christian.loehle@arm.com>
Cc: Florian Schmaus <flo@geekplace.eu>, Ingo Molnar <mingo@redhat.com>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
	Kent Overstreet <kent.overstreet@linux.dev>,
	linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] bcachefs: set rebalance thread to SCHED_BATCH and
 nice 19
Message-ID: <20250114144000.GU5388@noisy.programming.kicks-ass.net>
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

On Tue, Jan 14, 2025 at 01:29:04PM +0000, Christian Loehle wrote:

> I know nothing about bcachefs internals, but could this also be a problem?
> The rebalance thread might not run for O(second) or so? 

SCHED_BATCH should not behave anything like that, mostly SCHED_BATCH
tasks will not cause wakeup preemption. But otherwise they compete at
the same level as everybody else.

Notably a BATCH and NORMAL task that are each while(1) loops will get
the normal 50-50 distribution of time. It's just that when a NORMAL task
is running, the waking of a BATCH task won't ever kick the NORMAL from
the CPU, instead waiting for the tick to do so.

So a task that is IO heavy (as suggested here), that wakes a lot to
issue further IO, will not immediately interrupt whatever is on the CPU,
instead it waits until it gets selected through other means.

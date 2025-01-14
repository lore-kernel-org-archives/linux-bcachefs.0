Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 37BDE12C7FD;
	Tue, 14 Jan 2025 15:05:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736867136; cv=none; b=OfAZdbS/r4WI8EZ8PRnUTohA6GjTi2zZey1ISq1l5w/6U4pRBYOqhDJs5d//Tq/1krdhDGC2HoN0ibfTdyAvJnb1BEKt7VCHwOjXARIErXi92lEHGkxGTPRgdb5KMK358asHuo/moqrpPYGDz35/GrsAkJft8nuU1gmssW12e0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736867136; c=relaxed/simple;
	bh=kEH+eh30rlr4m9LdMOIIoGrMKpvIiN5QsYVVQ8qOaJ0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=T98ogkFWhBuceccu/DdnSyCRDeKtTLXsNj/lKVbza40tFkMK0M4aUH9FgBGGCMa6Ou9eY7u793FU7iEuU8i3AU5H5E3k4Z+URNK7OUxkwR/Ok4YoYMDSndsxKCQoSyD8UP4OvVjjCS4R5VurRXWYwWwAS5BYZtxA8ea35Bqc9uM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E84DC11FB;
	Tue, 14 Jan 2025 07:06:02 -0800 (PST)
Received: from [10.1.25.68] (e127648.arm.com [10.1.25.68])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E92B13F673;
	Tue, 14 Jan 2025 07:05:31 -0800 (PST)
Message-ID: <866f8d37-2ef5-434b-bf70-f142fbbcfc62@arm.com>
Date: Tue, 14 Jan 2025 15:05:29 +0000
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] bcachefs: set rebalance thread to SCHED_BATCH and
 nice 19
To: Peter Zijlstra <peterz@infradead.org>
Cc: Florian Schmaus <flo@geekplace.eu>, Ingo Molnar <mingo@redhat.com>,
 Juri Lelli <juri.lelli@redhat.com>,
 Vincent Guittot <vincent.guittot@linaro.org>,
 Dietmar Eggemann <dietmar.eggemann@arm.com>,
 Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>,
 Mel Gorman <mgorman@suse.de>, Valentin Schneider <vschneid@redhat.com>,
 Kent Overstreet <kent.overstreet@linux.dev>, linux-bcachefs@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20250114130513.498482-2-flo@geekplace.eu>
 <20250114130513.498482-4-flo@geekplace.eu>
 <28688fa8-718b-4ee6-8417-822efac8b603@arm.com>
 <20250114144000.GU5388@noisy.programming.kicks-ass.net>
Content-Language: en-US
From: Christian Loehle <christian.loehle@arm.com>
In-Reply-To: <20250114144000.GU5388@noisy.programming.kicks-ass.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 1/14/25 14:40, Peter Zijlstra wrote:
> On Tue, Jan 14, 2025 at 01:29:04PM +0000, Christian Loehle wrote:
> 
>> I know nothing about bcachefs internals, but could this also be a problem?
>> The rebalance thread might not run for O(second) or so? 
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

I was thinking about two SCHED_BATCH tasks here and one having to wait
for a long time for it to complete, but that was because I was still
under the impression that SCHED_BATCH uses a different base slice which
apparently isn't true. My bad!

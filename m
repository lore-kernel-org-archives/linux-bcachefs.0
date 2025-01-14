Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 103F9232432;
	Tue, 14 Jan 2025 13:29:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736861353; cv=none; b=ajEIuOgkyYSnJx88cLJKlm1z9Waai3rgmb3weVny/AT98InFyRkEUiKzLq15v9tNtv32Zm6m3u+NlWFfpxsZAAXVriIerFAcduFJ2vN5p1FXfblyy573SG0VCwIrjxeD8vGH/EUZP1NBV0InDH43UBJsD48kMRWBuDzSUPuP7bE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736861353; c=relaxed/simple;
	bh=CzY5Yo78DXFthPa6Bv0Bv0PCnAHlN3UWLgLYqeRKF40=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Ec98Tn8MjvpunLHSOGyNAji9MnJr6uwu6TWVgzgRNHUUPhA/OcFvPY5huGvA7CPXQ8BwniHXGpzarrV1YUu2JAdD7roSroyey4fzfvlBJZLNjqxem+HTfyJSK1S5EWf6CcmcJ4JfrrNZVw1BgkOq9GXEFZYtYJQp6asFri8e3oA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 39F8D339;
	Tue, 14 Jan 2025 05:29:37 -0800 (PST)
Received: from [10.1.25.68] (e127648.arm.com [10.1.25.68])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3E0BF3F673;
	Tue, 14 Jan 2025 05:29:06 -0800 (PST)
Message-ID: <28688fa8-718b-4ee6-8417-822efac8b603@arm.com>
Date: Tue, 14 Jan 2025 13:29:04 +0000
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] bcachefs: set rebalance thread to SCHED_BATCH and
 nice 19
To: Florian Schmaus <flo@geekplace.eu>, Ingo Molnar <mingo@redhat.com>,
 Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>,
 Vincent Guittot <vincent.guittot@linaro.org>,
 Dietmar Eggemann <dietmar.eggemann@arm.com>,
 Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>,
 Mel Gorman <mgorman@suse.de>, Valentin Schneider <vschneid@redhat.com>,
 Kent Overstreet <kent.overstreet@linux.dev>
Cc: linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20250114130513.498482-2-flo@geekplace.eu>
 <20250114130513.498482-4-flo@geekplace.eu>
Content-Language: en-US
From: Christian Loehle <christian.loehle@arm.com>
In-Reply-To: <20250114130513.498482-4-flo@geekplace.eu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 1/14/25 12:47, Florian Schmaus wrote:
> While the rebalance thread is isually not compute bound, it does cause

s/isually/usually

> a considerable amount of I/O. Since "reducing" the nice level from 0
> to 19, also implicitly reduces the threads best-effort I/O scheduling
> class level from 4 to 7, the reblance thread's I/O will be depriotized

s/depriotized/deprioritized/

> over normal I/O.
> 
> Furthermore, we set the rebalance thread's scheduling class to BATCH,
> which means that it will potentially receive a higher scheduling
> latency. Making room for threads that need a low
> schedulinglatency (e.g., interactive onces).

s/schedulinglatency/
I know nothing about bcachefs internals, but could this also be a problem?
The rebalance thread might not run for O(second) or so? 


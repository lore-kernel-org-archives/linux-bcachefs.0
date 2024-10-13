Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E670914AD3F
	for <linux-bcachefs@vger.kernel.org>; Sun, 13 Oct 2024 23:05:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728860748; cv=none; b=LS5ODO5qTxd2GNUlMEYyeJYsNClYQzXVe8z3pC6KGVk8riWjJxJncDtr9M+qraAkI3FSKGxCZxdB9BxjTCz4DfDODL4tfi5HyYvOpNG8Mn9Of4qdb0qyyVku3tPl2/8SA71hKL481Rq9vhi147SoYFl2DNGZTtwgEBsC1zyuAks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728860748; c=relaxed/simple;
	bh=vVFuco5IkUVZm6+4vPSvWvWGw6JLz15lWSmvpfk6Nx0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Z2oLtgxmh5h65LHvdgdvhb89ICw5JZgucerPUxqnbBbDNIJzOgr5BndxI7+PQV2urAnQiL/BRKxSuDkoVSvzG7gLj0cR3JZ62SXy89dFzcLJSEwVYKc+3ag8MX7hwM0L20jBWSFNhdEVA/sXo2tlnXnyprUwxgBQ6/FGrmJuPEI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=A+j51JSt; arc=none smtp.client-ip=91.218.175.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="A+j51JSt"
Date: Sun, 13 Oct 2024 19:05:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1728860744;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=OwnQUpfLFyhtFnNBmva4jZ85PzjV+X96ARhGEi0eXec=;
	b=A+j51JSt0HCazZp0xxO5iuW/zKv6+/vmeMyNkpJt6J7mQR/Zsf0GIKajQ3UV6PZJpL4cor
	4vLXRxz6HjSu+F/2mKr7Fkm35XhRlZZRIGh7L0wjoRRiPW8LSra04bewcEaokEdTwMDUr+
	xRD5n5H3f/p5GD2pQI0K7YaOIrAuAGE=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Kuan-Wei Chiu <visitorckw@gmail.com>
Cc: colyli@suse.de, msakai@redhat.com, corbet@lwn.net, 
	peterz@infradead.org, mingo@redhat.com, acme@kernel.org, namhyung@kernel.org, 
	akpm@linux-foundation.org, mark.rutland@arm.com, alexander.shishkin@linux.intel.com, 
	jolsa@kernel.org, irogers@google.com, adrian.hunter@intel.com, 
	kan.liang@linux.intel.com, jserv@ccns.ncku.edu.tw, linux-kernel@vger.kernel.org, 
	linux-bcache@vger.kernel.org, dm-devel@lists.linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-perf-users@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH 0/3] Enhance min heap API with non-inline functions and
 optimizations
Message-ID: <uisaqjn2ttzhohe3a5qrdw4x6m7rhuoxxuhfoz5szufynuz5fz@4wicz52jydwz>
References: <20241013184703.659652-1-visitorckw@gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241013184703.659652-1-visitorckw@gmail.com>
X-Migadu-Flow: FLOW_OUT

On Mon, Oct 14, 2024 at 02:47:00AM GMT, Kuan-Wei Chiu wrote:
> Add non-inline versions of the min heap API functions in lib/min_heap.c
> and updates all users outside of kernel/events/core.c to use these
> non-inline versions. Additionally, it micro-optimizes the efficiency of
> the min heap by pre-scaling the counter, following the same approach as
> in lib/sort.c. Documentation for the min heap API has also been added
> to the core-api section.

Nice, has it been tested - do you need a CI account?

I'd like to start seeing links to CI results in patch postings (and I
need to tweak the CI to add git fetch links, as well).

Coly, there's ktest tests for bcache that need to be updated - if you
wanted to take that on it'd be lovely to consolidate how our subsystems
are getting tested; I can give you a CI account as well.

> 
> Regards,
> Kuan-Wei
> 
> Kuan-Wei Chiu (3):
>   lib/min_heap: Introduce non-inline versions of min heap API functions
>   lib min_heap: Optimize min heap by prescaling counters for better
>     performance
>   Documentation/core-api: Add min heap API introduction
> 
>  Documentation/core-api/index.rst    |   1 +
>  Documentation/core-api/min_heap.rst | 291 ++++++++++++++++++++++++++++
>  drivers/md/bcache/Kconfig           |   1 +
>  drivers/md/dm-vdo/Kconfig           |   1 +
>  fs/bcachefs/Kconfig                 |   1 +
>  include/linux/min_heap.h            | 202 ++++++++++++-------
>  kernel/events/core.c                |   6 +-
>  lib/Kconfig                         |   3 +
>  lib/Kconfig.debug                   |   1 +
>  lib/Makefile                        |   1 +
>  lib/min_heap.c                      |  70 +++++++
>  11 files changed, 508 insertions(+), 70 deletions(-)
>  create mode 100644 Documentation/core-api/min_heap.rst
>  create mode 100644 lib/min_heap.c


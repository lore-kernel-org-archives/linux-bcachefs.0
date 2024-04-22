Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BDD11553B0
	for <linux-bcachefs@vger.kernel.org>; Mon, 22 Apr 2024 20:20:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713817237; cv=none; b=rR1WHm91IsTcHDcpHAgwmKwDRv4W0KTV3vG/p0tTI597r9QA4FkyeJ+iTjzZqzWv0Q69ldNYhJIkWPQzWkXssQ1OWXP7tKfaxBuFRZQjSsxj4LLwad9F6UWiaDPQicwmXUJHOnjgxCPoNABe0OX8PtlHINB5H6BEvJ2pCQUP08s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713817237; c=relaxed/simple;
	bh=tB4j3Mp1cAbAPzA7/QjfWJaHulMX9TPibSa9gTEbIbw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HsLE7XY21ZfhlBMVGjhYFA5Q3j+YR0Ew5XG8h55xXxVDtbnoAF9qJ+c8rK85tRBlX4+xWlCdRLhHRHrqnp8aeIFttcGH1cpqi7ThXSWbXoDduElzq88sDGSL7SKPUeqY2tNnlK7G/Ib7nPSs4TvOzEeWAdWQi6ss4tNC2Os/BB0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=uQePScF2; arc=none smtp.client-ip=91.218.175.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="uQePScF2"
Date: Mon, 22 Apr 2024 16:20:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1713817234;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=5RG8Ru3lhWn45ANoWDq3cq77hbBwMzq6GTS3tURq8Wo=;
	b=uQePScF2xaCNayfHvN64HjSAdSMcLDdhKvjoFTZmqhwGG2g0Jkx6fWZ1g964VvWbejPnhE
	chFx2UEJnZNQMFh4stRdMHwcs2VFVtMhpsm5n/5T9QrwMT3PoHsG+USG/ZgoQokZ4pEk/r
	Pr7mR4uih1x7UhF4jRH5+kHb2m4YPVU=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Kuan-Wei Chiu <visitorckw@gmail.com>
Cc: colyli@suse.de, msakai@redhat.com, peterz@infradead.org, 
	mingo@redhat.com, acme@kernel.org, namhyung@kernel.org, akpm@linux-foundation.org, 
	bfoster@redhat.com, mark.rutland@arm.com, alexander.shishkin@linux.intel.com, 
	jolsa@kernel.org, irogers@google.com, adrian.hunter@intel.com, 
	jserv@ccns.ncku.edu.tw, linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org, 
	dm-devel@lists.linux.dev, linux-bcachefs@vger.kernel.org, linux-perf-users@vger.kernel.org
Subject: Re: [PATCH v3 00/17] treewide: Refactor heap related implementation
Message-ID: <asgiyolfhg2sfwarkrexbcx3y6mborcxklnncz4cn2g6ffubku@vhoumzvwdpzp>
References: <20240406164727.577914-1-visitorckw@gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240406164727.577914-1-visitorckw@gmail.com>
X-Migadu-Flow: FLOW_OUT

On Sun, Apr 07, 2024 at 12:47:10AM +0800, Kuan-Wei Chiu wrote:
> This patch series focuses on several adjustments related to heap
> implementation. Firstly, a type-safe interface has been added to the
> min_heap, along with the introduction of several new functions to
> enhance its functionality. Additionally, the heap implementation for
> bcache and bcachefs has been replaced with the generic min_heap
> implementation from include/linux. Furthermore, several typos have been
> corrected.
> 
> Previous discussion with Kent Overstreet:
> https://lkml.kernel.org/ioyfizrzq7w7mjrqcadtzsfgpuntowtjdw5pgn4qhvsdp4mqqg@nrlek5vmisbu
> 
> Regards,
> Kuan-Wei

We need to get this into -next, where are you at with v4?

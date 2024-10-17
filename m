Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FD251DA60D
	for <linux-bcachefs@vger.kernel.org>; Thu, 17 Oct 2024 10:46:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729161985; cv=none; b=IC9PphI3mK+C1HPSp6PRQ/NCDXCl7+viZFbbpR+ycHHGIWERnQrntmZY1r3WbpP6BYiNbdoC840FCyimtA6NfcgbfNrFjCu4AR/fLiDM69wAqJvS6naTRkytAOJdf/lDMNHRmc3+MYXvxBBjqU5HcrbLXGcGXthq+vlsW1P13D0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729161985; c=relaxed/simple;
	bh=ksJfOqZ0F+aqfgOXPTdsDbbytvSSQ9OVM/xbZDl3uy8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=syvLsPVPugca8LqI3WwD+SIj0LyTlBCfWZrHCAtn6tgmWnZeID8eH2RZep0HCxp3TC+3BdJ/bJQRMmw/XiIkJgDRbquSnbxS7NnJ55gKbIjyAM6C6suvjPNNEDWE8wAxeqnjbyyOcQBR5/E2bdEbeAcZbS3IxeUxPmTXhwXucbA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=NyNYbsHD; arc=none smtp.client-ip=91.218.175.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="NyNYbsHD"
Date: Thu, 17 Oct 2024 06:46:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1729161981;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=TuEkyXRK4a+z24nUqtPTb40oaVXyvk6oaPG3UBwJUew=;
	b=NyNYbsHDJQPkgXNY5JdRUA7Zh5I4863hzQEO7Dmv0Pc1JnNfmFBiE0GU89OHQ0JZkRtGAD
	u74yRbmA1j782KQL4lIBEySIJKlhXPHoeEHDtPRxh/nDRf/7SYcgbI4bonoeLaDIGvDsQI
	W9trTM7Iw3OYTp34mGWXyCqzAedPDsc=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Kuan-Wei Chiu <visitorckw@gmail.com>, colyli@suse.de, 
	msakai@redhat.com, corbet@lwn.net, mingo@redhat.com, acme@kernel.org, 
	namhyung@kernel.org, akpm@linux-foundation.org, mark.rutland@arm.com, 
	alexander.shishkin@linux.intel.com, jolsa@kernel.org, irogers@google.com, adrian.hunter@intel.com, 
	kan.liang@linux.intel.com, jserv@ccns.ncku.edu.tw, linux-kernel@vger.kernel.org, 
	linux-bcache@vger.kernel.org, dm-devel@lists.linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-perf-users@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH 1/3] lib/min_heap: Introduce non-inline versions of min
 heap API functions
Message-ID: <zne3invtehte3ym34ufnydtggigxazdb2ltfa26ca4tykvprls@rcawukx5hhcn>
References: <20241013184703.659652-1-visitorckw@gmail.com>
 <20241013184703.659652-2-visitorckw@gmail.com>
 <20241014081358.GS17263@noisy.programming.kicks-ass.net>
 <ZwznQzdZsg82KNT4@visitorckw-System-Product-Name>
 <xb2gihmastm3wjn2o2sufvtglvjkelhiiwhnlzoiz4qncywyga@txf4vvnyxhvu>
 <20241017095520.GV16066@noisy.programming.kicks-ass.net>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241017095520.GV16066@noisy.programming.kicks-ass.net>
X-Migadu-Flow: FLOW_OUT

On Thu, Oct 17, 2024 at 11:55:20AM +0200, Peter Zijlstra wrote:
> On Wed, Oct 16, 2024 at 11:26:30PM -0400, Kent Overstreet wrote:
> 
> > yeah, I think we would prefer smaller codesize, by default.
> > 
> > it'd be well worth checking the code size difference on inlined vs. not,
> > and then the really think to do would be to provide optional _inlined()
> > helpers that we can switch to if/when a particular codepath shows up in
> > a profile
> 
> Make sure to build with kCFI and IBT enabled when you do this and enjoy
> seeing ec_stripes_heap_cmp turn into this:

I wouldn't worry too much about the stripes heap, I'm going to replace
that with a persistent LRU.

After that it looks like the only heap left in bcachefs will be in the
clock code. Shame, they're one of my favorite data structures...

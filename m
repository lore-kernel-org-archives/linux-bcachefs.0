Received: from out-186.mta1.migadu.com (out-186.mta1.migadu.com [95.215.58.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F6FE22067
	for <linux-bcachefs@vger.kernel.org>; Sun, 19 May 2024 23:03:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716159809; cv=none; b=P8oefcOpGohq9QxsOMSmB14XXoDRsyTAIW2/Y6+Ob+mkXiT31OhsM63kDKbrr2B+DvmrgUxTg8dx7aENzwvkL2UQfDYD2lyOX22u83ey7Qas72vQf6+iyM4cbnJTbC26vbib9nKGOLMqV7juU/BrJDv5RdVQjqX/adzTZT/3LwU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716159809; c=relaxed/simple;
	bh=f+dqr7wX6Dzc+IEUgIjY13qVsDw6pGhMt1gywjtRTo8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VnL3l4myk6vUIc3TNAxznvz75Eon3LC10Q79HRtul2cKNSvfXIHVMPypXQRsPP6NBymHyPb8AoAqH/BWORpS1psHf3ChfHoWf3DkfpTK9WGb+wCZXWT2ndgQBEvl3gjw8hx+f8aoLUD5ylx1a4TYKEaIZLP2T6iAxiecbflvE3w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=f4IWLZse; arc=none smtp.client-ip=95.215.58.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="f4IWLZse"
X-Envelope-To: peterz@infradead.org
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1716159805;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+V0S8PCd3+C0VSIsGmhpI47bpGeTogzeC9Uf4DblCds=;
	b=f4IWLZseKij1P3S6iUqOHooBGx4YmH63N1gk6Db5y9+fNEwSYsB5ZWryj6CL/6Zp1k7KMO
	SXRrBiH2liO9rphAmazVFlmynGsMBvRp3AVIXqEOFxiO7bO6bM+N2G1qZd/b7Pq4BT2oX9
	y4a7bSknDHt6o0pyTN4E3oVxsZEC5y0=
X-Envelope-To: visitorckw@gmail.com
X-Envelope-To: colyli@suse.de
X-Envelope-To: msakai@redhat.com
X-Envelope-To: mingo@redhat.com
X-Envelope-To: acme@kernel.org
X-Envelope-To: namhyung@kernel.org
X-Envelope-To: akpm@linux-foundation.org
X-Envelope-To: bfoster@redhat.com
X-Envelope-To: mark.rutland@arm.com
X-Envelope-To: alexander.shishkin@linux.intel.com
X-Envelope-To: jolsa@kernel.org
X-Envelope-To: irogers@google.com
X-Envelope-To: adrian.hunter@intel.com
X-Envelope-To: bagasdotme@gmail.com
X-Envelope-To: jserv@ccns.ncku.edu.tw
X-Envelope-To: linux-bcache@vger.kernel.org
X-Envelope-To: linux-kernel@vger.kernel.org
X-Envelope-To: dm-devel@lists.linux.dev
X-Envelope-To: linux-bcachefs@vger.kernel.org
X-Envelope-To: linux-perf-users@vger.kernel.org
Date: Sun, 19 May 2024 19:03:20 -0400
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Kuan-Wei Chiu <visitorckw@gmail.com>, colyli@suse.de, 
	msakai@redhat.com, mingo@redhat.com, acme@kernel.org, namhyung@kernel.org, 
	akpm@linux-foundation.org, bfoster@redhat.com, mark.rutland@arm.com, 
	alexander.shishkin@linux.intel.com, jolsa@kernel.org, irogers@google.com, adrian.hunter@intel.com, 
	bagasdotme@gmail.com, jserv@ccns.ncku.edu.tw, linux-bcache@vger.kernel.org, 
	linux-kernel@vger.kernel.org, dm-devel@lists.linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-perf-users@vger.kernel.org
Subject: Re: [RESEND PATCH v5 11/16] lib min_heap: Update min_heap_push() and
 min_heap_pop() to return bool values
Message-ID: <tnsqm2iw2qmyll6hmgfadh6bgorpsqjjgefibg2vagopyqurjt@vrix7erg2jp7>
References: <20240514084724.557100-1-visitorckw@gmail.com>
 <20240514084724.557100-12-visitorckw@gmail.com>
 <20240515083755.GB40213@noisy.programming.kicks-ass.net>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240515083755.GB40213@noisy.programming.kicks-ass.net>
X-Migadu-Flow: FLOW_OUT

On Wed, May 15, 2024 at 10:37:55AM +0200, Peter Zijlstra wrote:
> On Tue, May 14, 2024 at 04:47:19PM +0800, Kuan-Wei Chiu wrote:
> > Modify the min_heap_push() and min_heap_pop() to return a boolean
> > value. They now return false when the operation fails and true when it
> > succeeds.
> 
> But why ?!

like Kuan said, it makes for cleaner code.

It's also what the bcache/bcachefs heap (and fifo) implementations do,
which we're consolidating.

Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E6531C28B
	for <linux-bcachefs@vger.kernel.org>; Fri, 10 Nov 2023 16:42:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="G31oroSN"
Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6909F3FAD8
	for <linux-bcachefs@vger.kernel.org>; Fri, 10 Nov 2023 08:42:54 -0800 (PST)
Date: Fri, 10 Nov 2023 11:42:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1699634572;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=X+ruubOEd64C8+Ur5Ak45sdWzu3epQLVQK2qsgpDsmc=;
	b=G31oroSN7UgpKyEhmE2kNVAuoBcrdVeHEG/XSKv0AnkmxeB9eiahE5ZHmbx2mPKGYTYdom
	75/8TN7eYY6B3K6+sxVCQqA3200+Trj6//IeJaV620Z7vYglkQbaDjMVZSBdIY6h3cPRia
	Nus/8G+N11wHXhW9+chNeP/rCjMOkN8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH 00/17] btree write buffer & journal optimizations
Message-ID: <20231110164250.aaklste6eeudhajt@moria.home.lan>
References: <20231110163157.2736111-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231110163157.2736111-1-kent.overstreet@linux.dev>
X-Migadu-Flow: FLOW_OUT

On Fri, Nov 10, 2023 at 11:31:37AM -0500, Kent Overstreet wrote:
> Large stack of changes - performance optimizations and improvements to
> related code.
> 
> The first big one, killing journal pre-reservations, is already merged:
> besides being a performance improvement it turned out to fix a few tests
> that were sporadically failing with "journal stuck" - nice. The idea
> with that patch is that instead of reserving space in the journal ahead
> of time (for journal reservations that must succeed or risk deadlock),
> we instead rely on watermarks and tracking which operations are
> necessary for reclaim - when we're low on space in the journal and
> flushing things for reclaim, we're able to flush things in order, or
> track when we're not flushing things in order and allow it to fail
> 
> Most of the other patches are prep work leading up to the big btree
> write buffer rewrite, which changes the btree write buffer to pull keys
> from the journal, instead of having the tranaction commit path directly
> add keys to the btree write buffer.
> 
> btree write buffer performance is pretty important for multithreaded
> update workloads - it's an amdahl's law situation, flushing it is single
> threaded. More performance optimizations there would still be
> worthwhile, and I've been looking at it because I'm sketching out a
> rewrite of disk space accounting (which will allow for per snapshot Id
> accounting) that will lean heavily on the btree write buffer.

Forgot to mention performance numbers -

fio, 4k random write iops, no data IO mode, checksums off (this is my
benchmark setup for just testing core bcachefs code):

		1 job		8 jobs
before		169k		645k
after		207k		798k

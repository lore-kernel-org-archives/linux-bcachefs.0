Received: from out-171.mta1.migadu.com (out-171.mta1.migadu.com [95.215.58.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFA77469D
	for <linux-bcachefs@vger.kernel.org>; Tue, 10 Dec 2024 19:31:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733859086; cv=none; b=oJxtyM21RuZa3A6vRtEPML1HsYVQnQ0vuaGSeY6u+PRPQ5IeflkgiEkFQ4bOAG+8n63qgJclXL3oHY79isvv0Tkv66YYdI2AAitrSpdzqkshj33bFkM2FGlxgujheNcLxdTpVPQF220n+FYgDxord89n2T0Lbhf41Sp3Nonydcs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733859086; c=relaxed/simple;
	bh=lwzSyy4B+wFgaaxE7qBsqud4VcX3TrWb6c1aGHSOuSo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ORF8UDaeAzoTwRUvX3X43q18MUvDQDEc3aDN4v0OxoG5T4mO0OmjJD0I1C1tGk/JnyTtXihfsX5T8i/QwREPxYbXLSIvIP1qQUWB3t/1P0+rFL7hpxRbsG4tZm0khX6a6TgXAzCvBr2wVWSYGASB1OGNSzvauhH7Kou1W90urME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=GUJU2Oq/; arc=none smtp.client-ip=95.215.58.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="GUJU2Oq/"
Date: Tue, 10 Dec 2024 14:31:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1733859081;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=oQHNPmSy/Un7BZAjZEumOVP8NRDVDFxgxPLMNKaSexg=;
	b=GUJU2Oq/N/HefXjnU09XUQaOs7oflOjeqUYv39k+LjLKpc/6p4A4r8k8L77aAb5jBvpMMK
	lRXVNHU0aF5wyHKr8X9iGfo10NvJNXQ32lvAYSglV/BX1AG4N+iJg9mKq0uccZbz2YXdN9
	L9EV6PryblEEckgFWZhIaAaF1VRTIyE=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Mark Rutland <mark.rutland@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: arm64: stacktrace: unwind exception boundaries
Message-ID: <aieiy7cowkk7ygkhpquggbkpzn5w4prlr5ujjuawpsw4re6467@iwuu4r32lr7r>
References: <36kx57aw46vwykgckr5cm4fafhw54tjuj4cqljrdnpfwvjl7if@a7znuhpfu54o>
 <zbwbgkuvvciezpmigcp6gaahfxwm7cwhpzus7gtbfnbzsjb2n3@kfbdppbd74o4>
 <Z1bWaGCvUrwrj2fZ@J2N7QTR9R3>
 <Z1gll87-TkAqFwUz@J2N7QTR9R3>
 <rxc57eg65sg4iayhj7gc7yl24w524lviedxnydl2mggqnatglq@iairj2ci7ioj>
 <Z1iT0AQqu5dqdCSg@J2N7QTR9R3>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z1iT0AQqu5dqdCSg@J2N7QTR9R3>
X-Migadu-Flow: FLOW_OUT

On Tue, Dec 10, 2024 at 07:17:36PM +0000, Mark Rutland wrote:
> On Tue, Dec 10, 2024 at 07:40:04AM -0500, Kent Overstreet wrote:
> > On Tue, Dec 10, 2024 at 11:27:19AM +0000, Mark Rutland wrote:
> > > On Mon, Dec 09, 2024 at 11:37:12AM +0000, Mark Rutland wrote:
> > > > On Thu, Dec 05, 2024 at 01:04:59PM -0500, Kent Overstreet wrote:
> 
> > > Looking some more, I see that bch2_btree_transactions_read() is trying
> > > to unwind other tasks, and I believe what's happening here is that the
> > > unwindee isn't actually blocked for the duration of the unwind, leading
> > > to the unwinder encountering junk and consequently producing the
> > > warning.
> > > 
> > > As a test case, it's possible to trigger similar with a few parallel
> > > instances of:
> > > 
> > > 	while true; do cat /proc/*/stack > /dev/null
> > > 
> > > The only thing we can do on the arm64 side is remove the WARN_ON_ONCE(),
> > > which'll get rid of the splat. It seems we've never been unlucky enough
> > > to hit a stale fgraph entry, or that would've blown up also.
> > > 
> > > Regardless of the way arm64 behaves here, the unwind performed by
> > > bch2_btree_transactions_read() is going to contain garbage unless the
> > > task is pinned in a blocked state. AFAICT the way
> > > btree_trans::locking_wait::task is used is here is racy, and there's no
> > > guarantee that the unwindee is actually blocked.
> > 
> > Occasionally returning garbage is completely fine, as long as the
> > interface is otherwise safe. This is debug info; it's important that it
> > be available and we can't impose additional synchronization for it.
> 
> Sure thing; just note that there's no guarantee that this is only
> "occasionally" garbage -- this could be wrong 1% of the time or 99% of
> the time depending on the specific scenario, HW it's running on, etc. As
> long as you're happy to hold the pieces when that happens, that's fine.
> 
> I've pushed out fixes to the arm64/stacktrace/fixes branch on my
> kernel.org git repo:
> 
>   https://git.kernel.org/pub/scm/linux/kernel/git/mark/linux.git/log/?h=arm64/stacktrace/fixes
>   git://git.kernel.org/pub/scm/linux/kernel/git/mark/linux.git arm64/stacktrace/fixes
> 
> ... and I'll get that out as a series on the list tomorrow.

Wonderful

The fact that /proc/pid/stack doesn't give anything if the process is in
TASK_RUNNING has been a problem in the past, yet this is something we're
not consistent on in the kernel; sysrq-trigger backtraces do give
backtraces for running processes (which then may require sorting through
everything).

So thanks for this :)

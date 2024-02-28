Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B2685E073
	for <linux-bcachefs@vger.kernel.org>; Wed, 28 Feb 2024 20:03:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709150594; cv=none; b=WiAvlcw/9rhNlygvlXlJA3l0teWQicsiXU+KroRBDKDK/9UNrzsnUyRteUudADRKme5J40uxg3t+sgmjb+LtqyW6MxX7q47EaE8h8IsUmwKmTGA+FGJNLIhyGQAagqVU0fo3fT4vCIkNaiQW8OnJlIo3NEzu3VBzMSejWiQWkMw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709150594; c=relaxed/simple;
	bh=96N/VsISlOry+hmvIgD+lYrXj4/LNgiLnND8t0eqyyI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ai2jXQdsfETLtcAWoGojR4x6bXglrcVFsPqBPid4E19Z7avd3H5M+3YRjV0mYPdbDbtI0xixJmj9EGCYGbetGObxXCwN4P17EHuICPoF5J+U7TzDcfo9IlzkpNMpmbXR5yZBaZluK3POtsYY2W75F2pnuv5Fme0HpTxiRK5ZmnY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=V9kEtriR; arc=none smtp.client-ip=91.218.175.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="V9kEtriR"
Date: Wed, 28 Feb 2024 15:03:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1709150589;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=tVLtku8euYOoI34C4OXIfekNcaMGomDud5CYdKG8FX4=;
	b=V9kEtriRT6rxsySe81Y7aJ4nWRyUe2La36HWy0VmpNTkr6fOOjNnLqVWehg5WdRZVRknnA
	9juKCWNQiPRKfr5PmzH85DYW3y0eUFf5GOQT4s2DmIwPA4a584waH7ETcZ0bv5NcF4S12R
	cEnPqT1GlDIq/BWsVQ8TSeT28Rja7U0=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Brian Foster <bfoster@redhat.com>
Cc: linux-bcachefs@vger.kernel.org
Subject: Re: [BUG] bcachefs fio lockup via generic/703
Message-ID: <izlhsoadddmmfyc64pc557tx3lk3vtu7ycwu3ahryh2r3o6nj5@eaqsftsh7kv3>
References: <Zd+NzotWTooA/9zq@bfoster>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zd+NzotWTooA/9zq@bfoster>
X-Migadu-Flow: FLOW_OUT

On Wed, Feb 28, 2024 at 02:47:26PM -0500, Brian Foster wrote:
> Hi Kent,
> 
> Firstly, I confirmed that today's master seems to avoid the splat I sent
> previously (re: your comment about a reverse journal replay patch or
> some such).
> 
> I still reproduce the stall issue on this system. After peeling away at
> it, I was eventually able to reproduce without the drop writes
> (dm-flakey) behavior from the test, and with fio using either the libaio
> or sync I/O engine options. The sync I/O mode fortunately provides a
> more useful stack trace:
> 
> # cat /proc/177747/stack 
> [<0>] bch2_dio_write_flush+0x122/0x160 [bcachefs]
> [<0>] bch2_direct_write+0xb53/0xce0 [bcachefs]
> [<0>] bch2_write_iter+0x142/0xc70 [bcachefs]
> [<0>] vfs_write+0x29b/0x470
> [<0>] ksys_write+0x6f/0xf0
> [<0>] do_syscall_64+0x86/0x170
> [<0>] entry_SYSCALL_64_after_hwframe+0x6e/0x76
> 
> ... which resolves down to the closure_sync() call in
> bch2_dio_write_flush(). The problem seems to go away if I remove the
> preceding journal flush from that function. This seems to rule out
> io_uring/aio and instead suggest that we're getting stuck somehow
> waiting on a journal flush.
> 
> Based on that I went back to the first commit before 746a33c96b7a0
> ("bcachefs: better journal pipelining"). With that, I can run hundreds
> of iterations of generic/703 without a problem, so this appears to be a
> regression associated with the journal pipeline improvements. I'm
> currently re-running on the last known good commit with my test tweaks
> backed out (i.e. so back to io_uring and drop writes) just to
> corroborate that it's the same problem, but so far it's running as
> expected...

So I suppose the journal must be getting stuck, and a journal write
isn't completing - what does sysfs internal/journal_debug say when it happens?

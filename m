Received: from out-175.mta1.migadu.com (out-175.mta1.migadu.com [95.215.58.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD17713D2E3
	for <linux-bcachefs@vger.kernel.org>; Wed, 28 Feb 2024 23:44:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709163846; cv=none; b=q1Cm/bnUFPKeWSUClP5snDEvE4G1sNV766/f3swy4y6aYXMraC8yySRDuv7CLAK5fFEndlqMvzkKF7TVZn7mOOYtRYcX96B2HzfOrnHVgf6F8I3rsK1LA25lZgkCvrOj7LXOCClmHG2sJuFOR5FUZkb4twtjRVdvIxD+DHYX3r8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709163846; c=relaxed/simple;
	bh=OQdtav5ZN5VXkpImRRgfdgdvax9asdTp7c5a4G5d4oI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YlPFphLY2jiYilY9jYRejUki7oqf5SW9HJXvAEKnVuCvqbeNgVpnUDWTQdtRrDgsOd1685etSCI7GPQ68B463dZVLthUK0n/tij4rb+vmRBrfY8XZFWz+lTHp86/6zUOhY4gykRI7JPaIvbLR1cJi/E0103xIBQlldrt90unKq0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=MCUu3ewM; arc=none smtp.client-ip=95.215.58.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="MCUu3ewM"
Date: Wed, 28 Feb 2024 18:43:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1709163839;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=/KnD5tsIige7OqaWrXtbpm15ibiDRsxz39Bq6uctoAM=;
	b=MCUu3ewM5+0DDtich6CQ4rD7wVQ4fouYlRqtz/2oYnLVwIfGWeNeK7mMWRrcYCdLOoWzXK
	naQgrgv3eWLmPaXwwn+TmfGPGy9goRG39A8DRd3C/E83xdsa5hsv9LXHMD+sA2uTHrTHc2
	+MUl6nFRdtv24U1f7PLGFCIwjN2D5aY=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Brian Foster <bfoster@redhat.com>
Cc: linux-bcachefs@vger.kernel.org
Subject: Re: [BUG] bcachefs fio lockup via generic/703
Message-ID: <j5yjaykxfukltyclurz5d5mtp2kzd7ctxp2kdk7tf7zm7ldm2v@jxhoqdtln453>
References: <Zd+NzotWTooA/9zq@bfoster>
 <izlhsoadddmmfyc64pc557tx3lk3vtu7ycwu3ahryh2r3o6nj5@eaqsftsh7kv3>
 <Zd+T0EeeodCXKqQt@bfoster>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zd+T0EeeodCXKqQt@bfoster>
X-Migadu-Flow: FLOW_OUT

On Wed, Feb 28, 2024 at 03:13:04PM -0500, Brian Foster wrote:
> On Wed, Feb 28, 2024 at 03:03:06PM -0500, Kent Overstreet wrote:
> > On Wed, Feb 28, 2024 at 02:47:26PM -0500, Brian Foster wrote:
> > > Hi Kent,
> > > 
> > > Firstly, I confirmed that today's master seems to avoid the splat I sent
> > > previously (re: your comment about a reverse journal replay patch or
> > > some such).
> > > 
> > > I still reproduce the stall issue on this system. After peeling away at
> > > it, I was eventually able to reproduce without the drop writes
> > > (dm-flakey) behavior from the test, and with fio using either the libaio
> > > or sync I/O engine options. The sync I/O mode fortunately provides a
> > > more useful stack trace:
> > > 
> > > # cat /proc/177747/stack 
> > > [<0>] bch2_dio_write_flush+0x122/0x160 [bcachefs]
> > > [<0>] bch2_direct_write+0xb53/0xce0 [bcachefs]
> > > [<0>] bch2_write_iter+0x142/0xc70 [bcachefs]
> > > [<0>] vfs_write+0x29b/0x470
> > > [<0>] ksys_write+0x6f/0xf0
> > > [<0>] do_syscall_64+0x86/0x170
> > > [<0>] entry_SYSCALL_64_after_hwframe+0x6e/0x76
> > > 
> > > ... which resolves down to the closure_sync() call in
> > > bch2_dio_write_flush(). The problem seems to go away if I remove the
> > > preceding journal flush from that function. This seems to rule out
> > > io_uring/aio and instead suggest that we're getting stuck somehow
> > > waiting on a journal flush.
> > > 
> > > Based on that I went back to the first commit before 746a33c96b7a0
> > > ("bcachefs: better journal pipelining"). With that, I can run hundreds
> > > of iterations of generic/703 without a problem, so this appears to be a
> > > regression associated with the journal pipeline improvements. I'm
> > > currently re-running on the last known good commit with my test tweaks
> > > backed out (i.e. so back to io_uring and drop writes) just to
> > > corroborate that it's the same problem, but so far it's running as
> > > expected...
> > 
> > So I suppose the journal must be getting stuck, and a journal write
> > isn't completing - what does sysfs internal/journal_debug say when it happens?
> > 
> 
> dirty journal entries:  0/32768
> seq:                    11
> seq_ondisk:             11
> last_seq:               12
> last_seq_ondisk:        11
> flushed_seq_ondisk:     11
> watermark:              stripe
> each entry reserved:    346
> nr flush writes:        10
> nr noflush writes:      1
> average write size:     10.9 KiB
> nr direct reclaim:      0
> nr background reclaim:  25
> reclaim kicked:         0
> reclaim runs in:        0 ms
> current entry sectors:  512
> current entry error:    ok
> current entry:          closed
> unwritten entries:
> last buf closed
> replay done:            1
> space:
>         discarded       512:244736
>         clean ondisk    512:244736
>         clean           512:244736
>         total           512:245760
> dev 0:
>         nr              480
>         bucket size     512
>         available       478:266
>         discard_idx     1
>         dirty_ondisk    1 (seq 11)
>         dirty_idx       1 (seq 11)
>         cur_idx         1 (seq 11)
> 

Can you enable closure debugging (in kconfig?) That will show
outstanding closures and info on what they're waiting on in debugfs.

bch2_dio_write_flush is doing a journal flush and waiting on it to
complete, but the journal isn't doing anything, so... lost wakeup,
perhaps?

Another thing to check for would be if we have waiters on journal_bufs
that aren't in use - maybe add some simple assertions in
journal_debug_to_text() -> journal_bufs_to_text(), if a buf isn't active
and isn't in the range that's being printed just make sure buf->wait is
NULL.

and journal_buf_to_text() doesn't seem to print out whether the waitlist
has waiters, that's an oversight...

Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC8DD620
	for <linux-bcachefs@vger.kernel.org>; Thu, 29 Feb 2024 00:02:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709164967; cv=none; b=JxmzdDtNtY2ElbJ+JxcULCTzhYe5o0mAN4GfrXsCb5IWnJ56fLAqJFWnyNMV7uTnHci/o9W79BuIpPNCv1I84WPk0ijHHM20zgL6MEp63uA9GCyIJ5x8KirEN6Df9zpq5MHVKQ+/KpVB+5BprjQ5bNZQCUYrkgUk0Hm/puz+j/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709164967; c=relaxed/simple;
	bh=tIgfmAT73We1XStI1Ns+2IyAhOLSGj9wrgqCQ+MJwhE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=W00iT6T8jS76Wk7D8YzeqT/EXBP5s5HB5AwR267SFGCqEN8YJP45lfOpE27b/Gpelp1aDXnoYXT7LDrIQ7Mt/D1Sf4jXR4muUGKTX4SzeQrIHWkxTfdIA0a4NondvR60/Wto40eC+2ecOay/9O8G5LqBPODG7i3tbhpiMCHGbXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=JhFTozgf; arc=none smtp.client-ip=91.218.175.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="JhFTozgf"
Date: Wed, 28 Feb 2024 19:02:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1709164963;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=U75c4RkOe/i2NlxXFtiZ4sRNJUr+XHJPkZvzaG+z630=;
	b=JhFTozgf+pD0LgL0rc8TIrhuOg4hRJhrBu1XNBhbeDMnvWp+58b6JMXobgulMi7mAVyQ8P
	ma6CzgMXZVbBg60cH9A1zHE4ow2hqsMoB1FMD+x7kN1rPdz4dMOsBURxY41MrsKW39HX20
	PQGZGJI037zLFIhhfblkMqwWi+mntRM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Brian Foster <bfoster@redhat.com>
Cc: linux-bcachefs@vger.kernel.org
Subject: Re: [BUG] bcachefs fio lockup via generic/703
Message-ID: <fv5nsvkc7cgl727nhyvloi6vhuvn5vbn2isg3r3mfet2t3ymry@4onepu6bzlfq>
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

I might see it - journal_last_unwritten_seq() is now wrong, it's
assuming that j->seq_ondisk + 1 hasn't been submitted yet.

bch2_journal_flush_seq_async() then sets that journal buf to "must be a
flush write", but if it's already been submitted - whoops

But your journal_debug says seq_ondisk == flushed_seq_ondisk, so maybe
that's not actually it here?

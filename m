Received: from out-187.mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F1A1481AD
	for <linux-bcachefs@vger.kernel.org>; Thu, 29 Feb 2024 02:59:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709175565; cv=none; b=Z2VkCpp48lBBlCAzeFE6w03DWEOnWiwc4ok3h5nq1cD8BLK3iflwFnsYrFLXO7T97m9NvQ3D9tW8RjWpaARInNmV57pbDVLlc/TJmpkj7tpNnGEQR3WDIg0/ihielUTKxA2V2flo6mBoHDhGMZiOhK7MeUAl+iwhHoO6LJHJDik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709175565; c=relaxed/simple;
	bh=Niu5undvn6d6N1Td0gPIAkitHL2+3fPlZIIdYDybKtg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LJnvmOzdTBv5oc6HYaXA5ZUKrqD5laK9wrCsvgJ9WIXf62TvCIX554gv2V60ZFPsHddhYXl81o2S6daoMLLO0136xiKnQr1lzYCa+x3CNQ0oJMaXXFAtWv9Szc2pGsfe1YuNEHaqNl/2sW8EGaXG2e204xC1V7Aj69hbLndpd7g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=LBS+KraF; arc=none smtp.client-ip=95.215.58.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="LBS+KraF"
Date: Wed, 28 Feb 2024 21:59:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1709175557;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9z2cKcRsz+2Zp9LYf4XM0SQ7dLeoYQgv3w/jfTDi/hE=;
	b=LBS+KraFM/IymPu/IW9kcNL/5SVrLR54d+6Naw8cSmXKdiQBENE3mO4uDtGc+4spViMEXw
	9L5CBIv7jqPskE2QGqRQRAp48+hvtCYO2IYpHUcI2CHrUXiAlvIzsaDoHafY1g7YrXy7jv
	l+K9M7rmsZF8wyjRoknAFFJer0DMwz8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Brian Foster <bfoster@redhat.com>
Cc: linux-bcachefs@vger.kernel.org
Subject: Re: [BUG] bcachefs fio lockup via generic/703
Message-ID: <h6cve56ifz6fszequog73uzgyjnalvtbdwz23kxupt4eun2ymh@anxj25u7gaf2>
References: <Zd+NzotWTooA/9zq@bfoster>
 <izlhsoadddmmfyc64pc557tx3lk3vtu7ycwu3ahryh2r3o6nj5@eaqsftsh7kv3>
 <Zd+T0EeeodCXKqQt@bfoster>
 <fv5nsvkc7cgl727nhyvloi6vhuvn5vbn2isg3r3mfet2t3ymry@4onepu6bzlfq>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fv5nsvkc7cgl727nhyvloi6vhuvn5vbn2isg3r3mfet2t3ymry@4onepu6bzlfq>
X-Migadu-Flow: FLOW_OUT

On Wed, Feb 28, 2024 at 07:02:39PM -0500, Kent Overstreet wrote:
> On Wed, Feb 28, 2024 at 03:13:04PM -0500, Brian Foster wrote:
> > On Wed, Feb 28, 2024 at 03:03:06PM -0500, Kent Overstreet wrote:
> > > On Wed, Feb 28, 2024 at 02:47:26PM -0500, Brian Foster wrote:
> > > > Hi Kent,
> > > > 
> > > > Firstly, I confirmed that today's master seems to avoid the splat I sent
> > > > previously (re: your comment about a reverse journal replay patch or
> > > > some such).
> > > > 
> > > > I still reproduce the stall issue on this system. After peeling away at
> > > > it, I was eventually able to reproduce without the drop writes
> > > > (dm-flakey) behavior from the test, and with fio using either the libaio
> > > > or sync I/O engine options. The sync I/O mode fortunately provides a
> > > > more useful stack trace:
> > > > 
> > > > # cat /proc/177747/stack 
> > > > [<0>] bch2_dio_write_flush+0x122/0x160 [bcachefs]
> > > > [<0>] bch2_direct_write+0xb53/0xce0 [bcachefs]
> > > > [<0>] bch2_write_iter+0x142/0xc70 [bcachefs]
> > > > [<0>] vfs_write+0x29b/0x470
> > > > [<0>] ksys_write+0x6f/0xf0
> > > > [<0>] do_syscall_64+0x86/0x170
> > > > [<0>] entry_SYSCALL_64_after_hwframe+0x6e/0x76
> > > > 
> > > > ... which resolves down to the closure_sync() call in
> > > > bch2_dio_write_flush(). The problem seems to go away if I remove the
> > > > preceding journal flush from that function. This seems to rule out
> > > > io_uring/aio and instead suggest that we're getting stuck somehow
> > > > waiting on a journal flush.
> > > > 
> > > > Based on that I went back to the first commit before 746a33c96b7a0
> > > > ("bcachefs: better journal pipelining"). With that, I can run hundreds
> > > > of iterations of generic/703 without a problem, so this appears to be a
> > > > regression associated with the journal pipeline improvements. I'm
> > > > currently re-running on the last known good commit with my test tweaks
> > > > backed out (i.e. so back to io_uring and drop writes) just to
> > > > corroborate that it's the same problem, but so far it's running as
> > > > expected...
> > > 
> > > So I suppose the journal must be getting stuck, and a journal write
> > > isn't completing - what does sysfs internal/journal_debug say when it happens?
> > > 
> > 
> > dirty journal entries:  0/32768
> > seq:                    11
> > seq_ondisk:             11
> > last_seq:               12
> > last_seq_ondisk:        11
> > flushed_seq_ondisk:     11
> > watermark:              stripe
> > each entry reserved:    346
> > nr flush writes:        10
> > nr noflush writes:      1
> > average write size:     10.9 KiB
> > nr direct reclaim:      0
> > nr background reclaim:  25
> > reclaim kicked:         0
> > reclaim runs in:        0 ms
> > current entry sectors:  512
> > current entry error:    ok
> > current entry:          closed
> > unwritten entries:
> > last buf closed
> > replay done:            1
> > space:
> >         discarded       512:244736
> >         clean ondisk    512:244736
> >         clean           512:244736
> >         total           512:245760
> > dev 0:
> >         nr              480
> >         bucket size     512
> >         available       478:266
> >         discard_idx     1
> >         dirty_ondisk    1 (seq 11)
> >         dirty_idx       1 (seq 11)
> >         cur_idx         1 (seq 11)
> > 
> 
> I might see it - journal_last_unwritten_seq() is now wrong, it's
> assuming that j->seq_ondisk + 1 hasn't been submitted yet.
> 
> bch2_journal_flush_seq_async() then sets that journal buf to "must be a
> flush write", but if it's already been submitted - whoops

On further reading, journal_flusH_seq_async() looks correct, but
bch2_journal_noflush_seq() was wrong - the following patch is in
-testing:


From 3c8f22258ab39992ac8a4b077610a30c733f068d Mon Sep 17 00:00:00 2001
From: Kent Overstreet <kent.overstreet@linux.dev>
Date: Wed, 28 Feb 2024 21:56:57 -0500
Subject: [PATCH] bcachefs: Fix bch2_journal_noflush_seq()

Improved journal pipelining broke journal_noflush_seq(); it implicitly
assumed only the oldest outstanding journal buf could be in flight, but
that's no longer true.

Make this more straightforward by just setting buf->must_flush whenever
we know a journal buf is going to be flush.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>

diff --git a/fs/bcachefs/journal.c b/fs/bcachefs/journal.c
index ed1724b52204..3dc1534d1d3c 100644
--- a/fs/bcachefs/journal.c
+++ b/fs/bcachefs/journal.c
@@ -715,7 +715,7 @@ int bch2_journal_flush_seq_async(struct journal *j, u64 seq,
 			return ret;
 
 		seq = res.seq;
-		buf = j->buf + (seq & JOURNAL_BUF_MASK);
+		buf = journal_seq_to_buf(j, seq);
 		buf->must_flush = true;
 
 		if (!buf->flush_time) {
@@ -733,8 +733,8 @@ int bch2_journal_flush_seq_async(struct journal *j, u64 seq,
 	}
 
 	/*
-	 * if write was kicked off without a flush, flush the next sequence
-	 * number instead
+	 * if write was kicked off without a flush, or if we promised it
+	 * wouldn't be a flush, flush the next sequence number instead
 	 */
 	buf = journal_seq_to_buf(j, seq);
 	if (buf->noflush) {
@@ -812,8 +812,8 @@ bool bch2_journal_noflush_seq(struct journal *j, u64 seq)
 	     unwritten_seq++) {
 		struct journal_buf *buf = journal_seq_to_buf(j, unwritten_seq);
 
-		/* journal write is already in flight, and was a flush write: */
-		if (unwritten_seq == journal_last_unwritten_seq(j) && !buf->noflush)
+		/* journal flush already in flight, or flush requseted */
+		if (buf->must_flush)
 			goto out;
 
 		buf->noflush = true;
diff --git a/fs/bcachefs/journal_io.c b/fs/bcachefs/journal_io.c
index 4557b5c1f7e1..77e93ad875d6 100644
--- a/fs/bcachefs/journal_io.c
+++ b/fs/bcachefs/journal_io.c
@@ -1935,6 +1935,7 @@ static int bch2_journal_write_pick_flush(struct journal *j, struct journal_buf *
 
 		j->nr_noflush_writes++;
 	} else {
+		w->must_flush = true;
 		j->last_flush_write = jiffies;
 		j->nr_flush_writes++;
 		clear_bit(JOURNAL_NEED_FLUSH_WRITE, &j->flags);

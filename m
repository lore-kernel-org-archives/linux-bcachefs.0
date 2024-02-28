Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9A763FBA7
	for <linux-bcachefs@vger.kernel.org>; Wed, 28 Feb 2024 20:11:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709151091; cv=none; b=jwg49HTnjJ6rAbDViLbE7bIiDRN0lLrX592uUQvPieprbAhMNSZUi2owXP5mwCxKDbiuRh0NCMQP/wMAzk5ey5cJU62SmQZ1WcM3VIYwzqUQq0UYG/+erG8gcNsLSlTiPjre8AYtvGYtOz0FQjWXL1TjZWrANMvd3N5C7xazIT0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709151091; c=relaxed/simple;
	bh=z9nAe/MD+ONtoRfGDu5OVu4vWPfHu+Y3qBJoXdyczJE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Yz0MYLl87ZgqGCNwf7QDLhf0sIBHuxYfCl3sAOEa7LCzU5Huu8Z8l4ip+55Pp5O4MHuyK4Beq57J1fpPYxRrqmJyBY67817iHjgC2ERMuHQOpJhHOioFYFOhhQ+sETyZcL7Aua1i2CN+d+sadtf12d5yHUAIxgmeyHR/zEGxadU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=R3xUW2J/; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="R3xUW2J/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709151085;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=n27EQJHuT5MB9CbgL0I6AtFhTvsIr6W8uYFtug7KHVg=;
	b=R3xUW2J/UviHgCeNwq96/faN+gjeqNxsAu2dswauBirC1vZt+HPS8sM0pSK9Rx45Mk2CQS
	tQEUu02Ee77NA1rTNHmlBW0x395oi6s1dKq8wg5B7hXtwZLFny4bBkfaIB0AsNDQsdG6gb
	3t4h4cgT27g4SxcQ49CERbh6YRlhnho=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-608-Uw4hegsJMUOGRBGonvs4zg-1; Wed,
 28 Feb 2024 15:11:23 -0500
X-MC-Unique: Uw4hegsJMUOGRBGonvs4zg-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2A30229ABA0C;
	Wed, 28 Feb 2024 20:11:23 +0000 (UTC)
Received: from bfoster (unknown [10.22.32.137])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 00440492BE2;
	Wed, 28 Feb 2024 20:11:22 +0000 (UTC)
Date: Wed, 28 Feb 2024 15:13:04 -0500
From: Brian Foster <bfoster@redhat.com>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: linux-bcachefs@vger.kernel.org
Subject: Re: [BUG] bcachefs fio lockup via generic/703
Message-ID: <Zd+T0EeeodCXKqQt@bfoster>
References: <Zd+NzotWTooA/9zq@bfoster>
 <izlhsoadddmmfyc64pc557tx3lk3vtu7ycwu3ahryh2r3o6nj5@eaqsftsh7kv3>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <izlhsoadddmmfyc64pc557tx3lk3vtu7ycwu3ahryh2r3o6nj5@eaqsftsh7kv3>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.10

On Wed, Feb 28, 2024 at 03:03:06PM -0500, Kent Overstreet wrote:
> On Wed, Feb 28, 2024 at 02:47:26PM -0500, Brian Foster wrote:
> > Hi Kent,
> > 
> > Firstly, I confirmed that today's master seems to avoid the splat I sent
> > previously (re: your comment about a reverse journal replay patch or
> > some such).
> > 
> > I still reproduce the stall issue on this system. After peeling away at
> > it, I was eventually able to reproduce without the drop writes
> > (dm-flakey) behavior from the test, and with fio using either the libaio
> > or sync I/O engine options. The sync I/O mode fortunately provides a
> > more useful stack trace:
> > 
> > # cat /proc/177747/stack 
> > [<0>] bch2_dio_write_flush+0x122/0x160 [bcachefs]
> > [<0>] bch2_direct_write+0xb53/0xce0 [bcachefs]
> > [<0>] bch2_write_iter+0x142/0xc70 [bcachefs]
> > [<0>] vfs_write+0x29b/0x470
> > [<0>] ksys_write+0x6f/0xf0
> > [<0>] do_syscall_64+0x86/0x170
> > [<0>] entry_SYSCALL_64_after_hwframe+0x6e/0x76
> > 
> > ... which resolves down to the closure_sync() call in
> > bch2_dio_write_flush(). The problem seems to go away if I remove the
> > preceding journal flush from that function. This seems to rule out
> > io_uring/aio and instead suggest that we're getting stuck somehow
> > waiting on a journal flush.
> > 
> > Based on that I went back to the first commit before 746a33c96b7a0
> > ("bcachefs: better journal pipelining"). With that, I can run hundreds
> > of iterations of generic/703 without a problem, so this appears to be a
> > regression associated with the journal pipeline improvements. I'm
> > currently re-running on the last known good commit with my test tweaks
> > backed out (i.e. so back to io_uring and drop writes) just to
> > corroborate that it's the same problem, but so far it's running as
> > expected...
> 
> So I suppose the journal must be getting stuck, and a journal write
> isn't completing - what does sysfs internal/journal_debug say when it happens?
> 

dirty journal entries:  0/32768
seq:                    11
seq_ondisk:             11
last_seq:               12
last_seq_ondisk:        11
flushed_seq_ondisk:     11
watermark:              stripe
each entry reserved:    346
nr flush writes:        10
nr noflush writes:      1
average write size:     10.9 KiB
nr direct reclaim:      0
nr background reclaim:  25
reclaim kicked:         0
reclaim runs in:        0 ms
current entry sectors:  512
current entry error:    ok
current entry:          closed
unwritten entries:
last buf closed
replay done:            1
space:
        discarded       512:244736
        clean ondisk    512:244736
        clean           512:244736
        total           512:245760
dev 0:
        nr              480
        bucket size     512
        available       478:266
        discard_idx     1
        dirty_ondisk    1 (seq 11)
        dirty_idx       1 (seq 11)
        cur_idx         1 (seq 11)


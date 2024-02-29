Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52C33158D8D
	for <linux-bcachefs@vger.kernel.org>; Thu, 29 Feb 2024 15:54:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709222049; cv=none; b=cFIWCuNYO9lekpk0l1Xvjvvmq2JC5buRCW6OSaG0Iyb8v7ABU2Oh04nhRoBlCnxVP7ODJ0eQMBrbo98LTpOdRirR6aQoPKZPzNm+0W7KKOLkodQoHpIC/EiJzcVDkRN3oxN35enFtuwcUW1n6Om1fCe8krb5XT7FB5ZGJkITzkU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709222049; c=relaxed/simple;
	bh=Wxly0EZf3ildG7e0m/KWGCTama69g8fh2gKlcuA3Rn0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WJF3RoLrQ8AEwNEHBBABW2q+ky6qKzKMuakYuPH9vliQx74iNsuBxOzO/w7g+/+llxBBl3XkJZlG5NHB2Qbd3b7eBolAa2q9WT77w5vn255AC1StXZyT7uVQZ9B/KrYB1DuEvZylWGYGKpKcEDaJsqklFs4qL5pHMTKPkmLpxt8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HfbFS142; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HfbFS142"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709222046;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=1LeGr2qI2Ix7ruOLt8M3tw01TGT2BZ8RDa9FZd19eDk=;
	b=HfbFS142YAENYzW91v5H5E065D9aZOsuH5RnFvAbKR+7JVKWOn2rrc8Ja1AKRiqHrj4Z97
	6c5uIxfbuX5Eyy4FewsroyfoJgSINtXNvT/JGzgiNeYxJsJgNXoEoSE4GLuZN4tN7lz28v
	VlO8ZmtM4/HgJ+bc76NTsT/kAc97jcY=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-331-PLGWnm_DNGG8_MaV0XwDFg-1; Thu,
 29 Feb 2024 10:54:04 -0500
X-MC-Unique: PLGWnm_DNGG8_MaV0XwDFg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8B141380673C;
	Thu, 29 Feb 2024 15:54:04 +0000 (UTC)
Received: from bfoster (unknown [10.22.32.137])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 64A002022AAC;
	Thu, 29 Feb 2024 15:54:04 +0000 (UTC)
Date: Thu, 29 Feb 2024 10:55:46 -0500
From: Brian Foster <bfoster@redhat.com>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: linux-bcachefs@vger.kernel.org
Subject: Re: [BUG] bcachefs fio lockup via generic/703
Message-ID: <ZeCpApARcJvDyAbf@bfoster>
References: <Zd+NzotWTooA/9zq@bfoster>
 <izlhsoadddmmfyc64pc557tx3lk3vtu7ycwu3ahryh2r3o6nj5@eaqsftsh7kv3>
 <Zd+T0EeeodCXKqQt@bfoster>
 <fv5nsvkc7cgl727nhyvloi6vhuvn5vbn2isg3r3mfet2t3ymry@4onepu6bzlfq>
 <h6cve56ifz6fszequog73uzgyjnalvtbdwz23kxupt4eun2ymh@anxj25u7gaf2>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <h6cve56ifz6fszequog73uzgyjnalvtbdwz23kxupt4eun2ymh@anxj25u7gaf2>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.4

On Wed, Feb 28, 2024 at 09:59:12PM -0500, Kent Overstreet wrote:
> On Wed, Feb 28, 2024 at 07:02:39PM -0500, Kent Overstreet wrote:
> > On Wed, Feb 28, 2024 at 03:13:04PM -0500, Brian Foster wrote:
> > > On Wed, Feb 28, 2024 at 03:03:06PM -0500, Kent Overstreet wrote:
> > > > On Wed, Feb 28, 2024 at 02:47:26PM -0500, Brian Foster wrote:
> > > > > Hi Kent,
> > > > > 
> > > > > Firstly, I confirmed that today's master seems to avoid the splat I sent
> > > > > previously (re: your comment about a reverse journal replay patch or
> > > > > some such).
> > > > > 
> > > > > I still reproduce the stall issue on this system. After peeling away at
> > > > > it, I was eventually able to reproduce without the drop writes
> > > > > (dm-flakey) behavior from the test, and with fio using either the libaio
> > > > > or sync I/O engine options. The sync I/O mode fortunately provides a
> > > > > more useful stack trace:
> > > > > 
> > > > > # cat /proc/177747/stack 
> > > > > [<0>] bch2_dio_write_flush+0x122/0x160 [bcachefs]
> > > > > [<0>] bch2_direct_write+0xb53/0xce0 [bcachefs]
> > > > > [<0>] bch2_write_iter+0x142/0xc70 [bcachefs]
> > > > > [<0>] vfs_write+0x29b/0x470
> > > > > [<0>] ksys_write+0x6f/0xf0
> > > > > [<0>] do_syscall_64+0x86/0x170
> > > > > [<0>] entry_SYSCALL_64_after_hwframe+0x6e/0x76
> > > > > 
> > > > > ... which resolves down to the closure_sync() call in
> > > > > bch2_dio_write_flush(). The problem seems to go away if I remove the
> > > > > preceding journal flush from that function. This seems to rule out
> > > > > io_uring/aio and instead suggest that we're getting stuck somehow
> > > > > waiting on a journal flush.
> > > > > 
> > > > > Based on that I went back to the first commit before 746a33c96b7a0
> > > > > ("bcachefs: better journal pipelining"). With that, I can run hundreds
> > > > > of iterations of generic/703 without a problem, so this appears to be a
> > > > > regression associated with the journal pipeline improvements. I'm
> > > > > currently re-running on the last known good commit with my test tweaks
> > > > > backed out (i.e. so back to io_uring and drop writes) just to
> > > > > corroborate that it's the same problem, but so far it's running as
> > > > > expected...
> > > > 
> > > > So I suppose the journal must be getting stuck, and a journal write
> > > > isn't completing - what does sysfs internal/journal_debug say when it happens?
> > > > 
> > > 
...
> > 
> > I might see it - journal_last_unwritten_seq() is now wrong, it's
> > assuming that j->seq_ondisk + 1 hasn't been submitted yet.
> > 
> > bch2_journal_flush_seq_async() then sets that journal buf to "must be a
> > flush write", but if it's already been submitted - whoops
> 
> On further reading, journal_flusH_seq_async() looks correct, but
> bch2_journal_noflush_seq() was wrong - the following patch is in
> -testing:
> 
...

So I can still reproduce the issue on master, which includes commit
3c8f22258ab ("bcachefs: Fix bch2_journal_noflush_seq()"). Just for
reference, the related debug info is as follows:

# cat /proc/13918/stack 
[<0>] bch2_dio_write_flush+0x15b/0x190 [bcachefs]
[<0>] bch2_direct_write+0xb75/0xd30 [bcachefs]
[<0>] bch2_write_iter+0x4c/0xf10 [bcachefs]
[<0>] vfs_write+0x29b/0x470
[<0>] ksys_write+0x6f/0xf0
[<0>] do_syscall_64+0x86/0x170
[<0>] entry_SYSCALL_64_after_hwframe+0x6e/0x76

# cat journal_debug 
dirty journal entries:  0/32768
seq:                    72
seq_ondisk:             72
last_seq:               73
last_seq_ondisk:        72
flushed_seq_ondisk:     72
watermark:              stripe
each entry reserved:    361
nr flush writes:        65
nr noflush writes:      0
average write size:     2.14 KiB
nr direct reclaim:      0
nr background reclaim:  66
reclaim kicked:         0
reclaim runs in:        0 ms
blocked:                0
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
        available       478:188
        discard_idx     1
        dirty_ondisk    1 (seq 72)
        dirty_idx       1 (seq 72)
        cur_idx         1 (seq 72)

# cat closures 
0000000044781eb9: __closure_sync+0x49/0x180 -> closure_sync_fn+0x0/0x30 p 0000000000000000 r 1 
 W bch2_journal_flush_seq_async.part.0+0xed/0x590 [bcachefs]

000000001b9a5601: bch2_fs_open+0x538/0x15e0 [bcachefs] -> 0x0 p 0000000000000000 r 1 R

Brian


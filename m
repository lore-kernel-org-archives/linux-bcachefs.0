Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAB1D16062B
	for <linux-bcachefs@vger.kernel.org>; Thu, 29 Feb 2024 16:24:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709223893; cv=none; b=NQrA147jm5qtsBSicHKRU9gw/0HvqIQ0nVajzAiReYwiszKzL6IJK/eZMpY5cNs+/SYfXcWoRXJl16olzreyR1G8yulWfKmjbUxp8ch9WJ2bQxe4/SNlroTVtO/yrMnzlxxOPVSwIbH+MIC+hWQsK5H/Sgw9MJAHtTvHQ8v7QB0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709223893; c=relaxed/simple;
	bh=HdjUQYZu1OZj2QKVKCdJixDfO99nINaRmSxA7bGFl2g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Fgq8xtmIwMdx8Vue/fWmiQVKLKeH+zyHhVF8TV4AC5dyekzEH4SjzR/qwPBrwXRKeBsnREI4mAcl5PtJdikFPqhl0jVn7Yrf7WxFMqLK6FmOT5Q44rGnLGwA8GfFz0ydA1FT3y6SID4C9sWLcREvZZxWxkw7OUbr8i4IgCsyiIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=GdEgCUql; arc=none smtp.client-ip=91.218.175.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="GdEgCUql"
Date: Thu, 29 Feb 2024 11:24:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1709223888;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Q2yi0Kq3LJ+m/+HJ0H8ANWNc5RP3umFTtcVHARSWr6o=;
	b=GdEgCUqlaE9ZWWJEzZpBBtM819YCJ4TObvqBOExjQyh+5SH2Qd1e2YuYiWj5u4s+T2bEmj
	U27ZvkBd5v16+EHO8qYqUHlP+WV8Lnj2MUYF4nJG/us0mST4poi2k5vDPHXOlwlvY4enhy
	jv8BZOFY5GkhZg+wMS0gE3a658qfs8I=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Brian Foster <bfoster@redhat.com>
Cc: linux-bcachefs@vger.kernel.org
Subject: Re: [BUG] bcachefs fio lockup via generic/703
Message-ID: <ay7pae6pkn3yg2nnopoii2iodfefi3k2ilkhd5hvtzsecctpfz@72rgb4psuqn2>
References: <Zd+NzotWTooA/9zq@bfoster>
 <izlhsoadddmmfyc64pc557tx3lk3vtu7ycwu3ahryh2r3o6nj5@eaqsftsh7kv3>
 <Zd+T0EeeodCXKqQt@bfoster>
 <fv5nsvkc7cgl727nhyvloi6vhuvn5vbn2isg3r3mfet2t3ymry@4onepu6bzlfq>
 <h6cve56ifz6fszequog73uzgyjnalvtbdwz23kxupt4eun2ymh@anxj25u7gaf2>
 <ZeCpApARcJvDyAbf@bfoster>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZeCpApARcJvDyAbf@bfoster>
X-Migadu-Flow: FLOW_OUT

On Thu, Feb 29, 2024 at 10:55:46AM -0500, Brian Foster wrote:
> So I can still reproduce the issue on master, which includes commit
> 3c8f22258ab ("bcachefs: Fix bch2_journal_noflush_seq()"). Just for
> reference, the related debug info is as follows:
> 
> # cat /proc/13918/stack 
> [<0>] bch2_dio_write_flush+0x15b/0x190 [bcachefs]
> [<0>] bch2_direct_write+0xb75/0xd30 [bcachefs]
> [<0>] bch2_write_iter+0x4c/0xf10 [bcachefs]
> [<0>] vfs_write+0x29b/0x470
> [<0>] ksys_write+0x6f/0xf0
> [<0>] do_syscall_64+0x86/0x170
> [<0>] entry_SYSCALL_64_after_hwframe+0x6e/0x76
> 
> # cat journal_debug 
> dirty journal entries:  0/32768
> seq:                    72
> seq_ondisk:             72
> last_seq:               73
> last_seq_ondisk:        72
> flushed_seq_ondisk:     72
> watermark:              stripe
> each entry reserved:    361
> nr flush writes:        65
> nr noflush writes:      0
> average write size:     2.14 KiB
> nr direct reclaim:      0
> nr background reclaim:  66
> reclaim kicked:         0
> reclaim runs in:        0 ms
> blocked:                0
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
>         available       478:188
>         discard_idx     1
>         dirty_ondisk    1 (seq 72)
>         dirty_idx       1 (seq 72)
>         cur_idx         1 (seq 72)
> 
> # cat closures 
> 0000000044781eb9: __closure_sync+0x49/0x180 -> closure_sync_fn+0x0/0x30 p 0000000000000000 r 1 
>  W bch2_journal_flush_seq_async.part.0+0xed/0x590 [bcachefs]
> 
> 000000001b9a5601: bch2_fs_open+0x538/0x15e0 [bcachefs] -> 0x0 p 0000000000000000 r 1 R

So, definitely some sort of lost wakeup, or we accidentally waited on a
journal buf that wasn't actually outstanding

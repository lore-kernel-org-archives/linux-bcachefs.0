Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05C96156C40
	for <linux-bcachefs@vger.kernel.org>; Tue, 17 Jun 2025 14:04:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750169069; cv=none; b=N09t6FnmyD5mFmnhEYrq8L6OH6JXkgM/1KkOHt2TxE87SfzULo7Xq3RqIuEj8vcVqY+asppqpyO1LEPbYwd08DVLijtevcN/fITaf2xQZcJrgAfK/krOfn9O1sTUNuuZOk5svQIRFaQLzHDtankwyqBz12qgkCrF9AsNShqaEWg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750169069; c=relaxed/simple;
	bh=MeSN08kN4iEpmRo+/LDeT4Ejqx2lIGiFxZzlCnNvRWQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=K6GCcvgUCw09eSYIkh/MreckMfFYQ2qu/H2RkN70/EN9VsisVqUu5ZlH9FGvqiam4W229aCXy9ARcXGa/Q9kyxg0Ph6d7PxSph7vw+HJS3F5I/9/JqO7Waqhluh8WI+csXV+da2SGgBIENleWgK2CkTfOTvTtpLzKJt9orvk1wY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=AiOem3tw; arc=none smtp.client-ip=91.218.175.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="AiOem3tw"
Date: Tue, 17 Jun 2025 10:04:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1750169064;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=616kP2pL78gOdvWTUN76JFu4y0HvycKB3E7Ybr5Q7ag=;
	b=AiOem3twK7OafF3Mf1wP5tNe/mWPzcf5EK99OlgWEZ2pi943LsVRX59v8wWGMe+LuZAfTr
	qy6Rtz5SXciXGxbO4KZR5TQNBEw+sqwHeoUMxKxvrJmQVQVbIunXVSfK8D6lHTVYbc2UDv
	7C4I80rr1vrl2k7k8k1sQxUqek3Q3k8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Julian Sun <sunjunchao2870@gmail.com>
Cc: linux-bcachefs@vger.kernel.org, 
	syzbot+56edda805363e0a093b8@syzkaller.appspotmail.com
Subject: Re: [PATCH] bcachefs: Return EROFS for BCH_IOCTL_DATA ioctl requests
 in ro mount mode.
Message-ID: <vigtvcnui66u4h2btagyohhsg5zvvuxmk5snidenqs353dwiwm@sxex5z7pnwkg>
References: <20250617134120.102668-1-sunjunchao2870@gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250617134120.102668-1-sunjunchao2870@gmail.com>
X-Migadu-Flow: FLOW_OUT

On Tue, Jun 17, 2025 at 09:41:20PM +0800, Julian Sun wrote:
> Recently, syzkaller reported the following issue:
> 
> BUG: kernel NULL pointer dereference, address: 0000000000000000
> Call Trace:
>  <TASK>
>  mempool_alloc_noprof+0x1a7/0x510 mm/mempool.c:402
>  bch2_btree_update_start+0x549/0x1480 fs/bcachefs/btree_update_interior.c:1194
>  bch2_btree_node_rewrite+0x17e/0x1120 fs/bcachefs/btree_update_interior.c:2208
>  bch2_move_btree+0x6f0/0xc70 fs/bcachefs/move.c:1093
>  bch2_scan_old_btree_nodes+0x95/0x240 fs/bcachefs/move.c:1215
>  bch2_data_job+0x646/0x910 fs/bcachefs/move.c:1354
>  bch2_data_thread+0x8f/0x1d0 fs/bcachefs/chardev.c:315
>  kthread+0x711/0x8a0 kernel/kthread.c:464
>  ret_from_fork+0x3fc/0x770 arch/x86/kernel/process.c:148
>  ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
> 
> This is because after commit d4d71b58e513 ("bcachefs: RO mounts now use less memory"),
> read-only mounts no longer initialize btree_interior_update_pool, which is required for
> processing BCH_IOCTL_DATA requests.

Alan already gave me a better fix for this. You pretty much never want
to just check if the filesystem is ro or rw - that would be racy, that
can change at any time. If you need the filesystem to be rw, you do it
by getting a write ref (which may fail).

Just checking SB_RDONLY here would be "technically" correct since we
only need the mempool, which is's never deallocated until filesystem
teardown, and the interior update path should get its own ref on
c->writes before doing anything serious.

But it's bad form, because then other code changes might go "ok, we've
checked that we're RW, we're safe" - but we're actually not.

And, I'm just now noticing that bch2_btree_update_start() actually does
not get a ref on c->writes, so we might want to fix that - or move.c
needs to be getting a write ref, or both.

c->writes is a percpu refcount, so it's dirt cheap, there's generally
zero downside to taking a ref even if an upper layer already has one.
The only exception is if it's an internal operation that needs to run
when we're going RO - but we have a flag for that,
BCH_TRANS_COMMIT_no_check_rw, which bch2_btree_update_start() can check.

The other consideration with write refs is that we don't want to be
holding them for an unbounded duration, because that will block going RO
- so I think bch2_ioctl_data() actually wasn't the best place for this,
we should be checking if we're RW in move.c, every time we kick off an
op.

Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F2631E9B29
	for <linux-bcachefs@vger.kernel.org>; Thu, 20 Feb 2025 20:37:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740083856; cv=none; b=KoLvck8q8qkl/39zgTemFn7J7dkrCyfulIkiHgjAkUljk33bL8ay0O1xxiBkfutrhQ4Rnl4Cc1Xm9Iu7sY3NMIxJ4CWvRLW3MUcFjmwewR5NL0H9t2ERdcRC+54ovioLWfoyNCCsiqOZOHLLwN+E8YZhQW5gnKsD2aCECG5ALF4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740083856; c=relaxed/simple;
	bh=Ygn/vx52ahFkSSo0reHFNthwr17rLllQAybhgtsxHzk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aM2zv9epG5AzFTfAHgOwG2yAZ90lTdx35CLaKzmRUdGPALgnA5WNS5Cx7rxTTn2jfXOp10Pa0QAxnAu17Vp37hx3kjJKU7OaQildZXdD/O2PO6TV+Y/jcu9rc5X9ENZUTUdwD2l3pwY6xImMZVMEMfD/ZOy/ubyI9ZLoTp+Tfow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=kK72U8kj; arc=none smtp.client-ip=91.218.175.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="kK72U8kj"
Date: Thu, 20 Feb 2025 15:37:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1740083851;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=NzQmdn3Jk+AmM1L7Qreqx98YTpwYbDt8ekO/n2uIRww=;
	b=kK72U8kj9C8IF5jtTLPzMID9GwNF/c0+AljB1Z7H97Be8YjGyckYRiWbSRGfNM0cnsl2NV
	1q7P5mhmvVacRWAfBFZ3d8NpWQ2HRUg7rhUqZJ46AUGUZP6OSXhvhmKRFj846U2c/wOa98
	96ajPFvc+7iMnZEG7Utp95tF6ovrUi0=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Alan Huang <mmpgouride@gmail.com>, linux-bcachefs@vger.kernel.org, 
	syzbot+fe63f377148a6371a9db@syzkaller.appspotmail.com, linux-mm@kvack.org, Tejun Heo <tj@kernel.org>, 
	Dennis Zhou <dennis@kernel.org>, Christoph Lameter <cl@linux.com>, 
	Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH] bcachefs: Use alloc_percpu_gfp to avoid deadlock
Message-ID: <fld5gkrscoialgpgfrsdig6grx4bbjeaevub4ii7mh234ejhi6@adwkhlzfpvwp>
References: <20250212100625.55860-1-mmpgouride@gmail.com>
 <issmt55cogzyglrmao7hmqdbhvu7n6eii625ydm4irktfkfnrp@wtdbg42tumpr>
 <25FBAAE5-8BC6-41F3-9A6D-65911BA5A5D7@gmail.com>
 <78d954b5-e33f-4bbc-855b-e91e96278bef@suse.cz>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <78d954b5-e33f-4bbc-855b-e91e96278bef@suse.cz>
X-Migadu-Flow: FLOW_OUT

On Thu, Feb 20, 2025 at 06:16:43PM +0100, Vlastimil Babka wrote:
> On 2/20/25 11:57, Alan Huang wrote:
> > Ping
> > 
> >> On Feb 12, 2025, at 22:27, Kent Overstreet <kent.overstreet@linux.dev> wrote:
> >> 
> >> Adding pcpu people to the CC
> >> 
> >> On Wed, Feb 12, 2025 at 06:06:25PM +0800, Alan Huang wrote:
> >>> The cycle:
> >>> 
> >>> CPU0: CPU1:
> >>> bc->lock pcpu_alloc_mutex
> >>> pcpu_alloc_mutex bc->lock
> >>> 
> >>> Reported-by: syzbot+fe63f377148a6371a9db@syzkaller.appspotmail.com
> >>> Tested-by: syzbot+fe63f377148a6371a9db@syzkaller.appspotmail.com
> >>> Signed-off-by: Alan Huang <mmpgouride@gmail.com>
> >> 
> >> So pcpu_alloc_mutex -> fs_reclaim?
> >> 
> >> That's really awkward; seems like something that might invite more
> >> issues. We can apply your fix if we need to, but I want to hear with the
> >> percpu people have to say first.
> >> 
> >> ======================================================
> >> WARNING: possible circular locking dependency detected
> >> 6.14.0-rc2-syzkaller-00039-g09fbf3d50205 #0 Not tainted
> >> ------------------------------------------------------
> >> syz.0.21/5625 is trying to acquire lock:
> >> ffffffff8ea19608 (pcpu_alloc_mutex){+.+.}-{4:4}, at: pcpu_alloc_noprof+0x293/0x1760 mm/percpu.c:1782
> >> 
> >> but task is already holding lock:
> >> ffff888051401c68 (&bc->lock){+.+.}-{4:4}, at: bch2_btree_node_mem_alloc+0x559/0x16f0 fs/bcachefs/btree_cache.c:804
> >> 
> >> which lock already depends on the new lock.
> >> 
> >> 
> >> the existing dependency chain (in reverse order) is:
> >> 
> >> -> #2 (&bc->lock){+.+.}-{4:4}:
> >>       lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5851
> >>       __mutex_lock_common kernel/locking/mutex.c:585 [inline]
> >>       __mutex_lock+0x19c/0x1010 kernel/locking/mutex.c:730
> >>       bch2_btree_cache_scan+0x184/0xec0 fs/bcachefs/btree_cache.c:482
> >>       do_shrink_slab+0x72d/0x1160 mm/shrinker.c:437
> >>       shrink_slab+0x1093/0x14d0 mm/shrinker.c:664
> >>       shrink_one+0x43b/0x850 mm/vmscan.c:4868
> >>       shrink_many mm/vmscan.c:4929 [inline]
> >>       lru_gen_shrink_node mm/vmscan.c:5007 [inline]
> >>       shrink_node+0x37c5/0x3e50 mm/vmscan.c:5978
> >>       kswapd_shrink_node mm/vmscan.c:6807 [inline]
> >>       balance_pgdat mm/vmscan.c:6999 [inline]
> >>       kswapd+0x20f3/0x3b10 mm/vmscan.c:7264
> >>       kthread+0x7a9/0x920 kernel/kthread.c:464
> >>       ret_from_fork+0x4b/0x80 arch/x86/kernel/process.c:148
> >>       ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244
> >> 
> >> -> #1 (fs_reclaim){+.+.}-{0:0}:
> >>       lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5851
> >>       __fs_reclaim_acquire mm/page_alloc.c:3853 [inline]
> >>       fs_reclaim_acquire+0x88/0x130 mm/page_alloc.c:3867
> >>       might_alloc include/linux/sched/mm.h:318 [inline]
> >>       slab_pre_alloc_hook mm/slub.c:4066 [inline]
> >>       slab_alloc_node mm/slub.c:4144 [inline]
> >>       __do_kmalloc_node mm/slub.c:4293 [inline]
> >>       __kmalloc_noprof+0xae/0x4c0 mm/slub.c:4306
> >>       kmalloc_noprof include/linux/slab.h:905 [inline]
> >>       kzalloc_noprof include/linux/slab.h:1037 [inline]
> >>       pcpu_mem_zalloc mm/percpu.c:510 [inline]
> >>       pcpu_alloc_chunk mm/percpu.c:1430 [inline]
> >>       pcpu_create_chunk+0x57/0xbc0 mm/percpu-vm.c:338
> >>       pcpu_balance_populated mm/percpu.c:2063 [inline]
> >>       pcpu_balance_workfn+0xc4d/0xd40 mm/percpu.c:2200
> >>       process_one_work kernel/workqueue.c:3236 [inline]
> >>       process_scheduled_works+0xa66/0x1840 kernel/workqueue.c:3317
> >>       worker_thread+0x870/0xd30 kernel/workqueue.c:3398
> >>       kthread+0x7a9/0x920 kernel/kthread.c:464
> >>       ret_from_fork+0x4b/0x80 arch/x86/kernel/process.c:148
> >>       ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244
> 
> Seeing this as part of the chain (fs reclaim from a worker doing
> pcpu_balance_workfn) makes me think Michal's patch could be a fix to this:
> 
> https://lore.kernel.org/all/20250206122633.167896-1-mhocko@kernel.org/

Thanks for the link - that does look like just the thing.

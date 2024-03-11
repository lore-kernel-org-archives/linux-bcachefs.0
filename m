Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E936915A5
	for <linux-bcachefs@vger.kernel.org>; Mon, 11 Mar 2024 03:35:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710128131; cv=none; b=f4iJ1ILevf09tMSiq5lkkg9OFAdBu9eAcuHdrePsEiJ4nl+fQjrnGL9n29gGJ5IEBPH4bMWCpt/Vu95dyHDw8RFBbcEdbg1nnOWR40+xoLuiRivYP/0mXXKn/o1lIPreDAVyJJ7VHiRCFjp0K/2GKVJgLa8w7oGY+NGsc2mF0hY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710128131; c=relaxed/simple;
	bh=rQPC3ljuqSHd1yxLiJsEstsDgdMOLjzQNBFFvjeiMiE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=r1YE2KBngXcRcCoDseoiqZ1cwJ6N7SqWYaKIlGsPslcgMu3saZWMuyUEaKBPFOY5Cq+AhqskKf6NawD04rEK7QKR+WE76UZ34tbC7pOYL3ykmN7Vo2i/oT5Rbnavh7DUhqtL3WRWBe3dfF0MQ4PsWSecYtfBBiKWSj7w6ZzWa/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=CWm1W0dw; arc=none smtp.client-ip=91.218.175.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="CWm1W0dw"
Date: Sun, 10 Mar 2024 23:35:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1710128125;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=TQk1USS3WlvgEXRdrRHfx2AP3E/smtnwUA4hb+WcKIk=;
	b=CWm1W0dwljTaK9zgze8izrt8MzOSNVD8JClc8KIppwQYOJenuSu/HTOnB7Ib02LrrnGGm8
	FbgVIspmgYavqdMv/bkTeQvdnBb7QHxpR+TN23XXUPCDuJPzTGeDDQ50Huhsuz6I41KE1D
	15Sqq/jR9riFOtB4xsnOhgfliO7Pa6Q=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Alec Moskvin <list.bcachefs@e.netreq.com>
Cc: linux-bcachefs@vger.kernel.org
Subject: Re: Kernel WARNING in get_page_from_freelist on Linux 6.7.9
Message-ID: <pbh5ylxkijypqeskpx3xylup2ompfkgc3kqecxuza7s7dwoc2h@thtmglxkhf22>
References: <20240309160907.GA3229@haswell>
 <enefmzphksyx3nclbgf4imddmgoaxzwbpcj5esihmdewv4fqvh@rjil5nzhtwuf>
 <20240311031717.GA277036@haswell>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240311031717.GA277036@haswell>
X-Migadu-Flow: FLOW_OUT

On Sun, Mar 10, 2024 at 11:17:17PM -0400, Alec Moskvin wrote:
> Hi Kent,
> 
> On Saturday 09 March 2024 12:11:24 EST, Kent Overstreet wrote:
> > this was a __GFP_NOFAIL use or two we needed to get rid of - it's fixed
> > in 6.8.
> 
> I got the same warning but with a different stack trace on 6.8:
> 
> [ 4574.388472] ------------[ cut here ]------------
> [ 4574.388479] WARNING: CPU: 7 PID: 127738 at mm/page_alloc.c:2896 get_page_from_freelist+0x9a2/0xcf0
> [ 4574.388488] CPU: 7 PID: 127738 Comm: kworker/u16:14 Not tainted 6.8.0 #165
> [ 4574.388491] Hardware name: Gigabyte Technology Co., Ltd. H97-D3H/H97-D3H-CF, BIOS F6 04/21/2015
> [ 4574.388493] Workqueue: writeback wb_workfn (flush-bcachefs-1)
> [ 4574.388499] RIP: 0010:get_page_from_freelist+0x9a2/0xcf0
> [ 4574.388503] Code: 0f 84 9f fc ff ff 48 8b 44 24 08 f7 44 24 54 00 80 00 00 8b 40 18 89 44 24 24 0f 84 bc f7 ff ff 41 83 ff 01 0f 86 b0 fa ff ff <0f> 0b e9 ab f7 ff ff 44 89 e6 e8 ff 46 fc ff 48 89 44 24 18 e9 8c
> [ 4574.388506] RSP: 0000:ffff922aa2cd38a0 EFLAGS: 00010202
> [ 4574.388509] RAX: 0000000000000000 RBX: 0000000000000101 RCX: 0000000000000002
> [ 4574.388511] RDX: 0000000000000001 RSI: ffffffff9d5cae10 RDI: ffffffff9d5cacc0
> [ 4574.388513] RBP: 0000000000458b96 R08: 0000000000000000 R09: ffffccda45b86c08
> [ 4574.388515] R10: 0000000000000002 R11: 0000000000000000 R12: 0000000000000002
> [ 4574.388517] R13: ffffffff9d5cacc0 R14: 3e000000007fffff R15: 0000000000000002
> [ 4574.388519] FS:  0000000000000000(0000) GS:ffff8fbcbddc0000(0000) knlGS:0000000000000000
> [ 4574.388521] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [ 4574.388524] CR2: 00007fa3acd3e000 CR3: 000000050a2d4004 CR4: 00000000001706f0
> [ 4574.388526] Call Trace:
> [ 4574.388529]  <TASK>
> [ 4574.388531]  ? __warn+0x66/0xc0
> [ 4574.388535]  ? get_page_from_freelist+0x9a2/0xcf0
> [ 4574.388538]  ? report_bug+0x166/0x1b0
> [ 4574.388542]  ? handle_bug+0x3c/0x70
> [ 4574.388545]  ? exc_invalid_op+0x17/0x70
> [ 4574.388548]  ? asm_exc_invalid_op+0x1a/0x20
> [ 4574.388553]  ? get_page_from_freelist+0x9a2/0xcf0
> [ 4574.388555]  ? bch2_btree_node_upgrade+0x48/0x2f0
> [ 4574.388560]  __alloc_pages+0x158/0x240
> [ 4574.388563]  __kmalloc_large_node+0x6a/0x130
> [ 4574.388566]  __bch2_writepage+0x68e/0x7b0
> [ 4574.388570]  ? folio_clear_dirty_for_io+0x113/0x180
> [ 4574.388574]  write_cache_pages+0x168/0x350
> [ 4574.388576]  ? bch2_readpages_end_io+0x240/0x240
> [ 4574.388579]  bch2_writepages+0x57/0xb0
> [ 4574.388583]  do_writepages+0xba/0x180
> [ 4574.388586]  __writeback_single_inode+0x2a/0x190
> [ 4574.388588]  writeback_sb_inodes+0x1d2/0x420
> [ 4574.388591]  __writeback_inodes_wb+0x47/0xd0
> [ 4574.388593]  wb_writeback.isra.0+0x150/0x1a0
> [ 4574.388596]  wb_workfn+0x269/0x370
> [ 4574.388598]  ? __schedule+0x2cd/0x11c0
> [ 4574.388600]  ? drm_sched_job_cleanup+0xd3/0x120
> [ 4574.388604]  process_one_work+0x12d/0x240
> [ 4574.388609]  worker_thread+0x2e8/0x400
> [ 4574.388612]  ? rescuer_thread+0x3f0/0x3f0
> [ 4574.388615]  kthread+0xcb/0xf0
> [ 4574.388619]  ? kthread_complete_and_exit+0x20/0x20
> [ 4574.388622]  ret_from_fork+0x2f/0x50
> [ 4574.388625]  ? kthread_complete_and_exit+0x20/0x20
> [ 4574.388628]  ret_from_fork_asm+0x11/0x20
> [ 4574.388631]  </TASK>
> [ 4574.388633] ---[ end trace 0000000000000000 ]---

Turns out, bch_folio_sector was 4 bytes, not 2, causing us to exceed the
8k limit. Thanks, fix will be out soon.

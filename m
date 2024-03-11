Received: from mail-108-mta104.mxroute.com (mail-108-mta104.mxroute.com [136.175.108.104])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E6991388
	for <linux-bcachefs@vger.kernel.org>; Mon, 11 Mar 2024 03:22:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=136.175.108.104
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710127355; cv=none; b=gukfGQ7l7CIIphZNepbruHQn/dy5UQw8cco7e/U/rXD0IKvu5sRGI8D0LyLjnhc/ADVyEC5z+j5EjGMszG5L2hZNbkZeDn+DAGAH5pMNsWvHblRHEtTA2B1LMKUGbyYnyOopbb5aQoBZfGS+e3UjUejfIknMJ8MKM1h1nu8oHJY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710127355; c=relaxed/simple;
	bh=8f0VSNWsrEFTnIxUbpXZjKlovxeXN9HJ6QiAuwWmWo4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=S3m21B1u3FW99dcthryhGs8ZbcS7+SNY7oYkdRwxyfWI1gHCJRaEBY9hNmn2AzyiR34on2cxul1Qmt+tQvcw45FJmXlKRMsKr4jWQ7Fo3UXYmsxInojNichrnMu5FcsBrrzf4mNHqcdnipr8R6kk+1rrThTCfnsc6Qccc0gX6aA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=e.netreq.com; spf=pass smtp.mailfrom=e.netreq.com; dkim=temperror (0-bit key) header.d=e.netreq.com header.i=@e.netreq.com header.b=lzJU1TwZ; arc=none smtp.client-ip=136.175.108.104
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=e.netreq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=e.netreq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=temperror (0-bit key) header.d=e.netreq.com header.i=@e.netreq.com header.b="lzJU1TwZ"
Received: from filter006.mxroute.com ([136.175.111.2] filter006.mxroute.com)
 (Authenticated sender: mN4UYu2MZsgR)
 by mail-108-mta104.mxroute.com (ZoneMTA) with ESMTPSA id 18e2b83c7b40003bea.002
 for <linux-bcachefs@vger.kernel.org>
 (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384);
 Mon, 11 Mar 2024 03:17:20 +0000
X-Zone-Loop: 50cf145347ae137b552c5e1e1841d5d9f949d68ba7fb
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=e.netreq.com; s=x; h=In-Reply-To:Content-Type:MIME-Version:References:
	Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=hJFNtXu0DN9vD/ZSfAyFHYFM88mG5jRk4RJeIAzpRuo=; b=lzJU1TwZExksU8Cq5+zpB5Jt0P
	VeimVZ6+N36n53WNLJv7yejnNZS8F1CKixazzzyBHuwYlxIIp56ExQroh28X7vE6tkaPfV6Mw1QnY
	QS833+5VUwgUGcwvrqcKHQlSRES9qtcEDk+VWbvB9b45lxdYKK+NWkH4bYNZjHTXm/j2dx/afFcWL
	TtMKzjO5bD0V+QO3VCV1bzsHxTs3eqFlb3d89jlO5MQP4rhtXmFur2T4CmsurYca+qCSgvBEZl3dd
	VtZ0dfVn65yVhXDa7rxujC3eRBBECtDfY/WyQ0XFUivjUU6aSZpSo07r0Lrg06gYSfLNvP4c1dXCP
	1oAGM1Dw==;
Date: Sun, 10 Mar 2024 23:17:17 -0400
From: Alec Moskvin <list.bcachefs@e.netreq.com>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: linux-bcachefs@vger.kernel.org
Subject: Re: Kernel WARNING in get_page_from_freelist on Linux 6.7.9
Message-ID: <20240311031717.GA277036@haswell>
References: <20240309160907.GA3229@haswell>
 <enefmzphksyx3nclbgf4imddmgoaxzwbpcj5esihmdewv4fqvh@rjil5nzhtwuf>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <enefmzphksyx3nclbgf4imddmgoaxzwbpcj5esihmdewv4fqvh@rjil5nzhtwuf>
User-Agent: Mutt/2.2.12 (2023-09-09)
X-Authenticated-Id: alec@netreq.com

Hi Kent,

On Saturday 09 March 2024 12:11:24 EST, Kent Overstreet wrote:
> this was a __GFP_NOFAIL use or two we needed to get rid of - it's fixed
> in 6.8.

I got the same warning but with a different stack trace on 6.8:

[ 4574.388472] ------------[ cut here ]------------
[ 4574.388479] WARNING: CPU: 7 PID: 127738 at mm/page_alloc.c:2896 get_page_from_freelist+0x9a2/0xcf0
[ 4574.388488] CPU: 7 PID: 127738 Comm: kworker/u16:14 Not tainted 6.8.0 #165
[ 4574.388491] Hardware name: Gigabyte Technology Co., Ltd. H97-D3H/H97-D3H-CF, BIOS F6 04/21/2015
[ 4574.388493] Workqueue: writeback wb_workfn (flush-bcachefs-1)
[ 4574.388499] RIP: 0010:get_page_from_freelist+0x9a2/0xcf0
[ 4574.388503] Code: 0f 84 9f fc ff ff 48 8b 44 24 08 f7 44 24 54 00 80 00 00 8b 40 18 89 44 24 24 0f 84 bc f7 ff ff 41 83 ff 01 0f 86 b0 fa ff ff <0f> 0b e9 ab f7 ff ff 44 89 e6 e8 ff 46 fc ff 48 89 44 24 18 e9 8c
[ 4574.388506] RSP: 0000:ffff922aa2cd38a0 EFLAGS: 00010202
[ 4574.388509] RAX: 0000000000000000 RBX: 0000000000000101 RCX: 0000000000000002
[ 4574.388511] RDX: 0000000000000001 RSI: ffffffff9d5cae10 RDI: ffffffff9d5cacc0
[ 4574.388513] RBP: 0000000000458b96 R08: 0000000000000000 R09: ffffccda45b86c08
[ 4574.388515] R10: 0000000000000002 R11: 0000000000000000 R12: 0000000000000002
[ 4574.388517] R13: ffffffff9d5cacc0 R14: 3e000000007fffff R15: 0000000000000002
[ 4574.388519] FS:  0000000000000000(0000) GS:ffff8fbcbddc0000(0000) knlGS:0000000000000000
[ 4574.388521] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 4574.388524] CR2: 00007fa3acd3e000 CR3: 000000050a2d4004 CR4: 00000000001706f0
[ 4574.388526] Call Trace:
[ 4574.388529]  <TASK>
[ 4574.388531]  ? __warn+0x66/0xc0
[ 4574.388535]  ? get_page_from_freelist+0x9a2/0xcf0
[ 4574.388538]  ? report_bug+0x166/0x1b0
[ 4574.388542]  ? handle_bug+0x3c/0x70
[ 4574.388545]  ? exc_invalid_op+0x17/0x70
[ 4574.388548]  ? asm_exc_invalid_op+0x1a/0x20
[ 4574.388553]  ? get_page_from_freelist+0x9a2/0xcf0
[ 4574.388555]  ? bch2_btree_node_upgrade+0x48/0x2f0
[ 4574.388560]  __alloc_pages+0x158/0x240
[ 4574.388563]  __kmalloc_large_node+0x6a/0x130
[ 4574.388566]  __bch2_writepage+0x68e/0x7b0
[ 4574.388570]  ? folio_clear_dirty_for_io+0x113/0x180
[ 4574.388574]  write_cache_pages+0x168/0x350
[ 4574.388576]  ? bch2_readpages_end_io+0x240/0x240
[ 4574.388579]  bch2_writepages+0x57/0xb0
[ 4574.388583]  do_writepages+0xba/0x180
[ 4574.388586]  __writeback_single_inode+0x2a/0x190
[ 4574.388588]  writeback_sb_inodes+0x1d2/0x420
[ 4574.388591]  __writeback_inodes_wb+0x47/0xd0
[ 4574.388593]  wb_writeback.isra.0+0x150/0x1a0
[ 4574.388596]  wb_workfn+0x269/0x370
[ 4574.388598]  ? __schedule+0x2cd/0x11c0
[ 4574.388600]  ? drm_sched_job_cleanup+0xd3/0x120
[ 4574.388604]  process_one_work+0x12d/0x240
[ 4574.388609]  worker_thread+0x2e8/0x400
[ 4574.388612]  ? rescuer_thread+0x3f0/0x3f0
[ 4574.388615]  kthread+0xcb/0xf0
[ 4574.388619]  ? kthread_complete_and_exit+0x20/0x20
[ 4574.388622]  ret_from_fork+0x2f/0x50
[ 4574.388625]  ? kthread_complete_and_exit+0x20/0x20
[ 4574.388628]  ret_from_fork_asm+0x11/0x20
[ 4574.388631]  </TASK>
[ 4574.388633] ---[ end trace 0000000000000000 ]---

Thanks,
Alec

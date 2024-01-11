Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1F1F19C
	for <linux-bcachefs@vger.kernel.org>; Thu, 11 Jan 2024 02:38:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="VQ/Gzw04"
Date: Wed, 10 Jan 2024 21:38:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1704940701;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9OnZBpdG9bOW8XLUaCBZabNj/tKnIUMV0rVnm5KFKXY=;
	b=VQ/Gzw04/W0DC/aZk2TVzGCAqq1yb5WRa4tcruimhCHsUABnYKLSvioHgVBQZy+6VY76fJ
	xLDPgODgdtuyS4OXXBmG8LVi2zQiIRVFqkPqYL5q27n25x5pbsVgcEV/LvtwEJjxpxuBt1
	WdvMuTTdOEX3baNYGQryYG14vG9UwWQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Su Yue <glass.su@suse.com>
Cc: linux-bcachefs@vger.kernel.org, l@damenly.org, bfoster@redhat.com
Subject: Re: [PATCH v3] bcachefs: fix memleak in bch2_split_devs
Message-ID: <5szfx5gdtviiupizdk6nkskircggnxpimo3dhimdqs4g6bh4vm@56lrt5hjs33k>
References: <20240108151108.1115630-1-glass.su@suse.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240108151108.1115630-1-glass.su@suse.com>
X-Migadu-Flow: FLOW_OUT

On Mon, Jan 08, 2024 at 11:11:08PM +0800, Su Yue wrote:
> The pointer dev_name can be modified by strseq(),
> then causes the memleak:
> 
> unreferenced object 0xffff9d08a2916c80 (size 32):
>   comm "mount.bcachefs", pid 9090, jiffies 4295856224 (age 17.564s)
>   hex dump (first 32 bytes):
>     2f 64 65 76 2f 6d 61 70 70 65 72 2f 74 65 73 74  /dev/mapper/test
>     2d 30 00 00 00 00 00 00 00 00 00 00 00 00 00 00  -0..............
>   backtrace:
>     [<00000000c5d3be7d>] __kmem_cache_alloc_node+0x1f3/0x2c0
>     [<0000000052215d26>] __kmalloc_node_track_caller+0x51/0x150
>     [<0000000069fea956>] kstrdup+0x32/0x60
>     [<000000000877fcf1>] bch2_split_devs+0x3f/0x150 [bcachefs]
>     [<000000007ee93204>] bch2_mount+0xcb/0x640 [bcachefs]
>     [<000000002dd1e04b>] legacy_get_tree+0x30/0x60
>     [<000000006afc31d3>] vfs_get_tree+0x28/0xf0
>     [<000000007b0c538e>] path_mount+0x475/0xb60
>     [<0000000092de5882>] __x64_sys_mount+0x105/0x140
>     [<0000000054fc05d8>] do_syscall_64+0x42/0xf0
>     [<00000000df584910>] entry_SYSCALL_64_after_hwframe+0x6e/0x76
> 
> Fix it by copy pointer dev_name at beginning and free the copied
> pointer at end.
> 
> Signed-off-by: Su Yue <glass.su@suse.com>

Thanks, applied :)

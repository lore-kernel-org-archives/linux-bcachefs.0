Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64B8F1F957
	for <linux-bcachefs@vger.kernel.org>; Sat, 21 Sep 2024 18:47:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726944455; cv=none; b=SrFynVnZR1dGItbn4lqgcEaNHlrGBRmJUJHukcY4cJ/cYQfrAtUNJeYgNvD6UzAf2BqiFc4w2658UouyGClpCuWm1wLuyR7K8FxN1tVp3SMGJATkakwRWpnGMVJXNBdciBBT2M1wVN/MZrsbMHB8yNMkVhPaxSRkK3rFh1RhofI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726944455; c=relaxed/simple;
	bh=7cfx5tCkGc7zfwaJh93vtOWLZ3JbMAGGKDDBGOj2Gqo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hNYZgKUZAUww+3bGO8nQx8MECTneiENgZUAFLEFP/GT2YuKsez/JFHBnQQ8yhzXAw+UnAApUfFejDUD/5KVJe+bH14v2KTVPwNuaH6of4ylcdTKSs3sjwaPJhdQm1aUDH7EtQ2gx2g5OKxk/oVPR678Xbxt7jdVm/8w0tPqza+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=r0NeH4Vv; arc=none smtp.client-ip=91.218.175.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="r0NeH4Vv"
Date: Sat, 21 Sep 2024 14:47:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1726944450;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Rvxa6KYGFv8Y/A02rpKkgoV4akVO6+7XDKnGOTjf4RE=;
	b=r0NeH4Vv6USFHMMStmcpvTQ/Svq6l96NGHnNJJtTda3M2RmB/nApkPkgv//SUaOLu5/fqs
	fo9tH9j6YBjdX90+J/8rAkPPUm2udrs1AIBIsJ9uAqsAQPg07K4KUmOxXdwsuryI+tWkzf
	M54vh8ZsEbKBDIMtVc+dbUwca1DRP6M=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Piotr Zalewski <pZ010001011111@proton.me>
Cc: linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	skhan@linuxfoundation.org
Subject: Re: [PATCH] bcachefs: add GFP_ZERO flag in btree_bounce_alloc
Message-ID: <frpohbqgpyhd6fkwkd5h6efqiph27mgmcbex3bipmksyc2vocp@tfz6oynigmgi>
References: <20240916224746.692973-1-pZ010001011111@proton.me>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240916224746.692973-1-pZ010001011111@proton.me>
X-Migadu-Flow: FLOW_OUT

On Mon, Sep 16, 2024 at 10:47:57PM GMT, Piotr Zalewski wrote:
> Add __GFP_ZERO flag to kvmalloc call in btree_bounce_alloc to mitigate
> later uinit-value use KMSAN warning[1].
> 
> After applying the patch reproducer still triggers stack overflow[2] but
> it seems unrelated to the uninit-value use warning. After further
> investigation it was found that stack overflow occurs because KMSAN adds
> additional function calls. Backtrace of where the stack magic number gets 
> smashed was added as a reply to syzkaller thread[3].
> 
> I confirmed that task's stack magic number gets smashed after the code path
> where KSMAN detects uninit-value use is executed, so it can be assumed that
> it doesn't contribute in any way to uninit-value use detection.
> 
> [1] https://syzkaller.appspot.com/bug?extid=6f655a60d3244d0c6718
> [2] https://lore.kernel.org/lkml/66e57e46.050a0220.115905.0002.GAE@google.com
> [3] https://lore.kernel.org/all/rVaWgPULej8K7HqMPNIu8kVNyXNjjCiTB-QBtItLFBmk0alH6fV2tk4joVPk97Evnuv4ZRDd8HB5uDCkiFG6u81xKdzDj-KrtIMJSlF6Kt8=@proton.me
> 
> Signed-off-by: Piotr Zalewski <pZ010001011111@proton.me>

Oh hey, nice find :)

We should be able to fix this in a more performant way, though; btree
node resort is a path where we do care about performance, we don't want
to touch the whole buffer more times than necessary.

Can you try zeroing out the portion after what we consumed, after we
sort into the bounce buffer?

> ---
>  fs/bcachefs/btree_io.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/bcachefs/btree_io.c b/fs/bcachefs/btree_io.c
> index 56ea9a77cd4a..3ac8b37f97d7 100644
> --- a/fs/bcachefs/btree_io.c
> +++ b/fs/bcachefs/btree_io.c
> @@ -121,7 +121,7 @@ static void *btree_bounce_alloc(struct bch_fs *c, size_t size,
>  	BUG_ON(size > c->opts.btree_node_size);
>  
>  	*used_mempool = false;
> -	p = kvmalloc(size, __GFP_NOWARN|GFP_NOWAIT);
> +	p = kvmalloc(size, __GFP_ZERO|__GFP_NOWARN|GFP_NOWAIT);
>  	if (!p) {
>  		*used_mempool = true;
>  		p = mempool_alloc(&c->btree_bounce_pool, GFP_NOFS);
> -- 
> 2.46.0
> 
> 

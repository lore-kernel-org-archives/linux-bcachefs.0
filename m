Received: from out-187.mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6281910A01
	for <linux-bcachefs@vger.kernel.org>; Tue, 30 Apr 2024 03:31:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714447887; cv=none; b=u4Y0E9uFfejr84W9YSc6OsvVwtNNA/aJKVTuePEMLGlytGbLvPEbjECR9GETb3UVQjhN1G6lklav14o8F/wq39QE0SYXrbBz8QiyeleXDDXTCLzVCsTr5BMLbpAz6GMUfxzh+zn00/+F3dc3su1oQY02/DLW3iuoRlPUT850bA8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714447887; c=relaxed/simple;
	bh=LMfpDW5w5x4oJd8+FDaMLuLBYtiAHznZIr+E0rtVK2I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=f28yDM0LSjo6rw+whJB/eOMhXwVzgZ+sKmw3/9kxuv8adi/Lk/ht6psgktiFA2F00mDTlp4UjLSK7maKYvMZ3Lrwt5AZQKiQ+g2ja8N1nRvwzDZB3g8h7LerSUDQJ76M5GaQq/F8qnGkWewnmDQJLr8G2e10IgBd4zjNO+EQx6U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=V9mCmdjl; arc=none smtp.client-ip=95.215.58.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="V9mCmdjl"
Date: Mon, 29 Apr 2024 23:31:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1714447884;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=7fc1Lq3tEEPo9NZlxBYxSolqOF6sb91EQJr9xYbaujE=;
	b=V9mCmdjlNi0pfHeTGsllnS8HRg4so/gOIo4ozJnIlbHAJRxxxfbG40BmMjv8XRQHomCqdI
	0V9mL/Ccjz1w6Xo2lvmv9qasaN/wXtmSiQkI5ola4B6rqL2fMg94iR39YbPZjpQSX/fUbE
	nMf1geFMvdxXyak1ntKrA9peCJUg+lY=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Youling Tang <youling.tang@linux.dev>
Cc: linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Youling Tang <tangyouling@kylinos.cn>
Subject: Re: [PATCH] bcachefs: Fix error path of bch2_link_trans()
Message-ID: <ww5fcxuzfcgttglsr6cpnrxufeusw4ixe76iqp7mab3djlyfje@zozue6qvxhzy>
References: <20240430032839.948404-1-youling.tang@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240430032839.948404-1-youling.tang@linux.dev>
X-Migadu-Flow: FLOW_OUT

On Tue, Apr 30, 2024 at 11:28:39AM +0800, Youling Tang wrote:
> From: Youling Tang <tangyouling@kylinos.cn>
> 
> In bch2_link_trans(), if bch2_inode_nlink_inc() fails, it needs to
> call bch2_trans_iter_exit() in the error path.

Thanks - applied.
> 
> Signed-off-by: Youling Tang <tangyouling@kylinos.cn>
> ---
>  fs/bcachefs/fs-common.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/bcachefs/fs-common.c b/fs/bcachefs/fs-common.c
> index 6c737def357e..508d029ac53d 100644
> --- a/fs/bcachefs/fs-common.c
> +++ b/fs/bcachefs/fs-common.c
> @@ -200,12 +200,12 @@ int bch2_link_trans(struct btree_trans *trans,
>  
>  	ret = bch2_inode_peek(trans, &inode_iter, inode_u, inum, BTREE_ITER_intent);
>  	if (ret)
> -		goto err;
> +		return ret;
>  
>  	inode_u->bi_ctime = now;
>  	ret = bch2_inode_nlink_inc(inode_u);
>  	if (ret)
> -		return ret;
> +		goto err;
>  
>  	ret = bch2_inode_peek(trans, &dir_iter, dir_u, dir, BTREE_ITER_intent);
>  	if (ret)
> -- 
> 2.34.1
> 

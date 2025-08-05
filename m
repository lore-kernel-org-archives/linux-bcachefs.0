Received: from out-180.mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE8501DE2C2
	for <linux-bcachefs@vger.kernel.org>; Tue,  5 Aug 2025 15:44:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754408668; cv=none; b=I/atzAgPLFa2pxTe+lgAhqx98DKZgEpbjkOuIWl1uGWYOmYOuz4Ff2Rq/eND1vJ4DRb/nHdcVcZnUcYG9XTqcTt5SoQiq288EqZPpQYcWs6vcveK0AqwMikWPpY9Xyz1z0BRiISB9Mia7gi8s6BqXmHvuVfsZVYNm+twL+FTpGk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754408668; c=relaxed/simple;
	bh=TBbMknKDMaCj3TTrGzd0FRssnqUItu4sBp6Duru32g8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nlOyu0zn/bvsatlAvSk6Wgq2jY90Y/sZGBPp1bDCBfKToa3i5TH0FULPQiPy5S7v/hG8vSSgAFfhnh6MlBzWwk+W3Gb6tqizFPA29d+fz5bRweID93rxLLig7nTbTp0zGVFJ6YWE0OpClpgilVTBUiwkDNFzsjmGRIAMQHzmd+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=mZG8D6BM; arc=none smtp.client-ip=95.215.58.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="mZG8D6BM"
Date: Tue, 5 Aug 2025 11:44:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1754408664;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=puQbTlQQ5EWfSITmy35dBNKbmzTBHId0m78+P/AP20Y=;
	b=mZG8D6BMZZBiepZmvnAFdZtInuDPLNz3p5XpmJIuizKqWgZp0xjJA0OJO3uAsz7KgelwDq
	dspkiBdC+VqzJqzlSaffC3o00pCFXEevuhzT1l69+5LLRrs9XLlVE8fKs5c1or8KfFIY2f
	Wx0vD86riAG4+KK/hlROMSmc3+Heh0s=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Alan Huang <mmpgouride@gmail.com>
Cc: linux-bcachefs@vger.kernel.org, 
	syzbot+23e4a7772eb9a9715b85@syzkaller.appspotmail.com
Subject: Re: [PATCH] bcachefs: Fix readahead involved deadlock
Message-ID: <7o3hesuda7dryjd4c7r4mq74ibpl2pow7l2uwtopd3fzmsjrle@lxevcvri3crb>
References: <20250805141435.432418-1-mmpgouride@gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250805141435.432418-1-mmpgouride@gmail.com>
X-Migadu-Flow: FLOW_OUT

On Tue, Aug 05, 2025 at 10:14:35PM +0800, Alan Huang wrote:
> readahead first lock the folio, then invokes aops->readahead, which
> locks the two state lock to block subsequent direct I/O. However,
> direct IO or bchfs_fpunch first lock the two state lock to block
> subsequent buffered I/O, and then lock the folio to invalidate or
> truncate it. Therefore, there is a deadlock:
> 
> thread1			thread2
> lock folio		bch2_pagecache_block_get
> bch2_pagecache_add_get 	lock folio
> 
> Reported-by: syzbot+23e4a7772eb9a9715b85@syzkaller.appspotmail.com
> Signed-off-by: Alan Huang <mmpgouride@gmail.com>

Readahead is allowed to silently fail (we fall back to read_folio), and
if the tryget fails that means another thread doesn't want new data
added to the pagecache, so this looks good.

Applied.

> ---
>  fs/bcachefs/fs-io-buffered.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/bcachefs/fs-io-buffered.c b/fs/bcachefs/fs-io-buffered.c
> index c5ed62a11f23..ed8329c6c00d 100644
> --- a/fs/bcachefs/fs-io-buffered.c
> +++ b/fs/bcachefs/fs-io-buffered.c
> @@ -290,7 +290,8 @@ void bch2_readahead(struct readahead_control *ractl)
>  	 * scheduling.
>  	 */
>  	blk_start_plug(&plug);
> -	bch2_pagecache_add_get(inode);
> +	if (!bch2_pagecache_add_tryget(inode))
> +		goto out;
>  
>  	struct btree_trans *trans = bch2_trans_get(c);
>  	while ((folio = readpage_iter_peek(&readpages_iter))) {
> @@ -317,6 +318,7 @@ void bch2_readahead(struct readahead_control *ractl)
>  	bch2_trans_put(trans);
>  
>  	bch2_pagecache_add_put(inode);
> +out:
>  	blk_finish_plug(&plug);
>  	darray_exit(&readpages_iter.folios);
>  }
> -- 
> 2.49.0
> 

Received: from out-186.mta1.migadu.com (out-186.mta1.migadu.com [95.215.58.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53E711DFD96
	for <linux-bcachefs@vger.kernel.org>; Fri,  8 Aug 2025 18:28:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754677730; cv=none; b=Y2d6AddnIcc0ot7Y8SwbLuAr5m7GiTz0TIZuJeWxJCW9zzdgbXZFuMZ8Zew7mPGcw4BRx1K/a+Zk3K/+o2vHMXy9EqahEbU/SeUqqKOsxbUBy4K06wzt4hjI8xBrLniriXlrwDYEJYosZktdt+yGm3TtkEkJhNdWy5X85beO0+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754677730; c=relaxed/simple;
	bh=h1zEDIOEH0sy6sNsFNfDv6ZJel+KUrxSyhjI1BzuqMU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Mh49gct+OCO/x4cVnix7moC7Q6jVhe/ubbI/PpME1nmeVgOe+qs5BXdcTcZHseqISBW7DAwcPf+bm719+2AxT41EPxoQSxMsqYlkXryjPTxzvMo9UQ01IojSilVz9xiiLdC85pzTsT2lppMlNHEs1vVSELmKtDI2DhfeFQa/9j0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=BJl3WrDI; arc=none smtp.client-ip=95.215.58.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="BJl3WrDI"
Date: Fri, 8 Aug 2025 14:28:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1754677726;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=RrniM/bMBvoi264bSxS177Yy+xqYWe+mCFZ/oQ7D4F4=;
	b=BJl3WrDIoYgFQ8PqWDwKxKvn3E9wfD2dPJknQi8IMmC2XoSFk0dDPrnPM5RiGtySsj9+x3
	r+7FrhXhcFq6bXUdlawv2C9HSqoo4qp3i6EEJXLLED/t9n88I6S8uDfmH9h664Ui3caixB
	1Vj38vSyEOPxMi7soAlgiECwjcyy4b0=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Alan Huang <mmpgouride@gmail.com>
Cc: linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH 1/3] bcachefs: Introduce bch2_splice_read
Message-ID: <patconq5iida3i5vr76bdui6wzbtzhkec3lshuklu7e76zxxeo@uqeumlxcnjb6>
References: <20250808134312.878432-1-mmpgouride@gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250808134312.878432-1-mmpgouride@gmail.com>
X-Migadu-Flow: FLOW_OUT

On Fri, Aug 08, 2025 at 09:43:10PM +0800, Alan Huang wrote:
> This provides our own splice read, which locks ei_pagecache_lock around
> filemap_splice_read.
> 
> Signed-off-by: Alan Huang <mmpgouride@gmail.com>
> ---
>  fs/bcachefs/fs-io-buffered.c | 12 ++++++++++++
>  fs/bcachefs/fs-io-buffered.h |  4 ++++
>  2 files changed, 16 insertions(+)
> 
> diff --git a/fs/bcachefs/fs-io-buffered.c b/fs/bcachefs/fs-io-buffered.c
> index fd8beb5167ee..c16c45a72c47 100644
> --- a/fs/bcachefs/fs-io-buffered.c
> +++ b/fs/bcachefs/fs-io-buffered.c
> @@ -1100,6 +1100,18 @@ ssize_t bch2_write_iter(struct kiocb *iocb, struct iov_iter *from)
>  	return bch2_err_class(ret);
>  }
>  
> +ssize_t bch2_splice_read(struct file *in, loff_t *ppos,
> +			 struct pipe_inode_info *pipe,
> +			 size_t len, unsigned int flags)
> +{
> +	ssize_t ret;
> +	struct bch_inode_info *inode = to_bch_ei(in->f_mapping->host);
> +	bch2_pagecache_add_get(inode);
> +	ret = filemap_splice_read(in, ppos, pipe, len, flags);
> +	bch2_pagecache_add_put(inode);
> +	return ret;
> +}

Taking the lock here, around the entire splice_read() call sucks - most
buffered reads (and this is the fastpath, which we care about) will be
reading from cache, i.e. they aren't adding new folios to the pagecache
and they don't need pagecache_add lock.

Meaning, we really don't want to add two new atomic ops on the inode to
every buffered read.

Does this help with lockdep at all? The main issue is still the fault
path vs. mmap_lock.

Received: from out-176.mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A34823CB
	for <linux-bcachefs@vger.kernel.org>; Thu, 19 Jun 2025 18:34:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750358084; cv=none; b=GmS55J3ju2bKQusOnrOq+jspk7+bLCRuV7UWDU0XdDWxymFFMDjIl4alMHa0pnxrZmGucC8l6p3A1/jJwIk/POgGrjNW71Rf06SU2zOhTjUsmx1aGoG5RWSe3RuQ1+okuhRrYj/tD1zRzODwaW72A++ObByPRtgF6OgyzHrwMIM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750358084; c=relaxed/simple;
	bh=eybq0y4mTh/FY8fHBirrsXyBBb7ogbB2JXp+KNBXNT4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UiZrDd8mHxlovTLzRjMaZy2hwwYo7/c/HuiaZS8OVgZb+PwVdo8qAl/IYgabr4yr0XrygXVmeauzmprDKFHiIkZP4D5Ur1x3J7SeJSyESj83MkO790QuRcWDNQynozDZGESbDjbf3pHY5dwsNTeDW3JuqjaMa6RLmYBpb8ArK/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=h7FHMiPa; arc=none smtp.client-ip=95.215.58.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="h7FHMiPa"
Date: Thu, 19 Jun 2025 14:34:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1750358080;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+VVUXkcQsSAEkNyAQaA4UYYUFVKEYZVYNfOjJ6WTTcA=;
	b=h7FHMiPa78vN5Vykf/kdjtad6MHMXol8qqI+16Tgb8R+Z8BUeeeDmv84EEuS+u11I7/zio
	M3OvjctburTihdiByfJyXwTxLW/l0LbCYUBdl2Iob5cJrzndWtYHnOtqjj8WBsSWyAfFmM
	wR4iw9JUccjy68pNfwVQIMKuj6ULnlg=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Alan Huang <mmpgouride@gmail.com>
Cc: linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH] bcachefs: Don't memcpy more than needed
Message-ID: <zzwhxqvgnqhzuylxfzdzaf23dpkrx34xvm7ed2pvyzauikcqre@m5yknudrzvno>
References: <20250619173317.975223-1-mmpgouride@gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250619173317.975223-1-mmpgouride@gmail.com>
X-Migadu-Flow: FLOW_OUT

On Fri, Jun 20, 2025 at 01:33:17AM +0800, Alan Huang wrote:
> buf->u64s is all we used.
> 
> Signed-off-by: Alan Huang <mmpgouride@gmail.com>

applied

> ---
>  fs/bcachefs/btree_update.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/bcachefs/btree_update.c b/fs/bcachefs/btree_update.c
> index ee657b9f4b96..d9a17d523db1 100644
> --- a/fs/bcachefs/btree_update.c
> +++ b/fs/bcachefs/btree_update.c
> @@ -566,7 +566,7 @@ void *__bch2_trans_subbuf_alloc(struct btree_trans *trans,
>  	if (buf->u64s)
>  		memcpy(n,
>  		       btree_trans_subbuf_base(trans, buf),
> -		       buf->size * sizeof(u64));
> +		       buf->u64s * sizeof(u64));
>  	buf->base = (u64 *) n - (u64 *) trans->mem;
>  	buf->size = new_size;
>  
> -- 
> 2.48.1
> 

Received: from out-175.mta1.migadu.com (out-175.mta1.migadu.com [95.215.58.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F26298493
	for <linux-bcachefs@vger.kernel.org>; Fri, 24 May 2024 20:15:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716581753; cv=none; b=ivZ6BM50kOCgWWiOL/SWH24CvRL6X3gwYPYloadVIrcVEfG9tfy8gVdj4ba++GaOuJIShJSYSzdTQDagVmPX72ljcqI8LyT8y79FRRMUEGpgTy/HVVJbrUrFZar2sKTb15pR8/SbwLzixEtCxd8XN9P1PostVi7LxCihT9umw8o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716581753; c=relaxed/simple;
	bh=7rQlO3YDfxPFunMmO2O7BiqGMJOkhP0EJeCOHg+XOHI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HlByY6O84f28VOUM3J1AYxdHCZbSL9gtUmsLMkLu9uJNz4X03/ei/dNi5cZqTpQbQt/9qf87F68YwLAKY7zkWbLoXHdP7GCZduE37013sCCmAYHEwcxHCm+nniJcJ/00QBeRD0BMUjlK4nNSKimCsDCPpYfZusxU3ct0VMOiFjM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=QaYWFFeT; arc=none smtp.client-ip=95.215.58.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="QaYWFFeT"
X-Envelope-To: willy@infradead.org
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1716581747;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=oN36Vx8+ufPhWmuk/jNR5LHC0Px/JDGURBT0CdBfQoo=;
	b=QaYWFFeTgjFAHn2k+VR7NYQiJu/slk6y1pFhd0vbRG/9F39hh7O9fZifrCuMDqdiOb4QxR
	fM0JkabI+35mFFrcE0vpjNEWfPUuv7+q1gUX73RElvbOiiV2BGwgWOYawkoMuBYkEATi2y
	6ALCbqXFPhhpkR2obJmUToHvT1iGQXU=
X-Envelope-To: bfoster@redhat.com
X-Envelope-To: linux-bcachefs@vger.kernel.org
Date: Fri, 24 May 2024 16:15:43 -0400
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Brian Foster <bfoster@redhat.com>, linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH] bcachefs: Use copy_folio_from_iter_atomic()
Message-ID: <q4xvkf7dfg4g2vgjnm5xlqqoxvo4xefs6lr2m4uxnpu6ergzh5@vrb7htlp2jii>
References: <20240524194627.711814-1-willy@infradead.org>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240524194627.711814-1-willy@infradead.org>
X-Migadu-Flow: FLOW_OUT

On Fri, May 24, 2024 at 08:46:25PM +0100, Matthew Wilcox (Oracle) wrote:
> copy_page_from_iter_atomic() will be removed at some point.
> Also fixup a comment for folios.
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>

Applied

> ---
>  fs/bcachefs/fs-io-buffered.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/bcachefs/fs-io-buffered.c b/fs/bcachefs/fs-io-buffered.c
> index b0a33fabadf8..c7b48ef3c637 100644
> --- a/fs/bcachefs/fs-io-buffered.c
> +++ b/fs/bcachefs/fs-io-buffered.c
> @@ -437,8 +437,8 @@ static void bch2_writepage_io_done(struct bch_write_op *op)
>  	 */
>  
>  	/*
> -	 * PageWriteback is effectively our ref on the inode - fixup i_blocks
> -	 * before calling end_page_writeback:
> +	 * The writeback flag is effectively our ref on the inode -
> +	 * fixup i_blocks before calling folio_end_writeback:
>  	 */
>  	bch2_i_sectors_acct(c, io->inode, NULL, io->op.i_sectors_delta);
>  
> @@ -898,7 +898,7 @@ static int __bch2_buffered_write(struct bch_inode_info *inode,
>  	darray_for_each(fs, fi) {
>  		f = *fi;
>  		f_len = min(end, folio_end_pos(f)) - f_pos;
> -		f_copied = copy_page_from_iter_atomic(&f->page, f_offset, f_len, iter);
> +		f_copied = copy_folio_from_iter_atomic(f, f_offset, f_len, iter);
>  		if (!f_copied) {
>  			folios_trunc(&fs, fi);
>  			break;
> -- 
> 2.43.0
> 

Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A386D219EB
	for <linux-bcachefs@vger.kernel.org>; Fri, 27 Jun 2025 02:16:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750990601; cv=none; b=Q34GROTeyxRy1n0Q2fS5IRiV/obQ9cZAZcJ8UIeuiI4I0gYymAgL/WqTEnx2HL3qbPRRUtB/l7vKReJlBeKqkjifDW+5M2+AKKiVXqX4HwoT4aIZKRzPjhxQuAGtXZRPh1xhra/B94ZVxHKMKglzcnQqYe7hPLGGLwpzUQUq/Ms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750990601; c=relaxed/simple;
	bh=pZsPe42CiZoGGMQSeeHGeXnuo34X8knlQoD8r/oOmIM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HwN7aJj2v0ZSKdIXrlS5jEcqqwHVuNj3/d3hj5Naerc46LZlSQ+PljbgTOZtK6CufbrBO3TWNpE15PK99NWYjbVTPuKcLXT8cbu0OoSKFLSjuZmEusy63x9ePmu8djKQeXf2TXUIxhIMbnAHVMU1tK2nY8eQ+Gltuy7VkVf9+34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=qy+yHzYF; arc=none smtp.client-ip=91.218.175.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="qy+yHzYF"
Date: Thu, 26 Jun 2025 22:16:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1750990593;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=U144Ph4RXxj4gGppJr9qT0Dw0b6wY2GgPOKo6Yovtog=;
	b=qy+yHzYFPd5ntOkc9N8/MwGXmHEUwJV01+b6dEnJ5EqsJ3Tm8V7fMSzGl+jPJM8uK1APRB
	9r2Jehd557lAkcgloXsi7Jg2jwVOpRsVCJ8aLNXiGF7E6ZqXpL6ESMr+QEgZ0lfIqHl4Xv
	WgdAIK8IjpWW56gl1zjvMQD1iwRapgc=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Youling Tang <youling.tang@linux.dev>
Cc: linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Youling Tang <tangyouling@kylinos.cn>
Subject: Re: [PATCH 1/2] bcachefs: Simplify bch2_bio_map()
Message-ID: <e6r3mzeb33xidr6e24ylrdop2v2hr7ztcqxl5uoskvfsmfbid2@2qztfbarr5bx>
References: <20250605020639.6868-1-youling.tang@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250605020639.6868-1-youling.tang@linux.dev>
X-Migadu-Flow: FLOW_OUT

On Thu, Jun 05, 2025 at 10:06:38AM +0800, Youling Tang wrote:
> From: Youling Tang <tangyouling@kylinos.cn>
> 
> For the part of directly mapping the kernel virtual address, there is no
> need to increase to bio page-by-page. It can be directly replaced by
> bio_add_virt_nofail().
> 
> For the address part of the vmalloc region, its physical address is
> discontinuous and needs to be increased page-by-page to bio. The helper
> function bio_add_vmalloc() can be used to simplify the implementation of
> bch2_bio_map().
> 
> Signed-off-by: Youling Tang <tangyouling@kylinos.cn>

Thanks, I'll apply this

> ---
> NOTE:
> The following patch needs to be applied (because the bcachefs.git repository
> has not been synchronized to the latest):
> commit 850e210d5ad2 ("block: add a bio_add_virt_nofail helper")
> commit 8dd16f5e3469 ("block: add a bio_add_vmalloc helpers")
> 
>  fs/bcachefs/util.c | 15 ++++-----------
>  1 file changed, 4 insertions(+), 11 deletions(-)
> 
> diff --git a/fs/bcachefs/util.c b/fs/bcachefs/util.c
> index dc3817f545fa..5e5075630bc6 100644
> --- a/fs/bcachefs/util.c
> +++ b/fs/bcachefs/util.c
> @@ -623,17 +623,10 @@ void bch2_pd_controller_debug_to_text(struct printbuf *out, struct bch_pd_contro
>  
>  void bch2_bio_map(struct bio *bio, void *base, size_t size)
>  {
> -	while (size) {
> -		struct page *page = is_vmalloc_addr(base)
> -				? vmalloc_to_page(base)
> -				: virt_to_page(base);
> -		unsigned offset = offset_in_page(base);
> -		unsigned len = min_t(size_t, PAGE_SIZE - offset, size);
> -
> -		BUG_ON(!bio_add_page(bio, page, len, offset));
> -		size -= len;
> -		base += len;
> -	}
> +	if (is_vmalloc_addr(base))
> +		bio_add_vmalloc(bio, base, size);
> +	else
> +		bio_add_virt_nofail(bio, base, size);
>  }
>  
>  int bch2_bio_alloc_pages(struct bio *bio, size_t size, gfp_t gfp_mask)
> -- 
> 2.34.1
> 

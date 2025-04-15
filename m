Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8647E1F542A
	for <linux-bcachefs@vger.kernel.org>; Tue, 15 Apr 2025 14:36:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744727770; cv=none; b=nnCznX1SFkftHe45BlTJAkgJ8i2LQkkS7yeWW+kwwQJcQuCznE5ZdFc7FW0Fe12DHeRUoAUYyg/rMOFHfu/MzAx2tmjYV7/LXYsU3A1069Rw4NMZpVrdomyLRlq4INAKwMxYSjbIVCH2KIn+DtjoVieKE7t0fTBE6KYxa2lDPas=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744727770; c=relaxed/simple;
	bh=KvGGiJ3VhQMRapOVnhb00hgJBjE/n3yhweya2WACHCA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TZA/kxRuWwGXy7f5t3fgajbN5pXPI1vNFs5ke9O/5suIIcqgd/roGfZHDx8ffUDT7dkroSdZQeInPyjpb0OuTRkuNU0Lmgi07B8uTVlm2nLMXYrzOb1vSjnANHvkQPU7+4s2UIQ2SADkhGgv1pmpvHVp246SPuRWG0f2xtQ/DG0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=LDnETdZ5; arc=none smtp.client-ip=91.218.175.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="LDnETdZ5"
Date: Tue, 15 Apr 2025 10:36:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1744727766;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=tbJj/mgfirLJO8qgKAAdCUf9fXB3X7mzto4QeAAsT20=;
	b=LDnETdZ5h6V8AA0YBqApyufdOiLcI2F2JPP5IjQqiEWul/qppCLZL1Y/JVkC6WZjAy9lLw
	v0mTFKyLV/v2PFpi61nigj1BJxE/rfNWSqly9qMJ+lCzALLZG86Ix6as5nF94Vmb3W2XVH
	JSvchRICsK30dC6LR5VZ60SitpEnmrk=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Alan Huang <mmpgouride@gmail.com>
Cc: linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH 4/4] bcachefs: Simplify logic
Message-ID: <ljjk2woo3as756sl5aehe3tjbrrym5mwfk665naqy43vj7zptw@7pqrhrfbe5v4>
References: <20250415053307.81354-1-mmpgouride@gmail.com>
 <20250415053307.81354-5-mmpgouride@gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250415053307.81354-5-mmpgouride@gmail.com>
X-Migadu-Flow: FLOW_OUT

On Tue, Apr 15, 2025 at 01:33:07PM +0800, Alan Huang wrote:
> Signed-off-by: Alan Huang <mmpgouride@gmail.com>

Applied

> ---
>  fs/bcachefs/btree_io.c | 8 ++------
>  1 file changed, 2 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/bcachefs/btree_io.c b/fs/bcachefs/btree_io.c
> index 14e3329baa43..afcd13092807 100644
> --- a/fs/bcachefs/btree_io.c
> +++ b/fs/bcachefs/btree_io.c
> @@ -1017,7 +1017,6 @@ int bch2_btree_node_read_done(struct bch_fs *c, struct bch_dev *ca,
>  	bool used_mempool, blacklisted;
>  	bool updated_range = b->key.k.type == KEY_TYPE_btree_ptr_v2 &&
>  		BTREE_PTR_RANGE_UPDATED(&bkey_i_to_btree_ptr_v2(&b->key)->v);
> -	unsigned u64s;
>  	unsigned ptr_written = btree_ptr_sectors_written(bkey_i_to_s_c(&b->key));
>  	u64 max_journal_seq = 0;
>  	struct printbuf buf = PRINTBUF;
> @@ -1224,23 +1223,20 @@ int bch2_btree_node_read_done(struct bch_fs *c, struct bch_dev *ca,
>  	sorted = btree_bounce_alloc(c, btree_buf_bytes(b), &used_mempool);
>  	sorted->keys.u64s = 0;
>  
> -	set_btree_bset(b, b->set, &b->data->keys);
> -
>  	b->nr = bch2_key_sort_fix_overlapping(c, &sorted->keys, iter);
>  	memset((uint8_t *)(sorted + 1) + b->nr.live_u64s * sizeof(u64), 0,
>  			btree_buf_bytes(b) -
>  			sizeof(struct btree_node) -
>  			b->nr.live_u64s * sizeof(u64));
>  
> -	u64s = le16_to_cpu(sorted->keys.u64s);
> +	b->data->keys.u64s = sorted->keys.u64s;
>  	*sorted = *b->data;
> -	sorted->keys.u64s = cpu_to_le16(u64s);
>  	swap(sorted, b->data);
>  	set_btree_bset(b, b->set, &b->data->keys);
>  	b->nsets = 1;
>  	b->data->keys.journal_seq = cpu_to_le64(max_journal_seq);
>  
> -	BUG_ON(b->nr.live_u64s != u64s);
> +	BUG_ON(b->nr.live_u64s != le16_to_cpu(b->data->keys.u64s));
>  
>  	btree_bounce_free(c, btree_buf_bytes(b), used_mempool, sorted);
>  
> -- 
> 2.48.1
> 

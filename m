Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 552EF1B0434
	for <linux-bcachefs@vger.kernel.org>; Tue, 15 Apr 2025 14:35:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744727739; cv=none; b=OhjT+v35RLARrMBMyYZUhb1TDgm+6YxIDk/6TN9N1E4uUJXyrdNk9rrcbh5YjK2eDbXoeRwepgN0cI9uMLFG0OiAYTyWIknJuT93qMjBDcQUYr3BDfggdSyW8mLkNszPUgRkt984IAirUKGu59I/4izsdeqV7lSsqh2SWu9JM/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744727739; c=relaxed/simple;
	bh=sNnra0zENpsYQke/qW9rwByDB1WdZ9QC5hEOsIACZAM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AS04dj3P3Eurn+qVcirTp8zqWQiUH/Lfr8y6O9h5omKA+hQ0Ifoj3OufPXrew6d5i/5cs63/1yGf6zKtI1HxHLeIprHk/zFvRoftuPak9AOgZcQJkqJ82r/kABxSjXktv0KAYPuVj6oXCBjHdv/qik0xAFzX7gTbVbkHutuswVI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=LT58iuP8; arc=none smtp.client-ip=91.218.175.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="LT58iuP8"
Date: Tue, 15 Apr 2025 10:35:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1744727734;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Rw5xKBrGOZNu3RNnK11VU2jO70BHdjsMuarMs81ljPI=;
	b=LT58iuP8pIvN2uqH9haGCgGPZZoBZzXaYRX3GOq6qrX9SVXpT6WZ0ebOfKTxguRzC/pUWu
	obHEKLshMdf9d9E4n3wXVHf3M9G3xh4kakbf/aUKffp5UAnDInaA/2beQWQJlaoYJb6sDY
	kHi1RIyWMOtPEzB9TIj0cW5KftY2xeo=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Alan Huang <mmpgouride@gmail.com>
Cc: linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH 3/4] bcachefs: Remove spurious +1/-1 operation
Message-ID: <b7udwk3bfp3ccr4tslonbgp5gw47foetxugu6luqd7nckzpth3@tt6brviavmkz>
References: <20250415053307.81354-1-mmpgouride@gmail.com>
 <20250415053307.81354-4-mmpgouride@gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250415053307.81354-4-mmpgouride@gmail.com>
X-Migadu-Flow: FLOW_OUT

On Tue, Apr 15, 2025 at 01:33:06PM +0800, Alan Huang wrote:
> Signed-off-by: Alan Huang <mmpgouride@gmail.com>

Applied

> ---
>  fs/bcachefs/btree_types.h | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/bcachefs/btree_types.h b/fs/bcachefs/btree_types.h
> index dd109dea0f1c..c2e05824e99b 100644
> --- a/fs/bcachefs/btree_types.h
> +++ b/fs/bcachefs/btree_types.h
> @@ -656,13 +656,13 @@ static inline struct bset_tree *bset_tree_last(struct btree *b)
>  static inline void *
>  __btree_node_offset_to_ptr(const struct btree *b, u16 offset)
>  {
> -	return (void *) ((u64 *) b->data + 1 + offset);
> +	return (void *) ((u64 *) b->data + offset);
>  }
>  
>  static inline u16
>  __btree_node_ptr_to_offset(const struct btree *b, const void *p)
>  {
> -	u16 ret = (u64 *) p - 1 - (u64 *) b->data;
> +	u16 ret = (u64 *) p - (u64 *) b->data;
>  
>  	EBUG_ON(__btree_node_offset_to_ptr(b, ret) != p);
>  	return ret;
> -- 
> 2.48.1
> 

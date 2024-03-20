Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 872942CA6
	for <linux-bcachefs@vger.kernel.org>; Wed, 20 Mar 2024 21:49:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710971345; cv=none; b=ugQzr3jrN5v7fF0KA8Gka2pGXTECyQH1q2zKCDut5CRX3MEwWdWxR7+JbHXNgb8EUTV1wdN9GOxO2nuDqgjI9ndCOKCw5D015SPUZdXfUM7Tz2fn4o0io3oW0KJOaazayJODy9HNcVl8w/SF295DAKdA98Ro9SMyQusyFskgDGk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710971345; c=relaxed/simple;
	bh=RKyRVbWC5v/cnVafta8wsFK11+HScT99GeMsbzw2Riw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tqUxfSJzQl/P6Y2zc4B2kfiooa+/D7d56w08T2mfF/rDhc05nAgUINbjigejO8rgOaMMgdK/l84DK+y8t+RNaHOdKgrchATbjZdCNHgTUtOGcxa67wC+SlV1YKlwNpln3dsc2JYrSlJjA3d6rfdeIKswa5nWjVMzGkVO64Jwl8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Qx5dsS5D; arc=none smtp.client-ip=95.215.58.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Qx5dsS5D"
Date: Wed, 20 Mar 2024 17:48:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1710971338;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=fLwxu/jT8RreXcWSA8pBnvlil888u4IBiRp1nDz/00c=;
	b=Qx5dsS5DTUAbHIb1cvqHmb6S3gqGfA5lQWdhojSw8iMTzD4YtpGeW+lsqyqnifplOgCHkR
	GPfY0FsXOGKZAueg1UfGBA7nyaQsNiqym42+fw1iEqC5VAuQ05XZrjKvJLThiJsG1CU1t+
	KaXrGhzqvSpKXJrjnLsuv/yiH9iM8SM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Zijie Zhao <zzjas98@gmail.com>
Cc: bfoster@redhat.com, linux-bcachefs@vger.kernel.org, 
	chenyuan0y@gmail.com
Subject: Re: [fs/bcachefs] Question about memory allocation in
 btree_paths_realloc
Message-ID: <bblgnrjjvyisunthmn4ti667nqyr5pglr5rws4kxalkxvs2wi4@k7w7ekoc2wru>
References: <080de8c1-497c-45aa-a5a0-10dba5319c64@gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <080de8c1-497c-45aa-a5a0-10dba5319c64@gmail.com>
X-Migadu-Flow: FLOW_OUT

On Wed, Mar 20, 2024 at 04:37:02PM -0500, Zijie Zhao wrote:
> Dear BCACHEFS maintainers,
> 
> We encountered an unusual usage of kzalloc in btree_paths_realloc while
> performing a static analysis for kernel code.
> 
> 
> https://elixir.bootlin.com/linux/latest/source/fs/bcachefs/btree_iter.c#L1523
> 
> ```
> static noinline void btree_paths_realloc(struct btree_trans *trans)
> {
> 	unsigned nr = trans->nr_paths * 2;
> 
> 	void *p = kzalloc(BITS_TO_LONGS(nr) * sizeof(unsigned long) +
> 			  sizeof(struct btree_trans_paths) +
> 			  nr * sizeof(struct btree_path) +
> 			  nr * sizeof(btree_path_idx_t) + 8 +
> 			  nr * sizeof(struct btree_insert_entry), GFP_KERNEL|__GFP_NOFAIL);
> 
> 	unsigned long *paths_allocated = p;
> 	memcpy(paths_allocated, trans->paths_allocated,
> BITS_TO_LONGS(trans->nr_paths) * sizeof(unsigned long));
> 	...
> }
> ```
> 
> Here kzalloc might return NULL in case of out-of-memory, making
> memcpy(NULL,...) to have undefined behavior. Would a NULL check be needed
> here?

See that __GFP_NOFAIL?

Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8228187348
	for <linux-bcachefs@vger.kernel.org>; Tue, 13 Aug 2024 12:18:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723551487; cv=none; b=MhQGkTJCUugfBPC5bzpk4KmBTvOc33KQ4b+hTZ7UQH6nylgGzw2hLdV6HO/F5gQUseRes/bGD2BfEYV+tYAEZZ+1er3m5p1iTAMW2wp6KlzyY3BVt/5of3pP8Z2k+m+SZ8cEjH2v6l1dlssLtVjYYjsrTDW+Qk5tIbyesv0uiBA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723551487; c=relaxed/simple;
	bh=cYTV3OZmCSdHE0Sjsh2ZNhvjH8mx+i931u3WQ2CECHc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Yxx8pLLfAtf8fc4PPLtj8xZdWJJjCg2I0RXXT9dScwhuKbAXAAbyxmFaJp6PRxEjQ9PkRbeF0ZUV0g7M2v3R279vVewp6LC2LIeYvEyC2iO7gPZ0gSCXLh3IWJzP3HcDvrCBFo5uahLwvx3No2C3q6thmXLvyrO8v6s1ZgaAXHI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=uJhjyeml; arc=none smtp.client-ip=91.218.175.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="uJhjyeml"
Date: Tue, 13 Aug 2024 08:17:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1723551481;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=SPiUg2tcJoade5P9oFX6IrpQDCGI8ZA8eeVxlmVqpeM=;
	b=uJhjyemlKURm80Yl1WubEOyrKgkFx5vVdEO5mAp37314u9Eh2J1wHYTG8n4J4FIlD+0dXt
	pFfWvRf0iT3uv4alvtKUSfAoSr3WibmNPrKj3wgEXVk48Z7bHs0dSvZd7FCVEiX0+JdLlC
	IoUAHFOoHs8xpQftoQ0Y4BhWBeodQMs=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: zhanghao <zhanghao1@kylinos.cn>
Cc: linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzbot+1a11884d9c9f1353942d@syzkaller.appspotmail.com
Subject: Re: [PATCH] bcachefs: Add check for the size of combined key and
 value
Message-ID: <ezutb7amte5sykqvcdb4vcsrihnuqbucmiqplp3uqhkdbt2kjc@g4l5dxav3vcl>
References: <20240813113119.114475-1-zhanghao1@kylinos.cn>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240813113119.114475-1-zhanghao1@kylinos.cn>
X-Migadu-Flow: FLOW_OUT

On Tue, Aug 13, 2024 at 07:31:19PM GMT, zhanghao wrote:
> The bkey_val_bytes() gets the number of bytes of value
> stored in bkey->u64s.If u64s is smaller than BKEY_U64s,
> it causes a negative number to be converted to an
> unsigned number.

Nope, this patch is is _completely_ wrong

> 
> Reported-by: syzbot+1a11884d9c9f1353942d@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=1a11884d9c9f1353942d
> Fixes: ba81523eaac3 ("bcachefs: Split out bkey_types.h")
> Link: https://lore.kernel.org/all/00000000000025321f061d7b62ff@google.com/T/
> 
> Signed-off-by: zhanghao <zhanghao1@kylinos.cn>
> ---
>  fs/bcachefs/bkey_types.h | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/fs/bcachefs/bkey_types.h b/fs/bcachefs/bkey_types.h
> index c9ae9e42b385..60fa5af93032 100644
> --- a/fs/bcachefs/bkey_types.h
> +++ b/fs/bcachefs/bkey_types.h
> @@ -21,6 +21,8 @@ static inline struct bkey_i *bkey_next(struct bkey_i *k)
>  
>  static inline size_t bkey_val_bytes(const struct bkey *k)
>  {
> +	if (k->u64s < BKEY_U64s)
> +		return 0;
>  	return bkey_val_u64s(k) * sizeof(u64);
>  }
>  
> 
> base-commit: d74da846046aeec9333e802f5918bd3261fb5509
> prerequisite-patch-id: 1ec511753fc7aab35ba0e982013cf91ba4403da6
> -- 
> 2.39.2
> 

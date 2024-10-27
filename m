Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA3F011CA9
	for <linux-bcachefs@vger.kernel.org>; Sun, 27 Oct 2024 00:39:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729989598; cv=none; b=CcLbFDSfkgLRGDImCthorCrce9dNbARAT2RpT2nSF3aDIsBewUHYZEjDIobseESvXiC3Aew0sfN1Rc57AcCXtOEjdmW8tW70TH+hsooBzgcHXUePdlPxqIYqK5N+3pQfNp/rlbNLvQ04Gzrtj9Hkk/SXt7wZuLzPZtkuPT7+GN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729989598; c=relaxed/simple;
	bh=3V5Xyiof6WGYeNirfX3cQzy0lYixO3/AyUQlZJx6NAQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lWsRtkdWdIEBZwP7PzlMhuqm9gICwjQJDxnZh1rfOLU6oaKPByllbvWyILf/Y8YsXMkoCHQhvbzU5JwQB1BHBUmw2y2hqVB1pOkaKhY+soIM/205BCo2oLnf35Rh6t8io4Fg8ALuGDYcesTXHsr63CElzB0yFUm9sUhdzKtrWRk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=NWavkOQe; arc=none smtp.client-ip=91.218.175.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="NWavkOQe"
Date: Sat, 26 Oct 2024 20:39:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1729989593;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Yku0gBsNXscRg41UowLZOCdQd6ymS/DiOHTLAMb60xg=;
	b=NWavkOQePAqnAclmpyoEMjk1ZgjiHB+byeZ5So60RDJnmsbHx8wycyAkOTo8gf0dZJLXF3
	qRgkyARVQ7p3XuaUhqhyMycQf9vlKdKLuVNLfmqJy+Hqburu0Sf05b2Lr1qWmuXq99qCZG
	0ue/xd4nVF6Fp+angyDank+5CnFvaAU=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Gaosheng Cui <cuigaosheng1@huawei.com>
Cc: wangweiyang2@huawei.com, linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH -next] bcachefs: fix possible null-ptr-deref in
 __bch2_ec_stripe_head_get()
Message-ID: <wgszcsdhbrme2eyzepsi64lzrkxgt3cc5o2ojogw5vaood4olg@wb2w4y7eyv2t>
References: <20241026102658.1184351-1-cuigaosheng1@huawei.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241026102658.1184351-1-cuigaosheng1@huawei.com>
X-Migadu-Flow: FLOW_OUT

On Sat, Oct 26, 2024 at 06:26:58PM +0800, Gaosheng Cui wrote:
> The function ec_new_stripe_head_alloc() returns nullptr if kzalloc()
> fails. It is crucial to verify its return value before dereferencing
> it to avoid a potential nullptr dereference.
> 
> Fixes: 035d72f72c91 ("bcachefs: bch2_ec_stripe_head_get() now checks for change in rw devices")
> Signed-off-by: Gaosheng Cui <cuigaosheng1@huawei.com>

Thanks, applied

> ---
>  fs/bcachefs/ec.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/fs/bcachefs/ec.c b/fs/bcachefs/ec.c
> index 25d20f73df60..b24089733467 100644
> --- a/fs/bcachefs/ec.c
> +++ b/fs/bcachefs/ec.c
> @@ -1859,6 +1859,10 @@ __bch2_ec_stripe_head_get(struct btree_trans *trans,
>  		}
>  
>  	h = ec_new_stripe_head_alloc(c, disk_label, algo, redundancy, watermark);
> +	if (!h) {
> +		h = ERR_PTR(-ENOMEM);
> +		goto err;
> +	}
>  found:
>  	if (h->rw_devs_change_count != c->rw_devs_change_count)
>  		ec_stripe_head_devs_update(c, h);
> -- 
> 2.25.1
> 

Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C23DECC
	for <linux-bcachefs@vger.kernel.org>; Sun, 27 Oct 2024 00:44:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729989845; cv=none; b=VI4G2sVpp/z7Nk5BMg7N69rAXuZbzLf7zpzWk2T42x067bpQ2ZmcT1L2ZtRxPjXQMfsJ2r4bcIb3vJgWs04DwyM6pw2YzkNzSaC1baVjqa4kgr4ONVmUuhOmTI1BAcjqQubtuUh89pPw1R43qlvNFh3vFWe6w9r7YOq+nHu+bTg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729989845; c=relaxed/simple;
	bh=Gb0isklgktSt418NQnetcWjoo5RnH/k55Z26VuZs1Gg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=B+ytwWjmXRlnCM8Hu3a0BN2n+hJyKMkMvHPC4sD0kEVNQQS6Kt/96osF25wi6/tOVnnlusqXBlTgiKQ3baiiczRupJFOcEMZKO/0yHTvFl8T83w+R7vt5MSCl4RbSqYC3L6lc6NrFDWQtTe/0ZtITweiUDlqq3b4lRyHR22QjmQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=CifhH4x+; arc=none smtp.client-ip=91.218.175.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="CifhH4x+"
Date: Sat, 26 Oct 2024 20:43:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1729989840;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=xPGnidHmtGaFOd8voGZYdhIPFIgwIYB4nigEv0YNeKU=;
	b=CifhH4x+ZonybeQ8FkeN64JWI/gs60QcHItTODUEIivdtCdxY0MDaZQG/r0vpNRSiilkDE
	eFR+REySqQLTXCZbIP9PX74AoTtkFAE4MXGexf0tD3CK1iZUN+aMHP31GntJVJV6szMJ3p
	1tmKFzXfH+y6K2HS6+4mnDiB13MrBb8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Gaosheng Cui <cuigaosheng1@huawei.com>
Cc: wangweiyang2@huawei.com, linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH -next] bcachefs: fix possible null-ptr-deref in
 __bch2_ec_stripe_head_get()
Message-ID: <xitw2pcjdmzurmme5nlthklzsiq4ozs2owcie24zwoq6t73w3b@eehkb2xjmk4a>
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

fyi: I'm changing this to -BCH_ERR_ENOMEM_stripe_head_alloc (and adding
that errcode to errcode.h).

It's unimportant in this case, as this is a small GFP_KERNEL allocation
and thus will never actually fail, but it's important in general as
using a dedicated error code means a better error message (that can be
traced to the exact line of code that generated it) - so we're slowly
killing off all uses of standard error codes and replacing them with
private ones.

> +		goto err;
> +	}
>  found:
>  	if (h->rw_devs_change_count != c->rw_devs_change_count)
>  		ec_stripe_head_devs_update(c, h);
> -- 
> 2.25.1
> 

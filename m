Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D98928CF64
	for <linux-bcachefs@vger.kernel.org>; Wed,  6 Aug 2025 14:09:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754489343; cv=none; b=qmtsGHVKyvsiLzWkN+7vhEQ2mFA0um4jf4BAS6XctDCOI0uxOxolfTfzbQOVWCztpSSnDs2ztvZMTrumFpmVIkr4+cMsDTQPs6FHu1DZY4yLBggz62HmwyvOrQzjyS5ZBB929qywavT6zeToLHr7ZxpJatPgaNiqgmzyZsA2nfk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754489343; c=relaxed/simple;
	bh=WtBsYoZ+xjXmRYUCdhVuvTb11NkBubMafVqo/q56kto=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IJ4Gix+/+upY/V7xoQLoQuzXk0K3zcNND8lGnzC+EN/hwrHmQiMYcINYxQbTN5b+GxHxmfszrdIQaivXUb4USx54qjKqt4IjAkMWhpgNF+WhyLnZEJU/MMStST3HgmXO+qcKnYFiPIgQpgeY2hjRO3kX4NfaRyoNpU/oGlbTZN4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=vxoOKbJz; arc=none smtp.client-ip=95.215.58.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="vxoOKbJz"
Date: Wed, 6 Aug 2025 10:08:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1754489338;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2zFH7Qmqmf3rdGadgcaC9aQmAuiyP46ckl2aEB+Kowc=;
	b=vxoOKbJz3zc1mZJq5dXniYIZq9InROjoP29M6msJsKIZaMu0wBOHOq8BNvrUUPQSDf+8Lt
	RFH+7jTxtDesoLvV1I3rCA00pB39sMu8m7xPKuZXM7mTpSFV+9Bh0N16RzkBFHo/koGfWM
	UoF6rsz3f9X2wmJKq2ev/fJQGr9eODY=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Alan Huang <mmpgouride@gmail.com>
Cc: dan.carpenter@linaro.org, linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH] bcachefs: Fix possible pointer dereference
Message-ID: <ki5kkqdlqkpaurjtojsm5ltvcphf2lwyz2ygjfdeqsu5oj7znz@xgv2lenx5gij>
References: <20250806122018.552250-1-mmpgouride@gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250806122018.552250-1-mmpgouride@gmail.com>
X-Migadu-Flow: FLOW_OUT

On Wed, Aug 06, 2025 at 08:20:18PM +0800, Alan Huang wrote:
> c hasn't been set yet here.
> 
> Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
> Fixes: 09b9c72bd4b7 ("bcachefs: bch_err_throw()")
> Signed-off-by: Alan Huang <mmpgouride@gmail.com>

Beat you to it, I fixed this one yesterday :)

> ---
>  fs/bcachefs/super.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/bcachefs/super.c b/fs/bcachefs/super.c
> index b0019488f586..5992ca040bf6 100644
> --- a/fs/bcachefs/super.c
> +++ b/fs/bcachefs/super.c
> @@ -2369,7 +2369,7 @@ struct bch_fs *bch2_fs_open(darray_const_str *devices,
>  	}
>  
>  	if (opts->nochanges && !opts->read_only) {
> -		ret = bch_err_throw(c, erofs_nochanges);
> +		ret = -BCH_ERR_erofs_nochanges;
>  		goto err_print;
>  	}
>  
> -- 
> 2.49.0
> 

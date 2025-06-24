Received: from out-180.mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3AC01A2545
	for <linux-bcachefs@vger.kernel.org>; Tue, 24 Jun 2025 20:28:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750796882; cv=none; b=aJvfa1OAF1n7uX0x59VQQL0klatRWHa1AJp4nkPY+Hhw83Ran9yaB/uIpGcab8xzBwa7NWjIzxSZAA+4IdBN5iuFnmz5UCFoq5DUC9rbybhbuZ3S9LGA02O9fr1s+AYEuHh9SrWEjY+m5JwDkBOxjLE8V16WhCYLE+R84GxAx3Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750796882; c=relaxed/simple;
	bh=tB/Xo74wrLATid+uzHvf+EZvYvDwEWW4foo7I0mIE9Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jmKmVzzL8CBKZ/eXBtUnGDC2wUiYCdkRC5jeInR3KxtoT7CRYjp5MuS2TASfEPwQdY1lwUsemCiAoPQHaXBcf5vDOe7ckLSBegirraupppK6FizOxzxV6h9zhlcHbQZ+RjvFPKyi6rqCK8ECaxeqM4tO2WP653aY62typOzA9v8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=fU0Ucq2Z; arc=none smtp.client-ip=95.215.58.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="fU0Ucq2Z"
Date: Tue, 24 Jun 2025 16:27:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1750796879;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Y+6/N6ENV/cVQH4C6mItQ2XGZILmk3Caqn91cFnyZ+A=;
	b=fU0Ucq2Zozn5lIme8umd+NPvnYdbeq8n+vgerZyyHe52W8djl0BAxU8Rw1jzxQGItfO/zu
	5EFjV/tvqGjcsYRDhHnB1mm4nQ1XGWXOstSwAncHxwj0b3Y5bhqq8bH6X60iRvQSjAVC0F
	4ARHps6J7H0XRlAknziGvzTfddv/ONc=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Alan Huang <mmpgouride@gmail.com>
Cc: linux-bcachefs@vger.kernel.org, 
	syzbot+d540192e763531d307ff@syzkaller.appspotmail.com
Subject: Re: [PATCH] bcachefs: Don't unlock the trans if ret doesn't match
 BCH_ERR_operation_blocked
Message-ID: <qcn736sc3xd324fcyg77teebjviazwljcwpjevmwngwqv36sdy@j42qf7bago65>
References: <20250624191027.1157638-1-mmpgouride@gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250624191027.1157638-1-mmpgouride@gmail.com>
X-Migadu-Flow: FLOW_OUT

On Wed, Jun 25, 2025 at 03:10:27AM +0800, Alan Huang wrote:
> Reported-by: syzbot+d540192e763531d307ff@syzkaller.appspotmail.com
> Signed-off-by: Alan Huang <mmpgouride@gmail.com>

thanks! applied

> ---
>  fs/bcachefs/btree_update_interior.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/bcachefs/btree_update_interior.c b/fs/bcachefs/btree_update_interior.c
> index 7bf1bd6a6e92..553059b33bfd 100644
> --- a/fs/bcachefs/btree_update_interior.c
> +++ b/fs/bcachefs/btree_update_interior.c
> @@ -1287,10 +1287,11 @@ bch2_btree_update_start(struct btree_trans *trans, struct btree_path *path,
>  
>  		do {
>  			ret = bch2_btree_reserve_get(trans, as, nr_nodes, target, flags, &cl);
> -
> +			if (!bch2_err_matches(ret, BCH_ERR_operation_blocked))
> +				break;
>  			bch2_trans_unlock(trans);
>  			bch2_wait_on_allocator(c, &cl);
> -		} while (bch2_err_matches(ret, BCH_ERR_operation_blocked));
> +		} while (1);
>  	}
>  
>  	if (ret) {
> -- 
> 2.48.1
> 

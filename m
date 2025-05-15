Received: from out-189.mta1.migadu.com (out-189.mta1.migadu.com [95.215.58.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2939D145B3E
	for <linux-bcachefs@vger.kernel.org>; Thu, 15 May 2025 17:07:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747328826; cv=none; b=ZbSAO2tP/SBQgGvHe8OUYIHUpZPKF8T/JA6a7ySf5hvfsT72ke9kZ7+kdZq7oIPEKj0EAT3ejFl796vCWGP99X87EVt2xbqcUKTe4hfI9kjl+iX5WFa4M+ZBbHXJrh8v5UoJ34rHqgDf+A5ezvXwVMP9ZHAwQaxfZlPi2HHHt3Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747328826; c=relaxed/simple;
	bh=Ph9Z6PZSsqZZilCQ/600W12IAdrXuPK1VjN/FUmVbQE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IZlOj5lyx2rMxSlxbXIDK2pe1UzV2fcwM0tE6ZkFAjNdAPP+6iBmtjuwvPN2loDuYktK/sQLwSAEmKnim+mYJn+tHvbhpw0F3n9N41V3uhsqhvAjr/QOnT7I7Gt4/sb10VauhjXfig72D/aSHHefneFiup4QkCUhErR6Qwd7c0I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=S1Bko8zM; arc=none smtp.client-ip=95.215.58.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="S1Bko8zM"
Date: Thu, 15 May 2025 13:06:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1747328821;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=zdV9GmtBhkCZGizgBlsTU3TJhj0KDDWIcXFTIYEf35o=;
	b=S1Bko8zMsTZ9w/ogd0+J9Ie6zzo/89B1L5R2xMs4PGh9CrePE76fsgvHSVnqfoKtxH1PIN
	QpUfCsycy9/0V0suEKsiApnXJkSJ/SN7oOyMgOM4mL4ul9D7RgqJT9bwo1UD93RnardQpq
	3MaJYnmWRCOj3GIup+xaprYfG34xFUE=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Alan Huang <mmpgouride@gmail.com>
Cc: linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH 2/2] bcachefs: Early return to avoid unnecessary lock
Message-ID: <wi2a3fypc2l6jx7formhbmfnklumcm3vft7t3c6wjzjtajec2b@7i7czdoqwnjh>
References: <20250512184426.72038-1-mmpgouride@gmail.com>
 <20250512184426.72038-2-mmpgouride@gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250512184426.72038-2-mmpgouride@gmail.com>
X-Migadu-Flow: FLOW_OUT

On Tue, May 13, 2025 at 02:44:26AM +0800, Alan Huang wrote:
> Signed-off-by: Alan Huang <mmpgouride@gmail.com>

Applied

> ---
>  fs/bcachefs/alloc_background.c | 13 ++++++-------
>  1 file changed, 6 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/bcachefs/alloc_background.c b/fs/bcachefs/alloc_background.c
> index ac27735c11e5..043f4814a0d0 100644
> --- a/fs/bcachefs/alloc_background.c
> +++ b/fs/bcachefs/alloc_background.c
> @@ -2585,19 +2585,18 @@ u64 bch2_min_rw_member_capacity(struct bch_fs *c)
>  static bool bch2_dev_has_open_write_point(struct bch_fs *c, struct bch_dev *ca)
>  {
>  	struct open_bucket *ob;
> -	bool ret = false;
>  
>  	for (ob = c->open_buckets;
>  	     ob < c->open_buckets + ARRAY_SIZE(c->open_buckets);
>  	     ob++) {
> -		spin_lock(&ob->lock);
> -		if (ob->valid && !ob->on_partial_list &&
> -		    ob->dev == ca->dev_idx)
> -			ret = true;
> -		spin_unlock(&ob->lock);
> +		scoped_guard(spinlock, &ob->lock) {
> +			if (ob->valid && !ob->on_partial_list &&
> +			    ob->dev == ca->dev_idx)
> +				return true;
> +		}
>  	}
>  
> -	return ret;
> +	return false;
>  }
>  
>  void bch2_dev_allocator_set_rw(struct bch_fs *c, struct bch_dev *ca, bool rw)
> -- 
> 2.48.1
> 

Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA8A4338596
	for <linux-bcachefs@vger.kernel.org>; Fri, 12 Jun 2026 22:01:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781301674; cv=none; b=AnNwDe31PseCng3gFgIOhw80H6SXCEprucy29oZCSIxRICECilYGtyG+6n9x8hUyzQ/pE1hiA52C0A60M05F0zLW7blIl1sf4Bj51x3X14KTiLauq5H1qFDId0jJtVD7llkLEKWI9txlU5V5DPGV77sV/WPGDoYHN3DjZf4gldA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781301674; c=relaxed/simple;
	bh=hBi+YP/gPochXjd4iQ/0vqiDCeM6pKEmr6oKD0kyo60=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QDGTg/Ao428DBd5oa5Zeqn2Pxis0Fk0vt3MPidE4YG0sG38S9PhPNKPWgck06eUZ29u5d75q14yFWHOcA2Y0ggG9p+X4IvFjCvg1WoRy5Na2Tq/hv4jVya5gcCY0nN2PsflCL048Tjm+I9omikcqcuUIZXdzfHxqZaiWNzWdyYA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=gQKJBZ8M; arc=none smtp.client-ip=91.218.175.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="gQKJBZ8M"
Date: Fri, 12 Jun 2026 18:01:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1781301669;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2l2kbt+FJ3IbbchmMpGUDyVNwQ/1lgFF1pQjBhk/n9c=;
	b=gQKJBZ8MHt9idTg3D+e037VC43QxRgRF1vSxtFF62SaPz4nTYgIAHTrLb+UExe01yinI7v
	h7wZl40sjRyIcXnnj1Xzqudv4ze0rY48cb6pEMQmmxVhtPaLOqQg08RvLO38hxwgXAmZkf
	kqiClN4LxaMWE4JnQ0Qq1palAtjbZ7Y=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Mikhail Dmitrichenko <mdmitrichenko@astralinux.ru>
Cc: linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	lvc-project@linuxtesting.org
Subject: Re: [PATCH] bcachefs: avoid truncating fiemap extent length
Message-ID: <aiyBmggzwkqvZXWJ@moria.home.lan>
References: <20260610105547.129545-1-mdmitrichenko@astralinux.ru>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260610105547.129545-1-mdmitrichenko@astralinux.ru>
X-Migadu-Flow: FLOW_OUT

On Wed, Jun 10, 2026 at 01:55:47PM +0300, Mikhail Dmitrichenko wrote:
> bkey sizes are stored in sectors as u32, while fiemap reports byte
> lengths as u64. Shifting k.k->size before widening performs the
> conversion in 32 bits, so an extent of 4 GiB or larger can wrap before
> it is passed to fiemap_fill_next_extent().
> 
> Compute the byte length after casting the sector count to u64 and reuse
> it for all bch2_fill_extent() cases.
> 
> Found by Linux Verification Center (linuxtesting.org) with SVACE.
> 
> Signed-off-by: Mikhail Dmitrichenko <mdmitrichenko@astralinux.ru>

Nice catch! Applied.

> ---
>  fs/bcachefs/vfs/fiemap.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/bcachefs/vfs/fiemap.c b/fs/bcachefs/vfs/fiemap.c
> index 067e191cf8d0..18a44622a7b0 100644
> --- a/fs/bcachefs/vfs/fiemap.c
> +++ b/fs/bcachefs/vfs/fiemap.c
> @@ -23,6 +23,7 @@ static int bch2_fill_extent(struct bch_fs *c,
>  			    struct bch_fiemap_extent *fe)
>  {
>  	struct bkey_s_c k = bkey_i_to_s_c(fe->kbuf.k);
> +	u64 len = (u64) k.k->size << 9;
>  	unsigned flags = fe->flags;
>  
>  	BUG_ON(!k.k->size);
> @@ -54,20 +55,20 @@ static int bch2_fill_extent(struct bch_fs *c,
>  			try(fiemap_fill_next_extent(info,
>  						bkey_start_offset(k.k) << 9,
>  						offset << 9,
> -						k.k->size << 9, flags|flags2));
> +						len, flags|flags2));
>  		}
>  
>  		return 0;
>  	} else if (bkey_extent_is_inline_data(k.k)) {
>  		return fiemap_fill_next_extent(info,
>  					       bkey_start_offset(k.k) << 9,
> -					       0, k.k->size << 9,
> +					       0, len,
>  					       flags|
>  					       FIEMAP_EXTENT_DATA_INLINE);
>  	} else if (k.k->type == KEY_TYPE_reservation) {
>  		return fiemap_fill_next_extent(info,
>  					       bkey_start_offset(k.k) << 9,
> -					       0, k.k->size << 9,
> +					       0, len,
>  					       flags|
>  					       FIEMAP_EXTENT_DELALLOC|
>  					       FIEMAP_EXTENT_UNWRITTEN);
> -- 
> 2.54.0.windows.1
> 

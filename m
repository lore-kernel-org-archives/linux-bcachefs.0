Received: from out-175.mta0.migadu.com (out-175.mta0.migadu.com [91.218.175.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6248D290F
	for <linux-bcachefs@vger.kernel.org>; Tue, 28 Jan 2025 00:01:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738022469; cv=none; b=PkodjabRJEzD62+HX7xEb4MZ9lnSFDOGUV1euKRxK9DURwkXjPkVeBMawpbqJQBxWYYyH09ArVoVwsQQtUceL3T0xTfHk1MUrYAcCYOxUVlh66mylJYSKkqlrggo9QiEr+fu50aQ7cFlCVN9Ir2eaPp0caUIXhxLuC+dtFZokrM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738022469; c=relaxed/simple;
	bh=oMdSGUNzWcD0gzORWoaBHD4cQrQyMUbZBv4aLL2v4mI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Vx5t/GddfMG0Wh4T+/7DVMl3FUqMpCsnbZADWa3BJIG7hmQlOSMDM00To+MmlDPoowd8BdHhdYhxSHO2+mWVqwhOIL5U00ePfvq0i8qDcBtkBrJZ7z1BLuKFnztrFZxRS3rN564B0nY0viviTv8iK8jJf+UT1JTpKVmAF7ZkGkg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Yy+sfytH; arc=none smtp.client-ip=91.218.175.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Yy+sfytH"
Date: Mon, 27 Jan 2025 19:00:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1738022459;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Q11W15i8iO2rzn5tpaiUy0BFh/h6IRoRskOMkCgB97w=;
	b=Yy+sfytHzJzzoTdcbizJA4X6Xc6qkZ8Ix/78ijDZXYUuuX4plLtjvoXypInNZyPExwrEWy
	CxJ28B6Sa5G811E0kA49vr8sZyW7qsF1wPntYx0gZF5TljZMf+B/QEvimLqqe96p0obrDS
	T+FEzRba1RM/XrViWrGay7w9OsaoR2s=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Alan Huang <mmpgouride@gmail.com>
Cc: linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH] bcachefs: Fix subtraction underflow
Message-ID: <rllztspognxwsvljntuhnetzx2fymmargdr4mkan2krz3lo2gh@udnyxohwqlae>
References: <20250127091241.470892-1-mmpgouride@gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250127091241.470892-1-mmpgouride@gmail.com>
X-Migadu-Flow: FLOW_OUT

On Mon, Jan 27, 2025 at 05:12:41PM +0800, Alan Huang wrote:
> When ancestor is less than IS_ANCESTOR_BITMAP, we would get an incorrect
> result.
> 
> Signed-off-by: Alan Huang <mmpgouride@gmail.com>
> ---
>  fs/bcachefs/snapshot.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/bcachefs/snapshot.c b/fs/bcachefs/snapshot.c
> index c54091a28909..ede0b480e7d4 100644
> --- a/fs/bcachefs/snapshot.c
> +++ b/fs/bcachefs/snapshot.c
> @@ -146,8 +146,9 @@ bool __bch2_snapshot_is_ancestor(struct bch_fs *c, u32 id, u32 ancestor)
>  		goto out;
>  	}
>  
> -	while (id && id < ancestor - IS_ANCESTOR_BITMAP)
> -		id = get_ancestor_below(t, id, ancestor);
> +	if (likely(ancestor >= IS_ANCESTOR_BITMAP))
> +		while (id && id < ancestor - IS_ANCESTOR_BITMAP)
> +			id = get_ancestor_below(t, id, ancestor);

That's not right, if ancestor < IS_ANCESTOR_BITMAP the bitmap would
still need to be initialized.

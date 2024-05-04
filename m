Received: from out-175.mta0.migadu.com (out-175.mta0.migadu.com [91.218.175.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAEF1AD2C
	for <linux-bcachefs@vger.kernel.org>; Sat,  4 May 2024 23:35:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714865725; cv=none; b=VHo85+6Ykwu089NZYm0CVL+ac1PqFN34KBcffhoPCjTGUlbDGWw+PfMC9aCa/jcavEedeVrSSLAWv/kQk8Dnbg0vCy1kcA/uHeVDNMVD8ktMOyXuRxdxauFJmB5EZ1vmd21aTf5sdsYinwDDyFbMVNhmHIY1xUzX4Y46ML1t/sU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714865725; c=relaxed/simple;
	bh=lIu68v/43w1401qBlqzoP/iY9yedGzGnDJgG9Mp4xTU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=c4BQHiSiCQyKxgDt2E3wSFJ/MqiNGmVlSuttXOg1yyTIrSscUC/EL5ZD8hKbv9wL+LNtH7O+Rb/LhblsjeNMai28/jhwxJGL9c/+b4oGnCFjckEA2cP5RPUyH5nx1wBubYAgkfkNjc5U2xzwBBXPMZ5xnZOfTqffdZ89qEvIruE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=lwrT1zX1; arc=none smtp.client-ip=91.218.175.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="lwrT1zX1"
Date: Sat, 4 May 2024 19:35:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1714865718;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Fet3+NvTwRfdfDRLigf+Ncvcni2kYjAwsVuysXQpROs=;
	b=lwrT1zX1koYGHAYeXFQ3MqzbNJavF7sg7oPyE8YoRpaWI+bGmLBY8ugbVMgY/VHi3ch0J3
	YzNeAvuH6Ue6r6kxQx+eoA1qV8/yvifNFg0iz2Zu07iGbYPeJYcuSilU4NKNlmf7eb4pnJ
	HN4fZvhw4cv7V21ktjxqBIlD6ytC0EA=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Reed Riley <reed@riley.engineer>
Cc: "linux-bcachefs@vger.kernel.org" <linux-bcachefs@vger.kernel.org>
Subject: Re: [PATCH] bcachefs: fix overflow in fiemap
Message-ID: <2x2pkl56bpo6ptinyp6kpjgrazbiwzsccw3qxb3jv7u775eesb@3bqc6om37j6f>
References: <7qU8xNKAHxFIkSlLrXO1B6kyf-7DvRoJRgZloXK5qHovOzUFYbbCYhe_9Tzv1J6MgiXcakyIFiovCX3HtotUEE9fsV25jYmifgyMz_wa-Ik=@riley.engineer>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7qU8xNKAHxFIkSlLrXO1B6kyf-7DvRoJRgZloXK5qHovOzUFYbbCYhe_9Tzv1J6MgiXcakyIFiovCX3HtotUEE9fsV25jYmifgyMz_wa-Ik=@riley.engineer>
X-Migadu-Flow: FLOW_OUT

On Sat, May 04, 2024 at 10:12:23PM +0000, Reed Riley wrote:
> filefrag (and potentially other utilities that call fiemap) sometimes
> pass ULONG_MAX as the length.  fiemap_prep clamps excessively large
> lengths - but the calculation of end can overflow if it occurs before
> calling fiemap_prep.  When this happens, filefrag assumes it has read to
> the end and exits.
> 
> Signed-off-by: Reed Riley <reed@riley.engineer>

Applied!

> ---
>  fs/bcachefs/fs.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/bcachefs/fs.c b/fs/bcachefs/fs.c
> index 4e4442bc71e3..ff01c954bff8 100644
> --- a/fs/bcachefs/fs.c
> +++ b/fs/bcachefs/fs.c
> @@ -996,7 +996,7 @@ static int bch2_fiemap(struct inode *vinode, struct fiemap_extent_info *info,
>         struct btree_iter iter;
>         struct bkey_s_c k;
>         struct bkey_buf cur, prev;
> -       struct bpos end = POS(ei->v.i_ino, (start + len) >> 9);
> +       struct bpos end;
>         unsigned offset_into_extent, sectors;
>         bool have_extent = false;
>         u32 snapshot;
> @@ -1006,6 +1006,7 @@ static int bch2_fiemap(struct inode *vinode, struct fiemap_extent_info *info,
>         if (ret)
>                 return ret;
>  
> +       end = POS(ei->v.i_ino, (start + len) >> 9);
>         if (start + len < start)
>                 return -EINVAL;
>  
> -- 
> 2.44.0
> 

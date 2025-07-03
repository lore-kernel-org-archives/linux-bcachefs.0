Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07EFA17C208
	for <linux-bcachefs@vger.kernel.org>; Thu,  3 Jul 2025 01:49:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751507359; cv=none; b=Wx5Un1DThyGz84KOfu+iJbc2cXbd0waMd47i9Chv4S5hvfnSBVHmv4VK6nTtiqyXI/Qj4mestryumkNn8N2k9SPb9WwDDhvQqxDYXPa/CmN5X8zvyMT/TOCFqrYFHEkmKodTN9K6i06piaW90nrzpYjv465Yu87N7JU1com7uaY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751507359; c=relaxed/simple;
	bh=AU/WsG2v03zvjcItiwonHMoIKcP0gh1PhbyAPAJDgpc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KtXKF3bjfKDSNp/bOndEywjRcx8TedhqASiX2Mm3ywAhhhiroQjtwsQEhGii/IrmkhUUTnJqcwKrGOa0OQs4hUF8DudyXNgXf1DI4LaUUym8xbBgMgGzjXzYcQSU2nJ6+1KXDqEtd0GDglwYDFJnfdaLRZbtJuztDtmUl9mp91A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=VEsYPqoR; arc=none smtp.client-ip=91.218.175.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="VEsYPqoR"
Date: Wed, 2 Jul 2025 21:49:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1751507354;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=nOwj7//FLp/FYC5pzQAtJEk4nUo/1o66BDqPxTN7RKo=;
	b=VEsYPqoRd6edTs8WIdGdSkP84rtmVoyGUo5p9kWiHhobXOAN3KSDIwK8MKTifLSnMsEvut
	xXcottAj7HxNZEMMdoDm/6hW3nEhv0eTwV8QjyQdseqGPtFDwKAbIkaHIi2yE+EAFRZtm+
	kBhMt/wNvNUNUMMzoHrCDhVSUSK6ouE=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: himikof@gmail.com
Cc: linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH] bcachefs: Suppress unnecessary inode_i_sectors_wrong
 fsck error
Message-ID: <f7hpbrshr7noebc5qeazeu43vysucvn3tb6gryozp454nne5qp@6hyupzp5f7ng>
References: <20250703-isectors-not-wrong-v1-1-37002be151e0@gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250703-isectors-not-wrong-v1-1-37002be151e0@gmail.com>
X-Migadu-Flow: FLOW_OUT

On Thu, Jul 03, 2025 at 02:59:11AM +0300, Nikita Ofitserov via B4 Relay wrote:
> From: Nikita Ofitserov <himikof@gmail.com>
> 
> It is possible that fsck first miscounted the expected sector count (due
> to applying other fixes at the same time, for example) and then
> corrected itself using extents. No need to log an fsck error and
> write the inode in this case.
> 
> Signed-off-by: Nikita Ofitserov <himikof@gmail.com>

Thanks, applied.

> ---
>  fs/bcachefs/fsck.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/bcachefs/fsck.c b/fs/bcachefs/fsck.c
> index 1ceca63c87a3bf3eb75d396f7a10949c502b0e8d..471e93a3f00c637050b5c485d72b27cfb284282d 100644
> --- a/fs/bcachefs/fsck.c
> +++ b/fs/bcachefs/fsck.c
> @@ -1638,7 +1638,8 @@ static int check_i_sectors_notnested(struct btree_trans *trans, struct inode_wal
>  			i->count = count2;
>  		}
>  
> -		if (fsck_err_on(!(i->inode.bi_flags & BCH_INODE_i_sectors_dirty),
> +		if (fsck_err_on(!(i->inode.bi_flags & BCH_INODE_i_sectors_dirty) &&
> +				i->inode.bi_sectors != i->count,
>  				trans, inode_i_sectors_wrong,
>  				"inode %llu:%u has incorrect i_sectors: got %llu, should be %llu",
>  				w->last_pos.inode, i->inode.bi_snapshot,
> 
> ---
> base-commit: 14a12362bb22b3735c51ecdb712570a12992a695
> change-id: 20250703-isectors-not-wrong-8e8a126cf307
> 
> Best regards,
> -- 
> Nikita Ofitserov
> 
> 

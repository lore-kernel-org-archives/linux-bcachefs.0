Received: from out-174.mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23F216CDBA
	for <linux-bcachefs@vger.kernel.org>; Thu, 24 Oct 2024 11:31:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729769470; cv=none; b=gvGNZVb2kqVR5nJvRnZR7aozZm2fGzSSJZrMyPFpTyNAxd9cVoibbTZxP5CJIw9kswmmuGJPliBLjo7BuHtGcuhqsRkusmwZr0IA1Fc81WP8lCDyICg++hcTMQAwqHLJbjz/vWHwRyOamjEX3kjZleuGNx79DhqQ5O8lSBdORgk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729769470; c=relaxed/simple;
	bh=xGaFYpcMrNg/2MxThfOuYn0ruVYXwDp/ky5utRlTUs8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CEWDHjiWgYtnNNHA99EiXq8cU8ldZLdtsaDceOL7jtbIMKPwpoq1/ZL+C1j/nzAokKahVs0G68eYuZfiRyakbjFxexwh7LnBGLuwilHbbeYutkaO6aq3hTrejEn1EzhMmSCA4lFwRPAfMW1H6b8acJtmnBnl9GCK3S+qsdPB1II=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Ni5VYoQu; arc=none smtp.client-ip=95.215.58.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Ni5VYoQu"
Date: Thu, 24 Oct 2024 07:30:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1729769459;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Ag0AhWZm7Q9w66/0CBibDtssTupUcNrYwF/ey22oIro=;
	b=Ni5VYoQuHsyGqhL8B4Wy4iut/Okyzo/QLW6kfI9Fh0O74g7wn7igaSGUdRhwdpzTqjxXH/
	rt/+gkLQINk/z4ETRcZeYk8ndMM2Q6OhYGXo0RPJkAxhVcXwDvnpaBg2Ohtcte5lO23CHr
	s4bdYNVG51UiWFVC8yMRqG8bCEAKAUc=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Jeongjun Park <aha310510@gmail.com>
Cc: mmpgouride@gmail.com, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzbot+7f45fa9805c40db3f108@syzkaller.appspotmail.com
Subject: Re: [PATCH v3] bcachefs: fix shift oob in alloc_lru_idx_fragmentation
Message-ID: <k6wt52qxkvfubt73ty7ix4s7gnxlh7336zsfkvz2umopuqofhu@j3grduxsmtxj>
References: <20241021154356.38221-1-aha310510@gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241021154356.38221-1-aha310510@gmail.com>
X-Migadu-Flow: FLOW_OUT

On Tue, Oct 22, 2024 at 12:43:56AM +0900, Jeongjun Park wrote:
> The size of a.data_type is set abnormally large, causing shift-out-of-bounds.
> To fix this, we need to add validation on a.data_type in 
> alloc_lru_idx_fragmentation().
> 
> Reported-by: syzbot+7f45fa9805c40db3f108@syzkaller.appspotmail.com
> Fixes: 260af1562ec1 ("bcachefs: Kill alloc_v4.fragmentation_lru")
> Signed-off-by: Jeongjun Park <aha310510@gmail.com>

Thanks, applied

> ---
>  fs/bcachefs/alloc_background.h | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/fs/bcachefs/alloc_background.h b/fs/bcachefs/alloc_background.h
> index f8e87c6721b1..163a67b97a40 100644
> --- a/fs/bcachefs/alloc_background.h
> +++ b/fs/bcachefs/alloc_background.h
> @@ -168,6 +168,9 @@ static inline bool data_type_movable(enum bch_data_type type)
>  static inline u64 alloc_lru_idx_fragmentation(struct bch_alloc_v4 a,
>  					      struct bch_dev *ca)
>  {
> +	if (a.data_type >= BCH_DATA_NR)
> +		return 0;
> +
>  	if (!data_type_movable(a.data_type) ||
>  	    !bch2_bucket_sectors_fragmented(ca, a))
>  		return 0;
> --

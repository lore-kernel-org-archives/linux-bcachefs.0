Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E217817D2
	for <linux-bcachefs@vger.kernel.org>; Sun, 23 Mar 2025 14:03:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742738614; cv=none; b=AN2+C/I2OnBRTFCCuyPI/QovFsigOfotIiSZEEJlq9L5Nlw2/7ikP+8iJK3HYYrkhSsEdJHHge4xjtxJsoOKtw8mTfsEE64EbPQEsCE8f/NLTK33+TTlLxkeNrOwTM/u67Lb7wY5iGnWwyLWmqy0L3JSGhf3FKvpEFcv1O9A6SQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742738614; c=relaxed/simple;
	bh=t3e3ZzW6uHccucb+NCRHL+9CiheGVYZlTc8TQpH57Ag=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tOsaAU4ZTP/rH4WKEiq74CWecW2EjJGO7sQ/Jeq8PMenP5YFeTJ8JBult0AD6vWQp80jqamSgB8p+GBiqJfAmPeCTRAL5zO9ywWUhXFsi8DIMMW/K2PVXN1BHzrVv3XpGTvCLkYk703+RjDKddqCbSCteGjDlP21xZ2AimixvsY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Mu8n9KQ0; arc=none smtp.client-ip=91.218.175.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Mu8n9KQ0"
Date: Sun, 23 Mar 2025 10:03:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1742738608;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=OI9vv1l36WF0yP/IMZOlN7jnxol4Ycr+FUzcV3tV3es=;
	b=Mu8n9KQ0eCh45h32l37vC3/xPBBYY/p3YvY2YCwdGxM3qvpAJTsQ5+EmPbG9328zbB3GG4
	KEmFYG2K4q1YL8VyYUq8/0mPCtwC/7+77TPc+E55nGN7Mf3FJg3bSa7IVASinn/X7DlnLj
	5j8OZeL8sWawiVZ/He1DdBECkn6RCAk=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Alan Huang <mmpgouride@gmail.com>
Cc: linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH v2] bcachefs: Add missing smp_rmb()
Message-ID: <mlklkzs4sgq7fnwayq4ozcaaavi5inqghbi7docxyuukedsu5q@e65utej7lejt>
References: <20250323042021.57711-1-mmpgouride@gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250323042021.57711-1-mmpgouride@gmail.com>
X-Migadu-Flow: FLOW_OUT

On Sun, Mar 23, 2025 at 12:20:21PM +0800, Alan Huang wrote:
> The smp_rmb() guarantees that reads from reservations.counter
> occur before accessing cur_entry_u64s. It's paired with the
> atomic64_try_cmpxchg in journal_entry_open.
> 
> Signed-off-by: Alan Huang <mmpgouride@gmail.com>

We're only using this once, the barrier suffices here.

> ---
> 
> Since I'm touching this part, add the READ_ONCE anyway.
> 
> 
>  fs/bcachefs/journal.h | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/bcachefs/journal.h b/fs/bcachefs/journal.h
> index ab68c5c4d8d8..fe362ddd2895 100644
> --- a/fs/bcachefs/journal.h
> +++ b/fs/bcachefs/journal.h
> @@ -350,9 +350,11 @@ static inline int journal_res_get_fast(struct journal *j,
>  
>  		/*
>  		 * Check if there is still room in the current journal
> -		 * entry:
> +		 * entry, smp_rmb() guarantees that reads from reservations.counter
> +		 * occur before accessing cur_entry_u64s:
>  		 */
> -		if (new.cur_entry_offset + res->u64s > j->cur_entry_u64s)
> +		smp_rmb();
> +		if (new.cur_entry_offset + res->u64s > READ_ONCE(j->cur_entry_u64s))
>  			return 0;
>  
>  		EBUG_ON(!journal_state_count(new, new.idx));
> -- 
> 2.48.1
> 

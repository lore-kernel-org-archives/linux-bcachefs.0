Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA01720D4E6
	for <linux-bcachefs@vger.kernel.org>; Tue, 18 Mar 2025 13:39:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742305175; cv=none; b=qWpGq/kIunUpN+xLbybkEZaNeXiOVKnFEFhOSddd6+K3lOEEXLO8eKoyG9CpNUhphhaLPo63X4CWtzTf3RLPIqfZsSn7H9gAd/BntRK6lEcD27dC4Idfgl+kJgOZvHxNJgFi2sLYx2+FYeci37MRC1puFxoRO/BkMONp8W8qegU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742305175; c=relaxed/simple;
	bh=++oT4a8t+zXc++nUahNOe3wtZnUYg4z8FlHPGqF31Bc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Pw2AvubR9Ru+WgyfhYf/Tf8e7pvVJwaq7TyLPVgarAQBy3OJx8x3gg3s5SxHmd09NiSgFKYnN7o4Uj9GB41xSoNGtKTFe2YQ1kytJLLq+931wj0++8/F2e1iPu3YXAPW5o5bTCw8oUZ+Pt3KFpC3zKPDTttljlWFiikQxIbEEoA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=eEibi4DE; arc=none smtp.client-ip=91.218.175.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="eEibi4DE"
Date: Tue, 18 Mar 2025 09:39:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1742305170;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=tp4yLx2NwbZARlA1RwqYS2P3BMtdhn2wXTJn/6zzqTI=;
	b=eEibi4DEJdhPCNivUR3XbMEuO55awLlPyEQUJn/hMBaMzvq7J5MMpLKcNmeP97kwjhf7pL
	+5sLvmbmANKdURMr4fP9bFa2bx7qHiVw5yYjijj1c5rhBBfnwsBIMjFvN+FeRsUy4pwmTQ
	sP4YFbX337VjRrZ0XWS/gJPxAdp3ea8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Alan Huang <mmpgouride@gmail.com>
Cc: linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH 1/2] bcachefs: Add missing smp_rmb()
Message-ID: <fk2m6avva5urejkbhuakahlyptekieyxievrwigrypiqyqdylc@izmg7tw5lef3>
References: <20250318075001.1976165-1-mmpgouride@gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250318075001.1976165-1-mmpgouride@gmail.com>
X-Migadu-Flow: FLOW_OUT

On Tue, Mar 18, 2025 at 03:50:00PM +0800, Alan Huang wrote:
> The smp_rmb() guarantees that reads from reservations.counter
> occur before accessing cur_entry_u64s. It's paired with the
> atomic64_try_cmpxchg in journal_entry_open.
> 
> Signed-off-by: Alan Huang <mmpgouride@gmail.com>

It would also work to recheck j->cur_entry_u64s after the cmxpchg() and
acquiring the journal reservation, backing out in the event of a race.

This is performance sensitive enough that we may want to test both
options, as well as moving cur_entry_u64s to the same cacheline as the
journal reservation state.

> ---
>  fs/bcachefs/journal.h | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/bcachefs/journal.h b/fs/bcachefs/journal.h
> index ab68c5c4d8d8..47828771f9c2 100644
> --- a/fs/bcachefs/journal.h
> +++ b/fs/bcachefs/journal.h
> @@ -350,8 +350,10 @@ static inline int journal_res_get_fast(struct journal *j,
>  
>  		/*
>  		 * Check if there is still room in the current journal
> -		 * entry:
> +		 * entry, smp_rmb() guarantees that reads from reservations.counter
> +		 * occur before accessing cur_entry_u64s:
>  		 */
> +		smp_rmb();
>  		if (new.cur_entry_offset + res->u64s > j->cur_entry_u64s)
>  			return 0;
>  
> -- 
> 2.48.1
> 

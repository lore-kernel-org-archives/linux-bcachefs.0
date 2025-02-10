Received: from out-180.mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 717E82580DB
	for <linux-bcachefs@vger.kernel.org>; Mon, 10 Feb 2025 16:28:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739204893; cv=none; b=RHiARAqU6u8kS2hsusHT/MnRwMlShdWySBOSvr2YYopWO/Y4HURtQBvGkJGopcolmNcb5jvrdhVmjppLvjeQYYCdIBTYjiq9vrURZeN1BtR+wCrYXhESjPjMxPDdvY7x444vWttPnyUheLrehwf1LXlxH2bYrfhT9bE8zhuz5v4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739204893; c=relaxed/simple;
	bh=O1lCHo9FEH62dAFU93XwSN3XBvbivQX+r488lcLIltg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Epx3+gRtt6l66mgNQubwbRVhvtQvpXLilz6rhxB//vzXVg7kQuUapXLhrKK0e+1gMa+oXFZtHs2lo1OCo7BVg81jqUgJFDlxE6EwutEM3M5NhQ0TenjLE+pfuNQC8LpzQdNIZzAiIhRUH8KT/aOxnZgqSBNoLuXaI2AkgbNiGnw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=hVeLpIea; arc=none smtp.client-ip=95.215.58.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="hVeLpIea"
Date: Mon, 10 Feb 2025 11:28:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1739204889;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=IEPk1IUPlAIMALgT08n24xC2gjS5W6MfiwlyJZFa/6o=;
	b=hVeLpIeaLVbOzL9qu54Cj7kwgG0RkLCrRNXdSJ2V0wZtT9yx8VukiMIaLttBfwnnBhf7Vz
	Se1st+dq7UdqzNWLbKwWEucZUgykM4BlYaiCcEMDGI6L0faFfQuXbxJgplAlYeTtvHdN0q
	DTeLI7XoD0ZTQluqxdsz3REiacBr89Y=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Alan Huang <mmpgouride@gmail.com>
Cc: linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH] bcachefs: Fix use after free
Message-ID: <glle55a36q4zzr72fa7a2n7gkp6z6xq26usmuxrojwlyctfxz7@mzhqlaumf64g>
References: <20250210030422.711912-1-mmpgouride@gmail.com>
 <20250210030422.711912-2-mmpgouride@gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250210030422.711912-2-mmpgouride@gmail.com>
X-Migadu-Flow: FLOW_OUT

On Mon, Feb 10, 2025 at 11:04:22AM +0800, Alan Huang wrote:
> acc->k.data should be used with the lock hold:

<snipped>

> 
> Signed-off-by: Alan Huang <mmpgouride@gmail.com>


Test this with lockdep (you know how to edit the lists of tests the CI
runs, right?

mark_lock usage is a giant mess, and calling percpu_down_read()
recursively by accident will mostly work, until it doesn't.

> ---
>  fs/bcachefs/disk_accounting.h | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/fs/bcachefs/disk_accounting.h b/fs/bcachefs/disk_accounting.h
> index 5360cbb3ec29..f4372cafea2e 100644
> --- a/fs/bcachefs/disk_accounting.h
> +++ b/fs/bcachefs/disk_accounting.h
> @@ -210,11 +210,13 @@ static inline void bch2_accounting_mem_read_counters(struct bch_accounting_mem *
>  static inline void bch2_accounting_mem_read(struct bch_fs *c, struct bpos p,
>  					    u64 *v, unsigned nr)
>  {
> +	percpu_down_read(&c->mark_lock);
>  	struct bch_accounting_mem *acc = &c->accounting;
>  	unsigned idx = eytzinger0_find(acc->k.data, acc->k.nr, sizeof(acc->k.data[0]),
>  				       accounting_pos_cmp, &p);
>  
>  	bch2_accounting_mem_read_counters(acc, idx, v, nr, false);
> +	percpu_up_read(&c->mark_lock);
>  }
>  
>  static inline struct bversion journal_pos_to_bversion(struct journal_res *res, unsigned offset)
> -- 
> 2.47.0
> 

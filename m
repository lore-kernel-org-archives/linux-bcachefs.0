Received: from out-171.mta1.migadu.com (out-171.mta1.migadu.com [95.215.58.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CC71381AD
	for <linux-bcachefs@vger.kernel.org>; Sun, 21 Jan 2024 16:17:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705853859; cv=none; b=JqOR6Wfe9j+vOXQUCMoelptYgKificYAL5f2wK+eBUOorfhEv1hNbNid2RdTGXIuxpD7pJ2gyIMmn873fnfZDLJ1JpnxLG4Z08r0ysxsY6MQjuL+WM+Lk43nlIM/N/Xjo2ilrkROY6Fv/d0g4n6NZleY4qeITrbuv3gEqFT7xpU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705853859; c=relaxed/simple;
	bh=gvZEIS/jBXoNpzvSUbni12ioK+70WxbZ/7qDCGgisGU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ru9F7JU7981jSIApnhqkA2wFDPDJkk/cLkwm3rr2yHzAlFKEG06NY3/vRdvw2cA2MJeyi6cKhlzvtiLH6mlMBui0VKmEHRasVn8hq7f+uTsfItz9kxrMmCyBfsmKCHTcKBECpOiadsEd075Qi5wsQBZmJMFRIX8yiLLmvhJEEUo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=i+cijJ+/; arc=none smtp.client-ip=95.215.58.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="i+cijJ+/"
Date: Sun, 21 Jan 2024 11:17:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1705853854;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=aBUz93f2jOBbyF/oUQgr9OHoouGr0fMqGUXTlJhH8ow=;
	b=i+cijJ+/iEse3wEqoLFRw0Z7YihzWsRXTkI3hPNaqKzJSedQgnHxJeLua7LGU/6vuyma3F
	RS1r/TSXRG/ySNsSSSKxMXYRq8zBdPUEWS9OPkmwxhiyFdJzqlM9ODvNmADwPsIVHpXwpF
	BBlmE1dnYIMmrQe8m2WfLCW03Y59kLg=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Kuan-Wei Chiu <visitorckw@gmail.com>
Cc: colyli@suse.de, bfoster@redhat.com, jserv@ccns.ncku.edu.tw, 
	linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org, linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH 2/5] bcachefs: Introduce parent function for
 sort_cmp_size()
Message-ID: <vrzgjxym2gnawuds54s4lr4zqbldm6sxp5yksrz5467hcrzjtp@lphbsqbidqdm>
References: <20240121153649.2733274-1-visitorckw@gmail.com>
 <20240121153649.2733274-3-visitorckw@gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240121153649.2733274-3-visitorckw@gmail.com>
X-Migadu-Flow: FLOW_OUT

On Sun, Jan 21, 2024 at 11:36:46PM +0800, Kuan-Wei Chiu wrote:
> When dealing with array indices, the parent's index can be obtained
> using the formula (i - 1) / 2. However, when working with byte offsets,
> this approach is not straightforward. To address this, we have
> introduced a branch-free parent function that does not require any
> division operations to calculate the parent's byte offset.

This is a good commit message - but it would be even better if it was a
function comment on parent()

> 
> Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
> ---
> This patch has undergone unit testing using the following code [1].
> 
> [1]:
> static int test(void)
> {
>     size_t i, p, size, lsbit;
> 
>     for (i = 0; i < 10000; i++) {
>         size = get_random_u32() % (1U << 10);
>         lsbit = size & -size;
>         i = get_random_u32() % (1U << 20) * size + size;
>         p = parent(i, lsbit, size);
>         if (p != (i / size - 1) / 2 * size)
>             return -1;
>     }
> 
>     return 0;
> }
> 
>  fs/bcachefs/util.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/fs/bcachefs/util.c b/fs/bcachefs/util.c
> index bbc83b43162e..f5bbf96df2ce 100644
> --- a/fs/bcachefs/util.c
> +++ b/fs/bcachefs/util.c
> @@ -907,6 +907,13 @@ static inline void do_swap(void *base, size_t n, size_t size,
>  		  size);
>  }
>  
> +static inline size_t parent(size_t i, size_t lsbit, size_t size)
> +{
> +	i -= size;
> +	i -= size & -(i & lsbit);
> +	return i >> 1;
> +}
> +
>  void eytzinger0_sort(void *base, size_t n, size_t size,
>  		     int (*cmp_func)(const void *, const void *, size_t),
>  		     void (*swap_func)(void *, void *, size_t))
> -- 
> 2.25.1
> 

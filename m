Received: from out-180.mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CDA315666D
	for <linux-bcachefs@vger.kernel.org>; Wed, 29 Jan 2025 17:54:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738173265; cv=none; b=ELHBl0NC1dkI+kX9dELTSR+5JR+d3YcP+J6MlHo3QkcxxKFBHJTP2pY2waf5jnlF/aqe6vK8VbjjkVnHjiD73Jz7kPx0lRLZeZYprHVWxgHBbsm/Nbj/h8HEcuf+21mdZFinukZGIJaT4jwSInUmqCPw+QBusL/9oVSsqmlhiEg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738173265; c=relaxed/simple;
	bh=abfJDt2vhB/k3XPYQf7lSvycOlKjBSSFjHvJKdN4Mlc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jC7C2rFNuKJ/YvjW1G2DDTsfePxRf5MagQZ2+ahUHFMfVKk4c19/iL5cwKH99jPhsjl971MkW4LNavQnUUkkZ1E7YJVMr0pe9XTUziPZ3K8Dhmz1+oFEDsZVm8hLoiP30b6+EfFNUTXgaYh4wkNSyXpIrm6HKtbNoQiTpmFmGsU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ScsB/KLU; arc=none smtp.client-ip=95.215.58.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ScsB/KLU"
Date: Wed, 29 Jan 2025 12:54:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1738173261;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=V0gJvJd0aZp8TPlc0Ya9Y160dceo9DteP5VT8DjFn7Y=;
	b=ScsB/KLUv16xiKwVHmCG3j4WdXZPVGQ5MaVbbvgHGK9zUAXZr4nV5Qq8SihNtBxd2xV7cu
	9H8WaURUFhw/+7CwE+dkiR3t6MLbluNS3qIfEAj71djBBDPa/6N+flEEpOWhb1P2g6CAjy
	U9wtjwEXDznyr0mQP7A1uw4VORvi81g=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Jeongjun Park <aha310510@gmail.com>
Cc: linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] bcachefs: fix deadlock in journal_entry_open()
Message-ID: <w5chf3yqiak337ndy2jx7q2rqa5lkiwrfeyh5lgd3inu6inxj3@x3qwdcrsqyif>
References: <20250129171744.132477-1-aha310510@gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250129171744.132477-1-aha310510@gmail.com>
X-Migadu-Flow: FLOW_OUT

On Thu, Jan 30, 2025 at 02:17:44AM +0900, Jeongjun Park wrote:
> In the previous commit b3d82c2f2761, code was added to prevent journal sequence
> overflow. Among them, the code added to journal_entry_open() uses the
> bch2_fs_fatal_err_on() function to handle errors.
> 
> However, __journal_res_get() , which calls journal_entry_open() , calls
> journal_entry_open() while holding journal->lock , but bch2_fs_fatal_err_on()
> internally tries to acquire journal->lock , which results in a deadlock.
> 
> Therefore, we need to use bch_err() instead of bch2_fs_fatal_err_on() to
> prevent deadlock.

We do the emergency shutdown though...

Perhaps add a bch2_journal_halt_locked() helper?

> Fixes: b3d82c2f2761 ("bcachefs: Guard against journal seq overflow")
> Signed-off-by: Jeongjun Park <aha310510@gmail.com>
> ---
>  fs/bcachefs/journal.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/bcachefs/journal.c b/fs/bcachefs/journal.c
> index 2cd20114b74b..38ba5ab785c3 100644
> --- a/fs/bcachefs/journal.c
> +++ b/fs/bcachefs/journal.c
> @@ -382,9 +382,10 @@ static int journal_entry_open(struct journal *j)
>  	if (nr_unwritten_journal_entries(j) == ARRAY_SIZE(j->buf))
>  		return JOURNAL_ERR_max_in_flight;
>  
> -	if (bch2_fs_fatal_err_on(journal_cur_seq(j) >= JOURNAL_SEQ_MAX,
> -				 c, "cannot start: journal seq overflow"))
> +	if (journal_cur_seq(j) >= JOURNAL_SEQ_MAX) {
> +		bch_err(c, "cannot start: journal seq overflow");
>  		return JOURNAL_ERR_insufficient_devices; /* -EROFS */
> +	}
>  
>  	BUG_ON(!j->cur_entry_sectors);
>  
> --

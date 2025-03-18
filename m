Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74ABE1A3159
	for <linux-bcachefs@vger.kernel.org>; Tue, 18 Mar 2025 13:34:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742304889; cv=none; b=goFIPhph+gNc8E1asVyQNA8AQ/zKvjPel2ZRKEuZHKSfqOS0AZ5Owt1n5BUupo0z+yEBpYiJfgJRSfi5SqIQxkw13CE+K7XJrW2Cr4yRXMrsserTX9RRatzBUVg9Pmuy37TUhL6p7m1Gspr79roxsyGnaPuSgL+MxGqU2YpgFMY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742304889; c=relaxed/simple;
	bh=cSMz60AcAZOXYkBEp0PG6exBjx87CmaLHqLymcUQsyg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Aw7Q1h2hgMP2nGMFdycKIvqIssHz9x3rwWEz0puOdhdYabsavX7xfPC+c0IemvMoAMv5N+memaBASXGihseYXt/3sA4g4j+BqbHmhVdcuXMl7rgssQVxGLKAz+4ceFUarOZ8Is1R2Bb4/k/8SaKNCHk714CusHpyTvUnUtzmCPI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Vg21EiTD; arc=none smtp.client-ip=91.218.175.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Vg21EiTD"
Date: Tue, 18 Mar 2025 09:34:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1742304880;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2DeVNW4NTjW2G9HEPyiVeuJWSqKoac4jlAH4Pc+53/Y=;
	b=Vg21EiTDYSedPaafyJ1rchT0aXV/Z2/6AAH8EpSOTIe45ZhXGA03hbluhUjo8GczUrFOtg
	J9GyfIQjuLOdgOGT5dTxDFAj3QC3M1YrX0ERi+OiZbv6G/vYyjVaBnMW0uJt8/Y7eGmQIK
	5UwEY7BpS+Ze8DPlGP9fnbYEf80Ngiw=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Alan Huang <mmpgouride@gmail.com>
Cc: linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH] bcachefs: Fix incorrect state count
Message-ID: <wz5bunkmlnij5qxew6skvzjiqag5hkde23k4ljlr5t5pcbsv35@ctxrcl74uxrx>
References: <20250317175424.1928597-1-mmpgouride@gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250317175424.1928597-1-mmpgouride@gmail.com>
X-Migadu-Flow: FLOW_OUT

On Tue, Mar 18, 2025 at 01:54:24AM +0800, Alan Huang wrote:
> atomic64_read(&j->seq) - j->seq_write_started == JOURNAL_STATE_BUF_NR is
> the condition in journal_entry_open where we return JOURNAL_ERR_max_open,
> so journal_cur_seq(j) - seq == JOURNAL_STATE_BUF_NR means that the buf
> corresponding to seq has started to write.
> 
> Signed-off-by: Alan Huang <mmpgouride@gmail.com>

Applied

> ---
>  fs/bcachefs/journal.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/bcachefs/journal.h b/fs/bcachefs/journal.h
> index 1c460ded2a11..ab68c5c4d8d8 100644
> --- a/fs/bcachefs/journal.h
> +++ b/fs/bcachefs/journal.h
> @@ -161,7 +161,7 @@ static inline int journal_state_count(union journal_res_state s, int idx)
>  static inline int journal_state_seq_count(struct journal *j,
>  					  union journal_res_state s, u64 seq)
>  {
> -	if (journal_cur_seq(j) - seq <= JOURNAL_STATE_BUF_NR)
> +	if (journal_cur_seq(j) - seq < JOURNAL_STATE_BUF_NR)
>  		return journal_state_count(s, seq & JOURNAL_STATE_BUF_MASK);
>  	else
>  		return 0;
> -- 
> 2.48.1
> 

Received: from out-187.mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B4D02144D6
	for <linux-bcachefs@vger.kernel.org>; Fri, 18 Apr 2025 17:03:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744995829; cv=none; b=slWgjcqNFLMge5rFbpHGWwlc+rKoyz34l/yjUx7kfIDBm3Ai6PaBKeXnnZHKH+bv0UO5zJm2tPNqcI0gj3wI9f5yoWQDHBjfQ3GlLESYF9KtC4LMt+aYvcItkqxKVWpABlnCGV4bKSEXGZ1n59qztsIv1QoFZMk72Cl1hm6kMiU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744995829; c=relaxed/simple;
	bh=21XjAVu7KqzkJZAWzvPzOZTllJbfvyTZS61b9pMZ3oA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bellx0PyMYlG+ESOo7iCd7nad7/bajK0tjBG37+hK3y8qyv+xHwqJQAajsK6/TtU0qXblpLAHSd6yg9HJFmmUZXm+L5MqV3z194w7AEgbPKdGPt4n4avwkAgFJtODTU0s4pb0i3E7zd2RFNsuAy/do0/gTdo3l9l2hzJnff65UI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=nKPLCa7T; arc=none smtp.client-ip=95.215.58.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="nKPLCa7T"
Date: Fri, 18 Apr 2025 13:03:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1744995824;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=UTYlBc451TDj5yZC/rJOi2qdtVJsuJ+2xSWm49Z2/y4=;
	b=nKPLCa7TVu3DVc/dOBo+u7HPQLhtTji3Xfl4esMGVVgJBUN9pgErIbuUCSojgSoS/MWXQX
	uHKxDKvXSTl/bEOYh43wfH0CevEYYpb5tYBIkHADTHfHz8+YyvjRI6Hb0cme0lSxwH4+eI
	D5heBx8ngyYxCz7dBfWlbG1xRnZa2kY=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Alan Huang <mmpgouride@gmail.com>
Cc: linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH] bcachefs: Kill dead code
Message-ID: <y47rkad6ynesz6hgru4nspdiy7ng27bvirukysoxrlcevi2qkq@2h4bfcnbvcdt>
References: <20250418075210.174321-1-mmpgouride@gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250418075210.174321-1-mmpgouride@gmail.com>
X-Migadu-Flow: FLOW_OUT

On Fri, Apr 18, 2025 at 03:52:10PM +0800, Alan Huang wrote:
> Signed-off-by: Alan Huang <mmpgouride@gmail.com>

Applied

> ---
>  fs/bcachefs/journal_reclaim.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/fs/bcachefs/journal_reclaim.c b/fs/bcachefs/journal_reclaim.c
> index 5d1547aa118a..59d8c9fa9b07 100644
> --- a/fs/bcachefs/journal_reclaim.c
> +++ b/fs/bcachefs/journal_reclaim.c
> @@ -624,8 +624,6 @@ static u64 journal_seq_to_flush(struct journal *j)
>  		/* Try to keep the journal at most half full: */
>  		nr_buckets = ja->nr / 2;
>  
> -		nr_buckets = min(nr_buckets, ja->nr);
> -
>  		bucket_to_flush = (ja->cur_idx + nr_buckets) % ja->nr;
>  		seq_to_flush = max(seq_to_flush,
>  				   ja->bucket_seq[bucket_to_flush]);
> -- 
> 2.48.1
> 

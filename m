Received: from out-186.mta1.migadu.com (out-186.mta1.migadu.com [95.215.58.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CBA83B1AB
	for <linux-bcachefs@vger.kernel.org>; Fri,  7 Mar 2025 17:01:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741366894; cv=none; b=R4hcocAtf3nrgdGA4aFxY4dCuHr01mKO42dcC1orVEhCtwWZu7zBFFRfNaQTiRGFOuzrfOo8xmnbmnwez4JL6+skCmh3JxlnjwZkxYoQFViaKG74HkxOO0VPDbT8EZx7SMNgcRlsGMzl/EVRh7KsFDMf5KmtpKOat9meDLjsu1Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741366894; c=relaxed/simple;
	bh=0y2sYy5QhwKS8MFTvtATcswTBlBLFVLzIblVWyocmj8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GPZ8PGYD4I+6FdsxCnkWIvchY2dm6y6loIduf2oGacZQauFZxdsodbgNbznQ0cHfwlr+5Ca5MlP1TwwhPwPo2VF6WAlXVxuq3fbhxQHGcm3fyPEkAYdpNZfDO+tVjASN0sqbbhzEhbY7Id8tUTKqnJm3ZP68cMRLnwkjwBTHghg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=gB5P5QD8; arc=none smtp.client-ip=95.215.58.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="gB5P5QD8"
Date: Fri, 7 Mar 2025 12:01:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1741366889;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=731AHXb3WKH/QFFoZifDbLJpmJG1YhvQQrPHlKgK57M=;
	b=gB5P5QD8tM75HXyXMJcGHzNnEkqFNZgpc3WJRLP+2mLHONrd6POdjMohIIGkHIyV+o6wFa
	IWeshLW0REJDmwL5+gpiVlHvsZGxfG0dt8+6cal7Y9KZg8t0bmsf2eQnsOkyuY5Oubw2KM
	YKsFC3BkqA0ZQBB/8I/dDzzhDY0dI8Y=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Alan Huang <mmpgouride@gmail.com>
Cc: linux-bcachefs@vger.kernel.org, 
	syzbot+3cb3d9e8c3f197754825@syzkaller.appspotmail.com
Subject: Re: [PATCH] bcachefs: Fix b->written overflow
Message-ID: <7upqxeu6d4k2yybdug6hml7w3o4azp3prwqksxepgnf77ygmwt@vnyi5n7gaun3>
References: <20250307165827.1775663-1-mmpgouride@gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250307165827.1775663-1-mmpgouride@gmail.com>
X-Migadu-Flow: FLOW_OUT

On Sat, Mar 08, 2025 at 12:58:27AM +0800, Alan Huang wrote:
> When bset past end of btree node, we should not add sectors to
> b->written, which will overflow b->written.
> 
> Reported-by: syzbot+3cb3d9e8c3f197754825@syzkaller.appspotmail.com
> Tested-by: syzbot+3cb3d9e8c3f197754825@syzkaller.appspotmail.com
> Signed-off-by: Alan Huang <mmpgouride@gmail.com>

Applied

> ---
>  fs/bcachefs/btree_io.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/bcachefs/btree_io.c b/fs/bcachefs/btree_io.c
> index 80a0094be356..18413b4f22a3 100644
> --- a/fs/bcachefs/btree_io.c
> +++ b/fs/bcachefs/btree_io.c
> @@ -1187,7 +1187,7 @@ int bch2_btree_node_read_done(struct bch_fs *c, struct bch_dev *ca,
>  			     le64_to_cpu(i->journal_seq),
>  			     b->written, b->written + sectors, ptr_written);
>  
> -		b->written += sectors;
> +		b->written = min(b->written + sectors, btree_sectors(c));
>  
>  		if (blacklisted && !first)
>  			continue;
> -- 
> 2.48.1
> 

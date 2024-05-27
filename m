Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48BA7BE68
	for <linux-bcachefs@vger.kernel.org>; Mon, 27 May 2024 03:33:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716780804; cv=none; b=vClLrh9PYJPQPKnHcW0jlY2Q0tXYr6VoWEHd/vyILjgFIlD5moou7MrU7WKSxK9ZnVCGO1iW9LEjVNBt3XpA8TwxrS3SHILxrWBvXMOBdeGY+G45Y8uaFW+YHnTQUvBktA7RxOIYFmsw7HJk8MYDzlRWB5opIWsed4WfHcS27dM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716780804; c=relaxed/simple;
	bh=JwfTFD+Scq2ubhFjBe8fFxs2omw8sx6tWtMFWwCXwjU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=H0mve3LzgIHgKA6o0zWt2Me5KAQRsXex/mkgLl0C5oqLD5bdarHdWn1SJYG3QdvRbuqMVeTgNNxdJvtvMnDXdsNVYJBNTawuyPV0jDs/GZ1pCo66wDER0lSCAa9oncCcONNbs2DjM5iHOe/ig1VJzQJFMz5FiNeJiiW9a5jMo4k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=tNRFOuOO; arc=none smtp.client-ip=91.218.175.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="tNRFOuOO"
X-Envelope-To: tahbertschinger@gmail.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1716780799;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=CLnjhv5hK12beNyOrQ9jUg23tBvS4hCz+8YS+7a1qTY=;
	b=tNRFOuOOEUi+k56RAKAwZB6xsdkzf9Fg3zoDhi+fSiEqb0YAFbPbr+yEOv2+HjWB1mlaFX
	Fys97lcEcg3V4zMLx9DW6tsrCpwCkdDpbp9i4JBo5Shy5WcuOON2kgPOZWFXYGiqK0MI8B
	bq/Fy90TaTkFkPABgc8pR4f4/dvkI4M=
X-Envelope-To: linux-bcachefs@vger.kernel.org
X-Envelope-To: bfoster@redhat.com
Date: Sun, 26 May 2024 23:33:16 -0400
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Thomas Bertschinger <tahbertschinger@gmail.com>
Cc: linux-bcachefs@vger.kernel.org, bfoster@redhat.com
Subject: Re: [PATCH 1/2] bcachefs: make offline fsck set read_only fs flag
Message-ID: <txscypk566w4n6p7ncttm2mxtpcxa64vd2rv3wsx7fko7x42el@ulbvz4xdvc5j>
References: <20240526190820.606162-1-tahbertschinger@gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240526190820.606162-1-tahbertschinger@gmail.com>
X-Migadu-Flow: FLOW_OUT

On Sun, May 26, 2024 at 01:08:19PM -0600, Thomas Bertschinger wrote:
> A subsequent change will remove "read_only" as a mount option in favor
> of the standard option "ro", meaning the userspace fsck command cannot
> pass it to the fsck ioctl. Instead, in offline fsck, set "read_only"
> kernel-side without trying to parse it as a mount option.
> 
> For compatibility with versions of the "bcachefs fsck" command that try
> to pass the "read_only" mount opt, remove it from the mount options
> string prior to parsing when it is present.
> 
> Signed-off-by: Thomas Bertschinger <tahbertschinger@gmail.com>

these are applied
> ---
>  fs/bcachefs/chardev.c | 13 +++++++++++++
>  1 file changed, 13 insertions(+)
> 
> diff --git a/fs/bcachefs/chardev.c b/fs/bcachefs/chardev.c
> index 9e54323f0f5f..5040c584cd72 100644
> --- a/fs/bcachefs/chardev.c
> +++ b/fs/bcachefs/chardev.c
> @@ -213,6 +213,18 @@ static long bch2_ioctl_fsck_offline(struct bch_ioctl_fsck_offline __user *user_a
>  
>  	if (arg.opts) {
>  		char *optstr = strndup_user((char __user *)(unsigned long) arg.opts, 1 << 16);
> +		char *ro, *rest;
> +
> +		/*
> +		 * If passed a "read_only" mount option, remove it because it is
> +		 * no longer a valid mount option, and the filesystem will be
> +		 * set "read_only" regardless.
> +		 */
> +		ro = strstr(optstr, "read_only");
> +		if (ro) {
> +			rest = ro + strlen("read_only");
> +			memmove(ro, rest, strlen(rest) + 1);
> +		}
>  
>  		ret =   PTR_ERR_OR_ZERO(optstr) ?:
>  			bch2_parse_mount_opts(NULL, &thr->opts, optstr);
> @@ -223,6 +235,7 @@ static long bch2_ioctl_fsck_offline(struct bch_ioctl_fsck_offline __user *user_a
>  	}
>  
>  	opt_set(thr->opts, stdio, (u64)(unsigned long)&thr->thr.stdio);
> +	opt_set(thr->opts, read_only, 1);
>  
>  	/* We need request_key() to be called before we punt to kthread: */
>  	opt_set(thr->opts, nostart, true);
> -- 
> 2.45.0
> 

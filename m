Received: from out-171.mta1.migadu.com (out-171.mta1.migadu.com [95.215.58.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CE3010A18
	for <linux-bcachefs@vger.kernel.org>; Sat,  5 Oct 2024 02:49:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728096566; cv=none; b=IrX306u2iWkHGH4HNJrVepaEveNE33ut4VZygbK6W8JUM6MLeC3c5+ZOGoxupyqVmi6JnSw+7hitF33b6Qf/Pt9AwyCThwXMtvfZXG5qb5kGR9/IGOX5hpW7ZQAZK7wFjg7yY7SR9G02KsMxv/Bm1RL8rvqEg1zLpHXRbCMr3PQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728096566; c=relaxed/simple;
	bh=8S/UmiyqCQa2HIR2BB5d03bbOsZyF8Jl/GRAVJFpnmo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IY6SxSul39pUjmizLBUdS9u2ykfY3PFddDbBNCBF6wovrRE4FBNm2aMyn4Rf9ecdprLH8tVl0sdgnkAroevcuc7tNDgbN9xZOjCnBxKitf5xrSF2gynSPs+B9AUvY2rajfRIt+a0NDbfL9K5r+r+2I+Q190bgM79jL776vhKVWc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=pNcE+2OO; arc=none smtp.client-ip=95.215.58.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="pNcE+2OO"
Date: Fri, 4 Oct 2024 22:49:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1728096556;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=monea4kTU2Uvxq8WBxsdjOBXCgND6pdtVbuHihxXg+M=;
	b=pNcE+2OObFyEwF0LpqtFFpZmoqQS1tX9iPtB//64jJ3nJEGDJq80VMEHxyxWXM1q8o0gmD
	okYheYpNc2UKnZKg6tgB1vHU/fofQHPQrgFki3aSsWN1CKjkBrOI0spXwKgrAWiM05ZlJX
	TgKQjeKFZBjLMR2NDqAoYbveJZR9U9k=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Thomas Bertschinger <tahbertschinger@gmail.com>
Cc: linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH TOOLS] fuse: graceful shutdown when startup fails
Message-ID: <3g73btmophoy52qdhmtlaqpbycirdnd5uudsojnrgf2j4jn7wk@3h3bqn2reh4k>
References: <20241005020654.93862-1-tahbertschinger@gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241005020654.93862-1-tahbertschinger@gmail.com>
X-Migadu-Flow: FLOW_OUT

On Fri, Oct 04, 2024 at 08:06:54PM GMT, Thomas Bertschinger wrote:
> When FUSE startup encounters an error after opening the filesystem--for
> example because of a bad mountpoint--it exited uncleanly, which is a
> bit unfriendly.
> 
> Signed-off-by: Thomas Bertschinger <tahbertschinger@gmail.com>
> ---
> 
> Another mitigation could be to check access(2) for the mountpoint before
> doing any work...

I don't like relying on access(2) because that's racy - this looks nice.

Applied

> 
>  c_src/cmd_fusemount.c | 39 +++++++++++++++++++++++++--------------
>  1 file changed, 25 insertions(+), 14 deletions(-)
> 
> diff --git a/c_src/cmd_fusemount.c b/c_src/cmd_fusemount.c
> index f43d29f5..50d35832 100644
> --- a/c_src/cmd_fusemount.c
> +++ b/c_src/cmd_fusemount.c
> @@ -1203,6 +1203,7 @@ int cmd_fusemount(int argc, char *argv[])
>  	struct bch_opts bch_opts = bch2_opts_empty();
>  	struct bf_context ctx = { 0 };
>  	struct bch_fs *c = NULL;
> +	struct fuse_session *se = NULL;
>  	int ret = 0, i;
>  
>  	/* Parse arguments. */
> @@ -1263,17 +1264,22 @@ int cmd_fusemount(int argc, char *argv[])
>  		    bch2_err_str(PTR_ERR(c)));
>  
>  	/* Fuse */
> -	struct fuse_session *se =
> -		fuse_session_new(&args, &bcachefs_fuse_ops,
> -				 sizeof(bcachefs_fuse_ops), c);
> -	if (!se)
> -		die("fuse_lowlevel_new err: %m");
> +	se = fuse_session_new(&args, &bcachefs_fuse_ops,
> +				sizeof(bcachefs_fuse_ops), c);
> +	if (!se) {
> +		fprintf(stderr, "fuse_lowlevel_new err: %m\n");
> +		goto err;
> +	}
>  
> -	if (fuse_set_signal_handlers(se) < 0)
> -		die("fuse_set_signal_handlers err: %m");
> +	if (fuse_set_signal_handlers(se) < 0) {
> +		fprintf(stderr, "fuse_set_signal_handlers err: %m\n");
> +		goto err;
> +	}
>  
> -	if (fuse_session_mount(se, fuse_opts.mountpoint))
> -		die("fuse_mount err: %m");
> +	if (fuse_session_mount(se, fuse_opts.mountpoint)) {
> +		fprintf(stderr, "fuse_mount err: %m\n");
> +		goto err;
> +	}
>  
>  	/* This print statement is a trigger for tests. */
>  	printf("Fuse mount initialized.\n");
> @@ -1287,17 +1293,22 @@ int cmd_fusemount(int argc, char *argv[])
>  
>  	ret = fuse_session_loop(se);
>  
> -	/* Cleanup */
> -	fuse_session_unmount(se);
> -	fuse_remove_signal_handlers(se);
> -	fuse_session_destroy(se);
> -
>  out:
> +	if (se) {
> +		fuse_session_unmount(se);
> +		fuse_remove_signal_handlers(se);
> +		fuse_session_destroy(se);
> +	}
> +
>  	free(fuse_opts.mountpoint);
>  	fuse_opt_free_args(&args);
>  	bf_context_free(&ctx);
>  
>  	return ret ? 1 : 0;
> +
> +err:
> +	bch2_fs_stop(c);
> +	goto out;
>  }
>  
>  #endif /* BCACHEFS_FUSE */
> -- 
> 2.46.0
> 

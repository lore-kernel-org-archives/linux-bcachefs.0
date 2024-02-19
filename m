Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20AF1210FA
	for <linux-bcachefs@vger.kernel.org>; Mon, 19 Feb 2024 10:04:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708337097; cv=none; b=UNwo1/azbBkad+s6nAg2MoHsvgtifn+BxNMg+Ff/7PFf3Gylmp0/6cBwQyC8NtUKPmbgXtsTSDFPFuuVV9PO2AVIhf9nSPpgkmhHL2PoWdNiiIFDRL7egU+BjRj7VTyIcBobwsPpGvU5SM37md/lLGwJ7lXZMC1vD/JA76oDiXo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708337097; c=relaxed/simple;
	bh=bAvSZKO2xIH07T32YlxVq/LXg6BfVqtMXShW+htt18k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=idj2pC0tKxjR+Xe3BqZySUCTvAfPp1wb2r7Ayduk/lPrdfIj1xjvQ1uAuAE/yo0F0EPODLMawbSc9ZWFrhVkT6vLvgenUu3vNhM5QmQ97mn0w3vb1+OLYqtOszDR1JoxhGp4dFmBJTe2h+0dX3/G/7eiowaNt33yuYS3Ji3q08Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Tk280tx7; arc=none smtp.client-ip=95.215.58.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Tk280tx7"
Date: Mon, 19 Feb 2024 05:04:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1708337093;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=FvvVuCLw6Eexv0krnB1tFnzta4YHLA73boqQSMVSce8=;
	b=Tk280tx79wPKR1SAovTDunGENnHfU9h2tchrvrbfTy1LMYvd6XWJuDkqTF0LfmtZqeelbe
	1KftFW5zwar9SJmBav5lvgAGp0Q9x7GyDixAJ8rEIBJuwzS6JHyncSxThw4ESfaRMi/x/W
	xmTnyiHX7xx6sIKyszw60kiVpa9Q9Cs=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Hongbo Li <lihongbo22@huawei.com>
Cc: bfoster@redhat.com, linux-bcachefs@vger.kernel.org, 
	ruanjinjie@huawei.com
Subject: Re: [PATCH] bcachefs: fix the error code when mounting with
 incorrect options.
Message-ID: <b3edruyblko7tbpbbpftov75tmnmwir4mx7m2mwpdzzaylt3av@ttwlfwzzoc6s>
References: <20240219095433.2566106-1-lihongbo22@huawei.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240219095433.2566106-1-lihongbo22@huawei.com>
X-Migadu-Flow: FLOW_OUT

On Mon, Feb 19, 2024 at 05:54:33PM +0800, Hongbo Li wrote:
> When mount with incorrect options such as:
> "mount -t bcachefs -o errors=back /dev/loop1 /mnt/bcachefs/".
> It rebacks the error "mount: /mnt/bcachefs: permission denied."
>  cause bch2_parse_mount_opts returns -1 and bch2_mount throws
> it up. This is unreasonable.
> 
> The real error message should be like this:
> "mount: /mnt/bcachefs: wrong fs type, bad option, bad
> superblock on /dev/loop1, missing codepage or helper program,
> or other error."

Thanks for the patch.

As a general policy though, we're not adding new direct references to
the standard error codes (except - the -ENOMEM is fine here).

Instead of returning -EINVAL, you'll want to define new errcodes in
errcode.h; the left field is the errcode it derives from, by specifying
EINVAL there it'll be translated to -EINVAL at the module boundary.

Also, our private error codes should generally only be thrown at one
source code location, not reused for multiple things.

This makes for _much_ better error messages and easier debugging -
nothing is worse than chasing down a -EINVAL with inadequate loging.

Cheers,
Kent

> 
> Signed-off-by: Hongbo Li <lihongbo22@huawei.com>
> ---
>  fs/bcachefs/opts.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/bcachefs/opts.c b/fs/bcachefs/opts.c
> index b1ed0b9a20d3..a9ee9eaab670 100644
> --- a/fs/bcachefs/opts.c
> +++ b/fs/bcachefs/opts.c
> @@ -456,7 +456,7 @@ int bch2_parse_mount_opts(struct bch_fs *c, struct bch_opts *opts,
>  
>  	copied_opts = kstrdup(options, GFP_KERNEL);
>  	if (!copied_opts)
> -		return -1;
> +		return -ENOMEM;
>  	copied_opts_start = copied_opts;
>  
>  	while ((opt = strsep(&copied_opts, ",")) != NULL) {
> @@ -501,11 +501,11 @@ int bch2_parse_mount_opts(struct bch_fs *c, struct bch_opts *opts,
>  
>  bad_opt:
>  	pr_err("Bad mount option %s", name);
> -	ret = -1;
> +	ret = -EINVAL;
>  	goto out;
>  bad_val:
>  	pr_err("Invalid mount option %s", err.buf);
> -	ret = -1;
> +	ret = -EINVAL;
>  	goto out;
>  out:
>  	kfree(copied_opts_start);
> -- 
> 2.34.1
> 

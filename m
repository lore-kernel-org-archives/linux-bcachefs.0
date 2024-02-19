Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09EF62DF7D
	for <linux-bcachefs@vger.kernel.org>; Mon, 19 Feb 2024 12:27:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708345665; cv=none; b=MuPDncNd6FIQ0lgfFzLt3vInpdD+CUmQvyzvH/CA15cyS8DKzpEj70niO2wsXzbJiXrjGmsgLXR5Yz8IQOzQLHyINgUexbLQqOAKKw5Jvwprz2FoLDZvV1TBR4D0KNsLlVrmYBCixHENtniBB8cx6K2zhEpYKenwQpvkCRgxbOU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708345665; c=relaxed/simple;
	bh=nhKJep6jVqhODONUOtk2v8Z3asssgHx8NwqOrriW3nU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HFATSVzjzPgwMl6ZD+k6aZvpana0T11mByd9HgpNbNK5PvUrGLMrlRGhng4lRmuMjcXpxMuNSZ2kXdsdDvi7tI7q+bHYQYFm6rPYOqqqQCLTt1SkdTMQ6OiDqBj1XPgsPzxmGxyLskXAQaqs7nOzwpK5PQqKNBESl7EupcKfLis=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=H5y3foGm; arc=none smtp.client-ip=95.215.58.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="H5y3foGm"
Date: Mon, 19 Feb 2024 07:27:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1708345662;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Sz3mhSlEA5dK612tlNHjvhnw16WrsGZnK80u2BYxFQI=;
	b=H5y3foGm2Jlh3nRi8vpNz65sJl2CA9By2WAUeiOG6keEH7/onR5UUHfteaC0qnCZw5Q6AC
	sjMMBdy29knu/OnvCGfuXM3HXtcGX+bSBie9k4OXmLVTIQbp/WIYZU9U+3pXsThwNGDRGl
	4rkk/DOeZ71QA27/M/3NUWi33sU83ro=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Hongbo Li <lihongbo22@huawei.com>
Cc: bfoster@redhat.com, linux-bcachefs@vger.kernel.org, 
	ruanjinjie@huawei.com
Subject: Re: [PATCH v2] bcachefs: fix the error code when mounting with
 incorrect options.
Message-ID: <tcjqfii2emtqwpsgt4doldgg2iwjnsh6fzv7nkdccxt43gpu4g@pfasjkkj3e4k>
References: <20240219122432.2570083-1-lihongbo22@huawei.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240219122432.2570083-1-lihongbo22@huawei.com>
X-Migadu-Flow: FLOW_OUT

On Mon, Feb 19, 2024 at 08:24:32PM +0800, Hongbo Li wrote:
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
> 
> Adding three private error codes for mounting error. Here are:
>   - BCH_ERR_mount_option as the parent class for option error.
>   - BCH_ERR_option_name represents the invalid option name.
>   - BCH_ERR_option_value represents the invalid option value.
> 
> Signed-off-by: Hongbo Li <lihongbo22@huawei.com>

thanks! I'll give this more detailed review tomorrow but at a glance,
looks good.

> ---
> Thanks for reviewing my patch. Here is my new changelog:
> 
> v2:
>  - return private error codes for internal functions.
> v1: https://lore.kernel.org/linux-bcachefs/b3edruyblko7tbpbbpftov75tmnmwir4mx7m2mwpdzzaylt3av@ttwlfwzzoc6s/T/#t
> ---
>  fs/bcachefs/errcode.h | 3 +++
>  fs/bcachefs/fs.c      | 4 +++-
>  fs/bcachefs/opts.c    | 6 +++---
>  3 files changed, 9 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/bcachefs/errcode.h b/fs/bcachefs/errcode.h
> index fe3fc14d3c9a..3653ff2c0c12 100644
> --- a/fs/bcachefs/errcode.h
> +++ b/fs/bcachefs/errcode.h
> @@ -5,6 +5,9 @@
>  #define BCH_ERRCODES()								\
>  	x(ERANGE,			ERANGE_option_too_small)		\
>  	x(ERANGE,			ERANGE_option_too_big)			\
> +	x(EINVAL,			mount_option)				\
> +	x(BCH_ERR_mount_option,		option_name)				\
> +	x(BCH_ERR_mount_option,		option_value)				\
>  	x(ENOMEM,			ENOMEM_stripe_buf)			\
>  	x(ENOMEM,			ENOMEM_replicas_table)			\
>  	x(ENOMEM,			ENOMEM_cpu_replicas)			\
> diff --git a/fs/bcachefs/fs.c b/fs/bcachefs/fs.c
> index 093f5404a655..3f073845bbd7 100644
> --- a/fs/bcachefs/fs.c
> +++ b/fs/bcachefs/fs.c
> @@ -1870,8 +1870,10 @@ static struct dentry *bch2_mount(struct file_system_type *fs_type,
>  	opt_set(opts, read_only, (flags & SB_RDONLY) != 0);
>  
>  	ret = bch2_parse_mount_opts(NULL, &opts, data);
> -	if (ret)
> +	if (ret) {
> +		ret = bch2_err_class(ret);
>  		return ERR_PTR(ret);
> +	}
>  
>  	if (!dev_name || strlen(dev_name) == 0)
>  		return ERR_PTR(-EINVAL);
> diff --git a/fs/bcachefs/opts.c b/fs/bcachefs/opts.c
> index b1ed0b9a20d3..1db11c15b2b9 100644
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
> +	ret = -BCH_ERR_option_name;
>  	goto out;
>  bad_val:
>  	pr_err("Invalid mount option %s", err.buf);
> -	ret = -1;
> +	ret = -BCH_ERR_option_value;
>  	goto out;
>  out:
>  	kfree(copied_opts_start);
> -- 
> 2.34.1
> 

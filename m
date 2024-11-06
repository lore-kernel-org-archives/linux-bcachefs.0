Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3037613A26F
	for <linux-bcachefs@vger.kernel.org>; Wed,  6 Nov 2024 21:21:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730928120; cv=none; b=BDIFCqo2vF8fJaAJ5X0/zdIr+Te9ZIYbh6T5TC4WUfV3+61nGSjF7cPdd6E5maRMFORGOHeaQLpZAgOU4WHrW3DB29OL0/bQaQTTnPzvEmrO0lIpkkQ4iSeul/0uxumNWCkzZqw1JRj3q1BIVmNPfVxlGjIFXRVHfZloJkJIG1Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730928120; c=relaxed/simple;
	bh=kXjpO3tawFVe5+/SWO3r12mN74I0k8IyYUVkUKBbUqM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DnHWMsYOX5L+3EGUm8Ps02uit+6kqNP+3frCE5GVhmsiBX0JmqDUmn+bfIDP2PNW5bRpMCGUXtDp1du9ywyr+co+hhWdagffQVAN1We8U7AO1oPBkADOjAONxZYaXEg7KuIin2bxkFsvfbv3EV0Le8tjqmhWEKfQLg3yXuVJDPg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=FPzWF4JW; arc=none smtp.client-ip=91.218.175.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="FPzWF4JW"
Date: Wed, 6 Nov 2024 16:21:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1730928116;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=fvYRMPHgzRnw0k4d2hwQC4iywtSvlA9mMoHST/abRrE=;
	b=FPzWF4JWX7KTOUkrNRAwZc8C9HCU1+1B0C5qx8/npFOgs+UcWvF7B9uPhr61lXmsv2JsKM
	m1e77k4VAdR9TrzDmoQWaE39NqcmhuUBZobpA0ysck25QxvrTKE21tnSeahJzc3x0SZSVx
	BZY9yHAlPdD17LGbcMgHk1lvT3yopzU=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Integral <integral@archlinuxcn.org>
Cc: kent.overstreet@gmail.com, lihongbo22@huawei.com, mmpgouride@gmail.com, 
	linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH] bcachefs-tools: Fix TODO "Show bcachefs version"
Message-ID: <lnyvfoni3zijn54iulzp3jafx7nbpma4eoudneoeqsy2vutkgr@xtudegnnq73u>
References: <20241105083601.246110-1-integral@archlinuxcn.org>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241105083601.246110-1-integral@archlinuxcn.org>
X-Migadu-Flow: FLOW_OUT

On Tue, Nov 05, 2024 at 04:36:01PM +0800, Integral wrote:
> Fix TODO "Show bcachefs version" in fusemount.
> 
> Signed-off-by: Integral <integral@archlinuxcn.org>

Applied

> ---
>  c_src/cmd_fusemount.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/c_src/cmd_fusemount.c b/c_src/cmd_fusemount.c
> index babdb6fb..e5674b42 100644
> --- a/c_src/cmd_fusemount.c
> +++ b/c_src/cmd_fusemount.c
> @@ -1222,9 +1222,9 @@ int cmd_fusemount(int argc, char *argv[])
>  		goto out;
>  	}
>  	if (fuse_opts.show_version) {
> -		/* TODO: Show bcachefs version. */
>  		printf("FUSE library version %s\n", fuse_pkgversion());
>  		fuse_lowlevel_version();
> +		printf("bcachefs version: %s\n", VERSION_STRING);
>  		ret = 0;
>  		goto out;
>  	}
> -- 
> 2.47.0
> 

Received: from out-186.mta1.migadu.com (out-186.mta1.migadu.com [95.215.58.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 128341A9B5D
	for <linux-bcachefs@vger.kernel.org>; Fri, 28 Mar 2025 15:12:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743174774; cv=none; b=d5PmDBpGGtGfJ0SJWcmD7Nkvg4PxfJoJmK9kZmvOJD1o+Hj67Xuj/9N4pr3avyrzqBdzdat6Zk+WkxesGkJE3nEthNnCFHO+WktHYdPljH2P7unNtU4TFDPT2hHll4EiFyV2JiTfAsssXiKe1/TaCNWrQxoJn7Wu7fmehY5hx50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743174774; c=relaxed/simple;
	bh=rC5gNwlsUOGyVENfGJg4tN32hTXwORL+DIaqkrQkQg0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=toJe7r63neQlpcn+TtqhV7wwICRTflF7cCtH3PxqWH/W3oFJ3kMsH/RYCVT2zZG3N7uB1a1NxM0b7DJqFRXTicE2NulPd8jpjbX65kHyWna7mgTbMBnk71h0hDg2Je4v2BR/7G80c/80L+x7iwjpGg2nkJz6cJYNmQ1YfWtQmUA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=esh46J4D; arc=none smtp.client-ip=95.215.58.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="esh46J4D"
Date: Fri, 28 Mar 2025 11:12:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1743174771;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=xWsa17AQtXY1IDkPkfIb1ycXrFuFrGLKoiUcim9BvdI=;
	b=esh46J4DnWABDNWwh+pYOHE4PWE/cjL+FVoc6plSSyRJUMoq04kVN4+e1dx4COg8i1zBJT
	8/2xfrsx5NGb+WPBojudPdrTt/slFRNA3rXfX/TKUpk10wC0fvmKbfRM8Yia39S4CLBwLE
	cS3+K/iIDTVm0/XqffDpDaqgR6LcCeI=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Integral <integral@archlinuxcn.org>
Cc: kent.overstreet@gmail.com, lihongbo22@huawei.com, mmpgouride@gmail.com, 
	linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH resend] bcachefs-tools: hide FUSE in usage when
 BCACHEFS_FUSE disabled
Message-ID: <bborfla7f3tzl4gqbugxzgqeib7m63pfxbsq5ws7mhgrgk4o2m@knfaoga6okpr>
References: <20250328024221.225699-2-integral@archlinuxcn.org>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250328024221.225699-2-integral@archlinuxcn.org>
X-Migadu-Flow: FLOW_OUT

On Fri, Mar 28, 2025 at 10:42:22AM +0800, Integral wrote:
> When BCACHEFS_FUSE is disabled or not defined, FUSE section shouldn't
> be displayed in bcachefs usage (--help).
> 
> Signed-off-by: Integral <integral@archlinuxcn.org>

Thanks, applied

> ---
>  c_src/bcachefs.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/c_src/bcachefs.c b/c_src/bcachefs.c
> index aed9c261..f2a1449e 100644
> --- a/c_src/bcachefs.c
> +++ b/c_src/bcachefs.c
> @@ -93,9 +93,11 @@ void bcachefs_usage(void)
>  	     "  list                     List filesystem metadata in textual form\n"
>  	     "  list_journal             List contents of journal\n"
>  	     "\n"
> +#ifdef BCACHEFS_FUSE
>  	     "FUSE:\n"
>  	     "  fusemount                Mount a filesystem via FUSE\n"
>  	     "\n"
> +#endif
>  	     "Miscellaneous:\n"
>           "  completions              Generate shell completions\n"
>  	     "  version                  Display the version of the invoked bcachefs tool\n");
> -- 
> 2.49.0
> 

Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C551A4C79
	for <linux-bcachefs@vger.kernel.org>; Wed, 14 Feb 2024 02:25:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707877532; cv=none; b=uXv1F6QaHHrLpizNhuuI8zPeOxuKTZPoXLb7/4mvAh7aSnfIip5ymY8jHK4STRMmF83PQTB14XXE1J6wjkxpse/rfzF0qlu9LqgOtX5HtCnh8i5vA2WsyMujYXRY0OcO64kiMWnYbLlwiU5A5GhY+xZjWuVqCZojYtMW1Dws/xY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707877532; c=relaxed/simple;
	bh=q39lTMoKIMCJJTYUMdC8IWxp7odChFr+U8d1vq8IfFI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JQ8FqMyDfwMMXm4Ja6N584IIFv/wkT6YK529C7LXppalXCp3GRlhKkF/iZxoBuWydLKi9rvFbQakq1dlZB4k9bSkI2vq1+MOyczAIGLCbYiwnMfouGDbW+AbRfHmyKG9ewMPoZ87D5SgrybFiRUCQ+LTCSPNZoWUO5qDiq7D+m4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=m/xGQtxo; arc=none smtp.client-ip=91.218.175.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="m/xGQtxo"
Date: Tue, 13 Feb 2024 21:25:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1707877528;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=IF2QbrxlUkSrURiMpxLZp2zR8xudxIslipixgpGPp/I=;
	b=m/xGQtxoHofEZb4m8IF+JDJzJe+gaA1ZNF1Fos9x0oQhfC+EaSUN1CSw1wde+FO7Fm7IiA
	0BNlDJVsfmXuhnU3EXRNZxFqKJ9/ESgjrMrloz9cEJPUmVacAaEENssw+U8hvxDGIRyQR5
	3BuF41iAy99auPoe32pc8Oesy9wCbwM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Guoyu Ou <benogy@gmail.com>
Cc: linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH] ktest: add a test case for rmdir empty snapshot
Message-ID: <m6mxscvbjhm6tcezmui3ast5fgddvitrlhdwvueu6qprl6p6nu@h6j6zc34oqy6>
References: <20240213071326.12699-1-benogy@gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240213071326.12699-1-benogy@gmail.com>
X-Migadu-Flow: FLOW_OUT

On Tue, Feb 13, 2024 at 03:13:25PM +0800, Guoyu Ou wrote:
> Signed-off-by: Guoyu Ou <benogy@gmail.com>

Thanks! Applied.

> ---
>  tests/bcachefs/subvol.ktest | 18 ++++++++++++++++++
>  1 file changed, 18 insertions(+)
> 
> diff --git a/tests/bcachefs/subvol.ktest b/tests/bcachefs/subvol.ktest
> index 1915d84..4a50da2 100755
> --- a/tests/bcachefs/subvol.ktest
> +++ b/tests/bcachefs/subvol.ktest
> @@ -718,4 +718,22 @@ test_subvol_mv()
>      bcachefs fsck ${ktest_scratch_dev[0]}
>  }
>  
> +test_subvol_rmdir_empty_snapshot()
> +{
> +    run_quiet "" bcachefs format -f ${ktest_scratch_dev[0]}
> +    mount -t bcachefs ${ktest_scratch_dev[0]} /mnt
> +
> +    cd /mnt
> +    bcachefs subvolume create ./sub
> +    cd sub
> +    bcachefs subvolume create ./sub2
> +    bcachefs subvolume snapshot . ./snap
> +    rmdir ./snap
> +
> +    cd /
> +    umount /mnt
> +
> +    bcachefs fsck ${ktest_scratch_dev[0]}
> +}
> +
>  main "$@"
> -- 
> 2.43.0
> 

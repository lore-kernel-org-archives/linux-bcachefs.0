Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41159136E37
	for <linux-bcachefs@vger.kernel.org>; Wed,  2 Apr 2025 16:39:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743611961; cv=none; b=pAkAZ545EjZbVTW/aZOQoVOceN+Vlpqz7dMnRpl1M71DFFYrfpKebtAac1D/GHG4MRVXLt7N67QEWxQYsyu5Pvt9y3t2bTwPVh2eF85pnajMIKn3I3VVmIfZmXfxrDgJc+HwaRkMmxEXwOa4ORSfTlTA0i/wIM6opQmjApv2L5M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743611961; c=relaxed/simple;
	bh=BkAcnHpE9GcSJiLqsTnz2GdUCPvSs02w+aGv7/VsciY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ij3hrH5O6/P8Y//ZOVBQvy3qT0c6eM1ZXrUJWDpH+1TL6zwIXD3DzY8lmggXkeIOSOKn7Usbs1n+Vx8MLbTDZ0ghCG6UzUc5reEzdk9j2ljiSOoCH212mesBw9GrxVL8Na+ZdAGqOBTkWmV4hDVgwzK7Y6T+7Lp4oZkUkiZfVkE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=QLmwZj1w; arc=none smtp.client-ip=91.218.175.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="QLmwZj1w"
Date: Wed, 2 Apr 2025 12:39:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1743611956;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=uwfGc+TCXVTqEsckpWniB97bv30j5zC7diDpefVuDxQ=;
	b=QLmwZj1wmjKjVUx2TirfQSa+Sn2H/tCEg1sYiLw9Cd1SAz4qculAYPuK87JzvITZWVFQJw
	W/A+N3TiEet8pjSyhif8E2Dh+w5/wOUHxbE7ZLYxQ5XNiaUXBUxyn14rIr2owv5s5RIGig
	MVM1NUH7kiRL/7uRjdPn6/TqKtN6254=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH] bcachefs: Remove unnecessary softdep on xxhash
Message-ID: <jlc7u3pf5ohys7v7x2zdgqdwm4t55iassjuzcudavcphg6rlz7@6xh3o7zvru6p>
References: <20250402162338.24424-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250402162338.24424-1-ebiggers@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Wed, Apr 02, 2025 at 09:23:38AM -0700, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> As with the other algorithms, bcachefs does not access xxhash through
> the crypto API.  So there is no need to use a module softdep to ensure
> that it is loaded.
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Applied

> ---
>  fs/bcachefs/super.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/fs/bcachefs/super.c b/fs/bcachefs/super.c
> index 7b3716a9e6cb7..1941b656f4103 100644
> --- a/fs/bcachefs/super.c
> +++ b/fs/bcachefs/super.c
> @@ -72,11 +72,10 @@
>  #include <linux/sysfs.h>
>  
>  MODULE_LICENSE("GPL");
>  MODULE_AUTHOR("Kent Overstreet <kent.overstreet@gmail.com>");
>  MODULE_DESCRIPTION("bcachefs filesystem");
> -MODULE_SOFTDEP("pre: xxhash");
>  
>  const char * const bch2_fs_flag_strs[] = {
>  #define x(n)		#n,
>  	BCH_FS_FLAGS()
>  #undef x
> 
> base-commit: 04c4768d24f70d457ff49681ef726d5d23c089a5
> -- 
> 2.49.0
> 

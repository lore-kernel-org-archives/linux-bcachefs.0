Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFAA41487E1
	for <linux-bcachefs@vger.kernel.org>; Thu, 31 Oct 2024 07:14:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730358853; cv=none; b=n5t+Hyf9NuKNUKUO7YhZfU1mrAdqt9mX6M+4x4XEHO1JFG15RQL8jN2iQOWMpEqdwAAUGW/rAq1jcYjVS/pC+/3FlMSUBskRmKGqqWj9jzOTB2ia+V1EIGoQqdeQJmb0RI6To5dyO9ue8XkUh+tFMKvD95nlW4irLyIkKgt0wXc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730358853; c=relaxed/simple;
	bh=jjAgEfHNrdOpfB3uC1aNDsZWx/qupbfDbB9XPQA2A0w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iLxHFQnskYPgD+08P5NGc+/8XD8OD0PKPUSga8tJHaw7Gb4Mqf8MnPHduhct8Ln9Ilcr1BbKov+GkVHwcAEkbet5lPT0t6cAcW3AXV6wqN5Jf7josnXbCnPO0FculraylZLoLTK8Xjm8fHBYPTlmxYl59cRUkHlsqTM/sMJbEnU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=MqbiO2Uw; arc=none smtp.client-ip=91.218.175.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="MqbiO2Uw"
Date: Thu, 31 Oct 2024 03:14:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1730358847;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=3h0vamvXQdriRj2Gf9Z7cLBPSBRv5r0hK6ZnJtzjOzc=;
	b=MqbiO2Uwj6WZcnCMemA9djWgdQ2hdxqZldyU6rSlypc4R0I+uzn+skSWnxQHQhaey+wjE1
	aHFR7zOBKg65tyurd8g8qgA5rRWHVVv+GgMUnZVbPXiVSlMBO6rvqZmbMaQ7pmbQGMKyxP
	X4xp51AQ8mEP+lYUVsdrF9U5I/6x4Kc=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Pei Xiao <xiaopei01@kylinos.cn>
Cc: linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	xiaopeitux@foxmail.com
Subject: Re: [PATCH] bcachefs: add check NULL return of bio_kmalloc in
 journal_read_bucket
Message-ID: <dp2ysiljektn5cibzvcuohkttw2fzm7ir2svkj7cr7xqcvyyni@esmrfmz4c44m>
References: <62a857230cd1bf17105fb7d3858b3c22098573d3.1730274320.git.xiaopei01@kylinos.cn>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <62a857230cd1bf17105fb7d3858b3c22098573d3.1730274320.git.xiaopei01@kylinos.cn>
X-Migadu-Flow: FLOW_OUT

On Wed, Oct 30, 2024 at 03:48:01PM +0800, Pei Xiao wrote:
> bio_kmalloc may return NULL, will cause NULL pointer dereference.
> Add check NULL return for bio_kmalloc in journal_read_bucket.
> 
> Signed-off-by: Pei Xiao <xiaopei01@kylinos.cn>
> Fixes: ac10a9611d87 ("bcachefs: Some fixes for building in userspace")

Thanks - applied.

> ---
>  fs/bcachefs/errcode.h    | 1 +
>  fs/bcachefs/journal_io.c | 2 ++
>  2 files changed, 3 insertions(+)
> 
> diff --git a/fs/bcachefs/errcode.h b/fs/bcachefs/errcode.h
> index f2736e830007..ae75cb0a842c 100644
> --- a/fs/bcachefs/errcode.h
> +++ b/fs/bcachefs/errcode.h
> @@ -83,6 +83,7 @@
>  	x(ENOMEM,			ENOMEM_fs_other_alloc)			\
>  	x(ENOMEM,			ENOMEM_dev_alloc)			\
>  	x(ENOMEM,			ENOMEM_disk_accounting)			\
> +	x(ENOMEM,                       ENOMEM_journal_read_bucket)             \
>  	x(ENOSPC,			ENOSPC_disk_reservation)		\
>  	x(ENOSPC,			ENOSPC_bucket_alloc)			\
>  	x(ENOSPC,			ENOSPC_disk_label_add)			\
> diff --git a/fs/bcachefs/journal_io.c b/fs/bcachefs/journal_io.c
> index fcb68f111079..667a2bb9e20b 100644
> --- a/fs/bcachefs/journal_io.c
> +++ b/fs/bcachefs/journal_io.c
> @@ -1014,6 +1014,8 @@ static int journal_read_bucket(struct bch_dev *ca,
>  			nr_bvecs = buf_pages(buf->data, sectors_read << 9);
>  
>  			bio = bio_kmalloc(nr_bvecs, GFP_KERNEL);
> +			if (!bio)
> +				return -BCH_ERR_ENOMEM_journal_read_bucket;
>  			bio_init(bio, ca->disk_sb.bdev, bio->bi_inline_vecs, nr_bvecs, REQ_OP_READ);
>  
>  			bio->bi_iter.bi_sector = offset;
> -- 
> 2.34.1
> 

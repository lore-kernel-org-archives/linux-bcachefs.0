Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 188D535966
	for <linux-bcachefs@vger.kernel.org>; Sat, 22 Feb 2025 14:09:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740233349; cv=none; b=KGVgt/+o8I51hwxa6E59FcHbWUenHbtgC2yYj7rcbwZzqxFLgtu0ncAvs5M4EYrwYnxX7xMu7gyBG48EwbVyvZFOvq3uGWULVUMUGiSKreCOydhpuKxQclGXOuq2hTsSZurDoy73BB+nFZGbYkhKKvz/CSom4chd6KKyO1+T36Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740233349; c=relaxed/simple;
	bh=Wj+2MWM7iLww/uXMrJEQ+limP4QYC5MQMMUFboK+EnY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JYfzYOIiIfb490vQCQsUAAa2xHCzNbyN9G3w7QYt1OHxY0MNXmJBtP302mqNLJt8Y4fmHepgU4CIukcj5znh2GE28CeZP7RSmEsPGqme7uxoV1xH3jf2cAZjUdL99ddRijw8cs6X/BTP84ROXH9oiQkBqHIk4ojV9/l0NloMPHM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=OgGtJqfU; arc=none smtp.client-ip=91.218.175.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="OgGtJqfU"
Date: Sat, 22 Feb 2025 09:09:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1740233345;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=wehk4/ETDKyrPPlVjlqaDGNi4kWKCwW/d1R2hpY/2bQ=;
	b=OgGtJqfU99fJvp0+rR5Sj6PIgNebMv9+YWzmY/LAfmnaRObIGH6rRbZ+jkDvArGjnPU4ol
	qHU9x80IZMUkyUsAgR63HDr/pIdSZaWzFh6omprHlZLWfI/dvEoUkhtOF28xupWqq2byxx
	5JDFKRkmMAzBPIHLZE/jGVMHq1rnMRQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Hongbo Li <lihongbo22@huawei.com>
Cc: linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH] bcachefs: fix directory i_size checking for the last
 entry
Message-ID: <4pga2aqhjfi73heyb3sa6aspkyqaqlpbar2pnahf6qksmfgzg6@agayobio2lph>
References: <20250222012412.460211-1-lihongbo22@huawei.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250222012412.460211-1-lihongbo22@huawei.com>
X-Migadu-Flow: FLOW_OUT

On Sat, Feb 22, 2025 at 09:24:12AM +0800, Hongbo Li wrote:
> Checking the i_size of the last directory entry when fsck.
> 
> Fixes: b9ddb3e1a8aa ("bcachefs: Fix fsck directory i_size checking")
> Signed-off-by: Hongbo Li <lihongbo22@huawei.com>

Applied

> ---
>  fs/bcachefs/fsck.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/bcachefs/fsck.c b/fs/bcachefs/fsck.c
> index 9bf316e7b845..a9480bb308b2 100644
> --- a/fs/bcachefs/fsck.c
> +++ b/fs/bcachefs/fsck.c
> @@ -2470,7 +2470,8 @@ int bch2_check_dirents(struct bch_fs *c)
>  				POS(BCACHEFS_ROOT_INO, 0),
>  				BTREE_ITER_prefetch|BTREE_ITER_all_snapshots, k,
>  			check_dirent(trans, &iter, k, &hash_info, &dir, &target, &s)) ?:
> -		check_subdir_count_notnested(trans, &dir));
> +		check_subdir_count_notnested(trans, &dir) ?:
> +		check_dir_i_size_notnested(trans, &dir));
>  
>  	snapshots_seen_exit(&s);
>  	inode_walker_exit(&dir);
> -- 
> 2.33.0
> 

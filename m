Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7EE8230268
	for <linux-bcachefs@vger.kernel.org>; Wed,  2 Apr 2025 03:43:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743565430; cv=none; b=W/HJjIRP+JOcwpXosBow47juhz8AdRly82kF2fwbc9wgBa3UGWA5zRSZ0YwoDJ0hGVRf6nV1ERNe8OFluM762BH4EvQa+IOtNtpOhHIl6ev7ijFTq/yyXeNsYCYNQIjGhapxjMvpuxFHxgaGO7sUZh0V9Rcu6Gm3Y53qBxW4bjg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743565430; c=relaxed/simple;
	bh=FmrYJYUZEKe6RRH51GHxIgp2a9R1JkKwolBbH2w4V/I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AsNk3/3Ducs608vxnTpJKuD9lt9bPvFBi30UGq86zo+P74jpjERS9daj24TXHvKtAsw1DHMWpyqFg0nhqIt6DlaJUvdfU4Y3x93BsVV3FemfALK1yJ3A+/wzO5cEOB2/HF4WsHZYjTGCTHgupzs6Cmeyhpq44H6KdHufG6VKpvY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=XLE1k/Vz; arc=none smtp.client-ip=91.218.175.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="XLE1k/Vz"
Date: Tue, 1 Apr 2025 23:43:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1743565425;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=6Llqkx1+8EPcFs/DfQBpjv0nD9cAUh7CBOXADQhMzGE=;
	b=XLE1k/Vz65wXknLuGgcUX79kD56kMqeDaA7dTEuXmPsMWh1sXag9btnfD9LahnVxLmfK+S
	45oJybCuAdII4eYAH5wSkAv13hLS51cP2UYwDY6B4vUAXTOIYrCbblpQtSbZ92SO+9Js9z
	43bGl2UgozmOFJnDydhP5WpvSYsisr8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-bcachefs@vger.kernel.org
Subject: Re: [ktest PATCH] root_image: explicitly chmod the image to 644
Message-ID: <fwqkech43jucof4unkbdw46ygde44kc7lpyzxj3pmshf76x6ae@zsclcajyciq4>
References: <20250402033931.282645-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250402033931.282645-1-ebiggers@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Tue, Apr 01, 2025 at 08:39:31PM -0700, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> Otherwise it is inaccessible to non-root users on systems that use a
> umask of 0077.
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Applied

> ---
>  root_image | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/root_image b/root_image
> index f2f36a4..964c791 100755
> --- a/root_image
> +++ b/root_image
> @@ -331,10 +331,11 @@ cmd_create()
>  
>      MNT=$(mktemp --tmpdir -d $(basename "$0")-XXXXXXXXXX)
>      #trap 'umount_image; rm "$ktest_image"' EXIT
>  
>      fallocate -l "$IMAGE_SIZE" "$ktest_image"
> +    chmod 644 "$ktest_image"
>      mkfs.ext4 -F "$ktest_image"
>      mount "$ktest_image" "$MNT"
>  
>      DEBOOTSTRAP_DIR=$ktest_dir/debootstrap $debootstrap	\
>  	--no-check-gpg					\
> 
> base-commit: 53229b36f8c4df0690af64dedfce3e247334505e
> -- 
> 2.49.0
> 

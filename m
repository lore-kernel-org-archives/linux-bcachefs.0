Received: from out-180.mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FD841EB1A7
	for <linux-bcachefs@vger.kernel.org>; Wed,  2 Apr 2025 16:27:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743611239; cv=none; b=S9ZPip7t8bhwijE9/xkklCuG4aL/PD4EYHxk7M7yOErEjmVdN2oZtx+jm8lrXjHOSxCKQ4WAgJ63Jw/qMeOzM3GXt231l+VXl519LOmwc7pI6b1RUNeE4j+TGwHQioQ7G/AIlcqNZKcF1YT36kLF/cH0dSSyX6YUOIwZdze/66E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743611239; c=relaxed/simple;
	bh=btYw9r3KlSDrbhQt9hhYqHwqRLoVJdIvDfzzR4IdkS0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Yc4YqBNfBFpLJI8aW7vejvpANJF4NIuK8L6pF+9/1F1wIg93gVKSTDQL90w9gjioXd2zjhajNx4a/Q/Hefux9gp6wY4ZQmy6AxFJOUuCdfbIbboM62O+em7VJvkw0AqTTMwepbbWQH2ucvHzrP2Zv3fXiMt4g9oObEIQJYA5YjA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=OQbW4EDc; arc=none smtp.client-ip=95.215.58.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="OQbW4EDc"
Date: Wed, 2 Apr 2025 12:27:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1743611235;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ZhMwAi34gw65hJfsReFUCHzsaiFK6Ualgjb5bgOm+Ew=;
	b=OQbW4EDcjGpBG+Rp07CIJIPJu/HCFvLqEkk6csePffH9oDxmBoajJfS4h+tbWIse1quA8O
	csBatc3XmzdgpiggPyAWuKbhhSDjUo83XDWebqtJw4pLnyNpBPgCNYBci5Auj2aJ+8EtoS
	mZlBOlQGdCphfbRyTC2vHY4e65Th5Ek=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH] bcachefs: Remove unused variable from
 bch2_fs_encryption_init()
Message-ID: <rt2djifoij2rbkrgpqgzxmabtbxfo3zt7qzo36kfetnrp3cnqa@oceirs5czwmw>
References: <20250402162256.24122-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250402162256.24122-1-ebiggers@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Wed, Apr 02, 2025 at 09:22:56AM -0700, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> The 'key' local variable is no longer used, now that the key is being
> written directly to the struct bch_fs.
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>


Applied
> ---
> 
> Please feel free to fold this into 
> "bcachefs: use library APIs for ChaCha20 and Poly1305".
> 
>  fs/bcachefs/checksum.c | 11 ++++-------
>  1 file changed, 4 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/bcachefs/checksum.c b/fs/bcachefs/checksum.c
> index 7d1e3b908eecd..d0a34a097b809 100644
> --- a/fs/bcachefs/checksum.c
> +++ b/fs/bcachefs/checksum.c
> @@ -682,20 +682,17 @@ void bch2_fs_encryption_exit(struct bch_fs *c)
>  }
>  
>  int bch2_fs_encryption_init(struct bch_fs *c)
>  {
>  	struct bch_sb_field_crypt *crypt;
> -	struct bch_key key;
> -	int ret = 0;
> +	int ret;
>  
>  	crypt = bch2_sb_field_get(c->disk_sb.sb, crypt);
>  	if (!crypt)
> -		goto out;
> +		return 0;
>  
>  	ret = bch2_decrypt_sb_key(c, crypt, &c->chacha20_key);
>  	if (ret)
> -		goto out;
> +		return ret;
>  	c->chacha20_key_set = true;
> -out:
> -	memzero_explicit(&key, sizeof(key));
> -	return ret;
> +	return 0;
>  }
> 
> base-commit: 04c4768d24f70d457ff49681ef726d5d23c089a5
> -- 
> 2.49.0
> 

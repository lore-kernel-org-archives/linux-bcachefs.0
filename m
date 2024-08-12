Received: from out-177.mta1.migadu.com (out-177.mta1.migadu.com [95.215.58.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15D31136A
	for <linux-bcachefs@vger.kernel.org>; Mon, 12 Aug 2024 01:41:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723426872; cv=none; b=ZbdLAQiJE+IYR9Z19e4vWKy0vAvzerhsTaSqaeKAU9PgPwQ4EZ/O3NWP0OC0DfeHATwiyAoWCjI16PlIpBenev+qhefgg5H4u5cjU7PcYANr7u+oEibG+j+O5OXi2t3jX/rL2SzvD3xya2xxrY+EdlMh3S0rdsVRXcGKrR0/Vaw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723426872; c=relaxed/simple;
	bh=YilJIyFH0HE4TGU4eGayTxVcUCJTY3Cq0Of8fXf3sIQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NduVhKA1aOtn544MpiwjpeyZ+xRaJn7mqlnEE8HbiTRPnEvcY5zcPDLh9eQQDljY6ET6WtvFS6bU8BKTZT8x3c0d9ZaS97PFdLb4qCR12v3XpW2jzclPI+9VZLucSj1rsyvo2RCG40HxP9owKO/ThbUuAJXJ85cULnBelT2G/Cw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=B4Kc/Agn; arc=none smtp.client-ip=95.215.58.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="B4Kc/Agn"
Date: Sun, 11 Aug 2024 21:41:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1723426865;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=8UAr05y++mNscHRp5j3Jz0Q+yPwgDTQwThgZI6fh9UQ=;
	b=B4Kc/AgnEq+Jr2/NJupjAMPfNxM9kz0pc7PWf8pr+ul0+HXhuSwPYk8AwNhbWODZsKPRcx
	P7Hwm9EiKfr3sKsf+yVuPKC+YEfcY+2yygqbVGFwVtLBEei2TAQSjsPik1zNSZj2OOYefb
	uPeJQl02JOpZBRvYqxquYfD6GFMfb2M=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Mae Kasza <git@badat.dev>
Cc: linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH] cmd_set_passphrase: initialize KDF parameters
Message-ID: <el5uhxcjrvo5pusy2yuptyxx3olzwaipzrdcqgcyoq65hpthhd@c2gegzjmqcmx>
References: <20240811214152.86593-2-git@badat.dev>
 <20240811214152.86593-3-git@badat.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240811214152.86593-3-git@badat.dev>
X-Migadu-Flow: FLOW_OUT

On Sun, Aug 11, 2024 at 11:40:38PM GMT, Mae Kasza wrote:
> From: mae <git@badat.dev>
> 
> The set-passphrase command failed to derive the key for disks initially
> formatted with --encrypted and --no_passphrase.
> 
> This happened because bch_sb_crypt_init only configures the KDF params
> if a passphrase is specified.
> This commit makes the command initialize the KDF with the same parameters
> as bch_sb_crypt_init if the key wasn't encrypted before.
> 
> Signed-off-by: Mae Kasza <git@badat.dev>

This looks good to me, but I'm in the middle of a 20 hour drive and not
feeling super confident to review crypto stuff tonight, so maybe someone
else can go over it too before I pull it in..

> ---
>  c_src/cmd_key.c |  9 +++++++--
>  c_src/crypto.c  | 13 ++++++++-----
>  c_src/crypto.h  |  1 +
>  3 files changed, 16 insertions(+), 7 deletions(-)
> 
> diff --git a/c_src/cmd_key.c b/c_src/cmd_key.c
> index adb0ac8d..2da83758 100644
> --- a/c_src/cmd_key.c
> +++ b/c_src/cmd_key.c
> @@ -104,7 +104,8 @@ int cmd_set_passphrase(int argc, char *argv[])
>  	if (IS_ERR(c))
>  		die("Error opening %s: %s", argv[1], bch2_err_str(PTR_ERR(c)));
>  
> -	struct bch_sb_field_crypt *crypt = bch2_sb_field_get(c->disk_sb.sb, crypt);
> +	struct bch_sb *sb = c->disk_sb.sb;
> +	struct bch_sb_field_crypt *crypt = bch2_sb_field_get(sb, crypt);
>  	if (!crypt)
>  		die("Filesystem does not have encryption enabled");
>  
> @@ -116,9 +117,13 @@ int cmd_set_passphrase(int argc, char *argv[])
>  		die("Error getting current key");
>  
>  	char *new_passphrase = read_passphrase_twice("Enter new passphrase: ");
> +	if (!bch2_key_is_encrypted(&crypt->key)) {
> +		bch_crypt_default_kdf_init(crypt);
> +	}
> +
>  	struct bch_key passphrase_key = derive_passphrase(crypt, new_passphrase);
>  
> -	if (bch2_chacha_encrypt_key(&passphrase_key, __bch2_sb_key_nonce(c->disk_sb.sb),
> +	if (bch2_chacha_encrypt_key(&passphrase_key, __bch2_sb_key_nonce(sb),
>  				    &new_key, sizeof(new_key)))
>  		die("error encrypting key");
>  	crypt->key = new_key;
> diff --git a/c_src/crypto.c b/c_src/crypto.c
> index 32671bd8..30ad92d4 100644
> --- a/c_src/crypto.c
> +++ b/c_src/crypto.c
> @@ -180,11 +180,7 @@ void bch_sb_crypt_init(struct bch_sb *sb,
>  	get_random_bytes(&crypt->key.key, sizeof(crypt->key.key));
>  
>  	if (passphrase) {
> -
> -		SET_BCH_CRYPT_KDF_TYPE(crypt, BCH_KDF_SCRYPT);
> -		SET_BCH_KDF_SCRYPT_N(crypt, ilog2(16384));
> -		SET_BCH_KDF_SCRYPT_R(crypt, ilog2(8));
> -		SET_BCH_KDF_SCRYPT_P(crypt, ilog2(16));
> +		bch_crypt_default_kdf_init(crypt);
>  
>  		struct bch_key passphrase_key = derive_passphrase(crypt, passphrase);
>  
> @@ -199,3 +195,10 @@ void bch_sb_crypt_init(struct bch_sb *sb,
>  		memzero_explicit(&passphrase_key, sizeof(passphrase_key));
>  	}
>  }
> +
> +void bch_crypt_default_kdf_init(struct bch_sb_field_crypt *crypt) {
> +		SET_BCH_CRYPT_KDF_TYPE(crypt, BCH_KDF_SCRYPT);
> +		SET_BCH_KDF_SCRYPT_N(crypt, ilog2(16384));
> +		SET_BCH_KDF_SCRYPT_R(crypt, ilog2(8));
> +		SET_BCH_KDF_SCRYPT_P(crypt, ilog2(16));
> +}
> diff --git a/c_src/crypto.h b/c_src/crypto.h
> index baea6d86..846a8931 100644
> --- a/c_src/crypto.h
> +++ b/c_src/crypto.h
> @@ -18,5 +18,6 @@ void bch2_passphrase_check(struct bch_sb *, const char *,
>  void bch2_add_key(struct bch_sb *, const char *, const char *, const char *);
>  void bch_sb_crypt_init(struct bch_sb *sb, struct bch_sb_field_crypt *,
>  		       const char *);
> +void bch_crypt_default_kdf_init(struct bch_sb_field_crypt *);
>  
>  #endif /* _CRYPTO_H */
> -- 
> 2.45.2
> 

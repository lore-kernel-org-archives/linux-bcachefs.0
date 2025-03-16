Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FA59944E
	for <linux-bcachefs@vger.kernel.org>; Sun, 16 Mar 2025 17:41:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742146894; cv=none; b=fUZdaxvDceKn9ftvc8YchjVZMF4s/B8BbK4wGdPYQL7YjjjW6jjnblovsac7HQvFYhd8iIK00RkBM4PoK9PM9iPqi5TMgyqjIRqzATV++zAta2lr4F+RKkaju+cQzwISu5RuEUG0MpWa0f8mXrB1c4UF1DDN70doIPJbLe0AfxE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742146894; c=relaxed/simple;
	bh=g+zMoHPNi4ukc9hlyCE+TIkqa+MGreByjCIetW7Toes=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=K2wtw+VIJ2AeyrdXfoGmF/3M94LdqCgsooeprm4LyGIoAZjPF3lUxxsHJfv9SpyQzy31vGJEutvPXXHTSmnAW8t/cOZeHbMOFPffiNs4Kq2aDoicmdjTHltWf/3j0IAoyXc6TvX7QtdVIA4z5MpSxZw+ipwZ7xF/+ZepMRTi8tc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=cwIdqpLn; arc=none smtp.client-ip=91.218.175.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="cwIdqpLn"
Date: Sun, 16 Mar 2025 13:41:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1742146890;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=F5h/ZYpx03v8HZCsr5KtrH7iBV2e0isR5DKpzKWhC4Y=;
	b=cwIdqpLnEGp6H7UwaoAnyxoYaI0K349vsT+UJz/gIQSGsaFaEzj2pI5onyHmGV0erkJTwI
	ZflDLTnQicQa8vsOuQ+/nClm2C5QzM97BJcZM5QsuUx13H1rJvnuzUkWGOQDlf7l6t80tL
	FiReC7nAIPvUq/TvrM08LXMjpDnM/9Q=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH] bcachefs: use sha256() instead of crypto_shash API
Message-ID: <wcqfd2phwvwh46udkc6p3zepuannhuuahwo7ddcfvg34smwu42@yw7m7pwn2hls>
References: <20250316034717.154288-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250316034717.154288-1-ebiggers@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Sat, Mar 15, 2025 at 08:47:17PM -0700, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> Just use sha256() instead of the clunky crypto API.  This is much
> simpler.
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Nice - applied.

> ---
>  fs/bcachefs/Kconfig    |  2 +-
>  fs/bcachefs/bcachefs.h |  1 -
>  fs/bcachefs/checksum.c | 10 ----------
>  fs/bcachefs/str_hash.h |  8 ++------
>  fs/bcachefs/super.c    |  1 -
>  5 files changed, 3 insertions(+), 19 deletions(-)
> 
> diff --git a/fs/bcachefs/Kconfig b/fs/bcachefs/Kconfig
> index fc7efd0a7525e..c9798750202d3 100644
> --- a/fs/bcachefs/Kconfig
> +++ b/fs/bcachefs/Kconfig
> @@ -14,11 +14,11 @@ config BCACHEFS_FS
>  	select ZLIB_DEFLATE
>  	select ZLIB_INFLATE
>  	select ZSTD_COMPRESS
>  	select ZSTD_DECOMPRESS
>  	select CRYPTO
> -	select CRYPTO_SHA256
> +	select CRYPTO_LIB_SHA256
>  	select CRYPTO_CHACHA20
>  	select CRYPTO_POLY1305
>  	select KEYS
>  	select RAID6_PQ
>  	select XOR_BLOCKS
> diff --git a/fs/bcachefs/bcachefs.h b/fs/bcachefs/bcachefs.h
> index b432bb6e6f6e0..0ea593e813f43 100644
> --- a/fs/bcachefs/bcachefs.h
> +++ b/fs/bcachefs/bcachefs.h
> @@ -977,11 +977,10 @@ struct bch_fs {
>  
>  	mempool_t		compression_bounce[2];
>  	mempool_t		compress_workspace[BCH_COMPRESSION_OPT_NR];
>  	size_t			zstd_workspace_size;
>  
> -	struct crypto_shash	*sha256;
>  	struct crypto_sync_skcipher *chacha20;
>  	struct crypto_shash	*poly1305;
>  
>  	atomic64_t		key_version;
>  
> diff --git a/fs/bcachefs/checksum.c b/fs/bcachefs/checksum.c
> index 23a383577d4c7..208e13e308084 100644
> --- a/fs/bcachefs/checksum.c
> +++ b/fs/bcachefs/checksum.c
> @@ -786,28 +786,18 @@ void bch2_fs_encryption_exit(struct bch_fs *c)
>  {
>  	if (c->poly1305)
>  		crypto_free_shash(c->poly1305);
>  	if (c->chacha20)
>  		crypto_free_sync_skcipher(c->chacha20);
> -	if (c->sha256)
> -		crypto_free_shash(c->sha256);
>  }
>  
>  int bch2_fs_encryption_init(struct bch_fs *c)
>  {
>  	struct bch_sb_field_crypt *crypt;
>  	struct bch_key key;
>  	int ret = 0;
>  
> -	c->sha256 = crypto_alloc_shash("sha256", 0, 0);
> -	ret = PTR_ERR_OR_ZERO(c->sha256);
> -	if (ret) {
> -		c->sha256 = NULL;
> -		bch_err(c, "error requesting sha256 module: %s", bch2_err_str(ret));
> -		goto out;
> -	}
> -
>  	crypt = bch2_sb_field_get(c->disk_sb.sb, crypt);
>  	if (!crypt)
>  		goto out;
>  
>  	ret = bch2_alloc_ciphers(c);
> diff --git a/fs/bcachefs/str_hash.h b/fs/bcachefs/str_hash.h
> index f645a4547b049..575ad1e039040 100644
> --- a/fs/bcachefs/str_hash.h
> +++ b/fs/bcachefs/str_hash.h
> @@ -10,11 +10,10 @@
>  #include "siphash.h"
>  #include "subvolume.h"
>  #include "super.h"
>  
>  #include <linux/crc32c.h>
> -#include <crypto/hash.h>
>  #include <crypto/sha2.h>
>  
>  static inline enum bch_str_hash_type
>  bch2_str_hash_opt_to_type(struct bch_fs *c, enum bch_str_hash_opts opt)
>  {
> @@ -53,17 +52,14 @@ bch2_hash_info_init(struct bch_fs *c, const struct bch_inode_unpacked *bi)
>  #endif
>  		.siphash_key = { .k0 = bi->bi_hash_seed }
>  	};
>  
>  	if (unlikely(info.type == BCH_STR_HASH_siphash_old)) {
> -		SHASH_DESC_ON_STACK(desc, c->sha256);
>  		u8 digest[SHA256_DIGEST_SIZE];
>  
> -		desc->tfm = c->sha256;
> -
> -		crypto_shash_digest(desc, (void *) &bi->bi_hash_seed,
> -				    sizeof(bi->bi_hash_seed), digest);
> +		sha256((const u8 *)&bi->bi_hash_seed,
> +		       sizeof(bi->bi_hash_seed), digest);
>  		memcpy(&info.siphash_key, digest, sizeof(info.siphash_key));
>  	}
>  
>  	return info;
>  }
> diff --git a/fs/bcachefs/super.c b/fs/bcachefs/super.c
> index 6de3a5751561e..8e928b3d8ef4a 100644
> --- a/fs/bcachefs/super.c
> +++ b/fs/bcachefs/super.c
> @@ -73,11 +73,10 @@
>  #include <crypto/hash.h>
>  
>  MODULE_LICENSE("GPL");
>  MODULE_AUTHOR("Kent Overstreet <kent.overstreet@gmail.com>");
>  MODULE_DESCRIPTION("bcachefs filesystem");
> -MODULE_SOFTDEP("pre: sha256");
>  MODULE_SOFTDEP("pre: chacha20");
>  MODULE_SOFTDEP("pre: poly1305");
>  MODULE_SOFTDEP("pre: xxhash");
>  
>  const char * const bch2_fs_flag_strs[] = {
> 
> base-commit: da920b7df701770e006928053672147075587fb2
> prerequisite-patch-id: 500a8dddbef9cb497eecaf59c0cb8fc7f2e4380e
> -- 
> 2.49.0
> 

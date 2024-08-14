Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB0E517C64
	for <linux-bcachefs@vger.kernel.org>; Wed, 14 Aug 2024 02:22:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723602123; cv=none; b=bODzUqfVkb1b7JtIwve4vZA5OEusvaM1OuqKcUUXewUXjKbwaXfBCk3aLlp7JtmL1oDB7Yf0Xu040UgQGQZQWn+61MVDCfZ6YRZyk78Le+eCEQ5qncP5YGqYEPdw9k5KfLoMXjeYb537riL6GBRUOjr4IVqfFJw7CmZLCDmUVxY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723602123; c=relaxed/simple;
	bh=8gMHrLc+L4wbi//fkmz9tTsrDrD7SFMp9i87gJy4+sk=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=FRN0/lVQrunmL8fsm7/SlYGM0j7r9UTMwU5/ITe85DehwS6bZ6DcJdRMwKsZrxOmXM6+74vdCqug3CBK2zTzvA1RTpbVV9AQR9EfaJ/PE5y7BWrSAwtoazBjuZAhLiwaW81gA4TZK1HFDlnEFhOgF8YNk6aVXM2x9qQQxn+tIGY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.162.254])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4WkBmH43R2zfbHy;
	Wed, 14 Aug 2024 10:19:59 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (unknown [7.185.36.66])
	by mail.maildlp.com (Postfix) with ESMTPS id 9B32618010A;
	Wed, 14 Aug 2024 10:21:56 +0800 (CST)
Received: from [10.67.111.104] (10.67.111.104) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 14 Aug 2024 10:21:56 +0800
Message-ID: <f22fb349-0fa1-43bd-82ec-a9328ab2feff@huawei.com>
Date: Wed, 14 Aug 2024 10:21:55 +0800
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] Extract bch_crypt_update_passphrase function
Content-Language: en-US
To: Mae Kasza <git@badat.dev>
CC: <kent.overstreet@linux.dev>, <linux-bcachefs@vger.kernel.org>
References: <5252a768-7abe-4af1-8d78-9cbfbd1c9186@badat.dev>
 <20240813173734.260952-2-git@badat.dev>
From: Hongbo Li <lihongbo22@huawei.com>
In-Reply-To: <20240813173734.260952-2-git@badat.dev>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpeml500022.china.huawei.com (7.185.36.66)



On 2024/8/14 1:37, Mae Kasza wrote:
> This also fixes a bug where the set-passphrase
> command failed to derive the key for disks initially
> formatted with --encrypted and --no_passphrase, due to
> bch_sb_crypt_init not configuring the KDF params if
> the passphrase wasn't specified during formatting.
> 
> Signed-off-by: Mae Kasza <git@badat.dev>
> ---
>   c_src/cmd_key.c | 26 ++++++++++----------------
>   c_src/crypto.c  | 43 ++++++++++++++++++++++++++++++++-----------
>   c_src/crypto.h  |  3 +++
>   3 files changed, 45 insertions(+), 27 deletions(-)
> 
> diff --git a/c_src/cmd_key.c b/c_src/cmd_key.c
> index adb0ac8d..ac8a94a8 100644
> --- a/c_src/cmd_key.c
> +++ b/c_src/cmd_key.c
> @@ -104,24 +104,19 @@ int cmd_set_passphrase(int argc, char *argv[])
>   	if (IS_ERR(c))
>   		die("Error opening %s: %s", argv[1], bch2_err_str(PTR_ERR(c)));
>   
> -	struct bch_sb_field_crypt *crypt = bch2_sb_field_get(c->disk_sb.sb, crypt);
> +	struct bch_sb *sb = c->disk_sb.sb;
> +	struct bch_sb_field_crypt *crypt = bch2_sb_field_get(sb, crypt);
>   	if (!crypt)
>   		die("Filesystem does not have encryption enabled");
>   
> -	struct bch_encrypted_key new_key;
> -	new_key.magic = BCH_KEY_MAGIC;
> -
> -	int ret = bch2_decrypt_sb_key(c, crypt, &new_key.key);
> +	struct bch_key key;
> +	int ret = bch2_decrypt_sb_key(c, crypt, &key);
>   	if (ret)
>   		die("Error getting current key");
>   
>   	char *new_passphrase = read_passphrase_twice("Enter new passphrase: ");
> -	struct bch_key passphrase_key = derive_passphrase(crypt, new_passphrase);
>   
> -	if (bch2_chacha_encrypt_key(&passphrase_key, __bch2_sb_key_nonce(c->disk_sb.sb),
> -				    &new_key, sizeof(new_key)))
> -		die("error encrypting key");
> -	crypt->key = new_key;
> +	bch_crypt_update_passphrase(sb, crypt, &key, new_passphrase);
>   
>   	bch2_revoke_key(c->disk_sb.sb);
>   	bch2_write_super(c);
> @@ -142,18 +137,17 @@ int cmd_remove_passphrase(int argc, char *argv[])
>   	if (IS_ERR(c))
>   		die("Error opening %s: %s", argv[1], bch2_err_str(PTR_ERR(c)));
>   
> -	struct bch_sb_field_crypt *crypt = bch2_sb_field_get(c->disk_sb.sb, crypt);
> +	struct bch_sb *sb = c->disk_sb.sb;
> +	struct bch_sb_field_crypt *crypt = bch2_sb_field_get(sb, crypt);
>   	if (!crypt)
>   		die("Filesystem does not have encryption enabled");
>   
> -	struct bch_encrypted_key new_key;
> -	new_key.magic = BCH_KEY_MAGIC;
> -
> -	int ret = bch2_decrypt_sb_key(c, crypt, &new_key.key);
> +	struct bch_key key;
> +	int ret = bch2_decrypt_sb_key(c, crypt, &key);
>   	if (ret)
>   		die("Error getting current key");
>   
> -	crypt->key = new_key;
> +	bch_crypt_update_passphrase(sb, crypt, &key, NULL);
>   
>   	bch2_write_super(c);
>   	bch2_fs_stop(c);
> diff --git a/c_src/crypto.c b/c_src/crypto.c
> index 32671bd8..301dbebe 100644
> --- a/c_src/crypto.c
> +++ b/c_src/crypto.c
> @@ -176,26 +176,47 @@ void bch_sb_crypt_init(struct bch_sb *sb,
>   		       struct bch_sb_field_crypt *crypt,
>   		       const char *passphrase)
>   {
> +	struct bch_key key;
> +	get_random_bytes(&key, sizeof(key));
> +
>   	crypt->key.magic = BCH_KEY_MAGIC;
> -	get_random_bytes(&crypt->key.key, sizeof(crypt->key.key));
> +	crypt->key.key = key;
>   
> -	if (passphrase) {
> +	bch_crypt_update_passphrase(sb, crypt, &key, passphrase);
> +}
>   
> +void bch_crypt_update_passphrase(
> +			struct bch_sb *sb,
> +			struct bch_sb_field_crypt *crypt,
> +			struct bch_key *key,
> +			const char *new_passphrase)
> +{
> +
> +	struct bch_encrypted_key new_key;
> +	new_key.magic = BCH_KEY_MAGIC;
> +	new_key.key = *key;
> +
> +	if(!new_passphrase) {
> +		crypt->key = new_key;
May be the helper like this is needed. But we could assign the 
crypt->key outside, which seems more reasonable according to the helper 
name. Just in my humble opinion.

Thanks,
Hongbo

> +		return;
> +	}
> +
> +	// If crypt already has an encrypted key reuse it's encryption params
> +	if (!bch2_key_is_encrypted(&crypt->key)) {
>   		SET_BCH_CRYPT_KDF_TYPE(crypt, BCH_KDF_SCRYPT);
>   		SET_BCH_KDF_SCRYPT_N(crypt, ilog2(16384));
>   		SET_BCH_KDF_SCRYPT_R(crypt, ilog2(8));
>   		SET_BCH_KDF_SCRYPT_P(crypt, ilog2(16));
> +	}
>   
> -		struct bch_key passphrase_key = derive_passphrase(crypt, passphrase);
> -
> -		assert(!bch2_key_is_encrypted(&crypt->key));
> +	struct bch_key passphrase_key = derive_passphrase(crypt, new_passphrase);
>   
> -		if (bch2_chacha_encrypt_key(&passphrase_key, __bch2_sb_key_nonce(sb),
> -					   &crypt->key, sizeof(crypt->key)))
> -			die("error encrypting key");
> +	if (bch2_chacha_encrypt_key(&passphrase_key, __bch2_sb_key_nonce(sb),
> +				    &new_key, sizeof(new_key)))
> +		die("error encrypting key");
>   
> -		assert(bch2_key_is_encrypted(&crypt->key));
> +	memzero_explicit(&passphrase_key, sizeof(passphrase_key));
>   
> -		memzero_explicit(&passphrase_key, sizeof(passphrase_key));
> -	}
> +	crypt->key = new_key;
> +	assert(bch2_key_is_encrypted(&crypt->key));
>   }
> diff --git a/c_src/crypto.h b/c_src/crypto.h
> index baea6d86..cd3baac8 100644
> --- a/c_src/crypto.h
> +++ b/c_src/crypto.h
> @@ -19,4 +19,7 @@ void bch2_add_key(struct bch_sb *, const char *, const char *, const char *);
>   void bch_sb_crypt_init(struct bch_sb *sb, struct bch_sb_field_crypt *,
>   		       const char *);
>   
> +void bch_crypt_update_passphrase(struct bch_sb *sb, struct bch_sb_field_crypt *crypt,
> +			struct bch_key *key, const char *new_passphrase);
> +
>   #endif /* _CRYPTO_H */

Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 440A51B1409
	for <linux-bcachefs@vger.kernel.org>; Wed, 14 Aug 2024 12:29:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723638561; cv=none; b=Sx4dVWg5+bxVOBjnBbDwdnoIDgYJkVWWDj1FtzwXegg5dP0uDTKL8679rHnQD7YTQ4hBUSBBur3dBj+XYN+oqIR2HrD2/nYErC3PB4DDdU3KMIqZvmxlSynU7w6CmIBVs8B3wSztC6twZ0e0pivjGHLthlWIvZ9iPgbLdNBdP90=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723638561; c=relaxed/simple;
	bh=1jj+JK0Opu0M8OQIVN6HSfuxcuOxMejDZNyVEoVv1HY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Jk8MOTkLgHmdkiDNItKI9t62C0e0MspPGsXa0whbTkS9tLcYpn7mfN7c1+cgQBhUkqmmBmPVrgZY69BP0NyJVnP9Vv5AnPw1QK6U+bhg0lRBMpsG8AzSm7qozZlwTLBr2BeZA3/ZxcTEGPMyuXC0D4wpTuMo7ZMtlfIhbD77C2w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=badat.dev; spf=pass smtp.mailfrom=badat.dev; dkim=pass (2048-bit key) header.d=badat.dev header.i=@badat.dev header.b=haGRNd2Y; arc=none smtp.client-ip=91.218.175.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=badat.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=badat.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=badat.dev header.i=@badat.dev header.b="haGRNd2Y"
Message-ID: <15a42dfe-adbe-4f10-beec-3ae6a822b841@badat.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=badat.dev; s=key1;
	t=1723638557;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OP6uJBkiwGie4W/iEyNuwl52V5cX/2lkRgqAHxuN/Sw=;
	b=haGRNd2Yp8+DQEbOzr6ghbAXJzUyls1dET5pgf0TY9zKpfQslrxjBZmTkcjA4Nn9IC0/Ie
	N21P/kn/pM44pXhRr6UAYXBhb2pmc/214s0TDI5fJaMmUpff1wh4/OLEl8gHTL3+ovmeCq
	nVDEaT4vzu3WeSUg0WXCHxkbnYkNWMMDf388DEfb8bXGjtzosJDP6jTB3PaWZlHtW9bKqZ
	aE5x4yBo1V42AtFbw2XzWcqhx2s7vntNEVFU/VfJo9P5goWb6aLzRXjd6PCY4IoS2ETzwN
	D0nxqXqV2uKll9ntMemfqy7Oo1oUnEaDj3/2P3G0CXpUf0LfiAk+g3nM7vZbwA==
Date: Wed, 14 Aug 2024 14:29:13 +0200
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH] Extract bch_crypt_update_passphrase function
To: Hongbo Li <lihongbo22@huawei.com>, Mae Kasza <git@badat.dev>
Cc: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org
References: <5252a768-7abe-4af1-8d78-9cbfbd1c9186@badat.dev>
 <20240813173734.260952-2-git@badat.dev>
 <f22fb349-0fa1-43bd-82ec-a9328ab2feff@huawei.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Mae Kasza <admin@badat.dev>
In-Reply-To: <f22fb349-0fa1-43bd-82ec-a9328ab2feff@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT


On 8/14/24 04:21, Hongbo Li wrote:
>
>
> On 2024/8/14 1:37, Mae Kasza wrote:
>> This also fixes a bug where the set-passphrase
>> command failed to derive the key for disks initially
>> formatted with --encrypted and --no_passphrase, due to
>> bch_sb_crypt_init not configuring the KDF params if
>> the passphrase wasn't specified during formatting.
>>
>> Signed-off-by: Mae Kasza <git@badat.dev>
>> ---
>>   c_src/cmd_key.c | 26 ++++++++++----------------
>>   c_src/crypto.c  | 43 ++++++++++++++++++++++++++++++++-----------
>>   c_src/crypto.h  |  3 +++
>>   3 files changed, 45 insertions(+), 27 deletions(-)
>>
>> diff --git a/c_src/cmd_key.c b/c_src/cmd_key.c
>> index adb0ac8d..ac8a94a8 100644
>> --- a/c_src/cmd_key.c
>> +++ b/c_src/cmd_key.c
>> @@ -104,24 +104,19 @@ int cmd_set_passphrase(int argc, char *argv[])
>>       if (IS_ERR(c))
>>           die("Error opening %s: %s", argv[1], 
>> bch2_err_str(PTR_ERR(c)));
>>   -    struct bch_sb_field_crypt *crypt = 
>> bch2_sb_field_get(c->disk_sb.sb, crypt);
>> +    struct bch_sb *sb = c->disk_sb.sb;
>> +    struct bch_sb_field_crypt *crypt = bch2_sb_field_get(sb, crypt);
>>       if (!crypt)
>>           die("Filesystem does not have encryption enabled");
>>   -    struct bch_encrypted_key new_key;
>> -    new_key.magic = BCH_KEY_MAGIC;
>> -
>> -    int ret = bch2_decrypt_sb_key(c, crypt, &new_key.key);
>> +    struct bch_key key;
>> +    int ret = bch2_decrypt_sb_key(c, crypt, &key);
>>       if (ret)
>>           die("Error getting current key");
>>         char *new_passphrase = read_passphrase_twice("Enter new 
>> passphrase: ");
>> -    struct bch_key passphrase_key = derive_passphrase(crypt, 
>> new_passphrase);
>>   -    if (bch2_chacha_encrypt_key(&passphrase_key, 
>> __bch2_sb_key_nonce(c->disk_sb.sb),
>> -                    &new_key, sizeof(new_key)))
>> -        die("error encrypting key");
>> -    crypt->key = new_key;
>> +    bch_crypt_update_passphrase(sb, crypt, &key, new_passphrase);
>>         bch2_revoke_key(c->disk_sb.sb);
>>       bch2_write_super(c);
>> @@ -142,18 +137,17 @@ int cmd_remove_passphrase(int argc, char *argv[])
>>       if (IS_ERR(c))
>>           die("Error opening %s: %s", argv[1], 
>> bch2_err_str(PTR_ERR(c)));
>>   -    struct bch_sb_field_crypt *crypt = 
>> bch2_sb_field_get(c->disk_sb.sb, crypt);
>> +    struct bch_sb *sb = c->disk_sb.sb;
>> +    struct bch_sb_field_crypt *crypt = bch2_sb_field_get(sb, crypt);
>>       if (!crypt)
>>           die("Filesystem does not have encryption enabled");
>>   -    struct bch_encrypted_key new_key;
>> -    new_key.magic = BCH_KEY_MAGIC;
>> -
>> -    int ret = bch2_decrypt_sb_key(c, crypt, &new_key.key);
>> +    struct bch_key key;
>> +    int ret = bch2_decrypt_sb_key(c, crypt, &key);
>>       if (ret)
>>           die("Error getting current key");
>>   -    crypt->key = new_key;
>> +    bch_crypt_update_passphrase(sb, crypt, &key, NULL);
>>         bch2_write_super(c);
>>       bch2_fs_stop(c);
>> diff --git a/c_src/crypto.c b/c_src/crypto.c
>> index 32671bd8..301dbebe 100644
>> --- a/c_src/crypto.c
>> +++ b/c_src/crypto.c
>> @@ -176,26 +176,47 @@ void bch_sb_crypt_init(struct bch_sb *sb,
>>                  struct bch_sb_field_crypt *crypt,
>>                  const char *passphrase)
>>   {
>> +    struct bch_key key;
>> +    get_random_bytes(&key, sizeof(key));
>> +
>>       crypt->key.magic = BCH_KEY_MAGIC;
>> -    get_random_bytes(&crypt->key.key, sizeof(crypt->key.key));
>> +    crypt->key.key = key;
>>   -    if (passphrase) {
>> +    bch_crypt_update_passphrase(sb, crypt, &key, passphrase);
>> +}
>>   +void bch_crypt_update_passphrase(
>> +            struct bch_sb *sb,
>> +            struct bch_sb_field_crypt *crypt,
>> +            struct bch_key *key,
>> +            const char *new_passphrase)
>> +{
>> +
>> +    struct bch_encrypted_key new_key;
>> +    new_key.magic = BCH_KEY_MAGIC;
>> +    new_key.key = *key;
>> +
>> +    if(!new_passphrase) {
>> +        crypt->key = new_key;
> May be the helper like this is needed. But we could assign the 
> crypt->key outside, which seems more reasonable according to the 
> helper name. Just in my humble opinion.
>
> Thanks,
> Hongbo

We need to assign to crypt->key regardless, since it's what contains the 
key encrypted with passphrase, I don't really see why we would want to 
leave that up to the caller

Thanks,

Mae

>
>> +        return;
>> +    }
>> +
>> +    // If crypt already has an encrypted key reuse it's encryption 
>> params
>> +    if (!bch2_key_is_encrypted(&crypt->key)) {
>>           SET_BCH_CRYPT_KDF_TYPE(crypt, BCH_KDF_SCRYPT);
>>           SET_BCH_KDF_SCRYPT_N(crypt, ilog2(16384));
>>           SET_BCH_KDF_SCRYPT_R(crypt, ilog2(8));
>>           SET_BCH_KDF_SCRYPT_P(crypt, ilog2(16));
>> +    }
>>   -        struct bch_key passphrase_key = derive_passphrase(crypt, 
>> passphrase);
>> -
>> -        assert(!bch2_key_is_encrypted(&crypt->key));
>> +    struct bch_key passphrase_key = derive_passphrase(crypt, 
>> new_passphrase);
>>   -        if (bch2_chacha_encrypt_key(&passphrase_key, 
>> __bch2_sb_key_nonce(sb),
>> -                       &crypt->key, sizeof(crypt->key)))
>> -            die("error encrypting key");
>> +    if (bch2_chacha_encrypt_key(&passphrase_key, 
>> __bch2_sb_key_nonce(sb),
>> +                    &new_key, sizeof(new_key)))
>> +        die("error encrypting key");
>>   -        assert(bch2_key_is_encrypted(&crypt->key));
>> +    memzero_explicit(&passphrase_key, sizeof(passphrase_key));
>>   -        memzero_explicit(&passphrase_key, sizeof(passphrase_key));
>> -    }
>> +    crypt->key = new_key;
>> +    assert(bch2_key_is_encrypted(&crypt->key));
>>   }
>> diff --git a/c_src/crypto.h b/c_src/crypto.h
>> index baea6d86..cd3baac8 100644
>> --- a/c_src/crypto.h
>> +++ b/c_src/crypto.h
>> @@ -19,4 +19,7 @@ void bch2_add_key(struct bch_sb *, const char *, 
>> const char *, const char *);
>>   void bch_sb_crypt_init(struct bch_sb *sb, struct bch_sb_field_crypt *,
>>                  const char *);
>>   +void bch_crypt_update_passphrase(struct bch_sb *sb, struct 
>> bch_sb_field_crypt *crypt,
>> +            struct bch_key *key, const char *new_passphrase);
>> +
>>   #endif /* _CRYPTO_H */

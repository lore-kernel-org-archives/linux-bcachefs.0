Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8AD71E517
	for <linux-bcachefs@vger.kernel.org>; Tue, 13 Aug 2024 13:16:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723555007; cv=none; b=eejjebXe6KvKFAuvh7oyLwcCP8eQWw1tW2ICuqiVlX8QtvtDQNWa4fLC1BQXAoIIxA1kHefwYSEwuqPptbGS3vp0i6ADnZjRJeMS209BRXOXu5sZAJh2/OJKv/m3W2adg+Shi1pqZWeF4Kx8sfhcuhWQlFJwWNPQqiTIc5rZIy0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723555007; c=relaxed/simple;
	bh=6KJ/IgUmWpp9/MxmVsQzq36zaat/iZMYlnUzCOZnTm4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=oitNXzzUZFNM1DUJ/s/ZqARIHsOUGuI7i/1jU9ffDpcrp9+SQVW5pyZs1MJtDLUzg4Wa099ZJRDKCjUdpXTpOkWNG1wNBkxQhy0R4vVo9WceRauxGGxvReqAcl90em3JXl7pUmrworGFXXWU1NcQKggP4a8+YmpD07qwfkiqmhg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=badat.dev; spf=pass smtp.mailfrom=badat.dev; dkim=pass (2048-bit key) header.d=badat.dev header.i=@badat.dev header.b=nRl5f92k; arc=none smtp.client-ip=91.218.175.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=badat.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=badat.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=badat.dev header.i=@badat.dev header.b="nRl5f92k"
Message-ID: <5252a768-7abe-4af1-8d78-9cbfbd1c9186@badat.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=badat.dev; s=key1;
	t=1723555001;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vEkesvM2V8Qo0T/hyBrP+dF2YXJXHS18/69F1bOF69k=;
	b=nRl5f92kRA4XOhsCtbt8Ok7wYWi3PkrHwTKMujTiSVk6+E5siZJ8hua58o6KVimvkBWJ+6
	BDXiIb+ag1hAbziS9VCXsIIR+CEoZghd0S3rDERqB/spkvhP/j/t9QxE2fwZO/asT9XGmo
	VYlp5nPSV/aNuh5w1PuVReIVdZTIHC5li/Yb1jk5dLL/qTQab/hUZLSDO0V7tiuWfwn9t2
	annQJ8kGciciVG+Tt7pocYQveVQqntCKd/0lt3630NEVuLhX7a+xTHlkBHgW0ORa0G7Ddq
	M5Vt99lQP5gCKDM3EJ4Q1SPoeu4fhfNA3psO9eNhJGRpKl67eUtamg+uADXuBQ==
Date: Tue, 13 Aug 2024 15:16:36 +0200
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH] cmd_set_passphrase: initialize KDF parameters
To: Hongbo Li <lihongbo22@huawei.com>,
 Kent Overstreet <kent.overstreet@linux.dev>, Mae Kasza <git@badat.dev>
Cc: linux-bcachefs@vger.kernel.org
References: <20240811214152.86593-2-git@badat.dev>
 <20240811214152.86593-3-git@badat.dev>
 <el5uhxcjrvo5pusy2yuptyxx3olzwaipzrdcqgcyoq65hpthhd@c2gegzjmqcmx>
 <9aca486e-ed70-4826-9cae-024fb64b12a8@huawei.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Mae Kasza <git@badat.dev>
In-Reply-To: <9aca486e-ed70-4826-9cae-024fb64b12a8@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT


On 8/12/24 04:50, Hongbo Li wrote:
>
>
> On 2024/8/12 9:41, Kent Overstreet wrote:
>> On Sun, Aug 11, 2024 at 11:40:38PM GMT, Mae Kasza wrote:
>>> From: mae <git@badat.dev>
>>>
>>> The set-passphrase command failed to derive the key for disks initially
>>> formatted with --encrypted and --no_passphrase.
>>>
>>> This happened because bch_sb_crypt_init only configures the KDF params
>>> if a passphrase is specified.
>>> This commit makes the command initialize the KDF with the same 
>>> parameters
>>> as bch_sb_crypt_init if the key wasn't encrypted before.
>>>
>>> Signed-off-by: Mae Kasza <git@badat.dev>
>>
>> This looks good to me, but I'm in the middle of a 20 hour drive and not
>> feeling super confident to review crypto stuff tonight, so maybe someone
>> else can go over it too before I pull it in..
>>
>>> ---
>>>   c_src/cmd_key.c |  9 +++++++--
>>>   c_src/crypto.c  | 13 ++++++++-----
>>>   c_src/crypto.h  |  1 +
>>>   3 files changed, 16 insertions(+), 7 deletions(-)
>>>
>>> diff --git a/c_src/cmd_key.c b/c_src/cmd_key.c
>>> index adb0ac8d..2da83758 100644
>>> --- a/c_src/cmd_key.c
>>> +++ b/c_src/cmd_key.c
>>> @@ -104,7 +104,8 @@ int cmd_set_passphrase(int argc, char *argv[])
>>>       if (IS_ERR(c))
>>>           die("Error opening %s: %s", argv[1], 
>>> bch2_err_str(PTR_ERR(c)));
>>>   -    struct bch_sb_field_crypt *crypt = 
>>> bch2_sb_field_get(c->disk_sb.sb, crypt);
>>> +    struct bch_sb *sb = c->disk_sb.sb;
>>> +    struct bch_sb_field_crypt *crypt = bch2_sb_field_get(sb, crypt);
>>>       if (!crypt)
>>>           die("Filesystem does not have encryption enabled");
>>>   @@ -116,9 +117,13 @@ int cmd_set_passphrase(int argc, char *argv[])
>>>           die("Error getting current key");
>>>         char *new_passphrase = read_passphrase_twice("Enter new 
>>> passphrase: ");
>>> +    if (!bch2_key_is_encrypted(&crypt->key)) {
>>> +        bch_crypt_default_kdf_init(crypt);
> It works, but using bch_sb_crypt_init to reinitialize crypt may be 
> better. In bch_sb_crypt_init, it has initialized the crypt and also 
> cleaned new_passphrase.
>
> Thanks
> Hongbo
>
bch_sb_crypt_init also reinitializes the crypt->key, so I can't just 
reuse it here.

I could extract it into a bch_crypt_update_passphrase function. 
Originally I wanted to avoid doing that to limit the scope of this 
patchset, but I'll give it a shot

Thanks for the review!

Mae

>>> +    }
>>> +
>>>       struct bch_key passphrase_key = derive_passphrase(crypt, 
>>> new_passphrase);
>>>   -    if (bch2_chacha_encrypt_key(&passphrase_key, 
>>> __bch2_sb_key_nonce(c->disk_sb.sb),
>>> +    if (bch2_chacha_encrypt_key(&passphrase_key, 
>>> __bch2_sb_key_nonce(sb),
>>>                       &new_key, sizeof(new_key)))
>>>           die("error encrypting key");
>>>       crypt->key = new_key;
>>> diff --git a/c_src/crypto.c b/c_src/crypto.c
>>> index 32671bd8..30ad92d4 100644
>>> --- a/c_src/crypto.c
>>> +++ b/c_src/crypto.c
>>> @@ -180,11 +180,7 @@ void bch_sb_crypt_init(struct bch_sb *sb,
>>>       get_random_bytes(&crypt->key.key, sizeof(crypt->key.key));
>>>         if (passphrase) {
>>> -
>>> -        SET_BCH_CRYPT_KDF_TYPE(crypt, BCH_KDF_SCRYPT);
>>> -        SET_BCH_KDF_SCRYPT_N(crypt, ilog2(16384));
>>> -        SET_BCH_KDF_SCRYPT_R(crypt, ilog2(8));
>>> -        SET_BCH_KDF_SCRYPT_P(crypt, ilog2(16));
>>> +        bch_crypt_default_kdf_init(crypt);
>>>             struct bch_key passphrase_key = derive_passphrase(crypt, 
>>> passphrase);
>>>   @@ -199,3 +195,10 @@ void bch_sb_crypt_init(struct bch_sb *sb,
>>>           memzero_explicit(&passphrase_key, sizeof(passphrase_key));
>>>       }
>>>   }
>>> +
>>> +void bch_crypt_default_kdf_init(struct bch_sb_field_crypt *crypt) {
>>> +        SET_BCH_CRYPT_KDF_TYPE(crypt, BCH_KDF_SCRYPT);
>>> +        SET_BCH_KDF_SCRYPT_N(crypt, ilog2(16384));
>>> +        SET_BCH_KDF_SCRYPT_R(crypt, ilog2(8));
>>> +        SET_BCH_KDF_SCRYPT_P(crypt, ilog2(16));
>>> +}
>>> diff --git a/c_src/crypto.h b/c_src/crypto.h
>>> index baea6d86..846a8931 100644
>>> --- a/c_src/crypto.h
>>> +++ b/c_src/crypto.h
>>> @@ -18,5 +18,6 @@ void bch2_passphrase_check(struct bch_sb *, const 
>>> char *,
>>>   void bch2_add_key(struct bch_sb *, const char *, const char *, 
>>> const char *);
>>>   void bch_sb_crypt_init(struct bch_sb *sb, struct 
>>> bch_sb_field_crypt *,
>>>                  const char *);
>>> +void bch_crypt_default_kdf_init(struct bch_sb_field_crypt *);
>>>     #endif /* _CRYPTO_H */
>>> -- 
>>> 2.45.2
>>>
>>
>>
>

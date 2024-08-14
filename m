Received: from out-177.mta1.migadu.com (out-177.mta1.migadu.com [95.215.58.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B42DE1B0126
	for <linux-bcachefs@vger.kernel.org>; Wed, 14 Aug 2024 12:25:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723638362; cv=none; b=mpnfnUDoNOxtWY7IiSYl6jjHhnTqRg53umMpPOLzyICgdb3GLI3yqXsXpf33MFy53dUPS7iBYq3GcybQhuCFBxyQQEOgmgni+PAQEGGWcnh3EmnnIDAEE0BCmFXFlYBoty7LRfcxypmEb0wiM/EMNNttT7aEqRHhYz+viZfCvAU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723638362; c=relaxed/simple;
	bh=nReeWZ2pgLj5+TTP+y/b5KPLDoD+pHbI5ReNtbCWOPk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CrpTeLzkDvsjXXt24yNdE3RunhScUuKZeifhAlRwFVPXqoKMXAeLz7PHFg109i0MZKQfU0IO5NO5gP0AUQq+YwsCEGlfu6P5KP81w2hzGIyfBsYZSiQIF+Wvc8Z6MXntBp12CS8PFI41w79LJNlF7QMS+FGT6NxF/Qc8Y/tYDPw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=badat.dev; spf=pass smtp.mailfrom=badat.dev; dkim=pass (2048-bit key) header.d=badat.dev header.i=@badat.dev header.b=rnOKo3UH; arc=none smtp.client-ip=95.215.58.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=badat.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=badat.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=badat.dev header.i=@badat.dev header.b="rnOKo3UH"
Message-ID: <b31673a7-dddd-45c5-9e55-798a2ff65407@badat.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=badat.dev; s=key1;
	t=1723638356;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pa94LhPHUv4WKluGoK8j1UU/zUSir9/j32bRGFUV8hc=;
	b=rnOKo3UHvjlVtQW1jUjewjgHACoaJI/GRwBEJnIE4W9OAbiumwoS8nz7ciTqsrc8x6qhZN
	vLVEWX+RrsXMZEUc+0DM6FRkydxpa0EW0vM4F6UosW9j10M8A4GNrS7kUoFTiJft3J10Vt
	nfZiaPeH03HIPWtt7VbI5lXuzCyNtysaw3idb80KsRRqmxZCz4nO407foCGKATkoggbpRI
	lcBFwali2p/Y+xTMnt9HP0YPT67OVRxZuhGJShaczY3009V2eh5RBbO72dSpp8L0q0DcvE
	8grd4s890pxZu1N28TRcrsGm1Oa9wcz81+SrNwKn+ANPBRelvistBmiCwnUVKg==
Date: Wed, 14 Aug 2024 14:25:48 +0200
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH] cmd_set_passphrase: initialize KDF parameters
To: Hongbo Li <lihongbo22@huawei.com>, Mae Kasza <git@badat.dev>,
 Kent Overstreet <kent.overstreet@linux.dev>
Cc: linux-bcachefs@vger.kernel.org
References: <20240811214152.86593-2-git@badat.dev>
 <20240811214152.86593-3-git@badat.dev>
 <el5uhxcjrvo5pusy2yuptyxx3olzwaipzrdcqgcyoq65hpthhd@c2gegzjmqcmx>
 <9aca486e-ed70-4826-9cae-024fb64b12a8@huawei.com>
 <5252a768-7abe-4af1-8d78-9cbfbd1c9186@badat.dev>
 <68c4ce8a-c904-4d71-9a8b-480e8d37a0e3@huawei.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Mae Kasza <admin@badat.dev>
In-Reply-To: <68c4ce8a-c904-4d71-9a8b-480e8d37a0e3@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT


On 8/14/24 04:10, Hongbo Li wrote:
>
>
> On 2024/8/13 21:16, Mae Kasza wrote:
>>
>> On 8/12/24 04:50, Hongbo Li wrote:
>>>
>>>
>>> On 2024/8/12 9:41, Kent Overstreet wrote:
>>>> On Sun, Aug 11, 2024 at 11:40:38PM GMT, Mae Kasza wrote:
>>>>> From: mae <git@badat.dev>
>>>>>
>>>>> The set-passphrase command failed to derive the key for disks 
>>>>> initially
>>>>> formatted with --encrypted and --no_passphrase.
>>>>>
>>>>> This happened because bch_sb_crypt_init only configures the KDF 
>>>>> params
>>>>> if a passphrase is specified.
>>>>> This commit makes the command initialize the KDF with the same 
>>>>> parameters
>>>>> as bch_sb_crypt_init if the key wasn't encrypted before.
>>>>>
>>>>> Signed-off-by: Mae Kasza <git@badat.dev>
>>>>
>>>> This looks good to me, but I'm in the middle of a 20 hour drive and 
>>>> not
>>>> feeling super confident to review crypto stuff tonight, so maybe 
>>>> someone
>>>> else can go over it too before I pull it in..
>>>>
>>>>> ---
>>>>>   c_src/cmd_key.c |  9 +++++++--
>>>>>   c_src/crypto.c  | 13 ++++++++-----
>>>>>   c_src/crypto.h  |  1 +
>>>>>   3 files changed, 16 insertions(+), 7 deletions(-)
>>>>>
>>>>> diff --git a/c_src/cmd_key.c b/c_src/cmd_key.c
>>>>> index adb0ac8d..2da83758 100644
>>>>> --- a/c_src/cmd_key.c
>>>>> +++ b/c_src/cmd_key.c
>>>>> @@ -104,7 +104,8 @@ int cmd_set_passphrase(int argc, char *argv[])
>>>>>       if (IS_ERR(c))
>>>>>           die("Error opening %s: %s", argv[1], 
>>>>> bch2_err_str(PTR_ERR(c)));
>>>>>   -    struct bch_sb_field_crypt *crypt = 
>>>>> bch2_sb_field_get(c->disk_sb.sb, crypt);
>>>>> +    struct bch_sb *sb = c->disk_sb.sb;
>>>>> +    struct bch_sb_field_crypt *crypt = bch2_sb_field_get(sb, crypt);
>>>>>       if (!crypt)
>>>>>           die("Filesystem does not have encryption enabled");
>>>>>   @@ -116,9 +117,13 @@ int cmd_set_passphrase(int argc, char *argv[])
>>>>>           die("Error getting current key");
>>>>>         char *new_passphrase = read_passphrase_twice("Enter new 
>>>>> passphrase: ");
>>>>> +    if (!bch2_key_is_encrypted(&crypt->key)) {
>>>>> +        bch_crypt_default_kdf_init(crypt);
>>> It works, but using bch_sb_crypt_init to reinitialize crypt may be 
>>> better. In bch_sb_crypt_init, it has initialized the crypt and also 
>>> cleaned new_passphrase.
>>>
>>> Thanks
>>> Hongbo
>>>
>> bch_sb_crypt_init also reinitializes the crypt->key, so I can't just 
>> reuse it here.
>>
> Yeah, it will change crypt->key. It seems the main point is not clean 
> the password.
> Do we need keep the crypt->key even the password is changed? Or does 
> the crypt->key like a random seed and need to be kept in the whole 
> lifecycle? Sorry I am a bit confused about this.
>
> Thanks,
> Hongbo

crypt->key does need to stay constant for the entire lifetime of a 
partition, since that's what's actually used to encrypt the data on the 
partition. The passphrase is just used to encrypt the crypt->key

Thanks,

Mae

>
>> I could extract it into a bch_crypt_update_passphrase function. 
>> Originally I wanted to avoid doing that to limit the scope of this 
>> patchset, but I'll give it a shot
>>
>> Thanks for the review!
>>
>> Mae
>>
>>>>> +    }
>>>>> +
>>>>>       struct bch_key passphrase_key = derive_passphrase(crypt, 
>>>>> new_passphrase);
>>>>>   -    if (bch2_chacha_encrypt_key(&passphrase_key, 
>>>>> __bch2_sb_key_nonce(c->disk_sb.sb),
>>>>> +    if (bch2_chacha_encrypt_key(&passphrase_key, 
>>>>> __bch2_sb_key_nonce(sb),
>>>>>                       &new_key, sizeof(new_key)))
>>>>>           die("error encrypting key");
>>>>>       crypt->key = new_key;
>>>>> diff --git a/c_src/crypto.c b/c_src/crypto.c
>>>>> index 32671bd8..30ad92d4 100644
>>>>> --- a/c_src/crypto.c
>>>>> +++ b/c_src/crypto.c
>>>>> @@ -180,11 +180,7 @@ void bch_sb_crypt_init(struct bch_sb *sb,
>>>>>       get_random_bytes(&crypt->key.key, sizeof(crypt->key.key));
>>>>>         if (passphrase) {
>>>>> -
>>>>> -        SET_BCH_CRYPT_KDF_TYPE(crypt, BCH_KDF_SCRYPT);
>>>>> -        SET_BCH_KDF_SCRYPT_N(crypt, ilog2(16384));
>>>>> -        SET_BCH_KDF_SCRYPT_R(crypt, ilog2(8));
>>>>> -        SET_BCH_KDF_SCRYPT_P(crypt, ilog2(16));
>>>>> +        bch_crypt_default_kdf_init(crypt);
>>>>>             struct bch_key passphrase_key = 
>>>>> derive_passphrase(crypt, passphrase);
>>>>>   @@ -199,3 +195,10 @@ void bch_sb_crypt_init(struct bch_sb *sb,
>>>>>           memzero_explicit(&passphrase_key, sizeof(passphrase_key));
>>>>>       }
>>>>>   }
>>>>> +
>>>>> +void bch_crypt_default_kdf_init(struct bch_sb_field_crypt *crypt) {
>>>>> +        SET_BCH_CRYPT_KDF_TYPE(crypt, BCH_KDF_SCRYPT);
>>>>> +        SET_BCH_KDF_SCRYPT_N(crypt, ilog2(16384));
>>>>> +        SET_BCH_KDF_SCRYPT_R(crypt, ilog2(8));
>>>>> +        SET_BCH_KDF_SCRYPT_P(crypt, ilog2(16));
>>>>> +}
>>>>> diff --git a/c_src/crypto.h b/c_src/crypto.h
>>>>> index baea6d86..846a8931 100644
>>>>> --- a/c_src/crypto.h
>>>>> +++ b/c_src/crypto.h
>>>>> @@ -18,5 +18,6 @@ void bch2_passphrase_check(struct bch_sb *, 
>>>>> const char *,
>>>>>   void bch2_add_key(struct bch_sb *, const char *, const char *, 
>>>>> const char *);
>>>>>   void bch_sb_crypt_init(struct bch_sb *sb, struct 
>>>>> bch_sb_field_crypt *,
>>>>>                  const char *);
>>>>> +void bch_crypt_default_kdf_init(struct bch_sb_field_crypt *);
>>>>>     #endif /* _CRYPTO_H */
>>>>> -- 
>>>>> 2.45.2
>>>>>
>>>>
>>>>
>>>

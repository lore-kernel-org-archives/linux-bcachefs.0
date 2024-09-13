Received: from out-175.mta0.migadu.com (out-175.mta0.migadu.com [91.218.175.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65B5F155A34
	for <linux-bcachefs@vger.kernel.org>; Fri, 13 Sep 2024 21:39:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726263597; cv=none; b=PXWKIJD+dQD5u21C/qOc9/+Bd/zU2oi64syqxM8mU1HJ71Xk4iooObZ3fNWnQUZPz3IIMAFENAt2dZC2lp5PaCj+RM4fLEovbmaurD9GuuYTDzGcgSpDZAqW6XY3tdCjHQVScDmGU8STDIq2vuk0uuL+w/dQP51G6Yf6I42MN0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726263597; c=relaxed/simple;
	bh=p5Y1GNMEqpIh+SzjXZmSX/U//7TwhuSLPRQxuJ3A3ds=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=poNWTfJogQJlThkiiKAILOM7k8cUjzt2wNttAKU658aKNmjZaIqG5AF8VhhrR4Rx0kIlkNhK2CzwBeITSMBfGsZS0aQqaS4sXj3PyVqRAwhJSVy9QYM7tYReQeVccH60CnEZBBkEU3kJBC1FsB4aXlnIEitb8Xm/PNfAIWv2zlo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=badat.dev; spf=pass smtp.mailfrom=badat.dev; dkim=pass (2048-bit key) header.d=badat.dev header.i=@badat.dev header.b=W8MRvb8/; arc=none smtp.client-ip=91.218.175.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=badat.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=badat.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=badat.dev header.i=@badat.dev header.b="W8MRvb8/"
Message-ID: <cfd27003-7d88-447f-a4b0-c353444e03e4@badat.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=badat.dev; s=key1;
	t=1726263588;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uP+2XRMjzLRUoKLU23HYOlVQBJlL6Fh+7OmFP33zKd4=;
	b=W8MRvb8/yx3hhET+Vbhh1fwc3LC1+9y98/+AUVxxUWloZHFo0F8s1Xtz9/Rxb43yhPngoF
	J6FPNSa1m+b327adAzNcHj85WukfyhMbeyrQfQrxqMxE5seTC5n9T3a0lJkAy5CFyDiVPc
	ODRRcO5FW8yZzZxgDEphgu0FkGZhy3153U8zYd+Ajl4pxyU/BoSn5Y0vMEWPk4hrc4nL7V
	hc0Z/1F6yfLg90wxnIXH1Wph5A94Hjfg96eo5M6yS3H0jyo3NrZEFwY2IJ4FVD2ccFANms
	J/ctM2n3dHKfWV9TuImrEaYiudjqlrCy6wW251sVCsBGO0nO08y3rBA4ne3zbg==
Date: Fri, 13 Sep 2024 23:39:41 +0200
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH] cmd_set_passphrase: initialize KDF parameters
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Mae Kasza <git@badat.dev>
To: Hongbo Li <lihongbo22@huawei.com>, Mae Kasza <git@badat.dev>,
 Kent Overstreet <kent.overstreet@linux.dev>
Cc: linux-bcachefs@vger.kernel.org
References: <20240811214152.86593-2-git@badat.dev>
 <20240811214152.86593-3-git@badat.dev>
 <el5uhxcjrvo5pusy2yuptyxx3olzwaipzrdcqgcyoq65hpthhd@c2gegzjmqcmx>
 <9aca486e-ed70-4826-9cae-024fb64b12a8@huawei.com>
 <5252a768-7abe-4af1-8d78-9cbfbd1c9186@badat.dev>
 <68c4ce8a-c904-4d71-9a8b-480e8d37a0e3@huawei.com>
 <b31673a7-dddd-45c5-9e55-798a2ff65407@badat.dev>
Content-Language: en-US
In-Reply-To: <b31673a7-dddd-45c5-9e55-798a2ff65407@badat.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Hi,

Appologies if this is bad etiquette, but I haven't gotten any review 
feedback and it seems like fixing this is relatively important to 
users(https://github.com/koverstreet/bcachefs-tools/pull/329#issuecomment-2336787443). 
Any chance someone(Kent) could look at this and merge the patch?

Thanks,

Mae

On 8/14/24 14:25, Mae Kasza wrote:
>
> On 8/14/24 04:10, Hongbo Li wrote:
>>
>>
>> On 2024/8/13 21:16, Mae Kasza wrote:
>>>
>>> On 8/12/24 04:50, Hongbo Li wrote:
>>>>
>>>>
>>>> On 2024/8/12 9:41, Kent Overstreet wrote:
>>>>> On Sun, Aug 11, 2024 at 11:40:38PM GMT, Mae Kasza wrote:
>>>>>> From: mae <git@badat.dev>
>>>>>>
>>>>>> The set-passphrase command failed to derive the key for disks 
>>>>>> initially
>>>>>> formatted with --encrypted and --no_passphrase.
>>>>>>
>>>>>> This happened because bch_sb_crypt_init only configures the KDF 
>>>>>> params
>>>>>> if a passphrase is specified.
>>>>>> This commit makes the command initialize the KDF with the same 
>>>>>> parameters
>>>>>> as bch_sb_crypt_init if the key wasn't encrypted before.
>>>>>>
>>>>>> Signed-off-by: Mae Kasza <git@badat.dev>
>>>>>
>>>>> This looks good to me, but I'm in the middle of a 20 hour drive 
>>>>> and not
>>>>> feeling super confident to review crypto stuff tonight, so maybe 
>>>>> someone
>>>>> else can go over it too before I pull it in..
>>>>>
>>>>>> ---
>>>>>>   c_src/cmd_key.c |  9 +++++++--
>>>>>>   c_src/crypto.c  | 13 ++++++++-----
>>>>>>   c_src/crypto.h  |  1 +
>>>>>>   3 files changed, 16 insertions(+), 7 deletions(-)
>>>>>>
>>>>>> diff --git a/c_src/cmd_key.c b/c_src/cmd_key.c
>>>>>> index adb0ac8d..2da83758 100644
>>>>>> --- a/c_src/cmd_key.c
>>>>>> +++ b/c_src/cmd_key.c
>>>>>> @@ -104,7 +104,8 @@ int cmd_set_passphrase(int argc, char *argv[])
>>>>>>       if (IS_ERR(c))
>>>>>>           die("Error opening %s: %s", argv[1], 
>>>>>> bch2_err_str(PTR_ERR(c)));
>>>>>>   -    struct bch_sb_field_crypt *crypt = 
>>>>>> bch2_sb_field_get(c->disk_sb.sb, crypt);
>>>>>> +    struct bch_sb *sb = c->disk_sb.sb;
>>>>>> +    struct bch_sb_field_crypt *crypt = bch2_sb_field_get(sb, 
>>>>>> crypt);
>>>>>>       if (!crypt)
>>>>>>           die("Filesystem does not have encryption enabled");
>>>>>>   @@ -116,9 +117,13 @@ int cmd_set_passphrase(int argc, char 
>>>>>> *argv[])
>>>>>>           die("Error getting current key");
>>>>>>         char *new_passphrase = read_passphrase_twice("Enter new 
>>>>>> passphrase: ");
>>>>>> +    if (!bch2_key_is_encrypted(&crypt->key)) {
>>>>>> +        bch_crypt_default_kdf_init(crypt);
>>>> It works, but using bch_sb_crypt_init to reinitialize crypt may be 
>>>> better. In bch_sb_crypt_init, it has initialized the crypt and also 
>>>> cleaned new_passphrase.
>>>>
>>>> Thanks
>>>> Hongbo
>>>>
>>> bch_sb_crypt_init also reinitializes the crypt->key, so I can't just 
>>> reuse it here.
>>>
>> Yeah, it will change crypt->key. It seems the main point is not clean 
>> the password.
>> Do we need keep the crypt->key even the password is changed? Or does 
>> the crypt->key like a random seed and need to be kept in the whole 
>> lifecycle? Sorry I am a bit confused about this.
>>
>> Thanks,
>> Hongbo
>
> crypt->key does need to stay constant for the entire lifetime of a 
> partition, since that's what's actually used to encrypt the data on 
> the partition. The passphrase is just used to encrypt the crypt->key
>
> Thanks,
>
> Mae
>
>>
>>> I could extract it into a bch_crypt_update_passphrase function. 
>>> Originally I wanted to avoid doing that to limit the scope of this 
>>> patchset, but I'll give it a shot
>>>
>>> Thanks for the review!
>>>
>>> Mae
>>>
>>>>>> +    }
>>>>>> +
>>>>>>       struct bch_key passphrase_key = derive_passphrase(crypt, 
>>>>>> new_passphrase);
>>>>>>   -    if (bch2_chacha_encrypt_key(&passphrase_key, 
>>>>>> __bch2_sb_key_nonce(c->disk_sb.sb),
>>>>>> +    if (bch2_chacha_encrypt_key(&passphrase_key, 
>>>>>> __bch2_sb_key_nonce(sb),
>>>>>>                       &new_key, sizeof(new_key)))
>>>>>>           die("error encrypting key");
>>>>>>       crypt->key = new_key;
>>>>>> diff --git a/c_src/crypto.c b/c_src/crypto.c
>>>>>> index 32671bd8..30ad92d4 100644
>>>>>> --- a/c_src/crypto.c
>>>>>> +++ b/c_src/crypto.c
>>>>>> @@ -180,11 +180,7 @@ void bch_sb_crypt_init(struct bch_sb *sb,
>>>>>>       get_random_bytes(&crypt->key.key, sizeof(crypt->key.key));
>>>>>>         if (passphrase) {
>>>>>> -
>>>>>> -        SET_BCH_CRYPT_KDF_TYPE(crypt, BCH_KDF_SCRYPT);
>>>>>> -        SET_BCH_KDF_SCRYPT_N(crypt, ilog2(16384));
>>>>>> -        SET_BCH_KDF_SCRYPT_R(crypt, ilog2(8));
>>>>>> -        SET_BCH_KDF_SCRYPT_P(crypt, ilog2(16));
>>>>>> +        bch_crypt_default_kdf_init(crypt);
>>>>>>             struct bch_key passphrase_key = 
>>>>>> derive_passphrase(crypt, passphrase);
>>>>>>   @@ -199,3 +195,10 @@ void bch_sb_crypt_init(struct bch_sb *sb,
>>>>>>           memzero_explicit(&passphrase_key, sizeof(passphrase_key));
>>>>>>       }
>>>>>>   }
>>>>>> +
>>>>>> +void bch_crypt_default_kdf_init(struct bch_sb_field_crypt *crypt) {
>>>>>> +        SET_BCH_CRYPT_KDF_TYPE(crypt, BCH_KDF_SCRYPT);
>>>>>> +        SET_BCH_KDF_SCRYPT_N(crypt, ilog2(16384));
>>>>>> +        SET_BCH_KDF_SCRYPT_R(crypt, ilog2(8));
>>>>>> +        SET_BCH_KDF_SCRYPT_P(crypt, ilog2(16));
>>>>>> +}
>>>>>> diff --git a/c_src/crypto.h b/c_src/crypto.h
>>>>>> index baea6d86..846a8931 100644
>>>>>> --- a/c_src/crypto.h
>>>>>> +++ b/c_src/crypto.h
>>>>>> @@ -18,5 +18,6 @@ void bch2_passphrase_check(struct bch_sb *, 
>>>>>> const char *,
>>>>>>   void bch2_add_key(struct bch_sb *, const char *, const char *, 
>>>>>> const char *);
>>>>>>   void bch_sb_crypt_init(struct bch_sb *sb, struct 
>>>>>> bch_sb_field_crypt *,
>>>>>>                  const char *);
>>>>>> +void bch_crypt_default_kdf_init(struct bch_sb_field_crypt *);
>>>>>>     #endif /* _CRYPTO_H */
>>>>>> -- 
>>>>>> 2.45.2
>>>>>>
>>>>>
>>>>>
>>>>

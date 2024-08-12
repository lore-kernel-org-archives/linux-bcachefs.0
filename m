Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFCB8136E37
	for <linux-bcachefs@vger.kernel.org>; Mon, 12 Aug 2024 02:50:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.190
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723431046; cv=none; b=qTB1hXcn3/1+P/+dP0+/f2EMLbQXTE24ISjCQUieVcGOiXxJou5DET+5wtCIGg+H9TdphEJrYYPBrefM/WOtrNfa0jcL7x+QGVFf0WY9N6r0UK8WiieZv0dBH43M6jfJvw8W0Oj/3RjJuZtUj01J/I/CalLX2agT7dZKwIdd1xo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723431046; c=relaxed/simple;
	bh=YjgeupSPkSz8gLDo27XJq0fIEzNRhhTq+toaZOqEtbg=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=CdwCt2Ih3TaBs2v9qbdKZNzTKOFjXgORf5IzI75rmBvh9stcPSMYzkvgtj8F7yToVaR/MD966ThiclA2SyMSSpYypwJ2reK6WlUaGcrKoIojNblPXUw1uWDPYLQQ1pSVMlFRpkTZk4zOnGzQ31WBsU7hy8gU5gr2BxgWucVLbbs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.190
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.214])
	by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4WhzRN4T6Jz20lRd;
	Mon, 12 Aug 2024 10:46:08 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (unknown [7.185.36.66])
	by mail.maildlp.com (Postfix) with ESMTPS id 0C7F11A016C;
	Mon, 12 Aug 2024 10:50:40 +0800 (CST)
Received: from [10.67.111.104] (10.67.111.104) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 12 Aug 2024 10:50:39 +0800
Message-ID: <9aca486e-ed70-4826-9cae-024fb64b12a8@huawei.com>
Date: Mon, 12 Aug 2024 10:50:39 +0800
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] cmd_set_passphrase: initialize KDF parameters
Content-Language: en-US
To: Kent Overstreet <kent.overstreet@linux.dev>, Mae Kasza <git@badat.dev>
CC: <linux-bcachefs@vger.kernel.org>
References: <20240811214152.86593-2-git@badat.dev>
 <20240811214152.86593-3-git@badat.dev>
 <el5uhxcjrvo5pusy2yuptyxx3olzwaipzrdcqgcyoq65hpthhd@c2gegzjmqcmx>
From: Hongbo Li <lihongbo22@huawei.com>
In-Reply-To: <el5uhxcjrvo5pusy2yuptyxx3olzwaipzrdcqgcyoq65hpthhd@c2gegzjmqcmx>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpeml500022.china.huawei.com (7.185.36.66)



On 2024/8/12 9:41, Kent Overstreet wrote:
> On Sun, Aug 11, 2024 at 11:40:38PM GMT, Mae Kasza wrote:
>> From: mae <git@badat.dev>
>>
>> The set-passphrase command failed to derive the key for disks initially
>> formatted with --encrypted and --no_passphrase.
>>
>> This happened because bch_sb_crypt_init only configures the KDF params
>> if a passphrase is specified.
>> This commit makes the command initialize the KDF with the same parameters
>> as bch_sb_crypt_init if the key wasn't encrypted before.
>>
>> Signed-off-by: Mae Kasza <git@badat.dev>
> 
> This looks good to me, but I'm in the middle of a 20 hour drive and not
> feeling super confident to review crypto stuff tonight, so maybe someone
> else can go over it too before I pull it in..
> 
>> ---
>>   c_src/cmd_key.c |  9 +++++++--
>>   c_src/crypto.c  | 13 ++++++++-----
>>   c_src/crypto.h  |  1 +
>>   3 files changed, 16 insertions(+), 7 deletions(-)
>>
>> diff --git a/c_src/cmd_key.c b/c_src/cmd_key.c
>> index adb0ac8d..2da83758 100644
>> --- a/c_src/cmd_key.c
>> +++ b/c_src/cmd_key.c
>> @@ -104,7 +104,8 @@ int cmd_set_passphrase(int argc, char *argv[])
>>   	if (IS_ERR(c))
>>   		die("Error opening %s: %s", argv[1], bch2_err_str(PTR_ERR(c)));
>>   
>> -	struct bch_sb_field_crypt *crypt = bch2_sb_field_get(c->disk_sb.sb, crypt);
>> +	struct bch_sb *sb = c->disk_sb.sb;
>> +	struct bch_sb_field_crypt *crypt = bch2_sb_field_get(sb, crypt);
>>   	if (!crypt)
>>   		die("Filesystem does not have encryption enabled");
>>   
>> @@ -116,9 +117,13 @@ int cmd_set_passphrase(int argc, char *argv[])
>>   		die("Error getting current key");
>>   
>>   	char *new_passphrase = read_passphrase_twice("Enter new passphrase: ");
>> +	if (!bch2_key_is_encrypted(&crypt->key)) {
>> +		bch_crypt_default_kdf_init(crypt);
It works, but using bch_sb_crypt_init to reinitialize crypt may be 
better. In bch_sb_crypt_init, it has initialized the crypt and also 
cleaned new_passphrase.

Thanks
Hongbo

>> +	}
>> +
>>   	struct bch_key passphrase_key = derive_passphrase(crypt, new_passphrase);
>>   
>> -	if (bch2_chacha_encrypt_key(&passphrase_key, __bch2_sb_key_nonce(c->disk_sb.sb),
>> +	if (bch2_chacha_encrypt_key(&passphrase_key, __bch2_sb_key_nonce(sb),
>>   				    &new_key, sizeof(new_key)))
>>   		die("error encrypting key");
>>   	crypt->key = new_key;
>> diff --git a/c_src/crypto.c b/c_src/crypto.c
>> index 32671bd8..30ad92d4 100644
>> --- a/c_src/crypto.c
>> +++ b/c_src/crypto.c
>> @@ -180,11 +180,7 @@ void bch_sb_crypt_init(struct bch_sb *sb,
>>   	get_random_bytes(&crypt->key.key, sizeof(crypt->key.key));
>>   
>>   	if (passphrase) {
>> -
>> -		SET_BCH_CRYPT_KDF_TYPE(crypt, BCH_KDF_SCRYPT);
>> -		SET_BCH_KDF_SCRYPT_N(crypt, ilog2(16384));
>> -		SET_BCH_KDF_SCRYPT_R(crypt, ilog2(8));
>> -		SET_BCH_KDF_SCRYPT_P(crypt, ilog2(16));
>> +		bch_crypt_default_kdf_init(crypt);
>>   
>>   		struct bch_key passphrase_key = derive_passphrase(crypt, passphrase);
>>   
>> @@ -199,3 +195,10 @@ void bch_sb_crypt_init(struct bch_sb *sb,
>>   		memzero_explicit(&passphrase_key, sizeof(passphrase_key));
>>   	}
>>   }
>> +
>> +void bch_crypt_default_kdf_init(struct bch_sb_field_crypt *crypt) {
>> +		SET_BCH_CRYPT_KDF_TYPE(crypt, BCH_KDF_SCRYPT);
>> +		SET_BCH_KDF_SCRYPT_N(crypt, ilog2(16384));
>> +		SET_BCH_KDF_SCRYPT_R(crypt, ilog2(8));
>> +		SET_BCH_KDF_SCRYPT_P(crypt, ilog2(16));
>> +}
>> diff --git a/c_src/crypto.h b/c_src/crypto.h
>> index baea6d86..846a8931 100644
>> --- a/c_src/crypto.h
>> +++ b/c_src/crypto.h
>> @@ -18,5 +18,6 @@ void bch2_passphrase_check(struct bch_sb *, const char *,
>>   void bch2_add_key(struct bch_sb *, const char *, const char *, const char *);
>>   void bch_sb_crypt_init(struct bch_sb *sb, struct bch_sb_field_crypt *,
>>   		       const char *);
>> +void bch_crypt_default_kdf_init(struct bch_sb_field_crypt *);
>>   
>>   #endif /* _CRYPTO_H */
>> -- 
>> 2.45.2
>>
> 
> 

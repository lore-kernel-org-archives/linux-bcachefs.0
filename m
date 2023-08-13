Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17CA5C001DB
	for <linux-bcachefs@archiver.kernel.org>; Sun, 13 Aug 2023 19:20:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230222AbjHMTUj (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Sun, 13 Aug 2023 15:20:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229646AbjHMTUj (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Sun, 13 Aug 2023 15:20:39 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8A0118E
        for <linux-bcachefs@vger.kernel.org>; Sun, 13 Aug 2023 12:20:40 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id 5b1f17b1804b1-3fbea14706eso32968585e9.2
        for <linux-bcachefs@vger.kernel.org>; Sun, 13 Aug 2023 12:20:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=froggi.es; s=google; t=1691954439; x=1692559239;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=fEHP+Aw3Vz0/gmkYNYBj5VLN7Q7vj6aNYrZOTNKj27Q=;
        b=J1EtS/ixtmfkxwxEvMmwCOzTakW4F3rmM7UMLQipcu6+cDko9+sVZVEq3gGQ8JZ483
         rrRlnpqPTg3dzuhXTj+1oHcBtyN3hWM2okEWI37zS1qBy1AjVkRzMdLUgorN41PKSMuw
         5JWWI1ikI9XfjMtzQbv5Jf689oeJuRlNmivDWB+WPGteChdvfbbjH1Sa90E+/dNFr5kC
         Qj1rVLv0zw8kielwq3i/SffoKdkKYp4BGAhwPBgn6lB6HQI1ahetG+h/6CWCb2ycGYv6
         nAld1+CLL9oe+kqH1RyFhiQbft+eFm5XhFHnMt7XHDIYFinVrw5bSrs0xU6PhCBbwxVY
         0kFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691954439; x=1692559239;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fEHP+Aw3Vz0/gmkYNYBj5VLN7Q7vj6aNYrZOTNKj27Q=;
        b=aVJ40TYuRA4CJL0rxnyEjQtSW9hB2FRsU3gDraI5FOenX8sRrGBy0sCQM4z1h3Z97k
         S5W9/o7AAs9xNTZyrpeli31H6w9pMk3BpTHCqrmGlZIENznvuNPjqUQAH6VKs7wvhYfz
         6osuJCX+RQCWKj2CLe89HC3fDCZHJAC+MVKPF6pgWrm+gneOG6TqrcGOUsGQg0SR+fLA
         kXkJAzFu1GI5yxuop4dnCMQf0I7gCJRDeupjjA7h5ZMEIqrUTExzmBqgN2UwMEhjLTSZ
         79JDgIA5VOtP0Gt5wNvW8MY9ZfRa2qdfFaw3HSiqFD3awtNeVsbJTluE9yLwO0RA3kNK
         qbPw==
X-Gm-Message-State: AOJu0Yx4iInn02VTZpIEX2Z1hDELlwx+155C9L5Y9uj3bOPRnXlBQKEd
        lHuJPq+nTPt94jHZ0105yAFNkmeNHtcVBzKbBdM=
X-Google-Smtp-Source: AGHT+IFdkW6WtZYgiwUYIz3/B8IfQPOSIMEmDHTpdU1Uwqd/kBZzkPn3NIQZYebvKPLBv44WQBCT5Q==
X-Received: by 2002:a1c:ed17:0:b0:3fd:2dcc:bc19 with SMTP id l23-20020a1ced17000000b003fd2dccbc19mr5918657wmh.15.1691954438706;
        Sun, 13 Aug 2023 12:20:38 -0700 (PDT)
Received: from [192.168.0.89] (darl-09-b2-v4wan-165404-cust288.vm5.cable.virginm.net. [86.17.61.33])
        by smtp.gmail.com with ESMTPSA id k1-20020a05600c0b4100b003fbb5506e54sm12068217wmr.29.2023.08.13.12.20.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 13 Aug 2023 12:20:38 -0700 (PDT)
Message-ID: <5a138da7-869a-4cb4-a274-dbf4b36bc72f@froggi.es>
Date:   Sun, 13 Aug 2023 20:20:37 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [v3 3/3] bcachefs: Implement casefolding
Content-Language: en-US
To:     Kent Overstreet <kent.overstreet@linux.dev>
Cc:     linux-bcachefs@vger.kernel.org,
        =?UTF-8?Q?Andr=C3=A9_Almeida?= <andrealmeid@igalia.com>,
        Gabriel Krisman Bertazi <krisman@suse.de>
References: <20230813173835.195840-1-joshua@froggi.es>
 <20230813173835.195840-4-joshua@froggi.es>
 <20230813181845.ukbrchtfjck3qdcw@moria.home.lan>
From:   Joshua Ashton <joshua@froggi.es>
In-Reply-To: <20230813181845.ukbrchtfjck3qdcw@moria.home.lan>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org



On 8/13/23 19:18, Kent Overstreet wrote:
> On Sun, Aug 13, 2023 at 06:38:27PM +0100, Joshua Ashton wrote:
>>   struct qstr bch2_dirent_get_name(struct bkey_s_c_dirent d)
>>   {
>> -	return (struct qstr) QSTR_INIT(d.v->d_name, bch2_dirent_name_bytes(d));
>> +	unsigned block_len = bch2_dirent_name_bytes(d);
>> +	if (d.v->d_casefold) {
>> +		unsigned name_len = min_t(unsigned, le16_to_cpu(d.v->d_cf_name_block.d_name_len), block_len);
> 
> You need to be validating d_name_len and d_cf_name_len - that they don't
> overrun the end of the bkey - in bch2_dirent_invalid(), then you won't
> need this min_t here

Makes sense, will do.

> 
>> +		return (struct qstr) QSTR_INIT(&d.v->d_cf_name_block.d_names[0], name_len);
>> +	} else {
>> +		unsigned name_len = block_len;
>> +		return (struct qstr) QSTR_INIT(d.v->d_name, name_len);
>> +	}
>> +}
>> +
>> +struct qstr bch2_dirent_get_casefold_name(struct bkey_s_c_dirent d)
>> +{
>> +	unsigned block_len = bch2_dirent_name_bytes(d);
>> +	if (d.v->d_casefold) {
>> +		unsigned name_len = min_t(unsigned, le16_to_cpu(d.v->d_cf_name_block.d_name_len), block_len);
>> +		unsigned cf_name_len = min_t(unsigned, le16_to_cpu(d.v->d_cf_name_block.d_cf_name_len), block_len - name_len);
> 
> Ditto
> 
>> @@ -157,6 +190,24 @@ int bch2_dirent_invalid(const struct bch_fs *c, struct bkey_s_c k,
>>   		return -BCH_ERR_invalid_bkey;
>>   	}
>>   
>> +	if (d.v->d_casefold) {
>> +#if !IS_ENABLED(CONFIG_UNICODE)
>> +		prt_printf(err, "dirent bkey with casefolding without CONFIG_UNICODE");
>> +		return -BCH_ERR_invalid_bkey;
>> +#endif
> 
> This is wrong - failing the .key_invalid() check means the key is
> _deleted_, we don't want that to happen just because a kernel config
> option was flipped.

We should never ever be in this situation to begin with -- that means a 
casefolded dir exists on a filesystem without the feature flag.

What would be a better alternative? A BUG_ON? Nothing?

> 
>> @@ -241,10 +320,19 @@ int bch2_dirent_create(struct btree_trans *trans, subvol_inum dir,
>>   		       u8 type, const struct qstr *name, u64 dst_inum,
>>   		       u64 *dir_offset, int flags)
>>   {
>> +	char cf_name_buf[BCH_NAME_MAX + 1];
> 
> No, as discussed 512 bytes is too much to stack allocate. And we don't
> need a separate buffer here, move the bch2_casefold() call into
> dirent_create_key, create it directly in place.
> 
> Big unnecessary stack allocations is a major no-no in the kernel, unless
> you've _really_ done the analysis and know that it's OK, and usually
> it's not. When we call into the btree code that can initiate IO
> directly, or we can end up invoking memory reclaim and _that_ can
> initiate IO, and btree_trans and our btree_iters have already consumed
> as much stack as we're allowed to in our code.

Makes sense, sorry about that. I forgot about it since I slept between 
that conversation. :-)

I do not think putting it in dirent_create_key is the right place -- 
that would mean we end up doing the casefolding operation multiple times 
in bch2_dirent_rename which seems bad.

We also need to know the length of the casefolded string before 
allocating it, so we cannot do it in-place either way...

Totally agree on the trans vs stack thing though.

> 
>> @@ -294,6 +382,10 @@ int bch2_dirent_rename(struct btree_trans *trans,
>>   		const struct qstr *dst_name, subvol_inum *dst_inum, u64 *dst_offset,
>>   		enum bch_rename_mode mode)
>>   {
>> +	char src_cf_name[BCH_NAME_MAX + 1];
>> +	char dst_cf_name[BCH_NAME_MAX + 1];
> 
> Use bch2_trans_kmalloc() for these.
> 
>> @@ -507,16 +611,24 @@ u64 bch2_dirent_lookup(struct bch_fs *c, subvol_inum dir,
>>   		       const struct bch_hash_info *hash_info,
>>   		       const struct qstr *name, subvol_inum *inum)
>>   {
>> +	char cf_name[BCH_NAME_MAX + 1];
> 
> Ditto, use bch2_trans_kmalloc().
> 
>> diff --git a/fs/bcachefs/fs-common.c b/fs/bcachefs/fs-common.c
>> index bb5305441f27..9649872797da 100644
>> --- a/fs/bcachefs/fs-common.c
>> +++ b/fs/bcachefs/fs-common.c
>> @@ -46,6 +46,10 @@ int bch2_create_trans(struct btree_trans *trans,
>>   	if (ret)
>>   		goto err;
>>   
>> +	/* Inherit casefold state from parent. */
>> +	if (dir_type == DT_DIR && (dir_u->bi_flags & BCH_INODE_CASEFOLDED))
>> +		new_inode->bi_flags |= BCH_INODE_CASEFOLDED;
> 
> if (S_ISDIR(mode))
> 	new_inode->bi_flags |= dir_u->bi_flags & BCH_INODE_CASEFOLDED;
> 
> How have you tested it so far?

For smoke-testing I have a script that builds with CONFIG_UNICODE=y and 
n and then I just have a qemu vm with a script to bcachefs format and 
mount some -o loop file. Test with a few things and edgecases to make 
sure stuff is working.

For more serious testing before sending to the ML, I have been running 
the kernel locally and copying a few Proton games + prefixes over, 
chattr'ing and testing actual games. So far I have had no issues.

Looking into your ktest and stuff to make sure we have coverage there 
too is on my radar also, but I have not done it yet.

- Joshie 🐸✨

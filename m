Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1FAD0EB64DD
	for <linux-bcachefs@archiver.kernel.org>; Sun, 13 Aug 2023 20:53:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229558AbjHMUxP (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Sun, 13 Aug 2023 16:53:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229522AbjHMUxP (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Sun, 13 Aug 2023 16:53:15 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F4CDE6D
        for <linux-bcachefs@vger.kernel.org>; Sun, 13 Aug 2023 13:53:17 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id 5b1f17b1804b1-3fe4cdb724cso34540845e9.1
        for <linux-bcachefs@vger.kernel.org>; Sun, 13 Aug 2023 13:53:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=froggi.es; s=google; t=1691959995; x=1692564795;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=zBAs9B94Zb8cqPxeYByoXvZNYhC4O8UXg6FuQB6Pr+k=;
        b=Cq3AahLwjuj6kA0s4Xht9LWte+BJn8NlffmRqxRRtP96PKAxum5bUmtYfOzLlN+iNa
         1slkJiQaBZyakuxZrzbcZk5VEPUJATg8yhbjacvJRNRpLAfpcbfQEGWRUDSI0EaDzGPi
         AayDsvcChMyZxqoNlsWWWt4GhhQm92o9ynP8Mf9OMRm5OEVuimtHM24Xr+Qj7Odz6fIZ
         lwBAtmFpSc+PA8ZpWrV8uLoAPFSox80CjE7eeYAgwWqN3v1j6GJD83N9O7MesSIiBkHe
         wF18XHLOLdsNPRupKVFkxWxTiloLuWMfLftAcWW9IlKu2ljIsuR4H2G0sRIFwkGBTvaM
         c5pQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691959995; x=1692564795;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zBAs9B94Zb8cqPxeYByoXvZNYhC4O8UXg6FuQB6Pr+k=;
        b=Spf0SvQMuH/RuJ5YUxn5BOjIOqjqcY+zycteBHIrEn1jMZalmeqJolPkuftRYNSQAQ
         ryDcFJzb7tn5jcPDFpACWFS9bDhtWG/egaYMMDAo6mlgFvGmO/UU7n7jeUGC9/jzbksR
         I7/BvJUOCqasevgtm+Rbg4ObjBO0SXybBsos4Go5i55MdBkWa+i/zz6NbL/INNPAsOZv
         vK6Fgc1pfd2Pl/iwF32uaI+9dl/mgzoHZ6gkh+Zu3RF6TznQM0TJfSLbfrmM6HHyqdco
         /7k2av/Ar991ZX7IV0N2aCTuf5LsKDgr1UXTuDp5K698R5+rCLRxQtsmJpTk61XcajQc
         a/1w==
X-Gm-Message-State: AOJu0Ywe3rzNha+qqKPqscFrASh0UVTkmnUxfFGxP/CchiYY54EKxnQe
        o2ufbUXiJhIigcU1adGungYKJA==
X-Google-Smtp-Source: AGHT+IF3C/wg+Ydgqc62jcN0SE4T++/lZiOzzqDS6THkXkkgdAfU73COjjm0VvL2s7w2ingn/7T5Hw==
X-Received: by 2002:a05:600c:3789:b0:3fe:1c11:7788 with SMTP id o9-20020a05600c378900b003fe1c117788mr6418132wmr.33.1691959994916;
        Sun, 13 Aug 2023 13:53:14 -0700 (PDT)
Received: from [192.168.0.89] (darl-09-b2-v4wan-165404-cust288.vm5.cable.virginm.net. [86.17.61.33])
        by smtp.gmail.com with ESMTPSA id k5-20020a7bc405000000b003fbdbd0a7desm15122331wmi.27.2023.08.13.13.53.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 13 Aug 2023 13:53:14 -0700 (PDT)
Message-ID: <6a1ad63e-05ea-4e97-abd6-e85569ef4eab@froggi.es>
Date:   Sun, 13 Aug 2023 21:53:14 +0100
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
 <5a138da7-869a-4cb4-a274-dbf4b36bc72f@froggi.es>
 <20230813204925.6b3aha24ky57sg5f@moria.home.lan>
From:   Joshua Ashton <joshua@froggi.es>
In-Reply-To: <20230813204925.6b3aha24ky57sg5f@moria.home.lan>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org



On 8/13/23 21:49, Kent Overstreet wrote:
> On Sun, Aug 13, 2023 at 08:20:37PM +0100, Joshua Ashton wrote:
>> On 8/13/23 19:18, Kent Overstreet wrote:
>>> This is wrong - failing the .key_invalid() check means the key is
>>> _deleted_, we don't want that to happen just because a kernel config
>>> option was flipped.
>>
>> We should never ever be in this situation to begin with -- that means a
>> casefolded dir exists on a filesystem without the feature flag.
>>
>> What would be a better alternative? A BUG_ON? Nothing?
> 
> Checking the feature bit directly would be better, but I would prefer to
> leave this entirely out of .key_invalid() and just add error paths in
> the appropriate places. .key_invalid methods preferably shouldn't be too
> complicated or depend on external state; they're more about catching
> corruption that would cause e.g. memory safety issues.

I will leave it out then.

> 
>>>> @@ -241,10 +320,19 @@ int bch2_dirent_create(struct btree_trans *trans, subvol_inum dir,
>>>>    		       u8 type, const struct qstr *name, u64 dst_inum,
>>>>    		       u64 *dir_offset, int flags)
>>>>    {
>>>> +	char cf_name_buf[BCH_NAME_MAX + 1];
>>>
>>> No, as discussed 512 bytes is too much to stack allocate. And we don't
>>> need a separate buffer here, move the bch2_casefold() call into
>>> dirent_create_key, create it directly in place.
>>>
>>> Big unnecessary stack allocations is a major no-no in the kernel, unless
>>> you've _really_ done the analysis and know that it's OK, and usually
>>> it's not. When we call into the btree code that can initiate IO
>>> directly, or we can end up invoking memory reclaim and _that_ can
>>> initiate IO, and btree_trans and our btree_iters have already consumed
>>> as much stack as we're allowed to in our code.
>>
>> Makes sense, sorry about that. I forgot about it since I slept between that
>> conversation. :-)
> 
> Always take notes - I often take notes by starting an empty commit and
> having the initial commit message be the todo list.
> 
>> I do not think putting it in dirent_create_key is the right place -- that
>> would mean we end up doing the casefolding operation multiple times in
>> bch2_dirent_rename which seems bad.
> 
> You mean on transaction restart? That's no big deal, transaction
> restarts are rare. Or?

No, I mean in every case on rename, because rename does hash lookups 
based on an input name and then dirent_creates with the names.

Having it passed in to dirent_create_key means we can avoid doing it twice.
(note that bch2_dirent_create, the function exposed in the header, does 
perform casefolding and passes it to dirent_create_key)

- Joshie 🐸✨

> 
>> We also need to know the length of the casefolded string before allocating
>> it, so we cannot do it in-place either way...
> 
> Ah, true.
> 
>> For smoke-testing I have a script that builds with CONFIG_UNICODE=y and n
>> and then I just have a qemu vm with a script to bcachefs format and mount
>> some -o loop file. Test with a few things and edgecases to make sure stuff
>> is working.
>>
>> For more serious testing before sending to the ML, I have been running the
>> kernel locally and copying a few Proton games + prefixes over, chattr'ing
>> and testing actual games. So far I have had no issues.
> 
> Ok, that's a good start.
> 
>> Looking into your ktest and stuff to make sure we have coverage there too is
>> on my radar also, but I have not done it yet.
> 
> Yeah, we'll need to make sure there's tests for this in either fstests
> or ktest before merging.


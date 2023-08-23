Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3012FEE49A0
	for <linux-bcachefs@archiver.kernel.org>; Wed, 23 Aug 2023 09:49:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231795AbjHWJtO (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Wed, 23 Aug 2023 05:49:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236123AbjHWJsf (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Wed, 23 Aug 2023 05:48:35 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D3EB198D
        for <linux-bcachefs@vger.kernel.org>; Wed, 23 Aug 2023 02:37:14 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id 5b1f17b1804b1-3ff7d73a6feso2840405e9.1
        for <linux-bcachefs@vger.kernel.org>; Wed, 23 Aug 2023 02:37:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=froggi.es; s=google; t=1692783433; x=1693388233;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=jO57oMPLPzoqiE+0WLfBuP/N1tX+uvf5vU4e2swax2A=;
        b=O9zcF6zNI9CAYlK1xiYnEkUBqzINBYdhuGx0W3YAuRI2nIUxYtd8lZnMUsBuh3hSEv
         jTJE0iDhQ4sL2D8vKyWAHbjF+p1a24agRzuJ3nZ3mDDzVAGDW/3Kox1ddiuECMeT3vMZ
         aU4ExvBcMn0eMYeu5gOY06ScIO0s8S2SmblW8h/BRRFSIxA9pRbvb0IIv84Xy2MUB+3O
         3cRJ+FNJhQGZVv8anZ3vIf1r0TaSRIwbWIOdLcGAjZCZVeUH9D03fESMkXXPaN3b2CWF
         90jLvWoGSUXBgSNTOVFsRlZPPGJwUyBzqnujhjEUJ9PbhLljaKc/aiicvWV0daynPQlb
         aurg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692783433; x=1693388233;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jO57oMPLPzoqiE+0WLfBuP/N1tX+uvf5vU4e2swax2A=;
        b=lr/ax3NG0EENVN5tb3JjNW9+liVCvJ9F0AW5F41KJLhi6UuEp4VA2ep18QCnjUG4yI
         STXUsigAEFtC4G1ZzacDjP0QJ308rB1vzotaxvNaXVTuynbPOkkJEyLEzolJhABRsWfV
         YK6tCaAxksMXY1UOcu9yVHTlL5BGwv2rENj0Ettxchcv8FMWKUoj0Pz+exVE0cJwKBb6
         Ap984EptzwJYrEyf2LHF5kSgob3/4oLv4+P3ttHzaPNfoizddjTP0VqexRoYQiXf+wRz
         JmRYTxqr+iaJrXj3KzsQ1q8UXiINtRq/JHTGWoa7o6TQ+mK8VgSP1LX/bFSZ1QYRmlI7
         ekwA==
X-Gm-Message-State: AOJu0YwHXs5yeOrdi7aG+msgYoli9dKvHE8PMzRgN64BQlP5hk+A+/XZ
        t2Ud/JoEK1zGSY2kgNj2OZfNWA==
X-Google-Smtp-Source: AGHT+IFqT4a9pv094K8tP/3/l5I7l/btWt8ETkAQoEPc1iauIlC3DHz859DMlUq3AACy51Fx9bn/Uw==
X-Received: by 2002:a7b:c7c3:0:b0:3f9:b748:ff37 with SMTP id z3-20020a7bc7c3000000b003f9b748ff37mr9458309wmk.20.1692783432901;
        Wed, 23 Aug 2023 02:37:12 -0700 (PDT)
Received: from [192.168.0.89] (darl-09-b2-v4wan-165404-cust288.vm5.cable.virginm.net. [86.17.61.33])
        by smtp.gmail.com with ESMTPSA id v7-20020a05600c214700b003fc01495383sm21918310wml.6.2023.08.23.02.37.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Aug 2023 02:37:12 -0700 (PDT)
Message-ID: <d05ab1d6-84f7-416e-92c6-911d153ee215@froggi.es>
Date:   Wed, 23 Aug 2023 10:37:11 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [v4 3/3] bcachefs: Implement casefolding
Content-Language: en-US
To:     Gabriel Krisman Bertazi <krisman@suse.de>,
        Kent Overstreet <kent.overstreet@linux.dev>
Cc:     linux-bcachefs@vger.kernel.org,
        =?UTF-8?Q?Andr=C3=A9_Almeida?= <andrealmeid@igalia.com>
References: <20230814012434.627641-1-joshua@froggi.es>
 <20230814012434.627641-4-joshua@froggi.es> <87v8dh60rd.fsf@suse.de>
 <8ffb410c-ebfc-490c-96d8-8ed72ef8eee2@froggi.es>
 <20230815005837.figd3mlz7if4w6oo@moria.home.lan> <87sf8k423r.fsf@suse.de>
From:   Joshua Ashton <joshua@froggi.es>
In-Reply-To: <87sf8k423r.fsf@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org



On 8/15/23 19:00, Gabriel Krisman Bertazi wrote:
> Kent Overstreet <kent.overstreet@linux.dev> writes:
> 
>> On Mon, Aug 14, 2023 at 10:18:33PM +0100, Joshua Ashton wrote:
>>
>>> Grepping the test right now I already know we will fail the
>>> `test_casefold_flag_removal` test as we don't support toggling the flag on
>>> non-empty directories as it would require rehashing and thus restructuring
>>> the btree.
>>
>> What was the motivation for supporting that on other filesystems? I'm
>> not inclined to add that to bcachefs without a good reason.
> 
> I don't think there was a better reason than "it is user-friendly to
> allow disabling the feature without having to remove the
> directory". Note that it is trivial to do so in empty directories for
> ext4/f2fs: it is just a matter of flipping a bit in the inode to
> enable/disable casefolding.
> 
> I think it's ok for the Windows games to not allow disabling
> case-insensitive once it is set for a directory.  For fstests, I suppose
> the easiest solution would be to skip that subtest when running on
> bcachefs.
> 

Makes sense. And yeah, we would never unset it in Steam/Proton.

>>>> Sure, if you have both, dirent and dentry->d_name casefolded, then it is
>>>> just a regular memcmp, but at least you don't have to change the disk
>>>> format and your implementation becomes simpler.
>>>>
>>>
>>> Given we have the opportunity to have support for this in the dirent format
>>> for bcachefs, I think it makes sense to take it right now.
>>
>> It also means that we have the option of defining a casefolding map that
>> handles ß correctly.
> 
> What do you mean by handling ß correctly?  do you intend to support NFKD
> normalization?  We can extend fs/unicode/ for that fairly easily,
> but iirc, other filesystems decided to stick with NFD, because NFKD is
> a bit too eager when folding some characters.

Yes, I believe we wanted to add support for other normalizations as 
bcachefs options.

Or at the very least, ensure we structure what we do around being able 
to support that in the future.

> 
>>>>> +#if IS_ENABLED(CONFIG_UNICODE)
>>>>> +	struct unicode_map 	*cf_encoding;
>>>>> +#endif
>>>>
>>>> This goes in struct super_block.
>>>
>>> The code in libfs.c that uses the s_encoding in the super_block is never
>>> used for bcachefs as it defines its own inode_operations and doesn't use any
>>> of the libfs common code for lookups/hashes there (ie. the
>>> dentry_operations).
>>>
>>> One thing we wanted to do down the line was to use the bcachefs options
>>> system to be able to pick the encoding on a per-inode basis.
>>>
>>> Currently I am storing it in the struct bch_fs as currently there is no need
>>> for other encodings right now and it is convenient, so there can only be one
>>> -- but that could change at some point with an opt attached to the inode.
>>>
>>> I am happy to bung it in the vfs super_block for now though -- but I need to
>>> look at how that all works out with mounting and the multiple drives
>>> situation. Just be aware that at some point, it will likely be moved back
>>> again to our code.
>>
>> We also don't always have a super_block available when we have a running
>> bch_fs object (e.g. when running in userspace, for fsck and various
>> other tools). Since s_encoding is used in dirent.c, it probably needs to
>> be in bch_fs.
> 
> Ah, I didn't know this is reused for userspace tools.  Still, as long as
> you initialize sb->s_encoding at mount time, libfs helpers will work fine.
> 

Cool.

- Joshie 🐸✨

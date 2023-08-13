Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F703C001B0
	for <linux-bcachefs@archiver.kernel.org>; Sun, 13 Aug 2023 15:29:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229553AbjHMP3x (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Sun, 13 Aug 2023 11:29:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229562AbjHMP3w (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Sun, 13 Aug 2023 11:29:52 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E98EE127
        for <linux-bcachefs@vger.kernel.org>; Sun, 13 Aug 2023 08:29:54 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id ffacd0b85a97d-317716a4622so3162375f8f.1
        for <linux-bcachefs@vger.kernel.org>; Sun, 13 Aug 2023 08:29:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=froggi.es; s=google; t=1691940593; x=1692545393;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=G9BUJjFSxs1d1wz9kc2KkV+2YzUkkxbUo72tU0yy9Hw=;
        b=Ad6G8RdZuNMd/IQfSY6vM6ZqSw4wEhRUGNZ8bCsx8iepRZYTqYCuP6Caeu5UP7PcNV
         39IxYQ5oDBUmWylR2kaAvYkWNTqAbkrrH4k9JCMnzS2kd2XT2DrrEANlXPPB/qgbL3nb
         T8fM4CFqRJ48PjedI2UOfRNsJZLTpPh30dUVm/hVGUhwxwgni/CTpooeXNcxpfxhbnu5
         dB3ay+5fjOl8pwpSH7PCNYJQI7Vu85+DVbEw6OLSo9uLzo93BQQEEBKTogomSypjinpx
         K4fK5kbxrFbTDWyDr61Nd2hpiO5WAWXKWQ8/puQ8e98aCtCJI3kOdRl/jPoEgFz1x3tJ
         kWLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691940593; x=1692545393;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=G9BUJjFSxs1d1wz9kc2KkV+2YzUkkxbUo72tU0yy9Hw=;
        b=Z97NuwK9BF/lS/cHV7OLmneYsV/NahpqissHGgD64xV8MWV8dqDyy/x7sC+lhnYMt5
         T5CSb4AV/I3XOfnrULOngQ+Zh898RH+vZxVHxyjBp8wBi4uh8Qj8kIYFbLY1BpAjkRx4
         A87ZPFlF9gL7uSSbKutmasG023MWfI6LmqoUReMyfqvLborXFW1oyiz2NPLzdYw1juZw
         z5950qBFQO3Q991Rt8u+3z1SrI74iZQojtzcpdvNZ17zd9zoz8TjULoBKCfld5j8x7nU
         tnPk2MnMP21VyAf6qMztf8/uSDGcfwWC2PGoG5k4Br7IwUtDRFrlkNsY7CFFJbkuHSND
         kSOg==
X-Gm-Message-State: AOJu0Yzp4P5Zx8ycpDjluMtumP029F52NgunFl1jMvaOP+qAcSwmgGr8
        Rdq5VZuwZQVVm3JovetKnXVmquTR777MBwwyEGc=
X-Google-Smtp-Source: AGHT+IGKZNm8Wu9yaErtG2egW2oIkCsVFpY8ivaU1FSMFRM0qDxG08l/Ys0vlVznotRmXBoKihEbQA==
X-Received: by 2002:a5d:668c:0:b0:317:5849:c2e0 with SMTP id l12-20020a5d668c000000b003175849c2e0mr5230462wru.9.1691940593307;
        Sun, 13 Aug 2023 08:29:53 -0700 (PDT)
Received: from [192.168.0.89] (darl-09-b2-v4wan-165404-cust288.vm5.cable.virginm.net. [86.17.61.33])
        by smtp.gmail.com with ESMTPSA id v2-20020adfe282000000b00317ab75748bsm11613723wri.49.2023.08.13.08.29.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 13 Aug 2023 08:29:52 -0700 (PDT)
Message-ID: <cba61c5b-efc8-4456-b325-fee85e066f1a@froggi.es>
Date:   Sun, 13 Aug 2023 16:29:52 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] bcachefs: Lower BCH_NAME_MAX to 512
To:     Kent Overstreet <kent.overstreet@linux.dev>
Cc:     linux-bcachefs@vger.kernel.org
References: <20230812235947.557433-1-joshua@froggi.es>
 <20230813151034.rgzwbyhwwqudjuk6@moria.home.lan>
Content-Language: en-US
From:   Joshua Ashton <joshua@froggi.es>
In-Reply-To: <20230813151034.rgzwbyhwwqudjuk6@moria.home.lan>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org



On 8/13/23 16:10, Kent Overstreet wrote:
> On Sun, Aug 13, 2023 at 12:59:17AM +0100, Joshua Ashton wrote:
>> To ensure we aren't shooting ourselves in the foot after merge for
>> potentially doing future revisions for dirent or for storing multiple
>> names for casefolding, limit this to 512 for now.
> 
> Any time you're changing something - always grep to see how it's used:

Was aware it was used here, but wasn't sure what you were willing to 
accept in terms of compat.

> 
> bch2_dirent_invalid():
> 
>          if (d_name.len > BCH_NAME_MAX) {
>                  prt_printf(err, "dirent name too big (%u > %u)",
>                         d_name.len, BCH_NAME_MAX);
>                  return -BCH_ERR_invalid_bkey;
>          }
> 
> We'll need to either delete that check, or only run it for new keys
> (flags & BKEY_INVALID_COMMIT), we don't want to be deleting existing
> dirents

It isn't actually possible for this check to even trigger with the old 
BCH_NAME_MAX given how the length was calculated and the value of it.

Makes sense to just change it to a check on COMMIT for new keys with the 
new size..
(Should also never happen, but makes sense for sanity.)

- Joshie 🐸✨

> 
>>
>> Previously this define was linked to the max size a d_name in
>> bch_dirent could be.
>>
>> Signed-off-by: Joshua Ashton <joshua@froggi.es>
>> ---
>>   fs/bcachefs/bcachefs_format.h | 4 +---
>>   1 file changed, 1 insertion(+), 3 deletions(-)
>>
>> diff --git a/fs/bcachefs/bcachefs_format.h b/fs/bcachefs/bcachefs_format.h
>> index 5ec218ee3569..23bae622309c 100644
>> --- a/fs/bcachefs/bcachefs_format.h
>> +++ b/fs/bcachefs/bcachefs_format.h
>> @@ -916,9 +916,7 @@ struct bch_dirent {
>>   #define DT_SUBVOL	16
>>   #define BCH_DT_MAX	17
>>   
>> -#define BCH_NAME_MAX	((unsigned) (U8_MAX * sizeof(__u64) -		\
>> -			 sizeof(struct bkey) -				\
>> -			 offsetof(struct bch_dirent, d_name)))
>> +#define BCH_NAME_MAX	512
>>   
>>   /* Xattrs */
>>   
>> -- 
>> 2.41.0
>>


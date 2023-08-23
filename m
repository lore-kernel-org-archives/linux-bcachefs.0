Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49B4FEE49B0
	for <linux-bcachefs@archiver.kernel.org>; Wed, 23 Aug 2023 10:05:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231442AbjHWKFG (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Wed, 23 Aug 2023 06:05:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234752AbjHWJks (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Wed, 23 Aug 2023 05:40:48 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D17E199A
        for <linux-bcachefs@vger.kernel.org>; Wed, 23 Aug 2023 02:35:01 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id ffacd0b85a97d-307d58b3efbso4698244f8f.0
        for <linux-bcachefs@vger.kernel.org>; Wed, 23 Aug 2023 02:35:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=froggi.es; s=google; t=1692783300; x=1693388100;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=EAHYvtvwmCee1GUX6z6Ztbirvz87WRh/9na+EDeD4+0=;
        b=mHJBaXSxG/0l5fu+cdtwHSUMKN565CRrfoypBPW6Gm10q6rp7+vijvoetJT2KC6Tv3
         8zyZWsp/pTX3bTengW7QvJHgVs6ztMoSWsdP9oHJkMBOIrrqZGh3H8WqhHAHZA9OQFUa
         wtb9xBRx4MyRLypBkosSHNv+P7qncV+arOyIZRQaHI8fKTvcQbkgLSGDPtZh2cZXbTgD
         vRqTS1Q+XPE2a1f37JGdDaAD7+iU5gpHh7KZmc2RDnoufYd1fKA075bpFtYnSepk80tq
         HNDiv3Ec13MGwZlt5twBfhcKrpaMiE08O1PbatQcRsxjhd5786QtnEjl0OdFuGquDqw3
         garQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692783300; x=1693388100;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EAHYvtvwmCee1GUX6z6Ztbirvz87WRh/9na+EDeD4+0=;
        b=QmDL2ZWFPXlj7Zgz7Y5xxjxDPDOrWq+JmGc73RnGFDPSMppJnNIOwZGkpy7O1n5gXP
         ACHjeJk/qDIru/rfuvoQEUf0+75aGnolijyLNZSDPNqY/YJWjDirB/dsY08zAIP6l5VE
         S5k4LXg5egEOltNIpK5BszMxMK9V4bCncrU44DrpkQMjndcEhaoG+swpcjl2ho2rfSYy
         JmcaLmZssew7xeS78Gs5e1UCHp7re53yi22oXik+LEhkeoczLhJJ3vaAsqeogDlBws9X
         HP0BPNf9CucdjV+fFdz5lGdmIIdBFTpztI+SOW5DGvbAdv5HdBCDRUpgVhmfqnwdM4Z3
         9S+w==
X-Gm-Message-State: AOJu0YxclULYFL7deIAPIOkAgNQvSTr/P+8EPa+Jrfe2KZ+tWyzbCeOa
        3gc5q2xWtZSfccHHRL8EK/8UvdtI5tZHV4I7ZxU=
X-Google-Smtp-Source: AGHT+IH/qpRNAddrVh64+hTPj1H+ne9BoTxAdFtfLnoPFfFJW+M4TqrA/nwlSIFpz577i2+UNewGfA==
X-Received: by 2002:adf:ce82:0:b0:317:6e62:b124 with SMTP id r2-20020adfce82000000b003176e62b124mr8922555wrn.18.1692783299783;
        Wed, 23 Aug 2023 02:34:59 -0700 (PDT)
Received: from [192.168.0.89] (darl-09-b2-v4wan-165404-cust288.vm5.cable.virginm.net. [86.17.61.33])
        by smtp.gmail.com with ESMTPSA id j7-20020adfea47000000b00317731a6e07sm18464703wrn.62.2023.08.23.02.34.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Aug 2023 02:34:59 -0700 (PDT)
Message-ID: <ead41a34-8bfb-4a27-ab00-f896a99a56ec@froggi.es>
Date:   Wed, 23 Aug 2023 10:34:58 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From:   Joshua Ashton <joshua@froggi.es>
Subject: Re: [v4 0/3] bcachefs: Casefolding implementation
To:     Kent Overstreet <kent.overstreet@linux.dev>
Cc:     linux-bcachefs@vger.kernel.org,
        Gabriel Krisman Bertazi <krisman@suse.de>
References: <20230814012434.627641-1-joshua@froggi.es>
 <20230816194014.guhw6afyvix3kvpn@moria.home.lan>
Content-Language: en-US
In-Reply-To: <20230816194014.guhw6afyvix3kvpn@moria.home.lan>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org



On 8/16/23 20:40, Kent Overstreet wrote:
> On Mon, Aug 14, 2023 at 02:24:24AM +0100, Joshua Ashton wrote:
>> This implements support for case-insensitive file and directory
>> lookups using the regular `chattr +F` (`S_CASEFOLD`, `FS_CASEFOLD_FL`)
>> casefolding attributes for bcachefs.
>>
>> The implementation uses the same UTF-8 lowering and normalization that
>> ext4 and f2fs is using currently
>>
>> The main usecase for casefolding is compatibility with software written
>> against other filesystems that rely on casefolded lookups
>> (eg. NTFS and Wine/Proton).
>> Taking advantage of file-system level casefolding can lead to great
>> loading time gains in many applications and games.
>>
>> See more information and rationale in:
>> Documentation/filesystems/bcachefs/casefolding.rst
>>
>> You can see/review the work in my tree here:
>> https://github.com/Joshua-Ashton/bcachefs/tree/casefold
>>
>> v2: Update format to store length in dirent based on flag, add comments, cleanup
>> dirent_create_key, other misc. nits from IRC.
>>
>> v3: Cleanup the dirent code, utilize the fact that BCH_NAME_MAX is smaller now,
>> remove fallbacks for too big keys that won't make sense anymore. Improved
>> lookup string lowering.
>>
>> v4: Move cf_name allocation from stack to trans alloc, validated bkey in invalid,
>> used length directly, misc. nits.
> 
> Josh, do you think you could post the benchmarks you ran at the start of
> all this? We should look at those again after negative dentries are
> hooked up and working correctly.
> 
> After giving this more thought, I'm starting to feel a bit more inclined
> to Gabriel's approach...

Sure. I've cleaned the synthetic ones up into an easy-to-run userspace 
benchmark available here:

https://github.com/Joshua-Ashton/casefolding-microbench

My results look like the following with -O2 on a Ryzen 7900XT:

------------------------------------------------------------------------------------------
Benchmark                                                Time  CPU 
Iterations
------------------------------------------------------------------------------------------
memcmp_ascii_eq                                       5.83 ns 5.82 ns 
119813859
memcmp_ascii_immediately_neq                          3.71 ns 3.70 ns 
188580499
memcmp_unicode_eq                                     6.63 ns 6.60 ns 
111117537
memcmp_unicode_immediately_neq                        3.67 ns 3.66 ns 
192004721
utf8_strncasecmp_ascii_eq                            30221 ns 30118 ns 
      23699
utf8_strncasecmp_ascii_immediately_neq                72.7 ns 72.6 ns 
   9634262
utf8_strncasecmp_unicode_eq                          33375 ns 33328 ns 
      21011
utf8_strncasecmp_unicode_immediately_neq               235 ns 235 ns 
  2981485
utf8_strncasecmp_unicode_cased                       34084 ns 34027 ns 
      20973
utf8_strncasecmp_folded_ascii_eq                     16301 ns 16276 ns 
      42710
utf8_strncasecmp_folded_ascii_immediately_neq         19.6 ns 19.6 ns 
  35654425
utf8_strncasecmp_folded_unicode_eq                   17529 ns 17504 ns 
      39968
utf8_strncasecmp_folded_unicode_immediately_neq        110 ns 110 ns 
  6373884
utf8_strncasecmp_folded_unicode_cased                19958 ns 19876 ns 
      35236

As you can see, using utf8_strncasecmp on our largest name ASCII strings 
can result in a 5183x slowdown for comparison checks, and for Unicode 
strings of similar length, a 5846x slowdown.

utf8_strncasecmp_folded was documented to give a 30% improvement for 
casefold lookup times in a large directory 
(3ae72562ad917df36a1b1247d749240e3b4865db). This bench shows that to be 
more like a 50% improvement on utf8_strncasecmp which is ballpark-ish. 
This is still a slowdown of 3006x in the best-case compared to memcmp.

Bear in mind, this is probably only once for a cmp in a small directory, 
and multiple times if there are hash collisions. At it's worst, at a 
minimum it will take ~0.04ms to do simply the cmp of a single case 
insensitive lookup.

Using -O3 makes things a bit better for strncasecmp, but not by any 
orders of magnitude that it needs:

------------------------------------------------------------------------------------------
Benchmark                                                Time  CPU 
Iterations
------------------------------------------------------------------------------------------
memcmp_ascii_eq                                       3.63 ns 3.62 ns 
193349553
memcmp_ascii_immediately_neq                          2.16 ns 2.15 ns 
338061946
memcmp_unicode_eq                                     4.43 ns 4.42 ns 
158399738
memcmp_unicode_immediately_neq                        2.18 ns 2.17 ns 
322218734
utf8_strncasecmp_ascii_eq                            13476 ns 13449 ns 
      51587
utf8_strncasecmp_ascii_immediately_neq                31.9 ns 31.8 ns 
  21838062
utf8_strncasecmp_unicode_eq                          18575 ns 18536 ns 
      37588
utf8_strncasecmp_unicode_immediately_neq               130 ns 130 ns 
  5408163
utf8_strncasecmp_unicode_cased                       17719 ns 17690 ns 
      37665
utf8_strncasecmp_folded_ascii_eq                      6132 ns 6124 ns 
    114403
utf8_strncasecmp_folded_ascii_immediately_neq         8.03 ns 8.02 ns 
  87290013
utf8_strncasecmp_folded_unicode_eq                    8734 ns 8722 ns 
     80225
utf8_strncasecmp_folded_unicode_immediately_neq       52.2 ns 52.1 ns 
  13370548
utf8_strncasecmp_folded_unicode_cased                 9874 ns 9859 ns 
     71000

Still pretty significant though. :/

I would really really like to avoid this inherent extra cost going forward.

One other reason I am pretty against going with utf8_strncasecmp_folded 
(even initially) is because if/when we do decide to do casefold caching 
in fs, we have to keep all of that code path around in dirent_cmp for 
compat which is super gross.

This also means if we want to do other encodings, such as ASCII alone, 
or whatever, the _cmp code needs to grow support for those too, which I 
also really dislike.

The dirent_cmp and dirent_hash, etc code should be kept as simple and 
efficient as possible and entirely free of all of this aside from using 
the already provided names.

One question I know is going to be asked is: How does this translate to 
the real world?

Given that the switch from utf8_strncasecmp to utf8_strncasecmp_folded 
for EXT4 increased perf with large directories by 30% as-per 
3ae72562ad917df36a1b1247d749240e3b4865db, then using a pure memcmp must 
improve it pretty significantly from the benchmarks above, although that 
is my pure speculation based on extrapolating the two data sets. :-D

We are of course always eating the cost of the initial utf8_casefold for 
hashing and cmp though...

Is there a need for more data here or is this enough to base our 
decision off of?

IIRC we had some data points about Proton prefix creation time and stuff 
following the ext4 casefolding work and strncasecmp vs folded too, but I 
may need to dig up if anyone still has those. I don't think they are 
super relevant here though.

- Joshie 🐸✨

Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B465C0015E
	for <linux-bcachefs@archiver.kernel.org>; Sat, 12 Aug 2023 17:09:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229568AbjHLRJg (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Sat, 12 Aug 2023 13:09:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229472AbjHLRJf (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Sat, 12 Aug 2023 13:09:35 -0400
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C7D41BB
        for <linux-bcachefs@vger.kernel.org>; Sat, 12 Aug 2023 10:09:38 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id 5b1f17b1804b1-3fe5c0e57d2so26304095e9.0
        for <linux-bcachefs@vger.kernel.org>; Sat, 12 Aug 2023 10:09:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=froggi.es; s=google; t=1691860176; x=1692464976;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=X4+yyFvacWjpMSTuZpKHoZXi1JRHwnwiy4npABreerI=;
        b=mvE2SmCznE9Fa3kNL3RgFYyKOIMKQRIkPPKjxPgtqs9scMKBU8nZ1Y37YSmy8CpsCz
         dTRgOvFFauyvKQhOhqbow8J6QPmNotL2JB+8lxeFCdUmYocmd8txfE+nhvpNf0ly20KH
         /H0hjTthFMsgSsjINi7MvJmUmznBF3dWbybnEZ5bz63snUvQPE/xWs5Uz3o9br+7IWXM
         lZsojWzpoX0zuQDrK2Lca0bzOYOSdmhvr3rURHt/zS5zcR4iReX5tOp/iiGK+8hDZ9V4
         H90lSpmIav6jMWAVQIRlHhE4Y/1HROzR9p0ChEmBo6QBfbH531VsHXveLLcHganFx+ma
         CiQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691860176; x=1692464976;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=X4+yyFvacWjpMSTuZpKHoZXi1JRHwnwiy4npABreerI=;
        b=ZWWjRUg9FI04C4pTLbuMZP3P09V3JTWjxiksdI1+opUf4kiQN1ItiOnT2F4+AXFJ4L
         DeYzeG2QDaV0bnzy/x+hAttELW14YUlCoznp8+80Qt6+vmr917orYf2nGoSmGCfWfvlq
         aQZjjVuzTSS6YLy6IEclkUGwJA4irc6qTIiGE1YZS/6qP4UTutAIqV+F9frxpjbao7lv
         /Elv6X/laBinWnZ9qXXiRu2u3/Yq9p1Jc2o2cqs/oBHK5l4+VMz9Ny5NzU3jTM1UjJM0
         1k9/4vIGWZhHtNunxsBwEINmh+96qrAtndFAD9T0vAmbNNwRSCBp+BDS7ejtCabB3Pmv
         66DA==
X-Gm-Message-State: AOJu0YwaMuNKdKYU5woZ+JC/s7Rggu3T+DfzAfXEdHG+M2n51jubPh+c
        uVXKpdHs6NWkTkz/P/o3LNDZaA==
X-Google-Smtp-Source: AGHT+IHL4hhJAM/bIXEVCWc4x87OKElb+cewCmfgVpj9HlHStEejsxgpRpyNKRb1GuGu3eaItFyw0Q==
X-Received: by 2002:adf:ef4a:0:b0:314:1b36:f440 with SMTP id c10-20020adfef4a000000b003141b36f440mr3584235wrp.70.1691860176434;
        Sat, 12 Aug 2023 10:09:36 -0700 (PDT)
Received: from [192.168.0.89] (darl-09-b2-v4wan-165404-cust288.vm5.cable.virginm.net. [86.17.61.33])
        by smtp.gmail.com with ESMTPSA id y14-20020adff6ce000000b00317e9f8f194sm9069037wrp.34.2023.08.12.10.09.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 12 Aug 2023 10:09:36 -0700 (PDT)
Message-ID: <1390401f-7797-40e7-a8d2-e266e53d22ba@froggi.es>
Date:   Sat, 12 Aug 2023 18:09:35 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/4] bcachefs: Optimize bch2_dirent_name_bytes
To:     Kent Overstreet <kent.overstreet@linux.dev>
Cc:     linux-bcachefs@vger.kernel.org
References: <20230812145017.259609-1-joshua@froggi.es>
 <20230812145017.259609-2-joshua@froggi.es>
 <20230812162330.6i6jybtasalh3asw@moria.home.lan>
Content-Language: en-US
From:   Joshua Ashton <joshua@froggi.es>
In-Reply-To: <20230812162330.6i6jybtasalh3asw@moria.home.lan>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org



On 8/12/23 17:23, Kent Overstreet wrote:
> On Sat, Aug 12, 2023 at 03:47:46PM +0100, Joshua Ashton wrote:
>> Avoids doing a full strnlen for getting the length of the name of a
>> dirent entry.
>>
>> Given the fact that the name of dirents is stored at the end of the
>> bkey's value, and we know the length of that in u64s, we can find the
>> last u64 and figure out how many NUL bytes are at the end of the string.
>>
>> On little endian systems this ends up being the leading zeros of the
>> last u64, whereas on big endian systems this ends up being the trailing
>> zeros of the last u64.
>> We can take that value in bits and divide it by 8 to get the number of
>> NUL bytes at the end.
>>
>> There is no endian-fixup or other compatibility here as this is string
>> data interpreted as a u64.
> 
> This needs a bit more analysis:
> 
> If we ever screwed up and created dirents where there was a nul before
> the last u64, this is going to change how those dirents are interpreted
> - we'll now be returning longer dirents, but with an embedded nul.
> 
> Fortunately, bch2_dirent_invalid() checks for this, so we're good there.
> 
> But, your change does break the check in bch2_dirent_invalid(); we still
> do need to check somehow that there aren't any embedded nuls. Can you
> fix that too?

Yes. I have fixed this locally by ensuring strlen(name.name, name.len) 
== name.len now in bch2_dirent_invalid.

- Joshie 🐸✨

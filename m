Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC23EC001E0
	for <linux-bcachefs@archiver.kernel.org>; Sat, 12 Aug 2023 23:04:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230006AbjHLXE2 (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Sat, 12 Aug 2023 19:04:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229512AbjHLXE2 (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Sat, 12 Aug 2023 19:04:28 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31AF01988
        for <linux-bcachefs@vger.kernel.org>; Sat, 12 Aug 2023 16:04:30 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id 5b1f17b1804b1-3fbea14706eso28003855e9.2
        for <linux-bcachefs@vger.kernel.org>; Sat, 12 Aug 2023 16:04:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=froggi.es; s=google; t=1691881468; x=1692486268;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=M+nhp/f2i7hUb1g4XSBT+0tTvyk/LctCxwtaQi235fo=;
        b=OkjY5eX3friUFY0lVcoq5Q4Kx+CDl6rmWQrpOG6mLNlYQJuFh/ZinUMs9HFM2zkJxj
         vk7T407YEizdH7/bA0yadPmDXkHkxBYREDBRsBTbNi/kyk9RSmHoLOzHeih3ue/5GAln
         DiqhTzM/ba0ty6VfMkTLsp8k/Ua7u71tzgoxBEVTSur57X3s+KpWDKIODBafNy5Ne+DW
         JNwDfUk+ynEVe/0h8N9ZuBgd+JSpWnI97jVDMtOT6GHlPzbdXFU1iXDB65KZmxH7czkl
         hOENPkHc+YSf6hnVEC971//xgk4qqXfriQnEWqQbu5QD/SzgL8tT7O8Quzedq6dtqKGx
         onQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691881468; x=1692486268;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=M+nhp/f2i7hUb1g4XSBT+0tTvyk/LctCxwtaQi235fo=;
        b=RtBb0GhbOQFLnipx3w9BHKcjjh6f/ggsxjjhNkbQfZuXZMJRd8QHuFAs8AUaN5p2jA
         YZWIgs2QTWcH1jOD8rlGp+UUdAwV4xU/SUMFGwxRUXQLvl1hwls3yUZJk6Mc7Uc02cnu
         MMk/XJ41IHpqVyFUCNZl7XRr7+Dk+J45A8NB0mAyk5heTiUpuc3iafOBqnT5k8UlvIGa
         pLT5JMqQFA+bar4eftvABXgaS/ioTHaiZ1Lc3JW20V2fde9XpHqmAEDXxgMvUeE6VjxS
         z/dSSgPJ9mQGG2eN+Mdf2Eav8Blvag1P8x8i7SE2jNaneip8VLqaG6FIiGIiWmJ75KRu
         4/yA==
X-Gm-Message-State: AOJu0Yysvt8WuIndeZ3ENU+7yk5lLehba11oKdNJ376OSxT+lh5cbYbP
        8oZECI7wutxXEPMMH/8vv8brDq4CMQL1xqW/8g8=
X-Google-Smtp-Source: AGHT+IEbId4g6mlE52ru09serXnGb5DFMn1daKABg4GQYHK6pnX7OGiQ7pSsJgHcIDPdbIK/X67bYw==
X-Received: by 2002:a7b:cd99:0:b0:3fe:14af:ea21 with SMTP id y25-20020a7bcd99000000b003fe14afea21mr4302529wmj.21.1691881468762;
        Sat, 12 Aug 2023 16:04:28 -0700 (PDT)
Received: from [192.168.0.89] (darl-09-b2-v4wan-165404-cust288.vm5.cable.virginm.net. [86.17.61.33])
        by smtp.gmail.com with ESMTPSA id n12-20020a7bcbcc000000b003fe557829ccsm12356886wmi.28.2023.08.12.16.04.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 12 Aug 2023 16:04:28 -0700 (PDT)
Message-ID: <e338f5aa-72a0-4a9f-b0f0-b29d1dd516f3@froggi.es>
Date:   Sun, 13 Aug 2023 00:04:27 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [v2 3/3] bcachefs: Implement casefolding
Content-Language: en-US
To:     Kent Overstreet <kent.overstreet@linux.dev>
Cc:     linux-bcachefs@vger.kernel.org,
        =?UTF-8?Q?Andr=C3=A9_Almeida?= <andrealmeid@igalia.com>,
        Gabriel Krisman Bertazi <krisman@suse.de>
References: <20230812212647.490829-1-joshua@froggi.es>
 <20230812212647.490829-4-joshua@froggi.es>
 <20230812224506.nplzn2chz63xbiyb@moria.home.lan>
 <c72eb610-5c52-4aa7-9643-e783daf00978@froggi.es>
 <20230812230252.amixsrv4zp3uyjpc@moria.home.lan>
From:   Joshua Ashton <joshua@froggi.es>
In-Reply-To: <20230812230252.amixsrv4zp3uyjpc@moria.home.lan>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

Are you sure? That would make moving files between directories 
potentially fail when going from regular -> casefolded which seems very 
wrong...

The whole reason for the fallback is so that this situation doesn't 
happen because it seems like it would break basically every userspace 
application.

- Joshie 🐸✨

On 8/13/23 00:02, Kent Overstreet wrote:
> On Sat, Aug 12, 2023 at 11:54:46PM +0100, Joshua Ashton wrote:
>> There is the edgecase of it being too big to cache the casefolding in the
>> dirent. That's what I mean by that.
> 
> Yeah, let's just not allow dirents that are that long.


Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51456C0015E
	for <linux-bcachefs@archiver.kernel.org>; Sat, 12 Aug 2023 23:57:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229656AbjHLX5Q (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Sat, 12 Aug 2023 19:57:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbjHLX5Q (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Sat, 12 Aug 2023 19:57:16 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9A6D1BF
        for <linux-bcachefs@vger.kernel.org>; Sat, 12 Aug 2023 16:57:17 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id ffacd0b85a97d-3180fd48489so2520103f8f.3
        for <linux-bcachefs@vger.kernel.org>; Sat, 12 Aug 2023 16:57:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=froggi.es; s=google; t=1691884636; x=1692489436;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=VYs5p47PyjzycRLooPER8Va7+Z7PNFAJ0rMkT6/LyRY=;
        b=euQCkkS+6m1VJ0OT4lCtDsVONGsK8zQifVGCEk/TIN+zO6u304CasuohK6J9DP2GAJ
         Er0upulFGfu8EbXAG+/VdCeYKcfuLxq5pW9g+r3+C5tuijzXv52/UibbdJDPccLWgONf
         J53PfMkSmmFg7HIiz5OK58PLL9P7eo6v+AjtAophd/+Kr5CPNCbKcZFRj4+8l8fL+Kqb
         7T67oSGiJMejmih5YM1i2gMdQnztJWZssMP266zkRx9NbeT81umeQkbqQSoibDfXlIk5
         ixnqqFHfGIWSxqu/fTeRb6mhQ8T+vgdcbz9BM12UBwM94ffL+aNc3J5/X1rpkavzqpvo
         hybQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691884636; x=1692489436;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VYs5p47PyjzycRLooPER8Va7+Z7PNFAJ0rMkT6/LyRY=;
        b=Af1HE9eoQGIIyuD1ZfuID/lquJnvGB7FkESVHfn3ZA2DovRg698BDl076svmHWeVzL
         sfo7OKANzviDw1NglXzItJh0gz7J2i0vkhT6HS8AG9SwnehfCGhdJ3gBD0ht98sYXP6A
         QGHkX59Oxj9ffcMUQ1asglI42677bWqpYEFcMsJQ7XRtaiD1Lkfyy0S2xfBDnulFAg5c
         x8FWPGgTn5uaboW6rTBm3RR22NNy+b5TL7dPkw3PsT3Tzl7KmJszdWVSYN3ehvtED8ZP
         Pq5zLE9/Lvx4Dr5gdCOmiv77jR47Qu6YTAivxm5Lqr1YOIK4Y/KtDI/C3zfvSwC/yZGL
         rLyw==
X-Gm-Message-State: AOJu0YyPyM5+rj74XPcoaHKReD86k2aM8nk2Am2hMx4Dr4EI7L/xZk6w
        vdP6G3ZhEn3pqfRWD69qPJXbU8GN0mcrcxXMLUs=
X-Google-Smtp-Source: AGHT+IFcOppzN/ruLdlIWqxEze/YBUtdTJGWGG81fuM/6Ck7WEOl0AEFPlzH5Dlhm5vgl1Nbq3Xbhw==
X-Received: by 2002:adf:db02:0:b0:317:6262:87af with SMTP id s2-20020adfdb02000000b00317626287afmr4193277wri.16.1691884636121;
        Sat, 12 Aug 2023 16:57:16 -0700 (PDT)
Received: from [192.168.0.89] (darl-09-b2-v4wan-165404-cust288.vm5.cable.virginm.net. [86.17.61.33])
        by smtp.gmail.com with ESMTPSA id s11-20020a5d510b000000b0031417fd473csm9835234wrt.78.2023.08.12.16.57.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 12 Aug 2023 16:57:15 -0700 (PDT)
Message-ID: <528ffb4b-5f13-4731-a3ec-2f36759d85d8@froggi.es>
Date:   Sun, 13 Aug 2023 00:57:15 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Please consider a more end-user appealing filesystem name
Content-Language: en-US
To:     =?UTF-8?Q?Maximilian_B=C3=B6hm?= <kernel@elbmurf.de>,
        linux-bcachefs@vger.kernel.org
References: <76853777-2f5f-4d8a-aa67-d84112c51c26@elbmurf.de>
From:   Joshua Ashton <joshua@froggi.es>
In-Reply-To: <76853777-2f5f-4d8a-aa67-d84112c51c26@elbmurf.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org



On 8/13/23 00:55, Maximilian Böhm wrote:
> Hi Kent et al., but especially Kent,
> 
> I’m very impressed by Bcachefs and very much looking forward to this FS 
> hopefully delivering us from eternally flawed btrfs.
> But I do have a consideration and please forgive me this blunt 
> overreach: It would really gain from a better name.
> 
> Please don’t take this personally. I know, Bcache was your invention and 
> its derivative is a fine academic name for an academic project. But for 
> users? As much as I’m looking forward to using this FS for the next 
> decades, having to read and write this name frequently doesn’t get me 
> excited. It’s a fine academic name but
> a) has too many syllables
> b) is hard to remember and hard to type (I still always want to write 
> Becachefs like in BeFS)
> c) is downright confusing when you just read "cache" and think this is 
> some sort of swap?
> d) is loosing against ZFS in the battle for coolness
> 
> Think of project names like SPDY, QUIC, even XFS. Heck, why not a 
> non-acronymic name, something like "Bontree", a wordplay with B+ trees? 
> At the same time an allusion to one of btrfs’ pronunciations and the 
> French word for "good". Something conveying a feeling, something to 
> identify with. It doesn’t have to be this technical letter salad - it 
> doesn’t even need the "fs" part, the "ext" series was perfectly good 
> without. In fact, damn the fs part in a rebranding.
> 
> I’m not here to suggest a better name but maybe you could ask the 
> community? I beg you to consider a shorter, cooler name for this FS 
> before it’s reaching end users on mainline. It really does deserve it!
> 
> With best regards
> Maximilian Böhm
> 

FrogFS anyone? 🐸

- Joshie 🐸✨

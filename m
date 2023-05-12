Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44F60C77B7F
	for <linux-bcachefs@archiver.kernel.org>; Fri, 12 May 2023 14:26:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241386AbjELO05 (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Fri, 12 May 2023 10:26:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240934AbjELO04 (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Fri, 12 May 2023 10:26:56 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33EBA272B
        for <linux-bcachefs@vger.kernel.org>; Fri, 12 May 2023 07:26:54 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id 5b1f17b1804b1-3f435658d23so39416815e9.3
        for <linux-bcachefs@vger.kernel.org>; Fri, 12 May 2023 07:26:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=truongsinh.pro; s=google; t=1683901612; x=1686493612;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=hQB0wElDevVXJNBpZm9sKECOn7xUmwKOoJcYMBg00RY=;
        b=KLlv1zGabTZ7hTwa0EuWt4pCuHLpMRO5sVNA5oQq7AXbdOz8y/YY3bdZHUHRoG8zrI
         S/ro+HTkdQTrpB99GjGjcfFcDja5LbCmykMbwaT/7wuE38BsSerhKpxb0e0liTKfxdSM
         I6fbc/rAWZyHKuYCdl3ODJkvUUa2yeq+CIueM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683901612; x=1686493612;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hQB0wElDevVXJNBpZm9sKECOn7xUmwKOoJcYMBg00RY=;
        b=lAZbtvjfEXIzNQdE+95txcCuEHa6VMku9mHH2e3g/KdNr+WksTqpXjPBq0EXopTlyM
         lZIdSm2cX8Vg910nn/UJact85dTvvVSSLbCBik3LkPz6rCP7F0JqtrJoBLf3ZgeIiSxU
         pC6YrWI8iVOiIN7kvAH5Hfg/kCfzYI3jTFvYh0CGtQwxxCMsdoMs1lts64yiTzPi4EqA
         i5owJO2UEDAtLzaCEqNuNHCJP0XWVN9cSXznuvbVBGsy+AM+gnTqXvfWyA5oA1LdP9qz
         N+kFAJ2vZ9ZlRBNortzY4+FbRve6LVSLVSTobo3G2TrnXl6t9vchZs893p5N3Istrabm
         q68g==
X-Gm-Message-State: AC+VfDzoxBNDAfYavtRYTnXW2jv23ZA6JafvVysU+AVENE5TnFQfGeve
        KKAPy95zpdKahRXjN6FBdfnWwWwuSoijk+0HX1rzLKT5thhqflp6aYQ=
X-Google-Smtp-Source: ACHHUZ7U48XunK8GAFAKibn2J3KJN5DJ8OycAT/nVA6rlvqweteFPTLXV3f5fq6savS1V+jOzSoH3K0wV9M8cobPcNY=
X-Received: by 2002:a7b:c5d6:0:b0:3f1:969f:c9d0 with SMTP id
 n22-20020a7bc5d6000000b003f1969fc9d0mr18612093wmk.4.1683901612483; Fri, 12
 May 2023 07:26:52 -0700 (PDT)
MIME-Version: 1.0
References: <CAMy36z5VP_6atrxdOyXSO6G+R36vA8SuaWCDAui3Om3viogPkQ@mail.gmail.com>
 <CAMy36z6+RjgAfEYUxpOhS6vFmTter=cFa2CEorSnKR=qxkft=A@mail.gmail.com>
 <CANiq72nYq5vimbhvfyUj9ejOS487LCQBxkv+7Nt5yYJ2xW_U-A@mail.gmail.com>
 <CAMy36z7iofMAK4GkYaUjW27cSC4sg-QGooj93mTg8SOb0eXxfw@mail.gmail.com>
 <CANiq72kcVS=_07D-KDcb9cVByV886mf50ydqNsMvcrJ1myLOuA@mail.gmail.com>
 <CAMy36z710P4ZVW0z_Y=ZObLkpP3Jc837B0z4sTGoDUXCH+8MRw@mail.gmail.com>
 <ZF2zCUV45mYxSe4e@moria.home.lan> <CAMy36z6fiC4esHKjAiOaOp6=sAOCbiJXpJku+6_h26xGPs8kWA@mail.gmail.com>
 <ZF2+Ah5koJEdq4A1@moria.home.lan> <CAMy36z7-hBv1HVTQaNPZzHXNzB6q-2CS4XzUrWLcwTbn3M1A7A@mail.gmail.com>
 <ZF3PwsqxsGNTVCDv@moria.home.lan>
In-Reply-To: <ZF3PwsqxsGNTVCDv@moria.home.lan>
From:   TruongSinh Tran-Nguyen <i@truongsinh.pro>
Date:   Fri, 12 May 2023 07:26:41 -0700
Message-ID: <CAMy36z6wAcNh1POmb_Dbay-M8jVH=d0WTmxUMxzv2Ped522sAA@mail.gmail.com>
Subject: Re: [PATCH] chore(util): minimal Rust build example
To:     Kent Overstreet <kent.overstreet@linux.dev>
Cc:     Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>,
        rust-for-linux@vger.kernel.org,
        Wedson Almeida Filho <wedsonaf@gmail.com>,
        linux-bcachefs@vger.kernel.org, Andreas Hindborg <nmi@metaspace.dk>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

> This seems like something for quite a long ways off, unless I'm
> misunderstanding what you're trying to do right now?

Correct, it is not my immediate need (neither for bcachefs nor other
user-space tools), just want to look out for the future. There is no
kernel module written fully in Rust yet anyway.

Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2DD9DC77B7F
	for <linux-bcachefs@archiver.kernel.org>; Fri, 12 May 2023 04:16:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239791AbjELEQh (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Fri, 12 May 2023 00:16:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229547AbjELEQf (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Fri, 12 May 2023 00:16:35 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E88EB5B8B
        for <linux-bcachefs@vger.kernel.org>; Thu, 11 May 2023 21:16:32 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id 5b1f17b1804b1-3f41d087bd3so44912445e9.3
        for <linux-bcachefs@vger.kernel.org>; Thu, 11 May 2023 21:16:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=truongsinh.pro; s=google; t=1683864991; x=1686456991;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=9EtIG/jRY8fOJEZg7odfWhF9RuBoWb+i+cnISUZXrwQ=;
        b=gaQDCIbVJtm0hnnblQb2cyHXgDPz0oxBn59T5rE+D4+WwIyNP0qB6JydFhkxghJpYr
         00sVufNVckTnU1sRQlXa+e4pEC96toCH4FvLoXpPEFCwfE2deg4wz9DNdqPwSox6yL9J
         BT4s1QGTvLpL2l2LrgIt+CieBUtba0Sxv/RYw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683864991; x=1686456991;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9EtIG/jRY8fOJEZg7odfWhF9RuBoWb+i+cnISUZXrwQ=;
        b=UIGK7hngtL5e3KrDIzdDMie2iCW4vwmN6C/LjBNW3wrRl9AqLaSSokbDa43kr9Vhsc
         LGLYvTVcrICEiKQuoSQRuM4frT9bRM2Uwv3l0edBAlppleGbu93aWGViNMKVijN2O78u
         mSHeILaLlVlRx2W6yFp7iN13w1i8rBcm/9XEHT2osLlohvaDinYu+ENqbPwP5K/KpWWZ
         shq9nFKhtamnyeBPcO+1aDjlC40Z5ccXHZLlFFii56Zk9V6DdliZ982m0JuCdOUQOIL7
         NK3UGpkVvP/RrPzypVfSx/Ml/SlixuvwElIC+Ck4Uz1MLe3J5THN8wLFuyvhhrXxBbhJ
         nxCQ==
X-Gm-Message-State: AC+VfDwKr3B80UAaNo8B0vE+ZJyBvIk++Q360mWDOhDtt4RqDfqX+o1D
        xXN2+oUgVxkFHhsbxuHn7ZzCuffDwFTpmUpr2RMVyA==
X-Google-Smtp-Source: ACHHUZ7GQwCcaf1K8LLhPj2fCve6DPpPS2dZglgRVP1nJS6DgdxsTE6pWj1kcI1LF58lXDkDCHysXJAXO9NQxlbk9mY=
X-Received: by 2002:adf:facc:0:b0:306:30e8:eb34 with SMTP id
 a12-20020adffacc000000b0030630e8eb34mr17071640wrs.48.1683864991006; Thu, 11
 May 2023 21:16:31 -0700 (PDT)
MIME-Version: 1.0
References: <ZFqHFTMqetbQKtah@moria.home.lan> <CAMy36z75N9obj0WM+OFhhnzXAPxqhg8PVY7_x8X6JbQABFnMQw@mail.gmail.com>
 <ZFqM8HOvlVn61VXs@moria.home.lan> <CANeycqq5xCUcjOeOfGAJCH1Tzd01-ALU3uqVJo-BvVX9HOK9wA@mail.gmail.com>
 <CAMy36z5VP_6atrxdOyXSO6G+R36vA8SuaWCDAui3Om3viogPkQ@mail.gmail.com>
 <CAMy36z6+RjgAfEYUxpOhS6vFmTter=cFa2CEorSnKR=qxkft=A@mail.gmail.com>
 <CANiq72nYq5vimbhvfyUj9ejOS487LCQBxkv+7Nt5yYJ2xW_U-A@mail.gmail.com>
 <CAMy36z7iofMAK4GkYaUjW27cSC4sg-QGooj93mTg8SOb0eXxfw@mail.gmail.com>
 <CANiq72kcVS=_07D-KDcb9cVByV886mf50ydqNsMvcrJ1myLOuA@mail.gmail.com>
 <CAMy36z710P4ZVW0z_Y=ZObLkpP3Jc837B0z4sTGoDUXCH+8MRw@mail.gmail.com> <ZF2zCUV45mYxSe4e@moria.home.lan>
In-Reply-To: <ZF2zCUV45mYxSe4e@moria.home.lan>
From:   TruongSinh Tran-Nguyen <i@truongsinh.pro>
Date:   Thu, 11 May 2023 21:16:19 -0700
Message-ID: <CAMy36z6fiC4esHKjAiOaOp6=sAOCbiJXpJku+6_h26xGPs8kWA@mail.gmail.com>
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

> This doesn't sound like a uapi question, it sounds more like - how do we
> expose C interfaces from Rust?

No, I do mean UAPI, as exposing C interfaces from Rust (to be consumed
by C code) is known. I'm interested in exposing Rust API (from kernel)
to be consumed by user-space Rust code.

> That's a good question. Do we have a sort of reverse-bindgen, that can
> emit a C header file for repr(c) functions?

There is, see https://docs.rust-embedded.org/book/interoperability/rust-with-c.html
which recommends https://github.com/mozilla/cbindgen

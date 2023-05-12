Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F451C7EE22
	for <linux-bcachefs@archiver.kernel.org>; Fri, 12 May 2023 00:03:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238254AbjELADn (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Thu, 11 May 2023 20:03:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229654AbjELADm (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Thu, 11 May 2023 20:03:42 -0400
Received: from mail-yw1-x1130.google.com (mail-yw1-x1130.google.com [IPv6:2607:f8b0:4864:20::1130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC2D686B9;
        Thu, 11 May 2023 17:03:11 -0700 (PDT)
Received: by mail-yw1-x1130.google.com with SMTP id 00721157ae682-55a79671a4dso142417267b3.2;
        Thu, 11 May 2023 17:03:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683849782; x=1686441782;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SoElPhGCyJCLzhpzB0Szm96H1WjKU+M6Vg/gozX8Hpw=;
        b=oNpQ7sIlhjSB3b408dB15+kQmDe+Bhc7XdUN2qakWNJGTJZdAwC+ja2RDoiPPm3jA+
         G0ti/qB1Em3g1+CFTJIT1QAHRny7Ig51dlvFmTjSKBHuKg7HIBvjW4eTn4oGoXLbNzYt
         BvfFlJwzOLkeb/0E1v7Qeh2L8GGaknaZdgEyOaC0Rb0BDeiyGRw7n1yWIoiBYXQvMqaY
         W9gBxIE1H0C/tGTDV710SP/Ts8zsOz+BfPYyS4YA3fzV2AO/4PhOJ3BJoPQ/vsdCkMUg
         dKhBexh2dkWlYyhQv5lOp2cbc8L1j2jE9DRLi5YNk3gouMzJc6xyGDUv6Iyp792q7pQj
         Zj6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683849782; x=1686441782;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SoElPhGCyJCLzhpzB0Szm96H1WjKU+M6Vg/gozX8Hpw=;
        b=Ue4c0kHlwcxMoC8bUeNDEgeeg45r9iZFFE++HDcpCqucTs2tnAVudBlIh4PA+ocH8K
         vHR4Dd8GlPXWqeG1kpbev0rbXMhehqKFBAhw2gQOe4Hmmdb+JLg9V5ytH4CnOG9v2dgk
         fOgyfU8NJ8YXDk5UQOO371hu6TBllucZbtXwDxwW1YPS4Bsz+pB+/uXD99OD7jnBNFja
         8y3HsdzVAXc/uOOXLrTe3SzniSinkPaiKRIiGuK3kc4U9dtMc8/7KoNAjN6haV/jtFJ1
         FwyT/IG1ckGJHZD+mHc87YOBL4h7YzRR3zdhXZ/awccHzFK+NwC6Cdg+JmXAkd7RiybW
         rduQ==
X-Gm-Message-State: AC+VfDxwGC6lftHlkjvTURIC5xWPr2soy3+Hbqc4q/QuPNhIit0i3b3g
        Swr9eEFpeWe9dqPVj4Hhjtc/2dy33pDnNX13mk4=
X-Google-Smtp-Source: ACHHUZ6n80rALcsAeLrSuCndPwVeEkkCkb/bjXB4qcwVXjkQOqjjnS+1d+pscMNOqC9oWcU7fR6h1qGAr2x9o7m1C6A=
X-Received: by 2002:a81:52d2:0:b0:55a:887e:e049 with SMTP id
 g201-20020a8152d2000000b0055a887ee049mr24480458ywb.39.1683849781722; Thu, 11
 May 2023 17:03:01 -0700 (PDT)
MIME-Version: 1.0
References: <20230503065354.19071-1-i@truongsinh.pro> <ZFqHFTMqetbQKtah@moria.home.lan>
 <CAMy36z75N9obj0WM+OFhhnzXAPxqhg8PVY7_x8X6JbQABFnMQw@mail.gmail.com>
 <ZFqM8HOvlVn61VXs@moria.home.lan> <CANeycqq5xCUcjOeOfGAJCH1Tzd01-ALU3uqVJo-BvVX9HOK9wA@mail.gmail.com>
 <CAMy36z5VP_6atrxdOyXSO6G+R36vA8SuaWCDAui3Om3viogPkQ@mail.gmail.com>
 <CAMy36z6+RjgAfEYUxpOhS6vFmTter=cFa2CEorSnKR=qxkft=A@mail.gmail.com>
 <CANiq72nYq5vimbhvfyUj9ejOS487LCQBxkv+7Nt5yYJ2xW_U-A@mail.gmail.com>
 <CAMy36z7iofMAK4GkYaUjW27cSC4sg-QGooj93mTg8SOb0eXxfw@mail.gmail.com>
 <CANiq72kcVS=_07D-KDcb9cVByV886mf50ydqNsMvcrJ1myLOuA@mail.gmail.com> <CAMy36z710P4ZVW0z_Y=ZObLkpP3Jc837B0z4sTGoDUXCH+8MRw@mail.gmail.com>
In-Reply-To: <CAMy36z710P4ZVW0z_Y=ZObLkpP3Jc837B0z4sTGoDUXCH+8MRw@mail.gmail.com>
From:   Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date:   Fri, 12 May 2023 02:02:50 +0200
Message-ID: <CANiq72=_FtgoatJM5KixR4LtyNZiKyZcXjBrGzAxaHp6FHZT0Q@mail.gmail.com>
Subject: Re: [PATCH] chore(util): minimal Rust build example
To:     TruongSinh Tran-Nguyen <i@truongsinh.pro>
Cc:     rust-for-linux@vger.kernel.org,
        Kent Overstreet <kent.overstreet@linux.dev>,
        Wedson Almeida Filho <wedsonaf@gmail.com>,
        linux-bcachefs@vger.kernel.org, Andreas Hindborg <nmi@metaspace.dk>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Fri, May 12, 2023 at 1:54=E2=80=AFAM TruongSinh Tran-Nguyen <i@truongsin=
h.pro> wrote:
>
> Yes I mean UAPI in "native" Rust. If its not provided right now, and
> there is a kernel module written fully in Rust, then is it recommended
> to have it have `repr(c)/[no_mangle]` and use cbindgen to generate
> UAPI in C (linux/*.h)?

We would need to see how to do it when the need comes. Are you
planning to upstream your code soon? Could you please show the Rust
code you need to provide an UAPI for?

Cheers,
Miguel

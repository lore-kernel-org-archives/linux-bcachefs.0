Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A9E3C77B7D
	for <linux-bcachefs@archiver.kernel.org>; Wed, 10 May 2023 17:59:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235962AbjEJR7Q (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Wed, 10 May 2023 13:59:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234152AbjEJR7Q (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Wed, 10 May 2023 13:59:16 -0400
Received: from mail-yw1-x112a.google.com (mail-yw1-x112a.google.com [IPv6:2607:f8b0:4864:20::112a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76F49E50;
        Wed, 10 May 2023 10:59:15 -0700 (PDT)
Received: by mail-yw1-x112a.google.com with SMTP id 00721157ae682-559e2051d05so109514667b3.3;
        Wed, 10 May 2023 10:59:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683741554; x=1686333554;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6nUMd85orgFR76H3L+DKeRG7aaMjIRNwRGwPnOWzt7w=;
        b=fUomTYC9lzYbNB50DD/M+2P420wUV1KC0CRXcOrM/yzCM1+YyQpuwDmTBLUSJ8xdlG
         tOlKgiVmvZGEScFUUlm6MD85/DSQgwtE6R0RlGoMpFo48aPHvq3ImA/6ZFoZAu926h7q
         jS+w1r1PsRca6AwlrLrxAaS9HI3htMj7sMoS7E9ACwcMD/H0xUhF0Gng/uFASECoToOt
         WnqauGEHHA/3UirV3S+IgXIReW8VVt3ZiGTTgjegdrrI52ZFAHCcTviCpAbpmInUhx86
         3EBlJc+zxZ7cXgCqMLHDyeDybTCU28OU4de8VlN5Jm3+Dqn7tproFM9RwzLULGerx2cl
         jDeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683741554; x=1686333554;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6nUMd85orgFR76H3L+DKeRG7aaMjIRNwRGwPnOWzt7w=;
        b=fcp2up8ONOo568b9J5qRhF5ByLwy7j409d7eQEm7cOqVn4GVcQNUMG+gL+cQLF6yka
         IlcGDDWyS1JJuSFXQsGS4Y2tw/o4HCuiae4P7nGSngj+/PI4prIVERQUbs/4ZqFC4e9/
         4PWO1lHweQp0S7+lr2PUOrW8exY3gTwTHG3XXNXAHevO3vUuddLpHWxYRfhix3biAe0A
         fwZc4cz351YQO9D7oLBx9uCCY5/9HC6HRNpv3mL1WkHdCnxzHXC7oHAfzyxgLY+27YGZ
         Dfhfq74bRhXL5bzj+cri5k9uOJsORvIvcjK7blGC6KHeeW2OvQh/dNj7YtpZtHA/GzI3
         QsZw==
X-Gm-Message-State: AC+VfDw940El+ryfUpKeRAYP4nz+Y2afKzdcMQeI296iG76URJFszLyP
        08tb773+B3JWvPKS34+7UeEtvEA89S3qBY03ySc=
X-Google-Smtp-Source: ACHHUZ4cpdBapNcUAPevs1S9V6GAmase1DFuNInV4429pzHPk31Hm+z+8sVf+XWHRdMcj2YL8EIoSTK9mbA1YQatRx4=
X-Received: by 2002:a81:9381:0:b0:55b:22c5:8768 with SMTP id
 k123-20020a819381000000b0055b22c58768mr23580724ywg.24.1683741554643; Wed, 10
 May 2023 10:59:14 -0700 (PDT)
MIME-Version: 1.0
References: <20230503065354.19071-1-i@truongsinh.pro> <ZFqHFTMqetbQKtah@moria.home.lan>
 <CAMy36z75N9obj0WM+OFhhnzXAPxqhg8PVY7_x8X6JbQABFnMQw@mail.gmail.com>
 <ZFqM8HOvlVn61VXs@moria.home.lan> <CANeycqq5xCUcjOeOfGAJCH1Tzd01-ALU3uqVJo-BvVX9HOK9wA@mail.gmail.com>
 <CAMy36z5VP_6atrxdOyXSO6G+R36vA8SuaWCDAui3Om3viogPkQ@mail.gmail.com> <CAMy36z6+RjgAfEYUxpOhS6vFmTter=cFa2CEorSnKR=qxkft=A@mail.gmail.com>
In-Reply-To: <CAMy36z6+RjgAfEYUxpOhS6vFmTter=cFa2CEorSnKR=qxkft=A@mail.gmail.com>
From:   Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date:   Wed, 10 May 2023 19:59:03 +0200
Message-ID: <CANiq72nYq5vimbhvfyUj9ejOS487LCQBxkv+7Nt5yYJ2xW_U-A@mail.gmail.com>
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

On Wed, May 10, 2023 at 5:30=E2=80=AFAM TruongSinh Tran-Nguyen <i@truongsin=
h.pro> wrote:
>
> I have another question. When working on user-space, I'm used to cargo
> dependency management, but I assume it's not possible when doing
> kernel development. Specifically, for the immediately next PR, I need
> to use these 2 crates (and their artifacts)

Please see https://rust-for-linux.com/third-party-crates (I just uploaded i=
t).

Cheers,
Miguel

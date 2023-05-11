Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF258C77B7C
	for <linux-bcachefs@archiver.kernel.org>; Thu, 11 May 2023 23:54:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238053AbjEKXyv (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Thu, 11 May 2023 19:54:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239591AbjEKXyu (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Thu, 11 May 2023 19:54:50 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C10C2D48
        for <linux-bcachefs@vger.kernel.org>; Thu, 11 May 2023 16:54:48 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id ffacd0b85a97d-3078d1c8828so6250447f8f.3
        for <linux-bcachefs@vger.kernel.org>; Thu, 11 May 2023 16:54:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=truongsinh.pro; s=google; t=1683849287; x=1686441287;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dk8onNKHZ+WGWCbbdc+ootAXxNIM8Z6Ni0lIRmMOwpE=;
        b=RifuI2g8FfVu6ydz/12z2od6ialy67lO23Mqp3r3ZhruS/Ja4y9UXr5d1+XIbgKQT7
         mU0PSwD9gHsF7zBzqIOqDmsH2ZtjTo8YlOENtCee5S8qG34qogEWji4v13VhwV19bLX7
         nnVbjvCEvWJKJo336cS2x+LEF0P2x2IDJ8Su4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683849287; x=1686441287;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dk8onNKHZ+WGWCbbdc+ootAXxNIM8Z6Ni0lIRmMOwpE=;
        b=OSF2PYZJscyZUIz86dLxXamAfJHe3+bc6zYcjptY+IfWVxyb8pa8QLYu78+/qLck4m
         EVw/9UQ1WTktW3MDoGWwVvJ/Wopw5fHM1xV4PwkD9cul/IgvWVxJpA8/YgGEani1q+p0
         CLU6d7Xa8GIppaBWSMwwTrKP4JGnXmtYrii/W26biurwKprB7P8wYWZFnKaJQq7xUTtA
         Igv4P28lsdFD/ZUAuSt5X23br0/Hlu30JhwSwAQvU792TSeqaPgWVHvDGHbK0kG+J3mS
         SkKLCd9DdvpFJnMqwW/AdLJf/Vkrp/4Ihp+GXCzir9DGRBJVAHfWLMsjpbFaQQndbbyh
         RMJw==
X-Gm-Message-State: AC+VfDy0q3D2yfbCuagvSSABg2U4vNmTcQGcB0GcV4vpou68LT4QUzZ/
        lolbhEv105ehjR5b7jymT8ihzvMAkhRDwhsoP+h06w==
X-Google-Smtp-Source: ACHHUZ51/SNz7lA4yHPo8G8/ygc7y+IzDQpp0ZDJ9rMDLCZ/GJNb0FcDHe9Rno6FN7bl+vOa32ksdQPYO2+Nu2JjswI=
X-Received: by 2002:adf:e448:0:b0:307:cb94:972f with SMTP id
 t8-20020adfe448000000b00307cb94972fmr2693015wrm.46.1683849286855; Thu, 11 May
 2023 16:54:46 -0700 (PDT)
MIME-Version: 1.0
References: <20230503065354.19071-1-i@truongsinh.pro> <ZFqHFTMqetbQKtah@moria.home.lan>
 <CAMy36z75N9obj0WM+OFhhnzXAPxqhg8PVY7_x8X6JbQABFnMQw@mail.gmail.com>
 <ZFqM8HOvlVn61VXs@moria.home.lan> <CANeycqq5xCUcjOeOfGAJCH1Tzd01-ALU3uqVJo-BvVX9HOK9wA@mail.gmail.com>
 <CAMy36z5VP_6atrxdOyXSO6G+R36vA8SuaWCDAui3Om3viogPkQ@mail.gmail.com>
 <CAMy36z6+RjgAfEYUxpOhS6vFmTter=cFa2CEorSnKR=qxkft=A@mail.gmail.com>
 <CANiq72nYq5vimbhvfyUj9ejOS487LCQBxkv+7Nt5yYJ2xW_U-A@mail.gmail.com>
 <CAMy36z7iofMAK4GkYaUjW27cSC4sg-QGooj93mTg8SOb0eXxfw@mail.gmail.com> <CANiq72kcVS=_07D-KDcb9cVByV886mf50ydqNsMvcrJ1myLOuA@mail.gmail.com>
In-Reply-To: <CANiq72kcVS=_07D-KDcb9cVByV886mf50ydqNsMvcrJ1myLOuA@mail.gmail.com>
From:   TruongSinh Tran-Nguyen <i@truongsinh.pro>
Date:   Thu, 11 May 2023 16:54:34 -0700
Message-ID: <CAMy36z710P4ZVW0z_Y=ZObLkpP3Jc837B0z4sTGoDUXCH+8MRw@mail.gmail.com>
Subject: Re: [PATCH] chore(util): minimal Rust build example
To:     Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Cc:     rust-for-linux@vger.kernel.org,
        Kent Overstreet <kent.overstreet@linux.dev>,
        Wedson Almeida Filho <wedsonaf@gmail.com>,
        linux-bcachefs@vger.kernel.org, Andreas Hindborg <nmi@metaspace.dk>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

> If you mean UAPI in "native" Rust, then we don't provide Rust ones
> yet. We may need to wait until Rust is not an experiment anymore
> within the kernel to do something like that.

Yes I mean UAPI in "native" Rust. If its not provided right now, and
there is a kernel module written fully in Rust, then is it recommended
to have it have `repr(c)/[no_mangle]` and use cbindgen to generate
UAPI in C (linux/*.h)?

Kind regards,
Sinh

TruongSinh Tran-Nguyen, PMI-ACP, PSM III, PSPO III

Tech Visionary, Craftsman, Coach and Investor

+1-6127-TR-SINH (+1-6127-87-7464) | @truongsinhtn

Find me on LinkedIn | Twitter | Github | StackOverflow

IBAN: LT76 3250 0264 6898 1177 | BIC: REVOLT21

Currently Reading

Get your own email signature




On Thu, 11 May 2023 at 16:37, Miguel Ojeda
<miguel.ojeda.sandonis@gmail.com> wrote:
>
> On Wed, May 10, 2023 at 8:21=E2=80=AFPM TruongSinh Tran-Nguyen <i@truongs=
inh.pro> wrote:
> >
> > So I assume there must be PR for these 2 first before I can move
> > forward, is that correct?
>
> I can look into adding those two to the experiment PR, so that you can
> move forward, and so that we can try them out in general (which is the
> purpose of the experiment).
>
> It is not a guarantee that they will land in mainline, but it is a
> first step to determine whether we want them, or whether we want
> something else.
>
> > One more question. Assuming that we have some Linux kernel API
> > exposing Rust interface (similar to `linux/*.h`), when writing
> > user-space tool, how do I `use`/`import` them? I have not been able to
> > find any answer or even good keywords to describe what I mean yet.
>
> If you mean libraries in general that you want to reuse in both
> userspace and the kernel, then I think this is the case that Kent
> wanted (though as far as I remember from Kangrejos, he wanted to share
> the code in crates.io, rather than the kernel tree).
>
> If you mean UAPI in "native" Rust, then we don't provide Rust ones
> yet. We may need to wait until Rust is not an experiment anymore
> within the kernel to do something like that.
>
> Cheers,
> Miguel

Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D924C77B7C
	for <linux-bcachefs@archiver.kernel.org>; Wed, 10 May 2023 17:56:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231874AbjEJR4V (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Wed, 10 May 2023 13:56:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229773AbjEJR4U (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Wed, 10 May 2023 13:56:20 -0400
Received: from mail-yb1-xb36.google.com (mail-yb1-xb36.google.com [IPv6:2607:f8b0:4864:20::b36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D68C30C7;
        Wed, 10 May 2023 10:56:19 -0700 (PDT)
Received: by mail-yb1-xb36.google.com with SMTP id 3f1490d57ef6-b983027d0faso9628854276.0;
        Wed, 10 May 2023 10:56:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683741379; x=1686333379;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LjUvc8WJEyiFXatiCyv7pIOQhKz1NOVRBjUovsin1Q8=;
        b=XIXVlSUj8/JH+6wtOqyE0DIbbNTgZG2mxvrZKueJNdyjoxjz9Nwx1ejPTv+1nu0ebH
         AQITyy0dpQ555RQSFZp8NjPzuH61PMrCjd1kB6S79QyAlWHzzrSwGdAoptuDdIC5T+mW
         2eP2fjuFyRLD/CbJkGTsD8ZXI5VpHR2gAX5fWqntxoPB+PyM4tiiMdY8oW8/2lkerlcP
         eHGMjBpg3xx0/IGNqGRK7v+7p89Di0Ioa1+bDeeDjEUn4td52lc9jr4rTxsMwW7Q8LC5
         Thd+cge5I/YAnD5PfUMEioxqhD6OFlKYQTYUSjlOm8JOXKBJT4I/eqfpQqSVQQPypy1W
         kGtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683741379; x=1686333379;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LjUvc8WJEyiFXatiCyv7pIOQhKz1NOVRBjUovsin1Q8=;
        b=bJuQogKCfK6vP7vsc4W4+mitFUtMVgwp9mjTtYyrDkW43ne4WZtH0PO6rn1BnD2bZQ
         8NxVNeXEW81AxeIgTBrutjs30dRRGkGaz4v+JoUF4W4+AFY3kfWfhwAXFa2n/UwpukCu
         AxJdNzBv/oJKkrCGyxBmSu648dd5xp+sR+4XCxOhqOod49F+1P/hZ7YeeWuXJzG5lNfr
         FJQM6VyozXl4DsvKzF6TaC5kPQRwtkv5o4LYWoa4tUu1DpPg7OcvI0vWv4y0I35MUiY0
         Q0QRfbiPrmkZGDYTJvqUSbSSGWIOrnDYl++oMQynXTOzPjaCgYHgttiYam5KlkvGIYTN
         Halw==
X-Gm-Message-State: AC+VfDycdR0+qzXSp7e0UpkIf4z2HegBxrlpLDl1TiRK5gaXBfS8RR6Q
        akWqB9QfD1VOVxiv1aqZM7zK7ERHRmUwiMhUG99FTr0dRzE=
X-Google-Smtp-Source: ACHHUZ6FxgFFf576tES4dMfhDOx5KiXkZkqcGXRqJcREBXGhvBTe1xPPL1OfOHguZFbA+UpBogk0rLPXiWcBEPiA/eA=
X-Received: by 2002:a25:4284:0:b0:b8f:490c:a0db with SMTP id
 p126-20020a254284000000b00b8f490ca0dbmr19847658yba.59.1683741378735; Wed, 10
 May 2023 10:56:18 -0700 (PDT)
MIME-Version: 1.0
References: <20230503065354.19071-1-i@truongsinh.pro> <ZFqHFTMqetbQKtah@moria.home.lan>
In-Reply-To: <ZFqHFTMqetbQKtah@moria.home.lan>
From:   Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date:   Wed, 10 May 2023 19:56:07 +0200
Message-ID: <CANiq72mwHa9coRUQqprGaEhLoac=spX2-2X4CMKYBYrovkQoLA@mail.gmail.com>
Subject: Re: [PATCH] chore(util): minimal Rust build example
To:     Kent Overstreet <kent.overstreet@linux.dev>
Cc:     TruongSinh Tran-Nguyen <i@truongsinh.pro>,
        linux-bcachefs@vger.kernel.org, rust-for-linux@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Tue, May 9, 2023 at 8:07=E2=80=AFPM Kent Overstreet
<kent.overstreet@linux.dev> wrote:
>
> So if I'm following, it looks like everything is basically there. It
> looks like we can add Rust source files to fs/bcachefs/ and have them
> built as part of the bcachefs module, and calling back and forth just
> works as expected - nice.

Indeed, that should work, and it may be useful, though typically you
will want to avoid crossing the C/Rust boundary all the time, so that
you can work with Rust types as much as possible.

For modules/drivers, we provide Rust abstractions for the C APIs so
that one can write drivers in Rust (and thus use Rust facilities and
avoid `unsafe` as much as possible), rather than mixing C and Rust
source code in the "leaves". Perhaps there are some parts within
bcachefs amenable to a similar approach.

> The kbuild stuff looks nice and clean - congrats to those responsible :)

Thanks for the kind words, though a rework of how that works is
planned, so hopefully you will also like the new way too... :)

Cheers,
Miguel

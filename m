Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C650AC77B7F
	for <linux-bcachefs@archiver.kernel.org>; Thu, 11 May 2023 23:37:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239376AbjEKXhe (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Thu, 11 May 2023 19:37:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239603AbjEKXhd (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Thu, 11 May 2023 19:37:33 -0400
Received: from mail-yb1-xb31.google.com (mail-yb1-xb31.google.com [IPv6:2607:f8b0:4864:20::b31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5CA065A4;
        Thu, 11 May 2023 16:37:17 -0700 (PDT)
Received: by mail-yb1-xb31.google.com with SMTP id 3f1490d57ef6-b9e27684b53so8217058276.0;
        Thu, 11 May 2023 16:37:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683848237; x=1686440237;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9H5YdbIWZFqJl3g2DhFPx7dOoR6U2lKiK0qlGLm9dxc=;
        b=piQONAc8qKKNZvBv6XyMYM1NJPNojA+25xCA1vEacDO4ZRa0gop0djs6eCyMv/BtAo
         RSauY9YIDGFMKahyB3NIUTWRL2yQI7IsNkG5ppcGHureNucB39EYWKYBE140jxpf6X1p
         iLsvWiKobro90axLXz70BIMmFpDLq/d90N/pWgN/0NVMdXjsQrE97aPFLPgq7/oY6hV8
         hBhy6PgY9cX8i8Ee8qBi26MZEWJ5hrVKt1QiytOBOSSlwH+3tvYWwNdQQnl8PPjXTeyc
         R31N1/o5+C8Zr0BEPD7YpU6wwwVsoQSLOpf93xqzC6or082nLLdRZ0FZ4ofFf6E5uy7I
         nO3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683848237; x=1686440237;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9H5YdbIWZFqJl3g2DhFPx7dOoR6U2lKiK0qlGLm9dxc=;
        b=dOCsYtYYgpscOBrYm9s3HjPu3Wq2lbaQzRUL136QmYK8nEpbMektR+kwQVxcd2VEsd
         1T1Wx+whnc0NjU9OWONsK1ZnhEHxeIKrp1auQr0/+ApT4zWSuWxCqrTxRGbeIq+WhZgT
         AS7J5D7um7eDC/W4TaeYdmkuEwpiRfrV4z6GmOqQMiB7ESopDLveiEmuJEesYgaSdO8x
         YSua3coZaoo1QOYJ0JVrntCPqej+WbNyE6P7Nyl38UiSNNlLUDQEcfS4uUXGXXGjnDbw
         KVTugNlUVXjst1Q+CSY/mWb48DyZ0JNChv6j9WxGclgwJe9O8EafsfurIbaKDCxI1MQm
         FEQg==
X-Gm-Message-State: AC+VfDxPTJE8O5TDfzjUFMlzbD9D3VaEr8AF6h4+KpXEOig8IJgqn/m6
        chqyWAYQKMT2Ws5tFqZNqQLM05kahN0wqAaPz4I=
X-Google-Smtp-Source: ACHHUZ44fq/Dd7mOX067Ofowd5nKlYvjVfBd1RVKhjZJhfuoUYHuilaBf9WYiq/ULoRuiKXrlSMIF5HXwJsBSE7UJoY=
X-Received: by 2002:a25:ce42:0:b0:ba1:d0ca:9189 with SMTP id
 x63-20020a25ce42000000b00ba1d0ca9189mr20421056ybe.53.1683848236731; Thu, 11
 May 2023 16:37:16 -0700 (PDT)
MIME-Version: 1.0
References: <20230503065354.19071-1-i@truongsinh.pro> <ZFqHFTMqetbQKtah@moria.home.lan>
 <CAMy36z75N9obj0WM+OFhhnzXAPxqhg8PVY7_x8X6JbQABFnMQw@mail.gmail.com>
 <ZFqM8HOvlVn61VXs@moria.home.lan> <CANeycqq5xCUcjOeOfGAJCH1Tzd01-ALU3uqVJo-BvVX9HOK9wA@mail.gmail.com>
 <CAMy36z5VP_6atrxdOyXSO6G+R36vA8SuaWCDAui3Om3viogPkQ@mail.gmail.com>
 <CAMy36z6+RjgAfEYUxpOhS6vFmTter=cFa2CEorSnKR=qxkft=A@mail.gmail.com>
 <CANiq72nYq5vimbhvfyUj9ejOS487LCQBxkv+7Nt5yYJ2xW_U-A@mail.gmail.com> <CAMy36z7iofMAK4GkYaUjW27cSC4sg-QGooj93mTg8SOb0eXxfw@mail.gmail.com>
In-Reply-To: <CAMy36z7iofMAK4GkYaUjW27cSC4sg-QGooj93mTg8SOb0eXxfw@mail.gmail.com>
From:   Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date:   Fri, 12 May 2023 01:37:05 +0200
Message-ID: <CANiq72kcVS=_07D-KDcb9cVByV886mf50ydqNsMvcrJ1myLOuA@mail.gmail.com>
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

On Wed, May 10, 2023 at 8:21=E2=80=AFPM TruongSinh Tran-Nguyen <i@truongsin=
h.pro> wrote:
>
> So I assume there must be PR for these 2 first before I can move
> forward, is that correct?

I can look into adding those two to the experiment PR, so that you can
move forward, and so that we can try them out in general (which is the
purpose of the experiment).

It is not a guarantee that they will land in mainline, but it is a
first step to determine whether we want them, or whether we want
something else.

> One more question. Assuming that we have some Linux kernel API
> exposing Rust interface (similar to `linux/*.h`), when writing
> user-space tool, how do I `use`/`import` them? I have not been able to
> find any answer or even good keywords to describe what I mean yet.

If you mean libraries in general that you want to reuse in both
userspace and the kernel, then I think this is the case that Kent
wanted (though as far as I remember from Kangrejos, he wanted to share
the code in crates.io, rather than the kernel tree).

If you mean UAPI in "native" Rust, then we don't provide Rust ones
yet. We may need to wait until Rust is not an experiment anymore
within the kernel to do something like that.

Cheers,
Miguel

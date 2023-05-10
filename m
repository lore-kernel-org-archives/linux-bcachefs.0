Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2782AC7EE22
	for <linux-bcachefs@archiver.kernel.org>; Wed, 10 May 2023 18:23:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236270AbjEJSXD (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Wed, 10 May 2023 14:23:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236347AbjEJSWv (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Wed, 10 May 2023 14:22:51 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A48C65FEF
        for <linux-bcachefs@vger.kernel.org>; Wed, 10 May 2023 11:22:28 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id ffacd0b85a97d-307a8386946so1625419f8f.2
        for <linux-bcachefs@vger.kernel.org>; Wed, 10 May 2023 11:22:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=truongsinh.pro; s=google; t=1683742889; x=1686334889;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NoWT/RU+1eRLJA5vsDNRU5hfWv9A5DPTjFIviPl/fc4=;
        b=XacdVqRfgs0nhhAabk8hjsACe4m6K2nvVoGdQZewISqNXG8BuaJgwHeJmMjjnF0maP
         OVFntbxmt1toafAT20Jq8FcyBJfoqRBCj/wUf1UJY770ZB8bzXHS3P18E3guRjlqGCIb
         EKPz2f0s8PxjTFcGT5yxbdUZdVA3pM/LfjwHc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683742889; x=1686334889;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NoWT/RU+1eRLJA5vsDNRU5hfWv9A5DPTjFIviPl/fc4=;
        b=EiLe2tNNGR2n1Wstt86/FmTcVQDJ9bopOxLlzGz1E0DMoP1cEK1QfWg5bZJfqk2kL9
         ojZmj7HnkdMWU/vJF6mf3W8GXKmOR1XUP4kb4Mp82RN/BP++N6yKff4FDX/6JaCyGWFj
         K6M22/ISl85IcxByxepfLJ9knlj8GQcb2RX81VMKRt6UsHuf0YPIJDTLwupLM2732YeB
         JbHhWouRhcBxSbEasIJHZ2asmZ64rQTaMHTzjGgPFPTzkB0/B9T1LY5hSvmdN/S883wF
         WbOWcubcHFSvoBAFl1pIMlUAEE8sUG5KOzVZgzll83DpI3JLzLatlYOCOp1W2nKX9I+E
         rWxw==
X-Gm-Message-State: AC+VfDxRmsLTFprc71+l5e5mCS0bcNsNJ+egEEhiJqOjXnsd360TCEYe
        ONokT+db1VmTAYax5/mJWPQFDIm6t1gBU+HqzNMY7g==
X-Google-Smtp-Source: ACHHUZ6ZtM3vQ9oAWCUOZpy8JdNzGxVouHt8UXX1Pw/NvVSzW7w+R9sjZXsr3xPOyxwN/wLaqrjNH3oRjJrcTBThJVc=
X-Received: by 2002:a5d:6684:0:b0:2dc:c0da:409 with SMTP id
 l4-20020a5d6684000000b002dcc0da0409mr13083786wru.27.1683742888573; Wed, 10
 May 2023 11:21:28 -0700 (PDT)
MIME-Version: 1.0
References: <20230503065354.19071-1-i@truongsinh.pro> <ZFqHFTMqetbQKtah@moria.home.lan>
 <CAMy36z75N9obj0WM+OFhhnzXAPxqhg8PVY7_x8X6JbQABFnMQw@mail.gmail.com>
 <ZFqM8HOvlVn61VXs@moria.home.lan> <CANeycqq5xCUcjOeOfGAJCH1Tzd01-ALU3uqVJo-BvVX9HOK9wA@mail.gmail.com>
 <CAMy36z5VP_6atrxdOyXSO6G+R36vA8SuaWCDAui3Om3viogPkQ@mail.gmail.com>
 <CAMy36z6+RjgAfEYUxpOhS6vFmTter=cFa2CEorSnKR=qxkft=A@mail.gmail.com> <CANiq72nYq5vimbhvfyUj9ejOS487LCQBxkv+7Nt5yYJ2xW_U-A@mail.gmail.com>
In-Reply-To: <CANiq72nYq5vimbhvfyUj9ejOS487LCQBxkv+7Nt5yYJ2xW_U-A@mail.gmail.com>
From:   TruongSinh Tran-Nguyen <i@truongsinh.pro>
Date:   Wed, 10 May 2023 11:21:17 -0700
Message-ID: <CAMy36z7iofMAK4GkYaUjW27cSC4sg-QGooj93mTg8SOb0eXxfw@mail.gmail.com>
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

Thanks, Miguel,

I just read through it, and it makes sense. I did expect this to be
the case, so the problem would go back to our needs of wrapper or
re-written of  https://docs.kernel.org/core-api/packing.html# (for
bitfield::bitfield macro) and
https://man7.org/linux/man-pages/man3/htons.3.html for byteorder
utility. I cannot find them anywhere in:

- https://rust-for-linux.github.io/docs/macros/all.html?search=3Dbitfield
- https://rust-for-linux.github.io/docs/macros/all.html?search=3Dbyteorder

So I assume there must be PR for these 2 first before I can move
forward, is that correct?

One more question. Assuming that we have some Linux kernel API
exposing Rust interface (similar to `linux/*.h`), when writing
user-space tool, how do I `use`/`import` them? I have not been able to
find any answer or even good keywords to describe what I mean yet.

Kind regards,
Sinh

TruongSinh Tran-Nguyen, PMI-ACP, PSM III, PSPO III

Tech Visionary, Craftsman, Coach and Investor

+1-6127-TR-SINH (+1-6127-87-7464) | @truongsinhtn

Find me on LinkedIn | Twitter | Github | StackOverflow

IBAN: LT76 3250 0264 6898 1177 | BIC: REVOLT21

Currently Reading

Get your own email signature

Kind regards,
Sinh

TruongSinh Tran-Nguyen, PMI-ACP, PSM III, PSPO III

Tech Visionary, Craftsman, Coach and Investor

+1-6127-TR-SINH (+1-6127-87-7464) | @truongsinhtn

Find me on LinkedIn | Twitter | Github | StackOverflow

IBAN: LT76 3250 0264 6898 1177 | BIC: REVOLT21

Currently Reading

Get your own email signature




On Wed, 10 May 2023 at 10:59, Miguel Ojeda
<miguel.ojeda.sandonis@gmail.com> wrote:
>
> On Wed, May 10, 2023 at 5:30=E2=80=AFAM TruongSinh Tran-Nguyen <i@truongs=
inh.pro> wrote:
> >
> > I have another question. When working on user-space, I'm used to cargo
> > dependency management, but I assume it's not possible when doing
> > kernel development. Specifically, for the immediately next PR, I need
> > to use these 2 crates (and their artifacts)
>
> Please see https://rust-for-linux.com/third-party-crates (I just uploaded=
 it).
>
> Cheers,
> Miguel

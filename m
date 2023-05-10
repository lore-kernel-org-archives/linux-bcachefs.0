Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9ADF1C77B7C
	for <linux-bcachefs@archiver.kernel.org>; Wed, 10 May 2023 03:12:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235669AbjEJDMI (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Tue, 9 May 2023 23:12:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235566AbjEJDLE (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Tue, 9 May 2023 23:11:04 -0400
Received: from mail-lj1-x233.google.com (mail-lj1-x233.google.com [IPv6:2a00:1450:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42D73658D
        for <linux-bcachefs@vger.kernel.org>; Tue,  9 May 2023 20:10:24 -0700 (PDT)
Received: by mail-lj1-x233.google.com with SMTP id 38308e7fff4ca-2ac8091351eso71998041fa.2
        for <linux-bcachefs@vger.kernel.org>; Tue, 09 May 2023 20:10:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=truongsinh.pro; s=google; t=1683688222; x=1686280222;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=4hQx4VSLc0JdiSwJJQsEBsxExDPNPoHDMjGVltWKgZA=;
        b=DH7yTIDhNu4WlRqV+FvGocLqthO26c+ibS3Ec+TD+Hc2KuhJzNCcdYsxBvUabeUlra
         atzA3yDcak1rkRUilvM+sok6xbQFivTT/IaDDunOTWaaoHgjZCHBWYUFTIV7XHPcHvLI
         gHZvbC9Lz7apsxYCNYPmr91tXE3veJu3ZuiMU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683688222; x=1686280222;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4hQx4VSLc0JdiSwJJQsEBsxExDPNPoHDMjGVltWKgZA=;
        b=WKauktpnQNfEDawdYdmKeosXRa6yI6wTIABx5hlV1pS91AIbIhl9HYV3inH3aqyjPC
         Gz+0hKFNR4U2VzG079b6Fr9D7jSk0nwhJ/Q+zPuwT86uGWfl7SJ1AC+J2+yXwU+xAFN5
         Rz0KG/ES4XJ/dTzNWVMc316nn7KyPaQ1xW0U6GDT2/jESa43UGbP150KtCeor0DjmbOk
         NmpBb4cfauMaOmcwyCSQYsHchMrgmrgacwV2PkxFCVRNY2KQL14M581blUpCowgNNrtK
         6PG4hqqqo2Xs9NhbSCxc7T0wXUn4As2xG3yRxZe4Q0LtH2lzDyBBJycdCg7EnsURZPv3
         lSjA==
X-Gm-Message-State: AC+VfDyLobKj207XdT68lNfSJz8lK/S1FrqQQCWYssdDLgcDyK6We5Gb
        W6hDZRdZ+8YKGIeMbPNCjYZxjg+gVkwPoF5ncucPNw==
X-Google-Smtp-Source: ACHHUZ5PHa7wy/ffUzJ7UIQvrNCIXoWRUWCGgYneQd9g2YNOvWsnYjl9wh7oixK35hS7d8p/Y2rGdi2Ly7p6fQRykns=
X-Received: by 2002:a2e:9355:0:b0:2a7:6e37:ee68 with SMTP id
 m21-20020a2e9355000000b002a76e37ee68mr1334947ljh.12.1683688222228; Tue, 09
 May 2023 20:10:22 -0700 (PDT)
MIME-Version: 1.0
References: <20230503065354.19071-1-i@truongsinh.pro> <ZFqHFTMqetbQKtah@moria.home.lan>
 <CAMy36z75N9obj0WM+OFhhnzXAPxqhg8PVY7_x8X6JbQABFnMQw@mail.gmail.com>
 <ZFqM8HOvlVn61VXs@moria.home.lan> <CANeycqq5xCUcjOeOfGAJCH1Tzd01-ALU3uqVJo-BvVX9HOK9wA@mail.gmail.com>
 <CAMy36z5VP_6atrxdOyXSO6G+R36vA8SuaWCDAui3Om3viogPkQ@mail.gmail.com>
In-Reply-To: <CAMy36z5VP_6atrxdOyXSO6G+R36vA8SuaWCDAui3Om3viogPkQ@mail.gmail.com>
From:   TruongSinh Tran-Nguyen <i@truongsinh.pro>
Date:   Tue, 9 May 2023 20:10:09 -0700
Message-ID: <CAMy36z6+RjgAfEYUxpOhS6vFmTter=cFa2CEorSnKR=qxkft=A@mail.gmail.com>
Subject: Re: [PATCH] chore(util): minimal Rust build example
To:     rust-for-linux@vger.kernel.org
Cc:     Kent Overstreet <kent.overstreet@linux.dev>,
        Wedson Almeida Filho <wedsonaf@gmail.com>,
        linux-bcachefs@vger.kernel.org, Andreas Hindborg <nmi@metaspace.dk>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

Hi Rust for Linux folks,

I have another question. When working on user-space, I'm used to cargo
dependency management, but I assume it's not possible when doing
kernel development. Specifically, for the immediately next PR, I need
to use these 2 crates (and their artifacts)

`
use bitfield::bitfield;
use byteorder::{LittleEndian, ReadBytesExt};
`

Is there something similar in Rust part of kernel already
(https://docs.kernel.org/core-api/packing.html# and
https://man7.org/linux/man-pages/man3/htons.3.html respectively, may
be) ? Or if not, is it normal to just copy-paste the needed code
together our code?

Kind regards,
Sinh

TruongSinh Tran-Nguyen, PMI-ACP, PSM III, PSPO III

Tech Visionary, Craftsman, Coach and Investor

+1-6127-TR-SINH (+1-6127-87-7464) | @truongsinhtn

Find me on LinkedIn | Twitter | Github | StackOverflow

IBAN: LT76 3250 0264 6898 1177 | BIC: REVOLT21

Currently Reading

Get your own email signature




On Tue, 9 May 2023 at 13:57, TruongSinh Tran-Nguyen <i@truongsinh.pro> wrote:
>
> Wonderful, thanks!
>
>
>
> On Tue, 9 May 2023 at 11:42, Wedson Almeida Filho <wedsonaf@gmail.com> wrote:
> >
> > On Tue, 9 May 2023 at 15:13, Kent Overstreet <kent.overstreet@linux.dev> wrote:
> > >
> > > On Tue, May 09, 2023 at 10:57:18AM -0700, TruongSinh Tran-Nguyen wrote:
> > > > On Tue, 9 May 2023 at 10:47, Kent Overstreet <kent.overstreet@linux.dev> wrote:
> > > >
> > > > > We pretty heavily use to_text() functions kernel side; these output to
> > > > > printbufs, and in Rust they map nicely to the Display trait - do we have
> > > > > that available in the kernel or is that in std?
> > > > >
> > > >
> > > > https://doc.rust-lang.org/std/fmt/trait.Display.html Display trait is definitely
> > > > in Rust `std`. As for the alternative from kernel, I am still searching.
> > > > Worst case, there is nothing right now, Rust-for-linux folks would
> > > > happy to take PR
> > > > to include it.
> > >
> > > I included them on the CC, maybe they'll have something to say.
> >
> > `Display` is in core: https://doc.rust-lang.org/core/fmt/trait.Display.html
> >
> > Here's an example of it being implemented (and used) in the kernel:
> > https://elixir.bootlin.com/linux/v6.4-rc1/source/rust/kernel/sync/arc.rs#L604
> >
> > >
> > > >
> > > > > Sounds like that would be a welcome cleanup :)
> > > >
> > > > By clean up, do you mean moving from `uuid_le` to `uuid_t`?
> > > >
> > > > Also, I don't expect this PR to be merge, as it is for demonstration
> > > > purposes only,
> > > > however, what would be a minimum mergeable PR (related to Rust build)
> > > > that you would consider?
> > >
> > > First thing to look at is going to be moving all the code under
> > > bch_bindgen in -tools into the kernel tree...

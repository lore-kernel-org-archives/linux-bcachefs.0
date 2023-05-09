Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA750C77B7C
	for <linux-bcachefs@archiver.kernel.org>; Tue,  9 May 2023 18:42:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233108AbjEISmG (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Tue, 9 May 2023 14:42:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234771AbjEISmF (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Tue, 9 May 2023 14:42:05 -0400
Received: from mail-yb1-xb2f.google.com (mail-yb1-xb2f.google.com [IPv6:2607:f8b0:4864:20::b2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B54A33C20;
        Tue,  9 May 2023 11:42:02 -0700 (PDT)
Received: by mail-yb1-xb2f.google.com with SMTP id 3f1490d57ef6-b9d8730fe5aso8251543276.1;
        Tue, 09 May 2023 11:42:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683657722; x=1686249722;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=8HastUPGLOFmtjkwswFSuxjmF1966hBsfmctid9rJhg=;
        b=mhlHga3VYCMCEX1yT5aT3VdySL0YlQ0yKlmD9+c5ZWsMyKZGivcNlm4W2aJwSKt48B
         mPW6X/bio69ojt83G96lWyYhF4Z1YX0B48tJUbJC8UOLXrkCLnB57EAbk7e8WeJy0cEo
         oeMrPW+GjHJUjcGqWX+gy3qApO9veO2tChCWWQHNH/mD6b3zOeuS73Km2Gz+ec0Nc470
         8hKjQ6RH6a+lXes6y/w7gAliS79BDwxK+K4Uc1ut6g8TrYc21zAK+wKvYBJgNmSJOHnX
         j8fZsm1O2XrLfTm2RuWGiRCgjpMau862eldsoUzlXW03/4lDnoWJ05CazmimhYzMSUSt
         zmkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683657722; x=1686249722;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8HastUPGLOFmtjkwswFSuxjmF1966hBsfmctid9rJhg=;
        b=Q90OS9MgsQAWYZ3EqjzDKyYhU/XO8YfTWlGLMFiwIDC2Bf9CkZpt2bzFpyfZ3MH4Vt
         yKU77ZfSlF3psYh4oESW486Z6/EXKVdLDQN5RW11DrJaIjXxiF/8SfNa6JK+9qTXLsUS
         LBh+IqkMaRNj1Lr2j0rJtEHVr0m4BNpgfl7O889zxoCOASV7CATgpmPrsrL98HKqgBGY
         FtolueRh9idVlxywNqT8iTEMhJkeISZerjUe0iyHW1FNz/2pwzku6vJ8Ue+fJ6NFF+0T
         6QeX0GQWeBUZzAOCE8QcB+U5l+/hMqgFlakd1nmu3uUAPn8dTTxEo5aFzrgM62IRrEtu
         6a1w==
X-Gm-Message-State: AC+VfDzmJrgzYfSuq7AevES7bHXLrGLuXoWpfPJBR2edkJGQ00YMuNRY
        SpO0wlNPmgofwoxDuTYyxXNqvvw0hTWfWlo5mmnZyGBxRkK27g==
X-Google-Smtp-Source: ACHHUZ4Uei0qK/cstulxbN5c8xxPvDRiF+z05PRnMCgiRVwXVB4C6nSqWz17fNdeW/7eHdhiiQIi/fSZ0D+NuhomKZA=
X-Received: by 2002:a25:e602:0:b0:b9e:7589:62fc with SMTP id
 d2-20020a25e602000000b00b9e758962fcmr15000204ybh.28.1683657721802; Tue, 09
 May 2023 11:42:01 -0700 (PDT)
MIME-Version: 1.0
References: <20230503065354.19071-1-i@truongsinh.pro> <ZFqHFTMqetbQKtah@moria.home.lan>
 <CAMy36z75N9obj0WM+OFhhnzXAPxqhg8PVY7_x8X6JbQABFnMQw@mail.gmail.com> <ZFqM8HOvlVn61VXs@moria.home.lan>
In-Reply-To: <ZFqM8HOvlVn61VXs@moria.home.lan>
From:   Wedson Almeida Filho <wedsonaf@gmail.com>
Date:   Tue, 9 May 2023 15:41:52 -0300
Message-ID: <CANeycqq5xCUcjOeOfGAJCH1Tzd01-ALU3uqVJo-BvVX9HOK9wA@mail.gmail.com>
Subject: Re: [PATCH] chore(util): minimal Rust build example
To:     Kent Overstreet <kent.overstreet@linux.dev>
Cc:     TruongSinh Tran-Nguyen <i@truongsinh.pro>,
        linux-bcachefs@vger.kernel.org, rust-for-linux@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Tue, 9 May 2023 at 15:13, Kent Overstreet <kent.overstreet@linux.dev> wrote:
>
> On Tue, May 09, 2023 at 10:57:18AM -0700, TruongSinh Tran-Nguyen wrote:
> > On Tue, 9 May 2023 at 10:47, Kent Overstreet <kent.overstreet@linux.dev> wrote:
> >
> > > We pretty heavily use to_text() functions kernel side; these output to
> > > printbufs, and in Rust they map nicely to the Display trait - do we have
> > > that available in the kernel or is that in std?
> > >
> >
> > https://doc.rust-lang.org/std/fmt/trait.Display.html Display trait is definitely
> > in Rust `std`. As for the alternative from kernel, I am still searching.
> > Worst case, there is nothing right now, Rust-for-linux folks would
> > happy to take PR
> > to include it.
>
> I included them on the CC, maybe they'll have something to say.

`Display` is in core: https://doc.rust-lang.org/core/fmt/trait.Display.html

Here's an example of it being implemented (and used) in the kernel:
https://elixir.bootlin.com/linux/v6.4-rc1/source/rust/kernel/sync/arc.rs#L604

>
> >
> > > Sounds like that would be a welcome cleanup :)
> >
> > By clean up, do you mean moving from `uuid_le` to `uuid_t`?
> >
> > Also, I don't expect this PR to be merge, as it is for demonstration
> > purposes only,
> > however, what would be a minimum mergeable PR (related to Rust build)
> > that you would consider?
>
> First thing to look at is going to be moving all the code under
> bch_bindgen in -tools into the kernel tree...

Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56720C7EE22
	for <linux-bcachefs@archiver.kernel.org>; Tue,  9 May 2023 20:59:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230284AbjEIU67 (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Tue, 9 May 2023 16:58:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235067AbjEIU66 (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Tue, 9 May 2023 16:58:58 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E26495592
        for <linux-bcachefs@vger.kernel.org>; Tue,  9 May 2023 13:58:18 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id ffacd0b85a97d-2fe3fb8e25fso4218112f8f.0
        for <linux-bcachefs@vger.kernel.org>; Tue, 09 May 2023 13:58:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=truongsinh.pro; s=google; t=1683665837; x=1686257837;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=mb9So3otA4hLlWEMptdzwozlRrz9OeZFROhk8yc0hJM=;
        b=N7zmgFZLgsUCSTkUBJESujfSh/mvDcVtPdy2C77WtIIIT7+w/nQuGkb6WgNUSnu57L
         n9yEt6tJZ9Ahr/FC1ev/6tclfk6J7CtpS/1Z8UVuqnn5FShgzplRMGL+twwPRKwtV/Z9
         urb9+Vel1tnT2TV+w2q9bTU8VSGEa1mrMVThc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683665837; x=1686257837;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mb9So3otA4hLlWEMptdzwozlRrz9OeZFROhk8yc0hJM=;
        b=QZ1iLchNxOZ9VJfwqWP3RaanOPpXIM2cc1G5GhaGbkTYTe1ULtLZsSkl9bij57LqYe
         opqiqVSXeXNThY+V5sL5dlXVj2Jl0kGc0CB76aS3BLs4IZuwBYN+ntZ/fASwe5Kr6hNT
         Ne72+RwY+nBDkQDY8bDxWo6wD1cRqpMIwqq2+2/ORtTqPvDAdqj9untDQnnZvyG/bTRb
         AHm8gvNcYh8wM/J3pJ9wxCVrNXxKoulVvvhPKc/LygkrYIJZBxuKP0vzv/PLW+/iShdF
         lSsuMNwv84JNHRrvSEpFBbqWNIZ1WhgEIMBKVP8qJa15o9f9TkqUb706hP3Tkza7gL/d
         P6XQ==
X-Gm-Message-State: AC+VfDxYuP+z/S4LvCh6fFAj+2SSAo9ks2532s9hfSK2vrqS5YiJmxMs
        Z5Nk1LHbC8VM2crlMIz2BPGyXukbxKuVdAZ9teBnIg==
X-Google-Smtp-Source: ACHHUZ4SxaqWLv9nl6gkBuVDjaZRVBcnZTFhq/L9SzIsg0t0avy297VSPgyxD1/c2RbGavlUcGIireeBntf6dLRrODc=
X-Received: by 2002:a5d:5286:0:b0:2cf:ee9d:ce2f with SMTP id
 c6-20020a5d5286000000b002cfee9dce2fmr10821278wrv.19.1683665836764; Tue, 09
 May 2023 13:57:16 -0700 (PDT)
MIME-Version: 1.0
References: <20230503065354.19071-1-i@truongsinh.pro> <ZFqHFTMqetbQKtah@moria.home.lan>
 <CAMy36z75N9obj0WM+OFhhnzXAPxqhg8PVY7_x8X6JbQABFnMQw@mail.gmail.com>
 <ZFqM8HOvlVn61VXs@moria.home.lan> <CANeycqq5xCUcjOeOfGAJCH1Tzd01-ALU3uqVJo-BvVX9HOK9wA@mail.gmail.com>
In-Reply-To: <CANeycqq5xCUcjOeOfGAJCH1Tzd01-ALU3uqVJo-BvVX9HOK9wA@mail.gmail.com>
From:   TruongSinh Tran-Nguyen <i@truongsinh.pro>
Date:   Tue, 9 May 2023 13:57:04 -0700
Message-ID: <CAMy36z5VP_6atrxdOyXSO6G+R36vA8SuaWCDAui3Om3viogPkQ@mail.gmail.com>
Subject: Re: [PATCH] chore(util): minimal Rust build example
To:     Wedson Almeida Filho <wedsonaf@gmail.com>
Cc:     Kent Overstreet <kent.overstreet@linux.dev>,
        linux-bcachefs@vger.kernel.org, rust-for-linux@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

Wonderful, thanks!



On Tue, 9 May 2023 at 11:42, Wedson Almeida Filho <wedsonaf@gmail.com> wrote:
>
> On Tue, 9 May 2023 at 15:13, Kent Overstreet <kent.overstreet@linux.dev> wrote:
> >
> > On Tue, May 09, 2023 at 10:57:18AM -0700, TruongSinh Tran-Nguyen wrote:
> > > On Tue, 9 May 2023 at 10:47, Kent Overstreet <kent.overstreet@linux.dev> wrote:
> > >
> > > > We pretty heavily use to_text() functions kernel side; these output to
> > > > printbufs, and in Rust they map nicely to the Display trait - do we have
> > > > that available in the kernel or is that in std?
> > > >
> > >
> > > https://doc.rust-lang.org/std/fmt/trait.Display.html Display trait is definitely
> > > in Rust `std`. As for the alternative from kernel, I am still searching.
> > > Worst case, there is nothing right now, Rust-for-linux folks would
> > > happy to take PR
> > > to include it.
> >
> > I included them on the CC, maybe they'll have something to say.
>
> `Display` is in core: https://doc.rust-lang.org/core/fmt/trait.Display.html
>
> Here's an example of it being implemented (and used) in the kernel:
> https://elixir.bootlin.com/linux/v6.4-rc1/source/rust/kernel/sync/arc.rs#L604
>
> >
> > >
> > > > Sounds like that would be a welcome cleanup :)
> > >
> > > By clean up, do you mean moving from `uuid_le` to `uuid_t`?
> > >
> > > Also, I don't expect this PR to be merge, as it is for demonstration
> > > purposes only,
> > > however, what would be a minimum mergeable PR (related to Rust build)
> > > that you would consider?
> >
> > First thing to look at is going to be moving all the code under
> > bch_bindgen in -tools into the kernel tree...

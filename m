Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6AF03C7EE23
	for <linux-bcachefs@archiver.kernel.org>; Thu, 11 May 2023 16:46:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238561AbjEKQqk (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Thu, 11 May 2023 12:46:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238633AbjEKQqi (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Thu, 11 May 2023 12:46:38 -0400
Received: from mail-lj1-x233.google.com (mail-lj1-x233.google.com [IPv6:2a00:1450:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 601035592
        for <linux-bcachefs@vger.kernel.org>; Thu, 11 May 2023 09:46:30 -0700 (PDT)
Received: by mail-lj1-x233.google.com with SMTP id 38308e7fff4ca-2ac80da3443so97759551fa.0
        for <linux-bcachefs@vger.kernel.org>; Thu, 11 May 2023 09:46:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=truongsinh.pro; s=google; t=1683823588; x=1686415588;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vZSXAeoJU0lqI5suPmhharDZ73A3nJBhiLQQU59+tms=;
        b=FF2+cEQmGM+haabG2XCXOCa5IxTnFtwywXKIxRI3QSkKvS/JWi8VpImYzOfkzouwJf
         GPkG/uAVN3GcYjtSqFBLmPR0MXDYOA2sp8bnRK5t/Y1IIuej3rUoxt/jl2HNHgsOcD5k
         hGAY9YxajIA7t71SKagj/sBnB8BaKLngglqcI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683823588; x=1686415588;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vZSXAeoJU0lqI5suPmhharDZ73A3nJBhiLQQU59+tms=;
        b=Sp+mjRuXQZ5tC7jv98eU7kVc8jZBLnzlCPQtw8d9Dg6p69/ZTHJaqBLBTtiBpwKMkc
         gXTXjfh8PHDYXw9lrl93GvI++EteJcWZuf0QZhIEpoHcMmt03z6lbaz8DbvGbTWy5b2W
         biXDXKbFMESircWjJuj+rsYTLAvnHdeTpUSugemdsV2OEAN//8KB6FCTNKz26EpHGJ13
         BOd/nz1lpU/2GoWbtp55dqXbsdC0UMhFu1Oezjd5/4yW7bP4fXUfaqFRZb7EizrK6pb6
         K1DjFxLnvdFNN3zJY672XCxEzTpKPzL2vHSVPJbDHq2zcN/rNJ1kRj8Rj0tCX+Fir+BM
         cxkg==
X-Gm-Message-State: AC+VfDxGt7oGer0OMx4pFdkkgcPnNzd40Iik+Sb9HN+e5W41CDgB5LcG
        3RYr0V7qAE48hyNIz5JuPfViZQtTPOmErg0AUGKZMpvlK0ct06rVfGVC1A==
X-Google-Smtp-Source: ACHHUZ6X3eHgOi79uI5voH7sTG5OHbFPxo1ZHkuOTzu1DU+nRzr7rAp3nO6BbHaaQaY5/bAqMpLEMSKnA9lLL2yGc9k=
X-Received: by 2002:a2e:8641:0:b0:2ad:aa42:8c0b with SMTP id
 i1-20020a2e8641000000b002adaa428c0bmr3325724ljj.35.1683823588368; Thu, 11 May
 2023 09:46:28 -0700 (PDT)
MIME-Version: 1.0
References: <20230503065354.19071-1-i@truongsinh.pro> <ZFqHFTMqetbQKtah@moria.home.lan>
 <CAMy36z75N9obj0WM+OFhhnzXAPxqhg8PVY7_x8X6JbQABFnMQw@mail.gmail.com>
 <ZFqM8HOvlVn61VXs@moria.home.lan> <CANeycqq5xCUcjOeOfGAJCH1Tzd01-ALU3uqVJo-BvVX9HOK9wA@mail.gmail.com>
 <CAMy36z5VP_6atrxdOyXSO6G+R36vA8SuaWCDAui3Om3viogPkQ@mail.gmail.com>
 <CAMy36z6+RjgAfEYUxpOhS6vFmTter=cFa2CEorSnKR=qxkft=A@mail.gmail.com> <U4SpqY6MGcSaFOCHP-pTC2oqyrv7dh2BAlR9xubt3iymLknSafueqtUuhj0UzZUw8YGGNjrbti9_G4cUTatBMlbkOuErR5Uxw2pXpvZnZ_g=@protonmail.com>
In-Reply-To: <U4SpqY6MGcSaFOCHP-pTC2oqyrv7dh2BAlR9xubt3iymLknSafueqtUuhj0UzZUw8YGGNjrbti9_G4cUTatBMlbkOuErR5Uxw2pXpvZnZ_g=@protonmail.com>
From:   TruongSinh Tran-Nguyen <i@truongsinh.pro>
Date:   Thu, 11 May 2023 09:46:15 -0700
Message-ID: <CAMy36z7_UVZT03svBPVQpQyYdhWqFFmVokY7K+iy7MkDtbvAww@mail.gmail.com>
Subject: Re: [PATCH] chore(util): minimal Rust build example
To:     =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>
Cc:     rust-for-linux@vger.kernel.org,
        Kent Overstreet <kent.overstreet@linux.dev>,
        Wedson Almeida Filho <wedsonaf@gmail.com>,
        linux-bcachefs@vger.kernel.org, Andreas Hindborg <nmi@metaspace.dk>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

Hi Bj=C3=B6rn,

Thanks for the help. About bitfields, we might consider using bindgen
for now. However, in the future, if we have a rust-only module (no C
code), it would no longer be an option. If I understand correctly,
there is currently no similar macro like the bitfield crate provides,
and thus one of the other options (if the license permits), is to copy
the macros code directly to the module. Is that correct?

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




On Thu, 11 May 2023 at 09:16, Bj=C3=B6rn Roy Baron <bjorn3_gh@protonmail.co=
m> wrote:
>
> On Wednesday, May 10th, 2023 at 05:10, TruongSinh Tran-Nguyen <i@truongsi=
nh.pro> wrote:
>
> > Hi Rust for Linux folks,
> >
> > I have another question. When working on user-space, I'm used to cargo
> > dependency management, but I assume it's not possible when doing
> > kernel development. Specifically, for the immediately next PR, I need
> > to use these 2 crates (and their artifacts)
> >
> > `use bitfield::bitfield; use byteorder::{LittleEndian, ReadBytesExt};`
> >
> > Is there something similar in Rust part of kernel already
> > (https://docs.kernel.org/core-api/packing.html# and
> > https://man7.org/linux/man-pages/man3/htons.3.html respectively, may
> > be) ? Or if not, is it normal to just copy-paste the needed code
> > together our code?
> >
> > Kind regards,
> > Sinh
> >
>
> For byteorder you can use the builtin {to,from}_{le,be,ne}_bytes and {fro=
m,to}_{be,le} methods. The former return and accepts a [u8; N] array where =
N is the size in bytes of the integer you called it on. The _be variants of=
 the later are equivalent to the htons family.
>
> For bitfields if you have a struct definition with bitfields in a C heade=
r already, bindgen should generate a type with getters and setters for the =
individual fields as well as a constructor. See https://rust-lang.github.io=
/rust-bindgen/using-bitfields.html If the type isn't defined on the C side =
I guess you could define it there as helper, but having a rust macro for th=
is like the bitfield crate provides is of course nicer.
>
> Cheers,
> Bjorn

Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E0E2C77B61
	for <linux-bcachefs@archiver.kernel.org>; Thu, 27 Apr 2023 21:17:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344080AbjD0VRb (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Thu, 27 Apr 2023 17:17:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229721AbjD0VRb (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Thu, 27 Apr 2023 17:17:31 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C12C35B0
        for <linux-bcachefs@vger.kernel.org>; Thu, 27 Apr 2023 14:17:29 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id ffacd0b85a97d-2fa0ce30ac2so8135320f8f.3
        for <linux-bcachefs@vger.kernel.org>; Thu, 27 Apr 2023 14:17:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=truongsinh.pro; s=google; t=1682630248; x=1685222248;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=D9s3laz9K6GyWlBHsZU/ESJSR7ul1X9DZfBwSyHsgNg=;
        b=NVqajhBjjFYEzzGsA0XU4d+8VCuMj7DXrszAbJTQuQCDQ2E+DLKDOp3ixB3j//3627
         1txBDCWRdEicGCkFBECZis+mwNZQFOR8UZKnqtzcChzkJamzVPm589Qzpv4QT4mlW2fy
         c9bwq4e7A4tRYk88MtAZKdHHdHiRZqSbVxEBs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682630248; x=1685222248;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=D9s3laz9K6GyWlBHsZU/ESJSR7ul1X9DZfBwSyHsgNg=;
        b=Rm/+9pgtDTaxkRLpKMAIpIU1CvHRQj1GfpCoQHa5iSfWpvKYPN/d40GP1G+/BweC37
         BSL2NY2HX55ezTSrjipE95C+wfMywgFfVrnZmjgK2qMOntoB5heDVw5fG6ykHtdCqXIP
         JYrimM9Otrqak7px0iNyD2onlyUVW5iDJfw5KlqS9WLCIlSoub+Lt1wTuYWmbEe8KHYt
         B+8CdltI1OT3PEYrHOnTuT9hawcgBKNJKFr6qWJkWaCM9ENuGnYvZsWGgLbBTJwAHQaw
         Tm3mTTL1/GoZI3LfCioJj+mFj2I7bXrZ/BzFXWUQ/twtu73HSazFkJiq4bOepdcDFDkn
         MZrQ==
X-Gm-Message-State: AC+VfDxBrjN5tidFeOHARygpfW62aLiRxALGTmFOg9/YUfKpevPiLufR
        LK5IYlnGE3OCBDPwoMmTgevaIGGF4icKPgo9oEcin7fIeAdnh92Fq6tGVA==
X-Google-Smtp-Source: ACHHUZ4wyqfktOpgpIVwGLnLewDVuM5C9ByHpg2I1gAaymrqNg53LoRnL08QZC+sunXvR/Ge/OVllJc+x/1w+2jeO6Y=
X-Received: by 2002:a05:6000:1110:b0:2cf:eb86:bd90 with SMTP id
 z16-20020a056000111000b002cfeb86bd90mr2173805wrw.63.1682630247716; Thu, 27
 Apr 2023 14:17:27 -0700 (PDT)
MIME-Version: 1.0
References: <20230427180200.18965-1-i@truongsinh.pro> <ZErYAKiCYD3nv3za@moria.home.lan>
In-Reply-To: <ZErYAKiCYD3nv3za@moria.home.lan>
From:   TruongSinh Tran-Nguyen <i@truongsinh.pro>
Date:   Thu, 27 Apr 2023 14:17:15 -0700
Message-ID: <CAMy36z4U_CkFqY1OnvMD7wJOy1TPYV0yb=xgcvSAmPOGoTBq5w@mail.gmail.com>
Subject: Re: [PATCH] chore(rust): add opt_get! and expose some FMODE_* as Rust const
To:     Kent Overstreet <kent.overstreet@linux.dev>
Cc:     linux-bcachefs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Thu, 27 Apr 2023 at 13:16, Kent Overstreet <kent.overstreet@linux.dev> wrote:
>
> On Thu, Apr 27, 2023 at 11:02:00AM -0700, TruongSinh Tran-Nguyen wrote:
> > In an effort to rewrite `bch2_read_super` from C to Rust,
> > it is neccessary to have `opt_get!` macro defined, and some
> > FMODE_* consts (defined as macro in `include/linux/blkdev.h`)
> > defined as Rust const.
> >
> > Bindgen is currently unable to exapnd C functional macro [1],
> > this this commit use the workaround as introduced in [2].
> >
> > [1] https://github.com/rust-lang/rust-bindgen/issues/753
> > [2] https://github.com/rust-lang/rust-bindgen/issues/753#issuecomment-608546390
> >
> > Signed-off-by: TruongSinh Tran-Nguyen <i@truongsinh.pro>
> > ---
> >  rust-src/bch_bindgen/build.rs                 | 11 +++++++
> >  .../bch_bindgen/src/libbcachefs_wrapper.h     |  7 +++++
> >  rust-src/bch_bindgen/src/opts.rs              | 30 +++++++++++++++++--
> >  3 files changed, 46 insertions(+), 2 deletions(-)
> >
> > diff --git a/rust-src/bch_bindgen/build.rs b/rust-src/bch_bindgen/build.rs
> > index f426316..92ec3ce 100644
> > --- a/rust-src/bch_bindgen/build.rs
> > +++ b/rust-src/bch_bindgen/build.rs
> > @@ -1,3 +1,12 @@
> > +
> > +#[derive(Debug)]
> > +pub struct Fix753 {}
> > +impl bindgen::callbacks::ParseCallbacks for Fix753 {
> > +    fn item_name(&self, original_item_name: &str) -> Option<String> {
> > +        Some(original_item_name.trim_start_matches("Fix753_").to_owned())
> > +    }
> > +}
> > +
> >  fn main() {
> >      use std::path::PathBuf;
> >
> > @@ -49,6 +58,7 @@ fn main() {
> >          .blocklist_type("srcu_struct")
> >          .allowlist_var("BCH_.*")
> >          .allowlist_var("KEY_SPEC_.*")
> > +        .allowlist_var("Fix753_FMODE_.*")
> >          .allowlist_var("bch.*")
> >          .allowlist_var("__BTREE_ITER.*")
> >          .allowlist_var("BTREE_ITER.*")
> > @@ -69,6 +79,7 @@ fn main() {
> >          .no_partialeq("bkey")
> >          .no_partialeq("bpos")
> >          .generate_inline_functions(true)
> > +        .parse_callbacks(Box::new(Fix753 {}))
> >          .generate()
> >          .expect("BindGen Generation Failiure: [libbcachefs_wrapper]");
> >      bindings
> > diff --git a/rust-src/bch_bindgen/src/libbcachefs_wrapper.h b/rust-src/bch_bindgen/src/libbcachefs_wrapper.h
> > index d1ebf4b..e7bcfcf 100644
> > --- a/rust-src/bch_bindgen/src/libbcachefs_wrapper.h
> > +++ b/rust-src/bch_bindgen/src/libbcachefs_wrapper.h
> > @@ -10,4 +10,11 @@
> >  #include "../libbcachefs.h"
> >  #include "../crypto.h"
> >  #include "../include/linux/bio.h"
> > +#include "../include/linux/blkdev.h"
> >
> > +
> > +#define MARK_FIX_753(req_name) const fmode_t Fix753_##req_name = req_name;
>
> Do we actually need to include Fix753_ in the constants we define? Why
> not shadow the macro names?
>
> > +
> > +MARK_FIX_753(FMODE_READ);
> > +MARK_FIX_753(FMODE_WRITE);
> > +MARK_FIX_753(FMODE_EXCL);
> > \ No newline at end of file
> > diff --git a/rust-src/bch_bindgen/src/opts.rs b/rust-src/bch_bindgen/src/opts.rs
> > index e226199..d38d469 100644
> > --- a/rust-src/bch_bindgen/src/opts.rs
> > +++ b/rust-src/bch_bindgen/src/opts.rs
> > @@ -3,7 +3,33 @@ macro_rules! opt_set {
> >      ($opts:ident, $n:ident, $v:expr) => {
> >          bch_bindgen::paste! {
> >              $opts.$n = $v;
> > -            $opts.[<set_ $n _defined>](1);
> > +            $opts.[<set_ $n _defined>](1)
> >          }
> > -    }
> > +    };
> > +}
> > +
> > +#[macro_export]
> > +macro_rules! opt_defined {
> > +    ($opts:ident, $n:ident) => {
> > +        bch_bindgen::paste! {
> > +            $opts.[< $n _defined>]()
> > +        }
> > +    };
> > +}
> > +
> > +#[macro_export]
> > +macro_rules! opt_get {
> > +    ($opts:ident, $n:ident) => {
> > +        if bch_bindgen::opt_defined!($opts, $n) == 0 {
> > +            bch_bindgen::paste! {
> > +                unsafe {
> > +                    bch_bindgen::bcachefs::bch2_opts_default.$n
> > +                }
> > +            }
> > +        } else {
> > +            bch_bindgen::paste! {
> > +                $opts.$n
> > +            }
> > +        }
> > +    };
>
> This is fine, it's a direct translation of the C code.
>
> At some point we ought to do a proper Rust version of the opts struct
> that uses Option<>. (We'd actually want two different versions, one that
> has every option wrapped in Option<> and one doesn't, since e.g. c->opts
> doesn't have unset options.)

> Do we actually need to include Fix753_ in the constants we define? Why
not shadow the macro names?

The prefix is during the process only, but it will be stripped out by
`.parse_callbacks(Box::new(Fix753 {}))`. In other words, in Rust,
it would be used like this:

```
sb.mode &= !FMODE_WRITE;
```

As for the reason we need `Fix753_` prefix even though it would not make it
to the final generated `bcachefs.rs`, I guess it is rust community convention
to have the workaround while waiting for the create to have the fix, and when
it is fixed, remove it.

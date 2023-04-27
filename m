Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6FFF2C77B61
	for <linux-bcachefs@archiver.kernel.org>; Thu, 27 Apr 2023 20:16:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343704AbjD0UQK (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Thu, 27 Apr 2023 16:16:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231563AbjD0UQK (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Thu, 27 Apr 2023 16:16:10 -0400
Received: from out-11.mta0.migadu.com (out-11.mta0.migadu.com [91.218.175.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 335C91704
        for <linux-bcachefs@vger.kernel.org>; Thu, 27 Apr 2023 13:16:05 -0700 (PDT)
Date:   Thu, 27 Apr 2023 16:16:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1682626563;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=wz2iTwdiNc5QvD377glWc2r4BjBV4DxKn69y6A1G5go=;
        b=F4Z51GdxAidcugwkP0Z5bj47gCeQuZTGoBzcEIQRWQ0K/5hd/OaB6X+alrkPN8apGj1UCw
        bhyRvfW/4ZQs4R8Pi7lS2/usO3G1UWh318ZKFn7yoak7K/VI/YQa4+m5NA+v1OhX8pvJDE
        G4a6LaQv/qG0ZYhD59ygqfTHWNGKDkc=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Kent Overstreet <kent.overstreet@linux.dev>
To:     TruongSinh Tran-Nguyen <i@truongsinh.pro>
Cc:     linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH] chore(rust): add opt_get! and expose some FMODE_* as
 Rust const
Message-ID: <ZErYAKiCYD3nv3za@moria.home.lan>
References: <20230427180200.18965-1-i@truongsinh.pro>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230427180200.18965-1-i@truongsinh.pro>
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Thu, Apr 27, 2023 at 11:02:00AM -0700, TruongSinh Tran-Nguyen wrote:
> In an effort to rewrite `bch2_read_super` from C to Rust,
> it is neccessary to have `opt_get!` macro defined, and some
> FMODE_* consts (defined as macro in `include/linux/blkdev.h`)
> defined as Rust const.
> 
> Bindgen is currently unable to exapnd C functional macro [1],
> this this commit use the workaround as introduced in [2].
> 
> [1] https://github.com/rust-lang/rust-bindgen/issues/753
> [2] https://github.com/rust-lang/rust-bindgen/issues/753#issuecomment-608546390
> 
> Signed-off-by: TruongSinh Tran-Nguyen <i@truongsinh.pro>
> ---
>  rust-src/bch_bindgen/build.rs                 | 11 +++++++
>  .../bch_bindgen/src/libbcachefs_wrapper.h     |  7 +++++
>  rust-src/bch_bindgen/src/opts.rs              | 30 +++++++++++++++++--
>  3 files changed, 46 insertions(+), 2 deletions(-)
> 
> diff --git a/rust-src/bch_bindgen/build.rs b/rust-src/bch_bindgen/build.rs
> index f426316..92ec3ce 100644
> --- a/rust-src/bch_bindgen/build.rs
> +++ b/rust-src/bch_bindgen/build.rs
> @@ -1,3 +1,12 @@
> +
> +#[derive(Debug)]
> +pub struct Fix753 {}
> +impl bindgen::callbacks::ParseCallbacks for Fix753 {
> +    fn item_name(&self, original_item_name: &str) -> Option<String> {
> +        Some(original_item_name.trim_start_matches("Fix753_").to_owned())
> +    }
> +}
> +
>  fn main() {
>      use std::path::PathBuf;
>  
> @@ -49,6 +58,7 @@ fn main() {
>          .blocklist_type("srcu_struct")
>          .allowlist_var("BCH_.*")
>          .allowlist_var("KEY_SPEC_.*")
> +        .allowlist_var("Fix753_FMODE_.*")
>          .allowlist_var("bch.*")
>          .allowlist_var("__BTREE_ITER.*")
>          .allowlist_var("BTREE_ITER.*")
> @@ -69,6 +79,7 @@ fn main() {
>          .no_partialeq("bkey")
>          .no_partialeq("bpos")
>          .generate_inline_functions(true)
> +        .parse_callbacks(Box::new(Fix753 {}))
>          .generate()
>          .expect("BindGen Generation Failiure: [libbcachefs_wrapper]");
>      bindings
> diff --git a/rust-src/bch_bindgen/src/libbcachefs_wrapper.h b/rust-src/bch_bindgen/src/libbcachefs_wrapper.h
> index d1ebf4b..e7bcfcf 100644
> --- a/rust-src/bch_bindgen/src/libbcachefs_wrapper.h
> +++ b/rust-src/bch_bindgen/src/libbcachefs_wrapper.h
> @@ -10,4 +10,11 @@
>  #include "../libbcachefs.h"
>  #include "../crypto.h"
>  #include "../include/linux/bio.h"
> +#include "../include/linux/blkdev.h"
>  
> +
> +#define MARK_FIX_753(req_name) const fmode_t Fix753_##req_name = req_name;

Do we actually need to include Fix753_ in the constants we define? Why
not shadow the macro names?

> +
> +MARK_FIX_753(FMODE_READ);
> +MARK_FIX_753(FMODE_WRITE);
> +MARK_FIX_753(FMODE_EXCL);
> \ No newline at end of file
> diff --git a/rust-src/bch_bindgen/src/opts.rs b/rust-src/bch_bindgen/src/opts.rs
> index e226199..d38d469 100644
> --- a/rust-src/bch_bindgen/src/opts.rs
> +++ b/rust-src/bch_bindgen/src/opts.rs
> @@ -3,7 +3,33 @@ macro_rules! opt_set {
>      ($opts:ident, $n:ident, $v:expr) => {
>          bch_bindgen::paste! {
>              $opts.$n = $v;
> -            $opts.[<set_ $n _defined>](1);
> +            $opts.[<set_ $n _defined>](1)
>          }
> -    }
> +    };
> +}
> +
> +#[macro_export]
> +macro_rules! opt_defined {
> +    ($opts:ident, $n:ident) => {
> +        bch_bindgen::paste! {
> +            $opts.[< $n _defined>]()
> +        }
> +    };
> +}
> +
> +#[macro_export]
> +macro_rules! opt_get {
> +    ($opts:ident, $n:ident) => {
> +        if bch_bindgen::opt_defined!($opts, $n) == 0 {
> +            bch_bindgen::paste! {
> +                unsafe {
> +                    bch_bindgen::bcachefs::bch2_opts_default.$n
> +                }
> +            }
> +        } else {
> +            bch_bindgen::paste! {
> +                $opts.$n
> +            }
> +        }
> +    };

This is fine, it's a direct translation of the C code.

At some point we ought to do a proper Rust version of the opts struct
that uses Option<>. (We'd actually want two different versions, one that
has every option wrapped in Option<> and one doesn't, since e.g. c->opts
doesn't have unset options.)

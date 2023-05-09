Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9BD4C77B75
	for <linux-bcachefs@archiver.kernel.org>; Tue,  9 May 2023 17:47:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229523AbjEIRrP (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Tue, 9 May 2023 13:47:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229491AbjEIRrO (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Tue, 9 May 2023 13:47:14 -0400
Received: from out-44.mta0.migadu.com (out-44.mta0.migadu.com [IPv6:2001:41d0:1004:224b::2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0488C10F6
        for <linux-bcachefs@vger.kernel.org>; Tue,  9 May 2023 10:47:12 -0700 (PDT)
Date:   Tue, 9 May 2023 13:47:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1683654430;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Mh08PWWBwtwvRi6TJFXNKI1t8DH8lDAr2+Vm2o39U1Y=;
        b=a8grNAsW3T1XeULI+4x4BDYLBGXbTk8kSH/NUtK8h6OAlE2gP1+EuNjgwlb6q/StskBqZr
        MIJS6vYaox2TqCsNJLlU5HmWncKkuhYbk0HUTDJPQ6yGD2w7Y1pjNMf6WUWDiA1IA8EjXu
        MR7YhJbwQaKLD/j4wmpH43Haf7nlVQo=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Kent Overstreet <kent.overstreet@linux.dev>
To:     TruongSinh Tran-Nguyen <i@truongsinh.pro>
Cc:     linux-bcachefs@vger.kernel.org, rust-for-linux@vger.kernel.org
Subject: Re: [PATCH] chore(util): minimal Rust build example
Message-ID: <ZFqHFTMqetbQKtah@moria.home.lan>
References: <20230503065354.19071-1-i@truongsinh.pro>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230503065354.19071-1-i@truongsinh.pro>
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Tue, May 02, 2023 at 11:53:54PM -0700, TruongSinh Tran-Nguyen wrote:
> This is a minimal demonstration of how to use Rust in kernel side
> of bcachefs. Kernel side rust does not have Rust `std`, thus
> formating is a bit more challenging than doing from user space

So if I'm following, it looks like everything is basically there. It
looks like we can add Rust source files to fs/bcachefs/ and have them
built as part of the bcachefs module, and calling back and forth just
works as expected - nice.

The kbuild stuff looks nice and clean - congrats to those responsible :)

We pretty heavily use to_text() functions kernel side; these output to
printbufs, and in Rust they map nicely to the Display trait - do we have
that available in the kernel or is that in std?

> This minimal demo implement `uuid_le_cmp`, but eventually,
> in Rust, we probably do not even need to use it, just simply
> `u1.b != u2.b` is good enough. Furthermore, we might consider
> (even in C code) to use uuid_t instead of uuid_le

Sounds like that would be a welcome cleanup :)

> Signed-off-by: TruongSinh Tran-Nguyen <i@truongsinh.pro>
> ---
>  fs/bcachefs/Makefile              |  3 +++
>  fs/bcachefs/util.h                |  8 ++++++++
>  fs/bcachefs/util_rust.rs          | 17 +++++++++++++++++
>  scripts/generate_rust_analyzer.py |  2 +-
>  4 files changed, 29 insertions(+), 1 deletion(-)
>  create mode 100644 fs/bcachefs/util_rust.rs
> 
> diff --git a/fs/bcachefs/Makefile b/fs/bcachefs/Makefile
> index a71956048a027..972976aac6921 100644
> --- a/fs/bcachefs/Makefile
> +++ b/fs/bcachefs/Makefile
> @@ -72,3 +72,6 @@ bcachefs-y		:=	\
>  	xattr.o
>  
>  bcachefs-$(CONFIG_BCACHEFS_POSIX_ACL) += acl.o
> +
> +bcachefs-$(CONFIG_RUST) +=	\
> +	util_rust.o	\
> diff --git a/fs/bcachefs/util.h b/fs/bcachefs/util.h
> index 9eb86c58e5509..6e87baee760a9 100644
> --- a/fs/bcachefs/util.h
> +++ b/fs/bcachefs/util.h
> @@ -839,9 +839,17 @@ static inline int u8_cmp(u8 l, u8 r)
>  
>  #include <linux/uuid.h>
>  
> +#ifdef CONFIG_RUST
> +int deprecated_uuid_le_cmp(const uuid_le *b1, const uuid_le *b2);
> +#endif
> +
>  static inline int uuid_le_cmp(const uuid_le u1, const uuid_le u2)
>  {
> +	#ifdef CONFIG_RUST
> +	return deprecated_uuid_le_cmp(&u1, &u2);
> +	#else
>  	return memcmp(&u1, &u2, sizeof(uuid_le));
> +	#endif
>  }
>  
>  #endif /* _BCACHEFS_UTIL_H */
> diff --git a/fs/bcachefs/util_rust.rs b/fs/bcachefs/util_rust.rs
> new file mode 100644
> index 0000000000000..23338c29384c0
> --- /dev/null
> +++ b/fs/bcachefs/util_rust.rs
> @@ -0,0 +1,17 @@
> +/* SPDX-License-Identifier: MIT */
> +
> +#[repr(C)]
> +pub struct UuidLe {
> +  b: [u8; 16],
> +}
> +
> +// this function is prefixed `deprecated` because it uses
> +// uuid_le from /usr/include/linux/uuid.h, which itself is
> +// deprecated in favor of uuid_t from include/linux/uuid.h
> +// it also does not exactly matches memcmp
> +#[no_mangle]
> +pub extern "C" fn deprecated_uuid_le_cmp( u1 : &UuidLe, u2 : &UuidLe) -> bool
> +{
> +  // pr_info!("using deprecated_uuid_le_cmp");
> +  return u1.b != u2.b;
> +}
> diff --git a/scripts/generate_rust_analyzer.py b/scripts/generate_rust_analyzer.py
> index 946e250c1b2a6..d258d10bb6e31 100755
> --- a/scripts/generate_rust_analyzer.py
> +++ b/scripts/generate_rust_analyzer.py
> @@ -98,7 +98,7 @@ def generate_crates(srctree, objtree, sysroot_src):
>      # Then, the rest outside of `rust/`.
>      #
>      # We explicitly mention the top-level folders we want to cover.
> -    for folder in ("samples", "drivers"):
> +    for folder in ("samples", "drivers", 'fs'):
>          for path in (srctree / folder).rglob("*.rs"):
>              logging.info("Checking %s", path)
>              name = path.name.replace(".rs", "")
> -- 
> 2.30.2
> 

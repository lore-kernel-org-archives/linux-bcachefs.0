Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5316C0015E
	for <linux-bcachefs@archiver.kernel.org>; Sat, 12 Aug 2023 16:06:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229501AbjHLQGk (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Sat, 12 Aug 2023 12:06:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229454AbjHLQGk (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Sat, 12 Aug 2023 12:06:40 -0400
Received: from out-90.mta0.migadu.com (out-90.mta0.migadu.com [91.218.175.90])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADBE8E58
        for <linux-bcachefs@vger.kernel.org>; Sat, 12 Aug 2023 09:06:42 -0700 (PDT)
Date:   Sat, 12 Aug 2023 12:06:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1691856400;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=PR4gr2s/SudiDOKwei8vJcgx/33icc1tCciPsl7DYhQ=;
        b=rmiqLsBNRdMl27VxV0qcgMm7kaxh7YzhFd/y1IZq2j1l4DUZzLR4a0RlpZ/V8tw7dusPtC
        4QNx/X0mNcN2scb39W93e6SiYLt//xWJzgRbU8G/8JOuwWNP/iyFR1LMmtGzJxrvv7Iozy
        CVYACNOp51Q5LEFAf0jikxp8I/5DaIk=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Kent Overstreet <kent.overstreet@linux.dev>
To:     Colin Gillespie <colin@cgillespie.xyz>
Cc:     linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH] cmd_mount: use the correct keyring key type
Message-ID: <20230812160635.42wm5rlrqkjngqsk@moria.home.lan>
References: <20230812035037.20681-1-colin@cgillespie.xyz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230812035037.20681-1-colin@cgillespie.xyz>
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Sat, Aug 12, 2023 at 01:50:37PM +1000, Colin Gillespie wrote:
> Mount is checking for and adding encryption keys using the logon key
> type instead of the user key type. This was causing it to not be able to
> unlock volumes on its own, and ask for a passphrase on already unlocked
> volumes.

Thanks! Applied.

> Signed-off-by: Colin Gillespie <colin@cgillespie.xyz>
> ---
>  rust-src/src/key.rs | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/rust-src/src/key.rs b/rust-src/src/key.rs
> index 2b4fc45..07292e8 100644
> --- a/rust-src/src/key.rs
> +++ b/rust-src/src/key.rs
> @@ -35,7 +35,7 @@ impl std::str::FromStr for KeyLoc {
>  fn check_for_key(key_name: &std::ffi::CStr) -> anyhow::Result<bool> {
>      use bch_bindgen::keyutils::{self, keyctl_search};
>      let key_name = key_name.to_bytes_with_nul().as_ptr() as *const _;
> -    let key_type = c_str!("logon");
> +    let key_type = c_str!("user");
>  
>      let key_id = unsafe { keyctl_search(keyutils::KEY_SPEC_USER_KEYRING, key_type, key_name, 0) };
>      if key_id > 0 {
> @@ -101,7 +101,7 @@ fn ask_for_key(sb: &bch_sb_handle) -> anyhow::Result<()> {
>      } else if key.magic != bch_key_magic {
>          Err(anyhow!("failed to verify the password"))
>      } else {
> -        let key_type = c_str!("logon");
> +        let key_type = c_str!("user");
>          let ret = unsafe {
>              bch_bindgen::keyutils::add_key(
>                  key_type,
> -- 
> 2.41.0
> 

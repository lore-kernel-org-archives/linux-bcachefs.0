Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F29CC77B7C
	for <linux-bcachefs@archiver.kernel.org>; Wed, 26 Apr 2023 14:44:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241482AbjDZOok (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Wed, 26 Apr 2023 10:44:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241483AbjDZOog (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Wed, 26 Apr 2023 10:44:36 -0400
Received: from out-19.mta0.migadu.com (out-19.mta0.migadu.com [91.218.175.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 205396EA2
        for <linux-bcachefs@vger.kernel.org>; Wed, 26 Apr 2023 07:44:34 -0700 (PDT)
Date:   Wed, 26 Apr 2023 10:44:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1682520272;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=A5VWxFkdIYemQyFozUN7S3Xv/vdGfHsLR3BVzcGFk0k=;
        b=dl3sjGBUXP8mzQ6RckvdGkJFcE1bqO8JceSXYvLQ1/znYfc3OfGd7RrH63hI7UrYl6PoN9
        JS3zms2ABa/hAQthwAWM2Qw9d1jdZllAVTRWiVQu6zzP5r4VEgqJeobhJHw2xnAplhdfiz
        7fUfXaPBYAT08xt7ePX1dn3h+u9WnyA=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Kent Overstreet <kent.overstreet@linux.dev>
To:     TruongSinh Tran-Nguyen <i@truongsinh.pro>
Cc:     linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH] feat(cmd_mount): Add support for magic keyword
 `OLD_BLKID_UUID`
Message-ID: <ZEk4zgwZFLKsHpXU@moria.home.lan>
References: <20230425224527.21103-1-i@truongsinh.pro>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230425224527.21103-1-i@truongsinh.pro>
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Tue, Apr 25, 2023 at 03:45:27PM -0700, TruongSinh Tran-Nguyen wrote:
> This commit enhances mount by allowing it to accept `OLD_BLKID_UUID=xxx` as the device, enabling whole fs mounting without relying on colon-separated devices. Using colon-separated devices in fstab is discouraged due to potential device reference issues after reboot. Additionally, using `UUID=xxx` in fstab is currently infeasible as it depends on blkid, which prior to v2.39, does not recognize bcachefs. This update enables mounting via fstab using `OLD_BLKID_UUID=xxx` as obtained from `bcachefs show-super` "External UUID".

Let's not delete the UUID= support, make it an additional parameter.

Also, your patches need signed-of-by lines, and you need to 80 character
wordwrap your commit messages.

Other than that I think it all looks good.

> ---
>  rust-src/src/cmd_mount.rs | 33 ++++++++++++++++++++++-----------
>  1 file changed, 22 insertions(+), 11 deletions(-)
> 
> diff --git a/rust-src/src/cmd_mount.rs b/rust-src/src/cmd_mount.rs
> index af370ef..14e6176 100644
> --- a/rust-src/src/cmd_mount.rs
> +++ b/rust-src/src/cmd_mount.rs
> @@ -1,9 +1,8 @@
>  use atty::Stream;
>  use bch_bindgen::{bcachefs, bcachefs::bch_sb_handle};
> -use log::{info, warn, debug, error, trace, LevelFilter};
> +use log::{info, debug, error, LevelFilter};
>  use clap::Parser;
>  use uuid::Uuid;
> -use std::convert::TryInto;
>  use std::path::PathBuf;
>  use crate::key;
>  use crate::key::KeyLoc;
> @@ -162,14 +161,17 @@ struct Cli {
>  }
>  
>  fn cmd_mount_inner(opt: Cli) -> anyhow::Result<()> {
> -    let (devs, sbs) = if opt.dev.starts_with("UUID=") {
> -        let uuid = opt.dev.replacen("UUID=", "", 1);
> -        let uuid = Uuid::parse_str(&uuid)?;
> -        let devs_sbs = get_devices_by_uuid(uuid)?;
> -
> -        let devs_strs: Vec<_> = devs_sbs.iter().map(|(dev, _)| dev.clone().into_os_string().into_string().unwrap()).collect();
> -        let devs_str = devs_strs.join(":");
> -        let sbs = devs_sbs.iter().map(|(_, sb)| *sb).collect();
> +    let (devs, sbs) = if opt.dev.starts_with("OLD_BLKID_UUID=") {
> +        let uuid = opt.dev.replacen("OLD_BLKID_UUID=", "", 1);
> +        debug!("enumerating devices with UUID {}", uuid);
> +        let devs_sbs = Uuid::parse_str(&uuid).map(|uuid| get_devices_by_uuid(uuid))??;
> +
> +        let devs_str = devs_sbs
> +            .iter()
> +            .map(|(dev, _)| dev.to_str().unwrap())
> +            .collect::<Vec<_>>()
> +            .join(":");
> +        let sbs: Vec<bch_sb_handle> = devs_sbs.iter().map(|(_, sb)| *sb).collect();
>  
>          (devs_str, sbs)
>      } else {
> @@ -183,7 +185,9 @@ fn cmd_mount_inner(opt: Cli) -> anyhow::Result<()> {
>          (opt.dev, sbs)
>      };
>  
> -    if unsafe { bcachefs::bch2_sb_is_encrypted(sbs[0].sb) } {
> +    if sbs.len() == 0 {
> +        Err(anyhow::anyhow!("No device found from specified parameters"))?;
> +    } else if unsafe { bcachefs::bch2_sb_is_encrypted(sbs[0].sb) } {
>          let key = opt
>              .key_location
>              .0
> @@ -192,6 +196,13 @@ fn cmd_mount_inner(opt: Cli) -> anyhow::Result<()> {
>          key::prepare_key(&sbs[0], key)?;
>      }
>  
> +    info!(
> +        "mounting with params: device: {}, target: {}, options: {}",
> +        devs,
> +        &opt.mountpoint.to_string_lossy(),
> +        &opt.options
> +    );
> +
>      mount(devs, &opt.mountpoint, &opt.options)?;
>      Ok(())
>  }
> -- 
> 2.33.1
> 

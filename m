Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A8FBCDB482
	for <linux-bcachefs@archiver.kernel.org>; Thu, 19 Oct 2023 06:31:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232057AbjJSGbh (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Thu, 19 Oct 2023 02:31:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229894AbjJSGbg (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Thu, 19 Oct 2023 02:31:36 -0400
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E4DBBE
        for <linux-bcachefs@vger.kernel.org>; Wed, 18 Oct 2023 23:31:34 -0700 (PDT)
Received: by mail-lf1-x130.google.com with SMTP id 2adb3069b0e04-507bd64814fso3738248e87.1
        for <linux-bcachefs@vger.kernel.org>; Wed, 18 Oct 2023 23:31:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1697697092; x=1698301892; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FthGN00KtXBYmbiHU96hoM4H045fCnfczea/upO9Ntw=;
        b=UGv/imSaqmAkouCDamCFYvLLuSCg4gDxIMLOCVn6ldmrplKYehb4ut+z9tvB3CaLbH
         2VJPbZyRdhFLMK3W/wX9o0yWUaau1b895MQB8C/LPWXjL6Ehv/TUuPOP/a1Rg5o9CAci
         Sr7tyPZr6lIQXT6PjSP/WyJHs8wq2lHFlg5m0TPCjAy1fQuDALeYqem2AvoXkuI4WRUM
         OEOk3K9d1RepZKEOINsbQgichdGYn1XF2snsUaf5MDn3DBOWgK4FRkCJEU0BEBnNzMUM
         mLcG8fT4wPxGBedVWg1OnlAEDfBk63rmE1CFcMGPG2u9HUAUwEW4LXyKs98zYmmwMNWf
         mz8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697697092; x=1698301892;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FthGN00KtXBYmbiHU96hoM4H045fCnfczea/upO9Ntw=;
        b=LeMyN7hc+h5SmiKkATBEg1cMUgjNJyXL8i+xjcnKp3JqTLP4dQ39MLqeWjRmR4GbX+
         2VtLvDsDUkmLQRILeKE4VE//AIHkrLTczqr0D2QWeqnoroVlyuuUkgRogeJj8WcFvGkN
         UCgpU7icl1fjvesu28zJpU5XJDA+EtAUBvQsR4q8OUCJLJV/RbmABkzjOochLTI1dFwq
         QGRI26cUsgBHcsTW0K0wZj1jMlchdWbTsh/DIp9dkVjTYv2kdrrXyq2bLQ88H22ymwDJ
         GhN/8C1YPWaZLWQ+7clzBzu1BhVSHiakWxsXJ5Pf++XZtrRlRVg40LbZS5wIC2c5hAjn
         ldiQ==
X-Gm-Message-State: AOJu0YwXEzrdP425S95vOU5x7wDtsmcvBj/XcGiCws5PuSzEnQ/KuJWT
        Ed6kFLuvftSg4vozuWPg0aE8ZUyvamiRTcauCk7aKeDFRW85FA==
X-Google-Smtp-Source: AGHT+IHJAyfUVK38pX8NLiLf7qTzIg7i+iD+9f2J7+zQc2u9xbyS9WQzf3v6vpK1pgEIv/Yt+XCVH2ioWN+7gO+okHk=
X-Received: by 2002:a19:6509:0:b0:507:aa8d:a572 with SMTP id
 z9-20020a196509000000b00507aa8da572mr807842lfb.49.1697697092055; Wed, 18 Oct
 2023 23:31:32 -0700 (PDT)
MIME-Version: 1.0
References: <CAPxz1+Yt644v4q-ahjE46Sh_ZZSE2r=wwSaup4nYC4uYgQy+rA@mail.gmail.com>
 <20231018202955.i2xjqqpd7cubunvg@moria.home.lan> <CAPxz1+ZTODcUt=nbToDtpsHr1LW04VNVqDPJNV2QhuXb-=+CnQ@mail.gmail.com>
 <20231019002654.cgsmfhu6pxnh4vro@moria.home.lan> <CAPxz1+YcGd23wH4J+Vo1ES6-ncMaW0ga6DSxehS8Ty=t6rTbNg@mail.gmail.com>
 <20231019004704.ehjplvjlhzqgnyx6@moria.home.lan>
In-Reply-To: <20231019004704.ehjplvjlhzqgnyx6@moria.home.lan>
From:   Parke <parke.nexus@gmail.com>
Date:   Wed, 18 Oct 2023 23:30:55 -0700
Message-ID: <CAPxz1+bKiC1h7VVKE3irfec7nJSDABfWErHzAoxrwnkZD+WuMg@mail.gmail.com>
Subject: Re: Bcachefs: export a different st_dev for each subvolume
To:     Kent Overstreet <kent.overstreet@linux.dev>
Cc:     linux-bcachefs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Wed, Oct 18, 2023 at 5:47=E2=80=AFPM Kent Overstreet
<kent.overstreet@linux.dev> wrote:
> So, in that case, you just need a single bit reported via stat() or
> statx().
>
> Unfortunately, I don't see a flags field in struct statx...

A single bit from somewhere would do it.

BTRFS's approach is pretty close to ideal.  A BTRFS subvolume can be
identified as follows:

1) Is the entry a directory?
2) Is the inode 256?
3) Is the filesystem type BTRFS?

1 and 2 are readily available in `ls`.  They are provided by stat(),
and `ls` already calls stat() for every entry.

If a directory has an inode of 256, then a single call to statfs() can
determine whether or not the filesystem is BTRFS, simultaneously
determining whether or not the directory itself is a subvolume.

`ls` does allow for one (or several?) additional function call(s) to
assist with colorization in some cases.  This is done to color files
with capabilities, for example.

ZFS is almost as good.  A ZFS subvolume (actually called a
"filesystem") has a low inode that is often 34.  But it is not
guaranteed to always be 34, unfortunately.

Source:  https://github.com/openzfs/zfs/discussions/15192

Cheers,

Parke

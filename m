Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD8CDC77B75
	for <linux-bcachefs@archiver.kernel.org>; Tue,  9 May 2023 17:57:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232812AbjEIR5f (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Tue, 9 May 2023 13:57:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229738AbjEIR5e (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Tue, 9 May 2023 13:57:34 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C41A74483
        for <linux-bcachefs@vger.kernel.org>; Tue,  9 May 2023 10:57:31 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id ffacd0b85a97d-306f2b42a86so3977287f8f.3
        for <linux-bcachefs@vger.kernel.org>; Tue, 09 May 2023 10:57:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=truongsinh.pro; s=google; t=1683655050; x=1686247050;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=S6LL4isc7La1a0/CYPICq1mhbCZgFeV2SZYktfMzc4o=;
        b=ct8vCDB28xJuCxqaEFZG6xVUf++2CcVlhv3LEQRRXCHj3HoLtiEmNgy2sQK8FNpPIn
         fDbUEIwvJEHlfJHWuFAEXxeWInf23ySDRQPqp1nASse7+x807d6EQlE2HU7Wpnpz0qPe
         o82wLHeWsH1uGZHKf7VSgivjlfUDnKUI7RqTM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683655050; x=1686247050;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=S6LL4isc7La1a0/CYPICq1mhbCZgFeV2SZYktfMzc4o=;
        b=VpL2I4GynP1cV/WLhK/hIQa0nwFnysnf7qJS/u99ruQWPQqmX7Ahh3I5j8KWhyyjy9
         TcaU4wJS1fyI35vOwhrww7EYwi2XBvpoFAmxMdRQ10l2s7mu1fSZshhfWNxEaQvQF8i6
         Nr2PDfmSuM/HhGt3HT/FDP+Zzrj1YaHw5DPCRuxU1DXV0lL5rAKc/w+xlawrPSlyrdlm
         hyr2z17G2YB8go12b9bOFWz+29MuRrE9wZ98tx8QfF7aG0bkYr14fFniOwZXLui7EnXq
         aBaU2XK1cc6TsqOEXAbYogPNs1sLyzT1RH9c8NfkEz11j0vDF/w92lba2aX1hINLS2T0
         h5tQ==
X-Gm-Message-State: AC+VfDzg1b+GXvPY0o+lS/dp26PJWMVnqrNyyl4EZlY2343TVZG7WGr0
        o0b3nNbgL4WiaFI7oyuXnoX48eULFQLUiFOgAxb3IQ==
X-Google-Smtp-Source: ACHHUZ4PGv+jpscj7FuCd5tinYXENXRsLvcd1eQM3ClGuqFCXJLOAFgZQ7VimrjA+w9zH9WK+Nm0RZZbc1Ghsd6GvSU=
X-Received: by 2002:adf:f00a:0:b0:306:3286:69a2 with SMTP id
 j10-20020adff00a000000b00306328669a2mr10269051wro.48.1683655049960; Tue, 09
 May 2023 10:57:29 -0700 (PDT)
MIME-Version: 1.0
References: <20230503065354.19071-1-i@truongsinh.pro> <ZFqHFTMqetbQKtah@moria.home.lan>
In-Reply-To: <ZFqHFTMqetbQKtah@moria.home.lan>
From:   TruongSinh Tran-Nguyen <i@truongsinh.pro>
Date:   Tue, 9 May 2023 10:57:18 -0700
Message-ID: <CAMy36z75N9obj0WM+OFhhnzXAPxqhg8PVY7_x8X6JbQABFnMQw@mail.gmail.com>
Subject: Re: [PATCH] chore(util): minimal Rust build example
To:     Kent Overstreet <kent.overstreet@linux.dev>
Cc:     linux-bcachefs@vger.kernel.org, rust-for-linux@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Tue, 9 May 2023 at 10:47, Kent Overstreet <kent.overstreet@linux.dev> wrote:

> We pretty heavily use to_text() functions kernel side; these output to
> printbufs, and in Rust they map nicely to the Display trait - do we have
> that available in the kernel or is that in std?
>

https://doc.rust-lang.org/std/fmt/trait.Display.html Display trait is definitely
in Rust `std`. As for the alternative from kernel, I am still searching.
Worst case, there is nothing right now, Rust-for-linux folks would
happy to take PR
to include it.

> Sounds like that would be a welcome cleanup :)

By clean up, do you mean moving from `uuid_le` to `uuid_t`?

Also, I don't expect this PR to be merge, as it is for demonstration
purposes only,
however, what would be a minimum mergeable PR (related to Rust build)
that you would consider?

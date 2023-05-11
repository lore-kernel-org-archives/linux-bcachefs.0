Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D8CFC7EE22
	for <linux-bcachefs@archiver.kernel.org>; Thu, 11 May 2023 23:38:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239198AbjEKXiF (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Thu, 11 May 2023 19:38:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238053AbjEKXiE (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Thu, 11 May 2023 19:38:04 -0400
Received: from mail-yb1-xb36.google.com (mail-yb1-xb36.google.com [IPv6:2607:f8b0:4864:20::b36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5FEA170D;
        Thu, 11 May 2023 16:37:59 -0700 (PDT)
Received: by mail-yb1-xb36.google.com with SMTP id 3f1490d57ef6-b9daef8681fso7973979276.1;
        Thu, 11 May 2023 16:37:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683848279; x=1686440279;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/Q2KKeQgU14QxWnFG+IpzqMI5PqMSFCbtm/YyhydxSQ=;
        b=Rent9btAE2kubLm8DSVbxue3ZRAXQDskz5wTRBSrSulqrY87Zkld5PlmQsi8bq4ecA
         9GJBuRCBz1e/bcW5iYBM7RRdXx7I6bJh5nWnhLtJvKlN8yY9HLlgqingMgULvmT45Xp5
         xS60PZGIhMDzfdcE60PJNfsVyvWIE+OhN3McEqOblQavQ5JwPXPBLg30cZotHpsF9+dr
         nRaHOhQOSOc+YLFP7+MWGW9KVJovktYM/08yoqYY4Vdux2ocKsjlsYTc/kLxRro2+Fe7
         aPH2IGnINyHses4ZMArNqH6AhCEQFiJxuEkFDNTj7gn34Ba+0pk8s25jwVLVIGgXGLZW
         pzZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683848279; x=1686440279;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/Q2KKeQgU14QxWnFG+IpzqMI5PqMSFCbtm/YyhydxSQ=;
        b=DOdj3NtEV5DR/F+oN8oYFZaDPQaMr6gpQmFdqkb/NVsbN5xfwvSPbt1p7ZR3+AFUHg
         QysP7oTU+oqWGBAlI7ni0fcp50GVFLeDqo6ch/IEcnpY+2fbI0ll6GkTp5fO3rkiQPTI
         VFGHTk4TQkc/V9ygsNP7Ii0FTLC597pBwV1a3//Z6VG9+/Op13FiWu2WOFvWnT5f8FEg
         AUlTLbnJJQvK0vynNz8nphZfMmi/TFXAG7Ws48pG7IGkuThrlNtif5QgPxpkFhkXIkLm
         eAsHHb8p6LdHXEcwVqkV1M9TpVCvLtRV9pqIG1ljPPTri3D5ML8icqMKQEgoAYelxkLT
         eNzw==
X-Gm-Message-State: AC+VfDz568V1/AbRTtJnC7SLjZlfqaT5EYxRk/mWbw6yclrbxjm0DuQi
        /Y60bcUCDi0EkM0knkYPnYyf/oNBDdF6Xr5gUwQ=
X-Google-Smtp-Source: ACHHUZ7WSyHy09W42DCYy9g4GPHKgJOBy03eLw9tGPYXeng2ATt0x5OkP3s7jfMOIW/1wPCPo7p14YUyJWRv16swYaY=
X-Received: by 2002:a25:26cc:0:b0:ba1:e7f2:8369 with SMTP id
 m195-20020a2526cc000000b00ba1e7f28369mr22392666ybm.40.1683848278801; Thu, 11
 May 2023 16:37:58 -0700 (PDT)
MIME-Version: 1.0
References: <20230503065354.19071-1-i@truongsinh.pro> <ZFqHFTMqetbQKtah@moria.home.lan>
 <CANiq72mwHa9coRUQqprGaEhLoac=spX2-2X4CMKYBYrovkQoLA@mail.gmail.com> <ZFvmKk86vBD051n7@moria.home.lan>
In-Reply-To: <ZFvmKk86vBD051n7@moria.home.lan>
From:   Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date:   Fri, 12 May 2023 01:37:47 +0200
Message-ID: <CANiq72kqeyUk0-405t6sXZMw17-YPtZjJg_Zqi5v59qqGHAMDQ@mail.gmail.com>
Subject: Re: [PATCH] chore(util): minimal Rust build example
To:     Kent Overstreet <kent.overstreet@linux.dev>
Cc:     TruongSinh Tran-Nguyen <i@truongsinh.pro>,
        linux-bcachefs@vger.kernel.org, rust-for-linux@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Wed, May 10, 2023 at 8:45=E2=80=AFPM Kent Overstreet
<kent.overstreet@linux.dev> wrote:
>
> I've been doing the same thing.
>
> Right now in bcachefs-tools we've got two different crates, one for
> bcachefs rust code proper and another for bindings, with a build.rs for
> bindgen.

Sounds great. (I was mentioning it due to the patch above, mostly,
i.e. I wouldn't recommend reimplementing a single function and writing
the bindings manually etc. -- the patch also was not follow either the
C or Rust styles).

> Any pointers to how we'll be interacting with bindgen kernel side? We
> need to pass it some stuff, see
> https://evilpiepirate.org/git/bcachefs-tools.git/tree/rust-src/bch_bindge=
n/build.rs

Currently we put the `#include`s in `rust/bindings/bindings_helper.h`,
and options if needed (e.g. allows/blocks like you also have) in
`rust/bindgen_parameters`.

When the `kernel` crate split happens, we may have
per-crate/per-subsystem/... configuration for this, too.

Cheers,
Miguel

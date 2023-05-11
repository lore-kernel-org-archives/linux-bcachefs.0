Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2C24C77B7C
	for <linux-bcachefs@archiver.kernel.org>; Thu, 11 May 2023 23:39:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239465AbjEKXjS (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Thu, 11 May 2023 19:39:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238953AbjEKXjR (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Thu, 11 May 2023 19:39:17 -0400
Received: from mail-yw1-x1130.google.com (mail-yw1-x1130.google.com [IPv6:2607:f8b0:4864:20::1130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99487B3;
        Thu, 11 May 2023 16:39:16 -0700 (PDT)
Received: by mail-yw1-x1130.google.com with SMTP id 00721157ae682-55c939fb24dso86800967b3.2;
        Thu, 11 May 2023 16:39:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683848356; x=1686440356;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rEeaQrDU6+P+R6qmxcJotruFw/nOblXhWtI3OV+dYic=;
        b=dmAEzk7RbUuUDkVzshoLCZO779CbEWlAC33Vce9M7pLiqx21D1Av5QRAlJh/qzwl6e
         NSDebB+gSkQYwuMOPHa6o5UjAVwlFkQSPJK4iKaD18uyvgOz0e8/pa7OQK4y+zIhfQSV
         EcDeENEHWnvfIeNN98kbUWBk2/0fnE3K5uFXkMq84Vz/88z6Oku+gvwUH+sJGI+LnRiS
         MaICS7hDbMVnNQotao5vInC3yC9Vp4aUlO8Ho2ZKTaTu/6zqwtEpruDYsxJ1cT8p8BAa
         +llYTYExmsUUi/TjwsmSFd9c9vBLcwssShS/2RZ/ZX+0cfsI5hj9HO1iNi75I3FUbcC0
         AJxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683848356; x=1686440356;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rEeaQrDU6+P+R6qmxcJotruFw/nOblXhWtI3OV+dYic=;
        b=KTn8qYEmDCIportl5wkLzEYONlEOuq8+k5K9W18TY0VD5rlULZcTTdAYRkfco2D4Fg
         JYe0INhcI9/yu26vDb54FzFwBsVtsP3aFLzoRP8XlMhPOrOVEhY66X7FX5BNbhtS0wqf
         cVHA4Vo5sgAai7ENmASbjk2+ikhwACoWklgCE96Kk2yXE0o1auYAGAUgu4Gw5bQZvnsc
         gi+vQ5EEIDg0YzIoS0HclnTIBgwW5rSewlli57gVWmwCn9faVsSMB11JAPzZ+OzCcANK
         Xe9nYYlMvrJyo7JTejQa10jzL7490JbSbW6pbtVONCj2yvv+oYJOy7wYF3i4n2RHHbXt
         CscQ==
X-Gm-Message-State: AC+VfDzKLy23w0D0dZNoych8aAgzSanZQQBAnRwr8Nzv9YqOFsAENUio
        HtIrFNrXaHGdbJU/jv2Zp6aPOTCpHOqXBBOo3pF1rHY685c=
X-Google-Smtp-Source: ACHHUZ49DWM752iXtGCuH30YDHeMFINHRYFPef2G+EfbsfKIMdZoAHRwwQHeU8DdZ8nYHD4mTdjeNdBUjg8cbL9SOa4=
X-Received: by 2002:a0d:d4c3:0:b0:55a:9d84:2e4e with SMTP id
 w186-20020a0dd4c3000000b0055a9d842e4emr23124362ywd.18.1683848355441; Thu, 11
 May 2023 16:39:15 -0700 (PDT)
MIME-Version: 1.0
References: <20230503065354.19071-1-i@truongsinh.pro> <ZFqHFTMqetbQKtah@moria.home.lan>
 <CAMy36z75N9obj0WM+OFhhnzXAPxqhg8PVY7_x8X6JbQABFnMQw@mail.gmail.com>
 <ZFqM8HOvlVn61VXs@moria.home.lan> <CANeycqq5xCUcjOeOfGAJCH1Tzd01-ALU3uqVJo-BvVX9HOK9wA@mail.gmail.com>
 <CAMy36z5VP_6atrxdOyXSO6G+R36vA8SuaWCDAui3Om3viogPkQ@mail.gmail.com>
 <CAMy36z6+RjgAfEYUxpOhS6vFmTter=cFa2CEorSnKR=qxkft=A@mail.gmail.com>
 <CANiq72nYq5vimbhvfyUj9ejOS487LCQBxkv+7Nt5yYJ2xW_U-A@mail.gmail.com> <ZFvkk9QUpIBTAIWj@moria.home.lan>
In-Reply-To: <ZFvkk9QUpIBTAIWj@moria.home.lan>
From:   Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date:   Fri, 12 May 2023 01:39:04 +0200
Message-ID: <CANiq72mFDr6LGXQg+e_VnO23UhmFxQvHHN7JdctrEZbX0fy9cQ@mail.gmail.com>
Subject: Re: [PATCH] chore(util): minimal Rust build example
To:     Kent Overstreet <kent.overstreet@linux.dev>
Cc:     TruongSinh Tran-Nguyen <i@truongsinh.pro>,
        rust-for-linux@vger.kernel.org,
        Wedson Almeida Filho <wedsonaf@gmail.com>,
        linux-bcachefs@vger.kernel.org, Andreas Hindborg <nmi@metaspace.dk>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Wed, May 10, 2023 at 8:38=E2=80=AFPM Kent Overstreet
<kent.overstreet@linux.dev> wrote:
>
> Has cargo vendor been getting discussed?

If you mean for dynamically fetching things, yeah, that is an option
(I think we discussed it in Kangrejos?); but the implementation
specifics are not too important: what we need is getting the agreement
from kernel maintainers on dynamically fetching them.

Cheers,
Miguel

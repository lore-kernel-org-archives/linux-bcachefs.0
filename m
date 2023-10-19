Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7CEACDB47E
	for <linux-bcachefs@archiver.kernel.org>; Thu, 19 Oct 2023 00:36:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229697AbjJSAgO (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Wed, 18 Oct 2023 20:36:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229632AbjJSAgN (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Wed, 18 Oct 2023 20:36:13 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FA10FE
        for <linux-bcachefs@vger.kernel.org>; Wed, 18 Oct 2023 17:36:12 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id 98e67ed59e1d1-27d23f1e3b8so5655969a91.1
        for <linux-bcachefs@vger.kernel.org>; Wed, 18 Oct 2023 17:36:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1697675772; x=1698280572; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+1houlz2b7FH3DTIGxa/1iwOd2QB82xPjuUDdSR3N80=;
        b=YXvyqPQ3vqksvk1q6UIJ64V8RO1jsjvXrPHU5lsXkQjVAiD0m6yiFM0ELFa/ldzgEv
         CQ8ZtS8bJh/ss3Voloswj84w1R4OPubwQFSl3ZXsLMxoIUL0gYLn74lswBrU7LEWL1Rh
         YQC9xDhyKrx4+HhO+S/vFATxllMyPP6fwxhA3vCWERlx4n7WXn/Klsi/hOwi61tatc/w
         0D9+Fpq4sNGYEIzfgM4+J/9WSuTfKrhRxKIUkdjz+WC3ESS60QJIJMrbLTWFV+WlfdfX
         HgY1PDJe+V8C8jpky8cSxFOhBItHTXafuc9P9eNMm0pvgI6uQDNsY4jcUafr1r+cE73U
         ozPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697675772; x=1698280572;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+1houlz2b7FH3DTIGxa/1iwOd2QB82xPjuUDdSR3N80=;
        b=k+czGyxQp83HxireMz88f6446JH+cC3s3ca1mcnZwoDoo2na9f9T7+9f88II6Ez3Mp
         ZIAFmFMUdUhMnHKn82kkfjVMudm2rogBcDLR8/+ndGSrYYklz4le2Md6ykN9ze7oAZrJ
         iVZSosibTDcNMvZhC7eFVp2XOqfdZsA4E0EywGePyZRuGn4hXz/Ergy6933Q9FtBjaDB
         Z6EcrRdDzxhyIb3It1aWk98cDXzZt/HC/NLJayAnzMME8tjw0yYsv8azcjkKEIznMu3O
         A0vL7DduFq6tJLGgmny7NBXp40jF+NPcAI1sPqGbty+A1WOsrMYw9d+EMKh2jwJqsqhf
         Lztw==
X-Gm-Message-State: AOJu0Ywn1M6FbkqDBxEOxheEdzgc0MTdcvakMjFOnr+exUHdU+HdcLy4
        waGnh2WJpV0Jf7GXHF1LDljku4bU/QFcnM9sWMGIMkMtcLZDgg==
X-Google-Smtp-Source: AGHT+IFbkSN7zHNJtvwI4hPF8N8iZuLSic17Wb2UfgHCXxV+JicqnFY5eBDXzG0UKSR88xNYAw0poKK051mcwtMdvYw=
X-Received: by 2002:a17:90b:38cf:b0:26c:f9a5:4493 with SMTP id
 nn15-20020a17090b38cf00b0026cf9a54493mr747121pjb.5.1697675771993; Wed, 18 Oct
 2023 17:36:11 -0700 (PDT)
MIME-Version: 1.0
References: <CAPxz1+Yt644v4q-ahjE46Sh_ZZSE2r=wwSaup4nYC4uYgQy+rA@mail.gmail.com>
 <20231018202955.i2xjqqpd7cubunvg@moria.home.lan> <CAPxz1+ZTODcUt=nbToDtpsHr1LW04VNVqDPJNV2QhuXb-=+CnQ@mail.gmail.com>
 <20231019002654.cgsmfhu6pxnh4vro@moria.home.lan>
In-Reply-To: <20231019002654.cgsmfhu6pxnh4vro@moria.home.lan>
From:   Parke <parke.nexus@gmail.com>
Date:   Wed, 18 Oct 2023 17:35:33 -0700
Message-ID: <CAPxz1+YcGd23wH4J+Vo1ES6-ncMaW0ga6DSxehS8Ty=t6rTbNg@mail.gmail.com>
Subject: Re: Bcachefs: export a different st_dev for each subvolume
To:     Kent Overstreet <kent.overstreet@linux.dev>
Cc:     linux-bcachefs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Wed, Oct 18, 2023 at 5:27=E2=80=AFPM Kent Overstreet
<kent.overstreet@linux.dev> wrote:
> What about testing if st_dev is different from the parent directory?

That was my first thought.

Unfortunately, there are complications due to symlinks, bind mounts,
and possibly other factors.

Discussion here:
https://lists.gnu.org/archive/html/coreutils/2023-10/msg00013.html

Cheers,

Parke

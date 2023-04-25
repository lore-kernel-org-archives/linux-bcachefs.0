Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B0D2C77B61
	for <linux-bcachefs@archiver.kernel.org>; Tue, 25 Apr 2023 16:58:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234859AbjDYQ6J (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Tue, 25 Apr 2023 12:58:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234853AbjDYQ6I (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Tue, 25 Apr 2023 12:58:08 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F180C17A1A
        for <linux-bcachefs@vger.kernel.org>; Tue, 25 Apr 2023 09:57:44 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id ffacd0b85a97d-3003b97fa12so3657117f8f.2
        for <linux-bcachefs@vger.kernel.org>; Tue, 25 Apr 2023 09:57:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=truongsinh.pro; s=google; t=1682441863; x=1685033863;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YlGcycSuM8B/bKSVsWbKGnGcnH3NdftC3isKkxalppY=;
        b=d21I66cEfAsIFjZVjLMZICJpQuxnpM0fujTy5LItW0s/x7U/Zpx3N4ydOw3YrukSK+
         oaA7wzCw1MKBOjxLoKOreedtye1KRQ0C+ba6SDTAruKY5NOE6mJpS3gcEu8WtVX/f0+j
         yHYGQ/NVOf97CsoBPIxWFZZ+UFPTtFkb4KvAE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682441863; x=1685033863;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YlGcycSuM8B/bKSVsWbKGnGcnH3NdftC3isKkxalppY=;
        b=IC9J5ughjBsCHmHiZzz7t5IdsMK/uMe8UHAumOsXAcIDz9q0teHN9ZO0QkOT8w9FC7
         WdP351x+3XKNozDJiAoLA6V3oFbk5/9e4PUkGese84CNBoy1dio6HOEMJ7g0aJXqf4Fk
         vz2TztkmIPrGkNyp02Y2jKhwdo3ImoIMJyacnDq8aWfI/X6ERyLSbJXSTygAA774WZui
         FG5vmqQZJ1RLzGPISLjiTkBGUYCek6N1UhoNGvv2chRp4rmegg1MfJPEkCN8GEBClhhF
         Njnu65HcQErv+3TnGJhMhJqenk+wSSKnmwtxO/z2XqaeKOpLXhzwtEZTVZn9NZ1+w7+1
         BmXg==
X-Gm-Message-State: AAQBX9fyd81F6drMWHnRvIgp8Hg9efV29iEqctYnI8g91XFSsC+jZwvA
        c3HY8McJpHcL+U5tHGVOLFJd4eqLBBsGVf5spRic5Q==
X-Google-Smtp-Source: AKy350YdsjKfo3oew2Kwh1TL+PNg2/3rW2Yj1UItigZMEsNWzTJ2VOoG4TkOarwHvzLwUtr3WdexhFT1pQYYG5ty2Go=
X-Received: by 2002:adf:cd85:0:b0:2f4:55c3:8452 with SMTP id
 q5-20020adfcd85000000b002f455c38452mr13939934wrj.22.1682441863019; Tue, 25
 Apr 2023 09:57:43 -0700 (PDT)
MIME-Version: 1.0
References: <CAMy36z4rxgcNUmxrtapBx_LY-ZYuB0_r2pEVSf27REodE4R3Sw@mail.gmail.com>
 <CAMy36z7GKiv5_u=WmoDpzFMUeRaWPaAme2eFmdgDdDJ+g-sROQ@mail.gmail.com> <ZEfyx+JWCtR3Yl9W@moria.home.lan>
In-Reply-To: <ZEfyx+JWCtR3Yl9W@moria.home.lan>
From:   TruongSinh Tran-Nguyen <i@truongsinh.pro>
Date:   Tue, 25 Apr 2023 09:57:31 -0700
Message-ID: <CAMy36z5MnjgvCAj0NmPfLo=sAkX8ho0yVG_psq-O-vEV3iRNtQ@mail.gmail.com>
Subject: Re: PR contribution
To:     Kent Overstreet <kent.overstreet@linux.dev>
Cc:     linux-bcachefs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

Done, i just send over 2 patches.

> not as big of  a fan of github's PR interface

How about Gitlab? See https://stackoverflow.com/a/68238913/1326678

> Consider lowering the barrier to entry by using modern tools such as GitH=
ub, GitLab, or BitBucket to manage your projects and accept patches, in lie=
u of emailed patches, email mailing lists, and git send-email. One huge suc=
cess case of making this transition recently is KiCad. In 2020 they were st=
ill using emailed git patches. Now, they have migrated fully to GitLab: htt=
ps://gitlab.com/kicad. Their issue reporting and management, for instance, =
is sooooo much easier now!: https://gitlab.com/kicad/code/kicad/-/issues.

Kind regards,
Sinh

TruongSinh Tran-Nguyen, PMI-ACP, PSM III, PSPO III

Tech Visionary, Craftsman, Coach and Investor

+1-6127-TR-SINH (+1-6127-87-7464) | @truongsinhtn

Find me on LinkedIn | Twitter | Github | StackOverflow

IBAN: LT76 3250 0264 6898 1177 | BIC: REVOLT21

Currently Reading

Get your own email signature

Kind regards,
Sinh

TruongSinh Tran-Nguyen, PMI-ACP, PSM III, PSPO III

Tech Visionary, Craftsman, Coach and Investor

+1-6127-TR-SINH (+1-6127-87-7464) | @truongsinhtn

Find me on LinkedIn | Twitter | Github | StackOverflow

IBAN: LT76 3250 0264 6898 1177 | BIC: REVOLT21

Currently Reading

Get your own email signature




On Tue, 25 Apr 2023 at 08:33, Kent Overstreet <kent.overstreet@linux.dev> w=
rote:
>
> On Mon, Apr 24, 2023 at 10:05:05AM -0700, TruongSinh Tran-Nguyen wrote:
> > Hi, I have 2 PRs on GitHub for bcachfs-tools [1] [2], but I don't know
> > whether it's more likely to be discussed and reviewed on this mailing
> > list. I can also submit git patch on this mailing list if it is easier
> > for the maintainer.
>
> Yeah we use github for issue tracking but I'm not as big of a fan of
> github's PR interface. Could you send the patches to the list?

Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B083C77B61
	for <linux-bcachefs@archiver.kernel.org>; Tue, 25 Apr 2023 16:42:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234455AbjDYQmk (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Tue, 25 Apr 2023 12:42:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234301AbjDYQmk (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Tue, 25 Apr 2023 12:42:40 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3561665BC
        for <linux-bcachefs@vger.kernel.org>; Tue, 25 Apr 2023 09:42:38 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id 5b1f17b1804b1-3f19c473b9eso89593135e9.0
        for <linux-bcachefs@vger.kernel.org>; Tue, 25 Apr 2023 09:42:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=truongsinh.pro; s=google; t=1682440956; x=1685032956;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=MJleUiuiKIDlww8VCA6zt+Ol1R3fion3Eil5tblcZHY=;
        b=WuAhYyJXeahxUdPiiZRrHXmLcTUZCGgv90VXwzMX4HwfUQczZxdQCPQkKzoFCcqrTx
         Xr5vb6kOcHlTLUb/Tk3YYmgahuSNawPm+EE7blnpYfkJWipqsMKg+arBFU5BAM7PJQV6
         v9MoImt53g06Nf4L5XaU+zp7C4Bo56ptgzjpM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682440956; x=1685032956;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MJleUiuiKIDlww8VCA6zt+Ol1R3fion3Eil5tblcZHY=;
        b=S3iuuf1RIRWthHXNipn5wbaq+xa1nPjuqP1jBtS6oN0VdYAx6hG//8n1neOOgY/mAv
         qRNPQ/fnWSOcpixLyg8TD+sgL4qaW1lmkZ1iP6REzRVrxuIhVgzYbh15uwfdh71A8Wof
         4RotDAHpG+JyxMJowLsP5GB/1Uft+MZPEbIRLVM8Xp8FUVyJjzqjI4R/JOOEq6iw+aFy
         qRIz+UBLBOqSqL/llD/kvO4DmSV3j36l9ZmBgcaEKbgqJw7FzrwtX0BzMpkITrhFBpd4
         T1B21scQ9unl9YwSKv4ECjhVfj+vNjHaKR6xQi/CgIpodWVvKe9+ZlTQuwq1VfpeRa39
         ukYQ==
X-Gm-Message-State: AAQBX9fgGbcJrIdlwhlFPwDWqLv73rmVHQriGOYDDrNJI3jE5iQvBzXg
        VP02D7lzz9SQJSLlShCwWtA2mPAJFv9UDKujoCIfHw==
X-Google-Smtp-Source: AKy350azOSjTdDu/BJX6ccKM18U0ukcAw3Dl48aSqgUt5Pl3vVo+m53xEsaHAQIa3mospAyg2uZpVP9a+bATdPJtOVw=
X-Received: by 2002:adf:fecd:0:b0:2f8:33bd:a170 with SMTP id
 q13-20020adffecd000000b002f833bda170mr14194309wrs.32.1682440956466; Tue, 25
 Apr 2023 09:42:36 -0700 (PDT)
MIME-Version: 1.0
References: <CAMy36z4rxgcNUmxrtapBx_LY-ZYuB0_r2pEVSf27REodE4R3Sw@mail.gmail.com>
 <CAMy36z7GKiv5_u=WmoDpzFMUeRaWPaAme2eFmdgDdDJ+g-sROQ@mail.gmail.com>
 <ZEfyx+JWCtR3Yl9W@moria.home.lan> <ZEfzlK/Tpsjwbba2@moria.home.lan>
In-Reply-To: <ZEfzlK/Tpsjwbba2@moria.home.lan>
From:   TruongSinh Tran-Nguyen <i@truongsinh.pro>
Date:   Tue, 25 Apr 2023 09:42:24 -0700
Message-ID: <CAMy36z60+phY8Wq7djyjfdgH+pYFniojZ90L1q6uRFSyj6Forw@mail.gmail.com>
Subject: Re: PR contribution
To:     Kent Overstreet <kent.overstreet@linux.dev>
Cc:     linux-bcachefs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

Will do, I need to setup GUI email clients first. Heard that Gmail Web
UI is shit for these workflow

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




On Tue, 25 Apr 2023 at 08:37, Kent Overstreet <kent.overstreet@linux.dev> wrote:
>
> On Tue, Apr 25, 2023 at 11:33:27AM -0400, Kent Overstreet wrote:
> > On Mon, Apr 24, 2023 at 10:05:05AM -0700, TruongSinh Tran-Nguyen wrote:
> > > Hi, I have 2 PRs on GitHub for bcachfs-tools [1] [2], but I don't know
> > > whether it's more likely to be discussed and reviewed on this mailing
> > > list. I can also submit git patch on this mailing list if it is easier
> > > for the maintainer.
> >
> > Yeah we use github for issue tracking but I'm not as big of a fan of
> > github's PR interface. Could you send the patches to the list?
>
> Also, include a link to your git repo in case of issues with git am;
> code review over IRC is also always a good option because then we can
> discuss what you're trying to do.
>
> Thanks!

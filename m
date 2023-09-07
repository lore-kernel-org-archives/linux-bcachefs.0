Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB57AEC8758
	for <linux-bcachefs@archiver.kernel.org>; Thu,  7 Sep 2023 20:52:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237394AbjIGUwQ (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Thu, 7 Sep 2023 16:52:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239155AbjIGUwP (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Thu, 7 Sep 2023 16:52:15 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE0E61BD5
        for <linux-bcachefs@vger.kernel.org>; Thu,  7 Sep 2023 13:52:10 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id a640c23a62f3a-99bf1f632b8so176483966b.1
        for <linux-bcachefs@vger.kernel.org>; Thu, 07 Sep 2023 13:52:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1694119929; x=1694724729; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=D+L9op70z4Tpmb4XlT5693A5llhh03vxW4gvGPs2i44=;
        b=AArLCjcbLc2cQGPDtIHz8MDWZwtvD675aYPWuf/aEjpGAmrBsGa1iSXreWEbR0IgJg
         KGfwWK/+FunAjqoJRXLggPuDbxU9rLDwrds5pR/uCeCYG7jyiOFlQ0pCoMwaZ1cuwS4P
         MZuAmmVNloi19QGas0WaHZhBfEzD1PQo8RYQ0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694119929; x=1694724729;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=D+L9op70z4Tpmb4XlT5693A5llhh03vxW4gvGPs2i44=;
        b=ISFbL/3qIu3mJVYhqr9T/PsSQI9M3HKGRMmkN0MZPWVrrTDkEkCaJWF6tAGBaLHQi1
         ggVvCl/LFcdxHpcOGj4qS7E05cuGeApYR+TwATHkX8eE6OIgcx984ERumK52xG9l/pU0
         S6Ie2XVhCkBeO988oa8jQDhsAaWMuVZHCMDPmO6Vkcrn0vjiWkysSMJsJs8akAFo6NBz
         SmfekWKaHzL26V8QOkVd+2qX1HH9h/Ea23o+trLTcgxcPYp3BCj8aeCzbDadnvHdN03/
         n4uA6kgXgFRQYR5PDS/buiZZspY1HR1lUaZMpbup1lmqGlNH3tdVOuXz6TUfjZxbWA/n
         uFTQ==
X-Gm-Message-State: AOJu0Yy1iFrctwMaWU4WXNJTRvKmcE2rBM6vMClJbttX00Pkj43vc4rC
        KbAyNMXM0d24HnKB9wsqhSEEAEvGHNuSSvjyJGoi176P
X-Google-Smtp-Source: AGHT+IE8qznMh9ZKa3NYqxcIMM41ig2msMoXCSRnFWH0/tpBUBw4HSCOHp/QBA/QRgRRi4ByJELtXw==
X-Received: by 2002:a17:906:738c:b0:99c:b0c9:4ec0 with SMTP id f12-20020a170906738c00b0099cb0c94ec0mr378481ejl.30.1694119929334;
        Thu, 07 Sep 2023 13:52:09 -0700 (PDT)
Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com. [209.85.208.51])
        by smtp.gmail.com with ESMTPSA id f2-20020a1709064dc200b009a1082f423esm105956ejw.88.2023.09.07.13.52.08
        for <linux-bcachefs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 07 Sep 2023 13:52:08 -0700 (PDT)
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-52bcd4db4cbso1835314a12.1
        for <linux-bcachefs@vger.kernel.org>; Thu, 07 Sep 2023 13:52:08 -0700 (PDT)
X-Received: by 2002:a05:6402:156:b0:52d:212d:78ee with SMTP id
 s22-20020a056402015600b0052d212d78eemr314041edu.25.1694119928158; Thu, 07 Sep
 2023 13:52:08 -0700 (PDT)
MIME-Version: 1.0
References: <20230903032555.np6lu5mouv5tw4ff@moria.home.lan>
 <CAHk-=wjUX287gJCKDXUY02Wpot1n0VkjQk-PmDOmrsrEfwPfPg@mail.gmail.com> <20230907203718.upkukiylhbmu5wjh@moria.home.lan>
In-Reply-To: <20230907203718.upkukiylhbmu5wjh@moria.home.lan>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu, 7 Sep 2023 13:51:50 -0700
X-Gmail-Original-Message-ID: <CAHk-=wjnjyOOU+NDcJy5Q7kQrA65UQQJCYUYADbr1Pz7up-8mw@mail.gmail.com>
Message-ID: <CAHk-=wjnjyOOU+NDcJy5Q7kQrA65UQQJCYUYADbr1Pz7up-8mw@mail.gmail.com>
Subject: Re: [GIT PULL] bcachefs
To:     Kent Overstreet <kent.overstreet@linux.dev>
Cc:     linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-bcachefs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Thu, 7 Sept 2023 at 13:37, Kent Overstreet <kent.overstreet@linux.dev> wrote:
>
> Linus, I specifically asked you about linux-next in the offlist pre-pull
> request thread back in May. It would have been nice if I could've gotten
> an answer back then; instead, I'm only getting a definitive answer on
> that now.

I may not have answered because it was so *obvious*.

Was there really any question about it?

Anyway, the fact that the code doesn't even build for me is kind of a
show-stopper regardless. It's the kind of things linux-next is
supposed to notice early, so that we aren't in the situation where the
code has not even been build-tested properly.

                   Linus

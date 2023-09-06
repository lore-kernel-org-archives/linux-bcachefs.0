Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C488EE14C3
	for <linux-bcachefs@archiver.kernel.org>; Wed,  6 Sep 2023 19:36:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244214AbjIFTgo (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Wed, 6 Sep 2023 15:36:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232033AbjIFTgn (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Wed, 6 Sep 2023 15:36:43 -0400
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A851C180
        for <linux-bcachefs@vger.kernel.org>; Wed,  6 Sep 2023 12:36:38 -0700 (PDT)
Received: by mail-lf1-x131.google.com with SMTP id 2adb3069b0e04-500a8b2b73eso238953e87.0
        for <linux-bcachefs@vger.kernel.org>; Wed, 06 Sep 2023 12:36:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1694028997; x=1694633797; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=mtg/nQGifsLU9qENmxHQ00cXrbdcS8vGgWh6gQnrcGw=;
        b=XJTTyExyrCZTjrBfDnQQ/HMwGqwX2BPUSBxIIHdqUV2ciXhUa8L6Os2ZahiyUO6XyC
         MalAgtXIrD3yl1YmsZO6+toCC9Fi6tyu08ew8ZOQCwLSz+z7QyPHI1H8cPTPEYppGvSi
         ZcCipA14wvU1hg9bMcUkOH2uXG9N/dw3eSJhc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1694028997; x=1694633797;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mtg/nQGifsLU9qENmxHQ00cXrbdcS8vGgWh6gQnrcGw=;
        b=bARwCj2/WMAa3LZ5ZcFa7cTtIDWTPWq6gpbBqDNSrVc8cU1VEZIoyFYaU1LGQ4rAE1
         073n/yUE2BDZtT68pLNsMH7KTseHFvxVCSYi2nx1ilVosx3QPwF821371/Bg7iOi/fFU
         5r1DRZ42tgga+FApMndWgSpVeD9IwxHnB5zseKdVnovn19E+4CFXoLxtF1Jchdusj3Pa
         25tePRSweQ4l4jci2XNxEat6UbNh5+n7+o4ew7lAECaZ2qH74Gfa3agWAx89KfdWfEwC
         O7yPjzye7ZPDQkGd11Kc+WCSDQt11gk1+mVRYC0NciaoYw0/KvaR5hmjf34kbnLAD+w7
         68uQ==
X-Gm-Message-State: AOJu0YzRWDfuT+AbLnpAjheoSXozCtNIdiRufSQHyO9zOGllCj3vMfYb
        ei4DxEggX3bALnfiOmA8oeKdLua26Q/aqIbRI9adSw==
X-Google-Smtp-Source: AGHT+IGtnOuxP1vnqsckg65eTONfFXnKefUL5+XYHe6jFjOVIfXv/q4kTpVekJ0MdmsWAZoN3SI+9Q==
X-Received: by 2002:a19:2d02:0:b0:500:adbd:43e7 with SMTP id k2-20020a192d02000000b00500adbd43e7mr3119538lfj.8.1694028996638;
        Wed, 06 Sep 2023 12:36:36 -0700 (PDT)
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com. [209.85.208.46])
        by smtp.gmail.com with ESMTPSA id fj22-20020a0564022b9600b005256aaa6e7asm2627475edb.78.2023.09.06.12.36.35
        for <linux-bcachefs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Sep 2023 12:36:36 -0700 (PDT)
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-52bd9ddb741so167078a12.0
        for <linux-bcachefs@vger.kernel.org>; Wed, 06 Sep 2023 12:36:35 -0700 (PDT)
X-Received: by 2002:a05:6402:334:b0:525:6d6e:ed4a with SMTP id
 q20-20020a056402033400b005256d6eed4amr3250657edw.23.1694028995634; Wed, 06
 Sep 2023 12:36:35 -0700 (PDT)
MIME-Version: 1.0
References: <20230903032555.np6lu5mouv5tw4ff@moria.home.lan>
In-Reply-To: <20230903032555.np6lu5mouv5tw4ff@moria.home.lan>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed, 6 Sep 2023 12:36:18 -0700
X-Gmail-Original-Message-ID: <CAHk-=wjUX287gJCKDXUY02Wpot1n0VkjQk-PmDOmrsrEfwPfPg@mail.gmail.com>
Message-ID: <CAHk-=wjUX287gJCKDXUY02Wpot1n0VkjQk-PmDOmrsrEfwPfPg@mail.gmail.com>
Subject: Re: [GIT PULL] bcachefs
To:     Kent Overstreet <kent.overstreet@linux.dev>
Cc:     linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-bcachefs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

So I'm starting to look at this because I have most other pull
requests done, and while I realize there's no universal support for it
I suspect any further changes are better done in-tree. The out-of-tree
thing has been done.

However, while I'll continue to look at it in this form, I just
realized that it's completely unacceptable for one very obvious
reason:

On Sat, 2 Sept 2023 at 20:26, Kent Overstreet <kent.overstreet@linux.dev> wrote:
>
>   https://evilpiepirate.org/git/bcachefs.git bcachefs-for-upstream

No way am I pulling that without a signed tag and a pgp key with a
chain of trust. You've been around for long enough that having such a
key shouldn't be a problem for you, so make it happen.

There are a few other issues that I have with this, and Christoph did
mention a big one: it's not been in linux-next. I don't know why I
thought it had been, it's just such an obvious thing for any new "I
want this merged upstream" tree.

So these kinds of "I'll just ignore _all_ basic rules" kinds of issues
do annoy me.

I need to know that you understand that if you actually want this
upstream, you need to work with upstream.

That very much means *NOT* continuing this "I'll just do it my way".
You need to show that you can work with others, that you can work
within the framework of upstream, and that not every single thread you
get into becomes an argument.

This, btw, is not negotiable.  If you feel uncomfortable with that
basic notion, you had better just continue doing development outside
the main kernel tree for another decade.

The fact that I only now notice that you never submitted this to
linux-next is obviously on me. My bad.

But at the same time it worries me that it might be a sign of you just
thinking that your way is special.

                Linus

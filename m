Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1D77C001DE
	for <linux-bcachefs@archiver.kernel.org>; Fri, 11 Aug 2023 05:20:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231684AbjHKFUo (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Fri, 11 Aug 2023 01:20:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230459AbjHKFUn (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Fri, 11 Aug 2023 01:20:43 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A6A92D48
        for <linux-bcachefs@vger.kernel.org>; Thu, 10 Aug 2023 22:20:42 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id a640c23a62f3a-997c4107d62so221201566b.0
        for <linux-bcachefs@vger.kernel.org>; Thu, 10 Aug 2023 22:20:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1691731241; x=1692336041;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=8cYlwrRaSF/zKzc5TC0jLD+97834wyo6L2H6kEGojaI=;
        b=hvFplaOxwO+eutNUxYlV7Q52nVCC4Gj4tyNmkZqqAVJBIb6wGenpc3HuxZ/VXRCt6B
         tT98YiTAa0moC3AnOZH9HN6e8wN0z9o2Ggo2s0uom42jIVPvdaZgRyjqP48lBDCHlbC/
         QFa0TrnhX7w1DnphZNwrDW/K1mnzHz4BYyAXQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691731241; x=1692336041;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8cYlwrRaSF/zKzc5TC0jLD+97834wyo6L2H6kEGojaI=;
        b=fSztq0LvwveIeiVb8230woppBKGGOIh0ya7XikQPYGmIru08zLS4cYcksCjFTeKlY8
         4oqVqn+Coqwu9O37CZXWiNapjhw3qgmX2TLu3yhIOuB5Rcg+HAmmk654s5oOieoUioC6
         uooSeHKe5wyKmg13VLneLgNYVkmt5RH2KRMBXpMAzm+yIMtk9t1c3OdDb04bjItepOue
         AwjEbdyiGJXwL6vUl1jXY6HVFjKoYXO49vM1T9eDcu4+4WJHX/huxsql0IjDA7e7EE/Y
         r/ixxKR40AThAOYXyzkNKhBx06Z8hO0QCRIpMioFAh5QzMoXUUtam/cWhxHzy1WcsBey
         o9EQ==
X-Gm-Message-State: AOJu0YxiXY99sCKRNBeuAmooZGuU+6R5LyBu+9Fzpfkcw9I0bnLomlZ5
        yNaBuZ6neOHiEL6MwuoVj3WGYASzqkK+38/+swzVcxHU
X-Google-Smtp-Source: AGHT+IFzwlNJBQ8gHiejMkizSQWbeM7sRk8Ta06yrX226i7bRroI0OfXq2jz2pFw3yIWOr1mCap9bA==
X-Received: by 2002:a17:906:1011:b0:99c:1b9a:b0a0 with SMTP id 17-20020a170906101100b0099c1b9ab0a0mr670414ejm.74.1691731240990;
        Thu, 10 Aug 2023 22:20:40 -0700 (PDT)
Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com. [209.85.208.53])
        by smtp.gmail.com with ESMTPSA id xa5-20020a170907b9c500b0099bd0b5a2bcsm1777520ejc.101.2023.08.10.22.20.39
        for <linux-bcachefs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Aug 2023 22:20:39 -0700 (PDT)
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-522bd411679so1989082a12.0
        for <linux-bcachefs@vger.kernel.org>; Thu, 10 Aug 2023 22:20:39 -0700 (PDT)
X-Received: by 2002:aa7:c382:0:b0:523:22f6:e8a5 with SMTP id
 k2-20020aa7c382000000b0052322f6e8a5mr817276edq.39.1691731239420; Thu, 10 Aug
 2023 22:20:39 -0700 (PDT)
MIME-Version: 1.0
References: <20230626214656.hcp4puionmtoloat@moria.home.lan>
 <20230706155602.mnhsylo3pnief2of@moria.home.lan> <20230712025459.dbzcjtkb4zem4pdn@moria.home.lan>
 <CAHk-=whaFz0uyBB79qcEh-7q=wUOAbGHaMPofJfxGqguiKzFyQ@mail.gmail.com>
 <20230810155453.6xz2k7f632jypqyz@moria.home.lan> <20230810223942.GG11336@frogsfrogsfrogs>
 <CAHk-=wj8RuUosugVZk+iqCAq7x6rs=7C-9sUXcO2heu4dCuOVw@mail.gmail.com> <20230811040310.c3q6nml6ukwtw3j5@moria.home.lan>
In-Reply-To: <20230811040310.c3q6nml6ukwtw3j5@moria.home.lan>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu, 10 Aug 2023 22:20:22 -0700
X-Gmail-Original-Message-ID: <CAHk-=whDuBPONoTMRQn2aX64uYTG5E3QaZ4abJStYRHFMMToyw@mail.gmail.com>
Message-ID: <CAHk-=whDuBPONoTMRQn2aX64uYTG5E3QaZ4abJStYRHFMMToyw@mail.gmail.com>
Subject: Re: [GIT PULL] bcachefs
To:     Kent Overstreet <kent.overstreet@linux.dev>
Cc:     "Darrick J. Wong" <djwong@kernel.org>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-bcachefs@vger.kernel.org, dchinner@redhat.com,
        sandeen@redhat.com, willy@infradead.org, josef@toxicpanda.com,
        tytso@mit.edu, bfoster@redhat.com, jack@suse.cz,
        andreas.gruenbacher@gmail.com, brauner@kernel.org,
        peterz@infradead.org, akpm@linux-foundation.org,
        dhowells@redhat.com, snitzer@kernel.org, axboe@kernel.dk
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Thu, 10 Aug 2023 at 21:03, Kent Overstreet <kent.overstreet@linux.dev> wrote:
>
> On Thu, Aug 10, 2023 at 04:47:22PM -0700, Linus Torvalds wrote:
> > So I might be barking up entirely the wrong tree.
>
> Yeah, I think you are, it sounds like you're describing an entirely
> different sort of race.

I was just going by Darrick's description of what he saw, which
*seemed* to be that umount had finished with stuff still active:

  "Here, umount exits before the filesystem is really torn down, and then
  mount fails because it can't get an exclusive lock on the device."

But maybe I misunderstood, and the umount wasn't actually successful
(ie "exits" may have been "failed with EBUSY")?

So I was trying to figure out what could cause the behavior I thought
Darrick was describing, which would imply a mnt_count issue.

If it's purely "umount doesnt' succeed because the filesystem is still
busy with cleanups", then things are much better.

The mnt_count is nasty, if it's not that, we're actually much better
off, and I'll be very happy to have misunderstood Darrick's case.

              Linus

Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4E8AC001B0
	for <linux-bcachefs@archiver.kernel.org>; Wed,  9 Aug 2023 01:27:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230081AbjHIB1u (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Tue, 8 Aug 2023 21:27:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230049AbjHIB1u (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Tue, 8 Aug 2023 21:27:50 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 843371BC1
        for <linux-bcachefs@vger.kernel.org>; Tue,  8 Aug 2023 18:27:49 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id 4fb4d7f45d1cf-51cff235226so874192a12.0
        for <linux-bcachefs@vger.kernel.org>; Tue, 08 Aug 2023 18:27:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1691544468; x=1692149268;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=O6VpqXFhriUJuQ+K1KbAMi5ftxncBbuJpQzUZ//b884=;
        b=NhOseeA4SwuASXokYQLUhbrXsQ28snOmBb7IDfD0PPAsBKbjSgtP+BmsrakOR0HrXT
         i1j/idi9ZPn28d/JgGk+8/9QyGFjCiyh0P+uwAJeO/1ohJWfK2aj37VtZ1zoy2LeACHa
         Hd5OrZM+7U2adtuZJ3oL7xF2jSId/4Ue8jZgY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691544468; x=1692149268;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=O6VpqXFhriUJuQ+K1KbAMi5ftxncBbuJpQzUZ//b884=;
        b=JGERyqQDv2+y1QTZtqY9Kym1Rl70iV6k86VP5L/mxNRt6p0LzkZs9fBpNYmW/BuIgT
         6z0ZRFZldlyRKJQD/rbGP3wABd10g7eOyxCn2eXZ9kCjIdyGmGvgDQ7u+Ncm9ytZbEjb
         Ys6CWOVGYhUrNflqIlLULSBkoO6uKKg4ko8dCGfW2veusvGcdtGjf5xwVifB3aGN33FF
         daTzURL5//ZULMKhEoOtOVL6S8RW755uSO/X5/sjWh88xSkWmr/7V904AxBbBpwm7zv6
         eGFoJZmBiI2N+2AusWoaIQTFcPPNAKBQ4bNEnX9XBTM7XTU2UytRfp8/Wkdx3P4wZezZ
         AQXA==
X-Gm-Message-State: AOJu0Yx/owowQKqNQONTDo1ApgbHLTsUZiwwz7uVg0rrsQKZjG71HGbp
        BpJkfbsBtzH3IcmudzSiEutsoAc7pkPFRfYnYBacEEth
X-Google-Smtp-Source: AGHT+IGAlBahenWdCs8vhRGx7yuGld4ge7hRPNeLOnE64ytSjfKxAZvXkLTSWmIUH8WKsdzua7Gazg==
X-Received: by 2002:a05:6402:42cf:b0:522:ab20:368a with SMTP id i15-20020a05640242cf00b00522ab20368amr14136776edc.13.1691544467941;
        Tue, 08 Aug 2023 18:27:47 -0700 (PDT)
Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com. [209.85.218.54])
        by smtp.gmail.com with ESMTPSA id l7-20020aa7cac7000000b005231f324a0bsm6559755edt.28.2023.08.08.18.27.46
        for <linux-bcachefs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Aug 2023 18:27:46 -0700 (PDT)
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-99c93638322so86216066b.1
        for <linux-bcachefs@vger.kernel.org>; Tue, 08 Aug 2023 18:27:46 -0700 (PDT)
X-Received: by 2002:a17:907:168a:b0:99b:f42d:b3f6 with SMTP id
 hc10-20020a170907168a00b0099bf42db3f6mr14125951ejc.32.1691544466349; Tue, 08
 Aug 2023 18:27:46 -0700 (PDT)
MIME-Version: 1.0
References: <20230626214656.hcp4puionmtoloat@moria.home.lan>
 <20230706155602.mnhsylo3pnief2of@moria.home.lan> <20230712025459.dbzcjtkb4zem4pdn@moria.home.lan>
In-Reply-To: <20230712025459.dbzcjtkb4zem4pdn@moria.home.lan>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue, 8 Aug 2023 18:27:29 -0700
X-Gmail-Original-Message-ID: <CAHk-=whaFz0uyBB79qcEh-7q=wUOAbGHaMPofJfxGqguiKzFyQ@mail.gmail.com>
Message-ID: <CAHk-=whaFz0uyBB79qcEh-7q=wUOAbGHaMPofJfxGqguiKzFyQ@mail.gmail.com>
Subject: Re: [GIT PULL] bcachefs
To:     Kent Overstreet <kent.overstreet@linux.dev>
Cc:     linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-bcachefs@vger.kernel.org, djwong@kernel.org,
        dchinner@redhat.com, sandeen@redhat.com, willy@infradead.org,
        josef@toxicpanda.com, tytso@mit.edu, bfoster@redhat.com,
        jack@suse.cz, andreas.gruenbacher@gmail.com, brauner@kernel.org,
        peterz@infradead.org, akpm@linux-foundation.org,
        dhowells@redhat.com, snitzer@kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

[ *Finally* getting back to this, I wanted to start reviewing the
changes immediately after the merge window, but something else always
kept coming up .. ]

On Tue, 11 Jul 2023 at 19:55, Kent Overstreet <kent.overstreet@linux.dev> wrote:
>
> So: looks like we missed the merge window. Boo :)

Well, looking at the latest 'bcachefs-for-upstream' state I see, I'm
happy to see the pre-requisites outside bcachefs being much smaller.

The six locks are now contained within bcachefs, and I like what I see
more now that it doesn't play games with 'u64' and lots of bitfields.

I'm still not actually convinced the locks *work* correctly, but I'm
not seeing huge red flags. I do suspect there are memory ordering
issues in there that would all be hidden on x86, and some of it looks
strange, but not necessarily unfixable.

Example of oddity:

                barrier();
                w->lock_acquired = true;

which really smells like it should be

                smp_store_release(&w->lock_acquired, true);

(and the reader side in six_lock_slowpath() should be a
smp_load_acquire()) because otherwise the preceding __list_del()
writes would seem to possibly by re-ordered by the CPU to past the
lock_acquired write, causing all kinds of problems.

On x86, you'd never see that as an issue, since all writes are
releases, so the 'barrier()' compiler ordering ends up forcing the
right magic.

Some of the other oddity is around the this_cpu ops, but I suspect
that is at least partly then because we don't have acquire/release
versions of the local cpu ops that the code looks like it would want.

I did *not* look at any of the internal bcachefs code itself (apart
from the locking, obviously). I'm not that much of a low-level
filesystem person (outside of the vfs itself), so I just don't care
deeply. I care that it's maintained and that people who *are*
filesystem people are at least not hugely against it.

That said, I do think that the prerequisites should go in first and
independently, and through maintainers.

And there clearly is something very strange going on with superblock
handling and the whole crazy discussion about fput being delayed. It
is what it is, and the patches I saw in this thread to not delay them
were bad.

As to the actual prereqs:

I'm not sure why 'd_mark_tmpfile()' didn't do the d_instantiate() that
everybody seems to want, but it looks fine to me. Maybe just because
Kent wanted the "mark" semantics for the naming. Fine.

The bio stuff should preferably go through Jens, or at least at a
minimum be acked.

The '.faults_disabled_mapping' thing is a bit odd, but I don't hate
it, and I could imagine that other filesystems could possibly use that
approach instead of the current 'pagefault_disable/enable' games and
->nofault games to avoid the whole "use mmap to have the source and
the destination of a write be the same page" thing.

So as things stand now, the stuff outside bcachefs itself I don't find
objectionable.

The stuff _inside_ bcachefs I care about only in the sense that I
really *really* would like a locking person to look at the six locks,
but at the same time as long as it's purely internal to bcachefs and
doesn't possibly affect anything else, I'm not *too* worried about
what I see.

The thing that actually bothers me most about this all is the personal
arguments I saw.  That I don't know what to do about. I don't actually
want to merge this over the objections of Christian, now that we have
a responsible vfs maintainer.

So those kinds of arguments do kind of have to be resolved, even aside
from the "I think the prerequisites should go in separately or at
least be clearly acked" issues.

Sorry for the delay, I really did want to get these comments out
directly after the merge window closed, but this just ended up always
being the "next thing"..

                  Linus

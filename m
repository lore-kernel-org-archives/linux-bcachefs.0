Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B94EC001DE
	for <linux-bcachefs@archiver.kernel.org>; Thu, 10 Aug 2023 23:47:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229581AbjHJXro (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Thu, 10 Aug 2023 19:47:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbjHJXrn (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Thu, 10 Aug 2023 19:47:43 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0077C270C
        for <linux-bcachefs@vger.kernel.org>; Thu, 10 Aug 2023 16:47:42 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id 4fb4d7f45d1cf-5222c5d71b8so1828627a12.2
        for <linux-bcachefs@vger.kernel.org>; Thu, 10 Aug 2023 16:47:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1691711261; x=1692316061;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=F1xWybKR18fWfB7DSn1NMqec9tUAwt+hx2Ek1PR4oVQ=;
        b=L0yf5/i2QRjbI+DN9CltyUfw08xBvcJOtmQmOKVrZPdqbSQQGl8OJvF9KtXbpDmHl1
         2wLDpQj33DvVfgDLeb19fJyFXQmo7lui6nP6X/WSsbY2wCZXFeKTLlovS8rQx8tWhTnk
         4yfs/OJ6ZJLleGXhD6Mzha8ywIXJZkeCMfjcM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691711261; x=1692316061;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=F1xWybKR18fWfB7DSn1NMqec9tUAwt+hx2Ek1PR4oVQ=;
        b=hIzqQwZVXKWPMM+M6sfYBVba93/HPatPvSL7ZfgcJJVTdUk/tjjsztY2O32RSh3FC0
         9o71wkxu1wsrwOXdGcYMKjlga5Ire0PurLubDjso+8kTnExX9mWfsLszfAtnzahzp6iQ
         JPsIUoV02c9JMjtR0BNCpwzqmHo9GOmHB4EoerJf2C1JkByYOP21fvUdrJz3kewQMdWa
         veX5XRQShCY8q4q8yZaxcAI/v1c1+oPg1YbzxHAYbX0Y0lSeeFrx/qbulHG1GOGdNZIU
         hkXxVFYbtNeXQpdnoL0z4pXvr56xocjK8c13PsksOwwSc/pqiEcuEY+a/dL99ksFSbwd
         CeJA==
X-Gm-Message-State: AOJu0YzRqJ2iEhomwpoFIqJKPLAPhBcRGppRVpvcXnSa9r//e84aTLg9
        9MplYvWdMOnOocEW84GAVPJ7vQ0WHKefRd1PiBbh1E6h
X-Google-Smtp-Source: AGHT+IFwZnw9+Ny/Ys2YsDwgkU8RxyUQyuFnkUU69uel328iBmtTsPe1MEXgHFLkPzpwjPITWBqRmg==
X-Received: by 2002:a17:906:3044:b0:992:42d4:a7dc with SMTP id d4-20020a170906304400b0099242d4a7dcmr321074ejd.21.1691711261394;
        Thu, 10 Aug 2023 16:47:41 -0700 (PDT)
Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com. [209.85.208.44])
        by smtp.gmail.com with ESMTPSA id lz15-20020a170906fb0f00b0099bc2d1429csm1525184ejb.72.2023.08.10.16.47.39
        for <linux-bcachefs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Aug 2023 16:47:40 -0700 (PDT)
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-51bece5d935so1838744a12.1
        for <linux-bcachefs@vger.kernel.org>; Thu, 10 Aug 2023 16:47:39 -0700 (PDT)
X-Received: by 2002:a50:fa87:0:b0:523:6bcd:9451 with SMTP id
 w7-20020a50fa87000000b005236bcd9451mr398376edr.13.1691711259520; Thu, 10 Aug
 2023 16:47:39 -0700 (PDT)
MIME-Version: 1.0
References: <20230626214656.hcp4puionmtoloat@moria.home.lan>
 <20230706155602.mnhsylo3pnief2of@moria.home.lan> <20230712025459.dbzcjtkb4zem4pdn@moria.home.lan>
 <CAHk-=whaFz0uyBB79qcEh-7q=wUOAbGHaMPofJfxGqguiKzFyQ@mail.gmail.com>
 <20230810155453.6xz2k7f632jypqyz@moria.home.lan> <20230810223942.GG11336@frogsfrogsfrogs>
In-Reply-To: <20230810223942.GG11336@frogsfrogsfrogs>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu, 10 Aug 2023 16:47:22 -0700
X-Gmail-Original-Message-ID: <CAHk-=wj8RuUosugVZk+iqCAq7x6rs=7C-9sUXcO2heu4dCuOVw@mail.gmail.com>
Message-ID: <CAHk-=wj8RuUosugVZk+iqCAq7x6rs=7C-9sUXcO2heu4dCuOVw@mail.gmail.com>
Subject: Re: [GIT PULL] bcachefs
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Kent Overstreet <kent.overstreet@linux.dev>,
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

On Thu, 10 Aug 2023 at 15:39, Darrick J. Wong <djwong@kernel.org> wrote:
>
> FWIW I recently fixed all my stupid debian package dependencies so that
> I could actually install liburing again, and rebuilt fstests.  The very
> next morning I noticed a number of new test failures in /exactly/ the
> way that Kent said to expect:
>
> fsstress -d /mnt & <sleep then simulate fs crash>; \
>         umount /mnt; mount /dev/sda /mnt
>
> Here, umount exits before the filesystem is really torn down, and then
> mount fails because it can't get an exclusive lock on the device.

I agree that that obviously sounds like mount is just returning either
too early. Or too eagerly.

But I suspect any delayed fput() issues (whether from aio or io_uring)
are then just a way to trigger the problem, not the fundamental cause.

Because even if the fput() is delayed, the mntput() part of that
delayed __fput action is the one that *should* have kept the
filesystem mounted until it is no longer busy.

And more importantly, having some of the common paths synchronize
*their* fput() calls only affects those paths.

It doesn't affect the fundamental issue that the last fput() can
happen in odd contexts when the file descriptor was used for something
a bit stranger.

So I do feel like the fput patch I saw looked more like a "hide the
problem" than a real fix.

Put another way: I would not be surprised in the *least* if then
adding more synchronization to fput would basically hide any issue,
particularly from tests that then use those things that you added
synchronization for.

But it really smells like it's purely hiding the symptom to me.

If I were a betting man, I'd look at ->mnt_count.  I'm not saying
that's the problem, but the mnt refcount handling is more than a bit
scary.

It is so hugely performance-critical (ie every single path access)
that we use those percpu counters for it, and I'm not at all sure it's
all race-free.

Just as an example, mnt_add_count() has this comment above it:

 * vfsmount lock must be held for read

but afaik the main way it gets called is through mntget(), and I see
no vfsmount lock held anywhere there (think "path_get() and friends).
Maybe I'm missing something obvious.

So I think that comment is some historical left-over that hasn't been
true for ages.

And all of the counter updates should be consistent even in the
absence of said lock, so it's not an issue.

Except when it is: it does look like it *would* screw up
mnt_get_count() that tries to add up all those percput counters with

        for_each_possible_cpu(cpu) {
                count += per_cpu_ptr(mnt->mnt_pcp, cpu)->mnt_count;
        }

and that one has that

 * vfsmount lock must be held for write

comment, which makes sense as a "that would indeed synchronize if
others held it for read". But...

And where is that sum used? Very much in things like may_umount_tree().

Anyway, I'm absolutely not saying this is the actual problem - we
probably at least partly just have stale or incomplete comments, and
maybe I think the fput() side is good mainly because I'm *much* more
familiar with that side than I am with the actual mount code these
days.

So I might be barking up entirely the wrong tree.

But I do feel like the fput patch I saw looked more like a "hide the
problem" than a real fix. Because the mount counting *should* be
entirely independent of when exactly a fput happens.

So I believe having the test-case then do some common fput's
synchronously pretty much by definition can't fix any issues, but it
*can* make sure that any normal test using just regular system calls
then never triggers the "oh, in other situations the last fput will be
delayed".

So that's why I'm very leery of the fput patch I saw. I don't think it
makes sense.

That does *not* mean that I don't believe that umount can have serious problems.

I suspect we get very little coverage of that in normal situations.

And yes, obviously io_uring does add *way* more asynchronicity, and
I'd not be surprised at all if it uncovers problems.

In most other situations, the main source of file counts are purely
open/close system calls, which are in many ways "simple" (and where
things like process exit obviously does the closing part).

                Linus

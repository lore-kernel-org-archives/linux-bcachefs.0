Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87363EB64DA
	for <linux-bcachefs@archiver.kernel.org>; Wed, 12 Jul 2023 19:48:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232634AbjGLTsf (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Wed, 12 Jul 2023 15:48:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232476AbjGLTse (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Wed, 12 Jul 2023 15:48:34 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E1EF1FE4
        for <linux-bcachefs@vger.kernel.org>; Wed, 12 Jul 2023 12:48:33 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id d2e1a72fcca58-666ed230c81so6596149b3a.0
        for <linux-bcachefs@vger.kernel.org>; Wed, 12 Jul 2023 12:48:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1689191312; x=1691783312;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=M4ZDRM5fvQMo9GlwKOHCyQm7Bm/RC8HHEV7PqArueRk=;
        b=P+qxeFDIOXYrfb8mKf4q2MKsfsAdNORvRZzlqorQhCiYlGDr4HR+fqoRqyaaCSw8qs
         gqW+0q6vFVb2yZh+NqTkF3pZvEHl6EAsJ5/5S2zGkkS41VQ+jjWhCanZHeMf4krxerwW
         t0YdCT3qXtqyZGRJ7+TrJBxjvX45zPbkp8JNg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689191312; x=1691783312;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=M4ZDRM5fvQMo9GlwKOHCyQm7Bm/RC8HHEV7PqArueRk=;
        b=PlPtzBvGuztE9f6upkmKvrywYAASyoTTkCMNeScTQOITepVQhFOnNOeDhRRs7yUQUz
         pR/re2XFfsz+XBkUKmRs6Z3Gr9IhxUssns5hzZ5QGs9Hn3ZQkTePC17VNbGtVR7V+BCV
         2qQm7DyWeSJ9V5Alq2lvqPmkCwrHh2igTlIed001V5Z5oTi13lr1cyCDS3wmY1IUZeKP
         mLJLyW3YOLpJukY64SZgbc1SntzI9kd2hI3B35dcdHeEVO0Akmo0rG8oBsiCJRi9jDJP
         Cr/3eU972QvYbptbLUqrWvGRJ8sgPz3HjEyq3RW50BAMJWUzqD9sMaySmytTc/1BazF1
         UBpA==
X-Gm-Message-State: ABy/qLaMGUXTJuEjQZAwQwdUbOT08KGTX815gr81psaA4r57QW2wMlsy
        0oflZN656Y0D6fEY9e3T1Gusxw==
X-Google-Smtp-Source: APBJJlHM2vxo8fnmZa5oicXLm6Q8d+5+DCS3hBxF+8rUtbVzNiS44Xe3ydnwgRLPo/qT2TQvgD/JCw==
X-Received: by 2002:a05:6a20:7353:b0:132:2f7d:29ca with SMTP id v19-20020a056a20735300b001322f7d29camr7630596pzc.24.1689191312528;
        Wed, 12 Jul 2023 12:48:32 -0700 (PDT)
Received: from www.outflux.net (198-0-35-241-static.hfc.comcastbusiness.net. [198.0.35.241])
        by smtp.gmail.com with ESMTPSA id h3-20020aa786c3000000b00682af82a9desm4082520pfo.98.2023.07.12.12.48.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Jul 2023 12:48:32 -0700 (PDT)
Date:   Wed, 12 Jul 2023 12:48:31 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Kent Overstreet <kent.overstreet@linux.dev>
Cc:     torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-bcachefs@vger.kernel.org,
        djwong@kernel.org, dchinner@redhat.com, sandeen@redhat.com,
        willy@infradead.org, josef@toxicpanda.com, tytso@mit.edu,
        bfoster@redhat.com, jack@suse.cz, andreas.gruenbacher@gmail.com,
        brauner@kernel.org, peterz@infradead.org,
        akpm@linux-foundation.org, dhowells@redhat.com, snitzer@kernel.org
Subject: Re: [GIT PULL] bcachefs
Message-ID: <202307121241.8295B924F@keescook>
References: <20230626214656.hcp4puionmtoloat@moria.home.lan>
 <20230706155602.mnhsylo3pnief2of@moria.home.lan>
 <20230712025459.dbzcjtkb4zem4pdn@moria.home.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230712025459.dbzcjtkb4zem4pdn@moria.home.lan>
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Tue, Jul 11, 2023 at 10:54:59PM -0400, Kent Overstreet wrote:
>  - Prereq patch series has been pruned down a bit more; also Mike
>    Snitzer suggested putting those patches in their own branch:
> 
>    https://evilpiepirate.org/git/bcachefs.git/log/?h=bcachefs-prereqs
> 
>    "iov_iter: copy_folio_from_iter_atomic()" was dropped and replaced
>    with willy's "iov_iter: Handle compound highmem pages in
>    copy_page_from_iter_atomic()"; he said he'd try to send this for -rc4
>    since it's technically a bug fix; in the meantime, it'll be getting
>    more testing from my users.
> 
>    The two lockdep patches have been dropped for now; the
>    bcachefs-for-upstream branch is switched back to
>    lockdep_set_novalidate_class() for btree node locks. 
> 
>    six locks, mean and variance have been moved into fs/bcachefs/ for
>    now; this means there's a new prereq patch to export
>    osq_(lock|unlock)
> 
>    The remaining prereq patches are pretty trivial, with the exception
>    of "block: Don't block on s_umount from __invalidate_super()". I
>    would like to get a reviewed-by for that patch, and it wouldn't hurt
>    for others.
> 
>    previously posting:
>    https://lore.kernel.org/linux-bcachefs/20230509165657.1735798-1-kent.overstreet@linux.dev/T/#m34397a4d39f5988cc0b635e29f70a6170927746f

Can you send these prereqs out again, with maintainers CCed
appropriately? (I think some feedback from the prior revision needs to
be addressed first, though. For example, __flatten already exists, etc.)

-- 
Kees Cook

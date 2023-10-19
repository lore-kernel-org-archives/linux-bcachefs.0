Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91AC6CDB47E
	for <linux-bcachefs@archiver.kernel.org>; Thu, 19 Oct 2023 02:28:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231709AbjJSC2m (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Wed, 18 Oct 2023 22:28:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229632AbjJSC2m (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Wed, 18 Oct 2023 22:28:42 -0400
Received: from mail-ot1-x334.google.com (mail-ot1-x334.google.com [IPv6:2607:f8b0:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CB05114
        for <linux-bcachefs@vger.kernel.org>; Wed, 18 Oct 2023 19:28:39 -0700 (PDT)
Received: by mail-ot1-x334.google.com with SMTP id 46e09a7af769-6ce27aadf24so283881a34.2
        for <linux-bcachefs@vger.kernel.org>; Wed, 18 Oct 2023 19:28:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1697682518; x=1698287318; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Pm17BzM2ARI2RrzePHTfnzeX6F07vJD4CzibGyt8MNI=;
        b=TC2KlZq2f+2NP9WBSoxKsyth38NDh+ATmZuG2rIQLAIemhXN2auh2MaLS5WF06Y/bZ
         piOMXBk56AEsAsq1lz8yi2ZBNGYm4SPxN4IIcE0SbCrzbrCs5vw7rjiTxiRBgB75DGbA
         vqz3pUbDrRA34Bg0QErysGhegUmoODSxBh8bM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697682518; x=1698287318;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Pm17BzM2ARI2RrzePHTfnzeX6F07vJD4CzibGyt8MNI=;
        b=wX+JrMX4oTyYWcyqgH1I/SJYMioLHXu7WlkVYSgilpkSTDjRTNzqEY0sRoVJOyjk2J
         z+Q2mjVmZ4KG7NOdlsGTjdbajYwT12cboz9Woud9TgRUtNR1j9wDz76rJlFVhQ2piQH2
         MUiwn5RKfJfWSv+RXg3Z+jLLNUgKmBSHSHvYSSjyo5KgThfYqdJK3WEM5jq8yyrvU2LW
         rURcc/Pc1+WiDaXJLZj9Jy1Y3LbGpiuzwPtPKnfZ39PRnh4zBGU9W5KLh0BJsGEwCGXF
         tNX+/Des0a5h+jrjsKs6ROk7+DiaazllTAXw0ViaBlz0K471/ZVwIh200JZm9ANn5Sbb
         trpg==
X-Gm-Message-State: AOJu0Ywuw8R5rQjvVXRVSgPj8WBqsIRe7yCg9pmgNEsdI3ExEk9tmYYg
        PNMQuXc5g+Ey7xds6n5GnVkZTyhWryBsqSmsqMI=
X-Google-Smtp-Source: AGHT+IH6n/YddGMyyhykRMLGfcwrjiN8g/F/Ne2bkA3nBvBFFVPKu/XWTZPWpMhTQPVvSmD2Qjdyhg==
X-Received: by 2002:a9d:7f94:0:b0:6b7:5687:8a9e with SMTP id t20-20020a9d7f94000000b006b756878a9emr1006430otp.15.1697682518599;
        Wed, 18 Oct 2023 19:28:38 -0700 (PDT)
Received: from www.outflux.net (198-0-35-241-static.hfc.comcastbusiness.net. [198.0.35.241])
        by smtp.gmail.com with ESMTPSA id a129-20020a624d87000000b006906aaf1e4dsm4142079pfb.150.2023.10.18.19.28.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Oct 2023 19:28:37 -0700 (PDT)
Date:   Wed, 18 Oct 2023 19:28:37 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Kent Overstreet <kent.overstreet@linux.dev>
Cc:     Brian Foster <bfoster@redhat.com>, linux-bcachefs@vger.kernel.org,
        kernel test robot <lkp@intel.com>,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH v3] bcachefs: Refactor memcpy into direct assignment
Message-ID: <202310181927.F9CCC45@keescook>
References: <20231018230728.make.202-kees@kernel.org>
 <20231019003232.5uwphr7de7nybsra@moria.home.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231019003232.5uwphr7de7nybsra@moria.home.lan>
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Wed, Oct 18, 2023 at 08:32:32PM -0400, Kent Overstreet wrote:
> On Wed, Oct 18, 2023 at 04:07:32PM -0700, Kees Cook wrote:
> > The memcpy() in bch2_bkey_append_ptr() is operating on an embedded fake
> > flexible array which looks to the compiler like it has 0 size. This
> > causes W=1 builds to emit warnings due to -Wstringop-overflow:
> > 
> >    In file included from include/linux/string.h:254,
> >                     from include/linux/bitmap.h:11,
> >                     from include/linux/cpumask.h:12,
> >                     from include/linux/smp.h:13,
> >                     from include/linux/lockdep.h:14,
> >                     from include/linux/radix-tree.h:14,
> >                     from include/linux/backing-dev-defs.h:6,
> >                     from fs/bcachefs/bcachefs.h:182:
> >    fs/bcachefs/extents.c: In function 'bch2_bkey_append_ptr':
> >    include/linux/fortify-string.h:57:33: warning: writing 8 bytes into a region of size 0 [-Wstringop-overflow=]
> >       57 | #define __underlying_memcpy     __builtin_memcpy
> >          |                                 ^
> >    include/linux/fortify-string.h:648:9: note: in expansion of macro '__underlying_memcpy'
> >      648 |         __underlying_##op(p, q, __fortify_size);                        \
> >          |         ^~~~~~~~~~~~~
> >    include/linux/fortify-string.h:693:26: note: in expansion of macro '__fortify_memcpy_chk'
> >      693 | #define memcpy(p, q, s)  __fortify_memcpy_chk(p, q, s,                  \
> >          |                          ^~~~~~~~~~~~~~~~~~~~
> >    fs/bcachefs/extents.c:235:17: note: in expansion of macro 'memcpy'
> >      235 |                 memcpy((void *) &k->v + bkey_val_bytes(&k->k),
> >          |                 ^~~~~~
> >    fs/bcachefs/bcachefs_format.h:287:33: note: destination object 'v' of size 0
> >      287 |                 struct bch_val  v;
> >          |                                 ^
> > 
> > Avoid making any structure changes and just replace the u64 copy into a
> > direct assignment, side-stepping the entire problem.
> 
> This does make me wonder about the usefulness of the fortify source
> stuff if it can be sidestepped this way, but hey, I'll take it :)

Well, the "weird" cases like this are the ones that get attention. All
the places it's working more cleanly are very effectively stomping real
bugs.

> Pulled it into the testing branch, https://evilpiepirate.org/~testdashboard/ci?branch=bcachefs-testing

Thanks!

-Kees

-- 
Kees Cook

Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B8CAC0015E
	for <linux-bcachefs@archiver.kernel.org>; Wed, 12 Jul 2023 22:38:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232357AbjGLWit (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Wed, 12 Jul 2023 18:38:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232259AbjGLWis (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Wed, 12 Jul 2023 18:38:48 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80AFE1FDB
        for <linux-bcachefs@vger.kernel.org>; Wed, 12 Jul 2023 15:38:46 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id d2e1a72fcca58-668730696a4so77528b3a.1
        for <linux-bcachefs@vger.kernel.org>; Wed, 12 Jul 2023 15:38:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1689201526; x=1691793526;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=H8YUW/Zd4/FzjfHiWuAqocnMNvPoUjuHs9kCi3pQTEg=;
        b=JcItZFYLGNLQpMetpc4AZXWDqjK75pr9B84E73Vg6Z6upHHtSs5EuoCIm08b1fOrw3
         W062q+m+kTVhfF5qDwmOmt5DE0H3S1o9iwgug7J+Af+YeKR6TrJjQyZrS64uyX3g/Vhl
         d9qmNjelUFRc6zilOeKM0muTSuN1qIHW/e5Zc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689201526; x=1691793526;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=H8YUW/Zd4/FzjfHiWuAqocnMNvPoUjuHs9kCi3pQTEg=;
        b=SifIEybpbE87oLjGGcCanEf9xQlgvu6eONvv5uc01n/1N645BZTUZuWArJC++LMdLJ
         ilvuJJibKhG4L6UGTc8SxrZre8raaAvHnT+sxZGuLsMQy0kwzgyk7UOxcGqXWISPKCb6
         7ZYwkzXeqXLGo5Ke9hzTuHZI9BwofxYpnh8hag4DpIIZMv6cRR1etlIITLvnjygG63Me
         jVA1c0saQQdr2/zJeDkGMeOjY6My5EfqImHikppq8cHTqX7g4qilO0RhO8a6X5touRST
         Qj8iWxZp7WOHFEm10QHnD3HJ84bESDD5Hvnyjy3onYwwLD0ql1l5EteTSjxcdGBsXuyu
         g22w==
X-Gm-Message-State: ABy/qLYHS+I5hBUJ5tl7pTSJ1N/NTX6ryFBp60RH7NDUTf21L2rBm1+O
        8DzV9UhupHDjfChD/8Aw8KcS8A==
X-Google-Smtp-Source: APBJJlEdhwXsXcGHCDh9IIXqffyekudE0U73cwGt4G+vJfJhXQWa0KQDZhRcqpkbW+8Hic7He3qlLQ==
X-Received: by 2002:a05:6a21:900c:b0:130:74c8:b501 with SMTP id tq12-20020a056a21900c00b0013074c8b501mr11827939pzb.30.1689201525956;
        Wed, 12 Jul 2023 15:38:45 -0700 (PDT)
Received: from www.outflux.net (198-0-35-241-static.hfc.comcastbusiness.net. [198.0.35.241])
        by smtp.gmail.com with ESMTPSA id bc1-20020a170902930100b001b3fb2f0296sm4462298plb.120.2023.07.12.15.38.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Jul 2023 15:38:45 -0700 (PDT)
Date:   Wed, 12 Jul 2023 15:38:44 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Kent Overstreet <kent.overstreet@linux.dev>
Cc:     linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-bcachefs@vger.kernel.org,
        Kent Overstreet <kent.overstreet@gmail.com>,
        linux-hardening@vger.kernel.org
Subject: Re: [PATCH 29/32] lib/string_helpers: string_get_size() now returns
 characters wrote
Message-ID: <202307121525.B3B6153D8@keescook>
References: <20230509165657.1735798-1-kent.overstreet@linux.dev>
 <20230509165657.1735798-30-kent.overstreet@linux.dev>
 <202307121248.36919B223@keescook>
 <20230712201931.kuksw5zmuwah7tqs@moria.home.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230712201931.kuksw5zmuwah7tqs@moria.home.lan>
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Wed, Jul 12, 2023 at 04:19:31PM -0400, Kent Overstreet wrote:
> On Wed, Jul 12, 2023 at 12:58:54PM -0700, Kees Cook wrote:
> > On Tue, May 09, 2023 at 12:56:54PM -0400, Kent Overstreet wrote:
> > > From: Kent Overstreet <kent.overstreet@gmail.com>
> > > 
> > > printbuf now needs to know the number of characters that would have been
> > > written if the buffer was too small, like snprintf(); this changes
> > > string_get_size() to return the the return value of snprintf().
> > 
> > Unfortunately, snprintf doesn't return characters written, it return
> > what it TRIED to write, and can cause a lot of problems[1]. This patch
> > would be fine with me if the snprintf was also replaced by scnprintf,
> > which will return the actual string length copied (or 0) *not* including
> > the trailing %NUL.
> 
> ...All of which would be solved if we were converting code away from raw
> char * buffers to a proper string building type.
> 
> Which I tried to address when I tried to push printbufs upstream, but
> that turned into a giant exercise in frustration in dealing with
> maintainers.

Heh, yeah, I've been trying to aim people at using seq_buf instead of
a long series of snprintf/strlcat/etc calls. Where can I look at how
you wired this up to seq_buf/printbuf? I had trouble finding it when I
looked before. I'd really like to find a way to do it without leaving
around foot-guns for future callers of string_get_size(). :)

I found the printbuf series:
https://lore.kernel.org/lkml/20220808024128.3219082-1-willy@infradead.org/
It seems there are some nice improvements in there. It'd be really nice
if seq_buf could just grow those changes. Adding a static version of
seq_buf_init to be used like you have PRINTBUF_EXTERN would be nice
(or even a statically sized initializer). And much of the conversions
is just changing types and functions. If we can leave all that alone,
things become MUCH easier to review, etc, etc. I'd *love* to see an
incremental improvement for seq_buf, especially the heap-allocation
part.

-- 
Kees Cook

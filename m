Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCE5FC001DE
	for <linux-bcachefs@archiver.kernel.org>; Wed, 12 Jul 2023 23:53:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231758AbjGLXxx (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Wed, 12 Jul 2023 19:53:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231791AbjGLXxw (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Wed, 12 Jul 2023 19:53:52 -0400
Received: from out-12.mta1.migadu.com (out-12.mta1.migadu.com [IPv6:2001:41d0:203:375::c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3C2A1FC0
        for <linux-bcachefs@vger.kernel.org>; Wed, 12 Jul 2023 16:53:50 -0700 (PDT)
Date:   Wed, 12 Jul 2023 19:53:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1689206027;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=yBbiZPgu2/j2Fa+PQjjTa+JWWHeCQ+gb4zvd8fQ/O2U=;
        b=X4/F4DWKUS7YK0Qkv05Gy9bs8fZ3ey/D5SMQwRXeN/aPm7A2jz+s0lPZtdOHgg6ajtCHRd
        hkyFyZ84fnVDDijHzp73tdR8QNsIpthNS+C1DwKth71R002qNzsSMVjGXlXDtNtMDweWHu
        jmWBbBEgnYcx3tPWNep+nNzI7CI4uuI=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Kent Overstreet <kent.overstreet@linux.dev>
To:     Kees Cook <keescook@chromium.org>
Cc:     linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-bcachefs@vger.kernel.org,
        Kent Overstreet <kent.overstreet@gmail.com>,
        linux-hardening@vger.kernel.org
Subject: Re: [PATCH 29/32] lib/string_helpers: string_get_size() now returns
 characters wrote
Message-ID: <20230712235343.wi5fryoqmqj333qo@moria.home.lan>
References: <20230509165657.1735798-1-kent.overstreet@linux.dev>
 <20230509165657.1735798-30-kent.overstreet@linux.dev>
 <202307121248.36919B223@keescook>
 <20230712201931.kuksw5zmuwah7tqs@moria.home.lan>
 <202307121525.B3B6153D8@keescook>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202307121525.B3B6153D8@keescook>
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Wed, Jul 12, 2023 at 03:38:44PM -0700, Kees Cook wrote:
> Heh, yeah, I've been trying to aim people at using seq_buf instead of
> a long series of snprintf/strlcat/etc calls. Where can I look at how
> you wired this up to seq_buf/printbuf? I had trouble finding it when I
> looked before. I'd really like to find a way to do it without leaving
> around foot-guns for future callers of string_get_size(). :)
> 
> I found the printbuf series:
> https://lore.kernel.org/lkml/20220808024128.3219082-1-willy@infradead.org/
> It seems there are some nice improvements in there. It'd be really nice
> if seq_buf could just grow those changes. Adding a static version of
> seq_buf_init to be used like you have PRINTBUF_EXTERN would be nice
> (or even a statically sized initializer). And much of the conversions
> is just changing types and functions. If we can leave all that alone,
> things become MUCH easier to review, etc, etc. I'd *love* to see an
> incremental improvement for seq_buf, especially the heap-allocation
> part.

Well, I raised that with Steve way back when I was starting on the
conversions of existing code, and I couldn't get any communication out
him regarding making those changes to seq_buf.

So, I'd _love_ to resurrect that patch series and get it in after the
bcachefs merger, but don't expect me to go back and redo everything :)
the amount of code in existing seq_buf users is fairly small compared to
bcachef's printbuf usage, and what that patch series does in the rest of
the kernel anyways.

I'd rather save that energy for ditching the seq_file interface and
making that just use a printbuf - clean up that bit of API
fragmentation.

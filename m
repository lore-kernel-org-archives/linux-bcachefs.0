Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50736C001DE
	for <linux-bcachefs@archiver.kernel.org>; Wed, 12 Jul 2023 20:19:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229512AbjGLUTj (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Wed, 12 Jul 2023 16:19:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229991AbjGLUTi (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Wed, 12 Jul 2023 16:19:38 -0400
Received: from out-36.mta1.migadu.com (out-36.mta1.migadu.com [IPv6:2001:41d0:203:375::24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AE3B1FF0
        for <linux-bcachefs@vger.kernel.org>; Wed, 12 Jul 2023 13:19:37 -0700 (PDT)
Date:   Wed, 12 Jul 2023 16:19:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1689193175;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=LRjkX1alqufdFp+5oDuqNAJ4YZpsTFqeehXA3ckgvjk=;
        b=HjAc5YxXPVPo/BB4dkzyLewEHGl8569ijrwJHsDTxvX7raSf8T/h83wknlmtGhl++GNQ8C
        eSV+Ow9rU+z9O75Ci1C3vEoHnfEVDHKfsrBhi1aK5z8DyVwAHr8JTPqSKwiIkNDzd8q89M
        gd2moP+hsPJmt+BoG8ewxWF3xzgiEFY=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Kent Overstreet <kent.overstreet@linux.dev>
To:     Kees Cook <keescook@chromium.org>
Cc:     linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-bcachefs@vger.kernel.org,
        Kent Overstreet <kent.overstreet@gmail.com>,
        linux-hardening@vger.kernel.org
Subject: Re: [PATCH 29/32] lib/string_helpers: string_get_size() now returns
 characters wrote
Message-ID: <20230712201931.kuksw5zmuwah7tqs@moria.home.lan>
References: <20230509165657.1735798-1-kent.overstreet@linux.dev>
 <20230509165657.1735798-30-kent.overstreet@linux.dev>
 <202307121248.36919B223@keescook>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202307121248.36919B223@keescook>
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Wed, Jul 12, 2023 at 12:58:54PM -0700, Kees Cook wrote:
> On Tue, May 09, 2023 at 12:56:54PM -0400, Kent Overstreet wrote:
> > From: Kent Overstreet <kent.overstreet@gmail.com>
> > 
> > printbuf now needs to know the number of characters that would have been
> > written if the buffer was too small, like snprintf(); this changes
> > string_get_size() to return the the return value of snprintf().
> 
> Unfortunately, snprintf doesn't return characters written, it return
> what it TRIED to write, and can cause a lot of problems[1]. This patch
> would be fine with me if the snprintf was also replaced by scnprintf,
> which will return the actual string length copied (or 0) *not* including
> the trailing %NUL.

...All of which would be solved if we were converting code away from raw
char * buffers to a proper string building type.

Which I tried to address when I tried to push printbufs upstream, but
that turned into a giant exercise in frustration in dealing with
maintainers.

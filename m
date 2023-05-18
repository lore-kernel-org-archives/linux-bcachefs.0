Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7CBA0C77B7A
	for <linux-bcachefs@archiver.kernel.org>; Thu, 18 May 2023 04:03:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229644AbjERED3 (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Thu, 18 May 2023 00:03:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbjERED1 (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Thu, 18 May 2023 00:03:27 -0400
Received: from out-31.mta1.migadu.com (out-31.mta1.migadu.com [95.215.58.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E436198D
        for <linux-bcachefs@vger.kernel.org>; Wed, 17 May 2023 21:03:24 -0700 (PDT)
Date:   Thu, 18 May 2023 00:03:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1684382602;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=LZQV+5Hm/b1RAFYPczCGIRb6Ie2EKWKQ6Ne+A3m0WsA=;
        b=Ho+agoiEGpwlcst26AWKUM5ah4KZCyPeX8vP3+VCKa4N/66QBwdb/Juvw86b36BLtAxWb8
        7+pQl1WiXFtHzfXh8LlMmAIUesOhllqMkRP+uBZUGGcWf+GJJyPOk0a5B+3qiV2g5LN+2N
        tD5O2yBlHafOeUlu+yrUJmtVpEmgR0s=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Kent Overstreet <kent.overstreet@linux.dev>
To:     Janpieter Sollie <janpieter.sollie@kabelmail.de>
Cc:     linux-bcachefs@vger.kernel.org,
        Janpieter Sollie <janpieter.sollie@edpnet.be>
Subject: Re: [PATCH] Improve CFLAGS for faster release, and more agressive
 debugging
Message-ID: <ZGWjh7BIcMgJZ6bj@moria.home.lan>
References: <20230517061529.902-1-janpieter.sollie@kabelmail.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230517061529.902-1-janpieter.sollie@kabelmail.de>
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Wed, May 17, 2023 at 08:15:30AM +0200, Janpieter Sollie wrote:
> From: Janpieter Sollie <janpieter.sollie@edpnet.be>
> 
> We've got several complaints about bcachefs being memory hungry and slow these days.
> It's not a good idea to start optimizing when debugging,
> but as we've a "make debug" target, I propose:
> - we turn on O2 for regular targets
> - we build a debug build with address sanitizer
> - we turn off 02 for debug builds, instead switching to -0g
> According to GCC manual, the last O flag is the one that counts,
> so having O2 and Og won't be a problem
> we still keep basic -g on release builds for a while,
> but set -ggdb on debug builds for more accurate debug options

This doesn't match the commit subject, you're only changing debug
options - and the -static options aren't explained.

Additionally, these are options I turn on on a case-by-case basis, not
for every debug build.

> 
> Signed-off-by: Janpieter Sollie <janpieter.sollie@kabelmail.de>
> ---
>  Makefile | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/Makefile b/Makefile
> index 3fc52cf..460fb9f 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -85,7 +85,7 @@ endif
>  all: bcachefs
>  
>  .PHONY: debug
> -debug: CFLAGS+=-Werror -DCONFIG_BCACHEFS_DEBUG=y -DCONFIG_VALGRIND=y
> +debug: CFLAGS+=-Werror -DCONFIG_BCACHEFS_DEBUG=y -DCONFIG_VALGRIND=y -Og -ggdb -fsanitize=address -fno-omit-frame-pointer -static-libstdc++ -static-libasan -lrt
>  debug: bcachefs
>  
>  .PHONY: tests
> -- 
> 2.40.1
> 

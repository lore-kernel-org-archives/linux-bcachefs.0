Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4342DC77B61
	for <linux-bcachefs@archiver.kernel.org>; Sat, 29 Apr 2023 00:33:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230147AbjD2AdD (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Fri, 28 Apr 2023 20:33:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229968AbjD2AdC (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Fri, 28 Apr 2023 20:33:02 -0400
Received: from out-60.mta1.migadu.com (out-60.mta1.migadu.com [IPv6:2001:41d0:203:375::3c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7BEF3A88
        for <linux-bcachefs@vger.kernel.org>; Fri, 28 Apr 2023 17:33:01 -0700 (PDT)
Date:   Fri, 28 Apr 2023 20:32:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1682728379;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=PVi9WqjsHmn4RbmoHLxa6mJLvn6LS+oHXGwYz56jGWY=;
        b=d4krP1SxjtGd6sgxADnP5ZCZxjT/w3sY/8z3bQqrHzIaaV4Sk4ZlS9dG9Yn+or9X0oOy3M
        3a3zNYCfEtMbcK5hQ2heawZ6qdilDoyZT3QQ18gUeiw9SeZC30bgCh7ghYxFRxlS2jHuJA
        rhgNbgFl6xJkVxHmIkqXODCs/e7cqOg=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Kent Overstreet <kent.overstreet@linux.dev>
To:     TruongSinh Tran-Nguyen <i@truongsinh.pro>
Cc:     linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH] chore(format): rewrite `read_one_super` in Rust
Message-ID: <ZExluHAmghQHp/Fi@moria.home.lan>
References: <20230428192833.86943-1-i@truongsinh.pro>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230428192833.86943-1-i@truongsinh.pro>
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Fri, Apr 28, 2023 at 12:28:33PM -0700, TruongSinh Tran-Nguyen wrote:
> This rewrite tries to be as close to C code as possible, thus almost the whole
> block is in `unsafe {}`. After this commit is merge, there will be further
> refactoring to make it more Rust-idiomatic. There are several things to note:
> 
> 1. `read_one_super_result` return the result, with the Error formatting again
>   closely matches C's counter-part. In the future, we may no longer need
>   `return_code` inside the error.
> 2. There is only 1 `goto` statement, which can be easily rewritten into a loop
>   with conditional break
> 3. There are several functions and const defined as C macro that are redefined
>   as `fn_*` for functions and `BLK_.*`
> 4. This rewritten is aware for BCACHEFS_NO_RUST flag

 - libbcachefs/ is imported from the kernel repository, we don't make
   changes here in -tools, they have to be commited to that repository
   and imported so things stay in sync.
 - also, we don't yet have things figured out for building rust code
   kernel side; there shouldn't be anything too difficult there but we
   need to figure out build system integration. If you're feeling
   ambitious, you could start there...

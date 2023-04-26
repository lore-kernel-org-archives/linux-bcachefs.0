Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B919FC77B60
	for <linux-bcachefs@archiver.kernel.org>; Wed, 26 Apr 2023 21:44:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232615AbjDZVoc (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Wed, 26 Apr 2023 17:44:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231915AbjDZVob (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Wed, 26 Apr 2023 17:44:31 -0400
Received: from out-12.mta1.migadu.com (out-12.mta1.migadu.com [95.215.58.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A9BF1FF2
        for <linux-bcachefs@vger.kernel.org>; Wed, 26 Apr 2023 14:44:30 -0700 (PDT)
Date:   Wed, 26 Apr 2023 17:44:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1682545468;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=5E7sSR1kS1Utm4Vg+AQS5zJVq640nw82EZ0z/Oq8Zdk=;
        b=D9oj1arlfvtpzcoUsBw3SGM5R+flQCpGuHZ9VodSCcbqiaykgaD+AdwPT/SD81nUvftsoM
        plJJKHrkqTT2xXTjF/lXjR4lFDwOc/MYJTNKWXhb+ueTNysrJ4aDLEPSszZ95UJcia0vaX
        0mhry0OBe3slz4s59QluzPwszN2FGI4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Kent Overstreet <kent.overstreet@linux.dev>
To:     TruongSinh Tran-Nguyen <i@truongsinh.pro>
Cc:     linux-bcachefs@vger.kernel.org
Subject: Re: printbuf problems when running rust-written command
Message-ID: <ZEmbOntZyk8yDBKN@moria.home.lan>
References: <CAMy36z4VzueBOSMf9ve+T=w+-WiUc8Gt0AmM6Dm93ks5P-qTjA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMy36z4VzueBOSMf9ve+T=w+-WiUc8Gt0AmM6Dm93ks5P-qTjA@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Wed, Apr 26, 2023 at 12:53:52PM -0700, TruongSinh Tran-Nguyen wrote:
> There are 2 problems I currently have:
> 
> 1. read_super_silent only suppresses the verbose logging temporarily,
> but still dumps everything before the command return 0 successfully

the cleanest thing to do (but perhaps not the most practical) would be
to refactor read_super() so that it returned errors instead of printing
them directly.

more practical option might be to add a quiet option.

> 2. when trying to print printbuf in rust unsafe block, I get seg
> fault. Probably because I don't use bindgen correctly.
> 
> My question is, when working with rust code, do we still need to use
> printbuf, or can we print directly to std{out,err}?

We want be turning to_text() functions into Rust objects that implement
the Display trait - there's several examples in
rust-src/bch_bindgen/src.

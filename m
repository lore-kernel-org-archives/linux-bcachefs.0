Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62289C77B7C
	for <linux-bcachefs@archiver.kernel.org>; Wed, 10 May 2023 18:38:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230423AbjEJSiV (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Wed, 10 May 2023 14:38:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbjEJSiU (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Wed, 10 May 2023 14:38:20 -0400
Received: from out-6.mta0.migadu.com (out-6.mta0.migadu.com [IPv6:2001:41d0:1004:224b::6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7C5540C1
        for <linux-bcachefs@vger.kernel.org>; Wed, 10 May 2023 11:38:18 -0700 (PDT)
Date:   Wed, 10 May 2023 14:38:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1683743896;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9f16k8ugHd8TbHIknd+R/Y5QclruUAGhKmWgAXEE0bc=;
        b=D3oRsxvmkQY1mxNLlNW0FpR0fUunv/20Vv6EW6wc+RmZlyv6b3QBmfdcYbQdbMFjiHvtv9
        3sHxggWM+YnMKcbwD4mDLxMPhWxV88Xj8En8LtNemq3fzX1hhwAfl6va3ADANqJ0KOAWee
        WjcrQ5TBDRSRirx1o/2b+1HemkOWfow=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Kent Overstreet <kent.overstreet@linux.dev>
To:     Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Cc:     TruongSinh Tran-Nguyen <i@truongsinh.pro>,
        rust-for-linux@vger.kernel.org,
        Wedson Almeida Filho <wedsonaf@gmail.com>,
        linux-bcachefs@vger.kernel.org, Andreas Hindborg <nmi@metaspace.dk>
Subject: Re: [PATCH] chore(util): minimal Rust build example
Message-ID: <ZFvkk9QUpIBTAIWj@moria.home.lan>
References: <20230503065354.19071-1-i@truongsinh.pro>
 <ZFqHFTMqetbQKtah@moria.home.lan>
 <CAMy36z75N9obj0WM+OFhhnzXAPxqhg8PVY7_x8X6JbQABFnMQw@mail.gmail.com>
 <ZFqM8HOvlVn61VXs@moria.home.lan>
 <CANeycqq5xCUcjOeOfGAJCH1Tzd01-ALU3uqVJo-BvVX9HOK9wA@mail.gmail.com>
 <CAMy36z5VP_6atrxdOyXSO6G+R36vA8SuaWCDAui3Om3viogPkQ@mail.gmail.com>
 <CAMy36z6+RjgAfEYUxpOhS6vFmTter=cFa2CEorSnKR=qxkft=A@mail.gmail.com>
 <CANiq72nYq5vimbhvfyUj9ejOS487LCQBxkv+7Nt5yYJ2xW_U-A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANiq72nYq5vimbhvfyUj9ejOS487LCQBxkv+7Nt5yYJ2xW_U-A@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Wed, May 10, 2023 at 07:59:03PM +0200, Miguel Ojeda wrote:
> On Wed, May 10, 2023 at 5:30 AM TruongSinh Tran-Nguyen <i@truongsinh.pro> wrote:
> >
> > I have another question. When working on user-space, I'm used to cargo
> > dependency management, but I assume it's not possible when doing
> > kernel development. Specifically, for the immediately next PR, I need
> > to use these 2 crates (and their artifacts)
> 
> Please see https://rust-for-linux.com/third-party-crates (I just uploaded it).

Has cargo vendor been getting discussed?

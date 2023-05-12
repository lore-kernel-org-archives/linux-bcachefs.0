Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05E62C77B7F
	for <linux-bcachefs@archiver.kernel.org>; Fri, 12 May 2023 05:34:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229885AbjELFeC (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Fri, 12 May 2023 01:34:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229655AbjELFeB (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Fri, 12 May 2023 01:34:01 -0400
Received: from out-43.mta1.migadu.com (out-43.mta1.migadu.com [95.215.58.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5820F4202
        for <linux-bcachefs@vger.kernel.org>; Thu, 11 May 2023 22:34:00 -0700 (PDT)
Date:   Fri, 12 May 2023 01:33:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1683869638;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=UO9NIpTkZZgJLBAVfn8oHY8/ZtP6+weDk8RulHur5pA=;
        b=mS4cwxjKk0gw1cbSG6QVa0xp2tKL38B7YiM7h421kVwMhEDfQ/CivJE8D274dP+1cx57Rm
        yNhBf3z3U0QbRvztoeTVAwrflYtoGm5k5Ta/RHS1GFBs5mSlxZ2S+ffcXeT78dU5F0liyH
        quCT9clxZQ6UY91PlKdqFBr3nXQPk+4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Kent Overstreet <kent.overstreet@linux.dev>
To:     TruongSinh Tran-Nguyen <i@truongsinh.pro>
Cc:     Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>,
        rust-for-linux@vger.kernel.org,
        Wedson Almeida Filho <wedsonaf@gmail.com>,
        linux-bcachefs@vger.kernel.org, Andreas Hindborg <nmi@metaspace.dk>
Subject: Re: [PATCH] chore(util): minimal Rust build example
Message-ID: <ZF3PwsqxsGNTVCDv@moria.home.lan>
References: <CAMy36z5VP_6atrxdOyXSO6G+R36vA8SuaWCDAui3Om3viogPkQ@mail.gmail.com>
 <CAMy36z6+RjgAfEYUxpOhS6vFmTter=cFa2CEorSnKR=qxkft=A@mail.gmail.com>
 <CANiq72nYq5vimbhvfyUj9ejOS487LCQBxkv+7Nt5yYJ2xW_U-A@mail.gmail.com>
 <CAMy36z7iofMAK4GkYaUjW27cSC4sg-QGooj93mTg8SOb0eXxfw@mail.gmail.com>
 <CANiq72kcVS=_07D-KDcb9cVByV886mf50ydqNsMvcrJ1myLOuA@mail.gmail.com>
 <CAMy36z710P4ZVW0z_Y=ZObLkpP3Jc837B0z4sTGoDUXCH+8MRw@mail.gmail.com>
 <ZF2zCUV45mYxSe4e@moria.home.lan>
 <CAMy36z6fiC4esHKjAiOaOp6=sAOCbiJXpJku+6_h26xGPs8kWA@mail.gmail.com>
 <ZF2+Ah5koJEdq4A1@moria.home.lan>
 <CAMy36z7-hBv1HVTQaNPZzHXNzB6q-2CS4XzUrWLcwTbn3M1A7A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMy36z7-hBv1HVTQaNPZzHXNzB6q-2CS4XzUrWLcwTbn3M1A7A@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Thu, May 11, 2023 at 09:39:34PM -0700, TruongSinh Tran-Nguyen wrote:
> > What's your use case?
> 
> https://github.com/koverstreet/bcachefs-tools/blob/master/cmd_migrate.c
> for example, includes several syscall and kernel uAPIs. Assuming in
> the far future,
> some/all of the APIs are written in Rust.

This seems like something for quite a long ways off, unless I'm
misunderstanding what you're trying to do right now?

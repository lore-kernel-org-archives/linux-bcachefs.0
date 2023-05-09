Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B027CC7EE22
	for <linux-bcachefs@archiver.kernel.org>; Tue,  9 May 2023 18:13:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229627AbjEISNU (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Tue, 9 May 2023 14:13:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229704AbjEISNS (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Tue, 9 May 2023 14:13:18 -0400
Received: from out-20.mta0.migadu.com (out-20.mta0.migadu.com [91.218.175.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2719B5588
        for <linux-bcachefs@vger.kernel.org>; Tue,  9 May 2023 11:12:50 -0700 (PDT)
Date:   Tue, 9 May 2023 14:12:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1683655922;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=7wc4rUWdgIny0m1gNmWu9Sj3J/HZuhYNS84FTFmtBfI=;
        b=vFH4Uzlo+sSqn//el+6CPWTtROQk42aEJYE6+g7AkiyOMnlVh06KMJ0z+we2m/1deec9g8
        Zv7dWaBKl0f+gcgGrKFqaKgO3P+965S9C0fiBTDQmKDsvB1asNBgxSTU94/9OsZO24XQI6
        58oTUb6FNs3OUfthPVNzX/0btu49LIA=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Kent Overstreet <kent.overstreet@linux.dev>
To:     TruongSinh Tran-Nguyen <i@truongsinh.pro>
Cc:     linux-bcachefs@vger.kernel.org, rust-for-linux@vger.kernel.org
Subject: Re: [PATCH] chore(util): minimal Rust build example
Message-ID: <ZFqM8HOvlVn61VXs@moria.home.lan>
References: <20230503065354.19071-1-i@truongsinh.pro>
 <ZFqHFTMqetbQKtah@moria.home.lan>
 <CAMy36z75N9obj0WM+OFhhnzXAPxqhg8PVY7_x8X6JbQABFnMQw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMy36z75N9obj0WM+OFhhnzXAPxqhg8PVY7_x8X6JbQABFnMQw@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Tue, May 09, 2023 at 10:57:18AM -0700, TruongSinh Tran-Nguyen wrote:
> On Tue, 9 May 2023 at 10:47, Kent Overstreet <kent.overstreet@linux.dev> wrote:
> 
> > We pretty heavily use to_text() functions kernel side; these output to
> > printbufs, and in Rust they map nicely to the Display trait - do we have
> > that available in the kernel or is that in std?
> >
> 
> https://doc.rust-lang.org/std/fmt/trait.Display.html Display trait is definitely
> in Rust `std`. As for the alternative from kernel, I am still searching.
> Worst case, there is nothing right now, Rust-for-linux folks would
> happy to take PR
> to include it.

I included them on the CC, maybe they'll have something to say.

> 
> > Sounds like that would be a welcome cleanup :)
> 
> By clean up, do you mean moving from `uuid_le` to `uuid_t`?
> 
> Also, I don't expect this PR to be merge, as it is for demonstration
> purposes only,
> however, what would be a minimum mergeable PR (related to Rust build)
> that you would consider?

First thing to look at is going to be moving all the code under
bch_bindgen in -tools into the kernel tree...

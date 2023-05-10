Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED29CC77B7C
	for <linux-bcachefs@archiver.kernel.org>; Wed, 10 May 2023 18:45:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229755AbjEJSpI (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Wed, 10 May 2023 14:45:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231486AbjEJSpG (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Wed, 10 May 2023 14:45:06 -0400
Received: from out-24.mta0.migadu.com (out-24.mta0.migadu.com [IPv6:2001:41d0:1004:224b::18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CD7B8F
        for <linux-bcachefs@vger.kernel.org>; Wed, 10 May 2023 11:45:02 -0700 (PDT)
Date:   Wed, 10 May 2023 14:44:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1683744300;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=F7t7XubnBU4WoZtLtGUr5TVuJgFDqeC+scjy0vdlqd0=;
        b=MV0/7UuVnE1PMluCNduYPlRYciCZe83smSGkiedBHhUdPb5x9/Foex9OYVdPKAXC3myGIO
        IF2+68pP+HGpk0LzPB9ILFiYye7j1H2zM7gEdv3UfRx/xBBK0jzZM0sougmXanLwgG3SdG
        F8U5y+YmccaiFuQ4D87yYg87tFla7II=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Kent Overstreet <kent.overstreet@linux.dev>
To:     Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Cc:     TruongSinh Tran-Nguyen <i@truongsinh.pro>,
        linux-bcachefs@vger.kernel.org, rust-for-linux@vger.kernel.org
Subject: Re: [PATCH] chore(util): minimal Rust build example
Message-ID: <ZFvmKk86vBD051n7@moria.home.lan>
References: <20230503065354.19071-1-i@truongsinh.pro>
 <ZFqHFTMqetbQKtah@moria.home.lan>
 <CANiq72mwHa9coRUQqprGaEhLoac=spX2-2X4CMKYBYrovkQoLA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANiq72mwHa9coRUQqprGaEhLoac=spX2-2X4CMKYBYrovkQoLA@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Wed, May 10, 2023 at 07:56:07PM +0200, Miguel Ojeda wrote:
> On Tue, May 9, 2023 at 8:07 PM Kent Overstreet
> <kent.overstreet@linux.dev> wrote:
> >
> > So if I'm following, it looks like everything is basically there. It
> > looks like we can add Rust source files to fs/bcachefs/ and have them
> > built as part of the bcachefs module, and calling back and forth just
> > works as expected - nice.
> 
> Indeed, that should work, and it may be useful, though typically you
> will want to avoid crossing the C/Rust boundary all the time, so that
> you can work with Rust types as much as possible.
> 
> For modules/drivers, we provide Rust abstractions for the C APIs so
> that one can write drivers in Rust (and thus use Rust facilities and
> avoid `unsafe` as much as possible), rather than mixing C and Rust
> source code in the "leaves". Perhaps there are some parts within
> bcachefs amenable to a similar approach.

I've been doing the same thing.

Right now in bcachefs-tools we've got two different crates, one for
bcachefs rust code proper and another for bindings, with a build.rs for
bindgen.

Any pointers to how we'll be interacting with bindgen kernel side? We
need to pass it some stuff, see
https://evilpiepirate.org/git/bcachefs-tools.git/tree/rust-src/bch_bindgen/build.rs

> 
> > The kbuild stuff looks nice and clean - congrats to those responsible :)
> 
> Thanks for the kind words, though a rework of how that works is
> planned, so hopefully you will also like the new way too... :)

Can't wait... :)

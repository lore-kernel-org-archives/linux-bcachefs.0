Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0D41C77B7A
	for <linux-bcachefs@archiver.kernel.org>; Sat, 20 May 2023 02:07:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232148AbjETCGi (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Fri, 19 May 2023 22:06:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232149AbjETCGK (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Fri, 19 May 2023 22:06:10 -0400
Received: from out-7.mta1.migadu.com (out-7.mta1.migadu.com [95.215.58.7])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D65E1A1
        for <linux-bcachefs@vger.kernel.org>; Fri, 19 May 2023 19:06:08 -0700 (PDT)
Date:   Fri, 19 May 2023 22:06:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1684548366;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Cgr5KWjH5uKRuuxPeHLjwGqXhvcsRX3EPFkc8yJMoXQ=;
        b=Roh30iisUYzPae1cZ5k9iIMr8ZAhdfYCBs/pjqzXa1mH36EXkt6MIdwtVsyVs5kLvuohcQ
        1aSiYQyi0WmoqOEZunmI40+EeBUgb/4IzGNUcWqky43STPUmZte6rL+yJYD4lajHu61uWn
        JfTv/BAfhdJZ10G6AcJ3ETLEZZ6mnWY=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Kent Overstreet <kent.overstreet@linux.dev>
To:     Janpieter Sollie <janpieter.sollie@kabelmail.de>
Cc:     linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH] Improve CFLAGS for faster release, and more agressive
 debugging
Message-ID: <ZGgrCjvaXdGFlRe5@moria.home.lan>
References: <20230517061529.902-1-janpieter.sollie@kabelmail.de>
 <ZGWjh7BIcMgJZ6bj@moria.home.lan>
 <995dd846-5b16-54f2-a211-6050881d6945@kabelmail.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <995dd846-5b16-54f2-a211-6050881d6945@kabelmail.de>
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Thu, May 18, 2023 at 08:24:34AM +0200, Janpieter Sollie wrote:
> Op 18/05/2023 om 06:03 schreef Kent Overstreet:
> > On Wed, May 17, 2023 at 08:15:30AM +0200, Janpieter Sollie wrote:
> > > From: Janpieter Sollie <janpieter.sollie@edpnet.be>
> > > 
> > > We've got several complaints about bcachefs being memory hungry and slow these days.
> > > It's not a good idea to start optimizing when debugging,
> > > but as we've a "make debug" target, I propose:
> > > - we turn on O2 for regular targets
> > > - we build a debug build with address sanitizer
> > > - we turn off 02 for debug builds, instead switching to -0g
> > > According to GCC manual, the last O flag is the one that counts,
> > > so having O2 and Og won't be a problem
> > > we still keep basic -g on release builds for a while,
> > > but set -ggdb on debug builds for more accurate debug options
> > This doesn't match the commit subject, you're only changing debug
> > options - and the -static options aren't explained.
> > 
> > Additionally, these are options I turn on on a case-by-case basis, not
> > for every debug build.
> 
> OK, gotcha,
> 
> Do you believe there is a target in optimizing userspace tools to perform
> algorithm testing etc instead of doing it in kernel space?

Not sure what you mean?

> Compiling and running a kasan kernel is a lot more CPU-intensive than using
> options I put in the patch to perform address sanitization.
> Is this a path that has some use? or is fs development / testing in
> userspace not a good idea whatsoever?

No, testing in userspace is definitely a good idea - it's just that
there's no 'correct' set of CFLAGS for debug mode testing; flipping
everything on will slow things down so much that we can't finish the
tests, or some bugs don't get exposed due to being race conditions that
we're running too slow to hit :) In general, We need different CFLAGS
depending on what we're looking for.

that said... kasan is cheaper than what we've had to use in the past. If
you wanted to run some benchmarks comparing current debug cflags and
you're version, and the difference isn't too great, we could consider
taking your patch.

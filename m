Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99E2AC05027
	for <linux-bcachefs@archiver.kernel.org>; Thu,  2 Feb 2023 17:09:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229679AbjBBRJf (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Thu, 2 Feb 2023 12:09:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232234AbjBBRJe (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Thu, 2 Feb 2023 12:09:34 -0500
Received: from out-1.mta0.migadu.com (out-1.mta0.migadu.com [IPv6:2001:41d0:1004:224b::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4246A728ED
        for <linux-bcachefs@vger.kernel.org>; Thu,  2 Feb 2023 09:09:32 -0800 (PST)
Date:   Thu, 2 Feb 2023 12:09:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1675357769;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ek6tv5J92F0oKDl4FsrrGxIic5lcRcF2xa7HNGP5xW0=;
        b=BEoCkXAzoh033iRQLvs7pNDSm/Fk/OusYAWRckyViXcSrDm5f2L03NKOoKN+0eNIgwR1Cl
        PXw4NBocC1H7IS0KNcYGgZowgwYENYuc//E+7XACelm4MmHn6KaawsFUHn78ysCPOdB8ew
        p7Be81uEkb6Fy7c28BwXS4+e38UY2FU=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Kent Overstreet <kent.overstreet@linux.dev>
To:     Brian Foster <bfoster@redhat.com>, dchinner@redhat.com
Cc:     linux-bcachefs@vger.kernel.org
Subject: Freezing (was: Re: fstests generic/441 -- occasional bcachefs
 failure)
Message-ID: <Y9vuQHtYOhAOqPF1@moria.home.lan>
References: <Y9FOlMILXFcNFsSW@bfoster>
 <Y9KXaSkuMZM663Vi@moria.home.lan>
 <Y9PkndpTQcHrZ+im@bfoster>
 <Y9f5GjOocd7Cq7V7@moria.home.lan>
 <Y9k7+6io64IpHlQh@bfoster>
 <Y9p4ihwzFs0OP6to@moria.home.lan>
 <Y9vbv7TFyu+stccD@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y9vbv7TFyu+stccD@bfoster>
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Thu, Feb 02, 2023 at 10:50:23AM -0500, Brian Foster wrote:
> I don't have a public repo atm but I've posted the patch if you have
> somewhere to land it for CI testing..? It survived my regression tests
> so far, FWIW. (I also had posted that random cleanup patch a bit ago if
> you hadn't noticed..).

Must have missed it, sorry. I can host a git repo for you on my server,
or github works fine - I generally prefer git repo links, git am is
always a bit of a hassle.

> Is there a reporting dashboard or something available for the test
> infrastruture for bcachefs?

https://evilpiepirate.org/~testdashboard/ci

I've got a small server farm that watches git branches and runs the
entire test suite on every commit starting from the recent - once you've
got a git branch up I'll add yours to the list it watches.

You'll probably want to get acquainted with ktest, it's what both the CI
uses for running tests, and what we use for local development:

https://evilpiepirate.org/git/ktest.git

> > Freeze definitely needs to happen. It's been _ages_ since I was looking
> > at it so I couldn't say offhand where we'd need to start, but if you're
> > interested I'd be happy to look at what it'd take.
> > 
> 
> Yeah, that would be interesting. Thanks.

Maybe we could get Dave to give us a brief rundown of freezing? It's
been ages since I was thinking about that and it's all fallen out of my
brain, but Dave was the one who was able to explain it to me before :)

I think getting freezing done would up our test coverage by a good bit,
so it's worth prioritizing.

> FWIW, I was reading through the "Journaling" and "Sequential
> consistency" sections of the architecture documentation [1]. It's
> possible I just misinterpreted some wording.
> 
> [1] https://bcachefs.org/Architecture/#Journaling

*nod* Thanks for the link, that's old but not ancient - that's from when
the journal seq blacklist mechanism was how we did sequential
consistency.

Whenever I find the time to work on documentation again, I want to move
more stuff (including that sort of high level developer documentation)
to the principles of operation: https://bcachefs.org/bcachefs-principles-of-operation.pdf

Right now it's more end user documentation, but last I was working on
that I was starting to add documentation centered around on disk data
structures - i.e. btrees and key types, and it seemed to be going in a
useful direction.

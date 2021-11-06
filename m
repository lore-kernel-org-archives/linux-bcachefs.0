Return-Path: <linux-bcachefs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77B9DC433F5
	for <linux-bcachefs@archiver.kernel.org>; Sat,  6 Nov 2021 21:36:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5382A60724
	for <linux-bcachefs@archiver.kernel.org>; Sat,  6 Nov 2021 21:36:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230233AbhKFVje (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Sat, 6 Nov 2021 17:39:34 -0400
Received: from cdw.me.uk ([91.203.57.136]:44383 "EHLO cdw.me.uk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229828AbhKFVjd (ORCPT <rfc822;linux-bcachefs@vger.kernel.org>);
        Sat, 6 Nov 2021 17:39:33 -0400
Received: from chris by delta.arachsys.com with local (Exim 4.80)
        (envelope-from <chris@arachsys.com>)
        id 1mjTMo-0002bx-0M; Sat, 06 Nov 2021 21:36:50 +0000
Date:   Sat, 6 Nov 2021 21:36:50 +0000
From:   Chris Webb <chris@arachsys.com>
To:     Kent Overstreet <kent.overstreet@gmail.com>
Cc:     linux-bcachefs@vger.kernel.org
Subject: Re: More eager discard behaviour
Message-ID: <20211106213649.GN11670@arachsys.com>
References: <20211106171156.GM11670@arachsys.com>
 <YYbZii7HNJ8lb8FF@moria.home.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YYbZii7HNJ8lb8FF@moria.home.lan>
User-Agent: Mutt/1.5.20 (2009-06-14)
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

Kent Overstreet <kent.overstreet@gmail.com> writes:

> On Sat, Nov 06, 2021 at 05:11:56PM +0000, Chris Webb wrote:
> > How practical would it be either to more-greedily wake the allocator thread
> > and reclaim buckets, or to detect buckets available to discard earlier in
> > their lifetime?
> 
> It's on the todo list, it'll be part of the grand allocator rework I have
> planned - there's a lot that needs to be done.

I read your discussion on the status update and in the related write-up on
the accounting code. It makes a lot of sense to me, given the tried and
tested btree layer is there to be used.

> We've got to rework the state transitions, and differentiate between buckets
> with cached data, buckets that need a journal commit before we can write to them
> again, buckets that need discarding, and buckets that are ready for use - and we
> need to start storing all that persistently, as well as build some new data
> structures to get rid of the scanning over every bucket we currently have to do
> in various places.
> 
> Step one is going to be creating a persistent LRU. It'll be another btree,
> sorted by the order in which we want to reuse buckets - a combination of the
> amount of live data in the bucket and the time since it was last read.
> 
> If you're interested in tackling this, I can sketch it out for you :)

I'm definitely interested in helping out if I can, although there's a slight
risk of biting off more than I can chew: I probably understand even less
about the design and structure of your fs at the moment than you think!

I don't want to be a slow-moving obstacle on your critical path or more of a
nuisance than a help, but equally, getting stuck in is clearly the best way
to figure out how it fits together and become more useful. So happy to give
anything a go that you think is reasonable for a newcomer to take a crack
at. :) 

Best wishes,

Chris.

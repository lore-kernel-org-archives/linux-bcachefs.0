Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1AAF3EE14C3
	for <linux-bcachefs@archiver.kernel.org>; Sun, 10 Sep 2023 02:03:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239079AbjIJCDN (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Sat, 9 Sep 2023 22:03:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233350AbjIJCDN (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Sat, 9 Sep 2023 22:03:13 -0400
Received: from out-220.mta0.migadu.com (out-220.mta0.migadu.com [91.218.175.220])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A247F1A5
        for <linux-bcachefs@vger.kernel.org>; Sat,  9 Sep 2023 19:03:08 -0700 (PDT)
Date:   Sat, 9 Sep 2023 22:03:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1694311387;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=KnKEvcOIpWWB/3q7BwdBY1opQhAbs06nKnf+oCny0Ts=;
        b=wext9NX2+jLaNZTHygkZxo1rQ6XV/r9Gr8YDFAVSjXYZfNWV6d5y7WXb1TuXSRcjMf46xT
        48t5taDi2o2uuUgKondHnQYrBhEITMd+GyPOqhnhOWZ9SzonH/TDPLKsvC8EdkaBtxftB7
        MTR7BeOmFyOenPU6hOUSslQkbtNVWvE=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Kent Overstreet <kent.overstreet@linux.dev>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH 3/3] bcachefs: fix race between journal entry close and
 pin set
Message-ID: <20230910020304.bhoqfrsq2ez3ngri@moria.home.lan>
References: <20230831110734.787212-1-bfoster@redhat.com>
 <20230831110734.787212-4-bfoster@redhat.com>
 <20230903211812.kh7paaa5z25lwbd4@moria.home.lan>
 <20230904022928.x64kp2vhtxxzvcal@moria.home.lan>
 <ZPcmFqnjouET8rqa@bfoster>
 <ZPjODscrfsdXcgPf@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZPjODscrfsdXcgPf@bfoster>
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Wed, Sep 06, 2023 at 03:07:58PM -0400, Brian Foster wrote:
> On Tue, Sep 05, 2023 at 08:59:02AM -0400, Brian Foster wrote:
> > On Sun, Sep 03, 2023 at 10:29:28PM -0400, Kent Overstreet wrote:
> > > On Sun, Sep 03, 2023 at 05:18:12PM -0400, Kent Overstreet wrote:
> > > > On Thu, Aug 31, 2023 at 07:07:34AM -0400, Brian Foster wrote:
> > > > > bcachefs freeze testing via fstests generic/390 occasionally
> > > > > reproduces the following BUG from bch2_fs_read_only():
> > > > > 
> > > > >   BUG_ON(atomic_long_read(&c->btree_key_cache.nr_dirty));
> > > >
> > > > Your fix makes sense, but I wonder if it might be simpler and better to
> > > > fix this in bch2_journal_reclaim_fast().
> ...
> > 
> > FWIW, one thing I disliked about the original patch was the need to
> > mostly duplicate the buf put helper due to the locking context quirk. I
> > was trying to avoid that, but I ran out of ideas before I wanted to move
> > on actually fixing the bug. My preference would be to address the
> > reference counting issue as is (to preserve design simplicity), and then
> > maybe think a bit harder about cleaning up the res put implementation if
> > the primary concern is that we feel like this starts to make things a
> > bit convoluted..
> > 
> 
> Another thought that comes to mind is to perhaps allow the journal_res
> to hold a reference to the pin fifo for the associated seq.. The idea
> would be we could continue to hold a reference during the open/close
> journal buffer lifecycle, but a res of the same seq would acquire an
> additional reference as well to keep the tail from popping before a
> transaction can actually set a pin (i.e. essentially parallel to the
> buffer reference).

Yeah that would probably be cleanest - but it would be much too heavy.

> In a sense the behavior in this patch is kind of an optimization of that
> approach, but I think implementing it directly would eliminate the need
> to mostly duplicate the put helper, perhaps making things a bit more
> natural. We could still fall into bch2_journal_reclaim_fast() from
> res_put(), but now only for cases where the reservation outlives the
> active journal buffer (due to a journal flush or whatever). That also
> still addresses the race by properly using the reference count. I'd
> probably have to try it to be sure I'm not missing something, but...
> thoughts?

We can do your approach if that's what you feel is going to be cleanest,
but if we go that way here's my two main concerns:

 - we can't put more slowpath code into the inline fastpath, remember
   this is all inlined into the main __bch2_trans_commit() path

 - your approach (the optimized version) means there's a new state
   transition where we do work, i.e. when journal_state_count() hits 0.

   So we have to make sure that that refcount isn't hitting 0 multiple
   times. The appropriate assertion already exists in
   journal_res_get_fast() - for a refcount to hit 0 multiple times it
   must leave 0 while in use, and we check for that.

   Let's just add a comment by that EBUG_ON(!journal_state_count(new,
   new.idx)) line indicating why it's now important.

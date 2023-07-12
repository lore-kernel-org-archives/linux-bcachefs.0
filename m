Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4177BEB64DA
	for <linux-bcachefs@archiver.kernel.org>; Wed, 12 Jul 2023 17:11:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231703AbjGLRLJ (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Wed, 12 Jul 2023 13:11:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230241AbjGLRLJ (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Wed, 12 Jul 2023 13:11:09 -0400
Received: from out-9.mta1.migadu.com (out-9.mta1.migadu.com [IPv6:2001:41d0:203:375::9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFDB919A7
        for <linux-bcachefs@vger.kernel.org>; Wed, 12 Jul 2023 10:11:06 -0700 (PDT)
Date:   Wed, 12 Jul 2023 13:10:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1689181865;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=6O6tF/vfSdHH1FvZdJ1GNRgqv/9a9QUjUIDpZJuVZzE=;
        b=XoeRGyR/wOhK3CFSwRlesyv4a+hRzJe44Ilm3LIvpFU0+YlgqxwbBCh7wZmv4a67JmA/pq
        msMtr1hDYOFmbc/+HftHxMvZnD9hbk5FatTRd64sFPv5av2jFrjM/l3z5zEvuszTH9sNT5
        7d4RxFsp5/bli+DMhgZBd66nccC6H6o=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Kent Overstreet <kent.overstreet@linux.dev>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-bcachefs@vger.kernel.org
Subject: Re: bcachefs backpointers errors in no write buf mode
Message-ID: <20230712171057.vp3ullcaravyrtvx@moria.home.lan>
References: <ZKhMGZBokKMq5p1P@bfoster>
 <20230707175823.3tct7p2blqrzr7wo@moria.home.lan>
 <ZKwJk/JBoZzizU4p@bfoster>
 <20230710145646.3vzxwzvrbbmxc57h@moria.home.lan>
 <ZK7AMu6MBLoLX8vJ@bfoster>
 <20230712154047.hqw7rdwjxasjvsdn@moria.home.lan>
 <ZK7aPhB9QV+56R/J@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZK7aPhB9QV+56R/J@bfoster>
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Wed, Jul 12, 2023 at 12:52:14PM -0400, Brian Foster wrote:
> On Wed, Jul 12, 2023 at 11:40:47AM -0400, Kent Overstreet wrote:
> > What if the entry being flushed is already at the tail of the journal,
> > and journal reclaim is already trying to flush everything at that
> > sequence number? Since we'll often have multiple write buffer keys per
> > journal entry, and per btree node, this might lead to btree nodes
> > getting flushed multiple times redundantly.
> > 
> 
> I think I follow what you mean, but isn't this what the fast path is
> doing already? (Not to say that it isn't a potential issue to be aware
> of.)

Yes, but when we're low on free space in the journal that's when we
switch to the slowpath.

> BTW, I haven't dug much into the btree code... If a btree node has a
> bunch of pins of different sequence numbers for whatever key updates are
> pending, is the whole set flushed out on the first pin flush (releasing
> all pins)? Or is it an incremental flush to update keys just up to the
> specified pin seq?

We write out everything that's dirty for that given btree node (which is
why a btree node only has to retain a single journal pin to the oldest
pinned journal entry).

> Indeed. Even if that is an optimization for key cache vs. more of a
> correctness issue for write buffer, it sounds like quite a bit of
> functional overlap.
> 
> Anyways, I'll see if I can prototype something to verify whether this
> addresses the backpointer issue before getting too far into the weeds.
> ;) Thanks for the feedback.

Sounds good :)

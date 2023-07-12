Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5241DEB64DA
	for <linux-bcachefs@archiver.kernel.org>; Wed, 12 Jul 2023 15:40:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233765AbjGLPkz (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Wed, 12 Jul 2023 11:40:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233762AbjGLPkz (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Wed, 12 Jul 2023 11:40:55 -0400
Received: from out-18.mta1.migadu.com (out-18.mta1.migadu.com [IPv6:2001:41d0:203:375::12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 258B61989
        for <linux-bcachefs@vger.kernel.org>; Wed, 12 Jul 2023 08:40:53 -0700 (PDT)
Date:   Wed, 12 Jul 2023 11:40:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1689176450;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=8emnZgxEr7dxUio+MofOChxaV4JMwPn0/O2ciAk3KI4=;
        b=F63xWuOYWScNlaeBTkZ321i78e22npeB3HBsqQe+LsVhykqr5XyIZjUYZrJf+kONXXRU++
        zS5TVICPxeC5tB6QE4k63d5gvFg/3DN7GE8AKlCuQ/FY6KmUB8w9Wy5mTDOJk3HZNJxLAL
        ECFgcDis8FnqkvjmZp41FylbmBN8q44=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Kent Overstreet <kent.overstreet@linux.dev>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-bcachefs@vger.kernel.org
Subject: Re: bcachefs backpointers errors in no write buf mode
Message-ID: <20230712154047.hqw7rdwjxasjvsdn@moria.home.lan>
References: <ZKhMGZBokKMq5p1P@bfoster>
 <20230707175823.3tct7p2blqrzr7wo@moria.home.lan>
 <ZKwJk/JBoZzizU4p@bfoster>
 <20230710145646.3vzxwzvrbbmxc57h@moria.home.lan>
 <ZK7AMu6MBLoLX8vJ@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZK7AMu6MBLoLX8vJ@bfoster>
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Wed, Jul 12, 2023 at 11:01:06AM -0400, Brian Foster wrote:
> Yep. I think I have a general idea of what's going on here. The first
> thing I realized after looking through some tracing was that this seems
> to correlate with the non-fast fallback paths for write buffer flushing.
> For example, if I unconditionally redirect wb key flushes to the
> trans_commit path in flush_one(), that 1. dramatically increases the
> reproduction rate and 2. also reproduces a similar issue for lru
> entries. I think the only reason we don't reproduce the lru variant of
> the problem with generic/388 alone is that I don't see nearly as many
> lru updates as backpointer updates, and so the workload just doesn't
> happen to facilitate it.

Fantastic :)

I just pulled dynamic fault injection into the bcachefs tree - to make
sure this path gets tested better in the future we can add a
dynamic_fault("race") here.

(first, I have to dust off the fault injection test integration...)

> With that, I tweaked my kernel to unconditionally redirect backpointer
> btree updates to the non-fast flush paths for debug purposes. From
> there, I've seen a few different variants of the problem that I think
> just happen to relate to the different extent modifying operations that
> fsstress happens to be running. The most simple example that describes
> the fundamental problem is as follows:
> 
> 1. Extent allocated and associated bp inserted to write buffer index 0.
> 2. Flush begins on idx 0, active idx switches to 1.
> 3. Previously alloc'd extent is deleted. Associated deleted bp key
> inserted to buffer idx 1.
> 4. Flush of idx 0 lands on the initial bp key for the extent. The
> trans_commit path rejournals the key for the backpointer btree update.
> 5. The fs shuts down. Recovery finds the key updates in the order they
> were journaled by this sequence (update->delete->update), which doesn't
> match the actual runtime changes of the extent btree (update->delete).
> This puts an entry in the backpointers btree that doesn't reflect
> reality.
> 
> So essentially the current rejournaling by the non-fast write buffer
> flush paths creates an on-disk journal ordering inconsistency wrt
> changes in associated btrees.

Yep, sounds like you nailed it.

> I tried to skip journaling in the write buffer flush commit path as a
> quick experiment, but that doesn't work on its own because we can then
> lose key updates in the journal held by the write buffer pin. I.e., the
> tail of the journal can then move past the key before it's been updated
> in the btree because the latter update hasn't journaled it (this results
> in similar backpointer errors and I can see the key getting lost by
> looking at list_journal vs. list_journal -a).

Correct

> OTOH, it looks like the fast flush path gets this right without
> rejournaling because it adds a pin to the btree buffer based on the seq
> of the already journaled key. IIUC, this essentially allows the btree
> update to refer to the journal entry created when the key was inserted
> into the write buffer. I'm wondering if the right way to fix this is to
> allow the trans update/commit path to basically do the same thing. I.e.,
> somehow or another allow a trans update of an already journaled key to
> inherit the seq of the key for a btree pin rather than explicitly
> rejournal it at the current seq of the transaction. Thoughts?

I think that could work.

What if the entry being flushed is already at the tail of the journal,
and journal reclaim is already trying to flush everything at that
sequence number? Since we'll often have multiple write buffer keys per
journal entry, and per btree node, this might lead to btree nodes
getting flushed multiple times redundantly.

I suspect this would only happen in artificial circumstances - it'll be
based on the ratio of write buffer size:journal size - so if we add a
slowpath tracepoint/counter, and make sure to to some testing where we
provoke this condition that'll be sufficient.

Maybe write a small journal, large write buffer test?

I was also looking at adding the same "skip rejournalling" optimization
to key cache flushing - this could take care of that too.

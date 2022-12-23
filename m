Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 500A3C4332F
	for <linux-bcachefs@archiver.kernel.org>; Fri, 23 Dec 2022 04:36:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229582AbiLWEg3 (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Thu, 22 Dec 2022 23:36:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229549AbiLWEg1 (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Thu, 22 Dec 2022 23:36:27 -0500
Received: from out2.migadu.com (out2.migadu.com [IPv6:2001:41d0:2:aacc::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C1D0A18D
        for <linux-bcachefs@vger.kernel.org>; Thu, 22 Dec 2022 20:36:24 -0800 (PST)
Date:   Thu, 22 Dec 2022 23:36:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1671770181;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Y4ZlfaFJgdG7w3nSzQbJv0VKtJHzBFVeqzcOXzM8jgU=;
        b=fZSit26r5wDtacn50gyFrpoR9RGEKq35SSZM+fofQ5D2kE7MVknPccYHlUTaDpli2AE/2y
        1tdmEi5ZyRasTH5vKGHt7vwmFl2OkuUyqSYxXRMVyclb4ElghHkZIQzOd0puHgnoKub6Yx
        zB+u45PxvcI4oKZEAx+syPZavFfjGKc=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Kent Overstreet <kent.overstreet@linux.dev>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH RFC] bcachefs: use inode as write point index instead of
 task
Message-ID: <Y6UwQnjX7VyV2NGk@moria.home.lan>
References: <20221212190602.1388127-1-bfoster@redhat.com>
 <20221213183743.3m6ntfnu7n3yebng@moria.home.lan>
 <Y5oLlLcHmS2EWp8n@bfoster>
 <Y5u3VlkA3AbhQKav@moria.home.lan>
 <Y6CC27y2Rf44DzFI@bfoster>
 <Y6EJmGTbFmAgmjre@moria.home.lan>
 <Y6RjqsXgCAJ/M7c+@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y6RjqsXgCAJ/M7c+@bfoster>
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Thu, Dec 22, 2022 at 09:03:22AM -0500, Brian Foster wrote:
> On Mon, Dec 19, 2022 at 08:02:16PM -0500, Kent Overstreet wrote:
> > On Mon, Dec 19, 2022 at 10:27:23AM -0500, Brian Foster wrote:
> > > A couple of the more common optimizations XFS uses are speculative
> > > preallocation and extent size hints. The former is designed to mitigate
> > > fragmentation, particularly in the case of concurrent sustained writes.
> > > Basically it will selectively increase the size of appending delalloc
> > > reservations beyond current eof in anticipation of further writes. In
> > > the meantime, writeback will attempt to allocate maximal sized physical
> > > extents for contiguous delalloc ranges. Finally, the allocation itself
> > > will start off with a simple hint based on the physical location of the
> > > inode. This helps ensure extents are eventually maximally sized whenever
> > > sufficient contiguous free extents are available and similarly ensures
> > > as related inodes are removed, contiguous extents are freed together.
> > > Excess/unused prealloc blocks are eventually reclaimed in the background
> > > or as needed.
> > > 
> > > Extent size hints are more for random write/allocation scenarios and
> > > must be set by the user. For example, consider a sparse vdisk image
> > > seeing random small writes all over the place. If we allocate single
> > > blocks at a time, fragmentation and the extent count can eventually
> > > explode out of control. An extent size hint of 1MB or so ensures every
> > > new allocation is sized/aligned as such and so helps mitigate that sort
> > > of problem as more of the file is allocated.
> > > 
> > > Of course XFS is fundamentally different in that it's not a COW fs, so
> > > might have different concerns. It supports reflinks, but that's a
> > > relatively recent feature compared to the allocation heuristics and not
> > > something they were designed around or significantly updated for (since
> > > COW is not default behavior, although I believe an always_cow mode does
> > > exist).
> > 
> > *nod* Yeah, I've been wondering how much this stuff makes sense in the context
> > of a COW filesystem.
> > 
> > But we do have nocow mode, complete with unwritten extents. If we need to go the
> > delalloc route, I think the existing allocator design should be able to support
> > that (we can pin space purely as an in memory operation, but we do have a fixed
> > number of those so we have to be careful about introducing deadlocks).
> > 
> > It sounds like the optimizations XFS is doing are trying to ensure that writes
> > remain contiguous on disk even when buffered writeback isn't batching them up as
> > much as we'd like? Is that something we still feel is important?
> > Pagecache/system memory size keeps going up but seek times do not (and go down
> > in the case of flash); it's not clear to me that this is still important today.
> > 
> 
> That's a good question and I don't really know the answer. I suspect
> there is more to it than the fundamental principles of hardware and
> related improvements. In practice these sorts of things still improve fs
> efficiency, performance, scalability, aging (perhaps under less than
> ideal hardware/workload/resource conditions), etc. Given the relative
> low cost (in terms of complexity) of the implementation, they certainly
> aren't things I see going away from fs' like XFS any time soon. The
> underlying concepts may just not be as generically relevant (i.e. useful
> across different fs implementations) as perhaps they might have been in
> the past.

Certainly no pressing reason to drop that code from XFS, but bcachefs is a clean
slate (and COW introduces different challenges) so I have to think about things
differently.

> 
> When you think about it, it is kind of amusing to see things like the fs
> attempt to create as large/contiguous mappings as possible, only for
> writeback to subsequently have to explicitly break them up into smaller
> I/O requests because otherwise the massive amount of in-core metadata
> status updates that result (i.e. clearing per-page writeback state)
> leads to excessive completion latency. ;) OTOH, if that eventually leads
> to more use of things like large folios, then perhaps that's an overall
> win.

Hmm? That sounds like an odd way to describe things.

Folios are certainly long overdue and are going to be a big help, but more in
the buffered IO paths than writeback I expect. Writeback can and does aggregate
adjacent pages into the same IO; in bcachefs this is right now limited to 2 MB
in practice because we represent the IO from the very start as a bio, but large
folios + multipage bvecs should finally get us past that limit.

IOW, once I do the large folio conversion writeback ought to be generating
bucket sized extents - when data checksums are off, as they'll otherwise limit
extent size (and that restriction will be lifted once we get extents with block
granular/variable granularity checksums).

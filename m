Return-Path: <linux-bcachefs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C96F1C4332F
	for <linux-bcachefs@archiver.kernel.org>; Tue, 20 Dec 2022 01:02:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229497AbiLTBCY (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Mon, 19 Dec 2022 20:02:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbiLTBCX (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Mon, 19 Dec 2022 20:02:23 -0500
Received: from out2.migadu.com (out2.migadu.com [188.165.223.204])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D93C5FF6
        for <linux-bcachefs@vger.kernel.org>; Mon, 19 Dec 2022 17:02:21 -0800 (PST)
Date:   Mon, 19 Dec 2022 20:02:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1671498139;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=eUpxdaaGNwVbS480nxaUtkxdnmUL3FJG4aAetA/DvTk=;
        b=BQp4rlQ3++5z7pVY0Ey5i8BJx3JS3QKWUB2M5ClUg933zbFcE/kci1a4kU48mC1Ys2y6z+
        TvgtzUJX5aA26ukjLaiWzxvme1+Ud9x76MC3G+u7PacsfoyqEba5vfS37gg9Esk1X1epVD
        xTrJi1Kw0Fj0WTgPU2PN/INeTIyjipI=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Kent Overstreet <kent.overstreet@linux.dev>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH RFC] bcachefs: use inode as write point index instead of
 task
Message-ID: <Y6EJmGTbFmAgmjre@moria.home.lan>
References: <20221212190602.1388127-1-bfoster@redhat.com>
 <20221213183743.3m6ntfnu7n3yebng@moria.home.lan>
 <Y5oLlLcHmS2EWp8n@bfoster>
 <Y5u3VlkA3AbhQKav@moria.home.lan>
 <Y6CC27y2Rf44DzFI@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y6CC27y2Rf44DzFI@bfoster>
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Mon, Dec 19, 2022 at 10:27:23AM -0500, Brian Foster wrote:
> A couple of the more common optimizations XFS uses are speculative
> preallocation and extent size hints. The former is designed to mitigate
> fragmentation, particularly in the case of concurrent sustained writes.
> Basically it will selectively increase the size of appending delalloc
> reservations beyond current eof in anticipation of further writes. In
> the meantime, writeback will attempt to allocate maximal sized physical
> extents for contiguous delalloc ranges. Finally, the allocation itself
> will start off with a simple hint based on the physical location of the
> inode. This helps ensure extents are eventually maximally sized whenever
> sufficient contiguous free extents are available and similarly ensures
> as related inodes are removed, contiguous extents are freed together.
> Excess/unused prealloc blocks are eventually reclaimed in the background
> or as needed.
> 
> Extent size hints are more for random write/allocation scenarios and
> must be set by the user. For example, consider a sparse vdisk image
> seeing random small writes all over the place. If we allocate single
> blocks at a time, fragmentation and the extent count can eventually
> explode out of control. An extent size hint of 1MB or so ensures every
> new allocation is sized/aligned as such and so helps mitigate that sort
> of problem as more of the file is allocated.
> 
> Of course XFS is fundamentally different in that it's not a COW fs, so
> might have different concerns. It supports reflinks, but that's a
> relatively recent feature compared to the allocation heuristics and not
> something they were designed around or significantly updated for (since
> COW is not default behavior, although I believe an always_cow mode does
> exist).

*nod* Yeah, I've been wondering how much this stuff makes sense in the context
of a COW filesystem.

But we do have nocow mode, complete with unwritten extents. If we need to go the
delalloc route, I think the existing allocator design should be able to support
that (we can pin space purely as an in memory operation, but we do have a fixed
number of those so we have to be careful about introducing deadlocks).

It sounds like the optimizations XFS is doing are trying to ensure that writes
remain contiguous on disk even when buffered writeback isn't batching them up as
much as we'd like? Is that something we still feel is important?
Pagecache/system memory size keeps going up but seek times do not (and go down
in the case of flash); it's not clear to me that this is still important today.

> Ok. Based on the above, it kind of sounds like a worse case scenario
> might be something like N files allocated by the same task in such a way
> that each bucket ends up split between the N files, and then some number
> of files end up removed. Rinse and repeat that sort of thing across new
> sets of files and then presumably we'd have increasing amount of free
> space in partially used buckets that cannot be allocated..?

Yep, that would do it.

> 
> Is copygc responsible for cleaning things up in such a case in order to
> create more usable free space (hence the excessive copygc comment
> below)?

Correct. Copygc finds buckets that are mostly but not completely empty and
evacuates them - writes the data in them to new buckets.

Copygc doesn't do any file-level defragmentation, but now that we have
backpointers it could.

> Hmm.. Ok, that gives me another area to look into re: copygc. ;) Thanks
> for all of the feedback and context..

Feel free to hit me up on IRC as you're looking at code. I'm also currently
working on the copygc code - we have a persistent fragmentation index about to
land, which will be a drastic improvement to copygc scalability. Not relevant to
what you're looking at, but the code is at least fresh in my mind :)

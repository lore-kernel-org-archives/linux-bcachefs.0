Return-Path: <linux-bcachefs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E73DC4332F
	for <linux-bcachefs@archiver.kernel.org>; Fri, 16 Dec 2022 00:10:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229815AbiLPAKn (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Thu, 15 Dec 2022 19:10:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230064AbiLPAKV (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Thu, 15 Dec 2022 19:10:21 -0500
Received: from out2.migadu.com (out2.migadu.com [IPv6:2001:41d0:2:aacc::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02F245EDFA
        for <linux-bcachefs@vger.kernel.org>; Thu, 15 Dec 2022 16:10:09 -0800 (PST)
Date:   Thu, 15 Dec 2022 19:09:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1671149407;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ILGPrktjdcT73eXBGTdUEEeng2jUrwqti3ZNsKTLpfo=;
        b=D15E6w6qzfGjKYhXK4U4o91GQiYU8u6Z/xyhnaIuFiPseO3Ih/tUkVJa2iIerdd8VqzitJ
        ztsBGrqq+LnKlXINNFXOroNjlWcW88UbN6DWpMar2+7T2rozlWZgCNUJ1ce8oRC78LIJET
        oDmUSNJzKSUiT2GGr4cckodYGwa1L8w=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Kent Overstreet <kent.overstreet@linux.dev>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH RFC] bcachefs: use inode as write point index instead of
 task
Message-ID: <Y5u3VlkA3AbhQKav@moria.home.lan>
References: <20221212190602.1388127-1-bfoster@redhat.com>
 <20221213183743.3m6ntfnu7n3yebng@moria.home.lan>
 <Y5oLlLcHmS2EWp8n@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y5oLlLcHmS2EWp8n@bfoster>
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Wed, Dec 14, 2022 at 12:44:52PM -0500, Brian Foster wrote:
> On Tue, Dec 13, 2022 at 01:38:33PM -0500, Kent Overstreet wrote:
> > Fundamentally, what we're doing is trying to preserve locality, the idea is that
> > data written by the same process is likely related and should be written out
> > together.
> > 
> > Consider a cp -r of many small files, or any sort of process that's writing out
> > to many small files. Using the pid for the writepoint preserves locality, using
> > the inode number would not.
> > 
> 
> Yeah, that makes sense. I'm more curious about the value and tradeoff of
> inter-file vs. intra-file locality and the associated workloads that
> might or might not benefit. I suppose I can see value of a single writer
> copying in a bunch of small files and the allocations being streamlined
> as such. OTOH, what's the cost if separate files don't happen to follow
> the same write point like this (i.e. as if cp were run one file at a
> time)? Is there some indirect/internal to bcachefs benefit to this
> behavior, or are we just trying to batch writes?

There's two main factors.

Firstly, we've only got so many write points, so we're more likely to end up
using the same write points as another application, and interspersing our data
with theirs.

The big factor is bucket based allocation and copygc: preserving locality is
more important in bcachefs than in other filesystems, because we have to
evacuate a bucket before it can be reused. Keeping related data grouped together
in the same bucket means that it's much more likely to all die (be deleted or
overwritten) at the same time, and copygc won't have to do any work.

(Side note: bucket based allocation and copygc is what will make really good
zoned device supoprt possible, which has been part of the design since forever
and something I want to see finished - I've just been focusing on more core
things).

> What about scenarios where the writing task is less relevant? For
> example, perhaps something like a file server ingesting data for
> multiple sets of large files via a thread pool or some such.. I'm not
> sure I see as much value of a worker task doling out per-task hinted
> allocations across a set of the N active files it might be processing..

There's been talk of plumbing a write point API up to userspace before - SSDs
could make good use of it if they had it.

Or, perhaps we could detect when a task is writing to multiple files at the same
time (not one after the other, as cp would) and switch to writepoint-per-file
then.

> The reason it stood out to me is that I'm not aware of fs' going through
> major pains to preserve per-task locality across inodes in this sort of
> way (XFS, for example, may deliberately spread files over the disk if
> they happen to span directories, perhaps for different reasons). OTOH,
> we do put effort into reducing per-file fragmentation in scenarios like
> concurrent sustained buffered writes or random write/alloc workloads to
> sparse files, and then usually hear from users one way or another when
> those optimizations aren't effective enough. ;)

Maybe you could tell me more? I don't know nearly as much as I'd like to about
allocator strategies in XFS; I've never gone as deep here as I'd like beacuse,
quite honestly, people haven't complained :)

(And the company funding me cares very much about streaming bandwidth on
rotating disk, it's something we've looked at. The bigger issue last time we
looked was that readdir order in bcachefs doesn't match create order or sort
order, because directories are implemented as simple open addressing hash
tables - meaning reading back files in a directory incurred unnecessary seeks on
file boundaries. Another todo list item :)

> Eh, I'd have to go back at play around with it to provide specifics.. I
> suspect I was doing something like multiple, concurrent, appending
> writes to a single file from different tasks, also concurrent with a set
> of sync_file_range() workers forcing frequent writeback activity, and
> then seeing a notably large number of extents for the relative size of
> the file. That turned around completely with the tweak in this patch.
> 
> This test wasn't intended to reflect any sort of sane workload. Rather,
> to just try and confirm assumptions made from reading the code. I've not
> actually tested anything like the more practical example mentioned
> above, and I wouldn't expect it to result in anything nearly as
> pathological as this test.

*nod*

> Did you have specific improvements or target use cases in mind in this
> area..?

I do think we could probably be doing something more than using the pid for the
writepoint, I've just been waiting until we see specific workloads where the
current behaviour falls over or have a specific complaint before designing
something new.

Target use cases - I want bcachefs to be able to handle any mainstream
application XFS can (as well as brtfs/ext4/zfs) - i.e. be a truly general
purpose filesystem. Anything needed to make that happen is on the table, long
term - including potentially switching out the entire bucket-based allocator for
something else, as an option - the codebase is flexible enough that we could do
that.

I doubt it'll come to that though, especially now that we've got nocow mode - my
expectation is that we'll be able to get it to do what we need to with perhaps
minor tweaks to writepoint usage. Always contingent upon more data, of course.

More immediately, I'm trying to set things up so that we've got good visibility
into what's going on can see what needs to be tweaked and tuned later.

One big thing we'll want to watch for is excessive copygc - that'll be an
indication our data layout could've been better. We've got backpointers from
buckets back to extents and inodes back to dirents, which means we could pretty
easily have the copygc tracepoints start telling us the specific filenames it
was moving data for.

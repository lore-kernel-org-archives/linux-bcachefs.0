Return-Path: <linux-bcachefs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6579EC4332F
	for <linux-bcachefs@archiver.kernel.org>; Wed, 14 Dec 2022 17:45:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237972AbiLNRpx (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Wed, 14 Dec 2022 12:45:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237364AbiLNRpk (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Wed, 14 Dec 2022 12:45:40 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D617928E38
        for <linux-bcachefs@vger.kernel.org>; Wed, 14 Dec 2022 09:44:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1671039892;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=dJfq65gZNgRwbBbw2Uo30mN481ZFUGjsjfnjyM/AboE=;
        b=dhH8xDbSdveawHJ3JAQNdKs450xmAH0mlvNc8WBFxJ0wlxfhciBPw95x0D0Dbz7XlRLpBx
        fD2GaChDPJ+bxHx4LC/HsXQXUjhaxdCxy/Go997MkthBKm1j8NfMinIEF8D8OHA8HFMuu2
        Dot0WCPA1sWBPg83buis2IHjUiR+EE0=
Received: from mail-vs1-f71.google.com (mail-vs1-f71.google.com
 [209.85.217.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-9-K7Y-HNYNMVK3WsNlOFLRnw-1; Wed, 14 Dec 2022 12:44:49 -0500
X-MC-Unique: K7Y-HNYNMVK3WsNlOFLRnw-1
Received: by mail-vs1-f71.google.com with SMTP id 187-20020a6715c4000000b003b08939591eso145653vsv.4
        for <linux-bcachefs@vger.kernel.org>; Wed, 14 Dec 2022 09:44:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dJfq65gZNgRwbBbw2Uo30mN481ZFUGjsjfnjyM/AboE=;
        b=ncPp8VrmoWq/sFztEeU5XULLjnMxkrKO4tO0riP19JFsMm2bGnOO1AZeYWQ+90wBzo
         mYUa+dDsvHZ2DtXXmBR8SDUTkMAuFfMZkOW4cZ9u7bTCw/eRWZojrSvClpZIglsNqw92
         eHS0+RIRpKfk/RUcur7NTTgN0MSIu+TwWp3ghJaDEbIjPrFOj1kBFz8zyvp5YUdHfa11
         B3FIykKeVhQJKnoVvH/1WY3U//cOY9FbjX7X97gfhbRefXJdqLpSkxRpZmxEYWImH7Fq
         sF/dNlk7xvaT1GpBcmsDdRQsdc9/QSySTPfdDq5OlU2jHqVl/+Q7SWgywBORUV3LVZXZ
         eS4w==
X-Gm-Message-State: ANoB5plLpnPlGAFohx177IKT5OlrELJQKnwtGF2zv957nuI1GZYODD3k
        uUgnYtzV8Eb+rXVd67taMlbyKphy8sGgYKetWLX656yRhmuZv3Z1MDUziL3l5nnB7v0ZMU/Sj6c
        lyXfVzT5MsdMAnBGapHGJigIuVyk=
X-Received: by 2002:a67:f997:0:b0:3b1:457e:ca6f with SMTP id b23-20020a67f997000000b003b1457eca6fmr13583296vsq.28.1671039887843;
        Wed, 14 Dec 2022 09:44:47 -0800 (PST)
X-Google-Smtp-Source: AA0mqf4M0BHvCeSnD1r5X0cRpd7op5VpYt/qIpGw/J+nhzyZ3BsMbO1R2BvzMAJ8PlEu5ELACUyFnQ==
X-Received: by 2002:a67:f997:0:b0:3b1:457e:ca6f with SMTP id b23-20020a67f997000000b003b1457eca6fmr13583270vsq.28.1671039887471;
        Wed, 14 Dec 2022 09:44:47 -0800 (PST)
Received: from bfoster (c-24-61-119-116.hsd1.ma.comcast.net. [24.61.119.116])
        by smtp.gmail.com with ESMTPSA id v25-20020a05620a0a9900b006f9f714cb6asm9925765qkg.50.2022.12.14.09.44.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Dec 2022 09:44:46 -0800 (PST)
Date:   Wed, 14 Dec 2022 12:44:52 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     Kent Overstreet <kent.overstreet@linux.dev>
Cc:     linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH RFC] bcachefs: use inode as write point index instead of
 task
Message-ID: <Y5oLlLcHmS2EWp8n@bfoster>
References: <20221212190602.1388127-1-bfoster@redhat.com>
 <20221213183743.3m6ntfnu7n3yebng@moria.home.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221213183743.3m6ntfnu7n3yebng@moria.home.lan>
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Tue, Dec 13, 2022 at 01:38:33PM -0500, Kent Overstreet wrote:
> On Mon, Dec 12, 2022 at 02:06:02PM -0500, Brian Foster wrote:
> > Use the pointer to the current in-core inode object as the hash of
> > the write point associated with block allocation for buffered
> > writes.
> > 
> > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > ---
> > 
> > Hi bcachefs folks,
> > 
> > I'm posting this RFC more as a discussion point than a direct proposal.
> > I've been poking around a bit at bcachefs just to grok some of the
> > basics and whatnot and ended up digging down into the block allocation
> > code a bit. From there I was trying to make sense of the bucket and
> > write point abstractions, and then noticed that the write point
> > structure used to track allocation/write contexts is hashed by task.
> > IIUC, that means a single task that might be writing to multiple files
> > will do so via a single write point, or conversely multiple tasks that
> > might be writing to a single file would do so with multiple write points
> > (one associated with each task). In turn, that means the allocation
> > layout of a particular file might be a characteristic of the set of
> > tasks that initially wrote the file as opposed to something more
> > traditional based on inode locality.
> > 
> > In thinking about this a bit more, it seems logical that this derives
> > from bcache because it seems like a perfectly good cache allocation
> > policy. I suppose it might make sense in certain filesystem workloads
> > where per-file contiguity might no longer necessarily be the most
> > important thing in the world, but I'm curious if that is intentional for
> > bcachefs (the approach is documented, after all) and if there are any
> > particular workloads or use cases in mind for that sort of approach?
> > 
> > Even if it makes sense in some cases, I wonder whether it's the ideal
> > approach across the board. For example, consider how the task is tracked
> > through the inode from buffered write to writeback contexts so the
> > latter can locate the write point for the last task that wrote to the
> > file. Even if multiple tasks perform buffered writes to a file, we only
> > really use the last task that wrote to the file before the current
> > writeback cycle. Absent frequent writebacks, wouldn't it make some sense
> > to just associate the write point with the current inode pointer and use
> > that to minimize per-inode fragmentation?
> 
> Fundamentally, what we're doing is trying to preserve locality, the idea is that
> data written by the same process is likely related and should be written out
> together.
> 
> Consider a cp -r of many small files, or any sort of process that's writing out
> to many small files. Using the pid for the writepoint preserves locality, using
> the inode number would not.
> 

Yeah, that makes sense. I'm more curious about the value and tradeoff of
inter-file vs. intra-file locality and the associated workloads that
might or might not benefit. I suppose I can see value of a single writer
copying in a bunch of small files and the allocations being streamlined
as such. OTOH, what's the cost if separate files don't happen to follow
the same write point like this (i.e. as if cp were run one file at a
time)? Is there some indirect/internal to bcachefs benefit to this
behavior, or are we just trying to batch writes?

What about scenarios where the writing task is less relevant? For
example, perhaps something like a file server ingesting data for
multiple sets of large files via a thread pool or some such.. I'm not
sure I see as much value of a worker task doling out per-task hinted
allocations across a set of the N active files it might be processing..

Note that I'm just probing here; trying to understand the origin of this
heuristic, where it might or might not apply between bcache and
bcachefs, etc. I'm not familiar with bcache and have only just scratched
the surface of bcachefs to this point and this just happened to be the
first higher level question that arose when reading through the
allocation code.

The reason it stood out to me is that I'm not aware of fs' going through
major pains to preserve per-task locality across inodes in this sort of
way (XFS, for example, may deliberately spread files over the disk if
they happen to span directories, perhaps for different reasons). OTOH,
we do put effort into reducing per-file fragmentation in scenarios like
concurrent sustained buffered writes or random write/alloc workloads to
sparse files, and then usually hear from users one way or another when
those optimizations aren't effective enough. ;)

> > FWIW, I was able to run some oddball workloads that produce excessive
> > fragmentation by forcing frequent writeback activity, but my tests so
> > far are ad hoc and moreso just playing around to help understand
> > behavior. To be fair, more traditional filesystems don't necessarily
> > handle the same sort of tests terribly well either. What I found more
> > interesting is that with the small tweak from this RFC, the allocation
> > layout from bcachefs went from notably worse to notably better in that
> > kind of pathological workload. Thoughts?
> 
> Could you describe more what you were seeing and what the changes were? I think
> there is room for improvement here, but we're going to have to carefully think
> about and describe what we're trying to acheive.
> 

Eh, I'd have to go back at play around with it to provide specifics.. I
suspect I was doing something like multiple, concurrent, appending
writes to a single file from different tasks, also concurrent with a set
of sync_file_range() workers forcing frequent writeback activity, and
then seeing a notably large number of extents for the relative size of
the file. That turned around completely with the tweak in this patch.

This test wasn't intended to reflect any sort of sane workload. Rather,
to just try and confirm assumptions made from reading the code. I've not
actually tested anything like the more practical example mentioned
above, and I wouldn't expect it to result in anything nearly as
pathological as this test.

Did you have specific improvements or target use cases in mind in this
area..?

> It's not clear to me how this would have an effect at all in the test you're
> describing; forcing frequent writebacks is going to hurt in a COW filesystem,
> since every write is an allocation - need more information here.
> 

Yeah, I was just trying to wrap my head around the initial allocation
case for the time being..

Brian


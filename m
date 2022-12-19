Return-Path: <linux-bcachefs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 246FBC4167B
	for <linux-bcachefs@archiver.kernel.org>; Mon, 19 Dec 2022 15:28:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232217AbiLSP2I (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Mon, 19 Dec 2022 10:28:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232198AbiLSP2H (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Mon, 19 Dec 2022 10:28:07 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7319B7674
        for <linux-bcachefs@vger.kernel.org>; Mon, 19 Dec 2022 07:27:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1671463646;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=GiVA/v3Odu9nN9H6qW7dUczW3jRvb2dB+euNCn+8IfA=;
        b=IgKgCjNtSl/fZsoCv2o4x+u6T26VLGIGu6bN0PuKSnNnb6S6PrXcuMNYDQJsemrtiav/Dy
        XJiah1xw5x1/BYCQ1TkVULIsR6zUEhR57mGtdD8JkvPXARYV1rMyEmQneFtQq/Y9/uvXW+
        u7YC4B2RBc9havj14eKWMECz62/kjIE=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-675-YIxmSqtEP9e-JCytaiTfEA-1; Mon, 19 Dec 2022 10:27:19 -0500
X-MC-Unique: YIxmSqtEP9e-JCytaiTfEA-1
Received: by mail-qv1-f69.google.com with SMTP id a15-20020ad441cf000000b004c79ef7689aso5729553qvq.14
        for <linux-bcachefs@vger.kernel.org>; Mon, 19 Dec 2022 07:27:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GiVA/v3Odu9nN9H6qW7dUczW3jRvb2dB+euNCn+8IfA=;
        b=PxA1FOToEt8AnfUtod19obD1d4n/uPw2M06XqXLUp/mcz6mJ4qEfNKif5UwoeY079a
         fLxrk6vAhn0yW3ldw7I1REV57Wttad5ulWDqdbfYKUAC7pecGvUqLFAhjCDmMWdXKauB
         dmqG2/C3towAUa3r81bX5dBIv1cF+L1+H/nSlEhvB8aEGxm27CSIa8CaFUHq2c8nyNmb
         le/eg2FXXd1Jel83M31Oq6ttcKgFkbX8MOURi+86p8Q/3EgQbZmS1Od39AEoHV+RVAhE
         JzYoM7KvtUYV2V+G5I3/RAK0+wvsFDFRwUUx6PSHpBw2JEp1UTSim/g0nx3EuhzWobGk
         QExg==
X-Gm-Message-State: ANoB5pmdn4hxOgVi8S2X6zSibp2BZBx6SKEkl6881IkBPEHil6RbPpOZ
        WMBbZrVl9J81LgPBJeiJvfecEaHGcSoK0mxQuSt6XBtA6ykhcbWUNIaFvnOk/psgOTpEb6laCKm
        I2r/uEFoOxs99PuOEbyDGyq9qbAw=
X-Received: by 2002:ac8:710e:0:b0:3a7:e625:14f with SMTP id z14-20020ac8710e000000b003a7e625014fmr53522619qto.9.1671463638561;
        Mon, 19 Dec 2022 07:27:18 -0800 (PST)
X-Google-Smtp-Source: AA0mqf5v1zMD5toeEd0C3YTHUAr6q2sRIiaJau1MxcDW47/th/0GqkUbpf5pyD0EYRf4yYQjXsqMow==
X-Received: by 2002:ac8:710e:0:b0:3a7:e625:14f with SMTP id z14-20020ac8710e000000b003a7e625014fmr53522586qto.9.1671463638087;
        Mon, 19 Dec 2022 07:27:18 -0800 (PST)
Received: from bfoster (c-24-61-119-116.hsd1.ma.comcast.net. [24.61.119.116])
        by smtp.gmail.com with ESMTPSA id x13-20020ac8120d000000b003a6847d6386sm6120079qti.68.2022.12.19.07.27.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Dec 2022 07:27:16 -0800 (PST)
Date:   Mon, 19 Dec 2022 10:27:23 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     Kent Overstreet <kent.overstreet@linux.dev>
Cc:     linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH RFC] bcachefs: use inode as write point index instead of
 task
Message-ID: <Y6CC27y2Rf44DzFI@bfoster>
References: <20221212190602.1388127-1-bfoster@redhat.com>
 <20221213183743.3m6ntfnu7n3yebng@moria.home.lan>
 <Y5oLlLcHmS2EWp8n@bfoster>
 <Y5u3VlkA3AbhQKav@moria.home.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y5u3VlkA3AbhQKav@moria.home.lan>
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Thu, Dec 15, 2022 at 07:09:58PM -0500, Kent Overstreet wrote:
> On Wed, Dec 14, 2022 at 12:44:52PM -0500, Brian Foster wrote:
> > On Tue, Dec 13, 2022 at 01:38:33PM -0500, Kent Overstreet wrote:
> > > Fundamentally, what we're doing is trying to preserve locality, the idea is that
> > > data written by the same process is likely related and should be written out
> > > together.
> > > 
> > > Consider a cp -r of many small files, or any sort of process that's writing out
> > > to many small files. Using the pid for the writepoint preserves locality, using
> > > the inode number would not.
> > > 
> > 
> > Yeah, that makes sense. I'm more curious about the value and tradeoff of
> > inter-file vs. intra-file locality and the associated workloads that
> > might or might not benefit. I suppose I can see value of a single writer
> > copying in a bunch of small files and the allocations being streamlined
> > as such. OTOH, what's the cost if separate files don't happen to follow
> > the same write point like this (i.e. as if cp were run one file at a
> > time)? Is there some indirect/internal to bcachefs benefit to this
> > behavior, or are we just trying to batch writes?
> 
> There's two main factors.
> 
> Firstly, we've only got so many write points, so we're more likely to end up
> using the same write points as another application, and interspersing our data
> with theirs.
> 
> The big factor is bucket based allocation and copygc: preserving locality is
> more important in bcachefs than in other filesystems, because we have to
> evacuate a bucket before it can be reused. Keeping related data grouped together
> in the same bucket means that it's much more likely to all die (be deleted or
> overwritten) at the same time, and copygc won't have to do any work.
> 

OK, thanks. This is context I didn't have and gives me a bit more to dig
into.

> (Side note: bucket based allocation and copygc is what will make really good
> zoned device supoprt possible, which has been part of the design since forever
> and something I want to see finished - I've just been focusing on more core
> things).
> 
> > What about scenarios where the writing task is less relevant? For
> > example, perhaps something like a file server ingesting data for
> > multiple sets of large files via a thread pool or some such.. I'm not
> > sure I see as much value of a worker task doling out per-task hinted
> > allocations across a set of the N active files it might be processing..
> 
> There's been talk of plumbing a write point API up to userspace before - SSDs
> could make good use of it if they had it.
> 
> Or, perhaps we could detect when a task is writing to multiple files at the same
> time (not one after the other, as cp would) and switch to writepoint-per-file
> then.
> 

That's more along the lines of the direction I was expecting this to go
(if anywhere)...

> > The reason it stood out to me is that I'm not aware of fs' going through
> > major pains to preserve per-task locality across inodes in this sort of
> > way (XFS, for example, may deliberately spread files over the disk if
> > they happen to span directories, perhaps for different reasons). OTOH,
> > we do put effort into reducing per-file fragmentation in scenarios like
> > concurrent sustained buffered writes or random write/alloc workloads to
> > sparse files, and then usually hear from users one way or another when
> > those optimizations aren't effective enough. ;)
> 
> Maybe you could tell me more? I don't know nearly as much as I'd like to about
> allocator strategies in XFS; I've never gone as deep here as I'd like beacuse,
> quite honestly, people haven't complained :)
> 

Yeah.. I suspect typical buffered write/writeback behavior turns this
more into a potential refinement than a bug or anything.

A couple of the more common optimizations XFS uses are speculative
preallocation and extent size hints. The former is designed to mitigate
fragmentation, particularly in the case of concurrent sustained writes.
Basically it will selectively increase the size of appending delalloc
reservations beyond current eof in anticipation of further writes. In
the meantime, writeback will attempt to allocate maximal sized physical
extents for contiguous delalloc ranges. Finally, the allocation itself
will start off with a simple hint based on the physical location of the
inode. This helps ensure extents are eventually maximally sized whenever
sufficient contiguous free extents are available and similarly ensures
as related inodes are removed, contiguous extents are freed together.
Excess/unused prealloc blocks are eventually reclaimed in the background
or as needed.

Extent size hints are more for random write/allocation scenarios and
must be set by the user. For example, consider a sparse vdisk image
seeing random small writes all over the place. If we allocate single
blocks at a time, fragmentation and the extent count can eventually
explode out of control. An extent size hint of 1MB or so ensures every
new allocation is sized/aligned as such and so helps mitigate that sort
of problem as more of the file is allocated.

Of course XFS is fundamentally different in that it's not a COW fs, so
might have different concerns. It supports reflinks, but that's a
relatively recent feature compared to the allocation heuristics and not
something they were designed around or significantly updated for (since
COW is not default behavior, although I believe an always_cow mode does
exist).

> (And the company funding me cares very much about streaming bandwidth on
> rotating disk, it's something we've looked at. The bigger issue last time we
> looked was that readdir order in bcachefs doesn't match create order or sort
> order, because directories are implemented as simple open addressing hash
> tables - meaning reading back files in a directory incurred unnecessary seeks on
> file boundaries. Another todo list item :)
> 
> > Eh, I'd have to go back at play around with it to provide specifics.. I
> > suspect I was doing something like multiple, concurrent, appending
> > writes to a single file from different tasks, also concurrent with a set
> > of sync_file_range() workers forcing frequent writeback activity, and
> > then seeing a notably large number of extents for the relative size of
> > the file. That turned around completely with the tweak in this patch.
> > 
> > This test wasn't intended to reflect any sort of sane workload. Rather,
> > to just try and confirm assumptions made from reading the code. I've not
> > actually tested anything like the more practical example mentioned
> > above, and I wouldn't expect it to result in anything nearly as
> > pathological as this test.
> 
> *nod*
> 
> > Did you have specific improvements or target use cases in mind in this
> > area..?
> 
> I do think we could probably be doing something more than using the pid for the
> writepoint, I've just been waiting until we see specific workloads where the
> current behaviour falls over or have a specific complaint before designing
> something new.
> 

Ok. Based on the above, it kind of sounds like a worse case scenario
might be something like N files allocated by the same task in such a way
that each bucket ends up split between the N files, and then some number
of files end up removed. Rinse and repeat that sort of thing across new
sets of files and then presumably we'd have increasing amount of free
space in partially used buckets that cannot be allocated..?

Is copygc responsible for cleaning things up in such a case in order to
create more usable free space (hence the excessive copygc comment
below)?

> Target use cases - I want bcachefs to be able to handle any mainstream
> application XFS can (as well as brtfs/ext4/zfs) - i.e. be a truly general
> purpose filesystem. Anything needed to make that happen is on the table, long
> term - including potentially switching out the entire bucket-based allocator for
> something else, as an option - the codebase is flexible enough that we could do
> that.
> 

Good to know.

> I doubt it'll come to that though, especially now that we've got nocow mode - my
> expectation is that we'll be able to get it to do what we need to with perhaps
> minor tweaks to writepoint usage. Always contingent upon more data, of course.
> 
> More immediately, I'm trying to set things up so that we've got good visibility
> into what's going on can see what needs to be tweaked and tuned later.
> 
> One big thing we'll want to watch for is excessive copygc - that'll be an
> indication our data layout could've been better. We've got backpointers from
> buckets back to extents and inodes back to dirents, which means we could pretty
> easily have the copygc tracepoints start telling us the specific filenames it
> was moving data for.
> 

Hmm.. Ok, that gives me another area to look into re: copygc. ;) Thanks
for all of the feedback and context..

Brian


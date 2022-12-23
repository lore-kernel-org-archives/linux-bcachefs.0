Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61E7DC4332F
	for <linux-bcachefs@archiver.kernel.org>; Fri, 23 Dec 2022 11:50:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235994AbiLWLuA (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Fri, 23 Dec 2022 06:50:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235995AbiLWLtw (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Fri, 23 Dec 2022 06:49:52 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22020389D1
        for <linux-bcachefs@vger.kernel.org>; Fri, 23 Dec 2022 03:49:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1671796141;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=WAdkrHqykNVbfefzyg+6jDvKYKiUhLQWFZNq+D0zLF4=;
        b=iUHbEYYwWmK+KAoxFRftLc5DtS69ttgW4XxlPwcUHu5G1lEaZnfWKuGkmQiH9GXb4TfMg/
        UIcDt+WffhFB6EAM7cYmbmGxBPw6YXlJo9wPjIbp7ZRfwrwN8ECVHUOVYopeJp3ANceQS+
        XQh8Mt922ujoohxIEZhKEvVxdvAUx2s=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-513-WASPlDEpOJaamkwhxitPGw-1; Fri, 23 Dec 2022 06:49:00 -0500
X-MC-Unique: WASPlDEpOJaamkwhxitPGw-1
Received: by mail-qt1-f200.google.com with SMTP id fg11-20020a05622a580b00b003a7eaa5cb47so1930076qtb.15
        for <linux-bcachefs@vger.kernel.org>; Fri, 23 Dec 2022 03:49:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WAdkrHqykNVbfefzyg+6jDvKYKiUhLQWFZNq+D0zLF4=;
        b=1ZLHDQD9nyDMmRNmwUMdkPltzBWOEEhWR+jZ7OrUfD5pPZ7P244fGaWySGtyfpM2eW
         94f9aA8OyDRz1MIWHHooJkjfuP02ckv6O8JqSS2OZzxsXHcBjqsFubjiPdNvIS6pIQ0y
         ADfBKbj1yigPjrr5Ok2Ol+14gc+AiXb2Tsk7nzQCP1x0BMhWdG0f1ewOUlXXf716bVZ4
         E9aBM8P9Q02TzBraGhsoCBPga37fGiFN72pEfqe4oQUZyipc5KiRS5ANbeUjPbekOSMU
         M2/6Ph9jDUB379E1uS/ZEoQrhBNpv+fmgaycCbsnKEcCWTB66G8j+diefVidzUmLQIMc
         Y8Qw==
X-Gm-Message-State: AFqh2kpKozTMUSFKX/xamtzMUV+s2w0bVbZwWQgkws133gQh2FNSCmpT
        79GiR91d6a4PcfxxvhAsn+yKFfhUl9Am0yJvSPWAyjs7GLvGv2iKdSHki3NMg0+AvbKXAZsbpg6
        YTHMMXoEu4h5H86qxSpu16uysJ6Y=
X-Received: by 2002:a05:622a:488a:b0:3a5:c553:fa4c with SMTP id fc10-20020a05622a488a00b003a5c553fa4cmr14087655qtb.65.1671796139445;
        Fri, 23 Dec 2022 03:48:59 -0800 (PST)
X-Google-Smtp-Source: AMrXdXtQM4HIQfq5M95yjXyiqtZRUlpJm2Zn12o0jrqQ9diMUwLsT9g2Yp4IRW/QSHCPOe/f6FtBsg==
X-Received: by 2002:a05:622a:488a:b0:3a5:c553:fa4c with SMTP id fc10-20020a05622a488a00b003a5c553fa4cmr14087639qtb.65.1671796139119;
        Fri, 23 Dec 2022 03:48:59 -0800 (PST)
Received: from bfoster (c-24-61-119-116.hsd1.ma.comcast.net. [24.61.119.116])
        by smtp.gmail.com with ESMTPSA id he9-20020a05622a600900b003a816011d51sm1845595qtb.38.2022.12.23.03.48.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Dec 2022 03:48:58 -0800 (PST)
Date:   Fri, 23 Dec 2022 06:49:05 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     Kent Overstreet <kent.overstreet@linux.dev>
Cc:     linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH RFC] bcachefs: use inode as write point index instead of
 task
Message-ID: <Y6WVsZ6IXPngUw9R@bfoster>
References: <20221212190602.1388127-1-bfoster@redhat.com>
 <20221213183743.3m6ntfnu7n3yebng@moria.home.lan>
 <Y5oLlLcHmS2EWp8n@bfoster>
 <Y5u3VlkA3AbhQKav@moria.home.lan>
 <Y6CC27y2Rf44DzFI@bfoster>
 <Y6EJmGTbFmAgmjre@moria.home.lan>
 <Y6RjqsXgCAJ/M7c+@bfoster>
 <Y6UwQnjX7VyV2NGk@moria.home.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y6UwQnjX7VyV2NGk@moria.home.lan>
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Thu, Dec 22, 2022 at 11:36:18PM -0500, Kent Overstreet wrote:
> On Thu, Dec 22, 2022 at 09:03:22AM -0500, Brian Foster wrote:
> > On Mon, Dec 19, 2022 at 08:02:16PM -0500, Kent Overstreet wrote:
> > > On Mon, Dec 19, 2022 at 10:27:23AM -0500, Brian Foster wrote:
> > > > A couple of the more common optimizations XFS uses are speculative
> > > > preallocation and extent size hints. The former is designed to mitigate
> > > > fragmentation, particularly in the case of concurrent sustained writes.
> > > > Basically it will selectively increase the size of appending delalloc
> > > > reservations beyond current eof in anticipation of further writes. In
> > > > the meantime, writeback will attempt to allocate maximal sized physical
> > > > extents for contiguous delalloc ranges. Finally, the allocation itself
> > > > will start off with a simple hint based on the physical location of the
> > > > inode. This helps ensure extents are eventually maximally sized whenever
> > > > sufficient contiguous free extents are available and similarly ensures
> > > > as related inodes are removed, contiguous extents are freed together.
> > > > Excess/unused prealloc blocks are eventually reclaimed in the background
> > > > or as needed.
> > > > 
> > > > Extent size hints are more for random write/allocation scenarios and
> > > > must be set by the user. For example, consider a sparse vdisk image
> > > > seeing random small writes all over the place. If we allocate single
> > > > blocks at a time, fragmentation and the extent count can eventually
> > > > explode out of control. An extent size hint of 1MB or so ensures every
> > > > new allocation is sized/aligned as such and so helps mitigate that sort
> > > > of problem as more of the file is allocated.
> > > > 
> > > > Of course XFS is fundamentally different in that it's not a COW fs, so
> > > > might have different concerns. It supports reflinks, but that's a
> > > > relatively recent feature compared to the allocation heuristics and not
> > > > something they were designed around or significantly updated for (since
> > > > COW is not default behavior, although I believe an always_cow mode does
> > > > exist).
> > > 
> > > *nod* Yeah, I've been wondering how much this stuff makes sense in the context
> > > of a COW filesystem.
> > > 
> > > But we do have nocow mode, complete with unwritten extents. If we need to go the
> > > delalloc route, I think the existing allocator design should be able to support
> > > that (we can pin space purely as an in memory operation, but we do have a fixed
> > > number of those so we have to be careful about introducing deadlocks).
> > > 
> > > It sounds like the optimizations XFS is doing are trying to ensure that writes
> > > remain contiguous on disk even when buffered writeback isn't batching them up as
> > > much as we'd like? Is that something we still feel is important?
> > > Pagecache/system memory size keeps going up but seek times do not (and go down
> > > in the case of flash); it's not clear to me that this is still important today.
> > > 
> > 
> > That's a good question and I don't really know the answer. I suspect
> > there is more to it than the fundamental principles of hardware and
> > related improvements. In practice these sorts of things still improve fs
> > efficiency, performance, scalability, aging (perhaps under less than
> > ideal hardware/workload/resource conditions), etc. Given the relative
> > low cost (in terms of complexity) of the implementation, they certainly
> > aren't things I see going away from fs' like XFS any time soon. The
> > underlying concepts may just not be as generically relevant (i.e. useful
> > across different fs implementations) as perhaps they might have been in
> > the past.
> 
> Certainly no pressing reason to drop that code from XFS, but bcachefs is a clean
> slate (and COW introduces different challenges) so I have to think about things
> differently.
> 
> > 
> > When you think about it, it is kind of amusing to see things like the fs
> > attempt to create as large/contiguous mappings as possible, only for
> > writeback to subsequently have to explicitly break them up into smaller
> > I/O requests because otherwise the massive amount of in-core metadata
> > status updates that result (i.e. clearing per-page writeback state)
> > leads to excessive completion latency. ;) OTOH, if that eventually leads
> > to more use of things like large folios, then perhaps that's an overall
> > win.
> 
> Hmm? That sounds like an odd way to describe things.
> 

IIRC that's pretty much the current behavior with XFS and iomap. XFS
aggressively allocates large contiguous extents, writeback thus
constructs large enough bio chains in the iomap ioend that completion
processing can produce soft lockups just dealing with pages involved
with the bio chain. Therefore the ioend became capped to a max number of
chained bios. Of course writeback still carries on submitting the same
amount of overall I/O either way, just made up of more ioends with
smaller bio chains. But I suspect as folio size is able to increase,
we'll be back to constructing larger I/Os based on fewer folios and thus
with less processing overhead per submission (in scenarios where
multipage bvecs doesn't already do so, at least).

Brian

> Folios are certainly long overdue and are going to be a big help, but more in
> the buffered IO paths than writeback I expect. Writeback can and does aggregate
> adjacent pages into the same IO; in bcachefs this is right now limited to 2 MB
> in practice because we represent the IO from the very start as a bio, but large
> folios + multipage bvecs should finally get us past that limit.
> 
> IOW, once I do the large folio conversion writeback ought to be generating
> bucket sized extents - when data checksums are off, as they'll otherwise limit
> extent size (and that restriction will be lifted once we get extents with block
> granular/variable granularity checksums).
> 


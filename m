Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A22AC4332F
	for <linux-bcachefs@archiver.kernel.org>; Thu, 22 Dec 2022 14:04:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229985AbiLVOEK (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Thu, 22 Dec 2022 09:04:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230299AbiLVOEI (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Thu, 22 Dec 2022 09:04:08 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C743C2A24F
        for <linux-bcachefs@vger.kernel.org>; Thu, 22 Dec 2022 06:03:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1671717801;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=CtfrUuxEUJ4vot5LWyYTZkOw5zQPrhXVMxNg75ZlaKk=;
        b=VFUzbnLPokQh02kmAUmb/a5yCp/b27bdUEYlzcG1k2n2ObCu3ZV/gRUy4b9PBSQj/2ghEX
        eJH0hSNNN7n9ge68zY5naxir9FCsHGes9qlkwN2+GbOnUSQEq/hZxy5XrvmFulumF5DszT
        oe9iUR4BCA8P82r/umgYZSLgP8H+7PY=
Received: from mail-oo1-f72.google.com (mail-oo1-f72.google.com
 [209.85.161.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-587-UiKKXwoyPqSkIG_PIYPhFg-1; Thu, 22 Dec 2022 09:03:19 -0500
X-MC-Unique: UiKKXwoyPqSkIG_PIYPhFg-1
Received: by mail-oo1-f72.google.com with SMTP id p27-20020a4a3c5b000000b004a3f1e7cc1fso748841oof.23
        for <linux-bcachefs@vger.kernel.org>; Thu, 22 Dec 2022 06:03:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CtfrUuxEUJ4vot5LWyYTZkOw5zQPrhXVMxNg75ZlaKk=;
        b=hVQAOu6N+fdHmbv8Kl35L0pUc9a4VG/3J8PHg37tYFQLZQCzUu0CD4EDXQL3n17ouN
         kySWWDEptUE0oCuhZQG3jglWTbn/j/xx0lorqTCORYtbdPUWLcGfz0T38EVN/zfiPwrq
         pTixKjB5/gDFEhp8byRDxP67dn5QhX1lq/7dK4POoMN4ellb5JIjdJbLJWhDBF4iG2SJ
         Jd+5Wsp/bYBleHsdhkFceSV7ecuD6TA5WQsM+oNbpImMF5VCW/iBRzI1NPig3g8eznky
         yDObjA4PPnvv1UZmBS7sfi6p8+8X+dloUSQSQ3rvMJFGOLq4RFPrcn0V2/czyhtA0pa+
         PGCw==
X-Gm-Message-State: AFqh2kpEZGIZk9V3MFb5ZgS3FS7NTk3Oc0ab4m/LGe9V3MK8oHyZrsLJ
        MS3uFPIEIF6RWqkK+NXcJ76aIeiOFeIT34NOfoHEZc4RpfVWW7gVrMP7Zx2wrVIrTA93KxfHY7R
        F6Uv5dqtN4A0xCiOPgYYcO+z26rE=
X-Received: by 2002:a54:461a:0:b0:35e:a6cd:a871 with SMTP id p26-20020a54461a000000b0035ea6cda871mr2512571oip.41.1671717797835;
        Thu, 22 Dec 2022 06:03:17 -0800 (PST)
X-Google-Smtp-Source: AMrXdXuo2L5IitDQ9YMC2g+WJs87akFORjLCgh6HIM5yxS8m+UAZ6A3mCs2TFwZG6Qz9nRaLu7A5dQ==
X-Received: by 2002:a54:461a:0:b0:35e:a6cd:a871 with SMTP id p26-20020a54461a000000b0035ea6cda871mr2512535oip.41.1671717797369;
        Thu, 22 Dec 2022 06:03:17 -0800 (PST)
Received: from bfoster (c-24-61-119-116.hsd1.ma.comcast.net. [24.61.119.116])
        by smtp.gmail.com with ESMTPSA id s10-20020a05620a29ca00b006ee949b8051sm345618qkp.51.2022.12.22.06.03.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Dec 2022 06:03:16 -0800 (PST)
Date:   Thu, 22 Dec 2022 09:03:22 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     Kent Overstreet <kent.overstreet@linux.dev>
Cc:     linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH RFC] bcachefs: use inode as write point index instead of
 task
Message-ID: <Y6RjqsXgCAJ/M7c+@bfoster>
References: <20221212190602.1388127-1-bfoster@redhat.com>
 <20221213183743.3m6ntfnu7n3yebng@moria.home.lan>
 <Y5oLlLcHmS2EWp8n@bfoster>
 <Y5u3VlkA3AbhQKav@moria.home.lan>
 <Y6CC27y2Rf44DzFI@bfoster>
 <Y6EJmGTbFmAgmjre@moria.home.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y6EJmGTbFmAgmjre@moria.home.lan>
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Mon, Dec 19, 2022 at 08:02:16PM -0500, Kent Overstreet wrote:
> On Mon, Dec 19, 2022 at 10:27:23AM -0500, Brian Foster wrote:
> > A couple of the more common optimizations XFS uses are speculative
> > preallocation and extent size hints. The former is designed to mitigate
> > fragmentation, particularly in the case of concurrent sustained writes.
> > Basically it will selectively increase the size of appending delalloc
> > reservations beyond current eof in anticipation of further writes. In
> > the meantime, writeback will attempt to allocate maximal sized physical
> > extents for contiguous delalloc ranges. Finally, the allocation itself
> > will start off with a simple hint based on the physical location of the
> > inode. This helps ensure extents are eventually maximally sized whenever
> > sufficient contiguous free extents are available and similarly ensures
> > as related inodes are removed, contiguous extents are freed together.
> > Excess/unused prealloc blocks are eventually reclaimed in the background
> > or as needed.
> > 
> > Extent size hints are more for random write/allocation scenarios and
> > must be set by the user. For example, consider a sparse vdisk image
> > seeing random small writes all over the place. If we allocate single
> > blocks at a time, fragmentation and the extent count can eventually
> > explode out of control. An extent size hint of 1MB or so ensures every
> > new allocation is sized/aligned as such and so helps mitigate that sort
> > of problem as more of the file is allocated.
> > 
> > Of course XFS is fundamentally different in that it's not a COW fs, so
> > might have different concerns. It supports reflinks, but that's a
> > relatively recent feature compared to the allocation heuristics and not
> > something they were designed around or significantly updated for (since
> > COW is not default behavior, although I believe an always_cow mode does
> > exist).
> 
> *nod* Yeah, I've been wondering how much this stuff makes sense in the context
> of a COW filesystem.
> 
> But we do have nocow mode, complete with unwritten extents. If we need to go the
> delalloc route, I think the existing allocator design should be able to support
> that (we can pin space purely as an in memory operation, but we do have a fixed
> number of those so we have to be careful about introducing deadlocks).
> 
> It sounds like the optimizations XFS is doing are trying to ensure that writes
> remain contiguous on disk even when buffered writeback isn't batching them up as
> much as we'd like? Is that something we still feel is important?
> Pagecache/system memory size keeps going up but seek times do not (and go down
> in the case of flash); it's not clear to me that this is still important today.
> 

That's a good question and I don't really know the answer. I suspect
there is more to it than the fundamental principles of hardware and
related improvements. In practice these sorts of things still improve fs
efficiency, performance, scalability, aging (perhaps under less than
ideal hardware/workload/resource conditions), etc. Given the relative
low cost (in terms of complexity) of the implementation, they certainly
aren't things I see going away from fs' like XFS any time soon. The
underlying concepts may just not be as generically relevant (i.e. useful
across different fs implementations) as perhaps they might have been in
the past.

When you think about it, it is kind of amusing to see things like the fs
attempt to create as large/contiguous mappings as possible, only for
writeback to subsequently have to explicitly break them up into smaller
I/O requests because otherwise the massive amount of in-core metadata
status updates that result (i.e. clearing per-page writeback state)
leads to excessive completion latency. ;) OTOH, if that eventually leads
to more use of things like large folios, then perhaps that's an overall
win.

Anyways, I just bring these things up here for reference and discussion
purposes..

> > Ok. Based on the above, it kind of sounds like a worse case scenario
> > might be something like N files allocated by the same task in such a way
> > that each bucket ends up split between the N files, and then some number
> > of files end up removed. Rinse and repeat that sort of thing across new
> > sets of files and then presumably we'd have increasing amount of free
> > space in partially used buckets that cannot be allocated..?
> 
> Yep, that would do it.
> 

Ok.

> > 
> > Is copygc responsible for cleaning things up in such a case in order to
> > create more usable free space (hence the excessive copygc comment
> > below)?
> 
> Correct. Copygc finds buckets that are mostly but not completely empty and
> evacuates them - writes the data in them to new buckets.
> 
> Copygc doesn't do any file-level defragmentation, but now that we have
> backpointers it could.
> 

Cool.

> > Hmm.. Ok, that gives me another area to look into re: copygc. ;) Thanks
> > for all of the feedback and context..
> 
> Feel free to hit me up on IRC as you're looking at code. I'm also currently
> working on the copygc code - we have a persistent fragmentation index about to
> land, which will be a drastic improvement to copygc scalability. Not relevant to
> what you're looking at, but the code is at least fresh in my mind :)
> 

Thanks. Appreciate the feedback here and in the other subthread. I'm
currently mostly trying to grok core concepts and map them to areas of
code and such, but will undoubtedly have more questions once I get more
into details..

Brian


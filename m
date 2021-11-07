Return-Path: <linux-bcachefs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4001C433EF
	for <linux-bcachefs@archiver.kernel.org>; Sun,  7 Nov 2021 14:59:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B45C260E97
	for <linux-bcachefs@archiver.kernel.org>; Sun,  7 Nov 2021 14:59:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229639AbhKGPBx (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Sun, 7 Nov 2021 10:01:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235544AbhKGPBx (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Sun, 7 Nov 2021 10:01:53 -0500
Received: from mail-qk1-x72f.google.com (mail-qk1-x72f.google.com [IPv6:2607:f8b0:4864:20::72f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7218C061714
        for <linux-bcachefs@vger.kernel.org>; Sun,  7 Nov 2021 06:59:10 -0800 (PST)
Received: by mail-qk1-x72f.google.com with SMTP id bi29so13350725qkb.5
        for <linux-bcachefs@vger.kernel.org>; Sun, 07 Nov 2021 06:59:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=WngOgI+nWUypHGzRy2Ah2wCMzPHPBhxCMGztxN+LJkM=;
        b=hHzNbPlkNuyNu3N2bMM+/n8WfLcJPEwh5SalkecJF89OsSN5OyWF4FZAQz8gQY5G4v
         anCQcGMEYEyN79LNBW0wYfnQ7Vb9YDVpfk40JVFW/+m295xFd1MycfUrSJhlb3InwQZn
         iNcqOS4Ak+R58PEAL9D+gB1wrU2cNZKB9Mi+48N2uhynWEAo0Q+Kp7ctBDJwgkaz7KRX
         OTEOhXiqvXoHQUhlOzS7wf2r5nQY3vdLSmCuk1TW4VQFEHnrrbcFbbK6kEuAFjtSrBzl
         mLiwmM1lXAWqp4fTBJFDM1flaJRWMw3Bx0ksGJZTzulx6RNj6AQq+fe4iUkDtsuhPCCQ
         SDDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=WngOgI+nWUypHGzRy2Ah2wCMzPHPBhxCMGztxN+LJkM=;
        b=LEf2uqCBMMO6OTQpaKjBiMBqQ7xyk2ZIACoTuge0wMQS0a73+wS+pR1S9O82Uf0xbK
         Xr6B6H4bbdQbXjfFIYY3hHSjrGKRqlIAdt4oB5rmx6EqYgDzGtB8jYcBbPO9EWHq6B9i
         FybjGn2G4Bx47wrTnsZIoinTQ08hF1Jh+tjmE+2tQdvjCyRKIHYSuxyt3fCiZddj+y3s
         vnhH8qwHPdpfKicsKy5G1H81phbaB0GtNta9rfK/H/DygcuyC+h450J6mX8Vi/hWFwOs
         9vzvhu8r3BQEpXuqw55PE4nciPzYv3GaKUpc5N+vB58wyq80zVn/mALsGS81ioFyBDIM
         bo+w==
X-Gm-Message-State: AOAM532+6XIGukBMDk75LS+VvXHhsACKsyuaLIdsMG5gav2jLaC0lolC
        fq9iw0gF2bps447d5cYjw3H3q3dFOQ==
X-Google-Smtp-Source: ABdhPJy4pMl27RpuHaABiQSPXmpGp42mAsuDYm6jTooS7qwmFaVEGTJuvpwMKKyRQlF+VV+wq3qVDA==
X-Received: by 2002:a05:620a:25ce:: with SMTP id y14mr58447469qko.66.1636297149453;
        Sun, 07 Nov 2021 06:59:09 -0800 (PST)
Received: from moria.home.lan (c-73-219-103-14.hsd1.vt.comcast.net. [73.219.103.14])
        by smtp.gmail.com with ESMTPSA id h14sm9575423qth.23.2021.11.07.06.59.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 Nov 2021 06:59:08 -0800 (PST)
Date:   Sun, 7 Nov 2021 09:59:07 -0500
From:   Kent Overstreet <kent.overstreet@gmail.com>
To:     Chris Webb <chris@arachsys.com>
Cc:     linux-bcachefs@vger.kernel.org
Subject: Re: More eager discard behaviour
Message-ID: <YYfpu0kzD7gmSLLH@moria.home.lan>
References: <20211106171156.GM11670@arachsys.com>
 <YYbZii7HNJ8lb8FF@moria.home.lan>
 <20211106213649.GN11670@arachsys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211106213649.GN11670@arachsys.com>
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Sat, Nov 06, 2021 at 09:36:50PM +0000, Chris Webb wrote:
> I'm definitely interested in helping out if I can, although there's a slight
> risk of biting off more than I can chew: I probably understand even less
> about the design and structure of your fs at the moment than you think!
> 
> I don't want to be a slow-moving obstacle on your critical path or more of a
> nuisance than a help, but equally, getting stuck in is clearly the best way
> to figure out how it fits together and become more useful. So happy to give
> anything a go that you think is reasonable for a newcomer to take a crack
> at. :) 

This won't be critical path for awhile - I need to focus on bugs before I can
start anything new (and I've been chasing zome real doozies the past few days; I
stumbled across multiple... interesting... bugs while trying to get xfstest
generic/547 to pass). And this might be one of the easier places to get started,
stuff that just interfaces with the btree tends to be fairly clean (vs. the code
that interfaces with the Linux VFS, which is where I'm at now).

So, the LRU: We don't do our LRU with lists, we do it with a clock. We've got
persistent clocks that track the amount of IO has been done in a filesystem,
broken out as reads or writes, and we track for each bucket when it was last
read or written to.

So in the btree, you've got struct bch_alloc/bch_alloc_v2/bch_alloc_v3 now -
that's the value type for alloc keys, which describe buckets - you'll see
they've got read_time and write_time fields (stored as varints).
bch2_bucket_io_time_reset() updates the read or write time for a given bucket.

Currently the lru is implemented by find_reclaimable_buckets_lru(), which scans
the in memory array of buckets and build up a heap - there's some logic in there
that won't be relevant for the persistent LRU, this code is also preferring
buckets which don't need a journal commit yet and that's going to be moved
elsewhere.

The relevant bit is the first path in bucket_sort_key(), for buckets that have a
nonzero amount of data (i.e. cached data in them) - there's some arithmetic in
there to combine the last read time with the amount of data currently used.

The new persistent LRU will be roughly the same idea - we'll create a new btree,
call it BTREE_ID_lru, where keys in that btree point back to buckets (and alloc
keys will also need a new field pointing the the LRU key, when it exists), and
the first key in the LRU btree will point to the bucket we want to reuse next.

We'll add a transactional trigger for alloc keys - bch2_trans_mark_alloc(),
following the patterns for other triggers in buckets.c (at some point we need to
split up buckets.c into multiple files, it's gotten to be a bit of a mishmash -
but that's where the btree triggers code lives for now).

The trigger will take an old and a new alloc key, and when the LRU index is
changing it'll just delete the old LRU key and create a new one. Note that
multiple buckets could end up with the same LRU index but we can't store their
keys in the LRU btree at the same slot - so when that happens we'll have to use
the next empty slot.

We need to decide how the LRU index should be calculated. The current code
calculates "time since this bucket was last read from", i.e. now -
g->io_time[READ], and then it scales that by the amount of live data in the
bucket - given two buckets that were both read from at the same time, we want to
prefer the bucket that has more live data in it.

But "time since this bucket was last read from" isn't a stable value, it changes
as we do IO. Ignoring the part where we scale by bucket_sectors_used for the
moment, we'd want the index in the LRU btree to be just the bucket's read_time
field - that would get us LRU behaviour.

So how do we incorporate bucket_sectors_used into the calculation? read_time *
sectors_used isn't right - it scales the LRU index up or down correctly as
sectors_used chages, but that means if we've got a full bucket that hasn't been
read from in a very long time, we'll prefer to keep that over a bucket that was
_just_ read from and is only half full.

I think this code will do roughly what we want:

/* ratio between 0 (completely full bucket) and 1 (full bucket)
float bucket_fragmentation = (bucket_size - bucket_sectors_used) / bucket_sectors_used;

u64 lru_idx = read_time - (now - read_time) * bucket_fragmentation;

Can't do floating point in the kernel so the actual arithmetic will be
different, and we'll have to guard against underflow and overflow. And this
calculation still isn't stable - we'll end up with a different number if we do
at different times, but that's ok as long as we store the LRU idx we calculated
in the alloc key.

Let me know if you get stuck :)

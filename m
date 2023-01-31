Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51225C636CC
	for <linux-bcachefs@archiver.kernel.org>; Tue, 31 Jan 2023 16:04:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231721AbjAaQEL (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Tue, 31 Jan 2023 11:04:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231822AbjAaQED (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Tue, 31 Jan 2023 11:04:03 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FF2E521F4
        for <linux-bcachefs@vger.kernel.org>; Tue, 31 Jan 2023 08:03:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675180993;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=WcSH2FlF8T7tnqFhUpL9O7/FW/4QrCR630dssshR37k=;
        b=ZdzNSEj9l/J6D1Ae7PYwqwnPTMcWIv9NQfjJYfosJYyniKzRufCmFw4XhQmIRLQgKftvYS
        UxCJ5Ahgx9xkpZkGBAB3ZH8LWuwpqOVFAl5UpHxdnJSCi491o4xdEvAxyxwhM8xvLIdegm
        OdAwA9pWAGPwrRNQLBHoJUHX2PMCPnM=
Received: from mail-ot1-f69.google.com (mail-ot1-f69.google.com
 [209.85.210.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-558-EDHY1oiYO0WbDN0o-ADDjA-1; Tue, 31 Jan 2023 11:03:01 -0500
X-MC-Unique: EDHY1oiYO0WbDN0o-ADDjA-1
Received: by mail-ot1-f69.google.com with SMTP id dj7-20020a0568303a8700b0068bbd360f07so4218038otb.16
        for <linux-bcachefs@vger.kernel.org>; Tue, 31 Jan 2023 08:03:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WcSH2FlF8T7tnqFhUpL9O7/FW/4QrCR630dssshR37k=;
        b=VkIiGOUy63TnYSHBzDiaJFyA483GYfPhQJHXzh1ffNNqAZknxPx4ZF0JHyBlvACqNP
         cycQFDDUUsA/Uy1ngQLfFr6wAh8Q3wnjc9Xyw1yUinRfbrDFnBndW0L5eqsx4CONQjBD
         AOun06R4m/QqUwYRuKSqnqDBbqwzNf14pWHSfONcXCRD95ZZnBBbS+UeqAxr2HZf3D9w
         SFjpsbKDho2lwHVrwWVFdOuZINrpdpR0E+5dYt6xHJhPPHpgPhm1eucXQIv4p5Fs4KG4
         NgKEhEMcPu0yd+5ICckSz7TkKlT3Ktk94Vesm9sQFoADZmK4Ji5/lbVLFeNqh1OwaJlR
         himw==
X-Gm-Message-State: AO0yUKU3LIl3e5v/RuM1SiEWzo8ZqiBztC0eZnUMGGc4UnmnCBOk7cuG
        3HWgoT+l/ZOde/sHL6grijBD2twvDAv32WxWHxoI+KsDnxCZPeKx/4nx/nuA6oizl2yqQ+wccOf
        V2hnJUebHzYIh0KyFsvlQZkfVWiQ=
X-Received: by 2002:a05:6830:1098:b0:684:ac9d:1a17 with SMTP id y24-20020a056830109800b00684ac9d1a17mr6131409oto.3.1675180979685;
        Tue, 31 Jan 2023 08:02:59 -0800 (PST)
X-Google-Smtp-Source: AK7set9VNRxmUMNWckbseZAjxv/6AbCI4+EwZDmmq6wW2Pq8PBSfIj4yOR1t5jtusUD42bcg3+LJKw==
X-Received: by 2002:a05:6830:1098:b0:684:ac9d:1a17 with SMTP id y24-20020a056830109800b00684ac9d1a17mr6131384oto.3.1675180979201;
        Tue, 31 Jan 2023 08:02:59 -0800 (PST)
Received: from bfoster (c-24-61-119-116.hsd1.ma.comcast.net. [24.61.119.116])
        by smtp.gmail.com with ESMTPSA id ea17-20020a05620a489100b007204305dee4sm3665289qkb.19.2023.01.31.08.02.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Jan 2023 08:02:57 -0800 (PST)
Date:   Tue, 31 Jan 2023 11:04:11 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     Kent Overstreet <kent.overstreet@linux.dev>
Cc:     linux-bcachefs@vger.kernel.org
Subject: Re: fstests generic/441 -- occasional bcachefs failure
Message-ID: <Y9k7+6io64IpHlQh@bfoster>
References: <Y9FOlMILXFcNFsSW@bfoster>
 <Y9KXaSkuMZM663Vi@moria.home.lan>
 <Y9PkndpTQcHrZ+im@bfoster>
 <Y9f5GjOocd7Cq7V7@moria.home.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y9f5GjOocd7Cq7V7@moria.home.lan>
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Mon, Jan 30, 2023 at 12:06:34PM -0500, Kent Overstreet wrote:
> On Fri, Jan 27, 2023 at 09:50:05AM -0500, Brian Foster wrote:
> > Something else that occurred to me while looking further at this is we
> > can also avoid the error in this case fairly easily by bailing out of
> > bch2_fsync() if page writeback fails, as opposed to the unconditional
> > flush -> sync meta -> flush log sequence that returns the first error
> > anyways. That would prevent marking the inode with a new sequence number
> > when I/Os are obviously failing. The caveat is that the test still
> > fails, now with a "Read-only file system" error instead of EIO, because
> > the filesystem is shutdown by the time the vfs write inode path actually
> > runs.
> 
> If some pages did write successfully we don't want to skip the rest of
> the fsync, though.
> 

What does it matter if the fsync() has already failed? ISTM this is
pretty standard error handling behavior across major fs', but it's not
clear to me if there's some bcachefs specific quirk that warrants
different handling..

FWIW, I think I've been able to fix this test with a couple small
tweaks:

1. Change bch2_fsync() to return on first error.
2. Introduce a bcachefs specific delay in the working -> error table
switchover.

I've not run a full regression test on the bcachefs change yet, but if
you're willing to take a patch along those lines I can do that and then
if it survives, follow up with an upstream fstests patch. That would
allow this test to pass fairly reliably and also no longer
unconditionally shutdown bcachefs.

> The test failing because the filesystem went read-only is because a
> btree node write fails - I'm assuming without that change the test just
> fails before any btree node writes are attempted.
> 

Not sure I parse the above. Generally speaking, the test fails because
after the last successful fsync, it immediately switches over to the
error dm table. The fs still has some reclaim/journal work to do after
this point, however, so this essentially always results in emergency
shutdown. Whether the test passes or fails at this point depends on a
race between this shutdown sequence in the background and an fsync call
successfuly committing a transaction (calling bch2_mark_inode()).

The winner of the race dictates whether the first fsync() after
switching back to the working dm table can avoid the journal flush
because the seq associated with the inode is already on disk, or whether
the fs wants to flush the seq on a filesystem that has been shutdown
(and so will always fail).

> > All in all ISTM the shutdown is the fundamental issue wrt to this test.
> > I'm not sure it's worth complicating the log flush error handling with
> > errseq and whatnot just to filter out certain errors when the fs has
> > seen a catastrophic failure/shutdown (also agree with your followup that
> > isn't the most critical bug in the world anyways).
> 
> Well, our default setting on serious error is to go read-only, an a
> btree node write failing (in a single device, non replicated filesystem)
> definitely qualifies.
> 
> It looks like our behaviour on btree node write error does need to be
> looked at and improved/fixed: btree_io.c line 1734 has a clearly
> unfinished case. It looks like we're missing whatever logic should be
> there for a replicated filesystem - we definitely need to decide what to
> do when some but not all btree node writes fail.
> 

Interesting. I noticed that hunk and thought it looked odd, but didn't
have enough context to grok it.

> More relevant to this test, we also a setting for error behaviour -
> errors=(continue|ro|panic), but that explicitly does _not_ apply to
> write IO errors; if we can't write out metadata we always go read-only.
> 
> I'm not in a hurry to change that, because one of the things bcachefs
> currently does really well is stopping the world if things ever go so
> wrong that the filesystem would be inconsistent - we haven't had too
> much in the way of unrecoverable filesystems, and I don't want that to
> change :)
> 

Indeed, that makes sense. I wonder if it would make sense to issue
retries at some point?

As another XFS example, it also has an emergency shutdown mechanism for
similar purposes. Certain I/O failures result in immediate shutdown of
the fs and no further changes make it to disk. Because shutdown itself
is a catastrophic failure, metadata write failures are retried at least
once before initiating shutdown to filter out transient errors. On top
of that, there's a sysfs section for each mount that allows an admin to
configure error handling behavior as needed. This allows setting the
number of retries before an error is considered permanent (including
infinite retries for scenarios where errors are expected to be manually
recoverable), or how long to delay retries.

I'm not sure a simple retry once sequence would help with this test, but
an infinite retry option (with some delay) probably would.

OTOH, I wonder if a more elegant solution is to explicitly quiesce the
fs before the working -> error table switchover. That might typically be
done with a freeze/unfreeze cycle so the test can serialize against
whatever background work needs to complete before putting the block
device into error mode. However, I notice freeze isn't currently
supported on bcachefs. Any thoughts on freeze support?

> > Either way, I am trying to grok the commit/writeback/journaling path a
> > bit better here to try and understand why the fs shuts down in this test
> > whereas other fs' don't seem to. One thing I'm noticing is that this
> > whole path is rather asynchronous, making it a bit hard to follow. Any
> > tips on the best way to work through the big picture steps involved in
> > the path from a trans commit, through journaling, to eventual btree
> > writeback?
> 
> Transaction commit path is pretty much all straight line synchronous
> code - that's btree_update_leaf.c.
> 
> Basically, the transaction commit path takes a list of updates, and
>  - runs triggers (which will then generate more updates!)
>  - ensures all btree paths are fully traversed and have intent locks
>  - takes write locks on btree nodes
>  - gets a journal reservation
>  - does updates to leaf nodes/btree key cache (and soon the btree write
>    buffer as well)
> 

Yep, I was able to follow most of this with the exception of some
confusion over the key cache bits. IIUC, the initial trans commit might
add a key update to the key cache, whereas reclaim might commit another
transaction to flush the key cache to the btree (via the journal
callback you mention below).

> Btree node merging and splitting is also driven by the transaction
> commit path - before doing the update we check if we need to merge
> btree nodes (it has to be before the transaction commit in order to
> happen reliably), and btree node splitting is done in an error path -
> after taking write locks if we don't have space for the insert we bail
> out and to the split in bch2_trans_commit_error().
>  
> When we update a leaf node or btree key cache key, we mark it as dirty
> and create a journal pin for the journal sequence number we got a
> journal reservation for. A journal pin has a callback for journal
> reclaim to invoke - typically, writeback for the btree node cache and
> btree key cache is driven entirely by journal reclaim, and the journal
> pin also keeps the relevant journal entry dirty so that it'll be
> replayed by journal replay.
> 
> (That writeback behaviour will be changing at some point: the behaviour
> up until recently was that journal reclaim monitored the dirty
> percentage of the btree node cache and key cache and would run to those
> numbers under some threshold, but it turns out that really hurts
> performance on purely random write benchmarks - we writeback too
> aggressively, and we need to allow those caches to be 100% dirty if
> there isn't any memory pressure).
> 
> The journalling code is pretty self contained w.r.t. the rest of
> bcachefs. It is indeed a big pile of tricky asynchronous code (the fast
> paths need to be lockless - right now I'm working on making it even more
> lockless - and there's a lot of pipelining it has to do). At a high
> level it's pretty simple though, and you should be able to treat it as a
> black box. The main operations are:
> 
>  - getting a reservation: this gets you a reservation in a specific
>    journal entry - you're supposed to memcpy() whatever you want
>    journalled into the entry to be written and then quickly drop your
>    reservation.
> 
>    Blocking with a reservation will block the entire journal - note that
>    we get our journal reservation after taking btree write locks in the
>    transaction commit path (but we do it in nonblocking mode; if we have
>    to block on the journal we drop btree locks and do the waiting in
>    bch2_trans_commit_error()).
>  
>  - getting a pre-reservation: trying to get a journal reservation while
>    holding a journal pin would deadlock the journal if it ever
>    completely filled up - a pre-reservation allows reserving space in
>    the journal so that we can get a reservation later without
>    deadlocking. This is for e.g. flushing the btree key cache: when we
>    do a btree key cache update we update the key cache in memory and
>    journal the update, to flush the key cache we have to update the
>    btree which requires (for simplicity) re-journalling the update.
> 

Ah.. so does "for simplicity" here essentially mean "for reuse of the
transaction code?"

>  - flush_seq: given a journal sequence number we previously got a
>    journal reservation on, request that it be written out (with a
>    flush/fua write, not all journal entries are written flush/fua).
> 

Thanks for this. Something that initially confused me wrt to the journal
is that I was seeing journal writes after btree node writes. The docs
mention the journal is primarily an optimization and ordering is not
important for crash consistency. With that in mind, does that mean a
journal "pin" refers to entries held in the journal until written back
to the btree (as opposed to the journal pinning keys in memory)? IOW, it
doesn't really matter in which order that journal/btree writes occur,
but only that entries remain pinned in the journal until btree writes
complete..?

(I suspect this confused me because XFS uses the same pinning
terminology, but in that context it refers to metadata items being
pinned by the log, until the log item is flushed and thus unpins the
metadata item for final writeback. So ordering is a critical factor in
this context.).

> Then there's btree node writes, which it sounds like you might be
> getting into soon. Btree node writes are more complicated: btree nodes
> are log structured, so we have to differentiate between the first write
> to a new node and subsequent appending writes, and before returning a
> completion for an appending btree node write we have to update the
> pointer to that btree node (btree node pointers record the number of
> sectors currently written; this is important for multi device
> filesystems, and also for ensuring consistent ordering of updates after
> a crash - updates can't be visible if they weren't completed in the
> journal, so we have to ignore btree node writes that are newer than the
> newest completed journal write.
> 
> Originally this was handled with the journal sequence number blacklist
> mechanism - so you might see a few references to that still in
> btree_io.c - but now it's handled by updating parent pointers after
> every write, up to the root.
> 
> Hope that helps - and feel free to ask me more questions on IRC,
> irc.oftc.net#bcache.
> 

#bcache or #bachefs?

This is all extremely helpful. Thanks again.

Brian

> Cheers,
> Kent
> 


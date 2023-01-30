Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 793E7C54EED
	for <linux-bcachefs@archiver.kernel.org>; Mon, 30 Jan 2023 17:12:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233434AbjA3RL7 (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Mon, 30 Jan 2023 12:11:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237501AbjA3RL5 (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Mon, 30 Jan 2023 12:11:57 -0500
X-Greylist: delayed 310 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 30 Jan 2023 09:11:52 PST
Received: from out-44.mta1.migadu.com (out-44.mta1.migadu.com [IPv6:2001:41d0:203:375::2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24C64442FD
        for <linux-bcachefs@vger.kernel.org>; Mon, 30 Jan 2023 09:11:51 -0800 (PST)
Date:   Mon, 30 Jan 2023 12:06:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1675098397;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=hmih9w0ISRoxLirVujmW7dJLqWbvOZCo3YAoGOQiS8I=;
        b=rLfqzdYhlOWTR48uDMrbhfrJ3cB66P5VNjDL04WhS7DERcGnTlhTsMLlLuYYiPoE03rn/7
        8I2f5MGbKlu8BgbFJYxtxH13dqa7EeSVEEAdt8THijlN8Hfg2NxslbPXo6cJW4OgW2nAwJ
        3YP0oUkQyECY88KDfZtPgf4GzCOpA+A=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Kent Overstreet <kent.overstreet@linux.dev>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-bcachefs@vger.kernel.org
Subject: Re: fstests generic/441 -- occasional bcachefs failure
Message-ID: <Y9f5GjOocd7Cq7V7@moria.home.lan>
References: <Y9FOlMILXFcNFsSW@bfoster>
 <Y9KXaSkuMZM663Vi@moria.home.lan>
 <Y9PkndpTQcHrZ+im@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y9PkndpTQcHrZ+im@bfoster>
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Fri, Jan 27, 2023 at 09:50:05AM -0500, Brian Foster wrote:
> Something else that occurred to me while looking further at this is we
> can also avoid the error in this case fairly easily by bailing out of
> bch2_fsync() if page writeback fails, as opposed to the unconditional
> flush -> sync meta -> flush log sequence that returns the first error
> anyways. That would prevent marking the inode with a new sequence number
> when I/Os are obviously failing. The caveat is that the test still
> fails, now with a "Read-only file system" error instead of EIO, because
> the filesystem is shutdown by the time the vfs write inode path actually
> runs.

If some pages did write successfully we don't want to skip the rest of
the fsync, though.

The test failing because the filesystem went read-only is because a
btree node write fails - I'm assuming without that change the test just
fails before any btree node writes are attempted.

> All in all ISTM the shutdown is the fundamental issue wrt to this test.
> I'm not sure it's worth complicating the log flush error handling with
> errseq and whatnot just to filter out certain errors when the fs has
> seen a catastrophic failure/shutdown (also agree with your followup that
> isn't the most critical bug in the world anyways).

Well, our default setting on serious error is to go read-only, an a
btree node write failing (in a single device, non replicated filesystem)
definitely qualifies.

It looks like our behaviour on btree node write error does need to be
looked at and improved/fixed: btree_io.c line 1734 has a clearly
unfinished case. It looks like we're missing whatever logic should be
there for a replicated filesystem - we definitely need to decide what to
do when some but not all btree node writes fail.

More relevant to this test, we also a setting for error behaviour -
errors=(continue|ro|panic), but that explicitly does _not_ apply to
write IO errors; if we can't write out metadata we always go read-only.

I'm not in a hurry to change that, because one of the things bcachefs
currently does really well is stopping the world if things ever go so
wrong that the filesystem would be inconsistent - we haven't had too
much in the way of unrecoverable filesystems, and I don't want that to
change :)

> Either way, I am trying to grok the commit/writeback/journaling path a
> bit better here to try and understand why the fs shuts down in this test
> whereas other fs' don't seem to. One thing I'm noticing is that this
> whole path is rather asynchronous, making it a bit hard to follow. Any
> tips on the best way to work through the big picture steps involved in
> the path from a trans commit, through journaling, to eventual btree
> writeback?

Transaction commit path is pretty much all straight line synchronous
code - that's btree_update_leaf.c.

Basically, the transaction commit path takes a list of updates, and
 - runs triggers (which will then generate more updates!)
 - ensures all btree paths are fully traversed and have intent locks
 - takes write locks on btree nodes
 - gets a journal reservation
 - does updates to leaf nodes/btree key cache (and soon the btree write
   buffer as well)

Btree node merging and splitting is also driven by the transaction
commit path - before doing the update we check if we need to merge
btree nodes (it has to be before the transaction commit in order to
happen reliably), and btree node splitting is done in an error path -
after taking write locks if we don't have space for the insert we bail
out and to the split in bch2_trans_commit_error().
 
When we update a leaf node or btree key cache key, we mark it as dirty
and create a journal pin for the journal sequence number we got a
journal reservation for. A journal pin has a callback for journal
reclaim to invoke - typically, writeback for the btree node cache and
btree key cache is driven entirely by journal reclaim, and the journal
pin also keeps the relevant journal entry dirty so that it'll be
replayed by journal replay.

(That writeback behaviour will be changing at some point: the behaviour
up until recently was that journal reclaim monitored the dirty
percentage of the btree node cache and key cache and would run to those
numbers under some threshold, but it turns out that really hurts
performance on purely random write benchmarks - we writeback too
aggressively, and we need to allow those caches to be 100% dirty if
there isn't any memory pressure).

The journalling code is pretty self contained w.r.t. the rest of
bcachefs. It is indeed a big pile of tricky asynchronous code (the fast
paths need to be lockless - right now I'm working on making it even more
lockless - and there's a lot of pipelining it has to do). At a high
level it's pretty simple though, and you should be able to treat it as a
black box. The main operations are:

 - getting a reservation: this gets you a reservation in a specific
   journal entry - you're supposed to memcpy() whatever you want
   journalled into the entry to be written and then quickly drop your
   reservation.

   Blocking with a reservation will block the entire journal - note that
   we get our journal reservation after taking btree write locks in the
   transaction commit path (but we do it in nonblocking mode; if we have
   to block on the journal we drop btree locks and do the waiting in
   bch2_trans_commit_error()).
 
 - getting a pre-reservation: trying to get a journal reservation while
   holding a journal pin would deadlock the journal if it ever
   completely filled up - a pre-reservation allows reserving space in
   the journal so that we can get a reservation later without
   deadlocking. This is for e.g. flushing the btree key cache: when we
   do a btree key cache update we update the key cache in memory and
   journal the update, to flush the key cache we have to update the
   btree which requires (for simplicity) re-journalling the update.

 - flush_seq: given a journal sequence number we previously got a
   journal reservation on, request that it be written out (with a
   flush/fua write, not all journal entries are written flush/fua).

Then there's btree node writes, which it sounds like you might be
getting into soon. Btree node writes are more complicated: btree nodes
are log structured, so we have to differentiate between the first write
to a new node and subsequent appending writes, and before returning a
completion for an appending btree node write we have to update the
pointer to that btree node (btree node pointers record the number of
sectors currently written; this is important for multi device
filesystems, and also for ensuring consistent ordering of updates after
a crash - updates can't be visible if they weren't completed in the
journal, so we have to ignore btree node writes that are newer than the
newest completed journal write.

Originally this was handled with the journal sequence number blacklist
mechanism - so you might see a few references to that still in
btree_io.c - but now it's handled by updating parent pointers after
every write, up to the root.

Hope that helps - and feel free to ask me more questions on IRC,
irc.oftc.net#bcache.

Cheers,
Kent

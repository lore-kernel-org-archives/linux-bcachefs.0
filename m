Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8CDB0C61DA4
	for <linux-bcachefs@archiver.kernel.org>; Thu,  2 Feb 2023 15:51:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232758AbjBBPvF (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Thu, 2 Feb 2023 10:51:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232294AbjBBPuz (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Thu, 2 Feb 2023 10:50:55 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE5DF521E2
        for <linux-bcachefs@vger.kernel.org>; Thu,  2 Feb 2023 07:49:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675352952;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=sADM0rqnC7LMsqA9/q+dbLH7MsuRWjVin7ubshK1Xr0=;
        b=VsHkOY4gLF3lQday1JGSx6h6oXWS8oqb/4J2fzQWZ0A1g/mcYgY3/1aZ4vQW+KN0DTl206
        syaZMuKwcF6lRFIHZJ3sKPwIOs2bCUSjjQ/Jb8rHluDa7XSIwDk9BIBpkaEgGV6GjDcCyM
        xjjUwOoZiZAou+Zy48nEUrQT7OJGdcQ=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-133-ixW73DxLOqK9-1CR2nx95A-1; Thu, 02 Feb 2023 10:49:11 -0500
X-MC-Unique: ixW73DxLOqK9-1CR2nx95A-1
Received: by mail-qt1-f198.google.com with SMTP id f22-20020a05622a1a1600b003b8674f2302so1141445qtb.7
        for <linux-bcachefs@vger.kernel.org>; Thu, 02 Feb 2023 07:49:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sADM0rqnC7LMsqA9/q+dbLH7MsuRWjVin7ubshK1Xr0=;
        b=QI1Uhz4U8Y5ZTdzF+PH9Fi2o5qbBfE1y2fOR5Z+l3K3IqC9xnAoJJ+t+5lEv+pCcMy
         pO31nxqaH+/dMF/dx1uUmokaBhjo6XotzounsFx57y1pAG5OI5tNWib02G89denOH364
         rTgd4utddFSKTEJKuZODdKvVYWTokGxVORdlCLsVxz+uVqmzC0fhBtKKrb+H7t4ZXtuY
         bHGf1sffozzmR3oPvN9RO+0xs9EWJ/mACE9sg3GN7n9cvkoLGHaEy64hgIrt/Wn0nGrq
         7VSaInsrzLEhZ7FLQZGacuZWFJCoZTrf8TaCxVskxOYVm0NVeYfX0TaHDad1BeFkJ2iB
         bP6g==
X-Gm-Message-State: AO0yUKWNJRinZMFUBiNqQcr9adNjXasSo0hJF8VoFEidZGNIzumqHM9e
        LYpFGKzcBI+fgAFPfe7tGsfexgHTbuPz6p4rDmNrPiRqwlN5LR8wVQVZbBy60zy8if4rHljGi9I
        DTh1HkzqsX4U3QpIvkD6ZcVBWGNs=
X-Received: by 2002:ac8:5b84:0:b0:3b8:461b:4134 with SMTP id a4-20020ac85b84000000b003b8461b4134mr12899385qta.68.1675352950792;
        Thu, 02 Feb 2023 07:49:10 -0800 (PST)
X-Google-Smtp-Source: AK7set/ayuTLHon9CpuZZt0PPp1K9Kj5K9NXvefu2ZLTUdS59MWXNOwQTxO1OKxkPrt4l8PyspP7Ag==
X-Received: by 2002:ac8:5b84:0:b0:3b8:461b:4134 with SMTP id a4-20020ac85b84000000b003b8461b4134mr12899336qta.68.1675352950384;
        Thu, 02 Feb 2023 07:49:10 -0800 (PST)
Received: from bfoster (c-24-61-119-116.hsd1.ma.comcast.net. [24.61.119.116])
        by smtp.gmail.com with ESMTPSA id op50-20020a05620a537200b0072ddf70791fsm36703qkn.122.2023.02.02.07.49.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Feb 2023 07:49:09 -0800 (PST)
Date:   Thu, 2 Feb 2023 10:50:23 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     Kent Overstreet <kent.overstreet@linux.dev>
Cc:     linux-bcachefs@vger.kernel.org
Subject: Re: fstests generic/441 -- occasional bcachefs failure
Message-ID: <Y9vbv7TFyu+stccD@bfoster>
References: <Y9FOlMILXFcNFsSW@bfoster>
 <Y9KXaSkuMZM663Vi@moria.home.lan>
 <Y9PkndpTQcHrZ+im@bfoster>
 <Y9f5GjOocd7Cq7V7@moria.home.lan>
 <Y9k7+6io64IpHlQh@bfoster>
 <Y9p4ihwzFs0OP6to@moria.home.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y9p4ihwzFs0OP6to@moria.home.lan>
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Wed, Feb 01, 2023 at 09:34:50AM -0500, Kent Overstreet wrote:
> On Tue, Jan 31, 2023 at 11:04:11AM -0500, Brian Foster wrote:
> > On Mon, Jan 30, 2023 at 12:06:34PM -0500, Kent Overstreet wrote:
> > > On Fri, Jan 27, 2023 at 09:50:05AM -0500, Brian Foster wrote:
> > > > Something else that occurred to me while looking further at this is we
> > > > can also avoid the error in this case fairly easily by bailing out of
> > > > bch2_fsync() if page writeback fails, as opposed to the unconditional
> > > > flush -> sync meta -> flush log sequence that returns the first error
> > > > anyways. That would prevent marking the inode with a new sequence number
> > > > when I/Os are obviously failing. The caveat is that the test still
> > > > fails, now with a "Read-only file system" error instead of EIO, because
> > > > the filesystem is shutdown by the time the vfs write inode path actually
> > > > runs.
> > > 
> > > If some pages did write successfully we don't want to skip the rest of
> > > the fsync, though.
> > > 
> > 
> > What does it matter if the fsync() has already failed? ISTM this is
> > pretty standard error handling behavior across major fs', but it's not
> > clear to me if there's some bcachefs specific quirk that warrants
> > different handling..
> > 
> > FWIW, I think I've been able to fix this test with a couple small
> > tweaks:
> > 
> > 1. Change bch2_fsync() to return on first error.
> > 2. Introduce a bcachefs specific delay in the working -> error table
> > switchover.
> > 
> > I've not run a full regression test on the bcachefs change yet, but if
> > you're willing to take a patch along those lines I can do that and then
> > if it survives, follow up with an upstream fstests patch. That would
> > allow this test to pass fairly reliably and also no longer
> > unconditionally shutdown bcachefs.
> 
> If you link me your git repo I'll add it to the CI so all the automated
> tests run.
> 

I don't have a public repo atm but I've posted the patch if you have
somewhere to land it for CI testing..? It survived my regression tests
so far, FWIW. (I also had posted that random cleanup patch a bit ago if
you hadn't noticed..).

Is there a reporting dashboard or something available for the test
infrastruture for bcachefs?

> > 
> > > The test failing because the filesystem went read-only is because a
> > > btree node write fails - I'm assuming without that change the test just
> > > fails before any btree node writes are attempted.
> > > 
> > 
> > Not sure I parse the above. Generally speaking, the test fails because
> > after the last successful fsync, it immediately switches over to the
> > error dm table. The fs still has some reclaim/journal work to do after
> > this point, however, so this essentially always results in emergency
> > shutdown. Whether the test passes or fails at this point depends on a
> > race between this shutdown sequence in the background and an fsync call
> > successfuly committing a transaction (calling bch2_mark_inode()).
> 
> *nod* That's more accurate.
> 
> > Indeed, that makes sense. I wonder if it would make sense to issue
> > retries at some point?
> 
> Possibly. AFAIK, on typical block devices we shouldn't see write errors
> unless the device is really not working anymore - both spinning rust and
> SSDs will remap on write error, and on transport error IMO the block
> layer is the more correct place to be issuing retries, if so desired.
> 
> But we do have aspirations of running on raw flash in the
> not-too-distant future (ZNS SSDs), and I would expect we'll need retry
> logic at that point.
> 
> > I'm not sure a simple retry once sequence would help with this test, but
> > an infinite retry option (with some delay) probably would.
> 
> I'd think we'd want a timeout, not a specific number of retries to
> attempt (or perhaps both).
> 
> > OTOH, I wonder if a more elegant solution is to explicitly quiesce the
> > fs before the working -> error table switchover. That might typically be
> > done with a freeze/unfreeze cycle so the test can serialize against
> > whatever background work needs to complete before putting the block
> > device into error mode. However, I notice freeze isn't currently
> > supported on bcachefs. Any thoughts on freeze support?
> 
> Freeze definitely needs to happen. It's been _ages_ since I was looking
> at it so I couldn't say offhand where we'd need to start, but if you're
> interested I'd be happy to look at what it'd take.
> 

Yeah, that would be interesting. Thanks.

> > Ah.. so does "for simplicity" here essentially mean "for reuse of the
> > transaction code?"
> 
> Yes - bch2_btree_key_cache_journal_flush() -> btree_key_cache_flush_pos()
> -> bch2_trans_commit().
> 
> > 
> > >  - flush_seq: given a journal sequence number we previously got a
> > >    journal reservation on, request that it be written out (with a
> > >    flush/fua write, not all journal entries are written flush/fua).
> > > 
> > 
> > Thanks for this. Something that initially confused me wrt to the journal
> > is that I was seeing journal writes after btree node writes. The docs
> > mention the journal is primarily an optimization and ordering is not
> > important for crash consistency.
> 
> Wherever you read that must date to well before bcachefs was a thing -
> that was true in bcache when the journalling code was still new. In
> bcachefs ordering of updates is important and the journal is indeed our
> global time ordering.
> 

FWIW, I was reading through the "Journaling" and "Sequential
consistency" sections of the architecture documentation [1]. It's
possible I just misinterpreted some wording.

[1] https://bcachefs.org/Architecture/#Journaling

> > With that in mind, does that mean a
> > journal "pin" refers to entries held in the journal until written back
> > to the btree (as opposed to the journal pinning keys in memory)? IOW, it
> > doesn't really matter in which order that journal/btree writes occur,
> > but only that entries remain pinned in the journal until btree writes
> > complete..?
> 
> Correct.
> 

Ok, I think I get the general idea then. I'll have to dig more into it
at some point.

> > (I suspect this confused me because XFS uses the same pinning
> > terminology, but in that context it refers to metadata items being
> > pinned by the log, until the log item is flushed and thus unpins the
> > metadata item for final writeback. So ordering is a critical factor in
> > this context.).
> 
> I see -  in XFS metadata items can't be written until the relevant log
> entry is written? Yeah we never did it that way in bcachefs, blocking
> writeback which already blocks memory reclaim sounded like a bad idea :)
> 

This is all a completely different design and architecture of course.
XFS has its own buffer cache for metadata, with aging heuristics, and
shrinker hooks and whatnot with feedback into log and metadata flushing
to manage all this and keep things moving along.

I was mainly just trying to wrap my head around the disk write ordering
rules for bcachefs journaling wrt to fs consistency, using "traditional
logging" (i.e. XFS) as a point of reference.

Brian

> Originally, before we started updating pointers to btree nodes after
> every write, we'd note in every btree node write the newest journal
> sequence number it had updates for - then in recovery we'd blacklist the
> next N journal sequence numbers and if we ever saw a btree node entry
> for a blacklisted journal sequence number we just ignored it.
> 
> > #bcache or #bachefs?
> 
> #bcache :)
> 


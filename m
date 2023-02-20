Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03736C636D6
	for <linux-bcachefs@archiver.kernel.org>; Mon, 20 Feb 2023 23:23:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229885AbjBTXXX (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Mon, 20 Feb 2023 18:23:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229560AbjBTXXW (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Mon, 20 Feb 2023 18:23:22 -0500
Received: from out-59.mta1.migadu.com (out-59.mta1.migadu.com [IPv6:2001:41d0:203:375::3b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 840AD6A52
        for <linux-bcachefs@vger.kernel.org>; Mon, 20 Feb 2023 15:23:21 -0800 (PST)
Date:   Mon, 20 Feb 2023 18:23:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1676935397;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=3zoxECl8PypD8FtQgFXjsH8SodkJnPTmGCbZ8XtonU8=;
        b=Lxf8Z/zAaup2ULID2S2gJ/uSt+NHIP/eECsU4m39As1gn5Vl9zLWE4lJpIhoonr2k1kK2J
        w+hZ3DIFHvay1Qz2SkF8MDUBUYJVoDcN68q3t0mo2Ghwv6W+2i/j7pogtvqpkGkwRvSpjn
        zWefPJZjcERbsr/pV53F1Sxu996QIRk=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Kent Overstreet <kent.overstreet@linux.dev>
To:     Dave Chinner <dchinner@redhat.com>
Cc:     Eric Wheeler <bcachefs@lists.ewheeler.net>,
        Brian Foster <bfoster@redhat.com>,
        linux-bcachefs@vger.kernel.org
Subject: Re: Freezing (was: Re: fstests generic/441 -- occasional bcachefs
 failure)
Message-ID: <Y/QA4nshHyqrrKE4@moria.home.lan>
References: <Y9f5GjOocd7Cq7V7@moria.home.lan>
 <Y9k7+6io64IpHlQh@bfoster>
 <Y9p4ihwzFs0OP6to@moria.home.lan>
 <Y9vbv7TFyu+stccD@bfoster>
 <Y9vuQHtYOhAOqPF1@moria.home.lan>
 <Y9xagNd8e1UqlHg6@rh>
 <Y92oQ82U73XQN38t@moria.home.lan>
 <Y+GVahobdcFLuZFZ@rh>
 <c7a8e8b2-33f5-341c-92ad-bf40b5634a35@ewheeler.net>
 <Y/Px+avr7z4EsMN+@rh>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y/Px+avr7z4EsMN+@rh>
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Tue, Feb 21, 2023 at 09:19:37AM +1100, Dave Chinner wrote:
> > Wait, so are you saying that XFS does not commit dirty buffers for 
> > sleeping, only on remount_ro?
> 
> Yup. But this is not unique to XFS - every journalling filesystem
> (ext3, ext4, jfs, etc) have exactly the same problem:
> sync_filesystem() only guarantees that the filesystem is consistent
> on disk, not that it is clean in memory.
> 
> And by "consistent on disk", that means all dirty metadata has been
> written -to the journal- so that if a crash occurs immeditately
> afterwards, journal recovery on the next mount will ensure that the
> filesystem is consistent.
> 
> IOWs, after sync_filesystem(), the filesystem is most definitely
> *not idle* and *not clean in memory*, and that's where all the
> issues with suspend end up coming from - it assumes sync() is all
> that is needed to put a filesystem in an idle state....
> 
> > In an ideal case I suppose the laptop ram is 
> > still hot... But sometimes (ahem, far too often) I close my laptop and 
> > forget about it, in which case the battery dies and of course then any 
> > dirty pages are lost.  IMHO sleep should always be crash-safe.
> 
> suspend is generally considered crash safe. The problems with
> suspend stem from inconsistent in-memory vs on-disk filesystem state
> in the suspend image - this causes problems on resume of the
> suspended image, not on the next cold boot of the system.

Ok, so that means we'll want to do things differently.

I don't think we _quite_ have a straightforward mechanism for quiescing
things without completely flushing the btree (which is actually driven
by journal reclaim).

There is bch2_journal_block()/bch2_journal_unblock() which blocks new
journal reservations - I think that can be our starting point.
bch2_journal_block() also waits for all in flight journal entries to be
written, so that's what we want here.

If we want all dirty metadata to be written _and visible_ in the
journal, we need to make sure the last journal entry written is a flush
entry - in general we do this by setting journal_buf->must_flush for the
entry to be written; see bch2_journal_meta() for a simple example.

We'll also need to prevent new btree node writes from being issued, and
wait for in flight ones to be finished. We don't have a mechanism for
that currently, we can probably create something like
bch2_journal_block() for that.

Other IO sources:
 - superblock writes (rare in normal operation, they happen when e.g. we
   start writing data to a new set of devices... we need that in the
   superblock so that mount knows which devices we need to mount).

 - data reads/writes

 - erasure coding writes (parity blocks when creating stripes,
   reconstruct reads).

I expect we'll have to block reads from being submitted as well? Then
we'll want to block data reads/btree node reads/ec reconstruct reads
after blocking all the sources of writes...

(this is starting to feel more like the old freezer stuff.. blech)

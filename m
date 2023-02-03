Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C73AC636D3
	for <linux-bcachefs@archiver.kernel.org>; Fri,  3 Feb 2023 00:52:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232731AbjBCAwJ (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Thu, 2 Feb 2023 19:52:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230021AbjBCAwI (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Thu, 2 Feb 2023 19:52:08 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FEFF65F18
        for <linux-bcachefs@vger.kernel.org>; Thu,  2 Feb 2023 16:51:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675385481;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=yZPdsIODodzu697GMdYaqMit8+jBmi37EZBs9jLr1Sw=;
        b=hn8MPG9wuw3GGIg7rmVOT633ue/RAFlH5ZHLgSrUO1SEdFqJXjAE4AXUrrRuB8vMpoxJWL
        jIhELXTt29hjUwWQ2iLhL/fHVCpg7/tl+iWAIDS40pfd18sg0cm+AX/ravHK/7lSvd51h0
        2HtnJzzubA7zrGpmDmjqDgPBvEInWcA=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-32-R1KkijrROJCpIZVnhje_0A-1; Thu, 02 Feb 2023 19:51:18 -0500
X-MC-Unique: R1KkijrROJCpIZVnhje_0A-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 34EBF80006E;
        Fri,  3 Feb 2023 00:51:18 +0000 (UTC)
Received: from rh (vpn2-52-17.bne.redhat.com [10.64.52.17])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C41E6112132C;
        Fri,  3 Feb 2023 00:51:17 +0000 (UTC)
Received: from localhost ([::1] helo=rh)
        by rh with esmtps  (TLS1.3) tls TLS_AES_256_GCM_SHA384
        (Exim 4.96)
        (envelope-from <dchinner@redhat.com>)
        id 1pNkIM-00FxRx-1i;
        Fri, 03 Feb 2023 11:51:14 +1100
Date:   Fri, 3 Feb 2023 11:51:12 +1100
From:   Dave Chinner <dchinner@redhat.com>
To:     Kent Overstreet <kent.overstreet@linux.dev>
Cc:     Brian Foster <bfoster@redhat.com>, linux-bcachefs@vger.kernel.org
Subject: Re: Freezing (was: Re: fstests generic/441 -- occasional bcachefs
 failure)
Message-ID: <Y9xagNd8e1UqlHg6@rh>
References: <Y9FOlMILXFcNFsSW@bfoster>
 <Y9KXaSkuMZM663Vi@moria.home.lan>
 <Y9PkndpTQcHrZ+im@bfoster>
 <Y9f5GjOocd7Cq7V7@moria.home.lan>
 <Y9k7+6io64IpHlQh@bfoster>
 <Y9p4ihwzFs0OP6to@moria.home.lan>
 <Y9vbv7TFyu+stccD@bfoster>
 <Y9vuQHtYOhAOqPF1@moria.home.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y9vuQHtYOhAOqPF1@moria.home.lan>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Thu, Feb 02, 2023 at 12:09:20PM -0500, Kent Overstreet wrote:
> On Thu, Feb 02, 2023 at 10:50:23AM -0500, Brian Foster wrote:
> > I don't have a public repo atm but I've posted the patch if you have
> > somewhere to land it for CI testing..? It survived my regression tests
> > so far, FWIW. (I also had posted that random cleanup patch a bit ago if
> > you hadn't noticed..).
> 
> Must have missed it, sorry. I can host a git repo for you on my server,
> or github works fine - I generally prefer git repo links, git am is
> always a bit of a hassle.
> 
> > Is there a reporting dashboard or something available for the test
> > infrastruture for bcachefs?
> 
> https://evilpiepirate.org/~testdashboard/ci
> 
> I've got a small server farm that watches git branches and runs the
> entire test suite on every commit starting from the recent - once you've
> got a git branch up I'll add yours to the list it watches.
> 
> You'll probably want to get acquainted with ktest, it's what both the CI
> uses for running tests, and what we use for local development:
> 
> https://evilpiepirate.org/git/ktest.git
> 
> > > Freeze definitely needs to happen. It's been _ages_ since I was looking
> > > at it so I couldn't say offhand where we'd need to start, but if you're
> > > interested I'd be happy to look at what it'd take.
> > > 
> > 
> > Yeah, that would be interesting. Thanks.
> 
> Maybe we could get Dave to give us a brief rundown of freezing? It's
> been ages since I was thinking about that and it's all fallen out of my
> brain, but Dave was the one who was able to explain it to me before :)

What do you need to know? The vast majority of the freeze
infrastructure is generic and the filesystem doesn't need to do
anything special. The only thing it needs to implement is
->freeze_fs to essentially quiesce the filesystem - by this stage
all the data has been written back and all user-driven operations
have either been stalled or drained at either the VFS or transaction
reservation points.

This requires the filesystem transaction start point to call
sb_start_intwrite() in a location the transaction start can block
safely forever, and to call sb_end_intwrite() when the transaction
is complete and being torn down. 

[Note that bcachefs might also require
sb_{start/end}_{write/pagefault} calls in paths that it has custom
handlers for and to protect against ioctl operations triggering
modifications during freezes.]

This allows freeze_super() to set a barrier to prevent new
transactions from starting, and to wait on transactions in flight to
drain. Once all transactions have drained, it will then call
->freeze_fs if it is defined so the filesystem can flush it's
journal and dirty in-memory metadata so that it becomes consistent
on disk without requiring journal recovery to be run.

This basically means that once ->fs_freeze completes, the filesystem
should be in the same state on-disk as if it were unmounted cleanly,
and the fs will not issue any more IO until the filesystem is
thawed. Thaw will call ->unfreeze_fs if defined before unblocking
tasks so that the filesystem can restart things that may be needed
for normal operation that were stopped during the freeze.

It's not all that complex anymore - a few hooks to enable
modification barriers to be placed and running the
writeback part of unmount in ->freeze_fs is the main component
of the work that needs to be done....

Cheers,

Dave.
-- 
Dave Chinner
dchinner@redhat.com


Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0AF0C64EC4
	for <linux-bcachefs@archiver.kernel.org>; Thu, 16 Feb 2023 20:12:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229462AbjBPUMC (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Thu, 16 Feb 2023 15:12:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229520AbjBPUMB (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Thu, 16 Feb 2023 15:12:01 -0500
X-Greylist: delayed 443 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 16 Feb 2023 12:12:00 PST
Received: from mx.ewheeler.net (mx.ewheeler.net [173.205.220.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B71E4BE83
        for <linux-bcachefs@vger.kernel.org>; Thu, 16 Feb 2023 12:12:00 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        by mx.ewheeler.net (Postfix) with ESMTP id DFE0447;
        Thu, 16 Feb 2023 12:04:36 -0800 (PST)
X-Virus-Scanned: amavisd-new at ewheeler.net
Received: from mx.ewheeler.net ([127.0.0.1])
        by localhost (mx.ewheeler.net [127.0.0.1]) (amavisd-new, port 10024)
        with LMTP id KjtMiPX5qbCV; Thu, 16 Feb 2023 12:04:36 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx.ewheeler.net (Postfix) with ESMTPSA id E01A940;
        Thu, 16 Feb 2023 12:04:35 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx.ewheeler.net E01A940
Date:   Thu, 16 Feb 2023 12:04:34 -0800 (PST)
From:   Eric Wheeler <bcachefs@lists.ewheeler.net>
To:     Dave Chinner <dchinner@redhat.com>
cc:     Kent Overstreet <kent.overstreet@linux.dev>,
        Brian Foster <bfoster@redhat.com>,
        linux-bcachefs@vger.kernel.org
Subject: Re: Freezing (was: Re: fstests generic/441 -- occasional bcachefs
 failure)
In-Reply-To: <Y+GVahobdcFLuZFZ@rh>
Message-ID: <c7a8e8b2-33f5-341c-92ad-bf40b5634a35@ewheeler.net>
References: <Y9FOlMILXFcNFsSW@bfoster> <Y9KXaSkuMZM663Vi@moria.home.lan> <Y9PkndpTQcHrZ+im@bfoster> <Y9f5GjOocd7Cq7V7@moria.home.lan> <Y9k7+6io64IpHlQh@bfoster> <Y9p4ihwzFs0OP6to@moria.home.lan> <Y9vbv7TFyu+stccD@bfoster> <Y9vuQHtYOhAOqPF1@moria.home.lan>
 <Y9xagNd8e1UqlHg6@rh> <Y92oQ82U73XQN38t@moria.home.lan> <Y+GVahobdcFLuZFZ@rh>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Tue, 7 Feb 2023, Dave Chinner wrote:
> On Fri, Feb 03, 2023 at 07:35:15PM -0500, Kent Overstreet wrote:
> > On Fri, Feb 03, 2023 at 11:51:12AM +1100, Dave Chinner wrote:
> > > What do you need to know? The vast majority of the freeze
> > > infrastructure is generic and the filesystem doesn't need to do
> > > anything special. The only thing it needs to implement is
> > > ->freeze_fs to essentially quiesce the filesystem - by this stage
> > > all the data has been written back and all user-driven operations
> > > have either been stalled or drained at either the VFS or transaction
> > > reservation points.
> > > 
> > > This requires the filesystem transaction start point to call
> > > sb_start_intwrite() in a location the transaction start can block
> > > safely forever, and to call sb_end_intwrite() when the transaction
> > > is complete and being torn down. 
> > > 
> > > [Note that bcachefs might also require
> > > sb_{start/end}_{write/pagefault} calls in paths that it has custom
> > > handlers for and to protect against ioctl operations triggering
> > > modifications during freezes.]
> > > 
> > > This allows freeze_super() to set a barrier to prevent new
> > > transactions from starting, and to wait on transactions in flight to
> > > drain. Once all transactions have drained, it will then call
> > > ->freeze_fs if it is defined so the filesystem can flush it's
> > > journal and dirty in-memory metadata so that it becomes consistent
> > > on disk without requiring journal recovery to be run.
> > > 
> > > This basically means that once ->fs_freeze completes, the filesystem
> > > should be in the same state on-disk as if it were unmounted cleanly,
> > > and the fs will not issue any more IO until the filesystem is
> > > thawed. Thaw will call ->unfreeze_fs if defined before unblocking
> > > tasks so that the filesystem can restart things that may be needed
> > > for normal operation that were stopped during the freeze.
> > > 
> > > It's not all that complex anymore - a few hooks to enable
> > > modification barriers to be placed and running the
> > > writeback part of unmount in ->freeze_fs is the main component
> > > of the work that needs to be done....
> > 
> > Thanks, that is a lot simpler than I was thinking - I guess I was
> > thinking about task freezing for suspend, that definitely had some
> > tricky bits.
> 
> "freezing for suspend" is a mess - it should just be calling
> freeze_super() and letting the filesystem take care of everything to
> do with freezing the filesystem. The whole idea that we can suspend
> a filesystem safely by running sync() and stopping kernel threads and
> workqueues from running is .... broken.
> 
> > Sounds like treating it as if we were remounting read-only
> > is all we need to do.
> 
> Yup, pretty much. XFS shares all the log quiescing code between
> ->freeze_fs and remount_ro. The only difference is that remount_ro
> has to do all the work to write dirty data back to disk before
> it quiesces the log....

Wait, so are you saying that XFS does not commit dirty buffers for 
sleeping, only on remount_ro? In an ideal case I suppose the laptop ram is 
still hot... But sometimes (ahem, far too often) I close my laptop and 
forget about it, in which case the battery dies and of course then any 
dirty pages are lost.  IMHO sleep should always be crash-safe.


--
Eric Wheeler



> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> dchinner@redhat.com
> 
> 

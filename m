Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ACB9FC636D6
	for <linux-bcachefs@archiver.kernel.org>; Mon, 20 Feb 2023 22:20:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232234AbjBTWUe (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Mon, 20 Feb 2023 17:20:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231993AbjBTWUe (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Mon, 20 Feb 2023 17:20:34 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D34DD1C5A3
        for <linux-bcachefs@vger.kernel.org>; Mon, 20 Feb 2023 14:19:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676931586;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/YmOkcc3Gu5rpJYgWMXrIHKeeAQPvKxW2tc+GcE/HPs=;
        b=BiELbKhYAtJKKd9rRsqsmvuxmY7RekA9j0jGzWrc9VpsWlW3/0z4Dx5F5L8KUNMZV3aZFw
        98HPNiaYc1gkSfh4T8Y5eHcSuRHn+CEjYqjVsY78k1o+o/1tHueZNaOGjoOOTkm7Qf5z0m
        BglV3plyoU8QXbtgB3w+/6DgrmN4RWM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-231-i_swqnFFO0Gb1ujwn60e-g-1; Mon, 20 Feb 2023 17:19:44 -0500
X-MC-Unique: i_swqnFFO0Gb1ujwn60e-g-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1E2A9101A52E;
        Mon, 20 Feb 2023 22:19:44 +0000 (UTC)
Received: from rh (vpn2-52-18.bne.redhat.com [10.64.52.18])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 66C331121314;
        Mon, 20 Feb 2023 22:19:43 +0000 (UTC)
Received: from localhost ([::1] helo=rh)
        by rh with esmtps  (TLS1.3) tls TLS_AES_256_GCM_SHA384
        (Exim 4.96)
        (envelope-from <dchinner@redhat.com>)
        id 1pUEVX-00Ddof-1e;
        Tue, 21 Feb 2023 09:19:39 +1100
Date:   Tue, 21 Feb 2023 09:19:37 +1100
From:   Dave Chinner <dchinner@redhat.com>
To:     Eric Wheeler <bcachefs@lists.ewheeler.net>
Cc:     Kent Overstreet <kent.overstreet@linux.dev>,
        Brian Foster <bfoster@redhat.com>,
        linux-bcachefs@vger.kernel.org
Subject: Re: Freezing (was: Re: fstests generic/441 -- occasional bcachefs
 failure)
Message-ID: <Y/Px+avr7z4EsMN+@rh>
References: <Y9PkndpTQcHrZ+im@bfoster>
 <Y9f5GjOocd7Cq7V7@moria.home.lan>
 <Y9k7+6io64IpHlQh@bfoster>
 <Y9p4ihwzFs0OP6to@moria.home.lan>
 <Y9vbv7TFyu+stccD@bfoster>
 <Y9vuQHtYOhAOqPF1@moria.home.lan>
 <Y9xagNd8e1UqlHg6@rh>
 <Y92oQ82U73XQN38t@moria.home.lan>
 <Y+GVahobdcFLuZFZ@rh>
 <c7a8e8b2-33f5-341c-92ad-bf40b5634a35@ewheeler.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c7a8e8b2-33f5-341c-92ad-bf40b5634a35@ewheeler.net>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Thu, Feb 16, 2023 at 12:04:34PM -0800, Eric Wheeler wrote:
> On Tue, 7 Feb 2023, Dave Chinner wrote:
> > On Fri, Feb 03, 2023 at 07:35:15PM -0500, Kent Overstreet wrote:
> > > On Fri, Feb 03, 2023 at 11:51:12AM +1100, Dave Chinner wrote:
> > > > What do you need to know? The vast majority of the freeze
> > > > infrastructure is generic and the filesystem doesn't need to do
> > > > anything special. The only thing it needs to implement is
> > > > ->freeze_fs to essentially quiesce the filesystem - by this stage
> > > > all the data has been written back and all user-driven operations
> > > > have either been stalled or drained at either the VFS or transaction
> > > > reservation points.
> > > > 
> > > > This requires the filesystem transaction start point to call
> > > > sb_start_intwrite() in a location the transaction start can block
> > > > safely forever, and to call sb_end_intwrite() when the transaction
> > > > is complete and being torn down. 
> > > > 
> > > > [Note that bcachefs might also require
> > > > sb_{start/end}_{write/pagefault} calls in paths that it has custom
> > > > handlers for and to protect against ioctl operations triggering
> > > > modifications during freezes.]
> > > > 
> > > > This allows freeze_super() to set a barrier to prevent new
> > > > transactions from starting, and to wait on transactions in flight to
> > > > drain. Once all transactions have drained, it will then call
> > > > ->freeze_fs if it is defined so the filesystem can flush it's
> > > > journal and dirty in-memory metadata so that it becomes consistent
> > > > on disk without requiring journal recovery to be run.
> > > > 
> > > > This basically means that once ->fs_freeze completes, the filesystem
> > > > should be in the same state on-disk as if it were unmounted cleanly,
> > > > and the fs will not issue any more IO until the filesystem is
> > > > thawed. Thaw will call ->unfreeze_fs if defined before unblocking
> > > > tasks so that the filesystem can restart things that may be needed
> > > > for normal operation that were stopped during the freeze.
> > > > 
> > > > It's not all that complex anymore - a few hooks to enable
> > > > modification barriers to be placed and running the
> > > > writeback part of unmount in ->freeze_fs is the main component
> > > > of the work that needs to be done....
> > > 
> > > Thanks, that is a lot simpler than I was thinking - I guess I was
> > > thinking about task freezing for suspend, that definitely had some
> > > tricky bits.
> > 
> > "freezing for suspend" is a mess - it should just be calling
> > freeze_super() and letting the filesystem take care of everything to
> > do with freezing the filesystem. The whole idea that we can suspend
> > a filesystem safely by running sync() and stopping kernel threads and
> > workqueues from running is .... broken.
> > 
> > > Sounds like treating it as if we were remounting read-only
> > > is all we need to do.
> > 
> > Yup, pretty much. XFS shares all the log quiescing code between
> > ->freeze_fs and remount_ro. The only difference is that remount_ro
> > has to do all the work to write dirty data back to disk before
> > it quiesces the log....
> 
> Wait, so are you saying that XFS does not commit dirty buffers for 
> sleeping, only on remount_ro?

Yup. But this is not unique to XFS - every journalling filesystem
(ext3, ext4, jfs, etc) have exactly the same problem:
sync_filesystem() only guarantees that the filesystem is consistent
on disk, not that it is clean in memory.

And by "consistent on disk", that means all dirty metadata has been
written -to the journal- so that if a crash occurs immeditately
afterwards, journal recovery on the next mount will ensure that the
filesystem is consistent.

IOWs, after sync_filesystem(), the filesystem is most definitely
*not idle* and *not clean in memory*, and that's where all the
issues with suspend end up coming from - it assumes sync() is all
that is needed to put a filesystem in an idle state....

> In an ideal case I suppose the laptop ram is 
> still hot... But sometimes (ahem, far too often) I close my laptop and 
> forget about it, in which case the battery dies and of course then any 
> dirty pages are lost.  IMHO sleep should always be crash-safe.

suspend is generally considered crash safe. The problems with
suspend stem from inconsistent in-memory vs on-disk filesystem state
in the suspend image - this causes problems on resume of the
suspended image, not on the next cold boot of the system.

-Dave.
-- 
Dave Chinner
dchinner@redhat.com


Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9059CC61DA4
	for <linux-bcachefs@archiver.kernel.org>; Tue,  7 Feb 2023 00:04:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229904AbjBGAEw (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Mon, 6 Feb 2023 19:04:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230240AbjBGAEw (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Mon, 6 Feb 2023 19:04:52 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9C5D17142
        for <linux-bcachefs@vger.kernel.org>; Mon,  6 Feb 2023 16:04:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675728244;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=m9ZVfm+YqHcyKC0EwX+4fGFFnrr2ZqKBGCyyvakWB5E=;
        b=bQH9jzimEz24Erx9AltvCrQOs0kJwcgFyCcxduWcbKw7JpgyjGFDntZhgoLgV1S+GMErML
        TvkI5WSiEeGdUzPdBhmbjsx51hKSYCpFJnWx3WvPG21DY1NEg9/2xr4Pp/NG/b/NF5ToRJ
        5cYmBk0MGC6nkLyKGcTFEvecOY7WAUo=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-625-vdVzX1hmMhaGGRHpSXJVug-1; Mon, 06 Feb 2023 19:04:01 -0500
X-MC-Unique: vdVzX1hmMhaGGRHpSXJVug-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D89C1385F360;
        Tue,  7 Feb 2023 00:04:00 +0000 (UTC)
Received: from rh (vpn2-52-17.bne.redhat.com [10.64.52.17])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id E5455492C3F;
        Tue,  7 Feb 2023 00:03:59 +0000 (UTC)
Received: from localhost ([::1] helo=rh)
        by rh with esmtps  (TLS1.3) tls TLS_AES_256_GCM_SHA384
        (Exim 4.96)
        (envelope-from <dchinner@redhat.com>)
        id 1pPBSm-007rTG-0Q;
        Tue, 07 Feb 2023 11:03:56 +1100
Date:   Tue, 7 Feb 2023 11:03:54 +1100
From:   Dave Chinner <dchinner@redhat.com>
To:     Kent Overstreet <kent.overstreet@linux.dev>
Cc:     Brian Foster <bfoster@redhat.com>, linux-bcachefs@vger.kernel.org
Subject: Re: Freezing (was: Re: fstests generic/441 -- occasional bcachefs
 failure)
Message-ID: <Y+GVahobdcFLuZFZ@rh>
References: <Y9FOlMILXFcNFsSW@bfoster>
 <Y9KXaSkuMZM663Vi@moria.home.lan>
 <Y9PkndpTQcHrZ+im@bfoster>
 <Y9f5GjOocd7Cq7V7@moria.home.lan>
 <Y9k7+6io64IpHlQh@bfoster>
 <Y9p4ihwzFs0OP6to@moria.home.lan>
 <Y9vbv7TFyu+stccD@bfoster>
 <Y9vuQHtYOhAOqPF1@moria.home.lan>
 <Y9xagNd8e1UqlHg6@rh>
 <Y92oQ82U73XQN38t@moria.home.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y92oQ82U73XQN38t@moria.home.lan>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Fri, Feb 03, 2023 at 07:35:15PM -0500, Kent Overstreet wrote:
> On Fri, Feb 03, 2023 at 11:51:12AM +1100, Dave Chinner wrote:
> > What do you need to know? The vast majority of the freeze
> > infrastructure is generic and the filesystem doesn't need to do
> > anything special. The only thing it needs to implement is
> > ->freeze_fs to essentially quiesce the filesystem - by this stage
> > all the data has been written back and all user-driven operations
> > have either been stalled or drained at either the VFS or transaction
> > reservation points.
> > 
> > This requires the filesystem transaction start point to call
> > sb_start_intwrite() in a location the transaction start can block
> > safely forever, and to call sb_end_intwrite() when the transaction
> > is complete and being torn down. 
> > 
> > [Note that bcachefs might also require
> > sb_{start/end}_{write/pagefault} calls in paths that it has custom
> > handlers for and to protect against ioctl operations triggering
> > modifications during freezes.]
> > 
> > This allows freeze_super() to set a barrier to prevent new
> > transactions from starting, and to wait on transactions in flight to
> > drain. Once all transactions have drained, it will then call
> > ->freeze_fs if it is defined so the filesystem can flush it's
> > journal and dirty in-memory metadata so that it becomes consistent
> > on disk without requiring journal recovery to be run.
> > 
> > This basically means that once ->fs_freeze completes, the filesystem
> > should be in the same state on-disk as if it were unmounted cleanly,
> > and the fs will not issue any more IO until the filesystem is
> > thawed. Thaw will call ->unfreeze_fs if defined before unblocking
> > tasks so that the filesystem can restart things that may be needed
> > for normal operation that were stopped during the freeze.
> > 
> > It's not all that complex anymore - a few hooks to enable
> > modification barriers to be placed and running the
> > writeback part of unmount in ->freeze_fs is the main component
> > of the work that needs to be done....
> 
> Thanks, that is a lot simpler than I was thinking - I guess I was
> thinking about task freezing for suspend, that definitely had some
> tricky bits.

"freezing for suspend" is a mess - it should just be calling
freeze_super() and letting the filesystem take care of everything to
do with freezing the filesystem. The whole idea that we can suspend
a filesystem safely by running sync() and stopping kernel threads and
workqueues from running is .... broken.

> Sounds like treating it as if we were remounting read-only
> is all we need to do.

Yup, pretty much. XFS shares all the log quiescing code between
->freeze_fs and remount_ro. The only difference is that remount_ro
has to do all the work to write dirty data back to disk before
it quiesces the log....

Cheers,

Dave.
-- 
Dave Chinner
dchinner@redhat.com


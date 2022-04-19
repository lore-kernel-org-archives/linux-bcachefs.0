Return-Path: <linux-bcachefs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E28C5C433F5
	for <linux-bcachefs@archiver.kernel.org>; Tue, 19 Apr 2022 20:42:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344267AbiDSUph (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Tue, 19 Apr 2022 16:45:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239506AbiDSUpg (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Tue, 19 Apr 2022 16:45:36 -0400
Received: from mx.ewheeler.net (mx.ewheeler.net [173.205.220.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C596341984
        for <linux-bcachefs@vger.kernel.org>; Tue, 19 Apr 2022 13:42:52 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by mx.ewheeler.net (Postfix) with ESMTP id 7D24441;
        Tue, 19 Apr 2022 13:42:52 -0700 (PDT)
X-Virus-Scanned: amavisd-new at ewheeler.net
Received: from mx.ewheeler.net ([127.0.0.1])
        by localhost (mx.ewheeler.net [127.0.0.1]) (amavisd-new, port 10024)
        with LMTP id 7WwUWIGA38Fn; Tue, 19 Apr 2022 13:42:51 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx.ewheeler.net (Postfix) with ESMTPSA id 9152A39;
        Tue, 19 Apr 2022 13:42:51 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx.ewheeler.net 9152A39
Date:   Tue, 19 Apr 2022 13:42:49 -0700 (PDT)
From:   Eric Wheeler <bcachefs@lists.ewheeler.net>
To:     Kent Overstreet <kent.overstreet@gmail.com>
cc:     Demi Marie Obenour <demi@invisiblethingslab.com>,
        linux-bcachefs@vger.kernel.org
Subject: Re: bcachefs loop devs
In-Reply-To: <20220419014140.5jz4hahhkfksulce@moria.home.lan>
Message-ID: <51a52bd6-b535-e5ac-12a1-2f6dc1a84353@ewheeler.net>
References: <Yk05Sk4ztxLMpgrt@itl-email> <20220415191140.2xyni3kusht6wear@moria.home.lan> <1f3290c6-535a-a15f-c02f-325099ecc4e0@ewheeler.net> <20220419014140.5jz4hahhkfksulce@moria.home.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Mon, 18 Apr 2022, Kent Overstreet wrote:
> On Mon, Apr 18, 2022 at 06:16:09PM -0700, Eric Wheeler wrote:
> > If bcachefs immediately calls .ki_complete() after queueing the IO within 
> > bcachefs but before it commits to bcachefs's disk, then loop.c will mark 
> > the IO as complete (blk_mq_complete_request via lo_rw_aio_complete) too 
> > soon after .write_iter is called, thus breaking the expected ordering in 
> > the filesystem (eg, xfs) atop of the loop device.
> 
> We don't call .ki_complete (in DIO mode) until the write has been complete,
> including the btree update - this is necessary for read-after-write consistency. 

Good, I figured it would and thought I would ask in case that was the 
issue.  
 
> If your description of the loopback code is correct that does sound suspicious
> though - queuing every IO to work item shouldn't hurt anything from a
> correctness POV but it definitely shouldn't be needed or wanted from a
> performance POV.

REQ_OP_FLUSH just calls vfs_sync (not WQ-queued) and all READ/WRITE IO's
hit the WQ.  Parallel per-socket WQ's might help performance since block
layer doesn't care about ordering and filesystems (or at least bcachefs!)
call ki_complete() after the write finishes so consistency should be ok.

Generally speaking I avoid loop devs for production systems unless
absolutely necessary.

> What are you seeing?

Nothing real-world.

I was just reviewing loop.c in preparation for leaving bcache+dm-thin
for bcachefs+loop to see if there are any DIO issues to consider.

IMHO, it would be neat to have native bcachefs block devices and avoid
the weird loop.c serial WQ (and possibly other issues loop.c has to deal
with that native bcachefs wouldn't).

This is a possible workflow for native bcachefs devices.  Since bcachefs 
is awesome - it would provide SSD caching, snapshots, encryption, and raw 
DIO block devices into VMs:

	]# bcachefs subvolume create /volumes/vol1
	]# truncate -s 1T /volumes/vol1/data.raw
	]# bcachefs blkdev register /volumes/vol1/data.raw
	/dev/bcachefs0
	]# bcachefs subvolume snapshot /volumes/vol1 /volumes/2022-04-19_vol1
	]# bcachefs blkdev register /volumes/2022-04-19_vol1/data.raw
	/dev/bcachefs1
	]# bcachefs blkdev unregister /dev/bcachefs0

And udev could be made to do something like this:
	]# ls -l /dev/bcachefs/volumes/vol1/data.raw
	lrwxrwxrwx 1 root root 7 Apr  9 17:35   data.raw -> /dev/bcachefs0

Which means the VM can have a its disk defined as 
/dev/bcachefs/volumes/vol1/data.raw in its libvirt config, and thus point 
at a real block device!

That would make bcachefs the most awesome disk volume manager, ever!



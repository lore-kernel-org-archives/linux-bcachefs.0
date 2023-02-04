Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE755C05027
	for <linux-bcachefs@archiver.kernel.org>; Sat,  4 Feb 2023 00:35:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231183AbjBDAfa (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Fri, 3 Feb 2023 19:35:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229610AbjBDAf3 (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Fri, 3 Feb 2023 19:35:29 -0500
Received: from out-50.mta1.migadu.com (out-50.mta1.migadu.com [IPv6:2001:41d0:203:375::32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 929458F276
        for <linux-bcachefs@vger.kernel.org>; Fri,  3 Feb 2023 16:35:25 -0800 (PST)
Date:   Fri, 3 Feb 2023 19:35:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1675470923;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=aScXi4AHTUr7lMf0rCFd6jcL8405CW07M4Hefa8n12A=;
        b=uTJa41GNfXxkN+DgO9Ll6wNcATQ3lVpRbysc4+fDSMVIh28OaMZw9LgIdiglPNnmG5h0x8
        etpVOkOKzlm8sOylkC10JUT3dZwwwN82NmBgz6BJszCyHVRTEXIEKqT23pgAZ4SzcWMVJC
        9vdxk/2duSwdpxTNHgT5+01AbOEwXkU=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Kent Overstreet <kent.overstreet@linux.dev>
To:     Dave Chinner <dchinner@redhat.com>
Cc:     Brian Foster <bfoster@redhat.com>, linux-bcachefs@vger.kernel.org
Subject: Re: Freezing (was: Re: fstests generic/441 -- occasional bcachefs
 failure)
Message-ID: <Y92oQ82U73XQN38t@moria.home.lan>
References: <Y9FOlMILXFcNFsSW@bfoster>
 <Y9KXaSkuMZM663Vi@moria.home.lan>
 <Y9PkndpTQcHrZ+im@bfoster>
 <Y9f5GjOocd7Cq7V7@moria.home.lan>
 <Y9k7+6io64IpHlQh@bfoster>
 <Y9p4ihwzFs0OP6to@moria.home.lan>
 <Y9vbv7TFyu+stccD@bfoster>
 <Y9vuQHtYOhAOqPF1@moria.home.lan>
 <Y9xagNd8e1UqlHg6@rh>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y9xagNd8e1UqlHg6@rh>
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Fri, Feb 03, 2023 at 11:51:12AM +1100, Dave Chinner wrote:
> What do you need to know? The vast majority of the freeze
> infrastructure is generic and the filesystem doesn't need to do
> anything special. The only thing it needs to implement is
> ->freeze_fs to essentially quiesce the filesystem - by this stage
> all the data has been written back and all user-driven operations
> have either been stalled or drained at either the VFS or transaction
> reservation points.
> 
> This requires the filesystem transaction start point to call
> sb_start_intwrite() in a location the transaction start can block
> safely forever, and to call sb_end_intwrite() when the transaction
> is complete and being torn down. 
> 
> [Note that bcachefs might also require
> sb_{start/end}_{write/pagefault} calls in paths that it has custom
> handlers for and to protect against ioctl operations triggering
> modifications during freezes.]
> 
> This allows freeze_super() to set a barrier to prevent new
> transactions from starting, and to wait on transactions in flight to
> drain. Once all transactions have drained, it will then call
> ->freeze_fs if it is defined so the filesystem can flush it's
> journal and dirty in-memory metadata so that it becomes consistent
> on disk without requiring journal recovery to be run.
> 
> This basically means that once ->fs_freeze completes, the filesystem
> should be in the same state on-disk as if it were unmounted cleanly,
> and the fs will not issue any more IO until the filesystem is
> thawed. Thaw will call ->unfreeze_fs if defined before unblocking
> tasks so that the filesystem can restart things that may be needed
> for normal operation that were stopped during the freeze.
> 
> It's not all that complex anymore - a few hooks to enable
> modification barriers to be placed and running the
> writeback part of unmount in ->freeze_fs is the main component
> of the work that needs to be done....

Thanks, that is a lot simpler than I was thinking - I guess I was
thinking about task freezing for suspend, that definitely had some
tricky bits. Sounds like treating it as if we were remounting read-only
is all we need to do.

I'll get on this when I get done with backpointers, unless someone else
is willing to work on it :)

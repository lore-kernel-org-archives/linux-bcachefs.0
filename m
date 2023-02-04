Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38730C61DA4
	for <linux-bcachefs@archiver.kernel.org>; Sat,  4 Feb 2023 22:15:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229746AbjBDWPU (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Sat, 4 Feb 2023 17:15:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229648AbjBDWPS (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Sat, 4 Feb 2023 17:15:18 -0500
Received: from out-197.mta1.migadu.com (out-197.mta1.migadu.com [IPv6:2001:41d0:203:375::c5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 264871554E
        for <linux-bcachefs@vger.kernel.org>; Sat,  4 Feb 2023 14:15:17 -0800 (PST)
Date:   Sat, 4 Feb 2023 17:15:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1675548915;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=A0VBYJfGBOA2NcVAmjdQbOEJxUv7yll6+8PpkA5MQlU=;
        b=Yh3YHzeuxzzf1pGkYsAFULemEH7Zc4JenFpDunhqc8GPDtMPq4BHKqD8kSWUCYaGUXi3Xh
        oREt3GycxiKRCvBnYlztNWs13c9fjxjEIr+Gm++cHtcRl2ghPh5p489/dw9xF6YVu/6oCc
        NT85HCBlUZ1yBrL+xkYap68bAVfWNvE=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Kent Overstreet <kent.overstreet@linux.dev>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-bcachefs@vger.kernel.org
Subject: Re: fstests generic/441 -- occasional bcachefs failure
Message-ID: <Y97Y76dSCVkF0WIE@moria.home.lan>
References: <Y9FOlMILXFcNFsSW@bfoster>
 <Y9KXaSkuMZM663Vi@moria.home.lan>
 <Y9PkndpTQcHrZ+im@bfoster>
 <Y9f5GjOocd7Cq7V7@moria.home.lan>
 <Y9k7+6io64IpHlQh@bfoster>
 <Y9w/oMzjVp90c/Pk@moria.home.lan>
 <Y97PNdqx82rot2WC@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y97PNdqx82rot2WC@bfoster>
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Sat, Feb 04, 2023 at 04:33:41PM -0500, Brian Foster wrote:
> On Thu, Feb 02, 2023 at 05:56:32PM -0500, Kent Overstreet wrote:
> > On Tue, Jan 31, 2023 at 11:04:11AM -0500, Brian Foster wrote:
> > > On Mon, Jan 30, 2023 at 12:06:34PM -0500, Kent Overstreet wrote:
> > > > On Fri, Jan 27, 2023 at 09:50:05AM -0500, Brian Foster wrote:
> > > > > Something else that occurred to me while looking further at this is we
> > > > > can also avoid the error in this case fairly easily by bailing out of
> > > > > bch2_fsync() if page writeback fails, as opposed to the unconditional
> > > > > flush -> sync meta -> flush log sequence that returns the first error
> > > > > anyways. That would prevent marking the inode with a new sequence number
> > > > > when I/Os are obviously failing. The caveat is that the test still
> > > > > fails, now with a "Read-only file system" error instead of EIO, because
> > > > > the filesystem is shutdown by the time the vfs write inode path actually
> > > > > runs.
> > > > 
> > > > If some pages did write successfully we don't want to skip the rest of
> > > > the fsync, though.
> > > > 
> > > 
> > > What does it matter if the fsync() has already failed? ISTM this is
> > > pretty standard error handling behavior across major fs', but it's not
> > > clear to me if there's some bcachefs specific quirk that warrants
> > > different handling..
> > > 
> > > FWIW, I think I've been able to fix this test with a couple small
> > > tweaks:
> > > 
> > > 1. Change bch2_fsync() to return on first error.
> > 
> > I suppose it doesn't make sense to flush the journal if
> > file_write_and_wait_range() didn't successfully do anything - but I
> > would prefer to keep the behaviour where we do flush the journal on
> > partial writeback.
> > 
> 
> That seems reasonable to me in principle...
> 
> > What if we plumbed a did_work parameter through?
> > 
> 
> ... but I'm not sure how that is supposed to work..? Tracking submits
> from the current flush wouldn't be hard, but wouldn't tell us about
> writeback that might have occurred in the background before fsync was
> called. It also doesn't give any information about what I/Os succeeded
> or failed.

Good point.

Now that I think about it, inode->bi_journal_seq won't be getting
updated unless a write actually did successfully complete - meaning
bch2_flush_inode() won't do anything unless there was a successful
transaction commit; either data was written or the inode was updated for
some other reason.

Maybe it's the sync_inode_metadata() call that's causing the journal
flush to happen?

Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3FF57C636D3
	for <linux-bcachefs@archiver.kernel.org>; Thu,  2 Feb 2023 22:57:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232750AbjBBW5Q (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Thu, 2 Feb 2023 17:57:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232102AbjBBW5P (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Thu, 2 Feb 2023 17:57:15 -0500
Received: from out-88.mta1.migadu.com (out-88.mta1.migadu.com [IPv6:2001:41d0:203:375::58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 366C16AC95
        for <linux-bcachefs@vger.kernel.org>; Thu,  2 Feb 2023 14:56:39 -0800 (PST)
Date:   Thu, 2 Feb 2023 17:56:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1675378596;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=YrZ2FOOU+6TzgFDJpHnfdx/xhhcX8QuoTpUlZKVY9hI=;
        b=Jyd43eoPDD2sjrjajW66RGdIVOANBvPSy8Z/dslGMlDmYHLh5saLkLFtB0pNb1FaptPhOi
        X+xeJt09Vfu3LZPmi5C2Xibf+/RU8/+Gb7H79O2DKTbXWpK4eD9TdciCIWa/XjR39BU8pz
        fkBbqlu/eJo5pKcIv55Onn+KcunTYcc=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Kent Overstreet <kent.overstreet@linux.dev>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-bcachefs@vger.kernel.org
Subject: Re: fstests generic/441 -- occasional bcachefs failure
Message-ID: <Y9w/oMzjVp90c/Pk@moria.home.lan>
References: <Y9FOlMILXFcNFsSW@bfoster>
 <Y9KXaSkuMZM663Vi@moria.home.lan>
 <Y9PkndpTQcHrZ+im@bfoster>
 <Y9f5GjOocd7Cq7V7@moria.home.lan>
 <Y9k7+6io64IpHlQh@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y9k7+6io64IpHlQh@bfoster>
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Tue, Jan 31, 2023 at 11:04:11AM -0500, Brian Foster wrote:
> On Mon, Jan 30, 2023 at 12:06:34PM -0500, Kent Overstreet wrote:
> > On Fri, Jan 27, 2023 at 09:50:05AM -0500, Brian Foster wrote:
> > > Something else that occurred to me while looking further at this is we
> > > can also avoid the error in this case fairly easily by bailing out of
> > > bch2_fsync() if page writeback fails, as opposed to the unconditional
> > > flush -> sync meta -> flush log sequence that returns the first error
> > > anyways. That would prevent marking the inode with a new sequence number
> > > when I/Os are obviously failing. The caveat is that the test still
> > > fails, now with a "Read-only file system" error instead of EIO, because
> > > the filesystem is shutdown by the time the vfs write inode path actually
> > > runs.
> > 
> > If some pages did write successfully we don't want to skip the rest of
> > the fsync, though.
> > 
> 
> What does it matter if the fsync() has already failed? ISTM this is
> pretty standard error handling behavior across major fs', but it's not
> clear to me if there's some bcachefs specific quirk that warrants
> different handling..
> 
> FWIW, I think I've been able to fix this test with a couple small
> tweaks:
> 
> 1. Change bch2_fsync() to return on first error.

I suppose it doesn't make sense to flush the journal if
file_write_and_wait_range() didn't successfully do anything - but I
would prefer to keep the behaviour where we do flush the journal on
partial writeback.

What if we plumbed a did_work parameter through?

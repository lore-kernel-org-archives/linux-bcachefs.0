Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 641DAC636D6
	for <linux-bcachefs@archiver.kernel.org>; Thu,  9 Feb 2023 14:58:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230172AbjBIO6r (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Thu, 9 Feb 2023 09:58:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229589AbjBIO6q (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Thu, 9 Feb 2023 09:58:46 -0500
Received: from out-126.mta1.migadu.com (out-126.mta1.migadu.com [IPv6:2001:41d0:203:375::7e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20CC218148
        for <linux-bcachefs@vger.kernel.org>; Thu,  9 Feb 2023 06:58:45 -0800 (PST)
Date:   Thu, 9 Feb 2023 09:58:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1675954721;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/TvIqZ1zwmYDmLtIP+TcNNqF6ARj+awXSPhEe3gKH+s=;
        b=s6GcEvPiXVytiqLA20oXpGMBpRaAnbOf9okBAXQ3rJ/hskIcqzhbER0OaBuZXxa2tnvtSI
        EodacDQ4tJHyCx5tj+rqPvD9SLn8YfNbbdtKh7sqz167f1FvWfQQ9WZrCgX3ZraR9Pre2g
        4niFj/o0InzwnBlnXeE83XZQu3nM2js=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Kent Overstreet <kent.overstreet@linux.dev>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-bcachefs@vger.kernel.org
Subject: Re: fstests generic/441 -- occasional bcachefs failure
Message-ID: <Y+UKGgcgAuepi6XK@moria.home.lan>
References: <Y9KXaSkuMZM663Vi@moria.home.lan>
 <Y9PkndpTQcHrZ+im@bfoster>
 <Y9f5GjOocd7Cq7V7@moria.home.lan>
 <Y9k7+6io64IpHlQh@bfoster>
 <Y9w/oMzjVp90c/Pk@moria.home.lan>
 <Y97PNdqx82rot2WC@bfoster>
 <Y97Y76dSCVkF0WIE@moria.home.lan>
 <Y+EduoshRHXec+XU@bfoster>
 <Y+F8u7AJ2K4vwpDq@moria.home.lan>
 <Y+Ttu34uCf4tn3jM@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y+Ttu34uCf4tn3jM@bfoster>
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Thu, Feb 09, 2023 at 07:57:31AM -0500, Brian Foster wrote:
> If you have any other open bugs that you think might be useful to look
> into, feel free to send them along..

https://evilpiepirate.org/~testdashboard/c/f99e51d956a74e1cd78f88648b27b0dac7c13a02/xfstests.generic.388/log.br

This might be a good one to start with: a file got truncated but still
has extents in it. I'd start by running it in a loop locally in ktest,
and seeing how easily it reproduces and what else turns up.

It's starting to look like there might be a btree ordering issue -
there's been a number of unusual bug reports of filesystem
inconsistencies that generally are repaired fine by fsck - but aren't
showing up in our tests either, this is the closest to those bugs that
I've come across in the tests.

truncate calls bch2_fpunch() which deletes extents using
bch2_extent_update(); it failing to delete some extents shouldn't be
possible and if i_sie/i_sectors somehow got out of sync I'd expect it to
be in the other direction; still, there might be some asserts we can
add.

'bcachefs list_journal -a' should be one of the first things you look
at, you can grep through the output to find the most recent transaction
commit(s) that updated that inode. See if anything looks funny - was
this one of the most recent updates when the test stopped, or was it
further back?

If it's a lower level btree inconsistency, that might show up by
verifying what the journal says we have against what's in the btree -
'bcachefs list' command.

If it's a btree ordering issue, there's two main possibilites:
 - after a crash, the btree has updates it shouldn't have, because
   they're newer than the newest update that made it into the journal
 - the btree failed to persist some updates that the journal didn't
   think it needed to replay anymore

Keys have a version number field: we can use it for distinguishing
between these two possibilities. In the transaction commit path, you'll
see code for a debug mode where we initialize it based on the sequence
number of the journal reservation we obtained. There may still be some
other related code for that debug mode; the idea is to check for keys
newer than the newest journal sequence number we replayed after a crash.

We should also check for keys with blacklisted journal sequence numbers.

I think one of those approaches will turn up something :)

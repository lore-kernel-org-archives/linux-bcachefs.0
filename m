Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3B95C05027
	for <linux-bcachefs@archiver.kernel.org>; Mon,  6 Feb 2023 22:18:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229884AbjBFWS5 (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Mon, 6 Feb 2023 17:18:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229718AbjBFWS4 (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Mon, 6 Feb 2023 17:18:56 -0500
Received: from out-48.mta0.migadu.com (out-48.mta0.migadu.com [IPv6:2001:41d0:1004:224b::30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C975525E05
        for <linux-bcachefs@vger.kernel.org>; Mon,  6 Feb 2023 14:18:52 -0800 (PST)
Date:   Mon, 6 Feb 2023 17:18:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1675721924;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=NZGX6sJtWdfn5SqIDEHPwUwcnXQjvYdURmLm0m2Tz+Y=;
        b=ET9Fci1Yt615R5uWrpc7pdYKj261HJr8CrqhWxZGLCtYYXAWDdxCnRFiho99cn2kZm9Tud
        RYaOkRCCvdm5Jq48qHsz2cL46T5cv40InoHqzkYCFVDNZCYv2xQqVZCuFgbQztF+5Cyth0
        ZRWeZ770UzMYNBN3dizSmoFmA2SkfuA=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Kent Overstreet <kent.overstreet@linux.dev>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-bcachefs@vger.kernel.org
Subject: Re: fstests generic/441 -- occasional bcachefs failure
Message-ID: <Y+F8u7AJ2K4vwpDq@moria.home.lan>
References: <Y9FOlMILXFcNFsSW@bfoster>
 <Y9KXaSkuMZM663Vi@moria.home.lan>
 <Y9PkndpTQcHrZ+im@bfoster>
 <Y9f5GjOocd7Cq7V7@moria.home.lan>
 <Y9k7+6io64IpHlQh@bfoster>
 <Y9w/oMzjVp90c/Pk@moria.home.lan>
 <Y97PNdqx82rot2WC@bfoster>
 <Y97Y76dSCVkF0WIE@moria.home.lan>
 <Y+EduoshRHXec+XU@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y+EduoshRHXec+XU@bfoster>
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Mon, Feb 06, 2023 at 10:33:14AM -0500, Brian Foster wrote:
> So yes, it seems the sync_inode_metadata() path is what bumps the
> journal seq and the explicit journal flush is what shuts down the fs,
> but I assume sync_inode_metadata() attempts the inode flush simply
> because the buffered write that precedes it works perfectly fine. This
> is what had me thinking that bch2_fsync() is being more aggressive than
> it really needs to be here. With the proposed logic tweak, the second
> issue is resolved because bcachefs no longer attempts the inode flush
> when page writeback has failed. So what happens in the test is that it
> switches back over to the functional dm table, the vfs inode flush
> occurs then and succeeds, and so the test sees no (unexpected) errors
> and the fs has survived without shutting down.

So, sync_inode_metadata() is just writing out timestamp updates.

But, there's no reason we couldn't be doing that as part of the write
path, if it was plumbed through - the write path has to do an inode
update anyways. Although that would involve an unpack/repack of the
inode, so maybe we don't want to do that - we'd want to change the inode
format to not encode timestamps as varints, and I'm not sure that's
worth the hassle and the increased inode size.

I was eyeing changing the way timestamp updates work to make them more
direct, it would get rid of the need to call sync_inode_metadata() and
regularize timestamp updates with the way inode updates work for
everything else - ISTR that's how it works in XFS as well. But it'd make
atime updates more expensive, and that's not something I've looked into
yet.

> All in all I think this test basically builds on some minor assumptions
> about how fsync error behavior is implemented in Linux, and bcachefs
> happens to slightly diverge in a way that leads to this shutdown. IOW,
> I'd expect the same problematic behavior out of XFS if it implemented
> this sort of fsync logic, but afaict no other fs does that, so the test
> is functional in practice. I admit that's not the best pure engineering
> justification for the change in bcachefs (so I understand any
> hesitation), but IMO it's reasonable in practice and worthwhile enough
> to improve test coverage. I haven't audited fstests for this or
> anything, but it wouldn't surprise me much if there are other tests that
> rely on this sort of "assumed behavior" for testing I/O failures.
> Thoughts?

Yeah, maybe we should hold off on making any decisions until we see
where else this comes up, I hoped this test was going to be easier to
fix but it doesn't seem like there's any clean obvious solutions. Ah
well :)

LSF is coming up and as I recall that's where the errseq stuff was
originally discussed - I'd like to hear from the people behind those
changes if they thing leaving our journal flush out of the errseq path
is reasonable (it seems so to me, but it's worth bringing up). I can
pencil it in to the bcachefs talk... need to start working on that...

We can just leave it failing in the CI for now - maybe make some notes
as to what our options are when we decide to come back to it, there's
definitely more straightforward and more impactful bugs to work on in
the meantime.

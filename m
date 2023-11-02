Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD451C4332F
	for <linux-bcachefs@archiver.kernel.org>; Thu,  2 Nov 2023 02:13:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235179AbjKBCNC (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Wed, 1 Nov 2023 22:13:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235167AbjKBCNC (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Wed, 1 Nov 2023 22:13:02 -0400
Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [IPv6:2001:41d0:1004:224b::b3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7546DBD
        for <linux-bcachefs@vger.kernel.org>; Wed,  1 Nov 2023 19:12:56 -0700 (PDT)
Date:   Wed, 1 Nov 2023 22:12:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1698891174;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=cFYhu5WKyQuSekHLdq6tni3Z2HdXRvV0NXT8GC6BK18=;
        b=w0doFKrHqpB8nr3gGM5LaIdy3bj1sapxovwnx14dwcLZTR4SDeBKo8gZkPDeE73faEQVF3
        jjGEDDkRSAW9iUqaDhy2Si1W5LXtugGmDwxvCegCK7P2nqwY+SCZjN3ENYhL+6+/1i3Mks
        jtoe6piY2wFP4HjRCEIYMBOG9/EEoXU=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Kent Overstreet <kent.overstreet@linux.dev>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH 0/2] bcachefs: early bucket allocator fixes
Message-ID: <20231102021249.2ptqo7cinoah3zdo@moria.home.lan>
References: <20231101190245.478567-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231101190245.478567-1-bfoster@redhat.com>
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Wed, Nov 01, 2023 at 03:02:43PM -0400, Brian Foster wrote:
> Hi all,
> 
> Here's a couple isolated fixes to the early bucket allocator. Both of
> these address issues that were uncovered due to an unrelated bug that
> temporarily caused the early bucket allocator to run indefinitely. Patch
> 1 addresses a race where multiple tasks can attempt to allocate the same
> bucket due to lack of exclusion when the target bucket is not resident
> in the key cache. Patch 2 fixes up an issue where the allocation cursor
> is never properly updated, which made early bucket allocator performance
> far worse than it should have been.
> 
> These have been tested in an ad hoc fashion on a kernel hacked up to use
> the early bucket allocator as well as on CI via my test branch [1].
> Thoughts, reviews, flames appreciated.

Both of these look good - thanks, applied

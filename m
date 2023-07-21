Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87737EB64DD
	for <linux-bcachefs@archiver.kernel.org>; Fri, 21 Jul 2023 20:49:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230246AbjGUUta (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Fri, 21 Jul 2023 16:49:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229529AbjGUUta (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Fri, 21 Jul 2023 16:49:30 -0400
Received: from out-57.mta1.migadu.com (out-57.mta1.migadu.com [95.215.58.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D54152D7B
        for <linux-bcachefs@vger.kernel.org>; Fri, 21 Jul 2023 13:49:28 -0700 (PDT)
Date:   Fri, 21 Jul 2023 16:49:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1689972566;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=hKN/MMx/doLKQDvJqacGwQdgKCB8HQK9Yk1cR35syFU=;
        b=ZQn0+80hHNuCIToQk1OsyGCmbn+LsJdamT9YSpIgqrVTpKBYO+C5zq1Cbyf9UOY8XH4rXQ
        KpTaBLHyEtH+Jt+mU5kGcDW1Q2oL6BjljQFIagRzu13MV2ERqaLxxx4Lz/oOvYC89NSu9V
        +Rgcba99v79kONedfOGq/3qZ6oNC5yg=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Kent Overstreet <kent.overstreet@linux.dev>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-bcachefs@vger.kernel.org
Subject: Re: [BUG] bcachefs fallocate btree lock contention
Message-ID: <20230721204923.vzgjvrtnqhk4cwqw@moria.home.lan>
References: <ZLqIB3k600oAS3G1@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZLqIB3k600oAS3G1@bfoster>
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Fri, Jul 21, 2023 at 09:28:39AM -0400, Brian Foster wrote:
> Hi all,
> 
> When testing the recent write buffer journaling series, I reproduced
> several fstests (i.e. generic/013) that seemed pretty much hung up in a
> livelock in fsstress. On some further digging, it appears they were
> stuck doing fallocates and were spinning heavily on transaction
> restarts. I don't think these tests are stuck indefinitely, but rather
> this manifests as some excessively long runtimes for tests that involve
> concurrent fsstress runs. I was eventually able to reproduce the same
> behavior without the write buffer patches, so it doesn't appear to be
> related.
> 
> I think the issue is basically that if multiple fallocates are running
> against independent inodes that might update the same extent btree node,
> the __bchfs_fallocate() loop can get into a tight spin due to the lock
> cycling around bch2_clamp_data_hole() contending with node updates. This
> is where I see most restarts, and I've seen upwards of 100k+ restarts
> and single fallocate latencies of tens of seconds. This is pretty
> trivial to reproduce by just running concurrent sequential fallocates to
> different files (8x or so on my test vm pretty much grinds things to a
> halt) [1].
> 
> One question that comes to mind: why do we cycle locks here? Is this a
> lock ordering requirement between folio locks and btree node locks?
> 
> To test the above, I ran with a quick hack to check for pagecache pages
> before we decide to clamp the range during fallocate. This speeds up the
> test significantly and pretty much removes the bottleneck. This only
> handles the simple case and doesn't quite feel like the proper fix to
> me, but since I'm low on time I threw it up on CI [2] for reference and
> to get a test cycle. I'm heading on vacation for the next week+, so I
> wanted to throw this up on the list so at least folks are aware of it if
> any excessive test latencies are observed.
> 
> Any thoughts are appreciated in the meantime. I'll pick it up once I'm
> back..

What about adding a nonblocking flag to bch2_clamp_data_hole() that only
uses trylock for locking folios?

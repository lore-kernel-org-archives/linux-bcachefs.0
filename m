Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80124EB64D9
	for <linux-bcachefs@archiver.kernel.org>; Fri,  7 Jul 2023 20:37:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231972AbjGGUhl (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Fri, 7 Jul 2023 16:37:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231316AbjGGUhk (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Fri, 7 Jul 2023 16:37:40 -0400
Received: from out-47.mta0.migadu.com (out-47.mta0.migadu.com [IPv6:2001:41d0:1004:224b::2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E16C51994
        for <linux-bcachefs@vger.kernel.org>; Fri,  7 Jul 2023 13:37:38 -0700 (PDT)
Date:   Fri, 7 Jul 2023 16:37:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1688762256;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=3inbPXbN4h8Yr4dmdoAtGYMsCYXyYnIXwJSQPw+a3oo=;
        b=T4pjPQCS9P2/IfHCUpyGridU2/I4cjEkYTY/uevBMZqvAxaawirexM98QmPSnCuzImwgw/
        SQ2+UnAZSKUpAxdTQDz9aTgQQZzFqmX9IHaIounXEEJTq2wWHoOz+cC5W7gkkWmsFfN3fo
        TXB2ASd1eVokHXuL66IMTfXeCXOdu6g=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Kent Overstreet <kent.overstreet@linux.dev>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-bcachefs@vger.kernel.org
Subject: Re: bcachefs backpointers errors in no write buf mode
Message-ID: <20230707203732.kbtz2wm3zh3pr36z@moria.home.lan>
References: <ZKhMGZBokKMq5p1P@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZKhMGZBokKMq5p1P@bfoster>
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Fri, Jul 07, 2023 at 01:32:09PM -0400, Brian Foster wrote:
> Hi Kent,
> 
> I'm doing some analysis of these "existing backpointer found when
> inserting" errors observed when running generic/388 in
> backpointers_no_use_write_buffer=1 mode. To start with context, here's
> what I see in one particular variant of the issue...
> 
> We're in read bio completion path doing a CRC narrow. The commit for
> that transaction runs trans triggers on the extent key, which then falls
> into bch2_trans_mark_extent() and attempts backpointer updates from
> there. I stuck a warning in the backpointer error checking code just to
> get a stack trace for the error context, which is appended below for
> reference.
> 
> On IRC Kent mentioned this was likely a trigger ordering issue and that
> something similar was addressed in the normal backpointer write buffer
> update path. I think I follow what's going on there from commit
> 0a1b82456400 ("bcachefs: btree write buffer update ordering"), but the
> context for the no write buf path seems a bit different..

So turns out - those patches were bogus. I was misremembering the
trigger ordering from how it was in the past; we shouldn't need to do
the weird dual different update ordering thing.

So I've backed out those patches for now (they were prep work for the
rebalance_work btree, but that's not ready yet), and with that the
merge_torture_flakey test is passing - more. It still fails if I loop
it, and interestingly it's _not_ a btree write buffer issue, it still
fails with the write buffer off.

backpointer for missing extent
  u64s 9 type backpointer 0:1966604288:0 len 0 ver 0: bucket=0:3751:0 btree=xattrs l=1 offset=0:0 len=64 pos=SPOS_MAX, exiting

We should improve the error message, it'd be useful to know if that's a
btree root or not.

Now that I have io_uring disabled in ktest/xfstests, I can start looping
generic/388 as well and see if that turns up any patterns...

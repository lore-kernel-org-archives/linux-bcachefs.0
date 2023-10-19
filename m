Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB3F0CDB465
	for <linux-bcachefs@archiver.kernel.org>; Thu, 19 Oct 2023 15:52:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233214AbjJSPwV (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Thu, 19 Oct 2023 11:52:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233176AbjJSPwU (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Thu, 19 Oct 2023 11:52:20 -0400
Received: from out-207.mta0.migadu.com (out-207.mta0.migadu.com [IPv6:2001:41d0:1004:224b::cf])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BB0D93
        for <linux-bcachefs@vger.kernel.org>; Thu, 19 Oct 2023 08:52:18 -0700 (PDT)
Date:   Thu, 19 Oct 2023 11:52:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1697730734;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=TQ2glw2E7OqJ6Q5LkUNaW719St9vmq0TU22+hkH1+Rg=;
        b=bvAQrQZOZymVcS6yyA1JTlIbRZgqtPo2sqso97DPVeaK+JZllhRigFsZPTDdGOczItI/bO
        g6VCEcay8Xz6JNDObIs5UJTxCDnJjjHXKsje9180I7nCu+krdu5yT1h+l5s3zyjIq1HLU2
        t8nScM3Nel5nKXpZQ7I2WFFqQmBSRAI=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Kent Overstreet <kent.overstreet@linux.dev>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-bcachefs@vger.kernel.org
Subject: Re: [BUG] bcachefs (early?) bucket allocator raciness
Message-ID: <20231019155211.ir433bgkuyuh6cqc@moria.home.lan>
References: <ZTExFP9G1fUIUgVZ@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZTExFP9G1fUIUgVZ@bfoster>
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Thu, Oct 19, 2023 at 09:37:24AM -0400, Brian Foster wrote:
> Hi Kent, All,
> 
> I recently observed a data corruption problem that is related to the
> recently discovered issue of mounted fs' running with the early bucket
> allocator instead of the freelist allocator. The immediate failure is
> generic/113 producing various splats, the most common of which is a
> duplicate backpointer issue. generic/113 is primarily an aio/dio stress
> test.
> 
> I eventually tracked this down to an actual duplicate bucket allocation
> in the early bucket allocator code. The race generally looks as follows:
> 
> - Task 1 lands in bch2_bucket_alloc_early(), selects key A from the
>   alloc btree, and then schedules (perhaps due to freelist_lock).
> 
> - Task 2 runs through the same alloc path and selects the same key K,
>   but proceeds to open the associated bucket, alloc/write to it,
>   complete the I/O and release the bucket (removing it from the hash).
> 
> - Task 1 continues with alloc key K. bch2_bucket_is_open() returns false
>   because the previously opened bucket has been removed from the hash
>   list. Therefore task 1 opens a new bucket for what is now no longer free
>   space and uses it for the its associated write operation.

This shouldn't be possible because task 1 is holding the alloc key
locked, and task 2 has to update that same alloc key before releasing
the open bucket.

Except perhaps not - perhaps this is a key cache coherency issue?

We're not using a BTREE_ITER_CACHED iterator, because we're scanning and
we can't scan with key cache iterators. It's still supposed to be
coherent with the key cache; bch2_btree_iter_peek_slot() ->
btree_trans_peek_key_cache() checks if a key exists in the key cache and
returns that key instead of the key in the btree if it exists.

But it doesn't return with that slot locked in the key cache locked if
the key didn't exist in the key cache. Oops.

So we're going to need to keep an eye out for this issue occuring
elsewhere, and maybe come up with a real fix in the btree iterator code:
looking up a key in a cached btree without BTREE_ITER_CACHED _does_
return the correct key at that particular point in time, but it does
_not_ necessarily keep it locked for the duration of the transaction.

For now, we can fix this locally in bch2_bucket_alloc_early() with a
second BTREE_ITER_CACHED iterator - run some tests with freespace
initialization disabled, confirm that that's the issue, then go from
there.

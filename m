Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B2B9C71153
	for <linux-bcachefs@archiver.kernel.org>; Sun,  3 Sep 2023 21:18:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348355AbjICVST (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Sun, 3 Sep 2023 17:18:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229523AbjICVST (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Sun, 3 Sep 2023 17:18:19 -0400
Received: from out-223.mta0.migadu.com (out-223.mta0.migadu.com [IPv6:2001:41d0:1004:224b::df])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16CC2E5
        for <linux-bcachefs@vger.kernel.org>; Sun,  3 Sep 2023 14:18:16 -0700 (PDT)
Date:   Sun, 3 Sep 2023 17:18:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1693775894;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=9rkbB0QgDNQTKOz9lLTpVyWf9y8/viHsGgQjpWt3NzM=;
        b=iZc2a4c3JcTvDfLke1TX9ZZUyvmQ/bZ0xclrRpsRlQT0Htu/ftqzRomqGK5xfk2wFGdR+t
        wMLycKtf4iZPz92cupyFkidROX1a1qKgclhWnTPMuU1ij1D2UVRnnfngF/O+iZPTUI79mN
        Q7iP1SiF2Sv9rPm79FymsMrdNRuI72M=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Kent Overstreet <kent.overstreet@linux.dev>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH 3/3] bcachefs: fix race between journal entry close and
 pin set
Message-ID: <20230903211812.kh7paaa5z25lwbd4@moria.home.lan>
References: <20230831110734.787212-1-bfoster@redhat.com>
 <20230831110734.787212-4-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230831110734.787212-4-bfoster@redhat.com>
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Thu, Aug 31, 2023 at 07:07:34AM -0400, Brian Foster wrote:
> bcachefs freeze testing via fstests generic/390 occasionally
> reproduces the following BUG from bch2_fs_read_only():
> 
>   BUG_ON(atomic_long_read(&c->btree_key_cache.nr_dirty));
> 
> This indicates that one or more dirty key cache keys still exist
> after the attempt to flush and quiesce the fs. The sequence that
> leads to this problem actually occurs on unfreeze (ro->rw), and
> looks something like the following:
> 
> - Task A begins a transaction commit and acquires journal_res for
>   the current seq. This transaction intends to perform key cache
>   insertion.
> - Task B begins a bch2_journal_flush() via bch2_sync_fs(). This ends
>   up in journal_entry_want_write(), which closes the current journal
>   entry and drops the reference to the pin list created on entry open.
>   The pin put pops the front of the journal via fast reclaim since the
>   reference count has dropped to 0.
> - Task A attempts to set the journal pin for the associated cached
>   key, but bch2_journal_pin_set() skips the pin insert because the
>   seq of the transaction reservation is behind the front of the pin
>   list fifo.
> 
> The end result is that the pin associated with the cached key is not
> added, which prevents a subsequent reclaim from processing the key
> and thus leaves it dangling at freeze time. The fundamental cause of
> this problem is that the front of the journal is allowed to pop
> before a transaction with outstanding reservation on the associated
> journal seq is able to add a pin. The count for the pin list
> associated with the seq drops to zero and is prematurely reclaimed
> as a result.
> 
> The logical fix for this problem lies in how the journal buffer is
> managed in similar scenarios where the entry might have been closed
> before a transaction with outstanding reservations happens to be
> committed.
> 
> When a journal entry is opened, the current sequence number is
> bumped, the associated pin list is initialized with a reference
> count of 1, and the journal buffer reference count is bumped (via
> journal_state_inc()). When a journal reservation is acquired, the
> reservation also acquires a reference on the associated buffer. If
> the journal entry is closed in the meantime, it drops both the pin
> and buffer references held by the open entry, but the buffer still
> has references held by outstanding reservation. After the associated
> transaction commits, the reservation release drops the associated
> buffer references and the buffer is written out once the reference
> count has dropped to zero.
> 
> The fundamental problem here is that the lifecycle of the pin list
> reference held by an open journal entry is too short to cover
> the processing of transactions with outstanding reservations. The
> simplest way to address this is to expand the pin list reference
> to the lifecycle of the buffer vs. the shorter lifecycle of the
> open journal entry. This allows a journal entry to closer for
> whatever reason, but ensures the pin list for the seq with
> outstanding reservation cannot be popped and reclaimed before all
> outstanding reservations have been released.
> 
> Move the pin put from journal entry close to where final reference
> count processing of the journal buffer occurs. Create a duplicate
> helper to cover the case where the caller doesn't already hold the
> journal lock. This allows generic/390 to pass reliably.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>

Good find :)

Your fix makes sense, but I wonder if it might be simpler and better to
fix this in bch2_journal_reclaim_fast().

We could just change it to check if the pin list is for a journal buf
that's still open and has a nonzero refcount.

It seems on the surface to be a bug where just fixing the lifetime
refcounts is the right approach, but I think that ends up being the
trickier approach here, since bch2_journal_buf_put() now has a couple
things it's checking at different stages of the journal buf lifetime.

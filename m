Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6C8CC678D4
	for <linux-bcachefs@archiver.kernel.org>; Tue,  7 Mar 2023 10:33:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229988AbjCGKd1 (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Tue, 7 Mar 2023 05:33:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230273AbjCGKcx (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Tue, 7 Mar 2023 05:32:53 -0500
X-Greylist: delayed 9154 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 07 Mar 2023 02:32:12 PST
Received: from out-36.mta1.migadu.com (out-36.mta1.migadu.com [95.215.58.36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6702627D63
        for <linux-bcachefs@vger.kernel.org>; Tue,  7 Mar 2023 02:32:11 -0800 (PST)
Date:   Tue, 7 Mar 2023 05:32:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1678185129;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=y1zwAiSF5d03wcTbMnD0V1o/sG1CF97ktOltoAbCaXg=;
        b=TW05Cf3Q6dMx5+tG0wTzXtmPNZtZXeZ8Ylg6DPZOg2JrHVd6W0Wtnu0TtxA7PKKvv9De8x
        qSzghlBlQWsZyi5z8cqhbgUGdR1GueSiTv3DRQAUonT+fqRfTwJxN6QnQXps/QOvhSNfbR
        w478yX3VGPr/LGE4x4E4NxORU3OVggc=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Kent Overstreet <kent.overstreet@linux.dev>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH RFC] bcachefs: don't bump key cache journal seq on
 nojournal commits
Message-ID: <ZAcSpXjwUeAchhMn@moria.home.lan>
References: <20230302195110.217282-1-bfoster@redhat.com>
 <ZAKwp52iF2v8Okqz@moria.home.lan>
 <ZAXoP29b/QVq3Onn@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZAXoP29b/QVq3Onn@bfoster>
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Mon, Mar 06, 2023 at 08:18:55AM -0500, Brian Foster wrote:
> I ran with the following logic over the weekend and it seemed to avoid
> any problems:
> 
>         if (!(insert_entry->flags & BTREE_UPDATE_NOJOURNAL) ||
>             !journal_pin_active(&ck->journal)) {
>                 ck->seq = trans->journal_res.seq;
>         }
>         bch2_journal_pin_add(&c->journal, trans->journal_res.seq,
>                              &ck->journal, bch2_btree_key_cache_journal_flush);
> 
> This addresses the scenario above by updating ck->seq when the key cache
> pin happens to be inactive, which is presumably (?) safe because that
> means the cache doesn't hold any previous updates. FWIW, I suspect there
> are probably multiple ways to fix this, such as allowing pin_add() to
> return whether it actually added a pin, or perhaps resetting ck->seq
> somewhere on key cache flush so the callback doesn't think it's valid,
> etc. Thoughts?

It took me a bit to work out why this is the correct fix, so it'll
definitely need some documenting (and the blame is on me;
BTREE_UPDATE_NOJOURNAL was clearly more subtle than I recognized at the
time) - but yeah, looks good.

To recap what we discussed on IRC, for anyone else who's reading:
naively one might assume that in BTREE_UPDATE_NOJOURNAL mode we
shouldn't do anything here and skip adding the journal pin, except that
NOJOURNAL updates _do_ need to be written back to the btree and it's
journal reclaim that is also responsible for that.

The reason for BTREE_UPDATE_NOJOURNAL is that sometimes we're doing
inode updates that are only updating bi_journal_seq, nothing else: these
updates are only needed so that fsync() later knows which journal
sequence number has to be flushed.

We have to record this in the btree, because if it was stored in the VFS
inode that's just a cache and reclaim would break fsync - but we're not
going to need it after a crash, hence no need to journal it.

So BTREE_UPDATE_NOJOURNAL updates are really this super rare, special
purpose performance hack that knowingly break our sequential consistency
model and should be regarded with suspicion :)

> I have a bigger picture question, however. The key cache is intended to
> hold updates to multiple different keys that land in the same btree
> node, right? If so, is it safe to update the key cache pin on later
> updates like this in general? Specifically I was thinking about the
> example of two inodes that happen to land in the same key cache (inode
> A, A+1) but under different journal seqs.

Yes.

Originally, on every key cache update we'd call
bch2_journal_pin_update() - dropping our old journal pin and pinning the
journal entry of the new update.

See the patch "bcachefs: Btree key cache optimization" where we switched
to the new behaviour - it's an optimization to avoid hitting the journal
lock.

> For example, suppose inode A commits, logs, adds the ck pin, and sets
> ck->seq (A). Then inode A+1 commits, logs to seq+1, and updates ck->seq
> again. At this point if journal reclaim flushes the cache with the
> original pin, we update the pin to the A+1 ck->seq value and return.  If
> this moves the pin from the front of the journal, what prevents last_seq
> from being updated to A+1 on disk and introducing the same sort of
> window where in-core updates aren't covered by the active range of the
> journal? I.e., if last_seq updates and the filesystem crashes, ISTM we
> potentially lose the inode A key update, even if it was journaled.

That's completely fine, provided inode A1 was journalled and is still
pinned in the journal - in your example, since the pin is updated to the
sequence number for A1 it will be.

That is, the journal is very much allowed to drop redundant updates. The
journal exists to guarantee time ordering, but that guarantee only
applies after we've finished replaying everything that was in the
journal.

If we're only partway through journal replay (say, after inode A but
before A1), then the btree is going to be complete nonsense in terms of
consistency - not just because stuff may have been dropped from the
journal, but because things in the journal maybe be flushed in any
order, so if we're only halfway through journal replay we fully expect
to find updates in the btree that are newer than where we're at in the
journal.

This is touching on the topic of how we guarantee sequential consistency
after crashes - which is an interesting and lengthy topic, but
fortunately we don't need to understand it for the problem at hand. The
only relevant thing for now is that yes, the journal can drop redundant
updates and it's completely fine.

Return-Path: <linux-bcachefs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57894C433EF
	for <linux-bcachefs@archiver.kernel.org>; Sun, 24 Oct 2021 16:39:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2911260E98
	for <linux-bcachefs@archiver.kernel.org>; Sun, 24 Oct 2021 16:39:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229830AbhJXQlg (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Sun, 24 Oct 2021 12:41:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229527AbhJXQlf (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Sun, 24 Oct 2021 12:41:35 -0400
Received: from mail-qv1-xf29.google.com (mail-qv1-xf29.google.com [IPv6:2607:f8b0:4864:20::f29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18647C061745
        for <linux-bcachefs@vger.kernel.org>; Sun, 24 Oct 2021 09:39:15 -0700 (PDT)
Received: by mail-qv1-xf29.google.com with SMTP id o20so5733878qvk.7
        for <linux-bcachefs@vger.kernel.org>; Sun, 24 Oct 2021 09:39:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=qnRP8gqb63dXIbmRvEvE1eJeyCo8oiBwoD3GsRxOerw=;
        b=mQdbMAV5IUBxqVA/uIshCGkKTiLhbee9MvCQz+EVy4/Z2rzqL8yHbYYYOPUeXVQ5/a
         hQL+u3FHUjv3ROf6GUasudqVLgjyWBKiurMiqCzLVGw8hVdDC7ohAzEX/9Si3kb80juq
         iB9RxbXBMwWO8nagk9MXzeMg2xz4SuY/Qm84Bt/sOt0I+IUJwHA+5QG9L1ed/wRcxnxi
         C+kSO1EKvzd8Bvs94eftv0E1j8BKfHJOwxZKEMN6GD00PYLrJLjNJCyq7246z9u/d6eE
         u/8VPZatMN+aUTlC0bQ3w0Fs/bHPIUWEK+5wY9kLg+TSHAyVSMWDwwdudOxQvW/cxc5A
         U8xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=qnRP8gqb63dXIbmRvEvE1eJeyCo8oiBwoD3GsRxOerw=;
        b=Z4l05XseONSusTvcLjg+nOgxrFjh4VlVDMoiZ/zTox/lJMhtCJyoUGiYGJjPm/smvD
         n4P2pFFEOxY5mMwSa8hLa1mx6JTgSToSZIftSFYKRE4Ny0W52Z0VY9ah6Fo70pAovVRi
         7QwA0fLgj/KTufD4Ot3wxdy2B/ZFGpZpfoId+zkhE5vQY3wV9G7Hcodt60lIhanrg4l7
         9bHHejwtGTSiZmrqRDG4rLTE50295vNHGZmJ3GCIUIp2gSA8nCk33vcSej4gmzgP9LUm
         GyT2zcUgqwa5bvUW5IUkA96Yw9abGKq7DkArTItgS410m0qR8AXOV/m5Kf/GOgzpREeB
         3Zgg==
X-Gm-Message-State: AOAM5320pKZQhIu9Rw20o/uEZPuusWn13j67wnoRoeAIp8PKumWVvdbm
        yuRBfuKfp9kCHd3GD8WIgyUf8J3pCQ==
X-Google-Smtp-Source: ABdhPJxCjBVJbmDL4XmPBVIyLq/YTBSXfyyDeYVUyUDZk7NUhFrrOcUjZeH9ZbmChg/hmj60qe4SDw==
X-Received: by 2002:ad4:5748:: with SMTP id q8mr11006691qvx.52.1635093554206;
        Sun, 24 Oct 2021 09:39:14 -0700 (PDT)
Received: from moria.home.lan (c-73-219-103-14.hsd1.vt.comcast.net. [73.219.103.14])
        by smtp.gmail.com with ESMTPSA id bj37sm7523790qkb.49.2021.10.24.09.39.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 24 Oct 2021 09:39:13 -0700 (PDT)
Date:   Sun, 24 Oct 2021 12:39:11 -0400
From:   Kent Overstreet <kent.overstreet@gmail.com>
To:     Chris Webb <chris@arachsys.com>
Cc:     linux-bcachefs@vger.kernel.org
Subject: Re: Metadata usage following device add
Message-ID: <YXWML9QLQKCsRgdh@moria.home.lan>
References: <20211024111547.GG11670@arachsys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211024111547.GG11670@arachsys.com>
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Sun, Oct 24, 2021 at 12:15:47PM +0100, Chris Webb wrote:
> Kent Overstreet <kent.overstreet@gmail.com> wrote:
> 
> > On Wed, Oct 13, 2021 at 05:52:40PM +0100, Chris Webb wrote:
> > > looks like sb and journal are still zero on the newly added device even
> > > following the data rereplicate operation.
> >
> > That's a separate (known) bug - adding a new device doesn't account for
> > sb/journal on the new device correctly. I should revisit that one...
> 
> Hi Kent. Sorry for this slow follow-up, but I took a look at what's going on
> to see if it was easy to fix. After a bit of printk() abuse, I think I
> understand why this happens:
> 
> bch2_dev_add calls __bch2_mark_metadata_bucket via bch2_mark_dev_superblock
> before the device is attached to the fs, so it can't yet use
> bch2_dev_usage_update.
> 
> Later, after the device is attached, we call bch2_trans_mark_dev_sb which
> diligently goes through re-marking buckets and updating the usage. However,
> the old and new bucket types and dirty_sectors values match, so
> bch2_dev_usage_update ends up repeatedly subtracting and then re-adding the
> sizes of all the BCH_DATA_sb and BCH_DATA_journal buckets from the usage
> data, leaving the usage unchanged.
> 
> In a comment in bch2_dev_add, you suggest "we have to mark, allocate the
> journal, reset all the marks, then remark after we attach" but unless I'm
> misunderstanding, I don't think I see anything that resets the marks in
> between the two metadata-marking operations?
> 
> If it's hard to do that right, I did wonder if an alternative approach would
> be to somehow flag the bucket as 'not yet accounted for' when !c in
> __bch2_mark_metadata_bucket, so that bch2_dev_usage_update could spot this
> during the later bch2_trans_mark_dev_sb operation, and not subtract the
> unaccounted-for old.dirty_sectors.
> 
> But I thought I'd better ask first, and make sure I've understood what's
> going on correctly, before getting any further out of my depth in the
> innards of your filesystem! :)

Good catch! I completely forgot about that comment and didn't think to fix it
that way, the last time I was looking at that I was looking at the device
accounting code in buckets.c. I've just pushed a fix, can you tell me if you see
anything I missed?

This is a good opportunity to talk about the disk space accounting code.

Basically I've been trying to incrementally move things away from using the
in-memory bucket away and transition all the logic to going off of the alloc
info in the btree - updating of filesystem wide, per-replica accounting works
that way now, but the per device accounting does not - it's slaved to the
updates of the in-memory bucket marks, see bch2_dev_usage_update() in buckets.c,
and updating the in memory bucket marks is triggered by btree updates to the alloc
btree, see bch2_mark_alloc().

We need to eventually get rid of the in memory bucket arrays - they take up too
much memory on (extremely large) filesystems, right now they're our biggest
scalability limitation.

Some background: we have memory triggers - triggers that update other in memory
data structures on btree updates; they update things that have to stay in sync
with the btree so they run with tree write locks held. And we have transactional
triggers, which look at the btree updates we're about to do and trigger more
btree updates

Updating of the filesystem wide accounting is another mechanism; the
transactional triggers build up a list of updates to be applied to the
filesystem wide accounting (based only on looking at old and new btree keys,
which is what we want), and then bch2_trans_fs_usage_apply() commits those
updates while we've got appropriate locks held.

The really big thing that needs to happen with disk space accounting is it needs
to be moved to keys in a btree. Right now, disk space accounting metadata is
"special"; it lives in the journal and is never flushed to the btree. The amount
of disk space accounting we can have on filesystems with many devices already
makes this problematic, and we need to add per-snapshot ID disk space accounting
too, as well as disk space accounting broken out by compression type, with
compressed and uncompressed size.

Complicating factors: the way disk space accounting is stored and managed now is
ridiculously complicated (but fast!). It's stored in percpu counters, which are
additionally sharded by outstanding journal commit (correspending to journal
entries/buffers in flight). Btree updates update the counters corresponding to
the journal buffer they took a journal reservation on; then prior to journal
write, those counters are rolled up into the main, non-percpu set of counters
and written out.

So I'm envisioning moving all disk space accounting - per device, per replica
set, per snapshot id - to keys in another btree. Indexing scheme to be
determined; using the str_hash code would be ideal since replica sets are
essentially strings (variable length list of device IDs, and I don't want to put
a hard cap on the number of devices in a replica set) - but the str_hash code
(probably?) won't work with the btree key cache code, which we'll need to use.

The locks for these accounting keys are going to become contention points -
unless we're able to come up with a way to do updates to them with just read
locks, which I think ought to be possible by carrying over the existing scheme
of applying deltas and sharding updates by journal buf and rolling them up prior
to journal write. If we can do it with just read locks, we're completely fine on
lock/cacheline contention - six locks have a fancy optional percpu read lock
mode.

Anyways, that's my current braindump on disk space accounting...

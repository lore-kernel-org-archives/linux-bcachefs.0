Return-Path: <linux-bcachefs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86704C433EF
	for <linux-bcachefs@archiver.kernel.org>; Sun, 24 Oct 2021 21:36:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5EFBD60F12
	for <linux-bcachefs@archiver.kernel.org>; Sun, 24 Oct 2021 21:36:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230520AbhJXViq (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Sun, 24 Oct 2021 17:38:46 -0400
Received: from cdw.me.uk ([91.203.57.136]:35635 "EHLO cdw.me.uk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229519AbhJXViq (ORCPT <rfc822;linux-bcachefs@vger.kernel.org>);
        Sun, 24 Oct 2021 17:38:46 -0400
Received: from chris by delta.arachsys.com with local (Exim 4.80)
        (envelope-from <chris@arachsys.com>)
        id 1melAF-0006c7-9k; Sun, 24 Oct 2021 22:36:23 +0100
Date:   Sun, 24 Oct 2021 22:36:23 +0100
From:   Chris Webb <chris@arachsys.com>
To:     Kent Overstreet <kent.overstreet@gmail.com>
Cc:     linux-bcachefs@vger.kernel.org
Subject: Re: Metadata usage following device add
Message-ID: <20211024213623.GJ11670@arachsys.com>
References: <20211024111547.GG11670@arachsys.com>
 <YXWML9QLQKCsRgdh@moria.home.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YXWML9QLQKCsRgdh@moria.home.lan>
User-Agent: Mutt/1.5.20 (2009-06-14)
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

Kent Overstreet <kent.overstreet@gmail.com> writes:

> Good catch! I completely forgot about that comment and didn't think to
> fix it that way, the last time I was looking at that I was looking at the
> device accounting code in buckets.c. I've just pushed a fix, can you tell
> me if you see anything I missed?

Thanks! I've played with it and tried everything I can think of to break it,
but I didn't find a way to get it out of sync or inconsistent.

> This is a good opportunity to talk about the disk space accounting code.

That was a really interesting write-up of your planned transition to move
the accounting into btree keys, thanks! Makes a lot of sense as you describe
it. (I saw you mention hitting 1M snapshots on a filesystem the other day,
which is good motivation for a scalable place to put accounting info!)

I need to spend a bit of time reading the code and getting a better sense of
how the allocation system more generally works. It's still one of the more
mysterious bits of the filesystem to me.

Am I right that in the current implementation, buckets only get discarded
when the allocator thread is woken because we've run out of free buckets for
a new allocation and need to reclaim - so they're discarded and quickly
reused? I wonder if waking the allocator thread periodically (or from a
userspace ioctl?) to reclaim and discard buckets earlier might be better for
SSD health, kind of like a fancy version of a manual fstrim on ext4?

Best wishes,

Chris.


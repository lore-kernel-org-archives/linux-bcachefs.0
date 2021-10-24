Return-Path: <linux-bcachefs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7495C433EF
	for <linux-bcachefs@archiver.kernel.org>; Sun, 24 Oct 2021 11:15:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 931F66103C
	for <linux-bcachefs@archiver.kernel.org>; Sun, 24 Oct 2021 11:15:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231400AbhJXLSK (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Sun, 24 Oct 2021 07:18:10 -0400
Received: from cdw.me.uk ([91.203.57.136]:41739 "EHLO cdw.me.uk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231394AbhJXLSJ (ORCPT <rfc822;linux-bcachefs@vger.kernel.org>);
        Sun, 24 Oct 2021 07:18:09 -0400
Received: from chris by delta.arachsys.com with local (Exim 4.80)
        (envelope-from <chris@arachsys.com>)
        id 1mebTf-0004fc-A0; Sun, 24 Oct 2021 12:15:47 +0100
Date:   Sun, 24 Oct 2021 12:15:47 +0100
From:   Chris Webb <chris@arachsys.com>
To:     Kent Overstreet <kent.overstreet@gmail.com>
Cc:     linux-bcachefs@vger.kernel.org
Subject: Metadata usage following device add
Message-ID: <20211024111547.GG11670@arachsys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

Kent Overstreet <kent.overstreet@gmail.com> wrote:

> On Wed, Oct 13, 2021 at 05:52:40PM +0100, Chris Webb wrote:
> > looks like sb and journal are still zero on the newly added device even
> > following the data rereplicate operation.
>
> That's a separate (known) bug - adding a new device doesn't account for
> sb/journal on the new device correctly. I should revisit that one...

Hi Kent. Sorry for this slow follow-up, but I took a look at what's going on
to see if it was easy to fix. After a bit of printk() abuse, I think I
understand why this happens:

bch2_dev_add calls __bch2_mark_metadata_bucket via bch2_mark_dev_superblock
before the device is attached to the fs, so it can't yet use
bch2_dev_usage_update.

Later, after the device is attached, we call bch2_trans_mark_dev_sb which
diligently goes through re-marking buckets and updating the usage. However,
the old and new bucket types and dirty_sectors values match, so
bch2_dev_usage_update ends up repeatedly subtracting and then re-adding the
sizes of all the BCH_DATA_sb and BCH_DATA_journal buckets from the usage
data, leaving the usage unchanged.

In a comment in bch2_dev_add, you suggest "we have to mark, allocate the
journal, reset all the marks, then remark after we attach" but unless I'm
misunderstanding, I don't think I see anything that resets the marks in
between the two metadata-marking operations?

If it's hard to do that right, I did wonder if an alternative approach would
be to somehow flag the bucket as 'not yet accounted for' when !c in
__bch2_mark_metadata_bucket, so that bch2_dev_usage_update could spot this
during the later bch2_trans_mark_dev_sb operation, and not subtract the
unaccounted-for old.dirty_sectors.

But I thought I'd better ask first, and make sure I've understood what's
going on correctly, before getting any further out of my depth in the
innards of your filesystem! :)

Best wishes,

Chris.

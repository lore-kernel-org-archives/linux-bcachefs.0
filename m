Return-Path: <linux-bcachefs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A33EC433F5
	for <linux-bcachefs@archiver.kernel.org>; Wed, 13 Oct 2021 19:39:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4F6C661165
	for <linux-bcachefs@archiver.kernel.org>; Wed, 13 Oct 2021 19:39:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230474AbhJMTlL (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Wed, 13 Oct 2021 15:41:11 -0400
Received: from cdw.me.uk ([91.203.57.136]:32805 "EHLO cdw.me.uk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229989AbhJMTlK (ORCPT <rfc822;linux-bcachefs@vger.kernel.org>);
        Wed, 13 Oct 2021 15:41:10 -0400
Received: from chris by delta.arachsys.com with local (Exim 4.80)
        (envelope-from <chris@arachsys.com>)
        id 1mak5h-00079F-F1; Wed, 13 Oct 2021 20:39:05 +0100
Date:   Wed, 13 Oct 2021 20:39:05 +0100
From:   Chris Webb <chris@arachsys.com>
To:     Kent Overstreet <kent.overstreet@gmail.com>
Cc:     linux-bcachefs@vger.kernel.org
Subject: Re: Metadata rereplication not triggering
Message-ID: <20211013193905.GD11670@arachsys.com>
References: <20211012090745.GA11670@arachsys.com>
 <YWXRy46DZY7AV+Kf@moria.home.lan>
 <20211013165240.GC11670@arachsys.com>
 <YWcXczNENXOTxBuw@moria.home.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YWcXczNENXOTxBuw@moria.home.lan>
User-Agent: Mutt/1.5.20 (2009-06-14)
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

Kent Overstreet <kent.overstreet@gmail.com> writes:

> It looks like I must have mixed up some test run output or something - you're
> right, it's still failing for me, but it does work if prior to rereplicate we
> either remove /dev/sdc or set it to failed - that is, a device being (possibly
> momentarily) offline isn't enough for rereplicate to consider a given extent.

Brilliant, that also explains some confusion on my part: I was convinced I'd
seen it work when I manually tested, then the automated test failed and
subsequent manual tests all failed too. I must have removed and added
devices when I first tested, but only used mount -o degraded later,
incorrectly assuming that was equivalent.

Sounds like logical behaviour to me now I know about it. You wouldn't want
to start making extra copies of data and assuming a block device had
permanently failed just because it was briefly inaccessible.

Testing with

-    mount -t bcachefs -o degraded /dev/sdb /mnt
+    mount -t bcachefs /dev/sdb:/dev/sdc /mnt
+    bcachefs device remove -f /dev/sdc

everything works fine, and I now know how to drive it correctly. :)

I see it works just as well using bcachefs device set-state failed instead
of bcachefs device remove, or adding the new drive before removing the old
one.

(Need to work on retraining my fingers not to keep typing "bcachefs device
remove /mnt /dev/sdc" to match "bcachefs device add /mnt /dev/sdc" though!)

Best wishes,

Chris.
